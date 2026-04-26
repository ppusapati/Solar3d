//
//  Generated code. Do not modify.
//  source: simulation/v1/simulation.proto
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

@$core.Deprecated('Use simulationTypeDescriptor instead')
const SimulationType$json = {
  '1': 'SimulationType',
  '2': [
    {'1': 'SIMULATION_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'SIMULATION_TYPE_SHADOW', '2': 1},
    {'1': 'SIMULATION_TYPE_IRRADIANCE', '2': 2},
    {'1': 'SIMULATION_TYPE_ANNUAL_YIELD', '2': 3},
  ],
};

/// Descriptor for `SimulationType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List simulationTypeDescriptor = $convert.base64Decode(
    'Cg5TaW11bGF0aW9uVHlwZRIfChtTSU1VTEFUSU9OX1RZUEVfVU5TUEVDSUZJRUQQABIaChZTSU'
    '1VTEFUSU9OX1RZUEVfU0hBRE9XEAESHgoaU0lNVUxBVElPTl9UWVBFX0lSUkFESUFOQ0UQAhIg'
    'ChxTSU1VTEFUSU9OX1RZUEVfQU5OVUFMX1lJRUxEEAM=');

@$core.Deprecated('Use simulationStatusDescriptor instead')
const SimulationStatus$json = {
  '1': 'SimulationStatus',
  '2': [
    {'1': 'SIMULATION_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'SIMULATION_STATUS_PENDING', '2': 1},
    {'1': 'SIMULATION_STATUS_RUNNING', '2': 2},
    {'1': 'SIMULATION_STATUS_COMPLETED', '2': 3},
    {'1': 'SIMULATION_STATUS_FAILED', '2': 4},
  ],
};

/// Descriptor for `SimulationStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List simulationStatusDescriptor = $convert.base64Decode(
    'ChBTaW11bGF0aW9uU3RhdHVzEiEKHVNJTVVMQVRJT05fU1RBVFVTX1VOU1BFQ0lGSUVEEAASHQ'
    'oZU0lNVUxBVElPTl9TVEFUVVNfUEVORElORxABEh0KGVNJTVVMQVRJT05fU1RBVFVTX1JVTk5J'
    'TkcQAhIfChtTSU1VTEFUSU9OX1NUQVRVU19DT01QTEVURUQQAxIcChhTSU1VTEFUSU9OX1NUQV'
    'RVU19GQUlMRUQQBA==');

@$core.Deprecated('Use simulationDescriptor instead')
const Simulation$json = {
  '1': 'Simulation',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 3, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'simulation_type', '3': 5, '4': 1, '5': 14, '6': '.simulation.v1.SimulationType', '10': 'simulationType'},
    {'1': 'status', '3': 6, '4': 1, '5': 14, '6': '.simulation.v1.SimulationStatus', '10': 'status'},
    {'1': 'params', '3': 7, '4': 1, '5': 11, '6': '.simulation.v1.SimulationParams', '10': 'params'},
    {'1': 'result', '3': 8, '4': 1, '5': 11, '6': '.simulation.v1.SimulationResult', '10': 'result'},
    {'1': 'created_at', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'completed_at', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'completedAt'},
  ],
};

/// Descriptor for `Simulation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List simulationDescriptor = $convert.base64Decode(
    'CgpTaW11bGF0aW9uEg4KAmlkGAEgASgJUgJpZBIdCgpwcm9qZWN0X2lkGAIgASgJUglwcm9qZW'
    'N0SWQSGwoJbGF5b3V0X2lkGAMgASgJUghsYXlvdXRJZBISCgRuYW1lGAQgASgJUgRuYW1lEkYK'
    'D3NpbXVsYXRpb25fdHlwZRgFIAEoDjIdLnNpbXVsYXRpb24udjEuU2ltdWxhdGlvblR5cGVSDn'
    'NpbXVsYXRpb25UeXBlEjcKBnN0YXR1cxgGIAEoDjIfLnNpbXVsYXRpb24udjEuU2ltdWxhdGlv'
    'blN0YXR1c1IGc3RhdHVzEjcKBnBhcmFtcxgHIAEoCzIfLnNpbXVsYXRpb24udjEuU2ltdWxhdG'
    'lvblBhcmFtc1IGcGFyYW1zEjcKBnJlc3VsdBgIIAEoCzIfLnNpbXVsYXRpb24udjEuU2ltdWxh'
    'dGlvblJlc3VsdFIGcmVzdWx0EjkKCmNyZWF0ZWRfYXQYCSABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUgljcmVhdGVkQXQSPQoMY29tcGxldGVkX2F0GAogASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFILY29tcGxldGVkQXQ=');

