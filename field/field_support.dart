import '../key/pkey.dart';
import '../key/fkey.dart';
import 'onset.dart';

mixin FieldSupport {
  late PKey _pkey;
  late FKey _fkey;
  late OnsetFunction? _onset;

  void onSet(bool structural) {
    if (_onset != null) {
      _onset!(_pkey, _fkey, structural);
    }
  }
}
