//
//  Generated code. Do not modify.
//  source: proto/pg.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'pg.pb.dart' as $0;

export 'pg.pb.dart';

@$pb.GrpcServiceName('PGService')
class PGServiceClient extends $grpc.Client {
  static final _$streamUpdates = $grpc.ClientMethod<$0.PGUpdate, $0.PGUpdate>(
      '/PGService/StreamUpdates',
      ($0.PGUpdate value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PGUpdate.fromBuffer(value));

  PGServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseStream<$0.PGUpdate> streamUpdates($async.Stream<$0.PGUpdate> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$streamUpdates, request, options: options);
  }
}

@$pb.GrpcServiceName('PGService')
abstract class PGServiceBase extends $grpc.Service {
  $core.String get $name => 'PGService';

  PGServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.PGUpdate, $0.PGUpdate>(
        'StreamUpdates',
        streamUpdates,
        true,
        true,
        ($core.List<$core.int> value) => $0.PGUpdate.fromBuffer(value),
        ($0.PGUpdate value) => value.writeToBuffer()));
  }

  $async.Stream<$0.PGUpdate> streamUpdates($grpc.ServiceCall call, $async.Stream<$0.PGUpdate> request);
}
