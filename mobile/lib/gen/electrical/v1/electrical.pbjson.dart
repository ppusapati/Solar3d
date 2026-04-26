//
//  Generated code. Do not modify.
//  source: electrical/v1/electrical.proto
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

@$core.Deprecated('Use acceptanceStatusDescriptor instead')
const AcceptanceStatus$json = {
  '1': 'AcceptanceStatus',
  '2': [
    {'1': 'ACCEPTANCE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ACCEPTANCE_STATUS_DRAFT', '2': 1},
    {'1': 'ACCEPTANCE_STATUS_REVIEW_PENDING', '2': 2},
    {'1': 'ACCEPTANCE_STATUS_APPROVED', '2': 3},
    {'1': 'ACCEPTANCE_STATUS_REJECTED', '2': 4},
  ],
};

/// Descriptor for `AcceptanceStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List acceptanceStatusDescriptor = $convert.base64Decode(
    'ChBBY2NlcHRhbmNlU3RhdHVzEiEKHUFDQ0VQVEFOQ0VfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGw'
    'oXQUNDRVBUQU5DRV9TVEFUVVNfRFJBRlQQARIkCiBBQ0NFUFRBTkNFX1NUQVRVU19SRVZJRVdf'
    'UEVORElORxACEh4KGkFDQ0VQVEFOQ0VfU1RBVFVTX0FQUFJPVkVEEAMSHgoaQUNDRVBUQU5DRV'
    '9TVEFUVVNfUkVKRUNURUQQBA==');

@$core.Deprecated('Use reviewMetadataDescriptor instead')
const ReviewMetadata$json = {
  '1': 'ReviewMetadata',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.electrical.v1.AcceptanceStatus', '10': 'status'},
    {'1': 'reviewed_by_actor_id', '3': 2, '4': 1, '5': 9, '10': 'reviewedByActorId'},
    {'1': 'reviewed_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'reviewedAt'},
    {'1': 'quality_score', '3': 4, '4': 1, '5': 1, '10': 'qualityScore'},
    {'1': 'review_comments', '3': 5, '4': 3, '5': 9, '10': 'reviewComments'},
    {'1': 'blockers', '3': 6, '4': 3, '5': 9, '10': 'blockers'},
    {'1': 'approval_timestamp_unix_secs', '3': 7, '4': 1, '5': 9, '10': 'approvalTimestampUnixSecs'},
  ],
};

/// Descriptor for `ReviewMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewMetadataDescriptor = $convert.base64Decode(
    'Cg5SZXZpZXdNZXRhZGF0YRI3CgZzdGF0dXMYASABKA4yHy5lbGVjdHJpY2FsLnYxLkFjY2VwdG'
    'FuY2VTdGF0dXNSBnN0YXR1cxIvChRyZXZpZXdlZF9ieV9hY3Rvcl9pZBgCIAEoCVIRcmV2aWV3'
    'ZWRCeUFjdG9ySWQSOwoLcmV2aWV3ZWRfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgpyZXZpZXdlZEF0EiMKDXF1YWxpdHlfc2NvcmUYBCABKAFSDHF1YWxpdHlTY29yZRIn'
    'Cg9yZXZpZXdfY29tbWVudHMYBSADKAlSDnJldmlld0NvbW1lbnRzEhoKCGJsb2NrZXJzGAYgAy'
    'gJUghibG9ja2VycxI/ChxhcHByb3ZhbF90aW1lc3RhbXBfdW5peF9zZWNzGAcgASgJUhlhcHBy'
    'b3ZhbFRpbWVzdGFtcFVuaXhTZWNz');

@$core.Deprecated('Use electricalNetworkDescriptor instead')
const ElectricalNetwork$json = {
  '1': 'ElectricalNetwork',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 3, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'total_dc_capacity_kw', '3': 5, '4': 1, '5': 1, '10': 'totalDcCapacityKw'},
    {'1': 'total_ac_capacity_kw', '3': 6, '4': 1, '5': 1, '10': 'totalAcCapacityKw'},
    {'1': 'dc_ac_ratio', '3': 7, '4': 1, '5': 1, '10': 'dcAcRatio'},
    {'1': 'string_count', '3': 8, '4': 1, '5': 5, '10': 'stringCount'},
    {'1': 'inverter_count', '3': 9, '4': 1, '5': 5, '10': 'inverterCount'},
    {'1': 'created_at', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'review_metadata', '3': 11, '4': 1, '5': 11, '6': '.electrical.v1.ReviewMetadata', '10': 'reviewMetadata'},
    {'1': 'validation_violations', '3': 12, '4': 3, '5': 9, '10': 'validationViolations'},
    {'1': 'electrical_feasibility_score', '3': 13, '4': 1, '5': 1, '10': 'electricalFeasibilityScore'},
  ],
};

/// Descriptor for `ElectricalNetwork`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List electricalNetworkDescriptor = $convert.base64Decode(
    'ChFFbGVjdHJpY2FsTmV0d29yaxIOCgJpZBgBIAEoCVICaWQSHQoKcHJvamVjdF9pZBgCIAEoCV'
    'IJcHJvamVjdElkEhsKCWxheW91dF9pZBgDIAEoCVIIbGF5b3V0SWQSEgoEbmFtZRgEIAEoCVIE'
    'bmFtZRIvChR0b3RhbF9kY19jYXBhY2l0eV9rdxgFIAEoAVIRdG90YWxEY0NhcGFjaXR5S3cSLw'
    'oUdG90YWxfYWNfY2FwYWNpdHlfa3cYBiABKAFSEXRvdGFsQWNDYXBhY2l0eUt3Eh4KC2RjX2Fj'
    'X3JhdGlvGAcgASgBUglkY0FjUmF0aW8SIQoMc3RyaW5nX2NvdW50GAggASgFUgtzdHJpbmdDb3'
    'VudBIlCg5pbnZlcnRlcl9jb3VudBgJIAEoBVINaW52ZXJ0ZXJDb3VudBI5CgpjcmVhdGVkX2F0'
    'GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EkYKD3Jldmlld1'
    '9tZXRhZGF0YRgLIAEoCzIdLmVsZWN0cmljYWwudjEuUmV2aWV3TWV0YWRhdGFSDnJldmlld01l'
    'dGFkYXRhEjMKFXZhbGlkYXRpb25fdmlvbGF0aW9ucxgMIAMoCVIUdmFsaWRhdGlvblZpb2xhdG'
    'lvbnMSQAocZWxlY3RyaWNhbF9mZWFzaWJpbGl0eV9zY29yZRgNIAEoAVIaZWxlY3RyaWNhbEZl'
    'YXNpYmlsaXR5U2NvcmU=');

@$core.Deprecated('Use panelStringDescriptor instead')
const PanelString$json = {
  '1': 'PanelString',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'network_id', '3': 2, '4': 1, '5': 9, '10': 'networkId'},
    {'1': 'inverter_group_id', '3': 3, '4': 1, '5': 9, '10': 'inverterGroupId'},
    {'1': 'panel_ids', '3': 4, '4': 3, '5': 9, '10': 'panelIds'},
    {'1': 'panel_count', '3': 5, '4': 1, '5': 5, '10': 'panelCount'},
    {'1': 'string_voltage', '3': 6, '4': 1, '5': 1, '10': 'stringVoltage'},
    {'1': 'string_current', '3': 7, '4': 1, '5': 1, '10': 'stringCurrent'},
    {'1': 'string_power_w', '3': 8, '4': 1, '5': 1, '10': 'stringPowerW'},
  ],
};

/// Descriptor for `PanelString`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List panelStringDescriptor = $convert.base64Decode(
    'CgtQYW5lbFN0cmluZxIOCgJpZBgBIAEoCVICaWQSHQoKbmV0d29ya19pZBgCIAEoCVIJbmV0d2'
    '9ya0lkEioKEWludmVydGVyX2dyb3VwX2lkGAMgASgJUg9pbnZlcnRlckdyb3VwSWQSGwoJcGFu'
    'ZWxfaWRzGAQgAygJUghwYW5lbElkcxIfCgtwYW5lbF9jb3VudBgFIAEoBVIKcGFuZWxDb3VudB'
    'IlCg5zdHJpbmdfdm9sdGFnZRgGIAEoAVINc3RyaW5nVm9sdGFnZRIlCg5zdHJpbmdfY3VycmVu'
    'dBgHIAEoAVINc3RyaW5nQ3VycmVudBIkCg5zdHJpbmdfcG93ZXJfdxgIIAEoAVIMc3RyaW5nUG'
    '93ZXJX');

