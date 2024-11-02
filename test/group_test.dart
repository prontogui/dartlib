import 'package:test/test.dart';
import 'package:dartlib/src/group.dart';
import 'package:dartlib/src/text.dart';
import 'package:dartlib/src/pkey.dart';

void main() {
  group('Group', () {
    test('should initialize with default values', () {
      var group = Group();
      expect(group.groupItems, isEmpty);
      expect(group.describeType, 'Group');
    });

    test('should initialize with provided group items', () {
      var primitive1 = Text();
      var primitive2 = Text();
      var group = Group(groupItems: [primitive1, primitive2]);
      expect(group.groupItems, [primitive1, primitive2]);
    });

    test('should set and get group items', () {
      var primitive1 = Text();
      var primitive2 = Text();
      var group = Group();
      group.groupItems = [primitive1, primitive2];
      expect(group.groupItems, [primitive1, primitive2]);
    });

    test('should locate next descendant correctly', () {
      var primitive1 = Text();
      var primitive2 = Text();
      var group = Group(groupItems: [primitive1, primitive2]);
      var locator = PKeyLocator(PKey(0, 1));
      var descendant = group.locateNextDescendant(locator);
      expect(descendant, primitive2);
    });

    test('should throw exception if locator is out of bounds', () {
      var group = Group();
      var locator = PKeyLocator(PKey(0));
      locator.nextIndex();
      expect(() => group.locateNextDescendant(locator), throwsException);
    });
  });
}
