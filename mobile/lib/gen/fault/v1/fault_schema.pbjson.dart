//
//  Generated code. Do not modify.
//  source: fault/v1/fault_schema.proto
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

@$core.Deprecated('Use faultTypeDescriptor instead')
const FaultType$json = {
  '1': 'FaultType',
  '2': [
    {'1': 'FAULT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'FAULT_TYPE_OVERCURRENT', '2': 1},
    {'1': 'FAULT_TYPE_EARTH_FAULT', '2': 2},
    {'1': 'FAULT_TYPE_UNDERVOLTAGE', '2': 3},
    {'1': 'FAULT_TYPE_OVERVOLTAGE', '2': 4},
    {'1': 'FAULT_TYPE_INVERTER_TRIP', '2': 5},
    {'1': 'FAULT_TYPE_COMMUNICATION_LOSS', '2': 6},
    {'1': 'FAULT_TYPE_THERMAL', '2': 7},
    {'1': 'FAULT_TYPE_MECHANICAL', '2': 8},
    {'1': 'FAULT_TYPE_PROTECTION_TRIP', '2': 9},
  ],
};

/// Descriptor for `FaultType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List faultTypeDescriptor = $convert.base64Decode(
    'CglGYXVsdFR5cGUSGgoWRkFVTFRfVFlQRV9VTlNQRUNJRklFRBAAEhoKFkZBVUxUX1RZUEVfT1'
    'ZFUkNVUlJFTlQQARIaChZGQVVMVF9UWVBFX0VBUlRIX0ZBVUxUEAISGwoXRkFVTFRfVFlQRV9V'
    'TkRFUlZPTFRBR0UQAxIaChZGQVVMVF9UWVBFX09WRVJWT0xUQUdFEAQSHAoYRkFVTFRfVFlQRV'
    '9JTlZFUlRFUl9UUklQEAUSIQodRkFVTFRfVFlQRV9DT01NVU5JQ0FUSU9OX0xPU1MQBhIWChJG'
    'QVVMVF9UWVBFX1RIRVJNQUwQBxIZChVGQVVMVF9UWVBFX01FQ0hBTklDQUwQCBIeChpGQVVMVF'
    '9UWVBFX1BST1RFQ1RJT05fVFJJUBAJ');

@$core.Deprecated('Use faultSeverityDescriptor instead')
const FaultSeverity$json = {
  '1': 'FaultSeverity',
  '2': [
    {'1': 'FAULT_SEVERITY_UNSPECIFIED', '2': 0},
    {'1': 'FAULT_SEVERITY_INFO', '2': 1},
    {'1': 'FAULT_SEVERITY_WARNING', '2': 2},
    {'1': 'FAULT_SEVERITY_CRITICAL', '2': 3},
    {'1': 'FAULT_SEVERITY_EMERGENCY', '2': 4},
  ],
};

/// Descriptor for `FaultSeverity`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List faultSeverityDescriptor = $convert.base64Decode(
    'Cg1GYXVsdFNldmVyaXR5Eh4KGkZBVUxUX1NFVkVSSVRZX1VOU1BFQ0lGSUVEEAASFwoTRkFVTF'
    'RfU0VWRVJJVFlfSU5GTxABEhoKFkZBVUxUX1NFVkVSSVRZX1dBUk5JTkcQAhIbChdGQVVMVF9T'
    'RVZFUklUWV9DUklUSUNBTBADEhwKGEZBVUxUX1NFVkVSSVRZX0VNRVJHRU5DWRAE');

@$core.Deprecated('Use faultStatusDescriptor instead')
const FaultStatus$json = {
  '1': 'FaultStatus',
  '2': [
    {'1': 'FAULT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'FAULT_STATUS_ACTIVE', '2': 1},
    {'1': 'FAULT_STATUS_ACKNOWLEDGED', '2': 2},
    {'1': 'FAULT_STATUS_RESOLVED', '2': 3},
  ],
};

/// Descriptor for `FaultStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List faultStatusDescriptor = $convert.base64Decode(
    'CgtGYXVsdFN0YXR1cxIcChhGQVVMVF9TVEFUVVNfVU5TUEVDSUZJRUQQABIXChNGQVVMVF9TVE'
    'FUVVNfQUNUSVZFEAESHQoZRkFVTFRfU1RBVFVTX0FDS05PV0xFREdFRBACEhkKFUZBVUxUX1NU'
    'QVRVU19SRVNPTFZFRBAD');

