// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:dartlib/src/any_field.dart';
import 'package:dartlib/src/string_field.dart';

import 'fkey.dart';
import 'pkey.dart';
import 'primitive_base.dart';
import 'boolean_field.dart';
import 'any1d_field.dart';
import 'primitive.dart';

/// A frame represents a complete user interface to show on the screen.  It could be
/// the main user interface or a sub-screen in the app.  It includes the ability to
/// layout controls in a specific manner.
class Frame extends PrimitiveBase {
  Frame(
      {super.embodiment,
      super.tag,
      List<Primitive> frameItems = const [],
      bool showing = false,
      String title = '',
      Primitive? icon}) {
    _frameItems = Any1DField.from(frameItems);
    _showing = BooleanField.from(showing);
    _title = StringField.from(title);
    _icon = AnyField.from(icon);
  }

  // Field storage
  late Any1DField _frameItems;
  late BooleanField _showing;
  late StringField _title;
  late AnyField _icon;

  @override
  String get describeType => 'Frame';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyFrameItems, _frameItems));
    fieldRefs.add(FieldRef(fkeyShowing, _showing));
    fieldRefs.add(FieldRef(fkeyIcon, _icon));
    fieldRefs.add(FieldRef(fkeyTitle, _title));
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    if (nextIndex != 0) {
      throw Exception('PKey locator is out of bounds');
    }

    // The next index thereafter specifies which primitive to access...
    return frameItems[locator.nextIndex()];
  }

  @override
  String toString() {
    return "";
  }

  /// The collection of primitives that make up the frame.
  List<Primitive> get frameItems => _frameItems.value;
  set frameItems(List<Primitive> frameItems) => _frameItems.value = frameItems;

  /// True if the Frame is being shown, or should be shown on the screen.
  bool get showing => _showing.value;
  set showing(bool showing) => _showing.value = showing;

  /// The optional title to display for the frame.  Note: this is only used in certain
  /// embodiments.
  String get title => _title.value;
  set title(String s) => _title.value = s;

  /// The optional icon to display along with the title for the frame.  Note: this
  /// is only used in certain embodiments.
  Primitive? get icon => _icon.value;
  set icon(Primitive? p) => _icon.value = p;
}
