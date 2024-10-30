import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/strings1d_field.dart';

void main() {
  group('Strings1DField', () {
    test('initial value is empty', () {
      final field = Strings1DField();
      expect(field.value, isEmpty);
    });

    test('set and get value', () {
      final field = Strings1DField();
      final testValue = ['hello', 'world'];
      field.value = testValue;
      expect(field.value, equals(testValue));
    });

    test('set makes a copy of value', () {
      final field = Strings1DField();
      final testValue = ['hello', 'world'];
      field.value = testValue;

      // Modify testValue.  This should not affect field.value.
      testValue.clear();

      expect(field.value, equals(['hello', 'world']));
    });

    test('get returns a copy of value', () {
      final field = Strings1DField();
      final testValue = ['hello', 'world'];
      field.value = testValue;

      // Modify field.value.  This should not affect testValue.
      field.value.clear();

      expect(field.value, equals(['hello', 'world']));
    });

    test('ingestFullCborValue with valid CborList', () {
      final field = Strings1DField();
      final cborList = CborList([CborString('hello'), CborString('world')]);
      field.ingestFullCborValue(cborList);
      expect(field.value, equals(['hello', 'world']));
    });

    test('ingestFullCborValue with invalid CborList throws exception', () {
      final field = Strings1DField();
      final cborList = CborList([CborString('hello'), CborSmallInt(42)]);
      expect(() => field.ingestFullCborValue(cborList), throwsException);
    });

    test('ingestPartialCborValue with valid CborList', () {
      final field = Strings1DField();
      final cborList = CborList([CborString('hello'), CborString('world')]);
      field.ingestPartialCborValue(cborList);
      expect(field.value, equals(['hello', 'world']));
    });

    test('ingestPartialCborValue with invalid CborList throws exception', () {
      final field = Strings1DField();
      final cborList = CborList([CborString('hello'), CborSmallInt(42)]);
      expect(() => field.ingestPartialCborValue(cborList), throwsException);
    });

    test('egestCborValue returns correct CborList', () {
      final field = Strings1DField();
      field.value = ['hello', 'world'];
      final cborValue = field.egestCborValue();
      expect(cborValue, isA<CborList>());
      expect((cborValue as CborList).toList(),
          equals([CborString('hello'), CborString('world')]));
    });

    test('toString returns correct string representation', () {
      final field = Strings1DField();
      field.value = ['hello', 'world'];
      expect(field.toString(), equals('"hello", "world"'));
    });
  });
}
