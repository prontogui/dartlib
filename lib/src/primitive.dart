// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'pkey.dart';
import 'fkey.dart';
import 'onset.dart';

// Interface for Primitives.
abstract class Primitive {
  void prepareForUpdates(PKey pkey, OnsetFunction onset);

  Primitive? locateNextDescendant(PKeyLocator locator);

  /// Egests a full update from this primitive as a CborMap.
  CborMap egestFullCborMap();

  /// Egests a partil update from this primitive as a CborMap.
  /// Only the fields specified in [fkeys] will be included in the map.
  /// It is assumed that [fkeys] is a subset of the fields of this primitive, otherwise
  /// an assertion is thrown.
  CborMap egestPartialCborMap(List<FKey> fkeys);

  /// Update field values by ingesting them from a CborMap.
  void ingestCborMap(CborMap cbor);

  // Returns the type of primitive this is.
  String get describeType;
}
