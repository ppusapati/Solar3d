//
//  Generated code. Do not modify.
//  source: transmission/v1/transmission.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../google/protobuf/field_mask.pbjson.dart' as $2;
import '../../google/protobuf/timestamp.pbjson.dart' as $0;
import '../../packages/pagination.pbjson.dart' as $1;

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

@$core.Deprecated('Use voltageClassDescriptor instead')
const VoltageClass$json = {
  '1': 'VoltageClass',
  '2': [
    {'1': 'VOLTAGE_CLASS_UNSPECIFIED', '2': 0},
    {'1': 'VOLTAGE_CLASS_11KV', '2': 1},
    {'1': 'VOLTAGE_CLASS_33KV', '2': 2},
    {'1': 'VOLTAGE_CLASS_HT_66KV', '2': 3},
    {'1': 'VOLTAGE_CLASS_HT_132KV', '2': 4},
    {'1': 'VOLTAGE_CLASS_HT_220KV', '2': 5},
    {'1': 'VOLTAGE_CLASS_HT_400KV', '2': 6},
  ],
};

/// Descriptor for `VoltageClass`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List voltageClassDescriptor = $convert.base64Decode(
    'CgxWb2x0YWdlQ2xhc3MSHQoZVk9MVEFHRV9DTEFTU19VTlNQRUNJRklFRBAAEhYKElZPTFRBR0'
    'VfQ0xBU1NfMTFLVhABEhYKElZPTFRBR0VfQ0xBU1NfMzNLVhACEhkKFVZPTFRBR0VfQ0xBU1Nf'
    'SFRfNjZLVhADEhoKFlZPTFRBR0VfQ0xBU1NfSFRfMTMyS1YQBBIaChZWT0xUQUdFX0NMQVNTX0'
    'hUXzIyMEtWEAUSGgoWVk9MVEFHRV9DTEFTU19IVF80MDBLVhAG');

@$core.Deprecated('Use approvalStatusDescriptor instead')
const ApprovalStatus$json = {
  '1': 'ApprovalStatus',
  '2': [
    {'1': 'APPROVAL_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'APPROVAL_STATUS_DRAFT', '2': 1},
    {'1': 'APPROVAL_STATUS_ENGINEERING_REVIEW', '2': 2},
    {'1': 'APPROVAL_STATUS_APPROVED', '2': 3},
    {'1': 'APPROVAL_STATUS_REJECTED', '2': 4},
  ],
};

/// Descriptor for `ApprovalStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List approvalStatusDescriptor = $convert.base64Decode(
    'Cg5BcHByb3ZhbFN0YXR1cxIfChtBUFBST1ZBTF9TVEFUVVNfVU5TUEVDSUZJRUQQABIZChVBUF'
    'BST1ZBTF9TVEFUVVNfRFJBRlQQARImCiJBUFBST1ZBTF9TVEFUVVNfRU5HSU5FRVJJTkdfUkVW'
    'SUVXEAISHAoYQVBQUk9WQUxfU1RBVFVTX0FQUFJPVkVEEAMSHAoYQVBQUk9WQUxfU1RBVFVTX1'
    'JFSkVDVEVEEAQ=');

@$core.Deprecated('Use installationModeDescriptor instead')
const InstallationMode$json = {
  '1': 'InstallationMode',
  '2': [
    {'1': 'INSTALLATION_MODE_UNSPECIFIED', '2': 0},
    {'1': 'INSTALLATION_MODE_OVERHEAD', '2': 1},
    {'1': 'INSTALLATION_MODE_UNDERGROUND', '2': 2},
  ],
};

/// Descriptor for `InstallationMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List installationModeDescriptor = $convert.base64Decode(
    'ChBJbnN0YWxsYXRpb25Nb2RlEiEKHUlOU1RBTExBVElPTl9NT0RFX1VOU1BFQ0lGSUVEEAASHg'
    'oaSU5TVEFMTEFUSU9OX01PREVfT1ZFUkhFQUQQARIhCh1JTlNUQUxMQVRJT05fTU9ERV9VTkRF'
    'UkdST1VORBAC');

@$core.Deprecated('Use reviewMetadataDescriptor instead')
const ReviewMetadata$json = {
  '1': 'ReviewMetadata',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.transmission.v1.AcceptanceStatus', '10': 'status'},
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
    'Cg5SZXZpZXdNZXRhZGF0YRI5CgZzdGF0dXMYASABKA4yIS50cmFuc21pc3Npb24udjEuQWNjZX'
    'B0YW5jZVN0YXR1c1IGc3RhdHVzEi8KFHJldmlld2VkX2J5X2FjdG9yX2lkGAIgASgJUhFyZXZp'
    'ZXdlZEJ5QWN0b3JJZBI7CgtyZXZpZXdlZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW'
    '1lc3RhbXBSCnJldmlld2VkQXQSIwoNcXVhbGl0eV9zY29yZRgEIAEoAVIMcXVhbGl0eVNjb3Jl'
    'EicKD3Jldmlld19jb21tZW50cxgFIAMoCVIOcmV2aWV3Q29tbWVudHMSGgoIYmxvY2tlcnMYBi'
    'ADKAlSCGJsb2NrZXJzEj8KHGFwcHJvdmFsX3RpbWVzdGFtcF91bml4X3NlY3MYByABKAlSGWFw'
    'cHJvdmFsVGltZXN0YW1wVW5peFNlY3M=');

@$core.Deprecated('Use waypointDescriptor instead')
const Waypoint$json = {
  '1': 'Waypoint',
  '2': [
    {'1': 'longitude', '3': 1, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'latitude', '3': 2, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'elevation', '3': 3, '4': 1, '5': 1, '10': 'elevation'},
  ],
};

/// Descriptor for `Waypoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List waypointDescriptor = $convert.base64Decode(
    'CghXYXlwb2ludBIcCglsb25naXR1ZGUYASABKAFSCWxvbmdpdHVkZRIaCghsYXRpdHVkZRgCIA'
    'EoAVIIbGF0aXR1ZGUSHAoJZWxldmF0aW9uGAMgASgBUgllbGV2YXRpb24=');

@$core.Deprecated('Use transmissionConstraintsDescriptor instead')
const TransmissionConstraints$json = {
  '1': 'TransmissionConstraints',
  '2': [
    {'1': 'min_span_m', '3': 1, '4': 1, '5': 1, '10': 'minSpanM'},
    {'1': 'max_span_m', '3': 2, '4': 1, '5': 1, '10': 'maxSpanM'},
    {'1': 'row_width_m', '3': 3, '4': 1, '5': 1, '10': 'rowWidthM'},
    {'1': 'max_slope_deg', '3': 4, '4': 1, '5': 1, '10': 'maxSlopeDeg'},
    {'1': 'slope_penalty_factor', '3': 5, '4': 1, '5': 1, '10': 'slopePenaltyFactor'},
    {'1': 'water_crossing_cost_mult', '3': 6, '4': 1, '5': 1, '10': 'waterCrossingCostMult'},
    {'1': 'road_parallel_discount', '3': 7, '4': 1, '5': 1, '10': 'roadParallelDiscount'},
    {'1': 'max_deflection_deg', '3': 8, '4': 1, '5': 1, '10': 'maxDeflectionDeg'},
    {'1': 'turn_penalty_factor', '3': 9, '4': 1, '5': 1, '10': 'turnPenaltyFactor'},
    {'1': 'off_road_penalty', '3': 10, '4': 1, '5': 1, '10': 'offRoadPenalty'},
    {'1': 'road_buffer_m', '3': 11, '4': 1, '5': 1, '10': 'roadBufferM'},
  ],
};