@$core.Deprecated('Use simulationParamsDescriptor instead')
const SimulationParams$json = {
  '1': 'SimulationParams',
  '2': [
    {'1': 'start_time', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'startTime'},
    {'1': 'end_time', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'endTime'},
    {'1': 'time_step_minutes', '3': 3, '4': 1, '5': 5, '10': 'timeStepMinutes'},
    {'1': 'latitude', '3': 4, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 5, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'include_terrain_shading', '3': 6, '4': 1, '5': 8, '10': 'includeTerrainShading'},
    {'1': 'include_panel_shading', '3': 7, '4': 1, '5': 8, '10': 'includePanelShading'},
  ],
};

/// Descriptor for `SimulationParams`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List simulationParamsDescriptor = $convert.base64Decode(
    'ChBTaW11bGF0aW9uUGFyYW1zEjkKCnN0YXJ0X3RpbWUYASABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUglzdGFydFRpbWUSNQoIZW5kX3RpbWUYAiABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUgdlbmRUaW1lEioKEXRpbWVfc3RlcF9taW51dGVzGAMgASgFUg90aW1lU3'
    'RlcE1pbnV0ZXMSGgoIbGF0aXR1ZGUYBCABKAFSCGxhdGl0dWRlEhwKCWxvbmdpdHVkZRgFIAEo'
    'AVIJbG9uZ2l0dWRlEjYKF2luY2x1ZGVfdGVycmFpbl9zaGFkaW5nGAYgASgIUhVpbmNsdWRlVG'
    'VycmFpblNoYWRpbmcSMgoVaW5jbHVkZV9wYW5lbF9zaGFkaW5nGAcgASgIUhNpbmNsdWRlUGFu'
    'ZWxTaGFkaW5n');

@$core.Deprecated('Use simulationResultDescriptor instead')
const SimulationResult$json = {
  '1': 'SimulationResult',
  '2': [
    {'1': 'total_irradiance_kwh_m2', '3': 1, '4': 1, '5': 1, '10': 'totalIrradianceKwhM2'},
    {'1': 'annual_yield_kwh', '3': 2, '4': 1, '5': 1, '10': 'annualYieldKwh'},
    {'1': 'performance_ratio', '3': 3, '4': 1, '5': 1, '10': 'performanceRatio'},
    {'1': 'shading_loss_percent', '3': 4, '4': 1, '5': 1, '10': 'shadingLossPercent'},
    {'1': 'result_file_path', '3': 5, '4': 1, '5': 9, '10': 'resultFilePath'},
  ],
};

/// Descriptor for `SimulationResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List simulationResultDescriptor = $convert.base64Decode(
    'ChBTaW11bGF0aW9uUmVzdWx0EjUKF3RvdGFsX2lycmFkaWFuY2Vfa3doX20yGAEgASgBUhR0b3'
    'RhbElycmFkaWFuY2VLd2hNMhIoChBhbm51YWxfeWllbGRfa3doGAIgASgBUg5hbm51YWxZaWVs'
    'ZEt3aBIrChFwZXJmb3JtYW5jZV9yYXRpbxgDIAEoAVIQcGVyZm9ybWFuY2VSYXRpbxIwChRzaG'
    'FkaW5nX2xvc3NfcGVyY2VudBgEIAEoAVISc2hhZGluZ0xvc3NQZXJjZW50EigKEHJlc3VsdF9m'
    'aWxlX3BhdGgYBSABKAlSDnJlc3VsdEZpbGVQYXRo');

@$core.Deprecated('Use sunPositionDescriptor instead')
const SunPosition$json = {
  '1': 'SunPosition',
  '2': [
    {'1': 'azimuth', '3': 1, '4': 1, '5': 1, '10': 'azimuth'},
    {'1': 'elevation', '3': 2, '4': 1, '5': 1, '10': 'elevation'},
    {'1': 'zenith', '3': 3, '4': 1, '5': 1, '10': 'zenith'},
    {'1': 'hour_angle', '3': 4, '4': 1, '5': 1, '10': 'hourAngle'},
    {'1': 'timestamp', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
  ],
};

/// Descriptor for `SunPosition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sunPositionDescriptor = $convert.base64Decode(
    'CgtTdW5Qb3NpdGlvbhIYCgdhemltdXRoGAEgASgBUgdhemltdXRoEhwKCWVsZXZhdGlvbhgCIA'
    'EoAVIJZWxldmF0aW9uEhYKBnplbml0aBgDIAEoAVIGemVuaXRoEh0KCmhvdXJfYW5nbGUYBCAB'
    'KAFSCWhvdXJBbmdsZRI4Cgl0aW1lc3RhbXAYBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZX'
    'N0YW1wUgl0aW1lc3RhbXA=');

