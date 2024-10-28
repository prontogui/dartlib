// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';
import 'fkey.dart';
import 'pkey.dart';
import 'onset.dart';

class StringField extends FieldBase implements Field {
  StringField() : _s = '';

  StringField.from(String s) : _s = s;

  String _s;

  String get() {
    return _s;
  }

  void set(String s) {
    _s = s;
    onSet(false);
  }

  @override
  bool prepareForUpdates(
      FKey fkey, PKey pkey, int fieldPKeyIndex, OnsetFunction onset) {
    stashUpdateInfo(fkey, pkey, fieldPKeyIndex, onset);
    return false;
  }

  @override
  bool ingestCborValue(CborValue value) {
    if (value is! CborString) {
      return false;
    }
    _s = value.toString();
    return true;
  }

  @override
  CborValue egestCborValue() {
    return CborString(_s);
  }
}
