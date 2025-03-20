// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'primitive_base.dart';
import 'boolean_field.dart';
import 'string_field.dart';

/// A check provides a yes/no, on/off, 1/0, kind of choice to the user.
/// It is often represented with a check box like you would see on a form.
class Check extends PrimitiveBase {
  Check(
      {super.embodiment, super.tag, bool checked = false, String label = ''}) {
    _checked = BooleanField.from(checked);
    _label = StringField.from(label);
  }

  // Field storage
  late BooleanField _checked;
  late StringField _label;

  @override
  String get describeType => 'Check';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyChecked, _checked));
    fieldRefs.add(FieldRef(fkeyLabel, _label));
  }

  @override
  String toString() {
    return _label.value;
  }

  /// The check state is Yes, On, 1, etc., and false if the check state is No, Off, 0, etc.
  bool get checked => _checked.value;
  set checked(bool checked) => _checked.value = checked;

  /// The text label to display.
  String get label => _label.value;
  set label(String label) => _label.value = label;

  /// Cycles to the next state.
  void nextState() {
    checked = !checked;
  }
}
