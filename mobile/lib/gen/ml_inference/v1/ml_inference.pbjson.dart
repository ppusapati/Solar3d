//
//  Generated code. Do not modify.
//  source: ml_inference/v1/ml_inference.proto
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
import 'features.pbjson.dart' as $2;

@$core.Deprecated('Use anomalyTypeDescriptor instead')
const AnomalyType$json = {
  '1': 'AnomalyType',
  '2': [
    {'1': 'NORMAL', '2': 0},
    {'1': 'SENSOR_FAULT', '2': 1},
    {'1': 'PERFORMANCE_DEGRADATION', '2': 2},
    {'1': 'INVERTER_ISSUE', '2': 3},
    {'1': 'STRING_MALFUNCTION', '2': 4},
    {'1': 'WEATHER_EVENT', '2': 5},
  ],
};

/// Descriptor for `AnomalyType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List anomalyTypeDescriptor = $convert.base64Decode(
    'CgtBbm9tYWx5VHlwZRIKCgZOT1JNQUwQABIQCgxTRU5TT1JfRkFVTFQQARIbChdQRVJGT1JNQU'
    '5DRV9ERUdSQURBVElPThACEhIKDklOVkVSVEVSX0lTU1VFEAMSFgoSU1RSSU5HX01BTEZVTkNU'
    'SU9OEAQSEQoNV0VBVEhFUl9FVkVOVBAF');

@$core.Deprecated('Use weatherFeaturesDescriptor instead')
const WeatherFeatures$json = {
  '1': 'WeatherFeatures',
  '2': [
    {'1': 'temperature_c', '3': 1, '4': 1, '5': 1, '10': 'temperatureC'},
    {'1': 'irradiance_w_m2', '3': 2, '4': 1, '5': 1, '10': 'irradianceWM2'},
    {'1': 'humidity_percent', '3': 3, '4': 1, '5': 1, '10': 'humidityPercent'},
    {'1': 'pressure_mb', '3': 4, '4': 1, '5': 1, '10': 'pressureMb'},
    {'1': 'wind_speed_m_s', '3': 5, '4': 1, '5': 1, '10': 'windSpeedMS'},
  ],
};

/// Descriptor for `WeatherFeatures`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List weatherFeaturesDescriptor = $convert.base64Decode(
    'Cg9XZWF0aGVyRmVhdHVyZXMSIwoNdGVtcGVyYXR1cmVfYxgBIAEoAVIMdGVtcGVyYXR1cmVDEi'
    'YKD2lycmFkaWFuY2Vfd19tMhgCIAEoAVINaXJyYWRpYW5jZVdNMhIpChBodW1pZGl0eV9wZXJj'
    'ZW50GAMgASgBUg9odW1pZGl0eVBlcmNlbnQSHwoLcHJlc3N1cmVfbWIYBCABKAFSCnByZXNzdX'
    'JlTWISIwoOd2luZF9zcGVlZF9tX3MYBSABKAFSC3dpbmRTcGVlZE1T');

@$core.Deprecated('Use solarFeaturesDescriptor instead')
const SolarFeatures$json = {
  '1': 'SolarFeatures',
  '2': [
    {'1': 'solar_altitude_deg', '3': 1, '4': 1, '5': 1, '10': 'solarAltitudeDeg'},
    {'1': 'solar_azimuth_deg', '3': 2, '4': 1, '5': 1, '10': 'solarAzimuthDeg'},
    {'1': 'air_mass', '3': 3, '4': 1, '5': 1, '10': 'airMass'},
    {'1': 'clearness_index', '3': 4, '4': 1, '5': 1, '10': 'clearnessIndex'},
  ],
};

/// Descriptor for `SolarFeatures`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List solarFeaturesDescriptor = $convert.base64Decode(
    'Cg1Tb2xhckZlYXR1cmVzEiwKEnNvbGFyX2FsdGl0dWRlX2RlZxgBIAEoAVIQc29sYXJBbHRpdH'
    'VkZURlZxIqChFzb2xhcl9hemltdXRoX2RlZxgCIAEoAVIPc29sYXJBemltdXRoRGVnEhkKCGFp'
    'cl9tYXNzGAMgASgBUgdhaXJNYXNzEicKD2NsZWFybmVzc19pbmRleBgEIAEoAVIOY2xlYXJuZX'
    'NzSW5kZXg=');

@$core.Deprecated('Use timeFeaturesDescriptor instead')
const TimeFeatures$json = {
  '1': 'TimeFeatures',
  '2': [
    {'1': 'hour_of_day', '3': 1, '4': 1, '5': 5, '10': 'hourOfDay'},
    {'1': 'day_of_year', '3': 2, '4': 1, '5': 5, '10': 'dayOfYear'},
    {'1': 'month', '3': 3, '4': 1, '5': 5, '10': 'month'},
    {'1': 'is_weekend', '3': 4, '4': 1, '5': 8, '10': 'isWeekend'},
  ],
};

/// Descriptor for `TimeFeatures`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timeFeaturesDescriptor = $convert.base64Decode(
    'CgxUaW1lRmVhdHVyZXMSHgoLaG91cl9vZl9kYXkYASABKAVSCWhvdXJPZkRheRIeCgtkYXlfb2'
    'ZfeWVhchgCIAEoBVIJZGF5T2ZZZWFyEhQKBW1vbnRoGAMgASgFUgVtb250aBIdCgppc193ZWVr'
    'ZW5kGAQgASgIUglpc1dlZWtlbmQ=');

@$core.Deprecated('Use featureVectorDescriptor instead')
const FeatureVector$json = {
  '1': 'FeatureVector',
  '2': [
    {'1': 'features', '3': 1, '4': 3, '5': 1, '10': 'features'},
    {'1': 'feature_names', '3': 2, '4': 3, '5': 9, '10': 'featureNames'},
  ],
};

/// Descriptor for `FeatureVector`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureVectorDescriptor = $convert.base64Decode(
    'Cg1GZWF0dXJlVmVjdG9yEhoKCGZlYXR1cmVzGAEgAygBUghmZWF0dXJlcxIjCg1mZWF0dXJlX2'
    '5hbWVzGAIgAygJUgxmZWF0dXJlTmFtZXM=');

@$core.Deprecated('Use featureExtractionRequestDescriptor instead')
const FeatureExtractionRequest$json = {
  '1': 'FeatureExtractionRequest',
  '2': [
    {'1': 'weather', '3': 1, '4': 1, '5': 11, '6': '.ml_inference.v1.WeatherFeatures', '10': 'weather'},
    {'1': 'solar', '3': 2, '4': 1, '5': 11, '6': '.ml_inference.v1.SolarFeatures', '10': 'solar'},
    {'1': 'time', '3': 3, '4': 1, '5': 11, '6': '.ml_inference.v1.TimeFeatures', '10': 'time'},
  ],
};

/// Descriptor for `FeatureExtractionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureExtractionRequestDescriptor = $convert.base64Decode(
    'ChhGZWF0dXJlRXh0cmFjdGlvblJlcXVlc3QSOgoHd2VhdGhlchgBIAEoCzIgLm1sX2luZmVyZW'
    '5jZS52MS5XZWF0aGVyRmVhdHVyZXNSB3dlYXRoZXISNAoFc29sYXIYAiABKAsyHi5tbF9pbmZl'
    'cmVuY2UudjEuU29sYXJGZWF0dXJlc1IFc29sYXISMQoEdGltZRgDIAEoCzIdLm1sX2luZmVyZW'
    '5jZS52MS5UaW1lRmVhdHVyZXNSBHRpbWU=');

@$core.Deprecated('Use featureExtractionResponseDescriptor instead')
const FeatureExtractionResponse$json = {
  '1': 'FeatureExtractionResponse',
  '2': [
    {'1': 'features', '3': 1, '4': 1, '5': 11, '6': '.ml_inference.v1.FeatureVector', '10': 'features'},
    {'1': 'feature_count', '3': 2, '4': 1, '5': 5, '10': 'featureCount'},
    {'1': 'payload', '3': 10, '4': 1, '5': 11, '6': '.ml_inference.v1.FeaturePayload', '10': 'payload'},
  ],
};

