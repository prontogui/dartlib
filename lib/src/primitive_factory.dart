// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cbor/cbor.dart';
import 'pkey.dart';
import 'primitive.dart';
import 'primitive_base.dart';

import 'check.dart';
import 'choice.dart';
import 'command.dart';
import 'export_file.dart';
import 'frame.dart';
import 'group.dart';
import 'icon.dart';
import 'import_file.dart';
import 'list.dart';
import 'numericfield.dart';
import 'table.dart';
import 'text.dart';
import 'textfield.dart';
import 'timer.dart';
import 'tristate.dart';

typedef FactoryFunction = PrimitiveBase Function();

final Map<String, FactoryFunction> _factoryFunctions = {
  "Checked": () => Check(),
  "Content": () => Text(),
  "Choice": () => Choice(),
  "CommandIssued": () => Command(),
  "Exported": () => ExportFile(),
  "GroupItems": () => Group(),
  "FrameItems": () => Frame(),
  "ListItems": () => ListP(),
  "State": () => Tristate(),
  "TextEntry": () => TextField(),
  "Imported": () => ImportFile(),
  "Rows": () => Table(),
  "PeriodMs": () => Timer(),
  "NumericEntry": () => NumericField(),
  "IconID": () => Icon(),
};

/// The static object factory responsible for creating primitive-type objects.
abstract class PrimitiveFactory {
  /// Creates the appropriate primitive from the CBOR specification provide in [ctorArgs].
  static Primitive createPrimitiveFromCborMap(PKey pkey, CborMap cbor) {
    // Determine what primitive to create from the unique set of fields it holds.
    for (var key in cbor.keys) {
      if (key is! CborString) {
        throw Exception(
            'encountered a field key in CBOR map that is not a string.');
      }
      var found = _factoryFunctions[key.toString()];
      if (found != null) {
        var p = found.call();
        p.initializeFromCborMap(pkey, cbor);
        return p;
      }
    }

    throw Exception('primitive not recognized.');
  }
}