@$core.Deprecated('Use shadowPolygonDescriptor instead')
const ShadowPolygon$json = {
  '1': 'ShadowPolygon',
  '2': [
    {'1': 'source_panel_id', '3': 1, '4': 1, '5': 9, '10': 'sourcePanelId'},
    {'1': 'shadow_geojson', '3': 2, '4': 1, '5': 9, '10': 'shadowGeojson'},
    {'1': 'shadow_intensity', '3': 3, '4': 1, '5': 1, '10': 'shadowIntensity'},
  ],
};

/// Descriptor for `ShadowPolygon`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List shadowPolygonDescriptor = $convert.base64Decode(
    'Cg1TaGFkb3dQb2x5Z29uEiYKD3NvdXJjZV9wYW5lbF9pZBgBIAEoCVINc291cmNlUGFuZWxJZB'
    'IlCg5zaGFkb3dfZ2VvanNvbhgCIAEoCVINc2hhZG93R2VvanNvbhIpChBzaGFkb3dfaW50ZW5z'
    'aXR5GAMgASgBUg9zaGFkb3dJbnRlbnNpdHk=');

@$core.Deprecated('Use createSimulationRequestDescriptor instead')
const CreateSimulationRequest$json = {
  '1': 'CreateSimulationRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'simulation_type', '3': 4, '4': 1, '5': 14, '6': '.simulation.v1.SimulationType', '10': 'simulationType'},
    {'1': 'params', '3': 5, '4': 1, '5': 11, '6': '.simulation.v1.SimulationParams', '10': 'params'},
  ],
};

/// Descriptor for `CreateSimulationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createSimulationRequestDescriptor = $convert.base64Decode(
    'ChdDcmVhdGVTaW11bGF0aW9uUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SW'
    'QSGwoJbGF5b3V0X2lkGAIgASgJUghsYXlvdXRJZBISCgRuYW1lGAMgASgJUgRuYW1lEkYKD3Np'
    'bXVsYXRpb25fdHlwZRgEIAEoDjIdLnNpbXVsYXRpb24udjEuU2ltdWxhdGlvblR5cGVSDnNpbX'
    'VsYXRpb25UeXBlEjcKBnBhcmFtcxgFIAEoCzIfLnNpbXVsYXRpb24udjEuU2ltdWxhdGlvblBh'
    'cmFtc1IGcGFyYW1z');

@$core.Deprecated('Use createSimulationResponseDescriptor instead')
const CreateSimulationResponse$json = {
  '1': 'CreateSimulationResponse',
  '2': [
    {'1': 'simulation', '3': 1, '4': 1, '5': 11, '6': '.simulation.v1.Simulation', '10': 'simulation'},
  ],
};

/// Descriptor for `CreateSimulationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createSimulationResponseDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVTaW11bGF0aW9uUmVzcG9uc2USOQoKc2ltdWxhdGlvbhgBIAEoCzIZLnNpbXVsYX'
    'Rpb24udjEuU2ltdWxhdGlvblIKc2ltdWxhdGlvbg==');

@$core.Deprecated('Use getSimulationRequestDescriptor instead')
const GetSimulationRequest$json = {
  '1': 'GetSimulationRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetSimulationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSimulationRequestDescriptor = $convert.base64Decode(
    'ChRHZXRTaW11bGF0aW9uUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use getSimulationResponseDescriptor instead')
const GetSimulationResponse$json = {
  '1': 'GetSimulationResponse',
  '2': [
    {'1': 'simulation', '3': 1, '4': 1, '5': 11, '6': '.simulation.v1.Simulation', '10': 'simulation'},
  ],
};

/// Descriptor for `GetSimulationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSimulationResponseDescriptor = $convert.base64Decode(
    'ChVHZXRTaW11bGF0aW9uUmVzcG9uc2USOQoKc2ltdWxhdGlvbhgBIAEoCzIZLnNpbXVsYXRpb2'
    '4udjEuU2ltdWxhdGlvblIKc2ltdWxhdGlvbg==');

@$core.Deprecated('Use listSimulationsRequestDescriptor instead')
const ListSimulationsRequest$json = {
  '1': 'ListSimulationsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
  ],
};

