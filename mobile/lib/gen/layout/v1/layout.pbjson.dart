//
//  Generated code. Do not modify.
//  source: layout/v1/layout.proto
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

@$core.Deprecated('Use componentTypeDescriptor instead')
const ComponentType$json = {
  '1': 'ComponentType',
  '2': [
    {'1': 'COMPONENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'COMPONENT_TYPE_PANEL', '2': 1},
    {'1': 'COMPONENT_TYPE_INVERTER', '2': 2},
    {'1': 'COMPONENT_TYPE_TRANSFORMER', '2': 3},
    {'1': 'COMPONENT_TYPE_JUNCTION_BOX', '2': 4},
    {'1': 'COMPONENT_TYPE_SUBSTATION', '2': 5},
    {'1': 'COMPONENT_TYPE_TRACKER', '2': 6},
    {'1': 'COMPONENT_TYPE_COMBINER_BOX', '2': 7},
  ],
};

/// Descriptor for `ComponentType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List componentTypeDescriptor = $convert.base64Decode(
    'Cg1Db21wb25lbnRUeXBlEh4KGkNPTVBPTkVOVF9UWVBFX1VOU1BFQ0lGSUVEEAASGAoUQ09NUE'
    '9ORU5UX1RZUEVfUEFORUwQARIbChdDT01QT05FTlRfVFlQRV9JTlZFUlRFUhACEh4KGkNPTVBP'
    'TkVOVF9UWVBFX1RSQU5TRk9STUVSEAMSHwobQ09NUE9ORU5UX1RZUEVfSlVOQ1RJT05fQk9YEA'
    'QSHQoZQ09NUE9ORU5UX1RZUEVfU1VCU1RBVElPThAFEhoKFkNPTVBPTkVOVF9UWVBFX1RSQUNL'
    'RVIQBhIfChtDT01QT05FTlRfVFlQRV9DT01CSU5FUl9CT1gQBw==');

@$core.Deprecated('Use reviewMetadataDescriptor instead')
const ReviewMetadata$json = {
  '1': 'ReviewMetadata',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.layout.v1.AcceptanceStatus', '10': 'status'},
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
    'Cg5SZXZpZXdNZXRhZGF0YRIzCgZzdGF0dXMYASABKA4yGy5sYXlvdXQudjEuQWNjZXB0YW5jZV'
    'N0YXR1c1IGc3RhdHVzEi8KFHJldmlld2VkX2J5X2FjdG9yX2lkGAIgASgJUhFyZXZpZXdlZEJ5'
    'QWN0b3JJZBI7CgtyZXZpZXdlZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCnJldmlld2VkQXQSIwoNcXVhbGl0eV9zY29yZRgEIAEoAVIMcXVhbGl0eVNjb3JlEicKD3Jl'
    'dmlld19jb21tZW50cxgFIAMoCVIOcmV2aWV3Q29tbWVudHMSGgoIYmxvY2tlcnMYBiADKAlSCG'
    'Jsb2NrZXJzEj8KHGFwcHJvdmFsX3RpbWVzdGFtcF91bml4X3NlY3MYByABKAlSGWFwcHJvdmFs'
    'VGltZXN0YW1wVW5peFNlY3M=');

@$core.Deprecated('Use layoutDescriptor instead')
const Layout$json = {
  '1': 'Layout',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'total_panels', '3': 4, '4': 1, '5': 5, '10': 'totalPanels'},
    {'1': 'total_capacity_kw', '3': 5, '4': 1, '5': 1, '10': 'totalCapacityKw'},
    {'1': 'tile_count', '3': 6, '4': 1, '5': 5, '10': 'tileCount'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'review_metadata', '3': 9, '4': 1, '5': 11, '6': '.layout.v1.ReviewMetadata', '10': 'reviewMetadata'},
    {'1': 'candidate_id', '3': 10, '4': 1, '5': 9, '10': 'candidateId'},
  ],
};

/// Descriptor for `Layout`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutDescriptor = $convert.base64Decode(
    'CgZMYXlvdXQSDgoCaWQYASABKAlSAmlkEh0KCnByb2plY3RfaWQYAiABKAlSCXByb2plY3RJZB'
    'ISCgRuYW1lGAMgASgJUgRuYW1lEiEKDHRvdGFsX3BhbmVscxgEIAEoBVILdG90YWxQYW5lbHMS'
    'KgoRdG90YWxfY2FwYWNpdHlfa3cYBSABKAFSD3RvdGFsQ2FwYWNpdHlLdxIdCgp0aWxlX2NvdW'
    '50GAYgASgFUgl0aWxlQ291bnQSOQoKY3JlYXRlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1'
    'Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAggASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EkIKD3Jldmlld19tZXRhZGF0YRgJIAEoCzIZLmxh'
    'eW91dC52MS5SZXZpZXdNZXRhZGF0YVIOcmV2aWV3TWV0YWRhdGESIQoMY2FuZGlkYXRlX2lkGA'
    'ogASgJUgtjYW5kaWRhdGVJZA==');

@$core.Deprecated('Use componentDescriptor instead')
const Component$json = {
  '1': 'Component',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'asset_id', '3': 3, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'component_type', '3': 4, '4': 1, '5': 14, '6': '.layout.v1.ComponentType', '10': 'componentType'},
    {'1': 'position', '3': 5, '4': 1, '5': 11, '6': '.layout.v1.Position', '10': 'position'},
    {'1': 'rotation', '3': 6, '4': 1, '5': 1, '10': 'rotation'},
    {'1': 'metadata_json', '3': 7, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
  ],
};

