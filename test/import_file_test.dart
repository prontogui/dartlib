import 'package:test/test.dart';
import 'package:dartlib/src/import_file.dart';

void main() {
  group('ImportFile', () {
    test('initial values are correct', () {
      final importFile = ImportFile();

      expect(importFile.imported, isFalse);
      expect(importFile.data, isEmpty);
      expect(importFile.name, isEmpty);
      expect(importFile.validExtensions, isEmpty);
    });

    test('importData sets data, name, and imported flag', () {
      final importFile = ImportFile();
      final data = [1, 2, 3];
      final name = 'test.txt';

      importFile.importData(data, name);

      expect(importFile.data, data);
      expect(importFile.name, name);
      expect(importFile.imported, isTrue);
    });

    test('reset clears data and imported flag', () {
      final importFile = ImportFile();
      final data = [1, 2, 3];
      final name = 'test.txt';

      importFile.importData(data, name);
      importFile.reset();

      expect(importFile.data, isEmpty);
      expect(importFile.imported, isFalse);
    });

    test('setters and getters work correctly', () {
      final importFile = ImportFile();
      final data = [4, 5, 6];
      final name = 'example.txt';
      final validExtensions = ['txt', 'md'];

      importFile.data = data;
      importFile.name = name;
      importFile.validExtensions = validExtensions;
      importFile.imported = true;

      expect(importFile.data, data);
      expect(importFile.name, name);
      expect(importFile.validExtensions, validExtensions);
      expect(importFile.imported, isTrue);
    });
  });
}
