// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:dartlib/src/strings1d_field.dart';

import 'fkey.dart';
import 'pkey.dart';
import 'primitive_base.dart';
import 'any1d_field.dart';
import 'integer_field.dart';
import 'primitive.dart';
import 'sub_embodiments.dart';

/// A list is a collection of primitives that have a sequential-like relationship
/// and might be dynamic in quantity or kind.
///
/// Note: it is named ListP to avoid conflict with the Dart List class.
class ListP extends PrimitiveBase with SubEmbodiments {
  ListP(
      {super.embodiment,
      super.tag,
      List<Primitive> listItems = const [],
      int selected = 0,
      List<String> subEmbodiments = const []}) {
    _listItems = Any1DField.from(listItems);
    _selected = IntegerField.from(selected);
    initializeSubEmbodiments(subEmbodiments);
  }

  // Field storage
  late Any1DField _listItems;
  late IntegerField _selected;

  @override
  // Return the cananical type name for this primitive.  ListP is used specifically
  // in this library because List is a reserved word in Dart.
  String get describeType => 'List';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyListItems, _listItems));
    fieldRefs.add(FieldRef(fkeySelected, _selected));
    describeSubEmbodimentsField(fieldRefs);
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    if (nextIndex != 0) {
      throw Exception('PKey locator is out of bounds');
    }

    // The next index thereafter specifies which primitive to access...
    return listItems[locator.nextIndex()];
  }

  @override
  void clearCachedFieldInformation(FKey? forFkey) {
    if (forFkey == null || forFkey == fkeySubEmbodiments) {
      clearCachedSubEmbodiments();
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
