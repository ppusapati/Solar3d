//
//  Generated code. Do not modify.
//  source: constraint/v1/constraint_zones.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../common/v1/primitives.pbjson.dart' as $0;
import '../../google/protobuf/timestamp.pbjson.dart' as $1;

@$core.Deprecated('Use zoneTypeDescriptor instead')
const ZoneType$json = {
  '1': 'ZoneType',
  '2': [
    {'1': 'ZONE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'ZONE_TYPE_EXCLUSION', '2': 1},
    {'1': 'ZONE_TYPE_INCLUSION', '2': 2},
    {'1': 'ZONE_TYPE_BUFFER', '2': 3},
  ],
};

/// Descriptor for `ZoneType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List zoneTypeDescriptor = $convert.base64Decode(
    'Cghab25lVHlwZRIZChVaT05FX1RZUEVfVU5TUEVDSUZJRUQQABIXChNaT05FX1RZUEVfRVhDTF'
    'VTSU9OEAESFwoTWk9ORV9UWVBFX0lOQ0xVU0lPThACEhQKEFpPTkVfVFlQRV9CVUZGRVIQAw==');

@$core.Deprecated('Use zoneCategoryDescriptor instead')
const ZoneCategory$json = {
  '1': 'ZoneCategory',
  '2': [
    {'1': 'ZONE_CATEGORY_UNSPECIFIED', '2': 0},
    {'1': 'ZONE_CATEGORY_GEOLOGICAL', '2': 1},
    {'1': 'ZONE_CATEGORY_ENVIRONMENTAL', '2': 2},
    {'1': 'ZONE_CATEGORY_REGULATORY', '2': 3},
    {'1': 'ZONE_CATEGORY_INFRASTRUCTURE', '2': 4},
    {'1': 'ZONE_CATEGORY_MILITARY', '2': 5},
    {'1': 'ZONE_CATEGORY_PROTECTED', '2': 6},
  ],
};

/// Descriptor for `ZoneCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List zoneCategoryDescriptor = $convert.base64Decode(
    'Cgxab25lQ2F0ZWdvcnkSHQoZWk9ORV9DQVRFR09SWV9VTlNQRUNJRklFRBAAEhwKGFpPTkVfQ0'
    'FURUdPUllfR0VPTE9HSUNBTBABEh8KG1pPTkVfQ0FURUdPUllfRU5WSVJPTk1FTlRBTBACEhwK'
    'GFpPTkVfQ0FURUdPUllfUkVHVUxBVE9SWRADEiAKHFpPTkVfQ0FURUdPUllfSU5GUkFTVFJVQ1'
    'RVUkUQBBIaChZaT05FX0NBVEVHT1JZX01JTElUQVJZEAUSGwoXWk9ORV9DQVRFR09SWV9QUk9U'
    'RUNURUQQBg==');

@$core.Deprecated('Use conflictSeverityDescriptor instead')
const ConflictSeverity$json = {
  '1': 'ConflictSeverity',
  '2': [
    {'1': 'CONFLICT_SEVERITY_UNSPECIFIED', '2': 0},
    {'1': 'CONFLICT_SEVERITY_INFO', '2': 1},
    {'1': 'CONFLICT_SEVERITY_WARNING', '2': 2},
    {'1': 'CONFLICT_SEVERITY_ERROR', '2': 3},
    {'1': 'CONFLICT_SEVERITY_BLOCKER', '2': 4},
  ],
};

/// Descriptor for `ConflictSeverity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List conflictSeverityDescriptor = $convert.base64Decode(
    'ChBDb25mbGljdFNldmVyaXR5EiEKHUNPTkZMSUNUX1NFVkVSSVRZX1VOU1BFQ0lGSUVEEAASGg'
    'oWQ09ORkxJQ1RfU0VWRVJJVFlfSU5GTxABEh0KGUNPTkZMSUNUX1NFVkVSSVRZX1dBUk5JTkcQ'
    'AhIbChdDT05GTElDVF9TRVZFUklUWV9FUlJPUhADEh0KGUNPTkZMSUNUX1NFVkVSSVRZX0JMT0'
    'NLRVIQBA==');

@$core.Deprecated('Use zoneStatusDescriptor instead')
const ZoneStatus$json = {
  '1': 'ZoneStatus',
  '2': [
    {'1': 'ZONE_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'ZONE_STATUS_ACTIVE', '2': 1},
    {'1': 'ZONE_STATUS_INACTIVE', '2': 2},
    {'1': 'ZONE_STATUS_EXPIRED', '2': 3},
    {'1': 'ZONE_STATUS_PENDING', '2': 4},
  ],
};

/// Descriptor for `ZoneStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List zoneStatusDescriptor = $convert.base64Decode(
    'Cgpab25lU3RhdHVzEhsKF1pPTkVfU1RBVFVTX1VOU1BFQ0lGSUVEEAASFgoSWk9ORV9TVEFUVV'
    'NfQUNUSVZFEAESGAoUWk9ORV9TVEFUVVNfSU5BQ1RJVkUQAhIXChNaT05FX1NUQVRVU19FWFBJ'
    'UkVEEAMSFwoTWk9ORV9TVEFUVVNfUEVORElORxAE');