/// Descriptor for `TransmissionConstraints`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transmissionConstraintsDescriptor = $convert.base64Decode(
    'ChdUcmFuc21pc3Npb25Db25zdHJhaW50cxIcCgptaW5fc3Bhbl9tGAEgASgBUghtaW5TcGFuTR'
    'IcCgptYXhfc3Bhbl9tGAIgASgBUghtYXhTcGFuTRIeCgtyb3dfd2lkdGhfbRgDIAEoAVIJcm93'
    'V2lkdGhNEiIKDW1heF9zbG9wZV9kZWcYBCABKAFSC21heFNsb3BlRGVnEjAKFHNsb3BlX3Blbm'
    'FsdHlfZmFjdG9yGAUgASgBUhJzbG9wZVBlbmFsdHlGYWN0b3ISNwoYd2F0ZXJfY3Jvc3Npbmdf'
    'Y29zdF9tdWx0GAYgASgBUhV3YXRlckNyb3NzaW5nQ29zdE11bHQSNAoWcm9hZF9wYXJhbGxlbF'
    '9kaXNjb3VudBgHIAEoAVIUcm9hZFBhcmFsbGVsRGlzY291bnQSLAoSbWF4X2RlZmxlY3Rpb25f'
    'ZGVnGAggASgBUhBtYXhEZWZsZWN0aW9uRGVnEi4KE3R1cm5fcGVuYWx0eV9mYWN0b3IYCSABKA'
    'FSEXR1cm5QZW5hbHR5RmFjdG9yEigKEG9mZl9yb2FkX3BlbmFsdHkYCiABKAFSDm9mZlJvYWRQ'
    'ZW5hbHR5EiIKDXJvYWRfYnVmZmVyX20YCyABKAFSC3JvYWRCdWZmZXJN');

@$core.Deprecated('Use elevationRasterInputDescriptor instead')
const ElevationRasterInput$json = {
  '1': 'ElevationRasterInput',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 5, '10': 'height'},
    {'1': 'cell_size_m', '3': 3, '4': 1, '5': 1, '10': 'cellSizeM'},
    {'1': 'origin_longitude', '3': 4, '4': 1, '5': 1, '10': 'originLongitude'},
    {'1': 'origin_latitude', '3': 5, '4': 1, '5': 1, '10': 'originLatitude'},
    {'1': 'elevations', '3': 6, '4': 3, '5': 1, '10': 'elevations'},
  ],
};

/// Descriptor for `ElevationRasterInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List elevationRasterInputDescriptor = $convert.base64Decode(
    'ChRFbGV2YXRpb25SYXN0ZXJJbnB1dBIUCgV3aWR0aBgBIAEoBVIFd2lkdGgSFgoGaGVpZ2h0GA'
    'IgASgFUgZoZWlnaHQSHgoLY2VsbF9zaXplX20YAyABKAFSCWNlbGxTaXplTRIpChBvcmlnaW5f'
    'bG9uZ2l0dWRlGAQgASgBUg9vcmlnaW5Mb25naXR1ZGUSJwoPb3JpZ2luX2xhdGl0dWRlGAUgAS'
    'gBUg5vcmlnaW5MYXRpdHVkZRIeCgplbGV2YXRpb25zGAYgAygBUgplbGV2YXRpb25z');

@$core.Deprecated('Use obstacleRasterInputDescriptor instead')
const ObstacleRasterInput$json = {
  '1': 'ObstacleRasterInput',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 5, '10': 'height'},
    {'1': 'cell_size_m', '3': 3, '4': 1, '5': 1, '10': 'cellSizeM'},
    {'1': 'origin_longitude', '3': 4, '4': 1, '5': 1, '10': 'originLongitude'},
    {'1': 'origin_latitude', '3': 5, '4': 1, '5': 1, '10': 'originLatitude'},
    {'1': 'values', '3': 6, '4': 3, '5': 1, '10': 'values'},
  ],
};

/// Descriptor for `ObstacleRasterInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List obstacleRasterInputDescriptor = $convert.base64Decode(
    'ChNPYnN0YWNsZVJhc3RlcklucHV0EhQKBXdpZHRoGAEgASgFUgV3aWR0aBIWCgZoZWlnaHQYAi'
    'ABKAVSBmhlaWdodBIeCgtjZWxsX3NpemVfbRgDIAEoAVIJY2VsbFNpemVNEikKEG9yaWdpbl9s'
    'b25naXR1ZGUYBCABKAFSD29yaWdpbkxvbmdpdHVkZRInCg9vcmlnaW5fbGF0aXR1ZGUYBSABKA'
    'FSDm9yaWdpbkxhdGl0dWRlEhYKBnZhbHVlcxgGIAMoAVIGdmFsdWVz');

@$core.Deprecated('Use vectorFeatureInputDescriptor instead')
const VectorFeatureInput$json = {
  '1': 'VectorFeatureInput',
  '2': [
    {'1': 'feature_type', '3': 1, '4': 1, '5': 9, '10': 'featureType'},
    {'1': 'geometry_geojson', '3': 2, '4': 1, '5': 9, '10': 'geometryGeojson'},
    {'1': 'cost_multiplier', '3': 3, '4': 1, '5': 1, '10': 'costMultiplier'},
  ],
};

/// Descriptor for `VectorFeatureInput`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vectorFeatureInputDescriptor = $convert.base64Decode(
    'ChJWZWN0b3JGZWF0dXJlSW5wdXQSIQoMZmVhdHVyZV90eXBlGAEgASgJUgtmZWF0dXJlVHlwZR'
    'IpChBnZW9tZXRyeV9nZW9qc29uGAIgASgJUg9nZW9tZXRyeUdlb2pzb24SJwoPY29zdF9tdWx0'
    'aXBsaWVyGAMgASgBUg5jb3N0TXVsdGlwbGllcg==');

@$core.Deprecated('Use towerPositionDescriptor instead')
const TowerPosition$json = {
  '1': 'TowerPosition',
  '2': [
    {'1': 'longitude', '3': 1, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'latitude', '3': 2, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'elevation', '3': 3, '4': 1, '5': 1, '10': 'elevation'},
    {'1': 'span_to_next_m', '3': 4, '4': 1, '5': 1, '10': 'spanToNextM'},
    {'1': 'height_m', '3': 5, '4': 1, '5': 1, '10': 'heightM'},
  ],
};

/// Descriptor for `TowerPosition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List towerPositionDescriptor = $convert.base64Decode(
    'Cg1Ub3dlclBvc2l0aW9uEhwKCWxvbmdpdHVkZRgBIAEoAVIJbG9uZ2l0dWRlEhoKCGxhdGl0dW'
    'RlGAIgASgBUghsYXRpdHVkZRIcCgllbGV2YXRpb24YAyABKAFSCWVsZXZhdGlvbhIjCg5zcGFu'
    'X3RvX25leHRfbRgEIAEoAVILc3BhblRvTmV4dE0SGQoIaGVpZ2h0X20YBSABKAFSB2hlaWdodE'
    '0=');

@$core.Deprecated('Use segmentExplanationDescriptor instead')
const SegmentExplanation$json = {
  '1': 'SegmentExplanation',
  '2': [
    {'1': 'from_index', '3': 1, '4': 1, '5': 5, '10': 'fromIndex'},
    {'1': 'slope_deg', '3': 2, '4': 1, '5': 1, '10': 'slopeDeg'},
    {'1': 'land_type', '3': 3, '4': 1, '5': 9, '10': 'landType'},
    {'1': 'cost_multiplier', '3': 4, '4': 1, '5': 1, '10': 'costMultiplier'},
    {'1': 'decision_reason', '3': 5, '4': 1, '5': 9, '10': 'decisionReason'},
    {'1': 'installation_mode', '3': 6, '4': 1, '5': 14, '6': '.transmission.v1.InstallationMode', '10': 'installationMode'},
  ],
};

/// Descriptor for `SegmentExplanation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List segmentExplanationDescriptor = $convert.base64Decode(
    'ChJTZWdtZW50RXhwbGFuYXRpb24SHQoKZnJvbV9pbmRleBgBIAEoBVIJZnJvbUluZGV4EhsKCX'
    'Nsb3BlX2RlZxgCIAEoAVIIc2xvcGVEZWcSGwoJbGFuZF90eXBlGAMgASgJUghsYW5kVHlwZRIn'
    'Cg9jb3N0X211bHRpcGxpZXIYBCABKAFSDmNvc3RNdWx0aXBsaWVyEicKD2RlY2lzaW9uX3JlYX'
    'NvbhgFIAEoCVIOZGVjaXNpb25SZWFzb24STgoRaW5zdGFsbGF0aW9uX21vZGUYBiABKA4yIS50'
    'cmFuc21pc3Npb24udjEuSW5zdGFsbGF0aW9uTW9kZVIQaW5zdGFsbGF0aW9uTW9kZQ==');

