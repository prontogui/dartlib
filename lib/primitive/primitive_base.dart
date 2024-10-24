// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'field.dart';
import 'package:dartlib/key/pkey.dart';
import 'package:dartlib/key/fkey.dart';
import 'package:dartlib/key/onset.dart';
import 'primitive.dart';

class FieldRef {
  FieldRef(this.fkey, this.field);

  FKey fkey;
  Field field;
}

mixin PrimitiveBase {
  late PKey _pkey;
  List<FieldRef>? _fieldRefs;

  prepareForUpdates(PKey pkey, OnsetFunction onset) {
    throw UnimplementedError();
  }

  Primitive? locateNextDescendant(PKeyLocator locator) {
    return null;
  }

  Field? findField(FKey fkey) {
    for (var fieldRef in _fieldRefs!) {
      if (fieldRef.fkey == fkey) {
        return fieldRef.field;
      }
    }
    return null;
  }

  CborMap egestCborUpdate(bool fullUpdate, List<FKey> fkeys) {
    Map<CborValue, CborValue> update = {};

    assert(_fieldRefs != null);

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

  bool ingestCborUpdate(CborMap update) {
    for (var item in update.entries) {
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

  // func (r *PrimitiveBase) InternalPrepareForUpdates(pkey key.PKey, onset key.OnSetFunction, getFields func() []FieldRef) {
  void internalPrepareForUpdates(
      PKey pkey, OnsetFunction onset, List<FieldRef> Function() getFields) {
    _pkey = pkey;

    // Attach fields (if not done already)
    _fieldRefs ??= getFields();

    // Prepare each field for updates
    var fieldPKeyIndex = 0;
    for (var fieldRef in getFields()) {
      if (fieldRef.field
          .prepareForUpdates(fieldRef.fkey, pkey, fieldPKeyIndex, onset)) {
        fieldPKeyIndex++;
      }
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

  // Default implementation of toString() for all primitives returns an empty string.
  String toString() {
    return '';
  }
}
