// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';

abstract class CommServerData {
  CborValue? exchangeUpdates(CborValue updateOut, bool nowait);
}

abstract class CommServerCtl {
  void startServing(String addr, int port);
  void stopServing();
}