@$core.Deprecated('Use costBreakdownDescriptor instead')
const CostBreakdown$json = {
  '1': 'CostBreakdown',
  '2': [
    {'1': 'conductor_cost', '3': 1, '4': 1, '5': 1, '10': 'conductorCost'},
    {'1': 'tower_cost', '3': 2, '4': 1, '5': 1, '10': 'towerCost'},
    {'1': 'row_acquisition_cost', '3': 3, '4': 1, '5': 1, '10': 'rowAcquisitionCost'},
    {'1': 'crossing_premium', '3': 4, '4': 1, '5': 1, '10': 'crossingPremium'},
    {'1': 'total_cost', '3': 5, '4': 1, '5': 1, '10': 'totalCost'},
    {'1': 'cost_per_km', '3': 6, '4': 1, '5': 1, '10': 'costPerKm'},
  ],
};

/// Descriptor for `CostBreakdown`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List costBreakdownDescriptor = $convert.base64Decode(
    'Cg1Db3N0QnJlYWtkb3duEiUKDmNvbmR1Y3Rvcl9jb3N0GAEgASgBUg1jb25kdWN0b3JDb3N0Eh'
    '0KCnRvd2VyX2Nvc3QYAiABKAFSCXRvd2VyQ29zdBIwChRyb3dfYWNxdWlzaXRpb25fY29zdBgD'
    'IAEoAVIScm93QWNxdWlzaXRpb25Db3N0EikKEGNyb3NzaW5nX3ByZW1pdW0YBCABKAFSD2Nyb3'
    'NzaW5nUHJlbWl1bRIdCgp0b3RhbF9jb3N0GAUgASgBUgl0b3RhbENvc3QSHgoLY29zdF9wZXJf'
    'a20YBiABKAFSCWNvc3RQZXJLbQ==');

@$core.Deprecated('Use routeScoreDescriptor instead')
const RouteScore$json = {
  '1': 'RouteScore',
  '2': [
    {'1': 'cost_score', '3': 1, '4': 1, '5': 1, '10': 'costScore'},
    {'1': 'risk_score', '3': 2, '4': 1, '5': 1, '10': 'riskScore'},
    {'1': 'constructability_score', '3': 3, '4': 1, '5': 1, '10': 'constructabilityScore'},
    {'1': 'schedule_score', '3': 4, '4': 1, '5': 1, '10': 'scheduleScore'},
    {'1': 'composite_score', '3': 5, '4': 1, '5': 1, '10': 'compositeScore'},
    {'1': 'pareto_frontier', '3': 6, '4': 1, '5': 8, '10': 'paretoFrontier'},
    {'1': 'recommendation_reason', '3': 7, '4': 1, '5': 9, '10': 'recommendationReason'},
    {'1': 'dimension_reasons', '3': 8, '4': 3, '5': 11, '6': '.transmission.v1.RouteScore.DimensionReasonsEntry', '10': 'dimensionReasons'},
  ],
  '3': [RouteScore_DimensionReasonsEntry$json],
};

@$core.Deprecated('Use routeScoreDescriptor instead')
const RouteScore_DimensionReasonsEntry$json = {
  '1': 'DimensionReasonsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `RouteScore`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List routeScoreDescriptor = $convert.base64Decode(
    'CgpSb3V0ZVNjb3JlEh0KCmNvc3Rfc2NvcmUYASABKAFSCWNvc3RTY29yZRIdCgpyaXNrX3Njb3'
    'JlGAIgASgBUglyaXNrU2NvcmUSNQoWY29uc3RydWN0YWJpbGl0eV9zY29yZRgDIAEoAVIVY29u'
    'c3RydWN0YWJpbGl0eVNjb3JlEiUKDnNjaGVkdWxlX3Njb3JlGAQgASgBUg1zY2hlZHVsZVNjb3'
    'JlEicKD2NvbXBvc2l0ZV9zY29yZRgFIAEoAVIOY29tcG9zaXRlU2NvcmUSJwoPcGFyZXRvX2Zy'
    'b250aWVyGAYgASgIUg5wYXJldG9Gcm9udGllchIzChVyZWNvbW1lbmRhdGlvbl9yZWFzb24YBy'
    'ABKAlSFHJlY29tbWVuZGF0aW9uUmVhc29uEl4KEWRpbWVuc2lvbl9yZWFzb25zGAggAygLMjEu'
    'dHJhbnNtaXNzaW9uLnYxLlJvdXRlU2NvcmUuRGltZW5zaW9uUmVhc29uc0VudHJ5UhBkaW1lbn'
    'Npb25SZWFzb25zGkMKFURpbWVuc2lvblJlYXNvbnNFbnRyeRIQCgNrZXkYASABKAlSA2tleRIU'
    'CgV2YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use governanceEventDescriptor instead')
const GovernanceEvent$json = {
  '1': 'GovernanceEvent',
  '2': [
    {'1': 'event_type', '3': 1, '4': 1, '5': 9, '10': 'eventType'},
    {'1': 'actor', '3': 2, '4': 1, '5': 9, '10': 'actor'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
    {'1': 'from_status', '3': 4, '4': 1, '5': 14, '6': '.transmission.v1.ApprovalStatus', '10': 'fromStatus'},
    {'1': 'to_status', '3': 5, '4': 1, '5': 14, '6': '.transmission.v1.ApprovalStatus', '10': 'toStatus'},
    {'1': 'occurred_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'occurredAt'},
  ],
};

/// Descriptor for `GovernanceEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List governanceEventDescriptor = $convert.base64Decode(
    'Cg9Hb3Zlcm5hbmNlRXZlbnQSHQoKZXZlbnRfdHlwZRgBIAEoCVIJZXZlbnRUeXBlEhQKBWFjdG'
    '9yGAIgASgJUgVhY3RvchISCgRub3RlGAMgASgJUgRub3RlEkAKC2Zyb21fc3RhdHVzGAQgASgO'
    'Mh8udHJhbnNtaXNzaW9uLnYxLkFwcHJvdmFsU3RhdHVzUgpmcm9tU3RhdHVzEjwKCXRvX3N0YX'
    'R1cxgFIAEoDjIfLnRyYW5zbWlzc2lvbi52MS5BcHByb3ZhbFN0YXR1c1IIdG9TdGF0dXMSOwoL'
    'b2NjdXJyZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgpvY2N1cnJlZE'
    'F0');

@$core.Deprecated('Use traceabilityBundleDescriptor instead')
const TraceabilityBundle$json = {
  '1': 'TraceabilityBundle',
  '2': [
    {'1': 'algorithm_version', '3': 1, '4': 1, '5': 9, '10': 'algorithmVersion'},
    {'1': 'input_fingerprint', '3': 2, '4': 1, '5': 9, '10': 'inputFingerprint'},
    {'1': 'route_fingerprint', '3': 3, '4': 1, '5': 9, '10': 'routeFingerprint'},
    {'1': 'regression_signature', '3': 4, '4': 1, '5': 9, '10': 'regressionSignature'},
    {'1': 'request_snapshot_json', '3': 5, '4': 1, '5': 9, '10': 'requestSnapshotJson'},
    {'1': 'data_snapshot_id', '3': 6, '4': 1, '5': 9, '10': 'dataSnapshotId'},
    {'1': 'approved_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'approvedAt'},
    {'1': 'approved_by', '3': 8, '4': 1, '5': 9, '10': 'approvedBy'},
  ],
};

/// Descriptor for `TraceabilityBundle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List traceabilityBundleDescriptor = $convert.base64Decode(
    'ChJUcmFjZWFiaWxpdHlCdW5kbGUSKwoRYWxnb3JpdGhtX3ZlcnNpb24YASABKAlSEGFsZ29yaX'
    'RobVZlcnNpb24SKwoRaW5wdXRfZmluZ2VycHJpbnQYAiABKAlSEGlucHV0RmluZ2VycHJpbnQS'
    'KwoRcm91dGVfZmluZ2VycHJpbnQYAyABKAlSEHJvdXRlRmluZ2VycHJpbnQSMQoUcmVncmVzc2'
    'lvbl9zaWduYXR1cmUYBCABKAlSE3JlZ3Jlc3Npb25TaWduYXR1cmUSMgoVcmVxdWVzdF9zbmFw'
    'c2hvdF9qc29uGAUgASgJUhNyZXF1ZXN0U25hcHNob3RKc29uEigKEGRhdGFfc25hcHNob3RfaW'
    'QYBiABKAlSDmRhdGFTbmFwc2hvdElkEjsKC2FwcHJvdmVkX2F0GAcgASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIKYXBwcm92ZWRBdBIfCgthcHByb3ZlZF9ieRgIIAEoCVIKYXBwcm'
    '92ZWRCeQ==');

@$core.Deprecated('Use towerScheduleEntryDescriptor instead')
const TowerScheduleEntry$json = {
  '1': 'TowerScheduleEntry',
  '2': [
    {'1': 'sequence', '3': 1, '4': 1, '5': 5, '10': 'sequence'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'latitude', '3': 3, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'elevation', '3': 4, '4': 1, '5': 1, '10': 'elevation'},
    {'1': 'span_to_next_m', '3': 5, '4': 1, '5': 1, '10': 'spanToNextM'},
    {'1': 'height_m', '3': 6, '4': 1, '5': 1, '10': 'heightM'},
    {'1': 'structure_type', '3': 7, '4': 1, '5': 9, '10': 'structureType'},
  ],
};

/// Descriptor for `TowerScheduleEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List towerScheduleEntryDescriptor = $convert.base64Decode(
    'ChJUb3dlclNjaGVkdWxlRW50cnkSGgoIc2VxdWVuY2UYASABKAVSCHNlcXVlbmNlEhwKCWxvbm'
    'dpdHVkZRgCIAEoAVIJbG9uZ2l0dWRlEhoKCGxhdGl0dWRlGAMgASgBUghsYXRpdHVkZRIcCgll'
    'bGV2YXRpb24YBCABKAFSCWVsZXZhdGlvbhIjCg5zcGFuX3RvX25leHRfbRgFIAEoAVILc3Bhbl'
    'RvTmV4dE0SGQoIaGVpZ2h0X20YBiABKAFSB2hlaWdodE0SJQoOc3RydWN0dXJlX3R5cGUYByAB'
    'KAlSDXN0cnVjdHVyZVR5cGU=');

