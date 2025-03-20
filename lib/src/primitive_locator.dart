// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'primitive.dart';

abstract class PrimitiveLocator {
  Primitive? locatePrimitive(PKey pkey);
}