@$core.Deprecated('Use inverterGroupDescriptor instead')
const InverterGroup$json = {
  '1': 'InverterGroup',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'network_id', '3': 2, '4': 1, '5': 9, '10': 'networkId'},
    {'1': 'inverter_asset_id', '3': 3, '4': 1, '5': 9, '10': 'inverterAssetId'},
    {'1': 'string_ids', '3': 4, '4': 3, '5': 9, '10': 'stringIds'},
    {'1': 'dc_input_kw', '3': 5, '4': 1, '5': 1, '10': 'dcInputKw'},
    {'1': 'ac_output_kw', '3': 6, '4': 1, '5': 1, '10': 'acOutputKw'},
    {'1': 'dc_ac_ratio', '3': 7, '4': 1, '5': 1, '10': 'dcAcRatio'},
    {'1': 'position_geojson', '3': 8, '4': 1, '5': 9, '10': 'positionGeojson'},
  ],
};

/// Descriptor for `InverterGroup`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List inverterGroupDescriptor = $convert.base64Decode(
    'Cg1JbnZlcnRlckdyb3VwEg4KAmlkGAEgASgJUgJpZBIdCgpuZXR3b3JrX2lkGAIgASgJUgluZX'
    'R3b3JrSWQSKgoRaW52ZXJ0ZXJfYXNzZXRfaWQYAyABKAlSD2ludmVydGVyQXNzZXRJZBIdCgpz'
    'dHJpbmdfaWRzGAQgAygJUglzdHJpbmdJZHMSHgoLZGNfaW5wdXRfa3cYBSABKAFSCWRjSW5wdX'
    'RLdxIgCgxhY19vdXRwdXRfa3cYBiABKAFSCmFjT3V0cHV0S3cSHgoLZGNfYWNfcmF0aW8YByAB'
    'KAFSCWRjQWNSYXRpbxIpChBwb3NpdGlvbl9nZW9qc29uGAggASgJUg9wb3NpdGlvbkdlb2pzb2'
    '4=');

@$core.Deprecated('Use createNetworkRequestDescriptor instead')
const CreateNetworkRequest$json = {
  '1': 'CreateNetworkRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `CreateNetworkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createNetworkRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVOZXR3b3JrUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SWQSGw'
    'oJbGF5b3V0X2lkGAIgASgJUghsYXlvdXRJZBISCgRuYW1lGAMgASgJUgRuYW1l');

@$core.Deprecated('Use createNetworkResponseDescriptor instead')
const CreateNetworkResponse$json = {
  '1': 'CreateNetworkResponse',
  '2': [
    {'1': 'network', '3': 1, '4': 1, '5': 11, '6': '.electrical.v1.ElectricalNetwork', '10': 'network'},
  ],
};

/// Descriptor for `CreateNetworkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createNetworkResponseDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVOZXR3b3JrUmVzcG9uc2USOgoHbmV0d29yaxgBIAEoCzIgLmVsZWN0cmljYWwudj'
    'EuRWxlY3RyaWNhbE5ldHdvcmtSB25ldHdvcms=');

@$core.Deprecated('Use getNetworkRequestDescriptor instead')
const GetNetworkRequest$json = {
  '1': 'GetNetworkRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetNetworkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNetworkRequestDescriptor = $convert.base64Decode(
    'ChFHZXROZXR3b3JrUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use getNetworkResponseDescriptor instead')
const GetNetworkResponse$json = {
  '1': 'GetNetworkResponse',
  '2': [
    {'1': 'network', '3': 1, '4': 1, '5': 11, '6': '.electrical.v1.ElectricalNetwork', '10': 'network'},
  ],
};

/// Descriptor for `GetNetworkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getNetworkResponseDescriptor = $convert.base64Decode(
    'ChJHZXROZXR3b3JrUmVzcG9uc2USOgoHbmV0d29yaxgBIAEoCzIgLmVsZWN0cmljYWwudjEuRW'
    'xlY3RyaWNhbE5ldHdvcmtSB25ldHdvcms=');

@$core.Deprecated('Use listNetworksRequestDescriptor instead')
const ListNetworksRequest$json = {
  '1': 'ListNetworksRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
  ],
};

/// Descriptor for `ListNetworksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNetworksRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0TmV0d29ya3NSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZA==');

@$core.Deprecated('Use listNetworksResponseDescriptor instead')
const ListNetworksResponse$json = {
  '1': 'ListNetworksResponse',
  '2': [
    {'1': 'networks', '3': 1, '4': 3, '5': 11, '6': '.electrical.v1.ElectricalNetwork', '10': 'networks'},
  ],
};

/// Descriptor for `ListNetworksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listNetworksResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0TmV0d29ya3NSZXNwb25zZRI8CghuZXR3b3JrcxgBIAMoCzIgLmVsZWN0cmljYWwudj'
    'EuRWxlY3RyaWNhbE5ldHdvcmtSCG5ldHdvcmtz');

@$core.Deprecated('Use deleteNetworkRequestDescriptor instead')
const DeleteNetworkRequest$json = {
  '1': 'DeleteNetworkRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteNetworkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteNetworkRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVOZXR3b3JrUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use deleteNetworkResponseDescriptor instead')
const DeleteNetworkResponse$json = {
  '1': 'DeleteNetworkResponse',
};

/// Descriptor for `DeleteNetworkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteNetworkResponseDescriptor = $convert.base64Decode(
    'ChVEZWxldGVOZXR3b3JrUmVzcG9uc2U=');

@$core.Deprecated('Use submitNetworkForReviewRequestDescriptor instead')
const SubmitNetworkForReviewRequest$json = {
  '1': 'SubmitNetworkForReviewRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
    {'1': 'submission_reason', '3': 2, '4': 1, '5': 9, '10': 'submissionReason'},
    {'1': 'submitted_by_actor_id', '3': 3, '4': 1, '5': 9, '10': 'submittedByActorId'},
  ],
};

/// Descriptor for `SubmitNetworkForReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitNetworkForReviewRequestDescriptor = $convert.base64Decode(
    'Ch1TdWJtaXROZXR3b3JrRm9yUmV2aWV3UmVxdWVzdBIdCgpuZXR3b3JrX2lkGAEgASgJUgluZX'
    'R3b3JrSWQSKwoRc3VibWlzc2lvbl9yZWFzb24YAiABKAlSEHN1Ym1pc3Npb25SZWFzb24SMQoV'
    'c3VibWl0dGVkX2J5X2FjdG9yX2lkGAMgASgJUhJzdWJtaXR0ZWRCeUFjdG9ySWQ=');

@$core.Deprecated('Use submitNetworkForReviewResponseDescriptor instead')
const SubmitNetworkForReviewResponse$json = {
  '1': 'SubmitNetworkForReviewResponse',
  '2': [
    {'1': 'network', '3': 1, '4': 1, '5': 11, '6': '.electrical.v1.ElectricalNetwork', '10': 'network'},
    {'1': 'review_metadata', '3': 2, '4': 1, '5': 11, '6': '.electrical.v1.ReviewMetadata', '10': 'reviewMetadata'},
  ],
};

/// Descriptor for `SubmitNetworkForReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitNetworkForReviewResponseDescriptor = $convert.base64Decode(
    'Ch5TdWJtaXROZXR3b3JrRm9yUmV2aWV3UmVzcG9uc2USOgoHbmV0d29yaxgBIAEoCzIgLmVsZW'
    'N0cmljYWwudjEuRWxlY3RyaWNhbE5ldHdvcmtSB25ldHdvcmsSRgoPcmV2aWV3X21ldGFkYXRh'
    'GAIgASgLMh0uZWxlY3RyaWNhbC52MS5SZXZpZXdNZXRhZGF0YVIOcmV2aWV3TWV0YWRhdGE=');

@$core.Deprecated('Use approveNetworkRequestDescriptor instead')
const ApproveNetworkRequest$json = {
  '1': 'ApproveNetworkRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
    {'1': 'quality_score', '3': 2, '4': 1, '5': 1, '10': 'qualityScore'},
    {'1': 'feasibility_score', '3': 3, '4': 1, '5': 1, '10': 'feasibilityScore'},
    {'1': 'approval_comments', '3': 4, '4': 3, '5': 9, '10': 'approvalComments'},
    {'1': 'approved_by_actor_id', '3': 5, '4': 1, '5': 9, '10': 'approvedByActorId'},
  ],
};