@$core.Deprecated('Use zoneDescriptor instead')
const Zone$json = {
  '1': 'Zone',
  '2': [
    {'1': 'zone_id', '3': 1, '4': 1, '5': 9, '10': 'zoneId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'zone_type', '3': 4, '4': 1, '5': 14, '6': '.constraint.v1.ZoneType', '10': 'zoneType'},
    {'1': 'zone_category', '3': 5, '4': 1, '5': 14, '6': '.constraint.v1.ZoneCategory', '10': 'zoneCategory'},
    {'1': 'zone_status', '3': 6, '4': 1, '5': 14, '6': '.constraint.v1.ZoneStatus', '10': 'zoneStatus'},
    {'1': 'geometry_wkt', '3': 7, '4': 1, '5': 9, '10': 'geometryWkt'},
    {'1': 'geometry_type', '3': 8, '4': 1, '5': 9, '10': 'geometryType'},
    {'1': 'bounding_box', '3': 9, '4': 1, '5': 11, '6': '.common.v1.BoundingBox2D', '10': 'boundingBox'},
    {'1': 'effective_start', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'effectiveStart'},
    {'1': 'effective_end', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'effectiveEnd'},
    {'1': 'source', '3': 12, '4': 1, '5': 9, '10': 'source'},
    {'1': 'source_id', '3': 13, '4': 1, '5': 9, '10': 'sourceId'},
    {'1': 'buffer_distance_meters', '3': 14, '4': 1, '5': 2, '10': 'bufferDistanceMeters'},
    {'1': 'tags', '3': 15, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'metadata', '3': 16, '4': 3, '5': 11, '6': '.constraint.v1.Zone.MetadataEntry', '10': 'metadata'},
    {'1': 'created_by', '3': 17, '4': 1, '5': 9, '10': 'createdBy'},
    {'1': 'project_id', '3': 18, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'is_public', '3': 19, '4': 1, '5': 8, '10': 'isPublic'},
    {'1': 'created_at', '3': 20, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 21, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'deleted_at', '3': 22, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'deletedAt'},
  ],
  '3': [Zone_MetadataEntry$json],
};

@$core.Deprecated('Use zoneDescriptor instead')
const Zone_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `Zone`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List zoneDescriptor = $convert.base64Decode(
    'CgRab25lEhcKB3pvbmVfaWQYASABKAlSBnpvbmVJZBISCgRuYW1lGAIgASgJUgRuYW1lEiAKC2'
    'Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhI0Cgl6b25lX3R5cGUYBCABKA4yFy5jb25z'
    'dHJhaW50LnYxLlpvbmVUeXBlUgh6b25lVHlwZRJACg16b25lX2NhdGVnb3J5GAUgASgOMhsuY2'
    '9uc3RyYWludC52MS5ab25lQ2F0ZWdvcnlSDHpvbmVDYXRlZ29yeRI6Cgt6b25lX3N0YXR1cxgG'
    'IAEoDjIZLmNvbnN0cmFpbnQudjEuWm9uZVN0YXR1c1IKem9uZVN0YXR1cxIhCgxnZW9tZXRyeV'
    '93a3QYByABKAlSC2dlb21ldHJ5V2t0EiMKDWdlb21ldHJ5X3R5cGUYCCABKAlSDGdlb21ldHJ5'
    'VHlwZRI7Cgxib3VuZGluZ19ib3gYCSABKAsyGC5jb21tb24udjEuQm91bmRpbmdCb3gyRFILYm'
    '91bmRpbmdCb3gSQwoPZWZmZWN0aXZlX3N0YXJ0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRp'
    'bWVzdGFtcFIOZWZmZWN0aXZlU3RhcnQSPwoNZWZmZWN0aXZlX2VuZBgLIAEoCzIaLmdvb2dsZS'
    '5wcm90b2J1Zi5UaW1lc3RhbXBSDGVmZmVjdGl2ZUVuZBIWCgZzb3VyY2UYDCABKAlSBnNvdXJj'
    'ZRIbCglzb3VyY2VfaWQYDSABKAlSCHNvdXJjZUlkEjQKFmJ1ZmZlcl9kaXN0YW5jZV9tZXRlcn'
    'MYDiABKAJSFGJ1ZmZlckRpc3RhbmNlTWV0ZXJzEhIKBHRhZ3MYDyADKAlSBHRhZ3MSPQoIbWV0'
    'YWRhdGEYECADKAsyIS5jb25zdHJhaW50LnYxLlpvbmUuTWV0YWRhdGFFbnRyeVIIbWV0YWRhdG'
    'ESHQoKY3JlYXRlZF9ieRgRIAEoCVIJY3JlYXRlZEJ5Eh0KCnByb2plY3RfaWQYEiABKAlSCXBy'
    'b2plY3RJZBIbCglpc19wdWJsaWMYEyABKAhSCGlzUHVibGljEjkKCmNyZWF0ZWRfYXQYFCABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgV'
    'IAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdBI5CgpkZWxldGVkX2'
    'F0GBYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJZGVsZXRlZEF0GjsKDU1ldGFk'
    'YXRhRW50cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use sitingConflictDescriptor instead')
const SitingConflict$json = {
  '1': 'SitingConflict',
  '2': [
    {'1': 'conflict_id', '3': 1, '4': 1, '5': 9, '10': 'conflictId'},
    {'1': 'zone_id', '3': 2, '4': 1, '5': 9, '10': 'zoneId'},
    {'1': 'conflicting_zone', '3': 3, '4': 1, '5': 11, '6': '.constraint.v1.Zone', '10': 'conflictingZone'},
    {'1': 'severity', '3': 4, '4': 1, '5': 14, '6': '.constraint.v1.ConflictSeverity', '10': 'severity'},
    {'1': 'conflict_reason', '3': 5, '4': 1, '5': 9, '10': 'conflictReason'},
    {'1': 'distance_meters', '3': 6, '4': 1, '5': 2, '10': 'distanceMeters'},
    {'1': 'overlap_area_sqm', '3': 7, '4': 1, '5': 2, '10': 'overlapAreaSqm'},
    {'1': 'mitigation_suggestions', '3': 8, '4': 3, '5': 9, '10': 'mitigationSuggestions'},
  ],
};

/// Descriptor for `SitingConflict`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sitingConflictDescriptor = $convert.base64Decode(
    'Cg5TaXRpbmdDb25mbGljdBIfCgtjb25mbGljdF9pZBgBIAEoCVIKY29uZmxpY3RJZBIXCgd6b2'
    '5lX2lkGAIgASgJUgZ6b25lSWQSPgoQY29uZmxpY3Rpbmdfem9uZRgDIAEoCzITLmNvbnN0cmFp'
    'bnQudjEuWm9uZVIPY29uZmxpY3Rpbmdab25lEjsKCHNldmVyaXR5GAQgASgOMh8uY29uc3RyYW'
    'ludC52MS5Db25mbGljdFNldmVyaXR5UghzZXZlcml0eRInCg9jb25mbGljdF9yZWFzb24YBSAB'
    'KAlSDmNvbmZsaWN0UmVhc29uEicKD2Rpc3RhbmNlX21ldGVycxgGIAEoAlIOZGlzdGFuY2VNZX'
    'RlcnMSKAoQb3ZlcmxhcF9hcmVhX3NxbRgHIAEoAlIOb3ZlcmxhcEFyZWFTcW0SNQoWbWl0aWdh'
    'dGlvbl9zdWdnZXN0aW9ucxgIIAMoCVIVbWl0aWdhdGlvblN1Z2dlc3Rpb25z');

