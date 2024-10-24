// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../key/pkey.dart';
import '../key/fkey.dart';
import '../key/onset.dart';

mixin FieldBase {
  // PKey of this field's container primitive.
  late PKey _pkey;

  // FKey of this field.
  late FKey _fkey;

  // The function to call to notify the field was updated.
  OnsetFunction? _onset;

  // This field's pkey index relative to its container primitive (if this field contains primitives).
  // It is used when assigning new primitives to this field.
  int _fieldPKeyIndex = -1;

  void stashUpdateInfo(
      FKey fkey, PKey pkey, fieldPKeyIndex, OnsetFunction onset) {
    _fkey = fkey;
    _pkey = pkey;
    _fieldPKeyIndex = fieldPKeyIndex;
    _onset = onset;
  }

  void onSet(bool structural) {
    if (_onset != null) {
      _onset!(_pkey, _fkey, structural);
    }
  }
}