/// Descriptor for `Component`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List componentDescriptor = $convert.base64Decode(
    'CglDb21wb25lbnQSDgoCaWQYASABKAlSAmlkEhsKCWxheW91dF9pZBgCIAEoCVIIbGF5b3V0SW'
    'QSGQoIYXNzZXRfaWQYAyABKAlSB2Fzc2V0SWQSPwoOY29tcG9uZW50X3R5cGUYBCABKA4yGC5s'
    'YXlvdXQudjEuQ29tcG9uZW50VHlwZVINY29tcG9uZW50VHlwZRIvCghwb3NpdGlvbhgFIAEoCz'
    'ITLmxheW91dC52MS5Qb3NpdGlvblIIcG9zaXRpb24SGgoIcm90YXRpb24YBiABKAFSCHJvdGF0'
    'aW9uEiMKDW1ldGFkYXRhX2pzb24YByABKAlSDG1ldGFkYXRhSnNvbhI5CgpjcmVhdGVkX2F0GA'
    'ggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0');

@$core.Deprecated('Use positionDescriptor instead')
const Position$json = {
  '1': 'Position',
  '2': [
    {'1': 'longitude', '3': 1, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'latitude', '3': 2, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'elevation', '3': 3, '4': 1, '5': 1, '10': 'elevation'},
  ],
};

/// Descriptor for `Position`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List positionDescriptor = $convert.base64Decode(
    'CghQb3NpdGlvbhIcCglsb25naXR1ZGUYASABKAFSCWxvbmdpdHVkZRIaCghsYXRpdHVkZRgCIA'
    'EoAVIIbGF0aXR1ZGUSHAoJZWxldmF0aW9uGAMgASgBUgllbGV2YXRpb24=');

@$core.Deprecated('Use layoutTileDescriptor instead')
const LayoutTile$json = {
  '1': 'LayoutTile',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'bbox', '3': 3, '4': 1, '5': 11, '6': '.layout.v1.BoundingBox', '10': 'bbox'},
    {'1': 'lod_level', '3': 4, '4': 1, '5': 5, '10': 'lodLevel'},
    {'1': 'panel_count', '3': 5, '4': 1, '5': 5, '10': 'panelCount'},
    {'1': 'metadata_json', '3': 6, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
  ],
};

/// Descriptor for `LayoutTile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutTileDescriptor = $convert.base64Decode(
    'CgpMYXlvdXRUaWxlEg4KAmlkGAEgASgJUgJpZBIbCglsYXlvdXRfaWQYAiABKAlSCGxheW91dE'
    'lkEioKBGJib3gYAyABKAsyFi5sYXlvdXQudjEuQm91bmRpbmdCb3hSBGJib3gSGwoJbG9kX2xl'
    'dmVsGAQgASgFUghsb2RMZXZlbBIfCgtwYW5lbF9jb3VudBgFIAEoBVIKcGFuZWxDb3VudBIjCg'
    '1tZXRhZGF0YV9qc29uGAYgASgJUgxtZXRhZGF0YUpzb24SOQoKY3JlYXRlZF9hdBgHIAEoCzIa'
    'Lmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use panelDescriptor instead')
const Panel$json = {
  '1': 'Panel',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'tile_id', '3': 2, '4': 1, '5': 9, '10': 'tileId'},
    {'1': 'string_id', '3': 3, '4': 1, '5': 9, '10': 'stringId'},
    {'1': 'geometry_geojson', '3': 4, '4': 1, '5': 9, '10': 'geometryGeojson'},
    {'1': 'tilt', '3': 5, '4': 1, '5': 1, '10': 'tilt'},
    {'1': 'azimuth', '3': 6, '4': 1, '5': 1, '10': 'azimuth'},
    {'1': 'elevation', '3': 7, '4': 1, '5': 1, '10': 'elevation'},
    {'1': 'metadata_json', '3': 8, '4': 1, '5': 9, '10': 'metadataJson'},
  ],
};

/// Descriptor for `Panel`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List panelDescriptor = $convert.base64Decode(
    'CgVQYW5lbBIOCgJpZBgBIAEoCVICaWQSFwoHdGlsZV9pZBgCIAEoCVIGdGlsZUlkEhsKCXN0cm'
    'luZ19pZBgDIAEoCVIIc3RyaW5nSWQSKQoQZ2VvbWV0cnlfZ2VvanNvbhgEIAEoCVIPZ2VvbWV0'
    'cnlHZW9qc29uEhIKBHRpbHQYBSABKAFSBHRpbHQSGAoHYXppbXV0aBgGIAEoAVIHYXppbXV0aB'
    'IcCgllbGV2YXRpb24YByABKAFSCWVsZXZhdGlvbhIjCg1tZXRhZGF0YV9qc29uGAggASgJUgxt'
    'ZXRhZGF0YUpzb24=');

@$core.Deprecated('Use boundingBoxDescriptor instead')
const BoundingBox$json = {
  '1': 'BoundingBox',
  '2': [
    {'1': 'min_x', '3': 1, '4': 1, '5': 1, '10': 'minX'},
    {'1': 'min_y', '3': 2, '4': 1, '5': 1, '10': 'minY'},
    {'1': 'max_x', '3': 3, '4': 1, '5': 1, '10': 'maxX'},
    {'1': 'max_y', '3': 4, '4': 1, '5': 1, '10': 'maxY'},
  ],
};

