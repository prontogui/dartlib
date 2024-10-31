// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';

typedef TimeProviderFunction = DateTime Function();

/// A field that holds a boolean value.
class EventField extends FieldBase implements Field {
  /// The timestamp returned from provider at the last time a value was injested.
  /// This is used to know if a value was injested during the current Wait cycle.
  DateTime? _eventTimestamp;

  /// A function that returns a timestamp uniquely tied to the current Wait cycle.
  TimeProviderFunction? _timeProvider;

  /// True if the event is issued.
  bool get issued {
    if (_eventTimestamp == null) {
      return false;
    }

    _checkMissingFunc();

    return _timeProvider!().difference(_eventTimestamp!) == Duration.zero;
  }

  /// Sets the time provider function to use.
  set timeProvider(TimeProviderFunction provider) {
    _timeProvider = provider;
  }

  void _checkMissingFunc() {
    if (_timeProvider == null) {
      throw Exception('Time provider function is missing');
    }
  }

  // Implement Field interface

  @override
  void ingestFullCborValue(CborValue value) {
    _checkMissingFunc();
    _eventTimestamp = _timeProvider!();
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
