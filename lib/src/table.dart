// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import "pkey.dart";
import 'primitive_base.dart';
import 'strings1d_field.dart';
import 'any1d_field.dart';
import 'any2d_field.dart';
import 'integer_field.dart';
import 'primitive.dart';

/// A table displays an array of primitives in a grid of rows and columns.
class Table extends PrimitiveBase {
  Table({
    super.embodiment,
    super.tag,
    List<String> headings = const [],
    List<Primitive> modelRow = const [],
    List<List<Primitive>> rows = const [],
    int status = 0,
  }) {
    _headings = Strings1DField.from(headings);
    _modelRow = Any1DField.from(modelRow);
    _rows = Any2DField.from(rows);
    _status = IntegerField.from(status);
  }

  // Field storage
  late Strings1DField _headings;
  late Any1DField _modelRow;
  late Any2DField _rows;
  late IntegerField _status;

  @override
  String get describeType => 'Table';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    // IMPORTANT: list fields in alphabetical order!
    fieldRefs.add(FieldRef(fkeyHeadings, _headings));
    fieldRefs.add(FieldRef(fkeyModelRow, _modelRow));
    fieldRefs.add(FieldRef(fkeyRows, _rows));
    fieldRefs.add(FieldRef(fkeyStatus, _status));
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    switch (nextIndex) {
      case 0:
        var colIndex = locator.nextIndex();
        return modelRow[colIndex];
      case 1:
        var rowIndex = locator.nextIndex();
        var colIndex = locator.nextIndex();

        // The next index thereafter specifies which primitive to access...
        return rows[rowIndex][colIndex];
      default:
        throw Exception('PKey locator is out of bounds');
    }
  }

  @override
  String toString() {
    return "";
  }

  /// The headings to use for each column in the table.
  List<String> get headings => _headings.value;
  set headings(List<String> headings) => _headings.value = headings;

  /// The model row of primitives to show for each column.
  List<Primitive> get modelRow => _modelRow.value;
  set modelRow(List<Primitive> modelRow) => _modelRow.value = modelRow;

  /// The dynamically populated 2D (rows, cols) collection of primitives that appear in the table.
  List<List<Primitive>> get rows => _rows.value;
  set rows(List<List<Primitive>> rows) => _rows.value = rows;

  /// The status of the table:  0 = Table Normal, 1 = Table Disabled, 2 = Table Hidden.
  int get status => _status.value;
  set status(int status) => _status.value = status;

  /// The dynamically populated 2D (rows, cols) collection of primitives that appear in the table.
  List<List<Primitive>> get rowPrototype => _rows.value;
  set rowPrototype(List<List<Primitive>> rows) => _rows.value = rows;

  /// Inserts a new row in this table before the index specified.  If index is -1 or extends beyond the number
  /// of rows in the table then row is appended at the end of the table.
  /// The row must match the dimension and cell types of the template row
  void insertRow(int index, List<Primitive> row) {
    _rows.insertRow(index, row);
  }

  /// Deletes a row in this table at the given index.  An exception is thrown
  /// if the index is out of range.
  void deleteRow(int index) {
    _rows.deleteRow(index);
  }

  /// Deletes all rows in the table.
  void deleteAllRows() {
    _rows.value = [];
  }

  /// Convenience function that returns the number of rows.
  int rowCount() {
    return _rows.rowCount;
  }
}
