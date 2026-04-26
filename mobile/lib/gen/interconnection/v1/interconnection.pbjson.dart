//
//  Generated code. Do not modify.
//  source: interconnection/v1/interconnection.proto
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

@$core.Deprecated('Use pOIDescriptor instead')
const POI$json = {
  '1': 'POI',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'utility_name', '3': 3, '4': 1, '5': 9, '10': 'utilityName'},
    {'1': 'feeder_id', '3': 4, '4': 1, '5': 9, '10': 'feederId'},
    {'1': 'latitude', '3': 5, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 6, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'voltage_kv', '3': 7, '4': 1, '5': 1, '10': 'voltageKv'},
    {'1': 'available_capacity_mva', '3': 8, '4': 1, '5': 1, '10': 'availableCapacityMva'},
    {'1': 'fault_current_ka', '3': 9, '4': 1, '5': 1, '10': 'faultCurrentKa'},
    {'1': 'interconnection_type', '3': 10, '4': 1, '5': 9, '10': 'interconnectionType'},
    {'1': 'created_at', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
  ],
};

/// Descriptor for `POI`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pOIDescriptor = $convert.base64Decode(
    'CgNQT0kSDgoCaWQYASABKAlSAmlkEh0KCnByb2plY3RfaWQYAiABKAlSCXByb2plY3RJZBIhCg'
    'x1dGlsaXR5X25hbWUYAyABKAlSC3V0aWxpdHlOYW1lEhsKCWZlZWRlcl9pZBgEIAEoCVIIZmVl'
    'ZGVySWQSGgoIbGF0aXR1ZGUYBSABKAFSCGxhdGl0dWRlEhwKCWxvbmdpdHVkZRgGIAEoAVIJbG'
    '9uZ2l0dWRlEh0KCnZvbHRhZ2Vfa3YYByABKAFSCXZvbHRhZ2VLdhI0ChZhdmFpbGFibGVfY2Fw'
    'YWNpdHlfbXZhGAggASgBUhRhdmFpbGFibGVDYXBhY2l0eU12YRIoChBmYXVsdF9jdXJyZW50X2'
    'thGAkgASgBUg5mYXVsdEN1cnJlbnRLYRIxChRpbnRlcmNvbm5lY3Rpb25fdHlwZRgKIAEoCVIT'
    'aW50ZXJjb25uZWN0aW9uVHlwZRI5CgpjcmVhdGVkX2F0GAsgASgLMhouZ29vZ2xlLnByb3RvYn'
    'VmLlRpbWVzdGFtcFIJY3JlYXRlZEF0');

@$core.Deprecated('Use transformerSizingDescriptor instead')
const TransformerSizing$json = {
  '1': 'TransformerSizing',
  '2': [
    {'1': 'recommended_kva', '3': 1, '4': 1, '5': 1, '10': 'recommendedKva'},
    {'1': 'primary_voltage_v', '3': 2, '4': 1, '5': 1, '10': 'primaryVoltageV'},
    {'1': 'secondary_voltage_v', '3': 3, '4': 1, '5': 1, '10': 'secondaryVoltageV'},
    {'1': 'impedance_pct', '3': 4, '4': 1, '5': 1, '10': 'impedancePct'},
    {'1': 'configuration', '3': 5, '4': 1, '5': 9, '10': 'configuration'},
    {'1': 'losses_kw', '3': 6, '4': 1, '5': 1, '10': 'lossesKw'},
  ],
};

/// Descriptor for `TransformerSizing`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transformerSizingDescriptor = $convert.base64Decode(
    'ChFUcmFuc2Zvcm1lclNpemluZxInCg9yZWNvbW1lbmRlZF9rdmEYASABKAFSDnJlY29tbWVuZG'
    'VkS3ZhEioKEXByaW1hcnlfdm9sdGFnZV92GAIgASgBUg9wcmltYXJ5Vm9sdGFnZVYSLgoTc2Vj'
    'b25kYXJ5X3ZvbHRhZ2VfdhgDIAEoAVIRc2Vjb25kYXJ5Vm9sdGFnZVYSIwoNaW1wZWRhbmNlX3'
    'BjdBgEIAEoAVIMaW1wZWRhbmNlUGN0EiQKDWNvbmZpZ3VyYXRpb24YBSABKAlSDWNvbmZpZ3Vy'
    'YXRpb24SGwoJbG9zc2VzX2t3GAYgASgBUghsb3NzZXNLdw==');

