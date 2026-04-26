//
//  Generated code. Do not modify.
//  source: protection/v1/protection.proto
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

@$core.Deprecated('Use neutralEarthingDescriptor instead')
const NeutralEarthing$json = {
  '1': 'NeutralEarthing',
  '2': [
    {'1': 'NEUTRAL_EARTHING_UNSPECIFIED', '2': 0},
    {'1': 'NEUTRAL_EARTHING_SOLID', '2': 1},
    {'1': 'NEUTRAL_EARTHING_RESISTANCE', '2': 2},
    {'1': 'NEUTRAL_EARTHING_PETERSEN_COIL', '2': 3},
    {'1': 'NEUTRAL_EARTHING_ISOLATED', '2': 4},
  ],
};

/// Descriptor for `NeutralEarthing`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List neutralEarthingDescriptor = $convert.base64Decode(
    'Cg9OZXV0cmFsRWFydGhpbmcSIAocTkVVVFJBTF9FQVJUSElOR19VTlNQRUNJRklFRBAAEhoKFk'
    '5FVVRSQUxfRUFSVEhJTkdfU09MSUQQARIfChtORVVUUkFMX0VBUlRISU5HX1JFU0lTVEFOQ0UQ'
    'AhIiCh5ORVVUUkFMX0VBUlRISU5HX1BFVEVSU0VOX0NPSUwQAxIdChlORVVUUkFMX0VBUlRISU'
    '5HX0lTT0xBVEVEEAQ=');

@$core.Deprecated('Use relayCharacteristicDescriptor instead')
const RelayCharacteristic$json = {
  '1': 'RelayCharacteristic',
  '2': [
    {'1': 'RELAY_CHARACTERISTIC_UNSPECIFIED', '2': 0},
    {'1': 'RELAY_CHARACTERISTIC_STANDARD_INVERSE', '2': 1},
    {'1': 'RELAY_CHARACTERISTIC_VERY_INVERSE', '2': 2},
    {'1': 'RELAY_CHARACTERISTIC_EXTREMELY_INVERSE', '2': 3},
    {'1': 'RELAY_CHARACTERISTIC_DEFINITE_TIME', '2': 4},
  ],
};

/// Descriptor for `RelayCharacteristic`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List relayCharacteristicDescriptor = $convert.base64Decode(
    'ChNSZWxheUNoYXJhY3RlcmlzdGljEiQKIFJFTEFZX0NIQVJBQ1RFUklTVElDX1VOU1BFQ0lGSU'
    'VEEAASKQolUkVMQVlfQ0hBUkFDVEVSSVNUSUNfU1RBTkRBUkRfSU5WRVJTRRABEiUKIVJFTEFZ'
    'X0NIQVJBQ1RFUklTVElDX1ZFUllfSU5WRVJTRRACEioKJlJFTEFZX0NIQVJBQ1RFUklTVElDX0'
    'VYVFJFTUVMWV9JTlZFUlNFEAMSJgoiUkVMQVlfQ0hBUkFDVEVSSVNUSUNfREVGSU5JVEVfVElN'
    'RRAE');

@$core.Deprecated('Use protectionStudyDescriptor instead')
const ProtectionStudy$json = {
  '1': 'ProtectionStudy',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'system_voltage_kv', '3': 4, '4': 1, '5': 1, '10': 'systemVoltageKv'},
    {'1': 'source_impedance_pu', '3': 5, '4': 1, '5': 1, '10': 'sourceImpedancePu'},
    {'1': 'mva_base', '3': 6, '4': 1, '5': 1, '10': 'mvaBase'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
  ],
};

/// Descriptor for `ProtectionStudy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List protectionStudyDescriptor = $convert.base64Decode(
    'Cg9Qcm90ZWN0aW9uU3R1ZHkSDgoCaWQYASABKAlSAmlkEh0KCnByb2plY3RfaWQYAiABKAlSCX'
    'Byb2plY3RJZBISCgRuYW1lGAMgASgJUgRuYW1lEioKEXN5c3RlbV92b2x0YWdlX2t2GAQgASgB'
    'Ug9zeXN0ZW1Wb2x0YWdlS3YSLgoTc291cmNlX2ltcGVkYW5jZV9wdRgFIAEoAVIRc291cmNlSW'
    '1wZWRhbmNlUHUSGQoIbXZhX2Jhc2UYBiABKAFSB212YUJhc2USOQoKY3JlYXRlZF9hdBgHIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdA==');

