// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:cbor/cbor.dart';

CborValue buildSamplePkey() {
  return CborList([
    const CborSmallInt(1),
    const CborSmallInt(5),
    const CborSmallInt(23),
  ]);
}

void main() {
  test('PKey default constructor', () {
    final pkey = PKey(1, 2, 3);
    expect(pkey.indices.length, equals(3));
    expect(pkey.indices[0], equals(1));
    expect(pkey.indices[1], equals(2));
    expect(pkey.indices[2], equals(3));
  });

  test('PKey default constructor', () {
    final pkey = PKey();
    expect(pkey.indices.length, equals(0));
  });

  test('Construct from CBOR.', () {
    final pkey = PKey.fromCbor(buildSamplePkey());
    expect(pkey.indices.length, equals(3));
    expect(pkey.indices[0], equals(1));
    expect(pkey.indices[1], equals(5));
    expect(pkey.indices[2], equals(23));
  });

  test('Construct from empty CBOR list', () {
    final emptyCborList = CborList([]);
    final pkey = PKey.fromCbor(emptyCborList);
    expect(pkey.indices.length, equals(0));
  });

  test('PKey fromIndices constructor', () {
    final indices = [1, 2, 3, 4];
    final pkey = PKey.fromIndices(indices);

    expect(pkey.indices.length, equals(4));
    expect(pkey.indices[0], equals(1));
    expect(pkey.indices[1], equals(2));
    expect(pkey.indices[2], equals(3));
    expect(pkey.indices[3], equals(4));
  });

  test('PKey fromIndicesString constructor', () {
    final pkey = PKey.fromIndicesString('1,2,3,4');

    expect(pkey.indices.length, equals(4));
    expect(pkey.indices[0], equals(1));
    expect(pkey.indices[1], equals(2));
    expect(pkey.indices[2], equals(3));
    expect(pkey.indices[3], equals(4));
  });

  test('PKey fromIndicesString with empty string', () {
    final pkey = PKey.fromIndicesString('');

    expect(pkey.indices.length, equals(0));
  });

  test('PKey fromIndicesString with invalid string', () {
    expect(() => PKey.fromIndicesString('1,2,a,4'), throwsFormatException);
  });

  test('PKey toString method', () {
    final pkey = PKey(1, 2, 3, 4);

    expect(pkey.toString(), equals('[1, 2, 3, 4]'));
  });

  test('PKey toString method with empty PKey', () {
    final pkey = PKey();

    expect(pkey.toString(), equals('[]'));
  });

  test('PKey isEqualTo method', () {
    final pkey1 = PKey(1, 2, 3);
    final pkey2 = PKey(1, 2, 3);
    final pkey3 = PKey(1, 2, 4);

    expect(pkey1.isEqualTo(pkey2), isTrue);
    expect(pkey1.isEqualTo(pkey3), isFalse);
  });

  test('PKey isEqualTo with different lengths', () {
    final pkey1 = PKey(1, 2, 3);
    final pkey2 = PKey(1, 2);

    expect(pkey1.isEqualTo(pkey2), isFalse);
  });

  test('PKeyLocator nextIndex and located', () {
    final pkey = PKey.fromCbor(buildSamplePkey());
    final locator = PKeyLocator(pkey);

    expect(locator.located(), isFalse);
    expect(locator.nextIndex(), equals(1));
    expect(locator.located(), isFalse);
    expect(locator.nextIndex(), equals(5));
    expect(locator.located(), isFalse);
    expect(locator.nextIndex(), equals(23));
    expect(locator.located(), isTrue);
  });

  test('PKey addLevel method', () {
    final pkey = PKey(1, 2, 3);
    final newPkey = PKey.fromPKey(pkey, 4);

    expect(newPkey.indices.length, equals(4));
    expect(newPkey.indices[0], equals(1));
    expect(newPkey.indices[1], equals(2));
    expect(newPkey.indices[2], equals(3));
    expect(newPkey.indices[3], equals(4));
  });

  test('PKey addLevel method (no added level)', () {
    final pkey = PKey(1, 2, 3);
    final newPkey = PKey.fromPKey(pkey);

    expect(newPkey.indices.length, equals(3));
    expect(newPkey.indices[0], equals(1));
    expect(newPkey.indices[1], equals(2));
    expect(newPkey.indices[2], equals(3));
  });

  test('PKey descendsFrom method', () {
    final pkey1 = PKey(1, 2, 3);
    final pkey2 = PKey(1, 2);
    final pkey3 = PKey(1, 2, 3, 4);
    final pkey4 = PKey(2, 3);

    expect(pkey1.descendsFrom(pkey2), isTrue);
    expect(pkey3.descendsFrom(pkey1), isTrue);
    expect(pkey2.descendsFrom(pkey1), isFalse);
    expect(pkey1.descendsFrom(pkey3), isFalse);
    expect(pkey1.descendsFrom(pkey4), isFalse);
  });

  test('PKey indexAtLevel method', () {
    final pkey = PKey(1, 2, 3, 4);

    expect(pkey.indexAtLevel(0), equals(1));
    expect(pkey.indexAtLevel(1), equals(2));
    expect(pkey.indexAtLevel(2), equals(3));
    expect(pkey.indexAtLevel(3), equals(4));
    expect(pkey.indexAtLevel(4), equals(invalidIndex));
    expect(pkey.indexAtLevel(-1), equals(invalidIndex));
  });

  test('PKey length getter', () {
    final pkey = PKey(1, 2, 3, 4);

    expect(pkey.length, equals(4));
  });

  test('PKey length getter with empty PKey', () {
    final pkey = PKey();

    expect(pkey.length, equals(0));
  });

  test('PKeyLocator with empty PKey', () {
    final pkey = PKey();
    final locator = PKeyLocator(pkey);

    expect(locator.located(), isTrue);
  });

  test('PKey isEmpty getter', () {
    final pkey1 = PKey(1, 2, 3);
    expect(pkey1.isEmpty, isFalse);
  });

  test('PKeyLocator with single index', () {
    final pkey = PKey(1);
    final locator = PKeyLocator(pkey);

    expect(locator.located(), isFalse);
    expect(locator.nextIndex(), equals(1));
    expect(locator.located(), isTrue);
  });

  test('PKeyLocator nextIndex throws exception when at last level', () {
    final pkey = PKey(1);
    final locator = PKeyLocator(pkey);

    expect(locator.nextIndex(), equals(1));
    expect(() => locator.nextIndex(), throwsException);
  });
}
