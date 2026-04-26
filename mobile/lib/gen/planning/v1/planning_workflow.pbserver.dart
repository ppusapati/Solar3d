//
//  Generated code. Do not modify.
//  source: planning/v1/planning_workflow.proto
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

import 'planning_workflow.pb.dart' as $1;
import 'planning_workflow.pbjson.dart';

export 'planning_workflow.pb.dart';

abstract class PlanningWorkflowServiceBase extends $pb.GeneratedService {
  $async.Future<$1.TransitionPhaseResponse> transitionPhase($pb.ServerContext ctx, $1.TransitionPhaseRequest request);
  $async.Future<$1.GetPhaseStateResponse> getPhaseState($pb.ServerContext ctx, $1.GetPhaseStateRequest request);
  $async.Future<$1.ListPhaseTransitionsResponse> listPhaseTransitions($pb.ServerContext ctx, $1.ListPhaseTransitionsRequest request);
  $async.Future<$1.ValidatePhaseReadinessResponse> validatePhaseReadiness($pb.ServerContext ctx, $1.ValidatePhaseReadinessRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'TransitionPhase': return $1.TransitionPhaseRequest();
      case 'GetPhaseState': return $1.GetPhaseStateRequest();
      case 'ListPhaseTransitions': return $1.ListPhaseTransitionsRequest();
      case 'ValidatePhaseReadiness': return $1.ValidatePhaseReadinessRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'TransitionPhase': return this.transitionPhase(ctx, request as $1.TransitionPhaseRequest);
      case 'GetPhaseState': return this.getPhaseState(ctx, request as $1.GetPhaseStateRequest);
      case 'ListPhaseTransitions': return this.listPhaseTransitions(ctx, request as $1.ListPhaseTransitionsRequest);
      case 'ValidatePhaseReadiness': return this.validatePhaseReadiness(ctx, request as $1.ValidatePhaseReadinessRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => PlanningWorkflowServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => PlanningWorkflowServiceBase$messageJson;
}