/// Descriptor for `BoundingBox`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boundingBoxDescriptor = $convert.base64Decode(
    'CgtCb3VuZGluZ0JveBITCgVtaW5feBgBIAEoAVIEbWluWBITCgVtaW5feRgCIAEoAVIEbWluWR'
    'ITCgVtYXhfeBgDIAEoAVIEbWF4WBITCgVtYXhfeRgEIAEoAVIEbWF4WQ==');

@$core.Deprecated('Use submitLayoutForReviewRequestDescriptor instead')
const SubmitLayoutForReviewRequest$json = {
  '1': 'SubmitLayoutForReviewRequest',
  '2': [
    {'1': 'layout_id', '3': 1, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'submission_reason', '3': 2, '4': 1, '5': 9, '10': 'submissionReason'},
    {'1': 'submitted_by_actor_id', '3': 3, '4': 1, '5': 9, '10': 'submittedByActorId'},
  ],
};

/// Descriptor for `SubmitLayoutForReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitLayoutForReviewRequestDescriptor = $convert.base64Decode(
    'ChxTdWJtaXRMYXlvdXRGb3JSZXZpZXdSZXF1ZXN0EhsKCWxheW91dF9pZBgBIAEoCVIIbGF5b3'
    'V0SWQSKwoRc3VibWlzc2lvbl9yZWFzb24YAiABKAlSEHN1Ym1pc3Npb25SZWFzb24SMQoVc3Vi'
    'bWl0dGVkX2J5X2FjdG9yX2lkGAMgASgJUhJzdWJtaXR0ZWRCeUFjdG9ySWQ=');

@$core.Deprecated('Use submitLayoutForReviewResponseDescriptor instead')
const SubmitLayoutForReviewResponse$json = {
  '1': 'SubmitLayoutForReviewResponse',
  '2': [
    {'1': 'layout', '3': 1, '4': 1, '5': 11, '6': '.layout.v1.Layout', '10': 'layout'},
    {'1': 'review_metadata', '3': 2, '4': 1, '5': 11, '6': '.layout.v1.ReviewMetadata', '10': 'reviewMetadata'},
  ],
};

/// Descriptor for `SubmitLayoutForReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitLayoutForReviewResponseDescriptor = $convert.base64Decode(
    'Ch1TdWJtaXRMYXlvdXRGb3JSZXZpZXdSZXNwb25zZRIpCgZsYXlvdXQYASABKAsyES5sYXlvdX'
    'QudjEuTGF5b3V0UgZsYXlvdXQSQgoPcmV2aWV3X21ldGFkYXRhGAIgASgLMhkubGF5b3V0LnYx'
    'LlJldmlld01ldGFkYXRhUg5yZXZpZXdNZXRhZGF0YQ==');

@$core.Deprecated('Use approveLayoutRequestDescriptor instead')
const ApproveLayoutRequest$json = {
  '1': 'ApproveLayoutRequest',
  '2': [
    {'1': 'layout_id', '3': 1, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'quality_score', '3': 2, '4': 1, '5': 1, '10': 'qualityScore'},
    {'1': 'approval_comments', '3': 3, '4': 3, '5': 9, '10': 'approvalComments'},
    {'1': 'approved_by_actor_id', '3': 4, '4': 1, '5': 9, '10': 'approvedByActorId'},
  ],
};

/// Descriptor for `ApproveLayoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveLayoutRequestDescriptor = $convert.base64Decode(
    'ChRBcHByb3ZlTGF5b3V0UmVxdWVzdBIbCglsYXlvdXRfaWQYASABKAlSCGxheW91dElkEiMKDX'
    'F1YWxpdHlfc2NvcmUYAiABKAFSDHF1YWxpdHlTY29yZRIrChFhcHByb3ZhbF9jb21tZW50cxgD'
    'IAMoCVIQYXBwcm92YWxDb21tZW50cxIvChRhcHByb3ZlZF9ieV9hY3Rvcl9pZBgEIAEoCVIRYX'
    'Bwcm92ZWRCeUFjdG9ySWQ=');

@$core.Deprecated('Use approveLayoutResponseDescriptor instead')
const ApproveLayoutResponse$json = {
  '1': 'ApproveLayoutResponse',
  '2': [
    {'1': 'layout', '3': 1, '4': 1, '5': 11, '6': '.layout.v1.Layout', '10': 'layout'},
    {'1': 'review_metadata', '3': 2, '4': 1, '5': 11, '6': '.layout.v1.ReviewMetadata', '10': 'reviewMetadata'},
  ],
};

/// Descriptor for `ApproveLayoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveLayoutResponseDescriptor = $convert.base64Decode(
    'ChVBcHByb3ZlTGF5b3V0UmVzcG9uc2USKQoGbGF5b3V0GAEgASgLMhEubGF5b3V0LnYxLkxheW'
    '91dFIGbGF5b3V0EkIKD3Jldmlld19tZXRhZGF0YRgCIAEoCzIZLmxheW91dC52MS5SZXZpZXdN'
    'ZXRhZGF0YVIOcmV2aWV3TWV0YWRhdGE=');

@$core.Deprecated('Use rejectLayoutRequestDescriptor instead')
const RejectLayoutRequest$json = {
  '1': 'RejectLayoutRequest',
  '2': [
    {'1': 'layout_id', '3': 1, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'rejection_reasons', '3': 2, '4': 3, '5': 9, '10': 'rejectionReasons'},
    {'1': 'rejected_by_actor_id', '3': 3, '4': 1, '5': 9, '10': 'rejectedByActorId'},
  ],
};

