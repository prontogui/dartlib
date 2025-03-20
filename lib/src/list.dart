// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:dartlib/src/any_field.dart';
import 'fkey.dart';
import 'pkey.dart';
import 'primitive_base.dart';
import 'any1d_field.dart';
import 'integer_field.dart';
import 'primitive.dart';

/// A list is a collection of primitives that have a sequential-like relationship
/// and might be dynamic in quantity or kind.
///
/// Note: it is named ListP to avoid conflict with the Dart List class.
class ListP extends PrimitiveBase {
  ListP({
    super.embodiment,
    super.tag,
    List<Primitive> listItems = const [],
    Primitive? modelItem,
    int selectedIndex = 0,
  }) {
    _listItems = Any1DField.from(listItems);
    _modelItem = AnyField.from(modelItem);
    _selectedIndex = IntegerField.from(selectedIndex);
  }

  // Field storage
  late Any1DField _listItems;

  // The model item to use when embodifying list items.
  late AnyField _modelItem;

  // This has either 1 item or is empty for no selection.
  late IntegerField _selectedIndex;

  @override
  // Return the canonical type name for this primitive.  ListP is used specifically
  // in this library because List is a reserved word in Dart.
  String get describeType => 'List';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyListItems, _listItems));
    fieldRefs.add(FieldRef(fkeyModelItem, _modelItem));
    fieldRefs.add(FieldRef(fkeySelectedIndex, _selectedIndex));
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    switch (nextIndex) {
      case 0:
        return listItems[locator.nextIndex()];
      case 1:
        if (_modelItem.value == null) {
          throw Exception('PKey locator is out of bounds');
        }
        return _modelItem.value!;
      default:
        throw Exception('PKey locator is out of bounds');
    }
  }

  @override
  String toString() {
    return "";
  }

  /// The collection of primitives that make up the list.
  List<Primitive> get listItems => _listItems.value;
  set listItems(List<Primitive> listItems) => _listItems.value = listItems;

  /// The currently selected item or -1 for none selected.
  int get selectedIndex {
    return _selectedIndex.value;
  }

  set selectedIndex(int selectedIndex) {
    _selectedIndex.value = selectedIndex;
  }

  /// SelectedItem returns the currently selected item from the list.
  /// If the selected index is within the valid range of list items, it returns the item at the selected index.
  /// If the selected index is out of range, it returns null.
  Primitive? get selectedItem {
    var selectedIndex = _selectedIndex.value;
    if (selectedIndex < 0 || selectedIndex >= listItems.length) {
      return null;
    }
    return listItems[selectedIndex];
  }

  /// The model primitive which all list items will be like.  It is mainly used to
  /// specify embodiment settings to use for all list items.
  Primitive? get modelItem {
    return _modelItem.value;
  }

  set modelItem(Primitive? p) {
    _modelItem.value = p;
  }
}
