//
//  Generated code. Do not modify.
//  source: terrain/v1/terrain.proto
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

@$core.Deprecated('Use terrainLayerTypeDescriptor instead')
const TerrainLayerType$json = {
  '1': 'TerrainLayerType',
  '2': [
    {'1': 'TERRAIN_LAYER_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'TERRAIN_LAYER_TYPE_DEM', '2': 1},
    {'1': 'TERRAIN_LAYER_TYPE_SLOPE', '2': 2},
    {'1': 'TERRAIN_LAYER_TYPE_ASPECT', '2': 3},
    {'1': 'TERRAIN_LAYER_TYPE_HILLSHADE', '2': 4},
  ],
};

/// Descriptor for `TerrainLayerType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List terrainLayerTypeDescriptor = $convert.base64Decode(
    'ChBUZXJyYWluTGF5ZXJUeXBlEiIKHlRFUlJBSU5fTEFZRVJfVFlQRV9VTlNQRUNJRklFRBAAEh'
    'oKFlRFUlJBSU5fTEFZRVJfVFlQRV9ERU0QARIcChhURVJSQUlOX0xBWUVSX1RZUEVfU0xPUEUQ'
    'AhIdChlURVJSQUlOX0xBWUVSX1RZUEVfQVNQRUNUEAMSIAocVEVSUkFJTl9MQVlFUl9UWVBFX0'
    'hJTExTSEFERRAE');

@$core.Deprecated('Use terrainLayerDescriptor instead')
const TerrainLayer$json = {
  '1': 'TerrainLayer',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'layer_type', '3': 4, '4': 1, '5': 14, '6': '.terrain.v1.TerrainLayerType', '10': 'layerType'},
    {'1': 'source_file', '3': 5, '4': 1, '5': 9, '10': 'sourceFile'},
    {'1': 'bounds', '3': 6, '4': 1, '5': 11, '6': '.terrain.v1.BoundingBox', '10': 'bounds'},
    {'1': 'resolution_m', '3': 7, '4': 1, '5': 1, '10': 'resolutionM'},
    {'1': 'crs', '3': 8, '4': 1, '5': 9, '10': 'crs'},
    {'1': 'min_elevation', '3': 9, '4': 1, '5': 1, '10': 'minElevation'},
    {'1': 'max_elevation', '3': 10, '4': 1, '5': 1, '10': 'maxElevation'},
    {'1': 'created_at', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
  ],
};

/// Descriptor for `TerrainLayer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List terrainLayerDescriptor = $convert.base64Decode(
    'CgxUZXJyYWluTGF5ZXISDgoCaWQYASABKAlSAmlkEh0KCnByb2plY3RfaWQYAiABKAlSCXByb2'
    'plY3RJZBISCgRuYW1lGAMgASgJUgRuYW1lEjsKCmxheWVyX3R5cGUYBCABKA4yHC50ZXJyYWlu'
    'LnYxLlRlcnJhaW5MYXllclR5cGVSCWxheWVyVHlwZRIfCgtzb3VyY2VfZmlsZRgFIAEoCVIKc2'
    '91cmNlRmlsZRIvCgZib3VuZHMYBiABKAsyFy50ZXJyYWluLnYxLkJvdW5kaW5nQm94UgZib3Vu'
    'ZHMSIQoMcmVzb2x1dGlvbl9tGAcgASgBUgtyZXNvbHV0aW9uTRIQCgNjcnMYCCABKAlSA2Nycx'
    'IjCg1taW5fZWxldmF0aW9uGAkgASgBUgxtaW5FbGV2YXRpb24SIwoNbWF4X2VsZXZhdGlvbhgK'
    'IAEoAVIMbWF4RWxldmF0aW9uEjkKCmNyZWF0ZWRfYXQYCyABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUgljcmVhdGVkQXQ=');

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

@$core.Deprecated('Use uploadTerrainRequestDescriptor instead')
const UploadTerrainRequest$json = {
  '1': 'UploadTerrainRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'file_path', '3': 3, '4': 1, '5': 9, '10': 'filePath'},
    {'1': 'crs', '3': 4, '4': 1, '5': 9, '10': 'crs'},
  ],
};

/// Descriptor for `UploadTerrainRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadTerrainRequestDescriptor = $convert.base64Decode(
    'ChRVcGxvYWRUZXJyYWluUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SWQSEg'
    'oEbmFtZRgCIAEoCVIEbmFtZRIbCglmaWxlX3BhdGgYAyABKAlSCGZpbGVQYXRoEhAKA2NycxgE'
    'IAEoCVIDY3Jz');

@$core.Deprecated('Use uploadTerrainResponseDescriptor instead')
const UploadTerrainResponse$json = {
  '1': 'UploadTerrainResponse',
  '2': [
    {'1': 'layer', '3': 1, '4': 1, '5': 11, '6': '.terrain.v1.TerrainLayer', '10': 'layer'},
  ],
};

/// Descriptor for `UploadTerrainResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadTerrainResponseDescriptor = $convert.base64Decode(
    'ChVVcGxvYWRUZXJyYWluUmVzcG9uc2USLgoFbGF5ZXIYASABKAsyGC50ZXJyYWluLnYxLlRlcn'
    'JhaW5MYXllclIFbGF5ZXI=');

@$core.Deprecated('Use getTerrainLayerRequestDescriptor instead')
const GetTerrainLayerRequest$json = {
  '1': 'GetTerrainLayerRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetTerrainLayerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTerrainLayerRequestDescriptor = $convert.base64Decode(
    'ChZHZXRUZXJyYWluTGF5ZXJSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use getTerrainLayerResponseDescriptor instead')
const GetTerrainLayerResponse$json = {
  '1': 'GetTerrainLayerResponse',
  '2': [
    {'1': 'layer', '3': 1, '4': 1, '5': 11, '6': '.terrain.v1.TerrainLayer', '10': 'layer'},
  ],
};

/// Descriptor for `GetTerrainLayerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTerrainLayerResponseDescriptor = $convert.base64Decode(
    'ChdHZXRUZXJyYWluTGF5ZXJSZXNwb25zZRIuCgVsYXllchgBIAEoCzIYLnRlcnJhaW4udjEuVG'
    'VycmFpbkxheWVyUgVsYXllcg==');

