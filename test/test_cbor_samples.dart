// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';

CborMap cborEmpty() {
  return CborMap({});
}

CborMap cborForCommand(String label, int status) {
  return CborMap({
    CborString('CommandIssued'): const CborBool(false),
    CborString('Label'): CborString(label),
    CborString('Status'): CborSmallInt(status),
  });
}

CborMap partialCborForText(String content) {
  return CborMap({
    CborString('Content'): CborString(content),
  });
}

CborMap cborForCommandAsOutlined() {
  return CborMap({
    CborString('CommandIssued'): const CborBool(false),
    CborString('Status'): const CborSmallInt(0),
    CborString('Embodiment'): CborString('outlined-button'),
  });
}

CborMap cborForCheck(String label) {
  return CborMap({
    CborString('Checked'): const CborBool(true),
    CborString('Label'): CborString(label),
  });
}

CborMap cborForChoice() {
  return CborMap({
    CborString('Choice'): CborString('A'),
    CborString('Choices'): CborList([CborString('A'), CborString('B')]),
  });
}

CborMap cborForFrame() {
  var cmd1 = cborForCommand('Press Me!', 0);
  var cmd2 = cborForCommand('Click Here! (disable)', 1);

  return CborMap({
    CborString('FrameItems'): CborList([cmd1, cmd2]),
  });
}

CborMap cborForGroup() {
  var cmd1 = cborForCommand('Press Me!', 0);
  var cmd2 = cborForCommand('Click Here! (disable)', 1);

  return CborMap({
    CborString('GroupItems'): CborList([cmd1, cmd2]),
  });
}

CborList cborForAny1DField() {
  var cmd1 = cborForCommand('Press Me!', 0);
  var cmd2 = cborForCommand('Click Here! (disable)', 1);

  return CborList([cmd1, cmd2]);
}

CborMap cborForList() {
  return CborMap({
    CborString('ListItems'): cborForAny1DField(),
    CborString('Selected'): const CborSmallInt(1),
  });
}

CborList cborForAny2DField() {
  var cmdR0C0 = cborForCommand('Press Me!', 0);
  var cmdR0C1 = cborForCommand('Click Here! (disable)', 1);
  var cmdR1C0 = cborForCommand('STOP', 2);
  var cmdR1C1 = cborForCommand('START', 2);

  var row0 = CborList([cmdR0C0, cmdR0C1]);
  var row1 = CborList([cmdR1C0, cmdR1C1]);

  return CborList([row0, row1]);
}

CborMap cborForEmptyEmbodiment() {
  return CborMap({
    CborString('Embodiment'): CborString(''),
  });
}

CborMap cborForEmptyWhitespaceEmbodiment() {
  return CborMap({
    CborString('Embodiment'): CborString('   '),
  });
}

CborMap cborForSimplifiedEmbodiment() {
  return CborMap({
    CborString('Embodiment'): CborString('down-and-dirty'),
  });
}

CborMap cborForComplexEmbodiment() {
  return CborMap({
    CborString('Embodiment'): CborString('''
{
  "embodiment":"fancy-look-and-feel",
  "layoutMethod":"flow",
  "flowDirection":"LTR"
}
'''),
  });
}

CborMap cborForTable() {
  return CborMap({
    CborString('Rows'): cborForAny2DField(),
  });
}

CborMap distinctCborForCommand() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('CommandIssued'): const CborBool(false),
  });
}

CborMap distinctCborForGroup() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('GroupItems'): CborList([]),
  });
}

CborMap distinctCborForFrame() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('FrameItems'): CborList([]),
  });
}

CborMap distinctCborForText() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Content'): CborString('Excepteur sint occaecat cupidatat'),
  });
}

CborMap distinctCborForChoice() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Choice'): CborString(''),
  });
}

CborMap distinctCborForCheck() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Checked'): const CborBool(false),
  });
}

CborMap distinctCborForTristate() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('State'): const CborSmallInt(0),
  });
}

CborMap distinctCborForList() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('ListItems'): CborList([]),
  });
}

CborMap distinctCborForTextField() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('TextEntry'): CborString(''),
  });
}

CborMap distinctCborForExportFile() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Exported'): const CborBool(true),
  });
}

CborMap distinctCborForImportFile() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Imported'): const CborBool(true),
  });
}

CborMap distinctCborForTable() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('Rows'): CborList([]),
  });
}

CborMap distinctCborForTimer() {
  return CborMap({
    // Only specify the Distinct Primitive Field
    CborString('PeriodMs'): const CborSmallInt(200),
  });
}
