// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/integer_field.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/pkey.dart';
import 'field_hooks_mock.dart';

void main() {
  group('IntegerField', () {
    late IntegerField field;
    late FieldHooksMock fieldhooks;

    setUp(() {
      field = IntegerField();
      fieldhooks = FieldHooksMock();
    });

    prepareForUpdates() {
      field.prepareForUpdates(fkeyStatus, PKey(0), 2, fieldhooks);
    }

    test('default constructor initializes with 0', () {
      expect(field.value, equals(0));
    });

    test('constructor from string initializes with correct value', () {
      final field = IntegerField.from(42);
      expect(field.value, equals(42));
    });

    test('value setter updates the value', () {
      prepareForUpdates();
      field.value = 100;
      expect(field.value, equals(100));
      fieldhooks.verifyOnsetCalled(1);
    });

    test('ingestFullCborValue sets the value correctly for CborSmallInt', () {
      prepareForUpdates();
      final cborValue = CborSmallInt(123);
      field.ingestFullCborValue(cborValue);
      expect(field.value, equals(123));
      fieldhooks.verifyOnsetCalled(0);
    });

    test('ingestFullCborValue sets the value correctly for CborInt', () {
      prepareForUpdates();
      final cborValue = CborInt(BigInt.from(9203));
      field.ingestFullCborValue(cborValue);
      expect(field.value, equals(9203));
      fieldhooks.verifyOnsetCalled(0);
    });

    test('ingestFullCborValue sets the value correctly for CborBigInt', () {
      prepareForUpdates();
      final cborValue = CborBigInt(BigInt.from(9203));
      field.ingestFullCborValue(cborValue);
      expect(field.value, equals(9203));
      fieldhooks.verifyOnsetCalled(0);
    });

    test('ingestPartialCborValue sets the value correctly for CborSmallInt',
        () {
      prepareForUpdates();
      final cborValue = CborSmallInt(123);
      field.ingestPartialCborValue(cborValue);
      expect(field.value, equals(123));
      fieldhooks.verifyOnsetCalled(1);
    });

    test('ingestFullCborValue throws exception for non-CborSmallInt', () {
      final cborValue = CborString('not an int');
      expect(() => field.ingestFullCborValue(cborValue), throwsException);
    });

    test('egestCborValue returns correct CborSmallInt', () {
      field.value = 456;
      final cborValue = field.egestCborValue();
      expect(cborValue, isA<CborSmallInt>());
      expect((cborValue as CborSmallInt).value, equals(456));
    });

    test('toString returns correct string representation', () {
      field.value = 789;
      expect(field.toString(), equals('789`'));
    });
  });
}
