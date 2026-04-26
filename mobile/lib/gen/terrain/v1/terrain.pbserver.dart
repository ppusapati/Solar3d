//
//  Generated code. Do not modify.
//  source: terrain/v1/terrain.proto
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

import 'terrain.pb.dart' as $1;
import 'terrain.pbjson.dart';

export 'terrain.pb.dart';

abstract class TerrainServiceBase extends $pb.GeneratedService {
  $async.Future<$1.UploadTerrainResponse> uploadTerrain($pb.ServerContext ctx, $1.UploadTerrainRequest request);
  $async.Future<$1.GetTerrainLayerResponse> getTerrainLayer($pb.ServerContext ctx, $1.GetTerrainLayerRequest request);
  $async.Future<$1.ListTerrainLayersResponse> listTerrainLayers($pb.ServerContext ctx, $1.ListTerrainLayersRequest request);
  $async.Future<$1.GetElevationResponse> getElevation($pb.ServerContext ctx, $1.GetElevationRequest request);
  $async.Future<$1.GetElevationGridResponse> getElevationGrid($pb.ServerContext ctx, $1.GetElevationGridRequest request);
  $async.Future<$1.AnalyzeEarthworkResponse> analyzeEarthwork($pb.ServerContext ctx, $1.AnalyzeEarthworkRequest request);
  $async.Future<$1.DiffTerrainLayersResponse> diffTerrainLayers($pb.ServerContext ctx, $1.DiffTerrainLayersRequest request);
  $async.Future<$1.GenerateGradingPlanResponse> generateGradingPlan($pb.ServerContext ctx, $1.GenerateGradingPlanRequest request);
  $async.Future<$1.ComputeSlopeResponse> computeSlope($pb.ServerContext ctx, $1.ComputeSlopeRequest request);
  $async.Future<$1.ComputeAspectResponse> computeAspect($pb.ServerContext ctx, $1.ComputeAspectRequest request);
  $async.Future<$1.DeleteTerrainLayerResponse> deleteTerrainLayer($pb.ServerContext ctx, $1.DeleteTerrainLayerRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'UploadTerrain': return $1.UploadTerrainRequest();
      case 'GetTerrainLayer': return $1.GetTerrainLayerRequest();
      case 'ListTerrainLayers': return $1.ListTerrainLayersRequest();
      case 'GetElevation': return $1.GetElevationRequest();
      case 'GetElevationGrid': return $1.GetElevationGridRequest();
      case 'AnalyzeEarthwork': return $1.AnalyzeEarthworkRequest();
      case 'DiffTerrainLayers': return $1.DiffTerrainLayersRequest();
      case 'GenerateGradingPlan': return $1.GenerateGradingPlanRequest();
      case 'ComputeSlope': return $1.ComputeSlopeRequest();
      case 'ComputeAspect': return $1.ComputeAspectRequest();
      case 'DeleteTerrainLayer': return $1.DeleteTerrainLayerRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'UploadTerrain': return this.uploadTerrain(ctx, request as $1.UploadTerrainRequest);
      case 'GetTerrainLayer': return this.getTerrainLayer(ctx, request as $1.GetTerrainLayerRequest);
      case 'ListTerrainLayers': return this.listTerrainLayers(ctx, request as $1.ListTerrainLayersRequest);
      case 'GetElevation': return this.getElevation(ctx, request as $1.GetElevationRequest);
      case 'GetElevationGrid': return this.getElevationGrid(ctx, request as $1.GetElevationGridRequest);
      case 'AnalyzeEarthwork': return this.analyzeEarthwork(ctx, request as $1.AnalyzeEarthworkRequest);
      case 'DiffTerrainLayers': return this.diffTerrainLayers(ctx, request as $1.DiffTerrainLayersRequest);
      case 'GenerateGradingPlan': return this.generateGradingPlan(ctx, request as $1.GenerateGradingPlanRequest);
      case 'ComputeSlope': return this.computeSlope(ctx, request as $1.ComputeSlopeRequest);
      case 'ComputeAspect': return this.computeAspect(ctx, request as $1.ComputeAspectRequest);
      case 'DeleteTerrainLayer': return this.deleteTerrainLayer(ctx, request as $1.DeleteTerrainLayerRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => TerrainServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => TerrainServiceBase$messageJson;
}

abstract class TerrainComputeServiceBase extends $pb.GeneratedService {
  $async.Future<$1.GetElevationResponse> getElevation($pb.ServerContext ctx, $1.GetElevationRequest request);
  $async.Future<$1.GetElevationGridResponse> getElevationGrid($pb.ServerContext ctx, $1.GetElevationGridRequest request);
  $async.Future<$1.ComputeSlopeResponse> computeSlope($pb.ServerContext ctx, $1.ComputeSlopeRequest request);
  $async.Future<$1.ComputeAspectResponse> computeAspect($pb.ServerContext ctx, $1.ComputeAspectRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetElevation': return $1.GetElevationRequest();
      case 'GetElevationGrid': return $1.GetElevationGridRequest();
      case 'ComputeSlope': return $1.ComputeSlopeRequest();
      case 'ComputeAspect': return $1.ComputeAspectRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetElevation': return this.getElevation(ctx, request as $1.GetElevationRequest);
      case 'GetElevationGrid': return this.getElevationGrid(ctx, request as $1.GetElevationGridRequest);
      case 'ComputeSlope': return this.computeSlope(ctx, request as $1.ComputeSlopeRequest);
      case 'ComputeAspect': return this.computeAspect(ctx, request as $1.ComputeAspectRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => TerrainComputeServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => TerrainComputeServiceBase$messageJson;
}

