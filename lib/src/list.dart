// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'primitive_base.dart';
import 'any1d_field.dart';
import 'integer_field.dart';
import 'primitive.dart';

/// A list is a collection of primitives that have a sequential-like relationship
/// and might be dynamic in quantity or kind.
///
/// Note: it is named ListP to avoid conflict with the Dart List class.
class ListP extends PrimitiveBase {
  ListP(
      {super.embodiment,
      super.tag,
      List<Primitive> listItems = const [],
      int selected = 0}) {
    _listItems = Any1DField.from(listItems);
    _selected = IntegerField.from(selected);
  }

  // Field storage
  late Any1DField _listItems;
  late IntegerField _selected;

  @override
  String get describeType => 'ListP';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyListItems, _listItems));
  }

  @override
  String toString() {
    return "";
  }

  /// The collection of primitives that make up the list.
  List<Primitive> get listItems => _listItems.value;
  set listItems(List<Primitive> listItems) => _listItems.value = listItems;

  /// The currently selected item or -1 for none selected.
  int get selected => _selected.value;
  set selected(int selected) => _selected.value = selected;

  /// SelectedItem returns the currently selected item from the list.
  /// If the selected index is within the valid range of list items, it returns the item at the selected index.
  /// If the selected index is out of range, it returns null.
  Primitive? get selectedItem {
    var selected = _selected.value;
    if (selected < 0 || selected >= listItems.length) {
      return null;
    }
    return listItems[selected];
  }
}
