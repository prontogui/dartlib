// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';

/// A field that holds a 1-dimensional array of string values.
class Integer1DField extends FieldBase implements Field {
  Integer1DField();

  /// Storage of this field's value.
  final List<int> _ia = [];

  Integer1DField.from(List<int> ia) {
    _ia.replaceRange(0, _ia.length, ia);
  }

  /// The value of this field.  When setting the value, a copy of the input
  /// list is made.  When getting the value, a copy of the internal list is
  /// returned.
  List<int> get value => _ia.toList();

  set value(List<int> ia) {
    _ia.replaceRange(0, _ia.length, ia);
    onSet();
  }

  @override
  void ingestFullCborValue(CborValue value) {
    if (value is CborNull) {
      _ia.clear();
      return;
    }

    if (value is! CborList) {
      throw Exception(
          'Integer1DField:ingestFullCborValue - value is not a CborList');
    }

    _ia.replaceRange(
        0,
        _ia.length,
        value.toList().map((e) {
          if (e is! CborSmallInt) {
            throw Exception('list element is not a CborSmallInt');
          }
          return e.value;
        }));
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    ingestFullCborValue(value);
    onIngest();
  }

  @override
  CborValue egestCborValue() {
    var cborList = _ia.map((i) => CborSmallInt(i)).toList();
    return CborList(cborList);
  }

  // Object overrides

  @override
  String toString() {
    var quotedIems = _ia.map((i) => '"$i"').toList();
    return quotedIems.join(', ');
  }
}
