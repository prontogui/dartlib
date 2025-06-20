// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'pkey.dart';
import 'fkey.dart';
import 'field_hooks.dart';
import 'field.dart';
import 'primitive_locator.dart';

abstract class FieldBase implements Field {
  FieldBase() : _isStructural = false {
    // Initialize the late fields, which is the same thing as unpreparing for updates.
    unprepareForUpdates();
  }

  FieldBase.structural() : _isStructural = true {
    // Initialize the late fields, which is the same thing as unpreparing for updates.
    unprepareForUpdates();
  }

  // Private storage for pkey field.
  late PKey _pkey;

  // Private storage for FKey of this field.
  late FKey _fkey;

  // Private storage for the fieldHooks field.
  late FieldHooks? _fieldHooks;

  // Private storage for fieldPKeyIndex field.
  late int _fieldPKeyIndex;

  /// PKey of this field's container primitive.
  PKey get pkey => PKey.fromPKey(_pkey);

  /// This field's pkey index relative to its container primitive (if this field contains primitives).
  /// It is used when assigning new primitives to this field.
  int get fieldPKeyIndex => _fieldPKeyIndex;

  // The interface to call to notify the field was updated.
  FieldHooks? get fieldHooks => _fieldHooks;

  /// True if the field has not been prepared yet for updates.
  bool get notPreparedYet => (_fieldHooks == null);

  /// Non-structural by default.  Structural fields must override prepareForUpdates.
  /// Derived field classes can override this when they are considered structural, that is,
  /// they contain other primitives.
  final bool _isStructural;

  bool get isStructural {
    return _isStructural;
  }

  @override
  bool prepareForUpdates(
      FKey fkey, PKey pkey, int fieldPKeyIndex, FieldHooks fieldHooks, PrimitiveLocator locator) {
    _fkey = fkey;
    _pkey = pkey;
    _fieldPKeyIndex = fieldPKeyIndex;
    _fieldHooks = fieldHooks;

    return isStructural;
  }

  @override
  void unprepareForUpdates() {
    _pkey = PKey();
    _fkey = invalidFieldName;
    _fieldPKeyIndex = -1;
    _fieldHooks = null;
  }

  void onSet() {
    if (_fieldHooks != null) {
      _fieldHooks!.onSetField(_pkey, _fkey, isStructural);
    }
  }

  void onIngest() {
    if (_fieldHooks != null) {
      _fieldHooks!.onIngestField(_pkey, _fkey, isStructural);
    }
  }
}
