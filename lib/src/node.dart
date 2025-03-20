// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'pkey.dart';
import 'primitive_base.dart';
import 'any_field.dart';
import 'any1d_field.dart';
import 'primitive.dart';

/// A node is used to represent a tree of primitives. If it contains other nodes,
/// then it is considered a branch.  If it contains other primitives then it is
/// considered a leaf.  It is an error to have both node and non-node primitives as items.
class Node extends PrimitiveBase {
  Node(
      {super.embodiment,
      super.tag,
      Primitive? nodeItem,
      List<Primitive> subNodes = const []}) {
/*        
    if (nodeItem == null) {
      _nodeItem = AnyField.from(Nothing());
    } else {
      _nodeItem = AnyField.from(nodeItem);
    }
*/
    _nodeItem = AnyField.from(nodeItem);
    _subNodes = Any1DField.from(subNodes);
  }

  // Field storage

  // This always holds a valid primitive or the Nothing primitive.
  late AnyField _nodeItem;
  late Any1DField _subNodes;

  @override
  String get describeType => 'Node';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    // IMPORTANT: list fields in alphabetical order!
    fieldRefs.add(FieldRef(fkeyNodeItem, _nodeItem));
    fieldRefs.add(FieldRef(fkeySubNodes, _subNodes));
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    if (nextIndex == 0) {
      if (_nodeItem.value == null) {
        throw Exception('PKey locator is out of bounds');
      }
      return _nodeItem.value!;
    } else if (nextIndex == 1) {
      // The next index thereafter specifies which primitive to access...
      return _subNodes.value[locator.nextIndex()];
    } else {
      throw Exception('PKey locator is out of bounds');
    }
  }

  @override
  String toString() {
    return "";
  }

  Primitive? locateNode(List<int> nodePath) {
    var nodes = _subNodes.value;

    if (nodePath.isEmpty) {
      return null;
    }

    var index = nodePath[0];
    if (index < 0 || index >= nodes.length) {
      return null;
    }

    var subNode = nodes[index] as Node;
    return subNode.locateNode(nodePath.sublist(1));
  }

  /// The sub-nodes (descendents) of this node.
  List<Primitive> get subNodes => _subNodes.value;
  set subNodes(List<Primitive> subNodes) => _subNodes.value = subNodes;

  /// The primitive this node contains.
  Primitive? get nodeItem {
    return _nodeItem.value;
  }

  set nodeItem(Primitive? nodeItem) => _nodeItem.value = nodeItem;

  /// Arbitrary data assigned and used by the App. Note: this is only used on the
  /// App side and is not implemented by server-side libraries like golib.
  dynamic appData;
}
