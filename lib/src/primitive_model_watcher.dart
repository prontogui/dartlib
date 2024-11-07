// Copyright 2024 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'pkey.dart';
import 'fkey.dart';

// Interface for objects that watch the model.
abstract class PrimitiveModelWatcher {
  void onFullModelUpdate();
  void onBeginPartialModelUpdate();
  void onPartialModelUpdate();
  void onTopLevelPrimitiveUpdate();
  void onSetField(PKey pkey, FKey fkey, bool structural);
}
