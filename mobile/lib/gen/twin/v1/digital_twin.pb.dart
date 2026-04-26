//
//  Generated code. Do not modify.
//  source: twin/v1/digital_twin.proto
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
import 'digital_twin.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'digital_twin.pbenum.dart';

/// OperationalState holds the mutable runtime metrics for a digital twin.
/// Values are updated by telemetry ingestion and fault reporting.
class OperationalState extends $pb.GeneratedMessage {
  factory OperationalState({
    $core.double? powerOutputKw,
    $core.double? availabilityPercent,
    $core.int? activeFaultCount,
    $core.double? healthScore,
    $0.Timestamp? lastInspectedAt,
  }) {
    final $result = create();
    if (powerOutputKw != null) {
      $result.powerOutputKw = powerOutputKw;
    }
    if (availabilityPercent != null) {
      $result.availabilityPercent = availabilityPercent;
    }
    if (activeFaultCount != null) {
      $result.activeFaultCount = activeFaultCount;
    }
    if (healthScore != null) {
      $result.healthScore = healthScore;
    }
    if (lastInspectedAt != null) {
      $result.lastInspectedAt = lastInspectedAt;
    }
    return $result;
  }
  OperationalState._() : super();
  factory OperationalState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OperationalState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OperationalState', package: const $pb.PackageName(_omitMessageNames ? '' : 'twin.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'powerOutputKw', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'availabilityPercent', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'activeFaultCount', $pb.PbFieldType.O3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'healthScore', $pb.PbFieldType.OD)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'lastInspectedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OperationalState clone() => OperationalState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OperationalState copyWith(void Function(OperationalState) updates) => super.copyWith((message) => updates(message as OperationalState)) as OperationalState;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OperationalState create() => OperationalState._();
  OperationalState createEmptyInstance() => create();
  static $pb.PbList<OperationalState> createRepeated() => $pb.PbList<OperationalState>();
  @$core.pragma('dart2js:noInline')
  static OperationalState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OperationalState>(create);
  static OperationalState? _defaultInstance;

  /// power_output_kw: Current AC output power in kilowatts.
  @$pb.TagNumber(1)
  $core.double get powerOutputKw => $_getN(0);
  @$pb.TagNumber(1)
  set powerOutputKw($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPowerOutputKw() => $_has(0);
  @$pb.TagNumber(1)
  void clearPowerOutputKw() => $_clearField(1);

  /// availability_percent: Plant availability [0, 100].
  @$pb.TagNumber(2)
  $core.double get availabilityPercent => $_getN(1);
  @$pb.TagNumber(2)
  set availabilityPercent($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAvailabilityPercent() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvailabilityPercent() => $_clearField(2);

  /// active_fault_count: Number of unresolved faults currently active.
  @$pb.TagNumber(3)
  $core.int get activeFaultCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set activeFaultCount($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasActiveFaultCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearActiveFaultCount() => $_clearField(3);

  /// health_score: Composite health indicator [0, 1] where 1 = nominal.
  @$pb.TagNumber(4)
  $core.double get healthScore => $_getN(3);
  @$pb.TagNumber(4)
  set healthScore($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHealthScore() => $_has(3);
  @$pb.TagNumber(4)
  void clearHealthScore() => $_clearField(4);

  /// last_inspected_at: Timestamp of last manual or automated inspection.
  @$pb.TagNumber(5)
  $0.Timestamp get lastInspectedAt => $_getN(4);
  @$pb.TagNumber(5)
  set lastInspectedAt($0.Timestamp v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasLastInspectedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastInspectedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureLastInspectedAt() => $_ensure(4);
}

/// DigitalTwin is the canonical representation of a provisioned project twin.
/// Immutable fields: id, project_id, layout_id, electrical_network_id,
/// transmission_route_id, approved_revision_id, provisioned_by_actor_id, provisioned_at.
/// Mutable fields: status, operational_state, last_telemetry_at, decommissioned_at,
/// asset_identity_link_count, metadata_json.
class DigitalTwin extends $pb.GeneratedMessage {
  factory DigitalTwin({
    $core.String? id,
    $core.String? projectId,
    $core.String? layoutId,
    $core.String? electricalNetworkId,
    $core.String? transmissionRouteId,
    $core.String? approvedRevisionId,
    TwinStatus? status,
    OperationalState? operationalState,
    $core.String? provisionedByActorId,
    $0.Timestamp? provisionedAt,
    $0.Timestamp? lastTelemetryAt,
    $0.Timestamp? decommissionedAt,
    $core.int? assetIdentityLinkCount,
    $core.String? metadataJson,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
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
    if (electricalNetworkId != null) {
      $result.electricalNetworkId = electricalNetworkId;
    }
    if (transmissionRouteId != null) {
      $result.transmissionRouteId = transmissionRouteId;
    }
    if (approvedRevisionId != null) {
      $result.approvedRevisionId = approvedRevisionId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (operationalState != null) {
      $result.operationalState = operationalState;
    }
    if (provisionedByActorId != null) {
      $result.provisionedByActorId = provisionedByActorId;
    }
    if (provisionedAt != null) {
      $result.provisionedAt = provisionedAt;
    }
    if (lastTelemetryAt != null) {
      $result.lastTelemetryAt = lastTelemetryAt;
    }
    if (decommissionedAt != null) {
      $result.decommissionedAt = decommissionedAt;
    }
    if (assetIdentityLinkCount != null) {
      $result.assetIdentityLinkCount = assetIdentityLinkCount;
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
  DigitalTwin._() : super();
  factory DigitalTwin.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DigitalTwin.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DigitalTwin', package: const $pb.PackageName(_omitMessageNames ? '' : 'twin.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'layoutId')
    ..aOS(4, _omitFieldNames ? '' : 'electricalNetworkId')
    ..aOS(5, _omitFieldNames ? '' : 'transmissionRouteId')
    ..aOS(6, _omitFieldNames ? '' : 'approvedRevisionId')
    ..e<TwinStatus>(7, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: TwinStatus.TWIN_STATUS_UNSPECIFIED, valueOf: TwinStatus.valueOf, enumValues: TwinStatus.values)
    ..aOM<OperationalState>(8, _omitFieldNames ? '' : 'operationalState', subBuilder: OperationalState.create)
    ..aOS(9, _omitFieldNames ? '' : 'provisionedByActorId')
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'provisionedAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'lastTelemetryAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'decommissionedAt', subBuilder: $0.Timestamp.create)
    ..a<$core.int>(13, _omitFieldNames ? '' : 'assetIdentityLinkCount', $pb.PbFieldType.O3)
    ..aOS(14, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$0.Timestamp>(15, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(16, _omitFieldNames ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DigitalTwin clone() => DigitalTwin()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DigitalTwin copyWith(void Function(DigitalTwin) updates) => super.copyWith((message) => updates(message as DigitalTwin)) as DigitalTwin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DigitalTwin create() => DigitalTwin._();
  DigitalTwin createEmptyInstance() => create();
  static $pb.PbList<DigitalTwin> createRepeated() => $pb.PbList<DigitalTwin>();
  @$core.pragma('dart2js:noInline')
  static DigitalTwin getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DigitalTwin>(create);
  static DigitalTwin? _defaultInstance;

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

  /// layout_id: ID of the approved layout artifact this twin was provisioned from.
  @$pb.TagNumber(3)
  $core.String get layoutId => $_getSZ(2);
  @$pb.TagNumber(3)
  set layoutId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLayoutId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLayoutId() => $_clearField(3);

  /// electrical_network_id: ID of the validated electrical network artifact.
  @$pb.TagNumber(4)
  $core.String get electricalNetworkId => $_getSZ(3);
  @$pb.TagNumber(4)
  set electricalNetworkId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasElectricalNetworkId() => $_has(3);
  @$pb.TagNumber(4)
  void clearElectricalNetworkId() => $_clearField(4);

  /// transmission_route_id: ID of the approved transmission route artifact.
  @$pb.TagNumber(5)
  $core.String get transmissionRouteId => $_getSZ(4);
  @$pb.TagNumber(5)
  set transmissionRouteId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTransmissionRouteId() => $_has(4);
  @$pb.TagNumber(5)
  void clearTransmissionRouteId() => $_clearField(5);

  /// approved_revision_id: Identifier of the approval record (StakeholderApproval evidence ID).
  @$pb.TagNumber(6)
  $core.String get approvedRevisionId => $_getSZ(5);
  @$pb.TagNumber(6)
  set approvedRevisionId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasApprovedRevisionId() => $_has(5);
  @$pb.TagNumber(6)
  void clearApprovedRevisionId() => $_clearField(6);

  @$pb.TagNumber(7)
  TwinStatus get status => $_getN(6);
  @$pb.TagNumber(7)
  set status(TwinStatus v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasStatus() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatus() => $_clearField(7);

  @$pb.TagNumber(8)
  OperationalState get operationalState => $_getN(7);
  @$pb.TagNumber(8)
  set operationalState(OperationalState v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasOperationalState() => $_has(7);
  @$pb.TagNumber(8)
  void clearOperationalState() => $_clearField(8);
  @$pb.TagNumber(8)
  OperationalState ensureOperationalState() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get provisionedByActorId => $_getSZ(8);
  @$pb.TagNumber(9)
  set provisionedByActorId($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasProvisionedByActorId() => $_has(8);
  @$pb.TagNumber(9)
  void clearProvisionedByActorId() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get provisionedAt => $_getN(9);
  @$pb.TagNumber(10)
  set provisionedAt($0.Timestamp v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasProvisionedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearProvisionedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureProvisionedAt() => $_ensure(9);

  /// last_telemetry_at: Timestamp of most recently ingested sensor reading.
  @$pb.TagNumber(11)
  $0.Timestamp get lastTelemetryAt => $_getN(10);
  @$pb.TagNumber(11)
  set lastTelemetryAt($0.Timestamp v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasLastTelemetryAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearLastTelemetryAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureLastTelemetryAt() => $_ensure(10);

  /// decommissioned_at: Set only when status = TWIN_STATUS_DECOMMISSIONED.
  @$pb.TagNumber(12)
  $0.Timestamp get decommissionedAt => $_getN(11);
  @$pb.TagNumber(12)
  set decommissionedAt($0.Timestamp v) { $_setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasDecommissionedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearDecommissionedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureDecommissionedAt() => $_ensure(11);

  /// asset_identity_link_count: Number of AssetIdentity records linked to this twin.
  @$pb.TagNumber(13)
  $core.int get assetIdentityLinkCount => $_getIZ(12);
  @$pb.TagNumber(13)
  set assetIdentityLinkCount($core.int v) { $_setSignedInt32(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasAssetIdentityLinkCount() => $_has(12);
  @$pb.TagNumber(13)
  void clearAssetIdentityLinkCount() => $_clearField(13);

  /// metadata_json: Free-form JSON for SCADA integration metadata, site codes, etc.
  @$pb.TagNumber(14)
  $core.String get metadataJson => $_getSZ(13);
  @$pb.TagNumber(14)
  set metadataJson($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasMetadataJson() => $_has(13);
  @$pb.TagNumber(14)
  void clearMetadataJson() => $_clearField(14);

  @$pb.TagNumber(15)
  $0.Timestamp get createdAt => $_getN(14);
  @$pb.TagNumber(15)
  set createdAt($0.Timestamp v) { $_setField(15, v); }
  @$pb.TagNumber(15)
  $core.bool hasCreatedAt() => $_has(14);
  @$pb.TagNumber(15)
  void clearCreatedAt() => $_clearField(15);
  @$pb.TagNumber(15)
  $0.Timestamp ensureCreatedAt() => $_ensure(14);

  @$pb.TagNumber(16)
  $0.Timestamp get updatedAt => $_getN(15);
  @$pb.TagNumber(16)
  set updatedAt($0.Timestamp v) { $_setField(16, v); }
  @$pb.TagNumber(16)
  $core.bool hasUpdatedAt() => $_has(15);
  @$pb.TagNumber(16)
  void clearUpdatedAt() => $_clearField(16);
  @$pb.TagNumber(16)
  $0.Timestamp ensureUpdatedAt() => $_ensure(15);
}

class ProvisionTwinRequest extends $pb.GeneratedMessage {
  factory ProvisionTwinRequest({
    $core.String? projectId,
    $core.String? layoutId,
    $core.String? electricalNetworkId,
    $core.String? transmissionRouteId,
    $core.String? approvedRevisionId,
    $core.String? provisionedByActorId,
    $core.String? metadataJson,
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
    if (transmissionRouteId != null) {
      $result.transmissionRouteId = transmissionRouteId;
    }
    if (approvedRevisionId != null) {
      $result.approvedRevisionId = approvedRevisionId;
    }
    if (provisionedByActorId != null) {
      $result.provisionedByActorId = provisionedByActorId;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    return $result;
  }
  ProvisionTwinRequest._() : super();
  factory ProvisionTwinRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProvisionTwinRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProvisionTwinRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'twin.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..aOS(3, _omitFieldNames ? '' : 'electricalNetworkId')
    ..aOS(4, _omitFieldNames ? '' : 'transmissionRouteId')
    ..aOS(5, _omitFieldNames ? '' : 'approvedRevisionId')
    ..aOS(6, _omitFieldNames ? '' : 'provisionedByActorId')
    ..aOS(7, _omitFieldNames ? '' : 'metadataJson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProvisionTwinRequest clone() => ProvisionTwinRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProvisionTwinRequest copyWith(void Function(ProvisionTwinRequest) updates) => super.copyWith((message) => updates(message as ProvisionTwinRequest)) as ProvisionTwinRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProvisionTwinRequest create() => ProvisionTwinRequest._();
  ProvisionTwinRequest createEmptyInstance() => create();
  static $pb.PbList<ProvisionTwinRequest> createRepeated() => $pb.PbList<ProvisionTwinRequest>();
  @$core.pragma('dart2js:noInline')
  static ProvisionTwinRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProvisionTwinRequest>(create);
  static ProvisionTwinRequest? _defaultInstance;

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

  @$pb.TagNumber(4)
  $core.String get transmissionRouteId => $_getSZ(3);
  @$pb.TagNumber(4)
  set transmissionRouteId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTransmissionRouteId() => $_has(3);
  @$pb.TagNumber(4)
  void clearTransmissionRouteId() => $_clearField(4);

  /// approved_revision_id: Stakeholder approval evidence record ID from the workflow.
  @$pb.TagNumber(5)
  $core.String get approvedRevisionId => $_getSZ(4);
  @$pb.TagNumber(5)
  set approvedRevisionId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasApprovedRevisionId() => $_has(4);
  @$pb.TagNumber(5)
  void clearApprovedRevisionId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get provisionedByActorId => $_getSZ(5);
  @$pb.TagNumber(6)
  set provisionedByActorId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasProvisionedByActorId() => $_has(5);
  @$pb.TagNumber(6)
  void clearProvisionedByActorId() => $_clearField(6);

  /// metadata_json: Optional SCADA/site integration metadata in JSON format.
  @$pb.TagNumber(7)
  $core.String get metadataJson => $_getSZ(6);
  @$pb.TagNumber(7)
  set metadataJson($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMetadataJson() => $_has(6);
  @$pb.TagNumber(7)
  void clearMetadataJson() => $_clearField(7);
}

class ProvisionTwinResponse extends $pb.GeneratedMessage {
  factory ProvisionTwinResponse({
    DigitalTwin? twin,
  }) {
    final $result = create();
    if (twin != null) {
      $result.twin = twin;
    }
    return $result;
  }
  ProvisionTwinResponse._() : super();
  factory ProvisionTwinResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ProvisionTwinResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProvisionTwinResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'twin.v1'), createEmptyInstance: create)
    ..aOM<DigitalTwin>(1, _omitFieldNames ? '' : 'twin', subBuilder: DigitalTwin.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ProvisionTwinResponse clone() => ProvisionTwinResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ProvisionTwinResponse copyWith(void Function(ProvisionTwinResponse) updates) => super.copyWith((message) => updates(message as ProvisionTwinResponse)) as ProvisionTwinResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProvisionTwinResponse create() => ProvisionTwinResponse._();
  ProvisionTwinResponse createEmptyInstance() => create();
  static $pb.PbList<ProvisionTwinResponse> createRepeated() => $pb.PbList<ProvisionTwinResponse>();
  @$core.pragma('dart2js:noInline')
  static ProvisionTwinResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProvisionTwinResponse>(create);
  static ProvisionTwinResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DigitalTwin get twin => $_getN(0);
  @$pb.TagNumber(1)
  set twin(DigitalTwin v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwin() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwin() => $_clearField(1);
  @$pb.TagNumber(1)
  DigitalTwin ensureTwin() => $_ensure(0);
}

class GetTwinStateRequest extends $pb.GeneratedMessage {
  factory GetTwinStateRequest({
    $core.String? twinId,
  }) {
    final $result = create();
    if (twinId != null) {
      $result.twinId = twinId;
    }
    return $result;
  }
  GetTwinStateRequest._() : super();
  factory GetTwinStateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTwinStateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetTwinStateRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'twin.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'twinId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTwinStateRequest clone() => GetTwinStateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTwinStateRequest copyWith(void Function(GetTwinStateRequest) updates) => super.copyWith((message) => updates(message as GetTwinStateRequest)) as GetTwinStateRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTwinStateRequest create() => GetTwinStateRequest._();
  GetTwinStateRequest createEmptyInstance() => create();
  static $pb.PbList<GetTwinStateRequest> createRepeated() => $pb.PbList<GetTwinStateRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTwinStateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTwinStateRequest>(create);
  static GetTwinStateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get twinId => $_getSZ(0);
  @$pb.TagNumber(1)
  set twinId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwinId() => $_clearField(1);
}

class GetTwinStateResponse extends $pb.GeneratedMessage {
  factory GetTwinStateResponse({
    DigitalTwin? twin,
  }) {
    final $result = create();
    if (twin != null) {
      $result.twin = twin;
    }
    return $result;
  }
  GetTwinStateResponse._() : super();
  factory GetTwinStateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTwinStateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetTwinStateResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'twin.v1'), createEmptyInstance: create)
    ..aOM<DigitalTwin>(1, _omitFieldNames ? '' : 'twin', subBuilder: DigitalTwin.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTwinStateResponse clone() => GetTwinStateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTwinStateResponse copyWith(void Function(GetTwinStateResponse) updates) => super.copyWith((message) => updates(message as GetTwinStateResponse)) as GetTwinStateResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTwinStateResponse create() => GetTwinStateResponse._();
  GetTwinStateResponse createEmptyInstance() => create();
  static $pb.PbList<GetTwinStateResponse> createRepeated() => $pb.PbList<GetTwinStateResponse>();
  @$core.pragma('dart2js:noInline')
  static GetTwinStateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTwinStateResponse>(create);
  static GetTwinStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DigitalTwin get twin => $_getN(0);
  @$pb.TagNumber(1)
  set twin(DigitalTwin v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwin() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwin() => $_clearField(1);
  @$pb.TagNumber(1)
  DigitalTwin ensureTwin() => $_ensure(0);
}

class UpdateTwinStateRequest extends $pb.GeneratedMessage {
  factory UpdateTwinStateRequest({
    $core.String? twinId,
    OperationalState? operationalState,
    $0.Timestamp? lastTelemetryAt,
  }) {
    final $result = create();
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (operationalState != null) {
      $result.operationalState = operationalState;
    }
    if (lastTelemetryAt != null) {
      $result.lastTelemetryAt = lastTelemetryAt;
    }
    return $result;
  }
  UpdateTwinStateRequest._() : super();
  factory UpdateTwinStateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateTwinStateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateTwinStateRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'twin.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'twinId')
    ..aOM<OperationalState>(2, _omitFieldNames ? '' : 'operationalState', subBuilder: OperationalState.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'lastTelemetryAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateTwinStateRequest clone() => UpdateTwinStateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateTwinStateRequest copyWith(void Function(UpdateTwinStateRequest) updates) => super.copyWith((message) => updates(message as UpdateTwinStateRequest)) as UpdateTwinStateRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateTwinStateRequest create() => UpdateTwinStateRequest._();
  UpdateTwinStateRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateTwinStateRequest> createRepeated() => $pb.PbList<UpdateTwinStateRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateTwinStateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateTwinStateRequest>(create);
  static UpdateTwinStateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get twinId => $_getSZ(0);
  @$pb.TagNumber(1)
  set twinId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwinId() => $_clearField(1);

  @$pb.TagNumber(2)
  OperationalState get operationalState => $_getN(1);
  @$pb.TagNumber(2)
  set operationalState(OperationalState v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasOperationalState() => $_has(1);
  @$pb.TagNumber(2)
  void clearOperationalState() => $_clearField(2);
  @$pb.TagNumber(2)
  OperationalState ensureOperationalState() => $_ensure(1);

  /// last_telemetry_at: Updated by TelemetryService after each successful ingest.
  @$pb.TagNumber(3)
  $0.Timestamp get lastTelemetryAt => $_getN(2);
  @$pb.TagNumber(3)
  set lastTelemetryAt($0.Timestamp v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLastTelemetryAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearLastTelemetryAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureLastTelemetryAt() => $_ensure(2);
}

class UpdateTwinStateResponse extends $pb.GeneratedMessage {
  factory UpdateTwinStateResponse({
    DigitalTwin? twin,
  }) {
    final $result = create();
    if (twin != null) {
      $result.twin = twin;
    }
    return $result;
  }
  UpdateTwinStateResponse._() : super();
  factory UpdateTwinStateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateTwinStateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateTwinStateResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'twin.v1'), createEmptyInstance: create)
    ..aOM<DigitalTwin>(1, _omitFieldNames ? '' : 'twin', subBuilder: DigitalTwin.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateTwinStateResponse clone() => UpdateTwinStateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateTwinStateResponse copyWith(void Function(UpdateTwinStateResponse) updates) => super.copyWith((message) => updates(message as UpdateTwinStateResponse)) as UpdateTwinStateResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateTwinStateResponse create() => UpdateTwinStateResponse._();
  UpdateTwinStateResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateTwinStateResponse> createRepeated() => $pb.PbList<UpdateTwinStateResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateTwinStateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateTwinStateResponse>(create);
  static UpdateTwinStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DigitalTwin get twin => $_getN(0);
  @$pb.TagNumber(1)
  set twin(DigitalTwin v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwin() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwin() => $_clearField(1);
  @$pb.TagNumber(1)
  DigitalTwin ensureTwin() => $_ensure(0);
}

class DeprovisionTwinRequest extends $pb.GeneratedMessage {
  factory DeprovisionTwinRequest({
    $core.String? twinId,
    $core.String? actorId,
    $core.String? reason,
  }) {
    final $result = create();
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (actorId != null) {
      $result.actorId = actorId;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    return $result;
  }
  DeprovisionTwinRequest._() : super();
  factory DeprovisionTwinRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeprovisionTwinRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeprovisionTwinRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'twin.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'twinId')
    ..aOS(2, _omitFieldNames ? '' : 'actorId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeprovisionTwinRequest clone() => DeprovisionTwinRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeprovisionTwinRequest copyWith(void Function(DeprovisionTwinRequest) updates) => super.copyWith((message) => updates(message as DeprovisionTwinRequest)) as DeprovisionTwinRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeprovisionTwinRequest create() => DeprovisionTwinRequest._();
  DeprovisionTwinRequest createEmptyInstance() => create();
  static $pb.PbList<DeprovisionTwinRequest> createRepeated() => $pb.PbList<DeprovisionTwinRequest>();
  @$core.pragma('dart2js:noInline')
  static DeprovisionTwinRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeprovisionTwinRequest>(create);
  static DeprovisionTwinRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get twinId => $_getSZ(0);
  @$pb.TagNumber(1)
  set twinId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwinId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get actorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set actorId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasActorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearActorId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);
}

class DeprovisionTwinResponse extends $pb.GeneratedMessage {
  factory DeprovisionTwinResponse({
    DigitalTwin? twin,
  }) {
    final $result = create();
    if (twin != null) {
      $result.twin = twin;
    }
    return $result;
  }
  DeprovisionTwinResponse._() : super();
  factory DeprovisionTwinResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeprovisionTwinResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeprovisionTwinResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'twin.v1'), createEmptyInstance: create)
    ..aOM<DigitalTwin>(1, _omitFieldNames ? '' : 'twin', subBuilder: DigitalTwin.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeprovisionTwinResponse clone() => DeprovisionTwinResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeprovisionTwinResponse copyWith(void Function(DeprovisionTwinResponse) updates) => super.copyWith((message) => updates(message as DeprovisionTwinResponse)) as DeprovisionTwinResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeprovisionTwinResponse create() => DeprovisionTwinResponse._();
  DeprovisionTwinResponse createEmptyInstance() => create();
  static $pb.PbList<DeprovisionTwinResponse> createRepeated() => $pb.PbList<DeprovisionTwinResponse>();
  @$core.pragma('dart2js:noInline')
  static DeprovisionTwinResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeprovisionTwinResponse>(create);
  static DeprovisionTwinResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DigitalTwin get twin => $_getN(0);
  @$pb.TagNumber(1)
  set twin(DigitalTwin v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwin() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwin() => $_clearField(1);
  @$pb.TagNumber(1)
  DigitalTwin ensureTwin() => $_ensure(0);
}

class ListTwinsByProjectRequest extends $pb.GeneratedMessage {
  factory ListTwinsByProjectRequest({
    $core.String? projectId,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    if (pageToken != null) {
      $result.pageToken = pageToken;
    }
    return $result;
  }
  ListTwinsByProjectRequest._() : super();
  factory ListTwinsByProjectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListTwinsByProjectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListTwinsByProjectRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'twin.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListTwinsByProjectRequest clone() => ListTwinsByProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListTwinsByProjectRequest copyWith(void Function(ListTwinsByProjectRequest) updates) => super.copyWith((message) => updates(message as ListTwinsByProjectRequest)) as ListTwinsByProjectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTwinsByProjectRequest create() => ListTwinsByProjectRequest._();
  ListTwinsByProjectRequest createEmptyInstance() => create();
  static $pb.PbList<ListTwinsByProjectRequest> createRepeated() => $pb.PbList<ListTwinsByProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static ListTwinsByProjectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTwinsByProjectRequest>(create);
  static ListTwinsByProjectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pageToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set pageToken($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPageToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageToken() => $_clearField(3);
}

class ListTwinsByProjectResponse extends $pb.GeneratedMessage {
  factory ListTwinsByProjectResponse({
    $core.Iterable<DigitalTwin>? twins,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final $result = create();
    if (twins != null) {
      $result.twins.addAll(twins);
    }
    if (nextPageToken != null) {
      $result.nextPageToken = nextPageToken;
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    return $result;
  }
  ListTwinsByProjectResponse._() : super();
  factory ListTwinsByProjectResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListTwinsByProjectResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListTwinsByProjectResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'twin.v1'), createEmptyInstance: create)
    ..pc<DigitalTwin>(1, _omitFieldNames ? '' : 'twins', $pb.PbFieldType.PM, subBuilder: DigitalTwin.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListTwinsByProjectResponse clone() => ListTwinsByProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListTwinsByProjectResponse copyWith(void Function(ListTwinsByProjectResponse) updates) => super.copyWith((message) => updates(message as ListTwinsByProjectResponse)) as ListTwinsByProjectResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTwinsByProjectResponse create() => ListTwinsByProjectResponse._();
  ListTwinsByProjectResponse createEmptyInstance() => create();
  static $pb.PbList<ListTwinsByProjectResponse> createRepeated() => $pb.PbList<ListTwinsByProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static ListTwinsByProjectResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTwinsByProjectResponse>(create);
  static ListTwinsByProjectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DigitalTwin> get twins => $_getList(0);

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

/// DigitalTwinService manages the lifecycle of digital twins provisioned from
/// approved solar project lineage.  A twin is provisioned exactly once per
/// approved project revision; it holds operational state and links design asset
/// IDs to physical/operational identities via the AssetIdentityService.
class DigitalTwinServiceApi {
  $pb.RpcClient _client;
  DigitalTwinServiceApi(this._client);

  /// ProvisionTwin creates a new digital twin from an approved project lineage.
  /// Requires an approved project_id and the IDs of the three design artifacts
  /// (layout, electrical network, transmission route) that form the approved revision.
  $async.Future<ProvisionTwinResponse> provisionTwin($pb.ClientContext? ctx, ProvisionTwinRequest request) =>
    _client.invoke<ProvisionTwinResponse>(ctx, 'DigitalTwinService', 'ProvisionTwin', request, ProvisionTwinResponse())
  ;
  /// GetTwinState retrieves the current twin including its operational state.
  /// Returns NOT_FOUND if the twin_id does not exist.
  $async.Future<GetTwinStateResponse> getTwinState($pb.ClientContext? ctx, GetTwinStateRequest request) =>
    _client.invoke<GetTwinStateResponse>(ctx, 'DigitalTwinService', 'GetTwinState', request, GetTwinStateResponse())
  ;
  /// UpdateTwinState patches the mutable operational state fields (power, availability,
  /// active fault count, health score).  All other fields are immutable after provisioning.
  $async.Future<UpdateTwinStateResponse> updateTwinState($pb.ClientContext? ctx, UpdateTwinStateRequest request) =>
    _client.invoke<UpdateTwinStateResponse>(ctx, 'DigitalTwinService', 'UpdateTwinState', request, UpdateTwinStateResponse())
  ;
  /// DeprovisionTwin marks a twin as decommissioned.  Decommissioned twins are
  /// immutable; telemetry ingestion is rejected for decommissioned twins.
  $async.Future<DeprovisionTwinResponse> deprovisionTwin($pb.ClientContext? ctx, DeprovisionTwinRequest request) =>
    _client.invoke<DeprovisionTwinResponse>(ctx, 'DigitalTwinService', 'DeprovisionTwin', request, DeprovisionTwinResponse())
  ;
  /// ListTwinsByProject returns all twins for a project ordered by provisioned_at desc.
  $async.Future<ListTwinsByProjectResponse> listTwinsByProject($pb.ClientContext? ctx, ListTwinsByProjectRequest request) =>
    _client.invoke<ListTwinsByProjectResponse>(ctx, 'DigitalTwinService', 'ListTwinsByProject', request, ListTwinsByProjectResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
