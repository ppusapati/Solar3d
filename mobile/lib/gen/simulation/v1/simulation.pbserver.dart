//
//  Generated code. Do not modify.
//  source: simulation/v1/simulation.proto
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

import 'simulation.pb.dart' as $1;
import 'simulation.pbjson.dart';

export 'simulation.pb.dart';

abstract class SimulationServiceBase extends $pb.GeneratedService {
  $async.Future<$1.CreateSimulationResponse> createSimulation($pb.ServerContext ctx, $1.CreateSimulationRequest request);
  $async.Future<$1.GetSimulationResponse> getSimulation($pb.ServerContext ctx, $1.GetSimulationRequest request);
  $async.Future<$1.ListSimulationsResponse> listSimulations($pb.ServerContext ctx, $1.ListSimulationsRequest request);
  $async.Future<$1.RunSimulationResponse> runSimulation($pb.ServerContext ctx, $1.RunSimulationRequest request);
  $async.Future<$1.GetSunPositionResponse> getSunPosition($pb.ServerContext ctx, $1.GetSunPositionRequest request);
  $async.Future<$1.GetShadowMapResponse> getShadowMap($pb.ServerContext ctx, $1.GetShadowMapRequest request);
  $async.Future<$1.DeleteSimulationResponse> deleteSimulation($pb.ServerContext ctx, $1.DeleteSimulationRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'CreateSimulation': return $1.CreateSimulationRequest();
      case 'GetSimulation': return $1.GetSimulationRequest();
      case 'ListSimulations': return $1.ListSimulationsRequest();
      case 'RunSimulation': return $1.RunSimulationRequest();
      case 'GetSunPosition': return $1.GetSunPositionRequest();
      case 'GetShadowMap': return $1.GetShadowMapRequest();
      case 'DeleteSimulation': return $1.DeleteSimulationRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'CreateSimulation': return this.createSimulation(ctx, request as $1.CreateSimulationRequest);
      case 'GetSimulation': return this.getSimulation(ctx, request as $1.GetSimulationRequest);
      case 'ListSimulations': return this.listSimulations(ctx, request as $1.ListSimulationsRequest);
      case 'RunSimulation': return this.runSimulation(ctx, request as $1.RunSimulationRequest);
      case 'GetSunPosition': return this.getSunPosition(ctx, request as $1.GetSunPositionRequest);
      case 'GetShadowMap': return this.getShadowMap(ctx, request as $1.GetShadowMapRequest);
      case 'DeleteSimulation': return this.deleteSimulation(ctx, request as $1.DeleteSimulationRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SimulationServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => SimulationServiceBase$messageJson;
}

abstract class SimulationComputeServiceBase extends $pb.GeneratedService {
  $async.Future<$1.GetSunPositionResponse> getSunPosition($pb.ServerContext ctx, $1.GetSunPositionRequest request);
  $async.Future<$1.GetShadowMapResponse> getShadowMap($pb.ServerContext ctx, $1.GetShadowMapRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetSunPosition': return $1.GetSunPositionRequest();
      case 'GetShadowMap': return $1.GetShadowMapRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetSunPosition': return this.getSunPosition(ctx, request as $1.GetSunPositionRequest);
      case 'GetShadowMap': return this.getShadowMap(ctx, request as $1.GetShadowMapRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => SimulationComputeServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => SimulationComputeServiceBase$messageJson;
}