/// Descriptor for `ApproveNetworkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveNetworkRequestDescriptor = $convert.base64Decode(
    'ChVBcHByb3ZlTmV0d29ya1JlcXVlc3QSHQoKbmV0d29ya19pZBgBIAEoCVIJbmV0d29ya0lkEi'
    'MKDXF1YWxpdHlfc2NvcmUYAiABKAFSDHF1YWxpdHlTY29yZRIrChFmZWFzaWJpbGl0eV9zY29y'
    'ZRgDIAEoAVIQZmVhc2liaWxpdHlTY29yZRIrChFhcHByb3ZhbF9jb21tZW50cxgEIAMoCVIQYX'
    'Bwcm92YWxDb21tZW50cxIvChRhcHByb3ZlZF9ieV9hY3Rvcl9pZBgFIAEoCVIRYXBwcm92ZWRC'
    'eUFjdG9ySWQ=');

@$core.Deprecated('Use approveNetworkResponseDescriptor instead')
const ApproveNetworkResponse$json = {
  '1': 'ApproveNetworkResponse',
  '2': [
    {'1': 'network', '3': 1, '4': 1, '5': 11, '6': '.electrical.v1.ElectricalNetwork', '10': 'network'},
    {'1': 'review_metadata', '3': 2, '4': 1, '5': 11, '6': '.electrical.v1.ReviewMetadata', '10': 'reviewMetadata'},
  ],
};

/// Descriptor for `ApproveNetworkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveNetworkResponseDescriptor = $convert.base64Decode(
    'ChZBcHByb3ZlTmV0d29ya1Jlc3BvbnNlEjoKB25ldHdvcmsYASABKAsyIC5lbGVjdHJpY2FsLn'
    'YxLkVsZWN0cmljYWxOZXR3b3JrUgduZXR3b3JrEkYKD3Jldmlld19tZXRhZGF0YRgCIAEoCzId'
    'LmVsZWN0cmljYWwudjEuUmV2aWV3TWV0YWRhdGFSDnJldmlld01ldGFkYXRh');

@$core.Deprecated('Use rejectNetworkRequestDescriptor instead')
const RejectNetworkRequest$json = {
  '1': 'RejectNetworkRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
    {'1': 'rejection_reasons', '3': 2, '4': 3, '5': 9, '10': 'rejectionReasons'},
    {'1': 'rejected_by_actor_id', '3': 3, '4': 1, '5': 9, '10': 'rejectedByActorId'},
  ],
};

/// Descriptor for `RejectNetworkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectNetworkRequestDescriptor = $convert.base64Decode(
    'ChRSZWplY3ROZXR3b3JrUmVxdWVzdBIdCgpuZXR3b3JrX2lkGAEgASgJUgluZXR3b3JrSWQSKw'
    'oRcmVqZWN0aW9uX3JlYXNvbnMYAiADKAlSEHJlamVjdGlvblJlYXNvbnMSLwoUcmVqZWN0ZWRf'
    'YnlfYWN0b3JfaWQYAyABKAlSEXJlamVjdGVkQnlBY3Rvcklk');

@$core.Deprecated('Use rejectNetworkResponseDescriptor instead')
const RejectNetworkResponse$json = {
  '1': 'RejectNetworkResponse',
  '2': [
    {'1': 'network', '3': 1, '4': 1, '5': 11, '6': '.electrical.v1.ElectricalNetwork', '10': 'network'},
    {'1': 'review_metadata', '3': 2, '4': 1, '5': 11, '6': '.electrical.v1.ReviewMetadata', '10': 'reviewMetadata'},
  ],
};

/// Descriptor for `RejectNetworkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectNetworkResponseDescriptor = $convert.base64Decode(
    'ChVSZWplY3ROZXR3b3JrUmVzcG9uc2USOgoHbmV0d29yaxgBIAEoCzIgLmVsZWN0cmljYWwudj'
    'EuRWxlY3RyaWNhbE5ldHdvcmtSB25ldHdvcmsSRgoPcmV2aWV3X21ldGFkYXRhGAIgASgLMh0u'
    'ZWxlY3RyaWNhbC52MS5SZXZpZXdNZXRhZGF0YVIOcmV2aWV3TWV0YWRhdGE=');

@$core.Deprecated('Use createStringRequestDescriptor instead')
const CreateStringRequest$json = {
  '1': 'CreateStringRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
    {'1': 'panel_ids', '3': 2, '4': 3, '5': 9, '10': 'panelIds'},
    {'1': 'inverter_group_id', '3': 3, '4': 1, '5': 9, '10': 'inverterGroupId'},
    {'1': 'panel_voltage', '3': 4, '4': 1, '5': 1, '10': 'panelVoltage'},
    {'1': 'panel_current', '3': 5, '4': 1, '5': 1, '10': 'panelCurrent'},
  ],
};

/// Descriptor for `CreateStringRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createStringRequestDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVTdHJpbmdSZXF1ZXN0Eh0KCm5ldHdvcmtfaWQYASABKAlSCW5ldHdvcmtJZBIbCg'
    'lwYW5lbF9pZHMYAiADKAlSCHBhbmVsSWRzEioKEWludmVydGVyX2dyb3VwX2lkGAMgASgJUg9p'
    'bnZlcnRlckdyb3VwSWQSIwoNcGFuZWxfdm9sdGFnZRgEIAEoAVIMcGFuZWxWb2x0YWdlEiMKDX'
    'BhbmVsX2N1cnJlbnQYBSABKAFSDHBhbmVsQ3VycmVudA==');

@$core.Deprecated('Use createStringResponseDescriptor instead')
const CreateStringResponse$json = {
  '1': 'CreateStringResponse',
  '2': [
    {'1': 'panel_string', '3': 1, '4': 1, '5': 11, '6': '.electrical.v1.PanelString', '10': 'panelString'},
  ],
};

/// Descriptor for `CreateStringResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createStringResponseDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVTdHJpbmdSZXNwb25zZRI9CgxwYW5lbF9zdHJpbmcYASABKAsyGi5lbGVjdHJpY2'
    'FsLnYxLlBhbmVsU3RyaW5nUgtwYW5lbFN0cmluZw==');

@$core.Deprecated('Use autoGenerateStringsRequestDescriptor instead')
const AutoGenerateStringsRequest$json = {
  '1': 'AutoGenerateStringsRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'panels_per_string', '3': 3, '4': 1, '5': 5, '10': 'panelsPerString'},
    {'1': 'inverter_asset_id', '3': 4, '4': 1, '5': 9, '10': 'inverterAssetId'},
    {'1': 'strings_per_inverter', '3': 5, '4': 1, '5': 5, '10': 'stringsPerInverter'},
    {'1': 'total_panels', '3': 6, '4': 1, '5': 5, '10': 'totalPanels'},
    {'1': 'panel_voltage', '3': 7, '4': 1, '5': 1, '10': 'panelVoltage'},
    {'1': 'panel_current', '3': 8, '4': 1, '5': 1, '10': 'panelCurrent'},
    {'1': 'panel_power_w', '3': 9, '4': 1, '5': 1, '10': 'panelPowerW'},
    {'1': 'inverter_ac_kw', '3': 10, '4': 1, '5': 1, '10': 'inverterAcKw'},
  ],
};

/// Descriptor for `AutoGenerateStringsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List autoGenerateStringsRequestDescriptor = $convert.base64Decode(
    'ChpBdXRvR2VuZXJhdGVTdHJpbmdzUmVxdWVzdBIdCgpuZXR3b3JrX2lkGAEgASgJUgluZXR3b3'
    'JrSWQSGwoJbGF5b3V0X2lkGAIgASgJUghsYXlvdXRJZBIqChFwYW5lbHNfcGVyX3N0cmluZxgD'
    'IAEoBVIPcGFuZWxzUGVyU3RyaW5nEioKEWludmVydGVyX2Fzc2V0X2lkGAQgASgJUg9pbnZlcn'
    'RlckFzc2V0SWQSMAoUc3RyaW5nc19wZXJfaW52ZXJ0ZXIYBSABKAVSEnN0cmluZ3NQZXJJbnZl'
    'cnRlchIhCgx0b3RhbF9wYW5lbHMYBiABKAVSC3RvdGFsUGFuZWxzEiMKDXBhbmVsX3ZvbHRhZ2'
    'UYByABKAFSDHBhbmVsVm9sdGFnZRIjCg1wYW5lbF9jdXJyZW50GAggASgBUgxwYW5lbEN1cnJl'
    'bnQSIgoNcGFuZWxfcG93ZXJfdxgJIAEoAVILcGFuZWxQb3dlclcSJAoOaW52ZXJ0ZXJfYWNfa3'
    'cYCiABKAFSDGludmVydGVyQWNLdw==');

