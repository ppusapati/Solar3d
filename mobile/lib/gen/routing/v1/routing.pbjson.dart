//
//  Generated code. Do not modify.
//  source: routing/v1/routing.proto
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

@$core.Deprecated('Use routeTypeDescriptor instead')
const RouteType$json = {
  '1': 'RouteType',
  '2': [
    {'1': 'ROUTE_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'ROUTE_TYPE_DC_CABLE', '2': 1},
    {'1': 'ROUTE_TYPE_AC_CABLE', '2': 2},
    {'1': 'ROUTE_TYPE_COMMUNICATION', '2': 3},
    {'1': 'ROUTE_TYPE_ACCESS_ROAD', '2': 4},
    {'1': 'ROUTE_TYPE_SERVICE_ROAD', '2': 5},
    {'1': 'ROUTE_TYPE_FENCE', '2': 6},
  ],
};

/// Descriptor for `RouteType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List routeTypeDescriptor = $convert.base64Decode(
    'CglSb3V0ZVR5cGUSGgoWUk9VVEVfVFlQRV9VTlNQRUNJRklFRBAAEhcKE1JPVVRFX1RZUEVfRE'
    'NfQ0FCTEUQARIXChNST1VURV9UWVBFX0FDX0NBQkxFEAISHAoYUk9VVEVfVFlQRV9DT01NVU5J'
    'Q0FUSU9OEAMSGgoWUk9VVEVfVFlQRV9BQ0NFU1NfUk9BRBAEEhsKF1JPVVRFX1RZUEVfU0VSVk'
    'lDRV9ST0FEEAUSFAoQUk9VVEVfVFlQRV9GRU5DRRAG');

@$core.Deprecated('Use routeDescriptor instead')
const Route$json = {
  '1': 'Route',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'route_type', '3': 3, '4': 1, '5': 14, '6': '.routing.v1.RouteType', '10': 'routeType'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'geometry_geojson', '3': 5, '4': 1, '5': 9, '10': 'geometryGeojson'},
    {'1': 'distance_m', '3': 6, '4': 1, '5': 1, '10': 'distanceM'},
    {'1': 'cost_estimate', '3': 7, '4': 1, '5': 1, '10': 'costEstimate'},
    {'1': 'metadata', '3': 8, '4': 1, '5': 11, '6': '.routing.v1.RouteMetadata', '10': 'metadata'},
    {'1': 'created_at', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
  ],
};

/// Descriptor for `Route`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List routeDescriptor = $convert.base64Decode(
    'CgVSb3V0ZRIOCgJpZBgBIAEoCVICaWQSHQoKcHJvamVjdF9pZBgCIAEoCVIJcHJvamVjdElkEj'
    'QKCnJvdXRlX3R5cGUYAyABKA4yFS5yb3V0aW5nLnYxLlJvdXRlVHlwZVIJcm91dGVUeXBlEhIK'
    'BG5hbWUYBCABKAlSBG5hbWUSKQoQZ2VvbWV0cnlfZ2VvanNvbhgFIAEoCVIPZ2VvbWV0cnlHZW'
    '9qc29uEh0KCmRpc3RhbmNlX20YBiABKAFSCWRpc3RhbmNlTRIjCg1jb3N0X2VzdGltYXRlGAcg'
    'ASgBUgxjb3N0RXN0aW1hdGUSNQoIbWV0YWRhdGEYCCABKAsyGS5yb3V0aW5nLnYxLlJvdXRlTW'
    'V0YWRhdGFSCG1ldGFkYXRhEjkKCmNyZWF0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idWYu'
    'VGltZXN0YW1wUgljcmVhdGVkQXQ=');

@$core.Deprecated('Use routeMetadataDescriptor instead')
const RouteMetadata$json = {
  '1': 'RouteMetadata',
  '2': [
    {'1': 'cable_type', '3': 1, '4': 1, '5': 9, '10': 'cableType'},
    {'1': 'cable_size_mm2', '3': 2, '4': 1, '5': 1, '10': 'cableSizeMm2'},
    {'1': 'voltage_drop_percent', '3': 3, '4': 1, '5': 1, '10': 'voltageDropPercent'},
    {'1': 'max_slope_percent', '3': 4, '4': 1, '5': 1, '10': 'maxSlopePercent'},
  ],
};

