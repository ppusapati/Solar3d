//
//  Generated code. Do not modify.
//  source: asset/v1/asset_identity.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use designAssetTypeDescriptor instead')
const DesignAssetType$json = {
  '1': 'DesignAssetType',
  '2': [
    {'1': 'DESIGN_ASSET_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'DESIGN_ASSET_TYPE_SOLAR_PANEL', '2': 1},
    {'1': 'DESIGN_ASSET_TYPE_INVERTER', '2': 2},
    {'1': 'DESIGN_ASSET_TYPE_STRING', '2': 3},
    {'1': 'DESIGN_ASSET_TYPE_TRANSFORMER', '2': 4},
    {'1': 'DESIGN_ASSET_TYPE_CABLE_RUN', '2': 5},
    {'1': 'DESIGN_ASSET_TYPE_COMBINER_BOX', '2': 6},
    {'1': 'DESIGN_ASSET_TYPE_PROTECTION_RELAY', '2': 7},
    {'1': 'DESIGN_ASSET_TYPE_TRANSMISSION_TOWER', '2': 8},
    {'1': 'DESIGN_ASSET_TYPE_OTHER', '2': 9},
  ],
};

/// Descriptor for `DesignAssetType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List designAssetTypeDescriptor = $convert.base64Decode(
    'Cg9EZXNpZ25Bc3NldFR5cGUSIQodREVTSUdOX0FTU0VUX1RZUEVfVU5TUEVDSUZJRUQQABIhCh'
    '1ERVNJR05fQVNTRVRfVFlQRV9TT0xBUl9QQU5FTBABEh4KGkRFU0lHTl9BU1NFVF9UWVBFX0lO'
    'VkVSVEVSEAISHAoYREVTSUdOX0FTU0VUX1RZUEVfU1RSSU5HEAMSIQodREVTSUdOX0FTU0VUX1'
    'RZUEVfVFJBTlNGT1JNRVIQBBIfChtERVNJR05fQVNTRVRfVFlQRV9DQUJMRV9SVU4QBRIiCh5E'
    'RVNJR05fQVNTRVRfVFlQRV9DT01CSU5FUl9CT1gQBhImCiJERVNJR05fQVNTRVRfVFlQRV9QUk'
    '9URUNUSU9OX1JFTEFZEAcSKAokREVTSUdOX0FTU0VUX1RZUEVfVFJBTlNNSVNTSU9OX1RPV0VS'
    'EAgSGwoXREVTSUdOX0FTU0VUX1RZUEVfT1RIRVIQCQ==');

