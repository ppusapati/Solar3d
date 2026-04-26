//
//  Generated code. Do not modify.
//  source: project/v1/project.proto
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

import 'project.pb.dart' as $4;
import 'project.pbjson.dart';

export 'project.pb.dart';

abstract class ProjectServiceBase extends $pb.GeneratedService {
  $async.Future<$4.CreateProjectResponse> createProject($pb.ServerContext ctx, $4.CreateProjectRequest request);
  $async.Future<$4.GetProjectResponse> getProject($pb.ServerContext ctx, $4.GetProjectRequest request);
  $async.Future<$4.ListProjectsResponse> listProjects($pb.ServerContext ctx, $4.ListProjectsRequest request);
  $async.Future<$4.UpdateProjectResponse> updateProject($pb.ServerContext ctx, $4.UpdateProjectRequest request);
  $async.Future<$4.DeleteProjectResponse> deleteProject($pb.ServerContext ctx, $4.DeleteProjectRequest request);
  $async.Future<$4.TransitionPhaseResponse> transitionPhase($pb.ServerContext ctx, $4.TransitionPhaseRequest request);
  $async.Future<$4.GetPhaseStateResponse> getPhaseState($pb.ServerContext ctx, $4.GetPhaseStateRequest request);
  $async.Future<$4.ListPhaseTransitionsResponse> listPhaseTransitions($pb.ServerContext ctx, $4.ListPhaseTransitionsRequest request);
  $async.Future<$4.ValidatePhaseReadinessResponse> validatePhaseReadiness($pb.ServerContext ctx, $4.ValidatePhaseReadinessRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateProject': return $4.CreateProjectRequest();
      case 'GetProject': return $4.GetProjectRequest();
      case 'ListProjects': return $4.ListProjectsRequest();
      case 'UpdateProject': return $4.UpdateProjectRequest();
      case 'DeleteProject': return $4.DeleteProjectRequest();
      case 'TransitionPhase': return $4.TransitionPhaseRequest();
      case 'GetPhaseState': return $4.GetPhaseStateRequest();
      case 'ListPhaseTransitions': return $4.ListPhaseTransitionsRequest();
      case 'ValidatePhaseReadiness': return $4.ValidatePhaseReadinessRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateProject': return this.createProject(ctx, request as $4.CreateProjectRequest);
      case 'GetProject': return this.getProject(ctx, request as $4.GetProjectRequest);
      case 'ListProjects': return this.listProjects(ctx, request as $4.ListProjectsRequest);
      case 'UpdateProject': return this.updateProject(ctx, request as $4.UpdateProjectRequest);
      case 'DeleteProject': return this.deleteProject(ctx, request as $4.DeleteProjectRequest);
      case 'TransitionPhase': return this.transitionPhase(ctx, request as $4.TransitionPhaseRequest);
      case 'GetPhaseState': return this.getPhaseState(ctx, request as $4.GetPhaseStateRequest);
      case 'ListPhaseTransitions': return this.listPhaseTransitions(ctx, request as $4.ListPhaseTransitionsRequest);
      case 'ValidatePhaseReadiness': return this.validatePhaseReadiness(ctx, request as $4.ValidatePhaseReadinessRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ProjectServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ProjectServiceBase$messageJson;
}