@$core.Deprecated('Use autoGenerateStringsResponseDescriptor instead')
const AutoGenerateStringsResponse$json = {
  '1': 'AutoGenerateStringsResponse',
  '2': [
    {'1': 'strings_created', '3': 1, '4': 1, '5': 5, '10': 'stringsCreated'},
    {'1': 'inverter_groups_created', '3': 2, '4': 1, '5': 5, '10': 'inverterGroupsCreated'},
    {'1': 'total_dc_kw', '3': 3, '4': 1, '5': 1, '10': 'totalDcKw'},
    {'1': 'total_ac_kw', '3': 4, '4': 1, '5': 1, '10': 'totalAcKw'},
    {'1': 'network', '3': 5, '4': 1, '5': 11, '6': '.electrical.v1.ElectricalNetwork', '10': 'network'},
  ],
};

/// Descriptor for `AutoGenerateStringsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List autoGenerateStringsResponseDescriptor = $convert.base64Decode(
    'ChtBdXRvR2VuZXJhdGVTdHJpbmdzUmVzcG9uc2USJwoPc3RyaW5nc19jcmVhdGVkGAEgASgFUg'
    '5zdHJpbmdzQ3JlYXRlZBI2ChdpbnZlcnRlcl9ncm91cHNfY3JlYXRlZBgCIAEoBVIVaW52ZXJ0'
    'ZXJHcm91cHNDcmVhdGVkEh4KC3RvdGFsX2RjX2t3GAMgASgBUgl0b3RhbERjS3cSHgoLdG90YW'
    'xfYWNfa3cYBCABKAFSCXRvdGFsQWNLdxI6CgduZXR3b3JrGAUgASgLMiAuZWxlY3RyaWNhbC52'
    'MS5FbGVjdHJpY2FsTmV0d29ya1IHbmV0d29yaw==');

@$core.Deprecated('Use listStringsRequestDescriptor instead')
const ListStringsRequest$json = {
  '1': 'ListStringsRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
  ],
};

/// Descriptor for `ListStringsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStringsRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0U3RyaW5nc1JlcXVlc3QSHQoKbmV0d29ya19pZBgBIAEoCVIJbmV0d29ya0lk');

@$core.Deprecated('Use listStringsResponseDescriptor instead')
const ListStringsResponse$json = {
  '1': 'ListStringsResponse',
  '2': [
    {'1': 'strings', '3': 1, '4': 3, '5': 11, '6': '.electrical.v1.PanelString', '10': 'strings'},
  ],
};

/// Descriptor for `ListStringsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStringsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0U3RyaW5nc1Jlc3BvbnNlEjQKB3N0cmluZ3MYASADKAsyGi5lbGVjdHJpY2FsLnYxLl'
    'BhbmVsU3RyaW5nUgdzdHJpbmdz');

@$core.Deprecated('Use assignInverterRequestDescriptor instead')
const AssignInverterRequest$json = {
  '1': 'AssignInverterRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
    {'1': 'inverter_asset_id', '3': 2, '4': 1, '5': 9, '10': 'inverterAssetId'},
    {'1': 'string_ids', '3': 3, '4': 3, '5': 9, '10': 'stringIds'},
    {'1': 'position_geojson', '3': 4, '4': 1, '5': 9, '10': 'positionGeojson'},
  ],
};

/// Descriptor for `AssignInverterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignInverterRequestDescriptor = $convert.base64Decode(
    'ChVBc3NpZ25JbnZlcnRlclJlcXVlc3QSHQoKbmV0d29ya19pZBgBIAEoCVIJbmV0d29ya0lkEi'
    'oKEWludmVydGVyX2Fzc2V0X2lkGAIgASgJUg9pbnZlcnRlckFzc2V0SWQSHQoKc3RyaW5nX2lk'
    'cxgDIAMoCVIJc3RyaW5nSWRzEikKEHBvc2l0aW9uX2dlb2pzb24YBCABKAlSD3Bvc2l0aW9uR2'
    'VvanNvbg==');

@$core.Deprecated('Use assignInverterResponseDescriptor instead')
const AssignInverterResponse$json = {
  '1': 'AssignInverterResponse',
  '2': [
    {'1': 'inverter_group', '3': 1, '4': 1, '5': 11, '6': '.electrical.v1.InverterGroup', '10': 'inverterGroup'},
  ],
};

/// Descriptor for `AssignInverterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List assignInverterResponseDescriptor = $convert.base64Decode(
    'ChZBc3NpZ25JbnZlcnRlclJlc3BvbnNlEkMKDmludmVydGVyX2dyb3VwGAEgASgLMhwuZWxlY3'
    'RyaWNhbC52MS5JbnZlcnRlckdyb3VwUg1pbnZlcnRlckdyb3Vw');

@$core.Deprecated('Use listInverterGroupsRequestDescriptor instead')
const ListInverterGroupsRequest$json = {
  '1': 'ListInverterGroupsRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
  ],
};

/// Descriptor for `ListInverterGroupsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInverterGroupsRequestDescriptor = $convert.base64Decode(
    'ChlMaXN0SW52ZXJ0ZXJHcm91cHNSZXF1ZXN0Eh0KCm5ldHdvcmtfaWQYASABKAlSCW5ldHdvcm'
    'tJZA==');

@$core.Deprecated('Use listInverterGroupsResponseDescriptor instead')
const ListInverterGroupsResponse$json = {
  '1': 'ListInverterGroupsResponse',
  '2': [
    {'1': 'inverter_groups', '3': 1, '4': 3, '5': 11, '6': '.electrical.v1.InverterGroup', '10': 'inverterGroups'},
  ],
};

/// Descriptor for `ListInverterGroupsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listInverterGroupsResponseDescriptor = $convert.base64Decode(
    'ChpMaXN0SW52ZXJ0ZXJHcm91cHNSZXNwb25zZRJFCg9pbnZlcnRlcl9ncm91cHMYASADKAsyHC'
    '5lbGVjdHJpY2FsLnYxLkludmVydGVyR3JvdXBSDmludmVydGVyR3JvdXBz');

@$core.Deprecated('Use calculateDCCapacityRequestDescriptor instead')
const CalculateDCCapacityRequest$json = {
  '1': 'CalculateDCCapacityRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
  ],
};

/// Descriptor for `CalculateDCCapacityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateDCCapacityRequestDescriptor = $convert.base64Decode(
    'ChpDYWxjdWxhdGVEQ0NhcGFjaXR5UmVxdWVzdBIdCgpuZXR3b3JrX2lkGAEgASgJUgluZXR3b3'
    'JrSWQ=');

@$core.Deprecated('Use calculateDCCapacityResponseDescriptor instead')
const CalculateDCCapacityResponse$json = {
  '1': 'CalculateDCCapacityResponse',
  '2': [
    {'1': 'total_dc_kw', '3': 1, '4': 1, '5': 1, '10': 'totalDcKw'},
    {'1': 'total_panels', '3': 2, '4': 1, '5': 5, '10': 'totalPanels'},
    {'1': 'total_strings', '3': 3, '4': 1, '5': 5, '10': 'totalStrings'},
  ],
};

/// Descriptor for `CalculateDCCapacityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateDCCapacityResponseDescriptor = $convert.base64Decode(
    'ChtDYWxjdWxhdGVEQ0NhcGFjaXR5UmVzcG9uc2USHgoLdG90YWxfZGNfa3cYASABKAFSCXRvdG'
    'FsRGNLdxIhCgx0b3RhbF9wYW5lbHMYAiABKAVSC3RvdGFsUGFuZWxzEiMKDXRvdGFsX3N0cmlu'
    'Z3MYAyABKAVSDHRvdGFsU3RyaW5ncw==');

@$core.Deprecated('Use calculateACCapacityRequestDescriptor instead')
const CalculateACCapacityRequest$json = {
  '1': 'CalculateACCapacityRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
  ],
};

/// Descriptor for `CalculateACCapacityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateACCapacityRequestDescriptor = $convert.base64Decode(
    'ChpDYWxjdWxhdGVBQ0NhcGFjaXR5UmVxdWVzdBIdCgpuZXR3b3JrX2lkGAEgASgJUgluZXR3b3'
    'JrSWQ=');

@$core.Deprecated('Use calculateACCapacityResponseDescriptor instead')
const CalculateACCapacityResponse$json = {
  '1': 'CalculateACCapacityResponse',
  '2': [
    {'1': 'total_ac_kw', '3': 1, '4': 1, '5': 1, '10': 'totalAcKw'},
    {'1': 'dc_ac_ratio', '3': 2, '4': 1, '5': 1, '10': 'dcAcRatio'},
    {'1': 'total_inverters', '3': 3, '4': 1, '5': 5, '10': 'totalInverters'},
  ],
};