@$core.Deprecated('Use computeShortCircuitRequestDescriptor instead')
const ComputeShortCircuitRequest$json = {
  '1': 'ComputeShortCircuitRequest',
  '2': [
    {'1': 'study_id', '3': 1, '4': 1, '5': 9, '10': 'studyId'},
    {'1': 'voltage_kv', '3': 2, '4': 1, '5': 1, '10': 'voltageKv'},
    {'1': 'source_impedance_ohm', '3': 3, '4': 1, '5': 1, '10': 'sourceImpedanceOhm'},
    {'1': 'cable_resistance_ohm', '3': 4, '4': 1, '5': 1, '10': 'cableResistanceOhm'},
    {'1': 'cable_reactance_ohm', '3': 5, '4': 1, '5': 1, '10': 'cableReactanceOhm'},
    {'1': 'zero_seq_impedance_ohm', '3': 6, '4': 1, '5': 1, '10': 'zeroSeqImpedanceOhm'},
    {'1': 'include_single_line_to_ground', '3': 7, '4': 1, '5': 8, '10': 'includeSingleLineToGround'},
  ],
};

/// Descriptor for `ComputeShortCircuitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeShortCircuitRequestDescriptor = $convert.base64Decode(
    'ChpDb21wdXRlU2hvcnRDaXJjdWl0UmVxdWVzdBIZCghzdHVkeV9pZBgBIAEoCVIHc3R1ZHlJZB'
    'IdCgp2b2x0YWdlX2t2GAIgASgBUgl2b2x0YWdlS3YSMAoUc291cmNlX2ltcGVkYW5jZV9vaG0Y'
    'AyABKAFSEnNvdXJjZUltcGVkYW5jZU9obRIwChRjYWJsZV9yZXNpc3RhbmNlX29obRgEIAEoAV'
    'ISY2FibGVSZXNpc3RhbmNlT2htEi4KE2NhYmxlX3JlYWN0YW5jZV9vaG0YBSABKAFSEWNhYmxl'
    'UmVhY3RhbmNlT2htEjMKFnplcm9fc2VxX2ltcGVkYW5jZV9vaG0YBiABKAFSE3plcm9TZXFJbX'
    'BlZGFuY2VPaG0SQAodaW5jbHVkZV9zaW5nbGVfbGluZV90b19ncm91bmQYByABKAhSGWluY2x1'
    'ZGVTaW5nbGVMaW5lVG9Hcm91bmQ=');

@$core.Deprecated('Use computeShortCircuitResponseDescriptor instead')
const ComputeShortCircuitResponse$json = {
  '1': 'ComputeShortCircuitResponse',
  '2': [
    {'1': 'study_id', '3': 1, '4': 1, '5': 9, '10': 'studyId'},
    {'1': 'v_ln_kv', '3': 2, '4': 1, '5': 1, '10': 'vLnKv'},
    {'1': 'z_total_pos_seq_ohm', '3': 3, '4': 1, '5': 1, '10': 'zTotalPosSeqOhm'},
    {'1': 'i_fault_3ph_ka', '3': 4, '4': 1, '5': 1, '10': 'iFault3phKa'},
    {'1': 'slg_computed', '3': 5, '4': 1, '5': 8, '10': 'slgComputed'},
    {'1': 'z_total_zero_seq_ohm', '3': 6, '4': 1, '5': 1, '10': 'zTotalZeroSeqOhm'},
    {'1': 'i_fault_slg_ka', '3': 7, '4': 1, '5': 1, '10': 'iFaultSlgKa'},
    {'1': 'governing_fault_ka', '3': 8, '4': 1, '5': 1, '10': 'governingFaultKa'},
    {'1': 'equation', '3': 9, '4': 1, '5': 9, '10': 'equation'},
  ],
};

/// Descriptor for `ComputeShortCircuitResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeShortCircuitResponseDescriptor = $convert.base64Decode(
    'ChtDb21wdXRlU2hvcnRDaXJjdWl0UmVzcG9uc2USGQoIc3R1ZHlfaWQYASABKAlSB3N0dWR5SW'
    'QSFgoHdl9sbl9rdhgCIAEoAVIFdkxuS3YSLAoTel90b3RhbF9wb3Nfc2VxX29obRgDIAEoAVIP'
    'elRvdGFsUG9zU2VxT2htEiMKDmlfZmF1bHRfM3BoX2thGAQgASgBUgtpRmF1bHQzcGhLYRIhCg'
    'xzbGdfY29tcHV0ZWQYBSABKAhSC3NsZ0NvbXB1dGVkEi4KFHpfdG90YWxfemVyb19zZXFfb2ht'
    'GAYgASgBUhB6VG90YWxaZXJvU2VxT2htEiMKDmlfZmF1bHRfc2xnX2thGAcgASgBUgtpRmF1bH'
    'RTbGdLYRIsChJnb3Zlcm5pbmdfZmF1bHRfa2EYCCABKAFSEGdvdmVybmluZ0ZhdWx0S2ESGgoI'
    'ZXF1YXRpb24YCSABKAlSCGVxdWF0aW9u');

