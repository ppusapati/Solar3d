//
//  Generated code. Do not modify.
//  source: asset/v1/asset_identity.proto
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
import 'asset_identity.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'asset_identity.pbenum.dart';

/// AssetIdentity is an immutable linkage record connecting a design-time asset ID
/// to a physical installation instance.  The linked_at, design_asset_id, and
/// design_asset_type fields are immutable after creation.
class AssetIdentity extends $pb.GeneratedMessage {
  factory AssetIdentity({
    $core.String? id,
    $core.String? projectId,
    $core.String? twinId,
    $core.String? designAssetId,
    DesignAssetType? designAssetType,
    $core.String? physicalSerialNumber,
    $core.String? manufacturer,
    $core.String? model,
    $0.Timestamp? installationDate,
    $core.String? commissioningReference,
    $core.String? installationNotes,
    $core.String? linkedByActorId,
    $0.Timestamp? linkedAt,
    $0.Timestamp? updatedAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (designAssetId != null) {
      $result.designAssetId = designAssetId;
    }
    if (designAssetType != null) {
      $result.designAssetType = designAssetType;
    }
    if (physicalSerialNumber != null) {
      $result.physicalSerialNumber = physicalSerialNumber;
    }
    if (manufacturer != null) {
      $result.manufacturer = manufacturer;
    }
    if (model != null) {
      $result.model = model;
    }
    if (installationDate != null) {
      $result.installationDate = installationDate;
    }
    if (commissioningReference != null) {
      $result.commissioningReference = commissioningReference;
    }
    if (installationNotes != null) {
      $result.installationNotes = installationNotes;
    }
    if (linkedByActorId != null) {
      $result.linkedByActorId = linkedByActorId;
    }
    if (linkedAt != null) {
      $result.linkedAt = linkedAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    return $result;
  }
  AssetIdentity._() : super();
  factory AssetIdentity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AssetIdentity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AssetIdentity', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'twinId')
    ..aOS(4, _omitFieldNames ? '' : 'designAssetId')
    ..e<DesignAssetType>(5, _omitFieldNames ? '' : 'designAssetType', $pb.PbFieldType.OE, defaultOrMaker: DesignAssetType.DESIGN_ASSET_TYPE_UNSPECIFIED, valueOf: DesignAssetType.valueOf, enumValues: DesignAssetType.values)
    ..aOS(6, _omitFieldNames ? '' : 'physicalSerialNumber')
    ..aOS(7, _omitFieldNames ? '' : 'manufacturer')
    ..aOS(8, _omitFieldNames ? '' : 'model')
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'installationDate', subBuilder: $0.Timestamp.create)
    ..aOS(10, _omitFieldNames ? '' : 'commissioningReference')
    ..aOS(11, _omitFieldNames ? '' : 'installationNotes')
    ..aOS(12, _omitFieldNames ? '' : 'linkedByActorId')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'linkedAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AssetIdentity clone() => AssetIdentity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AssetIdentity copyWith(void Function(AssetIdentity) updates) => super.copyWith((message) => updates(message as AssetIdentity)) as AssetIdentity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AssetIdentity create() => AssetIdentity._();
  AssetIdentity createEmptyInstance() => create();
  static $pb.PbList<AssetIdentity> createRepeated() => $pb.PbList<AssetIdentity>();
  @$core.pragma('dart2js:noInline')
  static AssetIdentity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AssetIdentity>(create);
  static AssetIdentity? _defaultInstance;

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

  /// twin_id: The provisioned DigitalTwin this identity belongs to.
  @$pb.TagNumber(3)
  $core.String get twinId => $_getSZ(2);
  @$pb.TagNumber(3)
  set twinId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTwinId() => $_has(2);
  @$pb.TagNumber(3)
  void clearTwinId() => $_clearField(3);

  /// design_asset_id: UUID of the asset in the originating design service
  /// (e.g., layout tile ID, electrical string ID, transmission tower position ID).
  @$pb.TagNumber(4)
  $core.String get designAssetId => $_getSZ(3);
  @$pb.TagNumber(4)
  set designAssetId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDesignAssetId() => $_has(3);
  @$pb.TagNumber(4)
  void clearDesignAssetId() => $_clearField(4);

  @$pb.TagNumber(5)
  DesignAssetType get designAssetType => $_getN(4);
  @$pb.TagNumber(5)
  set designAssetType(DesignAssetType v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasDesignAssetType() => $_has(4);
  @$pb.TagNumber(5)
  void clearDesignAssetType() => $_clearField(5);

  /// physical_serial_number: Manufacturer serial number of the installed unit.
  @$pb.TagNumber(6)
  $core.String get physicalSerialNumber => $_getSZ(5);
  @$pb.TagNumber(6)
  set physicalSerialNumber($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPhysicalSerialNumber() => $_has(5);
  @$pb.TagNumber(6)
  void clearPhysicalSerialNumber() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get manufacturer => $_getSZ(6);
  @$pb.TagNumber(7)
  set manufacturer($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasManufacturer() => $_has(6);
  @$pb.TagNumber(7)
  void clearManufacturer() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get model => $_getSZ(7);
  @$pb.TagNumber(8)
  set model($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasModel() => $_has(7);
  @$pb.TagNumber(8)
  void clearModel() => $_clearField(8);

  /// installation_date: Date the physical asset was installed on-site.
  @$pb.TagNumber(9)
  $0.Timestamp get installationDate => $_getN(8);
  @$pb.TagNumber(9)
  set installationDate($0.Timestamp v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasInstallationDate() => $_has(8);
  @$pb.TagNumber(9)
  void clearInstallationDate() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureInstallationDate() => $_ensure(8);

  /// commissioning_reference: IEC 62446-1 commissioning record reference for the asset.
  @$pb.TagNumber(10)
  $core.String get commissioningReference => $_getSZ(9);
  @$pb.TagNumber(10)
  set commissioningReference($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasCommissioningReference() => $_has(9);
  @$pb.TagNumber(10)
  void clearCommissioningReference() => $_clearField(10);

  /// installation_notes: Free-form field for installer notes, tag numbers, bay identifiers.
  @$pb.TagNumber(11)
  $core.String get installationNotes => $_getSZ(10);
  @$pb.TagNumber(11)
  set installationNotes($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasInstallationNotes() => $_has(10);
  @$pb.TagNumber(11)
  void clearInstallationNotes() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get linkedByActorId => $_getSZ(11);
  @$pb.TagNumber(12)
  set linkedByActorId($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasLinkedByActorId() => $_has(11);
  @$pb.TagNumber(12)
  void clearLinkedByActorId() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get linkedAt => $_getN(12);
  @$pb.TagNumber(13)
  set linkedAt($0.Timestamp v) { $_setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasLinkedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearLinkedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureLinkedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get updatedAt => $_getN(13);
  @$pb.TagNumber(14)
  set updatedAt($0.Timestamp v) { $_setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasUpdatedAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearUpdatedAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureUpdatedAt() => $_ensure(13);
}

class LinkAssetIdentityRequest extends $pb.GeneratedMessage {
  factory LinkAssetIdentityRequest({
    $core.String? projectId,
    $core.String? twinId,
    $core.String? designAssetId,
    DesignAssetType? designAssetType,
    $core.String? physicalSerialNumber,
    $core.String? manufacturer,
    $core.String? model,
    $0.Timestamp? installationDate,
    $core.String? commissioningReference,
    $core.String? installationNotes,
    $core.String? linkedByActorId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (designAssetId != null) {
      $result.designAssetId = designAssetId;
    }
    if (designAssetType != null) {
      $result.designAssetType = designAssetType;
    }
    if (physicalSerialNumber != null) {
      $result.physicalSerialNumber = physicalSerialNumber;
    }
    if (manufacturer != null) {
      $result.manufacturer = manufacturer;
    }
    if (model != null) {
      $result.model = model;
    }
    if (installationDate != null) {
      $result.installationDate = installationDate;
    }
    if (commissioningReference != null) {
      $result.commissioningReference = commissioningReference;
    }
    if (installationNotes != null) {
      $result.installationNotes = installationNotes;
    }
    if (linkedByActorId != null) {
      $result.linkedByActorId = linkedByActorId;
    }
    return $result;
  }
  LinkAssetIdentityRequest._() : super();
  factory LinkAssetIdentityRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LinkAssetIdentityRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LinkAssetIdentityRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'twinId')
    ..aOS(3, _omitFieldNames ? '' : 'designAssetId')
    ..e<DesignAssetType>(4, _omitFieldNames ? '' : 'designAssetType', $pb.PbFieldType.OE, defaultOrMaker: DesignAssetType.DESIGN_ASSET_TYPE_UNSPECIFIED, valueOf: DesignAssetType.valueOf, enumValues: DesignAssetType.values)
    ..aOS(5, _omitFieldNames ? '' : 'physicalSerialNumber')
    ..aOS(6, _omitFieldNames ? '' : 'manufacturer')
    ..aOS(7, _omitFieldNames ? '' : 'model')
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'installationDate', subBuilder: $0.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'commissioningReference')
    ..aOS(10, _omitFieldNames ? '' : 'installationNotes')
    ..aOS(11, _omitFieldNames ? '' : 'linkedByActorId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LinkAssetIdentityRequest clone() => LinkAssetIdentityRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LinkAssetIdentityRequest copyWith(void Function(LinkAssetIdentityRequest) updates) => super.copyWith((message) => updates(message as LinkAssetIdentityRequest)) as LinkAssetIdentityRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinkAssetIdentityRequest create() => LinkAssetIdentityRequest._();
  LinkAssetIdentityRequest createEmptyInstance() => create();
  static $pb.PbList<LinkAssetIdentityRequest> createRepeated() => $pb.PbList<LinkAssetIdentityRequest>();
  @$core.pragma('dart2js:noInline')
  static LinkAssetIdentityRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LinkAssetIdentityRequest>(create);
  static LinkAssetIdentityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get twinId => $_getSZ(1);
  @$pb.TagNumber(2)
  set twinId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTwinId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTwinId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get designAssetId => $_getSZ(2);
  @$pb.TagNumber(3)
  set designAssetId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDesignAssetId() => $_has(2);
  @$pb.TagNumber(3)
  void clearDesignAssetId() => $_clearField(3);

  @$pb.TagNumber(4)
  DesignAssetType get designAssetType => $_getN(3);
  @$pb.TagNumber(4)
  set designAssetType(DesignAssetType v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasDesignAssetType() => $_has(3);
  @$pb.TagNumber(4)
  void clearDesignAssetType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get physicalSerialNumber => $_getSZ(4);
  @$pb.TagNumber(5)
  set physicalSerialNumber($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPhysicalSerialNumber() => $_has(4);
  @$pb.TagNumber(5)
  void clearPhysicalSerialNumber() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get manufacturer => $_getSZ(5);
  @$pb.TagNumber(6)
  set manufacturer($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasManufacturer() => $_has(5);
  @$pb.TagNumber(6)
  void clearManufacturer() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get model => $_getSZ(6);
  @$pb.TagNumber(7)
  set model($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasModel() => $_has(6);
  @$pb.TagNumber(7)
  void clearModel() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get installationDate => $_getN(7);
  @$pb.TagNumber(8)
  set installationDate($0.Timestamp v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasInstallationDate() => $_has(7);
  @$pb.TagNumber(8)
  void clearInstallationDate() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureInstallationDate() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get commissioningReference => $_getSZ(8);
  @$pb.TagNumber(9)
  set commissioningReference($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCommissioningReference() => $_has(8);
  @$pb.TagNumber(9)
  void clearCommissioningReference() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get installationNotes => $_getSZ(9);
  @$pb.TagNumber(10)
  set installationNotes($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasInstallationNotes() => $_has(9);
  @$pb.TagNumber(10)
  void clearInstallationNotes() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get linkedByActorId => $_getSZ(10);
  @$pb.TagNumber(11)
  set linkedByActorId($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasLinkedByActorId() => $_has(10);
  @$pb.TagNumber(11)
  void clearLinkedByActorId() => $_clearField(11);
}

class LinkAssetIdentityResponse extends $pb.GeneratedMessage {
  factory LinkAssetIdentityResponse({
    AssetIdentity? assetIdentity,
  }) {
    final $result = create();
    if (assetIdentity != null) {
      $result.assetIdentity = assetIdentity;
    }
    return $result;
  }
  LinkAssetIdentityResponse._() : super();
  factory LinkAssetIdentityResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LinkAssetIdentityResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LinkAssetIdentityResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOM<AssetIdentity>(1, _omitFieldNames ? '' : 'assetIdentity', subBuilder: AssetIdentity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LinkAssetIdentityResponse clone() => LinkAssetIdentityResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LinkAssetIdentityResponse copyWith(void Function(LinkAssetIdentityResponse) updates) => super.copyWith((message) => updates(message as LinkAssetIdentityResponse)) as LinkAssetIdentityResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LinkAssetIdentityResponse create() => LinkAssetIdentityResponse._();
  LinkAssetIdentityResponse createEmptyInstance() => create();
  static $pb.PbList<LinkAssetIdentityResponse> createRepeated() => $pb.PbList<LinkAssetIdentityResponse>();
  @$core.pragma('dart2js:noInline')
  static LinkAssetIdentityResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LinkAssetIdentityResponse>(create);
  static LinkAssetIdentityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AssetIdentity get assetIdentity => $_getN(0);
  @$pb.TagNumber(1)
  set assetIdentity(AssetIdentity v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetIdentity() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetIdentity() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetIdentity ensureAssetIdentity() => $_ensure(0);
}

class GetAssetIdentityRequest extends $pb.GeneratedMessage {
  factory GetAssetIdentityRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetAssetIdentityRequest._() : super();
  factory GetAssetIdentityRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetAssetIdentityRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetAssetIdentityRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetAssetIdentityRequest clone() => GetAssetIdentityRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetAssetIdentityRequest copyWith(void Function(GetAssetIdentityRequest) updates) => super.copyWith((message) => updates(message as GetAssetIdentityRequest)) as GetAssetIdentityRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetIdentityRequest create() => GetAssetIdentityRequest._();
  GetAssetIdentityRequest createEmptyInstance() => create();
  static $pb.PbList<GetAssetIdentityRequest> createRepeated() => $pb.PbList<GetAssetIdentityRequest>();
  @$core.pragma('dart2js:noInline')
  static GetAssetIdentityRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetAssetIdentityRequest>(create);
  static GetAssetIdentityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetAssetIdentityResponse extends $pb.GeneratedMessage {
  factory GetAssetIdentityResponse({
    AssetIdentity? assetIdentity,
  }) {
    final $result = create();
    if (assetIdentity != null) {
      $result.assetIdentity = assetIdentity;
    }
    return $result;
  }
  GetAssetIdentityResponse._() : super();
  factory GetAssetIdentityResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetAssetIdentityResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetAssetIdentityResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOM<AssetIdentity>(1, _omitFieldNames ? '' : 'assetIdentity', subBuilder: AssetIdentity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetAssetIdentityResponse clone() => GetAssetIdentityResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetAssetIdentityResponse copyWith(void Function(GetAssetIdentityResponse) updates) => super.copyWith((message) => updates(message as GetAssetIdentityResponse)) as GetAssetIdentityResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAssetIdentityResponse create() => GetAssetIdentityResponse._();
  GetAssetIdentityResponse createEmptyInstance() => create();
  static $pb.PbList<GetAssetIdentityResponse> createRepeated() => $pb.PbList<GetAssetIdentityResponse>();
  @$core.pragma('dart2js:noInline')
  static GetAssetIdentityResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetAssetIdentityResponse>(create);
  static GetAssetIdentityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AssetIdentity get assetIdentity => $_getN(0);
  @$pb.TagNumber(1)
  set assetIdentity(AssetIdentity v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetIdentity() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetIdentity() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetIdentity ensureAssetIdentity() => $_ensure(0);
}

class ListAssetIdentitiesByProjectRequest extends $pb.GeneratedMessage {
  factory ListAssetIdentitiesByProjectRequest({
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
  ListAssetIdentitiesByProjectRequest._() : super();
  factory ListAssetIdentitiesByProjectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListAssetIdentitiesByProjectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListAssetIdentitiesByProjectRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListAssetIdentitiesByProjectRequest clone() => ListAssetIdentitiesByProjectRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListAssetIdentitiesByProjectRequest copyWith(void Function(ListAssetIdentitiesByProjectRequest) updates) => super.copyWith((message) => updates(message as ListAssetIdentitiesByProjectRequest)) as ListAssetIdentitiesByProjectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssetIdentitiesByProjectRequest create() => ListAssetIdentitiesByProjectRequest._();
  ListAssetIdentitiesByProjectRequest createEmptyInstance() => create();
  static $pb.PbList<ListAssetIdentitiesByProjectRequest> createRepeated() => $pb.PbList<ListAssetIdentitiesByProjectRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAssetIdentitiesByProjectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAssetIdentitiesByProjectRequest>(create);
  static ListAssetIdentitiesByProjectRequest? _defaultInstance;

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

class ListAssetIdentitiesByProjectResponse extends $pb.GeneratedMessage {
  factory ListAssetIdentitiesByProjectResponse({
    $core.Iterable<AssetIdentity>? assetIdentities,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final $result = create();
    if (assetIdentities != null) {
      $result.assetIdentities.addAll(assetIdentities);
    }
    if (nextPageToken != null) {
      $result.nextPageToken = nextPageToken;
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    return $result;
  }
  ListAssetIdentitiesByProjectResponse._() : super();
  factory ListAssetIdentitiesByProjectResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListAssetIdentitiesByProjectResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListAssetIdentitiesByProjectResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..pc<AssetIdentity>(1, _omitFieldNames ? '' : 'assetIdentities', $pb.PbFieldType.PM, subBuilder: AssetIdentity.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListAssetIdentitiesByProjectResponse clone() => ListAssetIdentitiesByProjectResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListAssetIdentitiesByProjectResponse copyWith(void Function(ListAssetIdentitiesByProjectResponse) updates) => super.copyWith((message) => updates(message as ListAssetIdentitiesByProjectResponse)) as ListAssetIdentitiesByProjectResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssetIdentitiesByProjectResponse create() => ListAssetIdentitiesByProjectResponse._();
  ListAssetIdentitiesByProjectResponse createEmptyInstance() => create();
  static $pb.PbList<ListAssetIdentitiesByProjectResponse> createRepeated() => $pb.PbList<ListAssetIdentitiesByProjectResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAssetIdentitiesByProjectResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAssetIdentitiesByProjectResponse>(create);
  static ListAssetIdentitiesByProjectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AssetIdentity> get assetIdentities => $_getList(0);

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

class ListAssetIdentitiesByTwinRequest extends $pb.GeneratedMessage {
  factory ListAssetIdentitiesByTwinRequest({
    $core.String? twinId,
    DesignAssetType? typeFilter,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final $result = create();
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (typeFilter != null) {
      $result.typeFilter = typeFilter;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    if (pageToken != null) {
      $result.pageToken = pageToken;
    }
    return $result;
  }
  ListAssetIdentitiesByTwinRequest._() : super();
  factory ListAssetIdentitiesByTwinRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListAssetIdentitiesByTwinRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListAssetIdentitiesByTwinRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'twinId')
    ..e<DesignAssetType>(2, _omitFieldNames ? '' : 'typeFilter', $pb.PbFieldType.OE, defaultOrMaker: DesignAssetType.DESIGN_ASSET_TYPE_UNSPECIFIED, valueOf: DesignAssetType.valueOf, enumValues: DesignAssetType.values)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListAssetIdentitiesByTwinRequest clone() => ListAssetIdentitiesByTwinRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListAssetIdentitiesByTwinRequest copyWith(void Function(ListAssetIdentitiesByTwinRequest) updates) => super.copyWith((message) => updates(message as ListAssetIdentitiesByTwinRequest)) as ListAssetIdentitiesByTwinRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssetIdentitiesByTwinRequest create() => ListAssetIdentitiesByTwinRequest._();
  ListAssetIdentitiesByTwinRequest createEmptyInstance() => create();
  static $pb.PbList<ListAssetIdentitiesByTwinRequest> createRepeated() => $pb.PbList<ListAssetIdentitiesByTwinRequest>();
  @$core.pragma('dart2js:noInline')
  static ListAssetIdentitiesByTwinRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAssetIdentitiesByTwinRequest>(create);
  static ListAssetIdentitiesByTwinRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get twinId => $_getSZ(0);
  @$pb.TagNumber(1)
  set twinId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwinId() => $_clearField(1);

  /// type_filter: If UNSPECIFIED, returns all asset types.
  @$pb.TagNumber(2)
  DesignAssetType get typeFilter => $_getN(1);
  @$pb.TagNumber(2)
  set typeFilter(DesignAssetType v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTypeFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearTypeFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get pageToken => $_getSZ(3);
  @$pb.TagNumber(4)
  set pageToken($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPageToken() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageToken() => $_clearField(4);
}

class ListAssetIdentitiesByTwinResponse extends $pb.GeneratedMessage {
  factory ListAssetIdentitiesByTwinResponse({
    $core.Iterable<AssetIdentity>? assetIdentities,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final $result = create();
    if (assetIdentities != null) {
      $result.assetIdentities.addAll(assetIdentities);
    }
    if (nextPageToken != null) {
      $result.nextPageToken = nextPageToken;
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    return $result;
  }
  ListAssetIdentitiesByTwinResponse._() : super();
  factory ListAssetIdentitiesByTwinResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListAssetIdentitiesByTwinResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListAssetIdentitiesByTwinResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..pc<AssetIdentity>(1, _omitFieldNames ? '' : 'assetIdentities', $pb.PbFieldType.PM, subBuilder: AssetIdentity.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListAssetIdentitiesByTwinResponse clone() => ListAssetIdentitiesByTwinResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListAssetIdentitiesByTwinResponse copyWith(void Function(ListAssetIdentitiesByTwinResponse) updates) => super.copyWith((message) => updates(message as ListAssetIdentitiesByTwinResponse)) as ListAssetIdentitiesByTwinResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListAssetIdentitiesByTwinResponse create() => ListAssetIdentitiesByTwinResponse._();
  ListAssetIdentitiesByTwinResponse createEmptyInstance() => create();
  static $pb.PbList<ListAssetIdentitiesByTwinResponse> createRepeated() => $pb.PbList<ListAssetIdentitiesByTwinResponse>();
  @$core.pragma('dart2js:noInline')
  static ListAssetIdentitiesByTwinResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListAssetIdentitiesByTwinResponse>(create);
  static ListAssetIdentitiesByTwinResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AssetIdentity> get assetIdentities => $_getList(0);

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

class UpdateAssetIdentityRequest extends $pb.GeneratedMessage {
  factory UpdateAssetIdentityRequest({
    $core.String? id,
    $core.String? physicalSerialNumber,
    $core.String? commissioningReference,
    $core.String? installationNotes,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (physicalSerialNumber != null) {
      $result.physicalSerialNumber = physicalSerialNumber;
    }
    if (commissioningReference != null) {
      $result.commissioningReference = commissioningReference;
    }
    if (installationNotes != null) {
      $result.installationNotes = installationNotes;
    }
    return $result;
  }
  UpdateAssetIdentityRequest._() : super();
  factory UpdateAssetIdentityRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateAssetIdentityRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateAssetIdentityRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'physicalSerialNumber')
    ..aOS(3, _omitFieldNames ? '' : 'commissioningReference')
    ..aOS(4, _omitFieldNames ? '' : 'installationNotes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateAssetIdentityRequest clone() => UpdateAssetIdentityRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateAssetIdentityRequest copyWith(void Function(UpdateAssetIdentityRequest) updates) => super.copyWith((message) => updates(message as UpdateAssetIdentityRequest)) as UpdateAssetIdentityRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAssetIdentityRequest create() => UpdateAssetIdentityRequest._();
  UpdateAssetIdentityRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateAssetIdentityRequest> createRepeated() => $pb.PbList<UpdateAssetIdentityRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateAssetIdentityRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateAssetIdentityRequest>(create);
  static UpdateAssetIdentityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get physicalSerialNumber => $_getSZ(1);
  @$pb.TagNumber(2)
  set physicalSerialNumber($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPhysicalSerialNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearPhysicalSerialNumber() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get commissioningReference => $_getSZ(2);
  @$pb.TagNumber(3)
  set commissioningReference($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCommissioningReference() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommissioningReference() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get installationNotes => $_getSZ(3);
  @$pb.TagNumber(4)
  set installationNotes($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasInstallationNotes() => $_has(3);
  @$pb.TagNumber(4)
  void clearInstallationNotes() => $_clearField(4);
}

class UpdateAssetIdentityResponse extends $pb.GeneratedMessage {
  factory UpdateAssetIdentityResponse({
    AssetIdentity? assetIdentity,
  }) {
    final $result = create();
    if (assetIdentity != null) {
      $result.assetIdentity = assetIdentity;
    }
    return $result;
  }
  UpdateAssetIdentityResponse._() : super();
  factory UpdateAssetIdentityResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateAssetIdentityResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateAssetIdentityResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOM<AssetIdentity>(1, _omitFieldNames ? '' : 'assetIdentity', subBuilder: AssetIdentity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateAssetIdentityResponse clone() => UpdateAssetIdentityResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateAssetIdentityResponse copyWith(void Function(UpdateAssetIdentityResponse) updates) => super.copyWith((message) => updates(message as UpdateAssetIdentityResponse)) as UpdateAssetIdentityResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateAssetIdentityResponse create() => UpdateAssetIdentityResponse._();
  UpdateAssetIdentityResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateAssetIdentityResponse> createRepeated() => $pb.PbList<UpdateAssetIdentityResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateAssetIdentityResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateAssetIdentityResponse>(create);
  static UpdateAssetIdentityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AssetIdentity get assetIdentity => $_getN(0);
  @$pb.TagNumber(1)
  set assetIdentity(AssetIdentity v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAssetIdentity() => $_has(0);
  @$pb.TagNumber(1)
  void clearAssetIdentity() => $_clearField(1);
  @$pb.TagNumber(1)
  AssetIdentity ensureAssetIdentity() => $_ensure(0);
}

class UnlinkAssetIdentityRequest extends $pb.GeneratedMessage {
  factory UnlinkAssetIdentityRequest({
    $core.String? id,
    $core.String? actorId,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (actorId != null) {
      $result.actorId = actorId;
    }
    return $result;
  }
  UnlinkAssetIdentityRequest._() : super();
  factory UnlinkAssetIdentityRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnlinkAssetIdentityRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnlinkAssetIdentityRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'actorId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnlinkAssetIdentityRequest clone() => UnlinkAssetIdentityRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnlinkAssetIdentityRequest copyWith(void Function(UnlinkAssetIdentityRequest) updates) => super.copyWith((message) => updates(message as UnlinkAssetIdentityRequest)) as UnlinkAssetIdentityRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnlinkAssetIdentityRequest create() => UnlinkAssetIdentityRequest._();
  UnlinkAssetIdentityRequest createEmptyInstance() => create();
  static $pb.PbList<UnlinkAssetIdentityRequest> createRepeated() => $pb.PbList<UnlinkAssetIdentityRequest>();
  @$core.pragma('dart2js:noInline')
  static UnlinkAssetIdentityRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnlinkAssetIdentityRequest>(create);
  static UnlinkAssetIdentityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get actorId => $_getSZ(1);
  @$pb.TagNumber(2)
  set actorId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasActorId() => $_has(1);
  @$pb.TagNumber(2)
  void clearActorId() => $_clearField(2);
}

class UnlinkAssetIdentityResponse extends $pb.GeneratedMessage {
  factory UnlinkAssetIdentityResponse({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  UnlinkAssetIdentityResponse._() : super();
  factory UnlinkAssetIdentityResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UnlinkAssetIdentityResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UnlinkAssetIdentityResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'asset.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UnlinkAssetIdentityResponse clone() => UnlinkAssetIdentityResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UnlinkAssetIdentityResponse copyWith(void Function(UnlinkAssetIdentityResponse) updates) => super.copyWith((message) => updates(message as UnlinkAssetIdentityResponse)) as UnlinkAssetIdentityResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UnlinkAssetIdentityResponse create() => UnlinkAssetIdentityResponse._();
  UnlinkAssetIdentityResponse createEmptyInstance() => create();
  static $pb.PbList<UnlinkAssetIdentityResponse> createRepeated() => $pb.PbList<UnlinkAssetIdentityResponse>();
  @$core.pragma('dart2js:noInline')
  static UnlinkAssetIdentityResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UnlinkAssetIdentityResponse>(create);
  static UnlinkAssetIdentityResponse? _defaultInstance;

  /// id: The ID of the unlinked record, confirming deletion.
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

/// AssetIdentityService manages the linkage of design-time asset IDs (from
/// layout, electrical, and transmission services) to physical/operational asset
/// identities (manufacturer serial numbers, SCADA tags, IEC 62446-1 commissioning
/// references).  Identity records are created during the commissioning handover
/// step and consumed by TelemetryService and FaultService for event correlation.
class AssetIdentityServiceApi {
  $pb.RpcClient _client;
  AssetIdentityServiceApi(this._client);

  /// LinkAssetIdentity creates an identity link between a design asset and its
  /// physical installation instance.  Requires an ACTIVE twin_id.
  /// Returns ALREADY_EXISTS if a link for the same design_asset_id already exists
  /// within the same twin.
  $async.Future<LinkAssetIdentityResponse> linkAssetIdentity($pb.ClientContext? ctx, LinkAssetIdentityRequest request) =>
    _client.invoke<LinkAssetIdentityResponse>(ctx, 'AssetIdentityService', 'LinkAssetIdentity', request, LinkAssetIdentityResponse())
  ;
  /// GetAssetIdentity returns a single identity link by its unique ID.
  $async.Future<GetAssetIdentityResponse> getAssetIdentity($pb.ClientContext? ctx, GetAssetIdentityRequest request) =>
    _client.invoke<GetAssetIdentityResponse>(ctx, 'AssetIdentityService', 'GetAssetIdentity', request, GetAssetIdentityResponse())
  ;
  /// ListAssetIdentitiesByProject returns all identity links for a project across
  /// all provisioned twins, ordered by linked_at descending.
  $async.Future<ListAssetIdentitiesByProjectResponse> listAssetIdentitiesByProject($pb.ClientContext? ctx, ListAssetIdentitiesByProjectRequest request) =>
    _client.invoke<ListAssetIdentitiesByProjectResponse>(ctx, 'AssetIdentityService', 'ListAssetIdentitiesByProject', request, ListAssetIdentitiesByProjectResponse())
  ;
  /// ListAssetIdentitiesByTwin returns all identity links for a specific twin,
  /// optionally filtered by design asset type.
  $async.Future<ListAssetIdentitiesByTwinResponse> listAssetIdentitiesByTwin($pb.ClientContext? ctx, ListAssetIdentitiesByTwinRequest request) =>
    _client.invoke<ListAssetIdentitiesByTwinResponse>(ctx, 'AssetIdentityService', 'ListAssetIdentitiesByTwin', request, ListAssetIdentitiesByTwinResponse())
  ;
  /// UpdateAssetIdentity patches the mutable physical identity fields
  /// (physical_serial_number, installation_notes, commissioning_reference).
  /// Design asset linkage fields (design_asset_id, design_asset_type) are immutable.
  $async.Future<UpdateAssetIdentityResponse> updateAssetIdentity($pb.ClientContext? ctx, UpdateAssetIdentityRequest request) =>
    _client.invoke<UpdateAssetIdentityResponse>(ctx, 'AssetIdentityService', 'UpdateAssetIdentity', request, UpdateAssetIdentityResponse())
  ;
  /// UnlinkAssetIdentity permanently removes an identity link.
  /// Records referenced by active TelemetryService readings cannot be unlinked.
  $async.Future<UnlinkAssetIdentityResponse> unlinkAssetIdentity($pb.ClientContext? ctx, UnlinkAssetIdentityRequest request) =>
    _client.invoke<UnlinkAssetIdentityResponse>(ctx, 'AssetIdentityService', 'UnlinkAssetIdentity', request, UnlinkAssetIdentityResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
