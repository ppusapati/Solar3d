//
//  Generated code. Do not modify.
//  source: kml/v1/kml_ingestion.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../common/v1/primitives.pbjson.dart' as $1;
import '../../google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use cRSCodeDescriptor instead')
const CRSCode$json = {
  '1': 'CRSCode',
  '2': [
    {'1': 'CRS_UNKNOWN', '2': 0},
    {'1': 'CRS_WGS84', '2': 4326},
    {'1': 'CRS_WEB_MERCATOR', '2': 3857},
    {'1': 'CRS_UTM', '2': 32633},
  ],
};

/// Descriptor for `CRSCode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List cRSCodeDescriptor = $convert.base64Decode(
    'CgdDUlNDb2RlEg8KC0NSU19VTktOT1dOEAASDgoJQ1JTX1dHUzg0EOYhEhUKEENSU19XRUJfTU'
    'VSQ0FUT1IQkR4SDQoHQ1JTX1VUTRD5/gE=');

@$core.Deprecated('Use uploadStatusDescriptor instead')
const UploadStatus$json = {
  '1': 'UploadStatus',
  '2': [
    {'1': 'STATUS_UNKNOWN', '2': 0},
    {'1': 'STATUS_PENDING', '2': 1},
    {'1': 'STATUS_PROCESSING', '2': 2},
    {'1': 'STATUS_COMPLETED', '2': 3},
    {'1': 'STATUS_FAILED', '2': 4},
  ],
};

/// Descriptor for `UploadStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List uploadStatusDescriptor = $convert.base64Decode(
    'CgxVcGxvYWRTdGF0dXMSEgoOU1RBVFVTX1VOS05PV04QABISCg5TVEFUVVNfUEVORElORxABEh'
    'UKEVNUQVRVU19QUk9DRVNTSU5HEAISFAoQU1RBVFVTX0NPTVBMRVRFRBADEhEKDVNUQVRVU19G'
    'QUlMRUQQBA==');

@$core.Deprecated('Use geometryTypeDescriptor instead')
const GeometryType$json = {
  '1': 'GeometryType',
  '2': [
    {'1': 'TYPE_UNKNOWN', '2': 0},
    {'1': 'TYPE_POINT', '2': 1},
    {'1': 'TYPE_LINESTRING', '2': 2},
    {'1': 'TYPE_POLYGON', '2': 3},
    {'1': 'TYPE_MULTIPOLYGON', '2': 4},
  ],
};

/// Descriptor for `GeometryType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List geometryTypeDescriptor = $convert.base64Decode(
    'CgxHZW9tZXRyeVR5cGUSEAoMVFlQRV9VTktOT1dOEAASDgoKVFlQRV9QT0lOVBABEhMKD1RZUE'
    'VfTElORVNUUklORxACEhAKDFRZUEVfUE9MWUdPThADEhUKEVRZUEVfTVVMVElQT0xZR09OEAQ=');

@$core.Deprecated('Use uploadKMLRequestDescriptor instead')
const UploadKMLRequest$json = {
  '1': 'UploadKMLRequest',
  '2': [
    {'1': 'file_data', '3': 1, '4': 1, '5': 12, '10': 'fileData'},
    {'1': 'file_name', '3': 2, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'source_crs', '3': 3, '4': 1, '5': 14, '6': '.kml.v1.CRSCode', '10': 'sourceCrs'},
    {'1': 'project_id', '3': 4, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'tags', '3': 5, '4': 3, '5': 11, '6': '.kml.v1.UploadKMLRequest.TagsEntry', '10': 'tags'},
  ],
  '3': [UploadKMLRequest_TagsEntry$json],
};