/// Descriptor for `RejectLayoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectLayoutRequestDescriptor = $convert.base64Decode(
    'ChNSZWplY3RMYXlvdXRSZXF1ZXN0EhsKCWxheW91dF9pZBgBIAEoCVIIbGF5b3V0SWQSKwoRcm'
    'VqZWN0aW9uX3JlYXNvbnMYAiADKAlSEHJlamVjdGlvblJlYXNvbnMSLwoUcmVqZWN0ZWRfYnlf'
    'YWN0b3JfaWQYAyABKAlSEXJlamVjdGVkQnlBY3Rvcklk');

@$core.Deprecated('Use rejectLayoutResponseDescriptor instead')
const RejectLayoutResponse$json = {
  '1': 'RejectLayoutResponse',
  '2': [
    {'1': 'layout', '3': 1, '4': 1, '5': 11, '6': '.layout.v1.Layout', '10': 'layout'},
    {'1': 'review_metadata', '3': 2, '4': 1, '5': 11, '6': '.layout.v1.ReviewMetadata', '10': 'reviewMetadata'},
  ],
};

/// Descriptor for `RejectLayoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectLayoutResponseDescriptor = $convert.base64Decode(
    'ChRSZWplY3RMYXlvdXRSZXNwb25zZRIpCgZsYXlvdXQYASABKAsyES5sYXlvdXQudjEuTGF5b3'
    'V0UgZsYXlvdXQSQgoPcmV2aWV3X21ldGFkYXRhGAIgASgLMhkubGF5b3V0LnYxLlJldmlld01l'
    'dGFkYXRhUg5yZXZpZXdNZXRhZGF0YQ==');

@$core.Deprecated('Use panelArrayParamsDescriptor instead')
const PanelArrayParams$json = {
  '1': 'PanelArrayParams',
  '2': [
    {'1': 'panel_width', '3': 1, '4': 1, '5': 1, '10': 'panelWidth'},
    {'1': 'panel_height', '3': 2, '4': 1, '5': 1, '10': 'panelHeight'},
    {'1': 'tilt_angle', '3': 3, '4': 1, '5': 1, '10': 'tiltAngle'},
    {'1': 'azimuth', '3': 4, '4': 1, '5': 1, '10': 'azimuth'},
    {'1': 'row_spacing', '3': 5, '4': 1, '5': 1, '10': 'rowSpacing'},
    {'1': 'column_spacing', '3': 6, '4': 1, '5': 1, '10': 'columnSpacing'},
    {'1': 'fill_area_geojson', '3': 7, '4': 1, '5': 9, '10': 'fillAreaGeojson'},
    {'1': 'terrain_layer_id', '3': 8, '4': 1, '5': 9, '10': 'terrainLayerId'},
  ],
};

/// Descriptor for `PanelArrayParams`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List panelArrayParamsDescriptor = $convert.base64Decode(
    'ChBQYW5lbEFycmF5UGFyYW1zEh8KC3BhbmVsX3dpZHRoGAEgASgBUgpwYW5lbFdpZHRoEiEKDH'
    'BhbmVsX2hlaWdodBgCIAEoAVILcGFuZWxIZWlnaHQSHQoKdGlsdF9hbmdsZRgDIAEoAVIJdGls'
    'dEFuZ2xlEhgKB2F6aW11dGgYBCABKAFSB2F6aW11dGgSHwoLcm93X3NwYWNpbmcYBSABKAFSCn'
    'Jvd1NwYWNpbmcSJQoOY29sdW1uX3NwYWNpbmcYBiABKAFSDWNvbHVtblNwYWNpbmcSKgoRZmls'
    'bF9hcmVhX2dlb2pzb24YByABKAlSD2ZpbGxBcmVhR2VvanNvbhIoChB0ZXJyYWluX2xheWVyX2'
    'lkGAggASgJUg50ZXJyYWluTGF5ZXJJZA==');

@$core.Deprecated('Use createLayoutRequestDescriptor instead')
const CreateLayoutRequest$json = {
  '1': 'CreateLayoutRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `CreateLayoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createLayoutRequestDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVMYXlvdXRSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZBISCg'
    'RuYW1lGAIgASgJUgRuYW1l');

@$core.Deprecated('Use createLayoutResponseDescriptor instead')
const CreateLayoutResponse$json = {
  '1': 'CreateLayoutResponse',
  '2': [
    {'1': 'layout', '3': 1, '4': 1, '5': 11, '6': '.layout.v1.Layout', '10': 'layout'},
  ],
};

/// Descriptor for `CreateLayoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createLayoutResponseDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVMYXlvdXRSZXNwb25zZRIpCgZsYXlvdXQYASABKAsyES5sYXlvdXQudjEuTGF5b3'
    'V0UgZsYXlvdXQ=');

@$core.Deprecated('Use getLayoutRequestDescriptor instead')
const GetLayoutRequest$json = {
  '1': 'GetLayoutRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetLayoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLayoutRequestDescriptor = $convert.base64Decode(
    'ChBHZXRMYXlvdXRSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use getLayoutResponseDescriptor instead')
const GetLayoutResponse$json = {
  '1': 'GetLayoutResponse',
  '2': [
    {'1': 'layout', '3': 1, '4': 1, '5': 11, '6': '.layout.v1.Layout', '10': 'layout'},
  ],
};

/// Descriptor for `GetLayoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLayoutResponseDescriptor = $convert.base64Decode(
    'ChFHZXRMYXlvdXRSZXNwb25zZRIpCgZsYXlvdXQYASABKAsyES5sYXlvdXQudjEuTGF5b3V0Ug'
    'ZsYXlvdXQ=');

@$core.Deprecated('Use listLayoutsRequestDescriptor instead')
const ListLayoutsRequest$json = {
  '1': 'ListLayoutsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
  ],
};

