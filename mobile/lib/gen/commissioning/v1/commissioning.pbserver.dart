//
//  Generated code. Do not modify.
//  source: commissioning/v1/commissioning.proto
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

import 'commissioning.pb.dart' as $3;
import 'commissioning.pbjson.dart';

export 'commissioning.pb.dart';

abstract class CommissioningServiceBase extends $pb.GeneratedService {
  $async.Future<$3.CreateChecklistResponse> createChecklist($pb.ServerContext ctx, $3.CreateChecklistRequest request);
  $async.Future<$3.GetChecklistResponse> getChecklist($pb.ServerContext ctx, $3.GetChecklistRequest request);
  $async.Future<$3.ListChecklistsResponse> listChecklists($pb.ServerContext ctx, $3.ListChecklistsRequest request);
  $async.Future<$3.AddChecklistItemResponse> addChecklistItem($pb.ServerContext ctx, $3.AddChecklistItemRequest request);
  $async.Future<$3.UpdateChecklistItemResponse> updateChecklistItem($pb.ServerContext ctx, $3.UpdateChecklistItemRequest request);
  $async.Future<$3.SignOffChecklistResponse> signOffChecklist($pb.ServerContext ctx, $3.SignOffChecklistRequest request);
  $async.Future<$3.ListSignoffsResponse> listSignoffs($pb.ServerContext ctx, $3.ListSignoffsRequest request);
  $async.Future<$3.CreateHandoverResponse> createHandover($pb.ServerContext ctx, $3.CreateHandoverRequest request);
  $async.Future<$3.GetHandoverResponse> getHandover($pb.ServerContext ctx, $3.GetHandoverRequest request);
  $async.Future<$3.RecordAsBuiltResponse> recordAsBuilt($pb.ServerContext ctx, $3.RecordAsBuiltRequest request);
  $async.Future<$3.ListAsBuiltArtifactsResponse> listAsBuiltArtifacts($pb.ServerContext ctx, $3.ListAsBuiltArtifactsRequest request);
  $async.Future<$3.GenerateCommissioningReportResponse> generateCommissioningReport($pb.ServerContext ctx, $3.GenerateCommissioningReportRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateChecklist': return $3.CreateChecklistRequest();
      case 'GetChecklist': return $3.GetChecklistRequest();
      case 'ListChecklists': return $3.ListChecklistsRequest();
      case 'AddChecklistItem': return $3.AddChecklistItemRequest();
      case 'UpdateChecklistItem': return $3.UpdateChecklistItemRequest();
      case 'SignOffChecklist': return $3.SignOffChecklistRequest();
      case 'ListSignoffs': return $3.ListSignoffsRequest();
      case 'CreateHandover': return $3.CreateHandoverRequest();
      case 'GetHandover': return $3.GetHandoverRequest();
      case 'RecordAsBuilt': return $3.RecordAsBuiltRequest();
      case 'ListAsBuiltArtifacts': return $3.ListAsBuiltArtifactsRequest();
      case 'GenerateCommissioningReport': return $3.GenerateCommissioningReportRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateChecklist': return this.createChecklist(ctx, request as $3.CreateChecklistRequest);
      case 'GetChecklist': return this.getChecklist(ctx, request as $3.GetChecklistRequest);
      case 'ListChecklists': return this.listChecklists(ctx, request as $3.ListChecklistsRequest);
      case 'AddChecklistItem': return this.addChecklistItem(ctx, request as $3.AddChecklistItemRequest);
      case 'UpdateChecklistItem': return this.updateChecklistItem(ctx, request as $3.UpdateChecklistItemRequest);
      case 'SignOffChecklist': return this.signOffChecklist(ctx, request as $3.SignOffChecklistRequest);
      case 'ListSignoffs': return this.listSignoffs(ctx, request as $3.ListSignoffsRequest);
      case 'CreateHandover': return this.createHandover(ctx, request as $3.CreateHandoverRequest);
      case 'GetHandover': return this.getHandover(ctx, request as $3.GetHandoverRequest);
      case 'RecordAsBuilt': return this.recordAsBuilt(ctx, request as $3.RecordAsBuiltRequest);
      case 'ListAsBuiltArtifacts': return this.listAsBuiltArtifacts(ctx, request as $3.ListAsBuiltArtifactsRequest);
      case 'GenerateCommissioningReport': return this.generateCommissioningReport(ctx, request as $3.GenerateCommissioningReportRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => CommissioningServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => CommissioningServiceBase$messageJson;
}

