// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'package:dartlib/key/pkey.dart';
import 'package:dartlib/key/fkey.dart';
import 'primitive.dart';
import 'primitive_factory.dart';
import 'primitive_model_watcher.dart';

class PrimitiveModel {
  List<Primitive> _topPrimitives = [];
  final List<PrimitiveModelWatcher> _watchers = [];

  /// Returns true i-if the model is empty.0
  bool get isEmpty {
    return _topPrimitives.isEmpty;
  }

  /// Gets a list of top-level primitives comprising the GUI.
  List<Primitive> get topPrimitives {
    return _topPrimitives;
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

  void onFullModelUpdate() {
    for (var w in _watchers) {
      w.onFullModelUpdate();
    }
  }

  void onTopLevelPrimitiveUpdate() {
    for (var w in _watchers) {
      w.onTopLevelPrimitiveUpdate();
    }
  }

  void onSetField(PKey pkey, FKey fkey, bool structural) {
    for (var w in _watchers) {
      w.onSetField(pkey, fkey, structural);
    }
  }

  void prepareForUpdates() {
    var emptyPKey = PKey();
    for (var p in _topPrimitives) {
      p.prepareForUpdates(emptyPKey, onSetField);
    }
  }

  Primitive? locatePrimitive(PKey pkey) {
    PKeyLocator locator = PKeyLocator(pkey);
    for (var p in _topPrimitives) {
      var found = p.locateNextDescendant(locator);
      if (found != null) {
        return found;
      }
    }
    return null;
  }

  bool ingestCborUpdate(CborValue v) {
    assert(v is CborList);

    var l = v as CborList;

    var fullUpdate = l.elementAt(0) as CborBool;
    var updateList = l.sublist(1);

    if (fullUpdate.value) {
      return _ingestFullUpdate(updateList);
    } else {
      return _ingestPartialUpdate(updateList);
    }
  }

  CborMap egestCborUpdate(bool fullUpdate, List<FKey> fkeys) {
    return CborMap({});
  }

  /// Ingests a full update from a list of CBOR values and notifies listeners.
  ///
  /// This method is used internally by the class.
  bool _ingestFullUpdate(List<CborValue> l) {
    final numPrimitives = l.length;
    final List<Primitive> newTopPrimitives = [];
    final pkey = PKey();

    for (var i = 0; i < numPrimitives; i++) {
      var cbor = l.elementAt(i) as CborMap;

      var newPrimitive = PrimitiveFactory.createPrimitiveFromCborMap(
          PKey.fromPKey(pkey, i), cbor);

      assert(newPrimitive != null);

      newTopPrimitives.add(newPrimitive!);
    }
    _topPrimitives = newTopPrimitives;

    onFullModelUpdate();

    return true;
  }

  /// Ingests a partial update from a list of CBOR values.  Listeners are notified as each
  /// updated primitive dictates.
  ///
  /// This method is used internally by the class.
  bool _ingestPartialUpdate(List<CborValue> l) {
    final numPrimitives = l.length;
    bool topLevelUpdated = false;

    for (var i = 0; i < numPrimitives; i += 2) {
      var pkey = PKey.fromCbor(l.elementAt(i));
      var cbor = l.elementAt(i + 1) as CborMap;
      if (cbor == null) {
        // TODO:  log an error
        return false;
      }

      var p = locatePrimitive(pkey);
      if (p == null) {
        // TODO:  log an error
        return false;
      }

      p.ingestCborMap(cbor);

      if (!topLevelUpdated) {
        topLevelUpdated = (pkey.indices.length == 1);
      }
    }

    if (topLevelUpdated) {
      onTopLevelPrimitiveUpdate();
    }

    return true;
  }
}
