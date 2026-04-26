//
//  Generated code. Do not modify.
//  source: extended/v1/extended.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use solarTranspositionRequestDescriptor instead')
const SolarTranspositionRequest$json = {
  '1': 'SolarTranspositionRequest',
  '2': [
    {'1': 'ghi_wm2', '3': 1, '4': 1, '5': 1, '10': 'ghiWm2'},
    {'1': 'dhi_wm2', '3': 2, '4': 1, '5': 1, '10': 'dhiWm2'},
    {'1': 'wind_speed_ms', '3': 3, '4': 1, '5': 1, '10': 'windSpeedMs'},
    {'1': 'temperature_c', '3': 4, '4': 1, '5': 1, '10': 'temperatureC'},
    {'1': 'surface_tilt_deg', '3': 5, '4': 1, '5': 1, '10': 'surfaceTiltDeg'},
    {'1': 'surface_azimuth', '3': 6, '4': 1, '5': 1, '10': 'surfaceAzimuth'},
    {'1': 'solar_altitude', '3': 7, '4': 1, '5': 1, '10': 'solarAltitude'},
    {'1': 'solar_azimuth', '3': 8, '4': 1, '5': 1, '10': 'solarAzimuth'},
  ],
};

/// Descriptor for `SolarTranspositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List solarTranspositionRequestDescriptor = $convert.base64Decode(
    'ChlTb2xhclRyYW5zcG9zaXRpb25SZXF1ZXN0EhcKB2doaV93bTIYASABKAFSBmdoaVdtMhIXCg'
    'dkaGlfd20yGAIgASgBUgZkaGlXbTISIgoNd2luZF9zcGVlZF9tcxgDIAEoAVILd2luZFNwZWVk'
    'TXMSIwoNdGVtcGVyYXR1cmVfYxgEIAEoAVIMdGVtcGVyYXR1cmVDEigKEHN1cmZhY2VfdGlsdF'
    '9kZWcYBSABKAFSDnN1cmZhY2VUaWx0RGVnEicKD3N1cmZhY2VfYXppbXV0aBgGIAEoAVIOc3Vy'
    'ZmFjZUF6aW11dGgSJQoOc29sYXJfYWx0aXR1ZGUYByABKAFSDXNvbGFyQWx0aXR1ZGUSIwoNc2'
    '9sYXJfYXppbXV0aBgIIAEoAVIMc29sYXJBemltdXRo');

@$core.Deprecated('Use solarTranspositionResponseDescriptor instead')
const SolarTranspositionResponse$json = {
  '1': 'SolarTranspositionResponse',
  '2': [
    {'1': 'poa_irradiance', '3': 1, '4': 1, '5': 1, '10': 'poaIrradiance'},
    {'1': 'aoi', '3': 2, '4': 1, '5': 1, '10': 'aoi'},
    {'1': 'incidence_modulation', '3': 3, '4': 1, '5': 1, '10': 'incidenceModulation'},
  ],
};

/// Descriptor for `SolarTranspositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List solarTranspositionResponseDescriptor = $convert.base64Decode(
    'ChpTb2xhclRyYW5zcG9zaXRpb25SZXNwb25zZRIlCg5wb2FfaXJyYWRpYW5jZRgBIAEoAVINcG'
    '9hSXJyYWRpYW5jZRIQCgNhb2kYAiABKAFSA2FvaRIxChRpbmNpZGVuY2VfbW9kdWxhdGlvbhgD'
    'IAEoAVITaW5jaWRlbmNlTW9kdWxhdGlvbg==');

@$core.Deprecated('Use financialMetricsRequestDescriptor instead')
const FinancialMetricsRequest$json = {
  '1': 'FinancialMetricsRequest',
  '2': [
    {'1': 'annual_cashflows', '3': 1, '4': 3, '5': 1, '10': 'annualCashflows'},
    {'1': 'initial_investment', '3': 2, '4': 1, '5': 1, '10': 'initialInvestment'},
    {'1': 'discount_rate', '3': 3, '4': 1, '5': 1, '10': 'discountRate'},
    {'1': 'pr_baseline', '3': 4, '4': 1, '5': 1, '10': 'prBaseline'},
    {'1': 'pr_actual', '3': 5, '4': 1, '5': 1, '10': 'prActual'},
  ],
};

/// Descriptor for `FinancialMetricsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List financialMetricsRequestDescriptor = $convert.base64Decode(
    'ChdGaW5hbmNpYWxNZXRyaWNzUmVxdWVzdBIpChBhbm51YWxfY2FzaGZsb3dzGAEgAygBUg9hbm'
    '51YWxDYXNoZmxvd3MSLQoSaW5pdGlhbF9pbnZlc3RtZW50GAIgASgBUhFpbml0aWFsSW52ZXN0'
    'bWVudBIjCg1kaXNjb3VudF9yYXRlGAMgASgBUgxkaXNjb3VudFJhdGUSHwoLcHJfYmFzZWxpbm'
    'UYBCABKAFSCnByQmFzZWxpbmUSGwoJcHJfYWN0dWFsGAUgASgBUghwckFjdHVhbA==');

