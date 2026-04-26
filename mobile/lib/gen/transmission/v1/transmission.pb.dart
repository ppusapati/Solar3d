//
//  Generated code. Do not modify.
//  source: transmission/v1/transmission.proto
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
import '../../packages/pagination.pb.dart' as $1;
import 'transmission.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'transmission.pbenum.dart';

/// ========== Review Metadata ==========
/// ReviewMetadata captures acceptance workflow state attached to a route artefact.
/// Populated by the acceptance RPCs below; consumed by PlanningWorkflow gate checks.
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReviewMetadata', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
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

  /// reviewed_by_actor_id is the user or system actor that performed the review.
  @$pb.TagNumber(2)
  $core.String get reviewedByActorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set reviewedByActorId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReviewedByActorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearReviewedByActorId() => $_clearField(2);

  /// reviewed_at is when the most recent review action occurred.
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

  /// quality_score is an overall quality rating [0, 1] assigned by the reviewer.
  @$pb.TagNumber(4)
  $core.double get qualityScore => $_getN(3);
  @$pb.TagNumber(4)
  set qualityScore($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasQualityScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearQualityScore() => $_clearField(4);

  /// review_comments are free-text comments attached by the reviewer.
  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get reviewComments => $_getList(4);

  /// blockers lists unresolved reasons that prevented approval. Empty when approved.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get blockers => $_getList(5);

  /// approval_timestamp_unix_secs records the ISO-8601 approval time as a string for audit.
  @$pb.TagNumber(7)
  $core.String get approvalTimestampUnixSecs => $_getSZ(6);
  @$pb.TagNumber(7)
  set approvalTimestampUnixSecs($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasApprovalTimestampUnixSecs() => $_has(6);
  @$pb.TagNumber(7)
  void clearApprovalTimestampUnixSecs() => $_clearField(7);
}

class Waypoint extends $pb.GeneratedMessage {
  factory Waypoint({
    $core.double? longitude,
    $core.double? latitude,
    $core.double? elevation,
  }) {
    final $result = create();
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (elevation != null) {
      $result.elevation = elevation;
    }
    return $result;
  }
  Waypoint._() : super();
  factory Waypoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Waypoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Waypoint', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'elevation', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Waypoint clone() => Waypoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Waypoint copyWith(void Function(Waypoint) updates) => super.copyWith((message) => updates(message as Waypoint)) as Waypoint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Waypoint create() => Waypoint._();
  Waypoint createEmptyInstance() => create();
  static $pb.PbList<Waypoint> createRepeated() => $pb.PbList<Waypoint>();
  @$core.pragma('dart2js:noInline')
  static Waypoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Waypoint>(create);
  static Waypoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get longitude => $_getN(0);
  @$pb.TagNumber(1)
  set longitude($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLongitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLongitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get latitude => $_getN(1);
  @$pb.TagNumber(2)
  set latitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLatitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get elevation => $_getN(2);
  @$pb.TagNumber(3)
  set elevation($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasElevation() => $_has(2);
  @$pb.TagNumber(3)
  void clearElevation() => $_clearField(3);
}

class TransmissionConstraints extends $pb.GeneratedMessage {
  factory TransmissionConstraints({
    $core.double? minSpanM,
    $core.double? maxSpanM,
    $core.double? rowWidthM,
    $core.double? maxSlopeDeg,
    $core.double? slopePenaltyFactor,
    $core.double? waterCrossingCostMult,
    $core.double? roadParallelDiscount,
    $core.double? maxDeflectionDeg,
    $core.double? turnPenaltyFactor,
    $core.double? offRoadPenalty,
    $core.double? roadBufferM,
  }) {
    final $result = create();
    if (minSpanM != null) {
      $result.minSpanM = minSpanM;
    }
    if (maxSpanM != null) {
      $result.maxSpanM = maxSpanM;
    }
    if (rowWidthM != null) {
      $result.rowWidthM = rowWidthM;
    }
    if (maxSlopeDeg != null) {
      $result.maxSlopeDeg = maxSlopeDeg;
    }
    if (slopePenaltyFactor != null) {
      $result.slopePenaltyFactor = slopePenaltyFactor;
    }
    if (waterCrossingCostMult != null) {
      $result.waterCrossingCostMult = waterCrossingCostMult;
    }
    if (roadParallelDiscount != null) {
      $result.roadParallelDiscount = roadParallelDiscount;
    }
    if (maxDeflectionDeg != null) {
      $result.maxDeflectionDeg = maxDeflectionDeg;
    }
    if (turnPenaltyFactor != null) {
      $result.turnPenaltyFactor = turnPenaltyFactor;
    }
    if (offRoadPenalty != null) {
      $result.offRoadPenalty = offRoadPenalty;
    }
    if (roadBufferM != null) {
      $result.roadBufferM = roadBufferM;
    }
    return $result;
  }
  TransmissionConstraints._() : super();
  factory TransmissionConstraints.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransmissionConstraints.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransmissionConstraints', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'minSpanM', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'maxSpanM', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'rowWidthM', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'maxSlopeDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'slopePenaltyFactor', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'waterCrossingCostMult', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'roadParallelDiscount', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'maxDeflectionDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'turnPenaltyFactor', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'offRoadPenalty', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'roadBufferM', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransmissionConstraints clone() => TransmissionConstraints()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransmissionConstraints copyWith(void Function(TransmissionConstraints) updates) => super.copyWith((message) => updates(message as TransmissionConstraints)) as TransmissionConstraints;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransmissionConstraints create() => TransmissionConstraints._();
  TransmissionConstraints createEmptyInstance() => create();
  static $pb.PbList<TransmissionConstraints> createRepeated() => $pb.PbList<TransmissionConstraints>();
  @$core.pragma('dart2js:noInline')
  static TransmissionConstraints getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransmissionConstraints>(create);
  static TransmissionConstraints? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get minSpanM => $_getN(0);
  @$pb.TagNumber(1)
  set minSpanM($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMinSpanM() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinSpanM() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get maxSpanM => $_getN(1);
  @$pb.TagNumber(2)
  set maxSpanM($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxSpanM() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxSpanM() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get rowWidthM => $_getN(2);
  @$pb.TagNumber(3)
  set rowWidthM($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRowWidthM() => $_has(2);
  @$pb.TagNumber(3)
  void clearRowWidthM() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get maxSlopeDeg => $_getN(3);
  @$pb.TagNumber(4)
  set maxSlopeDeg($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMaxSlopeDeg() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxSlopeDeg() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get slopePenaltyFactor => $_getN(4);
  @$pb.TagNumber(5)
  set slopePenaltyFactor($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSlopePenaltyFactor() => $_has(4);
  @$pb.TagNumber(5)
  void clearSlopePenaltyFactor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get waterCrossingCostMult => $_getN(5);
  @$pb.TagNumber(6)
  set waterCrossingCostMult($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasWaterCrossingCostMult() => $_has(5);
  @$pb.TagNumber(6)
  void clearWaterCrossingCostMult() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get roadParallelDiscount => $_getN(6);
  @$pb.TagNumber(7)
  set roadParallelDiscount($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasRoadParallelDiscount() => $_has(6);
  @$pb.TagNumber(7)
  void clearRoadParallelDiscount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get maxDeflectionDeg => $_getN(7);
  @$pb.TagNumber(8)
  set maxDeflectionDeg($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMaxDeflectionDeg() => $_has(7);
  @$pb.TagNumber(8)
  void clearMaxDeflectionDeg() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get turnPenaltyFactor => $_getN(8);
  @$pb.TagNumber(9)
  set turnPenaltyFactor($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasTurnPenaltyFactor() => $_has(8);
  @$pb.TagNumber(9)
  void clearTurnPenaltyFactor() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get offRoadPenalty => $_getN(9);
  @$pb.TagNumber(10)
  set offRoadPenalty($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasOffRoadPenalty() => $_has(9);
  @$pb.TagNumber(10)
  void clearOffRoadPenalty() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get roadBufferM => $_getN(10);
  @$pb.TagNumber(11)
  set roadBufferM($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasRoadBufferM() => $_has(10);
  @$pb.TagNumber(11)
  void clearRoadBufferM() => $_clearField(11);
}

class ElevationRasterInput extends $pb.GeneratedMessage {
  factory ElevationRasterInput({
    $core.int? width,
    $core.int? height,
    $core.double? cellSizeM,
    $core.double? originLongitude,
    $core.double? originLatitude,
    $core.Iterable<$core.double>? elevations,
  }) {
    final $result = create();
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (cellSizeM != null) {
      $result.cellSizeM = cellSizeM;
    }
    if (originLongitude != null) {
      $result.originLongitude = originLongitude;
    }
    if (originLatitude != null) {
      $result.originLatitude = originLatitude;
    }
    if (elevations != null) {
      $result.elevations.addAll(elevations);
    }
    return $result;
  }
  ElevationRasterInput._() : super();
  factory ElevationRasterInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ElevationRasterInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ElevationRasterInput', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'width', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'height', $pb.PbFieldType.O3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'cellSizeM', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'originLongitude', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'originLatitude', $pb.PbFieldType.OD)
    ..p<$core.double>(6, _omitFieldNames ? '' : 'elevations', $pb.PbFieldType.KD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ElevationRasterInput clone() => ElevationRasterInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ElevationRasterInput copyWith(void Function(ElevationRasterInput) updates) => super.copyWith((message) => updates(message as ElevationRasterInput)) as ElevationRasterInput;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ElevationRasterInput create() => ElevationRasterInput._();
  ElevationRasterInput createEmptyInstance() => create();
  static $pb.PbList<ElevationRasterInput> createRepeated() => $pb.PbList<ElevationRasterInput>();
  @$core.pragma('dart2js:noInline')
  static ElevationRasterInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ElevationRasterInput>(create);
  static ElevationRasterInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get width => $_getIZ(0);
  @$pb.TagNumber(1)
  set width($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get height => $_getIZ(1);
  @$pb.TagNumber(2)
  set height($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get cellSizeM => $_getN(2);
  @$pb.TagNumber(3)
  set cellSizeM($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCellSizeM() => $_has(2);
  @$pb.TagNumber(3)
  void clearCellSizeM() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get originLongitude => $_getN(3);
  @$pb.TagNumber(4)
  set originLongitude($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOriginLongitude() => $_has(3);
  @$pb.TagNumber(4)
  void clearOriginLongitude() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get originLatitude => $_getN(4);
  @$pb.TagNumber(5)
  set originLatitude($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasOriginLatitude() => $_has(4);
  @$pb.TagNumber(5)
  void clearOriginLatitude() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.double> get elevations => $_getList(5);
}

class ObstacleRasterInput extends $pb.GeneratedMessage {
  factory ObstacleRasterInput({
    $core.int? width,
    $core.int? height,
    $core.double? cellSizeM,
    $core.double? originLongitude,
    $core.double? originLatitude,
    $core.Iterable<$core.double>? values,
  }) {
    final $result = create();
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (cellSizeM != null) {
      $result.cellSizeM = cellSizeM;
    }
    if (originLongitude != null) {
      $result.originLongitude = originLongitude;
    }
    if (originLatitude != null) {
      $result.originLatitude = originLatitude;
    }
    if (values != null) {
      $result.values.addAll(values);
    }
    return $result;
  }
  ObstacleRasterInput._() : super();
  factory ObstacleRasterInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ObstacleRasterInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ObstacleRasterInput', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'width', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'height', $pb.PbFieldType.O3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'cellSizeM', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'originLongitude', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'originLatitude', $pb.PbFieldType.OD)
    ..p<$core.double>(6, _omitFieldNames ? '' : 'values', $pb.PbFieldType.KD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ObstacleRasterInput clone() => ObstacleRasterInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ObstacleRasterInput copyWith(void Function(ObstacleRasterInput) updates) => super.copyWith((message) => updates(message as ObstacleRasterInput)) as ObstacleRasterInput;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObstacleRasterInput create() => ObstacleRasterInput._();
  ObstacleRasterInput createEmptyInstance() => create();
  static $pb.PbList<ObstacleRasterInput> createRepeated() => $pb.PbList<ObstacleRasterInput>();
  @$core.pragma('dart2js:noInline')
  static ObstacleRasterInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ObstacleRasterInput>(create);
  static ObstacleRasterInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get width => $_getIZ(0);
  @$pb.TagNumber(1)
  set width($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get height => $_getIZ(1);
  @$pb.TagNumber(2)
  set height($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get cellSizeM => $_getN(2);
  @$pb.TagNumber(3)
  set cellSizeM($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCellSizeM() => $_has(2);
  @$pb.TagNumber(3)
  void clearCellSizeM() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get originLongitude => $_getN(3);
  @$pb.TagNumber(4)
  set originLongitude($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOriginLongitude() => $_has(3);
  @$pb.TagNumber(4)
  void clearOriginLongitude() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get originLatitude => $_getN(4);
  @$pb.TagNumber(5)
  set originLatitude($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasOriginLatitude() => $_has(4);
  @$pb.TagNumber(5)
  void clearOriginLatitude() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.double> get values => $_getList(5);
}

class VectorFeatureInput extends $pb.GeneratedMessage {
  factory VectorFeatureInput({
    $core.String? featureType,
    $core.String? geometryGeojson,
    $core.double? costMultiplier,
  }) {
    final $result = create();
    if (featureType != null) {
      $result.featureType = featureType;
    }
    if (geometryGeojson != null) {
      $result.geometryGeojson = geometryGeojson;
    }
    if (costMultiplier != null) {
      $result.costMultiplier = costMultiplier;
    }
    return $result;
  }
  VectorFeatureInput._() : super();
  factory VectorFeatureInput.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VectorFeatureInput.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VectorFeatureInput', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'featureType')
    ..aOS(2, _omitFieldNames ? '' : 'geometryGeojson')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'costMultiplier', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VectorFeatureInput clone() => VectorFeatureInput()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VectorFeatureInput copyWith(void Function(VectorFeatureInput) updates) => super.copyWith((message) => updates(message as VectorFeatureInput)) as VectorFeatureInput;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VectorFeatureInput create() => VectorFeatureInput._();
  VectorFeatureInput createEmptyInstance() => create();
  static $pb.PbList<VectorFeatureInput> createRepeated() => $pb.PbList<VectorFeatureInput>();
  @$core.pragma('dart2js:noInline')
  static VectorFeatureInput getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VectorFeatureInput>(create);
  static VectorFeatureInput? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get featureType => $_getSZ(0);
  @$pb.TagNumber(1)
  set featureType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFeatureType() => $_has(0);
  @$pb.TagNumber(1)
  void clearFeatureType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get geometryGeojson => $_getSZ(1);
  @$pb.TagNumber(2)
  set geometryGeojson($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGeometryGeojson() => $_has(1);
  @$pb.TagNumber(2)
  void clearGeometryGeojson() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get costMultiplier => $_getN(2);
  @$pb.TagNumber(3)
  set costMultiplier($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCostMultiplier() => $_has(2);
  @$pb.TagNumber(3)
  void clearCostMultiplier() => $_clearField(3);
}

class TowerPosition extends $pb.GeneratedMessage {
  factory TowerPosition({
    $core.double? longitude,
    $core.double? latitude,
    $core.double? elevation,
    $core.double? spanToNextM,
    $core.double? heightM,
  }) {
    final $result = create();
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (elevation != null) {
      $result.elevation = elevation;
    }
    if (spanToNextM != null) {
      $result.spanToNextM = spanToNextM;
    }
    if (heightM != null) {
      $result.heightM = heightM;
    }
    return $result;
  }
  TowerPosition._() : super();
  factory TowerPosition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TowerPosition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TowerPosition', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'elevation', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'spanToNextM', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'heightM', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TowerPosition clone() => TowerPosition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TowerPosition copyWith(void Function(TowerPosition) updates) => super.copyWith((message) => updates(message as TowerPosition)) as TowerPosition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TowerPosition create() => TowerPosition._();
  TowerPosition createEmptyInstance() => create();
  static $pb.PbList<TowerPosition> createRepeated() => $pb.PbList<TowerPosition>();
  @$core.pragma('dart2js:noInline')
  static TowerPosition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TowerPosition>(create);
  static TowerPosition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get longitude => $_getN(0);
  @$pb.TagNumber(1)
  set longitude($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLongitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLongitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get latitude => $_getN(1);
  @$pb.TagNumber(2)
  set latitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLatitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get elevation => $_getN(2);
  @$pb.TagNumber(3)
  set elevation($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasElevation() => $_has(2);
  @$pb.TagNumber(3)
  void clearElevation() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get spanToNextM => $_getN(3);
  @$pb.TagNumber(4)
  set spanToNextM($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSpanToNextM() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpanToNextM() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get heightM => $_getN(4);
  @$pb.TagNumber(5)
  set heightM($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHeightM() => $_has(4);
  @$pb.TagNumber(5)
  void clearHeightM() => $_clearField(5);
}

class SegmentExplanation extends $pb.GeneratedMessage {
  factory SegmentExplanation({
    $core.int? fromIndex,
    $core.double? slopeDeg,
    $core.String? landType,
    $core.double? costMultiplier,
    $core.String? decisionReason,
    InstallationMode? installationMode,
  }) {
    final $result = create();
    if (fromIndex != null) {
      $result.fromIndex = fromIndex;
    }
    if (slopeDeg != null) {
      $result.slopeDeg = slopeDeg;
    }
    if (landType != null) {
      $result.landType = landType;
    }
    if (costMultiplier != null) {
      $result.costMultiplier = costMultiplier;
    }
    if (decisionReason != null) {
      $result.decisionReason = decisionReason;
    }
    if (installationMode != null) {
      $result.installationMode = installationMode;
    }
    return $result;
  }
  SegmentExplanation._() : super();
  factory SegmentExplanation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SegmentExplanation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SegmentExplanation', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'fromIndex', $pb.PbFieldType.O3)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'slopeDeg', $pb.PbFieldType.OD)
    ..aOS(3, _omitFieldNames ? '' : 'landType')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'costMultiplier', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'decisionReason')
    ..e<InstallationMode>(6, _omitFieldNames ? '' : 'installationMode', $pb.PbFieldType.OE, defaultOrMaker: InstallationMode.INSTALLATION_MODE_UNSPECIFIED, valueOf: InstallationMode.valueOf, enumValues: InstallationMode.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SegmentExplanation clone() => SegmentExplanation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SegmentExplanation copyWith(void Function(SegmentExplanation) updates) => super.copyWith((message) => updates(message as SegmentExplanation)) as SegmentExplanation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SegmentExplanation create() => SegmentExplanation._();
  SegmentExplanation createEmptyInstance() => create();
  static $pb.PbList<SegmentExplanation> createRepeated() => $pb.PbList<SegmentExplanation>();
  @$core.pragma('dart2js:noInline')
  static SegmentExplanation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SegmentExplanation>(create);
  static SegmentExplanation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get fromIndex => $_getIZ(0);
  @$pb.TagNumber(1)
  set fromIndex($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFromIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearFromIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get slopeDeg => $_getN(1);
  @$pb.TagNumber(2)
  set slopeDeg($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSlopeDeg() => $_has(1);
  @$pb.TagNumber(2)
  void clearSlopeDeg() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get landType => $_getSZ(2);
  @$pb.TagNumber(3)
  set landType($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLandType() => $_has(2);
  @$pb.TagNumber(3)
  void clearLandType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get costMultiplier => $_getN(3);
  @$pb.TagNumber(4)
  set costMultiplier($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCostMultiplier() => $_has(3);
  @$pb.TagNumber(4)
  void clearCostMultiplier() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get decisionReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set decisionReason($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDecisionReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearDecisionReason() => $_clearField(5);

  @$pb.TagNumber(6)
  InstallationMode get installationMode => $_getN(5);
  @$pb.TagNumber(6)
  set installationMode(InstallationMode v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasInstallationMode() => $_has(5);
  @$pb.TagNumber(6)
  void clearInstallationMode() => $_clearField(6);
}

class CostBreakdown extends $pb.GeneratedMessage {
  factory CostBreakdown({
    $core.double? conductorCost,
    $core.double? towerCost,
    $core.double? rowAcquisitionCost,
    $core.double? crossingPremium,
    $core.double? totalCost,
    $core.double? costPerKm,
  }) {
    final $result = create();
    if (conductorCost != null) {
      $result.conductorCost = conductorCost;
    }
    if (towerCost != null) {
      $result.towerCost = towerCost;
    }
    if (rowAcquisitionCost != null) {
      $result.rowAcquisitionCost = rowAcquisitionCost;
    }
    if (crossingPremium != null) {
      $result.crossingPremium = crossingPremium;
    }
    if (totalCost != null) {
      $result.totalCost = totalCost;
    }
    if (costPerKm != null) {
      $result.costPerKm = costPerKm;
    }
    return $result;
  }
  CostBreakdown._() : super();
  factory CostBreakdown.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CostBreakdown.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CostBreakdown', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'conductorCost', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'towerCost', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'rowAcquisitionCost', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'crossingPremium', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'totalCost', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'costPerKm', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CostBreakdown clone() => CostBreakdown()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CostBreakdown copyWith(void Function(CostBreakdown) updates) => super.copyWith((message) => updates(message as CostBreakdown)) as CostBreakdown;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CostBreakdown create() => CostBreakdown._();
  CostBreakdown createEmptyInstance() => create();
  static $pb.PbList<CostBreakdown> createRepeated() => $pb.PbList<CostBreakdown>();
  @$core.pragma('dart2js:noInline')
  static CostBreakdown getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CostBreakdown>(create);
  static CostBreakdown? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get conductorCost => $_getN(0);
  @$pb.TagNumber(1)
  set conductorCost($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasConductorCost() => $_has(0);
  @$pb.TagNumber(1)
  void clearConductorCost() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get towerCost => $_getN(1);
  @$pb.TagNumber(2)
  set towerCost($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTowerCost() => $_has(1);
  @$pb.TagNumber(2)
  void clearTowerCost() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get rowAcquisitionCost => $_getN(2);
  @$pb.TagNumber(3)
  set rowAcquisitionCost($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRowAcquisitionCost() => $_has(2);
  @$pb.TagNumber(3)
  void clearRowAcquisitionCost() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get crossingPremium => $_getN(3);
  @$pb.TagNumber(4)
  set crossingPremium($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCrossingPremium() => $_has(3);
  @$pb.TagNumber(4)
  void clearCrossingPremium() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalCost => $_getN(4);
  @$pb.TagNumber(5)
  set totalCost($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalCost() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalCost() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get costPerKm => $_getN(5);
  @$pb.TagNumber(6)
  set costPerKm($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCostPerKm() => $_has(5);
  @$pb.TagNumber(6)
  void clearCostPerKm() => $_clearField(6);
}

class RouteScore extends $pb.GeneratedMessage {
  factory RouteScore({
    $core.double? costScore,
    $core.double? riskScore,
    $core.double? constructabilityScore,
    $core.double? scheduleScore,
    $core.double? compositeScore,
    $core.bool? paretoFrontier,
    $core.String? recommendationReason,
    $pb.PbMap<$core.String, $core.String>? dimensionReasons,
  }) {
    final $result = create();
    if (costScore != null) {
      $result.costScore = costScore;
    }
    if (riskScore != null) {
      $result.riskScore = riskScore;
    }
    if (constructabilityScore != null) {
      $result.constructabilityScore = constructabilityScore;
    }
    if (scheduleScore != null) {
      $result.scheduleScore = scheduleScore;
    }
    if (compositeScore != null) {
      $result.compositeScore = compositeScore;
    }
    if (paretoFrontier != null) {
      $result.paretoFrontier = paretoFrontier;
    }
    if (recommendationReason != null) {
      $result.recommendationReason = recommendationReason;
    }
    if (dimensionReasons != null) {
      $result.dimensionReasons.addAll(dimensionReasons);
    }
    return $result;
  }
  RouteScore._() : super();
  factory RouteScore.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RouteScore.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RouteScore', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'costScore', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'riskScore', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'constructabilityScore', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'scheduleScore', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'compositeScore', $pb.PbFieldType.OD)
    ..aOB(6, _omitFieldNames ? '' : 'paretoFrontier')
    ..aOS(7, _omitFieldNames ? '' : 'recommendationReason')
    ..m<$core.String, $core.String>(8, _omitFieldNames ? '' : 'dimensionReasons', entryClassName: 'RouteScore.DimensionReasonsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('transmission.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RouteScore clone() => RouteScore()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RouteScore copyWith(void Function(RouteScore) updates) => super.copyWith((message) => updates(message as RouteScore)) as RouteScore;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RouteScore create() => RouteScore._();
  RouteScore createEmptyInstance() => create();
  static $pb.PbList<RouteScore> createRepeated() => $pb.PbList<RouteScore>();
  @$core.pragma('dart2js:noInline')
  static RouteScore getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RouteScore>(create);
  static RouteScore? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get costScore => $_getN(0);
  @$pb.TagNumber(1)
  set costScore($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCostScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearCostScore() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get riskScore => $_getN(1);
  @$pb.TagNumber(2)
  set riskScore($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRiskScore() => $_has(1);
  @$pb.TagNumber(2)
  void clearRiskScore() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get constructabilityScore => $_getN(2);
  @$pb.TagNumber(3)
  set constructabilityScore($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasConstructabilityScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearConstructabilityScore() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get scheduleScore => $_getN(3);
  @$pb.TagNumber(4)
  set scheduleScore($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasScheduleScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearScheduleScore() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get compositeScore => $_getN(4);
  @$pb.TagNumber(5)
  set compositeScore($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCompositeScore() => $_has(4);
  @$pb.TagNumber(5)
  void clearCompositeScore() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get paretoFrontier => $_getBF(5);
  @$pb.TagNumber(6)
  set paretoFrontier($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasParetoFrontier() => $_has(5);
  @$pb.TagNumber(6)
  void clearParetoFrontier() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get recommendationReason => $_getSZ(6);
  @$pb.TagNumber(7)
  set recommendationReason($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasRecommendationReason() => $_has(6);
  @$pb.TagNumber(7)
  void clearRecommendationReason() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.String> get dimensionReasons => $_getMap(7);
}

class GovernanceEvent extends $pb.GeneratedMessage {
  factory GovernanceEvent({
    $core.String? eventType,
    $core.String? actor,
    $core.String? note,
    ApprovalStatus? fromStatus,
    ApprovalStatus? toStatus,
    $0.Timestamp? occurredAt,
  }) {
    final $result = create();
    if (eventType != null) {
      $result.eventType = eventType;
    }
    if (actor != null) {
      $result.actor = actor;
    }
    if (note != null) {
      $result.note = note;
    }
    if (fromStatus != null) {
      $result.fromStatus = fromStatus;
    }
    if (toStatus != null) {
      $result.toStatus = toStatus;
    }
    if (occurredAt != null) {
      $result.occurredAt = occurredAt;
    }
    return $result;
  }
  GovernanceEvent._() : super();
  factory GovernanceEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GovernanceEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GovernanceEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eventType')
    ..aOS(2, _omitFieldNames ? '' : 'actor')
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..e<ApprovalStatus>(4, _omitFieldNames ? '' : 'fromStatus', $pb.PbFieldType.OE, defaultOrMaker: ApprovalStatus.APPROVAL_STATUS_UNSPECIFIED, valueOf: ApprovalStatus.valueOf, enumValues: ApprovalStatus.values)
    ..e<ApprovalStatus>(5, _omitFieldNames ? '' : 'toStatus', $pb.PbFieldType.OE, defaultOrMaker: ApprovalStatus.APPROVAL_STATUS_UNSPECIFIED, valueOf: ApprovalStatus.valueOf, enumValues: ApprovalStatus.values)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'occurredAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GovernanceEvent clone() => GovernanceEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GovernanceEvent copyWith(void Function(GovernanceEvent) updates) => super.copyWith((message) => updates(message as GovernanceEvent)) as GovernanceEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GovernanceEvent create() => GovernanceEvent._();
  GovernanceEvent createEmptyInstance() => create();
  static $pb.PbList<GovernanceEvent> createRepeated() => $pb.PbList<GovernanceEvent>();
  @$core.pragma('dart2js:noInline')
  static GovernanceEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GovernanceEvent>(create);
  static GovernanceEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eventType => $_getSZ(0);
  @$pb.TagNumber(1)
  set eventType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEventType() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get actor => $_getSZ(1);
  @$pb.TagNumber(2)
  set actor($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasActor() => $_has(1);
  @$pb.TagNumber(2)
  void clearActor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);

  @$pb.TagNumber(4)
  ApprovalStatus get fromStatus => $_getN(3);
  @$pb.TagNumber(4)
  set fromStatus(ApprovalStatus v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFromStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearFromStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  ApprovalStatus get toStatus => $_getN(4);
  @$pb.TagNumber(5)
  set toStatus(ApprovalStatus v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasToStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearToStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get occurredAt => $_getN(5);
  @$pb.TagNumber(6)
  set occurredAt($0.Timestamp v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasOccurredAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearOccurredAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureOccurredAt() => $_ensure(5);
}

class TraceabilityBundle extends $pb.GeneratedMessage {
  factory TraceabilityBundle({
    $core.String? algorithmVersion,
    $core.String? inputFingerprint,
    $core.String? routeFingerprint,
    $core.String? regressionSignature,
    $core.String? requestSnapshotJson,
    $core.String? dataSnapshotId,
    $0.Timestamp? approvedAt,
    $core.String? approvedBy,
  }) {
    final $result = create();
    if (algorithmVersion != null) {
      $result.algorithmVersion = algorithmVersion;
    }
    if (inputFingerprint != null) {
      $result.inputFingerprint = inputFingerprint;
    }
    if (routeFingerprint != null) {
      $result.routeFingerprint = routeFingerprint;
    }
    if (regressionSignature != null) {
      $result.regressionSignature = regressionSignature;
    }
    if (requestSnapshotJson != null) {
      $result.requestSnapshotJson = requestSnapshotJson;
    }
    if (dataSnapshotId != null) {
      $result.dataSnapshotId = dataSnapshotId;
    }
    if (approvedAt != null) {
      $result.approvedAt = approvedAt;
    }
    if (approvedBy != null) {
      $result.approvedBy = approvedBy;
    }
    return $result;
  }
  TraceabilityBundle._() : super();
  factory TraceabilityBundle.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TraceabilityBundle.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TraceabilityBundle', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'algorithmVersion')
    ..aOS(2, _omitFieldNames ? '' : 'inputFingerprint')
    ..aOS(3, _omitFieldNames ? '' : 'routeFingerprint')
    ..aOS(4, _omitFieldNames ? '' : 'regressionSignature')
    ..aOS(5, _omitFieldNames ? '' : 'requestSnapshotJson')
    ..aOS(6, _omitFieldNames ? '' : 'dataSnapshotId')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'approvedAt', subBuilder: $0.Timestamp.create)
    ..aOS(8, _omitFieldNames ? '' : 'approvedBy')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TraceabilityBundle clone() => TraceabilityBundle()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TraceabilityBundle copyWith(void Function(TraceabilityBundle) updates) => super.copyWith((message) => updates(message as TraceabilityBundle)) as TraceabilityBundle;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TraceabilityBundle create() => TraceabilityBundle._();
  TraceabilityBundle createEmptyInstance() => create();
  static $pb.PbList<TraceabilityBundle> createRepeated() => $pb.PbList<TraceabilityBundle>();
  @$core.pragma('dart2js:noInline')
  static TraceabilityBundle getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TraceabilityBundle>(create);
  static TraceabilityBundle? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get algorithmVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set algorithmVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAlgorithmVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlgorithmVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get inputFingerprint => $_getSZ(1);
  @$pb.TagNumber(2)
  set inputFingerprint($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInputFingerprint() => $_has(1);
  @$pb.TagNumber(2)
  void clearInputFingerprint() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get routeFingerprint => $_getSZ(2);
  @$pb.TagNumber(3)
  set routeFingerprint($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRouteFingerprint() => $_has(2);
  @$pb.TagNumber(3)
  void clearRouteFingerprint() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get regressionSignature => $_getSZ(3);
  @$pb.TagNumber(4)
  set regressionSignature($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRegressionSignature() => $_has(3);
  @$pb.TagNumber(4)
  void clearRegressionSignature() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get requestSnapshotJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set requestSnapshotJson($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRequestSnapshotJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearRequestSnapshotJson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get dataSnapshotId => $_getSZ(5);
  @$pb.TagNumber(6)
  set dataSnapshotId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDataSnapshotId() => $_has(5);
  @$pb.TagNumber(6)
  void clearDataSnapshotId() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get approvedAt => $_getN(6);
  @$pb.TagNumber(7)
  set approvedAt($0.Timestamp v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasApprovedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearApprovedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureApprovedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get approvedBy => $_getSZ(7);
  @$pb.TagNumber(8)
  set approvedBy($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasApprovedBy() => $_has(7);
  @$pb.TagNumber(8)
  void clearApprovedBy() => $_clearField(8);
}

class TowerScheduleEntry extends $pb.GeneratedMessage {
  factory TowerScheduleEntry({
    $core.int? sequence,
    $core.double? longitude,
    $core.double? latitude,
    $core.double? elevation,
    $core.double? spanToNextM,
    $core.double? heightM,
    $core.String? structureType,
  }) {
    final $result = create();
    if (sequence != null) {
      $result.sequence = sequence;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (elevation != null) {
      $result.elevation = elevation;
    }
    if (spanToNextM != null) {
      $result.spanToNextM = spanToNextM;
    }
    if (heightM != null) {
      $result.heightM = heightM;
    }
    if (structureType != null) {
      $result.structureType = structureType;
    }
    return $result;
  }
  TowerScheduleEntry._() : super();
  factory TowerScheduleEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TowerScheduleEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TowerScheduleEntry', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'sequence', $pb.PbFieldType.O3)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'elevation', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'spanToNextM', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'heightM', $pb.PbFieldType.OD)
    ..aOS(7, _omitFieldNames ? '' : 'structureType')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TowerScheduleEntry clone() => TowerScheduleEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TowerScheduleEntry copyWith(void Function(TowerScheduleEntry) updates) => super.copyWith((message) => updates(message as TowerScheduleEntry)) as TowerScheduleEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TowerScheduleEntry create() => TowerScheduleEntry._();
  TowerScheduleEntry createEmptyInstance() => create();
  static $pb.PbList<TowerScheduleEntry> createRepeated() => $pb.PbList<TowerScheduleEntry>();
  @$core.pragma('dart2js:noInline')
  static TowerScheduleEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TowerScheduleEntry>(create);
  static TowerScheduleEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sequence => $_getIZ(0);
  @$pb.TagNumber(1)
  set sequence($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSequence() => $_has(0);
  @$pb.TagNumber(1)
  void clearSequence() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get latitude => $_getN(2);
  @$pb.TagNumber(3)
  set latitude($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLatitude() => $_has(2);
  @$pb.TagNumber(3)
  void clearLatitude() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get elevation => $_getN(3);
  @$pb.TagNumber(4)
  set elevation($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasElevation() => $_has(3);
  @$pb.TagNumber(4)
  void clearElevation() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get spanToNextM => $_getN(4);
  @$pb.TagNumber(5)
  set spanToNextM($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSpanToNextM() => $_has(4);
  @$pb.TagNumber(5)
  void clearSpanToNextM() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get heightM => $_getN(5);
  @$pb.TagNumber(6)
  set heightM($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasHeightM() => $_has(5);
  @$pb.TagNumber(6)
  void clearHeightM() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get structureType => $_getSZ(6);
  @$pb.TagNumber(7)
  set structureType($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasStructureType() => $_has(6);
  @$pb.TagNumber(7)
  void clearStructureType() => $_clearField(7);
}

class UndergroundChainageEntry extends $pb.GeneratedMessage {
  factory UndergroundChainageEntry({
    $core.int? segmentIndex,
    $core.double? startChainageM,
    $core.double? endChainageM,
    $core.double? lengthM,
    $core.String? reason,
  }) {
    final $result = create();
    if (segmentIndex != null) {
      $result.segmentIndex = segmentIndex;
    }
    if (startChainageM != null) {
      $result.startChainageM = startChainageM;
    }
    if (endChainageM != null) {
      $result.endChainageM = endChainageM;
    }
    if (lengthM != null) {
      $result.lengthM = lengthM;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  UndergroundChainageEntry._() : super();
  factory UndergroundChainageEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UndergroundChainageEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UndergroundChainageEntry', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'segmentIndex', $pb.PbFieldType.O3)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'startChainageM', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'endChainageM', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'lengthM', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UndergroundChainageEntry clone() => UndergroundChainageEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UndergroundChainageEntry copyWith(void Function(UndergroundChainageEntry) updates) => super.copyWith((message) => updates(message as UndergroundChainageEntry)) as UndergroundChainageEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UndergroundChainageEntry create() => UndergroundChainageEntry._();
  UndergroundChainageEntry createEmptyInstance() => create();
  static $pb.PbList<UndergroundChainageEntry> createRepeated() => $pb.PbList<UndergroundChainageEntry>();
  @$core.pragma('dart2js:noInline')
  static UndergroundChainageEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UndergroundChainageEntry>(create);
  static UndergroundChainageEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get segmentIndex => $_getIZ(0);
  @$pb.TagNumber(1)
  set segmentIndex($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSegmentIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearSegmentIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get startChainageM => $_getN(1);
  @$pb.TagNumber(2)
  set startChainageM($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStartChainageM() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartChainageM() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get endChainageM => $_getN(2);
  @$pb.TagNumber(3)
  set endChainageM($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEndChainageM() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndChainageM() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get lengthM => $_getN(3);
  @$pb.TagNumber(4)
  set lengthM($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLengthM() => $_has(3);
  @$pb.TagNumber(4)
  void clearLengthM() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get reason => $_getSZ(4);
  @$pb.TagNumber(5)
  set reason($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearReason() => $_clearField(5);
}

class CostBookEntry extends $pb.GeneratedMessage {
  factory CostBookEntry({
    $core.String? category,
    $core.String? subcategory,
    $core.double? amount,
    $core.String? basis,
  }) {
    final $result = create();
    if (category != null) {
      $result.category = category;
    }
    if (subcategory != null) {
      $result.subcategory = subcategory;
    }
    if (amount != null) {
      $result.amount = amount;
    }
    if (basis != null) {
      $result.basis = basis;
    }
    return $result;
  }
  CostBookEntry._() : super();
  factory CostBookEntry.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CostBookEntry.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CostBookEntry', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'category')
    ..aOS(2, _omitFieldNames ? '' : 'subcategory')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'amount', $pb.PbFieldType.OD)
    ..aOS(4, _omitFieldNames ? '' : 'basis')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CostBookEntry clone() => CostBookEntry()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CostBookEntry copyWith(void Function(CostBookEntry) updates) => super.copyWith((message) => updates(message as CostBookEntry)) as CostBookEntry;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CostBookEntry create() => CostBookEntry._();
  CostBookEntry createEmptyInstance() => create();
  static $pb.PbList<CostBookEntry> createRepeated() => $pb.PbList<CostBookEntry>();
  @$core.pragma('dart2js:noInline')
  static CostBookEntry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CostBookEntry>(create);
  static CostBookEntry? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get category => $_getSZ(0);
  @$pb.TagNumber(1)
  set category($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get subcategory => $_getSZ(1);
  @$pb.TagNumber(2)
  set subcategory($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSubcategory() => $_has(1);
  @$pb.TagNumber(2)
  void clearSubcategory() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get basis => $_getSZ(3);
  @$pb.TagNumber(4)
  set basis($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBasis() => $_has(3);
  @$pb.TagNumber(4)
  void clearBasis() => $_clearField(4);
}

class TransmissionRouteExportPack extends $pb.GeneratedMessage {
  factory TransmissionRouteExportPack({
    TransmissionRoute? route,
    $core.Iterable<TowerScheduleEntry>? towerSchedule,
    $core.Iterable<UndergroundChainageEntry>? undergroundChainage,
    $core.Iterable<CostBookEntry>? costBook,
    TraceabilityBundle? traceability,
    $0.Timestamp? generatedAt,
    $core.String? generatedBy,
  }) {
    final $result = create();
    if (route != null) {
      $result.route = route;
    }
    if (towerSchedule != null) {
      $result.towerSchedule.addAll(towerSchedule);
    }
    if (undergroundChainage != null) {
      $result.undergroundChainage.addAll(undergroundChainage);
    }
    if (costBook != null) {
      $result.costBook.addAll(costBook);
    }
    if (traceability != null) {
      $result.traceability = traceability;
    }
    if (generatedAt != null) {
      $result.generatedAt = generatedAt;
    }
    if (generatedBy != null) {
      $result.generatedBy = generatedBy;
    }
    return $result;
  }
  TransmissionRouteExportPack._() : super();
  factory TransmissionRouteExportPack.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransmissionRouteExportPack.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransmissionRouteExportPack', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOM<TransmissionRoute>(1, _omitFieldNames ? '' : 'route', subBuilder: TransmissionRoute.create)
    ..pc<TowerScheduleEntry>(2, _omitFieldNames ? '' : 'towerSchedule', $pb.PbFieldType.PM, subBuilder: TowerScheduleEntry.create)
    ..pc<UndergroundChainageEntry>(3, _omitFieldNames ? '' : 'undergroundChainage', $pb.PbFieldType.PM, subBuilder: UndergroundChainageEntry.create)
    ..pc<CostBookEntry>(4, _omitFieldNames ? '' : 'costBook', $pb.PbFieldType.PM, subBuilder: CostBookEntry.create)
    ..aOM<TraceabilityBundle>(5, _omitFieldNames ? '' : 'traceability', subBuilder: TraceabilityBundle.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'generatedAt', subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'generatedBy')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransmissionRouteExportPack clone() => TransmissionRouteExportPack()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransmissionRouteExportPack copyWith(void Function(TransmissionRouteExportPack) updates) => super.copyWith((message) => updates(message as TransmissionRouteExportPack)) as TransmissionRouteExportPack;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransmissionRouteExportPack create() => TransmissionRouteExportPack._();
  TransmissionRouteExportPack createEmptyInstance() => create();
  static $pb.PbList<TransmissionRouteExportPack> createRepeated() => $pb.PbList<TransmissionRouteExportPack>();
  @$core.pragma('dart2js:noInline')
  static TransmissionRouteExportPack getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransmissionRouteExportPack>(create);
  static TransmissionRouteExportPack? _defaultInstance;

  @$pb.TagNumber(1)
  TransmissionRoute get route => $_getN(0);
  @$pb.TagNumber(1)
  set route(TransmissionRoute v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoute() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoute() => $_clearField(1);
  @$pb.TagNumber(1)
  TransmissionRoute ensureRoute() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<TowerScheduleEntry> get towerSchedule => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<UndergroundChainageEntry> get undergroundChainage => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<CostBookEntry> get costBook => $_getList(3);

  @$pb.TagNumber(5)
  TraceabilityBundle get traceability => $_getN(4);
  @$pb.TagNumber(5)
  set traceability(TraceabilityBundle v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasTraceability() => $_has(4);
  @$pb.TagNumber(5)
  void clearTraceability() => $_clearField(5);
  @$pb.TagNumber(5)
  TraceabilityBundle ensureTraceability() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get generatedAt => $_getN(5);
  @$pb.TagNumber(6)
  set generatedAt($0.Timestamp v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasGeneratedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearGeneratedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureGeneratedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get generatedBy => $_getSZ(6);
  @$pb.TagNumber(7)
  set generatedBy($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasGeneratedBy() => $_has(6);
  @$pb.TagNumber(7)
  void clearGeneratedBy() => $_clearField(7);
}

class TransmissionRoute extends $pb.GeneratedMessage {
  factory TransmissionRoute({
    $core.String? id,
    $core.String? projectId,
    $core.String? name,
    VoltageClass? voltageClass,
    $core.String? pathGeojson,
    Waypoint? farmOutputPoint,
    Waypoint? gridInjectionPoint,
    $core.Iterable<TowerPosition>? towerPositions,
    $core.double? distanceM,
    CostBreakdown? costBreakdown,
    $core.Iterable<SegmentExplanation>? segmentExplanations,
    $core.String? routeSummary,
    $0.Timestamp? createdAt,
    RouteScore? routeScore,
    ApprovalStatus? approvalStatus,
    $0.Timestamp? engineeringReviewedAt,
    $core.String? engineeringReviewedBy,
    $0.Timestamp? approvedAt,
    $core.String? approvedBy,
    $core.Iterable<GovernanceEvent>? governanceEvents,
    $core.String? electricalNetworkId,
    ReviewMetadata? reviewMetadata,
    $core.Iterable<$core.String>? protectionDevices,
    $core.int? faultIsolationPoints,
    $core.Iterable<$core.String>? routeConflicts,
    $core.double? routeFeasibilityScore,
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
    if (voltageClass != null) {
      $result.voltageClass = voltageClass;
    }
    if (pathGeojson != null) {
      $result.pathGeojson = pathGeojson;
    }
    if (farmOutputPoint != null) {
      $result.farmOutputPoint = farmOutputPoint;
    }
    if (gridInjectionPoint != null) {
      $result.gridInjectionPoint = gridInjectionPoint;
    }
    if (towerPositions != null) {
      $result.towerPositions.addAll(towerPositions);
    }
    if (distanceM != null) {
      $result.distanceM = distanceM;
    }
    if (costBreakdown != null) {
      $result.costBreakdown = costBreakdown;
    }
    if (segmentExplanations != null) {
      $result.segmentExplanations.addAll(segmentExplanations);
    }
    if (routeSummary != null) {
      $result.routeSummary = routeSummary;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (routeScore != null) {
      $result.routeScore = routeScore;
    }
    if (approvalStatus != null) {
      $result.approvalStatus = approvalStatus;
    }
    if (engineeringReviewedAt != null) {
      $result.engineeringReviewedAt = engineeringReviewedAt;
    }
    if (engineeringReviewedBy != null) {
      $result.engineeringReviewedBy = engineeringReviewedBy;
    }
    if (approvedAt != null) {
      $result.approvedAt = approvedAt;
    }
    if (approvedBy != null) {
      $result.approvedBy = approvedBy;
    }
    if (governanceEvents != null) {
      $result.governanceEvents.addAll(governanceEvents);
    }
    if (electricalNetworkId != null) {
      $result.electricalNetworkId = electricalNetworkId;
    }
    if (reviewMetadata != null) {
      $result.reviewMetadata = reviewMetadata;
    }
    if (protectionDevices != null) {
      $result.protectionDevices.addAll(protectionDevices);
    }
    if (faultIsolationPoints != null) {
      $result.faultIsolationPoints = faultIsolationPoints;
    }
    if (routeConflicts != null) {
      $result.routeConflicts.addAll(routeConflicts);
    }
    if (routeFeasibilityScore != null) {
      $result.routeFeasibilityScore = routeFeasibilityScore;
    }
    return $result;
  }
  TransmissionRoute._() : super();
  factory TransmissionRoute.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransmissionRoute.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransmissionRoute', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..e<VoltageClass>(4, _omitFieldNames ? '' : 'voltageClass', $pb.PbFieldType.OE, defaultOrMaker: VoltageClass.VOLTAGE_CLASS_UNSPECIFIED, valueOf: VoltageClass.valueOf, enumValues: VoltageClass.values)
    ..aOS(5, _omitFieldNames ? '' : 'pathGeojson')
    ..aOM<Waypoint>(6, _omitFieldNames ? '' : 'farmOutputPoint', subBuilder: Waypoint.create)
    ..aOM<Waypoint>(7, _omitFieldNames ? '' : 'gridInjectionPoint', subBuilder: Waypoint.create)
    ..pc<TowerPosition>(8, _omitFieldNames ? '' : 'towerPositions', $pb.PbFieldType.PM, subBuilder: TowerPosition.create)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'distanceM', $pb.PbFieldType.OD)
    ..aOM<CostBreakdown>(10, _omitFieldNames ? '' : 'costBreakdown', subBuilder: CostBreakdown.create)
    ..pc<SegmentExplanation>(11, _omitFieldNames ? '' : 'segmentExplanations', $pb.PbFieldType.PM, subBuilder: SegmentExplanation.create)
    ..aOS(12, _omitFieldNames ? '' : 'routeSummary')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<RouteScore>(14, _omitFieldNames ? '' : 'routeScore', subBuilder: RouteScore.create)
    ..e<ApprovalStatus>(15, _omitFieldNames ? '' : 'approvalStatus', $pb.PbFieldType.OE, defaultOrMaker: ApprovalStatus.APPROVAL_STATUS_UNSPECIFIED, valueOf: ApprovalStatus.valueOf, enumValues: ApprovalStatus.values)
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'engineeringReviewedAt', subBuilder: $0.Timestamp.create)
    ..aOS(17, _omitFieldNames ? '' : 'engineeringReviewedBy')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'approvedAt', subBuilder: $0.Timestamp.create)
    ..aOS(19, _omitFieldNames ? '' : 'approvedBy')
    ..pc<GovernanceEvent>(20, _omitFieldNames ? '' : 'governanceEvents', $pb.PbFieldType.PM, subBuilder: GovernanceEvent.create)
    ..aOS(21, _omitFieldNames ? '' : 'electricalNetworkId')
    ..aOM<ReviewMetadata>(22, _omitFieldNames ? '' : 'reviewMetadata', subBuilder: ReviewMetadata.create)
    ..pPS(23, _omitFieldNames ? '' : 'protectionDevices')
    ..a<$core.int>(24, _omitFieldNames ? '' : 'faultIsolationPoints', $pb.PbFieldType.O3)
    ..pPS(25, _omitFieldNames ? '' : 'routeConflicts')
    ..a<$core.double>(26, _omitFieldNames ? '' : 'routeFeasibilityScore', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransmissionRoute clone() => TransmissionRoute()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransmissionRoute copyWith(void Function(TransmissionRoute) updates) => super.copyWith((message) => updates(message as TransmissionRoute)) as TransmissionRoute;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransmissionRoute create() => TransmissionRoute._();
  TransmissionRoute createEmptyInstance() => create();
  static $pb.PbList<TransmissionRoute> createRepeated() => $pb.PbList<TransmissionRoute>();
  @$core.pragma('dart2js:noInline')
  static TransmissionRoute getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransmissionRoute>(create);
  static TransmissionRoute? _defaultInstance;

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
  VoltageClass get voltageClass => $_getN(3);
  @$pb.TagNumber(4)
  set voltageClass(VoltageClass v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasVoltageClass() => $_has(3);
  @$pb.TagNumber(4)
  void clearVoltageClass() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get pathGeojson => $_getSZ(4);
  @$pb.TagNumber(5)
  set pathGeojson($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPathGeojson() => $_has(4);
  @$pb.TagNumber(5)
  void clearPathGeojson() => $_clearField(5);

  @$pb.TagNumber(6)
  Waypoint get farmOutputPoint => $_getN(5);
  @$pb.TagNumber(6)
  set farmOutputPoint(Waypoint v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasFarmOutputPoint() => $_has(5);
  @$pb.TagNumber(6)
  void clearFarmOutputPoint() => $_clearField(6);
  @$pb.TagNumber(6)
  Waypoint ensureFarmOutputPoint() => $_ensure(5);

  @$pb.TagNumber(7)
  Waypoint get gridInjectionPoint => $_getN(6);
  @$pb.TagNumber(7)
  set gridInjectionPoint(Waypoint v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasGridInjectionPoint() => $_has(6);
  @$pb.TagNumber(7)
  void clearGridInjectionPoint() => $_clearField(7);
  @$pb.TagNumber(7)
  Waypoint ensureGridInjectionPoint() => $_ensure(6);

  @$pb.TagNumber(8)
  $pb.PbList<TowerPosition> get towerPositions => $_getList(7);

  @$pb.TagNumber(9)
  $core.double get distanceM => $_getN(8);
  @$pb.TagNumber(9)
  set distanceM($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasDistanceM() => $_has(8);
  @$pb.TagNumber(9)
  void clearDistanceM() => $_clearField(9);

  @$pb.TagNumber(10)
  CostBreakdown get costBreakdown => $_getN(9);
  @$pb.TagNumber(10)
  set costBreakdown(CostBreakdown v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasCostBreakdown() => $_has(9);
  @$pb.TagNumber(10)
  void clearCostBreakdown() => $_clearField(10);
  @$pb.TagNumber(10)
  CostBreakdown ensureCostBreakdown() => $_ensure(9);

  @$pb.TagNumber(11)
  $pb.PbList<SegmentExplanation> get segmentExplanations => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get routeSummary => $_getSZ(11);
  @$pb.TagNumber(12)
  set routeSummary($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasRouteSummary() => $_has(11);
  @$pb.TagNumber(12)
  void clearRouteSummary() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get createdAt => $_getN(12);
  @$pb.TagNumber(13)
  set createdAt($0.Timestamp v) { $_setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasCreatedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCreatedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureCreatedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  RouteScore get routeScore => $_getN(13);
  @$pb.TagNumber(14)
  set routeScore(RouteScore v) { $_setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasRouteScore() => $_has(13);
  @$pb.TagNumber(14)
  void clearRouteScore() => $_clearField(14);
  @$pb.TagNumber(14)
  RouteScore ensureRouteScore() => $_ensure(13);

  @$pb.TagNumber(15)
  ApprovalStatus get approvalStatus => $_getN(14);
  @$pb.TagNumber(15)
  set approvalStatus(ApprovalStatus v) { $_setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasApprovalStatus() => $_has(14);
  @$pb.TagNumber(15)
  void clearApprovalStatus() => $_clearField(15);

  @$pb.TagNumber(16)
  $0.Timestamp get engineeringReviewedAt => $_getN(15);
  @$pb.TagNumber(16)
  set engineeringReviewedAt($0.Timestamp v) { $_setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasEngineeringReviewedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearEngineeringReviewedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureEngineeringReviewedAt() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.String get engineeringReviewedBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set engineeringReviewedBy($core.String v) { $_setString(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasEngineeringReviewedBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearEngineeringReviewedBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get approvedAt => $_getN(17);
  @$pb.TagNumber(18)
  set approvedAt($0.Timestamp v) { $_setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasApprovedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearApprovedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureApprovedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $core.String get approvedBy => $_getSZ(18);
  @$pb.TagNumber(19)
  set approvedBy($core.String v) { $_setString(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasApprovedBy() => $_has(18);
  @$pb.TagNumber(19)
  void clearApprovedBy() => $_clearField(19);

  @$pb.TagNumber(20)
  $pb.PbList<GovernanceEvent> get governanceEvents => $_getList(19);

  /// Acceptance gate fields added in Step 15.
  /// electrical_network_id links this route to its origin electrical network.
  @$pb.TagNumber(21)
  $core.String get electricalNetworkId => $_getSZ(20);
  @$pb.TagNumber(21)
  set electricalNetworkId($core.String v) { $_setString(20, v); }
  @$pb.TagNumber(21)
  $core.bool hasElectricalNetworkId() => $_has(20);
  @$pb.TagNumber(21)
  void clearElectricalNetworkId() => $_clearField(21);

  /// review_metadata holds the acceptance workflow state (gate check for TransmissionReady).
  @$pb.TagNumber(22)
  ReviewMetadata get reviewMetadata => $_getN(21);
  @$pb.TagNumber(22)
  set reviewMetadata(ReviewMetadata v) { $_setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasReviewMetadata() => $_has(21);
  @$pb.TagNumber(22)
  void clearReviewMetadata() => $_clearField(22);
  @$pb.TagNumber(22)
  ReviewMetadata ensureReviewMetadata() => $_ensure(21);

  /// protection_devices lists device identifiers validated on this route (IEC 60255).
  @$pb.TagNumber(23)
  $pb.PbList<$core.String> get protectionDevices => $_getList(22);

  /// fault_isolation_points is the count of validated fault isolation points on the route.
  @$pb.TagNumber(24)
  $core.int get faultIsolationPoints => $_getIZ(23);
  @$pb.TagNumber(24)
  set faultIsolationPoints($core.int v) { $_setSignedInt32(23, v); }
  @$pb.TagNumber(24)
  $core.bool hasFaultIsolationPoints() => $_has(23);
  @$pb.TagNumber(24)
  void clearFaultIsolationPoints() => $_clearField(24);

  /// route_conflicts lists unresolved spatial or electrical conflicts. Empty if route is clean.
  @$pb.TagNumber(25)
  $pb.PbList<$core.String> get routeConflicts => $_getList(24);

  /// route_feasibility_score is an overall engineering feasibility score [0, 1].
  @$pb.TagNumber(26)
  $core.double get routeFeasibilityScore => $_getN(25);
  @$pb.TagNumber(26)
  set routeFeasibilityScore($core.double v) { $_setDouble(25, v); }
  @$pb.TagNumber(26)
  $core.bool hasRouteFeasibilityScore() => $_has(25);
  @$pb.TagNumber(26)
  void clearRouteFeasibilityScore() => $_clearField(26);
}

class CalculateTransmissionRouteRequest extends $pb.GeneratedMessage {
  factory CalculateTransmissionRouteRequest({
    $core.String? projectId,
    $core.String? name,
    VoltageClass? voltageClass,
    Waypoint? farmOutputPoint,
    Waypoint? gridInjectionPoint,
    TransmissionConstraints? constraints,
    ElevationRasterInput? elevationRaster,
    ObstacleRasterInput? obstacleRaster,
    $core.Iterable<VectorFeatureInput>? vectorFeatures,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (voltageClass != null) {
      $result.voltageClass = voltageClass;
    }
    if (farmOutputPoint != null) {
      $result.farmOutputPoint = farmOutputPoint;
    }
    if (gridInjectionPoint != null) {
      $result.gridInjectionPoint = gridInjectionPoint;
    }
    if (constraints != null) {
      $result.constraints = constraints;
    }
    if (elevationRaster != null) {
      $result.elevationRaster = elevationRaster;
    }
    if (obstacleRaster != null) {
      $result.obstacleRaster = obstacleRaster;
    }
    if (vectorFeatures != null) {
      $result.vectorFeatures.addAll(vectorFeatures);
    }
    return $result;
  }
  CalculateTransmissionRouteRequest._() : super();
  factory CalculateTransmissionRouteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateTransmissionRouteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateTransmissionRouteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..e<VoltageClass>(3, _omitFieldNames ? '' : 'voltageClass', $pb.PbFieldType.OE, defaultOrMaker: VoltageClass.VOLTAGE_CLASS_UNSPECIFIED, valueOf: VoltageClass.valueOf, enumValues: VoltageClass.values)
    ..aOM<Waypoint>(4, _omitFieldNames ? '' : 'farmOutputPoint', subBuilder: Waypoint.create)
    ..aOM<Waypoint>(5, _omitFieldNames ? '' : 'gridInjectionPoint', subBuilder: Waypoint.create)
    ..aOM<TransmissionConstraints>(6, _omitFieldNames ? '' : 'constraints', subBuilder: TransmissionConstraints.create)
    ..aOM<ElevationRasterInput>(7, _omitFieldNames ? '' : 'elevationRaster', subBuilder: ElevationRasterInput.create)
    ..aOM<ObstacleRasterInput>(8, _omitFieldNames ? '' : 'obstacleRaster', subBuilder: ObstacleRasterInput.create)
    ..pc<VectorFeatureInput>(9, _omitFieldNames ? '' : 'vectorFeatures', $pb.PbFieldType.PM, subBuilder: VectorFeatureInput.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateTransmissionRouteRequest clone() => CalculateTransmissionRouteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateTransmissionRouteRequest copyWith(void Function(CalculateTransmissionRouteRequest) updates) => super.copyWith((message) => updates(message as CalculateTransmissionRouteRequest)) as CalculateTransmissionRouteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateTransmissionRouteRequest create() => CalculateTransmissionRouteRequest._();
  CalculateTransmissionRouteRequest createEmptyInstance() => create();
  static $pb.PbList<CalculateTransmissionRouteRequest> createRepeated() => $pb.PbList<CalculateTransmissionRouteRequest>();
  @$core.pragma('dart2js:noInline')
  static CalculateTransmissionRouteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateTransmissionRouteRequest>(create);
  static CalculateTransmissionRouteRequest? _defaultInstance;

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
  VoltageClass get voltageClass => $_getN(2);
  @$pb.TagNumber(3)
  set voltageClass(VoltageClass v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasVoltageClass() => $_has(2);
  @$pb.TagNumber(3)
  void clearVoltageClass() => $_clearField(3);

  @$pb.TagNumber(4)
  Waypoint get farmOutputPoint => $_getN(3);
  @$pb.TagNumber(4)
  set farmOutputPoint(Waypoint v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFarmOutputPoint() => $_has(3);
  @$pb.TagNumber(4)
  void clearFarmOutputPoint() => $_clearField(4);
  @$pb.TagNumber(4)
  Waypoint ensureFarmOutputPoint() => $_ensure(3);

  @$pb.TagNumber(5)
  Waypoint get gridInjectionPoint => $_getN(4);
  @$pb.TagNumber(5)
  set gridInjectionPoint(Waypoint v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasGridInjectionPoint() => $_has(4);
  @$pb.TagNumber(5)
  void clearGridInjectionPoint() => $_clearField(5);
  @$pb.TagNumber(5)
  Waypoint ensureGridInjectionPoint() => $_ensure(4);

  @$pb.TagNumber(6)
  TransmissionConstraints get constraints => $_getN(5);
  @$pb.TagNumber(6)
  set constraints(TransmissionConstraints v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasConstraints() => $_has(5);
  @$pb.TagNumber(6)
  void clearConstraints() => $_clearField(6);
  @$pb.TagNumber(6)
  TransmissionConstraints ensureConstraints() => $_ensure(5);

  @$pb.TagNumber(7)
  ElevationRasterInput get elevationRaster => $_getN(6);
  @$pb.TagNumber(7)
  set elevationRaster(ElevationRasterInput v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasElevationRaster() => $_has(6);
  @$pb.TagNumber(7)
  void clearElevationRaster() => $_clearField(7);
  @$pb.TagNumber(7)
  ElevationRasterInput ensureElevationRaster() => $_ensure(6);

  @$pb.TagNumber(8)
  ObstacleRasterInput get obstacleRaster => $_getN(7);
  @$pb.TagNumber(8)
  set obstacleRaster(ObstacleRasterInput v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasObstacleRaster() => $_has(7);
  @$pb.TagNumber(8)
  void clearObstacleRaster() => $_clearField(8);
  @$pb.TagNumber(8)
  ObstacleRasterInput ensureObstacleRaster() => $_ensure(7);

  @$pb.TagNumber(9)
  $pb.PbList<VectorFeatureInput> get vectorFeatures => $_getList(8);
}

class CalculateTransmissionRouteResponse extends $pb.GeneratedMessage {
  factory CalculateTransmissionRouteResponse({
    TransmissionRoute? route,
  }) {
    final $result = create();
    if (route != null) {
      $result.route = route;
    }
    return $result;
  }
  CalculateTransmissionRouteResponse._() : super();
  factory CalculateTransmissionRouteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateTransmissionRouteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateTransmissionRouteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOM<TransmissionRoute>(1, _omitFieldNames ? '' : 'route', subBuilder: TransmissionRoute.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateTransmissionRouteResponse clone() => CalculateTransmissionRouteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateTransmissionRouteResponse copyWith(void Function(CalculateTransmissionRouteResponse) updates) => super.copyWith((message) => updates(message as CalculateTransmissionRouteResponse)) as CalculateTransmissionRouteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateTransmissionRouteResponse create() => CalculateTransmissionRouteResponse._();
  CalculateTransmissionRouteResponse createEmptyInstance() => create();
  static $pb.PbList<CalculateTransmissionRouteResponse> createRepeated() => $pb.PbList<CalculateTransmissionRouteResponse>();
  @$core.pragma('dart2js:noInline')
  static CalculateTransmissionRouteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateTransmissionRouteResponse>(create);
  static CalculateTransmissionRouteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TransmissionRoute get route => $_getN(0);
  @$pb.TagNumber(1)
  set route(TransmissionRoute v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoute() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoute() => $_clearField(1);
  @$pb.TagNumber(1)
  TransmissionRoute ensureRoute() => $_ensure(0);
}

class StreamTransmissionRouteRequest extends $pb.GeneratedMessage {
  factory StreamTransmissionRouteRequest({
    CalculateTransmissionRouteRequest? request,
  }) {
    final $result = create();
    if (request != null) {
      $result.request = request;
    }
    return $result;
  }
  StreamTransmissionRouteRequest._() : super();
  factory StreamTransmissionRouteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StreamTransmissionRouteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StreamTransmissionRouteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOM<CalculateTransmissionRouteRequest>(1, _omitFieldNames ? '' : 'request', subBuilder: CalculateTransmissionRouteRequest.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StreamTransmissionRouteRequest clone() => StreamTransmissionRouteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StreamTransmissionRouteRequest copyWith(void Function(StreamTransmissionRouteRequest) updates) => super.copyWith((message) => updates(message as StreamTransmissionRouteRequest)) as StreamTransmissionRouteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamTransmissionRouteRequest create() => StreamTransmissionRouteRequest._();
  StreamTransmissionRouteRequest createEmptyInstance() => create();
  static $pb.PbList<StreamTransmissionRouteRequest> createRepeated() => $pb.PbList<StreamTransmissionRouteRequest>();
  @$core.pragma('dart2js:noInline')
  static StreamTransmissionRouteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StreamTransmissionRouteRequest>(create);
  static StreamTransmissionRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  CalculateTransmissionRouteRequest get request => $_getN(0);
  @$pb.TagNumber(1)
  set request(CalculateTransmissionRouteRequest v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRequest() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequest() => $_clearField(1);
  @$pb.TagNumber(1)
  CalculateTransmissionRouteRequest ensureRequest() => $_ensure(0);
}

class StreamTransmissionRouteResponse extends $pb.GeneratedMessage {
  factory StreamTransmissionRouteResponse({
    $core.String? phase,
    $core.int? percentComplete,
    $core.String? message,
    TransmissionRoute? route,
  }) {
    final $result = create();
    if (phase != null) {
      $result.phase = phase;
    }
    if (percentComplete != null) {
      $result.percentComplete = percentComplete;
    }
    if (message != null) {
      $result.message = message;
    }
    if (route != null) {
      $result.route = route;
    }
    return $result;
  }
  StreamTransmissionRouteResponse._() : super();
  factory StreamTransmissionRouteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StreamTransmissionRouteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StreamTransmissionRouteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'phase')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'percentComplete', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..aOM<TransmissionRoute>(4, _omitFieldNames ? '' : 'route', subBuilder: TransmissionRoute.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StreamTransmissionRouteResponse clone() => StreamTransmissionRouteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StreamTransmissionRouteResponse copyWith(void Function(StreamTransmissionRouteResponse) updates) => super.copyWith((message) => updates(message as StreamTransmissionRouteResponse)) as StreamTransmissionRouteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamTransmissionRouteResponse create() => StreamTransmissionRouteResponse._();
  StreamTransmissionRouteResponse createEmptyInstance() => create();
  static $pb.PbList<StreamTransmissionRouteResponse> createRepeated() => $pb.PbList<StreamTransmissionRouteResponse>();
  @$core.pragma('dart2js:noInline')
  static StreamTransmissionRouteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StreamTransmissionRouteResponse>(create);
  static StreamTransmissionRouteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phase => $_getSZ(0);
  @$pb.TagNumber(1)
  set phase($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPhase() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhase() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get percentComplete => $_getIZ(1);
  @$pb.TagNumber(2)
  set percentComplete($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPercentComplete() => $_has(1);
  @$pb.TagNumber(2)
  void clearPercentComplete() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  TransmissionRoute get route => $_getN(3);
  @$pb.TagNumber(4)
  set route(TransmissionRoute v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasRoute() => $_has(3);
  @$pb.TagNumber(4)
  void clearRoute() => $_clearField(4);
  @$pb.TagNumber(4)
  TransmissionRoute ensureRoute() => $_ensure(3);
}

class GetTransmissionRouteRequest extends $pb.GeneratedMessage {
  factory GetTransmissionRouteRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetTransmissionRouteRequest._() : super();
  factory GetTransmissionRouteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTransmissionRouteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetTransmissionRouteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTransmissionRouteRequest clone() => GetTransmissionRouteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTransmissionRouteRequest copyWith(void Function(GetTransmissionRouteRequest) updates) => super.copyWith((message) => updates(message as GetTransmissionRouteRequest)) as GetTransmissionRouteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTransmissionRouteRequest create() => GetTransmissionRouteRequest._();
  GetTransmissionRouteRequest createEmptyInstance() => create();
  static $pb.PbList<GetTransmissionRouteRequest> createRepeated() => $pb.PbList<GetTransmissionRouteRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTransmissionRouteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTransmissionRouteRequest>(create);
  static GetTransmissionRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetTransmissionRouteResponse extends $pb.GeneratedMessage {
  factory GetTransmissionRouteResponse({
    TransmissionRoute? route,
  }) {
    final $result = create();
    if (route != null) {
      $result.route = route;
    }
    return $result;
  }
  GetTransmissionRouteResponse._() : super();
  factory GetTransmissionRouteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTransmissionRouteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetTransmissionRouteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOM<TransmissionRoute>(1, _omitFieldNames ? '' : 'route', subBuilder: TransmissionRoute.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTransmissionRouteResponse clone() => GetTransmissionRouteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTransmissionRouteResponse copyWith(void Function(GetTransmissionRouteResponse) updates) => super.copyWith((message) => updates(message as GetTransmissionRouteResponse)) as GetTransmissionRouteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTransmissionRouteResponse create() => GetTransmissionRouteResponse._();
  GetTransmissionRouteResponse createEmptyInstance() => create();
  static $pb.PbList<GetTransmissionRouteResponse> createRepeated() => $pb.PbList<GetTransmissionRouteResponse>();
  @$core.pragma('dart2js:noInline')
  static GetTransmissionRouteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTransmissionRouteResponse>(create);
  static GetTransmissionRouteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TransmissionRoute get route => $_getN(0);
  @$pb.TagNumber(1)
  set route(TransmissionRoute v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoute() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoute() => $_clearField(1);
  @$pb.TagNumber(1)
  TransmissionRoute ensureRoute() => $_ensure(0);
}

class ListTransmissionRoutesRequest extends $pb.GeneratedMessage {
  factory ListTransmissionRoutesRequest({
    $core.String? projectId,
    $1.PaginationRequest? pagination,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListTransmissionRoutesRequest._() : super();
  factory ListTransmissionRoutesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListTransmissionRoutesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListTransmissionRoutesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<$1.PaginationRequest>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListTransmissionRoutesRequest clone() => ListTransmissionRoutesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListTransmissionRoutesRequest copyWith(void Function(ListTransmissionRoutesRequest) updates) => super.copyWith((message) => updates(message as ListTransmissionRoutesRequest)) as ListTransmissionRoutesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTransmissionRoutesRequest create() => ListTransmissionRoutesRequest._();
  ListTransmissionRoutesRequest createEmptyInstance() => create();
  static $pb.PbList<ListTransmissionRoutesRequest> createRepeated() => $pb.PbList<ListTransmissionRoutesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListTransmissionRoutesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTransmissionRoutesRequest>(create);
  static ListTransmissionRoutesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.PaginationRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationRequest v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationRequest ensurePagination() => $_ensure(1);
}

class ListTransmissionRoutesResponse extends $pb.GeneratedMessage {
  factory ListTransmissionRoutesResponse({
    $core.Iterable<TransmissionRoute>? routes,
    $1.PaginationResponse? pagination,
  }) {
    final $result = create();
    if (routes != null) {
      $result.routes.addAll(routes);
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListTransmissionRoutesResponse._() : super();
  factory ListTransmissionRoutesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListTransmissionRoutesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListTransmissionRoutesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..pc<TransmissionRoute>(1, _omitFieldNames ? '' : 'routes', $pb.PbFieldType.PM, subBuilder: TransmissionRoute.create)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListTransmissionRoutesResponse clone() => ListTransmissionRoutesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListTransmissionRoutesResponse copyWith(void Function(ListTransmissionRoutesResponse) updates) => super.copyWith((message) => updates(message as ListTransmissionRoutesResponse)) as ListTransmissionRoutesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTransmissionRoutesResponse create() => ListTransmissionRoutesResponse._();
  ListTransmissionRoutesResponse createEmptyInstance() => create();
  static $pb.PbList<ListTransmissionRoutesResponse> createRepeated() => $pb.PbList<ListTransmissionRoutesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListTransmissionRoutesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTransmissionRoutesResponse>(create);
  static ListTransmissionRoutesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TransmissionRoute> get routes => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationResponse v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationResponse ensurePagination() => $_ensure(1);
}

/// SubmitTransmissionRouteForReviewRequest submits a route for engineering review,
/// transitioning its approval_status to ENGINEERING_REVIEW and acceptance status to REVIEW_PENDING.
class SubmitTransmissionRouteForReviewRequest extends $pb.GeneratedMessage {
  factory SubmitTransmissionRouteForReviewRequest({
    $core.String? id,
    $core.String? actor,
    $core.String? note,
    $core.String? submissionReason,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (actor != null) {
      $result.actor = actor;
    }
    if (note != null) {
      $result.note = note;
    }
    if (submissionReason != null) {
      $result.submissionReason = submissionReason;
    }
    return $result;
  }
  SubmitTransmissionRouteForReviewRequest._() : super();
  factory SubmitTransmissionRouteForReviewRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitTransmissionRouteForReviewRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitTransmissionRouteForReviewRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'actor')
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..aOS(4, _omitFieldNames ? '' : 'submissionReason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitTransmissionRouteForReviewRequest clone() => SubmitTransmissionRouteForReviewRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitTransmissionRouteForReviewRequest copyWith(void Function(SubmitTransmissionRouteForReviewRequest) updates) => super.copyWith((message) => updates(message as SubmitTransmissionRouteForReviewRequest)) as SubmitTransmissionRouteForReviewRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitTransmissionRouteForReviewRequest create() => SubmitTransmissionRouteForReviewRequest._();
  SubmitTransmissionRouteForReviewRequest createEmptyInstance() => create();
  static $pb.PbList<SubmitTransmissionRouteForReviewRequest> createRepeated() => $pb.PbList<SubmitTransmissionRouteForReviewRequest>();
  @$core.pragma('dart2js:noInline')
  static SubmitTransmissionRouteForReviewRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitTransmissionRouteForReviewRequest>(create);
  static SubmitTransmissionRouteForReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get actor => $_getSZ(1);
  @$pb.TagNumber(2)
  set actor($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasActor() => $_has(1);
  @$pb.TagNumber(2)
  void clearActor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);

  /// submission_reason is a required human-readable justification for the review submission.
  @$pb.TagNumber(4)
  $core.String get submissionReason => $_getSZ(3);
  @$pb.TagNumber(4)
  set submissionReason($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSubmissionReason() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubmissionReason() => $_clearField(4);
}

/// SubmitTransmissionRouteForReviewResponse returns the route with updated approval and acceptance state.
class SubmitTransmissionRouteForReviewResponse extends $pb.GeneratedMessage {
  factory SubmitTransmissionRouteForReviewResponse({
    TransmissionRoute? route,
  }) {
    final $result = create();
    if (route != null) {
      $result.route = route;
    }
    return $result;
  }
  SubmitTransmissionRouteForReviewResponse._() : super();
  factory SubmitTransmissionRouteForReviewResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitTransmissionRouteForReviewResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitTransmissionRouteForReviewResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOM<TransmissionRoute>(1, _omitFieldNames ? '' : 'route', subBuilder: TransmissionRoute.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitTransmissionRouteForReviewResponse clone() => SubmitTransmissionRouteForReviewResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitTransmissionRouteForReviewResponse copyWith(void Function(SubmitTransmissionRouteForReviewResponse) updates) => super.copyWith((message) => updates(message as SubmitTransmissionRouteForReviewResponse)) as SubmitTransmissionRouteForReviewResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitTransmissionRouteForReviewResponse create() => SubmitTransmissionRouteForReviewResponse._();
  SubmitTransmissionRouteForReviewResponse createEmptyInstance() => create();
  static $pb.PbList<SubmitTransmissionRouteForReviewResponse> createRepeated() => $pb.PbList<SubmitTransmissionRouteForReviewResponse>();
  @$core.pragma('dart2js:noInline')
  static SubmitTransmissionRouteForReviewResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitTransmissionRouteForReviewResponse>(create);
  static SubmitTransmissionRouteForReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TransmissionRoute get route => $_getN(0);
  @$pb.TagNumber(1)
  set route(TransmissionRoute v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoute() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoute() => $_clearField(1);
  @$pb.TagNumber(1)
  TransmissionRoute ensureRoute() => $_ensure(0);
}

/// ApproveTransmissionRouteRequest approves a route in engineering review,
/// setting acceptance_status to APPROVED and recording quality/feasibility scores.
class ApproveTransmissionRouteRequest extends $pb.GeneratedMessage {
  factory ApproveTransmissionRouteRequest({
    $core.String? id,
    $core.String? actor,
    $core.String? note,
    $core.double? qualityScore,
    $core.double? feasibilityScore,
    $core.Iterable<$core.String>? approvalComments,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (actor != null) {
      $result.actor = actor;
    }
    if (note != null) {
      $result.note = note;
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
    return $result;
  }
  ApproveTransmissionRouteRequest._() : super();
  factory ApproveTransmissionRouteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApproveTransmissionRouteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApproveTransmissionRouteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'actor')
    ..aOS(3, _omitFieldNames ? '' : 'note')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'qualityScore', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'feasibilityScore', $pb.PbFieldType.OD)
    ..pPS(6, _omitFieldNames ? '' : 'approvalComments')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApproveTransmissionRouteRequest clone() => ApproveTransmissionRouteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApproveTransmissionRouteRequest copyWith(void Function(ApproveTransmissionRouteRequest) updates) => super.copyWith((message) => updates(message as ApproveTransmissionRouteRequest)) as ApproveTransmissionRouteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveTransmissionRouteRequest create() => ApproveTransmissionRouteRequest._();
  ApproveTransmissionRouteRequest createEmptyInstance() => create();
  static $pb.PbList<ApproveTransmissionRouteRequest> createRepeated() => $pb.PbList<ApproveTransmissionRouteRequest>();
  @$core.pragma('dart2js:noInline')
  static ApproveTransmissionRouteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproveTransmissionRouteRequest>(create);
  static ApproveTransmissionRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get actor => $_getSZ(1);
  @$pb.TagNumber(2)
  set actor($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasActor() => $_has(1);
  @$pb.TagNumber(2)
  void clearActor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get note => $_getSZ(2);
  @$pb.TagNumber(3)
  set note($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasNote() => $_has(2);
  @$pb.TagNumber(3)
  void clearNote() => $_clearField(3);

  /// quality_score is the reviewer-assigned quality rating [0, 1].
  @$pb.TagNumber(4)
  $core.double get qualityScore => $_getN(3);
  @$pb.TagNumber(4)
  set qualityScore($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasQualityScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearQualityScore() => $_clearField(4);

  /// feasibility_score is the reviewer-assigned engineering feasibility score [0, 1].
  @$pb.TagNumber(5)
  $core.double get feasibilityScore => $_getN(4);
  @$pb.TagNumber(5)
  set feasibilityScore($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFeasibilityScore() => $_has(4);
  @$pb.TagNumber(5)
  void clearFeasibilityScore() => $_clearField(5);

  /// approval_comments are free-text comments attached to the approval.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get approvalComments => $_getList(5);
}

/// ApproveTransmissionRouteResponse returns the route with APPROVED acceptance state.
class ApproveTransmissionRouteResponse extends $pb.GeneratedMessage {
  factory ApproveTransmissionRouteResponse({
    TransmissionRoute? route,
  }) {
    final $result = create();
    if (route != null) {
      $result.route = route;
    }
    return $result;
  }
  ApproveTransmissionRouteResponse._() : super();
  factory ApproveTransmissionRouteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApproveTransmissionRouteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApproveTransmissionRouteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOM<TransmissionRoute>(1, _omitFieldNames ? '' : 'route', subBuilder: TransmissionRoute.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApproveTransmissionRouteResponse clone() => ApproveTransmissionRouteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApproveTransmissionRouteResponse copyWith(void Function(ApproveTransmissionRouteResponse) updates) => super.copyWith((message) => updates(message as ApproveTransmissionRouteResponse)) as ApproveTransmissionRouteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveTransmissionRouteResponse create() => ApproveTransmissionRouteResponse._();
  ApproveTransmissionRouteResponse createEmptyInstance() => create();
  static $pb.PbList<ApproveTransmissionRouteResponse> createRepeated() => $pb.PbList<ApproveTransmissionRouteResponse>();
  @$core.pragma('dart2js:noInline')
  static ApproveTransmissionRouteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproveTransmissionRouteResponse>(create);
  static ApproveTransmissionRouteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TransmissionRoute get route => $_getN(0);
  @$pb.TagNumber(1)
  set route(TransmissionRoute v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoute() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoute() => $_clearField(1);
  @$pb.TagNumber(1)
  TransmissionRoute ensureRoute() => $_ensure(0);
}

/// RejectTransmissionRouteRequest rejects a route under review,
/// returning it to DRAFT with documented rejection reasons.
class RejectTransmissionRouteRequest extends $pb.GeneratedMessage {
  factory RejectTransmissionRouteRequest({
    $core.String? id,
    $core.String? actor,
    $core.Iterable<$core.String>? rejectionReasons,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (actor != null) {
      $result.actor = actor;
    }
    if (rejectionReasons != null) {
      $result.rejectionReasons.addAll(rejectionReasons);
    }
    return $result;
  }
  RejectTransmissionRouteRequest._() : super();
  factory RejectTransmissionRouteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RejectTransmissionRouteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RejectTransmissionRouteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'actor')
    ..pPS(3, _omitFieldNames ? '' : 'rejectionReasons')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RejectTransmissionRouteRequest clone() => RejectTransmissionRouteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RejectTransmissionRouteRequest copyWith(void Function(RejectTransmissionRouteRequest) updates) => super.copyWith((message) => updates(message as RejectTransmissionRouteRequest)) as RejectTransmissionRouteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectTransmissionRouteRequest create() => RejectTransmissionRouteRequest._();
  RejectTransmissionRouteRequest createEmptyInstance() => create();
  static $pb.PbList<RejectTransmissionRouteRequest> createRepeated() => $pb.PbList<RejectTransmissionRouteRequest>();
  @$core.pragma('dart2js:noInline')
  static RejectTransmissionRouteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RejectTransmissionRouteRequest>(create);
  static RejectTransmissionRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get actor => $_getSZ(1);
  @$pb.TagNumber(2)
  set actor($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasActor() => $_has(1);
  @$pb.TagNumber(2)
  void clearActor() => $_clearField(2);

  /// rejection_reasons must be non-empty; they populate review_metadata.blockers.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get rejectionReasons => $_getList(2);
}

/// RejectTransmissionRouteResponse returns the route with REJECTED acceptance state.
class RejectTransmissionRouteResponse extends $pb.GeneratedMessage {
  factory RejectTransmissionRouteResponse({
    TransmissionRoute? route,
  }) {
    final $result = create();
    if (route != null) {
      $result.route = route;
    }
    return $result;
  }
  RejectTransmissionRouteResponse._() : super();
  factory RejectTransmissionRouteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RejectTransmissionRouteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RejectTransmissionRouteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOM<TransmissionRoute>(1, _omitFieldNames ? '' : 'route', subBuilder: TransmissionRoute.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RejectTransmissionRouteResponse clone() => RejectTransmissionRouteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RejectTransmissionRouteResponse copyWith(void Function(RejectTransmissionRouteResponse) updates) => super.copyWith((message) => updates(message as RejectTransmissionRouteResponse)) as RejectTransmissionRouteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectTransmissionRouteResponse create() => RejectTransmissionRouteResponse._();
  RejectTransmissionRouteResponse createEmptyInstance() => create();
  static $pb.PbList<RejectTransmissionRouteResponse> createRepeated() => $pb.PbList<RejectTransmissionRouteResponse>();
  @$core.pragma('dart2js:noInline')
  static RejectTransmissionRouteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RejectTransmissionRouteResponse>(create);
  static RejectTransmissionRouteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TransmissionRoute get route => $_getN(0);
  @$pb.TagNumber(1)
  set route(TransmissionRoute v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoute() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoute() => $_clearField(1);
  @$pb.TagNumber(1)
  TransmissionRoute ensureRoute() => $_ensure(0);
}

class ExportTransmissionRoutePackRequest extends $pb.GeneratedMessage {
  factory ExportTransmissionRoutePackRequest({
    $core.String? id,
    $core.String? generatedBy,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (generatedBy != null) {
      $result.generatedBy = generatedBy;
    }
    return $result;
  }
  ExportTransmissionRoutePackRequest._() : super();
  factory ExportTransmissionRoutePackRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportTransmissionRoutePackRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExportTransmissionRoutePackRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'generatedBy')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportTransmissionRoutePackRequest clone() => ExportTransmissionRoutePackRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportTransmissionRoutePackRequest copyWith(void Function(ExportTransmissionRoutePackRequest) updates) => super.copyWith((message) => updates(message as ExportTransmissionRoutePackRequest)) as ExportTransmissionRoutePackRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExportTransmissionRoutePackRequest create() => ExportTransmissionRoutePackRequest._();
  ExportTransmissionRoutePackRequest createEmptyInstance() => create();
  static $pb.PbList<ExportTransmissionRoutePackRequest> createRepeated() => $pb.PbList<ExportTransmissionRoutePackRequest>();
  @$core.pragma('dart2js:noInline')
  static ExportTransmissionRoutePackRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportTransmissionRoutePackRequest>(create);
  static ExportTransmissionRoutePackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get generatedBy => $_getSZ(1);
  @$pb.TagNumber(2)
  set generatedBy($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGeneratedBy() => $_has(1);
  @$pb.TagNumber(2)
  void clearGeneratedBy() => $_clearField(2);
}

class ExportTransmissionRoutePackResponse extends $pb.GeneratedMessage {
  factory ExportTransmissionRoutePackResponse({
    TransmissionRouteExportPack? pack,
  }) {
    final $result = create();
    if (pack != null) {
      $result.pack = pack;
    }
    return $result;
  }
  ExportTransmissionRoutePackResponse._() : super();
  factory ExportTransmissionRoutePackResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportTransmissionRoutePackResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExportTransmissionRoutePackResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOM<TransmissionRouteExportPack>(1, _omitFieldNames ? '' : 'pack', subBuilder: TransmissionRouteExportPack.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportTransmissionRoutePackResponse clone() => ExportTransmissionRoutePackResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportTransmissionRoutePackResponse copyWith(void Function(ExportTransmissionRoutePackResponse) updates) => super.copyWith((message) => updates(message as ExportTransmissionRoutePackResponse)) as ExportTransmissionRoutePackResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExportTransmissionRoutePackResponse create() => ExportTransmissionRoutePackResponse._();
  ExportTransmissionRoutePackResponse createEmptyInstance() => create();
  static $pb.PbList<ExportTransmissionRoutePackResponse> createRepeated() => $pb.PbList<ExportTransmissionRoutePackResponse>();
  @$core.pragma('dart2js:noInline')
  static ExportTransmissionRoutePackResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportTransmissionRoutePackResponse>(create);
  static ExportTransmissionRoutePackResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TransmissionRouteExportPack get pack => $_getN(0);
  @$pb.TagNumber(1)
  set pack(TransmissionRouteExportPack v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPack() => $_has(0);
  @$pb.TagNumber(1)
  void clearPack() => $_clearField(1);
  @$pb.TagNumber(1)
  TransmissionRouteExportPack ensurePack() => $_ensure(0);
}

class DeleteTransmissionRouteRequest extends $pb.GeneratedMessage {
  factory DeleteTransmissionRouteRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteTransmissionRouteRequest._() : super();
  factory DeleteTransmissionRouteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteTransmissionRouteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteTransmissionRouteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteTransmissionRouteRequest clone() => DeleteTransmissionRouteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteTransmissionRouteRequest copyWith(void Function(DeleteTransmissionRouteRequest) updates) => super.copyWith((message) => updates(message as DeleteTransmissionRouteRequest)) as DeleteTransmissionRouteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteTransmissionRouteRequest create() => DeleteTransmissionRouteRequest._();
  DeleteTransmissionRouteRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteTransmissionRouteRequest> createRepeated() => $pb.PbList<DeleteTransmissionRouteRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteTransmissionRouteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteTransmissionRouteRequest>(create);
  static DeleteTransmissionRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteTransmissionRouteResponse extends $pb.GeneratedMessage {
  factory DeleteTransmissionRouteResponse() => create();
  DeleteTransmissionRouteResponse._() : super();
  factory DeleteTransmissionRouteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteTransmissionRouteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteTransmissionRouteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'transmission.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteTransmissionRouteResponse clone() => DeleteTransmissionRouteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteTransmissionRouteResponse copyWith(void Function(DeleteTransmissionRouteResponse) updates) => super.copyWith((message) => updates(message as DeleteTransmissionRouteResponse)) as DeleteTransmissionRouteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteTransmissionRouteResponse create() => DeleteTransmissionRouteResponse._();
  DeleteTransmissionRouteResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteTransmissionRouteResponse> createRepeated() => $pb.PbList<DeleteTransmissionRouteResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteTransmissionRouteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteTransmissionRouteResponse>(create);
  static DeleteTransmissionRouteResponse? _defaultInstance;
}

/// TransmissionRoutingService manages end-to-end transmission corridor routing
/// with engineering validation, governance workflow, and exportable delivery packs.
class TransmissionRoutingServiceApi {
  $pb.RpcClient _client;
  TransmissionRoutingServiceApi(this._client);

  /// CalculateTransmissionRoute computes a transmission route and returns the final result.
  $async.Future<CalculateTransmissionRouteResponse> calculateTransmissionRoute($pb.ClientContext? ctx, CalculateTransmissionRouteRequest request) =>
    _client.invoke<CalculateTransmissionRouteResponse>(ctx, 'TransmissionRoutingService', 'CalculateTransmissionRoute', request, CalculateTransmissionRouteResponse())
  ;
  /// StreamTransmissionRoute streams phase progress updates and emits the final route.
  $async.Future<StreamTransmissionRouteResponse> streamTransmissionRoute($pb.ClientContext? ctx, StreamTransmissionRouteRequest request) =>
    _client.invoke<StreamTransmissionRouteResponse>(ctx, 'TransmissionRoutingService', 'StreamTransmissionRoute', request, StreamTransmissionRouteResponse())
  ;
  /// GetTransmissionRoute returns a previously calculated transmission route by ID.
  $async.Future<GetTransmissionRouteResponse> getTransmissionRoute($pb.ClientContext? ctx, GetTransmissionRouteRequest request) =>
    _client.invoke<GetTransmissionRouteResponse>(ctx, 'TransmissionRoutingService', 'GetTransmissionRoute', request, GetTransmissionRouteResponse())
  ;
  /// ListTransmissionRoutes lists transmission routes for a project.
  $async.Future<ListTransmissionRoutesResponse> listTransmissionRoutes($pb.ClientContext? ctx, ListTransmissionRoutesRequest request) =>
    _client.invoke<ListTransmissionRoutesResponse>(ctx, 'TransmissionRoutingService', 'ListTransmissionRoutes', request, ListTransmissionRoutesResponse())
  ;
  /// SubmitTransmissionRouteForReview transitions a route into engineering review.
  $async.Future<SubmitTransmissionRouteForReviewResponse> submitTransmissionRouteForReview($pb.ClientContext? ctx, SubmitTransmissionRouteForReviewRequest request) =>
    _client.invoke<SubmitTransmissionRouteForReviewResponse>(ctx, 'TransmissionRoutingService', 'SubmitTransmissionRouteForReview', request, SubmitTransmissionRouteForReviewResponse())
  ;
  /// ApproveTransmissionRoute approves a reviewed route for downstream delivery.
  $async.Future<ApproveTransmissionRouteResponse> approveTransmissionRoute($pb.ClientContext? ctx, ApproveTransmissionRouteRequest request) =>
    _client.invoke<ApproveTransmissionRouteResponse>(ctx, 'TransmissionRoutingService', 'ApproveTransmissionRoute', request, ApproveTransmissionRouteResponse())
  ;
  /// ExportTransmissionRoutePack exports route artifacts required for handoff.
  $async.Future<ExportTransmissionRoutePackResponse> exportTransmissionRoutePack($pb.ClientContext? ctx, ExportTransmissionRoutePackRequest request) =>
    _client.invoke<ExportTransmissionRoutePackResponse>(ctx, 'TransmissionRoutingService', 'ExportTransmissionRoutePack', request, ExportTransmissionRoutePackResponse())
  ;
  /// DeleteTransmissionRoute removes a transmission route.
  $async.Future<DeleteTransmissionRouteResponse> deleteTransmissionRoute($pb.ClientContext? ctx, DeleteTransmissionRouteRequest request) =>
    _client.invoke<DeleteTransmissionRouteResponse>(ctx, 'TransmissionRoutingService', 'DeleteTransmissionRoute', request, DeleteTransmissionRouteResponse())
  ;
  /// RejectTransmissionRoute rejects a route under engineering review, returning it to draft.
  $async.Future<RejectTransmissionRouteResponse> rejectTransmissionRoute($pb.ClientContext? ctx, RejectTransmissionRouteRequest request) =>
    _client.invoke<RejectTransmissionRouteResponse>(ctx, 'TransmissionRoutingService', 'RejectTransmissionRoute', request, RejectTransmissionRouteResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
