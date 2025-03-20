// Copyright 2025 ProntoGUI, LLC.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:cbor/cbor.dart';
import 'pkey.dart';
import 'fkey.dart';
import 'field_hooks.dart';

// Interface for Primitives.
abstract class Primitive {
  /// The path to this primitive.
  PKey get pkey;

  /// Prepare this primitive for updates, where [pkey] is the path to this primitive,
  /// and [fieldHooks] is the interface to call when fields of this primitive are updated.
  void prepareForUpdates(PKey pkey, FieldHooks fieldHooks);

  /// Unprepare this primitive for updates.  Subsequent updates to fields will not
  /// call the previous onset function, not will this primitive have a valid PKey.
  void unprepareForUpdates();

  /// Returns the next primitive that is a direct descendant of this primitive.
  /// A caller presumes there is a next descendant, otherwise an exception is thrown.
  Primitive locateNextDescendant(PKeyLocator locator);

  /// Egests a full update from this primitive as a CborMap.
  CborMap egestFullCborMap();

  /// Egests a partial update from this primitive as a CborMap.
  /// Only the fields specified in [fkeys] will be included in the map.
  /// It is assumed that [fkeys] is a subset of the fields of this primitive, otherwise
  /// an assertion is thrown.
  CborMap egestPartialCborMap(List<FKey> fkeys);

  /// Initialize from a CborMap.  This includes creating new child primitives.
  void ingestFullCborMap(CborMap cbor);

  /// Update field values by ingesting them from a CborMap. The map can only contain
  /// updates for pre-existing child primmitives.  New children are not created.
  void ingestPartialCborMap(CborMap cbor);

  /// Returns the canonical type of this primitive.
  String get describeType;

  /// True if the primitive has not been prepared yet for updates.
  bool get notPreparedYet;

  /// The embodiment to use for rendering the primitive.
  ///
  /// Setting the embodiment is done using a 1) JSON string, 2) a simple assignment of embodiment type,
  /// or 3) a simplified key-value pair string.  Examples of 1 and 2 are:
  /// 'full-view' : equivalent to JSON {"embodiment":"full-view"}
  /// 'embodiment:outlined-button, width:200, height:50' : equivalent to JSON {"embodiment":"outlined-button", "width":200, "height":50}
  ///
  /// This will always return a JSON string, the canonical representation of the embodiment,
  /// regardless of how it was set.
  String get embodiment;
  set embodiment(String embodiment);

  /// The embodiment property map of this primitive, derived from the embodiment
  /// field of this primitive.  If there are no embodiment properties the null
  /// is returned.
  Map<String, dynamic>? get embodimentMap;

  /// A cached object representing the embodiment info, which is derived
  /// from embodimentMap and store here by the App. This is set to null
  /// by the primitive object whenever the embodiment changes.
  dynamic get embodimentInfo;
  set embodimentInfo(dynamic info);

  /// An arbitrary tag to keep around with this primitive.
  String get tag;
  set tag(String tag);
}
