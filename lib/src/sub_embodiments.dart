import 'fkey.dart';
import 'primitive_base.dart';
import 'strings1d_field.dart';
import 'dart:convert';

/// Implements the SubEmbodiments field for various primitives.
mixin SubEmbodiments {
  /// The SubEmbodiments stored in canonical form.
  final _subEmbodiments = Strings1DField.from(const []);

  /// Cached sub-embodiment properties.  These are built on demand and cleared when
  /// SubEmbodiements is reassigned.  If embodiment is empty then this value remains null.
  List<Map<String, dynamic>>? __cachedSubEmbodimentProperties = null;

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
  @override
  List<String> get subEmbodiments => _subEmbodiments.value;
  @override
  set subEmbodiments(List<String> subEmbodiments) {
    // In any case, clear the cached sub-embodiments properties.
    clearCachedSubEmbodiments();

    // Build a new list by canonizing each individual embodiment
    _subEmbodiments.value = List.generate(subEmbodiments.length,
        (i) => PrimitiveBase.canonizeEmbodiment(subEmbodiments[i]));
  }

  /// The sub-embodiments as property maps.
  List<Map<String, dynamic>> get subEmbodimentProperties {
    if (__cachedSubEmbodimentProperties != null) {
      return __cachedSubEmbodimentProperties!;
    }

    __cachedSubEmbodimentProperties = List<Map<String, dynamic>>.generate(
      _subEmbodiments.value.length,
      (i) {
        var embodimentJson = _subEmbodiments.value[i];

        if (embodimentJson.trim().isEmpty) {
          return const {};
        }

        return jsonDecode(embodimentJson) as Map<String, dynamic>;
      },
      growable: false,
    );

    return __cachedSubEmbodimentProperties!;
  }
}
