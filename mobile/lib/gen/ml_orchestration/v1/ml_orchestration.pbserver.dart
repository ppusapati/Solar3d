//
//  Generated code. Do not modify.
//  source: ml_orchestration/v1/ml_orchestration.proto
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

import 'ml_orchestration.pb.dart' as $0;
import 'ml_orchestration.pbjson.dart';

export 'ml_orchestration.pb.dart';

abstract class MLOrchestrationServiceBase extends $pb.GeneratedService {
  $async.Future<$0.SubmitTrainingJobResponse> submitTrainingJob($pb.ServerContext ctx, $0.SubmitTrainingJobRequest request);
  $async.Future<$0.GetJobStatusResponse> getJobStatus($pb.ServerContext ctx, $0.GetJobStatusRequest request);
  $async.Future<$0.CancelJobResponse> cancelJob($pb.ServerContext ctx, $0.CancelJobRequest request);
  $async.Future<$0.GetJobHistoryResponse> getJobHistory($pb.ServerContext ctx, $0.GetJobHistoryRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'SubmitTrainingJob': return $0.SubmitTrainingJobRequest();
      case 'GetJobStatus': return $0.GetJobStatusRequest();
      case 'CancelJob': return $0.CancelJobRequest();
      case 'GetJobHistory': return $0.GetJobHistoryRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'SubmitTrainingJob': return this.submitTrainingJob(ctx, request as $0.SubmitTrainingJobRequest);
      case 'GetJobStatus': return this.getJobStatus(ctx, request as $0.GetJobStatusRequest);
      case 'CancelJob': return this.cancelJob(ctx, request as $0.CancelJobRequest);
      case 'GetJobHistory': return this.getJobHistory(ctx, request as $0.GetJobHistoryRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => MLOrchestrationServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => MLOrchestrationServiceBase$messageJson;
}

