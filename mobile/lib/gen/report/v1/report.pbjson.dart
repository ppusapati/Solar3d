//
//  Generated code. Do not modify.
//  source: report/v1/report.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use reportTypeDescriptor instead')
const ReportType$json = {
  '1': 'ReportType',
  '2': [
    {'1': 'REPORT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'REPORT_TYPE_SITE_LAYOUT', '2': 1},
    {'1': 'REPORT_TYPE_PANEL_LAYOUT', '2': 2},
    {'1': 'REPORT_TYPE_SYSTEM_CAPACITY', '2': 3},
    {'1': 'REPORT_TYPE_ELECTRICAL_DIAGRAM', '2': 4},
    {'1': 'REPORT_TYPE_BILL_OF_MATERIALS', '2': 5},
    {'1': 'REPORT_TYPE_ENERGY_ESTIMATE', '2': 6},
    {'1': 'REPORT_TYPE_FULL_ENGINEERING', '2': 7},
  ],
};

/// Descriptor for `ReportType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reportTypeDescriptor = $convert.base64Decode(
    'CgpSZXBvcnRUeXBlEhsKF1JFUE9SVF9UWVBFX1VOU1BFQ0lGSUVEEAASGwoXUkVQT1JUX1RZUE'
    'VfU0lURV9MQVlPVVQQARIcChhSRVBPUlRfVFlQRV9QQU5FTF9MQVlPVVQQAhIfChtSRVBPUlRf'
    'VFlQRV9TWVNURU1fQ0FQQUNJVFkQAxIiCh5SRVBPUlRfVFlQRV9FTEVDVFJJQ0FMX0RJQUdSQU'
    '0QBBIhCh1SRVBPUlRfVFlQRV9CSUxMX09GX01BVEVSSUFMUxAFEh8KG1JFUE9SVF9UWVBFX0VO'
    'RVJHWV9FU1RJTUFURRAGEiAKHFJFUE9SVF9UWVBFX0ZVTExfRU5HSU5FRVJJTkcQBw==');

@$core.Deprecated('Use reportFormatDescriptor instead')
const ReportFormat$json = {
  '1': 'ReportFormat',
  '2': [
    {'1': 'REPORT_FORMAT_UNSPECIFIED', '2': 0},
    {'1': 'REPORT_FORMAT_PDF', '2': 1},
    {'1': 'REPORT_FORMAT_CSV', '2': 2},
    {'1': 'REPORT_FORMAT_EXCEL', '2': 3},
    {'1': 'REPORT_FORMAT_JSON', '2': 4},
  ],
};

/// Descriptor for `ReportFormat`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reportFormatDescriptor = $convert.base64Decode(
    'CgxSZXBvcnRGb3JtYXQSHQoZUkVQT1JUX0ZPUk1BVF9VTlNQRUNJRklFRBAAEhUKEVJFUE9SVF'
    '9GT1JNQVRfUERGEAESFQoRUkVQT1JUX0ZPUk1BVF9DU1YQAhIXChNSRVBPUlRfRk9STUFUX0VY'
    'Q0VMEAMSFgoSUkVQT1JUX0ZPUk1BVF9KU09OEAQ=');

@$core.Deprecated('Use reportStatusDescriptor instead')
const ReportStatus$json = {
  '1': 'ReportStatus',
  '2': [
    {'1': 'REPORT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'REPORT_STATUS_PENDING', '2': 1},
    {'1': 'REPORT_STATUS_GENERATING', '2': 2},
    {'1': 'REPORT_STATUS_COMPLETED', '2': 3},
    {'1': 'REPORT_STATUS_FAILED', '2': 4},
  ],
};

/// Descriptor for `ReportStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List reportStatusDescriptor = $convert.base64Decode(
    'CgxSZXBvcnRTdGF0dXMSHQoZUkVQT1JUX1NUQVRVU19VTlNQRUNJRklFRBAAEhkKFVJFUE9SVF'
    '9TVEFUVVNfUEVORElORxABEhwKGFJFUE9SVF9TVEFUVVNfR0VORVJBVElORxACEhsKF1JFUE9S'
    'VF9TVEFUVVNfQ09NUExFVEVEEAMSGAoUUkVQT1JUX1NUQVRVU19GQUlMRUQQBA==');

