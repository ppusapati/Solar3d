//
//  Generated code. Do not modify.
//  source: terrain/v1/terrain.proto
//

import "package:connectrpc/connect.dart" as connect;
import "terrain.pb.dart" as terrainv1terrain;

/// TerrainService manages terrain layer lifecycle and terrain analytics operations.
abstract final class TerrainService {
  /// Fully-qualified name of the TerrainService service.
  static const name = 'terrain.v1.TerrainService';

  /// UploadTerrain ingests a terrain file and creates a terrain layer.
  static const uploadTerrain = connect.Spec(
    '/$name/UploadTerrain',
    connect.StreamType.unary,
    terrainv1terrain.UploadTerrainRequest.new,
    terrainv1terrain.UploadTerrainResponse.new,
  );

  /// GetTerrainLayer returns a terrain layer by ID.
  static const getTerrainLayer = connect.Spec(
    '/$name/GetTerrainLayer',
    connect.StreamType.unary,
    terrainv1terrain.GetTerrainLayerRequest.new,
    terrainv1terrain.GetTerrainLayerResponse.new,
  );

  /// ListTerrainLayers lists terrain layers for a project.
  static const listTerrainLayers = connect.Spec(
    '/$name/ListTerrainLayers',
    connect.StreamType.unary,
    terrainv1terrain.ListTerrainLayersRequest.new,
    terrainv1terrain.ListTerrainLayersResponse.new,
  );

  /// GetElevation returns elevation at a single coordinate.
  static const getElevation = connect.Spec(
    '/$name/GetElevation',
    connect.StreamType.unary,
    terrainv1terrain.GetElevationRequest.new,
    terrainv1terrain.GetElevationResponse.new,
  );

  /// GetElevationGrid returns elevation values for a bounding box grid.
  static const getElevationGrid = connect.Spec(
    '/$name/GetElevationGrid',
    connect.StreamType.unary,
    terrainv1terrain.GetElevationGridRequest.new,
    terrainv1terrain.GetElevationGridResponse.new,
  );

  /// AnalyzeEarthwork computes cut/fill and related earthwork metrics.
  static const analyzeEarthwork = connect.Spec(
    '/$name/AnalyzeEarthwork',
    connect.StreamType.unary,
    terrainv1terrain.AnalyzeEarthworkRequest.new,
    terrainv1terrain.AnalyzeEarthworkResponse.new,
  );

  /// DiffTerrainLayers computes differences between two terrain layers.
  static const diffTerrainLayers = connect.Spec(
    '/$name/DiffTerrainLayers',
    connect.StreamType.unary,
    terrainv1terrain.DiffTerrainLayersRequest.new,
    terrainv1terrain.DiffTerrainLayersResponse.new,
  );

  /// GenerateGradingPlan generates grading recommendations from terrain constraints.
  static const generateGradingPlan = connect.Spec(
    '/$name/GenerateGradingPlan',
    connect.StreamType.unary,
    terrainv1terrain.GenerateGradingPlanRequest.new,
    terrainv1terrain.GenerateGradingPlanResponse.new,
  );

  /// ComputeSlope computes slope values from terrain data.
  static const computeSlope = connect.Spec(
    '/$name/ComputeSlope',
    connect.StreamType.unary,
    terrainv1terrain.ComputeSlopeRequest.new,
    terrainv1terrain.ComputeSlopeResponse.new,
  );

  /// ComputeAspect computes aspect values from terrain data.
  static const computeAspect = connect.Spec(
    '/$name/ComputeAspect',
    connect.StreamType.unary,
    terrainv1terrain.ComputeAspectRequest.new,
    terrainv1terrain.ComputeAspectResponse.new,
  );

  /// DeleteTerrainLayer deletes a terrain layer by ID.
  static const deleteTerrainLayer = connect.Spec(
    '/$name/DeleteTerrainLayer',
    connect.StreamType.unary,
    terrainv1terrain.DeleteTerrainLayerRequest.new,
    terrainv1terrain.DeleteTerrainLayerResponse.new,
  );
}
/// TerrainComputeService exposes only stateless compute-style terrain operations.
/// Lifecycle/storage operations remain in TerrainService.
abstract final class TerrainComputeService {
  /// Fully-qualified name of the TerrainComputeService service.
  static const name = 'terrain.v1.TerrainComputeService';

  /// GetElevation returns elevation at a single coordinate.
  static const getElevation = connect.Spec(
    '/$name/GetElevation',
    connect.StreamType.unary,
    terrainv1terrain.GetElevationRequest.new,
    terrainv1terrain.GetElevationResponse.new,
  );

  /// GetElevationGrid returns elevation values for a bounding box grid.
  static const getElevationGrid = connect.Spec(
    '/$name/GetElevationGrid',
    connect.StreamType.unary,
    terrainv1terrain.GetElevationGridRequest.new,
    terrainv1terrain.GetElevationGridResponse.new,
  );

  /// ComputeSlope computes slope values from terrain data.
  static const computeSlope = connect.Spec(
    '/$name/ComputeSlope',
    connect.StreamType.unary,
    terrainv1terrain.ComputeSlopeRequest.new,
    terrainv1terrain.ComputeSlopeResponse.new,
  );

  /// ComputeAspect computes aspect values from terrain data.
  static const computeAspect = connect.Spec(
    '/$name/ComputeAspect',
    connect.StreamType.unary,
    terrainv1terrain.ComputeAspectRequest.new,
    terrainv1terrain.ComputeAspectResponse.new,
  );
}