/// Descriptor for `FeatureExtractionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List featureExtractionResponseDescriptor = $convert.base64Decode(
    'ChlGZWF0dXJlRXh0cmFjdGlvblJlc3BvbnNlEjoKCGZlYXR1cmVzGAEgASgLMh4ubWxfaW5mZX'
    'JlbmNlLnYxLkZlYXR1cmVWZWN0b3JSCGZlYXR1cmVzEiMKDWZlYXR1cmVfY291bnQYAiABKAVS'
    'DGZlYXR1cmVDb3VudBI5CgdwYXlsb2FkGAogASgLMh8ubWxfaW5mZXJlbmNlLnYxLkZlYXR1cm'
    'VQYXlsb2FkUgdwYXlsb2Fk');

@$core.Deprecated('Use yieldPredictionRequestDescriptor instead')
const YieldPredictionRequest$json = {
  '1': 'YieldPredictionRequest',
  '2': [
    {'1': 'features', '3': 1, '4': 1, '5': 11, '6': '.ml_inference.v1.FeatureVector', '10': 'features'},
    {'1': 'model_output', '3': 2, '4': 1, '5': 1, '10': 'modelOutput'},
    {'1': 'uncertainty_estimate', '3': 3, '4': 1, '5': 1, '10': 'uncertaintyEstimate'},
    {'1': 'feature_payload', '3': 10, '4': 1, '5': 11, '6': '.ml_inference.v1.FeaturePayload', '10': 'featurePayload'},
  ],
};

/// Descriptor for `YieldPredictionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List yieldPredictionRequestDescriptor = $convert.base64Decode(
    'ChZZaWVsZFByZWRpY3Rpb25SZXF1ZXN0EjoKCGZlYXR1cmVzGAEgASgLMh4ubWxfaW5mZXJlbm'
    'NlLnYxLkZlYXR1cmVWZWN0b3JSCGZlYXR1cmVzEiEKDG1vZGVsX291dHB1dBgCIAEoAVILbW9k'
    'ZWxPdXRwdXQSMQoUdW5jZXJ0YWludHlfZXN0aW1hdGUYAyABKAFSE3VuY2VydGFpbnR5RXN0aW'
    '1hdGUSSAoPZmVhdHVyZV9wYXlsb2FkGAogASgLMh8ubWxfaW5mZXJlbmNlLnYxLkZlYXR1cmVQ'
    'YXlsb2FkUg5mZWF0dXJlUGF5bG9hZA==');

@$core.Deprecated('Use yieldForecastDescriptor instead')
const YieldForecast$json = {
  '1': 'YieldForecast',
  '2': [
    {'1': 'predicted_yield_kwh', '3': 1, '4': 1, '5': 1, '10': 'predictedYieldKwh'},
    {'1': 'confidence_lower', '3': 2, '4': 1, '5': 1, '10': 'confidenceLower'},
    {'1': 'confidence_upper', '3': 3, '4': 1, '5': 1, '10': 'confidenceUpper'},
    {'1': 'expected_value', '3': 4, '4': 1, '5': 1, '10': 'expectedValue'},
    {'1': 'variance', '3': 5, '4': 1, '5': 1, '10': 'variance'},
  ],
};

/// Descriptor for `YieldForecast`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List yieldForecastDescriptor = $convert.base64Decode(
    'Cg1ZaWVsZEZvcmVjYXN0Ei4KE3ByZWRpY3RlZF95aWVsZF9rd2gYASABKAFSEXByZWRpY3RlZF'
    'lpZWxkS3doEikKEGNvbmZpZGVuY2VfbG93ZXIYAiABKAFSD2NvbmZpZGVuY2VMb3dlchIpChBj'
    'b25maWRlbmNlX3VwcGVyGAMgASgBUg9jb25maWRlbmNlVXBwZXISJQoOZXhwZWN0ZWRfdmFsdW'
    'UYBCABKAFSDWV4cGVjdGVkVmFsdWUSGgoIdmFyaWFuY2UYBSABKAFSCHZhcmlhbmNl');

@$core.Deprecated('Use yieldPredictionResponseDescriptor instead')
const YieldPredictionResponse$json = {
  '1': 'YieldPredictionResponse',
  '2': [
    {'1': 'forecast', '3': 1, '4': 1, '5': 11, '6': '.ml_inference.v1.YieldForecast', '10': 'forecast'},
    {'1': 'ensemble_forecasts', '3': 2, '4': 3, '5': 11, '6': '.ml_inference.v1.YieldForecast', '10': 'ensembleForecasts'},
  ],
};

/// Descriptor for `YieldPredictionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List yieldPredictionResponseDescriptor = $convert.base64Decode(
    'ChdZaWVsZFByZWRpY3Rpb25SZXNwb25zZRI6Cghmb3JlY2FzdBgBIAEoCzIeLm1sX2luZmVyZW'
    '5jZS52MS5ZaWVsZEZvcmVjYXN0Ughmb3JlY2FzdBJNChJlbnNlbWJsZV9mb3JlY2FzdHMYAiAD'
    'KAsyHi5tbF9pbmZlcmVuY2UudjEuWWllbGRGb3JlY2FzdFIRZW5zZW1ibGVGb3JlY2FzdHM=');

@$core.Deprecated('Use anomalyScoreDescriptor instead')
const AnomalyScore$json = {
  '1': 'AnomalyScore',
  '2': [
    {'1': 'score', '3': 1, '4': 1, '5': 1, '10': 'score'},
    {'1': 'anomaly_type', '3': 2, '4': 1, '5': 14, '6': '.ml_inference.v1.AnomalyType', '10': 'anomalyType'},
    {'1': 'confidence', '3': 3, '4': 1, '5': 1, '10': 'confidence'},
  ],
};

/// Descriptor for `AnomalyScore`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List anomalyScoreDescriptor = $convert.base64Decode(
    'CgxBbm9tYWx5U2NvcmUSFAoFc2NvcmUYASABKAFSBXNjb3JlEj8KDGFub21hbHlfdHlwZRgCIA'
    'EoDjIcLm1sX2luZmVyZW5jZS52MS5Bbm9tYWx5VHlwZVILYW5vbWFseVR5cGUSHgoKY29uZmlk'
    'ZW5jZRgDIAEoAVIKY29uZmlkZW5jZQ==');

@$core.Deprecated('Use anomalyDetectionRequestDescriptor instead')
const AnomalyDetectionRequest$json = {
  '1': 'AnomalyDetectionRequest',
  '2': [
    {'1': 'expected_yield', '3': 1, '4': 1, '5': 1, '10': 'expectedYield'},
    {'1': 'actual_yield', '3': 2, '4': 1, '5': 1, '10': 'actualYield'},
    {'1': 'model_prediction', '3': 3, '4': 1, '5': 1, '10': 'modelPrediction'},
    {'1': 'sensor_variance', '3': 4, '4': 1, '5': 1, '10': 'sensorVariance'},
  ],
};

/// Descriptor for `AnomalyDetectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List anomalyDetectionRequestDescriptor = $convert.base64Decode(
    'ChdBbm9tYWx5RGV0ZWN0aW9uUmVxdWVzdBIlCg5leHBlY3RlZF95aWVsZBgBIAEoAVINZXhwZW'
    'N0ZWRZaWVsZBIhCgxhY3R1YWxfeWllbGQYAiABKAFSC2FjdHVhbFlpZWxkEikKEG1vZGVsX3By'
    'ZWRpY3Rpb24YAyABKAFSD21vZGVsUHJlZGljdGlvbhInCg9zZW5zb3JfdmFyaWFuY2UYBCABKA'
    'FSDnNlbnNvclZhcmlhbmNl');

@$core.Deprecated('Use anomalyDetectionResponseDescriptor instead')
const AnomalyDetectionResponse$json = {
  '1': 'AnomalyDetectionResponse',
  '2': [
    {'1': 'score', '3': 1, '4': 1, '5': 11, '6': '.ml_inference.v1.AnomalyScore', '10': 'score'},
    {'1': 'is_anomalous', '3': 2, '4': 1, '5': 8, '10': 'isAnomalous'},
    {'1': 'recommendation', '3': 3, '4': 1, '5': 9, '10': 'recommendation'},
  ],
};

