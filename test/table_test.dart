import 'package:test/test.dart';
import 'package:dartlib/src/table.dart';
import 'package:dartlib/src/text.dart';

void main() {
  group('Table', () {
    test('initial values are set correctly', () {
      var table = Table(
        headings: ['Column1', 'Column2'],
        rows: [
          [Text(), Text()],
          [Text(), Text()]
        ],
        status: 1,
      );

      expect(table.headings, ['Column1', 'Column2']);
      expect(table.rows.length, 2);
      expect(table.status, 1);
    });

    test('insertRow inserts a row at the correct index', () {
      var table = Table(
        headings: ['Column1', 'Column2'],
        rows: [
          [Text(), Text()],
          [Text(), Text()]
        ],
      );

      var newRow = [Text(), Text()];
      table.insertRow(1, newRow);

      expect(table.rows.length, 3);
      expect(table.rows[1], newRow);
    });

    test('deleteRow deletes a row at the correct index', () {
      var table = Table(
        headings: ['Column1', 'Column2'],
        rows: [
          [Text(), Text()],
          [Text(), Text()]
        ],
      );

      table.deleteRow(0);

      expect(table.rows.length, 1);
    });

    test('deleteAllRows deletes all rows', () {
      var table = Table(
        headings: ['Column1', 'Column2'],
        rows: [
          [Text(), Text()],
          [Text(), Text()]
        ],
      );

      table.deleteAllRows();

      expect(table.rows.length, 0);
    });

    test('rowCount returns the correct number of rows', () {
      var table = Table(
        headings: ['Column1', 'Column2'],
        rows: [
          [Text(), Text()],
          [Text(), Text()]
        ],
      );

      expect(table.rowCount(), 2);
    });

    test('status can be updated', () {
      var table = Table(
        headings: ['Column1', 'Column2'],
        rows: [
          [Text(), Text()],
          [Text(), Text()]
        ],
        status: 0,
      );

      table.status = 2;

      expect(table.status, 2);
    });
  });
}
