// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'primitive_base.dart';
import 'string_field.dart';
import 'strings1d_field.dart';

/// A choice is a user selection from a set of choices.  It is often represented using a pull-down list.
class Choice extends PrimitiveBase {
  Choice(
      {super.embodiment,
      super.tag,
      String choice = '',
      List<String> choices = const []}) {
    _choice = StringField.from(choice);
    _choices = Strings1DField.from(choices);
  }

  // Field storage
  late StringField _choice;
  late Strings1DField _choices;

  @override
  String get describeType => 'Choice';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyChoice, _choice));
    fieldRefs.add(FieldRef(fkeyChoices, _choices));
  }

  @override
  String toString() {
    return _choice.value;
  }

  /// the selected choice or empty if none chosen.
  String get choice => _choice.value;
  set choice(String choice) => _choice.value = choice;

  /// the set of valid choices to choose from.
  List<String> get choices => _choices.value;
  set choices(List<String> choices) => _choices.value = choices;

  /// The index (0, 1, ..) of selected choice or -1 if choice is empty.  This is a covenvenience
  /// function as an alternative to Choice().  The canonical storage of choice remains a string.
  /// Also used to set the selected choice or empty if none chosen or if index is out of range.
  int get choiceIndex => _choices.value.indexOf(_choice.value);
  set choiceIndex(int index) {
    if (index >= 0 && index < _choices.value.length) {
      _choice.value = _choices.value[index];
    } else {
      _choice.value = '';
    }
  }

  /// Returns whether or not the choice is valid.
  bool get isChoiceValid {
    return choices.contains(choice);
  }
}
