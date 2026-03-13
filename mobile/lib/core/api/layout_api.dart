import '../models/layout.dart';
import 'api_client.dart';

class LayoutApi {
  final ApiClient _client;

  LayoutApi(this._client);

  Future<List<Layout>> listLayouts(String projectId) async {
    return _client.get(
      '/api/v1/layouts',
      queryParameters: {'project_id': projectId},
      parser: (data) {
        final list = data['layouts'] as List<dynamic>? ?? [];
        return list
            .map((e) => Layout.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<Layout> getLayout(String id) async {
    return _client.get(
      '/api/v1/layouts/$id',
      parser: (data) => Layout.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Layout> createLayout({
    required String projectId,
    required String name,
  }) async {
    return _client.post(
      '/api/v1/layouts',
      data: {'project_id': projectId, 'name': name},
      parser: (data) => Layout.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<void> deleteLayout(String id) async {
    await _client.delete('/api/v1/layouts/$id');
  }

  Future<Layout> generatePanelArray(
    String layoutId,
    PanelArrayParams params,
  ) async {
    return _client.post(
      '/api/v1/layouts/$layoutId/generate-array',
      data: params.toJson(),
      parser: (data) => Layout.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<List<LayoutTile>> getTiles(
    String layoutId, {
    required double minX,
    required double minY,
    required double maxX,
    required double maxY,
    int lodLevel = 0,
  }) async {
    return _client.get(
      '/api/v1/layouts/$layoutId/tiles',
      queryParameters: {
        'min_x': minX,
        'min_y': minY,
        'max_x': maxX,
        'max_y': maxY,
        'lod_level': lodLevel,
      },
      parser: (data) {
        final list = data['tiles'] as List<dynamic>? ?? [];
        return list
            .map((e) => LayoutTile.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<List<Panel>> getTilePanels(String tileId) async {
    return _client.get(
      '/api/v1/tiles/$tileId/panels',
      parser: (data) {
        final list = data['panels'] as List<dynamic>? ?? [];
        return list
            .map((e) => Panel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<List<Component>> listComponents(String layoutId) async {
    return _client.get(
      '/api/v1/layouts/$layoutId/components',
      parser: (data) {
        final list = data['components'] as List<dynamic>? ?? [];
        return list
            .map((e) => Component.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<Component> placeComponent({
    required String layoutId,
    required String componentType,
    required ComponentPosition position,
    String? assetId,
  }) async {
    return _client.post(
      '/api/v1/layouts/$layoutId/components',
      data: {
        'component_type': componentType,
        'position': position.toJson(),
        if (assetId != null) 'asset_id': assetId,
      },
      parser: (data) => Component.fromJson(data as Map<String, dynamic>),
    );
  }
}