@$core.Deprecated('Use reactivePowerResultDescriptor instead')
const ReactivePowerResult$json = {
  '1': 'ReactivePowerResult',
  '2': [
    {'1': 'power_factor', '3': 1, '4': 1, '5': 1, '10': 'powerFactor'},
    {'1': 'reactive_power_kvar', '3': 2, '4': 1, '5': 1, '10': 'reactivePowerKvar'},
    {'1': 'voltage_rise_pct', '3': 3, '4': 1, '5': 1, '10': 'voltageRisePct'},
    {'1': 'requires_compensation', '3': 4, '4': 1, '5': 8, '10': 'requiresCompensation'},
    {'1': 'recommended_capacitor_kvar', '3': 5, '4': 1, '5': 1, '10': 'recommendedCapacitorKvar'},
    {'1': 'ieee1547_category', '3': 6, '4': 1, '5': 9, '10': 'ieee1547Category'},
  ],
};

/// Descriptor for `ReactivePowerResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reactivePowerResultDescriptor = $convert.base64Decode(
    'ChNSZWFjdGl2ZVBvd2VyUmVzdWx0EiEKDHBvd2VyX2ZhY3RvchgBIAEoAVILcG93ZXJGYWN0b3'
    'ISLgoTcmVhY3RpdmVfcG93ZXJfa3ZhchgCIAEoAVIRcmVhY3RpdmVQb3dlckt2YXISKAoQdm9s'
    'dGFnZV9yaXNlX3BjdBgDIAEoAVIOdm9sdGFnZVJpc2VQY3QSMwoVcmVxdWlyZXNfY29tcGVuc2'
    'F0aW9uGAQgASgIUhRyZXF1aXJlc0NvbXBlbnNhdGlvbhI8ChpyZWNvbW1lbmRlZF9jYXBhY2l0'
    'b3Jfa3ZhchgFIAEoAVIYcmVjb21tZW5kZWRDYXBhY2l0b3JLdmFyEisKEWllZWUxNTQ3X2NhdG'
    'Vnb3J5GAYgASgJUhBpZWVlMTU0N0NhdGVnb3J5');

@$core.Deprecated('Use applicationFormDescriptor instead')
const ApplicationForm$json = {
  '1': 'ApplicationForm',
  '2': [
    {'1': 'form_type', '3': 1, '4': 1, '5': 9, '10': 'formType'},
    {'1': 'content_text', '3': 2, '4': 1, '5': 9, '10': 'contentText'},
    {'1': 'content_pdf', '3': 3, '4': 1, '5': 12, '10': 'contentPdf'},
    {'1': 'required_documents', '3': 4, '4': 3, '5': 9, '10': 'requiredDocuments'},
  ],
};

/// Descriptor for `ApplicationForm`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List applicationFormDescriptor = $convert.base64Decode(
    'Cg9BcHBsaWNhdGlvbkZvcm0SGwoJZm9ybV90eXBlGAEgASgJUghmb3JtVHlwZRIhCgxjb250ZW'
    '50X3RleHQYAiABKAlSC2NvbnRlbnRUZXh0Eh8KC2NvbnRlbnRfcGRmGAMgASgMUgpjb250ZW50'
    'UGRmEi0KEnJlcXVpcmVkX2RvY3VtZW50cxgEIAMoCVIRcmVxdWlyZWREb2N1bWVudHM=');

@$core.Deprecated('Use createPOIRequestDescriptor instead')
const CreatePOIRequest$json = {
  '1': 'CreatePOIRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'utility_name', '3': 2, '4': 1, '5': 9, '10': 'utilityName'},
    {'1': 'feeder_id', '3': 3, '4': 1, '5': 9, '10': 'feederId'},
    {'1': 'latitude', '3': 4, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 5, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'voltage_kv', '3': 6, '4': 1, '5': 1, '10': 'voltageKv'},
    {'1': 'available_capacity_mva', '3': 7, '4': 1, '5': 1, '10': 'availableCapacityMva'},
    {'1': 'fault_current_ka', '3': 8, '4': 1, '5': 1, '10': 'faultCurrentKa'},
    {'1': 'interconnection_type', '3': 9, '4': 1, '5': 9, '10': 'interconnectionType'},
  ],
};