@$core.Deprecated('Use computeEarthFaultRequestDescriptor instead')
const ComputeEarthFaultRequest$json = {
  '1': 'ComputeEarthFaultRequest',
  '2': [
    {'1': 'study_id', '3': 1, '4': 1, '5': 9, '10': 'studyId'},
    {'1': 'voltage_kv', '3': 2, '4': 1, '5': 1, '10': 'voltageKv'},
    {'1': 'earthing_method', '3': 3, '4': 1, '5': 14, '6': '.protection.v1.NeutralEarthing', '10': 'earthingMethod'},
    {'1': 'ngr_resistance_ohm', '3': 4, '4': 1, '5': 1, '10': 'ngrResistanceOhm'},
    {'1': 'cable_resistance_ohm', '3': 5, '4': 1, '5': 1, '10': 'cableResistanceOhm'},
  ],
};

/// Descriptor for `ComputeEarthFaultRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeEarthFaultRequestDescriptor = $convert.base64Decode(
    'ChhDb21wdXRlRWFydGhGYXVsdFJlcXVlc3QSGQoIc3R1ZHlfaWQYASABKAlSB3N0dWR5SWQSHQ'
    'oKdm9sdGFnZV9rdhgCIAEoAVIJdm9sdGFnZUt2EkcKD2VhcnRoaW5nX21ldGhvZBgDIAEoDjIe'
    'LnByb3RlY3Rpb24udjEuTmV1dHJhbEVhcnRoaW5nUg5lYXJ0aGluZ01ldGhvZBIsChJuZ3Jfcm'
    'VzaXN0YW5jZV9vaG0YBCABKAFSEG5nclJlc2lzdGFuY2VPaG0SMAoUY2FibGVfcmVzaXN0YW5j'
    'ZV9vaG0YBSABKAFSEmNhYmxlUmVzaXN0YW5jZU9obQ==');

@$core.Deprecated('Use computeEarthFaultResponseDescriptor instead')
const ComputeEarthFaultResponse$json = {
  '1': 'ComputeEarthFaultResponse',
  '2': [
    {'1': 'study_id', '3': 1, '4': 1, '5': 9, '10': 'studyId'},
    {'1': 'earthing_method', '3': 2, '4': 1, '5': 14, '6': '.protection.v1.NeutralEarthing', '10': 'earthingMethod'},
    {'1': 'earth_fault_current_ka', '3': 3, '4': 1, '5': 1, '10': 'earthFaultCurrentKa'},
    {'1': 'touch_voltage_v', '3': 4, '4': 1, '5': 1, '10': 'touchVoltageV'},
    {'1': 'equation', '3': 5, '4': 1, '5': 9, '10': 'equation'},
  ],
};

/// Descriptor for `ComputeEarthFaultResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeEarthFaultResponseDescriptor = $convert.base64Decode(
    'ChlDb21wdXRlRWFydGhGYXVsdFJlc3BvbnNlEhkKCHN0dWR5X2lkGAEgASgJUgdzdHVkeUlkEk'
    'cKD2VhcnRoaW5nX21ldGhvZBgCIAEoDjIeLnByb3RlY3Rpb24udjEuTmV1dHJhbEVhcnRoaW5n'
    'Ug5lYXJ0aGluZ01ldGhvZBIzChZlYXJ0aF9mYXVsdF9jdXJyZW50X2thGAMgASgBUhNlYXJ0aE'
    'ZhdWx0Q3VycmVudEthEiYKD3RvdWNoX3ZvbHRhZ2VfdhgEIAEoAVINdG91Y2hWb2x0YWdlVhIa'
    'CghlcXVhdGlvbhgFIAEoCVIIZXF1YXRpb24=');

@$core.Deprecated('Use selectRelayRequestDescriptor instead')
const SelectRelayRequest$json = {
  '1': 'SelectRelayRequest',
  '2': [
    {'1': 'study_id', '3': 1, '4': 1, '5': 9, '10': 'studyId'},
    {'1': 'fault_current_ka', '3': 2, '4': 1, '5': 1, '10': 'faultCurrentKa'},
    {'1': 'load_current_a', '3': 3, '4': 1, '5': 1, '10': 'loadCurrentA'},
    {'1': 'preferred_characteristic', '3': 4, '4': 1, '5': 14, '6': '.protection.v1.RelayCharacteristic', '10': 'preferredCharacteristic'},
  ],
};

/// Descriptor for `SelectRelayRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectRelayRequestDescriptor = $convert.base64Decode(
    'ChJTZWxlY3RSZWxheVJlcXVlc3QSGQoIc3R1ZHlfaWQYASABKAlSB3N0dWR5SWQSKAoQZmF1bH'
    'RfY3VycmVudF9rYRgCIAEoAVIOZmF1bHRDdXJyZW50S2ESJAoObG9hZF9jdXJyZW50X2EYAyAB'
    'KAFSDGxvYWRDdXJyZW50QRJdChhwcmVmZXJyZWRfY2hhcmFjdGVyaXN0aWMYBCABKA4yIi5wcm'
    '90ZWN0aW9uLnYxLlJlbGF5Q2hhcmFjdGVyaXN0aWNSF3ByZWZlcnJlZENoYXJhY3RlcmlzdGlj');

