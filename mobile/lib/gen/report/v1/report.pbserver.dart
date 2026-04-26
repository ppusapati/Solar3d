//
//  Generated code. Do not modify.
//  source: report/v1/report.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'report.pb.dart' as $1;
import 'report.pbjson.dart';

export 'report.pb.dart';

abstract class ReportServiceBase extends $pb.GeneratedService {
  $async.Future<$1.GenerateReportResponse> generateReport($pb.ServerContext ctx, $1.GenerateReportRequest request);
  $async.Future<$1.GetReportResponse> getReport($pb.ServerContext ctx, $1.GetReportRequest request);
  $async.Future<$1.ListReportsResponse> listReports($pb.ServerContext ctx, $1.ListReportsRequest request);
  $async.Future<$1.DeleteReportResponse> deleteReport($pb.ServerContext ctx, $1.DeleteReportRequest request);
  $async.Future<$1.GenerateBOMResponse> generateBOM($pb.ServerContext ctx, $1.GenerateBOMRequest request);
  $async.Future<$1.ExportLayoutResponse> exportLayout($pb.ServerContext ctx, $1.ExportLayoutRequest request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GenerateReport': return $1.GenerateReportRequest();
      case 'GetReport': return $1.GetReportRequest();
      case 'ListReports': return $1.ListReportsRequest();
      case 'DeleteReport': return $1.DeleteReportRequest();
      case 'GenerateBOM': return $1.GenerateBOMRequest();
      case 'ExportLayout': return $1.ExportLayoutRequest();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GenerateReport': return this.generateReport(ctx, request as $1.GenerateReportRequest);
      case 'GetReport': return this.getReport(ctx, request as $1.GetReportRequest);
      case 'ListReports': return this.listReports(ctx, request as $1.ListReportsRequest);
      case 'DeleteReport': return this.deleteReport(ctx, request as $1.DeleteReportRequest);
      case 'GenerateBOM': return this.generateBOM(ctx, request as $1.GenerateBOMRequest);
      case 'ExportLayout': return this.exportLayout(ctx, request as $1.ExportLayoutRequest);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ReportServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => ReportServiceBase$messageJson;
}

