// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'fkey.dart';
import 'blob_field.dart';
import 'primitive_base.dart';
import 'boolean_field.dart';
import 'string_field.dart';

/// A file represents a blob of data that can be exported from the server side and
/// stored to a file on the app side.  The perspective of "export" is centered around
/// the server software.  This seems to be a little clearer than using Download/Upload
/// terminology.
class ExportFile extends PrimitiveBase {
  ExportFile({super.embodiment, super.tag, String name = ''}) {
    _exported = BooleanField();
    _data = BlobField();
    _name = StringField.from(name);
  }

  // Field storage
  late BooleanField _exported;
  late BlobField _data;
  late StringField _name;

  @override
  String get describeType => 'ExportFile';

  @override
  void describeFields(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeyExported, _exported));
    fieldRefs.add(FieldRef(fkeyData, _data));
    fieldRefs.add(FieldRef(fkeyName, _name));
  }

  @override
  String toString() {
    return _name.value;
  }

  /// Clears the exported data and the exported flag.
  void reset() {
    _data.value = [];
    _exported.value = false;
  }

  /// True when the file has been exported (stored to a file) by the app.
  /// This field is normally only updated by the app.
  bool get exported => _exported.value;
  set exported(bool value) => _exported.value = value;

  /// The blob of data representing the binary contents of the file.  Note:  this
  /// data could be empty and yet represent a valid, albeit empty, file for export.
  List<int> get data => _data.value;
  set data(List<int> value) => _data.value = value;

  /// the suggested file name (including its extension separated by a period) to save the file as.
  String get name => _name.value;
  set name(String value) => _name.value = value;
}