@$core.Deprecated('Use assetIdentityDescriptor instead')
const AssetIdentity$json = {
  '1': 'AssetIdentity',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'twin_id', '3': 3, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'design_asset_id', '3': 4, '4': 1, '5': 9, '10': 'designAssetId'},
    {'1': 'design_asset_type', '3': 5, '4': 1, '5': 14, '6': '.asset.v1.DesignAssetType', '10': 'designAssetType'},
    {'1': 'physical_serial_number', '3': 6, '4': 1, '5': 9, '10': 'physicalSerialNumber'},
    {'1': 'manufacturer', '3': 7, '4': 1, '5': 9, '10': 'manufacturer'},
    {'1': 'model', '3': 8, '4': 1, '5': 9, '10': 'model'},
    {'1': 'installation_date', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'installationDate'},
    {'1': 'commissioning_reference', '3': 10, '4': 1, '5': 9, '10': 'commissioningReference'},
    {'1': 'installation_notes', '3': 11, '4': 1, '5': 9, '10': 'installationNotes'},
    {'1': 'linked_by_actor_id', '3': 12, '4': 1, '5': 9, '10': 'linkedByActorId'},
    {'1': 'linked_at', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'linkedAt'},
    {'1': 'updated_at', '3': 14, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `AssetIdentity`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assetIdentityDescriptor = $convert.base64Decode(
    'Cg1Bc3NldElkZW50aXR5Eg4KAmlkGAEgASgJUgJpZBIdCgpwcm9qZWN0X2lkGAIgASgJUglwcm'
    '9qZWN0SWQSFwoHdHdpbl9pZBgDIAEoCVIGdHdpbklkEiYKD2Rlc2lnbl9hc3NldF9pZBgEIAEo'
    'CVINZGVzaWduQXNzZXRJZBJFChFkZXNpZ25fYXNzZXRfdHlwZRgFIAEoDjIZLmFzc2V0LnYxLk'
    'Rlc2lnbkFzc2V0VHlwZVIPZGVzaWduQXNzZXRUeXBlEjQKFnBoeXNpY2FsX3NlcmlhbF9udW1i'
    'ZXIYBiABKAlSFHBoeXNpY2FsU2VyaWFsTnVtYmVyEiIKDG1hbnVmYWN0dXJlchgHIAEoCVIMbW'
    'FudWZhY3R1cmVyEhQKBW1vZGVsGAggASgJUgVtb2RlbBJHChFpbnN0YWxsYXRpb25fZGF0ZRgJ'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSEGluc3RhbGxhdGlvbkRhdGUSNwoXY2'
    '9tbWlzc2lvbmluZ19yZWZlcmVuY2UYCiABKAlSFmNvbW1pc3Npb25pbmdSZWZlcmVuY2USLQoS'
    'aW5zdGFsbGF0aW9uX25vdGVzGAsgASgJUhFpbnN0YWxsYXRpb25Ob3RlcxIrChJsaW5rZWRfYn'
    'lfYWN0b3JfaWQYDCABKAlSD2xpbmtlZEJ5QWN0b3JJZBI3CglsaW5rZWRfYXQYDSABKAsyGi5n'
    'b29nbGUucHJvdG9idWYuVGltZXN0YW1wUghsaW5rZWRBdBI5Cgp1cGRhdGVkX2F0GA4gASgLMh'
    'ouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use linkAssetIdentityRequestDescriptor instead')
const LinkAssetIdentityRequest$json = {
  '1': 'LinkAssetIdentityRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'twin_id', '3': 2, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'design_asset_id', '3': 3, '4': 1, '5': 9, '10': 'designAssetId'},
    {'1': 'design_asset_type', '3': 4, '4': 1, '5': 14, '6': '.asset.v1.DesignAssetType', '10': 'designAssetType'},
    {'1': 'physical_serial_number', '3': 5, '4': 1, '5': 9, '10': 'physicalSerialNumber'},
    {'1': 'manufacturer', '3': 6, '4': 1, '5': 9, '10': 'manufacturer'},
    {'1': 'model', '3': 7, '4': 1, '5': 9, '10': 'model'},
    {'1': 'installation_date', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'installationDate'},
    {'1': 'commissioning_reference', '3': 9, '4': 1, '5': 9, '10': 'commissioningReference'},
    {'1': 'installation_notes', '3': 10, '4': 1, '5': 9, '10': 'installationNotes'},
    {'1': 'linked_by_actor_id', '3': 11, '4': 1, '5': 9, '10': 'linkedByActorId'},
  ],
};

/// Descriptor for `LinkAssetIdentityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkAssetIdentityRequestDescriptor = $convert.base64Decode(
    'ChhMaW5rQXNzZXRJZGVudGl0eVJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdE'
    'lkEhcKB3R3aW5faWQYAiABKAlSBnR3aW5JZBImCg9kZXNpZ25fYXNzZXRfaWQYAyABKAlSDWRl'
    'c2lnbkFzc2V0SWQSRQoRZGVzaWduX2Fzc2V0X3R5cGUYBCABKA4yGS5hc3NldC52MS5EZXNpZ2'
    '5Bc3NldFR5cGVSD2Rlc2lnbkFzc2V0VHlwZRI0ChZwaHlzaWNhbF9zZXJpYWxfbnVtYmVyGAUg'
    'ASgJUhRwaHlzaWNhbFNlcmlhbE51bWJlchIiCgxtYW51ZmFjdHVyZXIYBiABKAlSDG1hbnVmYW'
    'N0dXJlchIUCgVtb2RlbBgHIAEoCVIFbW9kZWwSRwoRaW5zdGFsbGF0aW9uX2RhdGUYCCABKAsy'
    'Gi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhBpbnN0YWxsYXRpb25EYXRlEjcKF2NvbW1pc3'
    'Npb25pbmdfcmVmZXJlbmNlGAkgASgJUhZjb21taXNzaW9uaW5nUmVmZXJlbmNlEi0KEmluc3Rh'
    'bGxhdGlvbl9ub3RlcxgKIAEoCVIRaW5zdGFsbGF0aW9uTm90ZXMSKwoSbGlua2VkX2J5X2FjdG'
    '9yX2lkGAsgASgJUg9saW5rZWRCeUFjdG9ySWQ=');

@$core.Deprecated('Use linkAssetIdentityResponseDescriptor instead')
const LinkAssetIdentityResponse$json = {
  '1': 'LinkAssetIdentityResponse',
  '2': [
    {'1': 'asset_identity', '3': 1, '4': 1, '5': 11, '6': '.asset.v1.AssetIdentity', '10': 'assetIdentity'},
  ],
};

