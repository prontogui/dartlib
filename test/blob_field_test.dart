import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/blob_field.dart';

void main() {
  group('BlobField', () {
    late BlobField blobField;

    setUp(() {
      blobField = BlobField();
    });

    final testData = List<int>.unmodifiable([1, 2, 3, 4]);

    populateField() {
      blobField.value = testData;
    }

    test('initial value is an empty list', () {
      expect(blobField.value, isEmpty);
    });

    test('setting and getting value', () {
      populateField();
      expect(blobField.value, equals(testData));
    });

    test('ingestFullCborValue with valid CborBytes', () {
      final cborValue = CborBytes(testData);
      blobField.ingestFullCborValue(cborValue);
      expect(blobField.value, equals(testData));
    });

    test('ingestFullCborValue with CborNull (empty)', () {
      blobField.ingestFullCborValue(const CborNull());
      expect(blobField.value, equals([]));
    });

    test('ingestFullCborValue with invalid CborValue throws exception', () {
      final cborValue = CborString('invalid');
      expect(() => blobField.ingestFullCborValue(cborValue), throwsException);
    });

    test('ingestPartialCborValue calls ingestFullCborValue', () {
      final cborValue = CborBytes(testData);
      blobField.ingestPartialCborValue(cborValue);
      expect(blobField.value, equals(testData));
    });

    test('egestCborValue returns correct CborBytes', () {
      populateField();
      final cborValue = blobField.egestCborValue();
      expect(cborValue, isA<CborBytes>());
      expect((cborValue as CborBytes).bytes, equals(testData));
    });

    test('toString returns correct format', () {
      blobField.value = [1, 2, 3, 4];
      expect(blobField.toString(), equals('Blob [4 bytes]'));
    });
  });
}
