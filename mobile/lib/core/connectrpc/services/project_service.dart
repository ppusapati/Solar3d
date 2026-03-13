import '../../models/project.dart';
import '../transport.dart';

class ProjectServiceClient {
  static const _service = 'solar.project.v1.ProjectService';
  final ConnectRpcTransport _transport;

  ProjectServiceClient(this._transport);

  Future<Project> createProject({
    required String name,
    String? description,
    double? targetCapacityMw,
    String? locationName,
    String? clientName,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'CreateProject',
      request: {
        'name': name,
        if (description != null) 'description': description,
        if (targetCapacityMw != null) 'target_capacity_mw': targetCapacityMw,
        if (locationName != null) 'location_name': locationName,
        if (clientName != null) 'client_name': clientName,
      },
    );
    return Project.fromJson(response['project'] as Map<String, dynamic>);
  }

  Future<Project> getProject(String id) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetProject',
      request: {'id': id},
    );
    return Project.fromJson(response['project'] as Map<String, dynamic>);
  }

  Future<List<Project>> listProjects({
    int pageSize = 50,
    String? pageToken,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'ListProjects',
      request: {
        'page_size': pageSize,
        if (pageToken != null) 'page_token': pageToken,
      },
    );
    final list = response['projects'] as List<dynamic>? ?? [];
    return list
        .map((e) => Project.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Project> updateProject(String id, Map<String, dynamic> updates) async {
    final response = await _transport.unary(
      service: _service,
      method: 'UpdateProject',
      request: {'id': id, ...updates},
    );
    return Project.fromJson(response['project'] as Map<String, dynamic>);
  }

  Future<void> deleteProject(String id) async {
    await _transport.unary(
      service: _service,
      method: 'DeleteProject',
      request: {'id': id},
    );
  }
}
