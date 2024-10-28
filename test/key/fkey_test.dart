// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:dartlib/src/fkey.dart';

void main() {
  test('Get a fieldname for an fkeyChecked.', () {
    var fieldname = fieldnameFor(fkeyChecked);
    expect(fieldname, equals('Checked'));
  });

  test('Get a fieldname for an fkeyImported.', () {
    var fieldname = fieldnameFor(fkeyImported);
    expect(fieldname, equals('Imported'));
  });

  test('Get a fieldname for an fkeyValidExtensions.', () {
    var fieldname = fieldnameFor(fkeyValidExtensions);
    expect(fieldname, equals('ValidExtensions'));
  });

  test('Get a fieldname for an invalid FKey.', () {
    var fieldname = fieldnameFor(254);
    expect(fieldname, equals(invalidFKey));
  });

  test('Get an FKey for Tag.', () {
    var fkey = fkeyFor('Tag');
    expect(fkey, equals(fkeyTag));
  });

  test('Get an FKey for Headings.', () {
    var fkey = fkeyFor('Headings');
    expect(fkey, equals(fkeyHeadings));
  });

  test('Get an FKey for Checked.', () {
    var fkey = fkeyFor('Checked');
    expect(fkey, equals(fkeyChecked));
  });

  test('Get an FKey for an invalid field name.', () {
    var fkey = fkeyFor('INVALID FIELD NAME');
    expect(fkey, equals(invalidFieldName));
  });
}