/// Descriptor for `CalculateACCapacityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateACCapacityResponseDescriptor = $convert.base64Decode(
    'ChtDYWxjdWxhdGVBQ0NhcGFjaXR5UmVzcG9uc2USHgoLdG90YWxfYWNfa3cYASABKAFSCXRvdG'
    'FsQWNLdxIeCgtkY19hY19yYXRpbxgCIAEoAVIJZGNBY1JhdGlvEicKD3RvdGFsX2ludmVydGVy'
    'cxgDIAEoBVIOdG90YWxJbnZlcnRlcnM=');

@$core.Deprecated('Use calculateLossesRequestDescriptor instead')
const CalculateLossesRequest$json = {
  '1': 'CalculateLossesRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
  ],
};

/// Descriptor for `CalculateLossesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateLossesRequestDescriptor = $convert.base64Decode(
    'ChZDYWxjdWxhdGVMb3NzZXNSZXF1ZXN0Eh0KCm5ldHdvcmtfaWQYASABKAlSCW5ldHdvcmtJZA'
    '==');

@$core.Deprecated('Use calculateLossesResponseDescriptor instead')
const CalculateLossesResponse$json = {
  '1': 'CalculateLossesResponse',
  '2': [
    {'1': 'dc_cable_loss_percent', '3': 1, '4': 1, '5': 1, '10': 'dcCableLossPercent'},
    {'1': 'ac_cable_loss_percent', '3': 2, '4': 1, '5': 1, '10': 'acCableLossPercent'},
    {'1': 'inverter_loss_percent', '3': 3, '4': 1, '5': 1, '10': 'inverterLossPercent'},
    {'1': 'transformer_loss_percent', '3': 4, '4': 1, '5': 1, '10': 'transformerLossPercent'},
    {'1': 'total_loss_percent', '3': 5, '4': 1, '5': 1, '10': 'totalLossPercent'},
  ],
};

/// Descriptor for `CalculateLossesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateLossesResponseDescriptor = $convert.base64Decode(
    'ChdDYWxjdWxhdGVMb3NzZXNSZXNwb25zZRIxChVkY19jYWJsZV9sb3NzX3BlcmNlbnQYASABKA'
    'FSEmRjQ2FibGVMb3NzUGVyY2VudBIxChVhY19jYWJsZV9sb3NzX3BlcmNlbnQYAiABKAFSEmFj'
    'Q2FibGVMb3NzUGVyY2VudBIyChVpbnZlcnRlcl9sb3NzX3BlcmNlbnQYAyABKAFSE2ludmVydG'
    'VyTG9zc1BlcmNlbnQSOAoYdHJhbnNmb3JtZXJfbG9zc19wZXJjZW50GAQgASgBUhZ0cmFuc2Zv'
    'cm1lckxvc3NQZXJjZW50EiwKEnRvdGFsX2xvc3NfcGVyY2VudBgFIAEoAVIQdG90YWxMb3NzUG'
    'VyY2VudA==');

@$core.Deprecated('Use validateSizingRequestDescriptor instead')
const ValidateSizingRequest$json = {
  '1': 'ValidateSizingRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
    {'1': 'panel_voc_v', '3': 2, '4': 1, '5': 1, '10': 'panelVocV'},
    {'1': 'panel_vmp_v', '3': 3, '4': 1, '5': 1, '10': 'panelVmpV'},
    {'1': 'panel_isc_a', '3': 4, '4': 1, '5': 1, '10': 'panelIscA'},
    {'1': 'panel_imp_a', '3': 5, '4': 1, '5': 1, '10': 'panelImpA'},
    {'1': 'panels_per_string', '3': 6, '4': 1, '5': 5, '10': 'panelsPerString'},
    {'1': 'inverter_vdc_max_v', '3': 7, '4': 1, '5': 1, '10': 'inverterVdcMaxV'},
    {'1': 'inverter_vmppt_min_v', '3': 8, '4': 1, '5': 1, '10': 'inverterVmpptMinV'},
    {'1': 'inverter_vmppt_max_v', '3': 9, '4': 1, '5': 1, '10': 'inverterVmpptMaxV'},
    {'1': 'inverter_idc_max_a', '3': 10, '4': 1, '5': 1, '10': 'inverterIdcMaxA'},
    {'1': 'inverter_ac_kw', '3': 11, '4': 1, '5': 1, '10': 'inverterAcKw'},
    {'1': 'dc_ac_ratio_min', '3': 12, '4': 1, '5': 1, '10': 'dcAcRatioMin'},
    {'1': 'dc_ac_ratio_max', '3': 13, '4': 1, '5': 1, '10': 'dcAcRatioMax'},
    {'1': 'temp_coeff_voc_pct_per_c', '3': 14, '4': 1, '5': 1, '10': 'tempCoeffVocPctPerC'},
    {'1': 'lowest_expected_temp_c', '3': 15, '4': 1, '5': 1, '10': 'lowestExpectedTempC'},
    {'1': 'highest_expected_temp_c', '3': 16, '4': 1, '5': 1, '10': 'highestExpectedTempC'},
  ],
};

/// Descriptor for `ValidateSizingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateSizingRequestDescriptor = $convert.base64Decode(
    'ChVWYWxpZGF0ZVNpemluZ1JlcXVlc3QSHQoKbmV0d29ya19pZBgBIAEoCVIJbmV0d29ya0lkEh'
    '4KC3BhbmVsX3ZvY192GAIgASgBUglwYW5lbFZvY1YSHgoLcGFuZWxfdm1wX3YYAyABKAFSCXBh'
    'bmVsVm1wVhIeCgtwYW5lbF9pc2NfYRgEIAEoAVIJcGFuZWxJc2NBEh4KC3BhbmVsX2ltcF9hGA'
    'UgASgBUglwYW5lbEltcEESKgoRcGFuZWxzX3Blcl9zdHJpbmcYBiABKAVSD3BhbmVsc1BlclN0'
    'cmluZxIrChJpbnZlcnRlcl92ZGNfbWF4X3YYByABKAFSD2ludmVydGVyVmRjTWF4VhIvChRpbn'
    'ZlcnRlcl92bXBwdF9taW5fdhgIIAEoAVIRaW52ZXJ0ZXJWbXBwdE1pblYSLwoUaW52ZXJ0ZXJf'
    'dm1wcHRfbWF4X3YYCSABKAFSEWludmVydGVyVm1wcHRNYXhWEisKEmludmVydGVyX2lkY19tYX'
    'hfYRgKIAEoAVIPaW52ZXJ0ZXJJZGNNYXhBEiQKDmludmVydGVyX2FjX2t3GAsgASgBUgxpbnZl'
    'cnRlckFjS3cSJQoPZGNfYWNfcmF0aW9fbWluGAwgASgBUgxkY0FjUmF0aW9NaW4SJQoPZGNfYW'
    'NfcmF0aW9fbWF4GA0gASgBUgxkY0FjUmF0aW9NYXgSNQoYdGVtcF9jb2VmZl92b2NfcGN0X3Bl'
    'cl9jGA4gASgBUhN0ZW1wQ29lZmZWb2NQY3RQZXJDEjMKFmxvd2VzdF9leHBlY3RlZF90ZW1wX2'
    'MYDyABKAFSE2xvd2VzdEV4cGVjdGVkVGVtcEMSNQoXaGlnaGVzdF9leHBlY3RlZF90ZW1wX2MY'
    'ECABKAFSFGhpZ2hlc3RFeHBlY3RlZFRlbXBD');

@$core.Deprecated('Use sizingViolationDescriptor instead')
const SizingViolation$json = {
  '1': 'SizingViolation',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'limit', '3': 3, '4': 1, '5': 1, '10': 'limit'},
    {'1': 'actual', '3': 4, '4': 1, '5': 1, '10': 'actual'},
  ],
};

/// Descriptor for `SizingViolation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sizingViolationDescriptor = $convert.base64Decode(
    'Cg9TaXppbmdWaW9sYXRpb24SEgoEY29kZRgBIAEoCVIEY29kZRIYCgdtZXNzYWdlGAIgASgJUg'
    'dtZXNzYWdlEhQKBWxpbWl0GAMgASgBUgVsaW1pdBIWCgZhY3R1YWwYBCABKAFSBmFjdHVhbA==');

