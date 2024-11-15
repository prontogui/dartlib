import 'dart:async';
import 'package:cbor/cbor.dart';
import 'comm_server.dart';

class GrpcCommServer implements CommServerCtl, CommServerData {
  @override
  void startServing(String addr, int port) {}

  @override
  void stopServing() {}

  /// Continuous stream of updates from the client.
  @override
  StreamView<CborValue> get updatesFromClient {
    return StreamView<CborValue>(Stream<CborValue>.empty());
  }

  /// Submit an update to send to the client.
  @override
  void submitUpdateToClient(CborValue update) {}
}
