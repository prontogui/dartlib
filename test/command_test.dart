// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:dartlib/src/field_hooks.dart';
import 'package:test/test.dart';
import 'package:dartlib/src/command.dart';
import 'package:dartlib/src/pkey.dart';

import 'test_cbor_samples.dart';

void main() {
  group('Command', () {
    test('initial values are set correctly', () {
      final command = Command(label: 'Test Command', status: 1);

      expect(command.label, 'Test Command');
      expect(command.status, 1);
      expect(command.enabled, false);
      expect(command.visible, true);
    });

    test('issueNow sets issued to true', () {
      final command = Command();
      command.prepareForUpdates(PKey(0), NullFieldHooks());
      command.issueNow();

      expect(command.issued, true);
    });

    test('label getter and setter work correctly', () {
      final command = Command();
      command.label = 'New Label';

      expect(command.label, 'New Label');
    });

    test('status getter and setter work correctly', () {
      final command = Command();
      command.status = 2;

      expect(command.status, 2);
      expect(command.enabled, false);
      expect(command.visible, false);
    });

    test('enabled getter and setter work correctly', () {
      final command = Command();
      command.enabled = true;

      expect(command.status, 0);
      expect(command.enabled, true);

      command.enabled = false;

      expect(command.status, 1);
      expect(command.enabled, false);
    });

    test('visible getter and setter work correctly', () {
      final command = Command();
      command.visible = true;

      expect(command.status, 0);
      expect(command.visible, true);

      command.visible = false;

      expect(command.status, 2);
      expect(command.visible, false);
    });

    test('all fields are added', () {
      final command = Command();
      expect(
          () => command.initializeFromCborMap(
              PKey(0), cborForCommandAsOutlined()),
          returnsNormally);
    });
  });
}
