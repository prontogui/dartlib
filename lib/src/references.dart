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

/*


class References {
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

  // Add your methods and properties here

  static const invalidRefNo = -1;

  // The maximum reference possible before it rolls over
  late final int _maxRefNo;

  // The last issued reference 
  int _lastRefNo = -1;

  // Returns a new, guaranteed unused reference number.
  int _newRefNo() {

    // Will next ref rollover?
    if (_lastRefNo == _maxRefNo) {
      throw StateError('No more references are possible.');
    }
    return ++_lastRefNo;
  }

  // Current references from each target identified by its ID to its assigned PKey.
  final Map<String, PKey> _refs = {};

  // Late references and callbacks for each target to be defined later.  This maps
  // a target's ID to another map of reference number to callbacks.
  final Map<String, Map<int, Function(PKey)>> _lateRefs = {};

  // Checks whether we can reset the last reference number if there no late 
  // references pending.
  void _checkToResetLastRef() {
    if (_lateRefs.isEmpty) {
      _lastRefNo = invalidRefNo;
    }
  }

  /// Defines a new reference target identified by [refID] and located by [pkey].  If
  /// there are late references to this target then it calls back on each reference
  /// with the pkey.
  void defineTarget(String refID, PKey pkey) {
    // Any late references for this ID?
    if (_lateRefs.containsKey(refID)) {

      // Callback each late reference
      for (var entry in _lateRefs[refID]!.entries) {
        entry.value(pkey);
      }

      // Remove late references
      _lateRefs.remove(refID);
      _checkToResetLastRef();
    }
    // Map this ID to supplied pkey
    _refs[refID] = pkey;
  }

  /// Undefines a target reference identified by [refID].
  void undefineTarget(String refID) {
    // Assert there are no late references for this ID
    assert(!_lateRefs.containsKey(refID));

    // Unmap this ID
    _refs.remove(refID);
  }

  /// References a target primitive identified by [refID] (the primmitive with matching ID value).
  /// If the target primitive is not defined yet then it saves a "late reference" to be clear up
  /// later when the target primitive is made ready.
  int reference(String refID, Function(PKey) refReturn) {
    // Is ID mapped to a PKey?
    var existingRef = _refs[refID];
    if (existingRef != null) {
      // Callback immediately
      refReturn(existingRef);

      // Return invalid refNo
      return invalidRefNo;
    }

    // Add a late reference with callback 
    var refNo = _newRefNo();

    var existingLateRef = _lateRefs[refID];
    if (existingLateRef != null) {
      existingLateRef[refNo] = refReturn;  
    } else {
      _lateRefs[refID] = <int, Function(PKey)>{refNo:refReturn};
    }

    return refNo;
  }

  /// Dereferences a target primitive identified by [refID] and with 
  void dereference(String refID, int refNo) {
    // If invalid refNo then return
    if (refNo == invalidRefNo) {
      return;
    }

    // Remove any late reference associated with this
    var existingLateRef = _lateRefs[refID];
    if (existingLateRef != null) {
      existingLateRef.remove(refNo);
      _checkToResetLastRef();
    }
  }

  @visibleForTesting
  void resetState() {
      _refs.clear();
      _lateRefs.clear();
      _lastRefNo = References.invalidRefNo;
  }

  @visibleForTesting
  int get maxRefNo => _maxRefNo;

  @visibleForTesting
  int get lastRefNo => _lastRefNo;

  @visibleForTesting
  set lastRefNo(int refNo) {
    _lastRefNo = refNo;
  }

  @visibleForTesting
  Map<String, PKey> get refs => _refs;

  @visibleForTesting
  Map<String, Map<int, Function(PKey)>> get lateRefs => _lateRefs;

  @visibleForTesting
  void checkToResetLastRef() => _checkToResetLastRef();
}


*/