/// Descriptor for `RouteMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List routeMetadataDescriptor = $convert.base64Decode(
    'Cg1Sb3V0ZU1ldGFkYXRhEh0KCmNhYmxlX3R5cGUYASABKAlSCWNhYmxlVHlwZRIkCg5jYWJsZV'
    '9zaXplX21tMhgCIAEoAVIMY2FibGVTaXplTW0yEjAKFHZvbHRhZ2VfZHJvcF9wZXJjZW50GAMg'
    'ASgBUhJ2b2x0YWdlRHJvcFBlcmNlbnQSKgoRbWF4X3Nsb3BlX3BlcmNlbnQYBCABKAFSD21heF'
    'Nsb3BlUGVyY2VudA==');

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

@$core.Deprecated('Use routeConstraintsDescriptor instead')
const RouteConstraints$json = {
  '1': 'RouteConstraints',
  '2': [
    {'1': 'max_slope_percent', '3': 1, '4': 1, '5': 1, '10': 'maxSlopePercent'},
    {'1': 'avoid_water', '3': 2, '4': 1, '5': 8, '10': 'avoidWater'},
    {'1': 'avoid_zone_geojsons', '3': 3, '4': 3, '5': 9, '10': 'avoidZoneGeojsons'},
    {'1': 'terrain_slope_penalty', '3': 4, '4': 1, '5': 1, '10': 'terrainSlopePenalty'},
  ],
};

/// Descriptor for `RouteConstraints`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List routeConstraintsDescriptor = $convert.base64Decode(
    'ChBSb3V0ZUNvbnN0cmFpbnRzEioKEW1heF9zbG9wZV9wZXJjZW50GAEgASgBUg9tYXhTbG9wZV'
    'BlcmNlbnQSHwoLYXZvaWRfd2F0ZXIYAiABKAhSCmF2b2lkV2F0ZXISLgoTYXZvaWRfem9uZV9n'
    'ZW9qc29ucxgDIAMoCVIRYXZvaWRab25lR2VvanNvbnMSMgoVdGVycmFpbl9zbG9wZV9wZW5hbH'
    'R5GAQgASgBUhN0ZXJyYWluU2xvcGVQZW5hbHR5');

@$core.Deprecated('Use createRouteRequestDescriptor instead')
const CreateRouteRequest$json = {
  '1': 'CreateRouteRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'route_type', '3': 3, '4': 1, '5': 14, '6': '.routing.v1.RouteType', '10': 'routeType'},
    {'1': 'geometry_geojson', '3': 4, '4': 1, '5': 9, '10': 'geometryGeojson'},
    {'1': 'distance_m', '3': 5, '4': 1, '5': 1, '10': 'distanceM'},
    {'1': 'cost_estimate', '3': 6, '4': 1, '5': 1, '10': 'costEstimate'},
    {'1': 'metadata', '3': 7, '4': 1, '5': 11, '6': '.routing.v1.RouteMetadata', '10': 'metadata'},
  ],
};

/// Descriptor for `CreateRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRouteRequestDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVSb3V0ZVJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElkEhIKBG'
    '5hbWUYAiABKAlSBG5hbWUSNAoKcm91dGVfdHlwZRgDIAEoDjIVLnJvdXRpbmcudjEuUm91dGVU'
    'eXBlUglyb3V0ZVR5cGUSKQoQZ2VvbWV0cnlfZ2VvanNvbhgEIAEoCVIPZ2VvbWV0cnlHZW9qc2'
    '9uEh0KCmRpc3RhbmNlX20YBSABKAFSCWRpc3RhbmNlTRIjCg1jb3N0X2VzdGltYXRlGAYgASgB'
    'Ugxjb3N0RXN0aW1hdGUSNQoIbWV0YWRhdGEYByABKAsyGS5yb3V0aW5nLnYxLlJvdXRlTWV0YW'
    'RhdGFSCG1ldGFkYXRh');

