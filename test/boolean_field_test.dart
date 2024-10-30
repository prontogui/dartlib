// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/boolean_field.dart';

void main() {
  group('BoolField', () {
    test('default value is false', () {
      final field = BooleanField();
      expect(field.value, isFalse);
    });

    test('can be constructed from a string', () {
      final field = BooleanField.from('true');
      expect(field.value, isTrue);
    });

    test('value can be set and retrieved', () {
      final field = BooleanField();
      field.value = true;
      expect(field.value, isTrue);
    });

    test('ingestFullCborValue sets the value correctly', () {
      final field = BooleanField();
      field.ingestFullCborValue(CborBool(true));
      expect(field.value, isTrue);
    });

    test('ingestFullCborValue throws exception for non-CborBool', () {
      final field = BooleanField();
      expect(() => field.ingestFullCborValue(CborString('asfas')),
          throwsException);
    });

    test('ingestPartialCborValue sets the value correctly', () {
      final field = BooleanField();
      field.ingestPartialCborValue(CborBool(true));
      expect(field.value, isTrue);
    });

    test('ingestPartialCborValue throws exception for non-CborBool', () {
      final field = BooleanField();
      expect(() => field.ingestPartialCborValue(CborString('asfas')),
          throwsException);
    });

    test('egestCborValue returns the correct CborBool', () {
      final field = BooleanField();
      field.value = true;
      final cborValue = field.egestCborValue();
      expect(cborValue, isA<CborBool>());
      expect((cborValue as CborBool).value, isTrue);
    });

    test('toString returns the correct string representation', () {
      final field = BooleanField();
      field.value = true;
      expect(field.toString(), 'true');
    });
  });
}
