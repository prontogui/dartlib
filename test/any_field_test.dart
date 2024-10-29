// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/text.dart';
import 'package:dartlib/src/any_field.dart';

void main() {
  group('AnyField', () {
    test('initial value is null', () {
      final field = AnyField();
      expect(field.value, isNull);
    });

    test('set and get value', () {
      final field = AnyField();
      final primitive = Text(content: 'test');
      field.value = primitive;
      expect(field.value, equals(primitive));
    });

    test('ingestCborValue throws exception if value is not CborMap', () {
      final field = AnyField();
      expect(() => field.ingestCborValue(CborString('test')), throwsException);
    });

    test('ingestCborValue throws exception if primitive is null', () {
      final field = AnyField();
      expect(() => field.ingestCborValue(CborMap({})), throwsException);
    });

    test('egestCborValue returns CborNull if primitive is null', () {
      final field = AnyField();
      expect(field.egestCborValue(), isA<CborNull>());
    });

    test('toString returns <empty> if primitive is null', () {
      final field = AnyField();
      expect(field.toString(), equals('<empty>'));
    });

    test('toString returns primitive description if primitive is not null', () {
      final field = AnyField();
      final primitive = Text(content: 'test');
      field.value = primitive;
      expect(field.toString(), equals(primitive.describeType));
    });
  });
}
