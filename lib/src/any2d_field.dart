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

/// A field that holds a uniform two-dimensional array of primitives.
class Any2DField extends FieldBase implements Field {
  /// Storage of this field's value.  Note:  all lists are created as unmodifiable.
  List<List<Primitive>> _pa = List<List<Primitive>>.unmodifiable([]);

  /// Storage of number fo columns.
  int _numColumns = 0;

  /// The value of this field.  When setting the value, a copy of the input
  /// list is made.  When getting the value, a copy of the internal list is
  /// returned.
  List<List<Primitive>> get value {
    return _pa;
  }

  /// The number of rows in the 2D array.
  int get numRows {
    return _pa.length;
  }

  /// The number of columns in the 2D array.
  int get numColumns {
    return _numColumns;
  }

  set value(List<List<Primitive>> pa) {
    _unprepareDescendantsForUpdates();

    var numColumns = _verifyUniformNumColumns(pa);
    if (numColumns == null) {
      throw Exception('number of columns in each row must be the same');
    }

    // Create new lists from supplied list.  New lists are unmodifiable.
    _pa = List<List<Primitive>>.unmodifiable(
        List<List<Primitive>>.generate(pa.length, (i) {
      return List<Primitive>.unmodifiable(pa[i]);
    }));

    _numColumns = numColumns;

    _prepareDescendantsForUpdates();

    onSet();
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

    int? numColumns;

    // Generate a list of rows from the cbor value...
    var newRows = List<List<Primitive>>.generate(value.length, (i) {
      var outerCbor = value.elementAt(i);

      if (outerCbor is! CborList) {
        throw Exception('element is not a CborList');
      }

      var outerPKey = PKey.fromPKey(fieldPKey, i);

      if (numColumns == null) {
        // Record the number of columns in the first row.
        numColumns = outerCbor.length;
      } else if (numColumns != outerCbor.length) {
        // Enforce that the number of columns in each row is the same.
        throw Exception('number of columns in each row must be the same');
      }

      // Generate a list of cells from the cbor value...
      var row = List<Primitive>.generate(outerCbor.length, (j) {
        var innerCbor = outerCbor.elementAt(j);

        if (innerCbor is! CborMap) {
          throw Exception('element is not a CborMap');
        }

        var innerPKey = PKey.fromPKey(outerPKey, j);

        return PrimitiveFactory.createPrimitiveFromCborMap(
            innerPKey, innerCbor);
      });

      return List<Primitive>.unmodifiable(row);
    });

    // Save the new list of rows and number of columns
    _pa = List<List<Primitive>>.unmodifiable(newRows);
    _numColumns = numColumns == null ? 0 : numColumns!;

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

    // Make sure the number of columns in each row is the same and matches
    // the number of columns in the existing 2D array.

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
    var numRows = _pa.length;

    if (numRows == 0) {
      return '<Empty>';
    }

    // Gather some information about the columns in 2D array
    var gatheredTypes = List<String>.generate(_numColumns, (index) => '');

    for (var row in _pa) {
      for (var i = 0; i < row.length; i++) {
        var gatheredType = gatheredTypes[i];

        if (gatheredType.isEmpty) {
          gatheredTypes[i] = row[i].describeType;
        } else {
          gatheredTypes[i] == row[i].describeType
              ? gatheredTypes[i]
              : '<mixed>';
        }
      }
    }

    return 'Array [${numRows}x$_numColumns  primitives], column types: ${gatheredTypes.join(', ')}';
  }

  int? _verifyUniformNumColumns(List<List<Primitive>> pa) {
    int? numColumns;

    for (var row in pa) {
      if (numColumns == null) {
        numColumns = row.length;
      } else if (numColumns != row.length) {
        return null;
      }
    }

    return numColumns ?? 0;
  }
}
