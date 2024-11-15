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

class PGUpdateToCborTransformer
    implements StreamTransformer<PGUpdate, CborValue> {
  @override
  Stream<CborValue> bind(Stream<PGUpdate> stream) {
    return stream.map((pgUpdate) {
      // TODO:  do we need to handle case where pgUpdate.cbor is empty?
      return cbor.decode(pgUpdate.cbor);
    });
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }
}

class CborToPGUpdateTransformer
    implements StreamTransformer<CborValue, PGUpdate> {
  @override
  Stream<PGUpdate> bind(Stream<CborValue> stream) {
    return stream.map((cborValue) {
      return PGUpdate(cbor: cbor.encode(cborValue));
    });
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }
}

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
  /// The amount of time (in seconds) to wait for a connection to be established.
  final int _connectingPeriod = 3;

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

  /// The call object for streaming updates from the server.
  ResponseStream<PGUpdate>? _call;

  /// A stream controller for incoming updates from the server.
  final _incomingUpdates = StreamController<CborValue>();

  /// A stream controller for outgoing updates to the server.
  final _outgoingUpdates = StreamController<CborValue>();

  /// A periodic timer used in different communication states.
  Timer? _timer;

  /// The state machine for communication.
  late final Machine<CommState> _state;

  // States of the communication state machine
  late final State<CommState> _inactiveState;
  late final State<CommState> _connectingState;
  late final State<CommState> _connectingWaitState;
  late final State<CommState> _activeState;
  late final State<CommState> _restablishmentDelayState;
  late final TimeoutTransition _restablishmentTimeoutTransition;

  /// The current state of communication.
  //CommState _state = CommState.inactive;

  /// True means the server is invalid or unreachable, given the provided server
  /// address and port in the open() method call.
  bool _invalidServer = false;

  /// True means GrpcCommClient is paused in working with a server, which may be down or
  /// unavailable at the moment.  If this is False and _active is True, then it can
  /// be assumed that streaming is working.
  // bool _paused = false;

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
    // Create the state machine
    _state = Machine<CommState>();
    _state.onAfterTransition.listen((event) {
      // Notify listeners of state change
      if (onStateChange == null) {
        return;
      }
      onStateChange!();
    });

    // Define the states and transitions of the communication state machine
    _inactiveState = State<CommState>(_state, CommState.inactive);
    _inactiveState.onEntry(() {
      _cleanupResources();
    });

    _connectingState = State<CommState>(_state, CommState.connecting);
    _connectingState.onEntry(() {
      _connect();
    });
    _connectingState.onTimeout(Duration(seconds: _connectingPeriod), () {
      _connectingWaitState.enter();
    });

    _connectingWaitState = State<CommState>(_state, CommState.connectingWait);
    _connectingWaitState.onEntry(() {
      _activeState.enter();
    });

    _activeState = State<CommState>(_state, CommState.active);
    _activeState.onTimeout(Duration(seconds: serverCheckinPeriod), () {
      // TODO:  create a timer to check in with server by injecting a blank update into _outgoingUpdates

      _streamUpdates();
    });

    _restablishmentTimeoutTransition =
        TimeoutTransition(Duration(seconds: reestablishmentPeriod), () {
      _connectingState.enter();
    });
    _restablishmentDelayState =
        State<CommState>(_state, CommState.reestablishmentDelay);
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
    // Already opened and doing something?
    if (_state.current != _inactiveState) {
      _inactiveState.enter();
    }

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
      _inactiveState.enter();
      _invalidServer = true;
      return;
    }
  }

  void _streamUpdates() async {
    _call = _stub!.streamUpdates(
        _outgoingUpdates.stream.transform(CborToPGUpdateTransformer()));
    _incomingUpdates.addStream(_call!.transform(PGUpdateToCborTransformer()));
  }

  /// Closes an open communication session (if any) and enters the inactive state.
  @override
  void close() {
    _inactiveState.enter();
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
    if (_timer == null) {
      return 0.0;
    }
    return _restablishmentTimeoutTransition.tick / reestablishmentPeriod;
  }

  @override
  String get serverAddress {
    return _serverAddress;
  }

  @override
  set serverAddress(String addr) {
    if (_state.current != _inactiveState && addr != _serverAddress) {
      _inactiveState.enter();
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
      _inactiveState.enter();
    }
    _serverPort = port;
  }

  /// The remaining timer ticks (approximately 1 second each) elapsed while waiting for
  /// a connection or the ticks left until the next attempt to re-establish streaming.
  int get ticks {
    return _timer != null ? _timer!.tick : 0;
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

  /// Cleans up outstanding resources for the active session.
  void _cleanupResources() async {
    // Clean up resources in reverse-order of creation
    _call?.cancel();
    _call = null;

    _timer?.cancel();
    _timer = null;

//    _response = PGUpdate();

    _stub = null;

    _channel?.terminate();
    _channel = null;

    await _outgoingUpdates.stream.drain();
    await _incomingUpdates.stream.drain();
  }
}
