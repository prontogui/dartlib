import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:dartlib/src/any1d_field.dart';
import 'package:dartlib/src/text.dart';

void main() {
  group('Any1DField', () {
    late Any1DField field;

    setUp(() {
      field = Any1DField();
    });

    test('initial value is an empty list', () {
      expect(field.value, isEmpty);
    });

    test('setting value updates the internal list', () {
      var primitives = [
        Text(content: 'Original Content 1'),
        Text(content: 'Original Content 2')
      ];
      field.value = primitives;
      expect(field.value, equals(primitives));
    });

    test('prepareForUpdates prepares descendant primitives', () {
      var primitives = [
        Text(content: 'Original Content 1'),
        Text(content: 'Original Content 2')
      ];
      field.value = primitives;
      field.prepareForUpdates(fkeyLabel, PKey(1), 0, (PKey, FKey, bool) {});
      for (var primitive in primitives) {
        expect(primitive.notPreparedYet, isFalse);
      }
    });

    test('assignment prepares descendant primitives', () {
      var primitives = [
        Text(content: 'Original Content 1'),
        Text(content: 'Original Content 2')
      ];
      field.prepareForUpdates(fkeyLabel, PKey(1), 0, (PKey, FKey, bool) {});
      field.value = primitives;
      for (var primitive in primitives) {
        expect(primitive.notPreparedYet, isFalse);
      }
    });

    test('assignment unprepares descendant primitives', () {
      var primitives = [
        Text(content: 'Original Content 1'),
        Text(content: 'Original Content 2')
      ];
      field.prepareForUpdates(fkeyLabel, PKey(1), 0, (PKey, FKey, bool) {});
      field.value = primitives;

      var newPrimitives = [
        Text(content: 'New Content 1'),
      ];
      field.value = newPrimitives;

      for (var primitive in primitives) {
        expect(primitive.notPreparedYet, isTrue);
      }
    });

    test('ingestFullCborValue updates the internal list', () {
      var p1 = Text(content: 'Original Content 1');
      var p2 = Text(content: 'Original Content 2');
      var primitives = [p1, p2];
      field.value = primitives;
      field.prepareForUpdates(fkeyLabel, PKey(1), 0, (PKey, FKey, bool) {});
      var cborList = CborList([
        CborMap({
          CborString('Content'): CborString('new content 1'),
        }),
      ]);
      field.ingestFullCborValue(cborList);
      var newText = field.value[0] as Text;
      expect(newText.content, equals('new content 1'));

      expect(field.value.length, equals(1));
      expect(p1.content, equals('Original Content 1'));
      expect(p1.notPreparedYet, isTrue);
      expect(p2.content, equals('Original Content 2'));
      expect(p2.notPreparedYet, isTrue);
    });

    test('ingestPartialCborValue updates existing primitives', () {
      var p1 = Text(content: 'Original Content 1');
      var p2 = Text(content: 'Original Content 2');
      var primitives = [p1, p2];
      field.value = primitives;
      var cborList = CborList([
        CborMap({
          CborString('Content'): CborString('new content 1'),
        }),
        CborMap({
          CborString('Content'): CborString('new content 2'),
        }),
      ]);
      field.ingestPartialCborValue(cborList);
      expect(p1.content, equals('new content 1'));
      expect(p2.content, equals('new content 2'));
    });

    test('egestCborValue returns the correct CborList', () {
      var p1 = Text(content: 'Original Content 1');
      var p2 = Text(content: 'Original Content 2');
      var primitives = [p1, p2];
      field.value = primitives;
      var cborValue = field.egestCborValue();
      expect(cborValue, isA<CborList>());
      expect((cborValue as CborList).length, equals(2));
    });

    test('toString returns a comma-separated list of primitive types', () {
      var p1 = Text(content: 'Original Content 1');
      var p2 = Text(content: 'Original Content 2');
      var primitives = [p1, p2];
      field.value = primitives;
      expect(field.toString(), equals('Text, Text'));
    });
  });
}
