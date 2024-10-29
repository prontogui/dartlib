// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'field.dart';
import 'pkey.dart';
import 'fkey.dart';
import 'onset.dart';
import 'primitive.dart';
import 'string_field.dart';

class FieldRef {
  FieldRef(this.fkey, this.field);

  FKey fkey;
  Field field;
}

abstract class PrimitiveBase implements Primitive {
  PrimitiveBase({String embodiment = '', String tag = ''})
      : _embodiment = StringField.from(embodiment),
        _tag = StringField.from(tag) {}

  late PKey _pkey;
  List<FieldRef>? __cachedFieldRefs;

  // Derived primitives must implement this method to describe their type and fields.
  void describeFields(List<FieldRef> fieldRefs);

  List<FieldRef> get _fieldRefs {
    // Build list of field refs on demand and cache it.
    if (__cachedFieldRefs == null) {
      var fieldRefs = List<FieldRef>.empty(growable: true);

      // Add common fields here...
      fieldRefs.add(FieldRef(fkeyEmbodiment, _embodiment));
      fieldRefs.add(FieldRef(fkeyTag, _tag));

      // Add fields specific to the derived class
      describeFields(fieldRefs);

      __cachedFieldRefs = fieldRefs;
    }

    return __cachedFieldRefs!;
  }

  // Common fields for all primitives
  final StringField _embodiment;
  final StringField _tag;

  // The embodiment to use for rendering the Text.
  String get embodiment => _embodiment.value;
  set embodiment(String embodiment) {
    _embodiment.value = embodiment;
  }

  // The tag to keep around with this primitive.
  String get tag => _tag.value;
  set tag(String tag) {
    _tag.value = tag;
  }

  void initializeFromCborMap(PKey pkey, CborMap cbor) {
    _pkey = pkey;
    ingestCborMap(cbor);
  }

  @override
  Primitive? locateNextDescendant(PKeyLocator locator) {
    return null;
  }

  Field? findField(FKey fkey) {
    for (var fieldRef in _fieldRefs) {
      if (fieldRef.fkey == fkey) {
        return fieldRef.field;
      }
    }
    return null;
  }

  @override
  void prepareForUpdates(PKey pkey, OnsetFunction onset) {
    _pkey = pkey;

    // Prepare each field for updates
    var fieldPKeyIndex = 0;
    for (var fieldRef in _fieldRefs) {
      fieldRef.field
          .prepareForUpdates(fieldRef.fkey, pkey, fieldPKeyIndex, onset);
      if (fieldRef.field.isStructural) {
        fieldPKeyIndex++;
      }
    }
  }

  /// Egests a full update from this primitive as a CborMap.
  @override
  CborMap egestFullCborMap() {
    Map<CborValue, CborValue> update = {};

    for (var field in _fieldRefs!) {
      update[CborString(fieldnameFor(field.fkey))] =
          field.field.egestCborValue();
    }

    return CborMap(update);
  }

  /// Egests a partil update from this primitive as a CborMap.
  /// Only the fields specified in [fkeys] will be included in the map.
  /// It is assumed that [fkeys] is a subset of the fields of this primitive, otherwise
  /// an assertion is thrown.
  @override
  CborMap egestPartialCborMap(List<FKey> fkeys) {
    Map<CborValue, CborValue> update = {};

    for (var fkey in fkeys) {
      var field = findField(fkey);
      assert(field != null);

      update[CborString(fieldnameFor(fkey))] = field!.egestCborValue();
    }

    return CborMap(update);
  }

  @override
  void ingestCborMap(CborMap cbor) {
    for (var item in cbor.entries) {
      var k = item.key;

      if (k is! CborString) {
        throw 'key is not a CborString';
      }

      var fkey = fkeyFor(k.toString());
      if (fkey == invalidFieldName) {
        throw 'invalid field name';
      }

      var field = findField(fkey);
      if (field == null) {
        throw 'field not found';
      }

      field.ingestCborValue(item.value);
    }
  }

  // Returns the index of this primitive in a parent container specified by [parentLevel] as follows:
  // parentLevel = 0, immediate parent container
  // parentLevel = 1, grandparent
  // parentLevel = 2, great grandparent
  // And so on.
  //
  // It returns -1 if parentLevel is a negative number or is invalid given the depth where the primitive belongs.
  int indexOf(int parentLevel) {
    int len = _pkey.length;

    if (parentLevel >= 0 && parentLevel < len) {
      return _pkey.indexAtLevel(len - parentLevel - 1);
    }

    return -1;
  }

  /// Returns a pretty-printed string representation of this primitive.
  String prettyPrint() {
    var pp = '$describeType\n  pkey : ${_pkey.toString()}';
    for (var field in _fieldRefs) {
      pp += '\n  ${fieldnameFor(field.fkey)} : ${field.field.toString()}';
    }
    return pp;
  }

  // Default implementation of toString() for all primitives returns an empty string.
  @override
  String toString() {
    return '';
  }
}