@$core.Deprecated('Use relaySelectionDescriptor instead')
const RelaySelection$json = {
  '1': 'RelaySelection',
  '2': [
    {'1': 'relay_id', '3': 1, '4': 1, '5': 9, '10': 'relayId'},
    {'1': 'make_model', '3': 2, '4': 1, '5': 9, '10': 'makeModel'},
    {'1': 'characteristic', '3': 3, '4': 1, '5': 14, '6': '.protection.v1.RelayCharacteristic', '10': 'characteristic'},
    {'1': 'pickup_current_a', '3': 4, '4': 1, '5': 1, '10': 'pickupCurrentA'},
    {'1': 'time_dial_setting', '3': 5, '4': 1, '5': 1, '10': 'timeDialSetting'},
    {'1': 'rationale', '3': 6, '4': 1, '5': 9, '10': 'rationale'},
  ],
};

/// Descriptor for `RelaySelection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List relaySelectionDescriptor = $convert.base64Decode(
    'Cg5SZWxheVNlbGVjdGlvbhIZCghyZWxheV9pZBgBIAEoCVIHcmVsYXlJZBIdCgptYWtlX21vZG'
    'VsGAIgASgJUgltYWtlTW9kZWwSSgoOY2hhcmFjdGVyaXN0aWMYAyABKA4yIi5wcm90ZWN0aW9u'
    'LnYxLlJlbGF5Q2hhcmFjdGVyaXN0aWNSDmNoYXJhY3RlcmlzdGljEigKEHBpY2t1cF9jdXJyZW'
    '50X2EYBCABKAFSDnBpY2t1cEN1cnJlbnRBEioKEXRpbWVfZGlhbF9zZXR0aW5nGAUgASgBUg90'
    'aW1lRGlhbFNldHRpbmcSHAoJcmF0aW9uYWxlGAYgASgJUglyYXRpb25hbGU=');

@$core.Deprecated('Use selectRelayResponseDescriptor instead')
const SelectRelayResponse$json = {
  '1': 'SelectRelayResponse',
  '2': [
    {'1': 'study_id', '3': 1, '4': 1, '5': 9, '10': 'studyId'},
    {'1': 'relay', '3': 2, '4': 1, '5': 11, '6': '.protection.v1.RelaySelection', '10': 'relay'},
  ],
};

/// Descriptor for `SelectRelayResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List selectRelayResponseDescriptor = $convert.base64Decode(
    'ChNTZWxlY3RSZWxheVJlc3BvbnNlEhkKCHN0dWR5X2lkGAEgASgJUgdzdHVkeUlkEjMKBXJlbG'
    'F5GAIgASgLMh0ucHJvdGVjdGlvbi52MS5SZWxheVNlbGVjdGlvblIFcmVsYXk=');

@$core.Deprecated('Use computeRelaySettingsRequestDescriptor instead')
const ComputeRelaySettingsRequest$json = {
  '1': 'ComputeRelaySettingsRequest',
  '2': [
    {'1': 'study_id', '3': 1, '4': 1, '5': 9, '10': 'studyId'},
    {'1': 'characteristic', '3': 2, '4': 1, '5': 14, '6': '.protection.v1.RelayCharacteristic', '10': 'characteristic'},
    {'1': 'pickup_current_a', '3': 3, '4': 1, '5': 1, '10': 'pickupCurrentA'},
    {'1': 'time_dial_setting', '3': 4, '4': 1, '5': 1, '10': 'timeDialSetting'},
    {'1': 'fault_current_a', '3': 5, '4': 1, '5': 1, '10': 'faultCurrentA'},
  ],
};

/// Descriptor for `ComputeRelaySettingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeRelaySettingsRequestDescriptor = $convert.base64Decode(
    'ChtDb21wdXRlUmVsYXlTZXR0aW5nc1JlcXVlc3QSGQoIc3R1ZHlfaWQYASABKAlSB3N0dWR5SW'
    'QSSgoOY2hhcmFjdGVyaXN0aWMYAiABKA4yIi5wcm90ZWN0aW9uLnYxLlJlbGF5Q2hhcmFjdGVy'
    'aXN0aWNSDmNoYXJhY3RlcmlzdGljEigKEHBpY2t1cF9jdXJyZW50X2EYAyABKAFSDnBpY2t1cE'
    'N1cnJlbnRBEioKEXRpbWVfZGlhbF9zZXR0aW5nGAQgASgBUg90aW1lRGlhbFNldHRpbmcSJgoP'
    'ZmF1bHRfY3VycmVudF9hGAUgASgBUg1mYXVsdEN1cnJlbnRB');

@$core.Deprecated('Use computeRelaySettingsResponseDescriptor instead')
const ComputeRelaySettingsResponse$json = {
  '1': 'ComputeRelaySettingsResponse',
  '2': [
    {'1': 'study_id', '3': 1, '4': 1, '5': 9, '10': 'studyId'},
    {'1': 'multiplier', '3': 2, '4': 1, '5': 1, '10': 'multiplier'},
    {'1': 'operating_time_s', '3': 3, '4': 1, '5': 1, '10': 'operatingTimeS'},
    {'1': 'characteristic', '3': 4, '4': 1, '5': 14, '6': '.protection.v1.RelayCharacteristic', '10': 'characteristic'},
    {'1': 'equation', '3': 5, '4': 1, '5': 9, '10': 'equation'},
  ],
};

