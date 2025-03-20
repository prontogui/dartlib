// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:dartlib/src/tristate.dart';

void main() {
  group('Tristate', () {
    test('Default constructor initializes with default values', () {
      final tristate = Tristate();
      expect(tristate.state, 0);
      expect(tristate.label, '');
    });

    test('Constructor initializes with provided values', () {
      final tristate = Tristate(state: 1, label: 'Test Label');
      expect(tristate.state, 1);
      expect(tristate.label, 'Test Label');
    });

    test('State getter and setter work correctly', () {
      final tristate = Tristate();
      tristate.state = -1;
      expect(tristate.state, -1);
    });

    test('Label getter and setter work correctly', () {
      final tristate = Tristate();
      tristate.label = 'New Label';
      expect(tristate.label, 'New Label');
    });

    test('stateAsBool getter works correctly', () {
      final tristate = Tristate(state: 0);
      expect(tristate.stateAsBool, false);

      tristate.state = 1;
      expect(tristate.stateAsBool, true);

      tristate.state = 2;
      expect(tristate.stateAsBool, null);
    });

    test('stateAsBool setter works correctly', () {
      final tristate = Tristate();
      tristate.stateAsBool = true;
      expect(tristate.state, 1);

      tristate.stateAsBool = false;
      expect(tristate.state, 0);

      tristate.stateAsBool = null;
      expect(tristate.state, 2);
    });

    test('toString returns label', () {
      final tristate = Tristate(label: 'Sample Label');
      expect(tristate.toString(), 'Sample Label');
    });
    test('nextState cycles through states correctly', () {
      final tristate = Tristate(state: 0);

      tristate.nextState();
      expect(tristate.state, 1);

      tristate.nextState();
      expect(tristate.state, 2);

      tristate.nextState();
      expect(tristate.state, 0);
    });

    test('describeType returns correct type', () {
      final tristate = Tristate();
      expect(tristate.describeType, 'Tristate');
    });
  });
}
