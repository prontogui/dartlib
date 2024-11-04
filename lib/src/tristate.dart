// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'primitive_base.dart';
import 'integer_field.dart';
import 'string_field.dart';

// A choice presented to the user that give three possible states:  Affirmative (Yes, On, 1, etc.),
// Negative (No, Off, 0, etc.), and Indeterminate.
class Tristate extends PrimitiveBase {
  Tristate({super.embodiment, super.tag, int state = 0, String label = ''}) {
    _state = IntegerField.from(state);
    _label = StringField.from(label);
  }

  // Field storage
  late IntegerField _state;
  late StringField _label;

  @override
  String get describeType => 'Tristate';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyState, _state));
    fieldRefs.add(FieldRef(fkeyLabel, _label));
  }

  @override
  String toString() {
    return _label.value;
  }

  /// The state of the option (0 = Negative, 1 = Affirmative, and -1 = Indeterminate).
  int get state => _state.value;
  set state(int state) => _state.value = state;

  /// The text label to display.
  String get label => _label.value;
  set label(String label) => _label.value = label;

  /// Alternative getter of state represented as nullable boolean.
  bool? get stateAsBool {
    switch (state) {
      case 0:
        return false;
      case 1:
        return true;
      case 2:
        return null;
      default:
        assert(false);
    }
    return null;
  }

  /// Alternative setter of state using a nullable boolean.  Calling this function also
  /// sets the state field appropriately.
  set stateAsBool(bool? boolState) {
    if (boolState == null) {
      state = 2;
    } else if (boolState) {
      state = 1;
    } else {
      state = 0;
    }
  }

  /// Cycles to the next state.
  void nextState() {
    switch (state) {
      case 0:
        state = 1;
      case 1:
        state = 2;
      case 2:
        state = 0;
      default:
        state = 0;
    }
  }
}