@$core.Deprecated('Use createRouteResponseDescriptor instead')
const CreateRouteResponse$json = {
  '1': 'CreateRouteResponse',
  '2': [
    {'1': 'route', '3': 1, '4': 1, '5': 11, '6': '.routing.v1.Route', '10': 'route'},
  ],
};

/// Descriptor for `CreateRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRouteResponseDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVSb3V0ZVJlc3BvbnNlEicKBXJvdXRlGAEgASgLMhEucm91dGluZy52MS5Sb3V0ZV'
    'IFcm91dGU=');

@$core.Deprecated('Use getRouteRequestDescriptor instead')
const GetRouteRequest$json = {
  '1': 'GetRouteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRouteRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRSb3V0ZVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use getRouteResponseDescriptor instead')
const GetRouteResponse$json = {
  '1': 'GetRouteResponse',
  '2': [
    {'1': 'route', '3': 1, '4': 1, '5': 11, '6': '.routing.v1.Route', '10': 'route'},
  ],
};

/// Descriptor for `GetRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getRouteResponseDescriptor = $convert.base64Decode(
    'ChBHZXRSb3V0ZVJlc3BvbnNlEicKBXJvdXRlGAEgASgLMhEucm91dGluZy52MS5Sb3V0ZVIFcm'
    '91dGU=');

@$core.Deprecated('Use calculateRouteRequestDescriptor instead')
const CalculateRouteRequest$json = {
  '1': 'CalculateRouteRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'source', '3': 2, '4': 1, '5': 11, '6': '.routing.v1.Waypoint', '10': 'source'},
    {'1': 'destination', '3': 3, '4': 1, '5': 11, '6': '.routing.v1.Waypoint', '10': 'destination'},
    {'1': 'route_type', '3': 4, '4': 1, '5': 14, '6': '.routing.v1.RouteType', '10': 'routeType'},
    {'1': 'constraints', '3': 5, '4': 1, '5': 11, '6': '.routing.v1.RouteConstraints', '10': 'constraints'},
    {'1': 'terrain_layer_id', '3': 6, '4': 1, '5': 9, '10': 'terrainLayerId'},
  ],
};

/// Descriptor for `CalculateRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateRouteRequestDescriptor = $convert.base64Decode(
    'ChVDYWxjdWxhdGVSb3V0ZVJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElkEi'
    'wKBnNvdXJjZRgCIAEoCzIULnJvdXRpbmcudjEuV2F5cG9pbnRSBnNvdXJjZRI2CgtkZXN0aW5h'
    'dGlvbhgDIAEoCzIULnJvdXRpbmcudjEuV2F5cG9pbnRSC2Rlc3RpbmF0aW9uEjQKCnJvdXRlX3'
    'R5cGUYBCABKA4yFS5yb3V0aW5nLnYxLlJvdXRlVHlwZVIJcm91dGVUeXBlEj4KC2NvbnN0cmFp'
    'bnRzGAUgASgLMhwucm91dGluZy52MS5Sb3V0ZUNvbnN0cmFpbnRzUgtjb25zdHJhaW50cxIoCh'
    'B0ZXJyYWluX2xheWVyX2lkGAYgASgJUg50ZXJyYWluTGF5ZXJJZA==');

@$core.Deprecated('Use calculateRouteResponseDescriptor instead')
const CalculateRouteResponse$json = {
  '1': 'CalculateRouteResponse',
  '2': [
    {'1': 'waypoints', '3': 1, '4': 3, '5': 11, '6': '.routing.v1.Waypoint', '10': 'waypoints'},
    {'1': 'distance_m', '3': 2, '4': 1, '5': 1, '10': 'distanceM'},
    {'1': 'cost_estimate', '3': 3, '4': 1, '5': 1, '10': 'costEstimate'},
    {'1': 'max_slope_encountered', '3': 4, '4': 1, '5': 1, '10': 'maxSlopeEncountered'},
  ],
};