@$core.Deprecated('Use listTerrainLayersRequestDescriptor instead')
const ListTerrainLayersRequest$json = {
  '1': 'ListTerrainLayersRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'type_filter', '3': 2, '4': 1, '5': 14, '6': '.terrain.v1.TerrainLayerType', '10': 'typeFilter'},
  ],
};

/// Descriptor for `ListTerrainLayersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTerrainLayersRequestDescriptor = $convert.base64Decode(
    'ChhMaXN0VGVycmFpbkxheWVyc1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdE'
    'lkEj0KC3R5cGVfZmlsdGVyGAIgASgOMhwudGVycmFpbi52MS5UZXJyYWluTGF5ZXJUeXBlUgp0'
    'eXBlRmlsdGVy');

@$core.Deprecated('Use listTerrainLayersResponseDescriptor instead')
const ListTerrainLayersResponse$json = {
  '1': 'ListTerrainLayersResponse',
  '2': [
    {'1': 'layers', '3': 1, '4': 3, '5': 11, '6': '.terrain.v1.TerrainLayer', '10': 'layers'},
  ],
};

/// Descriptor for `ListTerrainLayersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTerrainLayersResponseDescriptor = $convert.base64Decode(
    'ChlMaXN0VGVycmFpbkxheWVyc1Jlc3BvbnNlEjAKBmxheWVycxgBIAMoCzIYLnRlcnJhaW4udj'
    'EuVGVycmFpbkxheWVyUgZsYXllcnM=');

@$core.Deprecated('Use getElevationRequestDescriptor instead')
const GetElevationRequest$json = {
  '1': 'GetElevationRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'latitude', '3': 3, '4': 1, '5': 1, '10': 'latitude'},
  ],
};

/// Descriptor for `GetElevationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getElevationRequestDescriptor = $convert.base64Decode(
    'ChNHZXRFbGV2YXRpb25SZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZBIcCg'
    'lsb25naXR1ZGUYAiABKAFSCWxvbmdpdHVkZRIaCghsYXRpdHVkZRgDIAEoAVIIbGF0aXR1ZGU=');

@$core.Deprecated('Use getElevationResponseDescriptor instead')
const GetElevationResponse$json = {
  '1': 'GetElevationResponse',
  '2': [
    {'1': 'elevation', '3': 1, '4': 1, '5': 1, '10': 'elevation'},
  ],
};

/// Descriptor for `GetElevationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getElevationResponseDescriptor = $convert.base64Decode(
    'ChRHZXRFbGV2YXRpb25SZXNwb25zZRIcCgllbGV2YXRpb24YASABKAFSCWVsZXZhdGlvbg==');

@$core.Deprecated('Use getElevationGridRequestDescriptor instead')
const GetElevationGridRequest$json = {
  '1': 'GetElevationGridRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'bounds', '3': 2, '4': 1, '5': 11, '6': '.terrain.v1.BoundingBox', '10': 'bounds'},
    {'1': 'resolution_m', '3': 3, '4': 1, '5': 1, '10': 'resolutionM'},
  ],
};

/// Descriptor for `GetElevationGridRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getElevationGridRequestDescriptor = $convert.base64Decode(
    'ChdHZXRFbGV2YXRpb25HcmlkUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SW'
    'QSLwoGYm91bmRzGAIgASgLMhcudGVycmFpbi52MS5Cb3VuZGluZ0JveFIGYm91bmRzEiEKDHJl'
    'c29sdXRpb25fbRgDIAEoAVILcmVzb2x1dGlvbk0=');

@$core.Deprecated('Use getElevationGridResponseDescriptor instead')
const GetElevationGridResponse$json = {
  '1': 'GetElevationGridResponse',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 5, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 5, '10': 'height'},
    {'1': 'elevations', '3': 3, '4': 3, '5': 1, '10': 'elevations'},
    {'1': 'min_elevation', '3': 4, '4': 1, '5': 1, '10': 'minElevation'},
    {'1': 'max_elevation', '3': 5, '4': 1, '5': 1, '10': 'maxElevation'},
  ],
};

/// Descriptor for `GetElevationGridResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getElevationGridResponseDescriptor = $convert.base64Decode(
    'ChhHZXRFbGV2YXRpb25HcmlkUmVzcG9uc2USFAoFd2lkdGgYASABKAVSBXdpZHRoEhYKBmhlaW'
    'dodBgCIAEoBVIGaGVpZ2h0Eh4KCmVsZXZhdGlvbnMYAyADKAFSCmVsZXZhdGlvbnMSIwoNbWlu'
    'X2VsZXZhdGlvbhgEIAEoAVIMbWluRWxldmF0aW9uEiMKDW1heF9lbGV2YXRpb24YBSABKAFSDG'
    '1heEVsZXZhdGlvbg==');

@$core.Deprecated('Use analyzeEarthworkRequestDescriptor instead')
const AnalyzeEarthworkRequest$json = {
  '1': 'AnalyzeEarthworkRequest',
  '2': [
    {'1': 'terrain_layer_id', '3': 1, '4': 1, '5': 9, '10': 'terrainLayerId'},
    {'1': 'target_elevation_m', '3': 2, '4': 1, '5': 1, '9': 0, '10': 'targetElevationM', '17': true},
    {'1': 'boundary_geojson', '3': 3, '4': 1, '5': 9, '10': 'boundaryGeojson'},
    {'1': 'min_delta_m', '3': 4, '4': 1, '5': 1, '10': 'minDeltaM'},
    {'1': 'haul_factor', '3': 5, '4': 1, '5': 1, '10': 'haulFactor'},
    {'1': 'grid_width', '3': 6, '4': 1, '5': 5, '10': 'gridWidth'},
    {'1': 'grid_height', '3': 7, '4': 1, '5': 5, '10': 'gridHeight'},
  ],
  '8': [
    {'1': '_target_elevation_m'},
  ],
};

/// Descriptor for `AnalyzeEarthworkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List analyzeEarthworkRequestDescriptor = $convert.base64Decode(
    'ChdBbmFseXplRWFydGh3b3JrUmVxdWVzdBIoChB0ZXJyYWluX2xheWVyX2lkGAEgASgJUg50ZX'
    'JyYWluTGF5ZXJJZBIxChJ0YXJnZXRfZWxldmF0aW9uX20YAiABKAFIAFIQdGFyZ2V0RWxldmF0'
    'aW9uTYgBARIpChBib3VuZGFyeV9nZW9qc29uGAMgASgJUg9ib3VuZGFyeUdlb2pzb24SHgoLbW'
    'luX2RlbHRhX20YBCABKAFSCW1pbkRlbHRhTRIfCgtoYXVsX2ZhY3RvchgFIAEoAVIKaGF1bEZh'
    'Y3RvchIdCgpncmlkX3dpZHRoGAYgASgFUglncmlkV2lkdGgSHwoLZ3JpZF9oZWlnaHQYByABKA'
    'VSCmdyaWRIZWlnaHRCFQoTX3RhcmdldF9lbGV2YXRpb25fbQ==');

