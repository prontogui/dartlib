// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/integer_field.dart';

void main() {
  group('IntegerField', () {
    test('default constructor initializes with 0', () {
      final field = IntegerField();
      expect(field.value, equals(0));
    });

    test('constructor from string initializes with correct value', () {
      final field = IntegerField.from('42');
      expect(field.value, equals(42));
    });

    test('value setter updates the value', () {
      final field = IntegerField();
      field.value = 100;
      expect(field.value, equals(100));
    });

    test('ingestCborValue sets the value correctly for CborSmallInt', () {
      final field = IntegerField();
      final cborValue = CborSmallInt(123);
      field.ingestCborValue(cborValue);
      expect(field.value, equals(123));
    });

    test('ingestCborValue sets the value correctly for CborInt', () {
      final field = IntegerField();
      final cborValue = CborInt(BigInt.from(9203));
      field.ingestCborValue(cborValue);
      expect(field.value, equals(9203));
    });

    test('ingestCborValue sets the value correctly for CborBigInt', () {
      final field = IntegerField();
      final cborValue = CborBigInt(BigInt.from(9203));
      field.ingestCborValue(cborValue);
      expect(field.value, equals(9203));
    });

    test('ingestCborValue throws exception for non-CborSmallInt', () {
      final field = IntegerField();
      final cborValue = CborString('not an int');
      expect(() => field.ingestCborValue(cborValue), throwsException);
    });

    test('egestCborValue returns correct CborSmallInt', () {
      final field = IntegerField();
      field.value = 456;
      final cborValue = field.egestCborValue();
      expect(cborValue, isA<CborSmallInt>());
      expect((cborValue as CborSmallInt).value, equals(456));
    });

    test('toString returns correct string representation', () {
      final field = IntegerField();
      field.value = 789;
      expect(field.toString(), equals('789`'));
    });
  });
}
