import 'package:cbor/cbor.dart';
import 'comm_server.dart';

class GrpcCommServer implements CommServerCtl, CommServerData {
  @override
  void startServing(String addr, int port) {}

  @override
  void stopServing() {}

  @override
  CborValue? exchangeUpdates(CborValue updateOut, bool nowait) {
    return null;
  }
}