/// Descriptor for `ListSimulationsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSimulationsRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0U2ltdWxhdGlvbnNSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZA'
    '==');

@$core.Deprecated('Use listSimulationsResponseDescriptor instead')
const ListSimulationsResponse$json = {
  '1': 'ListSimulationsResponse',
  '2': [
    {'1': 'simulations', '3': 1, '4': 3, '5': 11, '6': '.simulation.v1.Simulation', '10': 'simulations'},
  ],
};

/// Descriptor for `ListSimulationsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSimulationsResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0U2ltdWxhdGlvbnNSZXNwb25zZRI7CgtzaW11bGF0aW9ucxgBIAMoCzIZLnNpbXVsYX'
    'Rpb24udjEuU2ltdWxhdGlvblILc2ltdWxhdGlvbnM=');

@$core.Deprecated('Use runSimulationRequestDescriptor instead')
const RunSimulationRequest$json = {
  '1': 'RunSimulationRequest',
  '2': [
    {'1': 'simulation_id', '3': 1, '4': 1, '5': 9, '10': 'simulationId'},
  ],
};

/// Descriptor for `RunSimulationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runSimulationRequestDescriptor = $convert.base64Decode(
    'ChRSdW5TaW11bGF0aW9uUmVxdWVzdBIjCg1zaW11bGF0aW9uX2lkGAEgASgJUgxzaW11bGF0aW'
    '9uSWQ=');

@$core.Deprecated('Use runSimulationResponseDescriptor instead')
const RunSimulationResponse$json = {
  '1': 'RunSimulationResponse',
  '2': [
    {'1': 'simulation', '3': 1, '4': 1, '5': 11, '6': '.simulation.v1.Simulation', '10': 'simulation'},
  ],
};

/// Descriptor for `RunSimulationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List runSimulationResponseDescriptor = $convert.base64Decode(
    'ChVSdW5TaW11bGF0aW9uUmVzcG9uc2USOQoKc2ltdWxhdGlvbhgBIAEoCzIZLnNpbXVsYXRpb2'
    '4udjEuU2ltdWxhdGlvblIKc2ltdWxhdGlvbg==');

@$core.Deprecated('Use getSunPositionRequestDescriptor instead')
const GetSunPositionRequest$json = {
  '1': 'GetSunPositionRequest',
  '2': [
    {'1': 'latitude', '3': 1, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'timestamp', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
  ],
};

/// Descriptor for `GetSunPositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSunPositionRequestDescriptor = $convert.base64Decode(
    'ChVHZXRTdW5Qb3NpdGlvblJlcXVlc3QSGgoIbGF0aXR1ZGUYASABKAFSCGxhdGl0dWRlEhwKCW'
    'xvbmdpdHVkZRgCIAEoAVIJbG9uZ2l0dWRlEjgKCXRpbWVzdGFtcBgDIAEoCzIaLmdvb2dsZS5w'
    'cm90b2J1Zi5UaW1lc3RhbXBSCXRpbWVzdGFtcA==');

@$core.Deprecated('Use getSunPositionResponseDescriptor instead')
const GetSunPositionResponse$json = {
  '1': 'GetSunPositionResponse',
  '2': [
    {'1': 'position', '3': 1, '4': 1, '5': 11, '6': '.simulation.v1.SunPosition', '10': 'position'},
  ],
};

/// Descriptor for `GetSunPositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSunPositionResponseDescriptor = $convert.base64Decode(
    'ChZHZXRTdW5Qb3NpdGlvblJlc3BvbnNlEjYKCHBvc2l0aW9uGAEgASgLMhouc2ltdWxhdGlvbi'
    '52MS5TdW5Qb3NpdGlvblIIcG9zaXRpb24=');