@$core.Deprecated('Use financialMetricsResponseDescriptor instead')
const FinancialMetricsResponse$json = {
  '1': 'FinancialMetricsResponse',
  '2': [
    {'1': 'npv_usd', '3': 1, '4': 1, '5': 1, '10': 'npvUsd'},
    {'1': 'irr_percent', '3': 2, '4': 1, '5': 1, '10': 'irrPercent'},
    {'1': 'pi_coeff', '3': 3, '4': 1, '5': 1, '10': 'piCoeff'},
    {'1': 'crop_percent', '3': 4, '4': 1, '5': 1, '10': 'cropPercent'},
  ],
};

/// Descriptor for `FinancialMetricsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List financialMetricsResponseDescriptor = $convert.base64Decode(
    'ChhGaW5hbmNpYWxNZXRyaWNzUmVzcG9uc2USFwoHbnB2X3VzZBgBIAEoAVIGbnB2VXNkEh8KC2'
    'lycl9wZXJjZW50GAIgASgBUgppcnJQZXJjZW50EhkKCHBpX2NvZWZmGAMgASgBUgdwaUNvZWZm'
    'EiEKDGNyb3BfcGVyY2VudBgEIAEoAVILY3JvcFBlcmNlbnQ=');

@$core.Deprecated('Use compareFinancialScenariosRequestDescriptor instead')
const CompareFinancialScenariosRequest$json = {
  '1': 'CompareFinancialScenariosRequest',
  '2': [
    {'1': 'annual_yield_kwh', '3': 1, '4': 1, '5': 1, '10': 'annualYieldKwh'},
    {'1': 'annual_om_usd', '3': 2, '4': 1, '5': 1, '10': 'annualOmUsd'},
    {'1': 'project_life_years', '3': 3, '4': 1, '5': 5, '10': 'projectLifeYears'},
    {'1': 'base_initial_investment', '3': 4, '4': 1, '5': 1, '10': 'baseInitialInvestment'},
    {'1': 'pr_baseline', '3': 5, '4': 1, '5': 1, '10': 'prBaseline'},
    {'1': 'scenarios', '3': 6, '4': 3, '5': 11, '6': '.extended.v1.FinancialScenario', '10': 'scenarios'},
  ],
};

/// Descriptor for `CompareFinancialScenariosRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compareFinancialScenariosRequestDescriptor = $convert.base64Decode(
    'CiBDb21wYXJlRmluYW5jaWFsU2NlbmFyaW9zUmVxdWVzdBIoChBhbm51YWxfeWllbGRfa3doGA'
    'EgASgBUg5hbm51YWxZaWVsZEt3aBIiCg1hbm51YWxfb21fdXNkGAIgASgBUgthbm51YWxPbVVz'
    'ZBIsChJwcm9qZWN0X2xpZmVfeWVhcnMYAyABKAVSEHByb2plY3RMaWZlWWVhcnMSNgoXYmFzZV'
    '9pbml0aWFsX2ludmVzdG1lbnQYBCABKAFSFWJhc2VJbml0aWFsSW52ZXN0bWVudBIfCgtwcl9i'
    'YXNlbGluZRgFIAEoAVIKcHJCYXNlbGluZRI8CglzY2VuYXJpb3MYBiADKAsyHi5leHRlbmRlZC'
    '52MS5GaW5hbmNpYWxTY2VuYXJpb1IJc2NlbmFyaW9z');

@$core.Deprecated('Use financialScenarioResultDescriptor instead')
const FinancialScenarioResult$json = {
  '1': 'FinancialScenarioResult',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'metrics', '3': 2, '4': 1, '5': 11, '6': '.extended.v1.FinancialMetricsResponse', '10': 'metrics'},
    {'1': 'annual_revenue_usd', '3': 3, '4': 1, '5': 1, '10': 'annualRevenueUsd'},
    {'1': 'net_annual_cashflow_usd', '3': 4, '4': 1, '5': 1, '10': 'netAnnualCashflowUsd'},
    {'1': 'simple_payback_years', '3': 5, '4': 1, '5': 1, '10': 'simplePaybackYears'},
    {'1': 'roi_percent', '3': 6, '4': 1, '5': 1, '10': 'roiPercent'},
  ],
};

/// Descriptor for `FinancialScenarioResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List financialScenarioResultDescriptor = $convert.base64Decode(
    'ChdGaW5hbmNpYWxTY2VuYXJpb1Jlc3VsdBISCgRuYW1lGAEgASgJUgRuYW1lEj8KB21ldHJpY3'
    'MYAiABKAsyJS5leHRlbmRlZC52MS5GaW5hbmNpYWxNZXRyaWNzUmVzcG9uc2VSB21ldHJpY3MS'
    'LAoSYW5udWFsX3JldmVudWVfdXNkGAMgASgBUhBhbm51YWxSZXZlbnVlVXNkEjUKF25ldF9hbm'
    '51YWxfY2FzaGZsb3dfdXNkGAQgASgBUhRuZXRBbm51YWxDYXNoZmxvd1VzZBIwChRzaW1wbGVf'
    'cGF5YmFja195ZWFycxgFIAEoAVISc2ltcGxlUGF5YmFja1llYXJzEh8KC3JvaV9wZXJjZW50GA'
    'YgASgBUgpyb2lQZXJjZW50');

