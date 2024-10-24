// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'package:dartlib/key/pkey.dart';
import 'package:dartlib/key/fkey.dart';
import 'package:dartlib/key/onset.dart';

// Interface for Primitives.
abstract class Primitive {
  prepareForUpdates(PKey pkey, OnsetFunction onset);
  Primitive? locateNextDescendant(PKeyLocator locator);
  CborMap egestCborUpdate(bool fullUpdate, List<FKey> fkeys);
  bool ingestCborUpdate(CborMap update);
}