@$core.Deprecated('Use undergroundChainageEntryDescriptor instead')
const UndergroundChainageEntry$json = {
  '1': 'UndergroundChainageEntry',
  '2': [
    {'1': 'segment_index', '3': 1, '4': 1, '5': 5, '10': 'segmentIndex'},
    {'1': 'start_chainage_m', '3': 2, '4': 1, '5': 1, '10': 'startChainageM'},
    {'1': 'end_chainage_m', '3': 3, '4': 1, '5': 1, '10': 'endChainageM'},
    {'1': 'length_m', '3': 4, '4': 1, '5': 1, '10': 'lengthM'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `UndergroundChainageEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List undergroundChainageEntryDescriptor = $convert.base64Decode(
    'ChhVbmRlcmdyb3VuZENoYWluYWdlRW50cnkSIwoNc2VnbWVudF9pbmRleBgBIAEoBVIMc2VnbW'
    'VudEluZGV4EigKEHN0YXJ0X2NoYWluYWdlX20YAiABKAFSDnN0YXJ0Q2hhaW5hZ2VNEiQKDmVu'
    'ZF9jaGFpbmFnZV9tGAMgASgBUgxlbmRDaGFpbmFnZU0SGQoIbGVuZ3RoX20YBCABKAFSB2xlbm'
    'd0aE0SFgoGcmVhc29uGAUgASgJUgZyZWFzb24=');

@$core.Deprecated('Use costBookEntryDescriptor instead')
const CostBookEntry$json = {
  '1': 'CostBookEntry',
  '2': [
    {'1': 'category', '3': 1, '4': 1, '5': 9, '10': 'category'},
    {'1': 'subcategory', '3': 2, '4': 1, '5': 9, '10': 'subcategory'},
    {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
    {'1': 'basis', '3': 4, '4': 1, '5': 9, '10': 'basis'},
  ],
};

/// Descriptor for `CostBookEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List costBookEntryDescriptor = $convert.base64Decode(
    'Cg1Db3N0Qm9va0VudHJ5EhoKCGNhdGVnb3J5GAEgASgJUghjYXRlZ29yeRIgCgtzdWJjYXRlZ2'
    '9yeRgCIAEoCVILc3ViY2F0ZWdvcnkSFgoGYW1vdW50GAMgASgBUgZhbW91bnQSFAoFYmFzaXMY'
    'BCABKAlSBWJhc2lz');

@$core.Deprecated('Use transmissionRouteExportPackDescriptor instead')
const TransmissionRouteExportPack$json = {
  '1': 'TransmissionRouteExportPack',
  '2': [
    {'1': 'route', '3': 1, '4': 1, '5': 11, '6': '.transmission.v1.TransmissionRoute', '10': 'route'},
    {'1': 'tower_schedule', '3': 2, '4': 3, '5': 11, '6': '.transmission.v1.TowerScheduleEntry', '10': 'towerSchedule'},
    {'1': 'underground_chainage', '3': 3, '4': 3, '5': 11, '6': '.transmission.v1.UndergroundChainageEntry', '10': 'undergroundChainage'},
    {'1': 'cost_book', '3': 4, '4': 3, '5': 11, '6': '.transmission.v1.CostBookEntry', '10': 'costBook'},
    {'1': 'traceability', '3': 5, '4': 1, '5': 11, '6': '.transmission.v1.TraceabilityBundle', '10': 'traceability'},
    {'1': 'generated_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'generatedAt'},
    {'1': 'generated_by', '3': 7, '4': 1, '5': 9, '10': 'generatedBy'},
  ],
};

/// Descriptor for `TransmissionRouteExportPack`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transmissionRouteExportPackDescriptor = $convert.base64Decode(
    'ChtUcmFuc21pc3Npb25Sb3V0ZUV4cG9ydFBhY2sSOAoFcm91dGUYASABKAsyIi50cmFuc21pc3'
    'Npb24udjEuVHJhbnNtaXNzaW9uUm91dGVSBXJvdXRlEkoKDnRvd2VyX3NjaGVkdWxlGAIgAygL'
    'MiMudHJhbnNtaXNzaW9uLnYxLlRvd2VyU2NoZWR1bGVFbnRyeVINdG93ZXJTY2hlZHVsZRJcCh'
    'R1bmRlcmdyb3VuZF9jaGFpbmFnZRgDIAMoCzIpLnRyYW5zbWlzc2lvbi52MS5VbmRlcmdyb3Vu'
    'ZENoYWluYWdlRW50cnlSE3VuZGVyZ3JvdW5kQ2hhaW5hZ2USOwoJY29zdF9ib29rGAQgAygLMh'
    '4udHJhbnNtaXNzaW9uLnYxLkNvc3RCb29rRW50cnlSCGNvc3RCb29rEkcKDHRyYWNlYWJpbGl0'
    'eRgFIAEoCzIjLnRyYW5zbWlzc2lvbi52MS5UcmFjZWFiaWxpdHlCdW5kbGVSDHRyYWNlYWJpbG'
    'l0eRI9CgxnZW5lcmF0ZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgtn'
    'ZW5lcmF0ZWRBdBIhCgxnZW5lcmF0ZWRfYnkYByABKAlSC2dlbmVyYXRlZEJ5');

@$core.Deprecated('Use transmissionRouteDescriptor instead')
const TransmissionRoute$json = {
  '1': 'TransmissionRoute',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'voltage_class', '3': 4, '4': 1, '5': 14, '6': '.transmission.v1.VoltageClass', '10': 'voltageClass'},
    {'1': 'path_geojson', '3': 5, '4': 1, '5': 9, '10': 'pathGeojson'},
    {'1': 'farm_output_point', '3': 6, '4': 1, '5': 11, '6': '.transmission.v1.Waypoint', '10': 'farmOutputPoint'},
    {'1': 'grid_injection_point', '3': 7, '4': 1, '5': 11, '6': '.transmission.v1.Waypoint', '10': 'gridInjectionPoint'},
    {'1': 'tower_positions', '3': 8, '4': 3, '5': 11, '6': '.transmission.v1.TowerPosition', '10': 'towerPositions'},
    {'1': 'distance_m', '3': 9, '4': 1, '5': 1, '10': 'distanceM'},
    {'1': 'cost_breakdown', '3': 10, '4': 1, '5': 11, '6': '.transmission.v1.CostBreakdown', '10': 'costBreakdown'},
    {'1': 'route_score', '3': 14, '4': 1, '5': 11, '6': '.transmission.v1.RouteScore', '10': 'routeScore'},
    {'1': 'segment_explanations', '3': 11, '4': 3, '5': 11, '6': '.transmission.v1.SegmentExplanation', '10': 'segmentExplanations'},
    {'1': 'route_summary', '3': 12, '4': 1, '5': 9, '10': 'routeSummary'},
    {'1': 'created_at', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'approval_status', '3': 15, '4': 1, '5': 14, '6': '.transmission.v1.ApprovalStatus', '10': 'approvalStatus'},
    {'1': 'engineering_reviewed_at', '3': 16, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'engineeringReviewedAt'},
    {'1': 'engineering_reviewed_by', '3': 17, '4': 1, '5': 9, '10': 'engineeringReviewedBy'},
    {'1': 'approved_at', '3': 18, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'approvedAt'},
    {'1': 'approved_by', '3': 19, '4': 1, '5': 9, '10': 'approvedBy'},
    {'1': 'governance_events', '3': 20, '4': 3, '5': 11, '6': '.transmission.v1.GovernanceEvent', '10': 'governanceEvents'},
    {'1': 'electrical_network_id', '3': 21, '4': 1, '5': 9, '10': 'electricalNetworkId'},
    {'1': 'review_metadata', '3': 22, '4': 1, '5': 11, '6': '.transmission.v1.ReviewMetadata', '10': 'reviewMetadata'},
    {'1': 'protection_devices', '3': 23, '4': 3, '5': 9, '10': 'protectionDevices'},
    {'1': 'fault_isolation_points', '3': 24, '4': 1, '5': 5, '10': 'faultIsolationPoints'},
    {'1': 'route_conflicts', '3': 25, '4': 3, '5': 9, '10': 'routeConflicts'},
    {'1': 'route_feasibility_score', '3': 26, '4': 1, '5': 1, '10': 'routeFeasibilityScore'},
  ],
};

/// Descriptor for `TransmissionRoute`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transmissionRouteDescriptor = $convert.base64Decode(
    'ChFUcmFuc21pc3Npb25Sb3V0ZRIOCgJpZBgBIAEoCVICaWQSHQoKcHJvamVjdF9pZBgCIAEoCV'
    'IJcHJvamVjdElkEhIKBG5hbWUYAyABKAlSBG5hbWUSQgoNdm9sdGFnZV9jbGFzcxgEIAEoDjId'
    'LnRyYW5zbWlzc2lvbi52MS5Wb2x0YWdlQ2xhc3NSDHZvbHRhZ2VDbGFzcxIhCgxwYXRoX2dlb2'
    'pzb24YBSABKAlSC3BhdGhHZW9qc29uEkUKEWZhcm1fb3V0cHV0X3BvaW50GAYgASgLMhkudHJh'
    'bnNtaXNzaW9uLnYxLldheXBvaW50Ug9mYXJtT3V0cHV0UG9pbnQSSwoUZ3JpZF9pbmplY3Rpb2'
    '5fcG9pbnQYByABKAsyGS50cmFuc21pc3Npb24udjEuV2F5cG9pbnRSEmdyaWRJbmplY3Rpb25Q'
    'b2ludBJHCg90b3dlcl9wb3NpdGlvbnMYCCADKAsyHi50cmFuc21pc3Npb24udjEuVG93ZXJQb3'
    'NpdGlvblIOdG93ZXJQb3NpdGlvbnMSHQoKZGlzdGFuY2VfbRgJIAEoAVIJZGlzdGFuY2VNEkUK'
    'DmNvc3RfYnJlYWtkb3duGAogASgLMh4udHJhbnNtaXNzaW9uLnYxLkNvc3RCcmVha2Rvd25SDW'
    'Nvc3RCcmVha2Rvd24SPAoLcm91dGVfc2NvcmUYDiABKAsyGy50cmFuc21pc3Npb24udjEuUm91'
    'dGVTY29yZVIKcm91dGVTY29yZRJWChRzZWdtZW50X2V4cGxhbmF0aW9ucxgLIAMoCzIjLnRyYW'
    '5zbWlzc2lvbi52MS5TZWdtZW50RXhwbGFuYXRpb25SE3NlZ21lbnRFeHBsYW5hdGlvbnMSIwoN'
    'cm91dGVfc3VtbWFyeRgMIAEoCVIMcm91dGVTdW1tYXJ5EjkKCmNyZWF0ZWRfYXQYDSABKAsyGi'
    '5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSSAoPYXBwcm92YWxfc3RhdHVz'
    'GA8gASgOMh8udHJhbnNtaXNzaW9uLnYxLkFwcHJvdmFsU3RhdHVzUg5hcHByb3ZhbFN0YXR1cx'
    'JSChdlbmdpbmVlcmluZ19yZXZpZXdlZF9hdBgQIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1l'
    'c3RhbXBSFWVuZ2luZWVyaW5nUmV2aWV3ZWRBdBI2ChdlbmdpbmVlcmluZ19yZXZpZXdlZF9ieR'
    'gRIAEoCVIVZW5naW5lZXJpbmdSZXZpZXdlZEJ5EjsKC2FwcHJvdmVkX2F0GBIgASgLMhouZ29v'
    'Z2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKYXBwcm92ZWRBdBIfCgthcHByb3ZlZF9ieRgTIAEoCV'
    'IKYXBwcm92ZWRCeRJNChFnb3Zlcm5hbmNlX2V2ZW50cxgUIAMoCzIgLnRyYW5zbWlzc2lvbi52'
    'MS5Hb3Zlcm5hbmNlRXZlbnRSEGdvdmVybmFuY2VFdmVudHMSMgoVZWxlY3RyaWNhbF9uZXR3b3'
    'JrX2lkGBUgASgJUhNlbGVjdHJpY2FsTmV0d29ya0lkEkgKD3Jldmlld19tZXRhZGF0YRgWIAEo'
    'CzIfLnRyYW5zbWlzc2lvbi52MS5SZXZpZXdNZXRhZGF0YVIOcmV2aWV3TWV0YWRhdGESLQoScH'
    'JvdGVjdGlvbl9kZXZpY2VzGBcgAygJUhFwcm90ZWN0aW9uRGV2aWNlcxI0ChZmYXVsdF9pc29s'
    'YXRpb25fcG9pbnRzGBggASgFUhRmYXVsdElzb2xhdGlvblBvaW50cxInCg9yb3V0ZV9jb25mbG'
    'ljdHMYGSADKAlSDnJvdXRlQ29uZmxpY3RzEjYKF3JvdXRlX2ZlYXNpYmlsaXR5X3Njb3JlGBog'
    'ASgBUhVyb3V0ZUZlYXNpYmlsaXR5U2NvcmU=');

