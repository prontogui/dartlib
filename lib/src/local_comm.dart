import 'dart:async';
import 'package:cbor/cbor.dart';
import 'comm_client.dart';
import 'comm_server.dart';

class LocalComm implements CommClientData, CommServerData {
  LocalComm({required this.onUpdate});

  final _serverIncoming = Future<CborValue>();
  final _clientIncoming = Future<CborValue>();

  @override
  OnUpdateFunction onUpdate;

  @override
  void streamUpdateToServer(CborValue cborUpdate) {
    _serverIncoming.add(cborUpdate);
  }

  @override
  Future<CborValue> exchangeUpdates(CborValue updateOut, bool nowait) async {
    _clientIncoming.add(updateOut);
    if (nowait) {
      return CborNull();
    }
    return await _serverIncoming.stream.first;
  }
}
