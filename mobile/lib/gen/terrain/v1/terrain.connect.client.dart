//
//  Generated code. Do not modify.
//  source: terrain/v1/terrain.proto
//

import "package:connectrpc/connect.dart" as connect;
import "terrain.pb.dart" as terrainv1terrain;
import "terrain.connect.spec.dart" as specs;

/// TerrainService manages terrain layer lifecycle and terrain analytics operations.
extension type TerrainServiceClient (connect.Transport _transport) {
  /// UploadTerrain ingests a terrain file and creates a terrain layer.
  Future<terrainv1terrain.UploadTerrainResponse> uploadTerrain(
    terrainv1terrain.UploadTerrainRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainService.uploadTerrain,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetTerrainLayer returns a terrain layer by ID.
  Future<terrainv1terrain.GetTerrainLayerResponse> getTerrainLayer(
    terrainv1terrain.GetTerrainLayerRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainService.getTerrainLayer,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListTerrainLayers lists terrain layers for a project.
  Future<terrainv1terrain.ListTerrainLayersResponse> listTerrainLayers(
    terrainv1terrain.ListTerrainLayersRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainService.listTerrainLayers,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetElevation returns elevation at a single coordinate.
  Future<terrainv1terrain.GetElevationResponse> getElevation(
    terrainv1terrain.GetElevationRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainService.getElevation,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetElevationGrid returns elevation values for a bounding box grid.
  Future<terrainv1terrain.GetElevationGridResponse> getElevationGrid(
    terrainv1terrain.GetElevationGridRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainService.getElevationGrid,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// AnalyzeEarthwork computes cut/fill and related earthwork metrics.
  Future<terrainv1terrain.AnalyzeEarthworkResponse> analyzeEarthwork(
    terrainv1terrain.AnalyzeEarthworkRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainService.analyzeEarthwork,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DiffTerrainLayers computes differences between two terrain layers.
  Future<terrainv1terrain.DiffTerrainLayersResponse> diffTerrainLayers(
    terrainv1terrain.DiffTerrainLayersRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainService.diffTerrainLayers,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GenerateGradingPlan generates grading recommendations from terrain constraints.
  Future<terrainv1terrain.GenerateGradingPlanResponse> generateGradingPlan(
    terrainv1terrain.GenerateGradingPlanRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainService.generateGradingPlan,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ComputeSlope computes slope values from terrain data.
  Future<terrainv1terrain.ComputeSlopeResponse> computeSlope(
    terrainv1terrain.ComputeSlopeRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainService.computeSlope,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ComputeAspect computes aspect values from terrain data.
  Future<terrainv1terrain.ComputeAspectResponse> computeAspect(
    terrainv1terrain.ComputeAspectRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainService.computeAspect,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// DeleteTerrainLayer deletes a terrain layer by ID.
  Future<terrainv1terrain.DeleteTerrainLayerResponse> deleteTerrainLayer(
    terrainv1terrain.DeleteTerrainLayerRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainService.deleteTerrainLayer,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
/// TerrainComputeService exposes only stateless compute-style terrain operations.
/// Lifecycle/storage operations remain in TerrainService.
extension type TerrainComputeServiceClient (connect.Transport _transport) {
  /// GetElevation returns elevation at a single coordinate.
  Future<terrainv1terrain.GetElevationResponse> getElevation(
    terrainv1terrain.GetElevationRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainComputeService.getElevation,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetElevationGrid returns elevation values for a bounding box grid.
  Future<terrainv1terrain.GetElevationGridResponse> getElevationGrid(
    terrainv1terrain.GetElevationGridRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainComputeService.getElevationGrid,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ComputeSlope computes slope values from terrain data.
  Future<terrainv1terrain.ComputeSlopeResponse> computeSlope(
    terrainv1terrain.ComputeSlopeRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainComputeService.computeSlope,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ComputeAspect computes aspect values from terrain data.
  Future<terrainv1terrain.ComputeAspectResponse> computeAspect(
    terrainv1terrain.ComputeAspectRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.TerrainComputeService.computeAspect,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
