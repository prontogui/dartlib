import 'package:cbor/cbor.dart';
import 'synchro_base.dart';
import 'pkey.dart';

import 'primitive.dart';
import 'primitive_locator.dart';

/// Tracks update to a primitive model and produces full or partial updates
/// which are ready for sending over a communication link.
class UpdateSynchro extends SynchroBase {
  UpdateSynchro(
      this.locator, super.fieldFilter, super.trackOnIngest, super.trackOnSet);

  /// The object used to locate a primitive in the model.
  PrimitiveLocator locator;

  /// Get a partial update based on pending updates tracked so far.
  /// The pending updates are cleared.
  CborList getPartialUpdate() {
    var updateList = List<CborValue>.empty(growable: true);

    // Protocol says:  first item is false, indicating a partial update.
    updateList.add(const CborBool(false));

    // For every pending update...
    for (var update in pendingUpdates) {
      if (update.coalesced) {
        continue;
      }

      var p = locator.locatePrimitive(update.pkey);
      assert(p != null);

      updateList.add(update.pkey.toCbor());
      updateList.add(p!.egestPartialCborMap(update.fields));
    }

    clearPendingUpdates();

    return CborList(updateList);
  }

  /// Gets a full update consisting of all top-level primitives.
  CborList getFullUpdate() {
    var updateList = List<CborValue>.empty(growable: true);

    // Protocol says:  first item is true, indicating a full update.
    updateList.add(const CborBool(true));

    var i = 0;

    // Scan list of top-level primitives (where PKey = [i])
    Primitive? next;
    while (true) {
      next = locator.locatePrimitive(PKey(i++));
      if (next == null) {
        break;
      }
      updateList.add(next.egestFullCborMap());
    }

    clearPendingUpdates();

    return CborList(updateList);
  }
}
