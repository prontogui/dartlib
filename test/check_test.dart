import 'package:test/test.dart';
import 'package:dartlib/src/check.dart';

import 'test_cbor_samples.dart';
import 'package:dartlib/src/pkey.dart';

void main() {
  group('Check', () {
    test('Default constructor initializes with default values', () {
      final check = Check();
      expect(check.checked, false);
      expect(check.label, '');
    });

    test('Constructor initializes with provided values', () {
      final check = Check(checked: true, label: 'Accept Terms');
      expect(check.checked, true);
      expect(check.label, 'Accept Terms');
    });

    test('Checked getter and setter work correctly', () {
      final check = Check();
      check.checked = true;
      expect(check.checked, true);
      check.checked = false;
      expect(check.checked, false);
    });

    test('Label getter and setter work correctly', () {
      final check = Check();
      check.label = 'New Label';
      expect(check.label, 'New Label');
    });

    test('toString returns label', () {
      final check = Check(label: 'Sample Label');
      expect(check.toString(), 'Sample Label');
    });

    test('describeType returns correct type', () {
      final check = Check();
      expect(check.describeType, 'Check');
    });

    test('nextState toggles the checked state', () {
      final check = Check();
      expect(check.checked, false);
      check.nextState();
      expect(check.checked, true);
      check.nextState();
      expect(check.checked, false);
    });

    test('all fields are added', () {
      final command = Check();
      expect(
          () => command.initializeFromCborMap(PKey(0), cborForCheck('Turn On')),
          returnsNormally);
    });
  });
}