/// Descriptor for `ListLayoutsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLayoutsRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0TGF5b3V0c1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElk');

@$core.Deprecated('Use listLayoutsResponseDescriptor instead')
const ListLayoutsResponse$json = {
  '1': 'ListLayoutsResponse',
  '2': [
    {'1': 'layouts', '3': 1, '4': 3, '5': 11, '6': '.layout.v1.Layout', '10': 'layouts'},
  ],
};

/// Descriptor for `ListLayoutsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listLayoutsResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0TGF5b3V0c1Jlc3BvbnNlEisKB2xheW91dHMYASADKAsyES5sYXlvdXQudjEuTGF5b3'
    'V0UgdsYXlvdXRz');

@$core.Deprecated('Use deleteLayoutRequestDescriptor instead')
const DeleteLayoutRequest$json = {
  '1': 'DeleteLayoutRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteLayoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteLayoutRequestDescriptor = $convert.base64Decode(
    'ChNEZWxldGVMYXlvdXRSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use deleteLayoutResponseDescriptor instead')
const DeleteLayoutResponse$json = {
  '1': 'DeleteLayoutResponse',
};

/// Descriptor for `DeleteLayoutResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteLayoutResponseDescriptor = $convert.base64Decode(
    'ChREZWxldGVMYXlvdXRSZXNwb25zZQ==');

@$core.Deprecated('Use placeComponentRequestDescriptor instead')
const PlaceComponentRequest$json = {
  '1': 'PlaceComponentRequest',
  '2': [
    {'1': 'layout_id', '3': 1, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'asset_id', '3': 2, '4': 1, '5': 9, '10': 'assetId'},
    {'1': 'component_type', '3': 3, '4': 1, '5': 14, '6': '.layout.v1.ComponentType', '10': 'componentType'},
    {'1': 'position', '3': 4, '4': 1, '5': 11, '6': '.layout.v1.Position', '10': 'position'},
    {'1': 'rotation', '3': 5, '4': 1, '5': 1, '10': 'rotation'},
    {'1': 'metadata_json', '3': 6, '4': 1, '5': 9, '10': 'metadataJson'},
  ],
};

/// Descriptor for `PlaceComponentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeComponentRequestDescriptor = $convert.base64Decode(
    'ChVQbGFjZUNvbXBvbmVudFJlcXVlc3QSGwoJbGF5b3V0X2lkGAEgASgJUghsYXlvdXRJZBIZCg'
    'hhc3NldF9pZBgCIAEoCVIHYXNzZXRJZBI/Cg5jb21wb25lbnRfdHlwZRgDIAEoDjIYLmxheW91'
    'dC52MS5Db21wb25lbnRUeXBlUg1jb21wb25lbnRUeXBlEi8KCHBvc2l0aW9uGAQgASgLMhMubG'
    'F5b3V0LnYxLlBvc2l0aW9uUghwb3NpdGlvbhIaCghyb3RhdGlvbhgFIAEoAVIIcm90YXRpb24S'
    'IwoNbWV0YWRhdGFfanNvbhgGIAEoCVIMbWV0YWRhdGFKc29u');

@$core.Deprecated('Use placeComponentResponseDescriptor instead')
const PlaceComponentResponse$json = {
  '1': 'PlaceComponentResponse',
  '2': [
    {'1': 'component', '3': 1, '4': 1, '5': 11, '6': '.layout.v1.Component', '10': 'component'},
  ],
};

/// Descriptor for `PlaceComponentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List placeComponentResponseDescriptor = $convert.base64Decode(
    'ChZQbGFjZUNvbXBvbmVudFJlc3BvbnNlEjIKCWNvbXBvbmVudBgBIAEoCzIULmxheW91dC52MS'
    '5Db21wb25lbnRSCWNvbXBvbmVudA==');

@$core.Deprecated('Use moveComponentRequestDescriptor instead')
const MoveComponentRequest$json = {
  '1': 'MoveComponentRequest',
  '2': [
    {'1': 'component_id', '3': 1, '4': 1, '5': 9, '10': 'componentId'},
    {'1': 'position', '3': 2, '4': 1, '5': 11, '6': '.layout.v1.Position', '10': 'position'},
    {'1': 'rotation', '3': 3, '4': 1, '5': 1, '10': 'rotation'},
  ],
};

/// Descriptor for `MoveComponentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveComponentRequestDescriptor = $convert.base64Decode(
    'ChRNb3ZlQ29tcG9uZW50UmVxdWVzdBIhCgxjb21wb25lbnRfaWQYASABKAlSC2NvbXBvbmVudE'
    'lkEi8KCHBvc2l0aW9uGAIgASgLMhMubGF5b3V0LnYxLlBvc2l0aW9uUghwb3NpdGlvbhIaCghy'
    'b3RhdGlvbhgDIAEoAVIIcm90YXRpb24=');

@$core.Deprecated('Use moveComponentResponseDescriptor instead')
const MoveComponentResponse$json = {
  '1': 'MoveComponentResponse',
  '2': [
    {'1': 'component', '3': 1, '4': 1, '5': 11, '6': '.layout.v1.Component', '10': 'component'},
  ],
};

/// Descriptor for `MoveComponentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List moveComponentResponseDescriptor = $convert.base64Decode(
    'ChVNb3ZlQ29tcG9uZW50UmVzcG9uc2USMgoJY29tcG9uZW50GAEgASgLMhQubGF5b3V0LnYxLk'
    'NvbXBvbmVudFIJY29tcG9uZW50');

