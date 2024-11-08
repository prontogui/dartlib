// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';

/// A field that holds Binary Large OBject (BLOB) value.
class BlobField extends FieldBase implements Field {
  /// Storage of this field's value.
  List<int> _ba = [];

  /// The value of this field.  WHen setting the value, a copy of the input
  /// list is made.  When getting the value, a copy of the internal list is
  /// returned.
  List<int> get value => _ba;
  set value(List<int> ba) {
    _ba = ba;
    onSet();
  }

  @override
  void ingestFullCborValue(CborValue value) {
    if (value is CborNull) {
      _ba.clear();
      return;
    }

    if (value is! CborBytes) {
      throw Exception('value is not a CborBytes');
    }
    _ba = value.bytes;
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    ingestFullCborValue(value);
    onIngest();
  }

  @override
  CborValue egestCborValue() {
    return CborBytes(_ba);
  }

  // Object overrides

  @override
  String toString() {
    return 'Blob [${_ba.length} bytes]';
  }
}
