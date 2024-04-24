import 'package:cbor/cbor.dart';

const invalidIndex = -1;

class PKey {
  PKey.fromCbor(CborValue v) {
    assert(v is CborList);
    var cborIndices = v as CborList;

    _indices = List<int>.generate(cborIndices.length,
        (index) => (cborIndices[index] as CborSmallInt).value,
        growable: false);
  }

  late List<int> _indices;

  List<int> indices() {
    return _indices;
  }
}

class PKeyLocator {
  PKeyLocator(this.pkey) : locationLevel = -1;

  final PKey pkey;
  int locationLevel;

  int nextIndex() {
    assert(locationLevel < (pkey.indices().length - 1));
    locationLevel++;
    return pkey.indices()[locationLevel];
  }

  bool located() {
    return locationLevel == (pkey.indices().length - 1);
  }
}
