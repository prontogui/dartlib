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
  DateTime _eventTimestamp = DateTime.now();

  /// The list of objects watching this model.
  List<PrimitiveModelWatcher> get watchers =>
      List<PrimitiveModelWatcher>.unmodifiable(_watchers);

  /// Returns true if the model is empty.
  bool get isEmpty {
    return _topPrimitives.isEmpty;
  }

  // List of top-level primitives comprising the GUI.
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

    var nextIndex = locator.nextIndex();
    if (nextIndex >= topPrimitives.length) {
      return null;
    }

    Primitive? next = topPrimitives[nextIndex];

    while (!locator.located()) {
      next = next!.locateNextDescendant(locator);
    }

    return next;
  }

  @override
  DateTime getEventTimestamp() {
    return _eventTimestamp;
  }

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural) {
    for (var w in _watchers) {
      w.onSetField(pkey, fkey, structural);
    }
  }

  @override
  void onIngestField(PKey pkey, FKey fkey, bool structural) {
    for (var w in _watchers) {
      w.onIngestField(pkey, fkey, structural);
    }
  }

  /// Ingests a full or partial update from a CBOR value and notifies listeners.
  Primitive? ingestCborUpdate(CborValue v) {
    assert(v is CborList);

    var l = v as CborList;

    var fullUpdate = l.elementAt(0) as CborBool;
    var updateList = l.sublist(1);

    if (fullUpdate.value) {
      _ingestFullUpdate(updateList);
      return null;
    } else {
      return _ingestPartialUpdate(updateList);
    }
  }

  /// Ingests a partial update from a CBOR value and notifies listeners.
  /// If the update ends up being a full update then an exception is thrown.
  Primitive ingestPartialUpdateOnly(CborValue v) {
    var p = ingestCborUpdate(v);
    if (p == null) {
      throw Exception(
          'A full update was received.  Only a partial update is allowed.');
    }
    return p;
  }

  CborMap egestCborUpdate(bool fullUpdate, List<FKey> fkeys) {
    return CborMap({});
  }

  void updateEventTimestamp() {
    _eventTimestamp = DateTime.now();
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
  Primitive? _ingestPartialUpdate(List<CborValue> l) {
    onBeginPartialModelUpdate();

    final numPrimitives = l.length;
    bool topLevelUpdated = false;
    Primitive? firstUpdatedPrimitive;

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

      firstUpdatedPrimitive ??= p;
    }

    if (topLevelUpdated) {
      onTopLevelPrimitiveUpdate();
    }

    onPartialModelUpdate();

    return firstUpdatedPrimitive;
  }
}
