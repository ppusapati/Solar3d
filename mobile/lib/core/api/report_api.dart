import '../models/report.dart';
import 'api_client.dart';

class ReportApi {
  final ApiClient _client;

  ReportApi(this._client);

  Future<List<Report>> listReports(String projectId) async {
    return _client.get(
      '/api/v1/reports',
      queryParameters: {'project_id': projectId},
      parser: (data) {
        final list = data['reports'] as List<dynamic>? ?? [];
        return list
            .map((e) => Report.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<Report> getReport(String id) async {
    return _client.get(
      '/api/v1/reports/$id',
      parser: (data) => Report.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Report> generateReport({
    required String projectId,
    required String reportType,
    required String format,
    String? layoutId,
  }) async {
    return _client.post(
      '/api/v1/reports',
      data: {
        'project_id': projectId,
        'report_type': reportType,
        'format': format,
        if (layoutId != null) 'layout_id': layoutId,
      },
      parser: (data) => Report.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<BillOfMaterials> generateBOM(String projectId) async {
    return _client.post(
      '/api/v1/reports/bom',
      data: {'project_id': projectId},
      parser: (data) =>
          BillOfMaterials.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<void> deleteReport(String id) async {
    await _client.delete('/api/v1/reports/$id');
  }
}
