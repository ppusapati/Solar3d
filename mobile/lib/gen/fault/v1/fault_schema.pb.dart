//
//  Generated code. Do not modify.
//  source: fault/v1/fault_schema.proto
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
import 'fault_schema.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'fault_schema.pbenum.dart';

/// FaultEvent represents a single operational fault detected in a provisioned
/// digital twin asset.  All audit fields (detected_at, acknowledged_at,
/// resolved_at) are immutable once set.
class FaultEvent extends $pb.GeneratedMessage {
  factory FaultEvent({
    $core.String? id,
    $core.String? twinId,
    $core.String? projectId,
    $core.String? assetIdentityId,
    $core.String? faultCode,
    FaultType? faultType,
    FaultSeverity? severity,
    $core.String? description,
    FaultStatus? status,
    $core.String? sourceSystem,
    $0.Timestamp? detectedAt,
    $0.Timestamp? acknowledgedAt,
    $core.String? acknowledgedByActorId,
    $0.Timestamp? resolvedAt,
    $core.String? resolvedByActorId,
    $core.String? resolutionNotes,
    $core.String? metadataJson,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (assetIdentityId != null) {
      $result.assetIdentityId = assetIdentityId;
    }
    if (faultCode != null) {
      $result.faultCode = faultCode;
    }
    if (faultType != null) {
      $result.faultType = faultType;
    }
    if (severity != null) {
      $result.severity = severity;
    }
    if (description != null) {
      $result.description = description;
    }
    if (status != null) {
      $result.status = status;
    }
    if (sourceSystem != null) {
      $result.sourceSystem = sourceSystem;
    }
    if (detectedAt != null) {
      $result.detectedAt = detectedAt;
    }
    if (acknowledgedAt != null) {
      $result.acknowledgedAt = acknowledgedAt;
    }
    if (acknowledgedByActorId != null) {
      $result.acknowledgedByActorId = acknowledgedByActorId;
    }
    if (resolvedAt != null) {
      $result.resolvedAt = resolvedAt;
    }
    if (resolvedByActorId != null) {
      $result.resolvedByActorId = resolvedByActorId;
    }
    if (resolutionNotes != null) {
      $result.resolutionNotes = resolutionNotes;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    return $result;
  }
  FaultEvent._() : super();
  factory FaultEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FaultEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FaultEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'fault.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'twinId')
    ..aOS(3, _omitFieldNames ? '' : 'projectId')
    ..aOS(4, _omitFieldNames ? '' : 'assetIdentityId')
    ..aOS(5, _omitFieldNames ? '' : 'faultCode')
    ..e<FaultType>(6, _omitFieldNames ? '' : 'faultType', $pb.PbFieldType.OE, defaultOrMaker: FaultType.FAULT_TYPE_UNSPECIFIED, valueOf: FaultType.valueOf, enumValues: FaultType.values)
    ..e<FaultSeverity>(7, _omitFieldNames ? '' : 'severity', $pb.PbFieldType.OE, defaultOrMaker: FaultSeverity.FAULT_SEVERITY_UNSPECIFIED, valueOf: FaultSeverity.valueOf, enumValues: FaultSeverity.values)
    ..aOS(8, _omitFieldNames ? '' : 'description')
    ..e<FaultStatus>(9, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: FaultStatus.FAULT_STATUS_UNSPECIFIED, valueOf: FaultStatus.valueOf, enumValues: FaultStatus.values)
    ..aOS(10, _omitFieldNames ? '' : 'sourceSystem')
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'detectedAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'acknowledgedAt', subBuilder: $0.Timestamp.create)
    ..aOS(13, _omitFieldNames ? '' : 'acknowledgedByActorId')
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'resolvedAt', subBuilder: $0.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'resolvedByActorId')
    ..aOS(16, _omitFieldNames ? '' : 'resolutionNotes')
    ..aOS(17, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$0.Timestamp>(18, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(19, _omitFieldNames ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FaultEvent clone() => FaultEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FaultEvent copyWith(void Function(FaultEvent) updates) => super.copyWith((message) => updates(message as FaultEvent)) as FaultEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FaultEvent create() => FaultEvent._();
  FaultEvent createEmptyInstance() => create();
  static $pb.PbList<FaultEvent> createRepeated() => $pb.PbList<FaultEvent>();
  @$core.pragma('dart2js:noInline')
  static FaultEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FaultEvent>(create);
  static FaultEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// twin_id: The digital twin in which the fault was detected.
  @$pb.TagNumber(2)
  $core.String get twinId => $_getSZ(1);
  @$pb.TagNumber(2)
  set twinId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTwinId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTwinId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get projectId => $_getSZ(2);
  @$pb.TagNumber(3)
  set projectId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProjectId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProjectId() => $_clearField(3);

  /// asset_identity_id: Optional — links to the physical asset that triggered the fault.
  @$pb.TagNumber(4)
  $core.String get assetIdentityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set assetIdentityId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAssetIdentityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssetIdentityId() => $_clearField(4);

  /// fault_code: Vendor or standard fault code (e.g., IEC 60255 relay alarm code,
  /// inverter manufacturer alarm ID, or IEC 61724-1 energy loss category code).
  @$pb.TagNumber(5)
  $core.String get faultCode => $_getSZ(4);
  @$pb.TagNumber(5)
  set faultCode($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFaultCode() => $_has(4);
  @$pb.TagNumber(5)
  void clearFaultCode() => $_clearField(5);

  @$pb.TagNumber(6)
  FaultType get faultType => $_getN(5);
  @$pb.TagNumber(6)
  set faultType(FaultType v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasFaultType() => $_has(5);
  @$pb.TagNumber(6)
  void clearFaultType() => $_clearField(6);

  @$pb.TagNumber(7)
  FaultSeverity get severity => $_getN(6);
  @$pb.TagNumber(7)
  set severity(FaultSeverity v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasSeverity() => $_has(6);
  @$pb.TagNumber(7)
  void clearSeverity() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get description => $_getSZ(7);
  @$pb.TagNumber(8)
  set description($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasDescription() => $_has(7);
  @$pb.TagNumber(8)
  void clearDescription() => $_clearField(8);

  @$pb.TagNumber(9)
  FaultStatus get status => $_getN(8);
  @$pb.TagNumber(9)
  set status(FaultStatus v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearStatus() => $_clearField(9);

  /// source_system: Originating system (e.g., "SCADA", "protection_relay", "manual", "telemetry").
  @$pb.TagNumber(10)
  $core.String get sourceSystem => $_getSZ(9);
  @$pb.TagNumber(10)
  set sourceSystem($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSourceSystem() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourceSystem() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get detectedAt => $_getN(10);
  @$pb.TagNumber(11)
  set detectedAt($0.Timestamp v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasDetectedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearDetectedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureDetectedAt() => $_ensure(10);

  /// acknowledged_at: Set when AcknowledgeFault is called; empty if not yet acknowledged.
  @$pb.TagNumber(12)
  $0.Timestamp get acknowledgedAt => $_getN(11);
  @$pb.TagNumber(12)
  set acknowledgedAt($0.Timestamp v) { $_setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasAcknowledgedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearAcknowledgedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureAcknowledgedAt() => $_ensure(11);

  /// acknowledged_by_actor_id: Operator who acknowledged the fault.
  @$pb.TagNumber(13)
  $core.String get acknowledgedByActorId => $_getSZ(12);
  @$pb.TagNumber(13)
  set acknowledgedByActorId($core.String v) { $_setString(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasAcknowledgedByActorId() => $_has(12);
  @$pb.TagNumber(13)
  void clearAcknowledgedByActorId() => $_clearField(13);

  /// resolved_at: Set when ResolveFault is called; empty if not yet resolved.
  @$pb.TagNumber(14)
  $0.Timestamp get resolvedAt => $_getN(13);
  @$pb.TagNumber(14)
  set resolvedAt($0.Timestamp v) { $_setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasResolvedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearResolvedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureResolvedAt() => $_ensure(13);

  /// resolved_by_actor_id: Operator who resolved the fault.
  @$pb.TagNumber(15)
  $core.String get resolvedByActorId => $_getSZ(14);
  @$pb.TagNumber(15)
  set resolvedByActorId($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasResolvedByActorId() => $_has(14);
  @$pb.TagNumber(15)
  void clearResolvedByActorId() => $_clearField(15);

  /// resolution_notes: Free-form description of corrective action taken.
  @$pb.TagNumber(16)
  $core.String get resolutionNotes => $_getSZ(15);
  @$pb.TagNumber(16)
  set resolutionNotes($core.String v) { $_setString(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasResolutionNotes() => $_has(15);
  @$pb.TagNumber(16)
  void clearResolutionNotes() => $_clearField(16);

  /// metadata_json: Optional JSON for SCADA-specific event payload or vendor diagnostics.
  @$pb.TagNumber(17)
  $core.String get metadataJson => $_getSZ(16);
  @$pb.TagNumber(17)
  set metadataJson($core.String v) { $_setString(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasMetadataJson() => $_has(16);
  @$pb.TagNumber(17)
  void clearMetadataJson() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.Timestamp get createdAt => $_getN(17);
  @$pb.TagNumber(18)
  set createdAt($0.Timestamp v) { $_setField(18, v); }
  @$pb.TagNumber(18)
  $core.bool hasCreatedAt() => $_has(17);
  @$pb.TagNumber(18)
  void clearCreatedAt() => $_clearField(18);
  @$pb.TagNumber(18)
  $0.Timestamp ensureCreatedAt() => $_ensure(17);

  @$pb.TagNumber(19)
  $0.Timestamp get updatedAt => $_getN(18);
  @$pb.TagNumber(19)
  set updatedAt($0.Timestamp v) { $_setField(19, v); }
  @$pb.TagNumber(19)
  $core.bool hasUpdatedAt() => $_has(18);
  @$pb.TagNumber(19)
  void clearUpdatedAt() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.Timestamp ensureUpdatedAt() => $_ensure(18);
}

class ReportFaultRequest extends $pb.GeneratedMessage {
  factory ReportFaultRequest({
    $core.String? twinId,
    $core.String? projectId,
    $core.String? assetIdentityId,
    $core.String? faultCode,
    FaultType? faultType,
    FaultSeverity? severity,
    $core.String? description,
    $core.String? sourceSystem,
    $0.Timestamp? detectedAt,
    $core.String? metadataJson,
  }) {
    final $result = create();
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (assetIdentityId != null) {
      $result.assetIdentityId = assetIdentityId;
    }
    if (faultCode != null) {
      $result.faultCode = faultCode;
    }
    if (faultType != null) {
      $result.faultType = faultType;
    }
    if (severity != null) {
      $result.severity = severity;
    }
    if (description != null) {
      $result.description = description;
    }
    if (sourceSystem != null) {
      $result.sourceSystem = sourceSystem;
    }
    if (detectedAt != null) {
      $result.detectedAt = detectedAt;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    return $result;
  }
  ReportFaultRequest._() : super();
  factory ReportFaultRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReportFaultRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReportFaultRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'fault.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'twinId')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'assetIdentityId')
    ..aOS(4, _omitFieldNames ? '' : 'faultCode')
    ..e<FaultType>(5, _omitFieldNames ? '' : 'faultType', $pb.PbFieldType.OE, defaultOrMaker: FaultType.FAULT_TYPE_UNSPECIFIED, valueOf: FaultType.valueOf, enumValues: FaultType.values)
    ..e<FaultSeverity>(6, _omitFieldNames ? '' : 'severity', $pb.PbFieldType.OE, defaultOrMaker: FaultSeverity.FAULT_SEVERITY_UNSPECIFIED, valueOf: FaultSeverity.valueOf, enumValues: FaultSeverity.values)
    ..aOS(7, _omitFieldNames ? '' : 'description')
    ..aOS(8, _omitFieldNames ? '' : 'sourceSystem')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'detectedAt', subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'metadataJson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReportFaultRequest clone() => ReportFaultRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReportFaultRequest copyWith(void Function(ReportFaultRequest) updates) => super.copyWith((message) => updates(message as ReportFaultRequest)) as ReportFaultRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportFaultRequest create() => ReportFaultRequest._();
  ReportFaultRequest createEmptyInstance() => create();
  static $pb.PbList<ReportFaultRequest> createRepeated() => $pb.PbList<ReportFaultRequest>();
  @$core.pragma('dart2js:noInline')
  static ReportFaultRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportFaultRequest>(create);
  static ReportFaultRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get twinId => $_getSZ(0);
  @$pb.TagNumber(1)
  set twinId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwinId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get projectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set projectId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get assetIdentityId => $_getSZ(2);
  @$pb.TagNumber(3)
  set assetIdentityId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAssetIdentityId() => $_has(2);
  @$pb.TagNumber(3)
  void clearAssetIdentityId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get faultCode => $_getSZ(3);
  @$pb.TagNumber(4)
  set faultCode($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFaultCode() => $_has(3);
  @$pb.TagNumber(4)
  void clearFaultCode() => $_clearField(4);

  @$pb.TagNumber(5)
  FaultType get faultType => $_getN(4);
  @$pb.TagNumber(5)
  set faultType(FaultType v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasFaultType() => $_has(4);
  @$pb.TagNumber(5)
  void clearFaultType() => $_clearField(5);

  @$pb.TagNumber(6)
  FaultSeverity get severity => $_getN(5);
  @$pb.TagNumber(6)
  set severity(FaultSeverity v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasSeverity() => $_has(5);
  @$pb.TagNumber(6)
  void clearSeverity() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get description => $_getSZ(6);
  @$pb.TagNumber(7)
  set description($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasDescription() => $_has(6);
  @$pb.TagNumber(7)
  void clearDescription() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get sourceSystem => $_getSZ(7);
  @$pb.TagNumber(8)
  set sourceSystem($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSourceSystem() => $_has(7);
  @$pb.TagNumber(8)
  void clearSourceSystem() => $_clearField(8);

  /// detected_at: Caller-supplied detection time; defaults to server time if empty.
  @$pb.TagNumber(9)
  $0.Timestamp get detectedAt => $_getN(8);
  @$pb.TagNumber(9)
  set detectedAt($0.Timestamp v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasDetectedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearDetectedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureDetectedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $core.String get metadataJson => $_getSZ(9);
  @$pb.TagNumber(10)
  set metadataJson($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasMetadataJson() => $_has(9);
  @$pb.TagNumber(10)
  void clearMetadataJson() => $_clearField(10);
}

class ReportFaultResponse extends $pb.GeneratedMessage {
  factory ReportFaultResponse({
    FaultEvent? faultEvent,
  }) {
    final $result = create();
    if (faultEvent != null) {
      $result.faultEvent = faultEvent;
    }
    return $result;
  }
  ReportFaultResponse._() : super();
  factory ReportFaultResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ReportFaultResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReportFaultResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'fault.v1'), createEmptyInstance: create)
    ..aOM<FaultEvent>(1, _omitFieldNames ? '' : 'faultEvent', subBuilder: FaultEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ReportFaultResponse clone() => ReportFaultResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ReportFaultResponse copyWith(void Function(ReportFaultResponse) updates) => super.copyWith((message) => updates(message as ReportFaultResponse)) as ReportFaultResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportFaultResponse create() => ReportFaultResponse._();
  ReportFaultResponse createEmptyInstance() => create();
  static $pb.PbList<ReportFaultResponse> createRepeated() => $pb.PbList<ReportFaultResponse>();
  @$core.pragma('dart2js:noInline')
  static ReportFaultResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportFaultResponse>(create);
  static ReportFaultResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FaultEvent get faultEvent => $_getN(0);
  @$pb.TagNumber(1)
  set faultEvent(FaultEvent v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFaultEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearFaultEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  FaultEvent ensureFaultEvent() => $_ensure(0);
}

class GetFaultRequest extends $pb.GeneratedMessage {
  factory GetFaultRequest({
    $core.String? faultId,
  }) {
    final $result = create();
    if (faultId != null) {
      $result.faultId = faultId;
    }
    return $result;
  }
  GetFaultRequest._() : super();
  factory GetFaultRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFaultRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetFaultRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'fault.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'faultId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFaultRequest clone() => GetFaultRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFaultRequest copyWith(void Function(GetFaultRequest) updates) => super.copyWith((message) => updates(message as GetFaultRequest)) as GetFaultRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFaultRequest create() => GetFaultRequest._();
  GetFaultRequest createEmptyInstance() => create();
  static $pb.PbList<GetFaultRequest> createRepeated() => $pb.PbList<GetFaultRequest>();
  @$core.pragma('dart2js:noInline')
  static GetFaultRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFaultRequest>(create);
  static GetFaultRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get faultId => $_getSZ(0);
  @$pb.TagNumber(1)
  set faultId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFaultId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFaultId() => $_clearField(1);
}

class GetFaultResponse extends $pb.GeneratedMessage {
  factory GetFaultResponse({
    FaultEvent? faultEvent,
  }) {
    final $result = create();
    if (faultEvent != null) {
      $result.faultEvent = faultEvent;
    }
    return $result;
  }
  GetFaultResponse._() : super();
  factory GetFaultResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFaultResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetFaultResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'fault.v1'), createEmptyInstance: create)
    ..aOM<FaultEvent>(1, _omitFieldNames ? '' : 'faultEvent', subBuilder: FaultEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFaultResponse clone() => GetFaultResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFaultResponse copyWith(void Function(GetFaultResponse) updates) => super.copyWith((message) => updates(message as GetFaultResponse)) as GetFaultResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFaultResponse create() => GetFaultResponse._();
  GetFaultResponse createEmptyInstance() => create();
  static $pb.PbList<GetFaultResponse> createRepeated() => $pb.PbList<GetFaultResponse>();
  @$core.pragma('dart2js:noInline')
  static GetFaultResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFaultResponse>(create);
  static GetFaultResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FaultEvent get faultEvent => $_getN(0);
  @$pb.TagNumber(1)
  set faultEvent(FaultEvent v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFaultEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearFaultEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  FaultEvent ensureFaultEvent() => $_ensure(0);
}

class ListFaultsRequest extends $pb.GeneratedMessage {
  factory ListFaultsRequest({
    $core.String? twinId,
    $core.String? projectId,
    FaultSeverity? severityFilter,
    FaultStatus? statusFilter,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final $result = create();
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (severityFilter != null) {
      $result.severityFilter = severityFilter;
    }
    if (statusFilter != null) {
      $result.statusFilter = statusFilter;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    if (pageToken != null) {
      $result.pageToken = pageToken;
    }
    return $result;
  }
  ListFaultsRequest._() : super();
  factory ListFaultsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListFaultsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListFaultsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'fault.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'twinId')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..e<FaultSeverity>(3, _omitFieldNames ? '' : 'severityFilter', $pb.PbFieldType.OE, defaultOrMaker: FaultSeverity.FAULT_SEVERITY_UNSPECIFIED, valueOf: FaultSeverity.valueOf, enumValues: FaultSeverity.values)
    ..e<FaultStatus>(4, _omitFieldNames ? '' : 'statusFilter', $pb.PbFieldType.OE, defaultOrMaker: FaultStatus.FAULT_STATUS_UNSPECIFIED, valueOf: FaultStatus.valueOf, enumValues: FaultStatus.values)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOS(6, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListFaultsRequest clone() => ListFaultsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListFaultsRequest copyWith(void Function(ListFaultsRequest) updates) => super.copyWith((message) => updates(message as ListFaultsRequest)) as ListFaultsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFaultsRequest create() => ListFaultsRequest._();
  ListFaultsRequest createEmptyInstance() => create();
  static $pb.PbList<ListFaultsRequest> createRepeated() => $pb.PbList<ListFaultsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListFaultsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListFaultsRequest>(create);
  static ListFaultsRequest? _defaultInstance;

  /// twin_id: If set, returns faults for that twin only.
  @$pb.TagNumber(1)
  $core.String get twinId => $_getSZ(0);
  @$pb.TagNumber(1)
  set twinId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwinId() => $_clearField(1);

  /// project_id: If set (and twin_id is empty), returns faults across all twins for the project.
  @$pb.TagNumber(2)
  $core.String get projectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set projectId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  /// severity_filter: If UNSPECIFIED, all severities are returned.
  @$pb.TagNumber(3)
  FaultSeverity get severityFilter => $_getN(2);
  @$pb.TagNumber(3)
  set severityFilter(FaultSeverity v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSeverityFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeverityFilter() => $_clearField(3);

  /// status_filter: If UNSPECIFIED, all statuses are returned.
  @$pb.TagNumber(4)
  FaultStatus get statusFilter => $_getN(3);
  @$pb.TagNumber(4)
  set statusFilter(FaultStatus v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatusFilter() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatusFilter() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get pageToken => $_getSZ(5);
  @$pb.TagNumber(6)
  set pageToken($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPageToken() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageToken() => $_clearField(6);
}

class ListFaultsResponse extends $pb.GeneratedMessage {
  factory ListFaultsResponse({
    $core.Iterable<FaultEvent>? faultEvents,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final $result = create();
    if (faultEvents != null) {
      $result.faultEvents.addAll(faultEvents);
    }
    if (nextPageToken != null) {
      $result.nextPageToken = nextPageToken;
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    return $result;
  }
  ListFaultsResponse._() : super();
  factory ListFaultsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListFaultsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListFaultsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'fault.v1'), createEmptyInstance: create)
    ..pc<FaultEvent>(1, _omitFieldNames ? '' : 'faultEvents', $pb.PbFieldType.PM, subBuilder: FaultEvent.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListFaultsResponse clone() => ListFaultsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListFaultsResponse copyWith(void Function(ListFaultsResponse) updates) => super.copyWith((message) => updates(message as ListFaultsResponse)) as ListFaultsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFaultsResponse create() => ListFaultsResponse._();
  ListFaultsResponse createEmptyInstance() => create();
  static $pb.PbList<ListFaultsResponse> createRepeated() => $pb.PbList<ListFaultsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListFaultsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListFaultsResponse>(create);
  static ListFaultsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FaultEvent> get faultEvents => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalCount($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);
}

class AcknowledgeFaultRequest extends $pb.GeneratedMessage {
  factory AcknowledgeFaultRequest({
    $core.String? faultId,
    $core.String? actorId,
  }) {
    final $result = create();
    if (faultId != null) {
      $result.faultId = faultId;
    }
    if (actorId != null) {
      $result.actorId = actorId;
    }
    return $result;
  }
  AcknowledgeFaultRequest._() : super();
  factory AcknowledgeFaultRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AcknowledgeFaultRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AcknowledgeFaultRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'fault.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'faultId')
    ..aOS(2, _omitFieldNames ? '' : 'actorId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AcknowledgeFaultRequest clone() => AcknowledgeFaultRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AcknowledgeFaultRequest copyWith(void Function(AcknowledgeFaultRequest) updates) => super.copyWith((message) => updates(message as AcknowledgeFaultRequest)) as AcknowledgeFaultRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeFaultRequest create() => AcknowledgeFaultRequest._();
  AcknowledgeFaultRequest createEmptyInstance() => create();
  static $pb.PbList<AcknowledgeFaultRequest> createRepeated() => $pb.PbList<AcknowledgeFaultRequest>();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeFaultRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AcknowledgeFaultRequest>(create);
  static AcknowledgeFaultRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get faultId => $_getSZ(0);
  @$pb.TagNumber(1)
  set faultId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFaultId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFaultId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get actorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set actorId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasActorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearActorId() => $_clearField(2);
}

class AcknowledgeFaultResponse extends $pb.GeneratedMessage {
  factory AcknowledgeFaultResponse({
    FaultEvent? faultEvent,
  }) {
    final $result = create();
    if (faultEvent != null) {
      $result.faultEvent = faultEvent;
    }
    return $result;
  }
  AcknowledgeFaultResponse._() : super();
  factory AcknowledgeFaultResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AcknowledgeFaultResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AcknowledgeFaultResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'fault.v1'), createEmptyInstance: create)
    ..aOM<FaultEvent>(1, _omitFieldNames ? '' : 'faultEvent', subBuilder: FaultEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AcknowledgeFaultResponse clone() => AcknowledgeFaultResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AcknowledgeFaultResponse copyWith(void Function(AcknowledgeFaultResponse) updates) => super.copyWith((message) => updates(message as AcknowledgeFaultResponse)) as AcknowledgeFaultResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcknowledgeFaultResponse create() => AcknowledgeFaultResponse._();
  AcknowledgeFaultResponse createEmptyInstance() => create();
  static $pb.PbList<AcknowledgeFaultResponse> createRepeated() => $pb.PbList<AcknowledgeFaultResponse>();
  @$core.pragma('dart2js:noInline')
  static AcknowledgeFaultResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AcknowledgeFaultResponse>(create);
  static AcknowledgeFaultResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FaultEvent get faultEvent => $_getN(0);
  @$pb.TagNumber(1)
  set faultEvent(FaultEvent v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFaultEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearFaultEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  FaultEvent ensureFaultEvent() => $_ensure(0);
}

class ResolveFaultRequest extends $pb.GeneratedMessage {
  factory ResolveFaultRequest({
    $core.String? faultId,
    $core.String? actorId,
    $core.String? resolutionNotes,
  }) {
    final $result = create();
    if (faultId != null) {
      $result.faultId = faultId;
    }
    if (actorId != null) {
      $result.actorId = actorId;
    }
    if (resolutionNotes != null) {
      $result.resolutionNotes = resolutionNotes;
    }
    return $result;
  }
  ResolveFaultRequest._() : super();
  factory ResolveFaultRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResolveFaultRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResolveFaultRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'fault.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'faultId')
    ..aOS(2, _omitFieldNames ? '' : 'actorId')
    ..aOS(3, _omitFieldNames ? '' : 'resolutionNotes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResolveFaultRequest clone() => ResolveFaultRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResolveFaultRequest copyWith(void Function(ResolveFaultRequest) updates) => super.copyWith((message) => updates(message as ResolveFaultRequest)) as ResolveFaultRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveFaultRequest create() => ResolveFaultRequest._();
  ResolveFaultRequest createEmptyInstance() => create();
  static $pb.PbList<ResolveFaultRequest> createRepeated() => $pb.PbList<ResolveFaultRequest>();
  @$core.pragma('dart2js:noInline')
  static ResolveFaultRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResolveFaultRequest>(create);
  static ResolveFaultRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get faultId => $_getSZ(0);
  @$pb.TagNumber(1)
  set faultId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFaultId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFaultId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get actorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set actorId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasActorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearActorId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get resolutionNotes => $_getSZ(2);
  @$pb.TagNumber(3)
  set resolutionNotes($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasResolutionNotes() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolutionNotes() => $_clearField(3);
}

class ResolveFaultResponse extends $pb.GeneratedMessage {
  factory ResolveFaultResponse({
    FaultEvent? faultEvent,
  }) {
    final $result = create();
    if (faultEvent != null) {
      $result.faultEvent = faultEvent;
    }
    return $result;
  }
  ResolveFaultResponse._() : super();
  factory ResolveFaultResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResolveFaultResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResolveFaultResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'fault.v1'), createEmptyInstance: create)
    ..aOM<FaultEvent>(1, _omitFieldNames ? '' : 'faultEvent', subBuilder: FaultEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResolveFaultResponse clone() => ResolveFaultResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResolveFaultResponse copyWith(void Function(ResolveFaultResponse) updates) => super.copyWith((message) => updates(message as ResolveFaultResponse)) as ResolveFaultResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResolveFaultResponse create() => ResolveFaultResponse._();
  ResolveFaultResponse createEmptyInstance() => create();
  static $pb.PbList<ResolveFaultResponse> createRepeated() => $pb.PbList<ResolveFaultResponse>();
  @$core.pragma('dart2js:noInline')
  static ResolveFaultResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResolveFaultResponse>(create);
  static ResolveFaultResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FaultEvent get faultEvent => $_getN(0);
  @$pb.TagNumber(1)
  set faultEvent(FaultEvent v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFaultEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearFaultEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  FaultEvent ensureFaultEvent() => $_ensure(0);
}

/// FaultService manages operational fault events received from digital twins,
/// SCADA systems, protection relays, and manual reports.  Fault codes align
/// with IEC 60909 (short-circuit fault calculations) and IEC 61724-1 (PV system
/// performance monitoring) where applicable.
class FaultServiceApi {
  $pb.RpcClient _client;
  FaultServiceApi(this._client);

  /// ReportFault creates a new fault event for a digital twin asset.
  /// The twin_id must correspond to an ACTIVE DigitalTwin.
  $async.Future<ReportFaultResponse> reportFault($pb.ClientContext? ctx, ReportFaultRequest request) =>
    _client.invoke<ReportFaultResponse>(ctx, 'FaultService', 'ReportFault', request, ReportFaultResponse())
  ;
  /// GetFault retrieves a single fault event by its unique ID.
  $async.Future<GetFaultResponse> getFault($pb.ClientContext? ctx, GetFaultRequest request) =>
    _client.invoke<GetFaultResponse>(ctx, 'FaultService', 'GetFault', request, GetFaultResponse())
  ;
  /// ListFaults returns fault events filtered by twin, project, severity or status.
  /// Results are ordered by detected_at descending.
  $async.Future<ListFaultsResponse> listFaults($pb.ClientContext? ctx, ListFaultsRequest request) =>
    _client.invoke<ListFaultsResponse>(ctx, 'FaultService', 'ListFaults', request, ListFaultsResponse())
  ;
  /// AcknowledgeFault marks a fault as seen by an operator.  Only faults in
  /// FAULT_STATUS_ACTIVE state may be acknowledged; others return FAILED_PRECONDITION.
  $async.Future<AcknowledgeFaultResponse> acknowledgeFault($pb.ClientContext? ctx, AcknowledgeFaultRequest request) =>
    _client.invoke<AcknowledgeFaultResponse>(ctx, 'FaultService', 'AcknowledgeFault', request, AcknowledgeFaultResponse())
  ;
  /// ResolveFault closes a fault with operator resolution notes.  Faults must be
  /// in FAULT_STATUS_ACTIVE or FAULT_STATUS_ACKNOWLEDGED state to be resolved.
  $async.Future<ResolveFaultResponse> resolveFault($pb.ClientContext? ctx, ResolveFaultRequest request) =>
    _client.invoke<ResolveFaultResponse>(ctx, 'FaultService', 'ResolveFault', request, ResolveFaultResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
