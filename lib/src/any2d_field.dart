// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';
import 'primitive.dart';
import 'fkey.dart';
import 'pkey.dart';
import 'onset.dart';
import 'primitive_factory.dart';

/// A field that holds a two-dimensional array of primitives.
class Any2DField extends FieldBase implements Field {
  /// Storage of this field's value.
  List<List<Primitive>> _pa = [];

  /// The value of this field.  When setting the value, a copy of the input
  /// list is made.  When getting the value, a copy of the internal list is
  /// returned.
  List<List<Primitive>> get value {
    // Make a copy of the internal lists
    _pa.toList();
  }

  set value(List<List<Primitive>> pa) {
    _unprepareDescendantsForUpdates();
    _pa.replaceRange(0, _pa.length, pa);
    _prepareDescendantsForUpdates();
    onSet();

    // Put some thought into the above
    return true;
  }

  // Implement Field interface

  // Override the default implementation to prepare the descendant primitives.
  @override
  void prepareForUpdates(
      FKey fkey, PKey pkey, int fieldPKeyIndex, OnsetFunction onset) {
    super.prepareForUpdates(fkey, pkey, fieldPKeyIndex, onset);

    _prepareDescendantsForUpdates();
  }

  /// Prepare descendant primitives for updates.
  void _prepareDescendantsForUpdates() {
    // Short circuit for the case where the primitives are being used in freestyle fashion.
    // That is, they are participating in a model yet and hence we aren't trackig updates.
    if (notPreparedYet) {
      return;
    }

    // Prepare each individual descendant primitives for updates

    var fieldPKey = PKey.fromPKey(pkey, fieldPKeyIndex);

    for (var i = 0; i < _pa.length; i++) {
      var outerPKey = PKey.fromPKey(fieldPKey, i);

      var innerList = _pa[i];
      for (var j = 0; j < innerList.length; j++) {
        var innerPKey = PKey.fromPKey(outerPKey, j);

        // Add another level representing the array index of primitive
        innerList[j].prepareForUpdates(innerPKey, onset!);
      }
    }
  }

  void _unprepareDescendantsForUpdates() {
    for (var row in _pa) {
      for (var cell in row) {
        cell.unprepareForUpdates();
      }
    }
  }

  @override
  void ingestFullCborValue(CborValue value) {
    if (value is! CborList) {
      throw Exception('value is not a CborList');
    }

    _unprepareDescendantsForUpdates();

    var fieldPKey = PKey.fromPKey(pkey, fieldPKeyIndex);

    // Generate a list of rows from the cbor value...
    _pa = List<List<Primitive>>.generate(value.length, (i) {
      var cbor = value.elementAt(i);

      if (cbor is! CborList) {
        throw Exception('element is not a CborList');
      }

      var outerPKey = PKey.fromPKey(fieldPKey, i);

      // Generate a list of cells from the cbor value...
      var row = List<Primitive>.generate(cbor.length, (j) {
        var cbor2 = cbor.elementAt(j);

        if (cbor2 is! CborMap) {
          throw Exception('element is not a CborMap');
        }

        var innerPKey = PKey.fromPKey(outerPKey, j);

        return PrimitiveFactory.createPrimitiveFromCborMap(innerPKey, cbor2);
      });

      return row;
    });

    _prepareDescendantsForUpdates();
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    if (value is! CborList) {
      throw Exception('value is not a CborList');
    }

    if (_pa.length != value.length) {
      throw Exception(
          'number of primitives in update does not equal existing primitives');
    }

    // For each existing row...
    for (var i = 0; i < _pa.length; i++) {
      var cbor = value.elementAt(i);

      if (cbor is! CborList) {
        throw Exception('element is not a CborList');
      }

      if (_pa[i].length != cbor.length) {
        throw Exception(
            'number of primitives in update does not equal existing primitives');
      }

      // For each existing cell...
      for (var j = 0; j < _pa[i].length; j++) {
        var cbor2 = cbor.elementAt(j);

        if (cbor2 is! CborMap) {
          throw Exception('element is not a CborMap');
        }

        // Update the existing cell from cbor map
        _pa[i][j].ingestPartialCborMap(cbor2);
      }
    }
  }

  @override
  CborValue egestCborValue() {
    var update = <CborList>[];

    for (var p in _pa) {
      var row = <CborValue>[];

      for (var cell in p) {
        row.add(cell.egestFullCborMap());
      }

      update.add(CborList(row));
    }

    return CborList(update);
  }

  // Object overrides

  @override
  String toString() {
    /*
    return List<String>.generate(_pa.length, (index) => _pa[index].describeType)
        .join(', ');
        */
  }
}
