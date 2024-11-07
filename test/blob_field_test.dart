import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/blob_field.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/pkey.dart';
import 'field_hooks_mock.dart';

void main() {
  group('BlobField', () {
    late BlobField field;
    late FieldHooksMock fieldhooks;

    setUp(() {
      field = BlobField();
      fieldhooks = FieldHooksMock();
    });

    final testData1 = List<int>.unmodifiable([1, 2, 3, 4]);
    final testData2 = List<int>.unmodifiable([3, 4]);

    populateField() {
      field.value = testData1;
    }

    prepareForUpdates() {
      field.prepareForUpdates(fkeyData, PKey(0), 2, fieldhooks);
    }

    test('initial value is an empty list', () {
      expect(field.value, isEmpty);
    });

    test('setting and getting value', () {
      prepareForUpdates();
      populateField();
      expect(field.value, equals(testData1));
      fieldhooks.verifyOnsetCalled(1);
    });

    test('ingestFullCborValue with valid CborBytes', () {
      prepareForUpdates();
      final cborValue = CborBytes(testData1);
      field.ingestFullCborValue(cborValue);
      expect(field.value, equals(testData1));
      fieldhooks.verifyOnsetCalled(0);
    });

    test('ingestFullCborValue with CborNull (empty)', () {
      field.ingestFullCborValue(const CborNull());
      expect(field.value, equals([]));
    });

    test('ingestFullCborValue with invalid CborValue throws exception', () {
      final cborValue = CborString('invalid');
      expect(() => field.ingestFullCborValue(cborValue), throwsException);
    });

    test('ingestPartialCborValue calls ingestFullCborValue', () {
      populateField();
      prepareForUpdates();
      final cborValue = CborBytes(testData2);
      field.ingestPartialCborValue(cborValue);
      expect(field.value, equals(testData2));
      fieldhooks.verifyOnsetCalled(1);
    });

    test('egestCborValue returns correct CborBytes', () {
      populateField();
      final cborValue = field.egestCborValue();
      expect(cborValue, isA<CborBytes>());
      expect((cborValue as CborBytes).bytes, equals(testData1));
    });

    test('toString returns correct format', () {
      field.value = [1, 2, 3, 4];
      expect(field.toString(), equals('Blob [4 bytes]'));
    });
  });
}