/// Descriptor for `AnomalyDetectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List anomalyDetectionResponseDescriptor = $convert.base64Decode(
    'ChhBbm9tYWx5RGV0ZWN0aW9uUmVzcG9uc2USMwoFc2NvcmUYASABKAsyHS5tbF9pbmZlcmVuY2'
    'UudjEuQW5vbWFseVNjb3JlUgVzY29yZRIhCgxpc19hbm9tYWxvdXMYAiABKAhSC2lzQW5vbWFs'
    'b3VzEiYKDnJlY29tbWVuZGF0aW9uGAMgASgJUg5yZWNvbW1lbmRhdGlvbg==');

@$core.Deprecated('Use degradationForecastDescriptor instead')
const DegradationForecast$json = {
  '1': 'DegradationForecast',
  '2': [
    {'1': 'current_degradation_percent', '3': 1, '4': 1, '5': 1, '10': 'currentDegradationPercent'},
    {'1': 'annual_degradation_rate', '3': 2, '4': 1, '5': 1, '10': 'annualDegradationRate'},
    {'1': 'projected_degradation_5yr', '3': 3, '4': 1, '5': 1, '10': 'projectedDegradation5yr'},
    {'1': 'projected_degradation_10yr', '3': 4, '4': 1, '5': 1, '10': 'projectedDegradation10yr'},
    {'1': 'confidence_interval', '3': 5, '4': 1, '5': 1, '10': 'confidenceInterval'},
  ],
};

/// Descriptor for `DegradationForecast`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List degradationForecastDescriptor = $convert.base64Decode(
    'ChNEZWdyYWRhdGlvbkZvcmVjYXN0Ej4KG2N1cnJlbnRfZGVncmFkYXRpb25fcGVyY2VudBgBIA'
    'EoAVIZY3VycmVudERlZ3JhZGF0aW9uUGVyY2VudBI2Chdhbm51YWxfZGVncmFkYXRpb25fcmF0'
    'ZRgCIAEoAVIVYW5udWFsRGVncmFkYXRpb25SYXRlEjoKGXByb2plY3RlZF9kZWdyYWRhdGlvbl'
    '81eXIYAyABKAFSF3Byb2plY3RlZERlZ3JhZGF0aW9uNXlyEjwKGnByb2plY3RlZF9kZWdyYWRh'
    'dGlvbl8xMHlyGAQgASgBUhhwcm9qZWN0ZWREZWdyYWRhdGlvbjEweXISLwoTY29uZmlkZW5jZV'
    '9pbnRlcnZhbBgFIAEoAVISY29uZmlkZW5jZUludGVydmFs');

@$core.Deprecated('Use degradationRequestDescriptor instead')
const DegradationRequest$json = {
  '1': 'DegradationRequest',
  '2': [
    {'1': 'current_degradation', '3': 1, '4': 1, '5': 1, '10': 'currentDegradation'},
    {'1': 'annual_rate', '3': 2, '4': 1, '5': 1, '10': 'annualRate'},
    {'1': 'years', '3': 3, '4': 1, '5': 5, '10': 'years'},
  ],
};

/// Descriptor for `DegradationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List degradationRequestDescriptor = $convert.base64Decode(
    'ChJEZWdyYWRhdGlvblJlcXVlc3QSLwoTY3VycmVudF9kZWdyYWRhdGlvbhgBIAEoAVISY3Vycm'
    'VudERlZ3JhZGF0aW9uEh8KC2FubnVhbF9yYXRlGAIgASgBUgphbm51YWxSYXRlEhQKBXllYXJz'
    'GAMgASgFUgV5ZWFycw==');

@$core.Deprecated('Use degradationResponseDescriptor instead')
const DegradationResponse$json = {
  '1': 'DegradationResponse',
  '2': [
    {'1': 'forecast', '3': 1, '4': 1, '5': 11, '6': '.ml_inference.v1.DegradationForecast', '10': 'forecast'},
    {'1': 'remaining_useful_life_years', '3': 2, '4': 1, '5': 1, '10': 'remainingUsefulLifeYears'},
  ],
};

/// Descriptor for `DegradationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List degradationResponseDescriptor = $convert.base64Decode(
    'ChNEZWdyYWRhdGlvblJlc3BvbnNlEkAKCGZvcmVjYXN0GAEgASgLMiQubWxfaW5mZXJlbmNlLn'
    'YxLkRlZ3JhZGF0aW9uRm9yZWNhc3RSCGZvcmVjYXN0Ej0KG3JlbWFpbmluZ191c2VmdWxfbGlm'
    'ZV95ZWFycxgCIAEoAVIYcmVtYWluaW5nVXNlZnVsTGlmZVllYXJz');

@$core.Deprecated('Use submitFeedbackRequestDescriptor instead')
const SubmitFeedbackRequest$json = {
  '1': 'SubmitFeedbackRequest',
  '2': [
    {'1': 'prediction_id', '3': 1, '4': 1, '5': 9, '10': 'predictionId'},
    {'1': 'site_id', '3': 2, '4': 1, '5': 9, '10': 'siteId'},
    {'1': 'task_type', '3': 3, '4': 1, '5': 9, '10': 'taskType'},
    {'1': 'actual_label', '3': 4, '4': 1, '5': 1, '10': 'actualLabel'},
    {'1': 'notes', '3': 5, '4': 1, '5': 9, '10': 'notes'},
    {'1': 'submitted_by', '3': 6, '4': 1, '5': 9, '10': 'submittedBy'},
    {'1': 'sample', '3': 10, '4': 1, '5': 11, '6': '.ml_inference.v1.LabeledFeatureSample', '10': 'sample'},
  ],
};

/// Descriptor for `SubmitFeedbackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitFeedbackRequestDescriptor = $convert.base64Decode(
    'ChVTdWJtaXRGZWVkYmFja1JlcXVlc3QSIwoNcHJlZGljdGlvbl9pZBgBIAEoCVIMcHJlZGljdG'
    'lvbklkEhcKB3NpdGVfaWQYAiABKAlSBnNpdGVJZBIbCgl0YXNrX3R5cGUYAyABKAlSCHRhc2tU'
    'eXBlEiEKDGFjdHVhbF9sYWJlbBgEIAEoAVILYWN0dWFsTGFiZWwSFAoFbm90ZXMYBSABKAlSBW'
    '5vdGVzEiEKDHN1Ym1pdHRlZF9ieRgGIAEoCVILc3VibWl0dGVkQnkSPQoGc2FtcGxlGAogASgL'
    'MiUubWxfaW5mZXJlbmNlLnYxLkxhYmVsZWRGZWF0dXJlU2FtcGxlUgZzYW1wbGU=');