@$core.Deprecated('Use calculateTransmissionRouteRequestDescriptor instead')
const CalculateTransmissionRouteRequest$json = {
  '1': 'CalculateTransmissionRouteRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'voltage_class', '3': 3, '4': 1, '5': 14, '6': '.transmission.v1.VoltageClass', '10': 'voltageClass'},
    {'1': 'farm_output_point', '3': 4, '4': 1, '5': 11, '6': '.transmission.v1.Waypoint', '10': 'farmOutputPoint'},
    {'1': 'grid_injection_point', '3': 5, '4': 1, '5': 11, '6': '.transmission.v1.Waypoint', '10': 'gridInjectionPoint'},
    {'1': 'constraints', '3': 6, '4': 1, '5': 11, '6': '.transmission.v1.TransmissionConstraints', '10': 'constraints'},
    {'1': 'elevation_raster', '3': 7, '4': 1, '5': 11, '6': '.transmission.v1.ElevationRasterInput', '10': 'elevationRaster'},
    {'1': 'obstacle_raster', '3': 8, '4': 1, '5': 11, '6': '.transmission.v1.ObstacleRasterInput', '10': 'obstacleRaster'},
    {'1': 'vector_features', '3': 9, '4': 3, '5': 11, '6': '.transmission.v1.VectorFeatureInput', '10': 'vectorFeatures'},
  ],
};

