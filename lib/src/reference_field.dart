// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';
import 'references.dart';

/// A field that references a primitive.
class ReferenceField extends FieldBase implements Field {
  /// Construct a ReferenceField with a default value.
  ReferenceField() : _i = 0;

  ReferenceField.from(int i) : _i = i;

  /// Storage of this field's value.
  int _i;

  /// The value of this field.
  int get value => _i;
  set value(int i) {
    var refs = References();

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
