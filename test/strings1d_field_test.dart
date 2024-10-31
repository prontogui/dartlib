// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/strings1d_field.dart';

void main() {
  group('Strings1DField', () {
    late Strings1DField field;

    setUp(() {
      field = Strings1DField();
    });

    List<String> populateField() {
      var testValue = ['hello', 'world'];
      field.value = testValue;
      return testValue;
    }

    test('initial value is empty', () {
      expect(field.value, isEmpty);
    });

    test('set and get value', () {
      var testValue = populateField();
      expect(field.value, equals(testValue));
    });

    test('set makes a copy of value', () {
      final testValue = ['hello', 'world'];
      field.value = testValue;

      // Modify testValue.  This should not affect field.value.
      testValue.clear();

      expect(field.value, equals(['hello', 'world']));
    });

    test('get returns a copy of value', () {
      var testValue = populateField();

      var value = field.value;
      value.clear();

      expect(field.value, equals(testValue));
    });

    test('ingestFullCborValue with valid CborList', () {
      final cborList = CborList([CborString('hello'), CborString('world')]);
      field.ingestFullCborValue(cborList);
      expect(field.value, equals(['hello', 'world']));
    });

    test('ingestFullCborValue with invalid CborList throws exception', () {
      final cborList = CborList([CborString('hello'), CborSmallInt(42)]);
      expect(() => field.ingestFullCborValue(cborList), throwsException);
    });

    test('ingestPartialCborValue with valid CborList', () {
      final cborList = CborList([CborString('hello'), CborString('world')]);
      field.ingestPartialCborValue(cborList);
      expect(field.value, equals(['hello', 'world']));
    });

    test('ingestPartialCborValue with invalid CborList throws exception', () {
      final cborList = CborList([CborString('hello'), CborSmallInt(42)]);
      expect(() => field.ingestPartialCborValue(cborList), throwsException);
    });

    test('egestCborValue returns correct CborList', () {
      field.value = ['hello', 'world'];
      final cborValue = field.egestCborValue();
      expect(cborValue, isA<CborList>());
      expect((cborValue as CborList).toList(),
          equals([CborString('hello'), CborString('world')]));
    });

    test('toString returns correct string representation', () {
      field.value = ['hello', 'world'];
      expect(field.toString(), equals('"hello", "world"'));
    });
  });
}