/// Descriptor for `CalculateTransmissionRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateTransmissionRouteRequestDescriptor = $convert.base64Decode(
    'CiFDYWxjdWxhdGVUcmFuc21pc3Npb25Sb3V0ZVJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCV'
    'IJcHJvamVjdElkEhIKBG5hbWUYAiABKAlSBG5hbWUSQgoNdm9sdGFnZV9jbGFzcxgDIAEoDjId'
    'LnRyYW5zbWlzc2lvbi52MS5Wb2x0YWdlQ2xhc3NSDHZvbHRhZ2VDbGFzcxJFChFmYXJtX291dH'
    'B1dF9wb2ludBgEIAEoCzIZLnRyYW5zbWlzc2lvbi52MS5XYXlwb2ludFIPZmFybU91dHB1dFBv'
    'aW50EksKFGdyaWRfaW5qZWN0aW9uX3BvaW50GAUgASgLMhkudHJhbnNtaXNzaW9uLnYxLldheX'
    'BvaW50UhJncmlkSW5qZWN0aW9uUG9pbnQSSgoLY29uc3RyYWludHMYBiABKAsyKC50cmFuc21p'
    'c3Npb24udjEuVHJhbnNtaXNzaW9uQ29uc3RyYWludHNSC2NvbnN0cmFpbnRzElAKEGVsZXZhdG'
    'lvbl9yYXN0ZXIYByABKAsyJS50cmFuc21pc3Npb24udjEuRWxldmF0aW9uUmFzdGVySW5wdXRS'
    'D2VsZXZhdGlvblJhc3RlchJNCg9vYnN0YWNsZV9yYXN0ZXIYCCABKAsyJC50cmFuc21pc3Npb2'
    '4udjEuT2JzdGFjbGVSYXN0ZXJJbnB1dFIOb2JzdGFjbGVSYXN0ZXISTAoPdmVjdG9yX2ZlYXR1'
    'cmVzGAkgAygLMiMudHJhbnNtaXNzaW9uLnYxLlZlY3RvckZlYXR1cmVJbnB1dFIOdmVjdG9yRm'
    'VhdHVyZXM=');

@$core.Deprecated('Use calculateTransmissionRouteResponseDescriptor instead')
const CalculateTransmissionRouteResponse$json = {
  '1': 'CalculateTransmissionRouteResponse',
  '2': [
    {'1': 'route', '3': 1, '4': 1, '5': 11, '6': '.transmission.v1.TransmissionRoute', '10': 'route'},
  ],
};

/// Descriptor for `CalculateTransmissionRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateTransmissionRouteResponseDescriptor = $convert.base64Decode(
    'CiJDYWxjdWxhdGVUcmFuc21pc3Npb25Sb3V0ZVJlc3BvbnNlEjgKBXJvdXRlGAEgASgLMiIudH'
    'JhbnNtaXNzaW9uLnYxLlRyYW5zbWlzc2lvblJvdXRlUgVyb3V0ZQ==');

@$core.Deprecated('Use streamTransmissionRouteRequestDescriptor instead')
const StreamTransmissionRouteRequest$json = {
  '1': 'StreamTransmissionRouteRequest',
  '2': [
    {'1': 'request', '3': 1, '4': 1, '5': 11, '6': '.transmission.v1.CalculateTransmissionRouteRequest', '10': 'request'},
  ],
};

/// Descriptor for `StreamTransmissionRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamTransmissionRouteRequestDescriptor = $convert.base64Decode(
    'Ch5TdHJlYW1UcmFuc21pc3Npb25Sb3V0ZVJlcXVlc3QSTAoHcmVxdWVzdBgBIAEoCzIyLnRyYW'
    '5zbWlzc2lvbi52MS5DYWxjdWxhdGVUcmFuc21pc3Npb25Sb3V0ZVJlcXVlc3RSB3JlcXVlc3Q=');

@$core.Deprecated('Use streamTransmissionRouteResponseDescriptor instead')
const StreamTransmissionRouteResponse$json = {
  '1': 'StreamTransmissionRouteResponse',
  '2': [
    {'1': 'phase', '3': 1, '4': 1, '5': 9, '10': 'phase'},
    {'1': 'percent_complete', '3': 2, '4': 1, '5': 5, '10': 'percentComplete'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
    {'1': 'route', '3': 4, '4': 1, '5': 11, '6': '.transmission.v1.TransmissionRoute', '10': 'route'},
  ],
};

/// Descriptor for `StreamTransmissionRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamTransmissionRouteResponseDescriptor = $convert.base64Decode(
    'Ch9TdHJlYW1UcmFuc21pc3Npb25Sb3V0ZVJlc3BvbnNlEhQKBXBoYXNlGAEgASgJUgVwaGFzZR'
    'IpChBwZXJjZW50X2NvbXBsZXRlGAIgASgFUg9wZXJjZW50Q29tcGxldGUSGAoHbWVzc2FnZRgD'
    'IAEoCVIHbWVzc2FnZRI4CgVyb3V0ZRgEIAEoCzIiLnRyYW5zbWlzc2lvbi52MS5UcmFuc21pc3'
    'Npb25Sb3V0ZVIFcm91dGU=');

@$core.Deprecated('Use getTransmissionRouteRequestDescriptor instead')
const GetTransmissionRouteRequest$json = {
  '1': 'GetTransmissionRouteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetTransmissionRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTransmissionRouteRequestDescriptor = $convert.base64Decode(
    'ChtHZXRUcmFuc21pc3Npb25Sb3V0ZVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use getTransmissionRouteResponseDescriptor instead')
const GetTransmissionRouteResponse$json = {
  '1': 'GetTransmissionRouteResponse',
  '2': [
    {'1': 'route', '3': 1, '4': 1, '5': 11, '6': '.transmission.v1.TransmissionRoute', '10': 'route'},
  ],
};

/// Descriptor for `GetTransmissionRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTransmissionRouteResponseDescriptor = $convert.base64Decode(
    'ChxHZXRUcmFuc21pc3Npb25Sb3V0ZVJlc3BvbnNlEjgKBXJvdXRlGAEgASgLMiIudHJhbnNtaX'
    'NzaW9uLnYxLlRyYW5zbWlzc2lvblJvdXRlUgVyb3V0ZQ==');

@$core.Deprecated('Use listTransmissionRoutesRequestDescriptor instead')
const ListTransmissionRoutesRequest$json = {
  '1': 'ListTransmissionRoutesRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `ListTransmissionRoutesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTransmissionRoutesRequestDescriptor = $convert.base64Decode(
    'Ch1MaXN0VHJhbnNtaXNzaW9uUm91dGVzUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm'
    '9qZWN0SWQSTQoKcGFnaW5hdGlvbhgCIAEoCzItLnBhY2thZ2VzLmFwaS52MS5wYWdpbmF0aW9u'
    'LlBhZ2luYXRpb25SZXF1ZXN0UgpwYWdpbmF0aW9u');

@$core.Deprecated('Use listTransmissionRoutesResponseDescriptor instead')
const ListTransmissionRoutesResponse$json = {
  '1': 'ListTransmissionRoutesResponse',
  '2': [
    {'1': 'routes', '3': 1, '4': 3, '5': 11, '6': '.transmission.v1.TransmissionRoute', '10': 'routes'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `ListTransmissionRoutesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTransmissionRoutesResponseDescriptor = $convert.base64Decode(
    'Ch5MaXN0VHJhbnNtaXNzaW9uUm91dGVzUmVzcG9uc2USOgoGcm91dGVzGAEgAygLMiIudHJhbn'
    'NtaXNzaW9uLnYxLlRyYW5zbWlzc2lvblJvdXRlUgZyb3V0ZXMSTgoKcGFnaW5hdGlvbhgCIAEo'
    'CzIuLnBhY2thZ2VzLmFwaS52MS5wYWdpbmF0aW9uLlBhZ2luYXRpb25SZXNwb25zZVIKcGFnaW'
    '5hdGlvbg==');

@$core.Deprecated('Use submitTransmissionRouteForReviewRequestDescriptor instead')
const SubmitTransmissionRouteForReviewRequest$json = {
  '1': 'SubmitTransmissionRouteForReviewRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'actor', '3': 2, '4': 1, '5': 9, '10': 'actor'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
    {'1': 'submission_reason', '3': 4, '4': 1, '5': 9, '10': 'submissionReason'},
  ],
};

/// Descriptor for `SubmitTransmissionRouteForReviewRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitTransmissionRouteForReviewRequestDescriptor = $convert.base64Decode(
    'CidTdWJtaXRUcmFuc21pc3Npb25Sb3V0ZUZvclJldmlld1JlcXVlc3QSDgoCaWQYASABKAlSAm'
    'lkEhQKBWFjdG9yGAIgASgJUgVhY3RvchISCgRub3RlGAMgASgJUgRub3RlEisKEXN1Ym1pc3Np'
    'b25fcmVhc29uGAQgASgJUhBzdWJtaXNzaW9uUmVhc29u');

@$core.Deprecated('Use submitTransmissionRouteForReviewResponseDescriptor instead')
const SubmitTransmissionRouteForReviewResponse$json = {
  '1': 'SubmitTransmissionRouteForReviewResponse',
  '2': [
    {'1': 'route', '3': 1, '4': 1, '5': 11, '6': '.transmission.v1.TransmissionRoute', '10': 'route'},
  ],
};

/// Descriptor for `SubmitTransmissionRouteForReviewResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitTransmissionRouteForReviewResponseDescriptor = $convert.base64Decode(
    'CihTdWJtaXRUcmFuc21pc3Npb25Sb3V0ZUZvclJldmlld1Jlc3BvbnNlEjgKBXJvdXRlGAEgAS'
    'gLMiIudHJhbnNtaXNzaW9uLnYxLlRyYW5zbWlzc2lvblJvdXRlUgVyb3V0ZQ==');

@$core.Deprecated('Use approveTransmissionRouteRequestDescriptor instead')
const ApproveTransmissionRouteRequest$json = {
  '1': 'ApproveTransmissionRouteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'actor', '3': 2, '4': 1, '5': 9, '10': 'actor'},
    {'1': 'note', '3': 3, '4': 1, '5': 9, '10': 'note'},
    {'1': 'quality_score', '3': 4, '4': 1, '5': 1, '10': 'qualityScore'},
    {'1': 'feasibility_score', '3': 5, '4': 1, '5': 1, '10': 'feasibilityScore'},
    {'1': 'approval_comments', '3': 6, '4': 3, '5': 9, '10': 'approvalComments'},
  ],
};

/// Descriptor for `ApproveTransmissionRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveTransmissionRouteRequestDescriptor = $convert.base64Decode(
    'Ch9BcHByb3ZlVHJhbnNtaXNzaW9uUm91dGVSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBIUCgVhY3'
    'RvchgCIAEoCVIFYWN0b3ISEgoEbm90ZRgDIAEoCVIEbm90ZRIjCg1xdWFsaXR5X3Njb3JlGAQg'
    'ASgBUgxxdWFsaXR5U2NvcmUSKwoRZmVhc2liaWxpdHlfc2NvcmUYBSABKAFSEGZlYXNpYmlsaX'
    'R5U2NvcmUSKwoRYXBwcm92YWxfY29tbWVudHMYBiADKAlSEGFwcHJvdmFsQ29tbWVudHM=');

