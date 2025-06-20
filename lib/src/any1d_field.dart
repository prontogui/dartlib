// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_base.dart';
import 'primitive.dart';
import 'fkey.dart';
import 'pkey.dart';
import 'field_hooks.dart';
import 'primitive_factory.dart';
import 'primitive_locator.dart';

/// A field that holds a one-dimensional array of primitives.
class Any1DField extends FieldBase implements Field {
  Any1DField() : _pa = List<Primitive>.unmodifiable([]), super.structural();

  Any1DField.from(List<Primitive> pa) : _pa = List<Primitive>.unmodifiable(pa);

  /// Storage of this field's value.
  late List<Primitive> _pa;

  /// The value of this field.  When setting the value, a copy of the input
  /// list is made.  When getting the value, a copy of the internal list is
  /// returned.
  List<Primitive> get value => _pa;
  set value(List<Primitive> pa) {
    _unprepareDescendantsForUpdates();
    _pa = List<Primitive>.unmodifiable(pa);
    _prepareDescendantsForUpdates();
    onSet();
  }

  @override
  bool get isStructural => true;

  /// The primitive locator
  PrimitiveLocator? _locator;

  // Implement Field interface

  // Override the default implementation to prepare the descendant primitives.
  @override
  bool prepareForUpdates(
      FKey fkey, PKey pkey, int fieldPKeyIndex, FieldHooks fieldHooks, PrimitiveLocator locator) {
    super.prepareForUpdates(fkey, pkey, fieldPKeyIndex, fieldHooks, locator);
    _locator = locator;
    _prepareDescendantsForUpdates();
    return isStructural;
  }

  /// Prepare descendant primitives for updates.
  void _prepareDescendantsForUpdates() {
    // Short circuit for the case where the primitives are being used in freestyle fashion.
    // That is, they are participating in a model yet and hence we aren't trackig updates.
    if (notPreparedYet) {
      return;
    }

    // Prepare each individual descendant primitives for updates

    var fieldPKey = PKey.fromPKey(pkey, fieldPKeyIndex);

    for (var i = 0; i < _pa.length; i++) {
      // Add another level representing the array index of primitive
      _pa[i].prepareForUpdates(PKey.fromPKey(fieldPKey, i), fieldHooks!, _locator!);
    }
  }

  void _unprepareDescendantsForUpdates() {
    for (var i = 0; i < _pa.length; i++) {
      _pa[i].unprepareForUpdates();
    }
  }

  @override
  void ingestFullCborValue(CborValue value) {
    _ingest(value);
  }

  @override
  void ingestPartialCborValue(CborValue value) {
    _ingest(value);
    onIngest();
  }

  void _ingest(CborValue value) {
    if (value is! CborList) {
      throw Exception(
          'Any1DField:ingestFullCborValue - value is not a CborList');
    }

    var newArray = List<Primitive>.generate(value.length, (index) {
      var cbor = value.elementAt(index);

      if (cbor is! CborMap) {
        throw Exception('element is not a CborMap');
      }

      return PrimitiveFactory.createPrimitiveFromCborMap(
          PKey.fromPKey(pkey, index), cbor);
    });

    _unprepareDescendantsForUpdates();
    _pa = List<Primitive>.unmodifiable(newArray);
    _prepareDescendantsForUpdates();
  }

  @override
  CborValue egestCborValue() {
    var update = <CborValue>[];

    for (var p in _pa) {
      update.add(p.egestFullCborMap());
    }

    return CborList(update);
  }

  // Object overrides

  @override
  String toString() {
    if (_pa.isEmpty) {
      return '<Empty>';
    }

    return 'Array [${_pa.length} primitives] with types: ${List<String>.generate(_pa.length, (index) => _pa[index].describeType).join(', ')}';
  }
}