@$core.Deprecated('Use analyzeEarthworkResponseDescriptor instead')
const AnalyzeEarthworkResponse$json = {
  '1': 'AnalyzeEarthworkResponse',
  '2': [
    {'1': 'dem_source_layer_id', '3': 1, '4': 1, '5': 9, '10': 'demSourceLayerId'},
    {'1': 'grid_width', '3': 2, '4': 1, '5': 5, '10': 'gridWidth'},
    {'1': 'grid_height', '3': 3, '4': 1, '5': 5, '10': 'gridHeight'},
    {'1': 'cell_area_sqm', '3': 4, '4': 1, '5': 1, '10': 'cellAreaSqm'},
    {'1': 'mean_elevation_m', '3': 5, '4': 1, '5': 1, '10': 'meanElevationM'},
    {'1': 'target_elevation_m', '3': 6, '4': 1, '5': 1, '10': 'targetElevationM'},
    {'1': 'cut_volume_m3', '3': 7, '4': 1, '5': 1, '10': 'cutVolumeM3'},
    {'1': 'fill_volume_m3', '3': 8, '4': 1, '5': 1, '10': 'fillVolumeM3'},
    {'1': 'net_volume_m3', '3': 9, '4': 1, '5': 1, '10': 'netVolumeM3'},
    {'1': 'imbalance_volume_m3', '3': 10, '4': 1, '5': 1, '10': 'imbalanceVolumeM3'},
    {'1': 'balanced_volume_ratio', '3': 11, '4': 1, '5': 1, '10': 'balancedVolumeRatio'},
    {'1': 'affected_area_sqm', '3': 12, '4': 1, '5': 1, '10': 'affectedAreaSqm'},
    {'1': 'average_absolute_delta_m', '3': 13, '4': 1, '5': 1, '10': 'averageAbsoluteDeltaM'},
    {'1': 'maximum_absolute_delta_m', '3': 14, '4': 1, '5': 1, '10': 'maximumAbsoluteDeltaM'},
    {'1': 'included_cell_count', '3': 15, '4': 1, '5': 5, '10': 'includedCellCount'},
    {'1': 'clipped_area_sqm', '3': 16, '4': 1, '5': 1, '10': 'clippedAreaSqm'},
    {'1': 'haul_distance_m', '3': 17, '4': 1, '5': 1, '10': 'haulDistanceM'},
    {'1': 'haul_effort_m3m', '3': 18, '4': 1, '5': 1, '10': 'haulEffortM3m'},
    {'1': 'recommended_target_min_m', '3': 19, '4': 1, '5': 1, '10': 'recommendedTargetMinM'},
    {'1': 'recommended_target_max_m', '3': 20, '4': 1, '5': 1, '10': 'recommendedTargetMaxM'},
  ],
};

/// Descriptor for `AnalyzeEarthworkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List analyzeEarthworkResponseDescriptor = $convert.base64Decode(
    'ChhBbmFseXplRWFydGh3b3JrUmVzcG9uc2USLQoTZGVtX3NvdXJjZV9sYXllcl9pZBgBIAEoCV'
    'IQZGVtU291cmNlTGF5ZXJJZBIdCgpncmlkX3dpZHRoGAIgASgFUglncmlkV2lkdGgSHwoLZ3Jp'
    'ZF9oZWlnaHQYAyABKAVSCmdyaWRIZWlnaHQSIgoNY2VsbF9hcmVhX3NxbRgEIAEoAVILY2VsbE'
    'FyZWFTcW0SKAoQbWVhbl9lbGV2YXRpb25fbRgFIAEoAVIObWVhbkVsZXZhdGlvbk0SLAoSdGFy'
    'Z2V0X2VsZXZhdGlvbl9tGAYgASgBUhB0YXJnZXRFbGV2YXRpb25NEiIKDWN1dF92b2x1bWVfbT'
    'MYByABKAFSC2N1dFZvbHVtZU0zEiQKDmZpbGxfdm9sdW1lX20zGAggASgBUgxmaWxsVm9sdW1l'
    'TTMSIgoNbmV0X3ZvbHVtZV9tMxgJIAEoAVILbmV0Vm9sdW1lTTMSLgoTaW1iYWxhbmNlX3ZvbH'
    'VtZV9tMxgKIAEoAVIRaW1iYWxhbmNlVm9sdW1lTTMSMgoVYmFsYW5jZWRfdm9sdW1lX3JhdGlv'
    'GAsgASgBUhNiYWxhbmNlZFZvbHVtZVJhdGlvEioKEWFmZmVjdGVkX2FyZWFfc3FtGAwgASgBUg'
    '9hZmZlY3RlZEFyZWFTcW0SNwoYYXZlcmFnZV9hYnNvbHV0ZV9kZWx0YV9tGA0gASgBUhVhdmVy'
    'YWdlQWJzb2x1dGVEZWx0YU0SNwoYbWF4aW11bV9hYnNvbHV0ZV9kZWx0YV9tGA4gASgBUhVtYX'
    'hpbXVtQWJzb2x1dGVEZWx0YU0SLgoTaW5jbHVkZWRfY2VsbF9jb3VudBgPIAEoBVIRaW5jbHVk'
    'ZWRDZWxsQ291bnQSKAoQY2xpcHBlZF9hcmVhX3NxbRgQIAEoAVIOY2xpcHBlZEFyZWFTcW0SJg'
    'oPaGF1bF9kaXN0YW5jZV9tGBEgASgBUg1oYXVsRGlzdGFuY2VNEiYKD2hhdWxfZWZmb3J0X20z'
    'bRgSIAEoAVINaGF1bEVmZm9ydE0zbRI3ChhyZWNvbW1lbmRlZF90YXJnZXRfbWluX20YEyABKA'
    'FSFXJlY29tbWVuZGVkVGFyZ2V0TWluTRI3ChhyZWNvbW1lbmRlZF90YXJnZXRfbWF4X20YFCAB'
    'KAFSFXJlY29tbWVuZGVkVGFyZ2V0TWF4TQ==');

