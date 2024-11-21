// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'package:grpc/grpc.dart';
import 'proto/pg.pbgrpc.dart';
import 'package:cbor/cbor.dart';
import 'comm_client.dart';
import 'package:statemachine/statemachine.dart';
import 'log.dart';
import 'progress_transition.dart';

/// ProntoGUI communication client to talk with a single server using gRPC.
///
/// An instance of this class handles communication with a single server.  To use this,
/// first create an instance and supply a callback (onUpdate) that handles CBOR updates
/// when they arrive from the server.  Next, call the open() method with an IP address and
/// port of the server.  The streaming communication will start with the server.  If the server
/// is down then it will retry until a connection is established.  It also sends
/// an empty "check-in" update to the server to make sure communication is still working.
/// If this check-in fails, then it will keep trying until communication is up again.
///
/// You can call open() any time to specify a different server to connect with.
class GrpcCommClient implements CommClientData, CommClientCtl {
  /// The user-supplied callback for sending notifications of state changes.
  final OnStateChange? onStateChange;

  /// The amount of time (in seconds) between attempts to re-establish streaming after
  /// it is paused.
  final int reestablishmentPeriod;

  /// The server address that was opened.
  String _serverAddress = "";

  /// The server port that was opened.
  int _serverPort = 0;

  /// The HTTP/2 channel in use
  ClientChannel? _channel;

  /// A client object for talking with PGService.  This object is generated
  /// by gRPC/Protobuf tools.
  PGServiceClient? _stub;

  /// The ongoing, active call for streaming updates to/from the server.
  ResponseStream<PGUpdate>? _call;

  /// A stream controller for incoming updates from the server.
  final _incomingUpdates = StreamController<CborValue>();

  /// A stream controller for outgoing updates to the server.
  var _outgoingUpdates = StreamController<CborValue>();

  /// The state machine for communication.
  late final Machine<CommState> _state;

  // States of the communication state machine
  late final State<CommState> _inactiveState;
  late final State<CommState> _connectingState;
  late final State<CommState> _connectingWaitState;
  late final State<CommState> _activeState;
  late final State<CommState> _restablishmentDelayState;
  late final ProgressTransition _restablishmentTimeoutTransition;

  /// True means the server is invalid or unreachable, given the provided server
  /// address and port in the open() method call.
  bool _invalidServer = false;

  /// Construct an object for streaming updates back/forth with a server.
  ///
  /// Required arguments:
  ///
  /// Optional arguments:
  /// * Callback function [onStateChange] for handling state changes in communication.
  ///
  /// * Time period [serverCheckinPeriod] expressed in seconds
  /// for how often to check communication with the server.  Communication checks
  /// are disable if this is set to 0.
  ///
  /// * Time period [reestablishmentPeriod] expressed in seconds for how often to try
  /// reestablishing streaming with the server during a paused state.
  GrpcCommClient(
      {this.onStateChange,
      int serverCheckinPeriod = 60,
      this.reestablishmentPeriod = 30}) {
    // Create the state machine for communication.
    _state = Machine<CommState>();

    /// Called every time a state is entered.
    uponStateEntry(String logText) {
      logger.i(logText);
      if (onStateChange != null) {
        onStateChange!();
      }
    }

    // Define the states and transitions of the communication state machine.

    // INACTIVE state
    _inactiveState = State<CommState>(_state, CommState.inactive);
    _inactiveState.onEntry(() {
      uponStateEntry('Entered inactive state');
      _cleanupResources();
    });

    // CONNECTING state
    _connectingState = State<CommState>(_state, CommState.connecting);
    _connectingState.onEntry(() {
      uponStateEntry('Entered connecting state');
      _connect();
    });

    // CONNECTING_WAIT state
    _connectingWaitState = State<CommState>(_state, CommState.connectingWait);
    _connectingWaitState.onEntry(() {
      uponStateEntry('Entered connecting wait state');
      _startStreaming();
    });

    // ACTIVE state
    _activeState = State<CommState>(_state, CommState.active);
    _activeState.onEntry(() {
      uponStateEntry('Entered active state');
    });

    // REESTABLISHMENT_DELAY state
    _restablishmentTimeoutTransition = ProgressTransition(
        // Duration until transition is fired
        Duration(seconds: reestablishmentPeriod),

        // Callback for firing transition
        () {
      _connectingWaitState.enter();
    },
        // Callback for progress
        progressCallback: (_) {
      onStateChange!();
    });

    _restablishmentDelayState =
        State<CommState>(_state, CommState.reestablishmentDelay);
    _restablishmentDelayState.onEntry(
      () {
        uponStateEntry('Entered reestablishment delay state');
      },
    );
    _restablishmentDelayState.addTransition(_restablishmentTimeoutTransition);

    // Initial state is inactive
    _state.current = _inactiveState;
  }

  /// Continuous stream of updates from the server.
  @override
  StreamView<CborValue> get updatesFromServer {
    return StreamView<CborValue>(_incomingUpdates.stream);
  }

  /// Submit an update to send to the server.
  @override
  void submitUpdateToServer(CborValue update) {
    _outgoingUpdates.add(update);
  }