/// Descriptor for `ComputeRelaySettingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computeRelaySettingsResponseDescriptor = $convert.base64Decode(
    'ChxDb21wdXRlUmVsYXlTZXR0aW5nc1Jlc3BvbnNlEhkKCHN0dWR5X2lkGAEgASgJUgdzdHVkeU'
    'lkEh4KCm11bHRpcGxpZXIYAiABKAFSCm11bHRpcGxpZXISKAoQb3BlcmF0aW5nX3RpbWVfcxgD'
    'IAEoAVIOb3BlcmF0aW5nVGltZVMSSgoOY2hhcmFjdGVyaXN0aWMYBCABKA4yIi5wcm90ZWN0aW'
    '9uLnYxLlJlbGF5Q2hhcmFjdGVyaXN0aWNSDmNoYXJhY3RlcmlzdGljEhoKCGVxdWF0aW9uGAUg'
    'ASgJUghlcXVhdGlvbg==');

@$core.Deprecated('Use coordinationPairDescriptor instead')
const CoordinationPair$json = {
  '1': 'CoordinationPair',
  '2': [
    {'1': 'upstream_relay_id', '3': 1, '4': 1, '5': 9, '10': 'upstreamRelayId'},
    {'1': 'downstream_relay_id', '3': 2, '4': 1, '5': 9, '10': 'downstreamRelayId'},
    {'1': 'upstream_time_s', '3': 3, '4': 1, '5': 1, '10': 'upstreamTimeS'},
    {'1': 'downstream_time_s', '3': 4, '4': 1, '5': 1, '10': 'downstreamTimeS'},
    {'1': 'margin_s', '3': 5, '4': 1, '5': 1, '10': 'marginS'},
  ],
};

/// Descriptor for `CoordinationPair`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coordinationPairDescriptor = $convert.base64Decode(
    'ChBDb29yZGluYXRpb25QYWlyEioKEXVwc3RyZWFtX3JlbGF5X2lkGAEgASgJUg91cHN0cmVhbV'
    'JlbGF5SWQSLgoTZG93bnN0cmVhbV9yZWxheV9pZBgCIAEoCVIRZG93bnN0cmVhbVJlbGF5SWQS'
    'JgoPdXBzdHJlYW1fdGltZV9zGAMgASgBUg11cHN0cmVhbVRpbWVTEioKEWRvd25zdHJlYW1fdG'
    'ltZV9zGAQgASgBUg9kb3duc3RyZWFtVGltZVMSGQoIbWFyZ2luX3MYBSABKAFSB21hcmdpblM=');

@$core.Deprecated('Use validateCoordinationRequestDescriptor instead')
const ValidateCoordinationRequest$json = {
  '1': 'ValidateCoordinationRequest',
  '2': [
    {'1': 'study_id', '3': 1, '4': 1, '5': 9, '10': 'studyId'},
    {'1': 'pairs', '3': 2, '4': 3, '5': 11, '6': '.protection.v1.CoordinationPair', '10': 'pairs'},
    {'1': 'minimum_margin_s', '3': 3, '4': 1, '5': 1, '10': 'minimumMarginS'},
  ],
};

/// Descriptor for `ValidateCoordinationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateCoordinationRequestDescriptor = $convert.base64Decode(
    'ChtWYWxpZGF0ZUNvb3JkaW5hdGlvblJlcXVlc3QSGQoIc3R1ZHlfaWQYASABKAlSB3N0dWR5SW'
    'QSNQoFcGFpcnMYAiADKAsyHy5wcm90ZWN0aW9uLnYxLkNvb3JkaW5hdGlvblBhaXJSBXBhaXJz'
    'EigKEG1pbmltdW1fbWFyZ2luX3MYAyABKAFSDm1pbmltdW1NYXJnaW5T');

@$core.Deprecated('Use coordinationViolationDescriptor instead')
const CoordinationViolation$json = {
  '1': 'CoordinationViolation',
  '2': [
    {'1': 'upstream_relay_id', '3': 1, '4': 1, '5': 9, '10': 'upstreamRelayId'},
    {'1': 'downstream_relay_id', '3': 2, '4': 1, '5': 9, '10': 'downstreamRelayId'},
    {'1': 'margin_s', '3': 3, '4': 1, '5': 1, '10': 'marginS'},
    {'1': 'minimum_required_s', '3': 4, '4': 1, '5': 1, '10': 'minimumRequiredS'},
  ],
};

