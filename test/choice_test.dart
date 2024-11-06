import 'package:test/test.dart';
import 'package:dartlib/src/choice.dart';
import 'package:dartlib/src/pkey.dart';
import 'test_cbor_samples.dart';

void main() {
  group('Choice', () {
    test('initial values are set correctly', () {
      final choice = Choice(choice: 'Option1', choices: ['Option1', 'Option2']);
      expect(choice.choice, 'Option1');
      expect(choice.choices, ['Option1', 'Option2']);
    });

    test('setting choice updates the value', () {
      final choice = Choice(choice: 'Option1', choices: ['Option1', 'Option2']);
      choice.choice = 'Option2';
      expect(choice.choice, 'Option2');
    });

    test('setting choices updates the list', () {
      final choice = Choice(choice: 'Option1', choices: ['Option1', 'Option2']);
      choice.choices = ['Option3', 'Option4'];
      expect(choice.choices, ['Option3', 'Option4']);
    });

    test('choiceIndex returns correct index', () {
      final choice = Choice(choice: 'Option1', choices: ['Option1', 'Option2']);
      expect(choice.choiceIndex, 0);
      choice.choice = 'Option2';
      expect(choice.choiceIndex, 1);
    });

    test('choiceIndex returns invalid index for invalid choice', () {
      final choice = Choice(choice: 'Option3', choices: ['Option1', 'Option2']);
      expect(choice.choiceIndex, -1);
    });

    test('setting choiceIndex updates the choice', () {
      final choice = Choice(choice: 'Option1', choices: ['Option1', 'Option2']);
      choice.choiceIndex = 1;
      expect(choice.choice, 'Option2');
    });

    test('setting invalid choiceIndex sets choice to empty', () {
      final choice = Choice(choice: 'Option1', choices: ['Option1', 'Option2']);
      choice.choiceIndex = 2;
      expect(choice.choice, '');
    });

    test('toString returns the selected choice', () {
      final choice = Choice(choice: 'Option1', choices: ['Option1', 'Option2']);
      expect(choice.toString(), 'Option1');
    });

    test('isChoiceValid returns true for valid choice', () {
      final choice = Choice(choice: 'Option1', choices: ['Option1', 'Option2']);
      expect(choice.isChoiceValid, isTrue);
    });

    test('isChoiceValid returns false for invalid choice', () {
      final choice = Choice(choice: 'Option3', choices: ['Option1', 'Option2']);
      expect(choice.isChoiceValid, isFalse);
    });

    test('isChoiceValid returns false for empty choice', () {
      final choice = Choice(choice: '', choices: ['Option1', 'Option2']);
      expect(choice.isChoiceValid, isFalse);
    });

    test('all fields are added', () {
      final command = Choice();
      expect(() => command.initializeFromCborMap(PKey(0), cborForChoice()),
          returnsNormally);
    });
  });
}
