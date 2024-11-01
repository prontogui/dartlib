// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'fkey.dart';
import 'pkey.dart';
import 'field_hooks.dart';

/// A field is a single piece of data or setting of a Primitive that can be updated.
abstract interface class Field {
  /// Prepare this field for updates, where [fkey] is the field key, [pkey] is the
  /// path to this primitive, [fieldPKeyIndex] is the PKey index to use for the field,
  /// and [fieldHooks] is the interface to call when fields of this primitive are updated.
  /// This method returns true if the field is structural, that is, it contains other
  /// primitives.
  void prepareForUpdates(
      FKey fkey, PKey pkey, int fieldPKeyIndex, FieldHooks fieldHooks);

  /// Unprepare this field for updates.  Subsequent updates to the field will not
  /// call the previous onset function, not will this field have a valid PKey or FKey.
  void unprepareForUpdates();

  /// Egest the field's value as a CBOR value.
  CborValue egestCborValue();

  /// Ingest a CBOR value into the field.  The update must only apply to pre-existing
  /// child primitives and no additional children can be created.  An exception is
  /// thrown if there is a problem ingesting the value.
  ///
  /// Note:  for atomic field types, this method is equivalent to ingestFullCborValue.
  void ingestPartialCborValue(CborValue value);

  /// Injest a CBOR value into the field.  An exception is thrown if there is a
  /// problem ingesting the value.  If this field contains primitive children, they
  /// will be replaced entirely by the new value.  An exception is
  /// thrown if there is a problem ingesting the value.
  ///
  /// Note:  for atomic field types, this method is equivalent to ingestPartialCborValue.
  void ingestFullCborValue(CborValue value);

  /// The structural status of this filed.  Fields that are structural can contains
  /// other primitives.  Non-structural fields are atomic such as String, Integer, etc.
  bool get isStructural => false;
}
