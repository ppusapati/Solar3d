import '../models/route.dart';
import 'api_client.dart';

class RoutingApi {
  final ApiClient _client;

  RoutingApi(this._client);

  Future<List<RouteModel>> listRoutes(String projectId) async {
    return _client.get(
      '/api/v1/routes',
      queryParameters: {'project_id': projectId},
      parser: (data) {
        final list = data['routes'] as List<dynamic>? ?? [];
        return list
            .map((e) => RouteModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<RouteModel> createRoute({
    required String projectId,
    required String layoutId,
    required String name,
    required String routeType,
    required List<Waypoint> waypoints,
    RouteConstraints? constraints,
  }) async {
    return _client.post(
      '/api/v1/routes',
      data: {
        'project_id': projectId,
        'layout_id': layoutId,
        'name': name,
        'route_type': routeType,
        'waypoints': waypoints.map((w) => w.toJson()).toList(),
        if (constraints != null) 'constraints': constraints.toJson(),
      },
      parser: (data) => RouteModel.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<void> deleteRoute(String id) async {
    await _client.delete('/api/v1/routes/$id');
  }
}
