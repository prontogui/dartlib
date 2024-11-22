// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/comm_server.dart';
import 'primitive.dart';
import 'primitive_model.dart';
import 'grpc_comm_server.dart';
import 'update_synchro.dart';
import 'local_comm.dart';

class ProntoGUI {
  /// Creates a ProntoGUI server that works locally with the app using [localComm].
  ProntoGUI.local(LocalComm localComm)
      : mainServer = localComm,
        auxServer = null,
        isRemote = false {
    _updateSynchro = UpdateSynchro(model, null, false, true);
  }

  /// Creates a ProntoGUI server that works remotely using GRPC.
  ProntoGUI.remote()
      : mainServer = GrpcCommServer(),
        auxServer = GrpcCommServer(),
        isRemote = true {
    _updateSynchro = UpdateSynchro(model, null, false, true);
  }

  // True if this was create as a remote server.
  final bool isRemote;

  // The model that holds the state of the GUI.
  final PrimitiveModel model = PrimitiveModel();

  bool fullUpdateRequired = true;

  // The main client for rendering the GUI.
  final CommServerData mainServer;

  // The auxiliary client for editing the GUI.
  final CommServerData? auxServer;

  // The Update Synchromization object that provides partial or full updates.
  late UpdateSynchro _updateSynchro;

  void startServing(
      String mainAddr, int mainPort, String auxAddr, int auxPort) {
    fullUpdateRequired = true;

    if (isRemote) {
      var mainServerCtl = mainServer as CommServerCtl;
      mainServerCtl.startServing(mainAddr, mainPort);

      if (auxServer != null) {
        var auxServerCtl = auxServer as CommServerCtl;
        auxServerCtl.startServing(auxAddr, auxPort);
      }
    }
  }

  void stopServing() {
    if (isRemote) {
      var mainServerCtl = mainServer as CommServerCtl;
      mainServerCtl.stopServing();

      if (auxServer != null) {
        var auxServerCtl = auxServer as CommServerCtl;
        auxServerCtl.stopServing();
      }
    }
  }

  void setGUI(List<Primitive> primitives) {
    fullUpdateRequired = true;
    model.topPrimitives = primitives;
  }

  void update() {
    var cborOut = _verifyGuiIsSetThenGetNextUpdate();
    try {
      mainServer.submitUpdateToClient(cborOut);
    } catch (e) {
      // TODO: log error
      fullUpdateRequired = true;
      rethrow;
    }
  }

  Future<Primitive> wait() async {
    var cborOut = _verifyGuiIsSetThenGetNextUpdate();
    late CborValue cborIn;

    // Do the exchange of output and input updates.
    try {
      mainServer.submitUpdateToClient(cborOut);
      cborIn = await mainServer.updatesFromClient.first;
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
