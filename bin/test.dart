// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//import 'package:dartlib/dartlib.dart' as dartlib;
import 'dart:io';
import 'dart:convert';
import 'package:dartlib/dartlib.dart';

void main(List<String> arguments) {
  print('Hello world, it\'s Dartlib!');

  var model = PrimitiveModel();
  var text = Text(content: 'Hello, Dartlib!');
  model.topPrimitives = [text];

  stdin.transform(utf8.decoder).listen((input) {
    input = input.trim();
    if (input.isEmpty) return;

    try {
      var result = executeCommand(input, model);
      print(result);
    } catch (e) {
      print('Error: $e');
    }
  });
}

String executeCommand(String command, PrimitiveModel model) {
  // Implement your command logic here
  // For example, you can add simple commands like 'echo', 'reverse', etc.
  if (command.startsWith('print ')) {
    var p = model.locatePrimitive(PKey(0));
    if (p != null) {
      var text = p as Text;
      return text.content;
    } else {
      return 'No primitive with PKey(0) found';
    }
  } else if (command == 'reverse') {
    return command.split('').reversed.join('');
  } else {
    throw 'Unknown command: $command';
  }
}