@$core.Deprecated('Use compareFinancialScenariosResponseDescriptor instead')
const CompareFinancialScenariosResponse$json = {
  '1': 'CompareFinancialScenariosResponse',
  '2': [
    {'1': 'scenarios', '3': 1, '4': 3, '5': 11, '6': '.extended.v1.FinancialScenarioResult', '10': 'scenarios'},
  ],
};

/// Descriptor for `CompareFinancialScenariosResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List compareFinancialScenariosResponseDescriptor = $convert.base64Decode(
    'CiFDb21wYXJlRmluYW5jaWFsU2NlbmFyaW9zUmVzcG9uc2USQgoJc2NlbmFyaW9zGAEgAygLMi'
    'QuZXh0ZW5kZWQudjEuRmluYW5jaWFsU2NlbmFyaW9SZXN1bHRSCXNjZW5hcmlvcw==');

@$core.Deprecated('Use climateImpactRequestDescriptor instead')
const ClimateImpactRequest$json = {
  '1': 'ClimateImpactRequest',
  '2': [
    {'1': 'temp_impact', '3': 1, '4': 1, '5': 1, '10': 'tempImpact'},
    {'1': 'soiling_impact', '3': 2, '4': 1, '5': 1, '10': 'soilingImpact'},
    {'1': 'wind_impact', '3': 3, '4': 1, '5': 1, '10': 'windImpact'},
    {'1': 'availability_impact', '3': 4, '4': 1, '5': 1, '10': 'availabilityImpact'},
  ],
};

/// Descriptor for `ClimateImpactRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List climateImpactRequestDescriptor = $convert.base64Decode(
    'ChRDbGltYXRlSW1wYWN0UmVxdWVzdBIfCgt0ZW1wX2ltcGFjdBgBIAEoAVIKdGVtcEltcGFjdB'
    'IlCg5zb2lsaW5nX2ltcGFjdBgCIAEoAVINc29pbGluZ0ltcGFjdBIfCgt3aW5kX2ltcGFjdBgD'
    'IAEoAVIKd2luZEltcGFjdBIvChNhdmFpbGFiaWxpdHlfaW1wYWN0GAQgASgBUhJhdmFpbGFiaW'
    'xpdHlJbXBhY3Q=');

@$core.Deprecated('Use climateImpactResponseDescriptor instead')
const ClimateImpactResponse$json = {
  '1': 'ClimateImpactResponse',
  '2': [
    {'1': 'soiling_factor_change', '3': 1, '4': 1, '5': 1, '10': 'soilingFactorChange'},
    {'1': 'efficiency_factor_change', '3': 2, '4': 1, '5': 1, '10': 'efficiencyFactorChange'},
    {'1': 'module_temperature_increase', '3': 3, '4': 1, '5': 1, '10': 'moduleTemperatureIncrease'},
    {'1': 'availability_impact_percent', '3': 4, '4': 1, '5': 1, '10': 'availabilityImpactPercent'},
  ],
};

/// Descriptor for `ClimateImpactResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List climateImpactResponseDescriptor = $convert.base64Decode(
    'ChVDbGltYXRlSW1wYWN0UmVzcG9uc2USMgoVc29pbGluZ19mYWN0b3JfY2hhbmdlGAEgASgBUh'
    'Nzb2lsaW5nRmFjdG9yQ2hhbmdlEjgKGGVmZmljaWVuY3lfZmFjdG9yX2NoYW5nZRgCIAEoAVIW'
    'ZWZmaWNpZW5jeUZhY3RvckNoYW5nZRI+Chttb2R1bGVfdGVtcGVyYXR1cmVfaW5jcmVhc2UYAy'
    'ABKAFSGW1vZHVsZVRlbXBlcmF0dXJlSW5jcmVhc2USPgobYXZhaWxhYmlsaXR5X2ltcGFjdF9w'
    'ZXJjZW50GAQgASgBUhlhdmFpbGFiaWxpdHlJbXBhY3RQZXJjZW50');

@$core.Deprecated('Use financialScenarioDescriptor instead')
const FinancialScenario$json = {
  '1': 'FinancialScenario',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'electricity_price', '3': 2, '4': 1, '5': 1, '10': 'electricityPrice'},
    {'1': 'escalation_rate_percent', '3': 3, '4': 1, '5': 1, '10': 'escalationRatePercent'},
    {'1': 'degradation_rate_percent', '3': 4, '4': 1, '5': 1, '10': 'degradationRatePercent'},
    {'1': 'discount_rate_percent', '3': 5, '4': 1, '5': 1, '10': 'discountRatePercent'},
    {'1': 'pr_actual', '3': 6, '4': 1, '5': 1, '10': 'prActual'},
    {'1': 'capex_multiplier', '3': 7, '4': 1, '5': 1, '10': 'capexMultiplier'},
  ],
};

