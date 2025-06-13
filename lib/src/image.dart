// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:typed_data';

import 'package:dartlib/dartlib.dart';
import 'references.dart';
import 'primitive_base.dart';
import 'blob_field.dart';
import 'string_field.dart';
import 'field_hooks.dart';

/// An image to display on the screen.  [fromFile] is the path to a file containing the image data.ArgumentError
/// The image can obtain its data from another Image in the primitive tree by specifying [ref], which is the ID 
/// assigned to the image.  You can assign [id] if you intend to reference this image's data in another
/// Image primitive elsewhere.
class Image extends PrimitiveBase {
  Image({super.embodiment, super.tag, String? fromFile, String id = '', String ref = ''}) {
    if (fromFile != null) {
      _image = BlobField.fromFile(fromFile);
    } else {
      _image = BlobField();
    }
    _id = StringField.from(id);
    _ref = StringField.from(ref);
  }

  // Field storage
  late BlobField _image;
  late StringField _id;
  late StringField _ref;

  // Internal variables
  PrimitiveRef? _targetRef;
  PrimitiveLocator? _locator;

  @override
  String get describeType => 'Image';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyID, _id));
    fieldRefs.add(FieldRef(fkeyImage, _image));
    fieldRefs.add(FieldRef(fkeyRef, _ref));
  }

  @override
  void prepareForUpdates(PKey pkey, FieldHooks fieldHooks, PrimitiveLocator locator) {
    super.prepareForUpdates(pkey, fieldHooks, locator);

    _locator = locator;

    // Any referencing going on?
    if (id.isNotEmpty) {
      _targetRef = References().defineTarget(id, pkey);
    }
  }

  @override
  void unprepareForUpdates() {
    super.unprepareForUpdates();

    var targetRef = _targetRef;
    if (targetRef != null) {
      References().undefineTarget(targetRef);
    }
    _targetRef = null;
    _locator = null;
  }

  @override
  String toString() {
    return '';
  }

  static final _emptyImage = Uint8List.fromList([]);

  /// The image data.  If there is no image data available then an empty list is returned.
  Uint8List get image {
    
    if (_image.value.isNotEmpty) {
      return _image.value;
    }

    var imageRef = ref;

    if (imageRef.isNotEmpty) {
      var p = References().dereference(imageRef, _locator!);

      // Reference primitive must be an Image and must not reference another Image
      // (this avoids cyclic references)
      if (p != null && p is Image && p.ref.isEmpty) {
        return p.image;
      }
    }
    
    return _emptyImage;
  }

  set image(Uint8List value) {
    _image.value = value;
  }

  /// Optional ID assigned to this primitive.
  String get id {
    return _id.value;
  }

  set id(String value) {
    _id.value = value;
  }

  /// Reference (ID) to a primitive that holds the actual image data.
  String get ref {
    return _ref.value;
  }

  set ref(String value) {
    _ref.value = value;
  }
}
