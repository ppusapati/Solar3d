//
//  Generated code. Do not modify.
//  source: solar/v1/solar.proto
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

@$core.Deprecated('Use solarPositionDescriptor instead')
const SolarPosition$json = {
  '1': 'SolarPosition',
  '2': [
    {'1': 'elevation_angle_deg', '3': 1, '4': 1, '5': 1, '10': 'elevationAngleDeg'},
    {'1': 'azimuth_angle_deg', '3': 2, '4': 1, '5': 1, '10': 'azimuthAngleDeg'},
    {'1': 'air_mass', '3': 3, '4': 1, '5': 1, '10': 'airMass'},
    {'1': 'zenith_angle_deg', '3': 4, '4': 1, '5': 1, '10': 'zenithAngleDeg'},
  ],
};

/// Descriptor for `SolarPosition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List solarPositionDescriptor = $convert.base64Decode(
    'Cg1Tb2xhclBvc2l0aW9uEi4KE2VsZXZhdGlvbl9hbmdsZV9kZWcYASABKAFSEWVsZXZhdGlvbk'
    'FuZ2xlRGVnEioKEWF6aW11dGhfYW5nbGVfZGVnGAIgASgBUg9hemltdXRoQW5nbGVEZWcSGQoI'
    'YWlyX21hc3MYAyABKAFSB2Fpck1hc3MSKAoQemVuaXRoX2FuZ2xlX2RlZxgEIAEoAVIOemVuaX'
    'RoQW5nbGVEZWc=');

@$core.Deprecated('Use solarPositionRequestDescriptor instead')
const SolarPositionRequest$json = {
  '1': 'SolarPositionRequest',
  '2': [
    {'1': 'timestamp_seconds', '3': 1, '4': 1, '5': 1, '10': 'timestampSeconds'},
    {'1': 'latitude_deg', '3': 2, '4': 1, '5': 1, '10': 'latitudeDeg'},
    {'1': 'longitude_deg', '3': 3, '4': 1, '5': 1, '10': 'longitudeDeg'},
    {'1': 'utc_offset_hours', '3': 4, '4': 1, '5': 1, '10': 'utcOffsetHours'},
  ],
};

/// Descriptor for `SolarPositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List solarPositionRequestDescriptor = $convert.base64Decode(
    'ChRTb2xhclBvc2l0aW9uUmVxdWVzdBIrChF0aW1lc3RhbXBfc2Vjb25kcxgBIAEoAVIQdGltZX'
    'N0YW1wU2Vjb25kcxIhCgxsYXRpdHVkZV9kZWcYAiABKAFSC2xhdGl0dWRlRGVnEiMKDWxvbmdp'
    'dHVkZV9kZWcYAyABKAFSDGxvbmdpdHVkZURlZxIoChB1dGNfb2Zmc2V0X2hvdXJzGAQgASgBUg'
    '51dGNPZmZzZXRIb3Vycw==');