@$core.Deprecated('Use riskScoreDescriptor instead')
const RiskScore$json = {
  '1': 'RiskScore',
  '2': [
    {'1': 'total_conflicts', '3': 1, '4': 1, '5': 5, '10': 'totalConflicts'},
    {'1': 'blocker_count', '3': 2, '4': 1, '5': 5, '10': 'blockerCount'},
    {'1': 'error_count', '3': 3, '4': 1, '5': 5, '10': 'errorCount'},
    {'1': 'warning_count', '3': 4, '4': 1, '5': 5, '10': 'warningCount'},
    {'1': 'overall_risk_percentage', '3': 5, '4': 1, '5': 2, '10': 'overallRiskPercentage'},
    {'1': 'is_siteable', '3': 6, '4': 1, '5': 8, '10': 'isSiteable'},
  ],
};

/// Descriptor for `RiskScore`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List riskScoreDescriptor = $convert.base64Decode(
    'CglSaXNrU2NvcmUSJwoPdG90YWxfY29uZmxpY3RzGAEgASgFUg50b3RhbENvbmZsaWN0cxIjCg'
    '1ibG9ja2VyX2NvdW50GAIgASgFUgxibG9ja2VyQ291bnQSHwoLZXJyb3JfY291bnQYAyABKAVS'
    'CmVycm9yQ291bnQSIwoNd2FybmluZ19jb3VudBgEIAEoBVIMd2FybmluZ0NvdW50EjYKF292ZX'
    'JhbGxfcmlza19wZXJjZW50YWdlGAUgASgCUhVvdmVyYWxsUmlza1BlcmNlbnRhZ2USHwoLaXNf'
    'c2l0ZWFibGUYBiABKAhSCmlzU2l0ZWFibGU=');

@$core.Deprecated('Use categoryDefDescriptor instead')
const CategoryDef$json = {
  '1': 'CategoryDef',
  '2': [
    {'1': 'category', '3': 1, '4': 1, '5': 14, '6': '.constraint.v1.ZoneCategory', '10': 'category'},
    {'1': 'display_name', '3': 2, '4': 1, '5': 9, '10': 'displayName'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'allowed_tags', '3': 4, '4': 3, '5': 9, '10': 'allowedTags'},
    {'1': 'associated_regulations', '3': 5, '4': 3, '5': 9, '10': 'associatedRegulations'},
  ],
};

/// Descriptor for `CategoryDef`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List categoryDefDescriptor = $convert.base64Decode(
    'CgtDYXRlZ29yeURlZhI3CghjYXRlZ29yeRgBIAEoDjIbLmNvbnN0cmFpbnQudjEuWm9uZUNhdG'
    'Vnb3J5UghjYXRlZ29yeRIhCgxkaXNwbGF5X25hbWUYAiABKAlSC2Rpc3BsYXlOYW1lEiAKC2Rl'
    'c2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhIhCgxhbGxvd2VkX3RhZ3MYBCADKAlSC2FsbG'
    '93ZWRUYWdzEjUKFmFzc29jaWF0ZWRfcmVndWxhdGlvbnMYBSADKAlSFWFzc29jaWF0ZWRSZWd1'
    'bGF0aW9ucw==');

@$core.Deprecated('Use createZoneRequestDescriptor instead')
const CreateZoneRequest$json = {
  '1': 'CreateZoneRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'zone_type', '3': 3, '4': 1, '5': 14, '6': '.constraint.v1.ZoneType', '10': 'zoneType'},
    {'1': 'zone_category', '3': 4, '4': 1, '5': 14, '6': '.constraint.v1.ZoneCategory', '10': 'zoneCategory'},
    {'1': 'geometry_wkt', '3': 5, '4': 1, '5': 9, '10': 'geometryWkt'},
    {'1': 'geometry_type', '3': 6, '4': 1, '5': 9, '10': 'geometryType'},
    {'1': 'effective_start', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'effectiveStart'},
    {'1': 'effective_end', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'effectiveEnd'},
    {'1': 'source', '3': 9, '4': 1, '5': 9, '10': 'source'},
    {'1': 'source_id', '3': 10, '4': 1, '5': 9, '10': 'sourceId'},
    {'1': 'buffer_distance_meters', '3': 11, '4': 1, '5': 2, '10': 'bufferDistanceMeters'},
    {'1': 'tags', '3': 12, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'metadata', '3': 13, '4': 3, '5': 11, '6': '.constraint.v1.CreateZoneRequest.MetadataEntry', '10': 'metadata'},
    {'1': 'project_id', '3': 14, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'is_public', '3': 15, '4': 1, '5': 8, '10': 'isPublic'},
  ],
  '3': [CreateZoneRequest_MetadataEntry$json],
};

