import 'dart:async';
import 'package:cbor/cbor.dart';
import 'comm_client.dart';
import 'comm_server.dart';

class LocalComm implements CommClientData, CommServerData {
  LocalComm();

  final _clientToServer = StreamController<CborValue>();
  final _serverToClient = StreamController<CborValue>();

  /// Continuous stream of updates from the client.
  @override
  StreamView<CborValue> get updatesFromClient {
    return StreamView<CborValue>(_clientToServer.stream);
  }

  /// Submit an update to send to the client.
  @override
  void submitUpdateToClient(CborValue update) {}

  /// Continuous stream of updates from the server.
  @override
  StreamView<CborValue> get updatesFromServer {
    return StreamView<CborValue>(_serverToClient.stream);
  }

  /// Submit an update to send to the server.
  @override
  void submitUpdateToServer(CborValue update) {}
}