/// Descriptor for `CoordinationViolation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List coordinationViolationDescriptor = $convert.base64Decode(
    'ChVDb29yZGluYXRpb25WaW9sYXRpb24SKgoRdXBzdHJlYW1fcmVsYXlfaWQYASABKAlSD3Vwc3'
    'RyZWFtUmVsYXlJZBIuChNkb3duc3RyZWFtX3JlbGF5X2lkGAIgASgJUhFkb3duc3RyZWFtUmVs'
    'YXlJZBIZCghtYXJnaW5fcxgDIAEoAVIHbWFyZ2luUxIsChJtaW5pbXVtX3JlcXVpcmVkX3MYBC'
    'ABKAFSEG1pbmltdW1SZXF1aXJlZFM=');

@$core.Deprecated('Use validateCoordinationResponseDescriptor instead')
const ValidateCoordinationResponse$json = {
  '1': 'ValidateCoordinationResponse',
  '2': [
    {'1': 'valid', '3': 1, '4': 1, '5': 8, '10': 'valid'},
    {'1': 'violations', '3': 2, '4': 3, '5': 11, '6': '.protection.v1.CoordinationViolation', '10': 'violations'},
  ],
};

/// Descriptor for `ValidateCoordinationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateCoordinationResponseDescriptor = $convert.base64Decode(
    'ChxWYWxpZGF0ZUNvb3JkaW5hdGlvblJlc3BvbnNlEhQKBXZhbGlkGAEgASgIUgV2YWxpZBJECg'
    'p2aW9sYXRpb25zGAIgAygLMiQucHJvdGVjdGlvbi52MS5Db29yZGluYXRpb25WaW9sYXRpb25S'
    'CnZpb2xhdGlvbnM=');

@$core.Deprecated('Use generateProtectionReportRequestDescriptor instead')
const GenerateProtectionReportRequest$json = {
  '1': 'GenerateProtectionReportRequest',
  '2': [
    {'1': 'study_id', '3': 1, '4': 1, '5': 9, '10': 'studyId'},
  ],
};

/// Descriptor for `GenerateProtectionReportRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateProtectionReportRequestDescriptor = $convert.base64Decode(
    'Ch9HZW5lcmF0ZVByb3RlY3Rpb25SZXBvcnRSZXF1ZXN0EhkKCHN0dWR5X2lkGAEgASgJUgdzdH'
    'VkeUlk');

@$core.Deprecated('Use generateProtectionReportResponseDescriptor instead')
const GenerateProtectionReportResponse$json = {
  '1': 'GenerateProtectionReportResponse',
  '2': [
    {'1': 'study_id', '3': 1, '4': 1, '5': 9, '10': 'studyId'},
    {'1': 'report_text', '3': 2, '4': 1, '5': 9, '10': 'reportText'},
  ],
};

/// Descriptor for `GenerateProtectionReportResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List generateProtectionReportResponseDescriptor = $convert.base64Decode(
    'CiBHZW5lcmF0ZVByb3RlY3Rpb25SZXBvcnRSZXNwb25zZRIZCghzdHVkeV9pZBgBIAEoCVIHc3'
    'R1ZHlJZBIfCgtyZXBvcnRfdGV4dBgCIAEoCVIKcmVwb3J0VGV4dA==');

@$core.Deprecated('Use createStudyRequestDescriptor instead')
const CreateStudyRequest$json = {
  '1': 'CreateStudyRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'system_voltage_kv', '3': 3, '4': 1, '5': 1, '10': 'systemVoltageKv'},
    {'1': 'source_impedance_pu', '3': 4, '4': 1, '5': 1, '10': 'sourceImpedancePu'},
    {'1': 'mva_base', '3': 5, '4': 1, '5': 1, '10': 'mvaBase'},
  ],
};

/// Descriptor for `CreateStudyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createStudyRequestDescriptor = $convert.base64Decode(
    'ChJDcmVhdGVTdHVkeVJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElkEhIKBG'
    '5hbWUYAiABKAlSBG5hbWUSKgoRc3lzdGVtX3ZvbHRhZ2Vfa3YYAyABKAFSD3N5c3RlbVZvbHRh'
    'Z2VLdhIuChNzb3VyY2VfaW1wZWRhbmNlX3B1GAQgASgBUhFzb3VyY2VJbXBlZGFuY2VQdRIZCg'
    'htdmFfYmFzZRgFIAEoAVIHbXZhQmFzZQ==');

@$core.Deprecated('Use createStudyResponseDescriptor instead')
const CreateStudyResponse$json = {
  '1': 'CreateStudyResponse',
  '2': [
    {'1': 'study', '3': 1, '4': 1, '5': 11, '6': '.protection.v1.ProtectionStudy', '10': 'study'},
  ],
};

/// Descriptor for `CreateStudyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createStudyResponseDescriptor = $convert.base64Decode(
    'ChNDcmVhdGVTdHVkeVJlc3BvbnNlEjQKBXN0dWR5GAEgASgLMh4ucHJvdGVjdGlvbi52MS5Qcm'
    '90ZWN0aW9uU3R1ZHlSBXN0dWR5');

