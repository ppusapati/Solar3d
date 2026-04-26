//
//  Generated code. Do not modify.
//  source: telemetry/v1/telemetry.proto
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

import 'telemetry.pb.dart' as $1;
import 'telemetry.pbjson.dart';

export 'telemetry.pb.dart';

abstract class TelemetryServiceBase extends $pb.GeneratedService {
  $async.Future<$1.IngestReadingsResponse> ingestReadings($pb.ServerContext ctx, $1.IngestReadingsRequest request);
  $async.Future<$1.GetLatestReadingsResponse> getLatestReadings($pb.ServerContext ctx, $1.GetLatestReadingsRequest request);
  $async.Future<$1.ListReadingsResponse> listReadings($pb.ServerContext ctx, $1.ListReadingsRequest request);
  $async.Future<$1.GetAggregatedMetricsResponse> getAggregatedMetrics($pb.ServerContext ctx, $1.GetAggregatedMetricsRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'IngestReadings': return $1.IngestReadingsRequest();
      case 'GetLatestReadings': return $1.GetLatestReadingsRequest();
      case 'ListReadings': return $1.ListReadingsRequest();
      case 'GetAggregatedMetrics': return $1.GetAggregatedMetricsRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'IngestReadings': return this.ingestReadings(ctx, request as $1.IngestReadingsRequest);
      case 'GetLatestReadings': return this.getLatestReadings(ctx, request as $1.GetLatestReadingsRequest);
      case 'ListReadings': return this.listReadings(ctx, request as $1.ListReadingsRequest);
      case 'GetAggregatedMetrics': return this.getAggregatedMetrics(ctx, request as $1.GetAggregatedMetricsRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => TelemetryServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => TelemetryServiceBase$messageJson;
}

