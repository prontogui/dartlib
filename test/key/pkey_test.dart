import 'package:test/test.dart';
import 'package:app/key/pkey.dart';
import 'package:cbor/cbor.dart';

CborValue buildSamplePkey() {
  return CborList([
    const CborSmallInt(1),
    const CborSmallInt(5),
    const CborSmallInt(23),
  ]);
}

void main() {
  test('Construct from CBOR.', () {
    final pkey = PKey.fromCbor(buildSamplePkey());
    expect(pkey.indices().length, equals(3));
    expect(pkey.indices()[0], equals(1));
    expect(pkey.indices()[1], equals(5));
    expect(pkey.indices()[2], equals(23));
  });
}
