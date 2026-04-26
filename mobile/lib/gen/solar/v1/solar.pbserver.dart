//
//  Generated code. Do not modify.
//  source: solar/v1/solar.proto
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

import 'solar.pb.dart' as $2;
import 'solar.pbjson.dart';

export 'solar.pb.dart';

abstract class SolarServiceBase extends $pb.GeneratedService {
  $async.Future<$2.SolarPositionResponse> calculateSolarPosition($pb.ServerContext ctx, $2.SolarPositionRequest request);
  $async.Future<$2.CastShadowsResponse> castShadows($pb.ServerContext ctx, $2.CastShadowsRequest request);
  $async.Future<$2.DNIResponse> calculateDNI($pb.ServerContext ctx, $2.DNIRequest request);
  $async.Future<$2.DHIResponse> calculateDHI($pb.ServerContext ctx, $2.DHIRequest request);
  $async.Future<$2.BulkSolarPositionResponse> bulkSolarPosition($pb.ServerContext ctx, $2.BulkSolarPositionRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CalculateSolarPosition': return $2.SolarPositionRequest();
      case 'CastShadows': return $2.CastShadowsRequest();
      case 'CalculateDNI': return $2.DNIRequest();
      case 'CalculateDHI': return $2.DHIRequest();
      case 'BulkSolarPosition': return $2.BulkSolarPositionRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CalculateSolarPosition': return this.calculateSolarPosition(ctx, request as $2.SolarPositionRequest);
      case 'CastShadows': return this.castShadows(ctx, request as $2.CastShadowsRequest);
      case 'CalculateDNI': return this.calculateDNI(ctx, request as $2.DNIRequest);
      case 'CalculateDHI': return this.calculateDHI(ctx, request as $2.DHIRequest);
      case 'BulkSolarPosition': return this.bulkSolarPosition(ctx, request as $2.BulkSolarPositionRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SolarServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => SolarServiceBase$messageJson;
}

