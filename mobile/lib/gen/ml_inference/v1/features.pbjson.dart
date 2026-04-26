//
//  Generated code. Do not modify.
//  source: ml_inference/v1/features.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use featureDataTypeDescriptor instead')
const FeatureDataType$json = {
  '1': 'FeatureDataType',
  '2': [
    {'1': 'FEATURE_DATA_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'FEATURE_DATA_TYPE_FLOAT64', '2': 1},
    {'1': 'FEATURE_DATA_TYPE_INT64', '2': 2},
    {'1': 'FEATURE_DATA_TYPE_BOOL', '2': 3},
    {'1': 'FEATURE_DATA_TYPE_STRING', '2': 4},
  ],
};

/// Descriptor for `FeatureDataType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List featureDataTypeDescriptor = $convert.base64Decode(
    'Cg9GZWF0dXJlRGF0YVR5cGUSIQodRkVBVFVSRV9EQVRBX1RZUEVfVU5TUEVDSUZJRUQQABIdCh'
    'lGRUFUVVJFX0RBVEFfVFlQRV9GTE9BVDY0EAESGwoXRkVBVFVSRV9EQVRBX1RZUEVfSU5UNjQQ'
    'AhIaChZGRUFUVVJFX0RBVEFfVFlQRV9CT09MEAMSHAoYRkVBVFVSRV9EQVRBX1RZUEVfU1RSSU'
    '5HEAQ=');

@$core.Deprecated('Use featureSpecDescriptor instead')
const FeatureSpec$json = {
  '1': 'FeatureSpec',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'data_type', '3': 2, '4': 1, '5': 14, '6': '.ml_inference.v1.FeatureDataType', '10': 'dataType'},
    {'1': 'required', '3': 3, '4': 1, '5': 8, '10': 'required'},
    {'1': 'unit', '3': 4, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'expected_range', '3': 5, '4': 1, '5': 11, '6': '.common.v1.NumericRange', '10': 'expectedRange'},
  ],
};

/// Descriptor for `FeatureSpec`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureSpecDescriptor = $convert.base64Decode(
    'CgtGZWF0dXJlU3BlYxISCgRuYW1lGAEgASgJUgRuYW1lEj0KCWRhdGFfdHlwZRgCIAEoDjIgLm'
    '1sX2luZmVyZW5jZS52MS5GZWF0dXJlRGF0YVR5cGVSCGRhdGFUeXBlEhoKCHJlcXVpcmVkGAMg'
    'ASgIUghyZXF1aXJlZBISCgR1bml0GAQgASgJUgR1bml0Ej4KDmV4cGVjdGVkX3JhbmdlGAUgAS'
    'gLMhcuY29tbW9uLnYxLk51bWVyaWNSYW5nZVINZXhwZWN0ZWRSYW5nZQ==');

@$core.Deprecated('Use featureSchemaDescriptor instead')
const FeatureSchema$json = {
  '1': 'FeatureSchema',
  '2': [
    {'1': 'schema_id', '3': 1, '4': 1, '5': 9, '10': 'schemaId'},
    {'1': 'schema_hash', '3': 2, '4': 1, '5': 9, '10': 'schemaHash'},
    {'1': 'task_type', '3': 3, '4': 1, '5': 9, '10': 'taskType'},
    {'1': 'features', '3': 4, '4': 3, '5': 11, '6': '.ml_inference.v1.FeatureSpec', '10': 'features'},
    {'1': 'created_at', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'contract', '3': 6, '4': 1, '5': 11, '6': '.common.v1.ContractMetadata', '10': 'contract'},
  ],
};

/// Descriptor for `FeatureSchema`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureSchemaDescriptor = $convert.base64Decode(
    'Cg1GZWF0dXJlU2NoZW1hEhsKCXNjaGVtYV9pZBgBIAEoCVIIc2NoZW1hSWQSHwoLc2NoZW1hX2'
    'hhc2gYAiABKAlSCnNjaGVtYUhhc2gSGwoJdGFza190eXBlGAMgASgJUgh0YXNrVHlwZRI4Cghm'
    'ZWF0dXJlcxgEIAMoCzIcLm1sX2luZmVyZW5jZS52MS5GZWF0dXJlU3BlY1IIZmVhdHVyZXMSOQ'
    'oKY3JlYXRlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRB'
    'dBI3Cghjb250cmFjdBgGIAEoCzIbLmNvbW1vbi52MS5Db250cmFjdE1ldGFkYXRhUghjb250cm'
    'FjdA==');

