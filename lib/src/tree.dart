// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'pkey.dart';
import 'primitive_base.dart';
import 'any_field.dart';
import 'integer1d_field.dart';
import 'primitive.dart';
import 'node.dart';

/// A node is used to represent a tree of primitives. If it contains other nodes,
/// then it is considered a branch.  If it contains other primitives then it is
/// considered a leaf.  It is an error to have both node and non-node primitives as items.
class Tree extends PrimitiveBase {
  Tree({super.embodiment, super.tag, Primitive? modelItem, Node? root}) {
    root ??= Node();
    _modelItem = AnyField.from(modelItem);
    _root = AnyField.from(root);
    _selection = Integer1DField();
  }

  // Field storage

  // This field stores a model item which can be any type of primitive.
  late AnyField _modelItem;

  // This always contains a Node primitive and is never null.
  late AnyField _root;

  late Integer1DField _selection;

  @override
  String get describeType => 'Tree';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyModelItem, _modelItem));
    fieldRefs.add(FieldRef(fkeyRoot, _root));
    fieldRefs.add(FieldRef(fkeySelection, _selection));
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    switch (nextIndex) {
      case 0:
        if (_modelItem.value == null) {
          throw Exception('PKey locator is out of bounds');
        }
        return _modelItem.value!;
      case 1:
        if (_root.value == null) {
          throw Exception('PKey locator is out of bounds');
        }
        return _root.value!;
      default:
        throw Exception('PKey locator is out of bounds');
    }
  }

  @override
  String toString() {
    return "";
  }

  /// The model primitive which all list items will be like.  It is mainly used to
  /// specify embodiment settings to use for all list items.
  Primitive? get modelItem {
    return _modelItem.value;
  }

  set modelItem(Primitive? p) {
    _modelItem.value = p;
  }

  /// The collection of primitives that make up the node.
  Node get root => _root.value! as Node;
  set root(Node node) => _root.value = node;

  /// The currently selected node or empty for none selected.  The selection is
  /// represented as a list of integers in the order of depth toward the selected
  /// node.  Each integer represents a child node index (zero relative) in that node
  /// level. Note:  it is possible to specify a selection that refers to a non-existant node.
  List<int> get selection => _selection.value;
  set selection(List<int> selection) => _selection.value = selection;

  /// SelectedItem returns the currently selected item from the list.
  /// If the selected index is within the valid range of list items, it returns the item at the selected index.
  /// If the selected index is out of range, it returns null.
  Primitive? get selectedItem {
    return root.locateNode(selection);
  }
}
