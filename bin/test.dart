// Copyright 2025 ProntoGUI, LLC.
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

  void prompt() {
    stdout.write(': ');
  }

  prompt();

  stdin.transform(utf8.decoder).listen((input) {
    input = input.trim();
    if (input.isEmpty) {
      prompt();
      return;
    }

    try {
      var result = executeCommand(input, model);
      print(result.$1);

      if (result.$2) {
        exit(0);
      }
    } catch (e) {
      print('Error: $e');
    }
    prompt();
  });
}

var lastCommandLine = '';

(String, bool) executeCommand(String commandLine, PrimitiveModel model) {
  var cmdArgs = commandLine.split(' ');
  if (cmdArgs.isEmpty) {
    throw 'No command found';
  }

  void checkParameterCount(int count) {
    if (cmdArgs.length != count + 1) {
      throw 'Expected $count parameters, but got ${cmdArgs.length - 1}';
    }
  }

/*
  int integerParameter(int parameterIndex) {
    return int.parse(cmdArgs[parameterIndex + 1]);
  }
*/

  PKey pkeyParameter(int parameterIndex) {
    return PKey.fromIndicesString(cmdArgs[parameterIndex + 1]);
  }

  var command = cmdArgs[0];
  var returnString = '';
  var quit = false;

  // Implement command logic here.  Each command is handled as a separate case.
  // Each command returns a string to display on the console or throws an exception.
  switch (cmdArgs[0]) {
    case 'print':
      checkParameterCount(1);

      var p = model.locatePrimitive(pkeyParameter(0));

      if (p != null) {
        var text = p as Text;
        returnString = text.prettyPrint();
      } else {
        returnString = 'No primitive with PKey(0) found';
      }
    case 'exit':
    case 'quit':
    case 'q':
      quit = true;
      returnString = 'Goodbye!';
      break;
    case 'r':
      if (lastCommandLine.isNotEmpty) {
        return executeCommand(lastCommandLine, model);
      }
    case 'r?':
      return ('Last command is: "$lastCommandLine"', false);
    default:
      throw 'Unknown command: $command';
  }

  // Save the last successful command line
  lastCommandLine = commandLine;

  return (returnString, quit);
}