@$core.Deprecated('Use reportDescriptor instead')
const Report$json = {
  '1': 'Report',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'report_type', '3': 4, '4': 1, '5': 14, '6': '.report.v1.ReportType', '10': 'reportType'},
    {'1': 'format', '3': 5, '4': 1, '5': 14, '6': '.report.v1.ReportFormat', '10': 'format'},
    {'1': 'file_path', '3': 6, '4': 1, '5': 9, '10': 'filePath'},
    {'1': 'status', '3': 7, '4': 1, '5': 14, '6': '.report.v1.ReportStatus', '10': 'status'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'completed_at', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'completedAt'},
  ],
};

/// Descriptor for `Report`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportDescriptor = $convert.base64Decode(
    'CgZSZXBvcnQSDgoCaWQYASABKAlSAmlkEh0KCnByb2plY3RfaWQYAiABKAlSCXByb2plY3RJZB'
    'ISCgRuYW1lGAMgASgJUgRuYW1lEjYKC3JlcG9ydF90eXBlGAQgASgOMhUucmVwb3J0LnYxLlJl'
    'cG9ydFR5cGVSCnJlcG9ydFR5cGUSLwoGZm9ybWF0GAUgASgOMhcucmVwb3J0LnYxLlJlcG9ydE'
    'Zvcm1hdFIGZm9ybWF0EhsKCWZpbGVfcGF0aBgGIAEoCVIIZmlsZVBhdGgSLwoGc3RhdHVzGAcg'
    'ASgOMhcucmVwb3J0LnYxLlJlcG9ydFN0YXR1c1IGc3RhdHVzEjkKCmNyZWF0ZWRfYXQYCCABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSPQoMY29tcGxldGVkX2F0'
    'GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILY29tcGxldGVkQXQ=');

@$core.Deprecated('Use bOMItemDescriptor instead')
const BOMItem$json = {
  '1': 'BOMItem',
  '2': [
    {'1': 'category', '3': 1, '4': 1, '5': 9, '10': 'category'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'specification', '3': 3, '4': 1, '5': 9, '10': 'specification'},
    {'1': 'quantity', '3': 4, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'unit', '3': 5, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'unit_cost', '3': 6, '4': 1, '5': 1, '10': 'unitCost'},
    {'1': 'total_cost', '3': 7, '4': 1, '5': 1, '10': 'totalCost'},
  ],
};

/// Descriptor for `BOMItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bOMItemDescriptor = $convert.base64Decode(
    'CgdCT01JdGVtEhoKCGNhdGVnb3J5GAEgASgJUghjYXRlZ29yeRISCgRuYW1lGAIgASgJUgRuYW'
    '1lEiQKDXNwZWNpZmljYXRpb24YAyABKAlSDXNwZWNpZmljYXRpb24SGgoIcXVhbnRpdHkYBCAB'
    'KAVSCHF1YW50aXR5EhIKBHVuaXQYBSABKAlSBHVuaXQSGwoJdW5pdF9jb3N0GAYgASgBUgh1bm'
    'l0Q29zdBIdCgp0b3RhbF9jb3N0GAcgASgBUgl0b3RhbENvc3Q=');

@$core.Deprecated('Use billOfMaterialsDescriptor instead')
const BillOfMaterials$json = {
  '1': 'BillOfMaterials',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.report.v1.BOMItem', '10': 'items'},
    {'1': 'total_cost', '3': 2, '4': 1, '5': 1, '10': 'totalCost'},
    {'1': 'total_panels', '3': 3, '4': 1, '5': 5, '10': 'totalPanels'},
    {'1': 'total_inverters', '3': 4, '4': 1, '5': 5, '10': 'totalInverters'},
    {'1': 'total_transformers', '3': 5, '4': 1, '5': 5, '10': 'totalTransformers'},
    {'1': 'total_cable_length_m', '3': 6, '4': 1, '5': 1, '10': 'totalCableLengthM'},
  ],
};

