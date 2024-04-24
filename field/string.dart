import 'field.dart';
import 'package:cbor/cbor.dart';
import 'field_support.dart';

class StringField with FieldSupport implements Field {
  StringField() : _s = "";

  String _s;

  String get() {
    return _s;
  }

  void set(String s) {
    _s = s;
  }

  @override
  void ingestValue(CborValue value) {}

  @override
  CborValue egestValue() {
    return const CborNull();
  }
}
