import 'package:test/test.dart';
import 'package:app/key/fkey.dart';

void main() {
  test('Get a fieldname for an FKey #1.', () {
    var fieldname = fieldnameFor(3);
    expect(fieldname, equals("B.Embodiment"));
  });

  test('Get a fieldname for an FKey #2.', () {
    var fieldname = fieldnameFor(10);
    expect(fieldname, equals("Rows"));
  });

  test('Get an FKey for a fieldname #1.', () {
    var fkey = fkeyFor("Choices");
    expect(fkey, equals(7));
  });

  test('Get an FKey for a fieldname #2.', () {
    var fkey = fkeyFor("B.Row");
    expect(fkey, equals(1));
  });
}
