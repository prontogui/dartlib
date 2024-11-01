// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:dartlib/src/field_hooks.dart';
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:dartlib/src/any1d_field.dart';
import 'package:dartlib/src/text.dart';

void main() {
  group('Any1DField', () {
    late Any1DField field;
    late Text primitive1;
    late Text primitive2;

    List<Text> primitives() => [primitive1, primitive2];

    setUp(() {
      field = Any1DField();
    });

    populateField() {
      primitive1 = Text(content: 'Original Content 1');
      primitive2 = Text(content: 'Original Content 2');
      field.value = [primitive1, primitive2];
    }

    CborValue getCborForTesting() {
      return CborList([
        CborMap({
          CborString('Content'): CborString('new content 1'),
        }),
        CborMap({
          CborString('Content'): CborString('new content 2'),
        }),
      ]);
    }

    populateFromCbor() {
      field.ingestFullCborValue(getCborForTesting());
    }

    test('initial value is an empty list', () {
      expect(field.value, isEmpty);
    });

    test('setting value updates the internal list', () {
      populateField();
      expect(field.value, equals(primitives()));
    });

    test('initial value is an unmodifiable list', () {
      expect(() => field.value.clear(), throwsUnsupportedError);
    });

    test('assigned value is an unmodifiable list', () {
      populateField();
      expect(() => field.value.clear(), throwsUnsupportedError);
    });

    test('ingested value is an unmodifiable list', () {
      var cborList = CborList([
        CborMap({
          CborString('Content'): CborString('new content 1'),
        }),
      ]);
      field.ingestFullCborValue(cborList);
      expect(() => field.value.clear(), throwsUnsupportedError);
    });

    test('prepareForUpdates prepares descendant primitives', () {
      var primitives = [
        Text(content: 'Original Content 1'),
        Text(content: 'Original Content 2')
      ];
      field.value = primitives;
      field.prepareForUpdates(fkeyLabel, PKey(1), 0, NullFieldHooks());
      for (var primitive in primitives) {
        expect(primitive.notPreparedYet, isFalse);
      }
    });

    test('assignment prepares descendant primitives', () {
      field.prepareForUpdates(fkeyLabel, PKey(1), 0, NullFieldHooks());
      populateField();
      for (var primitive in primitives()) {
        expect(primitive.notPreparedYet, isFalse);
      }
    });

    test('assignment unprepares descendant primitives', () {
      var primitives = [
        Text(content: 'Original Content 1'),
        Text(content: 'Original Content 2')
      ];
      field.prepareForUpdates(fkeyLabel, PKey(1), 0, NullFieldHooks());
      field.value = primitives;

      var newPrimitives = [
        Text(content: 'New Content 1'),
      ];
      field.value = newPrimitives;

      for (var primitive in primitives) {
        expect(primitive.notPreparedYet, isTrue);
      }
    });

    test('ingestFullCborValue updates the internal list', () {
      populateField();
      populateFromCbor();

      field.prepareForUpdates(fkeyLabel, PKey(1), 0, NullFieldHooks());

      var newText = field.value[0] as Text;
      expect(newText.content, equals('new content 1'));

      expect(field.value.length, equals(2));
      expect(primitive1.content, equals('Original Content 1'));
      expect(primitive1.notPreparedYet, isTrue);
      expect(primitive2.content, equals('Original Content 2'));
      expect(primitive2.notPreparedYet, isTrue);
    });

    test('ingestPartialCborValue updates existing primitives', () {
      populateField();
      field.ingestPartialCborValue(getCborForTesting());
      expect(primitive1.content, equals('new content 1'));
      expect(primitive2.content, equals('new content 2'));
    });

    test('egestCborValue returns the correct CborList', () {
      var p1 = Text(content: 'Original Content 1');
      var p2 = Text(content: 'Original Content 2');
      var primitives = [p1, p2];
      field.value = primitives;
      var cborValue = field.egestCborValue();
      expect(cborValue, isA<CborList>());
      expect((cborValue as CborList).length, equals(2));
    });

    test('toString returns for empty array', () {
      expect(field.toString(), equals('<Empty>'));
    });

    test('toString returns a comma-separated list of primitive types', () {
      populateField();
      expect(field.toString(),
          equals('Array [2 primitives] with types: Text, Text'));
    });
  });
}
