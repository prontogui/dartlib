// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';
import 'primitive.dart';
import 'fkey.dart';
import 'pkey.dart';
import 'field_hooks.dart';
import 'primitive_factory.dart';

/// A field that holds a uniform two-dimensional array of primitives.
class Any2DField extends FieldBase implements Field {
  /// Create with an empty array.
  Any2DField()
      : _pa = List<List<Primitive>>.unmodifiable([]),
        _columnCount = 0;

  /// Create a new field from a list of rows.  The number of columns in each row
  /// must be the same.  If not, an exception is thrown.
  Any2DField.from(List<List<Primitive>> pa) {
    var colCount = _verifyUniformNumColumns(pa);
    if (colCount == null) {
      throw Exception('number of columns in each row must be the same');
    }
    _columnCount = colCount;

    // Create new lists from supplied list.  New lists are unmodifiable.
    _pa = List<List<Primitive>>.unmodifiable(
        List<List<Primitive>>.generate(pa.length, (i) {
      return List<Primitive>.unmodifiable(pa[i]);
    }));
  }

  /// Storage of this field's value.  Note:  all lists are created as unmodifiable.
  late List<List<Primitive>> _pa;

  /// Storage of number fo columns.
  late int _columnCount;

  /// The number of rows in the 2D array.
  int get rowCount {
    return _pa.length;
  }

  /// The number of columns in the 2D array.
  int get columnCount {
    return _columnCount;
  }

  /// Inserts a new row in the array before the index specified.  If index is negative or
  /// extends beyond the number of rows in the table, then row is appended at the
  /// end of the table.  The row must match the dimension and cell types of the
  /// original array, otherwise an exception is thrown.
  void insertRow(int index, List<Primitive> row) {
    if (row.length != _columnCount) {
      throw Exception('number of columns in row does not match existing');
    }

    if (index < 0 || index > _pa.length) {
      index = _pa.length;
    }

    // Create new list from supplied list.  New list is unmodifiable.
    var newRow = List<Primitive>.unmodifiable(row);

    // Insert the new row into the list of rows
    var newpa = List<List<Primitive>>.unmodifiable(
        List<List<Primitive>>.from(_pa)..insert(index, newRow));

    _unprepareDescendantsForUpdates();
    _pa = newpa;
    _prepareDescendantsForUpdates();

    onSet();
  }

  /// Deletes a row in the array at the given index.  An exception is thrown
  /// if the index is out of range.
  void deleteRow(int index) {
    if (index < 0 || index >= _pa.length) {
      throw Exception('index out of range');
    }

    // Remove the row from the list of rows
    var newpa = List<List<Primitive>>.unmodifiable(
        List<List<Primitive>>.from(_pa)..removeAt(index));

    _unprepareDescendantsForUpdates();
    _pa = newpa;
    _prepareDescendantsForUpdates();

    onSet();
  }

  /// The value of this field.  When setting the value, a copy of the input
  /// list is made.  When getting the value, a copy of the internal list is
  /// returned.
  List<List<Primitive>> get value {
    return _pa;
  }

  set value(List<List<Primitive>> pa) {
    var columnCount = _verifyUniformNumColumns(pa);
    if (columnCount == null) {
      throw Exception('number of columns in each row must be the same');
    }

    // Create new lists from supplied list.  New lists are unmodifiable.
    var newpa = List<List<Primitive>>.unmodifiable(
        List<List<Primitive>>.generate(pa.length, (i) {
      return List<Primitive>.unmodifiable(pa[i]);
    }));

    _unprepareDescendantsForUpdates();
    _pa = newpa;
    _columnCount = columnCount;
    _prepareDescendantsForUpdates();

    onSet();
  }

  // Implement Field interface

  // Override the default implementation to prepare the descendant primitives.
  @override
  bool prepareForUpdates(
      FKey fkey, PKey pkey, int fieldPKeyIndex, FieldHooks fieldHooks) {
    super.prepareForUpdates(fkey, pkey, fieldPKeyIndex, fieldHooks);

    _prepareDescendantsForUpdates();
    return true;
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
        innerList[j].prepareForUpdates(innerPKey, fieldHooks!);
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
    _ingest(value);
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    _ingest(value);
    onIngest();
  }

  void _ingest(CborValue value) {
    if (value is! CborList) {
      throw Exception(
          'Any2DField:ingestFullCborValue - value is not a CborList');
    }

    var fieldPKey = PKey.fromPKey(pkey, fieldPKeyIndex);

    int? newColumnCount;

    // Generate a list of rows from the cbor value...
    var newpa = List<List<Primitive>>.generate(value.length, (i) {
      var outerCbor = value.elementAt(i);

      if (outerCbor is! CborList) {
        throw Exception('element is not a CborList');
      }

      var outerPKey = PKey.fromPKey(fieldPKey, i);

      if (newColumnCount == null) {
        // Record the number of columns in the first row.
        newColumnCount = outerCbor.length;
      } else if (newColumnCount != outerCbor.length) {
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
    _unprepareDescendantsForUpdates();
    _pa = List<List<Primitive>>.unmodifiable(newpa);
    _columnCount = newColumnCount ?? 0;
    _prepareDescendantsForUpdates();
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
    var gatheredTypes = List<String>.generate(_columnCount, (index) => '');

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

    return 'Array [${numRows}x$_columnCount  primitives], column types: ${gatheredTypes.join(', ')}';
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
