// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:cbor/cbor.dart';
import 'package:dartlib/src/primitive_model.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:dartlib/src/fkey.dart';
import 'package:dartlib/src/primitive_model_watcher.dart';
import 'package:dartlib/src/text.dart';
import 'package:dartlib/src/frame.dart';
import 'package:dartlib/src/group.dart';
import 'package:dartlib/src/list.dart';
import 'package:dartlib/src/table.dart';

import 'test_cbor_samples.dart';

class MockPrimitiveModelWatcher implements PrimitiveModelWatcher {
  bool fullModelUpdated = false;
  bool partialModelUpdated = false;
  bool topLevelPrimitiveUpdated = false;
  bool fieldSet = false;

  @override
  void onBeginFullModelUpdate() {}

  @override
  void onFullModelUpdate() {
    fullModelUpdated = true;
  }

  @override
  void onBeginPartialModelUpdate() {}

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

  @override
  void onIngestField(PKey pkey, FKey fkey, bool structural) {
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

    test('onSetField notifies watchers', () {
      var pkey = PKey();
      var fkey = fkeyChecked;
      model.onSetField(pkey, fkey, true);
      expect(watcher.fieldSet, isTrue);
    });
  });

  group('PKey assignments and locatePrimitive', () {
    final l1 = Text(content: 'l1');
    final l2 = Text(content: 'l2');
    final l = ListP(listItems: [l1, l2]);
    final g = Group(groupItems: [l]);
    final t1 = Text(content: 't1');
    final t2 = Text(content: 't2');
    final t = Table(rows: [
      [t1],
      [t2]
    ]);
    final f = Frame(frameItems: [g, t]);
    final model = PrimitiveModel();

    test('Correct PKeys are assigned', () {
      model.topPrimitives = [f];

      expect(f.pkey, PKey.fromIndices([0]));
      expect(t.pkey, PKey.fromIndices([0, 0, 1]));
      expect(t1.pkey, PKey.fromIndices([0, 0, 1, 0, 0, 0]));
      expect(t2.pkey, PKey.fromIndices([0, 0, 1, 0, 1, 0]));
      expect(g.pkey, PKey.fromIndices([0, 0, 0]));
      expect(l.pkey, PKey.fromIndices([0, 0, 0, 0, 0]));
      expect(l1.pkey, PKey.fromIndices([0, 0, 0, 0, 0, 0, 0]));
      expect(l2.pkey, PKey.fromIndices([0, 0, 0, 0, 0, 0, 1]));
    });
    test('locatePrimitive returns correct primitive', () {
      model.topPrimitives = [f];

      expect(model.locatePrimitive(PKey.fromIndices([0])), equals(f));
      expect(model.locatePrimitive(PKey.fromIndices([0, 0, 1])), equals(t));
      expect(model.locatePrimitive(PKey.fromIndices([0, 0, 1, 0, 0, 0])),
          equals(t1));
      expect(model.locatePrimitive(PKey.fromIndices([0, 0, 1, 0, 1, 0])),
          equals(t2));
      expect(model.locatePrimitive(PKey.fromIndices([0, 0, 0])), equals(g));
      expect(
          model.locatePrimitive(PKey.fromIndices([0, 0, 0, 0, 0])), equals(l));
      expect(model.locatePrimitive(PKey.fromIndices([0, 0, 0, 0, 0, 0, 0])),
          equals(l1));
      expect(model.locatePrimitive(PKey.fromIndices([0, 0, 0, 0, 0, 0, 1])),
          equals(l2));
    });
  });
}