/// Descriptor for `BillOfMaterials`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List billOfMaterialsDescriptor = $convert.base64Decode(
    'Cg9CaWxsT2ZNYXRlcmlhbHMSKAoFaXRlbXMYASADKAsyEi5yZXBvcnQudjEuQk9NSXRlbVIFaX'
    'RlbXMSHQoKdG90YWxfY29zdBgCIAEoAVIJdG90YWxDb3N0EiEKDHRvdGFsX3BhbmVscxgDIAEo'
    'BVILdG90YWxQYW5lbHMSJwoPdG90YWxfaW52ZXJ0ZXJzGAQgASgFUg50b3RhbEludmVydGVycx'
    'ItChJ0b3RhbF90cmFuc2Zvcm1lcnMYBSABKAVSEXRvdGFsVHJhbnNmb3JtZXJzEi8KFHRvdGFs'
    'X2NhYmxlX2xlbmd0aF9tGAYgASgBUhF0b3RhbENhYmxlTGVuZ3RoTQ==');

@$core.Deprecated('Use generateReportRequestDescriptor instead')
const GenerateReportRequest$json = {
  '1': 'GenerateReportRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'report_type', '3': 3, '4': 1, '5': 14, '6': '.report.v1.ReportType', '10': 'reportType'},
    {'1': 'format', '3': 4, '4': 1, '5': 14, '6': '.report.v1.ReportFormat', '10': 'format'},
    {'1': 'approval_status', '3': 5, '4': 1, '5': 9, '10': 'approvalStatus'},
    {'1': 'approved_by', '3': 6, '4': 1, '5': 9, '10': 'approvedBy'},
    {'1': 'approved_at_rfc3339', '3': 7, '4': 1, '5': 9, '10': 'approvedAtRfc3339'},
  ],
};

/// Descriptor for `GenerateReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateReportRequestDescriptor = $convert.base64Decode(
    'ChVHZW5lcmF0ZVJlcG9ydFJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElkEh'
    'IKBG5hbWUYAiABKAlSBG5hbWUSNgoLcmVwb3J0X3R5cGUYAyABKA4yFS5yZXBvcnQudjEuUmVw'
    'b3J0VHlwZVIKcmVwb3J0VHlwZRIvCgZmb3JtYXQYBCABKA4yFy5yZXBvcnQudjEuUmVwb3J0Rm'
    '9ybWF0UgZmb3JtYXQSJwoPYXBwcm92YWxfc3RhdHVzGAUgASgJUg5hcHByb3ZhbFN0YXR1cxIf'
    'CgthcHByb3ZlZF9ieRgGIAEoCVIKYXBwcm92ZWRCeRIuChNhcHByb3ZlZF9hdF9yZmMzMzM5GA'
    'cgASgJUhFhcHByb3ZlZEF0UmZjMzMzOQ==');

@$core.Deprecated('Use generateReportResponseDescriptor instead')
const GenerateReportResponse$json = {
  '1': 'GenerateReportResponse',
  '2': [
    {'1': 'report', '3': 1, '4': 1, '5': 11, '6': '.report.v1.Report', '10': 'report'},
  ],
};

/// Descriptor for `GenerateReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateReportResponseDescriptor = $convert.base64Decode(
    'ChZHZW5lcmF0ZVJlcG9ydFJlc3BvbnNlEikKBnJlcG9ydBgBIAEoCzIRLnJlcG9ydC52MS5SZX'
    'BvcnRSBnJlcG9ydA==');

@$core.Deprecated('Use getReportRequestDescriptor instead')
const GetReportRequest$json = {
  '1': 'GetReportRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReportRequestDescriptor = $convert.base64Decode(
    'ChBHZXRSZXBvcnRSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use getReportResponseDescriptor instead')
const GetReportResponse$json = {
  '1': 'GetReportResponse',
  '2': [
    {'1': 'report', '3': 1, '4': 1, '5': 11, '6': '.report.v1.Report', '10': 'report'},
  ],
};

/// Descriptor for `GetReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getReportResponseDescriptor = $convert.base64Decode(
    'ChFHZXRSZXBvcnRSZXNwb25zZRIpCgZyZXBvcnQYASABKAsyES5yZXBvcnQudjEuUmVwb3J0Ug'
    'ZyZXBvcnQ=');

@$core.Deprecated('Use listReportsRequestDescriptor instead')
const ListReportsRequest$json = {
  '1': 'ListReportsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
  ],
};

/// Descriptor for `ListReportsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReportsRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0UmVwb3J0c1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElk');

