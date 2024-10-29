// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'fkey.dart';
import 'pkey.dart';
import 'onset.dart';

/// A field is a single piece of data or setting of a Primitive that can be updated.
abstract interface class Field {
  /// Prepare this field for updates.  This includes assigning a [fkey], [pkey],
  /// and [fieldPKeyIndex] to the field, and setting the [onset] function to call
  /// when the field is updated.  This method returns true if the field is structural,
  /// that is, it contains other primitives.
  void prepareForUpdates(
      FKey fkey, PKey pkey, int fieldPKeyIndex, OnsetFunction onset);

  /// Egest the field's value as a CBOR value.
  CborValue egestCborValue();

  /// Ingest a CBOR value into the field.  An exception is thrown if there is a
  /// problem ingesting the value.
  void ingestCborValue(CborValue value);

  /// The structural status of this filed.  Fields that are structural can contains
  /// other primitives.  Non-structural fields are atomic such as String, Integer, etc.
  bool get isStructural => false;
}