@$core.Deprecated('Use removeComponentRequestDescriptor instead')
const RemoveComponentRequest$json = {
  '1': 'RemoveComponentRequest',
  '2': [
    {'1': 'component_id', '3': 1, '4': 1, '5': 9, '10': 'componentId'},
  ],
};

/// Descriptor for `RemoveComponentRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeComponentRequestDescriptor = $convert.base64Decode(
    'ChZSZW1vdmVDb21wb25lbnRSZXF1ZXN0EiEKDGNvbXBvbmVudF9pZBgBIAEoCVILY29tcG9uZW'
    '50SWQ=');

@$core.Deprecated('Use removeComponentResponseDescriptor instead')
const RemoveComponentResponse$json = {
  '1': 'RemoveComponentResponse',
};

/// Descriptor for `RemoveComponentResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removeComponentResponseDescriptor = $convert.base64Decode(
    'ChdSZW1vdmVDb21wb25lbnRSZXNwb25zZQ==');

@$core.Deprecated('Use listComponentsRequestDescriptor instead')
const ListComponentsRequest$json = {
  '1': 'ListComponentsRequest',
  '2': [
    {'1': 'layout_id', '3': 1, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'type_filter', '3': 2, '4': 1, '5': 14, '6': '.layout.v1.ComponentType', '10': 'typeFilter'},
  ],
};

/// Descriptor for `ListComponentsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listComponentsRequestDescriptor = $convert.base64Decode(
    'ChVMaXN0Q29tcG9uZW50c1JlcXVlc3QSGwoJbGF5b3V0X2lkGAEgASgJUghsYXlvdXRJZBI5Cg'
    't0eXBlX2ZpbHRlchgCIAEoDjIYLmxheW91dC52MS5Db21wb25lbnRUeXBlUgp0eXBlRmlsdGVy');

@$core.Deprecated('Use listComponentsResponseDescriptor instead')
const ListComponentsResponse$json = {
  '1': 'ListComponentsResponse',
  '2': [
    {'1': 'components', '3': 1, '4': 3, '5': 11, '6': '.layout.v1.Component', '10': 'components'},
  ],
};

/// Descriptor for `ListComponentsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listComponentsResponseDescriptor = $convert.base64Decode(
    'ChZMaXN0Q29tcG9uZW50c1Jlc3BvbnNlEjQKCmNvbXBvbmVudHMYASADKAsyFC5sYXlvdXQudj'
    'EuQ29tcG9uZW50Ugpjb21wb25lbnRz');

@$core.Deprecated('Use generatePanelArrayRequestDescriptor instead')
const GeneratePanelArrayRequest$json = {
  '1': 'GeneratePanelArrayRequest',
  '2': [
    {'1': 'layout_id', '3': 1, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'params', '3': 2, '4': 1, '5': 11, '6': '.layout.v1.PanelArrayParams', '10': 'params'},
  ],
};

/// Descriptor for `GeneratePanelArrayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generatePanelArrayRequestDescriptor = $convert.base64Decode(
    'ChlHZW5lcmF0ZVBhbmVsQXJyYXlSZXF1ZXN0EhsKCWxheW91dF9pZBgBIAEoCVIIbGF5b3V0SW'
    'QSMwoGcGFyYW1zGAIgASgLMhsubGF5b3V0LnYxLlBhbmVsQXJyYXlQYXJhbXNSBnBhcmFtcw==');

@$core.Deprecated('Use generatePanelArrayResponseDescriptor instead')
const GeneratePanelArrayResponse$json = {
  '1': 'GeneratePanelArrayResponse',
  '2': [
    {'1': 'panels_created', '3': 1, '4': 1, '5': 5, '10': 'panelsCreated'},
    {'1': 'tiles_created', '3': 2, '4': 1, '5': 5, '10': 'tilesCreated'},
    {'1': 'capacity_kw', '3': 3, '4': 1, '5': 1, '10': 'capacityKw'},
  ],
};

/// Descriptor for `GeneratePanelArrayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generatePanelArrayResponseDescriptor = $convert.base64Decode(
    'ChpHZW5lcmF0ZVBhbmVsQXJyYXlSZXNwb25zZRIlCg5wYW5lbHNfY3JlYXRlZBgBIAEoBVINcG'
    'FuZWxzQ3JlYXRlZBIjCg10aWxlc19jcmVhdGVkGAIgASgFUgx0aWxlc0NyZWF0ZWQSHwoLY2Fw'
    'YWNpdHlfa3cYAyABKAFSCmNhcGFjaXR5S3c=');

@$core.Deprecated('Use getTilesRequestDescriptor instead')
const GetTilesRequest$json = {
  '1': 'GetTilesRequest',
  '2': [
    {'1': 'layout_id', '3': 1, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'viewport', '3': 2, '4': 1, '5': 11, '6': '.layout.v1.BoundingBox', '10': 'viewport'},
    {'1': 'lod_level', '3': 3, '4': 1, '5': 5, '10': 'lodLevel'},
  ],
};

/// Descriptor for `GetTilesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTilesRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRUaWxlc1JlcXVlc3QSGwoJbGF5b3V0X2lkGAEgASgJUghsYXlvdXRJZBIyCgh2aWV3cG'
    '9ydBgCIAEoCzIWLmxheW91dC52MS5Cb3VuZGluZ0JveFIIdmlld3BvcnQSGwoJbG9kX2xldmVs'
    'GAMgASgFUghsb2RMZXZlbA==');