/// Descriptor for `CalculateRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateRouteResponseDescriptor = $convert.base64Decode(
    'ChZDYWxjdWxhdGVSb3V0ZVJlc3BvbnNlEjIKCXdheXBvaW50cxgBIAMoCzIULnJvdXRpbmcudj'
    'EuV2F5cG9pbnRSCXdheXBvaW50cxIdCgpkaXN0YW5jZV9tGAIgASgBUglkaXN0YW5jZU0SIwoN'
    'Y29zdF9lc3RpbWF0ZRgDIAEoAVIMY29zdEVzdGltYXRlEjIKFW1heF9zbG9wZV9lbmNvdW50ZX'
    'JlZBgEIAEoAVITbWF4U2xvcGVFbmNvdW50ZXJlZA==');

@$core.Deprecated('Use createCableRouteRequestDescriptor instead')
const CreateCableRouteRequest$json = {
  '1': 'CreateCableRouteRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'source', '3': 3, '4': 1, '5': 11, '6': '.routing.v1.Waypoint', '10': 'source'},
    {'1': 'destination', '3': 4, '4': 1, '5': 11, '6': '.routing.v1.Waypoint', '10': 'destination'},
    {'1': 'cable_type', '3': 5, '4': 1, '5': 9, '10': 'cableType'},
    {'1': 'cable_size_mm2', '3': 6, '4': 1, '5': 1, '10': 'cableSizeMm2'},
    {'1': 'constraints', '3': 7, '4': 1, '5': 11, '6': '.routing.v1.RouteConstraints', '10': 'constraints'},
    {'1': 'terrain_layer_id', '3': 8, '4': 1, '5': 9, '10': 'terrainLayerId'},
  ],
};

/// Descriptor for `CreateCableRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCableRouteRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVDYWJsZVJvdXRlUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SW'
    'QSEgoEbmFtZRgCIAEoCVIEbmFtZRIsCgZzb3VyY2UYAyABKAsyFC5yb3V0aW5nLnYxLldheXBv'
    'aW50UgZzb3VyY2USNgoLZGVzdGluYXRpb24YBCABKAsyFC5yb3V0aW5nLnYxLldheXBvaW50Ug'
    'tkZXN0aW5hdGlvbhIdCgpjYWJsZV90eXBlGAUgASgJUgljYWJsZVR5cGUSJAoOY2FibGVfc2l6'
    'ZV9tbTIYBiABKAFSDGNhYmxlU2l6ZU1tMhI+Cgtjb25zdHJhaW50cxgHIAEoCzIcLnJvdXRpbm'
    'cudjEuUm91dGVDb25zdHJhaW50c1ILY29uc3RyYWludHMSKAoQdGVycmFpbl9sYXllcl9pZBgI'
    'IAEoCVIOdGVycmFpbkxheWVySWQ=');

@$core.Deprecated('Use createCableRouteResponseDescriptor instead')
const CreateCableRouteResponse$json = {
  '1': 'CreateCableRouteResponse',
  '2': [
    {'1': 'route', '3': 1, '4': 1, '5': 11, '6': '.routing.v1.Route', '10': 'route'},
  ],
};

/// Descriptor for `CreateCableRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createCableRouteResponseDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVDYWJsZVJvdXRlUmVzcG9uc2USJwoFcm91dGUYASABKAsyES5yb3V0aW5nLnYxLl'
    'JvdXRlUgVyb3V0ZQ==');

@$core.Deprecated('Use createRoadRouteRequestDescriptor instead')
const CreateRoadRouteRequest$json = {
  '1': 'CreateRoadRouteRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'source', '3': 3, '4': 1, '5': 11, '6': '.routing.v1.Waypoint', '10': 'source'},
    {'1': 'destination', '3': 4, '4': 1, '5': 11, '6': '.routing.v1.Waypoint', '10': 'destination'},
    {'1': 'road_width_m', '3': 5, '4': 1, '5': 1, '10': 'roadWidthM'},
    {'1': 'constraints', '3': 6, '4': 1, '5': 11, '6': '.routing.v1.RouteConstraints', '10': 'constraints'},
    {'1': 'terrain_layer_id', '3': 7, '4': 1, '5': 9, '10': 'terrainLayerId'},
  ],
};

