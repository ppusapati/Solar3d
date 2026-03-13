import '../../models/simulation.dart';
import '../transport.dart';

class SimulationServiceClient {
  static const _service = 'solar.simulation.v1.SimulationService';
  final ConnectRpcTransport _transport;

  SimulationServiceClient(this._transport);

  Future<Simulation> createSimulation({
    required String projectId,
    required String layoutId,
    required String name,
    required String simulationType,
    required SimulationParams params,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'CreateSimulation',
      request: {
        'project_id': projectId,
        'layout_id': layoutId,
        'name': name,
        'simulation_type': simulationType,
        'params': params.toJson(),
      },
    );
    return Simulation.fromJson(
        response['simulation'] as Map<String, dynamic>);
  }

  Future<Simulation> getSimulation(String id) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetSimulation',
      request: {'id': id},
    );
    return Simulation.fromJson(
        response['simulation'] as Map<String, dynamic>);
  }

  Future<List<Simulation>> listSimulations(String projectId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'ListSimulations',
      request: {'project_id': projectId},
    );
    final list = response['simulations'] as List<dynamic>? ?? [];
    return list
        .map((e) => Simulation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Simulation> runSimulation(String id) async {
    final response = await _transport.unary(
      service: _service,
      method: 'RunSimulation',
      request: {'id': id},
    );
    return Simulation.fromJson(
        response['simulation'] as Map<String, dynamic>);
  }

  Future<void> deleteSimulation(String id) async {
    await _transport.unary(
      service: _service,
      method: 'DeleteSimulation',
      request: {'id': id},
    );
  }

  Future<SunPosition> getSunPosition({
    required double latitude,
    required double longitude,
    required String timestamp,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetSunPosition',
      request: {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp,
      },
    );
    return SunPosition.fromJson(response as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> getShadowMap({
    required String layoutId,
    required String timestamp,
    required double latitude,
    required double longitude,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetShadowMap',
      request: {
        'layout_id': layoutId,
        'timestamp': timestamp,
        'latitude': latitude,
        'longitude': longitude,
      },
    );
    return (response['shadow_polygons'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
  }
}