@$core.Deprecated('Use getShadowMapRequestDescriptor instead')
const GetShadowMapRequest$json = {
  '1': 'GetShadowMapRequest',
  '2': [
    {'1': 'layout_id', '3': 1, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    {'1': 'latitude', '3': 3, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 4, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

/// Descriptor for `GetShadowMapRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getShadowMapRequestDescriptor = $convert.base64Decode(
    'ChNHZXRTaGFkb3dNYXBSZXF1ZXN0EhsKCWxheW91dF9pZBgBIAEoCVIIbGF5b3V0SWQSOAoJdG'
    'ltZXN0YW1wGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdGltZXN0YW1wEhoK'
    'CGxhdGl0dWRlGAMgASgBUghsYXRpdHVkZRIcCglsb25naXR1ZGUYBCABKAFSCWxvbmdpdHVkZQ'
    '==');

@$core.Deprecated('Use getShadowMapResponseDescriptor instead')
const GetShadowMapResponse$json = {
  '1': 'GetShadowMapResponse',
  '2': [
    {'1': 'shadows', '3': 1, '4': 3, '5': 11, '6': '.simulation.v1.ShadowPolygon', '10': 'shadows'},
    {'1': 'sun_position', '3': 2, '4': 1, '5': 11, '6': '.simulation.v1.SunPosition', '10': 'sunPosition'},
  ],
};

/// Descriptor for `GetShadowMapResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getShadowMapResponseDescriptor = $convert.base64Decode(
    'ChRHZXRTaGFkb3dNYXBSZXNwb25zZRI2CgdzaGFkb3dzGAEgAygLMhwuc2ltdWxhdGlvbi52MS'
    '5TaGFkb3dQb2x5Z29uUgdzaGFkb3dzEj0KDHN1bl9wb3NpdGlvbhgCIAEoCzIaLnNpbXVsYXRp'
    'b24udjEuU3VuUG9zaXRpb25SC3N1blBvc2l0aW9u');

@$core.Deprecated('Use deleteSimulationRequestDescriptor instead')
const DeleteSimulationRequest$json = {
  '1': 'DeleteSimulationRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteSimulationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteSimulationRequestDescriptor = $convert.base64Decode(
    'ChdEZWxldGVTaW11bGF0aW9uUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use deleteSimulationResponseDescriptor instead')
const DeleteSimulationResponse$json = {
  '1': 'DeleteSimulationResponse',
};

/// Descriptor for `DeleteSimulationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteSimulationResponseDescriptor = $convert.base64Decode(
    'ChhEZWxldGVTaW11bGF0aW9uUmVzcG9uc2U=');

const $core.Map<$core.String, $core.dynamic> SimulationServiceBase$json = {
  '1': 'SimulationService',
  '2': [
    {'1': 'CreateSimulation', '2': '.simulation.v1.CreateSimulationRequest', '3': '.simulation.v1.CreateSimulationResponse'},
    {'1': 'GetSimulation', '2': '.simulation.v1.GetSimulationRequest', '3': '.simulation.v1.GetSimulationResponse'},
    {'1': 'ListSimulations', '2': '.simulation.v1.ListSimulationsRequest', '3': '.simulation.v1.ListSimulationsResponse'},
    {'1': 'RunSimulation', '2': '.simulation.v1.RunSimulationRequest', '3': '.simulation.v1.RunSimulationResponse'},
    {'1': 'GetSunPosition', '2': '.simulation.v1.GetSunPositionRequest', '3': '.simulation.v1.GetSunPositionResponse'},
    {'1': 'GetShadowMap', '2': '.simulation.v1.GetShadowMapRequest', '3': '.simulation.v1.GetShadowMapResponse'},
    {'1': 'DeleteSimulation', '2': '.simulation.v1.DeleteSimulationRequest', '3': '.simulation.v1.DeleteSimulationResponse'},
  ],
};

@$core.Deprecated('Use simulationServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> SimulationServiceBase$messageJson = {
  '.simulation.v1.CreateSimulationRequest': CreateSimulationRequest$json,
  '.simulation.v1.SimulationParams': SimulationParams$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.simulation.v1.CreateSimulationResponse': CreateSimulationResponse$json,
  '.simulation.v1.Simulation': Simulation$json,
  '.simulation.v1.SimulationResult': SimulationResult$json,
  '.simulation.v1.GetSimulationRequest': GetSimulationRequest$json,
  '.simulation.v1.GetSimulationResponse': GetSimulationResponse$json,
  '.simulation.v1.ListSimulationsRequest': ListSimulationsRequest$json,
  '.simulation.v1.ListSimulationsResponse': ListSimulationsResponse$json,
  '.simulation.v1.RunSimulationRequest': RunSimulationRequest$json,
  '.simulation.v1.RunSimulationResponse': RunSimulationResponse$json,
  '.simulation.v1.GetSunPositionRequest': GetSunPositionRequest$json,
  '.simulation.v1.GetSunPositionResponse': GetSunPositionResponse$json,
  '.simulation.v1.SunPosition': SunPosition$json,
  '.simulation.v1.GetShadowMapRequest': GetShadowMapRequest$json,
  '.simulation.v1.GetShadowMapResponse': GetShadowMapResponse$json,
  '.simulation.v1.ShadowPolygon': ShadowPolygon$json,
  '.simulation.v1.DeleteSimulationRequest': DeleteSimulationRequest$json,
  '.simulation.v1.DeleteSimulationResponse': DeleteSimulationResponse$json,
};

/// Descriptor for `SimulationService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List simulationServiceDescriptor = $convert.base64Decode(
    'ChFTaW11bGF0aW9uU2VydmljZRJjChBDcmVhdGVTaW11bGF0aW9uEiYuc2ltdWxhdGlvbi52MS'
    '5DcmVhdGVTaW11bGF0aW9uUmVxdWVzdBonLnNpbXVsYXRpb24udjEuQ3JlYXRlU2ltdWxhdGlv'
    'blJlc3BvbnNlEloKDUdldFNpbXVsYXRpb24SIy5zaW11bGF0aW9uLnYxLkdldFNpbXVsYXRpb2'
    '5SZXF1ZXN0GiQuc2ltdWxhdGlvbi52MS5HZXRTaW11bGF0aW9uUmVzcG9uc2USYAoPTGlzdFNp'
    'bXVsYXRpb25zEiUuc2ltdWxhdGlvbi52MS5MaXN0U2ltdWxhdGlvbnNSZXF1ZXN0GiYuc2ltdW'
    'xhdGlvbi52MS5MaXN0U2ltdWxhdGlvbnNSZXNwb25zZRJaCg1SdW5TaW11bGF0aW9uEiMuc2lt'
    'dWxhdGlvbi52MS5SdW5TaW11bGF0aW9uUmVxdWVzdBokLnNpbXVsYXRpb24udjEuUnVuU2ltdW'
    'xhdGlvblJlc3BvbnNlEl0KDkdldFN1blBvc2l0aW9uEiQuc2ltdWxhdGlvbi52MS5HZXRTdW5Q'
    'b3NpdGlvblJlcXVlc3QaJS5zaW11bGF0aW9uLnYxLkdldFN1blBvc2l0aW9uUmVzcG9uc2USVw'
    'oMR2V0U2hhZG93TWFwEiIuc2ltdWxhdGlvbi52MS5HZXRTaGFkb3dNYXBSZXF1ZXN0GiMuc2lt'
    'dWxhdGlvbi52MS5HZXRTaGFkb3dNYXBSZXNwb25zZRJjChBEZWxldGVTaW11bGF0aW9uEiYuc2'
    'ltdWxhdGlvbi52MS5EZWxldGVTaW11bGF0aW9uUmVxdWVzdBonLnNpbXVsYXRpb24udjEuRGVs'
    'ZXRlU2ltdWxhdGlvblJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> SimulationComputeServiceBase$json = {
  '1': 'SimulationComputeService',
  '2': [
    {'1': 'GetSunPosition', '2': '.simulation.v1.GetSunPositionRequest', '3': '.simulation.v1.GetSunPositionResponse'},
    {'1': 'GetShadowMap', '2': '.simulation.v1.GetShadowMapRequest', '3': '.simulation.v1.GetShadowMapResponse'},
  ],
};