@$core.Deprecated('Use uploadKMLRequestDescriptor instead')
const UploadKMLRequest_TagsEntry$json = {
  '1': 'TagsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `UploadKMLRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadKMLRequestDescriptor = $convert.base64Decode(
    'ChBVcGxvYWRLTUxSZXF1ZXN0EhsKCWZpbGVfZGF0YRgBIAEoDFIIZmlsZURhdGESGwoJZmlsZV'
    '9uYW1lGAIgASgJUghmaWxlTmFtZRIuCgpzb3VyY2VfY3JzGAMgASgOMg8ua21sLnYxLkNSU0Nv'
    'ZGVSCXNvdXJjZUNycxIdCgpwcm9qZWN0X2lkGAQgASgJUglwcm9qZWN0SWQSNgoEdGFncxgFIA'
    'MoCzIiLmttbC52MS5VcGxvYWRLTUxSZXF1ZXN0LlRhZ3NFbnRyeVIEdGFncxo3CglUYWdzRW50'
    'cnkSEAoDa2V5GAEgASgJUgNrZXkSFAoFdmFsdWUYAiABKAlSBXZhbHVlOgI4AQ==');

@$core.Deprecated('Use uploadKMLResponseDescriptor instead')
const UploadKMLResponse$json = {
  '1': 'UploadKMLResponse',
  '2': [
    {'1': 'upload_job_id', '3': 1, '4': 1, '5': 9, '10': 'uploadJobId'},
    {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.kml.v1.UploadStatus', '10': 'status'},
    {'1': 'created_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
  ],
};

/// Descriptor for `UploadKMLResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadKMLResponseDescriptor = $convert.base64Decode(
    'ChFVcGxvYWRLTUxSZXNwb25zZRIiCg11cGxvYWRfam9iX2lkGAEgASgJUgt1cGxvYWRKb2JJZB'
    'IsCgZzdGF0dXMYAiABKA4yFC5rbWwudjEuVXBsb2FkU3RhdHVzUgZzdGF0dXMSOQoKY3JlYXRl'
    'ZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use getUploadStatusRequestDescriptor instead')
const GetUploadStatusRequest$json = {
  '1': 'GetUploadStatusRequest',
  '2': [
    {'1': 'upload_job_id', '3': 1, '4': 1, '5': 9, '10': 'uploadJobId'},
  ],
};

/// Descriptor for `GetUploadStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUploadStatusRequestDescriptor = $convert.base64Decode(
    'ChZHZXRVcGxvYWRTdGF0dXNSZXF1ZXN0EiIKDXVwbG9hZF9qb2JfaWQYASABKAlSC3VwbG9hZE'
    'pvYklk');