@$core.Deprecated('Use approveTransmissionRouteResponseDescriptor instead')
const ApproveTransmissionRouteResponse$json = {
  '1': 'ApproveTransmissionRouteResponse',
  '2': [
    {'1': 'route', '3': 1, '4': 1, '5': 11, '6': '.transmission.v1.TransmissionRoute', '10': 'route'},
  ],
};

/// Descriptor for `ApproveTransmissionRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List approveTransmissionRouteResponseDescriptor = $convert.base64Decode(
    'CiBBcHByb3ZlVHJhbnNtaXNzaW9uUm91dGVSZXNwb25zZRI4CgVyb3V0ZRgBIAEoCzIiLnRyYW'
    '5zbWlzc2lvbi52MS5UcmFuc21pc3Npb25Sb3V0ZVIFcm91dGU=');

@$core.Deprecated('Use rejectTransmissionRouteRequestDescriptor instead')
const RejectTransmissionRouteRequest$json = {
  '1': 'RejectTransmissionRouteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'actor', '3': 2, '4': 1, '5': 9, '10': 'actor'},
    {'1': 'rejection_reasons', '3': 3, '4': 3, '5': 9, '10': 'rejectionReasons'},
  ],
};

/// Descriptor for `RejectTransmissionRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectTransmissionRouteRequestDescriptor = $convert.base64Decode(
    'Ch5SZWplY3RUcmFuc21pc3Npb25Sb3V0ZVJlcXVlc3QSDgoCaWQYASABKAlSAmlkEhQKBWFjdG'
    '9yGAIgASgJUgVhY3RvchIrChFyZWplY3Rpb25fcmVhc29ucxgDIAMoCVIQcmVqZWN0aW9uUmVh'
    'c29ucw==');

@$core.Deprecated('Use rejectTransmissionRouteResponseDescriptor instead')
const RejectTransmissionRouteResponse$json = {
  '1': 'RejectTransmissionRouteResponse',
  '2': [
    {'1': 'route', '3': 1, '4': 1, '5': 11, '6': '.transmission.v1.TransmissionRoute', '10': 'route'},
  ],
};

/// Descriptor for `RejectTransmissionRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectTransmissionRouteResponseDescriptor = $convert.base64Decode(
    'Ch9SZWplY3RUcmFuc21pc3Npb25Sb3V0ZVJlc3BvbnNlEjgKBXJvdXRlGAEgASgLMiIudHJhbn'
    'NtaXNzaW9uLnYxLlRyYW5zbWlzc2lvblJvdXRlUgVyb3V0ZQ==');

@$core.Deprecated('Use exportTransmissionRoutePackRequestDescriptor instead')
const ExportTransmissionRoutePackRequest$json = {
  '1': 'ExportTransmissionRoutePackRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'generated_by', '3': 2, '4': 1, '5': 9, '10': 'generatedBy'},
  ],
};

/// Descriptor for `ExportTransmissionRoutePackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportTransmissionRoutePackRequestDescriptor = $convert.base64Decode(
    'CiJFeHBvcnRUcmFuc21pc3Npb25Sb3V0ZVBhY2tSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBIhCg'
    'xnZW5lcmF0ZWRfYnkYAiABKAlSC2dlbmVyYXRlZEJ5');

@$core.Deprecated('Use exportTransmissionRoutePackResponseDescriptor instead')
const ExportTransmissionRoutePackResponse$json = {
  '1': 'ExportTransmissionRoutePackResponse',
  '2': [
    {'1': 'pack', '3': 1, '4': 1, '5': 11, '6': '.transmission.v1.TransmissionRouteExportPack', '10': 'pack'},
  ],
};

/// Descriptor for `ExportTransmissionRoutePackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exportTransmissionRoutePackResponseDescriptor = $convert.base64Decode(
    'CiNFeHBvcnRUcmFuc21pc3Npb25Sb3V0ZVBhY2tSZXNwb25zZRJACgRwYWNrGAEgASgLMiwudH'
    'JhbnNtaXNzaW9uLnYxLlRyYW5zbWlzc2lvblJvdXRlRXhwb3J0UGFja1IEcGFjaw==');

@$core.Deprecated('Use deleteTransmissionRouteRequestDescriptor instead')
const DeleteTransmissionRouteRequest$json = {
  '1': 'DeleteTransmissionRouteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteTransmissionRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTransmissionRouteRequestDescriptor = $convert.base64Decode(
    'Ch5EZWxldGVUcmFuc21pc3Npb25Sb3V0ZVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use deleteTransmissionRouteResponseDescriptor instead')
const DeleteTransmissionRouteResponse$json = {
  '1': 'DeleteTransmissionRouteResponse',
};

/// Descriptor for `DeleteTransmissionRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTransmissionRouteResponseDescriptor = $convert.base64Decode(
    'Ch9EZWxldGVUcmFuc21pc3Npb25Sb3V0ZVJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> TransmissionRoutingServiceBase$json = {
  '1': 'TransmissionRoutingService',
  '2': [
    {'1': 'CalculateTransmissionRoute', '2': '.transmission.v1.CalculateTransmissionRouteRequest', '3': '.transmission.v1.CalculateTransmissionRouteResponse'},
    {'1': 'StreamTransmissionRoute', '2': '.transmission.v1.StreamTransmissionRouteRequest', '3': '.transmission.v1.StreamTransmissionRouteResponse', '6': true},
    {'1': 'GetTransmissionRoute', '2': '.transmission.v1.GetTransmissionRouteRequest', '3': '.transmission.v1.GetTransmissionRouteResponse'},
    {'1': 'ListTransmissionRoutes', '2': '.transmission.v1.ListTransmissionRoutesRequest', '3': '.transmission.v1.ListTransmissionRoutesResponse'},
    {'1': 'SubmitTransmissionRouteForReview', '2': '.transmission.v1.SubmitTransmissionRouteForReviewRequest', '3': '.transmission.v1.SubmitTransmissionRouteForReviewResponse'},
    {'1': 'ApproveTransmissionRoute', '2': '.transmission.v1.ApproveTransmissionRouteRequest', '3': '.transmission.v1.ApproveTransmissionRouteResponse'},
    {'1': 'ExportTransmissionRoutePack', '2': '.transmission.v1.ExportTransmissionRoutePackRequest', '3': '.transmission.v1.ExportTransmissionRoutePackResponse'},
    {'1': 'DeleteTransmissionRoute', '2': '.transmission.v1.DeleteTransmissionRouteRequest', '3': '.transmission.v1.DeleteTransmissionRouteResponse'},
    {'1': 'RejectTransmissionRoute', '2': '.transmission.v1.RejectTransmissionRouteRequest', '3': '.transmission.v1.RejectTransmissionRouteResponse'},
  ],
};