@$core.Deprecated('Use featureValueDescriptor instead')
const FeatureValue$json = {
  '1': 'FeatureValue',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'double_value', '3': 2, '4': 1, '5': 1, '9': 0, '10': 'doubleValue'},
    {'1': 'int64_value', '3': 3, '4': 1, '5': 3, '9': 0, '10': 'int64Value'},
    {'1': 'bool_value', '3': 4, '4': 1, '5': 8, '9': 0, '10': 'boolValue'},
    {'1': 'string_value', '3': 5, '4': 1, '5': 9, '9': 0, '10': 'stringValue'},
  ],
  '8': [
    {'1': 'value'},
  ],
};

/// Descriptor for `FeatureValue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureValueDescriptor = $convert.base64Decode(
    'CgxGZWF0dXJlVmFsdWUSEgoEbmFtZRgBIAEoCVIEbmFtZRIjCgxkb3VibGVfdmFsdWUYAiABKA'
    'FIAFILZG91YmxlVmFsdWUSIQoLaW50NjRfdmFsdWUYAyABKANIAFIKaW50NjRWYWx1ZRIfCgpi'
    'b29sX3ZhbHVlGAQgASgISABSCWJvb2xWYWx1ZRIjCgxzdHJpbmdfdmFsdWUYBSABKAlIAFILc3'
    'RyaW5nVmFsdWVCBwoFdmFsdWU=');

@$core.Deprecated('Use featurePayloadDescriptor instead')
const FeaturePayload$json = {
  '1': 'FeaturePayload',
  '2': [
    {'1': 'payload_id', '3': 1, '4': 1, '5': 9, '10': 'payloadId'},
    {'1': 'task_type', '3': 2, '4': 1, '5': 9, '10': 'taskType'},
    {'1': 'schema', '3': 3, '4': 1, '5': 11, '6': '.ml_inference.v1.FeatureSchema', '10': 'schema'},
    {'1': 'values', '3': 4, '4': 3, '5': 11, '6': '.ml_inference.v1.FeatureValue', '10': 'values'},
    {'1': 'observed_at', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'observedAt'},
    {'1': 'site_id', '3': 6, '4': 1, '5': 9, '10': 'siteId'},
  ],
};

/// Descriptor for `FeaturePayload`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featurePayloadDescriptor = $convert.base64Decode(
    'Cg5GZWF0dXJlUGF5bG9hZBIdCgpwYXlsb2FkX2lkGAEgASgJUglwYXlsb2FkSWQSGwoJdGFza1'
    '90eXBlGAIgASgJUgh0YXNrVHlwZRI2CgZzY2hlbWEYAyABKAsyHi5tbF9pbmZlcmVuY2UudjEu'
    'RmVhdHVyZVNjaGVtYVIGc2NoZW1hEjUKBnZhbHVlcxgEIAMoCzIdLm1sX2luZmVyZW5jZS52MS'
    '5GZWF0dXJlVmFsdWVSBnZhbHVlcxI7CgtvYnNlcnZlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSCm9ic2VydmVkQXQSFwoHc2l0ZV9pZBgGIAEoCVIGc2l0ZUlk');

@$core.Deprecated('Use labeledFeatureSampleDescriptor instead')
const LabeledFeatureSample$json = {
  '1': 'LabeledFeatureSample',
  '2': [
    {'1': 'sample_id', '3': 1, '4': 1, '5': 9, '10': 'sampleId'},
    {'1': 'payload', '3': 2, '4': 1, '5': 11, '6': '.ml_inference.v1.FeaturePayload', '10': 'payload'},
    {'1': 'label', '3': 3, '4': 1, '5': 1, '10': 'label'},
    {'1': 'label_source', '3': 4, '4': 1, '5': 9, '10': 'labelSource'},
    {'1': 'labeled_at', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'labeledAt'},
  ],
};

/// Descriptor for `LabeledFeatureSample`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List labeledFeatureSampleDescriptor = $convert.base64Decode(
    'ChRMYWJlbGVkRmVhdHVyZVNhbXBsZRIbCglzYW1wbGVfaWQYASABKAlSCHNhbXBsZUlkEjkKB3'
    'BheWxvYWQYAiABKAsyHy5tbF9pbmZlcmVuY2UudjEuRmVhdHVyZVBheWxvYWRSB3BheWxvYWQS'
    'FAoFbGFiZWwYAyABKAFSBWxhYmVsEiEKDGxhYmVsX3NvdXJjZRgEIAEoCVILbGFiZWxTb3VyY2'
    'USOQoKbGFiZWxlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWxhYmVs'
    'ZWRBdA==');