@$core.Deprecated('Use solarPositionResponseDescriptor instead')
const SolarPositionResponse$json = {
  '1': 'SolarPositionResponse',
  '2': [
    {'1': 'position', '3': 1, '4': 1, '5': 11, '6': '.solar.v1.SolarPosition', '10': 'position'},
    {'1': 'is_night', '3': 2, '4': 1, '5': 8, '10': 'isNight'},
    {'1': 'contract', '3': 10, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `SolarPositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List solarPositionResponseDescriptor = $convert.base64Decode(
    'ChVTb2xhclBvc2l0aW9uUmVzcG9uc2USMwoIcG9zaXRpb24YASABKAsyFy5zb2xhci52MS5Tb2'
    'xhclBvc2l0aW9uUghwb3NpdGlvbhIZCghpc19uaWdodBgCIAEoCFIHaXNOaWdodBI3Cghjb250'
    'cmFjdBgKIAEoCzIbLmNvbW1vbi52MS5Db250cmFjdE1ldGFkYXRhUghjb250cmFjdA==');

@$core.Deprecated('Use obstacleDescriptor instead')
const Obstacle$json = {
  '1': 'Obstacle',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'base', '3': 2, '4': 1, '5': 11, '6': '.common.v1.Point3D', '10': 'base'},
    {'1': 'height_m', '3': 3, '4': 1, '5': 1, '10': 'heightM'},
    {'1': 'extent_m', '3': 4, '4': 1, '5': 1, '10': 'extentM'},
  ],
};

/// Descriptor for `Obstacle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List obstacleDescriptor = $convert.base64Decode(
    'CghPYnN0YWNsZRIOCgJpZBgBIAEoCVICaWQSJgoEYmFzZRgCIAEoCzISLmNvbW1vbi52MS5Qb2'
    'ludDNEUgRiYXNlEhkKCGhlaWdodF9tGAMgASgBUgdoZWlnaHRNEhkKCGV4dGVudF9tGAQgASgB'
    'UgdleHRlbnRN');

@$core.Deprecated('Use shadowPolygonDescriptor instead')
const ShadowPolygon$json = {
  '1': 'ShadowPolygon',
  '2': [
    {'1': 'obstacle_id', '3': 1, '4': 1, '5': 9, '10': 'obstacleId'},
    {'1': 'shadow_vertices', '3': 2, '4': 3, '5': 11, '6': '.common.v1.Point2D', '10': 'shadowVertices'},
    {'1': 'shadow_length_m', '3': 3, '4': 1, '5': 1, '10': 'shadowLengthM'},
    {'1': 'sun_elevation_deg', '3': 4, '4': 1, '5': 1, '10': 'sunElevationDeg'},
  ],
};

/// Descriptor for `ShadowPolygon`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shadowPolygonDescriptor = $convert.base64Decode(
    'Cg1TaGFkb3dQb2x5Z29uEh8KC29ic3RhY2xlX2lkGAEgASgJUgpvYnN0YWNsZUlkEjsKD3NoYW'
    'Rvd192ZXJ0aWNlcxgCIAMoCzISLmNvbW1vbi52MS5Qb2ludDJEUg5zaGFkb3dWZXJ0aWNlcxIm'
    'Cg9zaGFkb3dfbGVuZ3RoX20YAyABKAFSDXNoYWRvd0xlbmd0aE0SKgoRc3VuX2VsZXZhdGlvbl'
    '9kZWcYBCABKAFSD3N1bkVsZXZhdGlvbkRlZw==');

@$core.Deprecated('Use castShadowsRequestDescriptor instead')
const CastShadowsRequest$json = {
  '1': 'CastShadowsRequest',
  '2': [
    {'1': 'obstacles', '3': 1, '4': 3, '5': 11, '6': '.solar.v1.Obstacle', '10': 'obstacles'},
    {'1': 'sun_elevation_deg', '3': 2, '4': 1, '5': 1, '10': 'sunElevationDeg'},
    {'1': 'sun_azimuth_deg', '3': 3, '4': 1, '5': 1, '10': 'sunAzimuthDeg'},
    {'1': 'exaggeration', '3': 4, '4': 1, '5': 1, '10': 'exaggeration'},
  ],
};

/// Descriptor for `CastShadowsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List castShadowsRequestDescriptor = $convert.base64Decode(
    'ChJDYXN0U2hhZG93c1JlcXVlc3QSMAoJb2JzdGFjbGVzGAEgAygLMhIuc29sYXIudjEuT2JzdG'
    'FjbGVSCW9ic3RhY2xlcxIqChFzdW5fZWxldmF0aW9uX2RlZxgCIAEoAVIPc3VuRWxldmF0aW9u'
    'RGVnEiYKD3N1bl9hemltdXRoX2RlZxgDIAEoAVINc3VuQXppbXV0aERlZxIiCgxleGFnZ2VyYX'
    'Rpb24YBCABKAFSDGV4YWdnZXJhdGlvbg==');

@$core.Deprecated('Use castShadowsResponseDescriptor instead')
const CastShadowsResponse$json = {
  '1': 'CastShadowsResponse',
  '2': [
    {'1': 'shadows', '3': 1, '4': 3, '5': 11, '6': '.solar.v1.ShadowPolygon', '10': 'shadows'},
    {'1': 'shadow_count', '3': 2, '4': 1, '5': 5, '10': 'shadowCount'},
    {'1': 'contract', '3': 10, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `CastShadowsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List castShadowsResponseDescriptor = $convert.base64Decode(
    'ChNDYXN0U2hhZG93c1Jlc3BvbnNlEjEKB3NoYWRvd3MYASADKAsyFy5zb2xhci52MS5TaGFkb3'
    'dQb2x5Z29uUgdzaGFkb3dzEiEKDHNoYWRvd19jb3VudBgCIAEoBVILc2hhZG93Q291bnQSNwoI'
    'Y29udHJhY3QYCiABKAsyGy5jb21tb24udjEuQ29udHJhY3RNZXRhZGF0YVIIY29udHJhY3Q=');

@$core.Deprecated('Use dNIRequestDescriptor instead')
const DNIRequest$json = {
  '1': 'DNIRequest',
  '2': [
    {'1': 'air_mass', '3': 1, '4': 1, '5': 1, '10': 'airMass'},
    {'1': 'zenith_angle_deg', '3': 2, '4': 1, '5': 1, '10': 'zenithAngleDeg'},
    {'1': 'turbidity', '3': 3, '4': 1, '5': 1, '10': 'turbidity'},
  ],
};

/// Descriptor for `DNIRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dNIRequestDescriptor = $convert.base64Decode(
    'CgpETklSZXF1ZXN0EhkKCGFpcl9tYXNzGAEgASgBUgdhaXJNYXNzEigKEHplbml0aF9hbmdsZV'
    '9kZWcYAiABKAFSDnplbml0aEFuZ2xlRGVnEhwKCXR1cmJpZGl0eRgDIAEoAVIJdHVyYmlkaXR5');

@$core.Deprecated('Use dNIResponseDescriptor instead')
const DNIResponse$json = {
  '1': 'DNIResponse',
  '2': [
    {'1': 'dni_w_m2', '3': 1, '4': 1, '5': 1, '10': 'dniWM2'},
    {'1': 'valid', '3': 2, '4': 1, '5': 8, '10': 'valid'},
  ],
};

/// Descriptor for `DNIResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dNIResponseDescriptor = $convert.base64Decode(
    'CgtETklSZXNwb25zZRIYCghkbmlfd19tMhgBIAEoAVIGZG5pV00yEhQKBXZhbGlkGAIgASgIUg'
    'V2YWxpZA==');

@$core.Deprecated('Use dHIRequestDescriptor instead')
const DHIRequest$json = {
  '1': 'DHIRequest',
  '2': [
    {'1': 'zenith_angle_deg', '3': 1, '4': 1, '5': 1, '10': 'zenithAngleDeg'},
    {'1': 'clearness_index', '3': 2, '4': 1, '5': 1, '10': 'clearnessIndex'},
  ],
};

/// Descriptor for `DHIRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dHIRequestDescriptor = $convert.base64Decode(
    'CgpESElSZXF1ZXN0EigKEHplbml0aF9hbmdsZV9kZWcYASABKAFSDnplbml0aEFuZ2xlRGVnEi'
    'cKD2NsZWFybmVzc19pbmRleBgCIAEoAVIOY2xlYXJuZXNzSW5kZXg=');

@$core.Deprecated('Use dHIResponseDescriptor instead')
const DHIResponse$json = {
  '1': 'DHIResponse',
  '2': [
    {'1': 'dhi_w_m2', '3': 1, '4': 1, '5': 1, '10': 'dhiWM2'},
    {'1': 'valid', '3': 2, '4': 1, '5': 8, '10': 'valid'},
  ],
};

/// Descriptor for `DHIResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dHIResponseDescriptor = $convert.base64Decode(
    'CgtESElSZXNwb25zZRIYCghkaGlfd19tMhgBIAEoAVIGZGhpV00yEhQKBXZhbGlkGAIgASgIUg'
    'V2YWxpZA==');

@$core.Deprecated('Use timestampPositionDescriptor instead')
const TimestampPosition$json = {
  '1': 'TimestampPosition',
  '2': [
    {'1': 'timestamp_seconds', '3': 1, '4': 1, '5': 1, '10': 'timestampSeconds'},
    {'1': 'position', '3': 2, '4': 1, '5': 11, '6': '.solar.v1.SolarPosition', '10': 'position'},
  ],
};

/// Descriptor for `TimestampPosition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timestampPositionDescriptor = $convert.base64Decode(
    'ChFUaW1lc3RhbXBQb3NpdGlvbhIrChF0aW1lc3RhbXBfc2Vjb25kcxgBIAEoAVIQdGltZXN0YW'
    '1wU2Vjb25kcxIzCghwb3NpdGlvbhgCIAEoCzIXLnNvbGFyLnYxLlNvbGFyUG9zaXRpb25SCHBv'
    'c2l0aW9u');

