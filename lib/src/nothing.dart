// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'primitive_base.dart';

// This was originally created as a valid primitive for Tree:nodeItem when null is used in
// its constructor, and for locating descendant primitives.

/// A primitive that represents nothing.
class Nothing extends PrimitiveBase {
  Nothing({super.embodiment, super.tag}) {}

  @override
  String get describeType => 'Nothing';

  @override
  void describeFields(List<FieldRef> fieldRefs) {}

  @override
  String toString() {
    return '';
  }
}
