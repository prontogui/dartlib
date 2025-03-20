// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'pkey.dart';
import 'fkey.dart';

/// Hooks to provide all fields for them to notify when they are updated,
/// get timestamps for event fields, etc.
abstract class FieldHooks {
  void onSetField(PKey pkey, FKey fkey, bool structural);
  void onIngestField(PKey pkey, FKey fkey, bool structural);
  DateTime getEventTimestamp();
}

/// A null implementation of [FieldHooks] that does nothing.  Primarily used
/// for testing purposes.
class NullFieldHooks implements FieldHooks {
  NullFieldHooks() : _timestamp = DateTime.now();

  final DateTime _timestamp;

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural) {
    // Do nothing.
  }

  @override
  void onIngestField(PKey pkey, FKey fkey, bool structural) {
    // Do nothing.
  }

  @override
  DateTime getEventTimestamp() => _timestamp;
}