@$core.Deprecated('Use getStudyRequestDescriptor instead')
const GetStudyRequest$json = {
  '1': 'GetStudyRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetStudyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStudyRequestDescriptor = $convert.base64Decode(
    'Cg9HZXRTdHVkeVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use getStudyResponseDescriptor instead')
const GetStudyResponse$json = {
  '1': 'GetStudyResponse',
  '2': [
    {'1': 'study', '3': 1, '4': 1, '5': 11, '6': '.protection.v1.ProtectionStudy', '10': 'study'},
  ],
};

/// Descriptor for `GetStudyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStudyResponseDescriptor = $convert.base64Decode(
    'ChBHZXRTdHVkeVJlc3BvbnNlEjQKBXN0dWR5GAEgASgLMh4ucHJvdGVjdGlvbi52MS5Qcm90ZW'
    'N0aW9uU3R1ZHlSBXN0dWR5');

@$core.Deprecated('Use listStudiesRequestDescriptor instead')
const ListStudiesRequest$json = {
  '1': 'ListStudiesRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
  ],
};

/// Descriptor for `ListStudiesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStudiesRequestDescriptor = $convert.base64Decode(
    'ChJMaXN0U3R1ZGllc1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElk');

@$core.Deprecated('Use listStudiesResponseDescriptor instead')
const ListStudiesResponse$json = {
  '1': 'ListStudiesResponse',
  '2': [
    {'1': 'studies', '3': 1, '4': 3, '5': 11, '6': '.protection.v1.ProtectionStudy', '10': 'studies'},
  ],
};

/// Descriptor for `ListStudiesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listStudiesResponseDescriptor = $convert.base64Decode(
    'ChNMaXN0U3R1ZGllc1Jlc3BvbnNlEjgKB3N0dWRpZXMYASADKAsyHi5wcm90ZWN0aW9uLnYxLl'
    'Byb3RlY3Rpb25TdHVkeVIHc3R1ZGllcw==');

@$core.Deprecated('Use deleteStudyRequestDescriptor instead')
const DeleteStudyRequest$json = {
  '1': 'DeleteStudyRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteStudyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteStudyRequestDescriptor = $convert.base64Decode(
    'ChJEZWxldGVTdHVkeVJlcXVlc3QSDgoCaWQYASABKAlSAmlk');

@$core.Deprecated('Use deleteStudyResponseDescriptor instead')
const DeleteStudyResponse$json = {
  '1': 'DeleteStudyResponse',
};

/// Descriptor for `DeleteStudyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteStudyResponseDescriptor = $convert.base64Decode(
    'ChNEZWxldGVTdHVkeVJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> ProtectionServiceBase$json = {
  '1': 'ProtectionService',
  '2': [
    {'1': 'CreateStudy', '2': '.protection.v1.CreateStudyRequest', '3': '.protection.v1.CreateStudyResponse'},
    {'1': 'GetStudy', '2': '.protection.v1.GetStudyRequest', '3': '.protection.v1.GetStudyResponse'},
    {'1': 'ListStudies', '2': '.protection.v1.ListStudiesRequest', '3': '.protection.v1.ListStudiesResponse'},
    {'1': 'DeleteStudy', '2': '.protection.v1.DeleteStudyRequest', '3': '.protection.v1.DeleteStudyResponse'},
    {'1': 'ComputeShortCircuit', '2': '.protection.v1.ComputeShortCircuitRequest', '3': '.protection.v1.ComputeShortCircuitResponse'},
    {'1': 'ComputeEarthFault', '2': '.protection.v1.ComputeEarthFaultRequest', '3': '.protection.v1.ComputeEarthFaultResponse'},
    {'1': 'SelectRelay', '2': '.protection.v1.SelectRelayRequest', '3': '.protection.v1.SelectRelayResponse'},
    {'1': 'ComputeRelaySettings', '2': '.protection.v1.ComputeRelaySettingsRequest', '3': '.protection.v1.ComputeRelaySettingsResponse'},
    {'1': 'ValidateCoordination', '2': '.protection.v1.ValidateCoordinationRequest', '3': '.protection.v1.ValidateCoordinationResponse'},
    {'1': 'GenerateProtectionReport', '2': '.protection.v1.GenerateProtectionReportRequest', '3': '.protection.v1.GenerateProtectionReportResponse'},
  ],
};

