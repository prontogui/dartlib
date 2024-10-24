// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';

const invalidIndex = -1;

// A path of integers used to locate a Primitive in the model.
class PKey {
  late List<int> _indices;

  // Create a PKey from supplied integers.
  PKey(
      [int? i0,
      int? i1,
      int? i2,
      int? i3,
      int? i4,
      int? i5,
      int? i6,
      int? i7]) {
    _indices = [];

    if (i0 != null) {
      _indices.add(i0);
    }
    if (i1 != null) {
      _indices.add(i1);
    }
    if (i2 != null) {
      _indices.add(i2);
    }
    if (i3 != null) {
      _indices.add(i3);
    }
    if (i4 != null) {
      _indices.add(i4);
    }
    if (i5 != null) {
      _indices.add(i5);
    }
    if (i6 != null) {
      _indices.add(i6);
    }
    if (i7 != null) {
      _indices.add(i7);
    }
  }

  // Create a PKey from a list of indices in a CborList.
  PKey.fromCbor(CborValue v) {
    assert(v is CborList);
    var cborIndices = v as CborList;

    _indices = List<int>.generate(cborIndices.length,
        (index) => (cborIndices[index] as CborSmallInt).value,
        growable: false);
  }

  // Create a PKey from the supplied indices.
  PKey.fromIndices(List<int> indices) {
    _indices = List<int>.from(indices);
  }

  // The list of indices in the PKey.
  List<int> get indices {
    return _indices;
  }

  // Return true if this PKey is equal to the other PKey.
  bool isEqualTo(PKey other) {
    if (_indices.length != other._indices.length) {
      return false;
    }

    for (var i = 0; i < _indices.length; i++) {
      if (_indices[i] != other._indices[i]) {
        return false;
      }
    }

    return true;
  }

  // Returns a new PKey with the supplied index added to the end.
  PKey addLevel(int index) {
    var newIndices = List<int>.from(_indices);
    newIndices.add(index);
    return PKey.fromIndices(newIndices);
  }

  // Returns true if this PKey descends from the other PKey.
  bool descendsFrom(PKey other) {
    if (_indices.length <= other._indices.length) {
      return false;
    }

    for (var i = 0; i < other._indices.length; i++) {
      if (_indices[i] != other._indices[i]) {
        return false;
      }
    }
    return true;
  }

  // Returns the index at supplied level.
  int indexAtLevel(int level) {
    if (level >= 0 && level < _indices.length) {
      return _indices[level];
    } else {
      return invalidIndex;
    }
  }

  // Returns the number of levels in the PKey.
  int get length {
    return _indices.length;
  }
}

// A helper class to locate a Primitive in the model.
class PKeyLocator {
  PKeyLocator(this.pkey) : locationLevel = -1;

  // The PKey being located.
  final PKey pkey;

  // The current level of the locator.
  late int locationLevel;

  // Advance the level and return the index at that level.
  int nextIndex() {
    assert(locationLevel < (pkey.indices.length - 1));
    locationLevel++;
    return pkey.indices[locationLevel];
  }

  // Return true if the locator is at the last level and therefore
  // primitive hase been located.
  bool located() {
    return locationLevel == (pkey.indices.length - 1);
  }
}
