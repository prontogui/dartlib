import 'package:cbor/cbor.dart';
import 'comm_client.dart';
import 'comm_server.dart';

class LocalComm implements CommClientData, CommServerData {
  LocalComm({required this.onUpdate});

  @override
  OnUpdateFunction onUpdate;

  @override
  void streamUpdateToServer(CborValue cborUpdate) {}

  @override
  CborValue exchangeUpdates(CborValue updateOut, bool nowait) {
    return CborNull();
  }
}