/// Descriptor for `CreateRoadRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoadRouteRequestDescriptor = $convert.base64Decode(
    'ChZDcmVhdGVSb2FkUm91dGVSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZB'
    'ISCgRuYW1lGAIgASgJUgRuYW1lEiwKBnNvdXJjZRgDIAEoCzIULnJvdXRpbmcudjEuV2F5cG9p'
    'bnRSBnNvdXJjZRI2CgtkZXN0aW5hdGlvbhgEIAEoCzIULnJvdXRpbmcudjEuV2F5cG9pbnRSC2'
    'Rlc3RpbmF0aW9uEiAKDHJvYWRfd2lkdGhfbRgFIAEoAVIKcm9hZFdpZHRoTRI+Cgtjb25zdHJh'
    'aW50cxgGIAEoCzIcLnJvdXRpbmcudjEuUm91dGVDb25zdHJhaW50c1ILY29uc3RyYWludHMSKA'
    'oQdGVycmFpbl9sYXllcl9pZBgHIAEoCVIOdGVycmFpbkxheWVySWQ=');

@$core.Deprecated('Use createRoadRouteResponseDescriptor instead')
const CreateRoadRouteResponse$json = {
  '1': 'CreateRoadRouteResponse',
  '2': [
    {'1': 'route', '3': 1, '4': 1, '5': 11, '6': '.routing.v1.Route', '10': 'route'},
  ],
};

/// Descriptor for `CreateRoadRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoadRouteResponseDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVSb2FkUm91dGVSZXNwb25zZRInCgVyb3V0ZRgBIAEoCzIRLnJvdXRpbmcudjEuUm'
    '91dGVSBXJvdXRl');

@$core.Deprecated('Use listRoutesRequestDescriptor instead')
const ListRoutesRequest$json = {
  '1': 'ListRoutesRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'type_filter', '3': 2, '4': 1, '5': 14, '6': '.routing.v1.RouteType', '10': 'typeFilter'},
    {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `ListRoutesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoutesRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0Um91dGVzUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SWQSNgoLdH'
    'lwZV9maWx0ZXIYAiABKA4yFS5yb3V0aW5nLnYxLlJvdXRlVHlwZVIKdHlwZUZpbHRlchJNCgpw'
    'YWdpbmF0aW9uGAMgASgLMi0ucGFja2FnZXMuYXBpLnYxLnBhZ2luYXRpb24uUGFnaW5hdGlvbl'
    'JlcXVlc3RSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use listRoutesResponseDescriptor instead')
const ListRoutesResponse$json = {
  '1': 'ListRoutesResponse',
  '2': [
    {'1': 'routes', '3': 1, '4': 3, '5': 11, '6': '.routing.v1.Route', '10': 'routes'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `ListRoutesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listRoutesResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0Um91dGVzUmVzcG9uc2USKQoGcm91dGVzGAEgAygLMhEucm91dGluZy52MS5Sb3V0ZV'
    'IGcm91dGVzEk4KCnBhZ2luYXRpb24YAiABKAsyLi5wYWNrYWdlcy5hcGkudjEucGFnaW5hdGlv'
    'bi5QYWdpbmF0aW9uUmVzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use deleteRouteRequestDescriptor instead')
const DeleteRouteRequest$json = {
  '1': 'DeleteRouteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteRouteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRouteRequestDescriptor = $convert.base64Decode(
    'ChJEZWxldGVSb3V0ZVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use deleteRouteResponseDescriptor instead')
const DeleteRouteResponse$json = {
  '1': 'DeleteRouteResponse',
};

/// Descriptor for `DeleteRouteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteRouteResponseDescriptor = $convert.base64Decode(
    'ChNEZWxldGVSb3V0ZVJlc3BvbnNl');

