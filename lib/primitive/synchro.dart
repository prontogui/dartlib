import '../key/pkey.dart';
import '../key/fkey.dart';

import 'primitive_model_watcher.dart';

class PrimitiveUpdate {
  PrimitiveUpdate(this.pkey, this.fields) : ignored = false;

  final PKey pkey;
  late List<FKey> fields;
  late bool ignored;

  void appendField(FKey fkey) {
    for (var field in fields) {
      if (field == fkey) {
        return;
      }
    }
    fields.add(fkey);
  }
}

// Base support for all Synchro objects.
class SynchroBase implements PrimitiveModelWatcher {
  // List of updates to be applied.
  final List<PrimitiveUpdate> _pendingUpdates = [];

  @override
  void onFullModelUpdate() {}

  @override
  void onTopLevelPrimitiveUpdate() {}

  @override
  void onSetField(PKey pkey, FKey fkeu, bool structural) {}

  PrimitiveUpdate? _findUpdate(PKey pkey) {
    for (var update in _pendingUpdates) {
      if (update.pkey.isEqualTo(pkey)) {
        return update;
      }
    }
    return null;
  }

  void _ignoreDescendantUpdates(PKey pkey) {
    for (var update in _pendingUpdates) {
      if (update.pkey.descendsFrom(pkey)) {
        update.ignored = true;
      }
    }
  }
}