/// Descriptor for `FinancialScenario`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List financialScenarioDescriptor = $convert.base64Decode(
    'ChFGaW5hbmNpYWxTY2VuYXJpbxISCgRuYW1lGAEgASgJUgRuYW1lEisKEWVsZWN0cmljaXR5X3'
    'ByaWNlGAIgASgBUhBlbGVjdHJpY2l0eVByaWNlEjYKF2VzY2FsYXRpb25fcmF0ZV9wZXJjZW50'
    'GAMgASgBUhVlc2NhbGF0aW9uUmF0ZVBlcmNlbnQSOAoYZGVncmFkYXRpb25fcmF0ZV9wZXJjZW'
    '50GAQgASgBUhZkZWdyYWRhdGlvblJhdGVQZXJjZW50EjIKFWRpc2NvdW50X3JhdGVfcGVyY2Vu'
    'dBgFIAEoAVITZGlzY291bnRSYXRlUGVyY2VudBIbCglwcl9hY3R1YWwYBiABKAFSCHByQWN0dW'
    'FsEikKEGNhcGV4X211bHRpcGxpZXIYByABKAFSD2NhcGV4TXVsdGlwbGllcg==');

@$core.Deprecated('Use saveFinancialScenarioSetRequestDescriptor instead')
const SaveFinancialScenarioSetRequest$json = {
  '1': 'SaveFinancialScenarioSetRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'scenarios', '3': 3, '4': 3, '5': 11, '6': '.extended.v1.FinancialScenario', '10': 'scenarios'},
  ],
};

/// Descriptor for `SaveFinancialScenarioSetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveFinancialScenarioSetRequestDescriptor = $convert.base64Decode(
    'Ch9TYXZlRmluYW5jaWFsU2NlbmFyaW9TZXRSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCX'
    'Byb2plY3RJZBIbCglsYXlvdXRfaWQYAiABKAlSCGxheW91dElkEjwKCXNjZW5hcmlvcxgDIAMo'
    'CzIeLmV4dGVuZGVkLnYxLkZpbmFuY2lhbFNjZW5hcmlvUglzY2VuYXJpb3M=');

@$core.Deprecated('Use saveFinancialScenarioSetResponseDescriptor instead')
const SaveFinancialScenarioSetResponse$json = {
  '1': 'SaveFinancialScenarioSetResponse',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'scenarios', '3': 3, '4': 3, '5': 11, '6': '.extended.v1.FinancialScenario', '10': 'scenarios'},
    {'1': 'updated_at_rfc3339', '3': 4, '4': 1, '5': 9, '10': 'updatedAtRfc3339'},
  ],
};

/// Descriptor for `SaveFinancialScenarioSetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List saveFinancialScenarioSetResponseDescriptor = $convert.base64Decode(
    'CiBTYXZlRmluYW5jaWFsU2NlbmFyaW9TZXRSZXNwb25zZRIdCgpwcm9qZWN0X2lkGAEgASgJUg'
    'lwcm9qZWN0SWQSGwoJbGF5b3V0X2lkGAIgASgJUghsYXlvdXRJZBI8CglzY2VuYXJpb3MYAyAD'
    'KAsyHi5leHRlbmRlZC52MS5GaW5hbmNpYWxTY2VuYXJpb1IJc2NlbmFyaW9zEiwKEnVwZGF0ZW'
    'RfYXRfcmZjMzMzORgEIAEoCVIQdXBkYXRlZEF0UmZjMzMzOQ==');

@$core.Deprecated('Use getFinancialScenarioSetRequestDescriptor instead')
const GetFinancialScenarioSetRequest$json = {
  '1': 'GetFinancialScenarioSetRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
  ],
};

/// Descriptor for `GetFinancialScenarioSetRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFinancialScenarioSetRequestDescriptor = $convert.base64Decode(
    'Ch5HZXRGaW5hbmNpYWxTY2VuYXJpb1NldFJlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcH'
    'JvamVjdElkEhsKCWxheW91dF9pZBgCIAEoCVIIbGF5b3V0SWQ=');

@$core.Deprecated('Use getFinancialScenarioSetResponseDescriptor instead')
const GetFinancialScenarioSetResponse$json = {
  '1': 'GetFinancialScenarioSetResponse',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'scenarios', '3': 3, '4': 3, '5': 11, '6': '.extended.v1.FinancialScenario', '10': 'scenarios'},
    {'1': 'updated_at_rfc3339', '3': 4, '4': 1, '5': 9, '10': 'updatedAtRfc3339'},
  ],
};

/// Descriptor for `GetFinancialScenarioSetResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFinancialScenarioSetResponseDescriptor = $convert.base64Decode(
    'Ch9HZXRGaW5hbmNpYWxTY2VuYXJpb1NldFJlc3BvbnNlEh0KCnByb2plY3RfaWQYASABKAlSCX'
    'Byb2plY3RJZBIbCglsYXlvdXRfaWQYAiABKAlSCGxheW91dElkEjwKCXNjZW5hcmlvcxgDIAMo'
    'CzIeLmV4dGVuZGVkLnYxLkZpbmFuY2lhbFNjZW5hcmlvUglzY2VuYXJpb3MSLAoSdXBkYXRlZF'
    '9hdF9yZmMzMzM5GAQgASgJUhB1cGRhdGVkQXRSZmMzMzM5');

@$core.Deprecated('Use listFinancialScenarioSetsRequestDescriptor instead')
const ListFinancialScenarioSetsRequest$json = {
  '1': 'ListFinancialScenarioSetsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
  ],
};

