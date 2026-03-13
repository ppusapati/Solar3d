import '../models/electrical.dart';
import 'api_client.dart';

class ElectricalApi {
  final ApiClient _client;

  ElectricalApi(this._client);

  Future<List<ElectricalNetwork>> listNetworks(String projectId) async {
    return _client.get(
      '/api/v1/electrical/networks',
      queryParameters: {'project_id': projectId},
      parser: (data) {
        final list = data['networks'] as List<dynamic>? ?? [];
        return list
            .map((e) =>
                ElectricalNetwork.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<ElectricalNetwork> getNetwork(String id) async {
    return _client.get(
      '/api/v1/electrical/networks/$id',
      parser: (data) =>
          ElectricalNetwork.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<ElectricalNetwork> createNetwork({
    required String projectId,
    required String layoutId,
    required String name,
  }) async {
    return _client.post(
      '/api/v1/electrical/networks',
      data: {
        'project_id': projectId,
        'layout_id': layoutId,
        'name': name,
      },
      parser: (data) =>
          ElectricalNetwork.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<ElectricalNetwork> autoGenerateStrings(String networkId) async {
    return _client.post(
      '/api/v1/electrical/networks/$networkId/auto-generate',
      parser: (data) =>
          ElectricalNetwork.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<LossBreakdown> calculateLosses(String networkId) async {
    return _client.get(
      '/api/v1/electrical/networks/$networkId/losses',
      parser: (data) => LossBreakdown.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<void> deleteNetwork(String id) async {
    await _client.delete('/api/v1/electrical/networks/$id');
  }
}
