import 'package:test/test.dart';
import 'package:dartlib/src/timer.dart';

void main() {
  group('Timer', () {
    test('should initialize with default periodMs', () {
      final timer = Timer();
      expect(timer.periodMs, 0);
    });

    test('should initialize with given periodMs', () {
      final timer = Timer(periodMs: 1000);
      expect(timer.periodMs, 1000);
    });

    test('should update periodMs', () {
      final timer = Timer();
      timer.periodMs = 500;
      expect(timer.periodMs, 500);
    });

    test('should describe type correctly', () {
      final timer = Timer();
      expect(timer.describeType, 'Timer');
    });

    test('should convert to string correctly', () {
      final timer = Timer(periodMs: 2000);
      expect(timer.toString(), 'Timer: periodMs=2000 (ms)');
    });
  });
}