@$core.Deprecated('Use submitFeedbackResponseDescriptor instead')
const SubmitFeedbackResponse$json = {
  '1': 'SubmitFeedbackResponse',
  '2': [
    {'1': 'feedback_id', '3': 1, '4': 1, '5': 9, '10': 'feedbackId'},
    {'1': 'accepted', '3': 2, '4': 1, '5': 8, '10': 'accepted'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `SubmitFeedbackResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List submitFeedbackResponseDescriptor = $convert.base64Decode(
    'ChZTdWJtaXRGZWVkYmFja1Jlc3BvbnNlEh8KC2ZlZWRiYWNrX2lkGAEgASgJUgpmZWVkYmFja0'
    'lkEhoKCGFjY2VwdGVkGAIgASgIUghhY2NlcHRlZBIYCgdtZXNzYWdlGAMgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use trainingDataConfigDescriptor instead')
const TrainingDataConfig$json = {
  '1': 'TrainingDataConfig',
  '2': [
    {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
    {'1': 'lookback_days', '3': 2, '4': 1, '5': 5, '10': 'lookbackDays'},
    {'1': 'min_samples_per_site', '3': 3, '4': 1, '5': 5, '10': 'minSamplesPerSite'},
    {'1': 'train_split_ratio', '3': 4, '4': 1, '5': 1, '10': 'trainSplitRatio'},
    {'1': 'validation_split_ratio', '3': 5, '4': 1, '5': 1, '10': 'validationSplitRatio'},
    {'1': 'test_split_ratio', '3': 6, '4': 1, '5': 1, '10': 'testSplitRatio'},
    {'1': 'time_aware_split', '3': 7, '4': 1, '5': 8, '10': 'timeAwareSplit'},
    {'1': 'feature_schema_hash', '3': 8, '4': 1, '5': 9, '10': 'featureSchemaHash'},
    {'1': 'feature_schema', '3': 10, '4': 1, '5': 11, '6': '.ml_inference.v1.FeatureSchema', '10': 'featureSchema'},
  ],
};

/// Descriptor for `TrainingDataConfig`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trainingDataConfigDescriptor = $convert.base64Decode(
    'ChJUcmFpbmluZ0RhdGFDb25maWcSGAoHdmVyc2lvbhgBIAEoCVIHdmVyc2lvbhIjCg1sb29rYm'
    'Fja19kYXlzGAIgASgFUgxsb29rYmFja0RheXMSLwoUbWluX3NhbXBsZXNfcGVyX3NpdGUYAyAB'
    'KAVSEW1pblNhbXBsZXNQZXJTaXRlEioKEXRyYWluX3NwbGl0X3JhdGlvGAQgASgBUg90cmFpbl'
    'NwbGl0UmF0aW8SNAoWdmFsaWRhdGlvbl9zcGxpdF9yYXRpbxgFIAEoAVIUdmFsaWRhdGlvblNw'
    'bGl0UmF0aW8SKAoQdGVzdF9zcGxpdF9yYXRpbxgGIAEoAVIOdGVzdFNwbGl0UmF0aW8SKAoQdG'
    'ltZV9hd2FyZV9zcGxpdBgHIAEoCFIOdGltZUF3YXJlU3BsaXQSLgoTZmVhdHVyZV9zY2hlbWFf'
    'aGFzaBgIIAEoCVIRZmVhdHVyZVNjaGVtYUhhc2gSRQoOZmVhdHVyZV9zY2hlbWEYCiABKAsyHi'
    '5tbF9pbmZlcmVuY2UudjEuRmVhdHVyZVNjaGVtYVINZmVhdHVyZVNjaGVtYQ==');

@$core.Deprecated('Use startTrainingRequestDescriptor instead')
const StartTrainingRequest$json = {
  '1': 'StartTrainingRequest',
  '2': [
    {'1': 'task_type', '3': 1, '4': 1, '5': 9, '10': 'taskType'},
    {'1': 'config', '3': 2, '4': 1, '5': 11, '6': '.ml_inference.v1.TrainingDataConfig', '10': 'config'},
    {'1': 'hyperparams', '3': 3, '4': 3, '5': 11, '6': '.ml_inference.v1.StartTrainingRequest.HyperparamsEntry', '10': 'hyperparams'},
    {'1': 'triggered_by', '3': 4, '4': 1, '5': 9, '10': 'triggeredBy'},
    {'1': 'commit_hash', '3': 5, '4': 1, '5': 9, '10': 'commitHash'},
    {'1': 'expected_schema', '3': 10, '4': 1, '5': 11, '6': '.ml_inference.v1.FeatureSchema', '10': 'expectedSchema'},
  ],
  '3': [StartTrainingRequest_HyperparamsEntry$json],
};

@$core.Deprecated('Use startTrainingRequestDescriptor instead')
const StartTrainingRequest_HyperparamsEntry$json = {
  '1': 'HyperparamsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `StartTrainingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startTrainingRequestDescriptor = $convert.base64Decode(
    'ChRTdGFydFRyYWluaW5nUmVxdWVzdBIbCgl0YXNrX3R5cGUYASABKAlSCHRhc2tUeXBlEjsKBm'
    'NvbmZpZxgCIAEoCzIjLm1sX2luZmVyZW5jZS52MS5UcmFpbmluZ0RhdGFDb25maWdSBmNvbmZp'
    'ZxJYCgtoeXBlcnBhcmFtcxgDIAMoCzI2Lm1sX2luZmVyZW5jZS52MS5TdGFydFRyYWluaW5nUm'
    'VxdWVzdC5IeXBlcnBhcmFtc0VudHJ5UgtoeXBlcnBhcmFtcxIhCgx0cmlnZ2VyZWRfYnkYBCAB'
    'KAlSC3RyaWdnZXJlZEJ5Eh8KC2NvbW1pdF9oYXNoGAUgASgJUgpjb21taXRIYXNoEkcKD2V4cG'
    'VjdGVkX3NjaGVtYRgKIAEoCzIeLm1sX2luZmVyZW5jZS52MS5GZWF0dXJlU2NoZW1hUg5leHBl'
    'Y3RlZFNjaGVtYRo+ChBIeXBlcnBhcmFtc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbH'
    'VlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use startTrainingResponseDescriptor instead')
const StartTrainingResponse$json = {
  '1': 'StartTrainingResponse',
  '2': [
    {'1': 'training_run_id', '3': 1, '4': 1, '5': 9, '10': 'trainingRunId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'queued_at_ms', '3': 3, '4': 1, '5': 3, '10': 'queuedAtMs'},
  ],
};

/// Descriptor for `StartTrainingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List startTrainingResponseDescriptor = $convert.base64Decode(
    'ChVTdGFydFRyYWluaW5nUmVzcG9uc2USJgoPdHJhaW5pbmdfcnVuX2lkGAEgASgJUg10cmFpbm'
    'luZ1J1bklkEhYKBnN0YXR1cxgCIAEoCVIGc3RhdHVzEiAKDHF1ZXVlZF9hdF9tcxgDIAEoA1IK'
    'cXVldWVkQXRNcw==');

@$core.Deprecated('Use getTrainingStatusRequestDescriptor instead')
const GetTrainingStatusRequest$json = {
  '1': 'GetTrainingStatusRequest',
  '2': [
    {'1': 'training_run_id', '3': 1, '4': 1, '5': 9, '10': 'trainingRunId'},
  ],
};

/// Descriptor for `GetTrainingStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTrainingStatusRequestDescriptor = $convert.base64Decode(
    'ChhHZXRUcmFpbmluZ1N0YXR1c1JlcXVlc3QSJgoPdHJhaW5pbmdfcnVuX2lkGAEgASgJUg10cm'
    'FpbmluZ1J1bklk');

@$core.Deprecated('Use trainingMetricsDescriptor instead')
const TrainingMetrics$json = {
  '1': 'TrainingMetrics',
  '2': [
    {'1': 'train_loss', '3': 1, '4': 1, '5': 1, '10': 'trainLoss'},
    {'1': 'validation_loss', '3': 2, '4': 1, '5': 1, '10': 'validationLoss'},
    {'1': 'test_loss', '3': 3, '4': 1, '5': 1, '10': 'testLoss'},
    {'1': 'test_mae', '3': 4, '4': 1, '5': 1, '10': 'testMae'},
    {'1': 'test_rmse', '3': 5, '4': 1, '5': 1, '10': 'testRmse'},
    {'1': 'test_coverage_lower', '3': 6, '4': 1, '5': 1, '10': 'testCoverageLower'},
    {'1': 'test_coverage_upper', '3': 7, '4': 1, '5': 1, '10': 'testCoverageUpper'},
    {'1': 'custom_metrics', '3': 8, '4': 3, '5': 11, '6': '.ml_inference.v1.TrainingMetrics.CustomMetricsEntry', '10': 'customMetrics'},
  ],
  '3': [TrainingMetrics_CustomMetricsEntry$json],
};

@$core.Deprecated('Use trainingMetricsDescriptor instead')
const TrainingMetrics_CustomMetricsEntry$json = {
  '1': 'CustomMetricsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 1, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `TrainingMetrics`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trainingMetricsDescriptor = $convert.base64Decode(
    'Cg9UcmFpbmluZ01ldHJpY3MSHQoKdHJhaW5fbG9zcxgBIAEoAVIJdHJhaW5Mb3NzEicKD3ZhbG'
    'lkYXRpb25fbG9zcxgCIAEoAVIOdmFsaWRhdGlvbkxvc3MSGwoJdGVzdF9sb3NzGAMgASgBUgh0'
    'ZXN0TG9zcxIZCgh0ZXN0X21hZRgEIAEoAVIHdGVzdE1hZRIbCgl0ZXN0X3Jtc2UYBSABKAFSCH'
    'Rlc3RSbXNlEi4KE3Rlc3RfY292ZXJhZ2VfbG93ZXIYBiABKAFSEXRlc3RDb3ZlcmFnZUxvd2Vy'
    'Ei4KE3Rlc3RfY292ZXJhZ2VfdXBwZXIYByABKAFSEXRlc3RDb3ZlcmFnZVVwcGVyEloKDmN1c3'
    'RvbV9tZXRyaWNzGAggAygLMjMubWxfaW5mZXJlbmNlLnYxLlRyYWluaW5nTWV0cmljcy5DdXN0'
    'b21NZXRyaWNzRW50cnlSDWN1c3RvbU1ldHJpY3MaQAoSQ3VzdG9tTWV0cmljc0VudHJ5EhAKA2'
    'tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgBUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use getTrainingStatusResponseDescriptor instead')
const GetTrainingStatusResponse$json = {
  '1': 'GetTrainingStatusResponse',
  '2': [
    {'1': 'training_run_id', '3': 1, '4': 1, '5': 9, '10': 'trainingRunId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'metrics', '3': 3, '4': 1, '5': 11, '6': '.ml_inference.v1.TrainingMetrics', '10': 'metrics'},
    {'1': 'error_message', '3': 4, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'started_at_ms', '3': 5, '4': 1, '5': 3, '10': 'startedAtMs'},
    {'1': 'completed_at_ms', '3': 6, '4': 1, '5': 3, '10': 'completedAtMs'},
    {'1': 'model_version_id', '3': 7, '4': 1, '5': 9, '10': 'modelVersionId'},
    {'1': 'completion_progress', '3': 8, '4': 1, '5': 1, '10': 'completionProgress'},
  ],
};

/// Descriptor for `GetTrainingStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTrainingStatusResponseDescriptor = $convert.base64Decode(
    'ChlHZXRUcmFpbmluZ1N0YXR1c1Jlc3BvbnNlEiYKD3RyYWluaW5nX3J1bl9pZBgBIAEoCVINdH'
    'JhaW5pbmdSdW5JZBIWCgZzdGF0dXMYAiABKAlSBnN0YXR1cxI6CgdtZXRyaWNzGAMgASgLMiAu'
    'bWxfaW5mZXJlbmNlLnYxLlRyYWluaW5nTWV0cmljc1IHbWV0cmljcxIjCg1lcnJvcl9tZXNzYW'
    'dlGAQgASgJUgxlcnJvck1lc3NhZ2USIgoNc3RhcnRlZF9hdF9tcxgFIAEoA1ILc3RhcnRlZEF0'
    'TXMSJgoPY29tcGxldGVkX2F0X21zGAYgASgDUg1jb21wbGV0ZWRBdE1zEigKEG1vZGVsX3Zlcn'
    'Npb25faWQYByABKAlSDm1vZGVsVmVyc2lvbklkEi8KE2NvbXBsZXRpb25fcHJvZ3Jlc3MYCCAB'
    'KAFSEmNvbXBsZXRpb25Qcm9ncmVzcw==');

@$core.Deprecated('Use evaluateModelRequestDescriptor instead')
const EvaluateModelRequest$json = {
  '1': 'EvaluateModelRequest',
  '2': [
    {'1': 'model_version_id', '3': 1, '4': 1, '5': 9, '10': 'modelVersionId'},
    {'1': 'dataset', '3': 2, '4': 1, '5': 9, '10': 'dataset'},
    {'1': 'versus_model_id', '3': 3, '4': 1, '5': 9, '10': 'versusModelId'},
  ],
};

/// Descriptor for `EvaluateModelRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateModelRequestDescriptor = $convert.base64Decode(
    'ChRFdmFsdWF0ZU1vZGVsUmVxdWVzdBIoChBtb2RlbF92ZXJzaW9uX2lkGAEgASgJUg5tb2RlbF'
    'ZlcnNpb25JZBIYCgdkYXRhc2V0GAIgASgJUgdkYXRhc2V0EiYKD3ZlcnN1c19tb2RlbF9pZBgD'
    'IAEoCVINdmVyc3VzTW9kZWxJZA==');

@$core.Deprecated('Use modelEvaluationDescriptor instead')
const ModelEvaluation$json = {
  '1': 'ModelEvaluation',
  '2': [
    {'1': 'model_version_id', '3': 1, '4': 1, '5': 9, '10': 'modelVersionId'},
    {'1': 'versus_model_id', '3': 2, '4': 1, '5': 9, '10': 'versusModelId'},
    {'1': 'metric_name', '3': 3, '4': 1, '5': 9, '10': 'metricName'},
    {'1': 'baseline_value', '3': 4, '4': 1, '5': 1, '10': 'baselineValue'},
    {'1': 'candidate_value', '3': 5, '4': 1, '5': 1, '10': 'candidateValue'},
    {'1': 'improvement_percent', '3': 6, '4': 1, '5': 1, '10': 'improvementPercent'},
    {'1': 'meets_threshold', '3': 7, '4': 1, '5': 8, '10': 'meetsThreshold'},
  ],
};

/// Descriptor for `ModelEvaluation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modelEvaluationDescriptor = $convert.base64Decode(
    'Cg9Nb2RlbEV2YWx1YXRpb24SKAoQbW9kZWxfdmVyc2lvbl9pZBgBIAEoCVIObW9kZWxWZXJzaW'
    '9uSWQSJgoPdmVyc3VzX21vZGVsX2lkGAIgASgJUg12ZXJzdXNNb2RlbElkEh8KC21ldHJpY19u'
    'YW1lGAMgASgJUgptZXRyaWNOYW1lEiUKDmJhc2VsaW5lX3ZhbHVlGAQgASgBUg1iYXNlbGluZV'
    'ZhbHVlEicKD2NhbmRpZGF0ZV92YWx1ZRgFIAEoAVIOY2FuZGlkYXRlVmFsdWUSLwoTaW1wcm92'
    'ZW1lbnRfcGVyY2VudBgGIAEoAVISaW1wcm92ZW1lbnRQZXJjZW50EicKD21lZXRzX3RocmVzaG'
    '9sZBgHIAEoCFIObWVldHNUaHJlc2hvbGQ=');