@$core.Deprecated('Use getTilesResponseDescriptor instead')
const GetTilesResponse$json = {
  '1': 'GetTilesResponse',
  '2': [
    {'1': 'tiles', '3': 1, '4': 3, '5': 11, '6': '.layout.v1.LayoutTile', '10': 'tiles'},
  ],
};

/// Descriptor for `GetTilesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTilesResponseDescriptor = $convert.base64Decode(
    'ChBHZXRUaWxlc1Jlc3BvbnNlEisKBXRpbGVzGAEgAygLMhUubGF5b3V0LnYxLkxheW91dFRpbG'
    'VSBXRpbGVz');

@$core.Deprecated('Use getTilePanelsRequestDescriptor instead')
const GetTilePanelsRequest$json = {
  '1': 'GetTilePanelsRequest',
  '2': [
    {'1': 'tile_id', '3': 1, '4': 1, '5': 9, '10': 'tileId'},
  ],
};

/// Descriptor for `GetTilePanelsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTilePanelsRequestDescriptor = $convert.base64Decode(
    'ChRHZXRUaWxlUGFuZWxzUmVxdWVzdBIXCgd0aWxlX2lkGAEgASgJUgZ0aWxlSWQ=');

@$core.Deprecated('Use getTilePanelsResponseDescriptor instead')
const GetTilePanelsResponse$json = {
  '1': 'GetTilePanelsResponse',
  '2': [
    {'1': 'panels', '3': 1, '4': 3, '5': 11, '6': '.layout.v1.Panel', '10': 'panels'},
  ],
};

/// Descriptor for `GetTilePanelsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTilePanelsResponseDescriptor = $convert.base64Decode(
    'ChVHZXRUaWxlUGFuZWxzUmVzcG9uc2USKAoGcGFuZWxzGAEgAygLMhAubGF5b3V0LnYxLlBhbm'
    'VsUgZwYW5lbHM=');

const $core.Map<$core.String, $core.dynamic> LayoutServiceBase$json = {
  '1': 'LayoutService',
  '2': [
    {'1': 'CreateLayout', '2': '.layout.v1.CreateLayoutRequest', '3': '.layout.v1.CreateLayoutResponse'},
    {'1': 'GetLayout', '2': '.layout.v1.GetLayoutRequest', '3': '.layout.v1.GetLayoutResponse'},
    {'1': 'ListLayouts', '2': '.layout.v1.ListLayoutsRequest', '3': '.layout.v1.ListLayoutsResponse'},
    {'1': 'DeleteLayout', '2': '.layout.v1.DeleteLayoutRequest', '3': '.layout.v1.DeleteLayoutResponse'},
    {'1': 'PlaceComponent', '2': '.layout.v1.PlaceComponentRequest', '3': '.layout.v1.PlaceComponentResponse'},
    {'1': 'MoveComponent', '2': '.layout.v1.MoveComponentRequest', '3': '.layout.v1.MoveComponentResponse'},
    {'1': 'RemoveComponent', '2': '.layout.v1.RemoveComponentRequest', '3': '.layout.v1.RemoveComponentResponse'},
    {'1': 'ListComponents', '2': '.layout.v1.ListComponentsRequest', '3': '.layout.v1.ListComponentsResponse'},
    {'1': 'GeneratePanelArray', '2': '.layout.v1.GeneratePanelArrayRequest', '3': '.layout.v1.GeneratePanelArrayResponse'},
    {'1': 'GetTiles', '2': '.layout.v1.GetTilesRequest', '3': '.layout.v1.GetTilesResponse'},
    {'1': 'GetTilePanels', '2': '.layout.v1.GetTilePanelsRequest', '3': '.layout.v1.GetTilePanelsResponse'},
    {'1': 'SubmitLayoutForReview', '2': '.layout.v1.SubmitLayoutForReviewRequest', '3': '.layout.v1.SubmitLayoutForReviewResponse'},
    {'1': 'ApproveLayout', '2': '.layout.v1.ApproveLayoutRequest', '3': '.layout.v1.ApproveLayoutResponse'},
    {'1': 'RejectLayout', '2': '.layout.v1.RejectLayoutRequest', '3': '.layout.v1.RejectLayoutResponse'},
  ],
};

@$core.Deprecated('Use layoutServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> LayoutServiceBase$messageJson = {
  '.layout.v1.CreateLayoutRequest': CreateLayoutRequest$json,
  '.layout.v1.CreateLayoutResponse': CreateLayoutResponse$json,
  '.layout.v1.Layout': Layout$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.layout.v1.ReviewMetadata': ReviewMetadata$json,
  '.layout.v1.GetLayoutRequest': GetLayoutRequest$json,
  '.layout.v1.GetLayoutResponse': GetLayoutResponse$json,
  '.layout.v1.ListLayoutsRequest': ListLayoutsRequest$json,
  '.layout.v1.ListLayoutsResponse': ListLayoutsResponse$json,
  '.layout.v1.DeleteLayoutRequest': DeleteLayoutRequest$json,
  '.layout.v1.DeleteLayoutResponse': DeleteLayoutResponse$json,
  '.layout.v1.PlaceComponentRequest': PlaceComponentRequest$json,
  '.layout.v1.Position': Position$json,
  '.layout.v1.PlaceComponentResponse': PlaceComponentResponse$json,
  '.layout.v1.Component': Component$json,
  '.layout.v1.MoveComponentRequest': MoveComponentRequest$json,
  '.layout.v1.MoveComponentResponse': MoveComponentResponse$json,
  '.layout.v1.RemoveComponentRequest': RemoveComponentRequest$json,
  '.layout.v1.RemoveComponentResponse': RemoveComponentResponse$json,
  '.layout.v1.ListComponentsRequest': ListComponentsRequest$json,
  '.layout.v1.ListComponentsResponse': ListComponentsResponse$json,
  '.layout.v1.GeneratePanelArrayRequest': GeneratePanelArrayRequest$json,
  '.layout.v1.PanelArrayParams': PanelArrayParams$json,
  '.layout.v1.GeneratePanelArrayResponse': GeneratePanelArrayResponse$json,
  '.layout.v1.GetTilesRequest': GetTilesRequest$json,
  '.layout.v1.BoundingBox': BoundingBox$json,
  '.layout.v1.GetTilesResponse': GetTilesResponse$json,
  '.layout.v1.LayoutTile': LayoutTile$json,
  '.layout.v1.GetTilePanelsRequest': GetTilePanelsRequest$json,
  '.layout.v1.GetTilePanelsResponse': GetTilePanelsResponse$json,
  '.layout.v1.Panel': Panel$json,
  '.layout.v1.SubmitLayoutForReviewRequest': SubmitLayoutForReviewRequest$json,
  '.layout.v1.SubmitLayoutForReviewResponse': SubmitLayoutForReviewResponse$json,
  '.layout.v1.ApproveLayoutRequest': ApproveLayoutRequest$json,
  '.layout.v1.ApproveLayoutResponse': ApproveLayoutResponse$json,
  '.layout.v1.RejectLayoutRequest': RejectLayoutRequest$json,
  '.layout.v1.RejectLayoutResponse': RejectLayoutResponse$json,
};