/// Descriptor for `ListFinancialScenarioSetsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFinancialScenarioSetsRequestDescriptor = $convert.base64Decode(
    'CiBMaXN0RmluYW5jaWFsU2NlbmFyaW9TZXRzUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUg'
    'lwcm9qZWN0SWQ=');

@$core.Deprecated('Use financialScenarioSetSummaryDescriptor instead')
const FinancialScenarioSetSummary$json = {
  '1': 'FinancialScenarioSetSummary',
  '2': [
    {'1': 'layout_id', '3': 1, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'scenario_count', '3': 2, '4': 1, '5': 5, '10': 'scenarioCount'},
    {'1': 'updated_at_rfc3339', '3': 3, '4': 1, '5': 9, '10': 'updatedAtRfc3339'},
  ],
};

/// Descriptor for `FinancialScenarioSetSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List financialScenarioSetSummaryDescriptor = $convert.base64Decode(
    'ChtGaW5hbmNpYWxTY2VuYXJpb1NldFN1bW1hcnkSGwoJbGF5b3V0X2lkGAEgASgJUghsYXlvdX'
    'RJZBIlCg5zY2VuYXJpb19jb3VudBgCIAEoBVINc2NlbmFyaW9Db3VudBIsChJ1cGRhdGVkX2F0'
    'X3JmYzMzMzkYAyABKAlSEHVwZGF0ZWRBdFJmYzMzMzk=');

@$core.Deprecated('Use listFinancialScenarioSetsResponseDescriptor instead')
const ListFinancialScenarioSetsResponse$json = {
  '1': 'ListFinancialScenarioSetsResponse',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.extended.v1.FinancialScenarioSetSummary', '10': 'items'},
  ],
};

/// Descriptor for `ListFinancialScenarioSetsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFinancialScenarioSetsResponseDescriptor = $convert.base64Decode(
    'CiFMaXN0RmluYW5jaWFsU2NlbmFyaW9TZXRzUmVzcG9uc2USPgoFaXRlbXMYASADKAsyKC5leH'
    'RlbmRlZC52MS5GaW5hbmNpYWxTY2VuYXJpb1NldFN1bW1hcnlSBWl0ZW1z');

@$core.Deprecated('Use financialScenarioSetVersionDescriptor instead')
const FinancialScenarioSetVersion$json = {
  '1': 'FinancialScenarioSetVersion',
  '2': [
    {'1': 'scenarios', '3': 1, '4': 3, '5': 11, '6': '.extended.v1.FinancialScenario', '10': 'scenarios'},
    {'1': 'saved_at_rfc3339', '3': 2, '4': 1, '5': 9, '10': 'savedAtRfc3339'},
  ],
};

/// Descriptor for `FinancialScenarioSetVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List financialScenarioSetVersionDescriptor = $convert.base64Decode(
    'ChtGaW5hbmNpYWxTY2VuYXJpb1NldFZlcnNpb24SPAoJc2NlbmFyaW9zGAEgAygLMh4uZXh0ZW'
    '5kZWQudjEuRmluYW5jaWFsU2NlbmFyaW9SCXNjZW5hcmlvcxIoChBzYXZlZF9hdF9yZmMzMzM5'
    'GAIgASgJUg5zYXZlZEF0UmZjMzMzOQ==');

@$core.Deprecated('Use getFinancialScenarioSetVersionsRequestDescriptor instead')
const GetFinancialScenarioSetVersionsRequest$json = {
  '1': 'GetFinancialScenarioSetVersionsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'layout_id', '3': 2, '4': 1, '5': 9, '10': 'layoutId'},
  ],
};

/// Descriptor for `GetFinancialScenarioSetVersionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFinancialScenarioSetVersionsRequestDescriptor = $convert.base64Decode(
    'CiZHZXRGaW5hbmNpYWxTY2VuYXJpb1NldFZlcnNpb25zUmVxdWVzdBIdCgpwcm9qZWN0X2lkGA'
    'EgASgJUglwcm9qZWN0SWQSGwoJbGF5b3V0X2lkGAIgASgJUghsYXlvdXRJZA==');

@$core.Deprecated('Use getFinancialScenarioSetVersionsResponseDescriptor instead')
const GetFinancialScenarioSetVersionsResponse$json = {
  '1': 'GetFinancialScenarioSetVersionsResponse',
  '2': [
    {'1': 'versions', '3': 1, '4': 3, '5': 11, '6': '.extended.v1.FinancialScenarioSetVersion', '10': 'versions'},
  ],
};

/// Descriptor for `GetFinancialScenarioSetVersionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFinancialScenarioSetVersionsResponseDescriptor = $convert.base64Decode(
    'CidHZXRGaW5hbmNpYWxTY2VuYXJpb1NldFZlcnNpb25zUmVzcG9uc2USRAoIdmVyc2lvbnMYAS'
    'ADKAsyKC5leHRlbmRlZC52MS5GaW5hbmNpYWxTY2VuYXJpb1NldFZlcnNpb25SCHZlcnNpb25z');

