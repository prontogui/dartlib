// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';

/// A field that holds an integer value.
class IntegerField extends FieldBase implements Field {
  /// Construct a StringField with a default value.
  IntegerField() : _i = 0;

  IntegerField.from(int i) : _i = i;

  /// Storage of this field's value.
  int _i;

  /// The value of this field.
  int get value => _i;
  set value(int i) {
    _i = i;
    onSet();
  }

  // Implement Field interface

  @override
  void ingestFullCborValue(CborValue value) {
    if (value is CborSmallInt) {
      _i = value.value;
    } else if (value is CborSmallInt) {
      _i = value.value;
    } else if (value is CborBigInt) {
      _i = value.toInt();
    } else {
      throw Exception('CBOR value is not an integer type');
    }
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    ingestFullCborValue(value);
    onIngest();
  }

  @override
  CborValue egestCborValue() {
    return CborSmallInt(_i);
  }

  // Object overrides

  @override
  String toString() {
    return '$_i`';
  }
}