@$core.Deprecated('Use computeSlopeRequestDescriptor instead')
const ComputeSlopeRequest$json = {
  '1': 'ComputeSlopeRequest',
  '2': [
    {'1': 'terrain_layer_id', '3': 1, '4': 1, '5': 9, '10': 'terrainLayerId'},
  ],
};

/// Descriptor for `ComputeSlopeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeSlopeRequestDescriptor = $convert.base64Decode(
    'ChNDb21wdXRlU2xvcGVSZXF1ZXN0EigKEHRlcnJhaW5fbGF5ZXJfaWQYASABKAlSDnRlcnJhaW'
    '5MYXllcklk');

@$core.Deprecated('Use computeSlopeResponseDescriptor instead')
const ComputeSlopeResponse$json = {
  '1': 'ComputeSlopeResponse',
  '2': [
    {'1': 'slope_layer', '3': 1, '4': 1, '5': 11, '6': '.terrain.v1.TerrainLayer', '10': 'slopeLayer'},
  ],
};

/// Descriptor for `ComputeSlopeResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeSlopeResponseDescriptor = $convert.base64Decode(
    'ChRDb21wdXRlU2xvcGVSZXNwb25zZRI5CgtzbG9wZV9sYXllchgBIAEoCzIYLnRlcnJhaW4udj'
    'EuVGVycmFpbkxheWVyUgpzbG9wZUxheWVy');

@$core.Deprecated('Use computeAspectRequestDescriptor instead')
const ComputeAspectRequest$json = {
  '1': 'ComputeAspectRequest',
  '2': [
    {'1': 'terrain_layer_id', '3': 1, '4': 1, '5': 9, '10': 'terrainLayerId'},
  ],
};

/// Descriptor for `ComputeAspectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeAspectRequestDescriptor = $convert.base64Decode(
    'ChRDb21wdXRlQXNwZWN0UmVxdWVzdBIoChB0ZXJyYWluX2xheWVyX2lkGAEgASgJUg50ZXJyYW'
    'luTGF5ZXJJZA==');

@$core.Deprecated('Use computeAspectResponseDescriptor instead')
const ComputeAspectResponse$json = {
  '1': 'ComputeAspectResponse',
  '2': [
    {'1': 'aspect_layer', '3': 1, '4': 1, '5': 11, '6': '.terrain.v1.TerrainLayer', '10': 'aspectLayer'},
  ],
};

/// Descriptor for `ComputeAspectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeAspectResponseDescriptor = $convert.base64Decode(
    'ChVDb21wdXRlQXNwZWN0UmVzcG9uc2USOwoMYXNwZWN0X2xheWVyGAEgASgLMhgudGVycmFpbi'
    '52MS5UZXJyYWluTGF5ZXJSC2FzcGVjdExheWVy');

@$core.Deprecated('Use deleteTerrainLayerRequestDescriptor instead')
const DeleteTerrainLayerRequest$json = {
  '1': 'DeleteTerrainLayerRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteTerrainLayerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTerrainLayerRequestDescriptor = $convert.base64Decode(
    'ChlEZWxldGVUZXJyYWluTGF5ZXJSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use deleteTerrainLayerResponseDescriptor instead')
const DeleteTerrainLayerResponse$json = {
  '1': 'DeleteTerrainLayerResponse',
};

/// Descriptor for `DeleteTerrainLayerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteTerrainLayerResponseDescriptor = $convert.base64Decode(
    'ChpEZWxldGVUZXJyYWluTGF5ZXJSZXNwb25zZQ==');

@$core.Deprecated('Use diffTerrainLayersRequestDescriptor instead')
const DiffTerrainLayersRequest$json = {
  '1': 'DiffTerrainLayersRequest',
  '2': [
    {'1': 'base_layer_id', '3': 1, '4': 1, '5': 9, '10': 'baseLayerId'},
    {'1': 'compare_layer_id', '3': 2, '4': 1, '5': 9, '10': 'compareLayerId'},
    {'1': 'grid_width', '3': 3, '4': 1, '5': 5, '10': 'gridWidth'},
    {'1': 'grid_height', '3': 4, '4': 1, '5': 5, '10': 'gridHeight'},
  ],
};

/// Descriptor for `DiffTerrainLayersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List diffTerrainLayersRequestDescriptor = $convert.base64Decode(
    'ChhEaWZmVGVycmFpbkxheWVyc1JlcXVlc3QSIgoNYmFzZV9sYXllcl9pZBgBIAEoCVILYmFzZU'
    'xheWVySWQSKAoQY29tcGFyZV9sYXllcl9pZBgCIAEoCVIOY29tcGFyZUxheWVySWQSHQoKZ3Jp'
    'ZF93aWR0aBgDIAEoBVIJZ3JpZFdpZHRoEh8KC2dyaWRfaGVpZ2h0GAQgASgFUgpncmlkSGVpZ2'
    'h0');

@$core.Deprecated('Use diffTerrainLayersResponseDescriptor instead')
const DiffTerrainLayersResponse$json = {
  '1': 'DiffTerrainLayersResponse',
  '2': [
    {'1': 'base_layer_id', '3': 1, '4': 1, '5': 9, '10': 'baseLayerId'},
    {'1': 'compare_layer_id', '3': 2, '4': 1, '5': 9, '10': 'compareLayerId'},
    {'1': 'overlap_bounds', '3': 3, '4': 1, '5': 11, '6': '.terrain.v1.BoundingBox', '10': 'overlapBounds'},
    {'1': 'grid_width', '3': 4, '4': 1, '5': 5, '10': 'gridWidth'},
    {'1': 'grid_height', '3': 5, '4': 1, '5': 5, '10': 'gridHeight'},
    {'1': 'cell_area_sqm', '3': 6, '4': 1, '5': 1, '10': 'cellAreaSqm'},
    {'1': 'delta_elevations', '3': 7, '4': 3, '5': 1, '10': 'deltaElevations'},
    {'1': 'mean_delta_m', '3': 8, '4': 1, '5': 1, '10': 'meanDeltaM'},
    {'1': 'rms_delta_m', '3': 9, '4': 1, '5': 1, '10': 'rmsDeltaM'},
    {'1': 'max_abs_delta_m', '3': 10, '4': 1, '5': 1, '10': 'maxAbsDeltaM'},
    {'1': 'volume_added_m3', '3': 11, '4': 1, '5': 1, '10': 'volumeAddedM3'},
    {'1': 'volume_removed_m3', '3': 12, '4': 1, '5': 1, '10': 'volumeRemovedM3'},
    {'1': 'net_volume_m3', '3': 13, '4': 1, '5': 1, '10': 'netVolumeM3'},
    {'1': 'valid_cell_count', '3': 14, '4': 1, '5': 5, '10': 'validCellCount'},
  ],
};

