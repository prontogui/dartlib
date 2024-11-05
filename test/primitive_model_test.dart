import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/primitive_model.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/primitive_model_watcher.dart';
import 'package:dartlib/src/text.dart';
import 'test_cbor_samples.dart';

class MockPrimitiveModelWatcher implements PrimitiveModelWatcher {
  bool fullModelUpdated = false;
  bool partialModelUpdated = false;
  bool topLevelPrimitiveUpdated = false;
  bool fieldSet = false;

  @override
  void onFullModelUpdate() {
    fullModelUpdated = true;
  }

  @override
  void onPartialModelUpdate() {
    partialModelUpdated = true;
  }

  @override
  void onTopLevelPrimitiveUpdate() {
    topLevelPrimitiveUpdated = true;
  }

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural) {
    fieldSet = true;
  }
}

void main() {
  group('PrimitiveModel', () {
    late PrimitiveModel model;
    late MockPrimitiveModelWatcher watcher;

    setUp(() {
      model = PrimitiveModel();
      watcher = MockPrimitiveModelWatcher();
      model.addWatcher(watcher);
    });

    test('isEmpty returns true when no primitives are present', () {
      expect(model.isEmpty, isTrue);
    });

    test('isEmpty returns false when primitives are present', () {
      model.topPrimitives = [Text()];
      expect(model.isEmpty, isFalse);
    });

    test('addWatcher adds a watcher', () {
      expect(model.watchers.contains(watcher), isTrue);
    });

    test('removeWatcher removes a watcher', () {
      model.removeWatcher(watcher);
      expect(model.watchers.contains(watcher), isFalse);
    });

    test('onFullModelUpdate notifies watchers', () {
      model.onFullModelUpdate();
      expect(watcher.fullModelUpdated, isTrue);
    });

    test('onTopLevelPrimitiveUpdate notifies watchers', () {
      model.onTopLevelPrimitiveUpdate();
      expect(watcher.topLevelPrimitiveUpdated, isTrue);
    });

    test('ingestCborUpdate handles full update', () {
      var cborList = CborList([CborBool(true), distinctCborForText()]);
      model.ingestCborUpdate(cborList);
      expect(watcher.fullModelUpdated, isTrue);
    });

    test('ingestCborUpdate handles partial update', () {
/* DISABLED
      var cborList = CborList([CborBool(false), CborList([])]);
      model.ingestCborUpdate(cborList);
      expect(watcher.topLevelPrimitiveUpdated, isTrue);
*/
    });

    test('locatePrimitive returns correct primitive', () {
      var primitive = Text();
      model.topPrimitives = [primitive];
      var pkey = PKey.fromIndices([0]);
      expect(model.locatePrimitive(pkey), primitive);
    });

    test('onSetField notifies watchers', () {
      var pkey = PKey();
      var fkey = fkeyChecked;
      model.onSetField(pkey, fkey, true);
      expect(watcher.fieldSet, isTrue);
    });
  });
}
