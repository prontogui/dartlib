import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/primitive_base.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/field_hooks.dart';

class TestPrimitive extends PrimitiveBase {
  TestPrimitive({super.embodiment, super.tag});

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    // Add test-specific fields here
  }

  @override
  String get describeType => 'TestPrimitive';
}

void main() {
  group('PrimitiveBase Tests', () {
    test('Test embodiment and tag getters and setters', () {
      var primitive =
          TestPrimitive(embodiment: 'initialEmbodiment', tag: 'initialTag');
      expect(primitive.embodiment, 'initialEmbodiment');
      expect(primitive.tag, 'initialTag');

      primitive.embodiment = 'newEmbodiment';
      primitive.tag = 'newTag';
      expect(primitive.embodiment, 'newEmbodiment');
      expect(primitive.tag, 'newTag');
    });

    test('Test initializeFromCborMap', () {
      var primitive = TestPrimitive();
      var pkey = PKey();
      var cborMap = CborMap({
        CborString('Embodiment'): CborString('testEmbodiment'),
        CborString('Tag'): CborString('testTag'),
      });

      primitive.initializeFromCborMap(pkey, cborMap);
      expect(primitive.embodiment, 'testEmbodiment');
      expect(primitive.tag, 'testTag');
    });

    test('Test egestFullCborMap', () {
      var primitive =
          TestPrimitive(embodiment: 'testEmbodiment', tag: 'testTag');
      var cborMap = primitive.egestFullCborMap();

      expect(cborMap[CborString('Embodiment')], CborString('testEmbodiment'));
      expect(cborMap[CborString('Tag')], CborString('testTag'));
    });

    test('Test egestPartialCborMap', () {
      var primitive =
          TestPrimitive(embodiment: 'testEmbodiment', tag: 'testTag');

      primitive.prepareForUpdates(PKey(0), NullFieldHooks());
      primitive.embodiment = 'testEmbodiment update';
      var cborMap = primitive.egestPartialCborMap([fkeyEmbodiment]);

      expect(cborMap.length, 1);
      expect(cborMap[CborString('Embodiment')],
          CborString('testEmbodiment update'));
    });

    test('Test ingestFullCborMap', () {
      var primitive = TestPrimitive();
      var cborMap = CborMap({
        CborString('Embodiment'): CborString('testEmbodiment'),
        CborString('Tag'): CborString('testTag'),
      });

      primitive.ingestFullCborMap(cborMap);
      expect(primitive.embodiment, 'testEmbodiment');
      expect(primitive.tag, 'testTag');
    });

    test('Test ingestPartialCborMap', () {
      var primitive =
          TestPrimitive(embodiment: 'initialEmbodiment', tag: 'initialTag');
      var cborMap = CborMap({
        CborString('Embodiment'): CborString('testEmbodiment'),
      });

      primitive.ingestPartialCborMap(cborMap);
      expect(primitive.embodiment, 'testEmbodiment');
      expect(primitive.tag, 'initialTag');
    });

    test('Test prettyPrint', () {
      var primitive =
          TestPrimitive(embodiment: 'testEmbodiment', tag: 'testTag');
      primitive.prepareForUpdates(PKey(0, 2), NullFieldHooks());
      var prettyString = primitive.prettyPrint();

      expect(prettyString.contains('testEmbodiment'), true);
      expect(prettyString.contains('testTag'), true);
    });
  });
}
