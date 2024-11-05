import 'pkey.dart';
import 'fkey.dart';
import 'primitive_model_watcher.dart';

/// Represents a pending update to a primitive.
class PrimitiveUpdate {
  PrimitiveUpdate(this.pkey, this.fields) : coalesced = false;

  /// PKey of the primitive being updated.
  final PKey pkey;

  /// Subset of fields being updated.
  late List<FKey> fields;

  /// True if this update will be coalesced with a parent update.
  late bool coalesced;

  /// Appends a field to the list of fields being updated.
  void appendField(FKey fkey) {
    for (var field in fields) {
      if (field == fkey) {
        return;
      }
    }
    fields.add(fkey);
  }
}

/// Base support for all Synchro objects.
class SynchroBase implements PrimitiveModelWatcher {
  SynchroBase(this.fieldFilter);

  // List of updates to be applied.
  final List<PrimitiveUpdate> pendingUpdates = [];

  /// Set of fields to filter updates by.  If this is null, all fields are tracked
  /// for updates.  If this is non-null, only fields in this list are tracked.
  final Set<FKey>? fieldFilter;

  @override
  void onFullModelUpdate() {
    clearPendingUpdates();
  }

  @override
  void onPartialModelUpdate() {}

  @override
  void onTopLevelPrimitiveUpdate() {}

  @override
  void onSetField(PKey pkey, FKey fkey, bool structural) {
    // Filtering by field?
    if (fieldFilter != null && !fieldFilter!.contains(fkey)) {
      return;
    }

    var existingUpdate = _findUpdate(pkey);
    if (existingUpdate != null) {
      existingUpdate.appendField(fkey);
    } else {
      var newUpdate = PrimitiveUpdate(pkey, [fkey]);
      pendingUpdates.add(newUpdate);
    }

    if (structural) {
      _ignoreDescendantUpdates(pkey);
    }
  }

  /// Clears all pending updates.
  void clearPendingUpdates() {
    pendingUpdates.clear();
  }

  /// Finds an update in the list of pending updates.
  PrimitiveUpdate? _findUpdate(PKey pkey) {
    for (var update in pendingUpdates) {
      if (update.pkey.isEqualTo(pkey)) {
        return update;
      }
    }
    return null;
  }

  /// Marks all updates descending from a given PKey as coalesced.
  void _ignoreDescendantUpdates(PKey pkey) {
    for (var update in pendingUpdates) {
      if (update.pkey.descendsFrom(pkey)) {
        update.coalesced = true;
      }
    }
  }
}