/// Descriptor for `CreatePOIRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPOIRequestDescriptor = $convert.base64Decode(
    'ChBDcmVhdGVQT0lSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZBIhCgx1dG'
    'lsaXR5X25hbWUYAiABKAlSC3V0aWxpdHlOYW1lEhsKCWZlZWRlcl9pZBgDIAEoCVIIZmVlZGVy'
    'SWQSGgoIbGF0aXR1ZGUYBCABKAFSCGxhdGl0dWRlEhwKCWxvbmdpdHVkZRgFIAEoAVIJbG9uZ2'
    'l0dWRlEh0KCnZvbHRhZ2Vfa3YYBiABKAFSCXZvbHRhZ2VLdhI0ChZhdmFpbGFibGVfY2FwYWNp'
    'dHlfbXZhGAcgASgBUhRhdmFpbGFibGVDYXBhY2l0eU12YRIoChBmYXVsdF9jdXJyZW50X2thGA'
    'ggASgBUg5mYXVsdEN1cnJlbnRLYRIxChRpbnRlcmNvbm5lY3Rpb25fdHlwZRgJIAEoCVITaW50'
    'ZXJjb25uZWN0aW9uVHlwZQ==');

@$core.Deprecated('Use createPOIResponseDescriptor instead')
const CreatePOIResponse$json = {
  '1': 'CreatePOIResponse',
  '2': [
    {'1': 'poi', '3': 1, '4': 1, '5': 11, '6': '.interconnection.v1.POI', '10': 'poi'},
  ],
};

/// Descriptor for `CreatePOIResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createPOIResponseDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVQT0lSZXNwb25zZRIpCgNwb2kYASABKAsyFy5pbnRlcmNvbm5lY3Rpb24udjEuUE'
    '9JUgNwb2k=');

@$core.Deprecated('Use getPOIRequestDescriptor instead')
const GetPOIRequest$json = {
  '1': 'GetPOIRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetPOIRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPOIRequestDescriptor = $convert.base64Decode(
    'Cg1HZXRQT0lSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use getPOIResponseDescriptor instead')
const GetPOIResponse$json = {
  '1': 'GetPOIResponse',
  '2': [
    {'1': 'poi', '3': 1, '4': 1, '5': 11, '6': '.interconnection.v1.POI', '10': 'poi'},
  ],
};

/// Descriptor for `GetPOIResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPOIResponseDescriptor = $convert.base64Decode(
    'Cg5HZXRQT0lSZXNwb25zZRIpCgNwb2kYASABKAsyFy5pbnRlcmNvbm5lY3Rpb24udjEuUE9JUg'
    'Nwb2k=');

@$core.Deprecated('Use listPOIsRequestDescriptor instead')
const ListPOIsRequest$json = {
  '1': 'ListPOIsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
  ],
};

/// Descriptor for `ListPOIsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPOIsRequestDescriptor = $convert.base64Decode(
    'Cg9MaXN0UE9Jc1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElk');

@$core.Deprecated('Use listPOIsResponseDescriptor instead')
const ListPOIsResponse$json = {
  '1': 'ListPOIsResponse',
  '2': [
    {'1': 'pois', '3': 1, '4': 3, '5': 11, '6': '.interconnection.v1.POI', '10': 'pois'},
  ],
};

/// Descriptor for `ListPOIsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPOIsResponseDescriptor = $convert.base64Decode(
    'ChBMaXN0UE9Jc1Jlc3BvbnNlEisKBHBvaXMYASADKAsyFy5pbnRlcmNvbm5lY3Rpb24udjEuUE'
    '9JUgRwb2lz');

