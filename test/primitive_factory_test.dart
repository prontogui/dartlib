// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:test/test.dart';
import 'package:dartlib/src/primitive_factory.dart';
import 'package:dartlib/src/pkey.dart';
import 'package:dartlib/src/check.dart';
import 'package:dartlib/src/choice.dart';
import 'package:dartlib/src/command.dart';
import 'package:dartlib/src/export_file.dart';
import 'package:dartlib/src/frame.dart';
import 'package:dartlib/src/group.dart';
import 'package:dartlib/src/import_file.dart';
import 'package:dartlib/src/list.dart';
import 'package:dartlib/src/table.dart';
import 'package:dartlib/src/text.dart';
import 'package:dartlib/src/textfield.dart';
import 'package:dartlib/src/timer.dart';
import 'package:dartlib/src/tristate.dart';
import 'test_cbor_samples.dart';

void main() {
  final pkey = PKey(1);

  test('Create a Check primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForCheck());
    expect(p, isA<Check>());
    expect(p.describeType, equals('Check'));
  });

  test('Create a Choice primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForChoice());
    expect(p, isA<Choice>());
    expect(p.describeType, equals('Choice'));
  });

  test('Create a Command primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForCommand());
    expect(p, isA<Command>());
    expect(p.describeType, equals('Command'));
  });

  test('Create an ExportFile primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForExportFile());
    expect(p, isA<ExportFile>());
    expect(p.describeType, equals('ExportFile'));
  });

  test('Create a Frame primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForFrame());
    expect(p, isA<Frame>());
    expect(p.describeType, equals('Frame'));
  });

  test('Create a Group primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForGroup());
    expect(p, isA<Group>());
    expect(p.describeType, equals('Group'));
  });

  test('Create an ImportFile primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForImportFile());
    expect(p, isA<ImportFile>());
    expect(p.describeType, equals('ImportFile'));
  });

  test('Create a ListP primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForList());
    expect(p, isA<ListP>());
    expect(p.describeType, equals('ListP'));
  });

  test('Create a Table primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForTable());
    expect(p, isA<Table>());
    expect(p.describeType, equals('Table'));
  });

  test('Create a Text primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForText());
    expect(p, isA<Text>());
    expect(p.describeType, equals('Text'));
  });

  test('Create a TextField primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForTextField());
    expect(p, isA<TextField>());
    expect(p.describeType, equals('TextField'));
  });

  test('Create a Timer primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForTimer());
    expect(p, isA<Timer>());
    expect(p.describeType, equals('Timer'));
  });

  test('Create a Tristate primitive.', () {
    var p = PrimitiveFactory.createPrimitiveFromCborMap(
        pkey, distinctCborForTristate());
    expect(p, isA<Tristate>());
    expect(p.describeType, equals('Tristate'));
  });
}