@$core.Deprecated('Use validateSizingResponseDescriptor instead')
const ValidateSizingResponse$json = {
  '1': 'ValidateSizingResponse',
  '2': [
    {'1': 'valid', '3': 1, '4': 1, '5': 8, '10': 'valid'},
    {'1': 'violations', '3': 2, '4': 3, '5': 11, '6': '.electrical.v1.SizingViolation', '10': 'violations'},
    {'1': 'string_voc_cold_v', '3': 3, '4': 1, '5': 1, '10': 'stringVocColdV'},
    {'1': 'string_vmp_hot_v', '3': 4, '4': 1, '5': 1, '10': 'stringVmpHotV'},
    {'1': 'dc_string_power_kw', '3': 5, '4': 1, '5': 1, '10': 'dcStringPowerKw'},
    {'1': 'dc_ac_ratio', '3': 6, '4': 1, '5': 1, '10': 'dcAcRatio'},
    {'1': 'max_panels_per_string', '3': 7, '4': 1, '5': 5, '10': 'maxPanelsPerString'},
    {'1': 'min_panels_per_string', '3': 8, '4': 1, '5': 5, '10': 'minPanelsPerString'},
  ],
};

/// Descriptor for `ValidateSizingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateSizingResponseDescriptor = $convert.base64Decode(
    'ChZWYWxpZGF0ZVNpemluZ1Jlc3BvbnNlEhQKBXZhbGlkGAEgASgIUgV2YWxpZBI+Cgp2aW9sYX'
    'Rpb25zGAIgAygLMh4uZWxlY3RyaWNhbC52MS5TaXppbmdWaW9sYXRpb25SCnZpb2xhdGlvbnMS'
    'KQoRc3RyaW5nX3ZvY19jb2xkX3YYAyABKAFSDnN0cmluZ1ZvY0NvbGRWEicKEHN0cmluZ192bX'
    'BfaG90X3YYBCABKAFSDXN0cmluZ1ZtcEhvdFYSKwoSZGNfc3RyaW5nX3Bvd2VyX2t3GAUgASgB'
    'Ug9kY1N0cmluZ1Bvd2VyS3cSHgoLZGNfYWNfcmF0aW8YBiABKAFSCWRjQWNSYXRpbxIxChVtYX'
    'hfcGFuZWxzX3Blcl9zdHJpbmcYByABKAVSEm1heFBhbmVsc1BlclN0cmluZxIxChVtaW5fcGFu'
    'ZWxzX3Blcl9zdHJpbmcYCCABKAVSEm1pblBhbmVsc1BlclN0cmluZw==');

@$core.Deprecated('Use validateNetworkRequestDescriptor instead')
const ValidateNetworkRequest$json = {
  '1': 'ValidateNetworkRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
    {'1': 'inverter_mppt_count', '3': 2, '4': 1, '5': 5, '10': 'inverterMpptCount'},
    {'1': 'max_strings_per_mppt', '3': 3, '4': 1, '5': 5, '10': 'maxStringsPerMppt'},
  ],
};

/// Descriptor for `ValidateNetworkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateNetworkRequestDescriptor = $convert.base64Decode(
    'ChZWYWxpZGF0ZU5ldHdvcmtSZXF1ZXN0Eh0KCm5ldHdvcmtfaWQYASABKAlSCW5ldHdvcmtJZB'
    'IuChNpbnZlcnRlcl9tcHB0X2NvdW50GAIgASgFUhFpbnZlcnRlck1wcHRDb3VudBIvChRtYXhf'
    'c3RyaW5nc19wZXJfbXBwdBgDIAEoBVIRbWF4U3RyaW5nc1Blck1wcHQ=');

@$core.Deprecated('Use networkTopologyIssueDescriptor instead')
const NetworkTopologyIssue$json = {
  '1': 'NetworkTopologyIssue',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'entity_id', '3': 3, '4': 1, '5': 9, '10': 'entityId'},
  ],
};

/// Descriptor for `NetworkTopologyIssue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List networkTopologyIssueDescriptor = $convert.base64Decode(
    'ChROZXR3b3JrVG9wb2xvZ3lJc3N1ZRISCgRjb2RlGAEgASgJUgRjb2RlEhgKB21lc3NhZ2UYAi'
    'ABKAlSB21lc3NhZ2USGwoJZW50aXR5X2lkGAMgASgJUghlbnRpdHlJZA==');

@$core.Deprecated('Use validateNetworkResponseDescriptor instead')
const ValidateNetworkResponse$json = {
  '1': 'ValidateNetworkResponse',
  '2': [
    {'1': 'valid', '3': 1, '4': 1, '5': 8, '10': 'valid'},
    {'1': 'issues', '3': 2, '4': 3, '5': 11, '6': '.electrical.v1.NetworkTopologyIssue', '10': 'issues'},
    {'1': 'total_strings', '3': 3, '4': 1, '5': 5, '10': 'totalStrings'},
    {'1': 'assigned_strings', '3': 4, '4': 1, '5': 5, '10': 'assignedStrings'},
    {'1': 'unassigned_strings', '3': 5, '4': 1, '5': 5, '10': 'unassignedStrings'},
    {'1': 'total_panels', '3': 6, '4': 1, '5': 5, '10': 'totalPanels'},
    {'1': 'duplicate_panel_refs', '3': 7, '4': 1, '5': 5, '10': 'duplicatePanelRefs'},
    {'1': 'total_dc_kw', '3': 8, '4': 1, '5': 1, '10': 'totalDcKw'},
    {'1': 'total_ac_kw', '3': 9, '4': 1, '5': 1, '10': 'totalAcKw'},
    {'1': 'dc_ac_ratio', '3': 10, '4': 1, '5': 1, '10': 'dcAcRatio'},
  ],
};

/// Descriptor for `ValidateNetworkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateNetworkResponseDescriptor = $convert.base64Decode(
    'ChdWYWxpZGF0ZU5ldHdvcmtSZXNwb25zZRIUCgV2YWxpZBgBIAEoCFIFdmFsaWQSOwoGaXNzdW'
    'VzGAIgAygLMiMuZWxlY3RyaWNhbC52MS5OZXR3b3JrVG9wb2xvZ3lJc3N1ZVIGaXNzdWVzEiMK'
    'DXRvdGFsX3N0cmluZ3MYAyABKAVSDHRvdGFsU3RyaW5ncxIpChBhc3NpZ25lZF9zdHJpbmdzGA'
    'QgASgFUg9hc3NpZ25lZFN0cmluZ3MSLQoSdW5hc3NpZ25lZF9zdHJpbmdzGAUgASgFUhF1bmFz'
    'c2lnbmVkU3RyaW5ncxIhCgx0b3RhbF9wYW5lbHMYBiABKAVSC3RvdGFsUGFuZWxzEjAKFGR1cG'
    'xpY2F0ZV9wYW5lbF9yZWZzGAcgASgFUhJkdXBsaWNhdGVQYW5lbFJlZnMSHgoLdG90YWxfZGNf'
    'a3cYCCABKAFSCXRvdGFsRGNLdxIeCgt0b3RhbF9hY19rdxgJIAEoAVIJdG90YWxBY0t3Eh4KC2'
    'RjX2FjX3JhdGlvGAogASgBUglkY0FjUmF0aW8=');

@$core.Deprecated('Use generateNetworkBOMRequestDescriptor instead')
const GenerateNetworkBOMRequest$json = {
  '1': 'GenerateNetworkBOMRequest',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
    {'1': 'panel_unit_cost', '3': 2, '4': 1, '5': 1, '10': 'panelUnitCost'},
    {'1': 'inverter_unit_cost', '3': 3, '4': 1, '5': 1, '10': 'inverterUnitCost'},
    {'1': 'cable_cost_per_m', '3': 4, '4': 1, '5': 1, '10': 'cableCostPerM'},
    {'1': 'mounting_cost_per_panel', '3': 5, '4': 1, '5': 1, '10': 'mountingCostPerPanel'},
    {'1': 'currency_code', '3': 6, '4': 1, '5': 9, '10': 'currencyCode'},
  ],
};

/// Descriptor for `GenerateNetworkBOMRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateNetworkBOMRequestDescriptor = $convert.base64Decode(
    'ChlHZW5lcmF0ZU5ldHdvcmtCT01SZXF1ZXN0Eh0KCm5ldHdvcmtfaWQYASABKAlSCW5ldHdvcm'
    'tJZBImCg9wYW5lbF91bml0X2Nvc3QYAiABKAFSDXBhbmVsVW5pdENvc3QSLAoSaW52ZXJ0ZXJf'
    'dW5pdF9jb3N0GAMgASgBUhBpbnZlcnRlclVuaXRDb3N0EicKEGNhYmxlX2Nvc3RfcGVyX20YBC'
    'ABKAFSDWNhYmxlQ29zdFBlck0SNQoXbW91bnRpbmdfY29zdF9wZXJfcGFuZWwYBSABKAFSFG1v'
    'dW50aW5nQ29zdFBlclBhbmVsEiMKDWN1cnJlbmN5X2NvZGUYBiABKAlSDGN1cnJlbmN5Q29kZQ'
    '==');