@$core.Deprecated('Use sizeTransformerRequestDescriptor instead')
const SizeTransformerRequest$json = {
  '1': 'SizeTransformerRequest',
  '2': [
    {'1': 'poi_id', '3': 1, '4': 1, '5': 9, '10': 'poiId'},
    {'1': 'plant_ac_kw', '3': 2, '4': 1, '5': 1, '10': 'plantAcKw'},
    {'1': 'plant_voltage_v', '3': 3, '4': 1, '5': 1, '10': 'plantVoltageV'},
  ],
};

/// Descriptor for `SizeTransformerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sizeTransformerRequestDescriptor = $convert.base64Decode(
    'ChZTaXplVHJhbnNmb3JtZXJSZXF1ZXN0EhUKBnBvaV9pZBgBIAEoCVIFcG9pSWQSHgoLcGxhbn'
    'RfYWNfa3cYAiABKAFSCXBsYW50QWNLdxImCg9wbGFudF92b2x0YWdlX3YYAyABKAFSDXBsYW50'
    'Vm9sdGFnZVY=');

@$core.Deprecated('Use sizeTransformerResponseDescriptor instead')
const SizeTransformerResponse$json = {
  '1': 'SizeTransformerResponse',
  '2': [
    {'1': 'sizing', '3': 1, '4': 1, '5': 11, '6': '.interconnection.v1.TransformerSizing', '10': 'sizing'},
  ],
};

/// Descriptor for `SizeTransformerResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sizeTransformerResponseDescriptor = $convert.base64Decode(
    'ChdTaXplVHJhbnNmb3JtZXJSZXNwb25zZRI9CgZzaXppbmcYASABKAsyJS5pbnRlcmNvbm5lY3'
    'Rpb24udjEuVHJhbnNmb3JtZXJTaXppbmdSBnNpemluZw==');

@$core.Deprecated('Use reactivePowerStudyRequestDescriptor instead')
const ReactivePowerStudyRequest$json = {
  '1': 'ReactivePowerStudyRequest',
  '2': [
    {'1': 'poi_id', '3': 1, '4': 1, '5': 9, '10': 'poiId'},
    {'1': 'plant_ac_kw', '3': 2, '4': 1, '5': 1, '10': 'plantAcKw'},
    {'1': 'inverter_power_factor', '3': 3, '4': 1, '5': 1, '10': 'inverterPowerFactor'},
    {'1': 'line_impedance_ohm', '3': 4, '4': 1, '5': 1, '10': 'lineImpedanceOhm'},
  ],
};

/// Descriptor for `ReactivePowerStudyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reactivePowerStudyRequestDescriptor = $convert.base64Decode(
    'ChlSZWFjdGl2ZVBvd2VyU3R1ZHlSZXF1ZXN0EhUKBnBvaV9pZBgBIAEoCVIFcG9pSWQSHgoLcG'
    'xhbnRfYWNfa3cYAiABKAFSCXBsYW50QWNLdxIyChVpbnZlcnRlcl9wb3dlcl9mYWN0b3IYAyAB'
    'KAFSE2ludmVydGVyUG93ZXJGYWN0b3ISLAoSbGluZV9pbXBlZGFuY2Vfb2htGAQgASgBUhBsaW'
    '5lSW1wZWRhbmNlT2ht');

@$core.Deprecated('Use reactivePowerStudyResponseDescriptor instead')
const ReactivePowerStudyResponse$json = {
  '1': 'ReactivePowerStudyResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.interconnection.v1.ReactivePowerResult', '10': 'result'},
  ],
};

/// Descriptor for `ReactivePowerStudyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reactivePowerStudyResponseDescriptor = $convert.base64Decode(
    'ChpSZWFjdGl2ZVBvd2VyU3R1ZHlSZXNwb25zZRI/CgZyZXN1bHQYASABKAsyJy5pbnRlcmNvbm'
    '5lY3Rpb24udjEuUmVhY3RpdmVQb3dlclJlc3VsdFIGcmVzdWx0');

