import '../../models/terrain.dart';
import '../transport.dart';

class TerrainServiceClient {
  static const _service = 'solar.terrain.v1.TerrainService';
  final ConnectRpcTransport _transport;

  TerrainServiceClient(this._transport);

  Future<TerrainLayer> uploadTerrain({
    required String projectId,
    required String name,
    required String layerType,
    required String data,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'UploadTerrain',
      request: {
        'project_id': projectId,
        'name': name,
        'layer_type': layerType,
        'data': data,
      },
    );
    return TerrainLayer.fromJson(
        response['terrain_layer'] as Map<String, dynamic>);
  }

  Future<TerrainLayer> getTerrainLayer(String id) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetTerrainLayer',
      request: {'id': id},
    );
    return TerrainLayer.fromJson(
        response['terrain_layer'] as Map<String, dynamic>);
  }

  Future<List<TerrainLayer>> listTerrainLayers(String projectId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'ListTerrainLayers',
      request: {'project_id': projectId},
    );
    final list = response['terrain_layers'] as List<dynamic>? ?? [];
    return list
        .map((e) => TerrainLayer.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<double> getElevation({
    required String projectId,
    required double longitude,
    required double latitude,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetElevation',
      request: {
        'project_id': projectId,
        'longitude': longitude,
        'latitude': latitude,
      },
    );
    return (response['elevation'] as num).toDouble();
  }

  Future<ElevationGrid> getElevationGrid({
    required String projectId,
    required double minX,
    required double minY,
    required double maxX,
    required double maxY,
    int resolution = 30,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetElevationGrid',
      request: {
        'project_id': projectId,
        'bbox': {
          'min_x': minX,
          'min_y': minY,
          'max_x': maxX,
          'max_y': maxY,
        },
        'resolution': resolution,
      },
    );
    return ElevationGrid.fromJson(response as Map<String, dynamic>);
  }

  Future<TerrainLayer> computeSlope(String terrainLayerId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'ComputeSlope',
      request: {'terrain_layer_id': terrainLayerId},
    );
    return TerrainLayer.fromJson(
        response['terrain_layer'] as Map<String, dynamic>);
  }

  Future<TerrainLayer> computeAspect(String terrainLayerId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'ComputeAspect',
      request: {'terrain_layer_id': terrainLayerId},
    );
    return TerrainLayer.fromJson(
        response['terrain_layer'] as Map<String, dynamic>);
  }

  Future<void> deleteTerrainLayer(String id) async {
    await _transport.unary(
      service: _service,
      method: 'DeleteTerrainLayer',
      request: {'id': id},
    );
  }
}
