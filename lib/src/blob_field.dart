// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:io';
import 'dart:typed_data';

import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';

/// A field that holds Binary Large OBject (BLOB) value.
class BlobField extends FieldBase implements Field {

  /// Constructs a BlobField holding an value with zero data bytes;
  BlobField();

  /// Constructs a BlobField from the contents of a file.
  BlobField.fromFile(String filePath) {
    loadFromFile(filePath);
  }

  /// Storage of this field's value.
  Uint8List _ba = Uint8List(0);

  /// The value of this field.  WHen setting the value, a copy of the input
  /// list is made.  When getting the value, a copy of the internal list is
  /// returned.
  Uint8List get value => _ba;
  set value(Uint8List ba) {
    _ba = ba;
    onSet();
  }

  void loadFromFile(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('File not found: $filePath');
    }
    _ba = file.readAsBytesSync();
    onSet();
  }

  @override
  void ingestFullCborValue(CborValue value) {
    if (value is CborNull) {
      _ba = Uint8List(0);
      return;
    }

    if (value is! CborBytes) {
      throw Exception('value is not a CborBytes');
    }
    _ba = Uint8List.fromList(value.bytes);
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