@$core.Deprecated('Use generateApplicationFormRequestDescriptor instead')
const GenerateApplicationFormRequest$json = {
  '1': 'GenerateApplicationFormRequest',
  '2': [
    {'1': 'poi_id', '3': 1, '4': 1, '5': 9, '10': 'poiId'},
    {'1': 'form_type', '3': 2, '4': 1, '5': 9, '10': 'formType'},
    {'1': 'applicant_name', '3': 3, '4': 1, '5': 9, '10': 'applicantName'},
    {'1': 'applicant_address', '3': 4, '4': 1, '5': 9, '10': 'applicantAddress'},
    {'1': 'system_capacity_kw', '3': 5, '4': 1, '5': 1, '10': 'systemCapacityKw'},
  ],
};

/// Descriptor for `GenerateApplicationFormRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateApplicationFormRequestDescriptor = $convert.base64Decode(
    'Ch5HZW5lcmF0ZUFwcGxpY2F0aW9uRm9ybVJlcXVlc3QSFQoGcG9pX2lkGAEgASgJUgVwb2lJZB'
    'IbCglmb3JtX3R5cGUYAiABKAlSCGZvcm1UeXBlEiUKDmFwcGxpY2FudF9uYW1lGAMgASgJUg1h'
    'cHBsaWNhbnROYW1lEisKEWFwcGxpY2FudF9hZGRyZXNzGAQgASgJUhBhcHBsaWNhbnRBZGRyZX'
    'NzEiwKEnN5c3RlbV9jYXBhY2l0eV9rdxgFIAEoAVIQc3lzdGVtQ2FwYWNpdHlLdw==');

@$core.Deprecated('Use generateApplicationFormResponseDescriptor instead')
const GenerateApplicationFormResponse$json = {
  '1': 'GenerateApplicationFormResponse',
  '2': [
    {'1': 'form', '3': 1, '4': 1, '5': 11, '6': '.interconnection.v1.ApplicationForm', '10': 'form'},
  ],
};

/// Descriptor for `GenerateApplicationFormResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateApplicationFormResponseDescriptor = $convert.base64Decode(
    'Ch9HZW5lcmF0ZUFwcGxpY2F0aW9uRm9ybVJlc3BvbnNlEjcKBGZvcm0YASABKAsyIy5pbnRlcm'
    'Nvbm5lY3Rpb24udjEuQXBwbGljYXRpb25Gb3JtUgRmb3Jt');

@$core.Deprecated('Use deletePOIRequestDescriptor instead')
const DeletePOIRequest$json = {
  '1': 'DeletePOIRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeletePOIRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePOIRequestDescriptor = $convert.base64Decode(
    'ChBEZWxldGVQT0lSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');

@$core.Deprecated('Use deletePOIResponseDescriptor instead')
const DeletePOIResponse$json = {
  '1': 'DeletePOIResponse',
};

/// Descriptor for `DeletePOIResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deletePOIResponseDescriptor = $convert.base64Decode(
    'ChFEZWxldGVQT0lSZXNwb25zZQ==');

const $core.Map<$core.String, $core.dynamic> InterconnectionServiceBase$json = {
  '1': 'InterconnectionService',
  '2': [
    {'1': 'CreatePOI', '2': '.interconnection.v1.CreatePOIRequest', '3': '.interconnection.v1.CreatePOIResponse'},
    {'1': 'GetPOI', '2': '.interconnection.v1.GetPOIRequest', '3': '.interconnection.v1.GetPOIResponse'},
    {'1': 'ListPOIs', '2': '.interconnection.v1.ListPOIsRequest', '3': '.interconnection.v1.ListPOIsResponse'},
    {'1': 'SizeTransformer', '2': '.interconnection.v1.SizeTransformerRequest', '3': '.interconnection.v1.SizeTransformerResponse'},
    {'1': 'ReactivePowerStudy', '2': '.interconnection.v1.ReactivePowerStudyRequest', '3': '.interconnection.v1.ReactivePowerStudyResponse'},
    {'1': 'GenerateApplicationForm', '2': '.interconnection.v1.GenerateApplicationFormRequest', '3': '.interconnection.v1.GenerateApplicationFormResponse'},
    {'1': 'DeletePOI', '2': '.interconnection.v1.DeletePOIRequest', '3': '.interconnection.v1.DeletePOIResponse'},
  ],
};