/// Descriptor for `DiffTerrainLayersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List diffTerrainLayersResponseDescriptor = $convert.base64Decode(
    'ChlEaWZmVGVycmFpbkxheWVyc1Jlc3BvbnNlEiIKDWJhc2VfbGF5ZXJfaWQYASABKAlSC2Jhc2'
    'VMYXllcklkEigKEGNvbXBhcmVfbGF5ZXJfaWQYAiABKAlSDmNvbXBhcmVMYXllcklkEj4KDm92'
    'ZXJsYXBfYm91bmRzGAMgASgLMhcudGVycmFpbi52MS5Cb3VuZGluZ0JveFINb3ZlcmxhcEJvdW'
    '5kcxIdCgpncmlkX3dpZHRoGAQgASgFUglncmlkV2lkdGgSHwoLZ3JpZF9oZWlnaHQYBSABKAVS'
    'CmdyaWRIZWlnaHQSIgoNY2VsbF9hcmVhX3NxbRgGIAEoAVILY2VsbEFyZWFTcW0SKQoQZGVsdG'
    'FfZWxldmF0aW9ucxgHIAMoAVIPZGVsdGFFbGV2YXRpb25zEiAKDG1lYW5fZGVsdGFfbRgIIAEo'
    'AVIKbWVhbkRlbHRhTRIeCgtybXNfZGVsdGFfbRgJIAEoAVIJcm1zRGVsdGFNEiUKD21heF9hYn'
    'NfZGVsdGFfbRgKIAEoAVIMbWF4QWJzRGVsdGFNEiYKD3ZvbHVtZV9hZGRlZF9tMxgLIAEoAVIN'
    'dm9sdW1lQWRkZWRNMxIqChF2b2x1bWVfcmVtb3ZlZF9tMxgMIAEoAVIPdm9sdW1lUmVtb3ZlZE'
    '0zEiIKDW5ldF92b2x1bWVfbTMYDSABKAFSC25ldFZvbHVtZU0zEigKEHZhbGlkX2NlbGxfY291'
    'bnQYDiABKAVSDnZhbGlkQ2VsbENvdW50');

@$core.Deprecated('Use generateGradingPlanRequestDescriptor instead')
const GenerateGradingPlanRequest$json = {
  '1': 'GenerateGradingPlanRequest',
  '2': [
    {'1': 'terrain_layer_id', '3': 1, '4': 1, '5': 9, '10': 'terrainLayerId'},
    {'1': 'target_elevation_m', '3': 2, '4': 1, '5': 1, '9': 0, '10': 'targetElevationM', '17': true},
    {'1': 'boundary_geojson', '3': 3, '4': 1, '5': 9, '10': 'boundaryGeojson'},
    {'1': 'min_delta_m', '3': 4, '4': 1, '5': 1, '10': 'minDeltaM'},
    {'1': 'haul_factor', '3': 5, '4': 1, '5': 1, '10': 'haulFactor'},
    {'1': 'grid_width', '3': 6, '4': 1, '5': 5, '10': 'gridWidth'},
    {'1': 'grid_height', '3': 7, '4': 1, '5': 5, '10': 'gridHeight'},
    {'1': 'cut_rate_per_m3', '3': 8, '4': 1, '5': 1, '10': 'cutRatePerM3'},
    {'1': 'fill_rate_per_m3', '3': 9, '4': 1, '5': 1, '10': 'fillRatePerM3'},
    {'1': 'haul_rate_per_m3m', '3': 10, '4': 1, '5': 1, '10': 'haulRatePerM3m'},
    {'1': 'import_rate_per_m3', '3': 11, '4': 1, '5': 1, '10': 'importRatePerM3'},
    {'1': 'export_rate_per_m3', '3': 12, '4': 1, '5': 1, '10': 'exportRatePerM3'},
    {'1': 'compaction_factor', '3': 13, '4': 1, '5': 1, '10': 'compactionFactor'},
    {'1': 'currency_code', '3': 14, '4': 1, '5': 9, '10': 'currencyCode'},
  ],
  '8': [
    {'1': '_target_elevation_m'},
  ],
};

/// Descriptor for `GenerateGradingPlanRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateGradingPlanRequestDescriptor = $convert.base64Decode(
    'ChpHZW5lcmF0ZUdyYWRpbmdQbGFuUmVxdWVzdBIoChB0ZXJyYWluX2xheWVyX2lkGAEgASgJUg'
    '50ZXJyYWluTGF5ZXJJZBIxChJ0YXJnZXRfZWxldmF0aW9uX20YAiABKAFIAFIQdGFyZ2V0RWxl'
    'dmF0aW9uTYgBARIpChBib3VuZGFyeV9nZW9qc29uGAMgASgJUg9ib3VuZGFyeUdlb2pzb24SHg'
    'oLbWluX2RlbHRhX20YBCABKAFSCW1pbkRlbHRhTRIfCgtoYXVsX2ZhY3RvchgFIAEoAVIKaGF1'
    'bEZhY3RvchIdCgpncmlkX3dpZHRoGAYgASgFUglncmlkV2lkdGgSHwoLZ3JpZF9oZWlnaHQYBy'
    'ABKAVSCmdyaWRIZWlnaHQSJQoPY3V0X3JhdGVfcGVyX20zGAggASgBUgxjdXRSYXRlUGVyTTMS'
    'JwoQZmlsbF9yYXRlX3Blcl9tMxgJIAEoAVINZmlsbFJhdGVQZXJNMxIpChFoYXVsX3JhdGVfcG'
    'VyX20zbRgKIAEoAVIOaGF1bFJhdGVQZXJNM20SKwoSaW1wb3J0X3JhdGVfcGVyX20zGAsgASgB'
    'Ug9pbXBvcnRSYXRlUGVyTTMSKwoSZXhwb3J0X3JhdGVfcGVyX20zGAwgASgBUg9leHBvcnRSYX'
    'RlUGVyTTMSKwoRY29tcGFjdGlvbl9mYWN0b3IYDSABKAFSEGNvbXBhY3Rpb25GYWN0b3ISIwoN'
    'Y3VycmVuY3lfY29kZRgOIAEoCVIMY3VycmVuY3lDb2RlQhUKE190YXJnZXRfZWxldmF0aW9uX2'
    '0=');

