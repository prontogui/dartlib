// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'field.dart';
import 'package:dartlib/key/pkey.dart';
import 'package:dartlib/key/fkey.dart';
import 'package:dartlib/key/onset.dart';
import 'primitive.dart';
import 'string_field.dart';

class FieldRef {
  FieldRef(this.fkey, this.field);

  FKey fkey;
  Field field;
}

abstract class PrimitiveBase {
  PrimitiveBase({String embodiment = '', String tag = ''})
      : _embodiment = StringField.from(embodiment),
        _tag = StringField.from(tag) {}

  late PKey _pkey;
  late List<FieldRef>? __cached_fieldRefs;

  List<FieldRef> get _fieldRefs {
    // Build list of field refs on demand and cache it.
    if (__cached_fieldRefs == null) {
      var fieldRefs = List<FieldRef>.empty(growable: true);

      // Add common fields here...
      fieldRefs.add(FieldRef(fkeyEmbodiment, _embodiment));
      fieldRefs.add(FieldRef(fkeyTag, _tag));

      // Add fields specific to the derived class
      describeFields(fieldRefs);

      __cached_fieldRefs = fieldRefs;
    }

    return __cached_fieldRefs!;
  }

  // Common fields for all primitives
  final StringField _embodiment;
  final StringField _tag;

  // The embodiment to use for rendering the Text.
  String get embodiment => _embodiment.get();
  set embodiment(String embodiment) {
    _embodiment.set(embodiment);
  }

  // The tag to keep around with this primitive.
  String get tag => _tag.get();
  set tag(String tag) {
    _tag.set(tag);
  }

  // Derived primitives must implement this method to describe their fields.
  void describeFields(List<FieldRef> fieldRefs);

  bool initializeFromCborMap(PKey pkey, CborMap cbor) {
    _pkey = pkey;
    return ingestCborMap(cbor);
  }

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

  void prepareForUpdates(PKey pkey, OnsetFunction onset) {
    _pkey = pkey;

    // Prepare each field for updates
    var fieldPKeyIndex = 0;
    for (var fieldRef in _fieldRefs) {
      if (fieldRef.field
          .prepareForUpdates(fieldRef.fkey, pkey, fieldPKeyIndex, onset)) {
        fieldPKeyIndex++;
      }
    }
  }

  CborMap egestCborMap(bool fullUpdate, List<FKey> fkeys) {
    Map<CborValue, CborValue> update = {};

    if (fullUpdate) {
      for (var field in _fieldRefs!) {
        update[CborString(fieldnameFor(field.fkey))] =
            field.field.egestCborValue();
      }
    } else {
      for (var fkey in fkeys) {
        var field = findField(fkey);
        assert(field != null);

        update[CborString(fieldnameFor(fkey))] = field!.egestCborValue();
      }
    }

    return CborMap(update);
  }

  bool ingestCborMap(CborMap cbor) {
    for (var item in cbor.entries) {
      var k = item.key;

      if (k is! CborString) {
        // TODO: Log an error
        return false;
      }

      var fkey = fkeyFor(k.toString());
      if (fkey == invalidFieldName) {
        // TODO: Log an error
        return false;
      }

      var field = findField(fkey);
      if (field == null) {
        // TODO: Log an error
        return false;
      }

      if (!field.ingestCborValue(item.value)) {
        // TODO: Log an error
        return false;
      }
    }

    return true;
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

  // Default implementation of toString() for all primitives returns an empty string.
  String toString() {
    return '';
  }
}
