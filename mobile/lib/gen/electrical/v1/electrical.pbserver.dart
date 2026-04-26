//
//  Generated code. Do not modify.
//  source: electrical/v1/electrical.proto
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

import 'electrical.pb.dart' as $1;
import 'electrical.pbjson.dart';

export 'electrical.pb.dart';

abstract class ElectricalServiceBase extends $pb.GeneratedService {
  $async.Future<$1.CreateNetworkResponse> createNetwork($pb.ServerContext ctx, $1.CreateNetworkRequest request);
  $async.Future<$1.GetNetworkResponse> getNetwork($pb.ServerContext ctx, $1.GetNetworkRequest request);
  $async.Future<$1.ListNetworksResponse> listNetworks($pb.ServerContext ctx, $1.ListNetworksRequest request);
  $async.Future<$1.DeleteNetworkResponse> deleteNetwork($pb.ServerContext ctx, $1.DeleteNetworkRequest request);
  $async.Future<$1.CreateStringResponse> createString($pb.ServerContext ctx, $1.CreateStringRequest request);
  $async.Future<$1.AutoGenerateStringsResponse> autoGenerateStrings($pb.ServerContext ctx, $1.AutoGenerateStringsRequest request);
  $async.Future<$1.ListStringsResponse> listStrings($pb.ServerContext ctx, $1.ListStringsRequest request);
  $async.Future<$1.AssignInverterResponse> assignInverter($pb.ServerContext ctx, $1.AssignInverterRequest request);
  $async.Future<$1.ListInverterGroupsResponse> listInverterGroups($pb.ServerContext ctx, $1.ListInverterGroupsRequest request);
  $async.Future<$1.CalculateDCCapacityResponse> calculateDCCapacity($pb.ServerContext ctx, $1.CalculateDCCapacityRequest request);
  $async.Future<$1.CalculateACCapacityResponse> calculateACCapacity($pb.ServerContext ctx, $1.CalculateACCapacityRequest request);
  $async.Future<$1.CalculateLossesResponse> calculateLosses($pb.ServerContext ctx, $1.CalculateLossesRequest request);
  $async.Future<$1.ValidateSizingResponse> validateSizing($pb.ServerContext ctx, $1.ValidateSizingRequest request);
  $async.Future<$1.ValidateNetworkResponse> validateNetwork($pb.ServerContext ctx, $1.ValidateNetworkRequest request);
  $async.Future<$1.GenerateNetworkBOMResponse> generateNetworkBOM($pb.ServerContext ctx, $1.GenerateNetworkBOMRequest request);
  $async.Future<$1.SubmitNetworkForReviewResponse> submitNetworkForReview($pb.ServerContext ctx, $1.SubmitNetworkForReviewRequest request);
  $async.Future<$1.ApproveNetworkResponse> approveNetwork($pb.ServerContext ctx, $1.ApproveNetworkRequest request);
  $async.Future<$1.RejectNetworkResponse> rejectNetwork($pb.ServerContext ctx, $1.RejectNetworkRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateNetwork': return $1.CreateNetworkRequest();
      case 'GetNetwork': return $1.GetNetworkRequest();
      case 'ListNetworks': return $1.ListNetworksRequest();
      case 'DeleteNetwork': return $1.DeleteNetworkRequest();
      case 'CreateString': return $1.CreateStringRequest();
      case 'AutoGenerateStrings': return $1.AutoGenerateStringsRequest();
      case 'ListStrings': return $1.ListStringsRequest();
      case 'AssignInverter': return $1.AssignInverterRequest();
      case 'ListInverterGroups': return $1.ListInverterGroupsRequest();
      case 'CalculateDCCapacity': return $1.CalculateDCCapacityRequest();
      case 'CalculateACCapacity': return $1.CalculateACCapacityRequest();
      case 'CalculateLosses': return $1.CalculateLossesRequest();
      case 'ValidateSizing': return $1.ValidateSizingRequest();
      case 'ValidateNetwork': return $1.ValidateNetworkRequest();
      case 'GenerateNetworkBOM': return $1.GenerateNetworkBOMRequest();
      case 'SubmitNetworkForReview': return $1.SubmitNetworkForReviewRequest();
      case 'ApproveNetwork': return $1.ApproveNetworkRequest();
      case 'RejectNetwork': return $1.RejectNetworkRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateNetwork': return this.createNetwork(ctx, request as $1.CreateNetworkRequest);
      case 'GetNetwork': return this.getNetwork(ctx, request as $1.GetNetworkRequest);
      case 'ListNetworks': return this.listNetworks(ctx, request as $1.ListNetworksRequest);
      case 'DeleteNetwork': return this.deleteNetwork(ctx, request as $1.DeleteNetworkRequest);
      case 'CreateString': return this.createString(ctx, request as $1.CreateStringRequest);
      case 'AutoGenerateStrings': return this.autoGenerateStrings(ctx, request as $1.AutoGenerateStringsRequest);
      case 'ListStrings': return this.listStrings(ctx, request as $1.ListStringsRequest);
      case 'AssignInverter': return this.assignInverter(ctx, request as $1.AssignInverterRequest);
      case 'ListInverterGroups': return this.listInverterGroups(ctx, request as $1.ListInverterGroupsRequest);
      case 'CalculateDCCapacity': return this.calculateDCCapacity(ctx, request as $1.CalculateDCCapacityRequest);
      case 'CalculateACCapacity': return this.calculateACCapacity(ctx, request as $1.CalculateACCapacityRequest);
      case 'CalculateLosses': return this.calculateLosses(ctx, request as $1.CalculateLossesRequest);
      case 'ValidateSizing': return this.validateSizing(ctx, request as $1.ValidateSizingRequest);
      case 'ValidateNetwork': return this.validateNetwork(ctx, request as $1.ValidateNetworkRequest);
      case 'GenerateNetworkBOM': return this.generateNetworkBOM(ctx, request as $1.GenerateNetworkBOMRequest);
      case 'SubmitNetworkForReview': return this.submitNetworkForReview(ctx, request as $1.SubmitNetworkForReviewRequest);
      case 'ApproveNetwork': return this.approveNetwork(ctx, request as $1.ApproveNetworkRequest);
      case 'RejectNetwork': return this.rejectNetwork(ctx, request as $1.RejectNetworkRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ElectricalServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ElectricalServiceBase$messageJson;
}

