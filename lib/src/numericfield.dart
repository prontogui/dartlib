// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'primitive_base.dart';
import 'string_field.dart';

// An entry field that allows the user to enter numeric values.
class NumericField extends PrimitiveBase {
  NumericField({super.embodiment, super.tag, String numericEntry = ''}) {
    _numericEntry = StringField.from(numericEntry);
  }

  // The numeric value, as text, that was entered by user.
  late StringField _numericEntry;

  @override
  String get describeType => 'NumericField';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyNumericEntry, _numericEntry));
  }

  @override
  String toString() {
    return _numericEntry.value;
  }

  /// The initial numeric text to show user and, also, the text entered by the user.
  String get numericEntry => _numericEntry.value;
  set numericEntry(String numericEntry) => _numericEntry.value = numericEntry;
}
