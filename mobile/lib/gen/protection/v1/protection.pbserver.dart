//
//  Generated code. Do not modify.
//  source: protection/v1/protection.proto
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

import 'protection.pb.dart' as $1;
import 'protection.pbjson.dart';

export 'protection.pb.dart';

abstract class ProtectionServiceBase extends $pb.GeneratedService {
  $async.Future<$1.CreateStudyResponse> createStudy($pb.ServerContext ctx, $1.CreateStudyRequest request);
  $async.Future<$1.GetStudyResponse> getStudy($pb.ServerContext ctx, $1.GetStudyRequest request);
  $async.Future<$1.ListStudiesResponse> listStudies($pb.ServerContext ctx, $1.ListStudiesRequest request);
  $async.Future<$1.DeleteStudyResponse> deleteStudy($pb.ServerContext ctx, $1.DeleteStudyRequest request);
  $async.Future<$1.ComputeShortCircuitResponse> computeShortCircuit($pb.ServerContext ctx, $1.ComputeShortCircuitRequest request);
  $async.Future<$1.ComputeEarthFaultResponse> computeEarthFault($pb.ServerContext ctx, $1.ComputeEarthFaultRequest request);
  $async.Future<$1.SelectRelayResponse> selectRelay($pb.ServerContext ctx, $1.SelectRelayRequest request);
  $async.Future<$1.ComputeRelaySettingsResponse> computeRelaySettings($pb.ServerContext ctx, $1.ComputeRelaySettingsRequest request);
  $async.Future<$1.ValidateCoordinationResponse> validateCoordination($pb.ServerContext ctx, $1.ValidateCoordinationRequest request);
  $async.Future<$1.GenerateProtectionReportResponse> generateProtectionReport($pb.ServerContext ctx, $1.GenerateProtectionReportRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateStudy': return $1.CreateStudyRequest();
      case 'GetStudy': return $1.GetStudyRequest();
      case 'ListStudies': return $1.ListStudiesRequest();
      case 'DeleteStudy': return $1.DeleteStudyRequest();
      case 'ComputeShortCircuit': return $1.ComputeShortCircuitRequest();
      case 'ComputeEarthFault': return $1.ComputeEarthFaultRequest();
      case 'SelectRelay': return $1.SelectRelayRequest();
      case 'ComputeRelaySettings': return $1.ComputeRelaySettingsRequest();
      case 'ValidateCoordination': return $1.ValidateCoordinationRequest();
      case 'GenerateProtectionReport': return $1.GenerateProtectionReportRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateStudy': return this.createStudy(ctx, request as $1.CreateStudyRequest);
      case 'GetStudy': return this.getStudy(ctx, request as $1.GetStudyRequest);
      case 'ListStudies': return this.listStudies(ctx, request as $1.ListStudiesRequest);
      case 'DeleteStudy': return this.deleteStudy(ctx, request as $1.DeleteStudyRequest);
      case 'ComputeShortCircuit': return this.computeShortCircuit(ctx, request as $1.ComputeShortCircuitRequest);
      case 'ComputeEarthFault': return this.computeEarthFault(ctx, request as $1.ComputeEarthFaultRequest);
      case 'SelectRelay': return this.selectRelay(ctx, request as $1.SelectRelayRequest);
      case 'ComputeRelaySettings': return this.computeRelaySettings(ctx, request as $1.ComputeRelaySettingsRequest);
      case 'ValidateCoordination': return this.validateCoordination(ctx, request as $1.ValidateCoordinationRequest);
      case 'GenerateProtectionReport': return this.generateProtectionReport(ctx, request as $1.GenerateProtectionReportRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ProtectionServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ProtectionServiceBase$messageJson;
}

