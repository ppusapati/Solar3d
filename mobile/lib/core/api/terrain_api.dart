import '../models/terrain.dart';
import 'api_client.dart';

class TerrainApi {
  final ApiClient _client;

  TerrainApi(this._client);

  Future<List<TerrainLayer>> listTerrainLayers(String projectId) async {
    return _client.get(
      '/api/v1/terrain',
      queryParameters: {'project_id': projectId},
      parser: (data) {
        final list = data['terrain_layers'] as List<dynamic>? ?? [];
        return list
            .map((e) => TerrainLayer.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<TerrainLayer> getTerrainLayer(String id) async {
    return _client.get(
      '/api/v1/terrain/$id',
      parser: (data) => TerrainLayer.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<ElevationGrid> getElevationGrid({
    required String projectId,
    required double minX,
    required double minY,
    required double maxX,
    required double maxY,
    int resolution = 30,
  }) async {
    return _client.get(
      '/api/v1/terrain/elevation-grid',
      queryParameters: {
        'project_id': projectId,
        'min_x': minX,
        'min_y': minY,
        'max_x': maxX,
        'max_y': maxY,
        'resolution': resolution,
      },
      parser: (data) => ElevationGrid.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<double> getElevation({
    required String projectId,
    required double longitude,
    required double latitude,
  }) async {
    return _client.get(
      '/api/v1/terrain/elevation',
      queryParameters: {
        'project_id': projectId,
        'longitude': longitude,
        'latitude': latitude,
      },
      parser: (data) => (data['elevation'] as num).toDouble(),
    );
  }

  Future<void> deleteTerrainLayer(String id) async {
    await _client.delete('/api/v1/terrain/$id');
  }
}
