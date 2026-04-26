//
//  Generated code. Do not modify.
//  source: twin/v1/digital_twin.proto
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

@$core.Deprecated('Use twinStatusDescriptor instead')
const TwinStatus$json = {
  '1': 'TwinStatus',
  '2': [
    {'1': 'TWIN_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'TWIN_STATUS_PROVISIONING', '2': 1},
    {'1': 'TWIN_STATUS_ACTIVE', '2': 2},
    {'1': 'TWIN_STATUS_SUSPENDED', '2': 3},
    {'1': 'TWIN_STATUS_DECOMMISSIONED', '2': 4},
  ],
};

/// Descriptor for `TwinStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List twinStatusDescriptor = $convert.base64Decode(
    'CgpUd2luU3RhdHVzEhsKF1RXSU5fU1RBVFVTX1VOU1BFQ0lGSUVEEAASHAoYVFdJTl9TVEFUVV'
    'NfUFJPVklTSU9OSU5HEAESFgoSVFdJTl9TVEFUVVNfQUNUSVZFEAISGQoVVFdJTl9TVEFUVVNf'
    'U1VTUEVOREVEEAMSHgoaVFdJTl9TVEFUVVNfREVDT01NSVNTSU9ORUQQBA==');

@$core.Deprecated('Use operationalStateDescriptor instead')
const OperationalState$json = {
  '1': 'OperationalState',
  '2': [
    {'1': 'power_output_kw', '3': 1, '4': 1, '5': 1, '10': 'powerOutputKw'},
    {'1': 'availability_percent', '3': 2, '4': 1, '5': 1, '10': 'availabilityPercent'},
    {'1': 'active_fault_count', '3': 3, '4': 1, '5': 5, '10': 'activeFaultCount'},
    {'1': 'health_score', '3': 4, '4': 1, '5': 1, '10': 'healthScore'},
    {'1': 'last_inspected_at', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastInspectedAt'},
  ],
};

/// Descriptor for `OperationalState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List operationalStateDescriptor = $convert.base64Decode(
    'ChBPcGVyYXRpb25hbFN0YXRlEiYKD3Bvd2VyX291dHB1dF9rdxgBIAEoAVINcG93ZXJPdXRwdX'
    'RLdxIxChRhdmFpbGFiaWxpdHlfcGVyY2VudBgCIAEoAVITYXZhaWxhYmlsaXR5UGVyY2VudBIs'
    'ChJhY3RpdmVfZmF1bHRfY291bnQYAyABKAVSEGFjdGl2ZUZhdWx0Q291bnQSIQoMaGVhbHRoX3'
    'Njb3JlGAQgASgBUgtoZWFsdGhTY29yZRJGChFsYXN0X2luc3BlY3RlZF9hdBgFIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSD2xhc3RJbnNwZWN0ZWRBdA==');