@$core.Deprecated('Use networkBOMItemDescriptor instead')
const NetworkBOMItem$json = {
  '1': 'NetworkBOMItem',
  '2': [
    {'1': 'category', '3': 1, '4': 1, '5': 9, '10': 'category'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'quantity', '3': 3, '4': 1, '5': 5, '10': 'quantity'},
    {'1': 'unit', '3': 4, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'unit_cost', '3': 5, '4': 1, '5': 1, '10': 'unitCost'},
    {'1': 'total_cost', '3': 6, '4': 1, '5': 1, '10': 'totalCost'},
  ],
};

/// Descriptor for `NetworkBOMItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List networkBOMItemDescriptor = $convert.base64Decode(
    'Cg5OZXR3b3JrQk9NSXRlbRIaCghjYXRlZ29yeRgBIAEoCVIIY2F0ZWdvcnkSEgoEbmFtZRgCIA'
    'EoCVIEbmFtZRIaCghxdWFudGl0eRgDIAEoBVIIcXVhbnRpdHkSEgoEdW5pdBgEIAEoCVIEdW5p'
    'dBIbCgl1bml0X2Nvc3QYBSABKAFSCHVuaXRDb3N0Eh0KCnRvdGFsX2Nvc3QYBiABKAFSCXRvdG'
    'FsQ29zdA==');

@$core.Deprecated('Use generateNetworkBOMResponseDescriptor instead')
const GenerateNetworkBOMResponse$json = {
  '1': 'GenerateNetworkBOMResponse',
  '2': [
    {'1': 'network_id', '3': 1, '4': 1, '5': 9, '10': 'networkId'},
    {'1': 'panel_count', '3': 2, '4': 1, '5': 5, '10': 'panelCount'},
    {'1': 'string_count', '3': 3, '4': 1, '5': 5, '10': 'stringCount'},
    {'1': 'inverter_group_count', '3': 4, '4': 1, '5': 5, '10': 'inverterGroupCount'},
    {'1': 'total_dc_kw', '3': 5, '4': 1, '5': 1, '10': 'totalDcKw'},
    {'1': 'total_ac_kw', '3': 6, '4': 1, '5': 1, '10': 'totalAcKw'},
    {'1': 'items', '3': 7, '4': 3, '5': 11, '6': '.electrical.v1.NetworkBOMItem', '10': 'items'},
    {'1': 'total_cost', '3': 8, '4': 1, '5': 1, '10': 'totalCost'},
    {'1': 'currency_code', '3': 9, '4': 1, '5': 9, '10': 'currencyCode'},
  ],
};

/// Descriptor for `GenerateNetworkBOMResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateNetworkBOMResponseDescriptor = $convert.base64Decode(
    'ChpHZW5lcmF0ZU5ldHdvcmtCT01SZXNwb25zZRIdCgpuZXR3b3JrX2lkGAEgASgJUgluZXR3b3'
    'JrSWQSHwoLcGFuZWxfY291bnQYAiABKAVSCnBhbmVsQ291bnQSIQoMc3RyaW5nX2NvdW50GAMg'
    'ASgFUgtzdHJpbmdDb3VudBIwChRpbnZlcnRlcl9ncm91cF9jb3VudBgEIAEoBVISaW52ZXJ0ZX'
    'JHcm91cENvdW50Eh4KC3RvdGFsX2RjX2t3GAUgASgBUgl0b3RhbERjS3cSHgoLdG90YWxfYWNf'
    'a3cYBiABKAFSCXRvdGFsQWNLdxIzCgVpdGVtcxgHIAMoCzIdLmVsZWN0cmljYWwudjEuTmV0d2'
    '9ya0JPTUl0ZW1SBWl0ZW1zEh0KCnRvdGFsX2Nvc3QYCCABKAFSCXRvdGFsQ29zdBIjCg1jdXJy'
    'ZW5jeV9jb2RlGAkgASgJUgxjdXJyZW5jeUNvZGU=');

const $core.Map<$core.String, $core.dynamic> ElectricalServiceBase$json = {
  '1': 'ElectricalService',
  '2': [
    {'1': 'CreateNetwork', '2': '.electrical.v1.CreateNetworkRequest', '3': '.electrical.v1.CreateNetworkResponse'},
    {'1': 'GetNetwork', '2': '.electrical.v1.GetNetworkRequest', '3': '.electrical.v1.GetNetworkResponse'},
    {'1': 'ListNetworks', '2': '.electrical.v1.ListNetworksRequest', '3': '.electrical.v1.ListNetworksResponse'},
    {'1': 'DeleteNetwork', '2': '.electrical.v1.DeleteNetworkRequest', '3': '.electrical.v1.DeleteNetworkResponse'},
    {'1': 'CreateString', '2': '.electrical.v1.CreateStringRequest', '3': '.electrical.v1.CreateStringResponse'},
    {'1': 'AutoGenerateStrings', '2': '.electrical.v1.AutoGenerateStringsRequest', '3': '.electrical.v1.AutoGenerateStringsResponse'},
    {'1': 'ListStrings', '2': '.electrical.v1.ListStringsRequest', '3': '.electrical.v1.ListStringsResponse'},
    {'1': 'AssignInverter', '2': '.electrical.v1.AssignInverterRequest', '3': '.electrical.v1.AssignInverterResponse'},
    {'1': 'ListInverterGroups', '2': '.electrical.v1.ListInverterGroupsRequest', '3': '.electrical.v1.ListInverterGroupsResponse'},
    {'1': 'CalculateDCCapacity', '2': '.electrical.v1.CalculateDCCapacityRequest', '3': '.electrical.v1.CalculateDCCapacityResponse'},
    {'1': 'CalculateACCapacity', '2': '.electrical.v1.CalculateACCapacityRequest', '3': '.electrical.v1.CalculateACCapacityResponse'},
    {'1': 'CalculateLosses', '2': '.electrical.v1.CalculateLossesRequest', '3': '.electrical.v1.CalculateLossesResponse'},
    {'1': 'ValidateSizing', '2': '.electrical.v1.ValidateSizingRequest', '3': '.electrical.v1.ValidateSizingResponse'},
    {'1': 'ValidateNetwork', '2': '.electrical.v1.ValidateNetworkRequest', '3': '.electrical.v1.ValidateNetworkResponse'},
    {'1': 'GenerateNetworkBOM', '2': '.electrical.v1.GenerateNetworkBOMRequest', '3': '.electrical.v1.GenerateNetworkBOMResponse'},
    {'1': 'SubmitNetworkForReview', '2': '.electrical.v1.SubmitNetworkForReviewRequest', '3': '.electrical.v1.SubmitNetworkForReviewResponse'},
    {'1': 'ApproveNetwork', '2': '.electrical.v1.ApproveNetworkRequest', '3': '.electrical.v1.ApproveNetworkResponse'},
    {'1': 'RejectNetwork', '2': '.electrical.v1.RejectNetworkRequest', '3': '.electrical.v1.RejectNetworkResponse'},
  ],
};

