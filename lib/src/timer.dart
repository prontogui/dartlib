// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'primitive_base.dart';
import 'integer_field.dart';
import 'event_field.dart';

// A timer is an invisible primitive that fires an event, triggering an update
// to the server.  This is useful for low-precision GUI updates that originate
// on the server side.  An example is updating "live" readings from a running
// process on the server.
class Timer extends PrimitiveBase {
  Timer({super.embodiment, super.tag, int periodMs = 0}) {
    _periodMs = IntegerField.from(periodMs);
    _timerFired = EventField();
  }

  // Field storage
  late IntegerField _periodMs;
  late EventField _timerFired;

  @override
  String get describeType => 'Timer';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyPeriodMs, _periodMs));
    fieldRefs.add(FieldRef(fkeyTimerFired, _timerFired));
  }

  @override
  String toString() {
    return 'Timer: periodMs=${_periodMs.value} (ms)';
  }

  /// The period of the timer in milliseconds.
  int get periodMs => _periodMs.value;
  set periodMs(int periodMs) => _periodMs.value = periodMs;

  /// Fires the event for the timer.
  void fireTimer() {
    _timerFired.issueNow();
  }
}
