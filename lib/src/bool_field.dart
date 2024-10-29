// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';

/// A field that holds a boolean value.
class BoolField extends FieldBase implements Field {
  /// Construct a BoolField with a default value.
  BoolField() : _b = false;

  /// Construct a BoolField from a string.
  BoolField.from(String s) : _b = bool.parse(s);

  /// Storage of this field's value.
  bool _b;

  /// The value of this field.
  bool get value => _b;
  set value(bool b) {
    _b = b;
    onSet();
  }

  // Implement Field interface

  @override
  void ingestCborValue(CborValue value) {
    if (value is! CborBool) {
      throw Exception('value is not a CborBool');
    }
    _b = value.value;
  }

  @override
  CborValue egestCborValue() {
    return CborBool(_b);
  }

  // Object overrides

  @override
  String toString() {
    return '$_b';
  }
}
