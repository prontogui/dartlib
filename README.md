A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

## To add a new primitive
* Add the source file for the primitive, following existing patterns.
* Update primitive_factory.dart
* Update dartlib.dart to export the new primitive.
