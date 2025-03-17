import 'package:test/test.dart';
import 'package:dartlib/src/list.dart';
import 'package:dartlib/src/text.dart';
import 'package:dartlib/src/pkey.dart';

void main() {
  group('ListP', () {
    test('should initialize with default values', () {
      var listP = ListP();
      expect(listP.listItems, isEmpty);
      expect(listP.selectedIndex, 0);
      expect(listP.selectedItem, isNull);
    });

    test('should set and get listItems', () {
      var primitive1 = Text();
      var primitive2 = Text();
      var listP = ListP(listItems: [primitive1, primitive2]);

      expect(listP.listItems, [primitive1, primitive2]);
    });

    test('should set and get selected', () {
      var listP = ListP(selectedIndex: 1);
      expect(listP.selectedIndex, 1);

      listP.selectedIndex = 2;
      expect(listP.selectedIndex, 2);
    });

    test('should return selectedItem correctly', () {
      var primitive1 = Text();
      var primitive2 = Text();
      var listP = ListP(listItems: [primitive1, primitive2], selectedIndex: 1);

      expect(listP.selectedItem, primitive2);

      listP.selectedIndex = 0;
      expect(listP.selectedItem, primitive1);

      listP.selectedIndex = -1;
      expect(listP.selectedItem, isNull);

      listP.selectedIndex = 2;
      expect(listP.selectedItem, isNull);
    });

    test('should throw exception for out of bounds locator', () {
      var listP = ListP();
      final locator = PKeyLocator(PKey(0));
      locator.nextIndex();
      expect(() => listP.locateNextDescendant(locator), throwsException);
    });
  });
}