@$core.Deprecated('Use calculateInterRowShadingRequestDescriptor instead')
const CalculateInterRowShadingRequest$json = {
  '1': 'CalculateInterRowShadingRequest',
  '2': [
    {'1': 'tilt_deg', '3': 1, '4': 1, '5': 1, '10': 'tiltDeg'},
    {'1': 'gcr', '3': 2, '4': 1, '5': 1, '10': 'gcr'},
    {'1': 'latitude_deg', '3': 3, '4': 1, '5': 1, '10': 'latitudeDeg'},
    {'1': 'analysis_days', '3': 4, '4': 1, '5': 5, '10': 'analysisDays'},
    {'1': 'is_tracker', '3': 5, '4': 1, '5': 8, '10': 'isTracker'},
  ],
};

/// Descriptor for `CalculateInterRowShadingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateInterRowShadingRequestDescriptor = $convert.base64Decode(
    'Ch9DYWxjdWxhdGVJbnRlclJvd1NoYWRpbmdSZXF1ZXN0EhkKCHRpbHRfZGVnGAEgASgBUgd0aW'
    'x0RGVnEhAKA2djchgCIAEoAVIDZ2NyEiEKDGxhdGl0dWRlX2RlZxgDIAEoAVILbGF0aXR1ZGVE'
    'ZWcSIwoNYW5hbHlzaXNfZGF5cxgEIAEoBVIMYW5hbHlzaXNEYXlzEh0KCmlzX3RyYWNrZXIYBS'
    'ABKAhSCWlzVHJhY2tlcg==');

@$core.Deprecated('Use calculateInterRowShadingResponseDescriptor instead')
const CalculateInterRowShadingResponse$json = {
  '1': 'CalculateInterRowShadingResponse',
  '2': [
    {'1': 'annual_shading_loss_percent', '3': 1, '4': 1, '5': 1, '10': 'annualShadingLossPercent'},
    {'1': 'near_shading_loss_percent', '3': 2, '4': 1, '5': 1, '10': 'nearShadingLossPercent'},
    {'1': 'optimal_gcr', '3': 3, '4': 1, '5': 1, '10': 'optimalGcr'},
    {'1': 'note', '3': 4, '4': 1, '5': 9, '10': 'note'},
  ],
};

/// Descriptor for `CalculateInterRowShadingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateInterRowShadingResponseDescriptor = $convert.base64Decode(
    'CiBDYWxjdWxhdGVJbnRlclJvd1NoYWRpbmdSZXNwb25zZRI9Chthbm51YWxfc2hhZGluZ19sb3'
    'NzX3BlcmNlbnQYASABKAFSGGFubnVhbFNoYWRpbmdMb3NzUGVyY2VudBI5ChluZWFyX3NoYWRp'
    'bmdfbG9zc19wZXJjZW50GAIgASgBUhZuZWFyU2hhZGluZ0xvc3NQZXJjZW50Eh8KC29wdGltYW'
    'xfZ2NyGAMgASgBUgpvcHRpbWFsR2NyEhIKBG5vdGUYBCABKAlSBG5vdGU=');

@$core.Deprecated('Use calculateYieldUncertaintyRequestDescriptor instead')
const CalculateYieldUncertaintyRequest$json = {
  '1': 'CalculateYieldUncertaintyRequest',
  '2': [
    {'1': 'p50_annual_kwh', '3': 1, '4': 1, '5': 1, '10': 'p50AnnualKwh'},
    {'1': 'interannual_variability_pct', '3': 2, '4': 1, '5': 1, '10': 'interannualVariabilityPct'},
    {'1': 'measurement_uncertainty_pct', '3': 3, '4': 1, '5': 1, '10': 'measurementUncertaintyPct'},
    {'1': 'model_uncertainty_pct', '3': 4, '4': 1, '5': 1, '10': 'modelUncertaintyPct'},
    {'1': 'soiling_uncertainty_pct', '3': 5, '4': 1, '5': 1, '10': 'soilingUncertaintyPct'},
    {'1': 'degradation_uncertainty_pct', '3': 6, '4': 1, '5': 1, '10': 'degradationUncertaintyPct'},
  ],
};

/// Descriptor for `CalculateYieldUncertaintyRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateYieldUncertaintyRequestDescriptor = $convert.base64Decode(
    'CiBDYWxjdWxhdGVZaWVsZFVuY2VydGFpbnR5UmVxdWVzdBIkCg5wNTBfYW5udWFsX2t3aBgBIA'
    'EoAVIMcDUwQW5udWFsS3doEj4KG2ludGVyYW5udWFsX3ZhcmlhYmlsaXR5X3BjdBgCIAEoAVIZ'
    'aW50ZXJhbm51YWxWYXJpYWJpbGl0eVBjdBI+ChttZWFzdXJlbWVudF91bmNlcnRhaW50eV9wY3'
    'QYAyABKAFSGW1lYXN1cmVtZW50VW5jZXJ0YWludHlQY3QSMgoVbW9kZWxfdW5jZXJ0YWludHlf'
    'cGN0GAQgASgBUhNtb2RlbFVuY2VydGFpbnR5UGN0EjYKF3NvaWxpbmdfdW5jZXJ0YWludHlfcG'
    'N0GAUgASgBUhVzb2lsaW5nVW5jZXJ0YWludHlQY3QSPgobZGVncmFkYXRpb25fdW5jZXJ0YWlu'
    'dHlfcGN0GAYgASgBUhlkZWdyYWRhdGlvblVuY2VydGFpbnR5UGN0');

