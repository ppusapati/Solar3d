//
//  Generated code. Do not modify.
//  source: orchestration/v1/orchestration.proto
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

import 'orchestration.pb.dart' as $1;
import 'orchestration.pbjson.dart';

export 'orchestration.pb.dart';

abstract class ComputeOrchestrationServiceBase extends $pb.GeneratedService {
  $async.Future<$1.SubmitJobResponse> submitJob($pb.ServerContext ctx, $1.SubmitJobRequest request);
  $async.Future<$1.GetJobResponse> getJob($pb.ServerContext ctx, $1.GetJobRequest request);
  $async.Future<$1.ListJobsResponse> listJobs($pb.ServerContext ctx, $1.ListJobsRequest request);
  $async.Future<$1.RetryJobResponse> retryJob($pb.ServerContext ctx, $1.RetryJobRequest request);
  $async.Future<$1.CancelJobResponse> cancelJob($pb.ServerContext ctx, $1.CancelJobRequest request);
  $async.Future<$1.ListDeadLettersResponse> listDeadLetters($pb.ServerContext ctx, $1.ListDeadLettersRequest request);
  $async.Future<$1.GetDeadLetterResponse> getDeadLetter($pb.ServerContext ctx, $1.GetDeadLetterRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'SubmitJob': return $1.SubmitJobRequest();
      case 'GetJob': return $1.GetJobRequest();
      case 'ListJobs': return $1.ListJobsRequest();
      case 'RetryJob': return $1.RetryJobRequest();
      case 'CancelJob': return $1.CancelJobRequest();
      case 'ListDeadLetters': return $1.ListDeadLettersRequest();
      case 'GetDeadLetter': return $1.GetDeadLetterRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'SubmitJob': return this.submitJob(ctx, request as $1.SubmitJobRequest);
      case 'GetJob': return this.getJob(ctx, request as $1.GetJobRequest);
      case 'ListJobs': return this.listJobs(ctx, request as $1.ListJobsRequest);
      case 'RetryJob': return this.retryJob(ctx, request as $1.RetryJobRequest);
      case 'CancelJob': return this.cancelJob(ctx, request as $1.CancelJobRequest);
      case 'ListDeadLetters': return this.listDeadLetters(ctx, request as $1.ListDeadLettersRequest);
      case 'GetDeadLetter': return this.getDeadLetter(ctx, request as $1.GetDeadLetterRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ComputeOrchestrationServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ComputeOrchestrationServiceBase$messageJson;
}

