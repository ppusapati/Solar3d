//
//  Generated code. Do not modify.
//  source: structural/v1/structural.proto
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

import 'structural.pb.dart' as $1;
import 'structural.pbjson.dart';

export 'structural.pb.dart';

abstract class StructuralServiceBase extends $pb.GeneratedService {
  $async.Future<$1.CreateDesignResponse> createDesign($pb.ServerContext ctx, $1.CreateDesignRequest request);
  $async.Future<$1.GetDesignResponse> getDesign($pb.ServerContext ctx, $1.GetDesignRequest request);
  $async.Future<$1.ListDesignsResponse> listDesigns($pb.ServerContext ctx, $1.ListDesignsRequest request);
  $async.Future<$1.DeleteDesignResponse> deleteDesign($pb.ServerContext ctx, $1.DeleteDesignRequest request);
  $async.Future<$1.ComputeDeadLoadResponse> computeDeadLoad($pb.ServerContext ctx, $1.ComputeDeadLoadRequest request);
  $async.Future<$1.ComputeWindLoadResponse> computeWindLoad($pb.ServerContext ctx, $1.ComputeWindLoadRequest request);
  $async.Future<$1.ComputeSeismicLoadResponse> computeSeismicLoad($pb.ServerContext ctx, $1.ComputeSeismicLoadRequest request);
  $async.Future<$1.ComputeFoundationRequirementResponse> computeFoundationRequirement($pb.ServerContext ctx, $1.ComputeFoundationRequirementRequest request);
  $async.Future<$1.ValidateStructuralDesignResponse> validateStructuralDesign($pb.ServerContext ctx, $1.ValidateStructuralDesignRequest request);
  $async.Future<$1.SubmitForReviewResponse> submitForReview($pb.ServerContext ctx, $1.SubmitForReviewRequest request);
  $async.Future<$1.ApproveDesignResponse> approveDesign($pb.ServerContext ctx, $1.ApproveDesignRequest request);
  $async.Future<$1.RejectDesignResponse> rejectDesign($pb.ServerContext ctx, $1.RejectDesignRequest request);
  $async.Future<$1.GenerateStructuralReportResponse> generateStructuralReport($pb.ServerContext ctx, $1.GenerateStructuralReportRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateDesign': return $1.CreateDesignRequest();
      case 'GetDesign': return $1.GetDesignRequest();
      case 'ListDesigns': return $1.ListDesignsRequest();
      case 'DeleteDesign': return $1.DeleteDesignRequest();
      case 'ComputeDeadLoad': return $1.ComputeDeadLoadRequest();
      case 'ComputeWindLoad': return $1.ComputeWindLoadRequest();
      case 'ComputeSeismicLoad': return $1.ComputeSeismicLoadRequest();
      case 'ComputeFoundationRequirement': return $1.ComputeFoundationRequirementRequest();
      case 'ValidateStructuralDesign': return $1.ValidateStructuralDesignRequest();
      case 'SubmitForReview': return $1.SubmitForReviewRequest();
      case 'ApproveDesign': return $1.ApproveDesignRequest();
      case 'RejectDesign': return $1.RejectDesignRequest();
      case 'GenerateStructuralReport': return $1.GenerateStructuralReportRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateDesign': return this.createDesign(ctx, request as $1.CreateDesignRequest);
      case 'GetDesign': return this.getDesign(ctx, request as $1.GetDesignRequest);
      case 'ListDesigns': return this.listDesigns(ctx, request as $1.ListDesignsRequest);
      case 'DeleteDesign': return this.deleteDesign(ctx, request as $1.DeleteDesignRequest);
      case 'ComputeDeadLoad': return this.computeDeadLoad(ctx, request as $1.ComputeDeadLoadRequest);
      case 'ComputeWindLoad': return this.computeWindLoad(ctx, request as $1.ComputeWindLoadRequest);
      case 'ComputeSeismicLoad': return this.computeSeismicLoad(ctx, request as $1.ComputeSeismicLoadRequest);
      case 'ComputeFoundationRequirement': return this.computeFoundationRequirement(ctx, request as $1.ComputeFoundationRequirementRequest);
      case 'ValidateStructuralDesign': return this.validateStructuralDesign(ctx, request as $1.ValidateStructuralDesignRequest);
      case 'SubmitForReview': return this.submitForReview(ctx, request as $1.SubmitForReviewRequest);
      case 'ApproveDesign': return this.approveDesign(ctx, request as $1.ApproveDesignRequest);
      case 'RejectDesign': return this.rejectDesign(ctx, request as $1.RejectDesignRequest);
      case 'GenerateStructuralReport': return this.generateStructuralReport(ctx, request as $1.GenerateStructuralReportRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => StructuralServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => StructuralServiceBase$messageJson;
}

