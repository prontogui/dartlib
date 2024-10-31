// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:dartlib/src/strings1d_field.dart';

import 'fkey.dart';
import 'blob_field.dart';
import 'primitive_base.dart';
import 'boolean_field.dart';
import 'string_field.dart';

/// A file that represents a blob of data that can be imported from the app side
/// and consumed on the server side.
class ImportFile extends PrimitiveBase {
  ImportFile(
      {super.embodiment,
      super.tag,
      String name = '',
      List<String> validExtensions = const []}) {
    _imported = BooleanField();
    _data = BlobField();
    _name = StringField.from(name);
    _validExtensions = Strings1DField.from(validExtensions);
  }

  // Field storage
  late BooleanField _imported;
  late BlobField _data;
  late StringField _name;
  late Strings1DField _validExtensions;

  @override
  String get describeType => 'ImportFile';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyImported, _imported));
    fieldRefs.add(FieldRef(fkeyData, _data));
    fieldRefs.add(FieldRef(fkeyName, _name));
    fieldRefs.add(FieldRef(fkeyValidExtensions, _validExtensions));
  }

  @override
  String toString() {
    return _name.value;
  }

  /// Clears the exported data and the imported flag.
  void reset() {
    _data.value = [];
    _imported.value = false;
  }

  /// Returns true when the file has been imported by the app side and signals to the server
  /// side that file is ready to processs.  This field is normally only updated by the app.
  bool get imported => _imported.value;
  set imported(bool value) => _imported.value = value;

  /// The blob of data representing the binary contents of the file.  Note:  this
  /// data could be empty and yet represent a valid, albeit empty, file for export.
  List<int> get data => _data.value;
  set data(List<int> value) => _data.value = value;

  /// the suggested file name (including its extension separated by a period) to save the file as.
  String get name => _name.value;
  set name(String value) => _name.value = value;

  /// The list of valid file extensions that the file can be saved as.
  List<String> get validExtensions => _validExtensions.value;
  set validExtensions(List<String> value) => _validExtensions.value = value;
}
