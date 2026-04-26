//
//  Generated code. Do not modify.
//  source: common/v1/primitives.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use apiVersionDescriptor instead')
const ApiVersion$json = {
  '1': 'ApiVersion',
  '2': [
    {'1': 'major', '3': 1, '4': 1, '5': 13, '10': 'major'},
    {'1': 'minor', '3': 2, '4': 1, '5': 13, '10': 'minor'},
    {'1': 'patch', '3': 3, '4': 1, '5': 13, '10': 'patch'},
  ],
};

/// Descriptor for `ApiVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List apiVersionDescriptor = $convert.base64Decode(
    'CgpBcGlWZXJzaW9uEhQKBW1ham9yGAEgASgNUgVtYWpvchIUCgVtaW5vchgCIAEoDVIFbWlub3'
    'ISFAoFcGF0Y2gYAyABKA1SBXBhdGNo');

@$core.Deprecated('Use contractMetadataDescriptor instead')
const ContractMetadata$json = {
  '1': 'ContractMetadata',
  '2': [
    {'1': 'schema_version', '3': 1, '4': 1, '5': 11, '6': '.common.v1.ApiVersion', '10': 'schemaVersion'},
    {'1': 'schema_id', '3': 2, '4': 1, '5': 9, '10': 'schemaId'},
    {'1': 'schema_hash', '3': 3, '4': 1, '5': 9, '10': 'schemaHash'},
    {'1': 'producer', '3': 4, '4': 1, '5': 9, '10': 'producer'},
    {'1': 'correlation_id', '3': 5, '4': 1, '5': 9, '10': 'correlationId'},
    {'1': 'created_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
  ],
};

/// Descriptor for `ContractMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contractMetadataDescriptor = $convert.base64Decode(
    'ChBDb250cmFjdE1ldGFkYXRhEjwKDnNjaGVtYV92ZXJzaW9uGAEgASgLMhUuY29tbW9uLnYxLk'
    'FwaVZlcnNpb25SDXNjaGVtYVZlcnNpb24SGwoJc2NoZW1hX2lkGAIgASgJUghzY2hlbWFJZBIf'
    'CgtzY2hlbWFfaGFzaBgDIAEoCVIKc2NoZW1hSGFzaBIaCghwcm9kdWNlchgEIAEoCVIIcHJvZH'
    'VjZXISJQoOY29ycmVsYXRpb25faWQYBSABKAlSDWNvcnJlbGF0aW9uSWQSOQoKY3JlYXRlZF9h'
    'dBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use point2DDescriptor instead')
const Point2D$json = {
  '1': 'Point2D',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
  ],
};

/// Descriptor for `Point2D`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List point2DDescriptor = $convert.base64Decode(
    'CgdQb2ludDJEEgwKAXgYASABKAFSAXgSDAoBeRgCIAEoAVIBeQ==');

@$core.Deprecated('Use point3DDescriptor instead')
const Point3D$json = {
  '1': 'Point3D',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 1, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 1, '10': 'y'},
    {'1': 'z', '3': 3, '4': 1, '5': 1, '10': 'z'},
  ],
};

/// Descriptor for `Point3D`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List point3DDescriptor = $convert.base64Decode(
    'CgdQb2ludDNEEgwKAXgYASABKAFSAXgSDAoBeRgCIAEoAVIBeRIMCgF6GAMgASgBUgF6');

@$core.Deprecated('Use boundingBox2DDescriptor instead')
const BoundingBox2D$json = {
  '1': 'BoundingBox2D',
  '2': [
    {'1': 'min_x', '3': 1, '4': 1, '5': 1, '10': 'minX'},
    {'1': 'min_y', '3': 2, '4': 1, '5': 1, '10': 'minY'},
    {'1': 'max_x', '3': 3, '4': 1, '5': 1, '10': 'maxX'},
    {'1': 'max_y', '3': 4, '4': 1, '5': 1, '10': 'maxY'},
  ],
};

/// Descriptor for `BoundingBox2D`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boundingBox2DDescriptor = $convert.base64Decode(
    'Cg1Cb3VuZGluZ0JveDJEEhMKBW1pbl94GAEgASgBUgRtaW5YEhMKBW1pbl95GAIgASgBUgRtaW'
    '5ZEhMKBW1heF94GAMgASgBUgRtYXhYEhMKBW1heF95GAQgASgBUgRtYXhZ');

@$core.Deprecated('Use lineString2DDescriptor instead')
const LineString2D$json = {
  '1': 'LineString2D',
  '2': [
    {'1': 'points', '3': 1, '4': 3, '5': 11, '6': '.common.v1.Point2D', '10': 'points'},
  ],
};

/// Descriptor for `LineString2D`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lineString2DDescriptor = $convert.base64Decode(
    'CgxMaW5lU3RyaW5nMkQSKgoGcG9pbnRzGAEgAygLMhIuY29tbW9uLnYxLlBvaW50MkRSBnBvaW'
    '50cw==');

@$core.Deprecated('Use polygon2DDescriptor instead')
const Polygon2D$json = {
  '1': 'Polygon2D',
  '2': [
    {'1': 'rings', '3': 1, '4': 3, '5': 11, '6': '.common.v1.LineString2D', '10': 'rings'},
  ],
};

/// Descriptor for `Polygon2D`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List polygon2DDescriptor = $convert.base64Decode(
    'CglQb2x5Z29uMkQSLQoFcmluZ3MYASADKAsyFy5jb21tb24udjEuTGluZVN0cmluZzJEUgVyaW'
    '5ncw==');

@$core.Deprecated('Use multiPolygon2DDescriptor instead')
const MultiPolygon2D$json = {
  '1': 'MultiPolygon2D',
  '2': [
    {'1': 'polygons', '3': 1, '4': 3, '5': 11, '6': '.common.v1.Polygon2D', '10': 'polygons'},
  ],
};

/// Descriptor for `MultiPolygon2D`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiPolygon2DDescriptor = $convert.base64Decode(
    'Cg5NdWx0aVBvbHlnb24yRBIwCghwb2x5Z29ucxgBIAMoCzIULmNvbW1vbi52MS5Qb2x5Z29uMk'
    'RSCHBvbHlnb25z');

@$core.Deprecated('Use numericRangeDescriptor instead')
const NumericRange$json = {
  '1': 'NumericRange',
  '2': [
    {'1': 'min', '3': 1, '4': 1, '5': 1, '10': 'min'},
    {'1': 'max', '3': 2, '4': 1, '5': 1, '10': 'max'},
  ],
};

/// Descriptor for `NumericRange`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List numericRangeDescriptor = $convert.base64Decode(
    'CgxOdW1lcmljUmFuZ2USEAoDbWluGAEgASgBUgNtaW4SEAoDbWF4GAIgASgBUgNtYXg=');

