/*
import '../src/fkey.dart';
import '../src/primitive_base.dart';
import '../src/strings1d_field.dart';
import 'dart:convert';

/// Implements the SubEmbodiments field for various primitives.
mixin SubEmbodiments {
  /// The SubEmbodiments stored in canonical form.
  final _subEmbodiments = Strings1DField.from(const []);

  /// Cached sub-embodiment properties.  These are built on demand and cleared when
  /// SubEmbodiements is reassigned.  If embodiment is empty then this value remains null.
  Map<int, Map<String, dynamic>>? __cachedSubEmbodimentProperties;

  void initializeSubEmbodiments(List<String> subEmbodiments) {
    // Use the field setter to make sure the embodiments are stored in canonical form
    this.subEmbodiments = subEmbodiments;
  }

  void describeSubEmbodimentsField(List<FieldRef> fieldRefs) {
    fieldRefs.add(FieldRef(fkeySubEmbodiments, _subEmbodiments));
  }

  void clearCachedSubEmbodiments() {
    __cachedSubEmbodimentProperties = null;
  }

  /// The sub-embodiments to use for rendering the primitive's items.
  ///
  /// Setting these embodiments is done using an array of: a JSON string,
  /// a simple assignment of embodiment type, or a simplified key-value pair string.
  ///
  /// This will always return an array of JSON strings, the canonical representation
  /// of the embodiments, regardless of how it was set.
  List<String> get subEmbodiments => _subEmbodiments.value;
  set subEmbodiments(List<String> subEmbodiments) {
    // In any case, clear the cached sub-embodiments properties.
    clearCachedSubEmbodiments();

    // Build a new list by canonizing each individual embodiment
    _subEmbodiments.value = List.generate(subEmbodiments.length,
        (i) => PrimitiveBase.canonizeEmbodiment(subEmbodiments[i]));
  }

  /// The sub-embodiments as property maps.
  Map<String, dynamic> getSubEmbodimentProperties(int index) {
    if (index < 0 || index >= _subEmbodiments.value.length) {
      return const {};
    }
    if (__cachedSubEmbodimentProperties != null) {
      var existing = __cachedSubEmbodimentProperties![index];
      if (existing != null) {
        return existing;
      }
    }

    var sub = _subEmbodiments.value[index];
    if (sub.trim().isEmpty) {
      return const {};
    }

    var subProps = jsonDecode(sub) as Map<String, dynamic>;

    // Put in the cache
    if (__cachedSubEmbodimentProperties == null) {
      __cachedSubEmbodimentProperties ??= {index: subProps};
    } else {
      __cachedSubEmbodimentProperties![index] = subProps;
    }

    return subProps;
  }
}
*/