@$core.Deprecated('Use gradingPlanCostBreakdownDescriptor instead')
const GradingPlanCostBreakdown$json = {
  '1': 'GradingPlanCostBreakdown',
  '2': [
    {'1': 'cut_volume_m3', '3': 1, '4': 1, '5': 1, '10': 'cutVolumeM3'},
    {'1': 'fill_volume_m3', '3': 2, '4': 1, '5': 1, '10': 'fillVolumeM3'},
    {'1': 'fill_demand_m3', '3': 3, '4': 1, '5': 1, '10': 'fillDemandM3'},
    {'1': 'export_volume_m3', '3': 4, '4': 1, '5': 1, '10': 'exportVolumeM3'},
    {'1': 'import_volume_m3', '3': 5, '4': 1, '5': 1, '10': 'importVolumeM3'},
    {'1': 'hauled_volume_m3', '3': 6, '4': 1, '5': 1, '10': 'hauledVolumeM3'},
    {'1': 'haul_distance_m', '3': 7, '4': 1, '5': 1, '10': 'haulDistanceM'},
    {'1': 'haul_effort_m3m', '3': 8, '4': 1, '5': 1, '10': 'haulEffortM3m'},
    {'1': 'cut_cost', '3': 9, '4': 1, '5': 1, '10': 'cutCost'},
    {'1': 'fill_cost', '3': 10, '4': 1, '5': 1, '10': 'fillCost'},
    {'1': 'haul_cost', '3': 11, '4': 1, '5': 1, '10': 'haulCost'},
    {'1': 'import_cost', '3': 12, '4': 1, '5': 1, '10': 'importCost'},
    {'1': 'export_cost', '3': 13, '4': 1, '5': 1, '10': 'exportCost'},
    {'1': 'total_cost', '3': 14, '4': 1, '5': 1, '10': 'totalCost'},
    {'1': 'currency_code', '3': 15, '4': 1, '5': 9, '10': 'currencyCode'},
  ],
};

/// Descriptor for `GradingPlanCostBreakdown`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List gradingPlanCostBreakdownDescriptor = $convert.base64Decode(
    'ChhHcmFkaW5nUGxhbkNvc3RCcmVha2Rvd24SIgoNY3V0X3ZvbHVtZV9tMxgBIAEoAVILY3V0Vm'
    '9sdW1lTTMSJAoOZmlsbF92b2x1bWVfbTMYAiABKAFSDGZpbGxWb2x1bWVNMxIkCg5maWxsX2Rl'
    'bWFuZF9tMxgDIAEoAVIMZmlsbERlbWFuZE0zEigKEGV4cG9ydF92b2x1bWVfbTMYBCABKAFSDm'
    'V4cG9ydFZvbHVtZU0zEigKEGltcG9ydF92b2x1bWVfbTMYBSABKAFSDmltcG9ydFZvbHVtZU0z'
    'EigKEGhhdWxlZF92b2x1bWVfbTMYBiABKAFSDmhhdWxlZFZvbHVtZU0zEiYKD2hhdWxfZGlzdG'
    'FuY2VfbRgHIAEoAVINaGF1bERpc3RhbmNlTRImCg9oYXVsX2VmZm9ydF9tM20YCCABKAFSDWhh'
    'dWxFZmZvcnRNM20SGQoIY3V0X2Nvc3QYCSABKAFSB2N1dENvc3QSGwoJZmlsbF9jb3N0GAogAS'
    'gBUghmaWxsQ29zdBIbCgloYXVsX2Nvc3QYCyABKAFSCGhhdWxDb3N0Eh8KC2ltcG9ydF9jb3N0'
    'GAwgASgBUgppbXBvcnRDb3N0Eh8KC2V4cG9ydF9jb3N0GA0gASgBUgpleHBvcnRDb3N0Eh0KCn'
    'RvdGFsX2Nvc3QYDiABKAFSCXRvdGFsQ29zdBIjCg1jdXJyZW5jeV9jb2RlGA8gASgJUgxjdXJy'
    'ZW5jeUNvZGU=');

@$core.Deprecated('Use generateGradingPlanResponseDescriptor instead')
const GenerateGradingPlanResponse$json = {
  '1': 'GenerateGradingPlanResponse',
  '2': [
    {'1': 'dem_layer_id', '3': 1, '4': 1, '5': 9, '10': 'demLayerId'},
    {'1': 'target_elevation_m', '3': 2, '4': 1, '5': 1, '10': 'targetElevationM'},
    {'1': 'mean_elevation_m', '3': 3, '4': 1, '5': 1, '10': 'meanElevationM'},
    {'1': 'affected_area_sqm', '3': 4, '4': 1, '5': 1, '10': 'affectedAreaSqm'},
    {'1': 'balanced_volume_ratio', '3': 5, '4': 1, '5': 1, '10': 'balancedVolumeRatio'},
    {'1': 'compaction_factor', '3': 6, '4': 1, '5': 1, '10': 'compactionFactor'},
    {'1': 'cut_rate_per_m3', '3': 7, '4': 1, '5': 1, '10': 'cutRatePerM3'},
    {'1': 'fill_rate_per_m3', '3': 8, '4': 1, '5': 1, '10': 'fillRatePerM3'},
    {'1': 'haul_rate_per_m3m', '3': 9, '4': 1, '5': 1, '10': 'haulRatePerM3m'},
    {'1': 'import_rate_per_m3', '3': 10, '4': 1, '5': 1, '10': 'importRatePerM3'},
    {'1': 'export_rate_per_m3', '3': 11, '4': 1, '5': 1, '10': 'exportRatePerM3'},
    {'1': 'cost', '3': 12, '4': 1, '5': 11, '6': '.terrain.v1.GradingPlanCostBreakdown', '10': 'cost'},
  ],
};

