// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/text.dart';
import 'package:dartlib/src/any_field.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/pkey.dart';

class PrepareForUpdatesSetup {
  PrepareForUpdatesSetup() {
    _setupTest();
  }

  final field = AnyField();
  final text = Text(content: 'test text');
  final otherText = Text(content: 'other test text');

  var onsetCalled = 0;
  var onsetPkey = PKey();
  var onsetFKey = invalidFieldName;

  void onset(PKey pkey, FKey fkey, bool structural) {
    onsetCalled++;
    onsetPkey = pkey;
    onsetFKey = fkey;
  }

  void _setupTest() {
    // Prepare for updates and set a field of text
    final fkey = fkeyLabel;
    final pkey = PKey(0, 1, 2);
    field.prepareForUpdates(fkey, pkey, 6, onset);
  }

  void verifyOnsetCalled1() {
    // Onset should have been called with the correct PKey and FKey.  Note:
    // the FKey is the field name of the field that was updated and PKey is
    // the PKey supplied to prepareForUpdates with the field index appended.
    expect(onsetCalled, equals(1));
    expect(onsetPkey.isEqualTo(PKey(0, 1, 2)), isTrue);
    expect(onsetFKey, equals(fkeyLabel));
  }

  void verifyOnsetCalled2() {
    // Onset should have been called with the correct PKey and FKey.  Note:
    // the FKey is the field name of the field that was updated and PKey is
    // the PKey supplied to prepareForUpdates with the field index appended.
    expect(onsetCalled, equals(2));
    expect(onsetPkey.isEqualTo(PKey(0, 1, 2, 6)), isTrue);
    expect(onsetFKey, equals(fkeyContent));
  }

  void verifyOnsetNotCalled() {
    expect(onsetCalled, equals(0));
  }
}

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
  });

  test('prepareForUpdates sets up field correctly (1)', () {
    var t = PrepareForUpdatesSetup();
    t.field.value = t.text;
    t.verifyOnsetCalled1();
  });

  test('prepareForUpdates sets up descendant primitives correctly', () {
    var t = PrepareForUpdatesSetup();
    t.field.value = t.text;
    t.text.content = 'updated';
    t.verifyOnsetCalled2();
  });

  test('when unpreparing for updates, it unprepares its primitive properly',
      () {
    var t = PrepareForUpdatesSetup();
    t.field.unprepareForUpdates();
    t.field.value = t.text;
    t.verifyOnsetNotCalled();
  });

  test('assignment unprepares previous primitive', () {
    var t = PrepareForUpdatesSetup();
    t.field.value = t.otherText;
    expect(t.text.notPreparedYet, isTrue);
  });

  test('ingest unprepares previous primitive', () {
    var t = PrepareForUpdatesSetup();
    var update = {CborString('Content'): CborString('new stuff')};
    t.field.ingestFullCborValue(CborMap(update));
    expect(t.text.notPreparedYet, isTrue);
  });
}