@$core.Deprecated('Use getUploadStatusResponseDescriptor instead')
const GetUploadStatusResponse$json = {
  '1': 'GetUploadStatusResponse',
  '2': [
    {'1': 'upload_job_id', '3': 1, '4': 1, '5': 9, '10': 'uploadJobId'},
    {'1': 'status', '3': 2, '4': 1, '5': 14, '6': '.kml.v1.UploadStatus', '10': 'status'},
    {'1': 'features_processed', '3': 3, '4': 1, '5': 5, '10': 'featuresProcessed'},
    {'1': 'total_features', '3': 4, '4': 1, '5': 5, '10': 'totalFeatures'},
    {'1': 'error_message', '3': 5, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'started_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'startedAt'},
    {'1': 'completed_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'completedAt'},
    {'1': 'detected_crs', '3': 8, '4': 1, '5': 14, '6': '.kml.v1.CRSCode', '10': 'detectedCrs'},
  ],
};

/// Descriptor for `GetUploadStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getUploadStatusResponseDescriptor = $convert.base64Decode(
    'ChdHZXRVcGxvYWRTdGF0dXNSZXNwb25zZRIiCg11cGxvYWRfam9iX2lkGAEgASgJUgt1cGxvYW'
    'RKb2JJZBIsCgZzdGF0dXMYAiABKA4yFC5rbWwudjEuVXBsb2FkU3RhdHVzUgZzdGF0dXMSLQoS'
    'ZmVhdHVyZXNfcHJvY2Vzc2VkGAMgASgFUhFmZWF0dXJlc1Byb2Nlc3NlZBIlCg50b3RhbF9mZW'
    'F0dXJlcxgEIAEoBVINdG90YWxGZWF0dXJlcxIjCg1lcnJvcl9tZXNzYWdlGAUgASgJUgxlcnJv'
    'ck1lc3NhZ2USOQoKc3RhcnRlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCXN0YXJ0ZWRBdBI9Cgxjb21wbGV0ZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGlt'
    'ZXN0YW1wUgtjb21wbGV0ZWRBdBIyCgxkZXRlY3RlZF9jcnMYCCABKA4yDy5rbWwudjEuQ1JTQ2'
    '9kZVILZGV0ZWN0ZWRDcnM=');

@$core.Deprecated('Use listImportedGeometriesRequestDescriptor instead')
const ListImportedGeometriesRequest$json = {
  '1': 'ListImportedGeometriesRequest',
  '2': [
    {'1': 'upload_job_id', '3': 1, '4': 1, '5': 9, '10': 'uploadJobId'},
    {'1': 'geometry_type', '3': 2, '4': 1, '5': 14, '6': '.kml.v1.GeometryType', '10': 'geometryType'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'offset', '3': 4, '4': 1, '5': 5, '10': 'offset'},
  ],
};

/// Descriptor for `ListImportedGeometriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listImportedGeometriesRequestDescriptor = $convert.base64Decode(
    'Ch1MaXN0SW1wb3J0ZWRHZW9tZXRyaWVzUmVxdWVzdBIiCg11cGxvYWRfam9iX2lkGAEgASgJUg'
    't1cGxvYWRKb2JJZBI5Cg1nZW9tZXRyeV90eXBlGAIgASgOMhQua21sLnYxLkdlb21ldHJ5VHlw'
    'ZVIMZ2VvbWV0cnlUeXBlEhQKBWxpbWl0GAMgASgFUgVsaW1pdBIWCgZvZmZzZXQYBCABKAVSBm'
    '9mZnNldA==');

@$core.Deprecated('Use importedGeometryStubDescriptor instead')
const ImportedGeometryStub$json = {
  '1': 'ImportedGeometryStub',
  '2': [
    {'1': 'geometry_id', '3': 1, '4': 1, '5': 9, '10': 'geometryId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'type', '3': 3, '4': 1, '5': 14, '6': '.kml.v1.GeometryType', '10': 'type'},
    {'1': 'bounding_box', '3': 4, '4': 1, '5': 11, '6': '.common.v1.BoundingBox2D', '10': 'boundingBox'},
    {'1': 'feature_count', '3': 5, '4': 1, '5': 5, '10': 'featureCount'},
  ],
};

/// Descriptor for `ImportedGeometryStub`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importedGeometryStubDescriptor = $convert.base64Decode(
    'ChRJbXBvcnRlZEdlb21ldHJ5U3R1YhIfCgtnZW9tZXRyeV9pZBgBIAEoCVIKZ2VvbWV0cnlJZB'
    'ISCgRuYW1lGAIgASgJUgRuYW1lEigKBHR5cGUYAyABKA4yFC5rbWwudjEuR2VvbWV0cnlUeXBl'
    'UgR0eXBlEjsKDGJvdW5kaW5nX2JveBgEIAEoCzIYLmNvbW1vbi52MS5Cb3VuZGluZ0JveDJEUg'
    'tib3VuZGluZ0JveBIjCg1mZWF0dXJlX2NvdW50GAUgASgFUgxmZWF0dXJlQ291bnQ=');