@$core.Deprecated('Use bulkSolarPositionRequestDescriptor instead')
const BulkSolarPositionRequest$json = {
  '1': 'BulkSolarPositionRequest',
  '2': [
    {'1': 'timestamp_seconds', '3': 1, '4': 3, '5': 1, '10': 'timestampSeconds'},
    {'1': 'latitude_deg', '3': 2, '4': 1, '5': 1, '10': 'latitudeDeg'},
    {'1': 'longitude_deg', '3': 3, '4': 1, '5': 1, '10': 'longitudeDeg'},
    {'1': 'utc_offset_hours', '3': 4, '4': 1, '5': 1, '10': 'utcOffsetHours'},
  ],
};

/// Descriptor for `BulkSolarPositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bulkSolarPositionRequestDescriptor = $convert.base64Decode(
    'ChhCdWxrU29sYXJQb3NpdGlvblJlcXVlc3QSKwoRdGltZXN0YW1wX3NlY29uZHMYASADKAFSEH'
    'RpbWVzdGFtcFNlY29uZHMSIQoMbGF0aXR1ZGVfZGVnGAIgASgBUgtsYXRpdHVkZURlZxIjCg1s'
    'b25naXR1ZGVfZGVnGAMgASgBUgxsb25naXR1ZGVEZWcSKAoQdXRjX29mZnNldF9ob3VycxgEIA'
    'EoAVIOdXRjT2Zmc2V0SG91cnM=');