@$core.Deprecated('Use electricalServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> ElectricalServiceBase$messageJson = {
  '.electrical.v1.CreateNetworkRequest': CreateNetworkRequest$json,
  '.electrical.v1.CreateNetworkResponse': CreateNetworkResponse$json,
  '.electrical.v1.ElectricalNetwork': ElectricalNetwork$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.electrical.v1.ReviewMetadata': ReviewMetadata$json,
  '.electrical.v1.GetNetworkRequest': GetNetworkRequest$json,
  '.electrical.v1.GetNetworkResponse': GetNetworkResponse$json,
  '.electrical.v1.ListNetworksRequest': ListNetworksRequest$json,
  '.electrical.v1.ListNetworksResponse': ListNetworksResponse$json,
  '.electrical.v1.DeleteNetworkRequest': DeleteNetworkRequest$json,
  '.electrical.v1.DeleteNetworkResponse': DeleteNetworkResponse$json,
  '.electrical.v1.CreateStringRequest': CreateStringRequest$json,
  '.electrical.v1.CreateStringResponse': CreateStringResponse$json,
  '.electrical.v1.PanelString': PanelString$json,
  '.electrical.v1.AutoGenerateStringsRequest': AutoGenerateStringsRequest$json,
  '.electrical.v1.AutoGenerateStringsResponse': AutoGenerateStringsResponse$json,
  '.electrical.v1.ListStringsRequest': ListStringsRequest$json,
  '.electrical.v1.ListStringsResponse': ListStringsResponse$json,
  '.electrical.v1.AssignInverterRequest': AssignInverterRequest$json,
  '.electrical.v1.AssignInverterResponse': AssignInverterResponse$json,
  '.electrical.v1.InverterGroup': InverterGroup$json,
  '.electrical.v1.ListInverterGroupsRequest': ListInverterGroupsRequest$json,
  '.electrical.v1.ListInverterGroupsResponse': ListInverterGroupsResponse$json,
  '.electrical.v1.CalculateDCCapacityRequest': CalculateDCCapacityRequest$json,
  '.electrical.v1.CalculateDCCapacityResponse': CalculateDCCapacityResponse$json,
  '.electrical.v1.CalculateACCapacityRequest': CalculateACCapacityRequest$json,
  '.electrical.v1.CalculateACCapacityResponse': CalculateACCapacityResponse$json,
  '.electrical.v1.CalculateLossesRequest': CalculateLossesRequest$json,
  '.electrical.v1.CalculateLossesResponse': CalculateLossesResponse$json,
  '.electrical.v1.ValidateSizingRequest': ValidateSizingRequest$json,
  '.electrical.v1.ValidateSizingResponse': ValidateSizingResponse$json,
  '.electrical.v1.SizingViolation': SizingViolation$json,
  '.electrical.v1.ValidateNetworkRequest': ValidateNetworkRequest$json,
  '.electrical.v1.ValidateNetworkResponse': ValidateNetworkResponse$json,
  '.electrical.v1.NetworkTopologyIssue': NetworkTopologyIssue$json,
  '.electrical.v1.GenerateNetworkBOMRequest': GenerateNetworkBOMRequest$json,
  '.electrical.v1.GenerateNetworkBOMResponse': GenerateNetworkBOMResponse$json,
  '.electrical.v1.NetworkBOMItem': NetworkBOMItem$json,
  '.electrical.v1.SubmitNetworkForReviewRequest': SubmitNetworkForReviewRequest$json,
  '.electrical.v1.SubmitNetworkForReviewResponse': SubmitNetworkForReviewResponse$json,
  '.electrical.v1.ApproveNetworkRequest': ApproveNetworkRequest$json,
  '.electrical.v1.ApproveNetworkResponse': ApproveNetworkResponse$json,
  '.electrical.v1.RejectNetworkRequest': RejectNetworkRequest$json,
  '.electrical.v1.RejectNetworkResponse': RejectNetworkResponse$json,
};

/// Descriptor for `ElectricalService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List electricalServiceDescriptor = $convert.base64Decode(
    'ChFFbGVjdHJpY2FsU2VydmljZRJaCg1DcmVhdGVOZXR3b3JrEiMuZWxlY3RyaWNhbC52MS5Dcm'
    'VhdGVOZXR3b3JrUmVxdWVzdBokLmVsZWN0cmljYWwudjEuQ3JlYXRlTmV0d29ya1Jlc3BvbnNl'
    'ElEKCkdldE5ldHdvcmsSIC5lbGVjdHJpY2FsLnYxLkdldE5ldHdvcmtSZXF1ZXN0GiEuZWxlY3'
    'RyaWNhbC52MS5HZXROZXR3b3JrUmVzcG9uc2USVwoMTGlzdE5ldHdvcmtzEiIuZWxlY3RyaWNh'
    'bC52MS5MaXN0TmV0d29ya3NSZXF1ZXN0GiMuZWxlY3RyaWNhbC52MS5MaXN0TmV0d29ya3NSZX'
    'Nwb25zZRJaCg1EZWxldGVOZXR3b3JrEiMuZWxlY3RyaWNhbC52MS5EZWxldGVOZXR3b3JrUmVx'
    'dWVzdBokLmVsZWN0cmljYWwudjEuRGVsZXRlTmV0d29ya1Jlc3BvbnNlElcKDENyZWF0ZVN0cm'
    'luZxIiLmVsZWN0cmljYWwudjEuQ3JlYXRlU3RyaW5nUmVxdWVzdBojLmVsZWN0cmljYWwudjEu'
    'Q3JlYXRlU3RyaW5nUmVzcG9uc2USbAoTQXV0b0dlbmVyYXRlU3RyaW5ncxIpLmVsZWN0cmljYW'
    'wudjEuQXV0b0dlbmVyYXRlU3RyaW5nc1JlcXVlc3QaKi5lbGVjdHJpY2FsLnYxLkF1dG9HZW5l'
    'cmF0ZVN0cmluZ3NSZXNwb25zZRJUCgtMaXN0U3RyaW5ncxIhLmVsZWN0cmljYWwudjEuTGlzdF'
    'N0cmluZ3NSZXF1ZXN0GiIuZWxlY3RyaWNhbC52MS5MaXN0U3RyaW5nc1Jlc3BvbnNlEl0KDkFz'
    'c2lnbkludmVydGVyEiQuZWxlY3RyaWNhbC52MS5Bc3NpZ25JbnZlcnRlclJlcXVlc3QaJS5lbG'
    'VjdHJpY2FsLnYxLkFzc2lnbkludmVydGVyUmVzcG9uc2USaQoSTGlzdEludmVydGVyR3JvdXBz'
    'EiguZWxlY3RyaWNhbC52MS5MaXN0SW52ZXJ0ZXJHcm91cHNSZXF1ZXN0GikuZWxlY3RyaWNhbC'
    '52MS5MaXN0SW52ZXJ0ZXJHcm91cHNSZXNwb25zZRJsChNDYWxjdWxhdGVEQ0NhcGFjaXR5Eiku'
    'ZWxlY3RyaWNhbC52MS5DYWxjdWxhdGVEQ0NhcGFjaXR5UmVxdWVzdBoqLmVsZWN0cmljYWwudj'
    'EuQ2FsY3VsYXRlRENDYXBhY2l0eVJlc3BvbnNlEmwKE0NhbGN1bGF0ZUFDQ2FwYWNpdHkSKS5l'
    'bGVjdHJpY2FsLnYxLkNhbGN1bGF0ZUFDQ2FwYWNpdHlSZXF1ZXN0GiouZWxlY3RyaWNhbC52MS'
    '5DYWxjdWxhdGVBQ0NhcGFjaXR5UmVzcG9uc2USYAoPQ2FsY3VsYXRlTG9zc2VzEiUuZWxlY3Ry'
    'aWNhbC52MS5DYWxjdWxhdGVMb3NzZXNSZXF1ZXN0GiYuZWxlY3RyaWNhbC52MS5DYWxjdWxhdG'
    'VMb3NzZXNSZXNwb25zZRJdCg5WYWxpZGF0ZVNpemluZxIkLmVsZWN0cmljYWwudjEuVmFsaWRh'
    'dGVTaXppbmdSZXF1ZXN0GiUuZWxlY3RyaWNhbC52MS5WYWxpZGF0ZVNpemluZ1Jlc3BvbnNlEm'
    'AKD1ZhbGlkYXRlTmV0d29yaxIlLmVsZWN0cmljYWwudjEuVmFsaWRhdGVOZXR3b3JrUmVxdWVz'
    'dBomLmVsZWN0cmljYWwudjEuVmFsaWRhdGVOZXR3b3JrUmVzcG9uc2USaQoSR2VuZXJhdGVOZX'
    'R3b3JrQk9NEiguZWxlY3RyaWNhbC52MS5HZW5lcmF0ZU5ldHdvcmtCT01SZXF1ZXN0GikuZWxl'
    'Y3RyaWNhbC52MS5HZW5lcmF0ZU5ldHdvcmtCT01SZXNwb25zZRJ1ChZTdWJtaXROZXR3b3JrRm'
    '9yUmV2aWV3EiwuZWxlY3RyaWNhbC52MS5TdWJtaXROZXR3b3JrRm9yUmV2aWV3UmVxdWVzdBot'
    'LmVsZWN0cmljYWwudjEuU3VibWl0TmV0d29ya0ZvclJldmlld1Jlc3BvbnNlEl0KDkFwcHJvdm'
    'VOZXR3b3JrEiQuZWxlY3RyaWNhbC52MS5BcHByb3ZlTmV0d29ya1JlcXVlc3QaJS5lbGVjdHJp'
    'Y2FsLnYxLkFwcHJvdmVOZXR3b3JrUmVzcG9uc2USWgoNUmVqZWN0TmV0d29yaxIjLmVsZWN0cm'
    'ljYWwudjEuUmVqZWN0TmV0d29ya1JlcXVlc3QaJC5lbGVjdHJpY2FsLnYxLlJlamVjdE5ldHdv'
    'cmtSZXNwb25zZQ==');