@$core.Deprecated('Use createZoneRequestDescriptor instead')
const CreateZoneRequest_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `CreateZoneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createZoneRequestDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVab25lUmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1lEiAKC2Rlc2NyaXB0aW9uGA'
    'IgASgJUgtkZXNjcmlwdGlvbhI0Cgl6b25lX3R5cGUYAyABKA4yFy5jb25zdHJhaW50LnYxLlpv'
    'bmVUeXBlUgh6b25lVHlwZRJACg16b25lX2NhdGVnb3J5GAQgASgOMhsuY29uc3RyYWludC52MS'
    '5ab25lQ2F0ZWdvcnlSDHpvbmVDYXRlZ29yeRIhCgxnZW9tZXRyeV93a3QYBSABKAlSC2dlb21l'
    'dHJ5V2t0EiMKDWdlb21ldHJ5X3R5cGUYBiABKAlSDGdlb21ldHJ5VHlwZRJDCg9lZmZlY3Rpdm'
    'Vfc3RhcnQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg5lZmZlY3RpdmVTdGFy'
    'dBI/Cg1lZmZlY3RpdmVfZW5kGAggASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMZW'
    'ZmZWN0aXZlRW5kEhYKBnNvdXJjZRgJIAEoCVIGc291cmNlEhsKCXNvdXJjZV9pZBgKIAEoCVII'
    'c291cmNlSWQSNAoWYnVmZmVyX2Rpc3RhbmNlX21ldGVycxgLIAEoAlIUYnVmZmVyRGlzdGFuY2'
    'VNZXRlcnMSEgoEdGFncxgMIAMoCVIEdGFncxJKCghtZXRhZGF0YRgNIAMoCzIuLmNvbnN0cmFp'
    'bnQudjEuQ3JlYXRlWm9uZVJlcXVlc3QuTWV0YWRhdGFFbnRyeVIIbWV0YWRhdGESHQoKcHJvam'
    'VjdF9pZBgOIAEoCVIJcHJvamVjdElkEhsKCWlzX3B1YmxpYxgPIAEoCFIIaXNQdWJsaWMaOwoN'
    'TWV0YWRhdGFFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2YWx1ZRgCIAEoCVIFdmFsdWU6Aj'
    'gB');

@$core.Deprecated('Use createZoneResponseDescriptor instead')
const CreateZoneResponse$json = {
  '1': 'CreateZoneResponse',
  '2': [
    {'1': 'zone_id', '3': 1, '4': 1, '5': 9, '10': 'zoneId'},
    {'1': 'zone', '3': 2, '4': 1, '5': 11, '6': '.constraint.v1.Zone', '10': 'zone'},
    {'1': 'created_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
  ],
};

/// Descriptor for `CreateZoneResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createZoneResponseDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVab25lUmVzcG9uc2USFwoHem9uZV9pZBgBIAEoCVIGem9uZUlkEicKBHpvbmUYAi'
    'ABKAsyEy5jb25zdHJhaW50LnYxLlpvbmVSBHpvbmUSOQoKY3JlYXRlZF9hdBgDIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use updateZoneRequestDescriptor instead')
