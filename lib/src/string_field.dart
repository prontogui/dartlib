// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';

/// A field that holds a string value.
class StringField extends FieldBase implements Field {
  /// Construct a StringField with an empty string.
  StringField() : _s = '';

  /// Construct a StringField from a string.
  StringField.from(String s) : _s = s;

  /// Storage of this field's value.
  String _s;

  /// The value of this field.
  String get value => _s;
  set value(String s) {
    _s = s;
    onSet();
  }

  // Implement Field interface

  @override
  void ingestFullCborValue(CborValue value) {
    if (value is! CborString) {
      throw Exception('value is not a CborString');
    }
    _s = value.toString();
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    ingestFullCborValue(value);
    onSet();
  }

  @override
  CborValue egestCborValue() {
    return CborString(_s);
  }

  // Object overrides

  @override
  String toString() {
    return _s;
  }
}
