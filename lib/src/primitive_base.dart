// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'field.dart';
import 'pkey.dart';
import 'fkey.dart';
import 'field_hooks.dart';
import 'primitive.dart';
import 'string_field.dart';
import 'dart:convert';

class FieldRef {
  FieldRef(this.fkey, this.field);

  FKey fkey;
  Field field;
}

/// The base class for all primitives.
abstract class PrimitiveBase implements Primitive {
  PrimitiveBase({String embodiment = '', String tag = ''}) {
    this.embodiment = embodiment;
    this.tag = tag;
  }

  // The PKey of this primitive.
  PKey _pkey = PKey();

  // Cached field refs.
  List<FieldRef>? __cachedFieldRefs;

  // Common fields for all primitives
  final _embodiment = StringField();
  final _tag = StringField();

  /// Cached embodimenet properties.  These are built on demand and cleared when
  /// embodiment is reassigned.  If embodiment is empty then this value remains null.
  Map<String, dynamic>? __cachedEmbodimentProperties;

  // Derived primitives must implement this method to describe their type and fields.
  void describeFields(List<FieldRef> fieldRefs);

  List<FieldRef> get _fieldRefs {
    // Build list of field refs on demand and cache it.
    if (__cachedFieldRefs == null) {
      var fieldRefs = List<FieldRef>.empty(growable: true);

      // Add fields specific to the derived class
      describeFields(fieldRefs);

      // Add common fields here...
      fieldRefs.add(FieldRef(fkeyEmbodiment, _embodiment));
      fieldRefs.add(FieldRef(fkeyTag, _tag));

      __cachedFieldRefs = fieldRefs;
    }

    return __cachedFieldRefs!;
  }

  /// The embodiment to use for rendering the primitive.
  ///
  /// Setting the embodiment is done using a JSON string, a simple assignment of embodiment type,
  /// or a simplified key-value pair string.  For example:
  ///
  /// This will always return a JSON string, the canonical representation of the embodiment,
  /// regardless of how it was set.
  String get embodiment => _embodiment.value;
  set embodiment(String embodiment) {
    // In any case, clear the cached embodiment properties.
    __cachedEmbodimentProperties = null;
    _embodiment.value = _canonizeEmbodiment(embodiment);
  }

  String _canonizeEmbodiment(String embodimentSetting) {
    var s = embodimentSetting.trim();

    if (s.isEmpty) {
      return '';
    }

    if (s.startsWith('{')) {
      return s;
    }

    if (s.contains(':')) {
      return _convertSimplifiedKVPairsToJson(s);
    }

    return '{"embodiment":"$s"}';
  }

  String _convertSimplifiedKVPairsToJson(String embodiment) {
    var innerJson = "";

    var pairs = embodiment.split(',');

    for (var pair in pairs) {
      var kv = pair.split(':');
      if (kv.length != 2) {
        throw Exception('Invalid key:value pair in simplified embodiment');
      }

      if (innerJson.isNotEmpty) {
        innerJson += ',';
      }

      innerJson += '"${kv[0].trim()}":"${kv[1].trim()}"';
    }

    return '{$innerJson}';
  }

  // The tag to keep around with this primitive.
  String get tag => _tag.value;
  set tag(String tag) {
    _tag.value = tag;
  }

  void initializeFromCborMap(PKey pkey, CborMap cbor) {
    _pkey = pkey;
    ingestFullCborMap(cbor);
  }

  @override
  PKey get pkey => _pkey;

  @override
  Primitive locateNextDescendant(PKeyLocator locator) {
    throw Exception(
        'locateNextDescendant not implemented for this primitive because it doesn\'t have descendants.');
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
  void prepareForUpdates(PKey pkey, FieldHooks fieldHooks) {
    _pkey = pkey;

    // Prepare each field for updates
    var fieldPKeyIndex = 0;
    for (var fieldRef in _fieldRefs) {
      fieldRef.field
          .prepareForUpdates(fieldRef.fkey, pkey, fieldPKeyIndex, fieldHooks);

      if (fieldRef.field.isStructural) {
        fieldPKeyIndex++;
      }
    }
  }

  @override
  void unprepareForUpdates() {
    _pkey = PKey();

    for (var fieldRef in _fieldRefs) {
      fieldRef.field.unprepareForUpdates();
    }
  }

  /// Egests a full update from this primitive as a CborMap.
  @override
  CborMap egestFullCborMap() {
    Map<CborValue, CborValue> update = {};

    for (var field in _fieldRefs) {
      update[CborString(fieldnameFor(field.fkey))] =
          field.field.egestCborValue();
    }

    return CborMap(update);
  }

  /// Egests a partial update from this primitive as a CborMap.
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
  void ingestFullCborMap(CborMap cbor) {
    __cachedEmbodimentProperties = null;
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
        throw 'field ${k.toString()} not found for primitive of type $describeType';
      }

      field.ingestFullCborValue(item.value);
    }
  }

  @override
  void ingestPartialCborMap(CborMap cbor) {
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
        throw 'field ${k.toString()} not found for primitive of type $describeType';
      }

      if (fkey == fkeyEmbodiment) {
        __cachedEmbodimentProperties = null;
      }

      field.ingestPartialCborValue(item.value);
    }
  }

  @override
  bool get notPreparedYet => _pkey.isEmpty;

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

  @override
  Map<String, dynamic> get embodimentProperties {
    if (__cachedEmbodimentProperties != null) {
      return __cachedEmbodimentProperties!;
    }

    late String embodimentJson = embodiment.trim();

    if (embodimentJson.trim().isEmpty) {
      return const {};
    }

    __cachedEmbodimentProperties =
        jsonDecode(embodimentJson) as Map<String, dynamic>;

    return __cachedEmbodimentProperties!;
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