@$core.Deprecated('Use listReportsResponseDescriptor instead')
const ListReportsResponse$json = {
  '1': 'ListReportsResponse',
  '2': [
    {'1': 'reports', '3': 1, '4': 3, '5': 11, '6': '.report.v1.Report', '10': 'reports'},
  ],
};

/// Descriptor for `ListReportsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReportsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0UmVwb3J0c1Jlc3BvbnNlEisKB3JlcG9ydHMYASADKAsyES5yZXBvcnQudjEuUmVwb3'
    'J0UgdyZXBvcnRz');

@$core.Deprecated('Use deleteReportRequestDescriptor instead')
const DeleteReportRequest$json = {
  '1': 'DeleteReportRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteReportRequestDescriptor = $convert.base64Decode(
    'ChNEZWxldGVSZXBvcnRSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use deleteReportResponseDescriptor instead')
const DeleteReportResponse$json = {
  '1': 'DeleteReportResponse',
};

/// Descriptor for `DeleteReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteReportResponseDescriptor = $convert.base64Decode(
    'ChREZWxldGVSZXBvcnRSZXNwb25zZQ==');

@$core.Deprecated('Use generateBOMRequestDescriptor instead')
const GenerateBOMRequest$json = {
  '1': 'GenerateBOMRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'electrical_network_id', '3': 3, '4': 1, '5': 9, '10': 'electricalNetworkId'},
  ],
};

/// Descriptor for `GenerateBOMRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateBOMRequestDescriptor = $convert.base64Decode(
    'ChJHZW5lcmF0ZUJPTVJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElkEhsKCW'
    'xheW91dF9pZBgCIAEoCVIIbGF5b3V0SWQSMgoVZWxlY3RyaWNhbF9uZXR3b3JrX2lkGAMgASgJ'
    'UhNlbGVjdHJpY2FsTmV0d29ya0lk');

@$core.Deprecated('Use generateBOMResponseDescriptor instead')
const GenerateBOMResponse$json = {
  '1': 'GenerateBOMResponse',
  '2': [
    {'1': 'bom', '3': 1, '4': 1, '5': 11, '6': '.report.v1.BillOfMaterials', '10': 'bom'},
  ],
};

/// Descriptor for `GenerateBOMResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateBOMResponseDescriptor = $convert.base64Decode(
    'ChNHZW5lcmF0ZUJPTVJlc3BvbnNlEiwKA2JvbRgBIAEoCzIaLnJlcG9ydC52MS5CaWxsT2ZNYX'
    'RlcmlhbHNSA2JvbQ==');

@$core.Deprecated('Use exportLayoutRequestDescriptor instead')
const ExportLayoutRequest$json = {
  '1': 'ExportLayoutRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'format', '3': 3, '4': 1, '5': 14, '6': '.report.v1.ReportFormat', '10': 'format'},
    {'1': 'approval_status', '3': 4, '4': 1, '5': 9, '10': 'approvalStatus'},
    {'1': 'approved_by', '3': 5, '4': 1, '5': 9, '10': 'approvedBy'},
    {'1': 'approved_at_rfc3339', '3': 6, '4': 1, '5': 9, '10': 'approvedAtRfc3339'},
  ],
};

/// Descriptor for `ExportLayoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportLayoutRequestDescriptor = $convert.base64Decode(
    'ChNFeHBvcnRMYXlvdXRSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZBIbCg'
    'lsYXlvdXRfaWQYAiABKAlSCGxheW91dElkEi8KBmZvcm1hdBgDIAEoDjIXLnJlcG9ydC52MS5S'
    'ZXBvcnRGb3JtYXRSBmZvcm1hdBInCg9hcHByb3ZhbF9zdGF0dXMYBCABKAlSDmFwcHJvdmFsU3'
    'RhdHVzEh8KC2FwcHJvdmVkX2J5GAUgASgJUgphcHByb3ZlZEJ5Ei4KE2FwcHJvdmVkX2F0X3Jm'
    'YzMzMzkYBiABKAlSEWFwcHJvdmVkQXRSZmMzMzM5');

@$core.Deprecated('Use exportLayoutResponseDescriptor instead')
const ExportLayoutResponse$json = {
  '1': 'ExportLayoutResponse',
  '2': [
    {'1': 'file_path', '3': 1, '4': 1, '5': 9, '10': 'filePath'},
  ],
};