@$core.Deprecated('Use bulkSolarPositionResponseDescriptor instead')
const BulkSolarPositionResponse$json = {
  '1': 'BulkSolarPositionResponse',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.solar.v1.TimestampPosition', '10': 'results'},
    {'1': 'night_count', '3': 2, '4': 1, '5': 5, '10': 'nightCount'},
    {'1': 'contract', '3': 10, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `BulkSolarPositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List bulkSolarPositionResponseDescriptor = $convert.base64Decode(
    'ChlCdWxrU29sYXJQb3NpdGlvblJlc3BvbnNlEjUKB3Jlc3VsdHMYASADKAsyGy5zb2xhci52MS'
    '5UaW1lc3RhbXBQb3NpdGlvblIHcmVzdWx0cxIfCgtuaWdodF9jb3VudBgCIAEoBVIKbmlnaHRD'
    'b3VudBI3Cghjb250cmFjdBgKIAEoCzIbLmNvbW1vbi52MS5Db250cmFjdE1ldGFkYXRhUghjb2'
    '50cmFjdA==');

const $core.Map<$core.String, $core.dynamic> SolarServiceBase$json = {
  '1': 'SolarService',
  '2': [
    {'1': 'CalculateSolarPosition', '2': '.solar.v1.SolarPositionRequest', '3': '.solar.v1.SolarPositionResponse'},
    {'1': 'CastShadows', '2': '.solar.v1.CastShadowsRequest', '3': '.solar.v1.CastShadowsResponse'},
    {'1': 'CalculateDNI', '2': '.solar.v1.DNIRequest', '3': '.solar.v1.DNIResponse'},
    {'1': 'CalculateDHI', '2': '.solar.v1.DHIRequest', '3': '.solar.v1.DHIResponse'},
    {'1': 'BulkSolarPosition', '2': '.solar.v1.BulkSolarPositionRequest', '3': '.solar.v1.BulkSolarPositionResponse'},
  ],
};

@$core.Deprecated('Use solarServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> SolarServiceBase$messageJson = {
  '.solar.v1.SolarPositionRequest': SolarPositionRequest$json,
  '.solar.v1.SolarPositionResponse': SolarPositionResponse$json,
  '.solar.v1.SolarPosition': SolarPosition$json,
  '.common.v1.ContractMetadata': $0.ContractMetadata$json,
  '.common.v1.ApiVersion': $0.ApiVersion$json,
  '.google.protobuf.Timestamp': $1.Timestamp$json,
  '.solar.v1.CastShadowsRequest': CastShadowsRequest$json,
  '.solar.v1.Obstacle': Obstacle$json,
  '.common.v1.Point3D': $0.Point3D$json,
  '.solar.v1.CastShadowsResponse': CastShadowsResponse$json,
  '.solar.v1.ShadowPolygon': ShadowPolygon$json,
  '.common.v1.Point2D': $0.Point2D$json,
  '.solar.v1.DNIRequest': DNIRequest$json,
  '.solar.v1.DNIResponse': DNIResponse$json,
  '.solar.v1.DHIRequest': DHIRequest$json,
  '.solar.v1.DHIResponse': DHIResponse$json,
  '.solar.v1.BulkSolarPositionRequest': BulkSolarPositionRequest$json,
  '.solar.v1.BulkSolarPositionResponse': BulkSolarPositionResponse$json,
  '.solar.v1.TimestampPosition': TimestampPosition$json,
};

/// Descriptor for `SolarService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List solarServiceDescriptor = $convert.base64Decode(
    'CgxTb2xhclNlcnZpY2USWQoWQ2FsY3VsYXRlU29sYXJQb3NpdGlvbhIeLnNvbGFyLnYxLlNvbG'
    'FyUG9zaXRpb25SZXF1ZXN0Gh8uc29sYXIudjEuU29sYXJQb3NpdGlvblJlc3BvbnNlEkoKC0Nh'
    'c3RTaGFkb3dzEhwuc29sYXIudjEuQ2FzdFNoYWRvd3NSZXF1ZXN0Gh0uc29sYXIudjEuQ2FzdF'
    'NoYWRvd3NSZXNwb25zZRI7CgxDYWxjdWxhdGVETkkSFC5zb2xhci52MS5ETklSZXF1ZXN0GhUu'
    'c29sYXIudjEuRE5JUmVzcG9uc2USOwoMQ2FsY3VsYXRlREhJEhQuc29sYXIudjEuREhJUmVxdW'
    'VzdBoVLnNvbGFyLnYxLkRISVJlc3BvbnNlElwKEUJ1bGtTb2xhclBvc2l0aW9uEiIuc29sYXIu'
    'djEuQnVsa1NvbGFyUG9zaXRpb25SZXF1ZXN0GiMuc29sYXIudjEuQnVsa1NvbGFyUG9zaXRpb2'
    '5SZXNwb25zZQ==');