@$core.Deprecated('Use calculateYieldUncertaintyResponseDescriptor instead')
const CalculateYieldUncertaintyResponse$json = {
  '1': 'CalculateYieldUncertaintyResponse',
  '2': [
    {'1': 'p50_kwh', '3': 1, '4': 1, '5': 1, '10': 'p50Kwh'},
    {'1': 'p90_kwh', '3': 2, '4': 1, '5': 1, '10': 'p90Kwh'},
    {'1': 'p99_kwh', '3': 3, '4': 1, '5': 1, '10': 'p99Kwh'},
    {'1': 'combined_uncertainty_pct', '3': 4, '4': 1, '5': 1, '10': 'combinedUncertaintyPct'},
  ],
};

/// Descriptor for `CalculateYieldUncertaintyResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateYieldUncertaintyResponseDescriptor = $convert.base64Decode(
    'CiFDYWxjdWxhdGVZaWVsZFVuY2VydGFpbnR5UmVzcG9uc2USFwoHcDUwX2t3aBgBIAEoAVIGcD'
    'UwS3doEhcKB3A5MF9rd2gYAiABKAFSBnA5MEt3aBIXCgdwOTlfa3doGAMgASgBUgZwOTlLd2gS'
    'OAoYY29tYmluZWRfdW5jZXJ0YWludHlfcGN0GAQgASgBUhZjb21iaW5lZFVuY2VydGFpbnR5UG'
    'N0');

const $core.Map<$core.String, $core.dynamic> ExtendedServiceBase$json = {
  '1': 'ExtendedService',
  '2': [
    {'1': 'SolarTransposition', '2': '.extended.v1.SolarTranspositionRequest', '3': '.extended.v1.SolarTranspositionResponse'},
    {'1': 'FinancialMetrics', '2': '.extended.v1.FinancialMetricsRequest', '3': '.extended.v1.FinancialMetricsResponse'},
    {'1': 'CompareFinancialScenarios', '2': '.extended.v1.CompareFinancialScenariosRequest', '3': '.extended.v1.CompareFinancialScenariosResponse'},
    {'1': 'ClimateImpact', '2': '.extended.v1.ClimateImpactRequest', '3': '.extended.v1.ClimateImpactResponse'},
    {'1': 'SaveFinancialScenarioSet', '2': '.extended.v1.SaveFinancialScenarioSetRequest', '3': '.extended.v1.SaveFinancialScenarioSetResponse'},
    {'1': 'GetFinancialScenarioSet', '2': '.extended.v1.GetFinancialScenarioSetRequest', '3': '.extended.v1.GetFinancialScenarioSetResponse'},
    {'1': 'ListFinancialScenarioSets', '2': '.extended.v1.ListFinancialScenarioSetsRequest', '3': '.extended.v1.ListFinancialScenarioSetsResponse'},
    {'1': 'GetFinancialScenarioSetVersions', '2': '.extended.v1.GetFinancialScenarioSetVersionsRequest', '3': '.extended.v1.GetFinancialScenarioSetVersionsResponse'},
    {'1': 'CalculateInterRowShading', '2': '.extended.v1.CalculateInterRowShadingRequest', '3': '.extended.v1.CalculateInterRowShadingResponse'},
    {'1': 'CalculateYieldUncertainty', '2': '.extended.v1.CalculateYieldUncertaintyRequest', '3': '.extended.v1.CalculateYieldUncertaintyResponse'},
  ],
};

@$core.Deprecated('Use extendedServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> ExtendedServiceBase$messageJson = {
  '.extended.v1.SolarTranspositionRequest': SolarTranspositionRequest$json,
  '.extended.v1.SolarTranspositionResponse': SolarTranspositionResponse$json,
  '.extended.v1.FinancialMetricsRequest': FinancialMetricsRequest$json,
  '.extended.v1.FinancialMetricsResponse': FinancialMetricsResponse$json,
  '.extended.v1.CompareFinancialScenariosRequest': CompareFinancialScenariosRequest$json,
  '.extended.v1.FinancialScenario': FinancialScenario$json,
  '.extended.v1.CompareFinancialScenariosResponse': CompareFinancialScenariosResponse$json,
  '.extended.v1.FinancialScenarioResult': FinancialScenarioResult$json,
  '.extended.v1.ClimateImpactRequest': ClimateImpactRequest$json,
  '.extended.v1.ClimateImpactResponse': ClimateImpactResponse$json,
  '.extended.v1.SaveFinancialScenarioSetRequest': SaveFinancialScenarioSetRequest$json,
  '.extended.v1.SaveFinancialScenarioSetResponse': SaveFinancialScenarioSetResponse$json,
  '.extended.v1.GetFinancialScenarioSetRequest': GetFinancialScenarioSetRequest$json,
  '.extended.v1.GetFinancialScenarioSetResponse': GetFinancialScenarioSetResponse$json,
  '.extended.v1.ListFinancialScenarioSetsRequest': ListFinancialScenarioSetsRequest$json,
  '.extended.v1.ListFinancialScenarioSetsResponse': ListFinancialScenarioSetsResponse$json,
  '.extended.v1.FinancialScenarioSetSummary': FinancialScenarioSetSummary$json,
  '.extended.v1.GetFinancialScenarioSetVersionsRequest': GetFinancialScenarioSetVersionsRequest$json,
  '.extended.v1.GetFinancialScenarioSetVersionsResponse': GetFinancialScenarioSetVersionsResponse$json,
  '.extended.v1.FinancialScenarioSetVersion': FinancialScenarioSetVersion$json,
  '.extended.v1.CalculateInterRowShadingRequest': CalculateInterRowShadingRequest$json,
  '.extended.v1.CalculateInterRowShadingResponse': CalculateInterRowShadingResponse$json,
  '.extended.v1.CalculateYieldUncertaintyRequest': CalculateYieldUncertaintyRequest$json,
  '.extended.v1.CalculateYieldUncertaintyResponse': CalculateYieldUncertaintyResponse$json,
};

