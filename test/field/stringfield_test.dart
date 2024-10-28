import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/string_field.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/pkey.dart';

void main() {
  group('StringField', () {
    test('initial value is empty string', () {
      var field = StringField();
      expect(field.get(), equals(''));
    });

    test('set and get value', () {
      var field = StringField();
      field.set('test');
      expect(field.get(), equals('test'));
    });

    test('prepareForUpdates returns false', () {
      var field = StringField();
      var result = field.prepareForUpdates(
          0, PKey(), 0, (PKey pkey, FKey fkey, bool tf) {});
      expect(result, isFalse);
    });

    test('ingestCborValue with valid CborString', () {
      var field = StringField();
      var cborValue = CborString('test');
      var result = field.ingestCborValue(cborValue);
      expect(result, isTrue);
      expect(field.get(), equals('test'));
    });

    test('ingestCborValue with invalid CborValue', () {
      var field = StringField();
      var cborValue = CborSmallInt(123);
      var result = field.ingestCborValue(cborValue);
      expect(result, isFalse);
      expect(field.get(), equals(''));
    });

    test('egestCborValue returns CborString', () {
      var field = StringField();
      field.set('test');
      var cborValue = field.egestCborValue();
      expect(cborValue, isA<CborString>());
      expect((cborValue as CborString).toString(), equals('test'));
    });
  });
}