@$core.Deprecated('Use protectionServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> ProtectionServiceBase$messageJson = {
  '.protection.v1.CreateStudyRequest': CreateStudyRequest$json,
  '.protection.v1.CreateStudyResponse': CreateStudyResponse$json,
  '.protection.v1.ProtectionStudy': ProtectionStudy$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.protection.v1.GetStudyRequest': GetStudyRequest$json,
  '.protection.v1.GetStudyResponse': GetStudyResponse$json,
  '.protection.v1.ListStudiesRequest': ListStudiesRequest$json,
  '.protection.v1.ListStudiesResponse': ListStudiesResponse$json,
  '.protection.v1.DeleteStudyRequest': DeleteStudyRequest$json,
  '.protection.v1.DeleteStudyResponse': DeleteStudyResponse$json,
  '.protection.v1.ComputeShortCircuitRequest': ComputeShortCircuitRequest$json,
  '.protection.v1.ComputeShortCircuitResponse': ComputeShortCircuitResponse$json,
  '.protection.v1.ComputeEarthFaultRequest': ComputeEarthFaultRequest$json,
  '.protection.v1.ComputeEarthFaultResponse': ComputeEarthFaultResponse$json,
  '.protection.v1.SelectRelayRequest': SelectRelayRequest$json,
  '.protection.v1.SelectRelayResponse': SelectRelayResponse$json,
  '.protection.v1.RelaySelection': RelaySelection$json,
  '.protection.v1.ComputeRelaySettingsRequest': ComputeRelaySettingsRequest$json,
  '.protection.v1.ComputeRelaySettingsResponse': ComputeRelaySettingsResponse$json,
  '.protection.v1.ValidateCoordinationRequest': ValidateCoordinationRequest$json,
  '.protection.v1.CoordinationPair': CoordinationPair$json,
  '.protection.v1.ValidateCoordinationResponse': ValidateCoordinationResponse$json,
  '.protection.v1.CoordinationViolation': CoordinationViolation$json,
  '.protection.v1.GenerateProtectionReportRequest': GenerateProtectionReportRequest$json,
  '.protection.v1.GenerateProtectionReportResponse': GenerateProtectionReportResponse$json,
};

/// Descriptor for `ProtectionService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List protectionServiceDescriptor = $convert.base64Decode(
    'ChFQcm90ZWN0aW9uU2VydmljZRJUCgtDcmVhdGVTdHVkeRIhLnByb3RlY3Rpb24udjEuQ3JlYX'
    'RlU3R1ZHlSZXF1ZXN0GiIucHJvdGVjdGlvbi52MS5DcmVhdGVTdHVkeVJlc3BvbnNlEksKCEdl'
    'dFN0dWR5Eh4ucHJvdGVjdGlvbi52MS5HZXRTdHVkeVJlcXVlc3QaHy5wcm90ZWN0aW9uLnYxLk'
    'dldFN0dWR5UmVzcG9uc2USVAoLTGlzdFN0dWRpZXMSIS5wcm90ZWN0aW9uLnYxLkxpc3RTdHVk'
    'aWVzUmVxdWVzdBoiLnByb3RlY3Rpb24udjEuTGlzdFN0dWRpZXNSZXNwb25zZRJUCgtEZWxldG'
    'VTdHVkeRIhLnByb3RlY3Rpb24udjEuRGVsZXRlU3R1ZHlSZXF1ZXN0GiIucHJvdGVjdGlvbi52'
    'MS5EZWxldGVTdHVkeVJlc3BvbnNlEmwKE0NvbXB1dGVTaG9ydENpcmN1aXQSKS5wcm90ZWN0aW'
    '9uLnYxLkNvbXB1dGVTaG9ydENpcmN1aXRSZXF1ZXN0GioucHJvdGVjdGlvbi52MS5Db21wdXRl'
    'U2hvcnRDaXJjdWl0UmVzcG9uc2USZgoRQ29tcHV0ZUVhcnRoRmF1bHQSJy5wcm90ZWN0aW9uLn'
    'YxLkNvbXB1dGVFYXJ0aEZhdWx0UmVxdWVzdBooLnByb3RlY3Rpb24udjEuQ29tcHV0ZUVhcnRo'
    'RmF1bHRSZXNwb25zZRJUCgtTZWxlY3RSZWxheRIhLnByb3RlY3Rpb24udjEuU2VsZWN0UmVsYX'
    'lSZXF1ZXN0GiIucHJvdGVjdGlvbi52MS5TZWxlY3RSZWxheVJlc3BvbnNlEm8KFENvbXB1dGVS'
    'ZWxheVNldHRpbmdzEioucHJvdGVjdGlvbi52MS5Db21wdXRlUmVsYXlTZXR0aW5nc1JlcXVlc3'
    'QaKy5wcm90ZWN0aW9uLnYxLkNvbXB1dGVSZWxheVNldHRpbmdzUmVzcG9uc2USbwoUVmFsaWRh'
    'dGVDb29yZGluYXRpb24SKi5wcm90ZWN0aW9uLnYxLlZhbGlkYXRlQ29vcmRpbmF0aW9uUmVxdW'
    'VzdBorLnByb3RlY3Rpb24udjEuVmFsaWRhdGVDb29yZGluYXRpb25SZXNwb25zZRJ7ChhHZW5l'
    'cmF0ZVByb3RlY3Rpb25SZXBvcnQSLi5wcm90ZWN0aW9uLnYxLkdlbmVyYXRlUHJvdGVjdGlvbl'
    'JlcG9ydFJlcXVlc3QaLy5wcm90ZWN0aW9uLnYxLkdlbmVyYXRlUHJvdGVjdGlvblJlcG9ydFJl'
    'c3BvbnNl');

