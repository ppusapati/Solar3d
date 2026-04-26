//
//  Generated code. Do not modify.
//  source: geo/v1/geo.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'geo.pb.dart' as $0;
import 'geo.pbjson.dart';

export 'geo.pb.dart';

abstract class GeoServiceBase extends $pb.GeneratedService {
  $async.Future<$0.BufferPointResponse> bufferPoint($pb.ServerContext ctx, $0.BufferPointRequest request);
  $async.Future<$0.NearestPointResponse> nearestPoint($pb.ServerContext ctx, $0.NearestPointRequest request);
  $async.Future<$0.GenerateContoursResponse> generateContours($pb.ServerContext ctx, $0.GenerateContoursRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'BufferPoint': return $0.BufferPointRequest();
      case 'NearestPoint': return $0.NearestPointRequest();
      case 'GenerateContours': return $0.GenerateContoursRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'BufferPoint': return this.bufferPoint(ctx, request as $0.BufferPointRequest);
      case 'NearestPoint': return this.nearestPoint(ctx, request as $0.NearestPointRequest);
      case 'GenerateContours': return this.generateContours(ctx, request as $0.GenerateContoursRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => GeoServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => GeoServiceBase$messageJson;
}