@$core.Deprecated('Use digitalTwinDescriptor instead')
const DigitalTwin$json = {
  '1': 'DigitalTwin',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 3, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'electrical_network_id', '3': 4, '4': 1, '5': 9, '10': 'electricalNetworkId'},
    {'1': 'transmission_route_id', '3': 5, '4': 1, '5': 9, '10': 'transmissionRouteId'},
    {'1': 'approved_revision_id', '3': 6, '4': 1, '5': 9, '10': 'approvedRevisionId'},
    {'1': 'status', '3': 7, '4': 1, '5': 14, '6': '.twin.v1.TwinStatus', '10': 'status'},
    {'1': 'operational_state', '3': 8, '4': 1, '5': 11, '6': '.twin.v1.OperationalState', '10': 'operationalState'},
    {'1': 'provisioned_by_actor_id', '3': 9, '4': 1, '5': 9, '10': 'provisionedByActorId'},
    {'1': 'provisioned_at', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'provisionedAt'},
    {'1': 'last_telemetry_at', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastTelemetryAt'},
    {'1': 'decommissioned_at', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'decommissionedAt'},
    {'1': 'asset_identity_link_count', '3': 13, '4': 1, '5': 5, '10': 'assetIdentityLinkCount'},
    {'1': 'metadata_json', '3': 14, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'created_at', '3': 15, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 16, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `DigitalTwin`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List digitalTwinDescriptor = $convert.base64Decode(
    'CgtEaWdpdGFsVHdpbhIOCgJpZBgBIAEoCVICaWQSHQoKcHJvamVjdF9pZBgCIAEoCVIJcHJvam'
    'VjdElkEhsKCWxheW91dF9pZBgDIAEoCVIIbGF5b3V0SWQSMgoVZWxlY3RyaWNhbF9uZXR3b3Jr'
    'X2lkGAQgASgJUhNlbGVjdHJpY2FsTmV0d29ya0lkEjIKFXRyYW5zbWlzc2lvbl9yb3V0ZV9pZB'
    'gFIAEoCVITdHJhbnNtaXNzaW9uUm91dGVJZBIwChRhcHByb3ZlZF9yZXZpc2lvbl9pZBgGIAEo'
    'CVISYXBwcm92ZWRSZXZpc2lvbklkEisKBnN0YXR1cxgHIAEoDjITLnR3aW4udjEuVHdpblN0YX'
    'R1c1IGc3RhdHVzEkYKEW9wZXJhdGlvbmFsX3N0YXRlGAggASgLMhkudHdpbi52MS5PcGVyYXRp'
    'b25hbFN0YXRlUhBvcGVyYXRpb25hbFN0YXRlEjUKF3Byb3Zpc2lvbmVkX2J5X2FjdG9yX2lkGA'
    'kgASgJUhRwcm92aXNpb25lZEJ5QWN0b3JJZBJBCg5wcm92aXNpb25lZF9hdBgKIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDXByb3Zpc2lvbmVkQXQSRgoRbGFzdF90ZWxlbWV0cn'
    'lfYXQYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg9sYXN0VGVsZW1ldHJ5QXQS'
    'RwoRZGVjb21taXNzaW9uZWRfYXQYDCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUh'
    'BkZWNvbW1pc3Npb25lZEF0EjkKGWFzc2V0X2lkZW50aXR5X2xpbmtfY291bnQYDSABKAVSFmFz'
    'c2V0SWRlbnRpdHlMaW5rQ291bnQSIwoNbWV0YWRhdGFfanNvbhgOIAEoCVIMbWV0YWRhdGFKc2'
    '9uEjkKCmNyZWF0ZWRfYXQYDyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVh'
    'dGVkQXQSOQoKdXBkYXRlZF9hdBgQIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCX'
    'VwZGF0ZWRBdA==');

@$core.Deprecated('Use provisionTwinRequestDescriptor instead')
const ProvisionTwinRequest$json = {
  '1': 'ProvisionTwinRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'electrical_network_id', '3': 3, '4': 1, '5': 9, '10': 'electricalNetworkId'},
    {'1': 'transmission_route_id', '3': 4, '4': 1, '5': 9, '10': 'transmissionRouteId'},
    {'1': 'approved_revision_id', '3': 5, '4': 1, '5': 9, '10': 'approvedRevisionId'},
    {'1': 'provisioned_by_actor_id', '3': 6, '4': 1, '5': 9, '10': 'provisionedByActorId'},
    {'1': 'metadata_json', '3': 7, '4': 1, '5': 9, '10': 'metadataJson'},
  ],
};

/// Descriptor for `ProvisionTwinRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List provisionTwinRequestDescriptor = $convert.base64Decode(
    'ChRQcm92aXNpb25Ud2luUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SWQSGw'
    'oJbGF5b3V0X2lkGAIgASgJUghsYXlvdXRJZBIyChVlbGVjdHJpY2FsX25ldHdvcmtfaWQYAyAB'
    'KAlSE2VsZWN0cmljYWxOZXR3b3JrSWQSMgoVdHJhbnNtaXNzaW9uX3JvdXRlX2lkGAQgASgJUh'
    'N0cmFuc21pc3Npb25Sb3V0ZUlkEjAKFGFwcHJvdmVkX3JldmlzaW9uX2lkGAUgASgJUhJhcHBy'
    'b3ZlZFJldmlzaW9uSWQSNQoXcHJvdmlzaW9uZWRfYnlfYWN0b3JfaWQYBiABKAlSFHByb3Zpc2'
    'lvbmVkQnlBY3RvcklkEiMKDW1ldGFkYXRhX2pzb24YByABKAlSDG1ldGFkYXRhSnNvbg==');

@$core.Deprecated('Use provisionTwinResponseDescriptor instead')
const ProvisionTwinResponse$json = {
  '1': 'ProvisionTwinResponse',
  '2': [
    {'1': 'twin', '3': 1, '4': 1, '5': 11, '6': '.twin.v1.DigitalTwin', '10': 'twin'},
  ],
};

/// Descriptor for `ProvisionTwinResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List provisionTwinResponseDescriptor = $convert.base64Decode(
    'ChVQcm92aXNpb25Ud2luUmVzcG9uc2USKAoEdHdpbhgBIAEoCzIULnR3aW4udjEuRGlnaXRhbF'
    'R3aW5SBHR3aW4=');

@$core.Deprecated('Use getTwinStateRequestDescriptor instead')
const GetTwinStateRequest$json = {
  '1': 'GetTwinStateRequest',
  '2': [
    {'1': 'twin_id', '3': 1, '4': 1, '5': 9, '10': 'twinId'},
  ],
};

