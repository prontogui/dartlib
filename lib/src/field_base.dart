// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'pkey.dart';
import 'fkey.dart';
import 'onset.dart';
import 'field.dart';

abstract class FieldBase implements Field {
  FieldBase() {
    // Initialize the late fields, which is the same thing as unpreparing for updates.
    unprepareForUpdates();
  }

  // Private storage for pkey field.
  late PKey _pkey;

  // Private storage for FKey of this field.
  late FKey _fkey;

  // Private storage for the onset field.
  late OnsetFunction? _onset;

  // Private storage for fieldPKeyIndex field.
  late int _fieldPKeyIndex;

  /// PKey of this field's container primitive.
  PKey get pkey => PKey.fromPKey(_pkey);

  /// This field's pkey index relative to its container primitive (if this field contains primitives).
  /// It is used when assigning new primitives to this field.
  int get fieldPKeyIndex => _fieldPKeyIndex;

  // The function to call to notify the field was updated.
  OnsetFunction? get onset => _onset;

  /// True if the field has not been prepared yet for updates.
  bool get notPreparedYet => (_onset == null);

  /// Derived field classes can override this when they are considered structural, that is,
  /// they contain other primitives.
  @override
  bool get isStructural => false;

  @override
  void prepareForUpdates(
      FKey fkey, PKey pkey, int fieldPKeyIndex, OnsetFunction onset) {
    _fkey = fkey;
    _pkey = pkey;
    _fieldPKeyIndex = fieldPKeyIndex;
    _onset = onset;
  }

  @override
  void unprepareForUpdates() {
    _pkey = PKey();
    _fkey = invalidFieldName;
    _fieldPKeyIndex = -1;
    _onset = null;
  }

  void onSet() {
    if (_onset != null) {
      _onset!(_pkey, _fkey, isStructural);
    }
  }
}
