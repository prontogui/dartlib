// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'pkey.dart';
import 'primitive_base.dart';
import 'any1d_field.dart';
import 'integer_field.dart';
import 'primitive.dart';

/// A node is a related set of primitives representing an item in a ListP primitive,
/// especially when a multi-level list is desired.  These items represent information
/// to display in the list item and are static in type and quantity.
class Node extends PrimitiveBase {
  Node(
      {super.embodiment,
      super.tag,
      List<Primitive> nodeItems = const [],
      int level = 0}) {
    _nodeItems = Any1DField.from(nodeItems);
    _level = IntegerField.from(level);
  }

  // Field storage
  late Any1DField _nodeItems;
  late IntegerField _level;

  @override
  String get describeType => 'Node';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyNodeItems, _nodeItems));
    fieldRefs.add(FieldRef(fkeyLevel, _level));
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    if (nextIndex != 0) {
      throw Exception('PKey locator is out of bounds');
    }

    // The next index thereafter specifies which primitive to access...
    return nodeItems[locator.nextIndex()];
  }

  @override
  String toString() {
    return "";
  }

  /// The collection of primitives that make up the node.
  List<Primitive> get nodeItems => _nodeItems.value;
  set nodeItems(List<Primitive> nodeItems) => _nodeItems.value = nodeItems;

  /// The level of the node inside a ListP that is display multi-level items.
  int get level => _level.value;
  set level(int level) {
    _level.value = level;
  }
}