@$core.Deprecated('Use faultEventDescriptor instead')
const FaultEvent$json = {
  '1': 'FaultEvent',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'twin_id', '3': 2, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'project_id', '3': 3, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'asset_identity_id', '3': 4, '4': 1, '5': 9, '10': 'assetIdentityId'},
    {'1': 'fault_code', '3': 5, '4': 1, '5': 9, '10': 'faultCode'},
    {'1': 'fault_type', '3': 6, '4': 1, '5': 14, '6': '.fault.v1.FaultType', '10': 'faultType'},
    {'1': 'severity', '3': 7, '4': 1, '5': 14, '6': '.fault.v1.FaultSeverity', '10': 'severity'},
    {'1': 'description', '3': 8, '4': 1, '5': 9, '10': 'description'},
    {'1': 'status', '3': 9, '4': 1, '5': 14, '6': '.fault.v1.FaultStatus', '10': 'status'},
    {'1': 'source_system', '3': 10, '4': 1, '5': 9, '10': 'sourceSystem'},
    {'1': 'detected_at', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'detectedAt'},
    {'1': 'acknowledged_at', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'acknowledgedAt'},
    {'1': 'acknowledged_by_actor_id', '3': 13, '4': 1, '5': 9, '10': 'acknowledgedByActorId'},
    {'1': 'resolved_at', '3': 14, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'resolvedAt'},
    {'1': 'resolved_by_actor_id', '3': 15, '4': 1, '5': 9, '10': 'resolvedByActorId'},
    {'1': 'resolution_notes', '3': 16, '4': 1, '5': 9, '10': 'resolutionNotes'},
    {'1': 'metadata_json', '3': 17, '4': 1, '5': 9, '10': 'metadataJson'},
    {'1': 'created_at', '3': 18, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 19, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `FaultEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List faultEventDescriptor = $convert.base64Decode(
    'CgpGYXVsdEV2ZW50Eg4KAmlkGAEgASgJUgJpZBIXCgd0d2luX2lkGAIgASgJUgZ0d2luSWQSHQ'
    'oKcHJvamVjdF9pZBgDIAEoCVIJcHJvamVjdElkEioKEWFzc2V0X2lkZW50aXR5X2lkGAQgASgJ'
    'Ug9hc3NldElkZW50aXR5SWQSHQoKZmF1bHRfY29kZRgFIAEoCVIJZmF1bHRDb2RlEjIKCmZhdW'
    'x0X3R5cGUYBiABKA4yEy5mYXVsdC52MS5GYXVsdFR5cGVSCWZhdWx0VHlwZRIzCghzZXZlcml0'
    'eRgHIAEoDjIXLmZhdWx0LnYxLkZhdWx0U2V2ZXJpdHlSCHNldmVyaXR5EiAKC2Rlc2NyaXB0aW'
    '9uGAggASgJUgtkZXNjcmlwdGlvbhItCgZzdGF0dXMYCSABKA4yFS5mYXVsdC52MS5GYXVsdFN0'
    'YXR1c1IGc3RhdHVzEiMKDXNvdXJjZV9zeXN0ZW0YCiABKAlSDHNvdXJjZVN5c3RlbRI7CgtkZX'
    'RlY3RlZF9hdBgLIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmRldGVjdGVkQXQS'
    'QwoPYWNrbm93bGVkZ2VkX2F0GAwgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIOYW'
    'Nrbm93bGVkZ2VkQXQSNwoYYWNrbm93bGVkZ2VkX2J5X2FjdG9yX2lkGA0gASgJUhVhY2tub3ds'
    'ZWRnZWRCeUFjdG9ySWQSOwoLcmVzb2x2ZWRfYXQYDiABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUgpyZXNvbHZlZEF0Ei8KFHJlc29sdmVkX2J5X2FjdG9yX2lkGA8gASgJUhFyZXNv'
    'bHZlZEJ5QWN0b3JJZBIpChByZXNvbHV0aW9uX25vdGVzGBAgASgJUg9yZXNvbHV0aW9uTm90ZX'
    'MSIwoNbWV0YWRhdGFfanNvbhgRIAEoCVIMbWV0YWRhdGFKc29uEjkKCmNyZWF0ZWRfYXQYEiAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdB'
    'gTIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');

@$core.Deprecated('Use reportFaultRequestDescriptor instead')
const ReportFaultRequest$json = {
  '1': 'ReportFaultRequest',
  '2': [
    {'1': 'twin_id', '3': 1, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'asset_identity_id', '3': 3, '4': 1, '5': 9, '10': 'assetIdentityId'},
    {'1': 'fault_code', '3': 4, '4': 1, '5': 9, '10': 'faultCode'},
    {'1': 'fault_type', '3': 5, '4': 1, '5': 14, '6': '.fault.v1.FaultType', '10': 'faultType'},
    {'1': 'severity', '3': 6, '4': 1, '5': 14, '6': '.fault.v1.FaultSeverity', '10': 'severity'},
    {'1': 'description', '3': 7, '4': 1, '5': 9, '10': 'description'},
    {'1': 'source_system', '3': 8, '4': 1, '5': 9, '10': 'sourceSystem'},
    {'1': 'detected_at', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'detectedAt'},
    {'1': 'metadata_json', '3': 10, '4': 1, '5': 9, '10': 'metadataJson'},
  ],
};

/// Descriptor for `ReportFaultRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportFaultRequestDescriptor = $convert.base64Decode(
    'ChJSZXBvcnRGYXVsdFJlcXVlc3QSFwoHdHdpbl9pZBgBIAEoCVIGdHdpbklkEh0KCnByb2plY3'
    'RfaWQYAiABKAlSCXByb2plY3RJZBIqChFhc3NldF9pZGVudGl0eV9pZBgDIAEoCVIPYXNzZXRJ'
    'ZGVudGl0eUlkEh0KCmZhdWx0X2NvZGUYBCABKAlSCWZhdWx0Q29kZRIyCgpmYXVsdF90eXBlGA'
    'UgASgOMhMuZmF1bHQudjEuRmF1bHRUeXBlUglmYXVsdFR5cGUSMwoIc2V2ZXJpdHkYBiABKA4y'
    'Fy5mYXVsdC52MS5GYXVsdFNldmVyaXR5UghzZXZlcml0eRIgCgtkZXNjcmlwdGlvbhgHIAEoCV'
    'ILZGVzY3JpcHRpb24SIwoNc291cmNlX3N5c3RlbRgIIAEoCVIMc291cmNlU3lzdGVtEjsKC2Rl'
    'dGVjdGVkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKZGV0ZWN0ZWRBdB'
    'IjCg1tZXRhZGF0YV9qc29uGAogASgJUgxtZXRhZGF0YUpzb24=');

@$core.Deprecated('Use reportFaultResponseDescriptor instead')
const ReportFaultResponse$json = {
  '1': 'ReportFaultResponse',
  '2': [
    {'1': 'fault_event', '3': 1, '4': 1, '5': 11, '6': '.fault.v1.FaultEvent', '10': 'faultEvent'},
  ],
};

/// Descriptor for `ReportFaultResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportFaultResponseDescriptor = $convert.base64Decode(
    'ChNSZXBvcnRGYXVsdFJlc3BvbnNlEjUKC2ZhdWx0X2V2ZW50GAEgASgLMhQuZmF1bHQudjEuRm'
    'F1bHRFdmVudFIKZmF1bHRFdmVudA==');

