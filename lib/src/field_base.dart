// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'pkey.dart';
import 'fkey.dart';
import 'onset.dart';

abstract class FieldBase {
  // PKey of this field's container primitive.
  late PKey _pkey;

  // FKey of this field.
  late FKey _fkey;

  // The function to call to notify the field was updated.
  OnsetFunction? _onset;

  // This field's pkey index relative to its container primitive (if this field contains primitives).
  // It is used when assigning new primitives to this field.
  int _fieldPKeyIndex = -1;

  /// Derived field classes can override this when they are considered structural, that is,
  /// they contain other primitives.
  bool get isStructural => false;

  @override
  void prepareForUpdates(
      FKey fkey, PKey pkey, int fieldPKeyIndex, OnsetFunction onset) {
    _fkey = fkey;
    _pkey = pkey;
    _fieldPKeyIndex = fieldPKeyIndex;
    _onset = onset;
  }

  void onSet() {
    if (_onset != null) {
      _onset!(_pkey, _fkey, isStructural);
    }
  }
}
