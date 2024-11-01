import 'package:test/test.dart';
import 'package:dartlib/src/frame.dart';
import 'package:dartlib/src/text.dart';
import 'package:dartlib/src/pkey.dart';

void main() {
  group('Frame', () {
    test('should initialize with default values', () {
      final frame = Frame();

      expect(frame.frameItems, isEmpty);
      expect(frame.showing, isFalse);
    });

    test('should initialize with provided values', () {
      final primitive = Text();
      final frame = Frame(frameItems: [primitive], showing: true);

      expect(frame.frameItems, contains(primitive));
      expect(frame.showing, isTrue);
    });

    test('should update frameItems', () {
      final frame = Frame();
      final primitive = Text();

      frame.frameItems = [primitive];

      expect(frame.frameItems, contains(primitive));
    });

    test('should update showing', () {
      final frame = Frame();

      frame.showing = true;

      expect(frame.showing, isTrue);
    });

    test('should describe type correctly', () {
      final frame = Frame();

      expect(frame.describeType, 'Frame');
    });

    test('should throw exception for out of bounds locator', () {
      final frame = Frame();
      final locator = PKeyLocator(PKey(0));
      locator.nextIndex();

      expect(() => frame.locateNextDescendant(locator), throwsException);
    });
  });
}