const UpdateZoneRequest$json = {
  '1': 'UpdateZoneRequest',
  '2': [
    {'1': 'zone_id', '3': 1, '4': 1, '5': 9, '10': 'zoneId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'zone_type', '3': 4, '4': 1, '5': 14, '6': '.constraint.v1.ZoneType', '10': 'zoneType'},
    {'1': 'zone_category', '3': 5, '4': 1, '5': 14, '6': '.constraint.v1.ZoneCategory', '10': 'zoneCategory'},
    {'1': 'zone_status', '3': 6, '4': 1, '5': 14, '6': '.constraint.v1.ZoneStatus', '10': 'zoneStatus'},
    {'1': 'geometry_wkt', '3': 7, '4': 1, '5': 9, '10': 'geometryWkt'},
    {'1': 'effective_start', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'effectiveStart'},
    {'1': 'effective_end', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'effectiveEnd'},
    {'1': 'buffer_distance_meters', '3': 10, '4': 1, '5': 2, '10': 'bufferDistanceMeters'},
    {'1': 'tags', '3': 11, '4': 3, '5': 9, '10': 'tags'},
    {'1': 'metadata', '3': 12, '4': 3, '5': 11, '6': '.constraint.v1.UpdateZoneRequest.MetadataEntry', '10': 'metadata'},
    {'1': 'is_public', '3': 13, '4': 1, '5': 8, '10': 'isPublic'},
  ],
  '3': [UpdateZoneRequest_MetadataEntry$json],
};

@$core.Deprecated('Use updateZoneRequestDescriptor instead')
const UpdateZoneRequest_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `UpdateZoneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateZoneRequestDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVab25lUmVxdWVzdBIXCgd6b25lX2lkGAEgASgJUgZ6b25lSWQSEgoEbmFtZRgCIA'
    'EoCVIEbmFtZRIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24SNAoJem9uZV90eXBl'
    'GAQgASgOMhcuY29uc3RyYWludC52MS5ab25lVHlwZVIIem9uZVR5cGUSQAoNem9uZV9jYXRlZ2'
    '9yeRgFIAEoDjIbLmNvbnN0cmFpbnQudjEuWm9uZUNhdGVnb3J5Ugx6b25lQ2F0ZWdvcnkSOgoL'
    'em9uZV9zdGF0dXMYBiABKA4yGS5jb25zdHJhaW50LnYxLlpvbmVTdGF0dXNSCnpvbmVTdGF0dX'
    'MSIQoMZ2VvbWV0cnlfd2t0GAcgASgJUgtnZW9tZXRyeVdrdBJDCg9lZmZlY3RpdmVfc3RhcnQY'
    'CCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg5lZmZlY3RpdmVTdGFydBI/Cg1lZm'
    'ZlY3RpdmVfZW5kGAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMZWZmZWN0aXZl'
    'RW5kEjQKFmJ1ZmZlcl9kaXN0YW5jZV9tZXRlcnMYCiABKAJSFGJ1ZmZlckRpc3RhbmNlTWV0ZX'
    'JzEhIKBHRhZ3MYCyADKAlSBHRhZ3MSSgoIbWV0YWRhdGEYDCADKAsyLi5jb25zdHJhaW50LnYx'
    'LlVwZGF0ZVpvbmVSZXF1ZXN0Lk1ldGFkYXRhRW50cnlSCG1ldGFkYXRhEhsKCWlzX3B1YmxpYx'
    'gNIAEoCFIIaXNQdWJsaWMaOwoNTWV0YWRhdGFFbnRyeRIQCgNrZXkYASABKAlSA2tleRIUCgV2'
    'YWx1ZRgCIAEoCVIFdmFsdWU6AjgB');

@$core.Deprecated('Use updateZoneResponseDescriptor instead')
const UpdateZoneResponse$json = {
  '1': 'UpdateZoneResponse',
  '2': [
    {'1': 'zone', '3': 1, '4': 1, '5': 11, '6': '.constraint.v1.Zone', '10': 'zone'},
    {'1': 'updated_at', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `UpdateZoneResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateZoneResponseDescriptor = $convert.base64Decode(
    'ChJVcGRhdGVab25lUmVzcG9uc2USJwoEem9uZRgBIAEoCzITLmNvbnN0cmFpbnQudjEuWm9uZV'
    'IEem9uZRI5Cgp1cGRhdGVkX2F0GAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJ'
    'dXBkYXRlZEF0');

@$core.Deprecated('Use deleteZoneRequestDescriptor instead')
const DeleteZoneRequest$json = {
  '1': 'DeleteZoneRequest',
  '2': [
    {'1': 'zone_id', '3': 1, '4': 1, '5': 9, '10': 'zoneId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `DeleteZoneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteZoneRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVab25lUmVxdWVzdBIXCgd6b25lX2lkGAEgASgJUgZ6b25lSWQSFgoGcmVhc29uGA'
    'IgASgJUgZyZWFzb24=');

@$core.Deprecated('Use deleteZoneResponseDescriptor instead')
const DeleteZoneResponse$json = {
  '1': 'DeleteZoneResponse',
  '2': [
    {'1': 'zone_id', '3': 1, '4': 1, '5': 9, '10': 'zoneId'},
    {'1': 'deleted_at', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'deletedAt'},
  ],
};

/// Descriptor for `DeleteZoneResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteZoneResponseDescriptor = $convert.base64Decode(
    'ChJEZWxldGVab25lUmVzcG9uc2USFwoHem9uZV9pZBgBIAEoCVIGem9uZUlkEjkKCmRlbGV0ZW'
    'RfYXQYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglkZWxldGVkQXQ=');

@$core.Deprecated('Use getZoneRequestDescriptor instead')
const GetZoneRequest$json = {
  '1': 'GetZoneRequest',
  '2': [
    {'1': 'zone_id', '3': 1, '4': 1, '5': 9, '10': 'zoneId'},
  ],
};

/// Descriptor for `GetZoneRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getZoneRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRab25lUmVxdWVzdBIXCgd6b25lX2lkGAEgASgJUgZ6b25lSWQ=');

@$core.Deprecated('Use getZoneResponseDescriptor instead')
const GetZoneResponse$json = {
  '1': 'GetZoneResponse',
  '2': [
    {'1': 'zone', '3': 1, '4': 1, '5': 11, '6': '.constraint.v1.Zone', '10': 'zone'},
  ],
};

/// Descriptor for `GetZoneResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getZoneResponseDescriptor = $convert.base64Decode(
    'Cg9HZXRab25lUmVzcG9uc2USJwoEem9uZRgBIAEoCzITLmNvbnN0cmFpbnQudjEuWm9uZVIEem'
    '9uZQ==');

@$core.Deprecated('Use listZonesRequestDescriptor instead')
const ListZonesRequest$json = {
  '1': 'ListZonesRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'zone_type', '3': 2, '4': 1, '5': 14, '6': '.constraint.v1.ZoneType', '10': 'zoneType'},
    {'1': 'zone_category', '3': 3, '4': 1, '5': 14, '6': '.constraint.v1.ZoneCategory', '10': 'zoneCategory'},
    {'1': 'zone_status', '3': 4, '4': 1, '5': 14, '6': '.constraint.v1.ZoneStatus', '10': 'zoneStatus'},
    {'1': 'search_query', '3': 5, '4': 1, '5': 9, '10': 'searchQuery'},
    {'1': 'limit', '3': 6, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 7, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListZonesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listZonesRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0Wm9uZXNSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZBI0Cgl6b2'
    '5lX3R5cGUYAiABKA4yFy5jb25zdHJhaW50LnYxLlpvbmVUeXBlUgh6b25lVHlwZRJACg16b25l'
    'X2NhdGVnb3J5GAMgASgOMhsuY29uc3RyYWludC52MS5ab25lQ2F0ZWdvcnlSDHpvbmVDYXRlZ2'
    '9yeRI6Cgt6b25lX3N0YXR1cxgEIAEoDjIZLmNvbnN0cmFpbnQudjEuWm9uZVN0YXR1c1IKem9u'
    'ZVN0YXR1cxIhCgxzZWFyY2hfcXVlcnkYBSABKAlSC3NlYXJjaFF1ZXJ5EhQKBWxpbWl0GAYgAS'
    'gFUgVsaW1pdBIWCgZvZmZzZXQYByABKAVSBm9mZnNldA==');

@$core.Deprecated('Use listZonesResponseDescriptor instead')
const ListZonesResponse$json = {
  '1': 'ListZonesResponse',
  '2': [
    {'1': 'zones', '3': 1, '4': 3, '5': 11, '6': '.constraint.v1.Zone', '10': 'zones'},
    {'1': 'total_count', '3': 2, '4': 1, '5': 3, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListZonesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listZonesResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0Wm9uZXNSZXNwb25zZRIpCgV6b25lcxgBIAMoCzITLmNvbnN0cmFpbnQudjEuWm9uZV'
    'IFem9uZXMSHwoLdG90YWxfY291bnQYAiABKANSCnRvdGFsQ291bnQ=');

@$core.Deprecated('Use queryZonesByLocationRequestDescriptor instead')
const QueryZonesByLocationRequest$json = {
  '1': 'QueryZonesByLocationRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'latitude', '3': 2, '4': 1, '5': 2, '10': 'latitude'},
    {'1': 'longitude', '3': 3, '4': 1, '5': 2, '10': 'longitude'},
    {'1': 'search_radius_meters', '3': 4, '4': 1, '5': 2, '10': 'searchRadiusMeters'},
    {'1': 'zone_type', '3': 5, '4': 1, '5': 14, '6': '.constraint.v1.ZoneType', '10': 'zoneType'},
    {'1': 'limit', '3': 6, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `QueryZonesByLocationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryZonesByLocationRequestDescriptor = $convert.base64Decode(
    'ChtRdWVyeVpvbmVzQnlMb2NhdGlvblJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvam'
    'VjdElkEhoKCGxhdGl0dWRlGAIgASgCUghsYXRpdHVkZRIcCglsb25naXR1ZGUYAyABKAJSCWxv'
    'bmdpdHVkZRIwChRzZWFyY2hfcmFkaXVzX21ldGVycxgEIAEoAlISc2VhcmNoUmFkaXVzTWV0ZX'
    'JzEjQKCXpvbmVfdHlwZRgFIAEoDjIXLmNvbnN0cmFpbnQudjEuWm9uZVR5cGVSCHpvbmVUeXBl'
    'EhQKBWxpbWl0GAYgASgFUgVsaW1pdA==');

@$core.Deprecated('Use queryZonesByLocationResponseDescriptor instead')
const QueryZonesByLocationResponse$json = {
  '1': 'QueryZonesByLocationResponse',
  '2': [
    {'1': 'nearby_zones', '3': 1, '4': 3, '5': 11, '6': '.constraint.v1.Zone', '10': 'nearbyZones'},
    {'1': 'potential_conflicts', '3': 2, '4': 3, '5': 11, '6': '.constraint.v1.SitingConflict', '10': 'potentialConflicts'},
    {'1': 'aggregated_bounds', '3': 3, '4': 1, '5': 11, '6': '.common.v1.BoundingBox2D', '10': 'aggregatedBounds'},
  ],
};

/// Descriptor for `QueryZonesByLocationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List queryZonesByLocationResponseDescriptor = $convert.base64Decode(
    'ChxRdWVyeVpvbmVzQnlMb2NhdGlvblJlc3BvbnNlEjYKDG5lYXJieV96b25lcxgBIAMoCzITLm'
    'NvbnN0cmFpbnQudjEuWm9uZVILbmVhcmJ5Wm9uZXMSTgoTcG90ZW50aWFsX2NvbmZsaWN0cxgC'
    'IAMoCzIdLmNvbnN0cmFpbnQudjEuU2l0aW5nQ29uZmxpY3RSEnBvdGVudGlhbENvbmZsaWN0cx'
    'JFChFhZ2dyZWdhdGVkX2JvdW5kcxgDIAEoCzIYLmNvbW1vbi52MS5Cb3VuZGluZ0JveDJEUhBh'
    'Z2dyZWdhdGVkQm91bmRz');

@$core.Deprecated('Use checkSitingConflictsRequestDescriptor instead')
const CheckSitingConflictsRequest$json = {
  '1': 'CheckSitingConflictsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'proposed_site_geometry_wkt', '3': 2, '4': 1, '5': 9, '10': 'proposedSiteGeometryWkt'},
    {'1': 'geometry_type', '3': 3, '4': 1, '5': 9, '10': 'geometryType'},
    {'1': 'geometry_bounds', '3': 4, '4': 1, '5': 11, '6': '.common.v1.BoundingBox2D', '10': 'geometryBounds'},
    {'1': 'check_zone_types', '3': 5, '4': 3, '5': 14, '6': '.constraint.v1.ZoneType', '10': 'checkZoneTypes'},
    {'1': 'include_buffer_zones', '3': 6, '4': 1, '5': 8, '10': 'includeBufferZones'},
    {'1': 'include_expired_zones', '3': 7, '4': 1, '5': 8, '10': 'includeExpiredZones'},
  ],
};

/// Descriptor for `CheckSitingConflictsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkSitingConflictsRequestDescriptor = $convert.base64Decode(
    'ChtDaGVja1NpdGluZ0NvbmZsaWN0c1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvam'
    'VjdElkEjsKGnByb3Bvc2VkX3NpdGVfZ2VvbWV0cnlfd2t0GAIgASgJUhdwcm9wb3NlZFNpdGVH'
    'ZW9tZXRyeVdrdBIjCg1nZW9tZXRyeV90eXBlGAMgASgJUgxnZW9tZXRyeVR5cGUSQQoPZ2VvbW'
    'V0cnlfYm91bmRzGAQgASgLMhguY29tbW9uLnYxLkJvdW5kaW5nQm94MkRSDmdlb21ldHJ5Qm91'
    'bmRzEkEKEGNoZWNrX3pvbmVfdHlwZXMYBSADKA4yFy5jb25zdHJhaW50LnYxLlpvbmVUeXBlUg'
    '5jaGVja1pvbmVUeXBlcxIwChRpbmNsdWRlX2J1ZmZlcl96b25lcxgGIAEoCFISaW5jbHVkZUJ1'
    'ZmZlclpvbmVzEjIKFWluY2x1ZGVfZXhwaXJlZF96b25lcxgHIAEoCFITaW5jbHVkZUV4cGlyZW'
    'Rab25lcw==');

@$core.Deprecated('Use checkSitingConflictsResponseDescriptor instead')
const CheckSitingConflictsResponse$json = {
  '1': 'CheckSitingConflictsResponse',
  '2': [
    {'1': 'conflicts', '3': 1, '4': 3, '5': 11, '6': '.constraint.v1.SitingConflict', '10': 'conflicts'},
    {'1': 'risk_score', '3': 2, '4': 1, '5': 11, '6': '.constraint.v1.RiskScore', '10': 'riskScore'},
    {'1': 'siting_recommendation', '3': 3, '4': 1, '5': 9, '10': 'sitingRecommendation'},
    {'1': 'total_zones_checked', '3': 4, '4': 1, '5': 5, '10': 'totalZonesChecked'},
  ],
};

/// Descriptor for `CheckSitingConflictsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List checkSitingConflictsResponseDescriptor = $convert.base64Decode(
    'ChxDaGVja1NpdGluZ0NvbmZsaWN0c1Jlc3BvbnNlEjsKCWNvbmZsaWN0cxgBIAMoCzIdLmNvbn'
    'N0cmFpbnQudjEuU2l0aW5nQ29uZmxpY3RSCWNvbmZsaWN0cxI3CgpyaXNrX3Njb3JlGAIgASgL'
    'MhguY29uc3RyYWludC52MS5SaXNrU2NvcmVSCXJpc2tTY29yZRIzChVzaXRpbmdfcmVjb21tZW'
    '5kYXRpb24YAyABKAlSFHNpdGluZ1JlY29tbWVuZGF0aW9uEi4KE3RvdGFsX3pvbmVzX2NoZWNr'
    'ZWQYBCABKAVSEXRvdGFsWm9uZXNDaGVja2Vk');

@$core.Deprecated('Use listZoneCategoriesRequestDescriptor instead')
const ListZoneCategoriesRequest$json = {
  '1': 'ListZoneCategoriesRequest',
};

/// Descriptor for `ListZoneCategoriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listZoneCategoriesRequestDescriptor = $convert.base64Decode(
    'ChlMaXN0Wm9uZUNhdGVnb3JpZXNSZXF1ZXN0');

@$core.Deprecated('Use listZoneCategoriesResponseDescriptor instead')
const ListZoneCategoriesResponse$json = {
  '1': 'ListZoneCategoriesResponse',
  '2': [
    {'1': 'categories', '3': 1, '4': 3, '5': 11, '6': '.constraint.v1.CategoryDef', '10': 'categories'},
  ],
};

/// Descriptor for `ListZoneCategoriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listZoneCategoriesResponseDescriptor = $convert.base64Decode(
    'ChpMaXN0Wm9uZUNhdGVnb3JpZXNSZXNwb25zZRI6CgpjYXRlZ29yaWVzGAEgAygLMhouY29uc3'
    'RyYWludC52MS5DYXRlZ29yeURlZlIKY2F0ZWdvcmllcw==');

const $core.Map<$core.String, $core.dynamic> ConstraintZoneServiceBase$json = {
  '1': 'ConstraintZoneService',
  '2': [
    {'1': 'CreateZone', '2': '.constraint.v1.CreateZoneRequest', '3': '.constraint.v1.CreateZoneResponse'},
    {'1': 'UpdateZone', '2': '.constraint.v1.UpdateZoneRequest', '3': '.constraint.v1.UpdateZoneResponse'},
    {'1': 'DeleteZone', '2': '.constraint.v1.DeleteZoneRequest', '3': '.constraint.v1.DeleteZoneResponse'},
    {'1': 'GetZone', '2': '.constraint.v1.GetZoneRequest', '3': '.constraint.v1.GetZoneResponse'},
    {'1': 'ListZones', '2': '.constraint.v1.ListZonesRequest', '3': '.constraint.v1.ListZonesResponse'},
    {'1': 'QueryZonesByLocation', '2': '.constraint.v1.QueryZonesByLocationRequest', '3': '.constraint.v1.QueryZonesByLocationResponse'},
    {'1': 'CheckSitingConflicts', '2': '.constraint.v1.CheckSitingConflictsRequest', '3': '.constraint.v1.CheckSitingConflictsResponse'},
    {'1': 'ListZoneCategories', '2': '.constraint.v1.ListZoneCategoriesRequest', '3': '.constraint.v1.ListZoneCategoriesResponse'},
  ],
};

@$core.Deprecated('Use constraintZoneServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> ConstraintZoneServiceBase$messageJson = {
  '.constraint.v1.CreateZoneRequest': CreateZoneRequest$json,
  '.google.protobuf.Timestamp': $1.Timestamp$json,
  '.constraint.v1.CreateZoneRequest.MetadataEntry': CreateZoneRequest_MetadataEntry$json,
  '.constraint.v1.CreateZoneResponse': CreateZoneResponse$json,
  '.constraint.v1.Zone': Zone$json,
  '.common.v1.BoundingBox2D': $0.BoundingBox2D$json,
  '.constraint.v1.Zone.MetadataEntry': Zone_MetadataEntry$json,
  '.constraint.v1.UpdateZoneRequest': UpdateZoneRequest$json,
  '.constraint.v1.UpdateZoneRequest.MetadataEntry': UpdateZoneRequest_MetadataEntry$json,
  '.constraint.v1.UpdateZoneResponse': UpdateZoneResponse$json,
  '.constraint.v1.DeleteZoneRequest': DeleteZoneRequest$json,
  '.constraint.v1.DeleteZoneResponse': DeleteZoneResponse$json,
  '.constraint.v1.GetZoneRequest': GetZoneRequest$json,
  '.constraint.v1.GetZoneResponse': GetZoneResponse$json,
  '.constraint.v1.ListZonesRequest': ListZonesRequest$json,
  '.constraint.v1.ListZonesResponse': ListZonesResponse$json,
  '.constraint.v1.QueryZonesByLocationRequest': QueryZonesByLocationRequest$json,
  '.constraint.v1.QueryZonesByLocationResponse': QueryZonesByLocationResponse$json,
  '.constraint.v1.SitingConflict': SitingConflict$json,
  '.constraint.v1.CheckSitingConflictsRequest': CheckSitingConflictsRequest$json,
  '.constraint.v1.CheckSitingConflictsResponse': CheckSitingConflictsResponse$json,
  '.constraint.v1.RiskScore': RiskScore$json,
  '.constraint.v1.ListZoneCategoriesRequest': ListZoneCategoriesRequest$json,
  '.constraint.v1.ListZoneCategoriesResponse': ListZoneCategoriesResponse$json,
  '.constraint.v1.CategoryDef': CategoryDef$json,
};

/// Descriptor for `ConstraintZoneService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List constraintZoneServiceDescriptor = $convert.base64Decode(
    'ChVDb25zdHJhaW50Wm9uZVNlcnZpY2USUQoKQ3JlYXRlWm9uZRIgLmNvbnN0cmFpbnQudjEuQ3'
    'JlYXRlWm9uZVJlcXVlc3QaIS5jb25zdHJhaW50LnYxLkNyZWF0ZVpvbmVSZXNwb25zZRJRCgpV'
    'cGRhdGVab25lEiAuY29uc3RyYWludC52MS5VcGRhdGVab25lUmVxdWVzdBohLmNvbnN0cmFpbn'
    'QudjEuVXBkYXRlWm9uZVJlc3BvbnNlElEKCkRlbGV0ZVpvbmUSIC5jb25zdHJhaW50LnYxLkRl'
    'bGV0ZVpvbmVSZXF1ZXN0GiEuY29uc3RyYWludC52MS5EZWxldGVab25lUmVzcG9uc2USSAoHR2'
    'V0Wm9uZRIdLmNvbnN0cmFpbnQudjEuR2V0Wm9uZVJlcXVlc3QaHi5jb25zdHJhaW50LnYxLkdl'
    'dFpvbmVSZXNwb25zZRJOCglMaXN0Wm9uZXMSHy5jb25zdHJhaW50LnYxLkxpc3Rab25lc1JlcX'
    'Vlc3QaIC5jb25zdHJhaW50LnYxLkxpc3Rab25lc1Jlc3BvbnNlEm8KFFF1ZXJ5Wm9uZXNCeUxv'
    'Y2F0aW9uEiouY29uc3RyYWludC52MS5RdWVyeVpvbmVzQnlMb2NhdGlvblJlcXVlc3QaKy5jb2'
    '5zdHJhaW50LnYxLlF1ZXJ5Wm9uZXNCeUxvY2F0aW9uUmVzcG9uc2USbwoUQ2hlY2tTaXRpbmdD'
    'b25mbGljdHMSKi5jb25zdHJhaW50LnYxLkNoZWNrU2l0aW5nQ29uZmxpY3RzUmVxdWVzdBorLm'
    'NvbnN0cmFpbnQudjEuQ2hlY2tTaXRpbmdDb25mbGljdHNSZXNwb25zZRJpChJMaXN0Wm9uZUNh'
    'dGVnb3JpZXMSKC5jb25zdHJhaW50LnYxLkxpc3Rab25lQ2F0ZWdvcmllc1JlcXVlc3QaKS5jb2'
    '5zdHJhaW50LnYxLkxpc3Rab25lQ2F0ZWdvcmllc1Jlc3BvbnNl');

