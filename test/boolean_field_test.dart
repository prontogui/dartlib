// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/boolean_field.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/pkey.dart';
import 'field_hooks_mock.dart';

void main() {
  group('BoolField', () {
    late BooleanField field;
    late FieldHooksMock fieldhooks;

    setUp(() {
      field = BooleanField();
      fieldhooks = FieldHooksMock();
    });

    prepareForUpdates() {
      field.prepareForUpdates(fkeyChecked, PKey(0), 2, fieldhooks);
    }

    test('default value is false', () {
      expect(field.value, isFalse);
    });

    test('can be constructed from a string', () {
      final field = BooleanField.from(true);
      expect(field.value, isTrue);
    });

    test('value can be set and retrieved', () {
      prepareForUpdates();
      field.value = true;
      expect(field.value, isTrue);
      fieldhooks.verifyTotalCalls(1);
    });

    test('ingestFullCborValue sets the value correctly', () {
      prepareForUpdates();
      field.ingestFullCborValue(CborBool(true));
      expect(field.value, isTrue);
      fieldhooks.verifyTotalCalls(0);
    });

    test('ingestFullCborValue throws exception for non-CborBool', () {
      expect(() => field.ingestFullCborValue(CborString('asfas')),
          throwsException);
    });

    test('ingestPartialCborValue sets the value correctly', () {
      prepareForUpdates();
      field.ingestPartialCborValue(CborBool(true));
      expect(field.value, isTrue);
      fieldhooks.verifyTotalCalls(1);
    });

    test('ingestPartialCborValue throws exception for non-CborBool', () {
      expect(() => field.ingestPartialCborValue(CborString('asfas')),
          throwsException);
    });

    test('egestCborValue returns the correct CborBool', () {
      field.value = true;
      final cborValue = field.egestCborValue();
      expect(cborValue, isA<CborBool>());
      expect((cborValue as CborBool).value, isTrue);
    });

    test('toString returns the correct string representation', () {
      field.value = true;
      expect(field.toString(), 'true');
    });
  });
}