/// Descriptor for `LayoutService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List layoutServiceDescriptor = $convert.base64Decode(
    'Cg1MYXlvdXRTZXJ2aWNlEk8KDENyZWF0ZUxheW91dBIeLmxheW91dC52MS5DcmVhdGVMYXlvdX'
    'RSZXF1ZXN0Gh8ubGF5b3V0LnYxLkNyZWF0ZUxheW91dFJlc3BvbnNlEkYKCUdldExheW91dBIb'
    'LmxheW91dC52MS5HZXRMYXlvdXRSZXF1ZXN0GhwubGF5b3V0LnYxLkdldExheW91dFJlc3Bvbn'
    'NlEkwKC0xpc3RMYXlvdXRzEh0ubGF5b3V0LnYxLkxpc3RMYXlvdXRzUmVxdWVzdBoeLmxheW91'
    'dC52MS5MaXN0TGF5b3V0c1Jlc3BvbnNlEk8KDERlbGV0ZUxheW91dBIeLmxheW91dC52MS5EZW'
    'xldGVMYXlvdXRSZXF1ZXN0Gh8ubGF5b3V0LnYxLkRlbGV0ZUxheW91dFJlc3BvbnNlElUKDlBs'
    'YWNlQ29tcG9uZW50EiAubGF5b3V0LnYxLlBsYWNlQ29tcG9uZW50UmVxdWVzdBohLmxheW91dC'
    '52MS5QbGFjZUNvbXBvbmVudFJlc3BvbnNlElIKDU1vdmVDb21wb25lbnQSHy5sYXlvdXQudjEu'
    'TW92ZUNvbXBvbmVudFJlcXVlc3QaIC5sYXlvdXQudjEuTW92ZUNvbXBvbmVudFJlc3BvbnNlEl'
    'gKD1JlbW92ZUNvbXBvbmVudBIhLmxheW91dC52MS5SZW1vdmVDb21wb25lbnRSZXF1ZXN0GiIu'
    'bGF5b3V0LnYxLlJlbW92ZUNvbXBvbmVudFJlc3BvbnNlElUKDkxpc3RDb21wb25lbnRzEiAubG'
    'F5b3V0LnYxLkxpc3RDb21wb25lbnRzUmVxdWVzdBohLmxheW91dC52MS5MaXN0Q29tcG9uZW50'
    'c1Jlc3BvbnNlEmEKEkdlbmVyYXRlUGFuZWxBcnJheRIkLmxheW91dC52MS5HZW5lcmF0ZVBhbm'
    'VsQXJyYXlSZXF1ZXN0GiUubGF5b3V0LnYxLkdlbmVyYXRlUGFuZWxBcnJheVJlc3BvbnNlEkMK'
    'CEdldFRpbGVzEhoubGF5b3V0LnYxLkdldFRpbGVzUmVxdWVzdBobLmxheW91dC52MS5HZXRUaW'
    'xlc1Jlc3BvbnNlElIKDUdldFRpbGVQYW5lbHMSHy5sYXlvdXQudjEuR2V0VGlsZVBhbmVsc1Jl'
    'cXVlc3QaIC5sYXlvdXQudjEuR2V0VGlsZVBhbmVsc1Jlc3BvbnNlEmoKFVN1Ym1pdExheW91dE'
    'ZvclJldmlldxInLmxheW91dC52MS5TdWJtaXRMYXlvdXRGb3JSZXZpZXdSZXF1ZXN0GigubGF5'
    'b3V0LnYxLlN1Ym1pdExheW91dEZvclJldmlld1Jlc3BvbnNlElIKDUFwcHJvdmVMYXlvdXQSHy'
    '5sYXlvdXQudjEuQXBwcm92ZUxheW91dFJlcXVlc3QaIC5sYXlvdXQudjEuQXBwcm92ZUxheW91'
    'dFJlc3BvbnNlEk8KDFJlamVjdExheW91dBIeLmxheW91dC52MS5SZWplY3RMYXlvdXRSZXF1ZX'
    'N0Gh8ubGF5b3V0LnYxLlJlamVjdExheW91dFJlc3BvbnNl');

