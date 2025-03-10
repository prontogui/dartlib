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

    test('should initialize with provided embodiment', () {
      final frame = Frame(embodiment: '{"embodiment": "full-view"}');

      expect(frame.embodiment, equals('{"embodiment": "full-view"}'));
      expect(frame.embodimentMap!['embodiment'], equals('full-view'));
    });

    test('should initialize with provided embodiment using special syntax 1',
        () {
      final frame = Frame(embodiment: 'full-view');

      expect(frame.embodiment, equals('{"embodiment":"full-view"}'));
      expect(frame.embodimentMap!['embodiment'], equals('full-view'));
    });

    test('should initialize with provided embodiment using special syntax 2',
        () {
      final frame = Frame(embodiment: 'embodiment : full-view, yadayada : 123');

      expect(frame.embodiment,
          equals('{"embodiment":"full-view","yadayada":"123"}'));
      expect(frame.embodimentMap!['embodiment'], equals('full-view'));
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

    test('should locate next descendant correctly', () {
      var primitive1 = Text();
      var primitive2 = Text();
      var frame = Frame(frameItems: [primitive1, primitive2]);
      var locator = PKeyLocator(PKey(0, 1));
      var descendant = frame.locateNextDescendant(locator);
      expect(descendant, primitive2);
    });

    test('should throw exception for out of bounds locator', () {
      final frame = Frame();
      final locator = PKeyLocator(PKey(0));
      locator.nextIndex();

      expect(() => frame.locateNextDescendant(locator), throwsException);
    });
  });
}
