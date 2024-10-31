// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'primitive_base.dart';
import 'boolean_field.dart';
import 'any1d_field.dart';
import 'primitive.dart';

/// A frame represents a complete user interface to show on the screen.  It could be
/// the main user interface or a sub-screen in the app.  It includes the ability to
/// layout controls in a specific manner.
class Frame extends PrimitiveBase {
  Frame({
    super.embodiment,
    super.tag,
    List<Primitive> frameItems = const [],
    bool showing = false,
  }) {
    _frameItems = Any1DField.from(frameItems);
    _showing = BooleanField.from(showing);
  }

  // Field storage
  late Any1DField _frameItems;
  late BooleanField _showing;

  @override
  String get describeType => 'Frame';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyFrameItems, _frameItems));
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
}
