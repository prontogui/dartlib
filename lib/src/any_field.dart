// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';
import 'primitive.dart';

/// A field that holds a single primitive.
class AnyField extends FieldBase implements Field {
  /// Storage of this field's value.
  Primitive? _p;

  /// The value of this field.
  Primitive? get value => _p;
  set value(Primitive? p) {
    _p = p;
    onSet();
  }

  // Implement Field interface

  @override
  void ingestCborValue(CborValue value) {
    if (value is! CborMap) {
      throw Exception('value is not a CborString');
    }
    if (_p == null) {
      throw Exception('field has a null primitive');
    }
    _p!.ingestCborMap(value);
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