  @override
  void open({String? serverAddress, int? serverPort}) {
    _invalidServer = false;

    // If already doing something then enter inactive state first.
    _enterInactiveState();

    // Stash a new server address and port if provided
    if (serverAddress != null) {
      _serverAddress = serverAddress;
    }
    if (serverPort != null) {
      _serverPort = serverPort;
    }

    // Enter the connecting state
    _connectingState.enter();
  }

  /// Closes an open communication session (if any) and enters the inactive state.
  @override
  void close() {
    _enterInactiveState();
  }

  @override
  CommState get state {
    assert(_state.current != null);
    return _state.current!.identifier;
  }

  @override
  bool get invalidServer {
    return _invalidServer;
  }

  @override
  double get reestablishmentWaitProgress {
    return _restablishmentTimeoutTransition.tick / reestablishmentPeriod;
  }

  @override
  String get serverAddress {
    return _serverAddress;
  }

  @override
  set serverAddress(String addr) {
    if (_state.current != _inactiveState && addr != _serverAddress) {
      _enterInactiveState();
    }
    _serverAddress = addr;
  }

  @override
  int get serverPort {
    return _serverPort;
  }

  @override
  set serverPort(int port) {
    if (_state.current != _inactiveState && port != _serverPort) {
      _enterInactiveState();
    }
    _serverPort = port;
  }

  @override
  void tryConnectionAgain() {
    if (_state.current == _connectingWaitState ||
        _state.current == _restablishmentDelayState) {
      _connectingState.enter();
    }
  }

  @override
  String serverEndpointDescription() {
    return 'Server at $_serverAddress:$_serverPort';
  }

  /// Connects to the server.
  void _connect() {
    try {
      // Open an HTTP/2 channel
      _channel = ClientChannel(
        InternetAddress(_serverAddress),
        port: _serverPort,
        options: ChannelOptions(
          credentials: const ChannelCredentials.insecure(),
          codecRegistry:
              CodecRegistry(codecs: const [GzipCodec(), IdentityCodec()]),
          //connectTimeout: const Duration(minutes: 5),
        ),
      );

      // Create a client object for talking with PGService
      _stub = PGServiceClient(_channel!);
    } catch (err) {
      logger.e('Error connecting to server: $err');
      _enterInactiveState();
      _invalidServer = true;
    } finally {
      _connectingWaitState.enter();
    }
  }

  /// Starts streaming updates to/from the server.
  void _startStreaming() {
    _outgoingUpdates = StreamController<CborValue>();

    try {
      // Call the GRPC service to start streaming updates while transforming from CborValue
      // to PGUpdate
      _call = _stub!.streamUpdates(
          _outgoingUpdates.stream.transform(_cborToPGUpdateTransformer));

      // Route the incoming updates to the _incomingUpdates stream while transforming
      // them from PGUpdate to CborValue
      _incomingUpdates.addStream(_call!.transform(_pgUpdateToCborTransformer));
    } catch (err) {
      logger.e('Error connecting to server: $err');
      _enterInactiveState();
      _invalidServer = true;
    }
  }

  /// Transforms PGUpdate to CborValue.  Handles errors by closing the outgoing updates
  /// and transitioning to the reestablishment delay state.
  StreamTransformer<PGUpdate, CborValue> get _pgUpdateToCborTransformer {
    return StreamTransformer<PGUpdate, CborValue>.fromHandlers(
        // When data is received from the server...
        handleData: (pgUpdate, sink) {
      logger.i('Received PGUpdate from server, size=${pgUpdate.cbor.length}');

      // If the state is not active, then transition to active state now.
      if (_state.current != _activeState) {
        _activeState.enter();
      }

      // Decode the update and pass to the receiver of updates.
      sink.add(cbor.decode(pgUpdate.cbor));

      // When an error happens in ccommunication...
      // (For example, the server goes down or the connection is lost)
    }, handleError: (err, stackTrace, sink) {
      // Pass the error to the receiver of updates.
      sink.addError(err);

      // Close the outgoing update stream, cleaning up that resource.
      _outgoingUpdates.close();

      // Transition to the reestablishment delay state.
      _restablishmentDelayState.enter();
    });
  }

  /// Transforms CborValue to PGUpdate.
  StreamTransformer<CborValue, PGUpdate> get _cborToPGUpdateTransformer {
    return StreamTransformer<CborValue, PGUpdate>.fromHandlers(
        handleData: (cborValue, sink) {
      sink.add(PGUpdate(cbor: cbor.encode(cborValue)));
    });
  }

  /// Enters the inactive state, but only when its in a different state.
  void _enterInactiveState() {
    if (_state.current != _inactiveState) {
      _state.current = _inactiveState;
    }
  }

  /// Cleans up outstanding resources for the active session.
  void _cleanupResources() {
    // Clean up resources in reverse-order of creation
    _call?.cancel();
    _call = null;

    _outgoingUpdates.close();
    _outgoingUpdates = StreamController<CborValue>();

    _stub = null;

    _channel?.terminate();
    _channel = null;
  }
}
