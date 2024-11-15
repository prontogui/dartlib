// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'primitive.dart';
import 'primitive_model.dart';
import 'grpc_comm_server.dart';
import 'update_synchro.dart';

abstract class ProntoGUI {
  // The model that holds the state of the GUI.
  final PrimitiveModel model = PrimitiveModel();
  bool fullUpdateRequired = true;

  void setGUI(List<Primitive> primitives) {
    fullUpdateRequired = true;
    model.topPrimitives = primitives;
  }

  void update();

  Future<Primitive> wait();
}

class LocalProntoGUI extends ProntoGUI {
  LocalProntoGUI() {}

  @override
  void update() {}

  @override
  Future<Primitive> wait() {
    throw UnimplementedError();
  }
}

class RemoteProntoGUI extends ProntoGUI {
  RemoteProntoGUI() {
    _updateSynchro = UpdateSynchro(model, null, false, true);
  }

  // The main client for rendering the GUI.
  final _mainServer = GrpcCommServer();

  // The auxiliary client for editing the GUI.
  final _auxServer = GrpcCommServer();

  // The Update Synchromization object that provides partial or full updates.
  late UpdateSynchro _updateSynchro;

  void startServing(
      String mainAddr, int mainPort, String auxAddr, int auxPort) {
    fullUpdateRequired = true;

    _mainServer.startServing(mainAddr, mainPort);
    _auxServer.startServing(auxAddr, auxPort);
  }

  void stopServing() {
    _mainServer.stopServing();
    _auxServer.stopServing();
  }

  @override
  void update() {
    var cborOut = _verifyGuiIsSetThenGetNextUpdate();
    try {
      _mainServer.submitUpdateToClient(cborOut);
    } catch (e) {
      // TODO: log error
      fullUpdateRequired = true;
      rethrow;
    }
  }

  @override
  Future<Primitive> wait() async {
    var cborOut = _verifyGuiIsSetThenGetNextUpdate();
    late CborValue cborIn;

    // Do the exchange of output and input updates.
    try {
      _mainServer.submitUpdateToClient(cborOut);
      cborIn = await _mainServer.updatesFromClient.first;
    } catch (e) {
      // TODO: log error
      fullUpdateRequired = true;
      rethrow;
    }

    model.updateEventTimestamp();

    // Ingest the input update.  It must only be a partial update.
    return model.ingestPartialUpdateOnly(cborIn);
  }

  CborValue _verifyGuiIsSetThenGetNextUpdate() {
    if (model.isEmpty) {
      throw Exception('GUI is not set');
    }

    // Need to send a full update?
    if (fullUpdateRequired) {
      fullUpdateRequired = false;
      return _updateSynchro.getFullUpdate();
    } else {
      return _updateSynchro.getPartialUpdate();
    }
  }
}