@$core.Deprecated('Use listImportedGeometriesResponseDescriptor instead')
const ListImportedGeometriesResponse$json = {
  '1': 'ListImportedGeometriesResponse',
  '2': [
    {'1': 'geometries', '3': 1, '4': 3, '5': 11, '6': '.kml.v1.ImportedGeometryStub', '10': 'geometries'},
    {'1': 'total_count', '3': 2, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListImportedGeometriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listImportedGeometriesResponseDescriptor = $convert.base64Decode(
    'Ch5MaXN0SW1wb3J0ZWRHZW9tZXRyaWVzUmVzcG9uc2USPAoKZ2VvbWV0cmllcxgBIAMoCzIcLm'
    'ttbC52MS5JbXBvcnRlZEdlb21ldHJ5U3R1YlIKZ2VvbWV0cmllcxIfCgt0b3RhbF9jb3VudBgC'
    'IAEoBVIKdG90YWxDb3VudA==');

@$core.Deprecated('Use getImportedGeometryRequestDescriptor instead')
const GetImportedGeometryRequest$json = {
  '1': 'GetImportedGeometryRequest',
  '2': [
    {'1': 'upload_job_id', '3': 1, '4': 1, '5': 9, '10': 'uploadJobId'},
    {'1': 'geometry_id', '3': 2, '4': 1, '5': 9, '10': 'geometryId'},
  ],
};

/// Descriptor for `GetImportedGeometryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getImportedGeometryRequestDescriptor = $convert.base64Decode(
    'ChpHZXRJbXBvcnRlZEdlb21ldHJ5UmVxdWVzdBIiCg11cGxvYWRfam9iX2lkGAEgASgJUgt1cG'
    'xvYWRKb2JJZBIfCgtnZW9tZXRyeV9pZBgCIAEoCVIKZ2VvbWV0cnlJZA==');

@$core.Deprecated('Use getImportedGeometryResponseDescriptor instead')
const GetImportedGeometryResponse$json = {
  '1': 'GetImportedGeometryResponse',
  '2': [
    {'1': 'geometry_id', '3': 1, '4': 1, '5': 9, '10': 'geometryId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'properties', '3': 4, '4': 3, '5': 11, '6': '.kml.v1.GetImportedGeometryResponse.PropertiesEntry', '10': 'properties'},
    {'1': 'type', '3': 5, '4': 1, '5': 14, '6': '.kml.v1.GeometryType', '10': 'type'},
    {'1': 'point', '3': 6, '4': 1, '5': 11, '6': '.common.v1.Point2D', '9': 0, '10': 'point'},
    {'1': 'linestring', '3': 7, '4': 1, '5': 11, '6': '.common.v1.LineString2D', '9': 0, '10': 'linestring'},
    {'1': 'polygon', '3': 8, '4': 1, '5': 11, '6': '.common.v1.Polygon2D', '9': 0, '10': 'polygon'},
    {'1': 'multipolygon', '3': 9, '4': 1, '5': 11, '6': '.common.v1.MultiPolygon2D', '9': 0, '10': 'multipolygon'},
    {'1': 'source_crs', '3': 10, '4': 1, '5': 14, '6': '.kml.v1.CRSCode', '10': 'sourceCrs'},
    {'1': 'bounding_box', '3': 11, '4': 1, '5': 11, '6': '.common.v1.BoundingBox2D', '10': 'boundingBox'},
    {'1': 'geometry_hash', '3': 12, '4': 1, '5': 9, '10': 'geometryHash'},
    {'1': 'imported_at', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'importedAt'},
  ],
  '3': [GetImportedGeometryResponse_PropertiesEntry$json],
  '8': [
    {'1': 'canonical_geometry'},
  ],
};

@$core.Deprecated('Use getImportedGeometryResponseDescriptor instead')
const GetImportedGeometryResponse_PropertiesEntry$json = {
  '1': 'PropertiesEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `GetImportedGeometryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getImportedGeometryResponseDescriptor = $convert.base64Decode(
    'ChtHZXRJbXBvcnRlZEdlb21ldHJ5UmVzcG9uc2USHwoLZ2VvbWV0cnlfaWQYASABKAlSCmdlb2'
    '1ldHJ5SWQSEgoEbmFtZRgCIAEoCVIEbmFtZRIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3Jp'
    'cHRpb24SUwoKcHJvcGVydGllcxgEIAMoCzIzLmttbC52MS5HZXRJbXBvcnRlZEdlb21ldHJ5Um'
    'VzcG9uc2UuUHJvcGVydGllc0VudHJ5Ugpwcm9wZXJ0aWVzEigKBHR5cGUYBSABKA4yFC5rbWwu'
    'djEuR2VvbWV0cnlUeXBlUgR0eXBlEioKBXBvaW50GAYgASgLMhIuY29tbW9uLnYxLlBvaW50Mk'
    'RIAFIFcG9pbnQSOQoKbGluZXN0cmluZxgHIAEoCzIXLmNvbW1vbi52MS5MaW5lU3RyaW5nMkRI'
    'AFIKbGluZXN0cmluZxIwCgdwb2x5Z29uGAggASgLMhQuY29tbW9uLnYxLlBvbHlnb24yREgAUg'
    'dwb2x5Z29uEj8KDG11bHRpcG9seWdvbhgJIAEoCzIZLmNvbW1vbi52MS5NdWx0aVBvbHlnb24y'
    'REgAUgxtdWx0aXBvbHlnb24SLgoKc291cmNlX2NycxgKIAEoDjIPLmttbC52MS5DUlNDb2RlUg'
    'lzb3VyY2VDcnMSOwoMYm91bmRpbmdfYm94GAsgASgLMhguY29tbW9uLnYxLkJvdW5kaW5nQm94'
    'MkRSC2JvdW5kaW5nQm94EiMKDWdlb21ldHJ5X2hhc2gYDCABKAlSDGdlb21ldHJ5SGFzaBI7Cg'
    'tpbXBvcnRlZF9hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmltcG9ydGVk'
    'QXQaPQoPUHJvcGVydGllc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUg'
    'V2YWx1ZToCOAFCFAoSY2Fub25pY2FsX2dlb21ldHJ5');

@$core.Deprecated('Use deleteUploadRequestDescriptor instead')
const DeleteUploadRequest$json = {
  '1': 'DeleteUploadRequest',
  '2': [
    {'1': 'upload_job_id', '3': 1, '4': 1, '5': 9, '10': 'uploadJobId'},
  ],
};

/// Descriptor for `DeleteUploadRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteUploadRequestDescriptor = $convert.base64Decode(
    'ChNEZWxldGVVcGxvYWRSZXF1ZXN0EiIKDXVwbG9hZF9qb2JfaWQYASABKAlSC3VwbG9hZEpvYk'
    'lk');

@$core.Deprecated('Use deleteUploadResponseDescriptor instead')
const DeleteUploadResponse$json = {
  '1': 'DeleteUploadResponse',
  '2': [
    {'1': 'upload_job_id', '3': 1, '4': 1, '5': 9, '10': 'uploadJobId'},
    {'1': 'deleted', '3': 2, '4': 1, '5': 8, '10': 'deleted'},
    {'1': 'geometries_deleted', '3': 3, '4': 1, '5': 5, '10': 'geometriesDeleted'},
  ],
};

/// Descriptor for `DeleteUploadResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteUploadResponseDescriptor = $convert.base64Decode(
    'ChREZWxldGVVcGxvYWRSZXNwb25zZRIiCg11cGxvYWRfam9iX2lkGAEgASgJUgt1cGxvYWRKb2'
    'JJZBIYCgdkZWxldGVkGAIgASgIUgdkZWxldGVkEi0KEmdlb21ldHJpZXNfZGVsZXRlZBgDIAEo'
    'BVIRZ2VvbWV0cmllc0RlbGV0ZWQ=');

const $core.Map<$core.String, $core.dynamic> KMLIngestionServiceBase$json = {
  '1': 'KMLIngestionService',
  '2': [
    {'1': 'UploadKML', '2': '.kml.v1.UploadKMLRequest', '3': '.kml.v1.UploadKMLResponse'},
    {'1': 'GetUploadStatus', '2': '.kml.v1.GetUploadStatusRequest', '3': '.kml.v1.GetUploadStatusResponse'},
    {'1': 'ListImportedGeometries', '2': '.kml.v1.ListImportedGeometriesRequest', '3': '.kml.v1.ListImportedGeometriesResponse'},
    {'1': 'GetImportedGeometry', '2': '.kml.v1.GetImportedGeometryRequest', '3': '.kml.v1.GetImportedGeometryResponse'},
    {'1': 'DeleteUpload', '2': '.kml.v1.DeleteUploadRequest', '3': '.kml.v1.DeleteUploadResponse'},
  ],
};

@$core.Deprecated('Use kMLIngestionServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> KMLIngestionServiceBase$messageJson = {
  '.kml.v1.UploadKMLRequest': UploadKMLRequest$json,
  '.kml.v1.UploadKMLRequest.TagsEntry': UploadKMLRequest_TagsEntry$json,
  '.kml.v1.UploadKMLResponse': UploadKMLResponse$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.kml.v1.GetUploadStatusRequest': GetUploadStatusRequest$json,
  '.kml.v1.GetUploadStatusResponse': GetUploadStatusResponse$json,
  '.kml.v1.ListImportedGeometriesRequest': ListImportedGeometriesRequest$json,
  '.kml.v1.ListImportedGeometriesResponse': ListImportedGeometriesResponse$json,
  '.kml.v1.ImportedGeometryStub': ImportedGeometryStub$json,
  '.common.v1.BoundingBox2D': $1.BoundingBox2D$json,
  '.kml.v1.GetImportedGeometryRequest': GetImportedGeometryRequest$json,
  '.kml.v1.GetImportedGeometryResponse': GetImportedGeometryResponse$json,
  '.kml.v1.GetImportedGeometryResponse.PropertiesEntry': GetImportedGeometryResponse_PropertiesEntry$json,
  '.common.v1.Point2D': $1.Point2D$json,
  '.common.v1.LineString2D': $1.LineString2D$json,
  '.common.v1.Polygon2D': $1.Polygon2D$json,
  '.common.v1.MultiPolygon2D': $1.MultiPolygon2D$json,
  '.kml.v1.DeleteUploadRequest': DeleteUploadRequest$json,
  '.kml.v1.DeleteUploadResponse': DeleteUploadResponse$json,
};

/// Descriptor for `KMLIngestionService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List kMLIngestionServiceDescriptor = $convert.base64Decode(
    'ChNLTUxJbmdlc3Rpb25TZXJ2aWNlEkAKCVVwbG9hZEtNTBIYLmttbC52MS5VcGxvYWRLTUxSZX'
    'F1ZXN0Ghkua21sLnYxLlVwbG9hZEtNTFJlc3BvbnNlElIKD0dldFVwbG9hZFN0YXR1cxIeLmtt'
    'bC52MS5HZXRVcGxvYWRTdGF0dXNSZXF1ZXN0Gh8ua21sLnYxLkdldFVwbG9hZFN0YXR1c1Jlc3'
    'BvbnNlEmcKFkxpc3RJbXBvcnRlZEdlb21ldHJpZXMSJS5rbWwudjEuTGlzdEltcG9ydGVkR2Vv'
    'bWV0cmllc1JlcXVlc3QaJi5rbWwudjEuTGlzdEltcG9ydGVkR2VvbWV0cmllc1Jlc3BvbnNlEl'
    '4KE0dldEltcG9ydGVkR2VvbWV0cnkSIi5rbWwudjEuR2V0SW1wb3J0ZWRHZW9tZXRyeVJlcXVl'
    'c3QaIy5rbWwudjEuR2V0SW1wb3J0ZWRHZW9tZXRyeVJlc3BvbnNlEkkKDERlbGV0ZVVwbG9hZB'
    'IbLmttbC52MS5EZWxldGVVcGxvYWRSZXF1ZXN0Ghwua21sLnYxLkRlbGV0ZVVwbG9hZFJlc3Bv'
    'bnNl');

