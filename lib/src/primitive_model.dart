// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'pkey.dart';
import 'fkey.dart';
import 'primitive.dart';
import 'primitive_factory.dart';
import 'primitive_model_watcher.dart';
import 'primitive_locator.dart';
import 'field_hooks.dart';

class PrimitiveModel implements PrimitiveLocator, FieldHooks {
  List<Primitive> _topPrimitives = [];
  final List<PrimitiveModelWatcher> _watchers = [];

  /// The list of objects watching this model.
  List<PrimitiveModelWatcher> get watchers =>
      List<PrimitiveModelWatcher>.unmodifiable(_watchers);

  /// Returns true if the model is empty.
  bool get isEmpty {
    return _topPrimitives.isEmpty;
  }

  /// List of top-level primitives comprising the GUI.
  List<Primitive> get topPrimitives {
    return _topPrimitives;
  }

  set topPrimitives(List<Primitive> primitives) {
    _topPrimitives = primitives;

    _prepareForUpdates();

    onFullModelUpdate();
  }

  void addWatcher(PrimitiveModelWatcher watcher) {
    // Already in the list of watchers?
    for (var w in _watchers) {
      if (w == watcher) {
        return;
      }
    }
    _watchers.add(watcher);
  }

  void removeWatcher(PrimitiveModelWatcher watcher) {
    _watchers.remove(watcher);
  }

  void onFullModelUpdate() {
    for (var w in _watchers) {
      w.onFullModelUpdate();
    }
  }

  void onBeginPartialModelUpdate() {
    for (var w in _watchers) {
      w.onBeginPartialModelUpdate();
    }
  }

  void onPartialModelUpdate() {
    for (var w in _watchers) {
      w.onPartialModelUpdate();
    }
  }

  void onTopLevelPrimitiveUpdate() {
    for (var w in _watchers) {
      w.onTopLevelPrimitiveUpdate();
    }
  }

  void _prepareForUpdates() {
    var i = 0;
    for (var p in _topPrimitives) {
      p.prepareForUpdates(PKey(i), this);
      i++;
    }
  }

  @override
  Primitive? locatePrimitive(PKey pkey) {
    var locator = PKeyLocator(pkey);

    Primitive? next = topPrimitives[locator.nextIndex()];

    while (!locator.located()) {
      next = next!.locateNextDescendant(locator);
    }

    return next;
  }

  @override
  DateTime getEventTimestamp() {
    return DateTime.now();
  }

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural) {
    for (var w in _watchers) {
      w.onSetField(pkey, fkey, structural);
    }
  }

  void ingestCborUpdate(CborValue v) {
    assert(v is CborList);

    var l = v as CborList;

    var fullUpdate = l.elementAt(0) as CborBool;
    var updateList = l.sublist(1);

    if (fullUpdate.value) {
      _ingestFullUpdate(updateList);
    } else {
      _ingestPartialUpdate(updateList);
    }
  }

  CborMap egestCborUpdate(bool fullUpdate, List<FKey> fkeys) {
    return CborMap({});
  }

  /// Ingests a full update from a list of CBOR values and notifies listeners.
  ///
  /// This method is used internally by the class.
  void _ingestFullUpdate(List<CborValue> l) {
    final numPrimitives = l.length;
    final List<Primitive> newTopPrimitives = [];
    final pkey = PKey();

    for (var i = 0; i < numPrimitives; i++) {
      var cbor = l.elementAt(i);

      if (cbor is! CborMap) {
        throw Exception('element is not a CborMap');
      }

      newTopPrimitives.add(PrimitiveFactory.createPrimitiveFromCborMap(
          PKey.fromPKey(pkey, i), cbor));
    }
    topPrimitives = newTopPrimitives;

    onFullModelUpdate();
  }

  /// Ingests a partial update from a list of CBOR values.  Listeners are notified as each
  /// updated primitive dictates.
  ///
  /// This method is used internally by the class.
  void _ingestPartialUpdate(List<CborValue> l) {
    onBeginPartialModelUpdate();

    final numPrimitives = l.length;
    bool topLevelUpdated = false;

    for (var i = 0; i < numPrimitives; i += 2) {
      var pkey = PKey.fromCbor(l.elementAt(i));
      var cbor = l.elementAt(i + 1);
      if (cbor is! CborMap) {
        throw Exception('element is not a CborMap');
      }

      var p = locatePrimitive(pkey);
      if (p == null) {
        throw Exception('primitive cannot be located');
      }

      p.ingestPartialCborMap(cbor);

      if (!topLevelUpdated) {
        topLevelUpdated = (pkey.indices.length == 1);
      }
    }

    if (topLevelUpdated) {
      onTopLevelPrimitiveUpdate();
    }

    onPartialModelUpdate();
  }
}