/// Descriptor for `LinkAssetIdentityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List linkAssetIdentityResponseDescriptor = $convert.base64Decode(
    'ChlMaW5rQXNzZXRJZGVudGl0eVJlc3BvbnNlEj4KDmFzc2V0X2lkZW50aXR5GAEgASgLMhcuYX'
    'NzZXQudjEuQXNzZXRJZGVudGl0eVINYXNzZXRJZGVudGl0eQ==');

@$core.Deprecated('Use getAssetIdentityRequestDescriptor instead')
const GetAssetIdentityRequest$json = {
  '1': 'GetAssetIdentityRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetAssetIdentityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetIdentityRequestDescriptor = $convert.base64Decode(
    'ChdHZXRBc3NldElkZW50aXR5UmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use getAssetIdentityResponseDescriptor instead')
const GetAssetIdentityResponse$json = {
  '1': 'GetAssetIdentityResponse',
  '2': [
    {'1': 'asset_identity', '3': 1, '4': 1, '5': 11, '6': '.asset.v1.AssetIdentity', '10': 'assetIdentity'},
  ],
};

/// Descriptor for `GetAssetIdentityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAssetIdentityResponseDescriptor = $convert.base64Decode(
    'ChhHZXRBc3NldElkZW50aXR5UmVzcG9uc2USPgoOYXNzZXRfaWRlbnRpdHkYASABKAsyFy5hc3'
    'NldC52MS5Bc3NldElkZW50aXR5Ug1hc3NldElkZW50aXR5');

@$core.Deprecated('Use listAssetIdentitiesByProjectRequestDescriptor instead')
const ListAssetIdentitiesByProjectRequest$json = {
  '1': 'ListAssetIdentitiesByProjectRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListAssetIdentitiesByProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssetIdentitiesByProjectRequestDescriptor = $convert.base64Decode(
    'CiNMaXN0QXNzZXRJZGVudGl0aWVzQnlQcm9qZWN0UmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgAS'
    'gJUglwcm9qZWN0SWQSGwoJcGFnZV9zaXplGAIgASgFUghwYWdlU2l6ZRIdCgpwYWdlX3Rva2Vu'
    'GAMgASgJUglwYWdlVG9rZW4=');

