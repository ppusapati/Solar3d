import '../../models/electrical.dart';
import '../transport.dart';

class ElectricalServiceClient {
  static const _service = 'solar.electrical.v1.ElectricalService';
  final ConnectRpcTransport _transport;

  ElectricalServiceClient(this._transport);

  Future<ElectricalNetwork> createNetwork({
    required String projectId,
    required String layoutId,
    required String name,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'CreateNetwork',
      request: {
        'project_id': projectId,
        'layout_id': layoutId,
        'name': name,
      },
    );
    return ElectricalNetwork.fromJson(
        response['network'] as Map<String, dynamic>);
  }

  Future<ElectricalNetwork> getNetwork(String id) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetNetwork',
      request: {'id': id},
    );
    return ElectricalNetwork.fromJson(
        response['network'] as Map<String, dynamic>);
  }

  Future<List<ElectricalNetwork>> listNetworks(String projectId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'ListNetworks',
      request: {'project_id': projectId},
    );
    final list = response['networks'] as List<dynamic>? ?? [];
    return list
        .map((e) => ElectricalNetwork.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteNetwork(String id) async {
    await _transport.unary(
      service: _service,
      method: 'DeleteNetwork',
      request: {'id': id},
    );
  }

  Future<PanelString> createString({
    required String networkId,
    required String name,
    required List<String> panelIds,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'CreateString',
      request: {
        'network_id': networkId,
        'name': name,
        'panel_ids': panelIds,
      },
    );
    return PanelString.fromJson(
        response['panel_string'] as Map<String, dynamic>);
  }

  Future<ElectricalNetwork> autoGenerateStrings(String networkId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'AutoGenerateStrings',
      request: {'network_id': networkId},
    );
    return ElectricalNetwork.fromJson(
        response['network'] as Map<String, dynamic>);
  }

  Future<List<PanelString>> listStrings(String networkId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'ListStrings',
      request: {'network_id': networkId},
    );
    final list = response['strings'] as List<dynamic>? ?? [];
    return list
        .map((e) => PanelString.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> assignInverter({
    required String networkId,
    required String inverterId,
    required List<String> stringIds,
  }) async {
    return await _transport.unary(
      service: _service,
      method: 'AssignInverter',
      request: {
        'network_id': networkId,
        'inverter_id': inverterId,
        'string_ids': stringIds,
      },
    );
  }

  Future<double> calculateDCCapacity(String networkId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'CalculateDCCapacity',
      request: {'network_id': networkId},
    );
    return (response['dc_capacity_kw'] as num).toDouble();
  }

  Future<double> calculateACCapacity(String networkId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'CalculateACCapacity',
      request: {'network_id': networkId},
    );
    return (response['ac_capacity_kw'] as num).toDouble();
  }

  Future<LossBreakdown> calculateLosses(String networkId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'CalculateLosses',
      request: {'network_id': networkId},
    );
    return LossBreakdown.fromJson(
        response['losses'] as Map<String, dynamic>);
  }
}
