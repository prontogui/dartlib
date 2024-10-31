// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/any2d_field.dart';
import 'package:dartlib/src/text.dart';

void main() {
  group('Any2DField', () {
    late Any2DField field;
    late Text primitive1;
    late Text primitive2;

    setUp(() {
      field = Any2DField();
    });

    populateField() {
      primitive1 = Text(content: 'Content 1');
      primitive2 = Text(content: 'Content 2');
      field.value = [
        [primitive1],
        [primitive2]
      ];
    }

    populateFromCbor() {
      var cborValue = CborList([
        CborList([
          CborMap({
            CborString('Content'): CborString('content 1'),
          }),
          CborMap({
            CborString('Content'): CborString('content 2'),
          }),
        ]),
        CborList([
          CborMap({
            CborString('Content'): CborString('content 3'),
          }),
          CborMap({
            CborString('Content'): CborString('content 4'),
          }),
        ]),
      ]);

      field.ingestFullCborValue(cborValue);
    }

    test('should set and get value correctly', () {
      populateField();
      expect(field.value[0][0], equals(primitive1));
      expect(field.value[1][0], equals(primitive2));
    });

    test('initial value is an unmodifiable list', () {
      expect(() => field.value.clear(), throwsUnsupportedError);
    });

    test('assgined value is an unmodifiable list', () {
      populateField();
      expect(() => field.value.clear(), throwsUnsupportedError);
      expect(() => field.value[0].clear(), throwsUnsupportedError);
    });

    test('ingest value is an unmodifiable list', () {
      populateFromCbor();
      expect(() => field.value.clear(), throwsUnsupportedError);
      expect(() => field.value[0].clear(), throwsUnsupportedError);
    });

    test('should throw exception when ingesting non-CborList value', () {
      var nonCborListValue = CborMap({});

      expect(
          () => field.ingestFullCborValue(nonCborListValue), throwsException);
    });

    test('should ingest full Cbor value correctly', () {
      populateFromCbor();
      expect(field.value.length, equals(2));
      expect(field.value[0].length, equals(2));
      expect(field.value[1].length, equals(2));
    });

    test(
        'should throw exception when ingesting partial Cbor value with different length',
        () {
      var cborValue = CborList([
        CborList([CborMap({})])
      ]);

      expect(() => field.ingestPartialCborValue(cborValue), throwsException);
    });

    test('should egest Cbor value correctly', () {
      populateField();
      var cborValue = field.egestCborValue();
      expect(cborValue, isA<CborList>());
      expect((cborValue as CborList).length, equals(2));
    });

    test('toString should return correct description for empty array', () {
      expect(field.toString(), equals('<Empty>'));
    });

    test('toString should return correct description for uniform array', () {
      populateField();
      expect(field.toString(),
          contains('Array [2x1  primitives], column types: Text'));
    });
  });
}
