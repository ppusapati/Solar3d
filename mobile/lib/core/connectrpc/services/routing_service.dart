import '../../models/route.dart';
import '../transport.dart';

class RoutingServiceClient {
  static const _service = 'routing.v1.RoutingService';
  final ConnectRpcTransport _transport;

  RoutingServiceClient(this._transport);

  Future<RouteModel> calculateRoute({
    required String projectId,
    required String layoutId,
    required String routeType,
    required List<Waypoint> waypoints,
    RouteConstraints? constraints,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'CalculateRoute',
      request: {
        'project_id': projectId,
        'layout_id': layoutId,
        'route_type': routeType,
        'waypoints': waypoints.map((w) => w.toJson()).toList(),
        if (constraints != null) 'constraints': constraints.toJson(),
      },
    );
    return RouteModel.fromJson(response['route'] as Map<String, dynamic>);
  }

  Future<RouteModel> createCableRoute({
    required String projectId,
    required String layoutId,
    required String name,
    required String routeType,
    required List<Waypoint> waypoints,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'CreateCableRoute',
      request: {
        'project_id': projectId,
        'layout_id': layoutId,
        'name': name,
        'route_type': routeType,
        'waypoints': waypoints.map((w) => w.toJson()).toList(),
      },
    );
    return RouteModel.fromJson(response['route'] as Map<String, dynamic>);
  }

  Future<RouteModel> createRoadRoute({
    required String projectId,
    required String layoutId,
    required String name,
    required List<Waypoint> waypoints,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'CreateRoadRoute',
      request: {
        'project_id': projectId,
        'layout_id': layoutId,
        'name': name,
        'waypoints': waypoints.map((w) => w.toJson()).toList(),
      },
    );
    return RouteModel.fromJson(response['route'] as Map<String, dynamic>);
  }

  Future<List<RouteModel>> listRoutes(String projectId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'ListRoutes',
      request: {'project_id': projectId},
    );
    final list = response['routes'] as List<dynamic>? ?? [];
    return list
        .map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteRoute(String id) async {
    await _transport.unary(
      service: _service,
      method: 'DeleteRoute',
      request: {'id': id},
    );
  }

  Future<List<RouteModel>> optimizeRoutes(String projectId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'OptimizeRoutes',
      request: {'project_id': projectId},
    );
    final list = response['routes'] as List<dynamic>? ?? [];
    return list
        .map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
