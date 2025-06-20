// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/any2d_field.dart';
import 'package:dartlib/src/text.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:dartlib/src/primitive_locator.dart';
import 'field_hooks_mock.dart';

void main() {
  group('Any2DField', () {
    late Any2DField field;
    late FieldHooksMock fieldhooks;
    late Text primitive1;
    late Text primitive2;

    setUp(() {
      // (re)assign test variables
      field = Any2DField();
      fieldhooks = FieldHooksMock();
      primitive1 = Text();
      primitive2 = Text();
    });

    populateField() {
      primitive1 = Text(content: 'Content 1');
      primitive2 = Text(content: 'Content 2');
      field.value = [
        [primitive1],
        [primitive2]
      ];
    }

    CborValue getCborContent() {
      return CborList([
        CborList([
          CborMap({
            CborString('Content'): CborString('new content 1'),
          }),
        ]),
        CborList([
          CborMap({
            CborString('Content'): CborString('new content 2'),
          }),
        ]),
      ]);
    }

    CborValue getCborEmptyContent() {
      return CborList([]);
    }

    populateFromFullCbor() {
      field.ingestFullCborValue(getCborContent());
    }

    populateFromPartialCbor() {
      field.ingestPartialCborValue(getCborContent());
    }

    prepareForUpdates() {
      var isStructural = field.prepareForUpdates(fkeyLabel, PKey(1), 0, fieldhooks, NullPrimitiveLocator());
      expect(isStructural, isTrue);
    }

    verifyUnmodifiable() {
      expect(() => field.value.clear(), throwsUnsupportedError);
      if (field.value.isNotEmpty) {
        expect(() => field.value[0].clear(), throwsUnsupportedError);
      }
    }

    test('should set and get value correctly', () {
      populateField();
      expect(field.value[0][0], equals(primitive1));
      expect(field.value[1][0], equals(primitive2));
      verifyUnmodifiable();
    });

    test('should return correct number of rows and columns', () {
      populateField();
      expect(field.rowCount, equals(2));
      expect(field.columnCount, equals(1));
    });

    test('initial value is empty array, no columns, and unmodifiable', () {
      expect(field.rowCount, equals(0));
      expect(field.columnCount, equals(0));
      verifyUnmodifiable();
    });

    test('columnCount is correct after contruction from array', () {
      var altField = Any2DField.from([
        [Text(content: 'Content 1'), Text(content: 'Content 2')],
      ]);
      expect(altField.columnCount, equals(2));
    });

    test('assgined value is an unmodifiable list', () {
      populateField();
      verifyUnmodifiable();
    });

    test('should throw exception when ingesting non-CborList value', () {
      var nonCborListValue = CborMap({});

      expect(
          () => field.ingestFullCborValue(nonCborListValue), throwsException);
    });

    test('should throw exception when ingesting a CborNull value', () {
      var cborNull = const CborNull();

      expect(() => field.ingestFullCborValue(cborNull), throwsException);
    });

    test('should ingest full Cbor value correctly', () {
      prepareForUpdates();
      populateFromFullCbor();
      expect(field.value.length, equals(2));
      expect(field.value[0].length, equals(1));
      expect((field.value[0][0] as Text).content, equals('new content 1'));
      expect(field.value[1].length, equals(1));
      expect((field.value[1][0] as Text).content, equals('new content 2'));
      fieldhooks.verifyTotalCalls(0);
      verifyUnmodifiable();
    });

    test('should ingest full Cbor, empty array, correctly', () {
      prepareForUpdates();
      field.ingestFullCborValue(getCborEmptyContent());
      expect(field.value.length, equals(0));
      verifyUnmodifiable();
    });

    test('should ingest partial Cbor value correctly', () {
      populateField();
      prepareForUpdates();
      populateFromPartialCbor();
      verifyUnmodifiable();
      expect(field.value.length, equals(2));
      expect(field.value[0].length, equals(1));
      var newp1 = field.value[0][0] as Text;
      var newp2 = field.value[1][0] as Text;

      expect(newp1.content, equals('new content 1'));
      expect(field.value[1].length, equals(1));
      expect(newp2.content, equals('new content 2'));
      fieldhooks.verifyOningestCalled(1);
    });

    test('should ingest partial Cbor, empty array, correctly', () {
      prepareForUpdates();
      field.ingestPartialCborValue(getCborEmptyContent());
      expect(field.value.length, equals(0));
      verifyUnmodifiable();
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