@$core.Deprecated('Use simulationComputeServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> SimulationComputeServiceBase$messageJson = {
  '.simulation.v1.GetSunPositionRequest': GetSunPositionRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.simulation.v1.GetSunPositionResponse': GetSunPositionResponse$json,
  '.simulation.v1.SunPosition': SunPosition$json,
  '.simulation.v1.GetShadowMapRequest': GetShadowMapRequest$json,
  '.simulation.v1.GetShadowMapResponse': GetShadowMapResponse$json,
  '.simulation.v1.ShadowPolygon': ShadowPolygon$json,
};

/// Descriptor for `SimulationComputeService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List simulationComputeServiceDescriptor = $convert.base64Decode(
    'ChhTaW11bGF0aW9uQ29tcHV0ZVNlcnZpY2USXQoOR2V0U3VuUG9zaXRpb24SJC5zaW11bGF0aW'
    '9uLnYxLkdldFN1blBvc2l0aW9uUmVxdWVzdBolLnNpbXVsYXRpb24udjEuR2V0U3VuUG9zaXRp'
    'b25SZXNwb25zZRJXCgxHZXRTaGFkb3dNYXASIi5zaW11bGF0aW9uLnYxLkdldFNoYWRvd01hcF'
    'JlcXVlc3QaIy5zaW11bGF0aW9uLnYxLkdldFNoYWRvd01hcFJlc3BvbnNl');