/// Descriptor for `GetTwinStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTwinStateRequestDescriptor = $convert.base64Decode(
    'ChNHZXRUd2luU3RhdGVSZXF1ZXN0EhcKB3R3aW5faWQYASABKAlSBnR3aW5JZA==');

@$core.Deprecated('Use getTwinStateResponseDescriptor instead')
const GetTwinStateResponse$json = {
  '1': 'GetTwinStateResponse',
  '2': [
    {'1': 'twin', '3': 1, '4': 1, '5': 11, '6': '.twin.v1.DigitalTwin', '10': 'twin'},
  ],
};

/// Descriptor for `GetTwinStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTwinStateResponseDescriptor = $convert.base64Decode(
    'ChRHZXRUd2luU3RhdGVSZXNwb25zZRIoCgR0d2luGAEgASgLMhQudHdpbi52MS5EaWdpdGFsVH'
    'dpblIEdHdpbg==');

@$core.Deprecated('Use updateTwinStateRequestDescriptor instead')
const UpdateTwinStateRequest$json = {
  '1': 'UpdateTwinStateRequest',
  '2': [
    {'1': 'twin_id', '3': 1, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'operational_state', '3': 2, '4': 1, '5': 11, '6': '.twin.v1.OperationalState', '10': 'operationalState'},
    {'1': 'last_telemetry_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastTelemetryAt'},
  ],
};

/// Descriptor for `UpdateTwinStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTwinStateRequestDescriptor = $convert.base64Decode(
    'ChZVcGRhdGVUd2luU3RhdGVSZXF1ZXN0EhcKB3R3aW5faWQYASABKAlSBnR3aW5JZBJGChFvcG'
    'VyYXRpb25hbF9zdGF0ZRgCIAEoCzIZLnR3aW4udjEuT3BlcmF0aW9uYWxTdGF0ZVIQb3BlcmF0'
    'aW9uYWxTdGF0ZRJGChFsYXN0X3RlbGVtZXRyeV9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSD2xhc3RUZWxlbWV0cnlBdA==');

@$core.Deprecated('Use updateTwinStateResponseDescriptor instead')
const UpdateTwinStateResponse$json = {
  '1': 'UpdateTwinStateResponse',
  '2': [
    {'1': 'twin', '3': 1, '4': 1, '5': 11, '6': '.twin.v1.DigitalTwin', '10': 'twin'},
  ],
};

/// Descriptor for `UpdateTwinStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateTwinStateResponseDescriptor = $convert.base64Decode(
    'ChdVcGRhdGVUd2luU3RhdGVSZXNwb25zZRIoCgR0d2luGAEgASgLMhQudHdpbi52MS5EaWdpdG'
    'FsVHdpblIEdHdpbg==');