@$core.Deprecated('Use interconnectionServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> InterconnectionServiceBase$messageJson = {
  '.interconnection.v1.CreatePOIRequest': CreatePOIRequest$json,
  '.interconnection.v1.CreatePOIResponse': CreatePOIResponse$json,
  '.interconnection.v1.POI': POI$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.interconnection.v1.GetPOIRequest': GetPOIRequest$json,
  '.interconnection.v1.GetPOIResponse': GetPOIResponse$json,
  '.interconnection.v1.ListPOIsRequest': ListPOIsRequest$json,
  '.interconnection.v1.ListPOIsResponse': ListPOIsResponse$json,
  '.interconnection.v1.SizeTransformerRequest': SizeTransformerRequest$json,
  '.interconnection.v1.SizeTransformerResponse': SizeTransformerResponse$json,
  '.interconnection.v1.TransformerSizing': TransformerSizing$json,
  '.interconnection.v1.ReactivePowerStudyRequest': ReactivePowerStudyRequest$json,
  '.interconnection.v1.ReactivePowerStudyResponse': ReactivePowerStudyResponse$json,
  '.interconnection.v1.ReactivePowerResult': ReactivePowerResult$json,
  '.interconnection.v1.GenerateApplicationFormRequest': GenerateApplicationFormRequest$json,
  '.interconnection.v1.GenerateApplicationFormResponse': GenerateApplicationFormResponse$json,
  '.interconnection.v1.ApplicationForm': ApplicationForm$json,
  '.interconnection.v1.DeletePOIRequest': DeletePOIRequest$json,
  '.interconnection.v1.DeletePOIResponse': DeletePOIResponse$json,
};

/// Descriptor for `InterconnectionService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List interconnectionServiceDescriptor = $convert.base64Decode(
    'ChZJbnRlcmNvbm5lY3Rpb25TZXJ2aWNlElgKCUNyZWF0ZVBPSRIkLmludGVyY29ubmVjdGlvbi'
    '52MS5DcmVhdGVQT0lSZXF1ZXN0GiUuaW50ZXJjb25uZWN0aW9uLnYxLkNyZWF0ZVBPSVJlc3Bv'
    'bnNlEk8KBkdldFBPSRIhLmludGVyY29ubmVjdGlvbi52MS5HZXRQT0lSZXF1ZXN0GiIuaW50ZX'
    'Jjb25uZWN0aW9uLnYxLkdldFBPSVJlc3BvbnNlElUKCExpc3RQT0lzEiMuaW50ZXJjb25uZWN0'
    'aW9uLnYxLkxpc3RQT0lzUmVxdWVzdBokLmludGVyY29ubmVjdGlvbi52MS5MaXN0UE9Jc1Jlc3'
    'BvbnNlEmoKD1NpemVUcmFuc2Zvcm1lchIqLmludGVyY29ubmVjdGlvbi52MS5TaXplVHJhbnNm'
    'b3JtZXJSZXF1ZXN0GisuaW50ZXJjb25uZWN0aW9uLnYxLlNpemVUcmFuc2Zvcm1lclJlc3Bvbn'
    'NlEnMKElJlYWN0aXZlUG93ZXJTdHVkeRItLmludGVyY29ubmVjdGlvbi52MS5SZWFjdGl2ZVBv'
    'd2VyU3R1ZHlSZXF1ZXN0Gi4uaW50ZXJjb25uZWN0aW9uLnYxLlJlYWN0aXZlUG93ZXJTdHVkeV'
    'Jlc3BvbnNlEoIBChdHZW5lcmF0ZUFwcGxpY2F0aW9uRm9ybRIyLmludGVyY29ubmVjdGlvbi52'
    'MS5HZW5lcmF0ZUFwcGxpY2F0aW9uRm9ybVJlcXVlc3QaMy5pbnRlcmNvbm5lY3Rpb24udjEuR2'
    'VuZXJhdGVBcHBsaWNhdGlvbkZvcm1SZXNwb25zZRJYCglEZWxldGVQT0kSJC5pbnRlcmNvbm5l'
    'Y3Rpb24udjEuRGVsZXRlUE9JUmVxdWVzdBolLmludGVyY29ubmVjdGlvbi52MS5EZWxldGVQT0'
    'lSZXNwb25zZQ==');