@$core.Deprecated('Use evaluateModelResponseDescriptor instead')
const EvaluateModelResponse$json = {
  '1': 'EvaluateModelResponse',
  '2': [
    {'1': 'evaluations', '3': 1, '4': 3, '5': 11, '6': '.ml_inference.v1.ModelEvaluation', '10': 'evaluations'},
    {'1': 'candidate_wins', '3': 2, '4': 1, '5': 8, '10': 'candidateWins'},
    {'1': 'recommendation', '3': 3, '4': 1, '5': 9, '10': 'recommendation'},
  ],
};

/// Descriptor for `EvaluateModelResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List evaluateModelResponseDescriptor = $convert.base64Decode(
    'ChVFdmFsdWF0ZU1vZGVsUmVzcG9uc2USQgoLZXZhbHVhdGlvbnMYASADKAsyIC5tbF9pbmZlcm'
    'VuY2UudjEuTW9kZWxFdmFsdWF0aW9uUgtldmFsdWF0aW9ucxIlCg5jYW5kaWRhdGVfd2lucxgC'
    'IAEoCFINY2FuZGlkYXRlV2lucxImCg5yZWNvbW1lbmRhdGlvbhgDIAEoCVIOcmVjb21tZW5kYX'
    'Rpb24=');

@$core.Deprecated('Use modelVersionInfoDescriptor instead')
const ModelVersionInfo$json = {
  '1': 'ModelVersionInfo',
  '2': [
    {'1': 'version_id', '3': 1, '4': 1, '5': 9, '10': 'versionId'},
    {'1': 'task_type', '3': 2, '4': 1, '5': 9, '10': 'taskType'},
    {'1': 'status', '3': 3, '4': 1, '5': 9, '10': 'status'},
    {'1': 'created_at_ms', '3': 4, '4': 1, '5': 3, '10': 'createdAtMs'},
    {'1': 'deployed_at_ms', '3': 5, '4': 1, '5': 3, '10': 'deployedAtMs'},
    {'1': 'metrics', '3': 6, '4': 1, '5': 11, '6': '.ml_inference.v1.TrainingMetrics', '10': 'metrics'},
    {'1': 'artifact_path', '3': 7, '4': 1, '5': 9, '10': 'artifactPath'},
    {'1': 'artifact_hash', '3': 8, '4': 1, '5': 9, '10': 'artifactHash'},
    {'1': 'schema_hash', '3': 9, '4': 1, '5': 9, '10': 'schemaHash'},
    {'1': 'training_run_id', '3': 10, '4': 1, '5': 9, '10': 'trainingRunId'},
    {'1': 'commit_hash', '3': 11, '4': 1, '5': 9, '10': 'commitHash'},
    {'1': 'metadata', '3': 12, '4': 3, '5': 11, '6': '.ml_inference.v1.ModelVersionInfo.MetadataEntry', '10': 'metadata'},
  ],
  '3': [ModelVersionInfo_MetadataEntry$json],
};