/// Descriptor for `ExportLayoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportLayoutResponseDescriptor = $convert.base64Decode(
    'ChRFeHBvcnRMYXlvdXRSZXNwb25zZRIbCglmaWxlX3BhdGgYASABKAlSCGZpbGVQYXRo');

const $core.Map<$core.String, $core.dynamic> ReportServiceBase$json = {
  '1': 'ReportService',
  '2': [
    {'1': 'GenerateReport', '2': '.report.v1.GenerateReportRequest', '3': '.report.v1.GenerateReportResponse'},
    {'1': 'GetReport', '2': '.report.v1.GetReportRequest', '3': '.report.v1.GetReportResponse'},
    {'1': 'ListReports', '2': '.report.v1.ListReportsRequest', '3': '.report.v1.ListReportsResponse'},
    {'1': 'DeleteReport', '2': '.report.v1.DeleteReportRequest', '3': '.report.v1.DeleteReportResponse'},
    {'1': 'GenerateBOM', '2': '.report.v1.GenerateBOMRequest', '3': '.report.v1.GenerateBOMResponse'},
    {'1': 'ExportLayout', '2': '.report.v1.ExportLayoutRequest', '3': '.report.v1.ExportLayoutResponse'},
  ],
};

@$core.Deprecated('Use reportServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> ReportServiceBase$messageJson = {
  '.report.v1.GenerateReportRequest': GenerateReportRequest$json,
  '.report.v1.GenerateReportResponse': GenerateReportResponse$json,
  '.report.v1.Report': Report$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.report.v1.GetReportRequest': GetReportRequest$json,
  '.report.v1.GetReportResponse': GetReportResponse$json,
  '.report.v1.ListReportsRequest': ListReportsRequest$json,
  '.report.v1.ListReportsResponse': ListReportsResponse$json,
  '.report.v1.DeleteReportRequest': DeleteReportRequest$json,
  '.report.v1.DeleteReportResponse': DeleteReportResponse$json,
  '.report.v1.GenerateBOMRequest': GenerateBOMRequest$json,
  '.report.v1.GenerateBOMResponse': GenerateBOMResponse$json,
  '.report.v1.BillOfMaterials': BillOfMaterials$json,
  '.report.v1.BOMItem': BOMItem$json,
  '.report.v1.ExportLayoutRequest': ExportLayoutRequest$json,
  '.report.v1.ExportLayoutResponse': ExportLayoutResponse$json,
};

/// Descriptor for `ReportService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List reportServiceDescriptor = $convert.base64Decode(
    'Cg1SZXBvcnRTZXJ2aWNlElUKDkdlbmVyYXRlUmVwb3J0EiAucmVwb3J0LnYxLkdlbmVyYXRlUm'
    'Vwb3J0UmVxdWVzdBohLnJlcG9ydC52MS5HZW5lcmF0ZVJlcG9ydFJlc3BvbnNlEkYKCUdldFJl'
    'cG9ydBIbLnJlcG9ydC52MS5HZXRSZXBvcnRSZXF1ZXN0GhwucmVwb3J0LnYxLkdldFJlcG9ydF'
    'Jlc3BvbnNlEkwKC0xpc3RSZXBvcnRzEh0ucmVwb3J0LnYxLkxpc3RSZXBvcnRzUmVxdWVzdBoe'
    'LnJlcG9ydC52MS5MaXN0UmVwb3J0c1Jlc3BvbnNlEk8KDERlbGV0ZVJlcG9ydBIeLnJlcG9ydC'
    '52MS5EZWxldGVSZXBvcnRSZXF1ZXN0Gh8ucmVwb3J0LnYxLkRlbGV0ZVJlcG9ydFJlc3BvbnNl'
    'EkwKC0dlbmVyYXRlQk9NEh0ucmVwb3J0LnYxLkdlbmVyYXRlQk9NUmVxdWVzdBoeLnJlcG9ydC'
    '52MS5HZW5lcmF0ZUJPTVJlc3BvbnNlEk8KDEV4cG9ydExheW91dBIeLnJlcG9ydC52MS5FeHBv'
    'cnRMYXlvdXRSZXF1ZXN0Gh8ucmVwb3J0LnYxLkV4cG9ydExheW91dFJlc3BvbnNl');

