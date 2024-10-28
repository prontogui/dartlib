import 'pkey.dart';
import 'primitive.dart';

abstract class PrimitiveLocator {
  Primitive? locatePrimitive(PKey pkey);
}
