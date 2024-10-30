// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/string_field.dart';

void main() {
  group('StringField', () {
    test('initial value is empty string', () {
      var field = StringField();
      expect(field.value, equals(''));
    });

    test('set and get value', () {
      var field = StringField();
      field.value = 'test';
      expect(field.value, equals('test'));
    });

    test('isStructural returns false', () {
      var field = StringField();
      expect(field.isStructural, isFalse);
    });

    test('ingestFullCborValue with valid CborString', () {
      var field = StringField();
      var cborValue = CborString('test');
      field.ingestFullCborValue(cborValue);
      expect(field.value, equals('test'));
    });

    test('ingestFullCborValue with invalid CborValue', () {
      var field = StringField();
      var cborValue = CborSmallInt(123);
      try {
        field.ingestFullCborValue(cborValue);
      } catch (e) {
        expect(e, isA<Exception>());
        expect(e.toString(), equals('Exception: value is not a CborString'));
      }
    });

    test('egestCborValue returns CborString', () {
      var field = StringField();
      field.value = 'test';
      var cborValue = field.egestCborValue();
      expect(cborValue, isA<CborString>());
      expect((cborValue as CborString).toString(), equals('test'));
    });
  });
}
