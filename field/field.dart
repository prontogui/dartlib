import 'package:cbor/cbor.dart';

abstract interface class Field {
  void ingestValue(CborValue value);
  CborValue egestValue();
}
