// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'package:statemachine/statemachine.dart';

/// A transition that happens automatically after a certain duration elapsed and
/// it reports progress every second.  Derived from statemachine TimeoutTransition
/// with a couple of additional features.
class ProgressTransition extends Transition {
  ProgressTransition(this.duration, this.callback, {this.progressCallback});

  /// The duration to wait before the timer triggers.
  final Duration duration;

  /// The callback to be evaluated when the timer is done.
  final Callback0 callback;

  /// The optional callback to be evaluated every second the timer ticks.
  final Callback1<int>? progressCallback;

  /// Time triggering after a timeout.
  Timer? _timer;

  /// The number of elapsed timer ticks since the transition was activated.
  int get tick => _timer?.tick ?? 0;

  @override
  void activate() {
    assert(_timer == null, 'timer must be null');
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (progressCallback != null) {
        progressCallback!(_timer!.tick);
      }
      if (_timer!.tick == duration.inSeconds) {
        callback();
        _timer?.cancel();
        _timer = null;
      }
    });
  }

  @override
  void deactivate() {
    _timer?.cancel();
    _timer = null;
  }
}
