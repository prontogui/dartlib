import 'pkey.dart';
import 'primitive.dart';
import 'primitive_locator.dart';
import 'package:meta/meta.dart';

typedef PrimitiveRef = (String, int, PKey);

class References {

  /* BEGIN OF SINGLETON BOILERPLATE CODE */

  // Private constructor
  References._internal() {
    if (identical(1.0, 1)) {
      _maxRefNo = 9007199254740991; // 2^53 - 1, max safe integer for double
    } else {
      _maxRefNo = 0x7FFFFFFFFFFFFFFF;  // 2^63 - 1, max 64-bit integer
    }
  }

  // The single instance of References
  static final References _instance = References._internal();

  // Factory constructor to return the same instance
  factory References() {
    return _instance;
  }
  /* END OF SINGLETON BOILERPLATE CODE */

  static const _initialRefNo = -1;

  // The maximum reference possible before it rolls over
  late final int _maxRefNo;

  // The last issued reference 
  int _lastRefNo = _initialRefNo;

  // Returns a new, guaranteed unused reference number.
  int _newRefNo() {

    // Will next ref rollover?
    if (_lastRefNo == _maxRefNo) {
      throw StateError('No more references are possible.');
    }
    return ++_lastRefNo;
  }

  // Current references from each targe. This maps the ref ID string
  // to a list of tuples.  Each tuple represents a (refNo, PKey) assigned
  // during a single call to defineTarget.
  final Map<String, List<PrimitiveRef>> _refs = {};

  // Checks whether we can reset the last reference number if there no late 
  // references pending.
  void _checkToResetLastRef() {
    if (_refs.isEmpty) {
      _lastRefNo = _initialRefNo;
    }
  }

  /// Defines a new reference target identified by [refID] and located by [pkey].  Returns
  /// a unique number [refNo] representing the target reference.
  PrimitiveRef defineTarget(String refID, PKey pkey) {

    var newRef = (refID, _newRefNo(), pkey);

    var existing = _refs[refID];
    if (existing != null) {
      existing.add(newRef);
    } else {
      _refs[refID] = [newRef];
    }

    return newRef;
  }

  /// Undefines a target reference identified by [refID].
  void undefineTarget(PrimitiveRef ref) {
    var origRefID = ref.$1;

    var existing = _refs[origRefID];
    if (existing != null) {
      // Most of the time....
      if (existing.length == 1) {
        _refs.remove(origRefID);
      } else {
        existing.remove(ref);
      }
    }

    _checkToResetLastRef();
  }

  void undefineAllTargets() {
    _refs.clear();
    _checkToResetLastRef();
  }

  /// Dereferences a target primitive identified by [refID] (the primmitive with matching ID value).
  /// Returns a PKey to the target or null if target not found.
  Primitive? dereference(String refID, PrimitiveLocator locator) {
    // Is ID mapped to a PKey?
    var existing = _refs[refID];
    if (existing != null) {
      // Return the last defined target for this refID
      return locator.locatePrimitive(existing.last.$3);
    }
    return null;
  }

  @visibleForTesting
  void resetState() {
      _refs.clear();
      _lastRefNo = References._initialRefNo;
  }
}