@$core.Deprecated('Use deprovisionTwinRequestDescriptor instead')
const DeprovisionTwinRequest$json = {
  '1': 'DeprovisionTwinRequest',
  '2': [
    {'1': 'twin_id', '3': 1, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'actor_id', '3': 2, '4': 1, '5': 9, '10': 'actorId'},
    {'1': 'reason', '3': 3, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `DeprovisionTwinRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deprovisionTwinRequestDescriptor = $convert.base64Decode(
    'ChZEZXByb3Zpc2lvblR3aW5SZXF1ZXN0EhcKB3R3aW5faWQYASABKAlSBnR3aW5JZBIZCghhY3'
    'Rvcl9pZBgCIAEoCVIHYWN0b3JJZBIWCgZyZWFzb24YAyABKAlSBnJlYXNvbg==');

@$core.Deprecated('Use deprovisionTwinResponseDescriptor instead')
const DeprovisionTwinResponse$json = {
  '1': 'DeprovisionTwinResponse',
  '2': [
    {'1': 'twin', '3': 1, '4': 1, '5': 11, '6': '.twin.v1.DigitalTwin', '10': 'twin'},
  ],
};

/// Descriptor for `DeprovisionTwinResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deprovisionTwinResponseDescriptor = $convert.base64Decode(
    'ChdEZXByb3Zpc2lvblR3aW5SZXNwb25zZRIoCgR0d2luGAEgASgLMhQudHdpbi52MS5EaWdpdG'
    'FsVHdpblIEdHdpbg==');

@$core.Deprecated('Use listTwinsByProjectRequestDescriptor instead')
const ListTwinsByProjectRequest$json = {
  '1': 'ListTwinsByProjectRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListTwinsByProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTwinsByProjectRequestDescriptor = $convert.base64Decode(
    'ChlMaXN0VHdpbnNCeVByb2plY3RSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3'
    'RJZBIbCglwYWdlX3NpemUYAiABKAVSCHBhZ2VTaXplEh0KCnBhZ2VfdG9rZW4YAyABKAlSCXBh'
    'Z2VUb2tlbg==');

@$core.Deprecated('Use listTwinsByProjectResponseDescriptor instead')
const ListTwinsByProjectResponse$json = {
  '1': 'ListTwinsByProjectResponse',
  '2': [
    {'1': 'twins', '3': 1, '4': 3, '5': 11, '6': '.twin.v1.DigitalTwin', '10': 'twins'},
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListTwinsByProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTwinsByProjectResponseDescriptor = $convert.base64Decode(
    'ChpMaXN0VHdpbnNCeVByb2plY3RSZXNwb25zZRIqCgV0d2lucxgBIAMoCzIULnR3aW4udjEuRG'
    'lnaXRhbFR3aW5SBXR3aW5zEiYKD25leHRfcGFnZV90b2tlbhgCIAEoCVINbmV4dFBhZ2VUb2tl'
    'bhIfCgt0b3RhbF9jb3VudBgDIAEoBVIKdG90YWxDb3VudA==');

const $core.Map<$core.String, $core.dynamic> DigitalTwinServiceBase$json = {
  '1': 'DigitalTwinService',
  '2': [
    {'1': 'ProvisionTwin', '2': '.twin.v1.ProvisionTwinRequest', '3': '.twin.v1.ProvisionTwinResponse'},
    {'1': 'GetTwinState', '2': '.twin.v1.GetTwinStateRequest', '3': '.twin.v1.GetTwinStateResponse'},
    {'1': 'UpdateTwinState', '2': '.twin.v1.UpdateTwinStateRequest', '3': '.twin.v1.UpdateTwinStateResponse'},
    {'1': 'DeprovisionTwin', '2': '.twin.v1.DeprovisionTwinRequest', '3': '.twin.v1.DeprovisionTwinResponse'},
    {'1': 'ListTwinsByProject', '2': '.twin.v1.ListTwinsByProjectRequest', '3': '.twin.v1.ListTwinsByProjectResponse'},
  ],
};

@$core.Deprecated('Use digitalTwinServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> DigitalTwinServiceBase$messageJson = {
  '.twin.v1.ProvisionTwinRequest': ProvisionTwinRequest$json,
  '.twin.v1.ProvisionTwinResponse': ProvisionTwinResponse$json,
  '.twin.v1.DigitalTwin': DigitalTwin$json,
  '.twin.v1.OperationalState': OperationalState$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.twin.v1.GetTwinStateRequest': GetTwinStateRequest$json,
  '.twin.v1.GetTwinStateResponse': GetTwinStateResponse$json,
  '.twin.v1.UpdateTwinStateRequest': UpdateTwinStateRequest$json,
  '.twin.v1.UpdateTwinStateResponse': UpdateTwinStateResponse$json,
  '.twin.v1.DeprovisionTwinRequest': DeprovisionTwinRequest$json,
  '.twin.v1.DeprovisionTwinResponse': DeprovisionTwinResponse$json,
  '.twin.v1.ListTwinsByProjectRequest': ListTwinsByProjectRequest$json,
  '.twin.v1.ListTwinsByProjectResponse': ListTwinsByProjectResponse$json,
};

/// Descriptor for `DigitalTwinService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List digitalTwinServiceDescriptor = $convert.base64Decode(
    'ChJEaWdpdGFsVHdpblNlcnZpY2USTgoNUHJvdmlzaW9uVHdpbhIdLnR3aW4udjEuUHJvdmlzaW'
    '9uVHdpblJlcXVlc3QaHi50d2luLnYxLlByb3Zpc2lvblR3aW5SZXNwb25zZRJLCgxHZXRUd2lu'
    'U3RhdGUSHC50d2luLnYxLkdldFR3aW5TdGF0ZVJlcXVlc3QaHS50d2luLnYxLkdldFR3aW5TdG'
    'F0ZVJlc3BvbnNlElQKD1VwZGF0ZVR3aW5TdGF0ZRIfLnR3aW4udjEuVXBkYXRlVHdpblN0YXRl'
    'UmVxdWVzdBogLnR3aW4udjEuVXBkYXRlVHdpblN0YXRlUmVzcG9uc2USVAoPRGVwcm92aXNpb2'
    '5Ud2luEh8udHdpbi52MS5EZXByb3Zpc2lvblR3aW5SZXF1ZXN0GiAudHdpbi52MS5EZXByb3Zp'
    'c2lvblR3aW5SZXNwb25zZRJdChJMaXN0VHdpbnNCeVByb2plY3QSIi50d2luLnYxLkxpc3RUd2'
    'luc0J5UHJvamVjdFJlcXVlc3QaIy50d2luLnYxLkxpc3RUd2luc0J5UHJvamVjdFJlc3BvbnNl');

