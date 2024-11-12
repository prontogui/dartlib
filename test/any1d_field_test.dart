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
import 'field_hooks_mock.dart';

void main() {
  group('Any1DField', () {
    late Any1DField field;
    late FieldHooksMock fieldhooks;
    late Text primitive1;
    late Text primitive2;

    setUp(() {
      // (re)assign test variables
      field = Any1DField();
      fieldhooks = FieldHooksMock();
      primitive1 = Text();
      primitive2 = Text();
    });

    List<Text> primitives() => [primitive1, primitive2];

    populateField() {
      primitive1 = Text(content: 'Original Content 1');
      primitive2 = Text(content: 'Original Content 2');
      field.value = [primitive1, primitive2];
    }

    void prepareForUpdates() {
      field.prepareForUpdates(fkeyLabel, PKey(1), 0, fieldhooks);
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

    populateFromFullCbor() {
      field.ingestFullCborValue(getCborForTesting());
    }

    populateFromPartialCbor() {
      field.ingestPartialCborValue(getCborForTesting());
    }

    verifyUnmodifiable() {
      expect(() => field.value.clear(), throwsUnsupportedError);
    }

    test('initial value is an empty, unmodifiable list', () {
      expect(field.value, isEmpty);
      verifyUnmodifiable();
    });

    test('setting value updates the internal list', () {
      populateField();
      expect(field.value, equals(primitives()));
      verifyUnmodifiable();
    });

    test('assigned value is an unmodifiable list', () {
      prepareForUpdates();
      populateField();
      verifyUnmodifiable();
      fieldhooks.verifyTotalCalls(1);
    });

    test('ingested value is an unmodifiable list', () {
      var cborList = CborList([
        CborMap({
          CborString('Content'): CborString('new content 1'),
        }),
      ]);
      field.ingestFullCborValue(cborList);
      verifyUnmodifiable();
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
      prepareForUpdates();
      populateFromFullCbor();
      verifyUnmodifiable();

      var newText = field.value[0] as Text;
      expect(newText.content, equals('new content 1'));

      expect(field.value.length, equals(2));

      // Verify the previous primitives have been unprepared
      expect(primitive1.notPreparedYet, isTrue);
      expect(primitive2.notPreparedYet, isTrue);

      // Verify the new primitives have correct field assignment and have been prepared for updates
      var newp1 = field.value[0] as Text;
      var newp2 = field.value[1] as Text;
      expect(newp1.content, equals('new content 1'));
      expect(newp1.notPreparedYet, isFalse);
      expect(newp2.content, equals('new content 2'));
      expect(newp2.notPreparedYet, isFalse);

      // Verify the onset was not called
      fieldhooks.verifyTotalCalls(0);
    });

    test('ingestPartialCborValue updates the internal list', () {
      populateField();
      prepareForUpdates();
      populateFromPartialCbor();
      verifyUnmodifiable();

      var newp1 = field.value[0] as Text;
      var newp2 = field.value[1] as Text;
      expect(newp1.content, equals('new content 1'));
      expect(newp2.content, equals('new content 2'));

      expect(newp1.notPreparedYet, isFalse);
      expect(newp2.notPreparedYet, isFalse);

      expect(primitive1.notPreparedYet, isTrue);
      expect(primitive2.notPreparedYet, isTrue);
      fieldhooks.verifyOningestCalled(1);
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
