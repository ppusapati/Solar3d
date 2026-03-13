import '../../models/layout.dart';
import '../transport.dart';

class LayoutServiceClient {
  static const _service = 'solar.layout.v1.LayoutService';
  final ConnectRpcTransport _transport;

  LayoutServiceClient(this._transport);

  Future<Layout> createLayout({
    required String projectId,
    required String name,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'CreateLayout',
      request: {'project_id': projectId, 'name': name},
    );
    return Layout.fromJson(response['layout'] as Map<String, dynamic>);
  }

  Future<Layout> getLayout(String id) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetLayout',
      request: {'id': id},
    );
    return Layout.fromJson(response['layout'] as Map<String, dynamic>);
  }

  Future<List<Layout>> listLayouts(String projectId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'ListLayouts',
      request: {'project_id': projectId},
    );
    final list = response['layouts'] as List<dynamic>? ?? [];
    return list
        .map((e) => Layout.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteLayout(String id) async {
    await _transport.unary(
      service: _service,
      method: 'DeleteLayout',
      request: {'id': id},
    );
  }

  Future<Layout> generatePanelArray({
    required String layoutId,
    required PanelArrayParams params,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GeneratePanelArray',
      request: {
        'layout_id': layoutId,
        ...params.toJson(),
      },
    );
    return Layout.fromJson(response['layout'] as Map<String, dynamic>);
  }

  Future<List<LayoutTile>> getTiles({
    required String layoutId,
    required double minX,
    required double minY,
    required double maxX,
    required double maxY,
    int lodLevel = 0,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetTiles',
      request: {
        'layout_id': layoutId,
        'bbox': {
          'min_x': minX,
          'min_y': minY,
          'max_x': maxX,
          'max_y': maxY,
        },
        'lod_level': lodLevel,
      },
    );
    final list = response['tiles'] as List<dynamic>? ?? [];
    return list
        .map((e) => LayoutTile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Panel>> getTilePanels(String tileId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetTilePanels',
      request: {'tile_id': tileId},
    );
    final list = response['panels'] as List<dynamic>? ?? [];
    return list
        .map((e) => Panel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Component> placeComponent({
    required String layoutId,
    required String componentType,
    required ComponentPosition position,
    String? assetId,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'PlaceComponent',
      request: {
        'layout_id': layoutId,
        'component_type': componentType,
        'position': position.toJson(),
        if (assetId != null) 'asset_id': assetId,
      },
    );
    return Component.fromJson(response['component'] as Map<String, dynamic>);
  }

  Future<Component> moveComponent({
    required String componentId,
    required ComponentPosition position,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'MoveComponent',
      request: {
        'component_id': componentId,
        'position': position.toJson(),
      },
    );
    return Component.fromJson(response['component'] as Map<String, dynamic>);
  }

  Future<void> removeComponent(String componentId) async {
    await _transport.unary(
      service: _service,
      method: 'RemoveComponent',
      request: {'component_id': componentId},
    );
  }

  Future<List<Component>> listComponents(String layoutId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'ListComponents',
      request: {'layout_id': layoutId},
    );
    final list = response['components'] as List<dynamic>? ?? [];
    return list
        .map((e) => Component.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
