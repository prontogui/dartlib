// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'fkey.dart';
import 'pkey.dart';
import 'onset.dart';

abstract interface class Field {
  bool prepareForUpdates(
      FKey fkey, PKey pkey, int fieldPKeyIndex, OnsetFunction onset);
  CborValue egestCborValue();
  bool ingestCborValue(CborValue value);
}
