// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'package:cbor/cbor.dart';
import 'comm_client.dart';
import 'comm_server.dart';

class LocalComm implements CommClientData, CommServerData {
  LocalComm();

  // Note:  updates going from client (app) to server have to be broadcast, since
  // a new listener request is performed every update cycle, for example, using
  // stream.first() method.
  final _clientToServer = StreamController<CborValue>.broadcast();
  final _serverToClient = StreamController<CborValue>();

  /// Continuous stream of updates from the client.
  @override
  StreamView<CborValue> get updatesFromClient {
    return StreamView<CborValue>(_clientToServer.stream);
  }

  /// Submit an update to send to the client.
  @override
  void submitUpdateToClient(CborValue update) {
    _serverToClient.add(update);
  }

  /// Continuous stream of updates from the server.
  @override
  StreamView<CborValue> get updatesFromServer {
    return StreamView<CborValue>(_serverToClient.stream);
  }

  /// Submit an update to send to the server.
  @override
  void submitUpdateToServer(CborValue update) {
    _clientToServer.add(update);
  }
}
