import 'package:test/test.dart';
import 'package:dartlib/primitive/primitive_base.dart';
import 'package:dartlib/primitive/text.dart';
import 'package:dartlib/key/pkey.dart';

void main() {
  group('Text', () {
    test('Default constructor initializes with empty strings', () {
      final text = Text();
      expect(text.content, '');
      expect(text.embodiment, '');
      expect(text.tag, '');
    });

    test('Constructor initializes with provided values', () {
      final text = Text(content: 'Hello', embodiment: 'Bold', tag: 'Greeting');
      expect(text.content, 'Hello');
      expect(text.embodiment, 'Bold');
      expect(text.tag, 'Greeting');
    });

    test('Content getter and setter work correctly', () {
      final text = Text();
      text.content = 'New Content';
      expect(text.content, 'New Content');
    });

    test('Embodiment getter and setter work correctly', () {
      final text = Text();
      text.embodiment = 'Italic';
      expect(text.embodiment, 'Italic');
    });

    test('Tag getter and setter work correctly', () {
      final text = Text();
      text.tag = 'New Tag';
      expect(text.tag, 'New Tag');
    });

    test('toString returns content', () {
      final text = Text(content: 'Sample Text');
      expect(text.toString(), 'Sample Text');
    });

    test('prepareForUpdates does not throw', () {
      final text = Text();
      expect(
          () => text.prepareForUpdates(PKey(), (PKey pkey, int i, bool b) {}),
          returnsNormally);
    });
  });
}
