// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'primitive_base.dart';
import 'string_field.dart';

// An entry field that allows the user to enter text.
class TextField extends PrimitiveBase {
  TextField({super.embodiment, super.tag, String textEntry = ''}) {
    _textEntry = StringField.from(textEntry);
  }

  // Field storage
  late StringField _textEntry;

  @override
  String get describeType => 'TextField';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyTextEntry, _textEntry));
  }

  @override
  String toString() {
    return _textEntry.value;
  }

  /// The initial text to show user and also the text entered by the user.
  String get textEntry => _textEntry.value;
  set textEntry(String textEntry) => _textEntry.value = textEntry;
}
