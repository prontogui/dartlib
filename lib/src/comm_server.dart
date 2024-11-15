// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:cbor/cbor.dart';

abstract class CommServerData {
  /// Continuous stream of updates from the client.
  StreamView<CborValue> get updatesFromClient;

  /// Submit an update to send to the client.
  void submitUpdateToClient(CborValue update);
}

abstract class CommServerCtl {
  void startServing(String addr, int port);
  void stopServing();
}
