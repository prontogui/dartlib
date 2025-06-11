// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:dartlib/src/text.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:dartlib/src/field_hooks.dart';
import 'package:dartlib/src/primitive_locator.dart';

void main() {
  group('Text', () {
    test('Default constructor initializes with empty strings', () {
      final text = Text();
      expect(text.content, '');
      expect(text.embodiment, '');
      expect(text.tag, '');
    });

    test('Constructor initializes with provided values', () {
      final text = Text(content: 'Hello', embodiment: 'FancyText', tag: 'Greeting');
      expect(text.content, 'Hello');
      expect(text.embodiment, '{"embodiment":"FancyText"}');
      expect(text.tag, 'Greeting');
    });

    test('Content getter and setter work correctly', () {
      final text = Text();
      text.content = 'New Content';
      expect(text.content, 'New Content');
    });

    test('Embodiment getter and setter work correctly', () {
      final text = Text();
      text.embodiment = 'FancyText';
      expect(text.embodiment, '{"embodiment":"FancyText"}');
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
      expect(() => text.prepareForUpdates(PKey(), NullFieldHooks(), NullPrimitiveLocator()),
          returnsNormally);
    });
  });
}