/// Descriptor for `ExtendedService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List extendedServiceDescriptor = $convert.base64Decode(
    'Cg9FeHRlbmRlZFNlcnZpY2USZQoSU29sYXJUcmFuc3Bvc2l0aW9uEiYuZXh0ZW5kZWQudjEuU2'
    '9sYXJUcmFuc3Bvc2l0aW9uUmVxdWVzdBonLmV4dGVuZGVkLnYxLlNvbGFyVHJhbnNwb3NpdGlv'
    'blJlc3BvbnNlEl8KEEZpbmFuY2lhbE1ldHJpY3MSJC5leHRlbmRlZC52MS5GaW5hbmNpYWxNZX'
    'RyaWNzUmVxdWVzdBolLmV4dGVuZGVkLnYxLkZpbmFuY2lhbE1ldHJpY3NSZXNwb25zZRJ6ChlD'
    'b21wYXJlRmluYW5jaWFsU2NlbmFyaW9zEi0uZXh0ZW5kZWQudjEuQ29tcGFyZUZpbmFuY2lhbF'
    'NjZW5hcmlvc1JlcXVlc3QaLi5leHRlbmRlZC52MS5Db21wYXJlRmluYW5jaWFsU2NlbmFyaW9z'
    'UmVzcG9uc2USVgoNQ2xpbWF0ZUltcGFjdBIhLmV4dGVuZGVkLnYxLkNsaW1hdGVJbXBhY3RSZX'
    'F1ZXN0GiIuZXh0ZW5kZWQudjEuQ2xpbWF0ZUltcGFjdFJlc3BvbnNlEncKGFNhdmVGaW5hbmNp'
    'YWxTY2VuYXJpb1NldBIsLmV4dGVuZGVkLnYxLlNhdmVGaW5hbmNpYWxTY2VuYXJpb1NldFJlcX'
    'Vlc3QaLS5leHRlbmRlZC52MS5TYXZlRmluYW5jaWFsU2NlbmFyaW9TZXRSZXNwb25zZRJ0ChdH'
    'ZXRGaW5hbmNpYWxTY2VuYXJpb1NldBIrLmV4dGVuZGVkLnYxLkdldEZpbmFuY2lhbFNjZW5hcm'
    'lvU2V0UmVxdWVzdBosLmV4dGVuZGVkLnYxLkdldEZpbmFuY2lhbFNjZW5hcmlvU2V0UmVzcG9u'
    'c2USegoZTGlzdEZpbmFuY2lhbFNjZW5hcmlvU2V0cxItLmV4dGVuZGVkLnYxLkxpc3RGaW5hbm'
    'NpYWxTY2VuYXJpb1NldHNSZXF1ZXN0Gi4uZXh0ZW5kZWQudjEuTGlzdEZpbmFuY2lhbFNjZW5h'
    'cmlvU2V0c1Jlc3BvbnNlEowBCh9HZXRGaW5hbmNpYWxTY2VuYXJpb1NldFZlcnNpb25zEjMuZX'
    'h0ZW5kZWQudjEuR2V0RmluYW5jaWFsU2NlbmFyaW9TZXRWZXJzaW9uc1JlcXVlc3QaNC5leHRl'
    'bmRlZC52MS5HZXRGaW5hbmNpYWxTY2VuYXJpb1NldFZlcnNpb25zUmVzcG9uc2USdwoYQ2FsY3'
    'VsYXRlSW50ZXJSb3dTaGFkaW5nEiwuZXh0ZW5kZWQudjEuQ2FsY3VsYXRlSW50ZXJSb3dTaGFk'
    'aW5nUmVxdWVzdBotLmV4dGVuZGVkLnYxLkNhbGN1bGF0ZUludGVyUm93U2hhZGluZ1Jlc3Bvbn'
    'NlEnoKGUNhbGN1bGF0ZVlpZWxkVW5jZXJ0YWludHkSLS5leHRlbmRlZC52MS5DYWxjdWxhdGVZ'
    'aWVsZFVuY2VydGFpbnR5UmVxdWVzdBouLmV4dGVuZGVkLnYxLkNhbGN1bGF0ZVlpZWxkVW5jZX'
    'J0YWludHlSZXNwb25zZQ==');

