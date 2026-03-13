import '../models/project.dart';
import 'api_client.dart';

class ProjectApi {
  final ApiClient _client;

  ProjectApi(this._client);

  Future<List<Project>> listProjects({
    int pageSize = 50,
    String? pageToken,
  }) async {
    return _client.get(
      '/api/v1/projects',
      queryParameters: {
        'page_size': pageSize,
        if (pageToken != null) 'page_token': pageToken,
      },
      parser: (data) {
        final list = data['projects'] as List<dynamic>? ?? [];
        return list
            .map((e) => Project.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<Project> getProject(String id) async {
    return _client.get(
      '/api/v1/projects/$id',
      parser: (data) => Project.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Project> createProject(CreateProjectRequest request) async {
    return _client.post(
      '/api/v1/projects',
      data: request.toJson(),
      parser: (data) => Project.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Project> updateProject(String id, Map<String, dynamic> updates) async {
    return _client.put(
      '/api/v1/projects/$id',
      data: updates,
      parser: (data) => Project.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<void> deleteProject(String id) async {
    await _client.delete('/api/v1/projects/$id');
  }
}
