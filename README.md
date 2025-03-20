# dartlib
Dart language library for programs to build user interfaces with ProntoGUI.

At present, this library only supports the client side of ProntoGUI communication channel.  It is imported by the App to handle communication and building/updating the primitive object model.

## Project Contents
This project consists of a sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and unit tests in `test/`.

## To add a new primitive
* Add the source file for the primitive, following existing patterns.
* Update primitive_factory.dart
* Update dartlib.dart to export the new primitive.

---
##### *Copyright 2025 ProntoGUI, LLC.*