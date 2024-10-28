//
//  Generated code. Do not modify.
//  source: proto/pg.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class PGUpdate extends $pb.GeneratedMessage {
  factory PGUpdate({
    $core.List<$core.int>? cbor,
  }) {
    final $result = create();
    if (cbor != null) {
      $result.cbor = cbor;
    }
    return $result;
  }
  PGUpdate._() : super();
  factory PGUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PGUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PGUpdate', createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'cbor', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PGUpdate clone() => PGUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PGUpdate copyWith(void Function(PGUpdate) updates) => super.copyWith((message) => updates(message as PGUpdate)) as PGUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PGUpdate create() => PGUpdate._();
  PGUpdate createEmptyInstance() => create();
  static $pb.PbList<PGUpdate> createRepeated() => $pb.PbList<PGUpdate>();
  @$core.pragma('dart2js:noInline')
  static PGUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PGUpdate>(create);
  static PGUpdate? _defaultInstance;

  /// CBOR encoded structure representing the update.
  @$pb.TagNumber(1)
  $core.List<$core.int> get cbor => $_getN(0);
  @$pb.TagNumber(1)
  set cbor($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCbor() => $_has(0);
  @$pb.TagNumber(1)
  void clearCbor() => clearField(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