@$core.Deprecated('Use modelVersionInfoDescriptor instead')
const ModelVersionInfo_MetadataEntry$json = {
  '1': 'MetadataEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `ModelVersionInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List modelVersionInfoDescriptor = $convert.base64Decode(
    'ChBNb2RlbFZlcnNpb25JbmZvEh0KCnZlcnNpb25faWQYASABKAlSCXZlcnNpb25JZBIbCgl0YX'
    'NrX3R5cGUYAiABKAlSCHRhc2tUeXBlEhYKBnN0YXR1cxgDIAEoCVIGc3RhdHVzEiIKDWNyZWF0'
    'ZWRfYXRfbXMYBCABKANSC2NyZWF0ZWRBdE1zEiQKDmRlcGxveWVkX2F0X21zGAUgASgDUgxkZX'
    'Bsb3llZEF0TXMSOgoHbWV0cmljcxgGIAEoCzIgLm1sX2luZmVyZW5jZS52MS5UcmFpbmluZ01l'
    'dHJpY3NSB21ldHJpY3MSIwoNYXJ0aWZhY3RfcGF0aBgHIAEoCVIMYXJ0aWZhY3RQYXRoEiMKDW'
    'FydGlmYWN0X2hhc2gYCCABKAlSDGFydGlmYWN0SGFzaBIfCgtzY2hlbWFfaGFzaBgJIAEoCVIK'
    'c2NoZW1hSGFzaBImCg90cmFpbmluZ19ydW5faWQYCiABKAlSDXRyYWluaW5nUnVuSWQSHwoLY2'
    '9tbWl0X2hhc2gYCyABKAlSCmNvbW1pdEhhc2gSSwoIbWV0YWRhdGEYDCADKAsyLy5tbF9pbmZl'
    'cmVuY2UudjEuTW9kZWxWZXJzaW9uSW5mby5NZXRhZGF0YUVudHJ5UghtZXRhZGF0YRo7Cg1NZX'
    'RhZGF0YUVudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOAE=');

@$core.Deprecated('Use getModelVersionsRequestDescriptor instead')
const GetModelVersionsRequest$json = {
  '1': 'GetModelVersionsRequest',
  '2': [
    {'1': 'task_type', '3': 1, '4': 1, '5': 9, '10': 'taskType'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
    {'1': 'status_filter', '3': 3, '4': 1, '5': 9, '10': 'statusFilter'},
  ],
};

/// Descriptor for `GetModelVersionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getModelVersionsRequestDescriptor = $convert.base64Decode(
    'ChdHZXRNb2RlbFZlcnNpb25zUmVxdWVzdBIbCgl0YXNrX3R5cGUYASABKAlSCHRhc2tUeXBlEh'
    'QKBWxpbWl0GAIgASgFUgVsaW1pdBIjCg1zdGF0dXNfZmlsdGVyGAMgASgJUgxzdGF0dXNGaWx0'
    'ZXI=');

@$core.Deprecated('Use getModelVersionsResponseDescriptor instead')
const GetModelVersionsResponse$json = {
  '1': 'GetModelVersionsResponse',
  '2': [
    {'1': 'versions', '3': 1, '4': 3, '5': 11, '6': '.ml_inference.v1.ModelVersionInfo', '10': 'versions'},
  ],
};

/// Descriptor for `GetModelVersionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getModelVersionsResponseDescriptor = $convert.base64Decode(
    'ChhHZXRNb2RlbFZlcnNpb25zUmVzcG9uc2USPQoIdmVyc2lvbnMYASADKAsyIS5tbF9pbmZlcm'
    'VuY2UudjEuTW9kZWxWZXJzaW9uSW5mb1IIdmVyc2lvbnM=');

@$core.Deprecated('Use deploymentPolicyDescriptor instead')
const DeploymentPolicy$json = {
  '1': 'DeploymentPolicy',
  '2': [
    {'1': 'min_improvement_percent', '3': 1, '4': 1, '5': 1, '10': 'minImprovementPercent'},
    {'1': 'require_manual_approval', '3': 2, '4': 1, '5': 8, '10': 'requireManualApproval'},
    {'1': 'canary_traffic_percent', '3': 3, '4': 1, '5': 1, '10': 'canaryTrafficPercent'},
    {'1': 'rollback_threshold_minutes', '3': 4, '4': 1, '5': 5, '10': 'rollbackThresholdMinutes'},
    {'1': 'alert_thresholds', '3': 5, '4': 3, '5': 9, '10': 'alertThresholds'},
  ],
};

/// Descriptor for `DeploymentPolicy`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deploymentPolicyDescriptor = $convert.base64Decode(
    'ChBEZXBsb3ltZW50UG9saWN5EjYKF21pbl9pbXByb3ZlbWVudF9wZXJjZW50GAEgASgBUhVtaW'
    '5JbXByb3ZlbWVudFBlcmNlbnQSNgoXcmVxdWlyZV9tYW51YWxfYXBwcm92YWwYAiABKAhSFXJl'
    'cXVpcmVNYW51YWxBcHByb3ZhbBI0ChZjYW5hcnlfdHJhZmZpY19wZXJjZW50GAMgASgBUhRjYW'
    '5hcnlUcmFmZmljUGVyY2VudBI8Chpyb2xsYmFja190aHJlc2hvbGRfbWludXRlcxgEIAEoBVIY'
    'cm9sbGJhY2tUaHJlc2hvbGRNaW51dGVzEikKEGFsZXJ0X3RocmVzaG9sZHMYBSADKAlSD2FsZX'
    'J0VGhyZXNob2xkcw==');

