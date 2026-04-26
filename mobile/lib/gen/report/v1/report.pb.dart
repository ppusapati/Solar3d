//
//  Generated code. Do not modify.
//  source: report/v1/report.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $0;
import 'report.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'report.pbenum.dart';

class Report extends $pb.GeneratedMessage {
  factory Report({
    $core.String? id,
    $core.String? projectId,
    $core.String? name,
    ReportType? reportType,
    ReportFormat? format,
    $core.String? filePath,
    ReportStatus? status,
    $0.Timestamp? createdAt,
    $0.Timestamp? completedAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (reportType != null) {
      $result.reportType = reportType;
    }
    if (format != null) {
      $result.format = format;
    }
    if (filePath != null) {
      $result.filePath = filePath;
    }
    if (status != null) {
      $result.status = status;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (completedAt != null) {
      $result.completedAt = completedAt;
    }
    return $result;
  }
  Report._() : super();
  factory Report.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Report.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Report', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..e<ReportType>(4, _omitFieldNames ? '' : 'reportType', $pb.PbFieldType.OE, defaultOrMaker: ReportType.REPORT_TYPE_UNSPECIFIED, valueOf: ReportType.valueOf, enumValues: ReportType.values)
    ..e<ReportFormat>(5, _omitFieldNames ? '' : 'format', $pb.PbFieldType.OE, defaultOrMaker: ReportFormat.REPORT_FORMAT_UNSPECIFIED, valueOf: ReportFormat.valueOf, enumValues: ReportFormat.values)
    ..aOS(6, _omitFieldNames ? '' : 'filePath')
    ..e<ReportStatus>(7, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: ReportStatus.REPORT_STATUS_UNSPECIFIED, valueOf: ReportStatus.valueOf, enumValues: ReportStatus.values)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'completedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Report clone() => Report()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Report copyWith(void Function(Report) updates) => super.copyWith((message) => updates(message as Report)) as Report;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Report create() => Report._();
  Report createEmptyInstance() => create();
  static $pb.PbList<Report> createRepeated() => $pb.PbList<Report>();
  @$core.pragma('dart2js:noInline')
  static Report getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Report>(create);
  static Report? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get projectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set projectId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  ReportType get reportType => $_getN(3);
  @$pb.TagNumber(4)
  set reportType(ReportType v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasReportType() => $_has(3);
  @$pb.TagNumber(4)
  void clearReportType() => $_clearField(4);

  @$pb.TagNumber(5)
  ReportFormat get format => $_getN(4);
  @$pb.TagNumber(5)
  set format(ReportFormat v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasFormat() => $_has(4);
  @$pb.TagNumber(5)
  void clearFormat() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get filePath => $_getSZ(5);
  @$pb.TagNumber(6)
  set filePath($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasFilePath() => $_has(5);
  @$pb.TagNumber(6)
  void clearFilePath() => $_clearField(6);

  @$pb.TagNumber(7)
  ReportStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(ReportStatus v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($0.Timestamp v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureCreatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get completedAt => $_getN(8);
  @$pb.TagNumber(9)
  set completedAt($0.Timestamp v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasCompletedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCompletedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureCompletedAt() => $_ensure(8);
}

class BOMItem extends $pb.GeneratedMessage {
  factory BOMItem({
    $core.String? category,
    $core.String? name,
    $core.String? specification,
    $core.int? quantity,
    $core.String? unit,
    $core.double? unitCost,
    $core.double? totalCost,
  }) {
    final $result = create();
    if (category != null) {
      $result.category = category;
    }
    if (name != null) {
      $result.name = name;
    }
    if (specification != null) {
      $result.specification = specification;
    }
    if (quantity != null) {
      $result.quantity = quantity;
    }
    if (unit != null) {
      $result.unit = unit;
    }
    if (unitCost != null) {
      $result.unitCost = unitCost;
    }
    if (totalCost != null) {
      $result.totalCost = totalCost;
    }
    return $result;
  }
  BOMItem._() : super();
  factory BOMItem.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BOMItem.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BOMItem', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'category')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'specification')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'quantity', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'unit')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'unitCost', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'totalCost', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BOMItem clone() => BOMItem()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BOMItem copyWith(void Function(BOMItem) updates) => super.copyWith((message) => updates(message as BOMItem)) as BOMItem;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BOMItem create() => BOMItem._();
  BOMItem createEmptyInstance() => create();
  static $pb.PbList<BOMItem> createRepeated() => $pb.PbList<BOMItem>();
  @$core.pragma('dart2js:noInline')
  static BOMItem getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BOMItem>(create);
  static BOMItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get category => $_getSZ(0);
  @$pb.TagNumber(1)
  set category($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get specification => $_getSZ(2);
  @$pb.TagNumber(3)
  set specification($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSpecification() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpecification() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get quantity => $_getIZ(3);
  @$pb.TagNumber(4)
  set quantity($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasQuantity() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get unit => $_getSZ(4);
  @$pb.TagNumber(5)
  set unit($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUnit() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnit() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get unitCost => $_getN(5);
  @$pb.TagNumber(6)
  set unitCost($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasUnitCost() => $_has(5);
  @$pb.TagNumber(6)
  void clearUnitCost() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get totalCost => $_getN(6);
  @$pb.TagNumber(7)
  set totalCost($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTotalCost() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalCost() => $_clearField(7);
}

class BillOfMaterials extends $pb.GeneratedMessage {
  factory BillOfMaterials({
    $core.Iterable<BOMItem>? items,
    $core.double? totalCost,
    $core.int? totalPanels,
    $core.int? totalInverters,
    $core.int? totalTransformers,
    $core.double? totalCableLengthM,
  }) {
    final $result = create();
    if (items != null) {
      $result.items.addAll(items);
    }
    if (totalCost != null) {
      $result.totalCost = totalCost;
    }
    if (totalPanels != null) {
      $result.totalPanels = totalPanels;
    }
    if (totalInverters != null) {
      $result.totalInverters = totalInverters;
    }
    if (totalTransformers != null) {
      $result.totalTransformers = totalTransformers;
    }
    if (totalCableLengthM != null) {
      $result.totalCableLengthM = totalCableLengthM;
    }
    return $result;
  }
  BillOfMaterials._() : super();
  factory BillOfMaterials.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BillOfMaterials.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BillOfMaterials', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..pc<BOMItem>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM, subBuilder: BOMItem.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'totalCost', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalPanels', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'totalInverters', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'totalTransformers', $pb.PbFieldType.O3)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'totalCableLengthM', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BillOfMaterials clone() => BillOfMaterials()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BillOfMaterials copyWith(void Function(BillOfMaterials) updates) => super.copyWith((message) => updates(message as BillOfMaterials)) as BillOfMaterials;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BillOfMaterials create() => BillOfMaterials._();
  BillOfMaterials createEmptyInstance() => create();
  static $pb.PbList<BillOfMaterials> createRepeated() => $pb.PbList<BillOfMaterials>();
  @$core.pragma('dart2js:noInline')
  static BillOfMaterials getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BillOfMaterials>(create);
  static BillOfMaterials? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<BOMItem> get items => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get totalCost => $_getN(1);
  @$pb.TagNumber(2)
  set totalCost($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalCost() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCost() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalPanels => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalPanels($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalPanels() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalPanels() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalInverters => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalInverters($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalInverters() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalInverters() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get totalTransformers => $_getIZ(4);
  @$pb.TagNumber(5)
  set totalTransformers($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalTransformers() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalTransformers() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalCableLengthM => $_getN(5);
  @$pb.TagNumber(6)
  set totalCableLengthM($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTotalCableLengthM() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalCableLengthM() => $_clearField(6);
}

class GenerateReportRequest extends $pb.GeneratedMessage {
  factory GenerateReportRequest({
    $core.String? projectId,
    $core.String? name,
    ReportType? reportType,
    ReportFormat? format,
    $core.String? approvalStatus,
    $core.String? approvedBy,
    $core.String? approvedAtRfc3339,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (reportType != null) {
      $result.reportType = reportType;
    }
    if (format != null) {
      $result.format = format;
    }
    if (approvalStatus != null) {
      $result.approvalStatus = approvalStatus;
    }
    if (approvedBy != null) {
      $result.approvedBy = approvedBy;
    }
    if (approvedAtRfc3339 != null) {
      $result.approvedAtRfc3339 = approvedAtRfc3339;
    }
    return $result;
  }
  GenerateReportRequest._() : super();
  factory GenerateReportRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateReportRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateReportRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..e<ReportType>(3, _omitFieldNames ? '' : 'reportType', $pb.PbFieldType.OE, defaultOrMaker: ReportType.REPORT_TYPE_UNSPECIFIED, valueOf: ReportType.valueOf, enumValues: ReportType.values)
    ..e<ReportFormat>(4, _omitFieldNames ? '' : 'format', $pb.PbFieldType.OE, defaultOrMaker: ReportFormat.REPORT_FORMAT_UNSPECIFIED, valueOf: ReportFormat.valueOf, enumValues: ReportFormat.values)
    ..aOS(5, _omitFieldNames ? '' : 'approvalStatus')
    ..aOS(6, _omitFieldNames ? '' : 'approvedBy')
    ..aOS(7, _omitFieldNames ? '' : 'approvedAtRfc3339')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateReportRequest clone() => GenerateReportRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateReportRequest copyWith(void Function(GenerateReportRequest) updates) => super.copyWith((message) => updates(message as GenerateReportRequest)) as GenerateReportRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateReportRequest create() => GenerateReportRequest._();
  GenerateReportRequest createEmptyInstance() => create();
  static $pb.PbList<GenerateReportRequest> createRepeated() => $pb.PbList<GenerateReportRequest>();
  @$core.pragma('dart2js:noInline')
  static GenerateReportRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateReportRequest>(create);
  static GenerateReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  ReportType get reportType => $_getN(2);
  @$pb.TagNumber(3)
  set reportType(ReportType v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasReportType() => $_has(2);
  @$pb.TagNumber(3)
  void clearReportType() => $_clearField(3);

  @$pb.TagNumber(4)
  ReportFormat get format => $_getN(3);
  @$pb.TagNumber(4)
  set format(ReportFormat v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFormat() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormat() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get approvalStatus => $_getSZ(4);
  @$pb.TagNumber(5)
  set approvalStatus($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasApprovalStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearApprovalStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get approvedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set approvedBy($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasApprovedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearApprovedBy() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get approvedAtRfc3339 => $_getSZ(6);
  @$pb.TagNumber(7)
  set approvedAtRfc3339($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasApprovedAtRfc3339() => $_has(6);
  @$pb.TagNumber(7)
  void clearApprovedAtRfc3339() => $_clearField(7);
}

class GenerateReportResponse extends $pb.GeneratedMessage {
  factory GenerateReportResponse({
    Report? report,
  }) {
    final $result = create();
    if (report != null) {
      $result.report = report;
    }
    return $result;
  }
  GenerateReportResponse._() : super();
  factory GenerateReportResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateReportResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateReportResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..aOM<Report>(1, _omitFieldNames ? '' : 'report', subBuilder: Report.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateReportResponse clone() => GenerateReportResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateReportResponse copyWith(void Function(GenerateReportResponse) updates) => super.copyWith((message) => updates(message as GenerateReportResponse)) as GenerateReportResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateReportResponse create() => GenerateReportResponse._();
  GenerateReportResponse createEmptyInstance() => create();
  static $pb.PbList<GenerateReportResponse> createRepeated() => $pb.PbList<GenerateReportResponse>();
  @$core.pragma('dart2js:noInline')
  static GenerateReportResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateReportResponse>(create);
  static GenerateReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Report get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(Report v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  Report ensureReport() => $_ensure(0);
}

class GetReportRequest extends $pb.GeneratedMessage {
  factory GetReportRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetReportRequest._() : super();
  factory GetReportRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetReportRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetReportRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetReportRequest clone() => GetReportRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetReportRequest copyWith(void Function(GetReportRequest) updates) => super.copyWith((message) => updates(message as GetReportRequest)) as GetReportRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReportRequest create() => GetReportRequest._();
  GetReportRequest createEmptyInstance() => create();
  static $pb.PbList<GetReportRequest> createRepeated() => $pb.PbList<GetReportRequest>();
  @$core.pragma('dart2js:noInline')
  static GetReportRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetReportRequest>(create);
  static GetReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetReportResponse extends $pb.GeneratedMessage {
  factory GetReportResponse({
    Report? report,
  }) {
    final $result = create();
    if (report != null) {
      $result.report = report;
    }
    return $result;
  }
  GetReportResponse._() : super();
  factory GetReportResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetReportResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetReportResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..aOM<Report>(1, _omitFieldNames ? '' : 'report', subBuilder: Report.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetReportResponse clone() => GetReportResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetReportResponse copyWith(void Function(GetReportResponse) updates) => super.copyWith((message) => updates(message as GetReportResponse)) as GetReportResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetReportResponse create() => GetReportResponse._();
  GetReportResponse createEmptyInstance() => create();
  static $pb.PbList<GetReportResponse> createRepeated() => $pb.PbList<GetReportResponse>();
  @$core.pragma('dart2js:noInline')
  static GetReportResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetReportResponse>(create);
  static GetReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Report get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(Report v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  Report ensureReport() => $_ensure(0);
}

class ListReportsRequest extends $pb.GeneratedMessage {
  factory ListReportsRequest({
    $core.String? projectId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    return $result;
  }
  ListReportsRequest._() : super();
  factory ListReportsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListReportsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListReportsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListReportsRequest clone() => ListReportsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListReportsRequest copyWith(void Function(ListReportsRequest) updates) => super.copyWith((message) => updates(message as ListReportsRequest)) as ListReportsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReportsRequest create() => ListReportsRequest._();
  ListReportsRequest createEmptyInstance() => create();
  static $pb.PbList<ListReportsRequest> createRepeated() => $pb.PbList<ListReportsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListReportsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListReportsRequest>(create);
  static ListReportsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);
}

class ListReportsResponse extends $pb.GeneratedMessage {
  factory ListReportsResponse({
    $core.Iterable<Report>? reports,
  }) {
    final $result = create();
    if (reports != null) {
      $result.reports.addAll(reports);
    }
    return $result;
  }
  ListReportsResponse._() : super();
  factory ListReportsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListReportsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListReportsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..pc<Report>(1, _omitFieldNames ? '' : 'reports', $pb.PbFieldType.PM, subBuilder: Report.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListReportsResponse clone() => ListReportsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListReportsResponse copyWith(void Function(ListReportsResponse) updates) => super.copyWith((message) => updates(message as ListReportsResponse)) as ListReportsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReportsResponse create() => ListReportsResponse._();
  ListReportsResponse createEmptyInstance() => create();
  static $pb.PbList<ListReportsResponse> createRepeated() => $pb.PbList<ListReportsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListReportsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListReportsResponse>(create);
  static ListReportsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Report> get reports => $_getList(0);
}

class DeleteReportRequest extends $pb.GeneratedMessage {
  factory DeleteReportRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteReportRequest._() : super();
  factory DeleteReportRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteReportRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteReportRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteReportRequest clone() => DeleteReportRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteReportRequest copyWith(void Function(DeleteReportRequest) updates) => super.copyWith((message) => updates(message as DeleteReportRequest)) as DeleteReportRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteReportRequest create() => DeleteReportRequest._();
  DeleteReportRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteReportRequest> createRepeated() => $pb.PbList<DeleteReportRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteReportRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteReportRequest>(create);
  static DeleteReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteReportResponse extends $pb.GeneratedMessage {
  factory DeleteReportResponse() => create();
  DeleteReportResponse._() : super();
  factory DeleteReportResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteReportResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteReportResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteReportResponse clone() => DeleteReportResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteReportResponse copyWith(void Function(DeleteReportResponse) updates) => super.copyWith((message) => updates(message as DeleteReportResponse)) as DeleteReportResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteReportResponse create() => DeleteReportResponse._();
  DeleteReportResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteReportResponse> createRepeated() => $pb.PbList<DeleteReportResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteReportResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteReportResponse>(create);
  static DeleteReportResponse? _defaultInstance;
}

class GenerateBOMRequest extends $pb.GeneratedMessage {
  factory GenerateBOMRequest({
    $core.String? projectId,
    $core.String? layoutId,
    $core.String? electricalNetworkId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (electricalNetworkId != null) {
      $result.electricalNetworkId = electricalNetworkId;
    }
    return $result;
  }
  GenerateBOMRequest._() : super();
  factory GenerateBOMRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateBOMRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateBOMRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..aOS(3, _omitFieldNames ? '' : 'electricalNetworkId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateBOMRequest clone() => GenerateBOMRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateBOMRequest copyWith(void Function(GenerateBOMRequest) updates) => super.copyWith((message) => updates(message as GenerateBOMRequest)) as GenerateBOMRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateBOMRequest create() => GenerateBOMRequest._();
  GenerateBOMRequest createEmptyInstance() => create();
  static $pb.PbList<GenerateBOMRequest> createRepeated() => $pb.PbList<GenerateBOMRequest>();
  @$core.pragma('dart2js:noInline')
  static GenerateBOMRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateBOMRequest>(create);
  static GenerateBOMRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get layoutId => $_getSZ(1);
  @$pb.TagNumber(2)
  set layoutId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayoutId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayoutId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get electricalNetworkId => $_getSZ(2);
  @$pb.TagNumber(3)
  set electricalNetworkId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasElectricalNetworkId() => $_has(2);
  @$pb.TagNumber(3)
  void clearElectricalNetworkId() => $_clearField(3);
}

class GenerateBOMResponse extends $pb.GeneratedMessage {
  factory GenerateBOMResponse({
    BillOfMaterials? bom,
  }) {
    final $result = create();
    if (bom != null) {
      $result.bom = bom;
    }
    return $result;
  }
  GenerateBOMResponse._() : super();
  factory GenerateBOMResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateBOMResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateBOMResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..aOM<BillOfMaterials>(1, _omitFieldNames ? '' : 'bom', subBuilder: BillOfMaterials.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateBOMResponse clone() => GenerateBOMResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateBOMResponse copyWith(void Function(GenerateBOMResponse) updates) => super.copyWith((message) => updates(message as GenerateBOMResponse)) as GenerateBOMResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateBOMResponse create() => GenerateBOMResponse._();
  GenerateBOMResponse createEmptyInstance() => create();
  static $pb.PbList<GenerateBOMResponse> createRepeated() => $pb.PbList<GenerateBOMResponse>();
  @$core.pragma('dart2js:noInline')
  static GenerateBOMResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateBOMResponse>(create);
  static GenerateBOMResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BillOfMaterials get bom => $_getN(0);
  @$pb.TagNumber(1)
  set bom(BillOfMaterials v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBom() => $_has(0);
  @$pb.TagNumber(1)
  void clearBom() => $_clearField(1);
  @$pb.TagNumber(1)
  BillOfMaterials ensureBom() => $_ensure(0);
}

class ExportLayoutRequest extends $pb.GeneratedMessage {
  factory ExportLayoutRequest({
    $core.String? projectId,
    $core.String? layoutId,
    ReportFormat? format,
    $core.String? approvalStatus,
    $core.String? approvedBy,
    $core.String? approvedAtRfc3339,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (format != null) {
      $result.format = format;
    }
    if (approvalStatus != null) {
      $result.approvalStatus = approvalStatus;
    }
    if (approvedBy != null) {
      $result.approvedBy = approvedBy;
    }
    if (approvedAtRfc3339 != null) {
      $result.approvedAtRfc3339 = approvedAtRfc3339;
    }
    return $result;
  }
  ExportLayoutRequest._() : super();
  factory ExportLayoutRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportLayoutRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExportLayoutRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..e<ReportFormat>(3, _omitFieldNames ? '' : 'format', $pb.PbFieldType.OE, defaultOrMaker: ReportFormat.REPORT_FORMAT_UNSPECIFIED, valueOf: ReportFormat.valueOf, enumValues: ReportFormat.values)
    ..aOS(4, _omitFieldNames ? '' : 'approvalStatus')
    ..aOS(5, _omitFieldNames ? '' : 'approvedBy')
    ..aOS(6, _omitFieldNames ? '' : 'approvedAtRfc3339')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportLayoutRequest clone() => ExportLayoutRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportLayoutRequest copyWith(void Function(ExportLayoutRequest) updates) => super.copyWith((message) => updates(message as ExportLayoutRequest)) as ExportLayoutRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExportLayoutRequest create() => ExportLayoutRequest._();
  ExportLayoutRequest createEmptyInstance() => create();
  static $pb.PbList<ExportLayoutRequest> createRepeated() => $pb.PbList<ExportLayoutRequest>();
  @$core.pragma('dart2js:noInline')
  static ExportLayoutRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportLayoutRequest>(create);
  static ExportLayoutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get layoutId => $_getSZ(1);
  @$pb.TagNumber(2)
  set layoutId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayoutId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayoutId() => $_clearField(2);

  @$pb.TagNumber(3)
  ReportFormat get format => $_getN(2);
  @$pb.TagNumber(3)
  set format(ReportFormat v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFormat() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormat() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get approvalStatus => $_getSZ(3);
  @$pb.TagNumber(4)
  set approvalStatus($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasApprovalStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearApprovalStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get approvedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set approvedBy($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasApprovedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearApprovedBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get approvedAtRfc3339 => $_getSZ(5);
  @$pb.TagNumber(6)
  set approvedAtRfc3339($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasApprovedAtRfc3339() => $_has(5);
  @$pb.TagNumber(6)
  void clearApprovedAtRfc3339() => $_clearField(6);
}

class ExportLayoutResponse extends $pb.GeneratedMessage {
  factory ExportLayoutResponse({
    $core.String? filePath,
  }) {
    final $result = create();
    if (filePath != null) {
      $result.filePath = filePath;
    }
    return $result;
  }
  ExportLayoutResponse._() : super();
  factory ExportLayoutResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportLayoutResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExportLayoutResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'report.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'filePath')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportLayoutResponse clone() => ExportLayoutResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportLayoutResponse copyWith(void Function(ExportLayoutResponse) updates) => super.copyWith((message) => updates(message as ExportLayoutResponse)) as ExportLayoutResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExportLayoutResponse create() => ExportLayoutResponse._();
  ExportLayoutResponse createEmptyInstance() => create();
  static $pb.PbList<ExportLayoutResponse> createRepeated() => $pb.PbList<ExportLayoutResponse>();
  @$core.pragma('dart2js:noInline')
  static ExportLayoutResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportLayoutResponse>(create);
  static ExportLayoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get filePath => $_getSZ(0);
  @$pb.TagNumber(1)
  set filePath($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFilePath() => $_has(0);
  @$pb.TagNumber(1)
  void clearFilePath() => $_clearField(1);
}

class ReportServiceApi {
  $pb.RpcClient _client;
  ReportServiceApi(this._client);

  $async.Future<GenerateReportResponse> generateReport($pb.ClientContext? ctx, GenerateReportRequest request) =>
    _client.invoke<GenerateReportResponse>(ctx, 'ReportService', 'GenerateReport', request, GenerateReportResponse())
  ;
  $async.Future<GetReportResponse> getReport($pb.ClientContext? ctx, GetReportRequest request) =>
    _client.invoke<GetReportResponse>(ctx, 'ReportService', 'GetReport', request, GetReportResponse())
  ;
  $async.Future<ListReportsResponse> listReports($pb.ClientContext? ctx, ListReportsRequest request) =>
    _client.invoke<ListReportsResponse>(ctx, 'ReportService', 'ListReports', request, ListReportsResponse())
  ;
  $async.Future<DeleteReportResponse> deleteReport($pb.ClientContext? ctx, DeleteReportRequest request) =>
    _client.invoke<DeleteReportResponse>(ctx, 'ReportService', 'DeleteReport', request, DeleteReportResponse())
  ;
  $async.Future<GenerateBOMResponse> generateBOM($pb.ClientContext? ctx, GenerateBOMRequest request) =>
    _client.invoke<GenerateBOMResponse>(ctx, 'ReportService', 'GenerateBOM', request, GenerateBOMResponse())
  ;
  $async.Future<ExportLayoutResponse> exportLayout($pb.ClientContext? ctx, ExportLayoutRequest request) =>
    _client.invoke<ExportLayoutResponse>(ctx, 'ReportService', 'ExportLayout', request, ExportLayoutResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
