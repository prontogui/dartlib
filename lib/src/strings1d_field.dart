// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';

/// A field that holds a 1-dimensional array of string values.
class Strings1DField extends FieldBase implements Field {
  Strings1DField();

  /// Storage of this field's value.
  final List<String> _sa = [];

  Strings1DField.from(List<String> sa) {
    _sa.replaceRange(0, _sa.length, sa);
  }

  /// The value of this field.  WHen setting the value, a copy of the input
  /// list is made.  When getting the value, a copy of the internal list is
  /// returned.
  List<String> get value => _sa.toList();

  set value(List<String> sa) {
    _sa.replaceRange(0, _sa.length, sa);
    onSet();
  }

  @override
  void ingestFullCborValue(CborValue value) {
    if (value is CborNull) {
      _sa.clear();
      return;
    }

    if (value is! CborList) {
      throw Exception(
          'Strings1DField:ingestFullCborValue - value is not a CborList');
    }

    _sa.replaceRange(
        0,
        _sa.length,
        value.toList().map((e) {
          if (e is! CborString) {
            throw Exception('list element is not a CborString');
          }
          return e.toString();
        }));
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    ingestFullCborValue(value);
    onIngest();
  }

  @override
  CborValue egestCborValue() {
    var cborList = _sa.map((s) => CborString(s)).toList();
    return CborList(cborList);
  }

  // Object overrides

  @override
  String toString() {
    var quotedIems = _sa.map((s) => '"$s"').toList();
    return quotedIems.join(', ');
  }
}