@$core.Deprecated('Use listAssetIdentitiesByProjectResponseDescriptor instead')
const ListAssetIdentitiesByProjectResponse$json = {
  '1': 'ListAssetIdentitiesByProjectResponse',
  '2': [
    {'1': 'asset_identities', '3': 1, '4': 3, '5': 11, '6': '.asset.v1.AssetIdentity', '10': 'assetIdentities'},
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListAssetIdentitiesByProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssetIdentitiesByProjectResponseDescriptor = $convert.base64Decode(
    'CiRMaXN0QXNzZXRJZGVudGl0aWVzQnlQcm9qZWN0UmVzcG9uc2USQgoQYXNzZXRfaWRlbnRpdG'
    'llcxgBIAMoCzIXLmFzc2V0LnYxLkFzc2V0SWRlbnRpdHlSD2Fzc2V0SWRlbnRpdGllcxImCg9u'
    'ZXh0X3BhZ2VfdG9rZW4YAiABKAlSDW5leHRQYWdlVG9rZW4SHwoLdG90YWxfY291bnQYAyABKA'
    'VSCnRvdGFsQ291bnQ=');

@$core.Deprecated('Use listAssetIdentitiesByTwinRequestDescriptor instead')
const ListAssetIdentitiesByTwinRequest$json = {
  '1': 'ListAssetIdentitiesByTwinRequest',
  '2': [
    {'1': 'twin_id', '3': 1, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'type_filter', '3': 2, '4': 1, '5': 14, '6': '.asset.v1.DesignAssetType', '10': 'typeFilter'},
    {'1': 'page_size', '3': 3, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 4, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListAssetIdentitiesByTwinRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssetIdentitiesByTwinRequestDescriptor = $convert.base64Decode(
    'CiBMaXN0QXNzZXRJZGVudGl0aWVzQnlUd2luUmVxdWVzdBIXCgd0d2luX2lkGAEgASgJUgZ0d2'
    'luSWQSOgoLdHlwZV9maWx0ZXIYAiABKA4yGS5hc3NldC52MS5EZXNpZ25Bc3NldFR5cGVSCnR5'
    'cGVGaWx0ZXISGwoJcGFnZV9zaXplGAMgASgFUghwYWdlU2l6ZRIdCgpwYWdlX3Rva2VuGAQgAS'
    'gJUglwYWdlVG9rZW4=');

@$core.Deprecated('Use listAssetIdentitiesByTwinResponseDescriptor instead')
const ListAssetIdentitiesByTwinResponse$json = {
  '1': 'ListAssetIdentitiesByTwinResponse',
  '2': [
    {'1': 'asset_identities', '3': 1, '4': 3, '5': 11, '6': '.asset.v1.AssetIdentity', '10': 'assetIdentities'},
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListAssetIdentitiesByTwinResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listAssetIdentitiesByTwinResponseDescriptor = $convert.base64Decode(
    'CiFMaXN0QXNzZXRJZGVudGl0aWVzQnlUd2luUmVzcG9uc2USQgoQYXNzZXRfaWRlbnRpdGllcx'
    'gBIAMoCzIXLmFzc2V0LnYxLkFzc2V0SWRlbnRpdHlSD2Fzc2V0SWRlbnRpdGllcxImCg9uZXh0'
    'X3BhZ2VfdG9rZW4YAiABKAlSDW5leHRQYWdlVG9rZW4SHwoLdG90YWxfY291bnQYAyABKAVSCn'
    'RvdGFsQ291bnQ=');

@$core.Deprecated('Use updateAssetIdentityRequestDescriptor instead')
const UpdateAssetIdentityRequest$json = {
  '1': 'UpdateAssetIdentityRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'physical_serial_number', '3': 2, '4': 1, '5': 9, '10': 'physicalSerialNumber'},
    {'1': 'commissioning_reference', '3': 3, '4': 1, '5': 9, '10': 'commissioningReference'},
    {'1': 'installation_notes', '3': 4, '4': 1, '5': 9, '10': 'installationNotes'},
  ],
};

/// Descriptor for `UpdateAssetIdentityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAssetIdentityRequestDescriptor = $convert.base64Decode(
    'ChpVcGRhdGVBc3NldElkZW50aXR5UmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSNAoWcGh5c2ljYW'
    'xfc2VyaWFsX251bWJlchgCIAEoCVIUcGh5c2ljYWxTZXJpYWxOdW1iZXISNwoXY29tbWlzc2lv'
    'bmluZ19yZWZlcmVuY2UYAyABKAlSFmNvbW1pc3Npb25pbmdSZWZlcmVuY2USLQoSaW5zdGFsbG'
    'F0aW9uX25vdGVzGAQgASgJUhFpbnN0YWxsYXRpb25Ob3Rlcw==');

@$core.Deprecated('Use updateAssetIdentityResponseDescriptor instead')
const UpdateAssetIdentityResponse$json = {
  '1': 'UpdateAssetIdentityResponse',
  '2': [
    {'1': 'asset_identity', '3': 1, '4': 1, '5': 11, '6': '.asset.v1.AssetIdentity', '10': 'assetIdentity'},
  ],
};

/// Descriptor for `UpdateAssetIdentityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateAssetIdentityResponseDescriptor = $convert.base64Decode(
    'ChtVcGRhdGVBc3NldElkZW50aXR5UmVzcG9uc2USPgoOYXNzZXRfaWRlbnRpdHkYASABKAsyFy'
    '5hc3NldC52MS5Bc3NldElkZW50aXR5Ug1hc3NldElkZW50aXR5');

@$core.Deprecated('Use unlinkAssetIdentityRequestDescriptor instead')
const UnlinkAssetIdentityRequest$json = {
  '1': 'UnlinkAssetIdentityRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'actor_id', '3': 2, '4': 1, '5': 9, '10': 'actorId'},
  ],
};

/// Descriptor for `UnlinkAssetIdentityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlinkAssetIdentityRequestDescriptor = $convert.base64Decode(
    'ChpVbmxpbmtBc3NldElkZW50aXR5UmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSGQoIYWN0b3JfaW'
    'QYAiABKAlSB2FjdG9ySWQ=');

@$core.Deprecated('Use unlinkAssetIdentityResponseDescriptor instead')
const UnlinkAssetIdentityResponse$json = {
  '1': 'UnlinkAssetIdentityResponse',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `UnlinkAssetIdentityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List unlinkAssetIdentityResponseDescriptor = $convert.base64Decode(
    'ChtVbmxpbmtBc3NldElkZW50aXR5UmVzcG9uc2USDgoCaWQYASABKAlSAmlk');

const $core.Map<$core.String, $core.dynamic> AssetIdentityServiceBase$json = {
  '1': 'AssetIdentityService',
  '2': [
    {'1': 'LinkAssetIdentity', '2': '.asset.v1.LinkAssetIdentityRequest', '3': '.asset.v1.LinkAssetIdentityResponse'},
    {'1': 'GetAssetIdentity', '2': '.asset.v1.GetAssetIdentityRequest', '3': '.asset.v1.GetAssetIdentityResponse'},
    {'1': 'ListAssetIdentitiesByProject', '2': '.asset.v1.ListAssetIdentitiesByProjectRequest', '3': '.asset.v1.ListAssetIdentitiesByProjectResponse'},
    {'1': 'ListAssetIdentitiesByTwin', '2': '.asset.v1.ListAssetIdentitiesByTwinRequest', '3': '.asset.v1.ListAssetIdentitiesByTwinResponse'},
    {'1': 'UpdateAssetIdentity', '2': '.asset.v1.UpdateAssetIdentityRequest', '3': '.asset.v1.UpdateAssetIdentityResponse'},
    {'1': 'UnlinkAssetIdentity', '2': '.asset.v1.UnlinkAssetIdentityRequest', '3': '.asset.v1.UnlinkAssetIdentityResponse'},
  ],
};

@$core.Deprecated('Use assetIdentityServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> AssetIdentityServiceBase$messageJson = {
  '.asset.v1.LinkAssetIdentityRequest': LinkAssetIdentityRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.asset.v1.LinkAssetIdentityResponse': LinkAssetIdentityResponse$json,
  '.asset.v1.AssetIdentity': AssetIdentity$json,
  '.asset.v1.GetAssetIdentityRequest': GetAssetIdentityRequest$json,
  '.asset.v1.GetAssetIdentityResponse': GetAssetIdentityResponse$json,
  '.asset.v1.ListAssetIdentitiesByProjectRequest': ListAssetIdentitiesByProjectRequest$json,
  '.asset.v1.ListAssetIdentitiesByProjectResponse': ListAssetIdentitiesByProjectResponse$json,
  '.asset.v1.ListAssetIdentitiesByTwinRequest': ListAssetIdentitiesByTwinRequest$json,
  '.asset.v1.ListAssetIdentitiesByTwinResponse': ListAssetIdentitiesByTwinResponse$json,
  '.asset.v1.UpdateAssetIdentityRequest': UpdateAssetIdentityRequest$json,
  '.asset.v1.UpdateAssetIdentityResponse': UpdateAssetIdentityResponse$json,
  '.asset.v1.UnlinkAssetIdentityRequest': UnlinkAssetIdentityRequest$json,
  '.asset.v1.UnlinkAssetIdentityResponse': UnlinkAssetIdentityResponse$json,
};

/// Descriptor for `AssetIdentityService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List assetIdentityServiceDescriptor = $convert.base64Decode(
    'ChRBc3NldElkZW50aXR5U2VydmljZRJcChFMaW5rQXNzZXRJZGVudGl0eRIiLmFzc2V0LnYxLk'
    'xpbmtBc3NldElkZW50aXR5UmVxdWVzdBojLmFzc2V0LnYxLkxpbmtBc3NldElkZW50aXR5UmVz'
    'cG9uc2USWQoQR2V0QXNzZXRJZGVudGl0eRIhLmFzc2V0LnYxLkdldEFzc2V0SWRlbnRpdHlSZX'
    'F1ZXN0GiIuYXNzZXQudjEuR2V0QXNzZXRJZGVudGl0eVJlc3BvbnNlEn0KHExpc3RBc3NldElk'
    'ZW50aXRpZXNCeVByb2plY3QSLS5hc3NldC52MS5MaXN0QXNzZXRJZGVudGl0aWVzQnlQcm9qZW'
    'N0UmVxdWVzdBouLmFzc2V0LnYxLkxpc3RBc3NldElkZW50aXRpZXNCeVByb2plY3RSZXNwb25z'
    'ZRJ0ChlMaXN0QXNzZXRJZGVudGl0aWVzQnlUd2luEiouYXNzZXQudjEuTGlzdEFzc2V0SWRlbn'
    'RpdGllc0J5VHdpblJlcXVlc3QaKy5hc3NldC52MS5MaXN0QXNzZXRJZGVudGl0aWVzQnlUd2lu'
    'UmVzcG9uc2USYgoTVXBkYXRlQXNzZXRJZGVudGl0eRIkLmFzc2V0LnYxLlVwZGF0ZUFzc2V0SW'
    'RlbnRpdHlSZXF1ZXN0GiUuYXNzZXQudjEuVXBkYXRlQXNzZXRJZGVudGl0eVJlc3BvbnNlEmIK'
    'E1VubGlua0Fzc2V0SWRlbnRpdHkSJC5hc3NldC52MS5VbmxpbmtBc3NldElkZW50aXR5UmVxdW'
    'VzdBolLmFzc2V0LnYxLlVubGlua0Fzc2V0SWRlbnRpdHlSZXNwb25zZQ==');

