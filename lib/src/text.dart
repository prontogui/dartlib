// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'primitive_base.dart';
import 'string_field.dart';

class Text extends PrimitiveBase {
  Text({super.embodiment, super.tag, String content = ''}) {
    _content = StringField.from(content);
  }

  // Field storage
  late StringField _content;

  @override
  String get describeType => 'Text';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyContent, _content));
  }

  @override
  String toString() {
    return _content.value;
  }

  /// The text content to display.
  String get content => _content.value;
  set content(String content) {
    _content.value = content;
  }
}
