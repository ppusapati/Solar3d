import '../../models/report.dart';
import '../transport.dart';

class ReportServiceClient {
  static const _service = 'report.v1.ReportService';
  final ConnectRpcTransport _transport;

  ReportServiceClient(this._transport);

  Future<Report> generateReport({
    required String projectId,
    required String reportType,
    required String format,
    String? layoutId,
  }) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GenerateReport',
      request: {
        'project_id': projectId,
        'report_type': reportType,
        'format': format,
        if (layoutId != null) 'layout_id': layoutId,
      },
    );
    return Report.fromJson(response['report'] as Map<String, dynamic>);
  }

  Future<Report> getReport(String id) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GetReport',
      request: {'id': id},
    );
    return Report.fromJson(response['report'] as Map<String, dynamic>);
  }

  Future<List<Report>> listReports(String projectId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'ListReports',
      request: {'project_id': projectId},
    );
    final list = response['reports'] as List<dynamic>? ?? [];
    return list
        .map((e) => Report.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteReport(String id) async {
    await _transport.unary(
      service: _service,
      method: 'DeleteReport',
      request: {'id': id},
    );
  }

  Future<BillOfMaterials> generateBOM(String projectId) async {
    final response = await _transport.unary(
      service: _service,
      method: 'GenerateBOM',
      request: {'project_id': projectId},
    );
    return BillOfMaterials.fromJson(response['bom'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> exportLayout({
    required String layoutId,
    required String format,
  }) async {
    return await _transport.unary(
      service: _service,
      method: 'ExportLayout',
      request: {
        'layout_id': layoutId,
        'format': format,
      },
    );
  }
}
