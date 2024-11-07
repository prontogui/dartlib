// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:dartlib/src/field_hooks.dart';
import 'package:test/test.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/pkey.dart';

class FieldHooksMock implements FieldHooks {
  var timestamp = DateTime.now();
  var onsetCalled = 0;
  var onsetPkey = PKey();
  var onsetFKey = invalidFieldName;

  @override
  DateTime getEventTimestamp() {
    return timestamp;
  }

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural) {
    onsetCalled++;
    onsetPkey = pkey;
    onsetFKey = fkey;
  }

  void verifyOnsetCalled(int callCount, {PKey? pkey, FKey? fkey}) {
    expect(onsetCalled, equals(callCount));

    if (pkey != null) {
      expect(onsetPkey.isEqualTo(pkey), isTrue);
    }

    if (fkey != null) {
      expect(onsetFKey, equals(fkey));
    }
  }
}
