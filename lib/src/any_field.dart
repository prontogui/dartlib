// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';
import 'primitive.dart';
import 'fkey.dart';
import 'pkey.dart';
import 'field_hooks.dart';
import 'primitive_factory.dart';

/// A field that holds a single primitive.
class AnyField extends FieldBase implements Field {
  /// Storage of this field's value.
  Primitive? _p;

  /// The value of this field.
  Primitive? get value => _p;
  set value(Primitive? p) {
    _unprepareDescendantsForUpdates();
    _p = p;
    _prepareDescendantsForUpdates();
    onSet();
  }

  // Implement Field interface

  // Override the default implementation to prepare the descendant primitive.
  @override
  void prepareForUpdates(
      FKey fkey, PKey pkey, int fieldPKeyIndex, FieldHooks fieldHooks) {
    super.prepareForUpdates(fkey, pkey, fieldPKeyIndex, fieldHooks);

    _prepareDescendantsForUpdates();
  }

  @override
  void unprepareForUpdates() {
    super.unprepareForUpdates();
    _unprepareDescendantsForUpdates();
  }

  /// Prepare descendant primitives for updates.
  void _prepareDescendantsForUpdates() {
    // Short circuit for the case where the primitives are being used in freestyle fashion.
    // That is, they are participating in a model yet and hence we aren't trackig updates.
    if (notPreparedYet) {
      return;
    }

    // Prepare descendant primitive for updates
    if (_p != null) {
      var fieldPKey = PKey.fromPKey(pkey, fieldPKeyIndex);
      _p!.prepareForUpdates(fieldPKey, fieldHooks!);
    }
  }

  void _unprepareDescendantsForUpdates() {
    if (_p != null) {
      _p!.unprepareForUpdates();
    }
  }

  @override
  void ingestFullCborValue(CborValue value) {
    if (value is! CborMap) {
      throw Exception('value is not a CborMap');
    }
    _unprepareDescendantsForUpdates();
    _p = PrimitiveFactory.createPrimitiveFromCborMap(pkey, value);
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    if (value is! CborMap) {
      throw Exception('value is not a CborString');
    }
    if (_p == null) {
      throw Exception('field has a null primitive');
    }
    _p!.ingestPartialCborMap(value);
    onIngest();
  }

  @override
  CborValue egestCborValue() {
    if (_p == null) {
      return CborNull();
    }
    return _p!.egestFullCborMap();
  }

  // Object overrides

  @override
  String toString() {
    if (_p == null) {
      return "<empty>";
    }
    return _p!.describeType;
  }
}
