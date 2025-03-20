// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:dartlib/src/textfield.dart';

void main() {
  group('TextField', () {
    test('initial textEntry is set correctly', () {
      final textField = TextField(textEntry: 'Hello');
      expect(textField.textEntry, 'Hello');
    });

    test('textEntry can be updated', () {
      final textField = TextField(textEntry: 'Hello');
      textField.textEntry = 'World';
      expect(textField.textEntry, 'World');
    });

    test('describeType returns correct type', () {
      final textField = TextField();
      expect(textField.describeType, 'TextField');
    });

    test('toString returns textEntry value', () {
      final textField = TextField(textEntry: 'Hello');
      expect(textField.toString(), 'Hello');
    });
  });
}