@$core.Deprecated('Use deployModelVersionRequestDescriptor instead')
const DeployModelVersionRequest$json = {
  '1': 'DeployModelVersionRequest',
  '2': [
    {'1': 'model_version_id', '3': 1, '4': 1, '5': 9, '10': 'modelVersionId'},
    {'1': 'policy', '3': 2, '4': 1, '5': 11, '6': '.ml_inference.v1.DeploymentPolicy', '10': 'policy'},
    {'1': 'deployed_by', '3': 3, '4': 1, '5': 9, '10': 'deployedBy'},
    {'1': 'approval_id', '3': 4, '4': 1, '5': 9, '10': 'approvalId'},
    {'1': 'notes', '3': 5, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `DeployModelVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deployModelVersionRequestDescriptor = $convert.base64Decode(
    'ChlEZXBsb3lNb2RlbFZlcnNpb25SZXF1ZXN0EigKEG1vZGVsX3ZlcnNpb25faWQYASABKAlSDm'
    '1vZGVsVmVyc2lvbklkEjkKBnBvbGljeRgCIAEoCzIhLm1sX2luZmVyZW5jZS52MS5EZXBsb3lt'
    'ZW50UG9saWN5UgZwb2xpY3kSHwoLZGVwbG95ZWRfYnkYAyABKAlSCmRlcGxveWVkQnkSHwoLYX'
    'Bwcm92YWxfaWQYBCABKAlSCmFwcHJvdmFsSWQSFAoFbm90ZXMYBSABKAlSBW5vdGVz');

@$core.Deprecated('Use deployModelVersionResponseDescriptor instead')
const DeployModelVersionResponse$json = {
  '1': 'DeployModelVersionResponse',
  '2': [
    {'1': 'deployment_id', '3': 1, '4': 1, '5': 9, '10': 'deploymentId'},
    {'1': 'status', '3': 2, '4': 1, '5': 9, '10': 'status'},
    {'1': 'deployed_at_ms', '3': 3, '4': 1, '5': 3, '10': 'deployedAtMs'},
    {'1': 'message', '3': 4, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `DeployModelVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deployModelVersionResponseDescriptor = $convert.base64Decode(
    'ChpEZXBsb3lNb2RlbFZlcnNpb25SZXNwb25zZRIjCg1kZXBsb3ltZW50X2lkGAEgASgJUgxkZX'
    'Bsb3ltZW50SWQSFgoGc3RhdHVzGAIgASgJUgZzdGF0dXMSJAoOZGVwbG95ZWRfYXRfbXMYAyAB'
    'KANSDGRlcGxveWVkQXRNcxIYCgdtZXNzYWdlGAQgASgJUgdtZXNzYWdl');

@$core.Deprecated('Use getActiveModelVersionRequestDescriptor instead')
const GetActiveModelVersionRequest$json = {
  '1': 'GetActiveModelVersionRequest',
  '2': [
    {'1': 'task_type', '3': 1, '4': 1, '5': 9, '10': 'taskType'},
  ],
};

/// Descriptor for `GetActiveModelVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActiveModelVersionRequestDescriptor = $convert.base64Decode(
    'ChxHZXRBY3RpdmVNb2RlbFZlcnNpb25SZXF1ZXN0EhsKCXRhc2tfdHlwZRgBIAEoCVIIdGFza1'
    'R5cGU=');

@$core.Deprecated('Use getActiveModelVersionResponseDescriptor instead')
const GetActiveModelVersionResponse$json = {
  '1': 'GetActiveModelVersionResponse',
  '2': [
    {'1': 'active_version', '3': 1, '4': 1, '5': 11, '6': '.ml_inference.v1.ModelVersionInfo', '10': 'activeVersion'},
    {'1': 'previous_version', '3': 2, '4': 1, '5': 11, '6': '.ml_inference.v1.ModelVersionInfo', '10': 'previousVersion'},
  ],
};

/// Descriptor for `GetActiveModelVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getActiveModelVersionResponseDescriptor = $convert.base64Decode(
    'Ch1HZXRBY3RpdmVNb2RlbFZlcnNpb25SZXNwb25zZRJICg5hY3RpdmVfdmVyc2lvbhgBIAEoCz'
    'IhLm1sX2luZmVyZW5jZS52MS5Nb2RlbFZlcnNpb25JbmZvUg1hY3RpdmVWZXJzaW9uEkwKEHBy'
    'ZXZpb3VzX3ZlcnNpb24YAiABKAsyIS5tbF9pbmZlcmVuY2UudjEuTW9kZWxWZXJzaW9uSW5mb1'
    'IPcHJldmlvdXNWZXJzaW9u');

@$core.Deprecated('Use rollbackModelVersionRequestDescriptor instead')
const RollbackModelVersionRequest$json = {
  '1': 'RollbackModelVersionRequest',
  '2': [
    {'1': 'task_type', '3': 1, '4': 1, '5': 9, '10': 'taskType'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'rolled_back_by', '3': 3, '4': 1, '5': 9, '10': 'rolledBackBy'},
  ],
};

/// Descriptor for `RollbackModelVersionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rollbackModelVersionRequestDescriptor = $convert.base64Decode(
    'ChtSb2xsYmFja01vZGVsVmVyc2lvblJlcXVlc3QSGwoJdGFza190eXBlGAEgASgJUgh0YXNrVH'
    'lwZRIWCgZyZWFzb24YAiABKAlSBnJlYXNvbhIkCg5yb2xsZWRfYmFja19ieRgDIAEoCVIMcm9s'
    'bGVkQmFja0J5');

@$core.Deprecated('Use rollbackModelVersionResponseDescriptor instead')
const RollbackModelVersionResponse$json = {
  '1': 'RollbackModelVersionResponse',
  '2': [
    {'1': 'active_version_id', '3': 1, '4': 1, '5': 9, '10': 'activeVersionId'},
    {'1': 'rolled_back_at_ms', '3': 2, '4': 1, '5': 3, '10': 'rolledBackAtMs'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '10': 'message'},
  ],
};

/// Descriptor for `RollbackModelVersionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rollbackModelVersionResponseDescriptor = $convert.base64Decode(
    'ChxSb2xsYmFja01vZGVsVmVyc2lvblJlc3BvbnNlEioKEWFjdGl2ZV92ZXJzaW9uX2lkGAEgAS'
    'gJUg9hY3RpdmVWZXJzaW9uSWQSKQoRcm9sbGVkX2JhY2tfYXRfbXMYAiABKANSDnJvbGxlZEJh'
    'Y2tBdE1zEhgKB21lc3NhZ2UYAyABKAlSB21lc3NhZ2U=');

const $core.Map<$core.String, $core.dynamic> MLInferenceServiceBase$json = {
  '1': 'MLInferenceService',
  '2': [
    {'1': 'PredictYield', '2': '.ml_inference.v1.YieldPredictionRequest', '3': '.ml_inference.v1.YieldPredictionResponse'},
    {'1': 'DetectAnomaly', '2': '.ml_inference.v1.AnomalyDetectionRequest', '3': '.ml_inference.v1.AnomalyDetectionResponse'},
    {'1': 'ForecastDegradation', '2': '.ml_inference.v1.DegradationRequest', '3': '.ml_inference.v1.DegradationResponse'},
    {'1': 'ExtractFeatures', '2': '.ml_inference.v1.FeatureExtractionRequest', '3': '.ml_inference.v1.FeatureExtractionResponse'},
    {'1': 'SubmitFeedback', '2': '.ml_inference.v1.SubmitFeedbackRequest', '3': '.ml_inference.v1.SubmitFeedbackResponse'},
    {'1': 'StartTraining', '2': '.ml_inference.v1.StartTrainingRequest', '3': '.ml_inference.v1.StartTrainingResponse'},
    {'1': 'GetTrainingStatus', '2': '.ml_inference.v1.GetTrainingStatusRequest', '3': '.ml_inference.v1.GetTrainingStatusResponse'},
    {'1': 'EvaluateModel', '2': '.ml_inference.v1.EvaluateModelRequest', '3': '.ml_inference.v1.EvaluateModelResponse'},
    {'1': 'GetModelVersions', '2': '.ml_inference.v1.GetModelVersionsRequest', '3': '.ml_inference.v1.GetModelVersionsResponse'},
    {'1': 'DeployModelVersion', '2': '.ml_inference.v1.DeployModelVersionRequest', '3': '.ml_inference.v1.DeployModelVersionResponse'},
    {'1': 'GetActiveModelVersion', '2': '.ml_inference.v1.GetActiveModelVersionRequest', '3': '.ml_inference.v1.GetActiveModelVersionResponse'},
    {'1': 'RollbackModelVersion', '2': '.ml_inference.v1.RollbackModelVersionRequest', '3': '.ml_inference.v1.RollbackModelVersionResponse'},
  ],
};