@$core.Deprecated('Use optimizeRoutesRequestDescriptor instead')
const OptimizeRoutesRequest$json = {
  '1': 'OptimizeRoutesRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'route_type', '3': 2, '4': 1, '5': 14, '6': '.routing.v1.RouteType', '10': 'routeType'},
  ],
};

/// Descriptor for `OptimizeRoutesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List optimizeRoutesRequestDescriptor = $convert.base64Decode(
    'ChVPcHRpbWl6ZVJvdXRlc1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElkEj'
    'QKCnJvdXRlX3R5cGUYAiABKA4yFS5yb3V0aW5nLnYxLlJvdXRlVHlwZVIJcm91dGVUeXBl');

@$core.Deprecated('Use optimizeRoutesResponseDescriptor instead')
const OptimizeRoutesResponse$json = {
  '1': 'OptimizeRoutesResponse',
  '2': [
    {'1': 'optimized_routes', '3': 1, '4': 3, '5': 11, '6': '.routing.v1.Route', '10': 'optimizedRoutes'},
    {'1': 'total_distance_m', '3': 2, '4': 1, '5': 1, '10': 'totalDistanceM'},
    {'1': 'total_cost_estimate', '3': 3, '4': 1, '5': 1, '10': 'totalCostEstimate'},
  ],
};

/// Descriptor for `OptimizeRoutesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List optimizeRoutesResponseDescriptor = $convert.base64Decode(
    'ChZPcHRpbWl6ZVJvdXRlc1Jlc3BvbnNlEjwKEG9wdGltaXplZF9yb3V0ZXMYASADKAsyES5yb3'
    'V0aW5nLnYxLlJvdXRlUg9vcHRpbWl6ZWRSb3V0ZXMSKAoQdG90YWxfZGlzdGFuY2VfbRgCIAEo'
    'AVIOdG90YWxEaXN0YW5jZU0SLgoTdG90YWxfY29zdF9lc3RpbWF0ZRgDIAEoAVIRdG90YWxDb3'
    'N0RXN0aW1hdGU=');

const $core.Map<$core.String, $core.dynamic> RoutingServiceBase$json = {
  '1': 'RoutingService',
  '2': [
    {'1': 'CreateRoute', '2': '.routing.v1.CreateRouteRequest', '3': '.routing.v1.CreateRouteResponse'},
    {'1': 'GetRoute', '2': '.routing.v1.GetRouteRequest', '3': '.routing.v1.GetRouteResponse'},
    {'1': 'CalculateRoute', '2': '.routing.v1.CalculateRouteRequest', '3': '.routing.v1.CalculateRouteResponse'},
    {'1': 'CreateCableRoute', '2': '.routing.v1.CreateCableRouteRequest', '3': '.routing.v1.CreateCableRouteResponse'},
    {'1': 'CreateRoadRoute', '2': '.routing.v1.CreateRoadRouteRequest', '3': '.routing.v1.CreateRoadRouteResponse'},
    {'1': 'ListRoutes', '2': '.routing.v1.ListRoutesRequest', '3': '.routing.v1.ListRoutesResponse'},
    {'1': 'DeleteRoute', '2': '.routing.v1.DeleteRouteRequest', '3': '.routing.v1.DeleteRouteResponse'},
    {'1': 'OptimizeRoutes', '2': '.routing.v1.OptimizeRoutesRequest', '3': '.routing.v1.OptimizeRoutesResponse'},
  ],
};

