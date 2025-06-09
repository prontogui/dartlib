// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:typed_data';

import 'fkey.dart';
import 'primitive_base.dart';
import 'blob_field.dart';

/// An image to display on the screen.
class Image extends PrimitiveBase {
  Image({super.embodiment, super.tag, String fromFile = ''}) {
    if (fromFile.isNotEmpty) {
      _image.loadFromFile(fromFile);
    }
  }

  // Field storage
  late BlobField _image;

  @override
  String get describeType => 'Image';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyImage, _image));
  }

  @override
  String toString() {
    return '';
  }

  /// The Material ID of the icon to use.
  Uint8List get image => _image.value;
  set image(Uint8List value) {
    _image.value = value;
  }
}
