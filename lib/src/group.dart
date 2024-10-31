// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'primitive_base.dart';
import 'any1d_field.dart';
import 'primitive.dart';

/// A group is a related set of primitives, such as a group of commands, that is
/// static in type and quantity.  If a dynamic number of primitives is desired
/// then consider using a List primitive instead.
class Group extends PrimitiveBase {
  Group({super.embodiment, super.tag, List<Primitive> groupItems = const []}) {
    _groupItems = Any1DField.from(groupItems);
  }

  // Field storage
  late Any1DField _groupItems;

  @override
  String get describeType => 'Group';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyGroupItems, _groupItems));
  }

  @override
  String toString() {
    return "";
  }

  /// The collection of primitives that make up the group.
  List<Primitive> get groupItems => _groupItems.value;
  set groupItems(List<Primitive> groupItems) => _groupItems.value = groupItems;
}
