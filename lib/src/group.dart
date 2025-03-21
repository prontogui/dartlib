// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'pkey.dart';
import 'primitive_base.dart';
import 'any1d_field.dart';
import 'integer_field.dart';
import 'primitive.dart';

/// A group is a related set of primitives, such as a group of commands, that is
/// static in type and quantity.  If a dynamic number of primitives is desired
/// then consider using a List primitive instead.
class Group extends PrimitiveBase {
  Group(
      {super.embodiment,
      super.tag,
      List<Primitive> groupItems = const [],
      int status = 0}) {
    _groupItems = Any1DField.from(groupItems);
    _status = IntegerField.from(status);
  }

  // Field storage
  late Any1DField _groupItems;
  late IntegerField _status;

  @override
  String get describeType => 'Group';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyGroupItems, _groupItems));
    fieldRefs.add(FieldRef(fkeyStatus, _status));
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    if (nextIndex != 0) {
      throw Exception('PKey locator is out of bounds');
    }

    // The next index thereafter specifies which primitive to access...
    return groupItems[locator.nextIndex()];
  }

  @override
  String toString() {
    return "";
  }

  /// The collection of primitives that make up the group.
  List<Primitive> get groupItems => _groupItems.value;
  set groupItems(List<Primitive> groupItems) => _groupItems.value = groupItems;

  /// The status of the primitive:  0 = Normal, 1 = Disabled, 2 = Hidden.
  int get status => _status.value;
  set status(int status) {
    _status.value = status;
  }

  /// The enabled status of the primitive.  This is derived from the Status field.
  /// Setting this to true will set Status to 0 (visible & enabled)
  /// and setting this to false will set Status to 1 (disabled).
  ///
  /// Note:  this is a helper method to make it easier to work with the status field.  The
  /// canonical storage is still with the status field.
  bool get enabled => status == 0;
  set enabled(bool enabled) {
    status = enabled ? 0 : 1;
  }

  /// The visibility of the primitive.  This is derived from the Status field.
  /// Setting this to true will set Status to 0 (visible & enabled)and setting
  /// this to false will set Status to 2 (hidden).
  ///
  /// Note:  this is a helper method to make it easier to work with the status field.  The
  /// canonical storage is still with the status field.
  bool get visible => status != 2;
  set visible(bool visible) {
    status = visible ? 0 : 2;
  }
}