/// Descriptor for `GenerateGradingPlanResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateGradingPlanResponseDescriptor = $convert.base64Decode(
    'ChtHZW5lcmF0ZUdyYWRpbmdQbGFuUmVzcG9uc2USIAoMZGVtX2xheWVyX2lkGAEgASgJUgpkZW'
    '1MYXllcklkEiwKEnRhcmdldF9lbGV2YXRpb25fbRgCIAEoAVIQdGFyZ2V0RWxldmF0aW9uTRIo'
    'ChBtZWFuX2VsZXZhdGlvbl9tGAMgASgBUg5tZWFuRWxldmF0aW9uTRIqChFhZmZlY3RlZF9hcm'
    'VhX3NxbRgEIAEoAVIPYWZmZWN0ZWRBcmVhU3FtEjIKFWJhbGFuY2VkX3ZvbHVtZV9yYXRpbxgF'
    'IAEoAVITYmFsYW5jZWRWb2x1bWVSYXRpbxIrChFjb21wYWN0aW9uX2ZhY3RvchgGIAEoAVIQY2'
    '9tcGFjdGlvbkZhY3RvchIlCg9jdXRfcmF0ZV9wZXJfbTMYByABKAFSDGN1dFJhdGVQZXJNMxIn'
    'ChBmaWxsX3JhdGVfcGVyX20zGAggASgBUg1maWxsUmF0ZVBlck0zEikKEWhhdWxfcmF0ZV9wZX'
    'JfbTNtGAkgASgBUg5oYXVsUmF0ZVBlck0zbRIrChJpbXBvcnRfcmF0ZV9wZXJfbTMYCiABKAFS'
    'D2ltcG9ydFJhdGVQZXJNMxIrChJleHBvcnRfcmF0ZV9wZXJfbTMYCyABKAFSD2V4cG9ydFJhdG'
    'VQZXJNMxI4CgRjb3N0GAwgASgLMiQudGVycmFpbi52MS5HcmFkaW5nUGxhbkNvc3RCcmVha2Rv'
    'd25SBGNvc3Q=');

const $core.Map<$core.String, $core.dynamic> TerrainServiceBase$json = {
  '1': 'TerrainService',
  '2': [
    {'1': 'UploadTerrain', '2': '.terrain.v1.UploadTerrainRequest', '3': '.terrain.v1.UploadTerrainResponse'},
    {'1': 'GetTerrainLayer', '2': '.terrain.v1.GetTerrainLayerRequest', '3': '.terrain.v1.GetTerrainLayerResponse'},
    {'1': 'ListTerrainLayers', '2': '.terrain.v1.ListTerrainLayersRequest', '3': '.terrain.v1.ListTerrainLayersResponse'},
    {'1': 'GetElevation', '2': '.terrain.v1.GetElevationRequest', '3': '.terrain.v1.GetElevationResponse'},
    {'1': 'GetElevationGrid', '2': '.terrain.v1.GetElevationGridRequest', '3': '.terrain.v1.GetElevationGridResponse'},
    {'1': 'AnalyzeEarthwork', '2': '.terrain.v1.AnalyzeEarthworkRequest', '3': '.terrain.v1.AnalyzeEarthworkResponse'},
    {'1': 'DiffTerrainLayers', '2': '.terrain.v1.DiffTerrainLayersRequest', '3': '.terrain.v1.DiffTerrainLayersResponse'},
    {'1': 'GenerateGradingPlan', '2': '.terrain.v1.GenerateGradingPlanRequest', '3': '.terrain.v1.GenerateGradingPlanResponse'},
    {'1': 'ComputeSlope', '2': '.terrain.v1.ComputeSlopeRequest', '3': '.terrain.v1.ComputeSlopeResponse'},
    {'1': 'ComputeAspect', '2': '.terrain.v1.ComputeAspectRequest', '3': '.terrain.v1.ComputeAspectResponse'},
    {'1': 'DeleteTerrainLayer', '2': '.terrain.v1.DeleteTerrainLayerRequest', '3': '.terrain.v1.DeleteTerrainLayerResponse'},
  ],
};

@$core.Deprecated('Use terrainServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> TerrainServiceBase$messageJson = {
  '.terrain.v1.UploadTerrainRequest': UploadTerrainRequest$json,
  '.terrain.v1.UploadTerrainResponse': UploadTerrainResponse$json,
  '.terrain.v1.TerrainLayer': TerrainLayer$json,
  '.terrain.v1.BoundingBox': BoundingBox$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.terrain.v1.GetTerrainLayerRequest': GetTerrainLayerRequest$json,
  '.terrain.v1.GetTerrainLayerResponse': GetTerrainLayerResponse$json,
  '.terrain.v1.ListTerrainLayersRequest': ListTerrainLayersRequest$json,
  '.terrain.v1.ListTerrainLayersResponse': ListTerrainLayersResponse$json,
  '.terrain.v1.GetElevationRequest': GetElevationRequest$json,
  '.terrain.v1.GetElevationResponse': GetElevationResponse$json,
  '.terrain.v1.GetElevationGridRequest': GetElevationGridRequest$json,
  '.terrain.v1.GetElevationGridResponse': GetElevationGridResponse$json,
  '.terrain.v1.AnalyzeEarthworkRequest': AnalyzeEarthworkRequest$json,
  '.terrain.v1.AnalyzeEarthworkResponse': AnalyzeEarthworkResponse$json,
  '.terrain.v1.DiffTerrainLayersRequest': DiffTerrainLayersRequest$json,
  '.terrain.v1.DiffTerrainLayersResponse': DiffTerrainLayersResponse$json,
  '.terrain.v1.GenerateGradingPlanRequest': GenerateGradingPlanRequest$json,
  '.terrain.v1.GenerateGradingPlanResponse': GenerateGradingPlanResponse$json,
  '.terrain.v1.GradingPlanCostBreakdown': GradingPlanCostBreakdown$json,
  '.terrain.v1.ComputeSlopeRequest': ComputeSlopeRequest$json,
  '.terrain.v1.ComputeSlopeResponse': ComputeSlopeResponse$json,
  '.terrain.v1.ComputeAspectRequest': ComputeAspectRequest$json,
  '.terrain.v1.ComputeAspectResponse': ComputeAspectResponse$json,
  '.terrain.v1.DeleteTerrainLayerRequest': DeleteTerrainLayerRequest$json,
  '.terrain.v1.DeleteTerrainLayerResponse': DeleteTerrainLayerResponse$json,
};

