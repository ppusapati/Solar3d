import '../models/simulation.dart';
import 'api_client.dart';

class SimulationApi {
  final ApiClient _client;

  SimulationApi(this._client);

  Future<List<Simulation>> listSimulations(String projectId) async {
    return _client.get(
      '/api/v1/simulations',
      queryParameters: {'project_id': projectId},
      parser: (data) {
        final list = data['simulations'] as List<dynamic>? ?? [];
        return list
            .map((e) => Simulation.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<Simulation> getSimulation(String id) async {
    return _client.get(
      '/api/v1/simulations/$id',
      parser: (data) => Simulation.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Simulation> createSimulation({
    required String projectId,
    required String layoutId,
    required String name,
    required String simulationType,
    required SimulationParams params,
  }) async {
    return _client.post(
      '/api/v1/simulations',
      data: {
        'project_id': projectId,
        'layout_id': layoutId,
        'name': name,
        'simulation_type': simulationType,
        'params': params.toJson(),
      },
      parser: (data) => Simulation.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Simulation> runSimulation(String id) async {
    return _client.post(
      '/api/v1/simulations/$id/run',
      parser: (data) => Simulation.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<void> deleteSimulation(String id) async {
    await _client.delete('/api/v1/simulations/$id');
  }

  Future<SunPosition> getSunPosition({
    required double latitude,
    required double longitude,
    required String timestamp,
  }) async {
    return _client.get(
      '/api/v1/sun-position',
      queryParameters: {
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': timestamp,
      },
      parser: (data) => SunPosition.fromJson(data as Map<String, dynamic>),
    );
  }
}