@$core.Deprecated('Use routingServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> RoutingServiceBase$messageJson = {
  '.routing.v1.CreateRouteRequest': CreateRouteRequest$json,
  '.routing.v1.RouteMetadata': RouteMetadata$json,
  '.routing.v1.CreateRouteResponse': CreateRouteResponse$json,
  '.routing.v1.Route': Route$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.routing.v1.GetRouteRequest': GetRouteRequest$json,
  '.routing.v1.GetRouteResponse': GetRouteResponse$json,
  '.routing.v1.CalculateRouteRequest': CalculateRouteRequest$json,
  '.routing.v1.Waypoint': Waypoint$json,
  '.routing.v1.RouteConstraints': RouteConstraints$json,
  '.routing.v1.CalculateRouteResponse': CalculateRouteResponse$json,
  '.routing.v1.CreateCableRouteRequest': CreateCableRouteRequest$json,
  '.routing.v1.CreateCableRouteResponse': CreateCableRouteResponse$json,
  '.routing.v1.CreateRoadRouteRequest': CreateRoadRouteRequest$json,
  '.routing.v1.CreateRoadRouteResponse': CreateRoadRouteResponse$json,
  '.routing.v1.ListRoutesRequest': ListRoutesRequest$json,
  '.packages.api.v1.pagination.PaginationRequest': $1.PaginationRequest$json,
  '.google.protobuf.FieldMask': $2.FieldMask$json,
  '.routing.v1.ListRoutesResponse': ListRoutesResponse$json,
  '.packages.api.v1.pagination.PaginationResponse': $1.PaginationResponse$json,
  '.routing.v1.DeleteRouteRequest': DeleteRouteRequest$json,
  '.routing.v1.DeleteRouteResponse': DeleteRouteResponse$json,
  '.routing.v1.OptimizeRoutesRequest': OptimizeRoutesRequest$json,
  '.routing.v1.OptimizeRoutesResponse': OptimizeRoutesResponse$json,
};

/// Descriptor for `RoutingService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List routingServiceDescriptor = $convert.base64Decode(
    'Cg5Sb3V0aW5nU2VydmljZRJOCgtDcmVhdGVSb3V0ZRIeLnJvdXRpbmcudjEuQ3JlYXRlUm91dG'
    'VSZXF1ZXN0Gh8ucm91dGluZy52MS5DcmVhdGVSb3V0ZVJlc3BvbnNlEkUKCEdldFJvdXRlEhsu'
    'cm91dGluZy52MS5HZXRSb3V0ZVJlcXVlc3QaHC5yb3V0aW5nLnYxLkdldFJvdXRlUmVzcG9uc2'
    'USVwoOQ2FsY3VsYXRlUm91dGUSIS5yb3V0aW5nLnYxLkNhbGN1bGF0ZVJvdXRlUmVxdWVzdBoi'
    'LnJvdXRpbmcudjEuQ2FsY3VsYXRlUm91dGVSZXNwb25zZRJdChBDcmVhdGVDYWJsZVJvdXRlEi'
    'Mucm91dGluZy52MS5DcmVhdGVDYWJsZVJvdXRlUmVxdWVzdBokLnJvdXRpbmcudjEuQ3JlYXRl'
    'Q2FibGVSb3V0ZVJlc3BvbnNlEloKD0NyZWF0ZVJvYWRSb3V0ZRIiLnJvdXRpbmcudjEuQ3JlYX'
    'RlUm9hZFJvdXRlUmVxdWVzdBojLnJvdXRpbmcudjEuQ3JlYXRlUm9hZFJvdXRlUmVzcG9uc2US'
    'SwoKTGlzdFJvdXRlcxIdLnJvdXRpbmcudjEuTGlzdFJvdXRlc1JlcXVlc3QaHi5yb3V0aW5nLn'
    'YxLkxpc3RSb3V0ZXNSZXNwb25zZRJOCgtEZWxldGVSb3V0ZRIeLnJvdXRpbmcudjEuRGVsZXRl'
    'Um91dGVSZXF1ZXN0Gh8ucm91dGluZy52MS5EZWxldGVSb3V0ZVJlc3BvbnNlElcKDk9wdGltaX'
    'plUm91dGVzEiEucm91dGluZy52MS5PcHRpbWl6ZVJvdXRlc1JlcXVlc3QaIi5yb3V0aW5nLnYx'
    'Lk9wdGltaXplUm91dGVzUmVzcG9uc2U=');

