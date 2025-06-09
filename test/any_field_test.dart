// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/text.dart';
import 'package:dartlib/src/any_field.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/pkey.dart';
import 'field_hooks_mock.dart';

import 'test_cbor_samples.dart';

void main() {
  group('AnyField', () {
    late AnyField field;
    late FieldHooksMock fieldhooks;
    late Text text;
    late Text otherText;

    setUp(() {
      // (re)assign test variables
      field = AnyField();
      fieldhooks = FieldHooksMock();
      text = Text(content: 'test text');
      otherText = Text(content: 'other test text');

      // Prepare for updates and set a field of text
      var isContainer = field.prepareForUpdates(fkeyLabel, PKey(0, 1, 2), 6, fieldhooks);
      expect(isContainer, isTrue);
    });

    test('initial value is null', () {
      final field = AnyField();
      expect(field.value, isNull);
    });

    test('set and get value', () {
      final primitive = Text(content: 'test');
      field.value = primitive;
      expect(field.value, equals(primitive));
      fieldhooks.verifyTotalCalls(1);
    });

    test('ingestFullCborValue works', () {
      field.ingestFullCborValue(distinctCborForText());
      expect(field.value!.describeType, equals('Text'));
      fieldhooks.verifyTotalCalls(0);
    });

    test('ingestParialCborValue works', () {
      field.value = text;
      field.ingestPartialCborValue(partialCborForText('ABC'));
      var newText = field.value as Text;
      expect(newText.content, equals('ABC'));
      // Verify the onset was called thrice (one time for previous field assignment,
      // one for the field itself, one time for primitive Content field update)
      fieldhooks.verifyTotalCalls(3);
    });

    test('ingestFullCborValue throws exception if value is not CborMap', () {
      final field = AnyField();
      expect(
          () => field.ingestFullCborValue(CborString('test')), throwsException);
    });

    test('ingestFullCborValue throws exception if primitive is null', () {
      final field = AnyField();
      expect(() => field.ingestFullCborValue(CborMap({})), throwsException);
    });

    test('ingestPartialCborValue throws exception if value is not CborMap', () {
      final field = AnyField();
      expect(() => field.ingestPartialCborValue(CborString('test')),
          throwsException);
    });

    test('ingestPartialCborValue throws exception if primitive is null', () {
      final field = AnyField();
      expect(() => field.ingestPartialCborValue(CborMap({})), throwsException);
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

    test('prepareForUpdates sets up field correctly (1)', () {
      field.value = text;
      fieldhooks.verifyOnsetCalled(1, pkey: PKey(0, 1, 2), fkey: fkeyLabel);
    });

    test('prepareForUpdates sets up descendant primitives correctly', () {
      field.value = text;
      text.content = 'updated';
      fieldhooks.verifyOnsetCalled(2,
          pkey: PKey(0, 1, 2, 6), fkey: fkeyContent);
    });

    test('when unpreparing for updates, it unprepares its primitive properly',
        () {
      field.unprepareForUpdates();
      field.value = text;
      fieldhooks.verifyTotalCalls(0);
    });

    test('assignment unprepares previous primitive', () {
      field.value = otherText;
      expect(text.notPreparedYet, isTrue);
    });

    test('ingest unprepares previous primitive', () {
      var update = {CborString('Content'): CborString('new stuff')};
      field.ingestFullCborValue(CborMap(update));
      expect(text.notPreparedYet, isTrue);
    });
  });
}
