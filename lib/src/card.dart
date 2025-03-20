// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'pkey.dart';
import 'primitive_base.dart';
import 'any_field.dart';
import 'primitive.dart';

/// A group is a related set of primitives, such as a group of commands, that is
/// static in type and quantity.  If a dynamic number of primitives is desired
/// then consider using a List primitive instead.
class Card extends PrimitiveBase {
  Card({
    super.embodiment,
    super.tag,
    Primitive? leadingItem,
    Primitive? mainItem,
    Primitive? subItem,
    Primitive? trailingItem,
  }) {
    _leadingItem = AnyField.from(leadingItem);
    _mainItem = AnyField.from(mainItem);
    _subItem = AnyField.from(subItem);
    _trailingItem = AnyField.from(trailingItem);
  }

  // Field storage
  late AnyField _leadingItem;
  late AnyField _mainItem;
  late AnyField _subItem;
  late AnyField _trailingItem;

  @override
  String get describeType => 'Card';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyLeadingItem, _leadingItem));
    fieldRefs.add(FieldRef(fkeyMainItem, _mainItem));
    fieldRefs.add(FieldRef(fkeySubItem, _subItem));
    fieldRefs.add(FieldRef(fkeyTrailingItem, _trailingItem));
  }

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    // The next index specifies which container field to access...
    var nextIndex = locator.nextIndex();
    Primitive? item;
    switch (nextIndex) {
      case 0:
        item = leadingItem;
      case 1:
        item = mainItem;
      case 2:
        item = subItem;
      case 3:
        item = trailingItem;
      default:
        throw Exception('PKey locator is out of bounds');
    }

    if (item == null) {
      throw Exception('PKey locator refers to non-existant item');
    }
    return item;
  }

  @override
  String toString() {
    return "";
  }

  /// The leading item of the card (typically an icon but can be other simple primitive).
  Primitive? get leadingItem => _leadingItem.value;
  set leadingItem(Primitive? item) => _leadingItem.value = item;

  /// The main item of the card (typically a title text but can be other simple primitive).
  Primitive? get mainItem => _mainItem.value;
  set mainItem(Primitive? item) => _mainItem.value = item;

  /// The sub item of the card (typically a sub-title text but can be other simple primitive).
  Primitive? get subItem => _subItem.value;
  set subItem(Primitive? item) => _subItem.value = item;

  /// The trailing item of the card (typically an icon or command but can be other simple primitive).
  Primitive? get trailingItem => _trailingItem.value;
  set trailingItem(Primitive? item) => _trailingItem.value = item;
}