@$core.Deprecated('Use mLInferenceServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> MLInferenceServiceBase$messageJson = {
  '.ml_inference.v1.YieldPredictionRequest': YieldPredictionRequest$json,
  '.ml_inference.v1.FeatureVector': FeatureVector$json,
  '.ml_inference.v1.FeaturePayload': $2.FeaturePayload$json,
  '.ml_inference.v1.FeatureSchema': $2.FeatureSchema$json,
  '.ml_inference.v1.FeatureSpec': $2.FeatureSpec$json,
  '.common.v1.NumericRange': $0.NumericRange$json,
  '.google.protobuf.Timestamp': $1.Timestamp$json,
  '.common.v1.ContractMetadata': $0.ContractMetadata$json,
  '.common.v1.ApiVersion': $0.ApiVersion$json,
  '.ml_inference.v1.FeatureValue': $2.FeatureValue$json,
  '.ml_inference.v1.YieldPredictionResponse': YieldPredictionResponse$json,
  '.ml_inference.v1.YieldForecast': YieldForecast$json,
  '.ml_inference.v1.AnomalyDetectionRequest': AnomalyDetectionRequest$json,
  '.ml_inference.v1.AnomalyDetectionResponse': AnomalyDetectionResponse$json,
  '.ml_inference.v1.AnomalyScore': AnomalyScore$json,
  '.ml_inference.v1.DegradationRequest': DegradationRequest$json,
  '.ml_inference.v1.DegradationResponse': DegradationResponse$json,
  '.ml_inference.v1.DegradationForecast': DegradationForecast$json,
  '.ml_inference.v1.FeatureExtractionRequest': FeatureExtractionRequest$json,
  '.ml_inference.v1.WeatherFeatures': WeatherFeatures$json,
  '.ml_inference.v1.SolarFeatures': SolarFeatures$json,
  '.ml_inference.v1.TimeFeatures': TimeFeatures$json,
  '.ml_inference.v1.FeatureExtractionResponse': FeatureExtractionResponse$json,
  '.ml_inference.v1.SubmitFeedbackRequest': SubmitFeedbackRequest$json,
  '.ml_inference.v1.LabeledFeatureSample': $2.LabeledFeatureSample$json,
  '.ml_inference.v1.SubmitFeedbackResponse': SubmitFeedbackResponse$json,
  '.ml_inference.v1.StartTrainingRequest': StartTrainingRequest$json,
  '.ml_inference.v1.TrainingDataConfig': TrainingDataConfig$json,
  '.ml_inference.v1.StartTrainingRequest.HyperparamsEntry': StartTrainingRequest_HyperparamsEntry$json,
  '.ml_inference.v1.StartTrainingResponse': StartTrainingResponse$json,
  '.ml_inference.v1.GetTrainingStatusRequest': GetTrainingStatusRequest$json,
  '.ml_inference.v1.GetTrainingStatusResponse': GetTrainingStatusResponse$json,
  '.ml_inference.v1.TrainingMetrics': TrainingMetrics$json,
  '.ml_inference.v1.TrainingMetrics.CustomMetricsEntry': TrainingMetrics_CustomMetricsEntry$json,
  '.ml_inference.v1.EvaluateModelRequest': EvaluateModelRequest$json,
  '.ml_inference.v1.EvaluateModelResponse': EvaluateModelResponse$json,
  '.ml_inference.v1.ModelEvaluation': ModelEvaluation$json,
  '.ml_inference.v1.GetModelVersionsRequest': GetModelVersionsRequest$json,
  '.ml_inference.v1.GetModelVersionsResponse': GetModelVersionsResponse$json,
  '.ml_inference.v1.ModelVersionInfo': ModelVersionInfo$json,
  '.ml_inference.v1.ModelVersionInfo.MetadataEntry': ModelVersionInfo_MetadataEntry$json,
  '.ml_inference.v1.DeployModelVersionRequest': DeployModelVersionRequest$json,
  '.ml_inference.v1.DeploymentPolicy': DeploymentPolicy$json,
  '.ml_inference.v1.DeployModelVersionResponse': DeployModelVersionResponse$json,
  '.ml_inference.v1.GetActiveModelVersionRequest': GetActiveModelVersionRequest$json,
  '.ml_inference.v1.GetActiveModelVersionResponse': GetActiveModelVersionResponse$json,
  '.ml_inference.v1.RollbackModelVersionRequest': RollbackModelVersionRequest$json,
  '.ml_inference.v1.RollbackModelVersionResponse': RollbackModelVersionResponse$json,
};

/// Descriptor for `MLInferenceService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List mLInferenceServiceDescriptor = $convert.base64Decode(
    'ChJNTEluZmVyZW5jZVNlcnZpY2USYQoMUHJlZGljdFlpZWxkEicubWxfaW5mZXJlbmNlLnYxLl'
    'lpZWxkUHJlZGljdGlvblJlcXVlc3QaKC5tbF9pbmZlcmVuY2UudjEuWWllbGRQcmVkaWN0aW9u'
    'UmVzcG9uc2USZAoNRGV0ZWN0QW5vbWFseRIoLm1sX2luZmVyZW5jZS52MS5Bbm9tYWx5RGV0ZW'
    'N0aW9uUmVxdWVzdBopLm1sX2luZmVyZW5jZS52MS5Bbm9tYWx5RGV0ZWN0aW9uUmVzcG9uc2US'
    'YAoTRm9yZWNhc3REZWdyYWRhdGlvbhIjLm1sX2luZmVyZW5jZS52MS5EZWdyYWRhdGlvblJlcX'
    'Vlc3QaJC5tbF9pbmZlcmVuY2UudjEuRGVncmFkYXRpb25SZXNwb25zZRJoCg9FeHRyYWN0RmVh'
    'dHVyZXMSKS5tbF9pbmZlcmVuY2UudjEuRmVhdHVyZUV4dHJhY3Rpb25SZXF1ZXN0GioubWxfaW'
    '5mZXJlbmNlLnYxLkZlYXR1cmVFeHRyYWN0aW9uUmVzcG9uc2USYQoOU3VibWl0RmVlZGJhY2sS'
    'Ji5tbF9pbmZlcmVuY2UudjEuU3VibWl0RmVlZGJhY2tSZXF1ZXN0GicubWxfaW5mZXJlbmNlLn'
    'YxLlN1Ym1pdEZlZWRiYWNrUmVzcG9uc2USXgoNU3RhcnRUcmFpbmluZxIlLm1sX2luZmVyZW5j'
    'ZS52MS5TdGFydFRyYWluaW5nUmVxdWVzdBomLm1sX2luZmVyZW5jZS52MS5TdGFydFRyYWluaW'
    '5nUmVzcG9uc2USagoRR2V0VHJhaW5pbmdTdGF0dXMSKS5tbF9pbmZlcmVuY2UudjEuR2V0VHJh'
    'aW5pbmdTdGF0dXNSZXF1ZXN0GioubWxfaW5mZXJlbmNlLnYxLkdldFRyYWluaW5nU3RhdHVzUm'
    'VzcG9uc2USXgoNRXZhbHVhdGVNb2RlbBIlLm1sX2luZmVyZW5jZS52MS5FdmFsdWF0ZU1vZGVs'
    'UmVxdWVzdBomLm1sX2luZmVyZW5jZS52MS5FdmFsdWF0ZU1vZGVsUmVzcG9uc2USZwoQR2V0TW'
    '9kZWxWZXJzaW9ucxIoLm1sX2luZmVyZW5jZS52MS5HZXRNb2RlbFZlcnNpb25zUmVxdWVzdBop'
    'Lm1sX2luZmVyZW5jZS52MS5HZXRNb2RlbFZlcnNpb25zUmVzcG9uc2USbQoSRGVwbG95TW9kZW'
    'xWZXJzaW9uEioubWxfaW5mZXJlbmNlLnYxLkRlcGxveU1vZGVsVmVyc2lvblJlcXVlc3QaKy5t'
    'bF9pbmZlcmVuY2UudjEuRGVwbG95TW9kZWxWZXJzaW9uUmVzcG9uc2USdgoVR2V0QWN0aXZlTW'
    '9kZWxWZXJzaW9uEi0ubWxfaW5mZXJlbmNlLnYxLkdldEFjdGl2ZU1vZGVsVmVyc2lvblJlcXVl'
    'c3QaLi5tbF9pbmZlcmVuY2UudjEuR2V0QWN0aXZlTW9kZWxWZXJzaW9uUmVzcG9uc2UScwoUUm'
    '9sbGJhY2tNb2RlbFZlcnNpb24SLC5tbF9pbmZlcmVuY2UudjEuUm9sbGJhY2tNb2RlbFZlcnNp'
    'b25SZXF1ZXN0Gi0ubWxfaW5mZXJlbmNlLnYxLlJvbGxiYWNrTW9kZWxWZXJzaW9uUmVzcG9uc2'
    'U=');

