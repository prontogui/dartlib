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

/// An image to display on the screen.
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
  late int _refNo;
  late PKey? _refImagePkey;
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

    // Any referencing going on?
    if (id.isNotEmpty) {
      References().defineTarget(id, pkey);
    }
    if (ref.isNotEmpty) {
      _refNo = References().reference(ref, (pkey) {
        _refImagePkey = pkey;
      });

      _locator = locator;
    }
  }

  @override
  void unprepareForUpdates() {
    super.unprepareForUpdates();

    // Any referencing going on?
    if (id.isNotEmpty) {
      References().undefineTarget(id);
    }
    if (ref.isNotEmpty) {
      References().dereference(ref, _refNo);
    }

    _refNo = References.invalidRefNo;
    _refImagePkey = null;
    _locator = null;
  }

  @override
  String toString() {
    return '';
  }

  static final _emptyImage = Uint8List.fromList([]);

  /// The image data
  Uint8List get image {
    if (_image.value.isNotEmpty) {
      return _image.value;
    }

    if (_refImagePkey != null) {
      var p = _locator!.locatePrimitive(_refImagePkey!);
      if (p != null && p is Image) {
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
