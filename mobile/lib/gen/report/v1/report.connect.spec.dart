//
//  Generated code. Do not modify.
//  source: report/v1/report.proto
//

import "package:connectrpc/connect.dart" as connect;
import "report.pb.dart" as reportv1report;

abstract final class ReportService {
  /// Fully-qualified name of the ReportService service.
  static const name = 'report.v1.ReportService';

  static const generateReport = connect.Spec(
    '/$name/GenerateReport',
    connect.StreamType.unary,
    reportv1report.GenerateReportRequest.new,
    reportv1report.GenerateReportResponse.new,
  );

  static const getReport = connect.Spec(
    '/$name/GetReport',
    connect.StreamType.unary,
    reportv1report.GetReportRequest.new,
    reportv1report.GetReportResponse.new,
  );

  static const listReports = connect.Spec(
    '/$name/ListReports',
    connect.StreamType.unary,
    reportv1report.ListReportsRequest.new,
    reportv1report.ListReportsResponse.new,
  );

  static const deleteReport = connect.Spec(
    '/$name/DeleteReport',
    connect.StreamType.unary,
    reportv1report.DeleteReportRequest.new,
    reportv1report.DeleteReportResponse.new,
  );

  static const generateBOM = connect.Spec(
    '/$name/GenerateBOM',
    connect.StreamType.unary,
    reportv1report.GenerateBOMRequest.new,
    reportv1report.GenerateBOMResponse.new,
  );

  static const exportLayout = connect.Spec(
    '/$name/ExportLayout',
    connect.StreamType.unary,
    reportv1report.ExportLayoutRequest.new,
    reportv1report.ExportLayoutResponse.new,
  );
}
