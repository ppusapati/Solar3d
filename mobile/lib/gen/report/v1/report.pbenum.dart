//
//  Generated code. Do not modify.
//  source: report/v1/report.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ReportType extends $pb.ProtobufEnum {
  static const ReportType REPORT_TYPE_UNSPECIFIED = ReportType._(0, _omitEnumNames ? '' : 'REPORT_TYPE_UNSPECIFIED');
  static const ReportType REPORT_TYPE_SITE_LAYOUT = ReportType._(1, _omitEnumNames ? '' : 'REPORT_TYPE_SITE_LAYOUT');
  static const ReportType REPORT_TYPE_PANEL_LAYOUT = ReportType._(2, _omitEnumNames ? '' : 'REPORT_TYPE_PANEL_LAYOUT');
  static const ReportType REPORT_TYPE_SYSTEM_CAPACITY = ReportType._(3, _omitEnumNames ? '' : 'REPORT_TYPE_SYSTEM_CAPACITY');
  static const ReportType REPORT_TYPE_ELECTRICAL_DIAGRAM = ReportType._(4, _omitEnumNames ? '' : 'REPORT_TYPE_ELECTRICAL_DIAGRAM');
  static const ReportType REPORT_TYPE_BILL_OF_MATERIALS = ReportType._(5, _omitEnumNames ? '' : 'REPORT_TYPE_BILL_OF_MATERIALS');
  static const ReportType REPORT_TYPE_ENERGY_ESTIMATE = ReportType._(6, _omitEnumNames ? '' : 'REPORT_TYPE_ENERGY_ESTIMATE');
  static const ReportType REPORT_TYPE_FULL_ENGINEERING = ReportType._(7, _omitEnumNames ? '' : 'REPORT_TYPE_FULL_ENGINEERING');

  static const $core.List<ReportType> values = <ReportType> [
    REPORT_TYPE_UNSPECIFIED,
    REPORT_TYPE_SITE_LAYOUT,
    REPORT_TYPE_PANEL_LAYOUT,
    REPORT_TYPE_SYSTEM_CAPACITY,
    REPORT_TYPE_ELECTRICAL_DIAGRAM,
    REPORT_TYPE_BILL_OF_MATERIALS,
    REPORT_TYPE_ENERGY_ESTIMATE,
    REPORT_TYPE_FULL_ENGINEERING,
  ];

  static final $core.Map<$core.int, ReportType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ReportType? valueOf($core.int value) => _byValue[value];

  const ReportType._(super.v, super.n);
}

class ReportFormat extends $pb.ProtobufEnum {
  static const ReportFormat REPORT_FORMAT_UNSPECIFIED = ReportFormat._(0, _omitEnumNames ? '' : 'REPORT_FORMAT_UNSPECIFIED');
  static const ReportFormat REPORT_FORMAT_PDF = ReportFormat._(1, _omitEnumNames ? '' : 'REPORT_FORMAT_PDF');
  static const ReportFormat REPORT_FORMAT_CSV = ReportFormat._(2, _omitEnumNames ? '' : 'REPORT_FORMAT_CSV');
  static const ReportFormat REPORT_FORMAT_EXCEL = ReportFormat._(3, _omitEnumNames ? '' : 'REPORT_FORMAT_EXCEL');
  static const ReportFormat REPORT_FORMAT_JSON = ReportFormat._(4, _omitEnumNames ? '' : 'REPORT_FORMAT_JSON');

  static const $core.List<ReportFormat> values = <ReportFormat> [
    REPORT_FORMAT_UNSPECIFIED,
    REPORT_FORMAT_PDF,
    REPORT_FORMAT_CSV,
    REPORT_FORMAT_EXCEL,
    REPORT_FORMAT_JSON,
  ];

  static final $core.Map<$core.int, ReportFormat> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ReportFormat? valueOf($core.int value) => _byValue[value];

  const ReportFormat._(super.v, super.n);
}

class ReportStatus extends $pb.ProtobufEnum {
  static const ReportStatus REPORT_STATUS_UNSPECIFIED = ReportStatus._(0, _omitEnumNames ? '' : 'REPORT_STATUS_UNSPECIFIED');
  static const ReportStatus REPORT_STATUS_PENDING = ReportStatus._(1, _omitEnumNames ? '' : 'REPORT_STATUS_PENDING');
  static const ReportStatus REPORT_STATUS_GENERATING = ReportStatus._(2, _omitEnumNames ? '' : 'REPORT_STATUS_GENERATING');
  static const ReportStatus REPORT_STATUS_COMPLETED = ReportStatus._(3, _omitEnumNames ? '' : 'REPORT_STATUS_COMPLETED');
  static const ReportStatus REPORT_STATUS_FAILED = ReportStatus._(4, _omitEnumNames ? '' : 'REPORT_STATUS_FAILED');

  static const $core.List<ReportStatus> values = <ReportStatus> [
    REPORT_STATUS_UNSPECIFIED,
    REPORT_STATUS_PENDING,
    REPORT_STATUS_GENERATING,
    REPORT_STATUS_COMPLETED,
    REPORT_STATUS_FAILED,
  ];

  static final $core.Map<$core.int, ReportStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ReportStatus? valueOf($core.int value) => _byValue[value];

  const ReportStatus._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
