// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';

/// A field that holds a boolean value.
class EventField extends FieldBase implements Field {
  /// The timestamp returned from provider at the last time a value was injested.
  /// This is used to know if a value was injested during the current Wait cycle.
  DateTime? _eventTimestamp;

  /// True if the event is issued.
  bool get issued {
    if (_eventTimestamp == null) {
      return false;
    }
    if (fieldHooks == null) {
      return false;
    }

    return fieldHooks!.getEventTimestamp().difference(_eventTimestamp!) ==
        Duration.zero;
  }

  /// Issues the event now.
  void issueNow() {
    if (fieldHooks == null) {
      return;
    }

    _eventTimestamp = fieldHooks!.getEventTimestamp();
  }

  // Implement Field interface

  @override
  void ingestFullCborValue(CborValue value) {
    if (fieldHooks == null) {
      return;
    }
    _eventTimestamp = fieldHooks!.getEventTimestamp();
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    ingestFullCborValue(value);
  }

  @override
  CborValue egestCborValue() {
    return CborBool(false);
  }

  // Object overrides

  @override
  String toString() {
    if (issued) {
      return '<Event Issued>';
    } else {
      return '<Event Not Issued>';
    }
  }
}
