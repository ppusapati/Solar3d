//
//  Generated code. Do not modify.
//  source: layout/v1/layout.proto
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
import 'layout.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'layout.pbenum.dart';

/// ========== Review Metadata ==========
/// ReviewMetadata captures the acceptance workflow state attached to a layout.
/// Populated by the SubmitLayoutForReview / ApproveLayout / RejectLayout RPCs.
/// Consumed by PlanningWorkflow gate enforcement for the LayoutReady -> ElectricalReady transition.
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReviewMetadata', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
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

class Layout extends $pb.GeneratedMessage {
  factory Layout({
    $core.String? id,
    $core.String? projectId,
    $core.String? name,
    $core.int? totalPanels,
    $core.double? totalCapacityKw,
    $core.int? tileCount,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    ReviewMetadata? reviewMetadata,
    $core.String? candidateId,
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
    if (totalPanels != null) {
      $result.totalPanels = totalPanels;
    }
    if (totalCapacityKw != null) {
      $result.totalCapacityKw = totalCapacityKw;
    }
    if (tileCount != null) {
      $result.tileCount = tileCount;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    if (reviewMetadata != null) {
      $result.reviewMetadata = reviewMetadata;
    }
    if (candidateId != null) {
      $result.candidateId = candidateId;
    }
    return $result;
  }
  Layout._() : super();
  factory Layout.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Layout.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Layout', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'totalPanels', $pb.PbFieldType.O3)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'totalCapacityKw', $pb.PbFieldType.OD)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'tileCount', $pb.PbFieldType.O3)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..aOM<ReviewMetadata>(9, _omitFieldNames ? '' : 'reviewMetadata', subBuilder: ReviewMetadata.create)
    ..aOS(10, _omitFieldNames ? '' : 'candidateId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Layout clone() => Layout()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Layout copyWith(void Function(Layout) updates) => super.copyWith((message) => updates(message as Layout)) as Layout;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Layout create() => Layout._();
  Layout createEmptyInstance() => create();
  static $pb.PbList<Layout> createRepeated() => $pb.PbList<Layout>();
  @$core.pragma('dart2js:noInline')
  static Layout getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Layout>(create);
  static Layout? _defaultInstance;

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
  $core.int get totalPanels => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalPanels($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalPanels() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalPanels() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get totalCapacityKw => $_getN(4);
  @$pb.TagNumber(5)
  set totalCapacityKw($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalCapacityKw() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalCapacityKw() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get tileCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set tileCount($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTileCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearTileCount() => $_clearField(6);

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

  @$pb.TagNumber(9)
  ReviewMetadata get reviewMetadata => $_getN(8);
  @$pb.TagNumber(9)
  set reviewMetadata(ReviewMetadata v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasReviewMetadata() => $_has(8);
  @$pb.TagNumber(9)
  void clearReviewMetadata() => $_clearField(9);
  @$pb.TagNumber(9)
  ReviewMetadata ensureReviewMetadata() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get candidateId => $_getSZ(9);
  @$pb.TagNumber(10)
  set candidateId($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasCandidateId() => $_has(9);
  @$pb.TagNumber(10)
  void clearCandidateId() => $_clearField(10);
}

class Component extends $pb.GeneratedMessage {
  factory Component({
    $core.String? id,
    $core.String? layoutId,
    $core.String? assetId,
    ComponentType? componentType,
    Position? position,
    $core.double? rotation,
    $core.String? metadataJson,
    $0.Timestamp? createdAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (componentType != null) {
      $result.componentType = componentType;
    }
    if (position != null) {
      $result.position = position;
    }
    if (rotation != null) {
      $result.rotation = rotation;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  Component._() : super();
  factory Component.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Component.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Component', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..aOS(3, _omitFieldNames ? '' : 'assetId')
    ..e<ComponentType>(4, _omitFieldNames ? '' : 'componentType', $pb.PbFieldType.OE, defaultOrMaker: ComponentType.COMPONENT_TYPE_UNSPECIFIED, valueOf: ComponentType.valueOf, enumValues: ComponentType.values)
    ..aOM<Position>(5, _omitFieldNames ? '' : 'position', subBuilder: Position.create)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'rotation', $pb.PbFieldType.OD)
    ..aOS(7, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Component clone() => Component()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Component copyWith(void Function(Component) updates) => super.copyWith((message) => updates(message as Component)) as Component;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Component create() => Component._();
  Component createEmptyInstance() => create();
  static $pb.PbList<Component> createRepeated() => $pb.PbList<Component>();
  @$core.pragma('dart2js:noInline')
  static Component getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Component>(create);
  static Component? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get layoutId => $_getSZ(1);
  @$pb.TagNumber(2)
  set layoutId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayoutId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayoutId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  ComponentType get componentType => $_getN(3);
  @$pb.TagNumber(4)
  set componentType(ComponentType v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasComponentType() => $_has(3);
  @$pb.TagNumber(4)
  void clearComponentType() => $_clearField(4);

  @$pb.TagNumber(5)
  Position get position => $_getN(4);
  @$pb.TagNumber(5)
  set position(Position v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasPosition() => $_has(4);
  @$pb.TagNumber(5)
  void clearPosition() => $_clearField(5);
  @$pb.TagNumber(5)
  Position ensurePosition() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.double get rotation => $_getN(5);
  @$pb.TagNumber(6)
  set rotation($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRotation() => $_has(5);
  @$pb.TagNumber(6)
  void clearRotation() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get metadataJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set metadataJson($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMetadataJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearMetadataJson() => $_clearField(7);

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
}

class Position extends $pb.GeneratedMessage {
  factory Position({
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
  Position._() : super();
  factory Position.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Position.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Position', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'elevation', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Position clone() => Position()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Position copyWith(void Function(Position) updates) => super.copyWith((message) => updates(message as Position)) as Position;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Position create() => Position._();
  Position createEmptyInstance() => create();
  static $pb.PbList<Position> createRepeated() => $pb.PbList<Position>();
  @$core.pragma('dart2js:noInline')
  static Position getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Position>(create);
  static Position? _defaultInstance;

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

class LayoutTile extends $pb.GeneratedMessage {
  factory LayoutTile({
    $core.String? id,
    $core.String? layoutId,
    BoundingBox? bbox,
    $core.int? lodLevel,
    $core.int? panelCount,
    $core.String? metadataJson,
    $0.Timestamp? createdAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (bbox != null) {
      $result.bbox = bbox;
    }
    if (lodLevel != null) {
      $result.lodLevel = lodLevel;
    }
    if (panelCount != null) {
      $result.panelCount = panelCount;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  LayoutTile._() : super();
  factory LayoutTile.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LayoutTile.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LayoutTile', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..aOM<BoundingBox>(3, _omitFieldNames ? '' : 'bbox', subBuilder: BoundingBox.create)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'lodLevel', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'panelCount', $pb.PbFieldType.O3)
    ..aOS(6, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LayoutTile clone() => LayoutTile()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LayoutTile copyWith(void Function(LayoutTile) updates) => super.copyWith((message) => updates(message as LayoutTile)) as LayoutTile;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LayoutTile create() => LayoutTile._();
  LayoutTile createEmptyInstance() => create();
  static $pb.PbList<LayoutTile> createRepeated() => $pb.PbList<LayoutTile>();
  @$core.pragma('dart2js:noInline')
  static LayoutTile getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LayoutTile>(create);
  static LayoutTile? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get layoutId => $_getSZ(1);
  @$pb.TagNumber(2)
  set layoutId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayoutId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayoutId() => $_clearField(2);

  @$pb.TagNumber(3)
  BoundingBox get bbox => $_getN(2);
  @$pb.TagNumber(3)
  set bbox(BoundingBox v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBbox() => $_has(2);
  @$pb.TagNumber(3)
  void clearBbox() => $_clearField(3);
  @$pb.TagNumber(3)
  BoundingBox ensureBbox() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get lodLevel => $_getIZ(3);
  @$pb.TagNumber(4)
  set lodLevel($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLodLevel() => $_has(3);
  @$pb.TagNumber(4)
  void clearLodLevel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get panelCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set panelCount($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPanelCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearPanelCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get metadataJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set metadataJson($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMetadataJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearMetadataJson() => $_clearField(6);

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
}

class Panel extends $pb.GeneratedMessage {
  factory Panel({
    $core.String? id,
    $core.String? tileId,
    $core.String? stringId,
    $core.String? geometryGeojson,
    $core.double? tilt,
    $core.double? azimuth,
    $core.double? elevation,
    $core.String? metadataJson,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (tileId != null) {
      $result.tileId = tileId;
    }
    if (stringId != null) {
      $result.stringId = stringId;
    }
    if (geometryGeojson != null) {
      $result.geometryGeojson = geometryGeojson;
    }
    if (tilt != null) {
      $result.tilt = tilt;
    }
    if (azimuth != null) {
      $result.azimuth = azimuth;
    }
    if (elevation != null) {
      $result.elevation = elevation;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    return $result;
  }
  Panel._() : super();
  factory Panel.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Panel.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Panel', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'tileId')
    ..aOS(3, _omitFieldNames ? '' : 'stringId')
    ..aOS(4, _omitFieldNames ? '' : 'geometryGeojson')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'tilt', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'azimuth', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'elevation', $pb.PbFieldType.OD)
    ..aOS(8, _omitFieldNames ? '' : 'metadataJson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Panel clone() => Panel()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Panel copyWith(void Function(Panel) updates) => super.copyWith((message) => updates(message as Panel)) as Panel;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Panel create() => Panel._();
  Panel createEmptyInstance() => create();
  static $pb.PbList<Panel> createRepeated() => $pb.PbList<Panel>();
  @$core.pragma('dart2js:noInline')
  static Panel getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Panel>(create);
  static Panel? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get tileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set tileId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTileId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get stringId => $_getSZ(2);
  @$pb.TagNumber(3)
  set stringId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStringId() => $_has(2);
  @$pb.TagNumber(3)
  void clearStringId() => $_clearField(3);

  /// GeoJSON polygon
  @$pb.TagNumber(4)
  $core.String get geometryGeojson => $_getSZ(3);
  @$pb.TagNumber(4)
  set geometryGeojson($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasGeometryGeojson() => $_has(3);
  @$pb.TagNumber(4)
  void clearGeometryGeojson() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get tilt => $_getN(4);
  @$pb.TagNumber(5)
  set tilt($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTilt() => $_has(4);
  @$pb.TagNumber(5)
  void clearTilt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get azimuth => $_getN(5);
  @$pb.TagNumber(6)
  set azimuth($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAzimuth() => $_has(5);
  @$pb.TagNumber(6)
  void clearAzimuth() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get elevation => $_getN(6);
  @$pb.TagNumber(7)
  set elevation($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasElevation() => $_has(6);
  @$pb.TagNumber(7)
  void clearElevation() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get metadataJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set metadataJson($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMetadataJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearMetadataJson() => $_clearField(8);
}

class BoundingBox extends $pb.GeneratedMessage {
  factory BoundingBox({
    $core.double? minX,
    $core.double? minY,
    $core.double? maxX,
    $core.double? maxY,
  }) {
    final $result = create();
    if (minX != null) {
      $result.minX = minX;
    }
    if (minY != null) {
      $result.minY = minY;
    }
    if (maxX != null) {
      $result.maxX = maxX;
    }
    if (maxY != null) {
      $result.maxY = maxY;
    }
    return $result;
  }
  BoundingBox._() : super();
  factory BoundingBox.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BoundingBox.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BoundingBox', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'minX', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'minY', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'maxX', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'maxY', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BoundingBox clone() => BoundingBox()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BoundingBox copyWith(void Function(BoundingBox) updates) => super.copyWith((message) => updates(message as BoundingBox)) as BoundingBox;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BoundingBox create() => BoundingBox._();
  BoundingBox createEmptyInstance() => create();
  static $pb.PbList<BoundingBox> createRepeated() => $pb.PbList<BoundingBox>();
  @$core.pragma('dart2js:noInline')
  static BoundingBox getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BoundingBox>(create);
  static BoundingBox? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get minX => $_getN(0);
  @$pb.TagNumber(1)
  set minX($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMinX() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get minY => $_getN(1);
  @$pb.TagNumber(2)
  set minY($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMinY() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinY() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get maxX => $_getN(2);
  @$pb.TagNumber(3)
  set maxX($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxX() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxX() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get maxY => $_getN(3);
  @$pb.TagNumber(4)
  set maxY($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMaxY() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxY() => $_clearField(4);
}

/// ========== Acceptance Request/Response Messages ==========
class SubmitLayoutForReviewRequest extends $pb.GeneratedMessage {
  factory SubmitLayoutForReviewRequest({
    $core.String? layoutId,
    $core.String? submissionReason,
    $core.String? submittedByActorId,
  }) {
    final $result = create();
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (submissionReason != null) {
      $result.submissionReason = submissionReason;
    }
    if (submittedByActorId != null) {
      $result.submittedByActorId = submittedByActorId;
    }
    return $result;
  }
  SubmitLayoutForReviewRequest._() : super();
  factory SubmitLayoutForReviewRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitLayoutForReviewRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitLayoutForReviewRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'layoutId')
    ..aOS(2, _omitFieldNames ? '' : 'submissionReason')
    ..aOS(3, _omitFieldNames ? '' : 'submittedByActorId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitLayoutForReviewRequest clone() => SubmitLayoutForReviewRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitLayoutForReviewRequest copyWith(void Function(SubmitLayoutForReviewRequest) updates) => super.copyWith((message) => updates(message as SubmitLayoutForReviewRequest)) as SubmitLayoutForReviewRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitLayoutForReviewRequest create() => SubmitLayoutForReviewRequest._();
  SubmitLayoutForReviewRequest createEmptyInstance() => create();
  static $pb.PbList<SubmitLayoutForReviewRequest> createRepeated() => $pb.PbList<SubmitLayoutForReviewRequest>();
  @$core.pragma('dart2js:noInline')
  static SubmitLayoutForReviewRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitLayoutForReviewRequest>(create);
  static SubmitLayoutForReviewRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layoutId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayoutId() => $_clearField(1);

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

class SubmitLayoutForReviewResponse extends $pb.GeneratedMessage {
  factory SubmitLayoutForReviewResponse({
    Layout? layout,
    ReviewMetadata? reviewMetadata,
  }) {
    final $result = create();
    if (layout != null) {
      $result.layout = layout;
    }
    if (reviewMetadata != null) {
      $result.reviewMetadata = reviewMetadata;
    }
    return $result;
  }
  SubmitLayoutForReviewResponse._() : super();
  factory SubmitLayoutForReviewResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitLayoutForReviewResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitLayoutForReviewResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOM<Layout>(1, _omitFieldNames ? '' : 'layout', subBuilder: Layout.create)
    ..aOM<ReviewMetadata>(2, _omitFieldNames ? '' : 'reviewMetadata', subBuilder: ReviewMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitLayoutForReviewResponse clone() => SubmitLayoutForReviewResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitLayoutForReviewResponse copyWith(void Function(SubmitLayoutForReviewResponse) updates) => super.copyWith((message) => updates(message as SubmitLayoutForReviewResponse)) as SubmitLayoutForReviewResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitLayoutForReviewResponse create() => SubmitLayoutForReviewResponse._();
  SubmitLayoutForReviewResponse createEmptyInstance() => create();
  static $pb.PbList<SubmitLayoutForReviewResponse> createRepeated() => $pb.PbList<SubmitLayoutForReviewResponse>();
  @$core.pragma('dart2js:noInline')
  static SubmitLayoutForReviewResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitLayoutForReviewResponse>(create);
  static SubmitLayoutForReviewResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Layout get layout => $_getN(0);
  @$pb.TagNumber(1)
  set layout(Layout v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayout() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayout() => $_clearField(1);
  @$pb.TagNumber(1)
  Layout ensureLayout() => $_ensure(0);

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

class ApproveLayoutRequest extends $pb.GeneratedMessage {
  factory ApproveLayoutRequest({
    $core.String? layoutId,
    $core.double? qualityScore,
    $core.Iterable<$core.String>? approvalComments,
    $core.String? approvedByActorId,
  }) {
    final $result = create();
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (qualityScore != null) {
      $result.qualityScore = qualityScore;
    }
    if (approvalComments != null) {
      $result.approvalComments.addAll(approvalComments);
    }
    if (approvedByActorId != null) {
      $result.approvedByActorId = approvedByActorId;
    }
    return $result;
  }
  ApproveLayoutRequest._() : super();
  factory ApproveLayoutRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApproveLayoutRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApproveLayoutRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'layoutId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'qualityScore', $pb.PbFieldType.OD)
    ..pPS(3, _omitFieldNames ? '' : 'approvalComments')
    ..aOS(4, _omitFieldNames ? '' : 'approvedByActorId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApproveLayoutRequest clone() => ApproveLayoutRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApproveLayoutRequest copyWith(void Function(ApproveLayoutRequest) updates) => super.copyWith((message) => updates(message as ApproveLayoutRequest)) as ApproveLayoutRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveLayoutRequest create() => ApproveLayoutRequest._();
  ApproveLayoutRequest createEmptyInstance() => create();
  static $pb.PbList<ApproveLayoutRequest> createRepeated() => $pb.PbList<ApproveLayoutRequest>();
  @$core.pragma('dart2js:noInline')
  static ApproveLayoutRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproveLayoutRequest>(create);
  static ApproveLayoutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layoutId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayoutId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get qualityScore => $_getN(1);
  @$pb.TagNumber(2)
  set qualityScore($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasQualityScore() => $_has(1);
  @$pb.TagNumber(2)
  void clearQualityScore() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get approvalComments => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get approvedByActorId => $_getSZ(3);
  @$pb.TagNumber(4)
  set approvedByActorId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasApprovedByActorId() => $_has(3);
  @$pb.TagNumber(4)
  void clearApprovedByActorId() => $_clearField(4);
}

class ApproveLayoutResponse extends $pb.GeneratedMessage {
  factory ApproveLayoutResponse({
    Layout? layout,
    ReviewMetadata? reviewMetadata,
  }) {
    final $result = create();
    if (layout != null) {
      $result.layout = layout;
    }
    if (reviewMetadata != null) {
      $result.reviewMetadata = reviewMetadata;
    }
    return $result;
  }
  ApproveLayoutResponse._() : super();
  factory ApproveLayoutResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApproveLayoutResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApproveLayoutResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOM<Layout>(1, _omitFieldNames ? '' : 'layout', subBuilder: Layout.create)
    ..aOM<ReviewMetadata>(2, _omitFieldNames ? '' : 'reviewMetadata', subBuilder: ReviewMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApproveLayoutResponse clone() => ApproveLayoutResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApproveLayoutResponse copyWith(void Function(ApproveLayoutResponse) updates) => super.copyWith((message) => updates(message as ApproveLayoutResponse)) as ApproveLayoutResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApproveLayoutResponse create() => ApproveLayoutResponse._();
  ApproveLayoutResponse createEmptyInstance() => create();
  static $pb.PbList<ApproveLayoutResponse> createRepeated() => $pb.PbList<ApproveLayoutResponse>();
  @$core.pragma('dart2js:noInline')
  static ApproveLayoutResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApproveLayoutResponse>(create);
  static ApproveLayoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Layout get layout => $_getN(0);
  @$pb.TagNumber(1)
  set layout(Layout v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayout() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayout() => $_clearField(1);
  @$pb.TagNumber(1)
  Layout ensureLayout() => $_ensure(0);

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

class RejectLayoutRequest extends $pb.GeneratedMessage {
  factory RejectLayoutRequest({
    $core.String? layoutId,
    $core.Iterable<$core.String>? rejectionReasons,
    $core.String? rejectedByActorId,
  }) {
    final $result = create();
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (rejectionReasons != null) {
      $result.rejectionReasons.addAll(rejectionReasons);
    }
    if (rejectedByActorId != null) {
      $result.rejectedByActorId = rejectedByActorId;
    }
    return $result;
  }
  RejectLayoutRequest._() : super();
  factory RejectLayoutRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RejectLayoutRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RejectLayoutRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'layoutId')
    ..pPS(2, _omitFieldNames ? '' : 'rejectionReasons')
    ..aOS(3, _omitFieldNames ? '' : 'rejectedByActorId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RejectLayoutRequest clone() => RejectLayoutRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RejectLayoutRequest copyWith(void Function(RejectLayoutRequest) updates) => super.copyWith((message) => updates(message as RejectLayoutRequest)) as RejectLayoutRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectLayoutRequest create() => RejectLayoutRequest._();
  RejectLayoutRequest createEmptyInstance() => create();
  static $pb.PbList<RejectLayoutRequest> createRepeated() => $pb.PbList<RejectLayoutRequest>();
  @$core.pragma('dart2js:noInline')
  static RejectLayoutRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RejectLayoutRequest>(create);
  static RejectLayoutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layoutId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayoutId() => $_clearField(1);

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

class RejectLayoutResponse extends $pb.GeneratedMessage {
  factory RejectLayoutResponse({
    Layout? layout,
    ReviewMetadata? reviewMetadata,
  }) {
    final $result = create();
    if (layout != null) {
      $result.layout = layout;
    }
    if (reviewMetadata != null) {
      $result.reviewMetadata = reviewMetadata;
    }
    return $result;
  }
  RejectLayoutResponse._() : super();
  factory RejectLayoutResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RejectLayoutResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RejectLayoutResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOM<Layout>(1, _omitFieldNames ? '' : 'layout', subBuilder: Layout.create)
    ..aOM<ReviewMetadata>(2, _omitFieldNames ? '' : 'reviewMetadata', subBuilder: ReviewMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RejectLayoutResponse clone() => RejectLayoutResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RejectLayoutResponse copyWith(void Function(RejectLayoutResponse) updates) => super.copyWith((message) => updates(message as RejectLayoutResponse)) as RejectLayoutResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectLayoutResponse create() => RejectLayoutResponse._();
  RejectLayoutResponse createEmptyInstance() => create();
  static $pb.PbList<RejectLayoutResponse> createRepeated() => $pb.PbList<RejectLayoutResponse>();
  @$core.pragma('dart2js:noInline')
  static RejectLayoutResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RejectLayoutResponse>(create);
  static RejectLayoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Layout get layout => $_getN(0);
  @$pb.TagNumber(1)
  set layout(Layout v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayout() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayout() => $_clearField(1);
  @$pb.TagNumber(1)
  Layout ensureLayout() => $_ensure(0);

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

class PanelArrayParams extends $pb.GeneratedMessage {
  factory PanelArrayParams({
    $core.double? panelWidth,
    $core.double? panelHeight,
    $core.double? tiltAngle,
    $core.double? azimuth,
    $core.double? rowSpacing,
    $core.double? columnSpacing,
    $core.String? fillAreaGeojson,
    $core.String? terrainLayerId,
  }) {
    final $result = create();
    if (panelWidth != null) {
      $result.panelWidth = panelWidth;
    }
    if (panelHeight != null) {
      $result.panelHeight = panelHeight;
    }
    if (tiltAngle != null) {
      $result.tiltAngle = tiltAngle;
    }
    if (azimuth != null) {
      $result.azimuth = azimuth;
    }
    if (rowSpacing != null) {
      $result.rowSpacing = rowSpacing;
    }
    if (columnSpacing != null) {
      $result.columnSpacing = columnSpacing;
    }
    if (fillAreaGeojson != null) {
      $result.fillAreaGeojson = fillAreaGeojson;
    }
    if (terrainLayerId != null) {
      $result.terrainLayerId = terrainLayerId;
    }
    return $result;
  }
  PanelArrayParams._() : super();
  factory PanelArrayParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PanelArrayParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PanelArrayParams', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'panelWidth', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'panelHeight', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'tiltAngle', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'azimuth', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'rowSpacing', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'columnSpacing', $pb.PbFieldType.OD)
    ..aOS(7, _omitFieldNames ? '' : 'fillAreaGeojson')
    ..aOS(8, _omitFieldNames ? '' : 'terrainLayerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PanelArrayParams clone() => PanelArrayParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PanelArrayParams copyWith(void Function(PanelArrayParams) updates) => super.copyWith((message) => updates(message as PanelArrayParams)) as PanelArrayParams;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PanelArrayParams create() => PanelArrayParams._();
  PanelArrayParams createEmptyInstance() => create();
  static $pb.PbList<PanelArrayParams> createRepeated() => $pb.PbList<PanelArrayParams>();
  @$core.pragma('dart2js:noInline')
  static PanelArrayParams getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PanelArrayParams>(create);
  static PanelArrayParams? _defaultInstance;

  /// Panel dimensions in meters
  @$pb.TagNumber(1)
  $core.double get panelWidth => $_getN(0);
  @$pb.TagNumber(1)
  set panelWidth($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPanelWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearPanelWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get panelHeight => $_getN(1);
  @$pb.TagNumber(2)
  set panelHeight($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPanelHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearPanelHeight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get tiltAngle => $_getN(2);
  @$pb.TagNumber(3)
  set tiltAngle($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTiltAngle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTiltAngle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get azimuth => $_getN(3);
  @$pb.TagNumber(4)
  set azimuth($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAzimuth() => $_has(3);
  @$pb.TagNumber(4)
  void clearAzimuth() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get rowSpacing => $_getN(4);
  @$pb.TagNumber(5)
  set rowSpacing($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRowSpacing() => $_has(4);
  @$pb.TagNumber(5)
  void clearRowSpacing() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get columnSpacing => $_getN(5);
  @$pb.TagNumber(6)
  set columnSpacing($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasColumnSpacing() => $_has(5);
  @$pb.TagNumber(6)
  void clearColumnSpacing() => $_clearField(6);

  /// GeoJSON polygon for the fill area
  @$pb.TagNumber(7)
  $core.String get fillAreaGeojson => $_getSZ(6);
  @$pb.TagNumber(7)
  set fillAreaGeojson($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasFillAreaGeojson() => $_has(6);
  @$pb.TagNumber(7)
  void clearFillAreaGeojson() => $_clearField(7);

  /// Optional terrain layer for alignment
  @$pb.TagNumber(8)
  $core.String get terrainLayerId => $_getSZ(7);
  @$pb.TagNumber(8)
  set terrainLayerId($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTerrainLayerId() => $_has(7);
  @$pb.TagNumber(8)
  void clearTerrainLayerId() => $_clearField(8);
}

class CreateLayoutRequest extends $pb.GeneratedMessage {
  factory CreateLayoutRequest({
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
  CreateLayoutRequest._() : super();
  factory CreateLayoutRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateLayoutRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateLayoutRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateLayoutRequest clone() => CreateLayoutRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateLayoutRequest copyWith(void Function(CreateLayoutRequest) updates) => super.copyWith((message) => updates(message as CreateLayoutRequest)) as CreateLayoutRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateLayoutRequest create() => CreateLayoutRequest._();
  CreateLayoutRequest createEmptyInstance() => create();
  static $pb.PbList<CreateLayoutRequest> createRepeated() => $pb.PbList<CreateLayoutRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateLayoutRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateLayoutRequest>(create);
  static CreateLayoutRequest? _defaultInstance;

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

class CreateLayoutResponse extends $pb.GeneratedMessage {
  factory CreateLayoutResponse({
    Layout? layout,
  }) {
    final $result = create();
    if (layout != null) {
      $result.layout = layout;
    }
    return $result;
  }
  CreateLayoutResponse._() : super();
  factory CreateLayoutResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateLayoutResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateLayoutResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOM<Layout>(1, _omitFieldNames ? '' : 'layout', subBuilder: Layout.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateLayoutResponse clone() => CreateLayoutResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateLayoutResponse copyWith(void Function(CreateLayoutResponse) updates) => super.copyWith((message) => updates(message as CreateLayoutResponse)) as CreateLayoutResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateLayoutResponse create() => CreateLayoutResponse._();
  CreateLayoutResponse createEmptyInstance() => create();
  static $pb.PbList<CreateLayoutResponse> createRepeated() => $pb.PbList<CreateLayoutResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateLayoutResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateLayoutResponse>(create);
  static CreateLayoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Layout get layout => $_getN(0);
  @$pb.TagNumber(1)
  set layout(Layout v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayout() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayout() => $_clearField(1);
  @$pb.TagNumber(1)
  Layout ensureLayout() => $_ensure(0);
}

class GetLayoutRequest extends $pb.GeneratedMessage {
  factory GetLayoutRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetLayoutRequest._() : super();
  factory GetLayoutRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetLayoutRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetLayoutRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetLayoutRequest clone() => GetLayoutRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetLayoutRequest copyWith(void Function(GetLayoutRequest) updates) => super.copyWith((message) => updates(message as GetLayoutRequest)) as GetLayoutRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLayoutRequest create() => GetLayoutRequest._();
  GetLayoutRequest createEmptyInstance() => create();
  static $pb.PbList<GetLayoutRequest> createRepeated() => $pb.PbList<GetLayoutRequest>();
  @$core.pragma('dart2js:noInline')
  static GetLayoutRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLayoutRequest>(create);
  static GetLayoutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetLayoutResponse extends $pb.GeneratedMessage {
  factory GetLayoutResponse({
    Layout? layout,
  }) {
    final $result = create();
    if (layout != null) {
      $result.layout = layout;
    }
    return $result;
  }
  GetLayoutResponse._() : super();
  factory GetLayoutResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetLayoutResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetLayoutResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOM<Layout>(1, _omitFieldNames ? '' : 'layout', subBuilder: Layout.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetLayoutResponse clone() => GetLayoutResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetLayoutResponse copyWith(void Function(GetLayoutResponse) updates) => super.copyWith((message) => updates(message as GetLayoutResponse)) as GetLayoutResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLayoutResponse create() => GetLayoutResponse._();
  GetLayoutResponse createEmptyInstance() => create();
  static $pb.PbList<GetLayoutResponse> createRepeated() => $pb.PbList<GetLayoutResponse>();
  @$core.pragma('dart2js:noInline')
  static GetLayoutResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLayoutResponse>(create);
  static GetLayoutResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Layout get layout => $_getN(0);
  @$pb.TagNumber(1)
  set layout(Layout v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayout() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayout() => $_clearField(1);
  @$pb.TagNumber(1)
  Layout ensureLayout() => $_ensure(0);
}

class ListLayoutsRequest extends $pb.GeneratedMessage {
  factory ListLayoutsRequest({
    $core.String? projectId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    return $result;
  }
  ListLayoutsRequest._() : super();
  factory ListLayoutsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListLayoutsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListLayoutsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListLayoutsRequest clone() => ListLayoutsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListLayoutsRequest copyWith(void Function(ListLayoutsRequest) updates) => super.copyWith((message) => updates(message as ListLayoutsRequest)) as ListLayoutsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLayoutsRequest create() => ListLayoutsRequest._();
  ListLayoutsRequest createEmptyInstance() => create();
  static $pb.PbList<ListLayoutsRequest> createRepeated() => $pb.PbList<ListLayoutsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListLayoutsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListLayoutsRequest>(create);
  static ListLayoutsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);
}

class ListLayoutsResponse extends $pb.GeneratedMessage {
  factory ListLayoutsResponse({
    $core.Iterable<Layout>? layouts,
  }) {
    final $result = create();
    if (layouts != null) {
      $result.layouts.addAll(layouts);
    }
    return $result;
  }
  ListLayoutsResponse._() : super();
  factory ListLayoutsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListLayoutsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListLayoutsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..pc<Layout>(1, _omitFieldNames ? '' : 'layouts', $pb.PbFieldType.PM, subBuilder: Layout.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListLayoutsResponse clone() => ListLayoutsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListLayoutsResponse copyWith(void Function(ListLayoutsResponse) updates) => super.copyWith((message) => updates(message as ListLayoutsResponse)) as ListLayoutsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListLayoutsResponse create() => ListLayoutsResponse._();
  ListLayoutsResponse createEmptyInstance() => create();
  static $pb.PbList<ListLayoutsResponse> createRepeated() => $pb.PbList<ListLayoutsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListLayoutsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListLayoutsResponse>(create);
  static ListLayoutsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Layout> get layouts => $_getList(0);
}

class DeleteLayoutRequest extends $pb.GeneratedMessage {
  factory DeleteLayoutRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteLayoutRequest._() : super();
  factory DeleteLayoutRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteLayoutRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteLayoutRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteLayoutRequest clone() => DeleteLayoutRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteLayoutRequest copyWith(void Function(DeleteLayoutRequest) updates) => super.copyWith((message) => updates(message as DeleteLayoutRequest)) as DeleteLayoutRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteLayoutRequest create() => DeleteLayoutRequest._();
  DeleteLayoutRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteLayoutRequest> createRepeated() => $pb.PbList<DeleteLayoutRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteLayoutRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteLayoutRequest>(create);
  static DeleteLayoutRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteLayoutResponse extends $pb.GeneratedMessage {
  factory DeleteLayoutResponse() => create();
  DeleteLayoutResponse._() : super();
  factory DeleteLayoutResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteLayoutResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteLayoutResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteLayoutResponse clone() => DeleteLayoutResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteLayoutResponse copyWith(void Function(DeleteLayoutResponse) updates) => super.copyWith((message) => updates(message as DeleteLayoutResponse)) as DeleteLayoutResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteLayoutResponse create() => DeleteLayoutResponse._();
  DeleteLayoutResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteLayoutResponse> createRepeated() => $pb.PbList<DeleteLayoutResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteLayoutResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteLayoutResponse>(create);
  static DeleteLayoutResponse? _defaultInstance;
}

class PlaceComponentRequest extends $pb.GeneratedMessage {
  factory PlaceComponentRequest({
    $core.String? layoutId,
    $core.String? assetId,
    ComponentType? componentType,
    Position? position,
    $core.double? rotation,
    $core.String? metadataJson,
  }) {
    final $result = create();
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (assetId != null) {
      $result.assetId = assetId;
    }
    if (componentType != null) {
      $result.componentType = componentType;
    }
    if (position != null) {
      $result.position = position;
    }
    if (rotation != null) {
      $result.rotation = rotation;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    return $result;
  }
  PlaceComponentRequest._() : super();
  factory PlaceComponentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlaceComponentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PlaceComponentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'layoutId')
    ..aOS(2, _omitFieldNames ? '' : 'assetId')
    ..e<ComponentType>(3, _omitFieldNames ? '' : 'componentType', $pb.PbFieldType.OE, defaultOrMaker: ComponentType.COMPONENT_TYPE_UNSPECIFIED, valueOf: ComponentType.valueOf, enumValues: ComponentType.values)
    ..aOM<Position>(4, _omitFieldNames ? '' : 'position', subBuilder: Position.create)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'rotation', $pb.PbFieldType.OD)
    ..aOS(6, _omitFieldNames ? '' : 'metadataJson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlaceComponentRequest clone() => PlaceComponentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlaceComponentRequest copyWith(void Function(PlaceComponentRequest) updates) => super.copyWith((message) => updates(message as PlaceComponentRequest)) as PlaceComponentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceComponentRequest create() => PlaceComponentRequest._();
  PlaceComponentRequest createEmptyInstance() => create();
  static $pb.PbList<PlaceComponentRequest> createRepeated() => $pb.PbList<PlaceComponentRequest>();
  @$core.pragma('dart2js:noInline')
  static PlaceComponentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlaceComponentRequest>(create);
  static PlaceComponentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layoutId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayoutId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get assetId => $_getSZ(1);
  @$pb.TagNumber(2)
  set assetId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAssetId() => $_has(1);
  @$pb.TagNumber(2)
  void clearAssetId() => $_clearField(2);

  @$pb.TagNumber(3)
  ComponentType get componentType => $_getN(2);
  @$pb.TagNumber(3)
  set componentType(ComponentType v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasComponentType() => $_has(2);
  @$pb.TagNumber(3)
  void clearComponentType() => $_clearField(3);

  @$pb.TagNumber(4)
  Position get position => $_getN(3);
  @$pb.TagNumber(4)
  set position(Position v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPosition() => $_has(3);
  @$pb.TagNumber(4)
  void clearPosition() => $_clearField(4);
  @$pb.TagNumber(4)
  Position ensurePosition() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.double get rotation => $_getN(4);
  @$pb.TagNumber(5)
  set rotation($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRotation() => $_has(4);
  @$pb.TagNumber(5)
  void clearRotation() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get metadataJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set metadataJson($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMetadataJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearMetadataJson() => $_clearField(6);
}

class PlaceComponentResponse extends $pb.GeneratedMessage {
  factory PlaceComponentResponse({
    Component? component,
  }) {
    final $result = create();
    if (component != null) {
      $result.component = component;
    }
    return $result;
  }
  PlaceComponentResponse._() : super();
  factory PlaceComponentResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlaceComponentResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PlaceComponentResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOM<Component>(1, _omitFieldNames ? '' : 'component', subBuilder: Component.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlaceComponentResponse clone() => PlaceComponentResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlaceComponentResponse copyWith(void Function(PlaceComponentResponse) updates) => super.copyWith((message) => updates(message as PlaceComponentResponse)) as PlaceComponentResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlaceComponentResponse create() => PlaceComponentResponse._();
  PlaceComponentResponse createEmptyInstance() => create();
  static $pb.PbList<PlaceComponentResponse> createRepeated() => $pb.PbList<PlaceComponentResponse>();
  @$core.pragma('dart2js:noInline')
  static PlaceComponentResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlaceComponentResponse>(create);
  static PlaceComponentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Component get component => $_getN(0);
  @$pb.TagNumber(1)
  set component(Component v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasComponent() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponent() => $_clearField(1);
  @$pb.TagNumber(1)
  Component ensureComponent() => $_ensure(0);
}

class MoveComponentRequest extends $pb.GeneratedMessage {
  factory MoveComponentRequest({
    $core.String? componentId,
    Position? position,
    $core.double? rotation,
  }) {
    final $result = create();
    if (componentId != null) {
      $result.componentId = componentId;
    }
    if (position != null) {
      $result.position = position;
    }
    if (rotation != null) {
      $result.rotation = rotation;
    }
    return $result;
  }
  MoveComponentRequest._() : super();
  factory MoveComponentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MoveComponentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MoveComponentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'componentId')
    ..aOM<Position>(2, _omitFieldNames ? '' : 'position', subBuilder: Position.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'rotation', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MoveComponentRequest clone() => MoveComponentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MoveComponentRequest copyWith(void Function(MoveComponentRequest) updates) => super.copyWith((message) => updates(message as MoveComponentRequest)) as MoveComponentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveComponentRequest create() => MoveComponentRequest._();
  MoveComponentRequest createEmptyInstance() => create();
  static $pb.PbList<MoveComponentRequest> createRepeated() => $pb.PbList<MoveComponentRequest>();
  @$core.pragma('dart2js:noInline')
  static MoveComponentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MoveComponentRequest>(create);
  static MoveComponentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get componentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set componentId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasComponentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponentId() => $_clearField(1);

  @$pb.TagNumber(2)
  Position get position => $_getN(1);
  @$pb.TagNumber(2)
  set position(Position v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearPosition() => $_clearField(2);
  @$pb.TagNumber(2)
  Position ensurePosition() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get rotation => $_getN(2);
  @$pb.TagNumber(3)
  set rotation($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRotation() => $_has(2);
  @$pb.TagNumber(3)
  void clearRotation() => $_clearField(3);
}

class MoveComponentResponse extends $pb.GeneratedMessage {
  factory MoveComponentResponse({
    Component? component,
  }) {
    final $result = create();
    if (component != null) {
      $result.component = component;
    }
    return $result;
  }
  MoveComponentResponse._() : super();
  factory MoveComponentResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MoveComponentResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MoveComponentResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOM<Component>(1, _omitFieldNames ? '' : 'component', subBuilder: Component.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MoveComponentResponse clone() => MoveComponentResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MoveComponentResponse copyWith(void Function(MoveComponentResponse) updates) => super.copyWith((message) => updates(message as MoveComponentResponse)) as MoveComponentResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MoveComponentResponse create() => MoveComponentResponse._();
  MoveComponentResponse createEmptyInstance() => create();
  static $pb.PbList<MoveComponentResponse> createRepeated() => $pb.PbList<MoveComponentResponse>();
  @$core.pragma('dart2js:noInline')
  static MoveComponentResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MoveComponentResponse>(create);
  static MoveComponentResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Component get component => $_getN(0);
  @$pb.TagNumber(1)
  set component(Component v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasComponent() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponent() => $_clearField(1);
  @$pb.TagNumber(1)
  Component ensureComponent() => $_ensure(0);
}

class RemoveComponentRequest extends $pb.GeneratedMessage {
  factory RemoveComponentRequest({
    $core.String? componentId,
  }) {
    final $result = create();
    if (componentId != null) {
      $result.componentId = componentId;
    }
    return $result;
  }
  RemoveComponentRequest._() : super();
  factory RemoveComponentRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveComponentRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveComponentRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'componentId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveComponentRequest clone() => RemoveComponentRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveComponentRequest copyWith(void Function(RemoveComponentRequest) updates) => super.copyWith((message) => updates(message as RemoveComponentRequest)) as RemoveComponentRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveComponentRequest create() => RemoveComponentRequest._();
  RemoveComponentRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveComponentRequest> createRepeated() => $pb.PbList<RemoveComponentRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveComponentRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveComponentRequest>(create);
  static RemoveComponentRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get componentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set componentId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasComponentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearComponentId() => $_clearField(1);
}

class RemoveComponentResponse extends $pb.GeneratedMessage {
  factory RemoveComponentResponse() => create();
  RemoveComponentResponse._() : super();
  factory RemoveComponentResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveComponentResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveComponentResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveComponentResponse clone() => RemoveComponentResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveComponentResponse copyWith(void Function(RemoveComponentResponse) updates) => super.copyWith((message) => updates(message as RemoveComponentResponse)) as RemoveComponentResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveComponentResponse create() => RemoveComponentResponse._();
  RemoveComponentResponse createEmptyInstance() => create();
  static $pb.PbList<RemoveComponentResponse> createRepeated() => $pb.PbList<RemoveComponentResponse>();
  @$core.pragma('dart2js:noInline')
  static RemoveComponentResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveComponentResponse>(create);
  static RemoveComponentResponse? _defaultInstance;
}

class ListComponentsRequest extends $pb.GeneratedMessage {
  factory ListComponentsRequest({
    $core.String? layoutId,
    ComponentType? typeFilter,
  }) {
    final $result = create();
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (typeFilter != null) {
      $result.typeFilter = typeFilter;
    }
    return $result;
  }
  ListComponentsRequest._() : super();
  factory ListComponentsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListComponentsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListComponentsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'layoutId')
    ..e<ComponentType>(2, _omitFieldNames ? '' : 'typeFilter', $pb.PbFieldType.OE, defaultOrMaker: ComponentType.COMPONENT_TYPE_UNSPECIFIED, valueOf: ComponentType.valueOf, enumValues: ComponentType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListComponentsRequest clone() => ListComponentsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListComponentsRequest copyWith(void Function(ListComponentsRequest) updates) => super.copyWith((message) => updates(message as ListComponentsRequest)) as ListComponentsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListComponentsRequest create() => ListComponentsRequest._();
  ListComponentsRequest createEmptyInstance() => create();
  static $pb.PbList<ListComponentsRequest> createRepeated() => $pb.PbList<ListComponentsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListComponentsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListComponentsRequest>(create);
  static ListComponentsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layoutId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayoutId() => $_clearField(1);

  @$pb.TagNumber(2)
  ComponentType get typeFilter => $_getN(1);
  @$pb.TagNumber(2)
  set typeFilter(ComponentType v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTypeFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearTypeFilter() => $_clearField(2);
}

class ListComponentsResponse extends $pb.GeneratedMessage {
  factory ListComponentsResponse({
    $core.Iterable<Component>? components,
  }) {
    final $result = create();
    if (components != null) {
      $result.components.addAll(components);
    }
    return $result;
  }
  ListComponentsResponse._() : super();
  factory ListComponentsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListComponentsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListComponentsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..pc<Component>(1, _omitFieldNames ? '' : 'components', $pb.PbFieldType.PM, subBuilder: Component.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListComponentsResponse clone() => ListComponentsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListComponentsResponse copyWith(void Function(ListComponentsResponse) updates) => super.copyWith((message) => updates(message as ListComponentsResponse)) as ListComponentsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListComponentsResponse create() => ListComponentsResponse._();
  ListComponentsResponse createEmptyInstance() => create();
  static $pb.PbList<ListComponentsResponse> createRepeated() => $pb.PbList<ListComponentsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListComponentsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListComponentsResponse>(create);
  static ListComponentsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Component> get components => $_getList(0);
}

class GeneratePanelArrayRequest extends $pb.GeneratedMessage {
  factory GeneratePanelArrayRequest({
    $core.String? layoutId,
    PanelArrayParams? params,
  }) {
    final $result = create();
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (params != null) {
      $result.params = params;
    }
    return $result;
  }
  GeneratePanelArrayRequest._() : super();
  factory GeneratePanelArrayRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GeneratePanelArrayRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GeneratePanelArrayRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'layoutId')
    ..aOM<PanelArrayParams>(2, _omitFieldNames ? '' : 'params', subBuilder: PanelArrayParams.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GeneratePanelArrayRequest clone() => GeneratePanelArrayRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GeneratePanelArrayRequest copyWith(void Function(GeneratePanelArrayRequest) updates) => super.copyWith((message) => updates(message as GeneratePanelArrayRequest)) as GeneratePanelArrayRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GeneratePanelArrayRequest create() => GeneratePanelArrayRequest._();
  GeneratePanelArrayRequest createEmptyInstance() => create();
  static $pb.PbList<GeneratePanelArrayRequest> createRepeated() => $pb.PbList<GeneratePanelArrayRequest>();
  @$core.pragma('dart2js:noInline')
  static GeneratePanelArrayRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeneratePanelArrayRequest>(create);
  static GeneratePanelArrayRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layoutId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayoutId() => $_clearField(1);

  @$pb.TagNumber(2)
  PanelArrayParams get params => $_getN(1);
  @$pb.TagNumber(2)
  set params(PanelArrayParams v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasParams() => $_has(1);
  @$pb.TagNumber(2)
  void clearParams() => $_clearField(2);
  @$pb.TagNumber(2)
  PanelArrayParams ensureParams() => $_ensure(1);
}

class GeneratePanelArrayResponse extends $pb.GeneratedMessage {
  factory GeneratePanelArrayResponse({
    $core.int? panelsCreated,
    $core.int? tilesCreated,
    $core.double? capacityKw,
  }) {
    final $result = create();
    if (panelsCreated != null) {
      $result.panelsCreated = panelsCreated;
    }
    if (tilesCreated != null) {
      $result.tilesCreated = tilesCreated;
    }
    if (capacityKw != null) {
      $result.capacityKw = capacityKw;
    }
    return $result;
  }
  GeneratePanelArrayResponse._() : super();
  factory GeneratePanelArrayResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GeneratePanelArrayResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GeneratePanelArrayResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'panelsCreated', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'tilesCreated', $pb.PbFieldType.O3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'capacityKw', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GeneratePanelArrayResponse clone() => GeneratePanelArrayResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GeneratePanelArrayResponse copyWith(void Function(GeneratePanelArrayResponse) updates) => super.copyWith((message) => updates(message as GeneratePanelArrayResponse)) as GeneratePanelArrayResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GeneratePanelArrayResponse create() => GeneratePanelArrayResponse._();
  GeneratePanelArrayResponse createEmptyInstance() => create();
  static $pb.PbList<GeneratePanelArrayResponse> createRepeated() => $pb.PbList<GeneratePanelArrayResponse>();
  @$core.pragma('dart2js:noInline')
  static GeneratePanelArrayResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GeneratePanelArrayResponse>(create);
  static GeneratePanelArrayResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get panelsCreated => $_getIZ(0);
  @$pb.TagNumber(1)
  set panelsCreated($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPanelsCreated() => $_has(0);
  @$pb.TagNumber(1)
  void clearPanelsCreated() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get tilesCreated => $_getIZ(1);
  @$pb.TagNumber(2)
  set tilesCreated($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTilesCreated() => $_has(1);
  @$pb.TagNumber(2)
  void clearTilesCreated() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get capacityKw => $_getN(2);
  @$pb.TagNumber(3)
  set capacityKw($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCapacityKw() => $_has(2);
  @$pb.TagNumber(3)
  void clearCapacityKw() => $_clearField(3);
}

class GetTilesRequest extends $pb.GeneratedMessage {
  factory GetTilesRequest({
    $core.String? layoutId,
    BoundingBox? viewport,
    $core.int? lodLevel,
  }) {
    final $result = create();
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (viewport != null) {
      $result.viewport = viewport;
    }
    if (lodLevel != null) {
      $result.lodLevel = lodLevel;
    }
    return $result;
  }
  GetTilesRequest._() : super();
  factory GetTilesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTilesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetTilesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'layoutId')
    ..aOM<BoundingBox>(2, _omitFieldNames ? '' : 'viewport', subBuilder: BoundingBox.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'lodLevel', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTilesRequest clone() => GetTilesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTilesRequest copyWith(void Function(GetTilesRequest) updates) => super.copyWith((message) => updates(message as GetTilesRequest)) as GetTilesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTilesRequest create() => GetTilesRequest._();
  GetTilesRequest createEmptyInstance() => create();
  static $pb.PbList<GetTilesRequest> createRepeated() => $pb.PbList<GetTilesRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTilesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTilesRequest>(create);
  static GetTilesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layoutId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayoutId() => $_clearField(1);

  @$pb.TagNumber(2)
  BoundingBox get viewport => $_getN(1);
  @$pb.TagNumber(2)
  set viewport(BoundingBox v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasViewport() => $_has(1);
  @$pb.TagNumber(2)
  void clearViewport() => $_clearField(2);
  @$pb.TagNumber(2)
  BoundingBox ensureViewport() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get lodLevel => $_getIZ(2);
  @$pb.TagNumber(3)
  set lodLevel($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLodLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearLodLevel() => $_clearField(3);
}

class GetTilesResponse extends $pb.GeneratedMessage {
  factory GetTilesResponse({
    $core.Iterable<LayoutTile>? tiles,
  }) {
    final $result = create();
    if (tiles != null) {
      $result.tiles.addAll(tiles);
    }
    return $result;
  }
  GetTilesResponse._() : super();
  factory GetTilesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTilesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetTilesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..pc<LayoutTile>(1, _omitFieldNames ? '' : 'tiles', $pb.PbFieldType.PM, subBuilder: LayoutTile.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTilesResponse clone() => GetTilesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTilesResponse copyWith(void Function(GetTilesResponse) updates) => super.copyWith((message) => updates(message as GetTilesResponse)) as GetTilesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTilesResponse create() => GetTilesResponse._();
  GetTilesResponse createEmptyInstance() => create();
  static $pb.PbList<GetTilesResponse> createRepeated() => $pb.PbList<GetTilesResponse>();
  @$core.pragma('dart2js:noInline')
  static GetTilesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTilesResponse>(create);
  static GetTilesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LayoutTile> get tiles => $_getList(0);
}

class GetTilePanelsRequest extends $pb.GeneratedMessage {
  factory GetTilePanelsRequest({
    $core.String? tileId,
  }) {
    final $result = create();
    if (tileId != null) {
      $result.tileId = tileId;
    }
    return $result;
  }
  GetTilePanelsRequest._() : super();
  factory GetTilePanelsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTilePanelsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetTilePanelsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'tileId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTilePanelsRequest clone() => GetTilePanelsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTilePanelsRequest copyWith(void Function(GetTilePanelsRequest) updates) => super.copyWith((message) => updates(message as GetTilePanelsRequest)) as GetTilePanelsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTilePanelsRequest create() => GetTilePanelsRequest._();
  GetTilePanelsRequest createEmptyInstance() => create();
  static $pb.PbList<GetTilePanelsRequest> createRepeated() => $pb.PbList<GetTilePanelsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTilePanelsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTilePanelsRequest>(create);
  static GetTilePanelsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set tileId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTileId() => $_clearField(1);
}

class GetTilePanelsResponse extends $pb.GeneratedMessage {
  factory GetTilePanelsResponse({
    $core.Iterable<Panel>? panels,
  }) {
    final $result = create();
    if (panels != null) {
      $result.panels.addAll(panels);
    }
    return $result;
  }
  GetTilePanelsResponse._() : super();
  factory GetTilePanelsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTilePanelsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetTilePanelsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'layout.v1'), createEmptyInstance: create)
    ..pc<Panel>(1, _omitFieldNames ? '' : 'panels', $pb.PbFieldType.PM, subBuilder: Panel.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTilePanelsResponse clone() => GetTilePanelsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTilePanelsResponse copyWith(void Function(GetTilePanelsResponse) updates) => super.copyWith((message) => updates(message as GetTilePanelsResponse)) as GetTilePanelsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTilePanelsResponse create() => GetTilePanelsResponse._();
  GetTilePanelsResponse createEmptyInstance() => create();
  static $pb.PbList<GetTilePanelsResponse> createRepeated() => $pb.PbList<GetTilePanelsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetTilePanelsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTilePanelsResponse>(create);
  static GetTilePanelsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Panel> get panels => $_getList(0);
}

/// LayoutService manages solar farm layout entities including panel arrays,
/// components (inverters, transformers, trackers), tile-based spatial queries,
/// and the acceptance workflow gate required for ElectricalReady phase progression.
class LayoutServiceApi {
  $pb.RpcClient _client;
  LayoutServiceApi(this._client);

  /// CreateLayout creates a new empty layout for a project.
  $async.Future<CreateLayoutResponse> createLayout($pb.ClientContext? ctx, CreateLayoutRequest request) =>
    _client.invoke<CreateLayoutResponse>(ctx, 'LayoutService', 'CreateLayout', request, CreateLayoutResponse())
  ;
  /// GetLayout retrieves a layout by ID including its current review metadata.
  $async.Future<GetLayoutResponse> getLayout($pb.ClientContext? ctx, GetLayoutRequest request) =>
    _client.invoke<GetLayoutResponse>(ctx, 'LayoutService', 'GetLayout', request, GetLayoutResponse())
  ;
  /// ListLayouts returns all layouts for a project ordered by creation time.
  $async.Future<ListLayoutsResponse> listLayouts($pb.ClientContext? ctx, ListLayoutsRequest request) =>
    _client.invoke<ListLayoutsResponse>(ctx, 'LayoutService', 'ListLayouts', request, ListLayoutsResponse())
  ;
  /// DeleteLayout permanently removes a layout and all its components and tiles.
  $async.Future<DeleteLayoutResponse> deleteLayout($pb.ClientContext? ctx, DeleteLayoutRequest request) =>
    _client.invoke<DeleteLayoutResponse>(ctx, 'LayoutService', 'DeleteLayout', request, DeleteLayoutResponse())
  ;
  /// Component placement
  $async.Future<PlaceComponentResponse> placeComponent($pb.ClientContext? ctx, PlaceComponentRequest request) =>
    _client.invoke<PlaceComponentResponse>(ctx, 'LayoutService', 'PlaceComponent', request, PlaceComponentResponse())
  ;
  /// MoveComponent updates the position of an existing placed component.
  $async.Future<MoveComponentResponse> moveComponent($pb.ClientContext? ctx, MoveComponentRequest request) =>
    _client.invoke<MoveComponentResponse>(ctx, 'LayoutService', 'MoveComponent', request, MoveComponentResponse())
  ;
  /// RemoveComponent removes a placed component from the layout.
  $async.Future<RemoveComponentResponse> removeComponent($pb.ClientContext? ctx, RemoveComponentRequest request) =>
    _client.invoke<RemoveComponentResponse>(ctx, 'LayoutService', 'RemoveComponent', request, RemoveComponentResponse())
  ;
  /// ListComponents returns all placed components for a layout.
  $async.Future<ListComponentsResponse> listComponents($pb.ClientContext? ctx, ListComponentsRequest request) =>
    _client.invoke<ListComponentsResponse>(ctx, 'LayoutService', 'ListComponents', request, ListComponentsResponse())
  ;
  /// Panel array generation
  $async.Future<GeneratePanelArrayResponse> generatePanelArray($pb.ClientContext? ctx, GeneratePanelArrayRequest request) =>
    _client.invoke<GeneratePanelArrayResponse>(ctx, 'LayoutService', 'GeneratePanelArray', request, GeneratePanelArrayResponse())
  ;
  /// Tile-based queries
  $async.Future<GetTilesResponse> getTiles($pb.ClientContext? ctx, GetTilesRequest request) =>
    _client.invoke<GetTilesResponse>(ctx, 'LayoutService', 'GetTiles', request, GetTilesResponse())
  ;
  /// GetTilePanels returns individual panel geometries within a specific tile for viewport rendering.
  $async.Future<GetTilePanelsResponse> getTilePanels($pb.ClientContext? ctx, GetTilePanelsRequest request) =>
    _client.invoke<GetTilePanelsResponse>(ctx, 'LayoutService', 'GetTilePanels', request, GetTilePanelsResponse())
  ;
  /// Acceptance workflow — gates the LayoutReady -> ElectricalReady phase transition.
  /// SubmitLayoutForReview transitions review_metadata.status to REVIEW_PENDING.
  $async.Future<SubmitLayoutForReviewResponse> submitLayoutForReview($pb.ClientContext? ctx, SubmitLayoutForReviewRequest request) =>
    _client.invoke<SubmitLayoutForReviewResponse>(ctx, 'LayoutService', 'SubmitLayoutForReview', request, SubmitLayoutForReviewResponse())
  ;
  /// ApproveLayout sets review_metadata.status to APPROVED, enabling ElectricalReady transition.
  $async.Future<ApproveLayoutResponse> approveLayout($pb.ClientContext? ctx, ApproveLayoutRequest request) =>
    _client.invoke<ApproveLayoutResponse>(ctx, 'LayoutService', 'ApproveLayout', request, ApproveLayoutResponse())
  ;
  /// RejectLayout sets review_metadata.status to REJECTED and records blockers preventing approval.
  $async.Future<RejectLayoutResponse> rejectLayout($pb.ClientContext? ctx, RejectLayoutRequest request) =>
    _client.invoke<RejectLayoutResponse>(ctx, 'LayoutService', 'RejectLayout', request, RejectLayoutResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
