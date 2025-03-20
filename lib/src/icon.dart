// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'primitive_base.dart';
import 'string_field.dart';

/// An icon to display on the screen.
class Icon extends PrimitiveBase {
  Icon({super.embodiment, super.tag, String iconID = ''}) {
    _iconID = StringField.from(iconID);
  }

  // Field storage
  late StringField _iconID;

  @override
  String get describeType => 'Icon';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyIconID, _iconID));
  }

  @override
  String toString() {
    return _iconID.value;
  }

  /// The Material ID of the icon to use.
  String get iconID => _iconID.value;
  set iconID(String id) {
    _iconID.value = id;
  }
}