@$core.Deprecated('Use transmissionRoutingServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> TransmissionRoutingServiceBase$messageJson = {
  '.transmission.v1.CalculateTransmissionRouteRequest': CalculateTransmissionRouteRequest$json,
  '.transmission.v1.Waypoint': Waypoint$json,
  '.transmission.v1.TransmissionConstraints': TransmissionConstraints$json,
  '.transmission.v1.ElevationRasterInput': ElevationRasterInput$json,
  '.transmission.v1.ObstacleRasterInput': ObstacleRasterInput$json,
  '.transmission.v1.VectorFeatureInput': VectorFeatureInput$json,
  '.transmission.v1.CalculateTransmissionRouteResponse': CalculateTransmissionRouteResponse$json,
  '.transmission.v1.TransmissionRoute': TransmissionRoute$json,
  '.transmission.v1.TowerPosition': TowerPosition$json,
  '.transmission.v1.CostBreakdown': CostBreakdown$json,
  '.transmission.v1.SegmentExplanation': SegmentExplanation$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.transmission.v1.RouteScore': RouteScore$json,
  '.transmission.v1.RouteScore.DimensionReasonsEntry': RouteScore_DimensionReasonsEntry$json,
  '.transmission.v1.GovernanceEvent': GovernanceEvent$json,
  '.transmission.v1.ReviewMetadata': ReviewMetadata$json,
  '.transmission.v1.StreamTransmissionRouteRequest': StreamTransmissionRouteRequest$json,
  '.transmission.v1.StreamTransmissionRouteResponse': StreamTransmissionRouteResponse$json,
  '.transmission.v1.GetTransmissionRouteRequest': GetTransmissionRouteRequest$json,
  '.transmission.v1.GetTransmissionRouteResponse': GetTransmissionRouteResponse$json,
  '.transmission.v1.ListTransmissionRoutesRequest': ListTransmissionRoutesRequest$json,
  '.packages.api.v1.pagination.PaginationRequest': $1.PaginationRequest$json,
  '.google.protobuf.FieldMask': $2.FieldMask$json,
  '.transmission.v1.ListTransmissionRoutesResponse': ListTransmissionRoutesResponse$json,
  '.packages.api.v1.pagination.PaginationResponse': $1.PaginationResponse$json,
  '.transmission.v1.SubmitTransmissionRouteForReviewRequest': SubmitTransmissionRouteForReviewRequest$json,
  '.transmission.v1.SubmitTransmissionRouteForReviewResponse': SubmitTransmissionRouteForReviewResponse$json,
  '.transmission.v1.ApproveTransmissionRouteRequest': ApproveTransmissionRouteRequest$json,
  '.transmission.v1.ApproveTransmissionRouteResponse': ApproveTransmissionRouteResponse$json,
  '.transmission.v1.ExportTransmissionRoutePackRequest': ExportTransmissionRoutePackRequest$json,
  '.transmission.v1.ExportTransmissionRoutePackResponse': ExportTransmissionRoutePackResponse$json,
  '.transmission.v1.TransmissionRouteExportPack': TransmissionRouteExportPack$json,
  '.transmission.v1.TowerScheduleEntry': TowerScheduleEntry$json,
  '.transmission.v1.UndergroundChainageEntry': UndergroundChainageEntry$json,
  '.transmission.v1.CostBookEntry': CostBookEntry$json,
  '.transmission.v1.TraceabilityBundle': TraceabilityBundle$json,
  '.transmission.v1.DeleteTransmissionRouteRequest': DeleteTransmissionRouteRequest$json,
  '.transmission.v1.DeleteTransmissionRouteResponse': DeleteTransmissionRouteResponse$json,
  '.transmission.v1.RejectTransmissionRouteRequest': RejectTransmissionRouteRequest$json,
  '.transmission.v1.RejectTransmissionRouteResponse': RejectTransmissionRouteResponse$json,
};

/// Descriptor for `TransmissionRoutingService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List transmissionRoutingServiceDescriptor = $convert.base64Decode(
    'ChpUcmFuc21pc3Npb25Sb3V0aW5nU2VydmljZRKFAQoaQ2FsY3VsYXRlVHJhbnNtaXNzaW9uUm'
    '91dGUSMi50cmFuc21pc3Npb24udjEuQ2FsY3VsYXRlVHJhbnNtaXNzaW9uUm91dGVSZXF1ZXN0'
    'GjMudHJhbnNtaXNzaW9uLnYxLkNhbGN1bGF0ZVRyYW5zbWlzc2lvblJvdXRlUmVzcG9uc2USfg'
    'oXU3RyZWFtVHJhbnNtaXNzaW9uUm91dGUSLy50cmFuc21pc3Npb24udjEuU3RyZWFtVHJhbnNt'
    'aXNzaW9uUm91dGVSZXF1ZXN0GjAudHJhbnNtaXNzaW9uLnYxLlN0cmVhbVRyYW5zbWlzc2lvbl'
    'JvdXRlUmVzcG9uc2UwARJzChRHZXRUcmFuc21pc3Npb25Sb3V0ZRIsLnRyYW5zbWlzc2lvbi52'
    'MS5HZXRUcmFuc21pc3Npb25Sb3V0ZVJlcXVlc3QaLS50cmFuc21pc3Npb24udjEuR2V0VHJhbn'
    'NtaXNzaW9uUm91dGVSZXNwb25zZRJ5ChZMaXN0VHJhbnNtaXNzaW9uUm91dGVzEi4udHJhbnNt'
    'aXNzaW9uLnYxLkxpc3RUcmFuc21pc3Npb25Sb3V0ZXNSZXF1ZXN0Gi8udHJhbnNtaXNzaW9uLn'
    'YxLkxpc3RUcmFuc21pc3Npb25Sb3V0ZXNSZXNwb25zZRKXAQogU3VibWl0VHJhbnNtaXNzaW9u'
    'Um91dGVGb3JSZXZpZXcSOC50cmFuc21pc3Npb24udjEuU3VibWl0VHJhbnNtaXNzaW9uUm91dG'
    'VGb3JSZXZpZXdSZXF1ZXN0GjkudHJhbnNtaXNzaW9uLnYxLlN1Ym1pdFRyYW5zbWlzc2lvblJv'
    'dXRlRm9yUmV2aWV3UmVzcG9uc2USfwoYQXBwcm92ZVRyYW5zbWlzc2lvblJvdXRlEjAudHJhbn'
    'NtaXNzaW9uLnYxLkFwcHJvdmVUcmFuc21pc3Npb25Sb3V0ZVJlcXVlc3QaMS50cmFuc21pc3Np'
    'b24udjEuQXBwcm92ZVRyYW5zbWlzc2lvblJvdXRlUmVzcG9uc2USiAEKG0V4cG9ydFRyYW5zbW'
    'lzc2lvblJvdXRlUGFjaxIzLnRyYW5zbWlzc2lvbi52MS5FeHBvcnRUcmFuc21pc3Npb25Sb3V0'
    'ZVBhY2tSZXF1ZXN0GjQudHJhbnNtaXNzaW9uLnYxLkV4cG9ydFRyYW5zbWlzc2lvblJvdXRlUG'
    'Fja1Jlc3BvbnNlEnwKF0RlbGV0ZVRyYW5zbWlzc2lvblJvdXRlEi8udHJhbnNtaXNzaW9uLnYx'
    'LkRlbGV0ZVRyYW5zbWlzc2lvblJvdXRlUmVxdWVzdBowLnRyYW5zbWlzc2lvbi52MS5EZWxldG'
    'VUcmFuc21pc3Npb25Sb3V0ZVJlc3BvbnNlEnwKF1JlamVjdFRyYW5zbWlzc2lvblJvdXRlEi8u'
    'dHJhbnNtaXNzaW9uLnYxLlJlamVjdFRyYW5zbWlzc2lvblJvdXRlUmVxdWVzdBowLnRyYW5zbW'
    'lzc2lvbi52MS5SZWplY3RUcmFuc21pc3Npb25Sb3V0ZVJlc3BvbnNl');

