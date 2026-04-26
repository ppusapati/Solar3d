//
//  Generated code. Do not modify.
//  source: constraint/v1/constraint_zones.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/v1/primitives.pb.dart' as $0;
import '../../google/protobuf/timestamp.pb.dart' as $1;
import 'constraint_zones.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'constraint_zones.pbenum.dart';

/// Zone represents a constraint zone (exclusion, inclusion, or buffer).
class Zone extends $pb.GeneratedMessage {
  factory Zone({
    $core.String? zoneId,
    $core.String? name,
    $core.String? description,
    ZoneType? zoneType,
    ZoneCategory? zoneCategory,
    ZoneStatus? zoneStatus,
    $core.String? geometryWkt,
    $core.String? geometryType,
    $0.BoundingBox2D? boundingBox,
    $1.Timestamp? effectiveStart,
    $1.Timestamp? effectiveEnd,
    $core.String? source,
    $core.String? sourceId,
    $core.double? bufferDistanceMeters,
    $core.Iterable<$core.String>? tags,
    $pb.PbMap<$core.String, $core.String>? metadata,
    $core.String? createdBy,
    $core.String? projectId,
    $core.bool? isPublic,
    $1.Timestamp? createdAt,
    $1.Timestamp? updatedAt,
    $1.Timestamp? deletedAt,
  }) {
    final $result = create();
    if (zoneId != null) {
      $result.zoneId = zoneId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (zoneType != null) {
      $result.zoneType = zoneType;
    }
    if (zoneCategory != null) {
      $result.zoneCategory = zoneCategory;
    }
    if (zoneStatus != null) {
      $result.zoneStatus = zoneStatus;
    }
    if (geometryWkt != null) {
      $result.geometryWkt = geometryWkt;
    }
    if (geometryType != null) {
      $result.geometryType = geometryType;
    }
    if (boundingBox != null) {
      $result.boundingBox = boundingBox;
    }
    if (effectiveStart != null) {
      $result.effectiveStart = effectiveStart;
    }
    if (effectiveEnd != null) {
      $result.effectiveEnd = effectiveEnd;
    }
    if (source != null) {
      $result.source = source;
    }
    if (sourceId != null) {
      $result.sourceId = sourceId;
    }
    if (bufferDistanceMeters != null) {
      $result.bufferDistanceMeters = bufferDistanceMeters;
    }
    if (tags != null) {
      $result.tags.addAll(tags);
    }
    if (metadata != null) {
      $result.metadata.addAll(metadata);
    }
    if (createdBy != null) {
      $result.createdBy = createdBy;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (isPublic != null) {
      $result.isPublic = isPublic;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    if (deletedAt != null) {
      $result.deletedAt = deletedAt;
    }
    return $result;
  }
  Zone._() : super();
  factory Zone.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Zone.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Zone', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'zoneId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..e<ZoneType>(4, _omitFieldNames ? '' : 'zoneType', $pb.PbFieldType.OE, defaultOrMaker: ZoneType.ZONE_TYPE_UNSPECIFIED, valueOf: ZoneType.valueOf, enumValues: ZoneType.values)
    ..e<ZoneCategory>(5, _omitFieldNames ? '' : 'zoneCategory', $pb.PbFieldType.OE, defaultOrMaker: ZoneCategory.ZONE_CATEGORY_UNSPECIFIED, valueOf: ZoneCategory.valueOf, enumValues: ZoneCategory.values)
    ..e<ZoneStatus>(6, _omitFieldNames ? '' : 'zoneStatus', $pb.PbFieldType.OE, defaultOrMaker: ZoneStatus.ZONE_STATUS_UNSPECIFIED, valueOf: ZoneStatus.valueOf, enumValues: ZoneStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'geometryWkt')
    ..aOS(8, _omitFieldNames ? '' : 'geometryType')
    ..aOM<$0.BoundingBox2D>(9, _omitFieldNames ? '' : 'boundingBox', subBuilder: $0.BoundingBox2D.create)
    ..aOM<$1.Timestamp>(10, _omitFieldNames ? '' : 'effectiveStart', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(11, _omitFieldNames ? '' : 'effectiveEnd', subBuilder: $1.Timestamp.create)
    ..aOS(12, _omitFieldNames ? '' : 'source')
    ..aOS(13, _omitFieldNames ? '' : 'sourceId')
    ..a<$core.double>(14, _omitFieldNames ? '' : 'bufferDistanceMeters', $pb.PbFieldType.OF)
    ..pPS(15, _omitFieldNames ? '' : 'tags')
    ..m<$core.String, $core.String>(16, _omitFieldNames ? '' : 'metadata', entryClassName: 'Zone.MetadataEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('constraint.v1'))
    ..aOS(17, _omitFieldNames ? '' : 'createdBy')
    ..aOS(18, _omitFieldNames ? '' : 'projectId')
    ..aOB(19, _omitFieldNames ? '' : 'isPublic')
    ..aOM<$1.Timestamp>(20, _omitFieldNames ? '' : 'createdAt', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(21, _omitFieldNames ? '' : 'updatedAt', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(22, _omitFieldNames ? '' : 'deletedAt', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Zone clone() => Zone()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Zone copyWith(void Function(Zone) updates) => super.copyWith((message) => updates(message as Zone)) as Zone;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Zone create() => Zone._();
  Zone createEmptyInstance() => create();
  static $pb.PbList<Zone> createRepeated() => $pb.PbList<Zone>();
  @$core.pragma('dart2js:noInline')
  static Zone getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Zone>(create);
  static Zone? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get zoneId => $_getSZ(0);
  @$pb.TagNumber(1)
  set zoneId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasZoneId() => $_has(0);
  @$pb.TagNumber(1)
  void clearZoneId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  ZoneType get zoneType => $_getN(3);
  @$pb.TagNumber(4)
  set zoneType(ZoneType v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasZoneType() => $_has(3);
  @$pb.TagNumber(4)
  void clearZoneType() => $_clearField(4);

  @$pb.TagNumber(5)
  ZoneCategory get zoneCategory => $_getN(4);
  @$pb.TagNumber(5)
  set zoneCategory(ZoneCategory v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasZoneCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearZoneCategory() => $_clearField(5);

  @$pb.TagNumber(6)
  ZoneStatus get zoneStatus => $_getN(5);
  @$pb.TagNumber(6)
  set zoneStatus(ZoneStatus v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasZoneStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearZoneStatus() => $_clearField(6);

  /// Geometry (WKT format or PostGIS reference)
  @$pb.TagNumber(7)
  $core.String get geometryWkt => $_getSZ(6);
  @$pb.TagNumber(7)
  set geometryWkt($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasGeometryWkt() => $_has(6);
  @$pb.TagNumber(7)
  void clearGeometryWkt() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get geometryType => $_getSZ(7);
  @$pb.TagNumber(8)
  set geometryType($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasGeometryType() => $_has(7);
  @$pb.TagNumber(8)
  void clearGeometryType() => $_clearField(8);

  @$pb.TagNumber(9)
  $0.BoundingBox2D get boundingBox => $_getN(8);
  @$pb.TagNumber(9)
  set boundingBox($0.BoundingBox2D v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasBoundingBox() => $_has(8);
  @$pb.TagNumber(9)
  void clearBoundingBox() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.BoundingBox2D ensureBoundingBox() => $_ensure(8);

  /// Temporal constraints
  @$pb.TagNumber(10)
  $1.Timestamp get effectiveStart => $_getN(9);
  @$pb.TagNumber(10)
  set effectiveStart($1.Timestamp v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasEffectiveStart() => $_has(9);
  @$pb.TagNumber(10)
  void clearEffectiveStart() => $_clearField(10);
  @$pb.TagNumber(10)
  $1.Timestamp ensureEffectiveStart() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.Timestamp get effectiveEnd => $_getN(10);
  @$pb.TagNumber(11)
  set effectiveEnd($1.Timestamp v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasEffectiveEnd() => $_has(10);
  @$pb.TagNumber(11)
  void clearEffectiveEnd() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.Timestamp ensureEffectiveEnd() => $_ensure(10);

  /// Metadata
  @$pb.TagNumber(12)
  $core.String get source => $_getSZ(11);
  @$pb.TagNumber(12)
  set source($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasSource() => $_has(11);
  @$pb.TagNumber(12)
  void clearSource() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get sourceId => $_getSZ(12);
  @$pb.TagNumber(13)
  set sourceId($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasSourceId() => $_has(12);
  @$pb.TagNumber(13)
  void clearSourceId() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get bufferDistanceMeters => $_getN(13);
  @$pb.TagNumber(14)
  set bufferDistanceMeters($core.double v) { $_setFloat(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasBufferDistanceMeters() => $_has(13);
  @$pb.TagNumber(14)
  void clearBufferDistanceMeters() => $_clearField(14);

  @$pb.TagNumber(15)
  $pb.PbList<$core.String> get tags => $_getList(14);

  @$pb.TagNumber(16)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(15);

  /// Permissions
  @$pb.TagNumber(17)
  $core.String get createdBy => $_getSZ(16);
  @$pb.TagNumber(17)
  set createdBy($core.String v) { $_setString(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasCreatedBy() => $_has(16);
  @$pb.TagNumber(17)
  void clearCreatedBy() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get projectId => $_getSZ(17);
  @$pb.TagNumber(18)
  set projectId($core.String v) { $_setString(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasProjectId() => $_has(17);
  @$pb.TagNumber(18)
  void clearProjectId() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.bool get isPublic => $_getBF(18);
  @$pb.TagNumber(19)
  set isPublic($core.bool v) { $_setBool(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasIsPublic() => $_has(18);
  @$pb.TagNumber(19)
  void clearIsPublic() => $_clearField(19);

  /// Audit
  @$pb.TagNumber(20)
  $1.Timestamp get createdAt => $_getN(19);
  @$pb.TagNumber(20)
  set createdAt($1.Timestamp v) { $_setField(20, v); }
  @$pb.TagNumber(20)
  $core.bool hasCreatedAt() => $_has(19);
  @$pb.TagNumber(20)
  void clearCreatedAt() => $_clearField(20);
  @$pb.TagNumber(20)
  $1.Timestamp ensureCreatedAt() => $_ensure(19);

  @$pb.TagNumber(21)
  $1.Timestamp get updatedAt => $_getN(20);
  @$pb.TagNumber(21)
  set updatedAt($1.Timestamp v) { $_setField(21, v); }
  @$pb.TagNumber(21)
  $core.bool hasUpdatedAt() => $_has(20);
  @$pb.TagNumber(21)
  void clearUpdatedAt() => $_clearField(21);
  @$pb.TagNumber(21)
  $1.Timestamp ensureUpdatedAt() => $_ensure(20);

  @$pb.TagNumber(22)
  $1.Timestamp get deletedAt => $_getN(21);
  @$pb.TagNumber(22)
  set deletedAt($1.Timestamp v) { $_setField(22, v); }
  @$pb.TagNumber(22)
  $core.bool hasDeletedAt() => $_has(21);
  @$pb.TagNumber(22)
  void clearDeletedAt() => $_clearField(22);
  @$pb.TagNumber(22)
  $1.Timestamp ensureDeletedAt() => $_ensure(21);
}

/// SitingConflict represents a conflict between a proposed site and a constraint zone.
class SitingConflict extends $pb.GeneratedMessage {
  factory SitingConflict({
    $core.String? conflictId,
    $core.String? zoneId,
    Zone? conflictingZone,
    ConflictSeverity? severity,
    $core.String? conflictReason,
    $core.double? distanceMeters,
    $core.double? overlapAreaSqm,
    $core.Iterable<$core.String>? mitigationSuggestions,
  }) {
    final $result = create();
    if (conflictId != null) {
      $result.conflictId = conflictId;
    }
    if (zoneId != null) {
      $result.zoneId = zoneId;
    }
    if (conflictingZone != null) {
      $result.conflictingZone = conflictingZone;
    }
    if (severity != null) {
      $result.severity = severity;
    }
    if (conflictReason != null) {
      $result.conflictReason = conflictReason;
    }
    if (distanceMeters != null) {
      $result.distanceMeters = distanceMeters;
    }
    if (overlapAreaSqm != null) {
      $result.overlapAreaSqm = overlapAreaSqm;
    }
    if (mitigationSuggestions != null) {
      $result.mitigationSuggestions.addAll(mitigationSuggestions);
    }
    return $result;
  }
  SitingConflict._() : super();
  factory SitingConflict.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SitingConflict.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SitingConflict', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'conflictId')
    ..aOS(2, _omitFieldNames ? '' : 'zoneId')
    ..aOM<Zone>(3, _omitFieldNames ? '' : 'conflictingZone', subBuilder: Zone.create)
    ..e<ConflictSeverity>(4, _omitFieldNames ? '' : 'severity', $pb.PbFieldType.OE, defaultOrMaker: ConflictSeverity.CONFLICT_SEVERITY_UNSPECIFIED, valueOf: ConflictSeverity.valueOf, enumValues: ConflictSeverity.values)
    ..aOS(5, _omitFieldNames ? '' : 'conflictReason')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'distanceMeters', $pb.PbFieldType.OF)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'overlapAreaSqm', $pb.PbFieldType.OF)
    ..pPS(8, _omitFieldNames ? '' : 'mitigationSuggestions')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SitingConflict clone() => SitingConflict()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SitingConflict copyWith(void Function(SitingConflict) updates) => super.copyWith((message) => updates(message as SitingConflict)) as SitingConflict;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SitingConflict create() => SitingConflict._();
  SitingConflict createEmptyInstance() => create();
  static $pb.PbList<SitingConflict> createRepeated() => $pb.PbList<SitingConflict>();
  @$core.pragma('dart2js:noInline')
  static SitingConflict getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SitingConflict>(create);
  static SitingConflict? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conflictId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conflictId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasConflictId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConflictId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get zoneId => $_getSZ(1);
  @$pb.TagNumber(2)
  set zoneId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasZoneId() => $_has(1);
  @$pb.TagNumber(2)
  void clearZoneId() => $_clearField(2);

  @$pb.TagNumber(3)
  Zone get conflictingZone => $_getN(2);
  @$pb.TagNumber(3)
  set conflictingZone(Zone v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasConflictingZone() => $_has(2);
  @$pb.TagNumber(3)
  void clearConflictingZone() => $_clearField(3);
  @$pb.TagNumber(3)
  Zone ensureConflictingZone() => $_ensure(2);

  @$pb.TagNumber(4)
  ConflictSeverity get severity => $_getN(3);
  @$pb.TagNumber(4)
  set severity(ConflictSeverity v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSeverity() => $_has(3);
  @$pb.TagNumber(4)
  void clearSeverity() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get conflictReason => $_getSZ(4);
  @$pb.TagNumber(5)
  set conflictReason($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasConflictReason() => $_has(4);
  @$pb.TagNumber(5)
  void clearConflictReason() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get distanceMeters => $_getN(5);
  @$pb.TagNumber(6)
  set distanceMeters($core.double v) { $_setFloat(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDistanceMeters() => $_has(5);
  @$pb.TagNumber(6)
  void clearDistanceMeters() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get overlapAreaSqm => $_getN(6);
  @$pb.TagNumber(7)
  set overlapAreaSqm($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasOverlapAreaSqm() => $_has(6);
  @$pb.TagNumber(7)
  void clearOverlapAreaSqm() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbList<$core.String> get mitigationSuggestions => $_getList(7);
}

/// RiskScore aggregates conflict severity for siting decision.
class RiskScore extends $pb.GeneratedMessage {
  factory RiskScore({
    $core.int? totalConflicts,
    $core.int? blockerCount,
    $core.int? errorCount,
    $core.int? warningCount,
    $core.double? overallRiskPercentage,
    $core.bool? isSiteable,
  }) {
    final $result = create();
    if (totalConflicts != null) {
      $result.totalConflicts = totalConflicts;
    }
    if (blockerCount != null) {
      $result.blockerCount = blockerCount;
    }
    if (errorCount != null) {
      $result.errorCount = errorCount;
    }
    if (warningCount != null) {
      $result.warningCount = warningCount;
    }
    if (overallRiskPercentage != null) {
      $result.overallRiskPercentage = overallRiskPercentage;
    }
    if (isSiteable != null) {
      $result.isSiteable = isSiteable;
    }
    return $result;
  }
  RiskScore._() : super();
  factory RiskScore.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RiskScore.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RiskScore', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'totalConflicts', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'blockerCount', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'errorCount', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'warningCount', $pb.PbFieldType.O3)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'overallRiskPercentage', $pb.PbFieldType.OF)
    ..aOB(6, _omitFieldNames ? '' : 'isSiteable')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RiskScore clone() => RiskScore()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RiskScore copyWith(void Function(RiskScore) updates) => super.copyWith((message) => updates(message as RiskScore)) as RiskScore;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RiskScore create() => RiskScore._();
  RiskScore createEmptyInstance() => create();
  static $pb.PbList<RiskScore> createRepeated() => $pb.PbList<RiskScore>();
  @$core.pragma('dart2js:noInline')
  static RiskScore getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RiskScore>(create);
  static RiskScore? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalConflicts => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalConflicts($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotalConflicts() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalConflicts() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get blockerCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set blockerCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBlockerCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearBlockerCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get errorCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set errorCount($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasErrorCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearErrorCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get warningCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set warningCount($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasWarningCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearWarningCount() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get overallRiskPercentage => $_getN(4);
  @$pb.TagNumber(5)
  set overallRiskPercentage($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasOverallRiskPercentage() => $_has(4);
  @$pb.TagNumber(5)
  void clearOverallRiskPercentage() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isSiteable => $_getBF(5);
  @$pb.TagNumber(6)
  set isSiteable($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIsSiteable() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsSiteable() => $_clearField(6);
}

/// ZoneCategory represents a category in the taxonomy.
class CategoryDef extends $pb.GeneratedMessage {
  factory CategoryDef({
    ZoneCategory? category,
    $core.String? displayName,
    $core.String? description,
    $core.Iterable<$core.String>? allowedTags,
    $core.Iterable<$core.String>? associatedRegulations,
  }) {
    final $result = create();
    if (category != null) {
      $result.category = category;
    }
    if (displayName != null) {
      $result.displayName = displayName;
    }
    if (description != null) {
      $result.description = description;
    }
    if (allowedTags != null) {
      $result.allowedTags.addAll(allowedTags);
    }
    if (associatedRegulations != null) {
      $result.associatedRegulations.addAll(associatedRegulations);
    }
    return $result;
  }
  CategoryDef._() : super();
  factory CategoryDef.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CategoryDef.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CategoryDef', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..e<ZoneCategory>(1, _omitFieldNames ? '' : 'category', $pb.PbFieldType.OE, defaultOrMaker: ZoneCategory.ZONE_CATEGORY_UNSPECIFIED, valueOf: ZoneCategory.valueOf, enumValues: ZoneCategory.values)
    ..aOS(2, _omitFieldNames ? '' : 'displayName')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..pPS(4, _omitFieldNames ? '' : 'allowedTags')
    ..pPS(5, _omitFieldNames ? '' : 'associatedRegulations')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CategoryDef clone() => CategoryDef()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CategoryDef copyWith(void Function(CategoryDef) updates) => super.copyWith((message) => updates(message as CategoryDef)) as CategoryDef;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CategoryDef create() => CategoryDef._();
  CategoryDef createEmptyInstance() => create();
  static $pb.PbList<CategoryDef> createRepeated() => $pb.PbList<CategoryDef>();
  @$core.pragma('dart2js:noInline')
  static CategoryDef getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CategoryDef>(create);
  static CategoryDef? _defaultInstance;

  @$pb.TagNumber(1)
  ZoneCategory get category => $_getN(0);
  @$pb.TagNumber(1)
  set category(ZoneCategory v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCategory() => $_has(0);
  @$pb.TagNumber(1)
  void clearCategory() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get displayName => $_getSZ(1);
  @$pb.TagNumber(2)
  set displayName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDisplayName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDisplayName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get allowedTags => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get associatedRegulations => $_getList(4);
}

class CreateZoneRequest extends $pb.GeneratedMessage {
  factory CreateZoneRequest({
    $core.String? name,
    $core.String? description,
    ZoneType? zoneType,
    ZoneCategory? zoneCategory,
    $core.String? geometryWkt,
    $core.String? geometryType,
    $1.Timestamp? effectiveStart,
    $1.Timestamp? effectiveEnd,
    $core.String? source,
    $core.String? sourceId,
    $core.double? bufferDistanceMeters,
    $core.Iterable<$core.String>? tags,
    $pb.PbMap<$core.String, $core.String>? metadata,
    $core.String? projectId,
    $core.bool? isPublic,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (zoneType != null) {
      $result.zoneType = zoneType;
    }
    if (zoneCategory != null) {
      $result.zoneCategory = zoneCategory;
    }
    if (geometryWkt != null) {
      $result.geometryWkt = geometryWkt;
    }
    if (geometryType != null) {
      $result.geometryType = geometryType;
    }
    if (effectiveStart != null) {
      $result.effectiveStart = effectiveStart;
    }
    if (effectiveEnd != null) {
      $result.effectiveEnd = effectiveEnd;
    }
    if (source != null) {
      $result.source = source;
    }
    if (sourceId != null) {
      $result.sourceId = sourceId;
    }
    if (bufferDistanceMeters != null) {
      $result.bufferDistanceMeters = bufferDistanceMeters;
    }
    if (tags != null) {
      $result.tags.addAll(tags);
    }
    if (metadata != null) {
      $result.metadata.addAll(metadata);
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (isPublic != null) {
      $result.isPublic = isPublic;
    }
    return $result;
  }
  CreateZoneRequest._() : super();
  factory CreateZoneRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateZoneRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateZoneRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'description')
    ..e<ZoneType>(3, _omitFieldNames ? '' : 'zoneType', $pb.PbFieldType.OE, defaultOrMaker: ZoneType.ZONE_TYPE_UNSPECIFIED, valueOf: ZoneType.valueOf, enumValues: ZoneType.values)
    ..e<ZoneCategory>(4, _omitFieldNames ? '' : 'zoneCategory', $pb.PbFieldType.OE, defaultOrMaker: ZoneCategory.ZONE_CATEGORY_UNSPECIFIED, valueOf: ZoneCategory.valueOf, enumValues: ZoneCategory.values)
    ..aOS(5, _omitFieldNames ? '' : 'geometryWkt')
    ..aOS(6, _omitFieldNames ? '' : 'geometryType')
    ..aOM<$1.Timestamp>(7, _omitFieldNames ? '' : 'effectiveStart', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'effectiveEnd', subBuilder: $1.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'source')
    ..aOS(10, _omitFieldNames ? '' : 'sourceId')
    ..a<$core.double>(11, _omitFieldNames ? '' : 'bufferDistanceMeters', $pb.PbFieldType.OF)
    ..pPS(12, _omitFieldNames ? '' : 'tags')
    ..m<$core.String, $core.String>(13, _omitFieldNames ? '' : 'metadata', entryClassName: 'CreateZoneRequest.MetadataEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('constraint.v1'))
    ..aOS(14, _omitFieldNames ? '' : 'projectId')
    ..aOB(15, _omitFieldNames ? '' : 'isPublic')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateZoneRequest clone() => CreateZoneRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateZoneRequest copyWith(void Function(CreateZoneRequest) updates) => super.copyWith((message) => updates(message as CreateZoneRequest)) as CreateZoneRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateZoneRequest create() => CreateZoneRequest._();
  CreateZoneRequest createEmptyInstance() => create();
  static $pb.PbList<CreateZoneRequest> createRepeated() => $pb.PbList<CreateZoneRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateZoneRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateZoneRequest>(create);
  static CreateZoneRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get description => $_getSZ(1);
  @$pb.TagNumber(2)
  set description($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);

  @$pb.TagNumber(3)
  ZoneType get zoneType => $_getN(2);
  @$pb.TagNumber(3)
  set zoneType(ZoneType v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasZoneType() => $_has(2);
  @$pb.TagNumber(3)
  void clearZoneType() => $_clearField(3);

  @$pb.TagNumber(4)
  ZoneCategory get zoneCategory => $_getN(3);
  @$pb.TagNumber(4)
  set zoneCategory(ZoneCategory v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasZoneCategory() => $_has(3);
  @$pb.TagNumber(4)
  void clearZoneCategory() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get geometryWkt => $_getSZ(4);
  @$pb.TagNumber(5)
  set geometryWkt($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasGeometryWkt() => $_has(4);
  @$pb.TagNumber(5)
  void clearGeometryWkt() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get geometryType => $_getSZ(5);
  @$pb.TagNumber(6)
  set geometryType($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasGeometryType() => $_has(5);
  @$pb.TagNumber(6)
  void clearGeometryType() => $_clearField(6);

  @$pb.TagNumber(7)
  $1.Timestamp get effectiveStart => $_getN(6);
  @$pb.TagNumber(7)
  set effectiveStart($1.Timestamp v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasEffectiveStart() => $_has(6);
  @$pb.TagNumber(7)
  void clearEffectiveStart() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.Timestamp ensureEffectiveStart() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Timestamp get effectiveEnd => $_getN(7);
  @$pb.TagNumber(8)
  set effectiveEnd($1.Timestamp v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasEffectiveEnd() => $_has(7);
  @$pb.TagNumber(8)
  void clearEffectiveEnd() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureEffectiveEnd() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get source => $_getSZ(8);
  @$pb.TagNumber(9)
  set source($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasSource() => $_has(8);
  @$pb.TagNumber(9)
  void clearSource() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get sourceId => $_getSZ(9);
  @$pb.TagNumber(10)
  set sourceId($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSourceId() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourceId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get bufferDistanceMeters => $_getN(10);
  @$pb.TagNumber(11)
  set bufferDistanceMeters($core.double v) { $_setFloat(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasBufferDistanceMeters() => $_has(10);
  @$pb.TagNumber(11)
  void clearBufferDistanceMeters() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbList<$core.String> get tags => $_getList(11);

  @$pb.TagNumber(13)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(12);

  @$pb.TagNumber(14)
  $core.String get projectId => $_getSZ(13);
  @$pb.TagNumber(14)
  set projectId($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasProjectId() => $_has(13);
  @$pb.TagNumber(14)
  void clearProjectId() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.bool get isPublic => $_getBF(14);
  @$pb.TagNumber(15)
  set isPublic($core.bool v) { $_setBool(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasIsPublic() => $_has(14);
  @$pb.TagNumber(15)
  void clearIsPublic() => $_clearField(15);
}

class CreateZoneResponse extends $pb.GeneratedMessage {
  factory CreateZoneResponse({
    $core.String? zoneId,
    Zone? zone,
    $1.Timestamp? createdAt,
  }) {
    final $result = create();
    if (zoneId != null) {
      $result.zoneId = zoneId;
    }
    if (zone != null) {
      $result.zone = zone;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  CreateZoneResponse._() : super();
  factory CreateZoneResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateZoneResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateZoneResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'zoneId')
    ..aOM<Zone>(2, _omitFieldNames ? '' : 'zone', subBuilder: Zone.create)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'createdAt', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateZoneResponse clone() => CreateZoneResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateZoneResponse copyWith(void Function(CreateZoneResponse) updates) => super.copyWith((message) => updates(message as CreateZoneResponse)) as CreateZoneResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateZoneResponse create() => CreateZoneResponse._();
  CreateZoneResponse createEmptyInstance() => create();
  static $pb.PbList<CreateZoneResponse> createRepeated() => $pb.PbList<CreateZoneResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateZoneResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateZoneResponse>(create);
  static CreateZoneResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get zoneId => $_getSZ(0);
  @$pb.TagNumber(1)
  set zoneId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasZoneId() => $_has(0);
  @$pb.TagNumber(1)
  void clearZoneId() => $_clearField(1);

  @$pb.TagNumber(2)
  Zone get zone => $_getN(1);
  @$pb.TagNumber(2)
  set zone(Zone v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasZone() => $_has(1);
  @$pb.TagNumber(2)
  void clearZone() => $_clearField(2);
  @$pb.TagNumber(2)
  Zone ensureZone() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Timestamp get createdAt => $_getN(2);
  @$pb.TagNumber(3)
  set createdAt($1.Timestamp v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureCreatedAt() => $_ensure(2);
}

class UpdateZoneRequest extends $pb.GeneratedMessage {
  factory UpdateZoneRequest({
    $core.String? zoneId,
    $core.String? name,
    $core.String? description,
    ZoneType? zoneType,
    ZoneCategory? zoneCategory,
    ZoneStatus? zoneStatus,
    $core.String? geometryWkt,
    $1.Timestamp? effectiveStart,
    $1.Timestamp? effectiveEnd,
    $core.double? bufferDistanceMeters,
    $core.Iterable<$core.String>? tags,
    $pb.PbMap<$core.String, $core.String>? metadata,
    $core.bool? isPublic,
  }) {
    final $result = create();
    if (zoneId != null) {
      $result.zoneId = zoneId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (zoneType != null) {
      $result.zoneType = zoneType;
    }
    if (zoneCategory != null) {
      $result.zoneCategory = zoneCategory;
    }
    if (zoneStatus != null) {
      $result.zoneStatus = zoneStatus;
    }
    if (geometryWkt != null) {
      $result.geometryWkt = geometryWkt;
    }
    if (effectiveStart != null) {
      $result.effectiveStart = effectiveStart;
    }
    if (effectiveEnd != null) {
      $result.effectiveEnd = effectiveEnd;
    }
    if (bufferDistanceMeters != null) {
      $result.bufferDistanceMeters = bufferDistanceMeters;
    }
    if (tags != null) {
      $result.tags.addAll(tags);
    }
    if (metadata != null) {
      $result.metadata.addAll(metadata);
    }
    if (isPublic != null) {
      $result.isPublic = isPublic;
    }
    return $result;
  }
  UpdateZoneRequest._() : super();
  factory UpdateZoneRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateZoneRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateZoneRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'zoneId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..e<ZoneType>(4, _omitFieldNames ? '' : 'zoneType', $pb.PbFieldType.OE, defaultOrMaker: ZoneType.ZONE_TYPE_UNSPECIFIED, valueOf: ZoneType.valueOf, enumValues: ZoneType.values)
    ..e<ZoneCategory>(5, _omitFieldNames ? '' : 'zoneCategory', $pb.PbFieldType.OE, defaultOrMaker: ZoneCategory.ZONE_CATEGORY_UNSPECIFIED, valueOf: ZoneCategory.valueOf, enumValues: ZoneCategory.values)
    ..e<ZoneStatus>(6, _omitFieldNames ? '' : 'zoneStatus', $pb.PbFieldType.OE, defaultOrMaker: ZoneStatus.ZONE_STATUS_UNSPECIFIED, valueOf: ZoneStatus.valueOf, enumValues: ZoneStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'geometryWkt')
    ..aOM<$1.Timestamp>(8, _omitFieldNames ? '' : 'effectiveStart', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(9, _omitFieldNames ? '' : 'effectiveEnd', subBuilder: $1.Timestamp.create)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'bufferDistanceMeters', $pb.PbFieldType.OF)
    ..pPS(11, _omitFieldNames ? '' : 'tags')
    ..m<$core.String, $core.String>(12, _omitFieldNames ? '' : 'metadata', entryClassName: 'UpdateZoneRequest.MetadataEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('constraint.v1'))
    ..aOB(13, _omitFieldNames ? '' : 'isPublic')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateZoneRequest clone() => UpdateZoneRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateZoneRequest copyWith(void Function(UpdateZoneRequest) updates) => super.copyWith((message) => updates(message as UpdateZoneRequest)) as UpdateZoneRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateZoneRequest create() => UpdateZoneRequest._();
  UpdateZoneRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateZoneRequest> createRepeated() => $pb.PbList<UpdateZoneRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateZoneRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateZoneRequest>(create);
  static UpdateZoneRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get zoneId => $_getSZ(0);
  @$pb.TagNumber(1)
  set zoneId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasZoneId() => $_has(0);
  @$pb.TagNumber(1)
  void clearZoneId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  ZoneType get zoneType => $_getN(3);
  @$pb.TagNumber(4)
  set zoneType(ZoneType v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasZoneType() => $_has(3);
  @$pb.TagNumber(4)
  void clearZoneType() => $_clearField(4);

  @$pb.TagNumber(5)
  ZoneCategory get zoneCategory => $_getN(4);
  @$pb.TagNumber(5)
  set zoneCategory(ZoneCategory v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasZoneCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearZoneCategory() => $_clearField(5);

  @$pb.TagNumber(6)
  ZoneStatus get zoneStatus => $_getN(5);
  @$pb.TagNumber(6)
  set zoneStatus(ZoneStatus v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasZoneStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearZoneStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get geometryWkt => $_getSZ(6);
  @$pb.TagNumber(7)
  set geometryWkt($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasGeometryWkt() => $_has(6);
  @$pb.TagNumber(7)
  void clearGeometryWkt() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.Timestamp get effectiveStart => $_getN(7);
  @$pb.TagNumber(8)
  set effectiveStart($1.Timestamp v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasEffectiveStart() => $_has(7);
  @$pb.TagNumber(8)
  void clearEffectiveStart() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Timestamp ensureEffectiveStart() => $_ensure(7);

  @$pb.TagNumber(9)
  $1.Timestamp get effectiveEnd => $_getN(8);
  @$pb.TagNumber(9)
  set effectiveEnd($1.Timestamp v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasEffectiveEnd() => $_has(8);
  @$pb.TagNumber(9)
  void clearEffectiveEnd() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.Timestamp ensureEffectiveEnd() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.double get bufferDistanceMeters => $_getN(9);
  @$pb.TagNumber(10)
  set bufferDistanceMeters($core.double v) { $_setFloat(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasBufferDistanceMeters() => $_has(9);
  @$pb.TagNumber(10)
  void clearBufferDistanceMeters() => $_clearField(10);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get tags => $_getList(10);

  @$pb.TagNumber(12)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(11);

  @$pb.TagNumber(13)
  $core.bool get isPublic => $_getBF(12);
  @$pb.TagNumber(13)
  set isPublic($core.bool v) { $_setBool(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasIsPublic() => $_has(12);
  @$pb.TagNumber(13)
  void clearIsPublic() => $_clearField(13);
}

class UpdateZoneResponse extends $pb.GeneratedMessage {
  factory UpdateZoneResponse({
    Zone? zone,
    $1.Timestamp? updatedAt,
  }) {
    final $result = create();
    if (zone != null) {
      $result.zone = zone;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    return $result;
  }
  UpdateZoneResponse._() : super();
  factory UpdateZoneResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateZoneResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateZoneResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOM<Zone>(1, _omitFieldNames ? '' : 'zone', subBuilder: Zone.create)
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'updatedAt', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateZoneResponse clone() => UpdateZoneResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateZoneResponse copyWith(void Function(UpdateZoneResponse) updates) => super.copyWith((message) => updates(message as UpdateZoneResponse)) as UpdateZoneResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateZoneResponse create() => UpdateZoneResponse._();
  UpdateZoneResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateZoneResponse> createRepeated() => $pb.PbList<UpdateZoneResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateZoneResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateZoneResponse>(create);
  static UpdateZoneResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Zone get zone => $_getN(0);
  @$pb.TagNumber(1)
  set zone(Zone v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasZone() => $_has(0);
  @$pb.TagNumber(1)
  void clearZone() => $_clearField(1);
  @$pb.TagNumber(1)
  Zone ensureZone() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Timestamp get updatedAt => $_getN(1);
  @$pb.TagNumber(2)
  set updatedAt($1.Timestamp v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUpdatedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpdatedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureUpdatedAt() => $_ensure(1);
}

class DeleteZoneRequest extends $pb.GeneratedMessage {
  factory DeleteZoneRequest({
    $core.String? zoneId,
    $core.String? reason,
  }) {
    final $result = create();
    if (zoneId != null) {
      $result.zoneId = zoneId;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  DeleteZoneRequest._() : super();
  factory DeleteZoneRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteZoneRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteZoneRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'zoneId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteZoneRequest clone() => DeleteZoneRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteZoneRequest copyWith(void Function(DeleteZoneRequest) updates) => super.copyWith((message) => updates(message as DeleteZoneRequest)) as DeleteZoneRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteZoneRequest create() => DeleteZoneRequest._();
  DeleteZoneRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteZoneRequest> createRepeated() => $pb.PbList<DeleteZoneRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteZoneRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteZoneRequest>(create);
  static DeleteZoneRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get zoneId => $_getSZ(0);
  @$pb.TagNumber(1)
  set zoneId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasZoneId() => $_has(0);
  @$pb.TagNumber(1)
  void clearZoneId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

class DeleteZoneResponse extends $pb.GeneratedMessage {
  factory DeleteZoneResponse({
    $core.String? zoneId,
    $1.Timestamp? deletedAt,
  }) {
    final $result = create();
    if (zoneId != null) {
      $result.zoneId = zoneId;
    }
    if (deletedAt != null) {
      $result.deletedAt = deletedAt;
    }
    return $result;
  }
  DeleteZoneResponse._() : super();
  factory DeleteZoneResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteZoneResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteZoneResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'zoneId')
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'deletedAt', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteZoneResponse clone() => DeleteZoneResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteZoneResponse copyWith(void Function(DeleteZoneResponse) updates) => super.copyWith((message) => updates(message as DeleteZoneResponse)) as DeleteZoneResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteZoneResponse create() => DeleteZoneResponse._();
  DeleteZoneResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteZoneResponse> createRepeated() => $pb.PbList<DeleteZoneResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteZoneResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteZoneResponse>(create);
  static DeleteZoneResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get zoneId => $_getSZ(0);
  @$pb.TagNumber(1)
  set zoneId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasZoneId() => $_has(0);
  @$pb.TagNumber(1)
  void clearZoneId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get deletedAt => $_getN(1);
  @$pb.TagNumber(2)
  set deletedAt($1.Timestamp v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeletedAt() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeletedAt() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureDeletedAt() => $_ensure(1);
}

class GetZoneRequest extends $pb.GeneratedMessage {
  factory GetZoneRequest({
    $core.String? zoneId,
  }) {
    final $result = create();
    if (zoneId != null) {
      $result.zoneId = zoneId;
    }
    return $result;
  }
  GetZoneRequest._() : super();
  factory GetZoneRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetZoneRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetZoneRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'zoneId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetZoneRequest clone() => GetZoneRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetZoneRequest copyWith(void Function(GetZoneRequest) updates) => super.copyWith((message) => updates(message as GetZoneRequest)) as GetZoneRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetZoneRequest create() => GetZoneRequest._();
  GetZoneRequest createEmptyInstance() => create();
  static $pb.PbList<GetZoneRequest> createRepeated() => $pb.PbList<GetZoneRequest>();
  @$core.pragma('dart2js:noInline')
  static GetZoneRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetZoneRequest>(create);
  static GetZoneRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get zoneId => $_getSZ(0);
  @$pb.TagNumber(1)
  set zoneId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasZoneId() => $_has(0);
  @$pb.TagNumber(1)
  void clearZoneId() => $_clearField(1);
}

class GetZoneResponse extends $pb.GeneratedMessage {
  factory GetZoneResponse({
    Zone? zone,
  }) {
    final $result = create();
    if (zone != null) {
      $result.zone = zone;
    }
    return $result;
  }
  GetZoneResponse._() : super();
  factory GetZoneResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetZoneResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetZoneResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOM<Zone>(1, _omitFieldNames ? '' : 'zone', subBuilder: Zone.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetZoneResponse clone() => GetZoneResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetZoneResponse copyWith(void Function(GetZoneResponse) updates) => super.copyWith((message) => updates(message as GetZoneResponse)) as GetZoneResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetZoneResponse create() => GetZoneResponse._();
  GetZoneResponse createEmptyInstance() => create();
  static $pb.PbList<GetZoneResponse> createRepeated() => $pb.PbList<GetZoneResponse>();
  @$core.pragma('dart2js:noInline')
  static GetZoneResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetZoneResponse>(create);
  static GetZoneResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Zone get zone => $_getN(0);
  @$pb.TagNumber(1)
  set zone(Zone v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasZone() => $_has(0);
  @$pb.TagNumber(1)
  void clearZone() => $_clearField(1);
  @$pb.TagNumber(1)
  Zone ensureZone() => $_ensure(0);
}

class ListZonesRequest extends $pb.GeneratedMessage {
  factory ListZonesRequest({
    $core.String? projectId,
    ZoneType? zoneType,
    ZoneCategory? zoneCategory,
    ZoneStatus? zoneStatus,
    $core.String? searchQuery,
    $core.int? limit,
    $core.int? offset,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (zoneType != null) {
      $result.zoneType = zoneType;
    }
    if (zoneCategory != null) {
      $result.zoneCategory = zoneCategory;
    }
    if (zoneStatus != null) {
      $result.zoneStatus = zoneStatus;
    }
    if (searchQuery != null) {
      $result.searchQuery = searchQuery;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    if (offset != null) {
      $result.offset = offset;
    }
    return $result;
  }
  ListZonesRequest._() : super();
  factory ListZonesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListZonesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListZonesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<ZoneType>(2, _omitFieldNames ? '' : 'zoneType', $pb.PbFieldType.OE, defaultOrMaker: ZoneType.ZONE_TYPE_UNSPECIFIED, valueOf: ZoneType.valueOf, enumValues: ZoneType.values)
    ..e<ZoneCategory>(3, _omitFieldNames ? '' : 'zoneCategory', $pb.PbFieldType.OE, defaultOrMaker: ZoneCategory.ZONE_CATEGORY_UNSPECIFIED, valueOf: ZoneCategory.valueOf, enumValues: ZoneCategory.values)
    ..e<ZoneStatus>(4, _omitFieldNames ? '' : 'zoneStatus', $pb.PbFieldType.OE, defaultOrMaker: ZoneStatus.ZONE_STATUS_UNSPECIFIED, valueOf: ZoneStatus.valueOf, enumValues: ZoneStatus.values)
    ..aOS(5, _omitFieldNames ? '' : 'searchQuery')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListZonesRequest clone() => ListZonesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListZonesRequest copyWith(void Function(ListZonesRequest) updates) => super.copyWith((message) => updates(message as ListZonesRequest)) as ListZonesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListZonesRequest create() => ListZonesRequest._();
  ListZonesRequest createEmptyInstance() => create();
  static $pb.PbList<ListZonesRequest> createRepeated() => $pb.PbList<ListZonesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListZonesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListZonesRequest>(create);
  static ListZonesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  ZoneType get zoneType => $_getN(1);
  @$pb.TagNumber(2)
  set zoneType(ZoneType v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasZoneType() => $_has(1);
  @$pb.TagNumber(2)
  void clearZoneType() => $_clearField(2);

  @$pb.TagNumber(3)
  ZoneCategory get zoneCategory => $_getN(2);
  @$pb.TagNumber(3)
  set zoneCategory(ZoneCategory v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasZoneCategory() => $_has(2);
  @$pb.TagNumber(3)
  void clearZoneCategory() => $_clearField(3);

  @$pb.TagNumber(4)
  ZoneStatus get zoneStatus => $_getN(3);
  @$pb.TagNumber(4)
  set zoneStatus(ZoneStatus v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasZoneStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearZoneStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get searchQuery => $_getSZ(4);
  @$pb.TagNumber(5)
  set searchQuery($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSearchQuery() => $_has(4);
  @$pb.TagNumber(5)
  void clearSearchQuery() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get limit => $_getIZ(5);
  @$pb.TagNumber(6)
  set limit($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLimit() => $_has(5);
  @$pb.TagNumber(6)
  void clearLimit() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get offset => $_getIZ(6);
  @$pb.TagNumber(7)
  set offset($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasOffset() => $_has(6);
  @$pb.TagNumber(7)
  void clearOffset() => $_clearField(7);
}

class ListZonesResponse extends $pb.GeneratedMessage {
  factory ListZonesResponse({
    $core.Iterable<Zone>? zones,
    $fixnum.Int64? totalCount,
  }) {
    final $result = create();
    if (zones != null) {
      $result.zones.addAll(zones);
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    return $result;
  }
  ListZonesResponse._() : super();
  factory ListZonesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListZonesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListZonesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..pc<Zone>(1, _omitFieldNames ? '' : 'zones', $pb.PbFieldType.PM, subBuilder: Zone.create)
    ..aInt64(2, _omitFieldNames ? '' : 'totalCount')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListZonesResponse clone() => ListZonesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListZonesResponse copyWith(void Function(ListZonesResponse) updates) => super.copyWith((message) => updates(message as ListZonesResponse)) as ListZonesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListZonesResponse create() => ListZonesResponse._();
  ListZonesResponse createEmptyInstance() => create();
  static $pb.PbList<ListZonesResponse> createRepeated() => $pb.PbList<ListZonesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListZonesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListZonesResponse>(create);
  static ListZonesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Zone> get zones => $_getList(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalCount => $_getI64(1);
  @$pb.TagNumber(2)
  set totalCount($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

class QueryZonesByLocationRequest extends $pb.GeneratedMessage {
  factory QueryZonesByLocationRequest({
    $core.String? projectId,
    $core.double? latitude,
    $core.double? longitude,
    $core.double? searchRadiusMeters,
    ZoneType? zoneType,
    $core.int? limit,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (searchRadiusMeters != null) {
      $result.searchRadiusMeters = searchRadiusMeters;
    }
    if (zoneType != null) {
      $result.zoneType = zoneType;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    return $result;
  }
  QueryZonesByLocationRequest._() : super();
  factory QueryZonesByLocationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryZonesByLocationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'QueryZonesByLocationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OF)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OF)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'searchRadiusMeters', $pb.PbFieldType.OF)
    ..e<ZoneType>(5, _omitFieldNames ? '' : 'zoneType', $pb.PbFieldType.OE, defaultOrMaker: ZoneType.ZONE_TYPE_UNSPECIFIED, valueOf: ZoneType.valueOf, enumValues: ZoneType.values)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryZonesByLocationRequest clone() => QueryZonesByLocationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryZonesByLocationRequest copyWith(void Function(QueryZonesByLocationRequest) updates) => super.copyWith((message) => updates(message as QueryZonesByLocationRequest)) as QueryZonesByLocationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QueryZonesByLocationRequest create() => QueryZonesByLocationRequest._();
  QueryZonesByLocationRequest createEmptyInstance() => create();
  static $pb.PbList<QueryZonesByLocationRequest> createRepeated() => $pb.PbList<QueryZonesByLocationRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryZonesByLocationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryZonesByLocationRequest>(create);
  static QueryZonesByLocationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get latitude => $_getN(1);
  @$pb.TagNumber(2)
  set latitude($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLatitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get longitude => $_getN(2);
  @$pb.TagNumber(3)
  set longitude($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLongitude() => $_has(2);
  @$pb.TagNumber(3)
  void clearLongitude() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get searchRadiusMeters => $_getN(3);
  @$pb.TagNumber(4)
  set searchRadiusMeters($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSearchRadiusMeters() => $_has(3);
  @$pb.TagNumber(4)
  void clearSearchRadiusMeters() => $_clearField(4);

  @$pb.TagNumber(5)
  ZoneType get zoneType => $_getN(4);
  @$pb.TagNumber(5)
  set zoneType(ZoneType v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasZoneType() => $_has(4);
  @$pb.TagNumber(5)
  void clearZoneType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get limit => $_getIZ(5);
  @$pb.TagNumber(6)
  set limit($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLimit() => $_has(5);
  @$pb.TagNumber(6)
  void clearLimit() => $_clearField(6);
}

class QueryZonesByLocationResponse extends $pb.GeneratedMessage {
  factory QueryZonesByLocationResponse({
    $core.Iterable<Zone>? nearbyZones,
    $core.Iterable<SitingConflict>? potentialConflicts,
    $0.BoundingBox2D? aggregatedBounds,
  }) {
    final $result = create();
    if (nearbyZones != null) {
      $result.nearbyZones.addAll(nearbyZones);
    }
    if (potentialConflicts != null) {
      $result.potentialConflicts.addAll(potentialConflicts);
    }
    if (aggregatedBounds != null) {
      $result.aggregatedBounds = aggregatedBounds;
    }
    return $result;
  }
  QueryZonesByLocationResponse._() : super();
  factory QueryZonesByLocationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryZonesByLocationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'QueryZonesByLocationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..pc<Zone>(1, _omitFieldNames ? '' : 'nearbyZones', $pb.PbFieldType.PM, subBuilder: Zone.create)
    ..pc<SitingConflict>(2, _omitFieldNames ? '' : 'potentialConflicts', $pb.PbFieldType.PM, subBuilder: SitingConflict.create)
    ..aOM<$0.BoundingBox2D>(3, _omitFieldNames ? '' : 'aggregatedBounds', subBuilder: $0.BoundingBox2D.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryZonesByLocationResponse clone() => QueryZonesByLocationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryZonesByLocationResponse copyWith(void Function(QueryZonesByLocationResponse) updates) => super.copyWith((message) => updates(message as QueryZonesByLocationResponse)) as QueryZonesByLocationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QueryZonesByLocationResponse create() => QueryZonesByLocationResponse._();
  QueryZonesByLocationResponse createEmptyInstance() => create();
  static $pb.PbList<QueryZonesByLocationResponse> createRepeated() => $pb.PbList<QueryZonesByLocationResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryZonesByLocationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryZonesByLocationResponse>(create);
  static QueryZonesByLocationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Zone> get nearbyZones => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<SitingConflict> get potentialConflicts => $_getList(1);

  @$pb.TagNumber(3)
  $0.BoundingBox2D get aggregatedBounds => $_getN(2);
  @$pb.TagNumber(3)
  set aggregatedBounds($0.BoundingBox2D v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAggregatedBounds() => $_has(2);
  @$pb.TagNumber(3)
  void clearAggregatedBounds() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.BoundingBox2D ensureAggregatedBounds() => $_ensure(2);
}

class CheckSitingConflictsRequest extends $pb.GeneratedMessage {
  factory CheckSitingConflictsRequest({
    $core.String? projectId,
    $core.String? proposedSiteGeometryWkt,
    $core.String? geometryType,
    $0.BoundingBox2D? geometryBounds,
    $core.Iterable<ZoneType>? checkZoneTypes,
    $core.bool? includeBufferZones,
    $core.bool? includeExpiredZones,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (proposedSiteGeometryWkt != null) {
      $result.proposedSiteGeometryWkt = proposedSiteGeometryWkt;
    }
    if (geometryType != null) {
      $result.geometryType = geometryType;
    }
    if (geometryBounds != null) {
      $result.geometryBounds = geometryBounds;
    }
    if (checkZoneTypes != null) {
      $result.checkZoneTypes.addAll(checkZoneTypes);
    }
    if (includeBufferZones != null) {
      $result.includeBufferZones = includeBufferZones;
    }
    if (includeExpiredZones != null) {
      $result.includeExpiredZones = includeExpiredZones;
    }
    return $result;
  }
  CheckSitingConflictsRequest._() : super();
  factory CheckSitingConflictsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CheckSitingConflictsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CheckSitingConflictsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'proposedSiteGeometryWkt')
    ..aOS(3, _omitFieldNames ? '' : 'geometryType')
    ..aOM<$0.BoundingBox2D>(4, _omitFieldNames ? '' : 'geometryBounds', subBuilder: $0.BoundingBox2D.create)
    ..pc<ZoneType>(5, _omitFieldNames ? '' : 'checkZoneTypes', $pb.PbFieldType.KE, valueOf: ZoneType.valueOf, enumValues: ZoneType.values, defaultEnumValue: ZoneType.ZONE_TYPE_UNSPECIFIED)
    ..aOB(6, _omitFieldNames ? '' : 'includeBufferZones')
    ..aOB(7, _omitFieldNames ? '' : 'includeExpiredZones')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CheckSitingConflictsRequest clone() => CheckSitingConflictsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CheckSitingConflictsRequest copyWith(void Function(CheckSitingConflictsRequest) updates) => super.copyWith((message) => updates(message as CheckSitingConflictsRequest)) as CheckSitingConflictsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckSitingConflictsRequest create() => CheckSitingConflictsRequest._();
  CheckSitingConflictsRequest createEmptyInstance() => create();
  static $pb.PbList<CheckSitingConflictsRequest> createRepeated() => $pb.PbList<CheckSitingConflictsRequest>();
  @$core.pragma('dart2js:noInline')
  static CheckSitingConflictsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckSitingConflictsRequest>(create);
  static CheckSitingConflictsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get proposedSiteGeometryWkt => $_getSZ(1);
  @$pb.TagNumber(2)
  set proposedSiteGeometryWkt($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProposedSiteGeometryWkt() => $_has(1);
  @$pb.TagNumber(2)
  void clearProposedSiteGeometryWkt() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get geometryType => $_getSZ(2);
  @$pb.TagNumber(3)
  set geometryType($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGeometryType() => $_has(2);
  @$pb.TagNumber(3)
  void clearGeometryType() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.BoundingBox2D get geometryBounds => $_getN(3);
  @$pb.TagNumber(4)
  set geometryBounds($0.BoundingBox2D v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasGeometryBounds() => $_has(3);
  @$pb.TagNumber(4)
  void clearGeometryBounds() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.BoundingBox2D ensureGeometryBounds() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<ZoneType> get checkZoneTypes => $_getList(4);

  @$pb.TagNumber(6)
  $core.bool get includeBufferZones => $_getBF(5);
  @$pb.TagNumber(6)
  set includeBufferZones($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIncludeBufferZones() => $_has(5);
  @$pb.TagNumber(6)
  void clearIncludeBufferZones() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get includeExpiredZones => $_getBF(6);
  @$pb.TagNumber(7)
  set includeExpiredZones($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIncludeExpiredZones() => $_has(6);
  @$pb.TagNumber(7)
  void clearIncludeExpiredZones() => $_clearField(7);
}

class CheckSitingConflictsResponse extends $pb.GeneratedMessage {
  factory CheckSitingConflictsResponse({
    $core.Iterable<SitingConflict>? conflicts,
    RiskScore? riskScore,
    $core.String? sitingRecommendation,
    $core.int? totalZonesChecked,
  }) {
    final $result = create();
    if (conflicts != null) {
      $result.conflicts.addAll(conflicts);
    }
    if (riskScore != null) {
      $result.riskScore = riskScore;
    }
    if (sitingRecommendation != null) {
      $result.sitingRecommendation = sitingRecommendation;
    }
    if (totalZonesChecked != null) {
      $result.totalZonesChecked = totalZonesChecked;
    }
    return $result;
  }
  CheckSitingConflictsResponse._() : super();
  factory CheckSitingConflictsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CheckSitingConflictsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CheckSitingConflictsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..pc<SitingConflict>(1, _omitFieldNames ? '' : 'conflicts', $pb.PbFieldType.PM, subBuilder: SitingConflict.create)
    ..aOM<RiskScore>(2, _omitFieldNames ? '' : 'riskScore', subBuilder: RiskScore.create)
    ..aOS(3, _omitFieldNames ? '' : 'sitingRecommendation')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'totalZonesChecked', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CheckSitingConflictsResponse clone() => CheckSitingConflictsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CheckSitingConflictsResponse copyWith(void Function(CheckSitingConflictsResponse) updates) => super.copyWith((message) => updates(message as CheckSitingConflictsResponse)) as CheckSitingConflictsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CheckSitingConflictsResponse create() => CheckSitingConflictsResponse._();
  CheckSitingConflictsResponse createEmptyInstance() => create();
  static $pb.PbList<CheckSitingConflictsResponse> createRepeated() => $pb.PbList<CheckSitingConflictsResponse>();
  @$core.pragma('dart2js:noInline')
  static CheckSitingConflictsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckSitingConflictsResponse>(create);
  static CheckSitingConflictsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SitingConflict> get conflicts => $_getList(0);

  @$pb.TagNumber(2)
  RiskScore get riskScore => $_getN(1);
  @$pb.TagNumber(2)
  set riskScore(RiskScore v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRiskScore() => $_has(1);
  @$pb.TagNumber(2)
  void clearRiskScore() => $_clearField(2);
  @$pb.TagNumber(2)
  RiskScore ensureRiskScore() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get sitingRecommendation => $_getSZ(2);
  @$pb.TagNumber(3)
  set sitingRecommendation($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSitingRecommendation() => $_has(2);
  @$pb.TagNumber(3)
  void clearSitingRecommendation() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get totalZonesChecked => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalZonesChecked($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalZonesChecked() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalZonesChecked() => $_clearField(4);
}

class ListZoneCategoriesRequest extends $pb.GeneratedMessage {
  factory ListZoneCategoriesRequest() => create();
  ListZoneCategoriesRequest._() : super();
  factory ListZoneCategoriesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListZoneCategoriesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListZoneCategoriesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListZoneCategoriesRequest clone() => ListZoneCategoriesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListZoneCategoriesRequest copyWith(void Function(ListZoneCategoriesRequest) updates) => super.copyWith((message) => updates(message as ListZoneCategoriesRequest)) as ListZoneCategoriesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListZoneCategoriesRequest create() => ListZoneCategoriesRequest._();
  ListZoneCategoriesRequest createEmptyInstance() => create();
  static $pb.PbList<ListZoneCategoriesRequest> createRepeated() => $pb.PbList<ListZoneCategoriesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListZoneCategoriesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListZoneCategoriesRequest>(create);
  static ListZoneCategoriesRequest? _defaultInstance;
}

class ListZoneCategoriesResponse extends $pb.GeneratedMessage {
  factory ListZoneCategoriesResponse({
    $core.Iterable<CategoryDef>? categories,
  }) {
    final $result = create();
    if (categories != null) {
      $result.categories.addAll(categories);
    }
    return $result;
  }
  ListZoneCategoriesResponse._() : super();
  factory ListZoneCategoriesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListZoneCategoriesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListZoneCategoriesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'constraint.v1'), createEmptyInstance: create)
    ..pc<CategoryDef>(1, _omitFieldNames ? '' : 'categories', $pb.PbFieldType.PM, subBuilder: CategoryDef.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListZoneCategoriesResponse clone() => ListZoneCategoriesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListZoneCategoriesResponse copyWith(void Function(ListZoneCategoriesResponse) updates) => super.copyWith((message) => updates(message as ListZoneCategoriesResponse)) as ListZoneCategoriesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListZoneCategoriesResponse create() => ListZoneCategoriesResponse._();
  ListZoneCategoriesResponse createEmptyInstance() => create();
  static $pb.PbList<ListZoneCategoriesResponse> createRepeated() => $pb.PbList<ListZoneCategoriesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListZoneCategoriesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListZoneCategoriesResponse>(create);
  static ListZoneCategoriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<CategoryDef> get categories => $_getList(0);
}

/// ConstraintZoneService provides zone management and siting conflict analysis.
class ConstraintZoneServiceApi {
  $pb.RpcClient _client;
  ConstraintZoneServiceApi(this._client);

  /// CreateZone creates a new constraint zone.
  $async.Future<CreateZoneResponse> createZone($pb.ClientContext? ctx, CreateZoneRequest request) =>
    _client.invoke<CreateZoneResponse>(ctx, 'ConstraintZoneService', 'CreateZone', request, CreateZoneResponse())
  ;
  /// UpdateZone updates an existing zone.
  $async.Future<UpdateZoneResponse> updateZone($pb.ClientContext? ctx, UpdateZoneRequest request) =>
    _client.invoke<UpdateZoneResponse>(ctx, 'ConstraintZoneService', 'UpdateZone', request, UpdateZoneResponse())
  ;
  /// DeleteZone removes a zone (soft delete with audit trail).
  $async.Future<DeleteZoneResponse> deleteZone($pb.ClientContext? ctx, DeleteZoneRequest request) =>
    _client.invoke<DeleteZoneResponse>(ctx, 'ConstraintZoneService', 'DeleteZone', request, DeleteZoneResponse())
  ;
  /// GetZone retrieves a single zone by ID.
  $async.Future<GetZoneResponse> getZone($pb.ClientContext? ctx, GetZoneRequest request) =>
    _client.invoke<GetZoneResponse>(ctx, 'ConstraintZoneService', 'GetZone', request, GetZoneResponse())
  ;
  /// ListZones lists zones with filtering and pagination.
  $async.Future<ListZonesResponse> listZones($pb.ClientContext? ctx, ListZonesRequest request) =>
    _client.invoke<ListZonesResponse>(ctx, 'ConstraintZoneService', 'ListZones', request, ListZonesResponse())
  ;
  /// QueryZonesByLocation finds zones intersecting/containing a location or geometry.
  $async.Future<QueryZonesByLocationResponse> queryZonesByLocation($pb.ClientContext? ctx, QueryZonesByLocationRequest request) =>
    _client.invoke<QueryZonesByLocationResponse>(ctx, 'ConstraintZoneService', 'QueryZonesByLocation', request, QueryZonesByLocationResponse())
  ;
  /// CheckSitingConflicts analyzes proposed landing site against constraint zones.
  $async.Future<CheckSitingConflictsResponse> checkSitingConflicts($pb.ClientContext? ctx, CheckSitingConflictsRequest request) =>
    _client.invoke<CheckSitingConflictsResponse>(ctx, 'ConstraintZoneService', 'CheckSitingConflicts', request, CheckSitingConflictsResponse())
  ;
  /// ListZoneCategories returns available zone category taxonomy.
  $async.Future<ListZoneCategoriesResponse> listZoneCategories($pb.ClientContext? ctx, ListZoneCategoriesRequest request) =>
    _client.invoke<ListZoneCategoriesResponse>(ctx, 'ConstraintZoneService', 'ListZoneCategories', request, ListZoneCategoriesResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
