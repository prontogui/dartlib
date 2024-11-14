// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';

/// States of communication
enum CommState {
  /// Communication is inactive because either open() hasn't been called yet or
  /// the close() method was called.
  inactive,

  /// A connection attempt has been made by trying to make an RPC.  This brief state is designed
  /// to allow time for the connection to be established without having to tell the user
  /// we are waiting for the connection to be made.  It's mainly for messaging purposes.  After
  /// the connectingPeriod elapses, it switches to the connectingWait state, where we
  /// can notify the user that we're waiting.
  connecting,

  /// A connection attempt has been made by trying to make an RPC.  It remains in this state
  /// until successful or the connection times out or an error is returned.  This state is
  /// designed so we can update the user that we are waiting on the connection to occur.
  connectingWait,

  /// State where streaming of updates is happening without any problems.
  active,

  /// This state is entered upon error or disconnection during active streaming.  It
  /// is where we peroidically try to reestablish streaming through a successful RPC.
  reestablishmentDelay,
}

/// A callback function for handling updates coming from the server.
typedef OnUpdateFunction = void Function(CborValue update);

/// A callback function for notifying the user of a state change in communication.
typedef OnStateChange = void Function();

abstract class CommClientData {
  OnUpdateFunction get onUpdate;
  set onUpdate(OnUpdateFunction f);

  /// Stream an update back to the server.
  void streamUpdateToServer(CborValue cborUpdate);
}

/// Interface for a ProntoGUI communication client to talk with a single server.
abstract class CommClientCtl {
  /// Returns the current state of communication.
  CommState get state;

  /// True means the server is invalid or unreachable.
  bool get invalidServer;

  /// If trying to reestablish communication, this metric represents the progress
  /// of the reestablishment wair period.  It is a value between 0.0 and 1.0.
  double get reestablishmentWaitProgress;

  /// Opens a session for streaming updates back/forth with a server.
  ///
  /// The optional [serverAddress] is the address of the server.  Likewise, the optional
  /// [serverPort] is the server port to connect through.  If either of these are not
  /// provided then it uses the previous values of the serverAddress and/or
  /// serverPort properties.
  void open({String? serverAddress, int? serverPort});

  /// Closes an open communication session (if any) and enters the inactive state.
  void close();

  /// Address of server we are streaming updates with.
  String get serverAddress;
  set serverAddress(String addr);

  /// Server port for the communication session.  If there is a session
  /// already open and the server port is different then it will be forcefully closed.
  int get serverPort;
  set serverPort(int port);

  /// Returns a description of the server endpoint we are trying to connect to.
  ///
  /// Note:  this is protocol-specific.
  String serverEndpointDescription();

  /// Forcefully try to re-establish streaming without waiting for a reconnection
  /// countdown to expire.
  void tryConnectionAgain();
}
