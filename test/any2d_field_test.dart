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

    test('should return correct number of rows and columns', () {
      populateField();
      expect(field.rowCount, equals(2));
      expect(field.columnCount, equals(1));
    });

    test('should handle empty array correctly', () {
      expect(field.rowCount, equals(0));
      expect(field.columnCount, equals(0));
    });

    test('initial value is an unmodifiable list', () {
      expect(() => field.value.clear(), throwsUnsupportedError);
    });

    test('construction value is an unmodifiable list', () {
      var altField = Any2DField.from([
        [Text(content: 'Content 1')],
      ]);
      expect(() => altField.value.clear(), throwsUnsupportedError);
    });

    test('columnCount is correct after contruction from array', () {
      var altField = Any2DField.from([
        [Text(content: 'Content 1'), Text(content: 'Content 2')],
      ]);
      expect(altField.columnCount, equals(2));
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

    test('should insert row correctly', () {
      populateField();
      var newRow = [Text(content: 'New Content')];
      field.insertRow(1, newRow);
      expect(field.value.length, equals(3));
      expect((field.value[1][0] as Text).content, equals('New Content'));
    });

    test('should append row when index = -1', () {
      populateField();
      var newRow = [Text(content: 'New Content')];
      field.insertRow(-1, newRow);
      expect(field.value.length, equals(3));
      expect((field.value[2][0] as Text).content, equals('New Content'));
    });

    test('should append row when index = 3', () {
      populateField();
      var newRow = [Text(content: 'New Content')];
      field.insertRow(3, newRow);
      expect(field.value.length, equals(3));
      expect((field.value[2][0] as Text).content, equals('New Content'));
    });

    test(
        'should throw exception when inserting row with incorrect column count',
        () {
      populateField();
      var newRow = [
        Text(content: 'New Content'),
        Text(content: 'Extra Content')
      ];
      expect(() => field.insertRow(1, newRow), throwsException);
    });

    test('should delete row correctly', () {
      populateField();
      field.deleteRow(0);
      expect(field.value.length, equals(1));
      expect(field.value[0][0], equals(primitive2));
    });

    test('should throw exception when deleting row with invalid index', () {
      populateField();
      expect(() => field.deleteRow(-1), throwsException);
      expect(() => field.deleteRow(2), throwsException);
    });
  });
}