/// Descriptor for `TerrainService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List terrainServiceDescriptor = $convert.base64Decode(
    'Cg5UZXJyYWluU2VydmljZRJUCg1VcGxvYWRUZXJyYWluEiAudGVycmFpbi52MS5VcGxvYWRUZX'
    'JyYWluUmVxdWVzdBohLnRlcnJhaW4udjEuVXBsb2FkVGVycmFpblJlc3BvbnNlEloKD0dldFRl'
    'cnJhaW5MYXllchIiLnRlcnJhaW4udjEuR2V0VGVycmFpbkxheWVyUmVxdWVzdBojLnRlcnJhaW'
    '4udjEuR2V0VGVycmFpbkxheWVyUmVzcG9uc2USYAoRTGlzdFRlcnJhaW5MYXllcnMSJC50ZXJy'
    'YWluLnYxLkxpc3RUZXJyYWluTGF5ZXJzUmVxdWVzdBolLnRlcnJhaW4udjEuTGlzdFRlcnJhaW'
    '5MYXllcnNSZXNwb25zZRJRCgxHZXRFbGV2YXRpb24SHy50ZXJyYWluLnYxLkdldEVsZXZhdGlv'
    'blJlcXVlc3QaIC50ZXJyYWluLnYxLkdldEVsZXZhdGlvblJlc3BvbnNlEl0KEEdldEVsZXZhdG'
    'lvbkdyaWQSIy50ZXJyYWluLnYxLkdldEVsZXZhdGlvbkdyaWRSZXF1ZXN0GiQudGVycmFpbi52'
    'MS5HZXRFbGV2YXRpb25HcmlkUmVzcG9uc2USXQoQQW5hbHl6ZUVhcnRod29yaxIjLnRlcnJhaW'
    '4udjEuQW5hbHl6ZUVhcnRod29ya1JlcXVlc3QaJC50ZXJyYWluLnYxLkFuYWx5emVFYXJ0aHdv'
    'cmtSZXNwb25zZRJgChFEaWZmVGVycmFpbkxheWVycxIkLnRlcnJhaW4udjEuRGlmZlRlcnJhaW'
    '5MYXllcnNSZXF1ZXN0GiUudGVycmFpbi52MS5EaWZmVGVycmFpbkxheWVyc1Jlc3BvbnNlEmYK'
    'E0dlbmVyYXRlR3JhZGluZ1BsYW4SJi50ZXJyYWluLnYxLkdlbmVyYXRlR3JhZGluZ1BsYW5SZX'
    'F1ZXN0GicudGVycmFpbi52MS5HZW5lcmF0ZUdyYWRpbmdQbGFuUmVzcG9uc2USUQoMQ29tcHV0'
    'ZVNsb3BlEh8udGVycmFpbi52MS5Db21wdXRlU2xvcGVSZXF1ZXN0GiAudGVycmFpbi52MS5Db2'
    '1wdXRlU2xvcGVSZXNwb25zZRJUCg1Db21wdXRlQXNwZWN0EiAudGVycmFpbi52MS5Db21wdXRl'
    'QXNwZWN0UmVxdWVzdBohLnRlcnJhaW4udjEuQ29tcHV0ZUFzcGVjdFJlc3BvbnNlEmMKEkRlbG'
    'V0ZVRlcnJhaW5MYXllchIlLnRlcnJhaW4udjEuRGVsZXRlVGVycmFpbkxheWVyUmVxdWVzdBom'
    'LnRlcnJhaW4udjEuRGVsZXRlVGVycmFpbkxheWVyUmVzcG9uc2U=');

const $core.Map<$core.String, $core.dynamic> TerrainComputeServiceBase$json = {
  '1': 'TerrainComputeService',
  '2': [
    {'1': 'GetElevation', '2': '.terrain.v1.GetElevationRequest', '3': '.terrain.v1.GetElevationResponse'},
    {'1': 'GetElevationGrid', '2': '.terrain.v1.GetElevationGridRequest', '3': '.terrain.v1.GetElevationGridResponse'},
    {'1': 'ComputeSlope', '2': '.terrain.v1.ComputeSlopeRequest', '3': '.terrain.v1.ComputeSlopeResponse'},
    {'1': 'ComputeAspect', '2': '.terrain.v1.ComputeAspectRequest', '3': '.terrain.v1.ComputeAspectResponse'},
  ],
};

@$core.Deprecated('Use terrainComputeServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> TerrainComputeServiceBase$messageJson = {
  '.terrain.v1.GetElevationRequest': GetElevationRequest$json,
  '.terrain.v1.GetElevationResponse': GetElevationResponse$json,
  '.terrain.v1.GetElevationGridRequest': GetElevationGridRequest$json,
  '.terrain.v1.BoundingBox': BoundingBox$json,
  '.terrain.v1.GetElevationGridResponse': GetElevationGridResponse$json,
  '.terrain.v1.ComputeSlopeRequest': ComputeSlopeRequest$json,
  '.terrain.v1.ComputeSlopeResponse': ComputeSlopeResponse$json,
  '.terrain.v1.TerrainLayer': TerrainLayer$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.terrain.v1.ComputeAspectRequest': ComputeAspectRequest$json,
  '.terrain.v1.ComputeAspectResponse': ComputeAspectResponse$json,
};

/// Descriptor for `TerrainComputeService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List terrainComputeServiceDescriptor = $convert.base64Decode(
    'ChVUZXJyYWluQ29tcHV0ZVNlcnZpY2USUQoMR2V0RWxldmF0aW9uEh8udGVycmFpbi52MS5HZX'
    'RFbGV2YXRpb25SZXF1ZXN0GiAudGVycmFpbi52MS5HZXRFbGV2YXRpb25SZXNwb25zZRJdChBH'
    'ZXRFbGV2YXRpb25HcmlkEiMudGVycmFpbi52MS5HZXRFbGV2YXRpb25HcmlkUmVxdWVzdBokLn'
    'RlcnJhaW4udjEuR2V0RWxldmF0aW9uR3JpZFJlc3BvbnNlElEKDENvbXB1dGVTbG9wZRIfLnRl'
    'cnJhaW4udjEuQ29tcHV0ZVNsb3BlUmVxdWVzdBogLnRlcnJhaW4udjEuQ29tcHV0ZVNsb3BlUm'
    'VzcG9uc2USVAoNQ29tcHV0ZUFzcGVjdBIgLnRlcnJhaW4udjEuQ29tcHV0ZUFzcGVjdFJlcXVl'
    'c3QaIS50ZXJyYWluLnYxLkNvbXB1dGVBc3BlY3RSZXNwb25zZQ==');