@$core.Deprecated('Use getFaultRequestDescriptor instead')
const GetFaultRequest$json = {
  '1': 'GetFaultRequest',
  '2': [
    {'1': 'fault_id', '3': 1, '4': 1, '5': 9, '10': 'faultId'},
  ],
};

/// Descriptor for `GetFaultRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFaultRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRGYXVsdFJlcXVlc3QSGQoIZmF1bHRfaWQYASABKAlSB2ZhdWx0SWQ=');

@$core.Deprecated('Use getFaultResponseDescriptor instead')
const GetFaultResponse$json = {
  '1': 'GetFaultResponse',
  '2': [
    {'1': 'fault_event', '3': 1, '4': 1, '5': 11, '6': '.fault.v1.FaultEvent', '10': 'faultEvent'},
  ],
};

/// Descriptor for `GetFaultResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFaultResponseDescriptor = $convert.base64Decode(
    'ChBHZXRGYXVsdFJlc3BvbnNlEjUKC2ZhdWx0X2V2ZW50GAEgASgLMhQuZmF1bHQudjEuRmF1bH'
    'RFdmVudFIKZmF1bHRFdmVudA==');

@$core.Deprecated('Use listFaultsRequestDescriptor instead')
const ListFaultsRequest$json = {
  '1': 'ListFaultsRequest',
  '2': [
    {'1': 'twin_id', '3': 1, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'severity_filter', '3': 3, '4': 1, '5': 14, '6': '.fault.v1.FaultSeverity', '10': 'severityFilter'},
    {'1': 'status_filter', '3': 4, '4': 1, '5': 14, '6': '.fault.v1.FaultStatus', '10': 'statusFilter'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 6, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListFaultsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFaultsRequestDescriptor = $convert.base64Decode(
    'ChFMaXN0RmF1bHRzUmVxdWVzdBIXCgd0d2luX2lkGAEgASgJUgZ0d2luSWQSHQoKcHJvamVjdF'
    '9pZBgCIAEoCVIJcHJvamVjdElkEkAKD3NldmVyaXR5X2ZpbHRlchgDIAEoDjIXLmZhdWx0LnYx'
    'LkZhdWx0U2V2ZXJpdHlSDnNldmVyaXR5RmlsdGVyEjoKDXN0YXR1c19maWx0ZXIYBCABKA4yFS'
    '5mYXVsdC52MS5GYXVsdFN0YXR1c1IMc3RhdHVzRmlsdGVyEhsKCXBhZ2Vfc2l6ZRgFIAEoBVII'
    'cGFnZVNpemUSHQoKcGFnZV90b2tlbhgGIAEoCVIJcGFnZVRva2Vu');

@$core.Deprecated('Use listFaultsResponseDescriptor instead')
const ListFaultsResponse$json = {
  '1': 'ListFaultsResponse',
  '2': [
    {'1': 'fault_events', '3': 1, '4': 3, '5': 11, '6': '.fault.v1.FaultEvent', '10': 'faultEvents'},
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListFaultsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFaultsResponseDescriptor = $convert.base64Decode(
    'ChJMaXN0RmF1bHRzUmVzcG9uc2USNwoMZmF1bHRfZXZlbnRzGAEgAygLMhQuZmF1bHQudjEuRm'
    'F1bHRFdmVudFILZmF1bHRFdmVudHMSJgoPbmV4dF9wYWdlX3Rva2VuGAIgASgJUg1uZXh0UGFn'
    'ZVRva2VuEh8KC3RvdGFsX2NvdW50GAMgASgFUgp0b3RhbENvdW50');

@$core.Deprecated('Use acknowledgeFaultRequestDescriptor instead')
const AcknowledgeFaultRequest$json = {
  '1': 'AcknowledgeFaultRequest',
  '2': [
    {'1': 'fault_id', '3': 1, '4': 1, '5': 9, '10': 'faultId'},
    {'1': 'actor_id', '3': 2, '4': 1, '5': 9, '10': 'actorId'},
  ],
};

/// Descriptor for `AcknowledgeFaultRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeFaultRequestDescriptor = $convert.base64Decode(
    'ChdBY2tub3dsZWRnZUZhdWx0UmVxdWVzdBIZCghmYXVsdF9pZBgBIAEoCVIHZmF1bHRJZBIZCg'
    'hhY3Rvcl9pZBgCIAEoCVIHYWN0b3JJZA==');

@$core.Deprecated('Use acknowledgeFaultResponseDescriptor instead')
const AcknowledgeFaultResponse$json = {
  '1': 'AcknowledgeFaultResponse',
  '2': [
    {'1': 'fault_event', '3': 1, '4': 1, '5': 11, '6': '.fault.v1.FaultEvent', '10': 'faultEvent'},
  ],
};

/// Descriptor for `AcknowledgeFaultResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgeFaultResponseDescriptor = $convert.base64Decode(
    'ChhBY2tub3dsZWRnZUZhdWx0UmVzcG9uc2USNQoLZmF1bHRfZXZlbnQYASABKAsyFC5mYXVsdC'
    '52MS5GYXVsdEV2ZW50UgpmYXVsdEV2ZW50');

@$core.Deprecated('Use resolveFaultRequestDescriptor instead')
const ResolveFaultRequest$json = {
  '1': 'ResolveFaultRequest',
  '2': [
    {'1': 'fault_id', '3': 1, '4': 1, '5': 9, '10': 'faultId'},
    {'1': 'actor_id', '3': 2, '4': 1, '5': 9, '10': 'actorId'},
    {'1': 'resolution_notes', '3': 3, '4': 1, '5': 9, '10': 'resolutionNotes'},
  ],
};

/// Descriptor for `ResolveFaultRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveFaultRequestDescriptor = $convert.base64Decode(
    'ChNSZXNvbHZlRmF1bHRSZXF1ZXN0EhkKCGZhdWx0X2lkGAEgASgJUgdmYXVsdElkEhkKCGFjdG'
    '9yX2lkGAIgASgJUgdhY3RvcklkEikKEHJlc29sdXRpb25fbm90ZXMYAyABKAlSD3Jlc29sdXRp'
    'b25Ob3Rlcw==');

@$core.Deprecated('Use resolveFaultResponseDescriptor instead')
const ResolveFaultResponse$json = {
  '1': 'ResolveFaultResponse',
  '2': [
    {'1': 'fault_event', '3': 1, '4': 1, '5': 11, '6': '.fault.v1.FaultEvent', '10': 'faultEvent'},
  ],
};

/// Descriptor for `ResolveFaultResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resolveFaultResponseDescriptor = $convert.base64Decode(
    'ChRSZXNvbHZlRmF1bHRSZXNwb25zZRI1CgtmYXVsdF9ldmVudBgBIAEoCzIULmZhdWx0LnYxLk'
    'ZhdWx0RXZlbnRSCmZhdWx0RXZlbnQ=');

const $core.Map<$core.String, $core.dynamic> FaultServiceBase$json = {
  '1': 'FaultService',
  '2': [
    {'1': 'ReportFault', '2': '.fault.v1.ReportFaultRequest', '3': '.fault.v1.ReportFaultResponse'},
    {'1': 'GetFault', '2': '.fault.v1.GetFaultRequest', '3': '.fault.v1.GetFaultResponse'},
    {'1': 'ListFaults', '2': '.fault.v1.ListFaultsRequest', '3': '.fault.v1.ListFaultsResponse'},
    {'1': 'AcknowledgeFault', '2': '.fault.v1.AcknowledgeFaultRequest', '3': '.fault.v1.AcknowledgeFaultResponse'},
    {'1': 'ResolveFault', '2': '.fault.v1.ResolveFaultRequest', '3': '.fault.v1.ResolveFaultResponse'},
  ],
};

@$core.Deprecated('Use faultServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> FaultServiceBase$messageJson = {
  '.fault.v1.ReportFaultRequest': ReportFaultRequest$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.fault.v1.ReportFaultResponse': ReportFaultResponse$json,
  '.fault.v1.FaultEvent': FaultEvent$json,
  '.fault.v1.GetFaultRequest': GetFaultRequest$json,
  '.fault.v1.GetFaultResponse': GetFaultResponse$json,
  '.fault.v1.ListFaultsRequest': ListFaultsRequest$json,
  '.fault.v1.ListFaultsResponse': ListFaultsResponse$json,
  '.fault.v1.AcknowledgeFaultRequest': AcknowledgeFaultRequest$json,
  '.fault.v1.AcknowledgeFaultResponse': AcknowledgeFaultResponse$json,
  '.fault.v1.ResolveFaultRequest': ResolveFaultRequest$json,
  '.fault.v1.ResolveFaultResponse': ResolveFaultResponse$json,
};

/// Descriptor for `FaultService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List faultServiceDescriptor = $convert.base64Decode(
    'CgxGYXVsdFNlcnZpY2USSgoLUmVwb3J0RmF1bHQSHC5mYXVsdC52MS5SZXBvcnRGYXVsdFJlcX'
    'Vlc3QaHS5mYXVsdC52MS5SZXBvcnRGYXVsdFJlc3BvbnNlEkEKCEdldEZhdWx0EhkuZmF1bHQu'
    'djEuR2V0RmF1bHRSZXF1ZXN0GhouZmF1bHQudjEuR2V0RmF1bHRSZXNwb25zZRJHCgpMaXN0Rm'
    'F1bHRzEhsuZmF1bHQudjEuTGlzdEZhdWx0c1JlcXVlc3QaHC5mYXVsdC52MS5MaXN0RmF1bHRz'
    'UmVzcG9uc2USWQoQQWNrbm93bGVkZ2VGYXVsdBIhLmZhdWx0LnYxLkFja25vd2xlZGdlRmF1bH'
    'RSZXF1ZXN0GiIuZmF1bHQudjEuQWNrbm93bGVkZ2VGYXVsdFJlc3BvbnNlEk0KDFJlc29sdmVG'
    'YXVsdBIdLmZhdWx0LnYxLlJlc29sdmVGYXVsdFJlcXVlc3QaHi5mYXVsdC52MS5SZXNvbHZlRm'
    'F1bHRSZXNwb25zZQ==');

