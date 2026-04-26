//
//  Generated code. Do not modify.
//  source: electrical/v1/electrical.proto
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
import 'electrical.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'electrical.pbenum.dart';

/// ========== Review Metadata ==========
/// ReviewMetadata captures the acceptance workflow state attached to an electrical network.
/// Populated by the SubmitNetworkForReview / ApproveNetwork / RejectNetwork RPCs.
/// Consumed by PlanningWorkflow gate enforcement for the ElectricalReady -> TransmissionReady transition.
class ReviewMetadata extends $pb.GeneratedMessage {
  factory ReviewMetadata({
    AcceptanceStatus? status,
    $core.String? reviewedByActorId,
    $0.Timestamp? reviewedAt,
    $core.double? qualityScore,
    $core.Iterable<$core.String>? reviewComments,
    $core.Iterable<$core.String>? blockers,
    $core.String? approvalTimestampUnixSecs,
  }) {
    final $result = create();
    if (status != null) {
      $result.status = status;
    }
    if (reviewedByActorId != null) {
      $result.reviewedByActorId = reviewedByActorId;
    }
    if (reviewedAt != null) {
      $result.reviewedAt = reviewedAt;
    }
    if (qualityScore != null) {
      $result.qualityScore = qualityScore;
    }
    if (reviewComments != null) {
      $result.reviewComments.addAll(reviewComments);
    }
    if (blockers != null) {
      $result.blockers.addAll(blockers);
    }
    if (approvalTimestampUnixSecs != null) {
      $result.approvalTimestampUnixSecs = approvalTimestampUnixSecs;
    }
    return $result;
  }
  ReviewMetadata._() : super();
  factory ReviewMetadata.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReviewMetadata.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReviewMetadata', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..e<AcceptanceStatus>(1, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: AcceptanceStatus.ACCEPTANCE_STATUS_UNSPECIFIED, valueOf: AcceptanceStatus.valueOf, enumValues: AcceptanceStatus.values)
    ..aOS(2, _omitFieldNames ? '' : 'reviewedByActorId')
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'reviewedAt', subBuilder: $0.Timestamp.create)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'qualityScore', $pb.PbFieldType.OD)
    ..pPS(5, _omitFieldNames ? '' : 'reviewComments')
    ..pPS(6, _omitFieldNames ? '' : 'blockers')
    ..aOS(7, _omitFieldNames ? '' : 'approvalTimestampUnixSecs')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReviewMetadata clone() => ReviewMetadata()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReviewMetadata copyWith(void Function(ReviewMetadata) updates) => super.copyWith((message) => updates(message as ReviewMetadata)) as ReviewMetadata;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReviewMetadata create() => ReviewMetadata._();
  ReviewMetadata createEmptyInstance() => create();
  static $pb.PbList<ReviewMetadata> createRepeated() => $pb.PbList<ReviewMetadata>();
  @$core.pragma('dart2js:noInline')
  static ReviewMetadata getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReviewMetadata>(create);
  static ReviewMetadata? _defaultInstance;

  /// status is the current acceptance gate state.
  @$pb.TagNumber(1)
  AcceptanceStatus get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(AcceptanceStatus v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);

  /// reviewed_by_actor_id is the user or system actor that performed the review action.
  @$pb.TagNumber(2)
  $core.String get reviewedByActorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set reviewedByActorId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReviewedByActorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReviewedByActorId() => $_clearField(2);

  /// reviewed_at is the timestamp of the most recent review action.
  @$pb.TagNumber(3)
  $0.Timestamp get reviewedAt => $_getN(2);
  @$pb.TagNumber(3)
  set reviewedAt($0.Timestamp v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasReviewedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearReviewedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureReviewedAt() => $_ensure(2);

  /// quality_score is a reviewer-assigned [0, 1] quality rating.
  @$pb.TagNumber(4)
  $core.double get qualityScore => $_getN(3);
  @$pb.TagNumber(4)
  set qualityScore($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasQualityScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearQualityScore() => $_clearField(4);

  /// review_comments are free-text annotations from the reviewer.
  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get reviewComments => $_getList(4);

  /// blockers are unresolved reasons preventing approval. Empty when approved.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get blockers => $_getList(5);

  /// approval_timestamp_unix_secs records the ISO-8601 approval time for the audit trail.
  @$pb.TagNumber(7)
  $core.String get approvalTimestampUnixSecs => $_getSZ(6);
  @$pb.TagNumber(7)
  set approvalTimestampUnixSecs($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasApprovalTimestampUnixSecs() => $_has(6);
  @$pb.TagNumber(7)
  void clearApprovalTimestampUnixSecs() => $_clearField(7);
}

class ElectricalNetwork extends $pb.GeneratedMessage {
  factory ElectricalNetwork({
    $core.String? id,
    $core.String? projectId,
    $core.String? layoutId,
    $core.String? name,
    $core.double? totalDcCapacityKw,
    $core.double? totalAcCapacityKw,
    $core.double? dcAcRatio,
    $core.int? stringCount,
    $core.int? inverterCount,
    $0.Timestamp? createdAt,
    ReviewMetadata? reviewMetadata,
    $core.Iterable<$core.String>? validationViolations,
    $core.double? electricalFeasibilityScore,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (totalDcCapacityKw != null) {
      $result.totalDcCapacityKw = totalDcCapacityKw;
    }
    if (totalAcCapacityKw != null) {
      $result.totalAcCapacityKw = totalAcCapacityKw;
    }
    if (dcAcRatio != null) {
      $result.dcAcRatio = dcAcRatio;
    }
    if (stringCount != null) {
      $result.stringCount = stringCount;
    }
    if (inverterCount != null) {
      $result.inverterCount = inverterCount;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (reviewMetadata != null) {
      $result.reviewMetadata = reviewMetadata;
    }
    if (validationViolations != null) {
      $result.validationViolations.addAll(validationViolations);
    }
    if (electricalFeasibilityScore != null) {
      $result.electricalFeasibilityScore = electricalFeasibilityScore;
    }
    return $result;
  }
  ElectricalNetwork._() : super();
  factory ElectricalNetwork.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ElectricalNetwork.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ElectricalNetwork', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'layoutId')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'totalDcCapacityKw', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'totalAcCapacityKw', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'dcAcRatio', $pb.PbFieldType.OD)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'stringCount', $pb.PbFieldType.O3)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'inverterCount', $pb.PbFieldType.O3)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<ReviewMetadata>(11, _omitFieldNames ? '' : 'reviewMetadata', subBuilder: ReviewMetadata.create)
    ..pPS(12, _omitFieldNames ? '' : 'validationViolations')
    ..a<$core.double>(13, _omitFieldNames ? '' : 'electricalFeasibilityScore', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ElectricalNetwork clone() => ElectricalNetwork()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ElectricalNetwork copyWith(void Function(ElectricalNetwork) updates) => super.copyWith((message) => updates(message as ElectricalNetwork)) as ElectricalNetwork;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ElectricalNetwork create() => ElectricalNetwork._();
  ElectricalNetwork createEmptyInstance() => create();
  static $pb.PbList<ElectricalNetwork> createRepeated() => $pb.PbList<ElectricalNetwork>();
  @$core.pragma('dart2js:noInline')
  static ElectricalNetwork getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ElectricalNetwork>(create);
  static ElectricalNetwork? _defaultInstance;

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
  $core.String get layoutId => $_getSZ(2);
  @$pb.TagNumber(3)
  set layoutId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLayoutId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLayoutId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalDcCapacityKw => $_getN(4);
  @$pb.TagNumber(5)
  set totalDcCapacityKw($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalDcCapacityKw() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalDcCapacityKw() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalAcCapacityKw => $_getN(5);
  @$pb.TagNumber(6)
  set totalAcCapacityKw($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTotalAcCapacityKw() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalAcCapacityKw() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get dcAcRatio => $_getN(6);
  @$pb.TagNumber(7)
  set dcAcRatio($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDcAcRatio() => $_has(6);
  @$pb.TagNumber(7)
  void clearDcAcRatio() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get stringCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set stringCount($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasStringCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearStringCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get inverterCount => $_getIZ(8);
  @$pb.TagNumber(9)
  set inverterCount($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasInverterCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearInverterCount() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($0.Timestamp v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  ReviewMetadata get reviewMetadata => $_getN(10);
  @$pb.TagNumber(11)
  set reviewMetadata(ReviewMetadata v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasReviewMetadata() => $_has(10);
  @$pb.TagNumber(11)
  void clearReviewMetadata() => $_clearField(11);
  @$pb.TagNumber(11)
  ReviewMetadata ensureReviewMetadata() => $_ensure(10);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get validationViolations => $_getList(11);

  @$pb.TagNumber(13)
  $core.double get electricalFeasibilityScore => $_getN(12);
  @$pb.TagNumber(13)
  set electricalFeasibilityScore($core.double v) { $_setDouble(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasElectricalFeasibilityScore() => $_has(12);
  @$pb.TagNumber(13)
  void clearElectricalFeasibilityScore() => $_clearField(13);
}

class PanelString extends $pb.GeneratedMessage {
  factory PanelString({
    $core.String? id,
    $core.String? networkId,
    $core.String? inverterGroupId,
    $core.Iterable<$core.String>? panelIds,
    $core.int? panelCount,
    $core.double? stringVoltage,
    $core.double? stringCurrent,
    $core.double? stringPowerW,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (networkId != null) {
      $result.networkId = networkId;
    }
    if (inverterGroupId != null) {
      $result.inverterGroupId = inverterGroupId;
    }
    if (panelIds != null) {
      $result.panelIds.addAll(panelIds);
    }
    if (panelCount != null) {
      $result.panelCount = panelCount;
    }
    if (stringVoltage != null) {
      $result.stringVoltage = stringVoltage;
    }
    if (stringCurrent != null) {
      $result.stringCurrent = stringCurrent;
    }
    if (stringPowerW != null) {
      $result.stringPowerW = stringPowerW;
    }
    return $result;
  }
  PanelString._() : super();
  factory PanelString.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PanelString.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PanelString', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'networkId')
    ..aOS(3, _omitFieldNames ? '' : 'inverterGroupId')
    ..pPS(4, _omitFieldNames ? '' : 'panelIds')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'panelCount', $pb.PbFieldType.O3)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'stringVoltage', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'stringCurrent', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'stringPowerW', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PanelString clone() => PanelString()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PanelString copyWith(void Function(PanelString) updates) => super.copyWith((message) => updates(message as PanelString)) as PanelString;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PanelString create() => PanelString._();
  PanelString createEmptyInstance() => create();
  static $pb.PbList<PanelString> createRepeated() => $pb.PbList<PanelString>();
  @$core.pragma('dart2js:noInline')
  static PanelString getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PanelString>(create);
  static PanelString? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get networkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set networkId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNetworkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNetworkId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get inverterGroupId => $_getSZ(2);
  @$pb.TagNumber(3)
  set inverterGroupId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasInverterGroupId() => $_has(2);
  @$pb.TagNumber(3)
  void clearInverterGroupId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get panelIds => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get panelCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set panelCount($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPanelCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearPanelCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get stringVoltage => $_getN(5);
  @$pb.TagNumber(6)
  set stringVoltage($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasStringVoltage() => $_has(5);
  @$pb.TagNumber(6)
  void clearStringVoltage() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get stringCurrent => $_getN(6);
  @$pb.TagNumber(7)
  set stringCurrent($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasStringCurrent() => $_has(6);
  @$pb.TagNumber(7)
  void clearStringCurrent() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get stringPowerW => $_getN(7);
  @$pb.TagNumber(8)
  set stringPowerW($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasStringPowerW() => $_has(7);
  @$pb.TagNumber(8)
  void clearStringPowerW() => $_clearField(8);
}

class InverterGroup extends $pb.GeneratedMessage {
  factory InverterGroup({
    $core.String? id,
    $core.String? networkId,
    $core.String? inverterAssetId,
    $core.Iterable<$core.String>? stringIds,
    $core.double? dcInputKw,
    $core.double? acOutputKw,
    $core.double? dcAcRatio,
    $core.String? positionGeojson,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (networkId != null) {
      $result.networkId = networkId;
    }
    if (inverterAssetId != null) {
      $result.inverterAssetId = inverterAssetId;
    }
    if (stringIds != null) {
      $result.stringIds.addAll(stringIds);
    }
    if (dcInputKw != null) {
      $result.dcInputKw = dcInputKw;
    }
    if (acOutputKw != null) {
      $result.acOutputKw = acOutputKw;
    }
    if (dcAcRatio != null) {
      $result.dcAcRatio = dcAcRatio;
    }
    if (positionGeojson != null) {
      $result.positionGeojson = positionGeojson;
    }
    return $result;
  }
  InverterGroup._() : super();
  factory InverterGroup.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InverterGroup.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InverterGroup', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'networkId')
    ..aOS(3, _omitFieldNames ? '' : 'inverterAssetId')
    ..pPS(4, _omitFieldNames ? '' : 'stringIds')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'dcInputKw', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'acOutputKw', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'dcAcRatio', $pb.PbFieldType.OD)
    ..aOS(8, _omitFieldNames ? '' : 'positionGeojson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InverterGroup clone() => InverterGroup()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InverterGroup copyWith(void Function(InverterGroup) updates) => super.copyWith((message) => updates(message as InverterGroup)) as InverterGroup;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InverterGroup create() => InverterGroup._();
  InverterGroup createEmptyInstance() => create();
  static $pb.PbList<InverterGroup> createRepeated() => $pb.PbList<InverterGroup>();
  @$core.pragma('dart2js:noInline')
  static InverterGroup getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InverterGroup>(create);
  static InverterGroup? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get networkId => $_getSZ(1);
  @$pb.TagNumber(2)
  set networkId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNetworkId() => $_has(1);
  @$pb.TagNumber(2)
  void clearNetworkId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get inverterAssetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set inverterAssetId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasInverterAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearInverterAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get stringIds => $_getList(3);

  @$pb.TagNumber(5)
  $core.double get dcInputKw => $_getN(4);
  @$pb.TagNumber(5)
  set dcInputKw($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDcInputKw() => $_has(4);
  @$pb.TagNumber(5)
  void clearDcInputKw() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get acOutputKw => $_getN(5);
  @$pb.TagNumber(6)
  set acOutputKw($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAcOutputKw() => $_has(5);
  @$pb.TagNumber(6)
  void clearAcOutputKw() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get dcAcRatio => $_getN(6);
  @$pb.TagNumber(7)
  set dcAcRatio($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDcAcRatio() => $_has(6);
  @$pb.TagNumber(7)
  void clearDcAcRatio() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get positionGeojson => $_getSZ(7);
  @$pb.TagNumber(8)
  set positionGeojson($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasPositionGeojson() => $_has(7);
  @$pb.TagNumber(8)
  void clearPositionGeojson() => $_clearField(8);
}

class CreateNetworkRequest extends $pb.GeneratedMessage {
  factory CreateNetworkRequest({
    $core.String? projectId,
    $core.String? layoutId,
    $core.String? name,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  CreateNetworkRequest._() : super();
  factory CreateNetworkRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateNetworkRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateNetworkRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateNetworkRequest clone() => CreateNetworkRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateNetworkRequest copyWith(void Function(CreateNetworkRequest) updates) => super.copyWith((message) => updates(message as CreateNetworkRequest)) as CreateNetworkRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateNetworkRequest create() => CreateNetworkRequest._();
  CreateNetworkRequest createEmptyInstance() => create();
  static $pb.PbList<CreateNetworkRequest> createRepeated() => $pb.PbList<CreateNetworkRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateNetworkRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateNetworkRequest>(create);
  static CreateNetworkRequest? _defaultInstance;

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
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);
}

class CreateNetworkResponse extends $pb.GeneratedMessage {
  factory CreateNetworkResponse({
    ElectricalNetwork? network,
  }) {
    final $result = create();
    if (network != null) {
      $result.network = network;
    }
    return $result;
  }
  CreateNetworkResponse._() : super();
  factory CreateNetworkResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateNetworkResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateNetworkResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOM<ElectricalNetwork>(1, _omitFieldNames ? '' : 'network', subBuilder: ElectricalNetwork.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateNetworkResponse clone() => CreateNetworkResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateNetworkResponse copyWith(void Function(CreateNetworkResponse) updates) => super.copyWith((message) => updates(message as CreateNetworkResponse)) as CreateNetworkResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateNetworkResponse create() => CreateNetworkResponse._();
  CreateNetworkResponse createEmptyInstance() => create();
  static $pb.PbList<CreateNetworkResponse> createRepeated() => $pb.PbList<CreateNetworkResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateNetworkResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateNetworkResponse>(create);
  static CreateNetworkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ElectricalNetwork get network => $_getN(0);
  @$pb.TagNumber(1)
  set network(ElectricalNetwork v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetwork() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetwork() => $_clearField(1);
  @$pb.TagNumber(1)
  ElectricalNetwork ensureNetwork() => $_ensure(0);
}

class GetNetworkRequest extends $pb.GeneratedMessage {
  factory GetNetworkRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetNetworkRequest._() : super();
  factory GetNetworkRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetNetworkRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetNetworkRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetNetworkRequest clone() => GetNetworkRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetNetworkRequest copyWith(void Function(GetNetworkRequest) updates) => super.copyWith((message) => updates(message as GetNetworkRequest)) as GetNetworkRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNetworkRequest create() => GetNetworkRequest._();
  GetNetworkRequest createEmptyInstance() => create();
  static $pb.PbList<GetNetworkRequest> createRepeated() => $pb.PbList<GetNetworkRequest>();
  @$core.pragma('dart2js:noInline')
  static GetNetworkRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetNetworkRequest>(create);
  static GetNetworkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetNetworkResponse extends $pb.GeneratedMessage {
  factory GetNetworkResponse({
    ElectricalNetwork? network,
  }) {
    final $result = create();
    if (network != null) {
      $result.network = network;
    }
    return $result;
  }
  GetNetworkResponse._() : super();
  factory GetNetworkResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetNetworkResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetNetworkResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOM<ElectricalNetwork>(1, _omitFieldNames ? '' : 'network', subBuilder: ElectricalNetwork.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetNetworkResponse clone() => GetNetworkResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetNetworkResponse copyWith(void Function(GetNetworkResponse) updates) => super.copyWith((message) => updates(message as GetNetworkResponse)) as GetNetworkResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetNetworkResponse create() => GetNetworkResponse._();
  GetNetworkResponse createEmptyInstance() => create();
  static $pb.PbList<GetNetworkResponse> createRepeated() => $pb.PbList<GetNetworkResponse>();
  @$core.pragma('dart2js:noInline')
  static GetNetworkResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetNetworkResponse>(create);
  static GetNetworkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ElectricalNetwork get network => $_getN(0);
  @$pb.TagNumber(1)
  set network(ElectricalNetwork v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetwork() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetwork() => $_clearField(1);
  @$pb.TagNumber(1)
  ElectricalNetwork ensureNetwork() => $_ensure(0);
}

class ListNetworksRequest extends $pb.GeneratedMessage {
  factory ListNetworksRequest({
    $core.String? projectId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    return $result;
  }
  ListNetworksRequest._() : super();
  factory ListNetworksRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListNetworksRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListNetworksRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListNetworksRequest clone() => ListNetworksRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListNetworksRequest copyWith(void Function(ListNetworksRequest) updates) => super.copyWith((message) => updates(message as ListNetworksRequest)) as ListNetworksRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListNetworksRequest create() => ListNetworksRequest._();
  ListNetworksRequest createEmptyInstance() => create();
  static $pb.PbList<ListNetworksRequest> createRepeated() => $pb.PbList<ListNetworksRequest>();
  @$core.pragma('dart2js:noInline')
  static ListNetworksRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListNetworksRequest>(create);
  static ListNetworksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);
}

class ListNetworksResponse extends $pb.GeneratedMessage {
  factory ListNetworksResponse({
    $core.Iterable<ElectricalNetwork>? networks,
  }) {
    final $result = create();
    if (networks != null) {
      $result.networks.addAll(networks);
    }
    return $result;
  }
  ListNetworksResponse._() : super();
  factory ListNetworksResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListNetworksResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListNetworksResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..pc<ElectricalNetwork>(1, _omitFieldNames ? '' : 'networks', $pb.PbFieldType.PM, subBuilder: ElectricalNetwork.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListNetworksResponse clone() => ListNetworksResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListNetworksResponse copyWith(void Function(ListNetworksResponse) updates) => super.copyWith((message) => updates(message as ListNetworksResponse)) as ListNetworksResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListNetworksResponse create() => ListNetworksResponse._();
  ListNetworksResponse createEmptyInstance() => create();
  static $pb.PbList<ListNetworksResponse> createRepeated() => $pb.PbList<ListNetworksResponse>();
  @$core.pragma('dart2js:noInline')
  static ListNetworksResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListNetworksResponse>(create);
  static ListNetworksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ElectricalNetwork> get networks => $_getList(0);
}

class DeleteNetworkRequest extends $pb.GeneratedMessage {
  factory DeleteNetworkRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteNetworkRequest._() : super();
  factory DeleteNetworkRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteNetworkRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteNetworkRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteNetworkRequest clone() => DeleteNetworkRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteNetworkRequest copyWith(void Function(DeleteNetworkRequest) updates) => super.copyWith((message) => updates(message as DeleteNetworkRequest)) as DeleteNetworkRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteNetworkRequest create() => DeleteNetworkRequest._();
  DeleteNetworkRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteNetworkRequest> createRepeated() => $pb.PbList<DeleteNetworkRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteNetworkRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteNetworkRequest>(create);
  static DeleteNetworkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteNetworkResponse extends $pb.GeneratedMessage {
  factory DeleteNetworkResponse() => create();
  DeleteNetworkResponse._() : super();
  factory DeleteNetworkResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteNetworkResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteNetworkResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteNetworkResponse clone() => DeleteNetworkResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteNetworkResponse copyWith(void Function(DeleteNetworkResponse) updates) => super.copyWith((message) => updates(message as DeleteNetworkResponse)) as DeleteNetworkResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteNetworkResponse create() => DeleteNetworkResponse._();
  DeleteNetworkResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteNetworkResponse> createRepeated() => $pb.PbList<DeleteNetworkResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteNetworkResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteNetworkResponse>(create);
  static DeleteNetworkResponse? _defaultInstance;
}

/// ========== Acceptance Request/Response Messages ==========
class SubmitNetworkForReviewRequest extends $pb.GeneratedMessage {
  factory SubmitNetworkForReviewRequest({
    $core.String? networkId,
    $core.String? submissionReason,
    $core.String? submittedByActorId,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    if (submissionReason != null) {
      $result.submissionReason = submissionReason;
    }
    if (submittedByActorId != null) {
      $result.submittedByActorId = submittedByActorId;
    }
    return $result;
  }
  SubmitNetworkForReviewRequest._() : super();
  factory SubmitNetworkForReviewRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitNetworkForReviewRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitNetworkForReviewRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..aOS(2, _omitFieldNames ? '' : 'submissionReason')
    ..aOS(3, _omitFieldNames ? '' : 'submittedByActorId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitNetworkForReviewRequest clone() => SubmitNetworkForReviewRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitNetworkForReviewRequest copyWith(void Function(SubmitNetworkForReviewRequest) updates) => super.copyWith((message) => updates(message as SubmitNetworkForReviewRequest)) as SubmitNetworkForReviewRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitNetworkForReviewRequest create() => SubmitNetworkForReviewRequest._();
  SubmitNetworkForReviewRequest createEmptyInstance() => create();
  static $pb.PbList<SubmitNetworkForReviewRequest> createRepeated() => $pb.PbList<SubmitNetworkForReviewRequest>();
  @$core.pragma('dart2js:noInline')
  static SubmitNetworkForReviewRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitNetworkForReviewRequest>(create);
  static SubmitNetworkForReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get submissionReason => $_getSZ(1);
  @$pb.TagNumber(2)
  set submissionReason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSubmissionReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubmissionReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get submittedByActorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set submittedByActorId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSubmittedByActorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSubmittedByActorId() => $_clearField(3);
}

class SubmitNetworkForReviewResponse extends $pb.GeneratedMessage {
  factory SubmitNetworkForReviewResponse({
    ElectricalNetwork? network,
    ReviewMetadata? reviewMetadata,
  }) {
    final $result = create();
    if (network != null) {
      $result.network = network;
    }
    if (reviewMetadata != null) {
      $result.reviewMetadata = reviewMetadata;
    }
    return $result;
  }
  SubmitNetworkForReviewResponse._() : super();
  factory SubmitNetworkForReviewResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitNetworkForReviewResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitNetworkForReviewResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOM<ElectricalNetwork>(1, _omitFieldNames ? '' : 'network', subBuilder: ElectricalNetwork.create)
    ..aOM<ReviewMetadata>(2, _omitFieldNames ? '' : 'reviewMetadata', subBuilder: ReviewMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitNetworkForReviewResponse clone() => SubmitNetworkForReviewResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitNetworkForReviewResponse copyWith(void Function(SubmitNetworkForReviewResponse) updates) => super.copyWith((message) => updates(message as SubmitNetworkForReviewResponse)) as SubmitNetworkForReviewResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitNetworkForReviewResponse create() => SubmitNetworkForReviewResponse._();
  SubmitNetworkForReviewResponse createEmptyInstance() => create();
  static $pb.PbList<SubmitNetworkForReviewResponse> createRepeated() => $pb.PbList<SubmitNetworkForReviewResponse>();
  @$core.pragma('dart2js:noInline')
  static SubmitNetworkForReviewResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitNetworkForReviewResponse>(create);
  static SubmitNetworkForReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ElectricalNetwork get network => $_getN(0);
  @$pb.TagNumber(1)
  set network(ElectricalNetwork v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetwork() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetwork() => $_clearField(1);
  @$pb.TagNumber(1)
  ElectricalNetwork ensureNetwork() => $_ensure(0);

  @$pb.TagNumber(2)
  ReviewMetadata get reviewMetadata => $_getN(1);
  @$pb.TagNumber(2)
  set reviewMetadata(ReviewMetadata v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasReviewMetadata() => $_has(1);
  @$pb.TagNumber(2)
  void clearReviewMetadata() => $_clearField(2);
  @$pb.TagNumber(2)
  ReviewMetadata ensureReviewMetadata() => $_ensure(1);
}

class ApproveNetworkRequest extends $pb.GeneratedMessage {
  factory ApproveNetworkRequest({
    $core.String? networkId,
    $core.double? qualityScore,
    $core.double? feasibilityScore,
    $core.Iterable<$core.String>? approvalComments,
    $core.String? approvedByActorId,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    if (qualityScore != null) {
      $result.qualityScore = qualityScore;
    }
    if (feasibilityScore != null) {
      $result.feasibilityScore = feasibilityScore;
    }
    if (approvalComments != null) {
      $result.approvalComments.addAll(approvalComments);
    }
    if (approvedByActorId != null) {
      $result.approvedByActorId = approvedByActorId;
    }
    return $result;
  }
  ApproveNetworkRequest._() : super();
  factory ApproveNetworkRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApproveNetworkRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApproveNetworkRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'qualityScore', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'feasibilityScore', $pb.PbFieldType.OD)
    ..pPS(4, _omitFieldNames ? '' : 'approvalComments')
    ..aOS(5, _omitFieldNames ? '' : 'approvedByActorId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApproveNetworkRequest clone() => ApproveNetworkRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApproveNetworkRequest copyWith(void Function(ApproveNetworkRequest) updates) => super.copyWith((message) => updates(message as ApproveNetworkRequest)) as ApproveNetworkRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveNetworkRequest create() => ApproveNetworkRequest._();
  ApproveNetworkRequest createEmptyInstance() => create();
  static $pb.PbList<ApproveNetworkRequest> createRepeated() => $pb.PbList<ApproveNetworkRequest>();
  @$core.pragma('dart2js:noInline')
  static ApproveNetworkRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproveNetworkRequest>(create);
  static ApproveNetworkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get qualityScore => $_getN(1);
  @$pb.TagNumber(2)
  set qualityScore($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasQualityScore() => $_has(1);
  @$pb.TagNumber(2)
  void clearQualityScore() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get feasibilityScore => $_getN(2);
  @$pb.TagNumber(3)
  set feasibilityScore($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFeasibilityScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeasibilityScore() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get approvalComments => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get approvedByActorId => $_getSZ(4);
  @$pb.TagNumber(5)
  set approvedByActorId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasApprovedByActorId() => $_has(4);
  @$pb.TagNumber(5)
  void clearApprovedByActorId() => $_clearField(5);
}

class ApproveNetworkResponse extends $pb.GeneratedMessage {
  factory ApproveNetworkResponse({
    ElectricalNetwork? network,
    ReviewMetadata? reviewMetadata,
  }) {
    final $result = create();
    if (network != null) {
      $result.network = network;
    }
    if (reviewMetadata != null) {
      $result.reviewMetadata = reviewMetadata;
    }
    return $result;
  }
  ApproveNetworkResponse._() : super();
  factory ApproveNetworkResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApproveNetworkResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApproveNetworkResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOM<ElectricalNetwork>(1, _omitFieldNames ? '' : 'network', subBuilder: ElectricalNetwork.create)
    ..aOM<ReviewMetadata>(2, _omitFieldNames ? '' : 'reviewMetadata', subBuilder: ReviewMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApproveNetworkResponse clone() => ApproveNetworkResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApproveNetworkResponse copyWith(void Function(ApproveNetworkResponse) updates) => super.copyWith((message) => updates(message as ApproveNetworkResponse)) as ApproveNetworkResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveNetworkResponse create() => ApproveNetworkResponse._();
  ApproveNetworkResponse createEmptyInstance() => create();
  static $pb.PbList<ApproveNetworkResponse> createRepeated() => $pb.PbList<ApproveNetworkResponse>();
  @$core.pragma('dart2js:noInline')
  static ApproveNetworkResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproveNetworkResponse>(create);
  static ApproveNetworkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ElectricalNetwork get network => $_getN(0);
  @$pb.TagNumber(1)
  set network(ElectricalNetwork v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetwork() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetwork() => $_clearField(1);
  @$pb.TagNumber(1)
  ElectricalNetwork ensureNetwork() => $_ensure(0);

  @$pb.TagNumber(2)
  ReviewMetadata get reviewMetadata => $_getN(1);
  @$pb.TagNumber(2)
  set reviewMetadata(ReviewMetadata v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasReviewMetadata() => $_has(1);
  @$pb.TagNumber(2)
  void clearReviewMetadata() => $_clearField(2);
  @$pb.TagNumber(2)
  ReviewMetadata ensureReviewMetadata() => $_ensure(1);
}

class RejectNetworkRequest extends $pb.GeneratedMessage {
  factory RejectNetworkRequest({
    $core.String? networkId,
    $core.Iterable<$core.String>? rejectionReasons,
    $core.String? rejectedByActorId,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    if (rejectionReasons != null) {
      $result.rejectionReasons.addAll(rejectionReasons);
    }
    if (rejectedByActorId != null) {
      $result.rejectedByActorId = rejectedByActorId;
    }
    return $result;
  }
  RejectNetworkRequest._() : super();
  factory RejectNetworkRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RejectNetworkRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RejectNetworkRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..pPS(2, _omitFieldNames ? '' : 'rejectionReasons')
    ..aOS(3, _omitFieldNames ? '' : 'rejectedByActorId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RejectNetworkRequest clone() => RejectNetworkRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RejectNetworkRequest copyWith(void Function(RejectNetworkRequest) updates) => super.copyWith((message) => updates(message as RejectNetworkRequest)) as RejectNetworkRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectNetworkRequest create() => RejectNetworkRequest._();
  RejectNetworkRequest createEmptyInstance() => create();
  static $pb.PbList<RejectNetworkRequest> createRepeated() => $pb.PbList<RejectNetworkRequest>();
  @$core.pragma('dart2js:noInline')
  static RejectNetworkRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RejectNetworkRequest>(create);
  static RejectNetworkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get rejectionReasons => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get rejectedByActorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set rejectedByActorId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRejectedByActorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRejectedByActorId() => $_clearField(3);
}

class RejectNetworkResponse extends $pb.GeneratedMessage {
  factory RejectNetworkResponse({
    ElectricalNetwork? network,
    ReviewMetadata? reviewMetadata,
  }) {
    final $result = create();
    if (network != null) {
      $result.network = network;
    }
    if (reviewMetadata != null) {
      $result.reviewMetadata = reviewMetadata;
    }
    return $result;
  }
  RejectNetworkResponse._() : super();
  factory RejectNetworkResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RejectNetworkResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RejectNetworkResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOM<ElectricalNetwork>(1, _omitFieldNames ? '' : 'network', subBuilder: ElectricalNetwork.create)
    ..aOM<ReviewMetadata>(2, _omitFieldNames ? '' : 'reviewMetadata', subBuilder: ReviewMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RejectNetworkResponse clone() => RejectNetworkResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RejectNetworkResponse copyWith(void Function(RejectNetworkResponse) updates) => super.copyWith((message) => updates(message as RejectNetworkResponse)) as RejectNetworkResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectNetworkResponse create() => RejectNetworkResponse._();
  RejectNetworkResponse createEmptyInstance() => create();
  static $pb.PbList<RejectNetworkResponse> createRepeated() => $pb.PbList<RejectNetworkResponse>();
  @$core.pragma('dart2js:noInline')
  static RejectNetworkResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RejectNetworkResponse>(create);
  static RejectNetworkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ElectricalNetwork get network => $_getN(0);
  @$pb.TagNumber(1)
  set network(ElectricalNetwork v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetwork() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetwork() => $_clearField(1);
  @$pb.TagNumber(1)
  ElectricalNetwork ensureNetwork() => $_ensure(0);

  @$pb.TagNumber(2)
  ReviewMetadata get reviewMetadata => $_getN(1);
  @$pb.TagNumber(2)
  set reviewMetadata(ReviewMetadata v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasReviewMetadata() => $_has(1);
  @$pb.TagNumber(2)
  void clearReviewMetadata() => $_clearField(2);
  @$pb.TagNumber(2)
  ReviewMetadata ensureReviewMetadata() => $_ensure(1);
}

class CreateStringRequest extends $pb.GeneratedMessage {
  factory CreateStringRequest({
    $core.String? networkId,
    $core.Iterable<$core.String>? panelIds,
    $core.String? inverterGroupId,
    $core.double? panelVoltage,
    $core.double? panelCurrent,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    if (panelIds != null) {
      $result.panelIds.addAll(panelIds);
    }
    if (inverterGroupId != null) {
      $result.inverterGroupId = inverterGroupId;
    }
    if (panelVoltage != null) {
      $result.panelVoltage = panelVoltage;
    }
    if (panelCurrent != null) {
      $result.panelCurrent = panelCurrent;
    }
    return $result;
  }
  CreateStringRequest._() : super();
  factory CreateStringRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateStringRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateStringRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..pPS(2, _omitFieldNames ? '' : 'panelIds')
    ..aOS(3, _omitFieldNames ? '' : 'inverterGroupId')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'panelVoltage', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'panelCurrent', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateStringRequest clone() => CreateStringRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateStringRequest copyWith(void Function(CreateStringRequest) updates) => super.copyWith((message) => updates(message as CreateStringRequest)) as CreateStringRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateStringRequest create() => CreateStringRequest._();
  CreateStringRequest createEmptyInstance() => create();
  static $pb.PbList<CreateStringRequest> createRepeated() => $pb.PbList<CreateStringRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateStringRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateStringRequest>(create);
  static CreateStringRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get panelIds => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get inverterGroupId => $_getSZ(2);
  @$pb.TagNumber(3)
  set inverterGroupId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasInverterGroupId() => $_has(2);
  @$pb.TagNumber(3)
  void clearInverterGroupId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get panelVoltage => $_getN(3);
  @$pb.TagNumber(4)
  set panelVoltage($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPanelVoltage() => $_has(3);
  @$pb.TagNumber(4)
  void clearPanelVoltage() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get panelCurrent => $_getN(4);
  @$pb.TagNumber(5)
  set panelCurrent($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPanelCurrent() => $_has(4);
  @$pb.TagNumber(5)
  void clearPanelCurrent() => $_clearField(5);
}

class CreateStringResponse extends $pb.GeneratedMessage {
  factory CreateStringResponse({
    PanelString? panelString,
  }) {
    final $result = create();
    if (panelString != null) {
      $result.panelString = panelString;
    }
    return $result;
  }
  CreateStringResponse._() : super();
  factory CreateStringResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateStringResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateStringResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOM<PanelString>(1, _omitFieldNames ? '' : 'panelString', subBuilder: PanelString.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateStringResponse clone() => CreateStringResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateStringResponse copyWith(void Function(CreateStringResponse) updates) => super.copyWith((message) => updates(message as CreateStringResponse)) as CreateStringResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateStringResponse create() => CreateStringResponse._();
  CreateStringResponse createEmptyInstance() => create();
  static $pb.PbList<CreateStringResponse> createRepeated() => $pb.PbList<CreateStringResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateStringResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateStringResponse>(create);
  static CreateStringResponse? _defaultInstance;

  @$pb.TagNumber(1)
  PanelString get panelString => $_getN(0);
  @$pb.TagNumber(1)
  set panelString(PanelString v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPanelString() => $_has(0);
  @$pb.TagNumber(1)
  void clearPanelString() => $_clearField(1);
  @$pb.TagNumber(1)
  PanelString ensurePanelString() => $_ensure(0);
}

class AutoGenerateStringsRequest extends $pb.GeneratedMessage {
  factory AutoGenerateStringsRequest({
    $core.String? networkId,
    $core.String? layoutId,
    $core.int? panelsPerString,
    $core.String? inverterAssetId,
    $core.int? stringsPerInverter,
    $core.int? totalPanels,
    $core.double? panelVoltage,
    $core.double? panelCurrent,
    $core.double? panelPowerW,
    $core.double? inverterAcKw,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (panelsPerString != null) {
      $result.panelsPerString = panelsPerString;
    }
    if (inverterAssetId != null) {
      $result.inverterAssetId = inverterAssetId;
    }
    if (stringsPerInverter != null) {
      $result.stringsPerInverter = stringsPerInverter;
    }
    if (totalPanels != null) {
      $result.totalPanels = totalPanels;
    }
    if (panelVoltage != null) {
      $result.panelVoltage = panelVoltage;
    }
    if (panelCurrent != null) {
      $result.panelCurrent = panelCurrent;
    }
    if (panelPowerW != null) {
      $result.panelPowerW = panelPowerW;
    }
    if (inverterAcKw != null) {
      $result.inverterAcKw = inverterAcKw;
    }
    return $result;
  }
  AutoGenerateStringsRequest._() : super();
  factory AutoGenerateStringsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AutoGenerateStringsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AutoGenerateStringsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'panelsPerString', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'inverterAssetId')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'stringsPerInverter', $pb.PbFieldType.O3)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'totalPanels', $pb.PbFieldType.O3)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'panelVoltage', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'panelCurrent', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'panelPowerW', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'inverterAcKw', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AutoGenerateStringsRequest clone() => AutoGenerateStringsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AutoGenerateStringsRequest copyWith(void Function(AutoGenerateStringsRequest) updates) => super.copyWith((message) => updates(message as AutoGenerateStringsRequest)) as AutoGenerateStringsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AutoGenerateStringsRequest create() => AutoGenerateStringsRequest._();
  AutoGenerateStringsRequest createEmptyInstance() => create();
  static $pb.PbList<AutoGenerateStringsRequest> createRepeated() => $pb.PbList<AutoGenerateStringsRequest>();
  @$core.pragma('dart2js:noInline')
  static AutoGenerateStringsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AutoGenerateStringsRequest>(create);
  static AutoGenerateStringsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get layoutId => $_getSZ(1);
  @$pb.TagNumber(2)
  set layoutId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayoutId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayoutId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get panelsPerString => $_getIZ(2);
  @$pb.TagNumber(3)
  set panelsPerString($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPanelsPerString() => $_has(2);
  @$pb.TagNumber(3)
  void clearPanelsPerString() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get inverterAssetId => $_getSZ(3);
  @$pb.TagNumber(4)
  set inverterAssetId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasInverterAssetId() => $_has(3);
  @$pb.TagNumber(4)
  void clearInverterAssetId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get stringsPerInverter => $_getIZ(4);
  @$pb.TagNumber(5)
  set stringsPerInverter($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasStringsPerInverter() => $_has(4);
  @$pb.TagNumber(5)
  void clearStringsPerInverter() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get totalPanels => $_getIZ(5);
  @$pb.TagNumber(6)
  set totalPanels($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTotalPanels() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalPanels() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get panelVoltage => $_getN(6);
  @$pb.TagNumber(7)
  set panelVoltage($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPanelVoltage() => $_has(6);
  @$pb.TagNumber(7)
  void clearPanelVoltage() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get panelCurrent => $_getN(7);
  @$pb.TagNumber(8)
  set panelCurrent($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasPanelCurrent() => $_has(7);
  @$pb.TagNumber(8)
  void clearPanelCurrent() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get panelPowerW => $_getN(8);
  @$pb.TagNumber(9)
  set panelPowerW($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasPanelPowerW() => $_has(8);
  @$pb.TagNumber(9)
  void clearPanelPowerW() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get inverterAcKw => $_getN(9);
  @$pb.TagNumber(10)
  set inverterAcKw($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasInverterAcKw() => $_has(9);
  @$pb.TagNumber(10)
  void clearInverterAcKw() => $_clearField(10);
}

class AutoGenerateStringsResponse extends $pb.GeneratedMessage {
  factory AutoGenerateStringsResponse({
    $core.int? stringsCreated,
    $core.int? inverterGroupsCreated,
    $core.double? totalDcKw,
    $core.double? totalAcKw,
    ElectricalNetwork? network,
  }) {
    final $result = create();
    if (stringsCreated != null) {
      $result.stringsCreated = stringsCreated;
    }
    if (inverterGroupsCreated != null) {
      $result.inverterGroupsCreated = inverterGroupsCreated;
    }
    if (totalDcKw != null) {
      $result.totalDcKw = totalDcKw;
    }
    if (totalAcKw != null) {
      $result.totalAcKw = totalAcKw;
    }
    if (network != null) {
      $result.network = network;
    }
    return $result;
  }
  AutoGenerateStringsResponse._() : super();
  factory AutoGenerateStringsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AutoGenerateStringsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AutoGenerateStringsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'stringsCreated', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'inverterGroupsCreated', $pb.PbFieldType.O3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'totalDcKw', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'totalAcKw', $pb.PbFieldType.OD)
    ..aOM<ElectricalNetwork>(5, _omitFieldNames ? '' : 'network', subBuilder: ElectricalNetwork.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AutoGenerateStringsResponse clone() => AutoGenerateStringsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AutoGenerateStringsResponse copyWith(void Function(AutoGenerateStringsResponse) updates) => super.copyWith((message) => updates(message as AutoGenerateStringsResponse)) as AutoGenerateStringsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AutoGenerateStringsResponse create() => AutoGenerateStringsResponse._();
  AutoGenerateStringsResponse createEmptyInstance() => create();
  static $pb.PbList<AutoGenerateStringsResponse> createRepeated() => $pb.PbList<AutoGenerateStringsResponse>();
  @$core.pragma('dart2js:noInline')
  static AutoGenerateStringsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AutoGenerateStringsResponse>(create);
  static AutoGenerateStringsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get stringsCreated => $_getIZ(0);
  @$pb.TagNumber(1)
  set stringsCreated($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStringsCreated() => $_has(0);
  @$pb.TagNumber(1)
  void clearStringsCreated() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get inverterGroupsCreated => $_getIZ(1);
  @$pb.TagNumber(2)
  set inverterGroupsCreated($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInverterGroupsCreated() => $_has(1);
  @$pb.TagNumber(2)
  void clearInverterGroupsCreated() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get totalDcKw => $_getN(2);
  @$pb.TagNumber(3)
  set totalDcKw($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalDcKw() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalDcKw() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get totalAcKw => $_getN(3);
  @$pb.TagNumber(4)
  set totalAcKw($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalAcKw() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalAcKw() => $_clearField(4);

  @$pb.TagNumber(5)
  ElectricalNetwork get network => $_getN(4);
  @$pb.TagNumber(5)
  set network(ElectricalNetwork v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasNetwork() => $_has(4);
  @$pb.TagNumber(5)
  void clearNetwork() => $_clearField(5);
  @$pb.TagNumber(5)
  ElectricalNetwork ensureNetwork() => $_ensure(4);
}

class ListStringsRequest extends $pb.GeneratedMessage {
  factory ListStringsRequest({
    $core.String? networkId,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    return $result;
  }
  ListStringsRequest._() : super();
  factory ListStringsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListStringsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListStringsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListStringsRequest clone() => ListStringsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListStringsRequest copyWith(void Function(ListStringsRequest) updates) => super.copyWith((message) => updates(message as ListStringsRequest)) as ListStringsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListStringsRequest create() => ListStringsRequest._();
  ListStringsRequest createEmptyInstance() => create();
  static $pb.PbList<ListStringsRequest> createRepeated() => $pb.PbList<ListStringsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListStringsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListStringsRequest>(create);
  static ListStringsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);
}

class ListStringsResponse extends $pb.GeneratedMessage {
  factory ListStringsResponse({
    $core.Iterable<PanelString>? strings,
  }) {
    final $result = create();
    if (strings != null) {
      $result.strings.addAll(strings);
    }
    return $result;
  }
  ListStringsResponse._() : super();
  factory ListStringsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListStringsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListStringsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..pc<PanelString>(1, _omitFieldNames ? '' : 'strings', $pb.PbFieldType.PM, subBuilder: PanelString.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListStringsResponse clone() => ListStringsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListStringsResponse copyWith(void Function(ListStringsResponse) updates) => super.copyWith((message) => updates(message as ListStringsResponse)) as ListStringsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListStringsResponse create() => ListStringsResponse._();
  ListStringsResponse createEmptyInstance() => create();
  static $pb.PbList<ListStringsResponse> createRepeated() => $pb.PbList<ListStringsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListStringsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListStringsResponse>(create);
  static ListStringsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PanelString> get strings => $_getList(0);
}

class AssignInverterRequest extends $pb.GeneratedMessage {
  factory AssignInverterRequest({
    $core.String? networkId,
    $core.String? inverterAssetId,
    $core.Iterable<$core.String>? stringIds,
    $core.String? positionGeojson,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    if (inverterAssetId != null) {
      $result.inverterAssetId = inverterAssetId;
    }
    if (stringIds != null) {
      $result.stringIds.addAll(stringIds);
    }
    if (positionGeojson != null) {
      $result.positionGeojson = positionGeojson;
    }
    return $result;
  }
  AssignInverterRequest._() : super();
  factory AssignInverterRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssignInverterRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AssignInverterRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..aOS(2, _omitFieldNames ? '' : 'inverterAssetId')
    ..pPS(3, _omitFieldNames ? '' : 'stringIds')
    ..aOS(4, _omitFieldNames ? '' : 'positionGeojson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssignInverterRequest clone() => AssignInverterRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssignInverterRequest copyWith(void Function(AssignInverterRequest) updates) => super.copyWith((message) => updates(message as AssignInverterRequest)) as AssignInverterRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignInverterRequest create() => AssignInverterRequest._();
  AssignInverterRequest createEmptyInstance() => create();
  static $pb.PbList<AssignInverterRequest> createRepeated() => $pb.PbList<AssignInverterRequest>();
  @$core.pragma('dart2js:noInline')
  static AssignInverterRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssignInverterRequest>(create);
  static AssignInverterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get inverterAssetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set inverterAssetId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInverterAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearInverterAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get stringIds => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get positionGeojson => $_getSZ(3);
  @$pb.TagNumber(4)
  set positionGeojson($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPositionGeojson() => $_has(3);
  @$pb.TagNumber(4)
  void clearPositionGeojson() => $_clearField(4);
}

class AssignInverterResponse extends $pb.GeneratedMessage {
  factory AssignInverterResponse({
    InverterGroup? inverterGroup,
  }) {
    final $result = create();
    if (inverterGroup != null) {
      $result.inverterGroup = inverterGroup;
    }
    return $result;
  }
  AssignInverterResponse._() : super();
  factory AssignInverterResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssignInverterResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AssignInverterResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOM<InverterGroup>(1, _omitFieldNames ? '' : 'inverterGroup', subBuilder: InverterGroup.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssignInverterResponse clone() => AssignInverterResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssignInverterResponse copyWith(void Function(AssignInverterResponse) updates) => super.copyWith((message) => updates(message as AssignInverterResponse)) as AssignInverterResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssignInverterResponse create() => AssignInverterResponse._();
  AssignInverterResponse createEmptyInstance() => create();
  static $pb.PbList<AssignInverterResponse> createRepeated() => $pb.PbList<AssignInverterResponse>();
  @$core.pragma('dart2js:noInline')
  static AssignInverterResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssignInverterResponse>(create);
  static AssignInverterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  InverterGroup get inverterGroup => $_getN(0);
  @$pb.TagNumber(1)
  set inverterGroup(InverterGroup v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasInverterGroup() => $_has(0);
  @$pb.TagNumber(1)
  void clearInverterGroup() => $_clearField(1);
  @$pb.TagNumber(1)
  InverterGroup ensureInverterGroup() => $_ensure(0);
}

class ListInverterGroupsRequest extends $pb.GeneratedMessage {
  factory ListInverterGroupsRequest({
    $core.String? networkId,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    return $result;
  }
  ListInverterGroupsRequest._() : super();
  factory ListInverterGroupsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListInverterGroupsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListInverterGroupsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListInverterGroupsRequest clone() => ListInverterGroupsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListInverterGroupsRequest copyWith(void Function(ListInverterGroupsRequest) updates) => super.copyWith((message) => updates(message as ListInverterGroupsRequest)) as ListInverterGroupsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListInverterGroupsRequest create() => ListInverterGroupsRequest._();
  ListInverterGroupsRequest createEmptyInstance() => create();
  static $pb.PbList<ListInverterGroupsRequest> createRepeated() => $pb.PbList<ListInverterGroupsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListInverterGroupsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListInverterGroupsRequest>(create);
  static ListInverterGroupsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);
}

class ListInverterGroupsResponse extends $pb.GeneratedMessage {
  factory ListInverterGroupsResponse({
    $core.Iterable<InverterGroup>? inverterGroups,
  }) {
    final $result = create();
    if (inverterGroups != null) {
      $result.inverterGroups.addAll(inverterGroups);
    }
    return $result;
  }
  ListInverterGroupsResponse._() : super();
  factory ListInverterGroupsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListInverterGroupsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListInverterGroupsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..pc<InverterGroup>(1, _omitFieldNames ? '' : 'inverterGroups', $pb.PbFieldType.PM, subBuilder: InverterGroup.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListInverterGroupsResponse clone() => ListInverterGroupsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListInverterGroupsResponse copyWith(void Function(ListInverterGroupsResponse) updates) => super.copyWith((message) => updates(message as ListInverterGroupsResponse)) as ListInverterGroupsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListInverterGroupsResponse create() => ListInverterGroupsResponse._();
  ListInverterGroupsResponse createEmptyInstance() => create();
  static $pb.PbList<ListInverterGroupsResponse> createRepeated() => $pb.PbList<ListInverterGroupsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListInverterGroupsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListInverterGroupsResponse>(create);
  static ListInverterGroupsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<InverterGroup> get inverterGroups => $_getList(0);
}

class CalculateDCCapacityRequest extends $pb.GeneratedMessage {
  factory CalculateDCCapacityRequest({
    $core.String? networkId,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    return $result;
  }
  CalculateDCCapacityRequest._() : super();
  factory CalculateDCCapacityRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateDCCapacityRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateDCCapacityRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateDCCapacityRequest clone() => CalculateDCCapacityRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateDCCapacityRequest copyWith(void Function(CalculateDCCapacityRequest) updates) => super.copyWith((message) => updates(message as CalculateDCCapacityRequest)) as CalculateDCCapacityRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateDCCapacityRequest create() => CalculateDCCapacityRequest._();
  CalculateDCCapacityRequest createEmptyInstance() => create();
  static $pb.PbList<CalculateDCCapacityRequest> createRepeated() => $pb.PbList<CalculateDCCapacityRequest>();
  @$core.pragma('dart2js:noInline')
  static CalculateDCCapacityRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateDCCapacityRequest>(create);
  static CalculateDCCapacityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);
}

class CalculateDCCapacityResponse extends $pb.GeneratedMessage {
  factory CalculateDCCapacityResponse({
    $core.double? totalDcKw,
    $core.int? totalPanels,
    $core.int? totalStrings,
  }) {
    final $result = create();
    if (totalDcKw != null) {
      $result.totalDcKw = totalDcKw;
    }
    if (totalPanels != null) {
      $result.totalPanels = totalPanels;
    }
    if (totalStrings != null) {
      $result.totalStrings = totalStrings;
    }
    return $result;
  }
  CalculateDCCapacityResponse._() : super();
  factory CalculateDCCapacityResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateDCCapacityResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateDCCapacityResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'totalDcKw', $pb.PbFieldType.OD)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'totalPanels', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalStrings', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateDCCapacityResponse clone() => CalculateDCCapacityResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateDCCapacityResponse copyWith(void Function(CalculateDCCapacityResponse) updates) => super.copyWith((message) => updates(message as CalculateDCCapacityResponse)) as CalculateDCCapacityResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateDCCapacityResponse create() => CalculateDCCapacityResponse._();
  CalculateDCCapacityResponse createEmptyInstance() => create();
  static $pb.PbList<CalculateDCCapacityResponse> createRepeated() => $pb.PbList<CalculateDCCapacityResponse>();
  @$core.pragma('dart2js:noInline')
  static CalculateDCCapacityResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateDCCapacityResponse>(create);
  static CalculateDCCapacityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get totalDcKw => $_getN(0);
  @$pb.TagNumber(1)
  set totalDcKw($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotalDcKw() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalDcKw() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalPanels => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalPanels($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalPanels() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalPanels() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalStrings => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalStrings($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalStrings() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalStrings() => $_clearField(3);
}

class CalculateACCapacityRequest extends $pb.GeneratedMessage {
  factory CalculateACCapacityRequest({
    $core.String? networkId,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    return $result;
  }
  CalculateACCapacityRequest._() : super();
  factory CalculateACCapacityRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateACCapacityRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateACCapacityRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateACCapacityRequest clone() => CalculateACCapacityRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateACCapacityRequest copyWith(void Function(CalculateACCapacityRequest) updates) => super.copyWith((message) => updates(message as CalculateACCapacityRequest)) as CalculateACCapacityRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateACCapacityRequest create() => CalculateACCapacityRequest._();
  CalculateACCapacityRequest createEmptyInstance() => create();
  static $pb.PbList<CalculateACCapacityRequest> createRepeated() => $pb.PbList<CalculateACCapacityRequest>();
  @$core.pragma('dart2js:noInline')
  static CalculateACCapacityRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateACCapacityRequest>(create);
  static CalculateACCapacityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);
}

class CalculateACCapacityResponse extends $pb.GeneratedMessage {
  factory CalculateACCapacityResponse({
    $core.double? totalAcKw,
    $core.double? dcAcRatio,
    $core.int? totalInverters,
  }) {
    final $result = create();
    if (totalAcKw != null) {
      $result.totalAcKw = totalAcKw;
    }
    if (dcAcRatio != null) {
      $result.dcAcRatio = dcAcRatio;
    }
    if (totalInverters != null) {
      $result.totalInverters = totalInverters;
    }
    return $result;
  }
  CalculateACCapacityResponse._() : super();
  factory CalculateACCapacityResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateACCapacityResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateACCapacityResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'totalAcKw', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'dcAcRatio', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalInverters', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateACCapacityResponse clone() => CalculateACCapacityResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateACCapacityResponse copyWith(void Function(CalculateACCapacityResponse) updates) => super.copyWith((message) => updates(message as CalculateACCapacityResponse)) as CalculateACCapacityResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateACCapacityResponse create() => CalculateACCapacityResponse._();
  CalculateACCapacityResponse createEmptyInstance() => create();
  static $pb.PbList<CalculateACCapacityResponse> createRepeated() => $pb.PbList<CalculateACCapacityResponse>();
  @$core.pragma('dart2js:noInline')
  static CalculateACCapacityResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateACCapacityResponse>(create);
  static CalculateACCapacityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get totalAcKw => $_getN(0);
  @$pb.TagNumber(1)
  set totalAcKw($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotalAcKw() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalAcKw() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get dcAcRatio => $_getN(1);
  @$pb.TagNumber(2)
  set dcAcRatio($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDcAcRatio() => $_has(1);
  @$pb.TagNumber(2)
  void clearDcAcRatio() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalInverters => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalInverters($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalInverters() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalInverters() => $_clearField(3);
}

class CalculateLossesRequest extends $pb.GeneratedMessage {
  factory CalculateLossesRequest({
    $core.String? networkId,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    return $result;
  }
  CalculateLossesRequest._() : super();
  factory CalculateLossesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateLossesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateLossesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateLossesRequest clone() => CalculateLossesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateLossesRequest copyWith(void Function(CalculateLossesRequest) updates) => super.copyWith((message) => updates(message as CalculateLossesRequest)) as CalculateLossesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateLossesRequest create() => CalculateLossesRequest._();
  CalculateLossesRequest createEmptyInstance() => create();
  static $pb.PbList<CalculateLossesRequest> createRepeated() => $pb.PbList<CalculateLossesRequest>();
  @$core.pragma('dart2js:noInline')
  static CalculateLossesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateLossesRequest>(create);
  static CalculateLossesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);
}

class CalculateLossesResponse extends $pb.GeneratedMessage {
  factory CalculateLossesResponse({
    $core.double? dcCableLossPercent,
    $core.double? acCableLossPercent,
    $core.double? inverterLossPercent,
    $core.double? transformerLossPercent,
    $core.double? totalLossPercent,
  }) {
    final $result = create();
    if (dcCableLossPercent != null) {
      $result.dcCableLossPercent = dcCableLossPercent;
    }
    if (acCableLossPercent != null) {
      $result.acCableLossPercent = acCableLossPercent;
    }
    if (inverterLossPercent != null) {
      $result.inverterLossPercent = inverterLossPercent;
    }
    if (transformerLossPercent != null) {
      $result.transformerLossPercent = transformerLossPercent;
    }
    if (totalLossPercent != null) {
      $result.totalLossPercent = totalLossPercent;
    }
    return $result;
  }
  CalculateLossesResponse._() : super();
  factory CalculateLossesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateLossesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateLossesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'dcCableLossPercent', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'acCableLossPercent', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'inverterLossPercent', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'transformerLossPercent', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'totalLossPercent', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateLossesResponse clone() => CalculateLossesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateLossesResponse copyWith(void Function(CalculateLossesResponse) updates) => super.copyWith((message) => updates(message as CalculateLossesResponse)) as CalculateLossesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateLossesResponse create() => CalculateLossesResponse._();
  CalculateLossesResponse createEmptyInstance() => create();
  static $pb.PbList<CalculateLossesResponse> createRepeated() => $pb.PbList<CalculateLossesResponse>();
  @$core.pragma('dart2js:noInline')
  static CalculateLossesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateLossesResponse>(create);
  static CalculateLossesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get dcCableLossPercent => $_getN(0);
  @$pb.TagNumber(1)
  set dcCableLossPercent($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDcCableLossPercent() => $_has(0);
  @$pb.TagNumber(1)
  void clearDcCableLossPercent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get acCableLossPercent => $_getN(1);
  @$pb.TagNumber(2)
  set acCableLossPercent($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAcCableLossPercent() => $_has(1);
  @$pb.TagNumber(2)
  void clearAcCableLossPercent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get inverterLossPercent => $_getN(2);
  @$pb.TagNumber(3)
  set inverterLossPercent($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasInverterLossPercent() => $_has(2);
  @$pb.TagNumber(3)
  void clearInverterLossPercent() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get transformerLossPercent => $_getN(3);
  @$pb.TagNumber(4)
  set transformerLossPercent($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTransformerLossPercent() => $_has(3);
  @$pb.TagNumber(4)
  void clearTransformerLossPercent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalLossPercent => $_getN(4);
  @$pb.TagNumber(5)
  set totalLossPercent($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalLossPercent() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalLossPercent() => $_clearField(5);
}

/// ValidateSizing checks DC/AC sizing constraints against parametric limits.
class ValidateSizingRequest extends $pb.GeneratedMessage {
  factory ValidateSizingRequest({
    $core.String? networkId,
    $core.double? panelVocV,
    $core.double? panelVmpV,
    $core.double? panelIscA,
    $core.double? panelImpA,
    $core.int? panelsPerString,
    $core.double? inverterVdcMaxV,
    $core.double? inverterVmpptMinV,
    $core.double? inverterVmpptMaxV,
    $core.double? inverterIdcMaxA,
    $core.double? inverterAcKw,
    $core.double? dcAcRatioMin,
    $core.double? dcAcRatioMax,
    $core.double? tempCoeffVocPctPerC,
    $core.double? lowestExpectedTempC,
    $core.double? highestExpectedTempC,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    if (panelVocV != null) {
      $result.panelVocV = panelVocV;
    }
    if (panelVmpV != null) {
      $result.panelVmpV = panelVmpV;
    }
    if (panelIscA != null) {
      $result.panelIscA = panelIscA;
    }
    if (panelImpA != null) {
      $result.panelImpA = panelImpA;
    }
    if (panelsPerString != null) {
      $result.panelsPerString = panelsPerString;
    }
    if (inverterVdcMaxV != null) {
      $result.inverterVdcMaxV = inverterVdcMaxV;
    }
    if (inverterVmpptMinV != null) {
      $result.inverterVmpptMinV = inverterVmpptMinV;
    }
    if (inverterVmpptMaxV != null) {
      $result.inverterVmpptMaxV = inverterVmpptMaxV;
    }
    if (inverterIdcMaxA != null) {
      $result.inverterIdcMaxA = inverterIdcMaxA;
    }
    if (inverterAcKw != null) {
      $result.inverterAcKw = inverterAcKw;
    }
    if (dcAcRatioMin != null) {
      $result.dcAcRatioMin = dcAcRatioMin;
    }
    if (dcAcRatioMax != null) {
      $result.dcAcRatioMax = dcAcRatioMax;
    }
    if (tempCoeffVocPctPerC != null) {
      $result.tempCoeffVocPctPerC = tempCoeffVocPctPerC;
    }
    if (lowestExpectedTempC != null) {
      $result.lowestExpectedTempC = lowestExpectedTempC;
    }
    if (highestExpectedTempC != null) {
      $result.highestExpectedTempC = highestExpectedTempC;
    }
    return $result;
  }
  ValidateSizingRequest._() : super();
  factory ValidateSizingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateSizingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateSizingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'panelVocV', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'panelVmpV', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'panelIscA', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'panelImpA', $pb.PbFieldType.OD)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'panelsPerString', $pb.PbFieldType.O3)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'inverterVdcMaxV', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'inverterVmpptMinV', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'inverterVmpptMaxV', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'inverterIdcMaxA', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'inverterAcKw', $pb.PbFieldType.OD)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'dcAcRatioMin', $pb.PbFieldType.OD)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'dcAcRatioMax', $pb.PbFieldType.OD)
    ..a<$core.double>(14, _omitFieldNames ? '' : 'tempCoeffVocPctPerC', $pb.PbFieldType.OD)
    ..a<$core.double>(15, _omitFieldNames ? '' : 'lowestExpectedTempC', $pb.PbFieldType.OD)
    ..a<$core.double>(16, _omitFieldNames ? '' : 'highestExpectedTempC', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateSizingRequest clone() => ValidateSizingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateSizingRequest copyWith(void Function(ValidateSizingRequest) updates) => super.copyWith((message) => updates(message as ValidateSizingRequest)) as ValidateSizingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateSizingRequest create() => ValidateSizingRequest._();
  ValidateSizingRequest createEmptyInstance() => create();
  static $pb.PbList<ValidateSizingRequest> createRepeated() => $pb.PbList<ValidateSizingRequest>();
  @$core.pragma('dart2js:noInline')
  static ValidateSizingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateSizingRequest>(create);
  static ValidateSizingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);

  /// Panel electrical characteristics
  @$pb.TagNumber(2)
  $core.double get panelVocV => $_getN(1);
  @$pb.TagNumber(2)
  set panelVocV($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPanelVocV() => $_has(1);
  @$pb.TagNumber(2)
  void clearPanelVocV() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get panelVmpV => $_getN(2);
  @$pb.TagNumber(3)
  set panelVmpV($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPanelVmpV() => $_has(2);
  @$pb.TagNumber(3)
  void clearPanelVmpV() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get panelIscA => $_getN(3);
  @$pb.TagNumber(4)
  set panelIscA($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPanelIscA() => $_has(3);
  @$pb.TagNumber(4)
  void clearPanelIscA() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get panelImpA => $_getN(4);
  @$pb.TagNumber(5)
  set panelImpA($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPanelImpA() => $_has(4);
  @$pb.TagNumber(5)
  void clearPanelImpA() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get panelsPerString => $_getIZ(5);
  @$pb.TagNumber(6)
  set panelsPerString($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPanelsPerString() => $_has(5);
  @$pb.TagNumber(6)
  void clearPanelsPerString() => $_clearField(6);

  /// Inverter input limits (from datasheet)
  @$pb.TagNumber(7)
  $core.double get inverterVdcMaxV => $_getN(6);
  @$pb.TagNumber(7)
  set inverterVdcMaxV($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasInverterVdcMaxV() => $_has(6);
  @$pb.TagNumber(7)
  void clearInverterVdcMaxV() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get inverterVmpptMinV => $_getN(7);
  @$pb.TagNumber(8)
  set inverterVmpptMinV($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasInverterVmpptMinV() => $_has(7);
  @$pb.TagNumber(8)
  void clearInverterVmpptMinV() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get inverterVmpptMaxV => $_getN(8);
  @$pb.TagNumber(9)
  set inverterVmpptMaxV($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasInverterVmpptMaxV() => $_has(8);
  @$pb.TagNumber(9)
  void clearInverterVmpptMaxV() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get inverterIdcMaxA => $_getN(9);
  @$pb.TagNumber(10)
  set inverterIdcMaxA($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasInverterIdcMaxA() => $_has(9);
  @$pb.TagNumber(10)
  void clearInverterIdcMaxA() => $_clearField(10);

  /// AC output
  @$pb.TagNumber(11)
  $core.double get inverterAcKw => $_getN(10);
  @$pb.TagNumber(11)
  set inverterAcKw($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasInverterAcKw() => $_has(10);
  @$pb.TagNumber(11)
  void clearInverterAcKw() => $_clearField(11);

  /// Target sizing range
  @$pb.TagNumber(12)
  $core.double get dcAcRatioMin => $_getN(11);
  @$pb.TagNumber(12)
  set dcAcRatioMin($core.double v) { $_setDouble(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasDcAcRatioMin() => $_has(11);
  @$pb.TagNumber(12)
  void clearDcAcRatioMin() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get dcAcRatioMax => $_getN(12);
  @$pb.TagNumber(13)
  set dcAcRatioMax($core.double v) { $_setDouble(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasDcAcRatioMax() => $_has(12);
  @$pb.TagNumber(13)
  void clearDcAcRatioMax() => $_clearField(13);

  /// Temperature correction factors (IEC 62548)
  @$pb.TagNumber(14)
  $core.double get tempCoeffVocPctPerC => $_getN(13);
  @$pb.TagNumber(14)
  set tempCoeffVocPctPerC($core.double v) { $_setDouble(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasTempCoeffVocPctPerC() => $_has(13);
  @$pb.TagNumber(14)
  void clearTempCoeffVocPctPerC() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.double get lowestExpectedTempC => $_getN(14);
  @$pb.TagNumber(15)
  set lowestExpectedTempC($core.double v) { $_setDouble(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasLowestExpectedTempC() => $_has(14);
  @$pb.TagNumber(15)
  void clearLowestExpectedTempC() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.double get highestExpectedTempC => $_getN(15);
  @$pb.TagNumber(16)
  set highestExpectedTempC($core.double v) { $_setDouble(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasHighestExpectedTempC() => $_has(15);
  @$pb.TagNumber(16)
  void clearHighestExpectedTempC() => $_clearField(16);
}

class SizingViolation extends $pb.GeneratedMessage {
  factory SizingViolation({
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
  SizingViolation._() : super();
  factory SizingViolation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SizingViolation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SizingViolation', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
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
  SizingViolation clone() => SizingViolation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SizingViolation copyWith(void Function(SizingViolation) updates) => super.copyWith((message) => updates(message as SizingViolation)) as SizingViolation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SizingViolation create() => SizingViolation._();
  SizingViolation createEmptyInstance() => create();
  static $pb.PbList<SizingViolation> createRepeated() => $pb.PbList<SizingViolation>();
  @$core.pragma('dart2js:noInline')
  static SizingViolation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SizingViolation>(create);
  static SizingViolation? _defaultInstance;

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

class ValidateSizingResponse extends $pb.GeneratedMessage {
  factory ValidateSizingResponse({
    $core.bool? valid,
    $core.Iterable<SizingViolation>? violations,
    $core.double? stringVocColdV,
    $core.double? stringVmpHotV,
    $core.double? dcStringPowerKw,
    $core.double? dcAcRatio,
    $core.int? maxPanelsPerString,
    $core.int? minPanelsPerString,
  }) {
    final $result = create();
    if (valid != null) {
      $result.valid = valid;
    }
    if (violations != null) {
      $result.violations.addAll(violations);
    }
    if (stringVocColdV != null) {
      $result.stringVocColdV = stringVocColdV;
    }
    if (stringVmpHotV != null) {
      $result.stringVmpHotV = stringVmpHotV;
    }
    if (dcStringPowerKw != null) {
      $result.dcStringPowerKw = dcStringPowerKw;
    }
    if (dcAcRatio != null) {
      $result.dcAcRatio = dcAcRatio;
    }
    if (maxPanelsPerString != null) {
      $result.maxPanelsPerString = maxPanelsPerString;
    }
    if (minPanelsPerString != null) {
      $result.minPanelsPerString = minPanelsPerString;
    }
    return $result;
  }
  ValidateSizingResponse._() : super();
  factory ValidateSizingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateSizingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateSizingResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'valid')
    ..pc<SizingViolation>(2, _omitFieldNames ? '' : 'violations', $pb.PbFieldType.PM, subBuilder: SizingViolation.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'stringVocColdV', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'stringVmpHotV', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'dcStringPowerKw', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'dcAcRatio', $pb.PbFieldType.OD)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'maxPanelsPerString', $pb.PbFieldType.O3)
    ..a<$core.int>(8, _omitFieldNames ? '' : 'minPanelsPerString', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateSizingResponse clone() => ValidateSizingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateSizingResponse copyWith(void Function(ValidateSizingResponse) updates) => super.copyWith((message) => updates(message as ValidateSizingResponse)) as ValidateSizingResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateSizingResponse create() => ValidateSizingResponse._();
  ValidateSizingResponse createEmptyInstance() => create();
  static $pb.PbList<ValidateSizingResponse> createRepeated() => $pb.PbList<ValidateSizingResponse>();
  @$core.pragma('dart2js:noInline')
  static ValidateSizingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateSizingResponse>(create);
  static ValidateSizingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get valid => $_getBF(0);
  @$pb.TagNumber(1)
  set valid($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearValid() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<SizingViolation> get violations => $_getList(1);

  @$pb.TagNumber(3)
  $core.double get stringVocColdV => $_getN(2);
  @$pb.TagNumber(3)
  set stringVocColdV($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStringVocColdV() => $_has(2);
  @$pb.TagNumber(3)
  void clearStringVocColdV() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get stringVmpHotV => $_getN(3);
  @$pb.TagNumber(4)
  set stringVmpHotV($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStringVmpHotV() => $_has(3);
  @$pb.TagNumber(4)
  void clearStringVmpHotV() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get dcStringPowerKw => $_getN(4);
  @$pb.TagNumber(5)
  set dcStringPowerKw($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDcStringPowerKw() => $_has(4);
  @$pb.TagNumber(5)
  void clearDcStringPowerKw() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get dcAcRatio => $_getN(5);
  @$pb.TagNumber(6)
  set dcAcRatio($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDcAcRatio() => $_has(5);
  @$pb.TagNumber(6)
  void clearDcAcRatio() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get maxPanelsPerString => $_getIZ(6);
  @$pb.TagNumber(7)
  set maxPanelsPerString($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMaxPanelsPerString() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxPanelsPerString() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get minPanelsPerString => $_getIZ(7);
  @$pb.TagNumber(8)
  set minPanelsPerString($core.int v) { $_setSignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMinPanelsPerString() => $_has(7);
  @$pb.TagNumber(8)
  void clearMinPanelsPerString() => $_clearField(8);
}

/// ValidateNetwork checks full network topology consistency.
class ValidateNetworkRequest extends $pb.GeneratedMessage {
  factory ValidateNetworkRequest({
    $core.String? networkId,
    $core.int? inverterMpptCount,
    $core.int? maxStringsPerMppt,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    if (inverterMpptCount != null) {
      $result.inverterMpptCount = inverterMpptCount;
    }
    if (maxStringsPerMppt != null) {
      $result.maxStringsPerMppt = maxStringsPerMppt;
    }
    return $result;
  }
  ValidateNetworkRequest._() : super();
  factory ValidateNetworkRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateNetworkRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateNetworkRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'inverterMpptCount', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'maxStringsPerMppt', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateNetworkRequest clone() => ValidateNetworkRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateNetworkRequest copyWith(void Function(ValidateNetworkRequest) updates) => super.copyWith((message) => updates(message as ValidateNetworkRequest)) as ValidateNetworkRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateNetworkRequest create() => ValidateNetworkRequest._();
  ValidateNetworkRequest createEmptyInstance() => create();
  static $pb.PbList<ValidateNetworkRequest> createRepeated() => $pb.PbList<ValidateNetworkRequest>();
  @$core.pragma('dart2js:noInline')
  static ValidateNetworkRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateNetworkRequest>(create);
  static ValidateNetworkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);

  /// Optional inverter MPPT count limit for over-subscription checking.
  @$pb.TagNumber(2)
  $core.int get inverterMpptCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set inverterMpptCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInverterMpptCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearInverterMpptCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get maxStringsPerMppt => $_getIZ(2);
  @$pb.TagNumber(3)
  set maxStringsPerMppt($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxStringsPerMppt() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxStringsPerMppt() => $_clearField(3);
}

class NetworkTopologyIssue extends $pb.GeneratedMessage {
  factory NetworkTopologyIssue({
    $core.String? code,
    $core.String? message,
    $core.String? entityId,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    if (message != null) {
      $result.message = message;
    }
    if (entityId != null) {
      $result.entityId = entityId;
    }
    return $result;
  }
  NetworkTopologyIssue._() : super();
  factory NetworkTopologyIssue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NetworkTopologyIssue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NetworkTopologyIssue', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'code')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'entityId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NetworkTopologyIssue clone() => NetworkTopologyIssue()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NetworkTopologyIssue copyWith(void Function(NetworkTopologyIssue) updates) => super.copyWith((message) => updates(message as NetworkTopologyIssue)) as NetworkTopologyIssue;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NetworkTopologyIssue create() => NetworkTopologyIssue._();
  NetworkTopologyIssue createEmptyInstance() => create();
  static $pb.PbList<NetworkTopologyIssue> createRepeated() => $pb.PbList<NetworkTopologyIssue>();
  @$core.pragma('dart2js:noInline')
  static NetworkTopologyIssue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NetworkTopologyIssue>(create);
  static NetworkTopologyIssue? _defaultInstance;

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
  $core.String get entityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set entityId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEntityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntityId() => $_clearField(3);
}

class ValidateNetworkResponse extends $pb.GeneratedMessage {
  factory ValidateNetworkResponse({
    $core.bool? valid,
    $core.Iterable<NetworkTopologyIssue>? issues,
    $core.int? totalStrings,
    $core.int? assignedStrings,
    $core.int? unassignedStrings,
    $core.int? totalPanels,
    $core.int? duplicatePanelRefs,
    $core.double? totalDcKw,
    $core.double? totalAcKw,
    $core.double? dcAcRatio,
  }) {
    final $result = create();
    if (valid != null) {
      $result.valid = valid;
    }
    if (issues != null) {
      $result.issues.addAll(issues);
    }
    if (totalStrings != null) {
      $result.totalStrings = totalStrings;
    }
    if (assignedStrings != null) {
      $result.assignedStrings = assignedStrings;
    }
    if (unassignedStrings != null) {
      $result.unassignedStrings = unassignedStrings;
    }
    if (totalPanels != null) {
      $result.totalPanels = totalPanels;
    }
    if (duplicatePanelRefs != null) {
      $result.duplicatePanelRefs = duplicatePanelRefs;
    }
    if (totalDcKw != null) {
      $result.totalDcKw = totalDcKw;
    }
    if (totalAcKw != null) {
      $result.totalAcKw = totalAcKw;
    }
    if (dcAcRatio != null) {
      $result.dcAcRatio = dcAcRatio;
    }
    return $result;
  }
  ValidateNetworkResponse._() : super();
  factory ValidateNetworkResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateNetworkResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateNetworkResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'valid')
    ..pc<NetworkTopologyIssue>(2, _omitFieldNames ? '' : 'issues', $pb.PbFieldType.PM, subBuilder: NetworkTopologyIssue.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalStrings', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'assignedStrings', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'unassignedStrings', $pb.PbFieldType.O3)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'totalPanels', $pb.PbFieldType.O3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'duplicatePanelRefs', $pb.PbFieldType.O3)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'totalDcKw', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'totalAcKw', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'dcAcRatio', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateNetworkResponse clone() => ValidateNetworkResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateNetworkResponse copyWith(void Function(ValidateNetworkResponse) updates) => super.copyWith((message) => updates(message as ValidateNetworkResponse)) as ValidateNetworkResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateNetworkResponse create() => ValidateNetworkResponse._();
  ValidateNetworkResponse createEmptyInstance() => create();
  static $pb.PbList<ValidateNetworkResponse> createRepeated() => $pb.PbList<ValidateNetworkResponse>();
  @$core.pragma('dart2js:noInline')
  static ValidateNetworkResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateNetworkResponse>(create);
  static ValidateNetworkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get valid => $_getBF(0);
  @$pb.TagNumber(1)
  set valid($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearValid() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<NetworkTopologyIssue> get issues => $_getList(1);

  @$pb.TagNumber(3)
  $core.int get totalStrings => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalStrings($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalStrings() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalStrings() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get assignedStrings => $_getIZ(3);
  @$pb.TagNumber(4)
  set assignedStrings($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAssignedStrings() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssignedStrings() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get unassignedStrings => $_getIZ(4);
  @$pb.TagNumber(5)
  set unassignedStrings($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUnassignedStrings() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnassignedStrings() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get totalPanels => $_getIZ(5);
  @$pb.TagNumber(6)
  set totalPanels($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTotalPanels() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalPanels() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get duplicatePanelRefs => $_getIZ(6);
  @$pb.TagNumber(7)
  set duplicatePanelRefs($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDuplicatePanelRefs() => $_has(6);
  @$pb.TagNumber(7)
  void clearDuplicatePanelRefs() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get totalDcKw => $_getN(7);
  @$pb.TagNumber(8)
  set totalDcKw($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTotalDcKw() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalDcKw() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get totalAcKw => $_getN(8);
  @$pb.TagNumber(9)
  set totalAcKw($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTotalAcKw() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotalAcKw() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get dcAcRatio => $_getN(9);
  @$pb.TagNumber(10)
  set dcAcRatio($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasDcAcRatio() => $_has(9);
  @$pb.TagNumber(10)
  void clearDcAcRatio() => $_clearField(10);
}

/// GenerateNetworkBOM derives bill-of-materials item counts from live network topology.
class GenerateNetworkBOMRequest extends $pb.GeneratedMessage {
  factory GenerateNetworkBOMRequest({
    $core.String? networkId,
    $core.double? panelUnitCost,
    $core.double? inverterUnitCost,
    $core.double? cableCostPerM,
    $core.double? mountingCostPerPanel,
    $core.String? currencyCode,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    if (panelUnitCost != null) {
      $result.panelUnitCost = panelUnitCost;
    }
    if (inverterUnitCost != null) {
      $result.inverterUnitCost = inverterUnitCost;
    }
    if (cableCostPerM != null) {
      $result.cableCostPerM = cableCostPerM;
    }
    if (mountingCostPerPanel != null) {
      $result.mountingCostPerPanel = mountingCostPerPanel;
    }
    if (currencyCode != null) {
      $result.currencyCode = currencyCode;
    }
    return $result;
  }
  GenerateNetworkBOMRequest._() : super();
  factory GenerateNetworkBOMRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateNetworkBOMRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateNetworkBOMRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'panelUnitCost', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'inverterUnitCost', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'cableCostPerM', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'mountingCostPerPanel', $pb.PbFieldType.OD)
    ..aOS(6, _omitFieldNames ? '' : 'currencyCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateNetworkBOMRequest clone() => GenerateNetworkBOMRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateNetworkBOMRequest copyWith(void Function(GenerateNetworkBOMRequest) updates) => super.copyWith((message) => updates(message as GenerateNetworkBOMRequest)) as GenerateNetworkBOMRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateNetworkBOMRequest create() => GenerateNetworkBOMRequest._();
  GenerateNetworkBOMRequest createEmptyInstance() => create();
  static $pb.PbList<GenerateNetworkBOMRequest> createRepeated() => $pb.PbList<GenerateNetworkBOMRequest>();
  @$core.pragma('dart2js:noInline')
  static GenerateNetworkBOMRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateNetworkBOMRequest>(create);
  static GenerateNetworkBOMRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);

  /// Optional cost parameters; zero values omit cost columns.
  @$pb.TagNumber(2)
  $core.double get panelUnitCost => $_getN(1);
  @$pb.TagNumber(2)
  set panelUnitCost($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPanelUnitCost() => $_has(1);
  @$pb.TagNumber(2)
  void clearPanelUnitCost() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get inverterUnitCost => $_getN(2);
  @$pb.TagNumber(3)
  set inverterUnitCost($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasInverterUnitCost() => $_has(2);
  @$pb.TagNumber(3)
  void clearInverterUnitCost() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get cableCostPerM => $_getN(3);
  @$pb.TagNumber(4)
  set cableCostPerM($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCableCostPerM() => $_has(3);
  @$pb.TagNumber(4)
  void clearCableCostPerM() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get mountingCostPerPanel => $_getN(4);
  @$pb.TagNumber(5)
  set mountingCostPerPanel($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMountingCostPerPanel() => $_has(4);
  @$pb.TagNumber(5)
  void clearMountingCostPerPanel() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get currencyCode => $_getSZ(5);
  @$pb.TagNumber(6)
  set currencyCode($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCurrencyCode() => $_has(5);
  @$pb.TagNumber(6)
  void clearCurrencyCode() => $_clearField(6);
}

class NetworkBOMItem extends $pb.GeneratedMessage {
  factory NetworkBOMItem({
    $core.String? category,
    $core.String? name,
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
  NetworkBOMItem._() : super();
  factory NetworkBOMItem.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NetworkBOMItem.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NetworkBOMItem', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'category')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'quantity', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'unit')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'unitCost', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'totalCost', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NetworkBOMItem clone() => NetworkBOMItem()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NetworkBOMItem copyWith(void Function(NetworkBOMItem) updates) => super.copyWith((message) => updates(message as NetworkBOMItem)) as NetworkBOMItem;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NetworkBOMItem create() => NetworkBOMItem._();
  NetworkBOMItem createEmptyInstance() => create();
  static $pb.PbList<NetworkBOMItem> createRepeated() => $pb.PbList<NetworkBOMItem>();
  @$core.pragma('dart2js:noInline')
  static NetworkBOMItem getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NetworkBOMItem>(create);
  static NetworkBOMItem? _defaultInstance;

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
  $core.int get quantity => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantity($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasQuantity() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantity() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get unit => $_getSZ(3);
  @$pb.TagNumber(4)
  set unit($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUnit() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get unitCost => $_getN(4);
  @$pb.TagNumber(5)
  set unitCost($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasUnitCost() => $_has(4);
  @$pb.TagNumber(5)
  void clearUnitCost() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalCost => $_getN(5);
  @$pb.TagNumber(6)
  set totalCost($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTotalCost() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalCost() => $_clearField(6);
}

class GenerateNetworkBOMResponse extends $pb.GeneratedMessage {
  factory GenerateNetworkBOMResponse({
    $core.String? networkId,
    $core.int? panelCount,
    $core.int? stringCount,
    $core.int? inverterGroupCount,
    $core.double? totalDcKw,
    $core.double? totalAcKw,
    $core.Iterable<NetworkBOMItem>? items,
    $core.double? totalCost,
    $core.String? currencyCode,
  }) {
    final $result = create();
    if (networkId != null) {
      $result.networkId = networkId;
    }
    if (panelCount != null) {
      $result.panelCount = panelCount;
    }
    if (stringCount != null) {
      $result.stringCount = stringCount;
    }
    if (inverterGroupCount != null) {
      $result.inverterGroupCount = inverterGroupCount;
    }
    if (totalDcKw != null) {
      $result.totalDcKw = totalDcKw;
    }
    if (totalAcKw != null) {
      $result.totalAcKw = totalAcKw;
    }
    if (items != null) {
      $result.items.addAll(items);
    }
    if (totalCost != null) {
      $result.totalCost = totalCost;
    }
    if (currencyCode != null) {
      $result.currencyCode = currencyCode;
    }
    return $result;
  }
  GenerateNetworkBOMResponse._() : super();
  factory GenerateNetworkBOMResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateNetworkBOMResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateNetworkBOMResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'electrical.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'networkId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'panelCount', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'stringCount', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'inverterGroupCount', $pb.PbFieldType.O3)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'totalDcKw', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'totalAcKw', $pb.PbFieldType.OD)
    ..pc<NetworkBOMItem>(7, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM, subBuilder: NetworkBOMItem.create)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'totalCost', $pb.PbFieldType.OD)
    ..aOS(9, _omitFieldNames ? '' : 'currencyCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateNetworkBOMResponse clone() => GenerateNetworkBOMResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateNetworkBOMResponse copyWith(void Function(GenerateNetworkBOMResponse) updates) => super.copyWith((message) => updates(message as GenerateNetworkBOMResponse)) as GenerateNetworkBOMResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateNetworkBOMResponse create() => GenerateNetworkBOMResponse._();
  GenerateNetworkBOMResponse createEmptyInstance() => create();
  static $pb.PbList<GenerateNetworkBOMResponse> createRepeated() => $pb.PbList<GenerateNetworkBOMResponse>();
  @$core.pragma('dart2js:noInline')
  static GenerateNetworkBOMResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateNetworkBOMResponse>(create);
  static GenerateNetworkBOMResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get networkId => $_getSZ(0);
  @$pb.TagNumber(1)
  set networkId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNetworkId() => $_has(0);
  @$pb.TagNumber(1)
  void clearNetworkId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get panelCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set panelCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPanelCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearPanelCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get stringCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set stringCount($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStringCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearStringCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get inverterGroupCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set inverterGroupCount($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasInverterGroupCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearInverterGroupCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalDcKw => $_getN(4);
  @$pb.TagNumber(5)
  set totalDcKw($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalDcKw() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalDcKw() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get totalAcKw => $_getN(5);
  @$pb.TagNumber(6)
  set totalAcKw($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTotalAcKw() => $_has(5);
  @$pb.TagNumber(6)
  void clearTotalAcKw() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<NetworkBOMItem> get items => $_getList(6);

  @$pb.TagNumber(8)
  $core.double get totalCost => $_getN(7);
  @$pb.TagNumber(8)
  set totalCost($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTotalCost() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalCost() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get currencyCode => $_getSZ(8);
  @$pb.TagNumber(9)
  set currencyCode($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCurrencyCode() => $_has(8);
  @$pb.TagNumber(9)
  void clearCurrencyCode() => $_clearField(9);
}

/// ElectricalService manages electrical network topology for solar farm layouts,
/// including string configuration, inverter assignment, capacity calculations,
/// network topology validation, BOM derivation, and the acceptance workflow gate
/// required for ElectricalReady -> TransmissionReady phase progression.
class ElectricalServiceApi {
  $pb.RpcClient _client;
  ElectricalServiceApi(this._client);

  /// CreateNetwork creates a new electrical network for a project layout.
  $async.Future<CreateNetworkResponse> createNetwork($pb.ClientContext? ctx, CreateNetworkRequest request) =>
    _client.invoke<CreateNetworkResponse>(ctx, 'ElectricalService', 'CreateNetwork', request, CreateNetworkResponse())
  ;
  /// GetNetwork retrieves an electrical network by ID including review metadata.
  $async.Future<GetNetworkResponse> getNetwork($pb.ClientContext? ctx, GetNetworkRequest request) =>
    _client.invoke<GetNetworkResponse>(ctx, 'ElectricalService', 'GetNetwork', request, GetNetworkResponse())
  ;
  /// ListNetworks returns all electrical networks for a project.
  $async.Future<ListNetworksResponse> listNetworks($pb.ClientContext? ctx, ListNetworksRequest request) =>
    _client.invoke<ListNetworksResponse>(ctx, 'ElectricalService', 'ListNetworks', request, ListNetworksResponse())
  ;
  /// DeleteNetwork permanently removes an electrical network and all its strings.
  $async.Future<DeleteNetworkResponse> deleteNetwork($pb.ClientContext? ctx, DeleteNetworkRequest request) =>
    _client.invoke<DeleteNetworkResponse>(ctx, 'ElectricalService', 'DeleteNetwork', request, DeleteNetworkResponse())
  ;
  /// String operations
  $async.Future<CreateStringResponse> createString($pb.ClientContext? ctx, CreateStringRequest request) =>
    _client.invoke<CreateStringResponse>(ctx, 'ElectricalService', 'CreateString', request, CreateStringResponse())
  ;
  /// AutoGenerateStrings generates panel strings automatically based on inverter groups.
  $async.Future<AutoGenerateStringsResponse> autoGenerateStrings($pb.ClientContext? ctx, AutoGenerateStringsRequest request) =>
    _client.invoke<AutoGenerateStringsResponse>(ctx, 'ElectricalService', 'AutoGenerateStrings', request, AutoGenerateStringsResponse())
  ;
  /// ListStrings returns all strings for a network.
  $async.Future<ListStringsResponse> listStrings($pb.ClientContext? ctx, ListStringsRequest request) =>
    _client.invoke<ListStringsResponse>(ctx, 'ElectricalService', 'ListStrings', request, ListStringsResponse())
  ;
  /// Inverter operations
  $async.Future<AssignInverterResponse> assignInverter($pb.ClientContext? ctx, AssignInverterRequest request) =>
    _client.invoke<AssignInverterResponse>(ctx, 'ElectricalService', 'AssignInverter', request, AssignInverterResponse())
  ;
  /// ListInverterGroups returns all inverter groups and their assigned strings.
  $async.Future<ListInverterGroupsResponse> listInverterGroups($pb.ClientContext? ctx, ListInverterGroupsRequest request) =>
    _client.invoke<ListInverterGroupsResponse>(ctx, 'ElectricalService', 'ListInverterGroups', request, ListInverterGroupsResponse())
  ;
  /// Calculations
  $async.Future<CalculateDCCapacityResponse> calculateDCCapacity($pb.ClientContext? ctx, CalculateDCCapacityRequest request) =>
    _client.invoke<CalculateDCCapacityResponse>(ctx, 'ElectricalService', 'CalculateDCCapacity', request, CalculateDCCapacityResponse())
  ;
  /// CalculateACCapacity computes total AC output capacity for the network.
  $async.Future<CalculateACCapacityResponse> calculateACCapacity($pb.ClientContext? ctx, CalculateACCapacityRequest request) =>
    _client.invoke<CalculateACCapacityResponse>(ctx, 'ElectricalService', 'CalculateACCapacity', request, CalculateACCapacityResponse())
  ;
  /// CalculateLosses computes cable, mismatch, and system losses for the network.
  $async.Future<CalculateLossesResponse> calculateLosses($pb.ClientContext? ctx, CalculateLossesRequest request) =>
    _client.invoke<CalculateLossesResponse>(ctx, 'ElectricalService', 'CalculateLosses', request, CalculateLossesResponse())
  ;
  /// ValidateSizing performs parametric sizing validation against design constraints.
  $async.Future<ValidateSizingResponse> validateSizing($pb.ClientContext? ctx, ValidateSizingRequest request) =>
    _client.invoke<ValidateSizingResponse>(ctx, 'ElectricalService', 'ValidateSizing', request, ValidateSizingResponse())
  ;
  /// ValidateNetwork performs full topology validation: all strings assigned, no orphans, MPPT limits.
  $async.Future<ValidateNetworkResponse> validateNetwork($pb.ClientContext? ctx, ValidateNetworkRequest request) =>
    _client.invoke<ValidateNetworkResponse>(ctx, 'ElectricalService', 'ValidateNetwork', request, ValidateNetworkResponse())
  ;
  /// GenerateNetworkBOM derives BOM item counts directly from the live network topology.
  $async.Future<GenerateNetworkBOMResponse> generateNetworkBOM($pb.ClientContext? ctx, GenerateNetworkBOMRequest request) =>
    _client.invoke<GenerateNetworkBOMResponse>(ctx, 'ElectricalService', 'GenerateNetworkBOM', request, GenerateNetworkBOMResponse())
  ;
  /// Acceptance workflow — gates the ElectricalReady -> TransmissionReady phase transition.
  /// SubmitNetworkForReview transitions review_metadata.status to REVIEW_PENDING.
  $async.Future<SubmitNetworkForReviewResponse> submitNetworkForReview($pb.ClientContext? ctx, SubmitNetworkForReviewRequest request) =>
    _client.invoke<SubmitNetworkForReviewResponse>(ctx, 'ElectricalService', 'SubmitNetworkForReview', request, SubmitNetworkForReviewResponse())
  ;
  /// ApproveNetwork sets review_metadata.status to APPROVED, enabling TransmissionReady transition.
  $async.Future<ApproveNetworkResponse> approveNetwork($pb.ClientContext? ctx, ApproveNetworkRequest request) =>
    _client.invoke<ApproveNetworkResponse>(ctx, 'ElectricalService', 'ApproveNetwork', request, ApproveNetworkResponse())
  ;
  /// RejectNetwork sets review_metadata.status to REJECTED and records blocker reasons.
  $async.Future<RejectNetworkResponse> rejectNetwork($pb.ClientContext? ctx, RejectNetworkRequest request) =>
    _client.invoke<RejectNetworkResponse>(ctx, 'ElectricalService', 'RejectNetwork', request, RejectNetworkResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
