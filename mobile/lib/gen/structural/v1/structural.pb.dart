//
//  Generated code. Do not modify.
//  source: structural/v1/structural.proto
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
import 'structural.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'structural.pbenum.dart';

class StructuralDesign extends $pb.GeneratedMessage {
  factory StructuralDesign({
    $core.String? id,
    $core.String? projectId,
    $core.String? name,
    ReviewState? reviewState,
    $core.String? reviewedBy,
    $core.String? reviewNotes,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $core.double? deadLoadKn,
    $core.double? windLoadKn,
    $core.double? seismicLoadKn,
    $core.double? governingLoadKn,
    FoundationResult? foundation,
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
    if (reviewState != null) {
      $result.reviewState = reviewState;
    }
    if (reviewedBy != null) {
      $result.reviewedBy = reviewedBy;
    }
    if (reviewNotes != null) {
      $result.reviewNotes = reviewNotes;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    if (deadLoadKn != null) {
      $result.deadLoadKn = deadLoadKn;
    }
    if (windLoadKn != null) {
      $result.windLoadKn = windLoadKn;
    }
    if (seismicLoadKn != null) {
      $result.seismicLoadKn = seismicLoadKn;
    }
    if (governingLoadKn != null) {
      $result.governingLoadKn = governingLoadKn;
    }
    if (foundation != null) {
      $result.foundation = foundation;
    }
    return $result;
  }
  StructuralDesign._() : super();
  factory StructuralDesign.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StructuralDesign.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StructuralDesign', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..e<ReviewState>(4, _omitFieldNames ? '' : 'reviewState', $pb.PbFieldType.OE, defaultOrMaker: ReviewState.REVIEW_STATE_UNSPECIFIED, valueOf: ReviewState.valueOf, enumValues: ReviewState.values)
    ..aOS(5, _omitFieldNames ? '' : 'reviewedBy')
    ..aOS(6, _omitFieldNames ? '' : 'reviewNotes')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'deadLoadKn', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'windLoadKn', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'seismicLoadKn', $pb.PbFieldType.OD)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'governingLoadKn', $pb.PbFieldType.OD)
    ..aOM<FoundationResult>(13, _omitFieldNames ? '' : 'foundation', subBuilder: FoundationResult.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StructuralDesign clone() => StructuralDesign()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StructuralDesign copyWith(void Function(StructuralDesign) updates) => super.copyWith((message) => updates(message as StructuralDesign)) as StructuralDesign;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StructuralDesign create() => StructuralDesign._();
  StructuralDesign createEmptyInstance() => create();
  static $pb.PbList<StructuralDesign> createRepeated() => $pb.PbList<StructuralDesign>();
  @$core.pragma('dart2js:noInline')
  static StructuralDesign getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StructuralDesign>(create);
  static StructuralDesign? _defaultInstance;

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
  ReviewState get reviewState => $_getN(3);
  @$pb.TagNumber(4)
  set reviewState(ReviewState v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasReviewState() => $_has(3);
  @$pb.TagNumber(4)
  void clearReviewState() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reviewedBy => $_getSZ(4);
  @$pb.TagNumber(5)
  set reviewedBy($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasReviewedBy() => $_has(4);
  @$pb.TagNumber(5)
  void clearReviewedBy() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get reviewNotes => $_getSZ(5);
  @$pb.TagNumber(6)
  set reviewNotes($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasReviewNotes() => $_has(5);
  @$pb.TagNumber(6)
  void clearReviewNotes() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get createdAt => $_getN(6);
  @$pb.TagNumber(7)
  set createdAt($0.Timestamp v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCreatedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get updatedAt => $_getN(7);
  @$pb.TagNumber(8)
  set updatedAt($0.Timestamp v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureUpdatedAt() => $_ensure(7);

  /// Snapshot of the last computed loads (populated after ComputeX calls)
  @$pb.TagNumber(9)
  $core.double get deadLoadKn => $_getN(8);
  @$pb.TagNumber(9)
  set deadLoadKn($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasDeadLoadKn() => $_has(8);
  @$pb.TagNumber(9)
  void clearDeadLoadKn() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get windLoadKn => $_getN(9);
  @$pb.TagNumber(10)
  set windLoadKn($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasWindLoadKn() => $_has(9);
  @$pb.TagNumber(10)
  void clearWindLoadKn() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get seismicLoadKn => $_getN(10);
  @$pb.TagNumber(11)
  set seismicLoadKn($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasSeismicLoadKn() => $_has(10);
  @$pb.TagNumber(11)
  void clearSeismicLoadKn() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get governingLoadKn => $_getN(11);
  @$pb.TagNumber(12)
  set governingLoadKn($core.double v) { $_setDouble(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasGoverningLoadKn() => $_has(11);
  @$pb.TagNumber(12)
  void clearGoverningLoadKn() => $_clearField(12);

  @$pb.TagNumber(13)
  FoundationResult get foundation => $_getN(12);
  @$pb.TagNumber(13)
  set foundation(FoundationResult v) { $_setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasFoundation() => $_has(12);
  @$pb.TagNumber(13)
  void clearFoundation() => $_clearField(13);
  @$pb.TagNumber(13)
  FoundationResult ensureFoundation() => $_ensure(12);
}

class ComputeDeadLoadRequest extends $pb.GeneratedMessage {
  factory ComputeDeadLoadRequest({
    $core.String? designId,
    $core.int? panelCount,
    $core.double? panelMassKg,
    $core.double? mountingMassPerPanelKg,
    $core.double? cableMassKg,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (panelCount != null) {
      $result.panelCount = panelCount;
    }
    if (panelMassKg != null) {
      $result.panelMassKg = panelMassKg;
    }
    if (mountingMassPerPanelKg != null) {
      $result.mountingMassPerPanelKg = mountingMassPerPanelKg;
    }
    if (cableMassKg != null) {
      $result.cableMassKg = cableMassKg;
    }
    return $result;
  }
  ComputeDeadLoadRequest._() : super();
  factory ComputeDeadLoadRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeDeadLoadRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeDeadLoadRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'panelCount', $pb.PbFieldType.O3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'panelMassKg', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'mountingMassPerPanelKg', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'cableMassKg', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeDeadLoadRequest clone() => ComputeDeadLoadRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeDeadLoadRequest copyWith(void Function(ComputeDeadLoadRequest) updates) => super.copyWith((message) => updates(message as ComputeDeadLoadRequest)) as ComputeDeadLoadRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeDeadLoadRequest create() => ComputeDeadLoadRequest._();
  ComputeDeadLoadRequest createEmptyInstance() => create();
  static $pb.PbList<ComputeDeadLoadRequest> createRepeated() => $pb.PbList<ComputeDeadLoadRequest>();
  @$core.pragma('dart2js:noInline')
  static ComputeDeadLoadRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeDeadLoadRequest>(create);
  static ComputeDeadLoadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get panelCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set panelCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPanelCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearPanelCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get panelMassKg => $_getN(2);
  @$pb.TagNumber(3)
  set panelMassKg($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPanelMassKg() => $_has(2);
  @$pb.TagNumber(3)
  void clearPanelMassKg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get mountingMassPerPanelKg => $_getN(3);
  @$pb.TagNumber(4)
  set mountingMassPerPanelKg($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMountingMassPerPanelKg() => $_has(3);
  @$pb.TagNumber(4)
  void clearMountingMassPerPanelKg() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get cableMassKg => $_getN(4);
  @$pb.TagNumber(5)
  set cableMassKg($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCableMassKg() => $_has(4);
  @$pb.TagNumber(5)
  void clearCableMassKg() => $_clearField(5);
}

class ComputeDeadLoadResponse extends $pb.GeneratedMessage {
  factory ComputeDeadLoadResponse({
    $core.String? designId,
    $core.double? panelMassTotalKg,
    $core.double? mountingMassTotalKg,
    $core.double? cableMassKg,
    $core.double? totalMassKg,
    $core.double? deadLoadKn,
    $core.String? equation,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (panelMassTotalKg != null) {
      $result.panelMassTotalKg = panelMassTotalKg;
    }
    if (mountingMassTotalKg != null) {
      $result.mountingMassTotalKg = mountingMassTotalKg;
    }
    if (cableMassKg != null) {
      $result.cableMassKg = cableMassKg;
    }
    if (totalMassKg != null) {
      $result.totalMassKg = totalMassKg;
    }
    if (deadLoadKn != null) {
      $result.deadLoadKn = deadLoadKn;
    }
    if (equation != null) {
      $result.equation = equation;
    }
    return $result;
  }
  ComputeDeadLoadResponse._() : super();
  factory ComputeDeadLoadResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeDeadLoadResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeDeadLoadResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'panelMassTotalKg', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'mountingMassTotalKg', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'cableMassKg', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'totalMassKg', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'deadLoadKn', $pb.PbFieldType.OD)
    ..aOS(7, _omitFieldNames ? '' : 'equation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeDeadLoadResponse clone() => ComputeDeadLoadResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeDeadLoadResponse copyWith(void Function(ComputeDeadLoadResponse) updates) => super.copyWith((message) => updates(message as ComputeDeadLoadResponse)) as ComputeDeadLoadResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeDeadLoadResponse create() => ComputeDeadLoadResponse._();
  ComputeDeadLoadResponse createEmptyInstance() => create();
  static $pb.PbList<ComputeDeadLoadResponse> createRepeated() => $pb.PbList<ComputeDeadLoadResponse>();
  @$core.pragma('dart2js:noInline')
  static ComputeDeadLoadResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeDeadLoadResponse>(create);
  static ComputeDeadLoadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get panelMassTotalKg => $_getN(1);
  @$pb.TagNumber(2)
  set panelMassTotalKg($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPanelMassTotalKg() => $_has(1);
  @$pb.TagNumber(2)
  void clearPanelMassTotalKg() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get mountingMassTotalKg => $_getN(2);
  @$pb.TagNumber(3)
  set mountingMassTotalKg($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMountingMassTotalKg() => $_has(2);
  @$pb.TagNumber(3)
  void clearMountingMassTotalKg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get cableMassKg => $_getN(3);
  @$pb.TagNumber(4)
  set cableMassKg($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCableMassKg() => $_has(3);
  @$pb.TagNumber(4)
  void clearCableMassKg() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalMassKg => $_getN(4);
  @$pb.TagNumber(5)
  set totalMassKg($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalMassKg() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalMassKg() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get deadLoadKn => $_getN(5);
  @$pb.TagNumber(6)
  set deadLoadKn($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDeadLoadKn() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeadLoadKn() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get equation => $_getSZ(6);
  @$pb.TagNumber(7)
  set equation($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasEquation() => $_has(6);
  @$pb.TagNumber(7)
  void clearEquation() => $_clearField(7);
}

class ComputeWindLoadRequest extends $pb.GeneratedMessage {
  factory ComputeWindLoadRequest({
    $core.String? designId,
    $core.double? windSpeedMS,
    ExposureCategory? exposure,
    $core.double? heightM,
    $core.double? panelTiltDeg,
    $core.double? totalPanelAreaSqm,
    $core.double? kZt,
    $core.double? kD,
    $core.double? gustFactor,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (windSpeedMS != null) {
      $result.windSpeedMS = windSpeedMS;
    }
    if (exposure != null) {
      $result.exposure = exposure;
    }
    if (heightM != null) {
      $result.heightM = heightM;
    }
    if (panelTiltDeg != null) {
      $result.panelTiltDeg = panelTiltDeg;
    }
    if (totalPanelAreaSqm != null) {
      $result.totalPanelAreaSqm = totalPanelAreaSqm;
    }
    if (kZt != null) {
      $result.kZt = kZt;
    }
    if (kD != null) {
      $result.kD = kD;
    }
    if (gustFactor != null) {
      $result.gustFactor = gustFactor;
    }
    return $result;
  }
  ComputeWindLoadRequest._() : super();
  factory ComputeWindLoadRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeWindLoadRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeWindLoadRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'windSpeedMS', $pb.PbFieldType.OD)
    ..e<ExposureCategory>(3, _omitFieldNames ? '' : 'exposure', $pb.PbFieldType.OE, defaultOrMaker: ExposureCategory.EXPOSURE_CATEGORY_UNSPECIFIED, valueOf: ExposureCategory.valueOf, enumValues: ExposureCategory.values)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'heightM', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'panelTiltDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'totalPanelAreaSqm', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'kZt', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'kD', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'gustFactor', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeWindLoadRequest clone() => ComputeWindLoadRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeWindLoadRequest copyWith(void Function(ComputeWindLoadRequest) updates) => super.copyWith((message) => updates(message as ComputeWindLoadRequest)) as ComputeWindLoadRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeWindLoadRequest create() => ComputeWindLoadRequest._();
  ComputeWindLoadRequest createEmptyInstance() => create();
  static $pb.PbList<ComputeWindLoadRequest> createRepeated() => $pb.PbList<ComputeWindLoadRequest>();
  @$core.pragma('dart2js:noInline')
  static ComputeWindLoadRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeWindLoadRequest>(create);
  static ComputeWindLoadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get windSpeedMS => $_getN(1);
  @$pb.TagNumber(2)
  set windSpeedMS($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasWindSpeedMS() => $_has(1);
  @$pb.TagNumber(2)
  void clearWindSpeedMS() => $_clearField(2);

  @$pb.TagNumber(3)
  ExposureCategory get exposure => $_getN(2);
  @$pb.TagNumber(3)
  set exposure(ExposureCategory v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasExposure() => $_has(2);
  @$pb.TagNumber(3)
  void clearExposure() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get heightM => $_getN(3);
  @$pb.TagNumber(4)
  set heightM($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeightM() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeightM() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get panelTiltDeg => $_getN(4);
  @$pb.TagNumber(5)
  set panelTiltDeg($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPanelTiltDeg() => $_has(4);
  @$pb.TagNumber(5)
  void clearPanelTiltDeg() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalPanelAreaSqm => $_getN(5);
  @$pb.TagNumber(6)
  set totalPanelAreaSqm($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTotalPanelAreaSqm() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalPanelAreaSqm() => $_clearField(6);

  /// Optional — if 0, code defaults are used
  @$pb.TagNumber(7)
  $core.double get kZt => $_getN(6);
  @$pb.TagNumber(7)
  set kZt($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasKZt() => $_has(6);
  @$pb.TagNumber(7)
  void clearKZt() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get kD => $_getN(7);
  @$pb.TagNumber(8)
  set kD($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasKD() => $_has(7);
  @$pb.TagNumber(8)
  void clearKD() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get gustFactor => $_getN(8);
  @$pb.TagNumber(9)
  set gustFactor($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasGustFactor() => $_has(8);
  @$pb.TagNumber(9)
  void clearGustFactor() => $_clearField(9);
}

class ComputeWindLoadResponse extends $pb.GeneratedMessage {
  factory ComputeWindLoadResponse({
    $core.String? designId,
    $core.double? kZ,
    $core.double? qZPa,
    $core.double? cP,
    $core.double? pressurePa,
    $core.double? totalWindForceKn,
    $core.double? windUpliftKn,
    $core.String? equation,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (kZ != null) {
      $result.kZ = kZ;
    }
    if (qZPa != null) {
      $result.qZPa = qZPa;
    }
    if (cP != null) {
      $result.cP = cP;
    }
    if (pressurePa != null) {
      $result.pressurePa = pressurePa;
    }
    if (totalWindForceKn != null) {
      $result.totalWindForceKn = totalWindForceKn;
    }
    if (windUpliftKn != null) {
      $result.windUpliftKn = windUpliftKn;
    }
    if (equation != null) {
      $result.equation = equation;
    }
    return $result;
  }
  ComputeWindLoadResponse._() : super();
  factory ComputeWindLoadResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeWindLoadResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeWindLoadResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'kZ', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'qZPa', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'cP', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'pressurePa', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'totalWindForceKn', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'windUpliftKn', $pb.PbFieldType.OD)
    ..aOS(8, _omitFieldNames ? '' : 'equation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeWindLoadResponse clone() => ComputeWindLoadResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeWindLoadResponse copyWith(void Function(ComputeWindLoadResponse) updates) => super.copyWith((message) => updates(message as ComputeWindLoadResponse)) as ComputeWindLoadResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeWindLoadResponse create() => ComputeWindLoadResponse._();
  ComputeWindLoadResponse createEmptyInstance() => create();
  static $pb.PbList<ComputeWindLoadResponse> createRepeated() => $pb.PbList<ComputeWindLoadResponse>();
  @$core.pragma('dart2js:noInline')
  static ComputeWindLoadResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeWindLoadResponse>(create);
  static ComputeWindLoadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get kZ => $_getN(1);
  @$pb.TagNumber(2)
  set kZ($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasKZ() => $_has(1);
  @$pb.TagNumber(2)
  void clearKZ() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get qZPa => $_getN(2);
  @$pb.TagNumber(3)
  set qZPa($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasQZPa() => $_has(2);
  @$pb.TagNumber(3)
  void clearQZPa() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get cP => $_getN(3);
  @$pb.TagNumber(4)
  set cP($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCP() => $_has(3);
  @$pb.TagNumber(4)
  void clearCP() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get pressurePa => $_getN(4);
  @$pb.TagNumber(5)
  set pressurePa($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPressurePa() => $_has(4);
  @$pb.TagNumber(5)
  void clearPressurePa() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalWindForceKn => $_getN(5);
  @$pb.TagNumber(6)
  set totalWindForceKn($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTotalWindForceKn() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalWindForceKn() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get windUpliftKn => $_getN(6);
  @$pb.TagNumber(7)
  set windUpliftKn($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasWindUpliftKn() => $_has(6);
  @$pb.TagNumber(7)
  void clearWindUpliftKn() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get equation => $_getSZ(7);
  @$pb.TagNumber(8)
  set equation($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasEquation() => $_has(7);
  @$pb.TagNumber(8)
  void clearEquation() => $_clearField(8);
}

class ComputeSeismicLoadRequest extends $pb.GeneratedMessage {
  factory ComputeSeismicLoadRequest({
    $core.String? designId,
    $core.double? sds,
    $core.double? totalMassKg,
    $core.double? rFactor,
    $core.double? importanceFactor,
    $core.double? csOverride,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (sds != null) {
      $result.sds = sds;
    }
    if (totalMassKg != null) {
      $result.totalMassKg = totalMassKg;
    }
    if (rFactor != null) {
      $result.rFactor = rFactor;
    }
    if (importanceFactor != null) {
      $result.importanceFactor = importanceFactor;
    }
    if (csOverride != null) {
      $result.csOverride = csOverride;
    }
    return $result;
  }
  ComputeSeismicLoadRequest._() : super();
  factory ComputeSeismicLoadRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeSeismicLoadRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeSeismicLoadRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'sds', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'totalMassKg', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'rFactor', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'importanceFactor', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'csOverride', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeSeismicLoadRequest clone() => ComputeSeismicLoadRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeSeismicLoadRequest copyWith(void Function(ComputeSeismicLoadRequest) updates) => super.copyWith((message) => updates(message as ComputeSeismicLoadRequest)) as ComputeSeismicLoadRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeSeismicLoadRequest create() => ComputeSeismicLoadRequest._();
  ComputeSeismicLoadRequest createEmptyInstance() => create();
  static $pb.PbList<ComputeSeismicLoadRequest> createRepeated() => $pb.PbList<ComputeSeismicLoadRequest>();
  @$core.pragma('dart2js:noInline')
  static ComputeSeismicLoadRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeSeismicLoadRequest>(create);
  static ComputeSeismicLoadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get sds => $_getN(1);
  @$pb.TagNumber(2)
  set sds($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSds() => $_has(1);
  @$pb.TagNumber(2)
  void clearSds() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get totalMassKg => $_getN(2);
  @$pb.TagNumber(3)
  set totalMassKg($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalMassKg() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalMassKg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get rFactor => $_getN(3);
  @$pb.TagNumber(4)
  set rFactor($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRFactor() => $_has(3);
  @$pb.TagNumber(4)
  void clearRFactor() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get importanceFactor => $_getN(4);
  @$pb.TagNumber(5)
  set importanceFactor($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasImportanceFactor() => $_has(4);
  @$pb.TagNumber(5)
  void clearImportanceFactor() => $_clearField(5);

  /// leave 0 for code minimum
  @$pb.TagNumber(6)
  $core.double get csOverride => $_getN(5);
  @$pb.TagNumber(6)
  set csOverride($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCsOverride() => $_has(5);
  @$pb.TagNumber(6)
  void clearCsOverride() => $_clearField(6);
}

class ComputeSeismicLoadResponse extends $pb.GeneratedMessage {
  factory ComputeSeismicLoadResponse({
    $core.String? designId,
    $core.double? cs,
    $core.double? seismicWeightKn,
    $core.double? baseShearKn,
    $core.double? equation,
    $core.String? equationStr,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (cs != null) {
      $result.cs = cs;
    }
    if (seismicWeightKn != null) {
      $result.seismicWeightKn = seismicWeightKn;
    }
    if (baseShearKn != null) {
      $result.baseShearKn = baseShearKn;
    }
    if (equation != null) {
      $result.equation = equation;
    }
    if (equationStr != null) {
      $result.equationStr = equationStr;
    }
    return $result;
  }
  ComputeSeismicLoadResponse._() : super();
  factory ComputeSeismicLoadResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeSeismicLoadResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeSeismicLoadResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'cs', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'seismicWeightKn', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'baseShearKn', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'equation', $pb.PbFieldType.OD)
    ..aOS(6, _omitFieldNames ? '' : 'equationStr')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeSeismicLoadResponse clone() => ComputeSeismicLoadResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeSeismicLoadResponse copyWith(void Function(ComputeSeismicLoadResponse) updates) => super.copyWith((message) => updates(message as ComputeSeismicLoadResponse)) as ComputeSeismicLoadResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeSeismicLoadResponse create() => ComputeSeismicLoadResponse._();
  ComputeSeismicLoadResponse createEmptyInstance() => create();
  static $pb.PbList<ComputeSeismicLoadResponse> createRepeated() => $pb.PbList<ComputeSeismicLoadResponse>();
  @$core.pragma('dart2js:noInline')
  static ComputeSeismicLoadResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeSeismicLoadResponse>(create);
  static ComputeSeismicLoadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get cs => $_getN(1);
  @$pb.TagNumber(2)
  set cs($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCs() => $_has(1);
  @$pb.TagNumber(2)
  void clearCs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get seismicWeightKn => $_getN(2);
  @$pb.TagNumber(3)
  set seismicWeightKn($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSeismicWeightKn() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeismicWeightKn() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get baseShearKn => $_getN(3);
  @$pb.TagNumber(4)
  set baseShearKn($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBaseShearKn() => $_has(3);
  @$pb.TagNumber(4)
  void clearBaseShearKn() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get equation => $_getN(4);
  @$pb.TagNumber(5)
  set equation($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEquation() => $_has(4);
  @$pb.TagNumber(5)
  void clearEquation() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get equationStr => $_getSZ(5);
  @$pb.TagNumber(6)
  set equationStr($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasEquationStr() => $_has(5);
  @$pb.TagNumber(6)
  void clearEquationStr() => $_clearField(6);
}

class ComputeFoundationRequirementRequest extends $pb.GeneratedMessage {
  factory ComputeFoundationRequirementRequest({
    $core.String? designId,
    $core.double? deadLoadKn,
    $core.double? windLoadKn,
    $core.double? seismicLoadKn,
    FoundationType? foundationType,
    $core.double? pileCapacityKn,
    $core.double? totalAreaSqm,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (deadLoadKn != null) {
      $result.deadLoadKn = deadLoadKn;
    }
    if (windLoadKn != null) {
      $result.windLoadKn = windLoadKn;
    }
    if (seismicLoadKn != null) {
      $result.seismicLoadKn = seismicLoadKn;
    }
    if (foundationType != null) {
      $result.foundationType = foundationType;
    }
    if (pileCapacityKn != null) {
      $result.pileCapacityKn = pileCapacityKn;
    }
    if (totalAreaSqm != null) {
      $result.totalAreaSqm = totalAreaSqm;
    }
    return $result;
  }
  ComputeFoundationRequirementRequest._() : super();
  factory ComputeFoundationRequirementRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeFoundationRequirementRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeFoundationRequirementRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'deadLoadKn', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'windLoadKn', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'seismicLoadKn', $pb.PbFieldType.OD)
    ..e<FoundationType>(5, _omitFieldNames ? '' : 'foundationType', $pb.PbFieldType.OE, defaultOrMaker: FoundationType.FOUNDATION_TYPE_UNSPECIFIED, valueOf: FoundationType.valueOf, enumValues: FoundationType.values)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'pileCapacityKn', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'totalAreaSqm', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeFoundationRequirementRequest clone() => ComputeFoundationRequirementRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeFoundationRequirementRequest copyWith(void Function(ComputeFoundationRequirementRequest) updates) => super.copyWith((message) => updates(message as ComputeFoundationRequirementRequest)) as ComputeFoundationRequirementRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeFoundationRequirementRequest create() => ComputeFoundationRequirementRequest._();
  ComputeFoundationRequirementRequest createEmptyInstance() => create();
  static $pb.PbList<ComputeFoundationRequirementRequest> createRepeated() => $pb.PbList<ComputeFoundationRequirementRequest>();
  @$core.pragma('dart2js:noInline')
  static ComputeFoundationRequirementRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeFoundationRequirementRequest>(create);
  static ComputeFoundationRequirementRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get deadLoadKn => $_getN(1);
  @$pb.TagNumber(2)
  set deadLoadKn($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeadLoadKn() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeadLoadKn() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get windLoadKn => $_getN(2);
  @$pb.TagNumber(3)
  set windLoadKn($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWindLoadKn() => $_has(2);
  @$pb.TagNumber(3)
  void clearWindLoadKn() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get seismicLoadKn => $_getN(3);
  @$pb.TagNumber(4)
  set seismicLoadKn($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSeismicLoadKn() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeismicLoadKn() => $_clearField(4);

  @$pb.TagNumber(5)
  FoundationType get foundationType => $_getN(4);
  @$pb.TagNumber(5)
  set foundationType(FoundationType v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasFoundationType() => $_has(4);
  @$pb.TagNumber(5)
  void clearFoundationType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get pileCapacityKn => $_getN(5);
  @$pb.TagNumber(6)
  set pileCapacityKn($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPileCapacityKn() => $_has(5);
  @$pb.TagNumber(6)
  void clearPileCapacityKn() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get totalAreaSqm => $_getN(6);
  @$pb.TagNumber(7)
  set totalAreaSqm($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTotalAreaSqm() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalAreaSqm() => $_clearField(7);
}

class FoundationResult extends $pb.GeneratedMessage {
  factory FoundationResult({
    $core.int? pileCount,
    $core.double? designLoadKn,
    $core.double? pileSpacingM,
    FoundationType? foundationType,
    $core.double? pileCapacityKn,
    $core.String? loadCombination,
  }) {
    final $result = create();
    if (pileCount != null) {
      $result.pileCount = pileCount;
    }
    if (designLoadKn != null) {
      $result.designLoadKn = designLoadKn;
    }
    if (pileSpacingM != null) {
      $result.pileSpacingM = pileSpacingM;
    }
    if (foundationType != null) {
      $result.foundationType = foundationType;
    }
    if (pileCapacityKn != null) {
      $result.pileCapacityKn = pileCapacityKn;
    }
    if (loadCombination != null) {
      $result.loadCombination = loadCombination;
    }
    return $result;
  }
  FoundationResult._() : super();
  factory FoundationResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FoundationResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FoundationResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'pileCount', $pb.PbFieldType.O3)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'designLoadKn', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'pileSpacingM', $pb.PbFieldType.OD)
    ..e<FoundationType>(4, _omitFieldNames ? '' : 'foundationType', $pb.PbFieldType.OE, defaultOrMaker: FoundationType.FOUNDATION_TYPE_UNSPECIFIED, valueOf: FoundationType.valueOf, enumValues: FoundationType.values)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'pileCapacityKn', $pb.PbFieldType.OD)
    ..aOS(6, _omitFieldNames ? '' : 'loadCombination')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FoundationResult clone() => FoundationResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FoundationResult copyWith(void Function(FoundationResult) updates) => super.copyWith((message) => updates(message as FoundationResult)) as FoundationResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FoundationResult create() => FoundationResult._();
  FoundationResult createEmptyInstance() => create();
  static $pb.PbList<FoundationResult> createRepeated() => $pb.PbList<FoundationResult>();
  @$core.pragma('dart2js:noInline')
  static FoundationResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FoundationResult>(create);
  static FoundationResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pileCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set pileCount($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPileCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearPileCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get designLoadKn => $_getN(1);
  @$pb.TagNumber(2)
  set designLoadKn($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDesignLoadKn() => $_has(1);
  @$pb.TagNumber(2)
  void clearDesignLoadKn() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get pileSpacingM => $_getN(2);
  @$pb.TagNumber(3)
  set pileSpacingM($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPileSpacingM() => $_has(2);
  @$pb.TagNumber(3)
  void clearPileSpacingM() => $_clearField(3);

  @$pb.TagNumber(4)
  FoundationType get foundationType => $_getN(3);
  @$pb.TagNumber(4)
  set foundationType(FoundationType v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFoundationType() => $_has(3);
  @$pb.TagNumber(4)
  void clearFoundationType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get pileCapacityKn => $_getN(4);
  @$pb.TagNumber(5)
  set pileCapacityKn($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPileCapacityKn() => $_has(4);
  @$pb.TagNumber(5)
  void clearPileCapacityKn() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get loadCombination => $_getSZ(5);
  @$pb.TagNumber(6)
  set loadCombination($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLoadCombination() => $_has(5);
  @$pb.TagNumber(6)
  void clearLoadCombination() => $_clearField(6);
}

class ComputeFoundationRequirementResponse extends $pb.GeneratedMessage {
  factory ComputeFoundationRequirementResponse({
    $core.String? designId,
    FoundationResult? result,
    $core.String? equation,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (result != null) {
      $result.result = result;
    }
    if (equation != null) {
      $result.equation = equation;
    }
    return $result;
  }
  ComputeFoundationRequirementResponse._() : super();
  factory ComputeFoundationRequirementResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeFoundationRequirementResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeFoundationRequirementResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..aOM<FoundationResult>(2, _omitFieldNames ? '' : 'result', subBuilder: FoundationResult.create)
    ..aOS(3, _omitFieldNames ? '' : 'equation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeFoundationRequirementResponse clone() => ComputeFoundationRequirementResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeFoundationRequirementResponse copyWith(void Function(ComputeFoundationRequirementResponse) updates) => super.copyWith((message) => updates(message as ComputeFoundationRequirementResponse)) as ComputeFoundationRequirementResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeFoundationRequirementResponse create() => ComputeFoundationRequirementResponse._();
  ComputeFoundationRequirementResponse createEmptyInstance() => create();
  static $pb.PbList<ComputeFoundationRequirementResponse> createRepeated() => $pb.PbList<ComputeFoundationRequirementResponse>();
  @$core.pragma('dart2js:noInline')
  static ComputeFoundationRequirementResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeFoundationRequirementResponse>(create);
  static ComputeFoundationRequirementResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  @$pb.TagNumber(2)
  FoundationResult get result => $_getN(1);
  @$pb.TagNumber(2)
  set result(FoundationResult v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasResult() => $_has(1);
  @$pb.TagNumber(2)
  void clearResult() => $_clearField(2);
  @$pb.TagNumber(2)
  FoundationResult ensureResult() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get equation => $_getSZ(2);
  @$pb.TagNumber(3)
  set equation($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEquation() => $_has(2);
  @$pb.TagNumber(3)
  void clearEquation() => $_clearField(3);
}

class StructuralViolation extends $pb.GeneratedMessage {
  factory StructuralViolation({
    $core.String? code,
    $core.String? message,
    $core.double? limit,
    $core.double? actual,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    if (actual != null) {
      $result.actual = actual;
    }
    return $result;
  }
  StructuralViolation._() : super();
  factory StructuralViolation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StructuralViolation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StructuralViolation', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'actual', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StructuralViolation clone() => StructuralViolation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StructuralViolation copyWith(void Function(StructuralViolation) updates) => super.copyWith((message) => updates(message as StructuralViolation)) as StructuralViolation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StructuralViolation create() => StructuralViolation._();
  StructuralViolation createEmptyInstance() => create();
  static $pb.PbList<StructuralViolation> createRepeated() => $pb.PbList<StructuralViolation>();
  @$core.pragma('dart2js:noInline')
  static StructuralViolation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StructuralViolation>(create);
  static StructuralViolation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get code => $_getSZ(0);
  @$pb.TagNumber(1)
  set code($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get limit => $_getN(2);
  @$pb.TagNumber(3)
  set limit($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get actual => $_getN(3);
  @$pb.TagNumber(4)
  set actual($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasActual() => $_has(3);
  @$pb.TagNumber(4)
  void clearActual() => $_clearField(4);
}

class ValidateStructuralDesignRequest extends $pb.GeneratedMessage {
  factory ValidateStructuralDesignRequest({
    $core.String? designId,
    $core.double? maxDcAcRatio,
    $core.double? maxWindPressurePa,
    $core.double? maxSeismicCoefficient,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (maxDcAcRatio != null) {
      $result.maxDcAcRatio = maxDcAcRatio;
    }
    if (maxWindPressurePa != null) {
      $result.maxWindPressurePa = maxWindPressurePa;
    }
    if (maxSeismicCoefficient != null) {
      $result.maxSeismicCoefficient = maxSeismicCoefficient;
    }
    return $result;
  }
  ValidateStructuralDesignRequest._() : super();
  factory ValidateStructuralDesignRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateStructuralDesignRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateStructuralDesignRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'maxDcAcRatio', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'maxWindPressurePa', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'maxSeismicCoefficient', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateStructuralDesignRequest clone() => ValidateStructuralDesignRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateStructuralDesignRequest copyWith(void Function(ValidateStructuralDesignRequest) updates) => super.copyWith((message) => updates(message as ValidateStructuralDesignRequest)) as ValidateStructuralDesignRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateStructuralDesignRequest create() => ValidateStructuralDesignRequest._();
  ValidateStructuralDesignRequest createEmptyInstance() => create();
  static $pb.PbList<ValidateStructuralDesignRequest> createRepeated() => $pb.PbList<ValidateStructuralDesignRequest>();
  @$core.pragma('dart2js:noInline')
  static ValidateStructuralDesignRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateStructuralDesignRequest>(create);
  static ValidateStructuralDesignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  /// Override limits; 0 = use code defaults
  @$pb.TagNumber(2)
  $core.double get maxDcAcRatio => $_getN(1);
  @$pb.TagNumber(2)
  set maxDcAcRatio($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxDcAcRatio() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxDcAcRatio() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get maxWindPressurePa => $_getN(2);
  @$pb.TagNumber(3)
  set maxWindPressurePa($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxWindPressurePa() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxWindPressurePa() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get maxSeismicCoefficient => $_getN(3);
  @$pb.TagNumber(4)
  set maxSeismicCoefficient($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMaxSeismicCoefficient() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxSeismicCoefficient() => $_clearField(4);
}

class ValidateStructuralDesignResponse extends $pb.GeneratedMessage {
  factory ValidateStructuralDesignResponse({
    $core.bool? valid,
    $core.Iterable<StructuralViolation>? violations,
    $core.double? utilizationRatio,
  }) {
    final $result = create();
    if (valid != null) {
      $result.valid = valid;
    }
    if (violations != null) {
      $result.violations.addAll(violations);
    }
    if (utilizationRatio != null) {
      $result.utilizationRatio = utilizationRatio;
    }
    return $result;
  }
  ValidateStructuralDesignResponse._() : super();
  factory ValidateStructuralDesignResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateStructuralDesignResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateStructuralDesignResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'valid')
    ..pc<StructuralViolation>(2, _omitFieldNames ? '' : 'violations', $pb.PbFieldType.PM, subBuilder: StructuralViolation.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'utilizationRatio', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateStructuralDesignResponse clone() => ValidateStructuralDesignResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateStructuralDesignResponse copyWith(void Function(ValidateStructuralDesignResponse) updates) => super.copyWith((message) => updates(message as ValidateStructuralDesignResponse)) as ValidateStructuralDesignResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateStructuralDesignResponse create() => ValidateStructuralDesignResponse._();
  ValidateStructuralDesignResponse createEmptyInstance() => create();
  static $pb.PbList<ValidateStructuralDesignResponse> createRepeated() => $pb.PbList<ValidateStructuralDesignResponse>();
  @$core.pragma('dart2js:noInline')
  static ValidateStructuralDesignResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateStructuralDesignResponse>(create);
  static ValidateStructuralDesignResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get valid => $_getBF(0);
  @$pb.TagNumber(1)
  set valid($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearValid() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<StructuralViolation> get violations => $_getList(1);

  @$pb.TagNumber(3)
  $core.double get utilizationRatio => $_getN(2);
  @$pb.TagNumber(3)
  set utilizationRatio($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUtilizationRatio() => $_has(2);
  @$pb.TagNumber(3)
  void clearUtilizationRatio() => $_clearField(3);
}

class SubmitForReviewRequest extends $pb.GeneratedMessage {
  factory SubmitForReviewRequest({
    $core.String? designId,
    $core.String? submittedBy,
    $core.String? notes,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (submittedBy != null) {
      $result.submittedBy = submittedBy;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    return $result;
  }
  SubmitForReviewRequest._() : super();
  factory SubmitForReviewRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitForReviewRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitForReviewRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..aOS(2, _omitFieldNames ? '' : 'submittedBy')
    ..aOS(3, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitForReviewRequest clone() => SubmitForReviewRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitForReviewRequest copyWith(void Function(SubmitForReviewRequest) updates) => super.copyWith((message) => updates(message as SubmitForReviewRequest)) as SubmitForReviewRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitForReviewRequest create() => SubmitForReviewRequest._();
  SubmitForReviewRequest createEmptyInstance() => create();
  static $pb.PbList<SubmitForReviewRequest> createRepeated() => $pb.PbList<SubmitForReviewRequest>();
  @$core.pragma('dart2js:noInline')
  static SubmitForReviewRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitForReviewRequest>(create);
  static SubmitForReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get submittedBy => $_getSZ(1);
  @$pb.TagNumber(2)
  set submittedBy($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSubmittedBy() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubmittedBy() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get notes => $_getSZ(2);
  @$pb.TagNumber(3)
  set notes($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNotes() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotes() => $_clearField(3);
}

class SubmitForReviewResponse extends $pb.GeneratedMessage {
  factory SubmitForReviewResponse({
    StructuralDesign? design,
  }) {
    final $result = create();
    if (design != null) {
      $result.design = design;
    }
    return $result;
  }
  SubmitForReviewResponse._() : super();
  factory SubmitForReviewResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitForReviewResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitForReviewResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOM<StructuralDesign>(1, _omitFieldNames ? '' : 'design', subBuilder: StructuralDesign.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitForReviewResponse clone() => SubmitForReviewResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitForReviewResponse copyWith(void Function(SubmitForReviewResponse) updates) => super.copyWith((message) => updates(message as SubmitForReviewResponse)) as SubmitForReviewResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitForReviewResponse create() => SubmitForReviewResponse._();
  SubmitForReviewResponse createEmptyInstance() => create();
  static $pb.PbList<SubmitForReviewResponse> createRepeated() => $pb.PbList<SubmitForReviewResponse>();
  @$core.pragma('dart2js:noInline')
  static SubmitForReviewResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitForReviewResponse>(create);
  static SubmitForReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StructuralDesign get design => $_getN(0);
  @$pb.TagNumber(1)
  set design(StructuralDesign v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesign() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesign() => $_clearField(1);
  @$pb.TagNumber(1)
  StructuralDesign ensureDesign() => $_ensure(0);
}

class ApproveDesignRequest extends $pb.GeneratedMessage {
  factory ApproveDesignRequest({
    $core.String? designId,
    $core.String? approvedBy,
    $core.String? notes,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (approvedBy != null) {
      $result.approvedBy = approvedBy;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    return $result;
  }
  ApproveDesignRequest._() : super();
  factory ApproveDesignRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApproveDesignRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApproveDesignRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..aOS(2, _omitFieldNames ? '' : 'approvedBy')
    ..aOS(3, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApproveDesignRequest clone() => ApproveDesignRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApproveDesignRequest copyWith(void Function(ApproveDesignRequest) updates) => super.copyWith((message) => updates(message as ApproveDesignRequest)) as ApproveDesignRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveDesignRequest create() => ApproveDesignRequest._();
  ApproveDesignRequest createEmptyInstance() => create();
  static $pb.PbList<ApproveDesignRequest> createRepeated() => $pb.PbList<ApproveDesignRequest>();
  @$core.pragma('dart2js:noInline')
  static ApproveDesignRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproveDesignRequest>(create);
  static ApproveDesignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get approvedBy => $_getSZ(1);
  @$pb.TagNumber(2)
  set approvedBy($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasApprovedBy() => $_has(1);
  @$pb.TagNumber(2)
  void clearApprovedBy() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get notes => $_getSZ(2);
  @$pb.TagNumber(3)
  set notes($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNotes() => $_has(2);
  @$pb.TagNumber(3)
  void clearNotes() => $_clearField(3);
}

class ApproveDesignResponse extends $pb.GeneratedMessage {
  factory ApproveDesignResponse({
    StructuralDesign? design,
  }) {
    final $result = create();
    if (design != null) {
      $result.design = design;
    }
    return $result;
  }
  ApproveDesignResponse._() : super();
  factory ApproveDesignResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApproveDesignResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApproveDesignResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOM<StructuralDesign>(1, _omitFieldNames ? '' : 'design', subBuilder: StructuralDesign.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApproveDesignResponse clone() => ApproveDesignResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApproveDesignResponse copyWith(void Function(ApproveDesignResponse) updates) => super.copyWith((message) => updates(message as ApproveDesignResponse)) as ApproveDesignResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveDesignResponse create() => ApproveDesignResponse._();
  ApproveDesignResponse createEmptyInstance() => create();
  static $pb.PbList<ApproveDesignResponse> createRepeated() => $pb.PbList<ApproveDesignResponse>();
  @$core.pragma('dart2js:noInline')
  static ApproveDesignResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproveDesignResponse>(create);
  static ApproveDesignResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StructuralDesign get design => $_getN(0);
  @$pb.TagNumber(1)
  set design(StructuralDesign v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesign() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesign() => $_clearField(1);
  @$pb.TagNumber(1)
  StructuralDesign ensureDesign() => $_ensure(0);
}

class RejectDesignRequest extends $pb.GeneratedMessage {
  factory RejectDesignRequest({
    $core.String? designId,
    $core.String? rejectedBy,
    $core.String? reason,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (rejectedBy != null) {
      $result.rejectedBy = rejectedBy;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  RejectDesignRequest._() : super();
  factory RejectDesignRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RejectDesignRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RejectDesignRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..aOS(2, _omitFieldNames ? '' : 'rejectedBy')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RejectDesignRequest clone() => RejectDesignRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RejectDesignRequest copyWith(void Function(RejectDesignRequest) updates) => super.copyWith((message) => updates(message as RejectDesignRequest)) as RejectDesignRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectDesignRequest create() => RejectDesignRequest._();
  RejectDesignRequest createEmptyInstance() => create();
  static $pb.PbList<RejectDesignRequest> createRepeated() => $pb.PbList<RejectDesignRequest>();
  @$core.pragma('dart2js:noInline')
  static RejectDesignRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RejectDesignRequest>(create);
  static RejectDesignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get rejectedBy => $_getSZ(1);
  @$pb.TagNumber(2)
  set rejectedBy($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRejectedBy() => $_has(1);
  @$pb.TagNumber(2)
  void clearRejectedBy() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class RejectDesignResponse extends $pb.GeneratedMessage {
  factory RejectDesignResponse({
    StructuralDesign? design,
  }) {
    final $result = create();
    if (design != null) {
      $result.design = design;
    }
    return $result;
  }
  RejectDesignResponse._() : super();
  factory RejectDesignResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RejectDesignResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RejectDesignResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOM<StructuralDesign>(1, _omitFieldNames ? '' : 'design', subBuilder: StructuralDesign.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RejectDesignResponse clone() => RejectDesignResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RejectDesignResponse copyWith(void Function(RejectDesignResponse) updates) => super.copyWith((message) => updates(message as RejectDesignResponse)) as RejectDesignResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectDesignResponse create() => RejectDesignResponse._();
  RejectDesignResponse createEmptyInstance() => create();
  static $pb.PbList<RejectDesignResponse> createRepeated() => $pb.PbList<RejectDesignResponse>();
  @$core.pragma('dart2js:noInline')
  static RejectDesignResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RejectDesignResponse>(create);
  static RejectDesignResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StructuralDesign get design => $_getN(0);
  @$pb.TagNumber(1)
  set design(StructuralDesign v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesign() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesign() => $_clearField(1);
  @$pb.TagNumber(1)
  StructuralDesign ensureDesign() => $_ensure(0);
}

class GenerateStructuralReportRequest extends $pb.GeneratedMessage {
  factory GenerateStructuralReportRequest({
    $core.String? designId,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    return $result;
  }
  GenerateStructuralReportRequest._() : super();
  factory GenerateStructuralReportRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateStructuralReportRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateStructuralReportRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateStructuralReportRequest clone() => GenerateStructuralReportRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateStructuralReportRequest copyWith(void Function(GenerateStructuralReportRequest) updates) => super.copyWith((message) => updates(message as GenerateStructuralReportRequest)) as GenerateStructuralReportRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateStructuralReportRequest create() => GenerateStructuralReportRequest._();
  GenerateStructuralReportRequest createEmptyInstance() => create();
  static $pb.PbList<GenerateStructuralReportRequest> createRepeated() => $pb.PbList<GenerateStructuralReportRequest>();
  @$core.pragma('dart2js:noInline')
  static GenerateStructuralReportRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateStructuralReportRequest>(create);
  static GenerateStructuralReportRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);
}

class GenerateStructuralReportResponse extends $pb.GeneratedMessage {
  factory GenerateStructuralReportResponse({
    $core.String? designId,
    $core.String? reportText,
    ReviewState? reviewState,
  }) {
    final $result = create();
    if (designId != null) {
      $result.designId = designId;
    }
    if (reportText != null) {
      $result.reportText = reportText;
    }
    if (reviewState != null) {
      $result.reviewState = reviewState;
    }
    return $result;
  }
  GenerateStructuralReportResponse._() : super();
  factory GenerateStructuralReportResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateStructuralReportResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateStructuralReportResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'designId')
    ..aOS(2, _omitFieldNames ? '' : 'reportText')
    ..e<ReviewState>(3, _omitFieldNames ? '' : 'reviewState', $pb.PbFieldType.OE, defaultOrMaker: ReviewState.REVIEW_STATE_UNSPECIFIED, valueOf: ReviewState.valueOf, enumValues: ReviewState.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateStructuralReportResponse clone() => GenerateStructuralReportResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateStructuralReportResponse copyWith(void Function(GenerateStructuralReportResponse) updates) => super.copyWith((message) => updates(message as GenerateStructuralReportResponse)) as GenerateStructuralReportResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateStructuralReportResponse create() => GenerateStructuralReportResponse._();
  GenerateStructuralReportResponse createEmptyInstance() => create();
  static $pb.PbList<GenerateStructuralReportResponse> createRepeated() => $pb.PbList<GenerateStructuralReportResponse>();
  @$core.pragma('dart2js:noInline')
  static GenerateStructuralReportResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateStructuralReportResponse>(create);
  static GenerateStructuralReportResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get designId => $_getSZ(0);
  @$pb.TagNumber(1)
  set designId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesignId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesignId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reportText => $_getSZ(1);
  @$pb.TagNumber(2)
  set reportText($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReportText() => $_has(1);
  @$pb.TagNumber(2)
  void clearReportText() => $_clearField(2);

  @$pb.TagNumber(3)
  ReviewState get reviewState => $_getN(2);
  @$pb.TagNumber(3)
  set reviewState(ReviewState v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasReviewState() => $_has(2);
  @$pb.TagNumber(3)
  void clearReviewState() => $_clearField(3);
}

class CreateDesignRequest extends $pb.GeneratedMessage {
  factory CreateDesignRequest({
    $core.String? projectId,
    $core.String? name,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  CreateDesignRequest._() : super();
  factory CreateDesignRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateDesignRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateDesignRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateDesignRequest clone() => CreateDesignRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateDesignRequest copyWith(void Function(CreateDesignRequest) updates) => super.copyWith((message) => updates(message as CreateDesignRequest)) as CreateDesignRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateDesignRequest create() => CreateDesignRequest._();
  CreateDesignRequest createEmptyInstance() => create();
  static $pb.PbList<CreateDesignRequest> createRepeated() => $pb.PbList<CreateDesignRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateDesignRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateDesignRequest>(create);
  static CreateDesignRequest? _defaultInstance;

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
}

class CreateDesignResponse extends $pb.GeneratedMessage {
  factory CreateDesignResponse({
    StructuralDesign? design,
  }) {
    final $result = create();
    if (design != null) {
      $result.design = design;
    }
    return $result;
  }
  CreateDesignResponse._() : super();
  factory CreateDesignResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateDesignResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateDesignResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOM<StructuralDesign>(1, _omitFieldNames ? '' : 'design', subBuilder: StructuralDesign.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateDesignResponse clone() => CreateDesignResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateDesignResponse copyWith(void Function(CreateDesignResponse) updates) => super.copyWith((message) => updates(message as CreateDesignResponse)) as CreateDesignResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateDesignResponse create() => CreateDesignResponse._();
  CreateDesignResponse createEmptyInstance() => create();
  static $pb.PbList<CreateDesignResponse> createRepeated() => $pb.PbList<CreateDesignResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateDesignResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateDesignResponse>(create);
  static CreateDesignResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StructuralDesign get design => $_getN(0);
  @$pb.TagNumber(1)
  set design(StructuralDesign v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesign() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesign() => $_clearField(1);
  @$pb.TagNumber(1)
  StructuralDesign ensureDesign() => $_ensure(0);
}

class GetDesignRequest extends $pb.GeneratedMessage {
  factory GetDesignRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetDesignRequest._() : super();
  factory GetDesignRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDesignRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDesignRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDesignRequest clone() => GetDesignRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDesignRequest copyWith(void Function(GetDesignRequest) updates) => super.copyWith((message) => updates(message as GetDesignRequest)) as GetDesignRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDesignRequest create() => GetDesignRequest._();
  GetDesignRequest createEmptyInstance() => create();
  static $pb.PbList<GetDesignRequest> createRepeated() => $pb.PbList<GetDesignRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDesignRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDesignRequest>(create);
  static GetDesignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetDesignResponse extends $pb.GeneratedMessage {
  factory GetDesignResponse({
    StructuralDesign? design,
  }) {
    final $result = create();
    if (design != null) {
      $result.design = design;
    }
    return $result;
  }
  GetDesignResponse._() : super();
  factory GetDesignResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDesignResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDesignResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOM<StructuralDesign>(1, _omitFieldNames ? '' : 'design', subBuilder: StructuralDesign.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDesignResponse clone() => GetDesignResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDesignResponse copyWith(void Function(GetDesignResponse) updates) => super.copyWith((message) => updates(message as GetDesignResponse)) as GetDesignResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDesignResponse create() => GetDesignResponse._();
  GetDesignResponse createEmptyInstance() => create();
  static $pb.PbList<GetDesignResponse> createRepeated() => $pb.PbList<GetDesignResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDesignResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDesignResponse>(create);
  static GetDesignResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StructuralDesign get design => $_getN(0);
  @$pb.TagNumber(1)
  set design(StructuralDesign v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDesign() => $_has(0);
  @$pb.TagNumber(1)
  void clearDesign() => $_clearField(1);
  @$pb.TagNumber(1)
  StructuralDesign ensureDesign() => $_ensure(0);
}

class ListDesignsRequest extends $pb.GeneratedMessage {
  factory ListDesignsRequest({
    $core.String? projectId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    return $result;
  }
  ListDesignsRequest._() : super();
  factory ListDesignsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListDesignsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListDesignsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListDesignsRequest clone() => ListDesignsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListDesignsRequest copyWith(void Function(ListDesignsRequest) updates) => super.copyWith((message) => updates(message as ListDesignsRequest)) as ListDesignsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDesignsRequest create() => ListDesignsRequest._();
  ListDesignsRequest createEmptyInstance() => create();
  static $pb.PbList<ListDesignsRequest> createRepeated() => $pb.PbList<ListDesignsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListDesignsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDesignsRequest>(create);
  static ListDesignsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);
}

class ListDesignsResponse extends $pb.GeneratedMessage {
  factory ListDesignsResponse({
    $core.Iterable<StructuralDesign>? designs,
  }) {
    final $result = create();
    if (designs != null) {
      $result.designs.addAll(designs);
    }
    return $result;
  }
  ListDesignsResponse._() : super();
  factory ListDesignsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListDesignsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListDesignsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..pc<StructuralDesign>(1, _omitFieldNames ? '' : 'designs', $pb.PbFieldType.PM, subBuilder: StructuralDesign.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListDesignsResponse clone() => ListDesignsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListDesignsResponse copyWith(void Function(ListDesignsResponse) updates) => super.copyWith((message) => updates(message as ListDesignsResponse)) as ListDesignsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDesignsResponse create() => ListDesignsResponse._();
  ListDesignsResponse createEmptyInstance() => create();
  static $pb.PbList<ListDesignsResponse> createRepeated() => $pb.PbList<ListDesignsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListDesignsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDesignsResponse>(create);
  static ListDesignsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<StructuralDesign> get designs => $_getList(0);
}

class DeleteDesignRequest extends $pb.GeneratedMessage {
  factory DeleteDesignRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteDesignRequest._() : super();
  factory DeleteDesignRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteDesignRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteDesignRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteDesignRequest clone() => DeleteDesignRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteDesignRequest copyWith(void Function(DeleteDesignRequest) updates) => super.copyWith((message) => updates(message as DeleteDesignRequest)) as DeleteDesignRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteDesignRequest create() => DeleteDesignRequest._();
  DeleteDesignRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteDesignRequest> createRepeated() => $pb.PbList<DeleteDesignRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteDesignRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteDesignRequest>(create);
  static DeleteDesignRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteDesignResponse extends $pb.GeneratedMessage {
  factory DeleteDesignResponse() => create();
  DeleteDesignResponse._() : super();
  factory DeleteDesignResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteDesignResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteDesignResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'structural.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteDesignResponse clone() => DeleteDesignResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteDesignResponse copyWith(void Function(DeleteDesignResponse) updates) => super.copyWith((message) => updates(message as DeleteDesignResponse)) as DeleteDesignResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteDesignResponse create() => DeleteDesignResponse._();
  DeleteDesignResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteDesignResponse> createRepeated() => $pb.PbList<DeleteDesignResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteDesignResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteDesignResponse>(create);
  static DeleteDesignResponse? _defaultInstance;
}

/// StructuralService provides load analysis and design verification for solar
/// mounting structures.  All calculations are traceable to ASCE 7-16 / EN 1991.
class StructuralServiceApi {
  $pb.RpcClient _client;
  StructuralServiceApi(this._client);

  /// Design lifecycle
  $async.Future<CreateDesignResponse> createDesign($pb.ClientContext? ctx, CreateDesignRequest request) =>
    _client.invoke<CreateDesignResponse>(ctx, 'StructuralService', 'CreateDesign', request, CreateDesignResponse())
  ;
  /// GetDesign returns a structural design by ID.
  $async.Future<GetDesignResponse> getDesign($pb.ClientContext? ctx, GetDesignRequest request) =>
    _client.invoke<GetDesignResponse>(ctx, 'StructuralService', 'GetDesign', request, GetDesignResponse())
  ;
  /// ListDesigns lists structural designs for a project.
  $async.Future<ListDesignsResponse> listDesigns($pb.ClientContext? ctx, ListDesignsRequest request) =>
    _client.invoke<ListDesignsResponse>(ctx, 'StructuralService', 'ListDesigns', request, ListDesignsResponse())
  ;
  /// DeleteDesign removes a structural design by ID.
  $async.Future<DeleteDesignResponse> deleteDesign($pb.ClientContext? ctx, DeleteDesignRequest request) =>
    _client.invoke<DeleteDesignResponse>(ctx, 'StructuralService', 'DeleteDesign', request, DeleteDesignResponse())
  ;
  /// Load calculations — every result references the equation used.
  $async.Future<ComputeDeadLoadResponse> computeDeadLoad($pb.ClientContext? ctx, ComputeDeadLoadRequest request) =>
    _client.invoke<ComputeDeadLoadResponse>(ctx, 'StructuralService', 'ComputeDeadLoad', request, ComputeDeadLoadResponse())
  ;
  /// ComputeWindLoad calculates wind load for the design inputs.
  $async.Future<ComputeWindLoadResponse> computeWindLoad($pb.ClientContext? ctx, ComputeWindLoadRequest request) =>
    _client.invoke<ComputeWindLoadResponse>(ctx, 'StructuralService', 'ComputeWindLoad', request, ComputeWindLoadResponse())
  ;
  /// ComputeSeismicLoad calculates seismic load for the design inputs.
  $async.Future<ComputeSeismicLoadResponse> computeSeismicLoad($pb.ClientContext? ctx, ComputeSeismicLoadRequest request) =>
    _client.invoke<ComputeSeismicLoadResponse>(ctx, 'StructuralService', 'ComputeSeismicLoad', request, ComputeSeismicLoadResponse())
  ;
  /// ComputeFoundationRequirement estimates foundation requirements from loads and soil.
  $async.Future<ComputeFoundationRequirementResponse> computeFoundationRequirement($pb.ClientContext? ctx, ComputeFoundationRequirementRequest request) =>
    _client.invoke<ComputeFoundationRequirementResponse>(ctx, 'StructuralService', 'ComputeFoundationRequirement', request, ComputeFoundationRequirementResponse())
  ;
  /// ValidateStructuralDesign validates design constraints and reports violations.
  $async.Future<ValidateStructuralDesignResponse> validateStructuralDesign($pb.ClientContext? ctx, ValidateStructuralDesignRequest request) =>
    _client.invoke<ValidateStructuralDesignResponse>(ctx, 'StructuralService', 'ValidateStructuralDesign', request, ValidateStructuralDesignResponse())
  ;
  /// Engineer review workflow
  $async.Future<SubmitForReviewResponse> submitForReview($pb.ClientContext? ctx, SubmitForReviewRequest request) =>
    _client.invoke<SubmitForReviewResponse>(ctx, 'StructuralService', 'SubmitForReview', request, SubmitForReviewResponse())
  ;
  /// ApproveDesign marks a submitted design as approved.
  $async.Future<ApproveDesignResponse> approveDesign($pb.ClientContext? ctx, ApproveDesignRequest request) =>
    _client.invoke<ApproveDesignResponse>(ctx, 'StructuralService', 'ApproveDesign', request, ApproveDesignResponse())
  ;
  /// RejectDesign marks a submitted design as rejected.
  $async.Future<RejectDesignResponse> rejectDesign($pb.ClientContext? ctx, RejectDesignRequest request) =>
    _client.invoke<RejectDesignResponse>(ctx, 'StructuralService', 'RejectDesign', request, RejectDesignResponse())
  ;
  /// Plain-text design report with all assumptions and equations
  $async.Future<GenerateStructuralReportResponse> generateStructuralReport($pb.ClientContext? ctx, GenerateStructuralReportRequest request) =>
    _client.invoke<GenerateStructuralReportResponse>(ctx, 'StructuralService', 'GenerateStructuralReport', request, GenerateStructuralReportResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
