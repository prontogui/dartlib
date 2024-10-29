// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/bool_field.dart';

void main() {
  group('BoolField', () {
    test('default value is false', () {
      final field = BoolField();
      expect(field.value, isFalse);
    });

    test('can be constructed from a string', () {
      final field = BoolField.from('true');
      expect(field.value, isTrue);
    });

    test('value can be set and retrieved', () {
      final field = BoolField();
      field.value = true;
      expect(field.value, isTrue);
    });

    test('ingestCborValue sets the value correctly', () {
      final field = BoolField();
      field.ingestCborValue(CborBool(true));
      expect(field.value, isTrue);
    });

    test('ingestCborValue throws exception for non-CborBool', () {
      final field = BoolField();
      expect(() => field.ingestCborValue(CborString('asfas')), throwsException);
    });

    test('egestCborValue returns the correct CborBool', () {
      final field = BoolField();
      field.value = true;
      final cborValue = field.egestCborValue();
      expect(cborValue, isA<CborBool>());
      expect((cborValue as CborBool).value, isTrue);
    });

    test('toString returns the correct string representation', () {
      final field = BoolField();
      field.value = true;
      expect(field.toString(), 'true');
    });
  });
}
