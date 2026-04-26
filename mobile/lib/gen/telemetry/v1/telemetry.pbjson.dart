//
//  Generated code. Do not modify.
//  source: telemetry/v1/telemetry.proto
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

@$core.Deprecated('Use telemetryMetricDescriptor instead')
const TelemetryMetric$json = {
  '1': 'TelemetryMetric',
  '2': [
    {'1': 'TELEMETRY_METRIC_UNSPECIFIED', '2': 0},
    {'1': 'TELEMETRY_METRIC_POWER_KW', '2': 1},
    {'1': 'TELEMETRY_METRIC_ENERGY_KWH', '2': 2},
    {'1': 'TELEMETRY_METRIC_IRRADIANCE_W_M2', '2': 3},
    {'1': 'TELEMETRY_METRIC_AMBIENT_TEMP_C', '2': 4},
    {'1': 'TELEMETRY_METRIC_MODULE_TEMP_C', '2': 5},
    {'1': 'TELEMETRY_METRIC_WIND_SPEED_MS', '2': 6},
    {'1': 'TELEMETRY_METRIC_DC_VOLTAGE_V', '2': 7},
    {'1': 'TELEMETRY_METRIC_DC_CURRENT_A', '2': 8},
    {'1': 'TELEMETRY_METRIC_AC_VOLTAGE_V', '2': 9},
    {'1': 'TELEMETRY_METRIC_AC_CURRENT_A', '2': 10},
    {'1': 'TELEMETRY_METRIC_INVERTER_EFFICIENCY', '2': 11},
    {'1': 'TELEMETRY_METRIC_AVAILABILITY', '2': 12},
  ],
};

/// Descriptor for `TelemetryMetric`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List telemetryMetricDescriptor = $convert.base64Decode(
    'Cg9UZWxlbWV0cnlNZXRyaWMSIAocVEVMRU1FVFJZX01FVFJJQ19VTlNQRUNJRklFRBAAEh0KGV'
    'RFTEVNRVRSWV9NRVRSSUNfUE9XRVJfS1cQARIfChtURUxFTUVUUllfTUVUUklDX0VORVJHWV9L'
    'V0gQAhIkCiBURUxFTUVUUllfTUVUUklDX0lSUkFESUFOQ0VfV19NMhADEiMKH1RFTEVNRVRSWV'
    '9NRVRSSUNfQU1CSUVOVF9URU1QX0MQBBIiCh5URUxFTUVUUllfTUVUUklDX01PRFVMRV9URU1Q'
    'X0MQBRIiCh5URUxFTUVUUllfTUVUUklDX1dJTkRfU1BFRURfTVMQBhIhCh1URUxFTUVUUllfTU'
    'VUUklDX0RDX1ZPTFRBR0VfVhAHEiEKHVRFTEVNRVRSWV9NRVRSSUNfRENfQ1VSUkVOVF9BEAgS'
    'IQodVEVMRU1FVFJZX01FVFJJQ19BQ19WT0xUQUdFX1YQCRIhCh1URUxFTUVUUllfTUVUUklDX0'
    'FDX0NVUlJFTlRfQRAKEigKJFRFTEVNRVRSWV9NRVRSSUNfSU5WRVJURVJfRUZGSUNJRU5DWRAL'
    'EiEKHVRFTEVNRVRSWV9NRVRSSUNfQVZBSUxBQklMSVRZEAw=');

@$core.Deprecated('Use readingQualityDescriptor instead')
const ReadingQuality$json = {
  '1': 'ReadingQuality',
  '2': [
    {'1': 'READING_QUALITY_UNSPECIFIED', '2': 0},
    {'1': 'READING_QUALITY_GOOD', '2': 1},
    {'1': 'READING_QUALITY_SUSPECT', '2': 2},
    {'1': 'READING_QUALITY_BAD', '2': 3},
  ],
};

/// Descriptor for `ReadingQuality`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List readingQualityDescriptor = $convert.base64Decode(
    'Cg5SZWFkaW5nUXVhbGl0eRIfChtSRUFESU5HX1FVQUxJVFlfVU5TUEVDSUZJRUQQABIYChRSRU'
    'FESU5HX1FVQUxJVFlfR09PRBABEhsKF1JFQURJTkdfUVVBTElUWV9TVVNQRUNUEAISFwoTUkVB'
    'RElOR19RVUFMSVRZX0JBRBAD');

@$core.Deprecated('Use sensorReadingDescriptor instead')
const SensorReading$json = {
  '1': 'SensorReading',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'twin_id', '3': 2, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'sensor_id', '3': 3, '4': 1, '5': 9, '10': 'sensorId'},
    {'1': 'asset_identity_id', '3': 4, '4': 1, '5': 9, '10': 'assetIdentityId'},
    {'1': 'metric', '3': 5, '4': 1, '5': 14, '6': '.telemetry.v1.TelemetryMetric', '10': 'metric'},
    {'1': 'value', '3': 6, '4': 1, '5': 1, '10': 'value'},
    {'1': 'unit', '3': 7, '4': 1, '5': 9, '10': 'unit'},
    {'1': 'quality', '3': 8, '4': 1, '5': 14, '6': '.telemetry.v1.ReadingQuality', '10': 'quality'},
    {'1': 'recorded_at', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'recordedAt'},
    {'1': 'ingested_at', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'ingestedAt'},
  ],
};

/// Descriptor for `SensorReading`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sensorReadingDescriptor = $convert.base64Decode(
    'Cg1TZW5zb3JSZWFkaW5nEg4KAmlkGAEgASgJUgJpZBIXCgd0d2luX2lkGAIgASgJUgZ0d2luSW'
    'QSGwoJc2Vuc29yX2lkGAMgASgJUghzZW5zb3JJZBIqChFhc3NldF9pZGVudGl0eV9pZBgEIAEo'
    'CVIPYXNzZXRJZGVudGl0eUlkEjUKBm1ldHJpYxgFIAEoDjIdLnRlbGVtZXRyeS52MS5UZWxlbW'
    'V0cnlNZXRyaWNSBm1ldHJpYxIUCgV2YWx1ZRgGIAEoAVIFdmFsdWUSEgoEdW5pdBgHIAEoCVIE'
    'dW5pdBI2CgdxdWFsaXR5GAggASgOMhwudGVsZW1ldHJ5LnYxLlJlYWRpbmdRdWFsaXR5UgdxdW'
    'FsaXR5EjsKC3JlY29yZGVkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIK'
    'cmVjb3JkZWRBdBI7Cgtpbmdlc3RlZF9hdBgKIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3'
    'RhbXBSCmluZ2VzdGVkQXQ=');

@$core.Deprecated('Use aggregatedMetricDescriptor instead')
const AggregatedMetric$json = {
  '1': 'AggregatedMetric',
  '2': [
    {'1': 'twin_id', '3': 1, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'metric', '3': 2, '4': 1, '5': 14, '6': '.telemetry.v1.TelemetryMetric', '10': 'metric'},
    {'1': 'window_start', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'windowStart'},
    {'1': 'window_end', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'windowEnd'},
    {'1': 'min_value', '3': 5, '4': 1, '5': 1, '10': 'minValue'},
    {'1': 'max_value', '3': 6, '4': 1, '5': 1, '10': 'maxValue'},
    {'1': 'avg_value', '3': 7, '4': 1, '5': 1, '10': 'avgValue'},
    {'1': 'sum_value', '3': 8, '4': 1, '5': 1, '10': 'sumValue'},
    {'1': 'reading_count', '3': 9, '4': 1, '5': 5, '10': 'readingCount'},
  ],
};

/// Descriptor for `AggregatedMetric`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List aggregatedMetricDescriptor = $convert.base64Decode(
    'ChBBZ2dyZWdhdGVkTWV0cmljEhcKB3R3aW5faWQYASABKAlSBnR3aW5JZBI1CgZtZXRyaWMYAi'
    'ABKA4yHS50ZWxlbWV0cnkudjEuVGVsZW1ldHJ5TWV0cmljUgZtZXRyaWMSPQoMd2luZG93X3N0'
    'YXJ0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFILd2luZG93U3RhcnQSOQoKd2'
    'luZG93X2VuZBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXdpbmRvd0VuZBIb'
    'CgltaW5fdmFsdWUYBSABKAFSCG1pblZhbHVlEhsKCW1heF92YWx1ZRgGIAEoAVIIbWF4VmFsdW'
    'USGwoJYXZnX3ZhbHVlGAcgASgBUghhdmdWYWx1ZRIbCglzdW1fdmFsdWUYCCABKAFSCHN1bVZh'
    'bHVlEiMKDXJlYWRpbmdfY291bnQYCSABKAVSDHJlYWRpbmdDb3VudA==');

@$core.Deprecated('Use ingestReadingsRequestDescriptor instead')
const IngestReadingsRequest$json = {
  '1': 'IngestReadingsRequest',
  '2': [
    {'1': 'twin_id', '3': 1, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'readings', '3': 2, '4': 3, '5': 11, '6': '.telemetry.v1.SensorReading', '10': 'readings'},
  ],
};

/// Descriptor for `IngestReadingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ingestReadingsRequestDescriptor = $convert.base64Decode(
    'ChVJbmdlc3RSZWFkaW5nc1JlcXVlc3QSFwoHdHdpbl9pZBgBIAEoCVIGdHdpbklkEjcKCHJlYW'
    'RpbmdzGAIgAygLMhsudGVsZW1ldHJ5LnYxLlNlbnNvclJlYWRpbmdSCHJlYWRpbmdz');

@$core.Deprecated('Use ingestReadingsResponseDescriptor instead')
const IngestReadingsResponse$json = {
  '1': 'IngestReadingsResponse',
  '2': [
    {'1': 'accepted_count', '3': 1, '4': 1, '5': 5, '10': 'acceptedCount'},
    {'1': 'rejected_count', '3': 2, '4': 1, '5': 5, '10': 'rejectedCount'},
  ],
};

/// Descriptor for `IngestReadingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List ingestReadingsResponseDescriptor = $convert.base64Decode(
    'ChZJbmdlc3RSZWFkaW5nc1Jlc3BvbnNlEiUKDmFjY2VwdGVkX2NvdW50GAEgASgFUg1hY2NlcH'
    'RlZENvdW50EiUKDnJlamVjdGVkX2NvdW50GAIgASgFUg1yZWplY3RlZENvdW50');

@$core.Deprecated('Use getLatestReadingsRequestDescriptor instead')
const GetLatestReadingsRequest$json = {
  '1': 'GetLatestReadingsRequest',
  '2': [
    {'1': 'twin_id', '3': 1, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'metric_filter', '3': 2, '4': 3, '5': 14, '6': '.telemetry.v1.TelemetryMetric', '10': 'metricFilter'},
  ],
};

/// Descriptor for `GetLatestReadingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLatestReadingsRequestDescriptor = $convert.base64Decode(
    'ChhHZXRMYXRlc3RSZWFkaW5nc1JlcXVlc3QSFwoHdHdpbl9pZBgBIAEoCVIGdHdpbklkEkIKDW'
    '1ldHJpY19maWx0ZXIYAiADKA4yHS50ZWxlbWV0cnkudjEuVGVsZW1ldHJ5TWV0cmljUgxtZXRy'
    'aWNGaWx0ZXI=');

@$core.Deprecated('Use getLatestReadingsResponseDescriptor instead')
const GetLatestReadingsResponse$json = {
  '1': 'GetLatestReadingsResponse',
  '2': [
    {'1': 'readings', '3': 1, '4': 3, '5': 11, '6': '.telemetry.v1.SensorReading', '10': 'readings'},
  ],
};

/// Descriptor for `GetLatestReadingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getLatestReadingsResponseDescriptor = $convert.base64Decode(
    'ChlHZXRMYXRlc3RSZWFkaW5nc1Jlc3BvbnNlEjcKCHJlYWRpbmdzGAEgAygLMhsudGVsZW1ldH'
    'J5LnYxLlNlbnNvclJlYWRpbmdSCHJlYWRpbmdz');

@$core.Deprecated('Use listReadingsRequestDescriptor instead')
const ListReadingsRequest$json = {
  '1': 'ListReadingsRequest',
  '2': [
    {'1': 'twin_id', '3': 1, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'metric_filter', '3': 2, '4': 1, '5': 14, '6': '.telemetry.v1.TelemetryMetric', '10': 'metricFilter'},
    {'1': 'window_start', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'windowStart'},
    {'1': 'window_end', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'windowEnd'},
    {'1': 'page_size', '3': 5, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 6, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListReadingsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReadingsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UmVhZGluZ3NSZXF1ZXN0EhcKB3R3aW5faWQYASABKAlSBnR3aW5JZBJCCg1tZXRyaW'
    'NfZmlsdGVyGAIgASgOMh0udGVsZW1ldHJ5LnYxLlRlbGVtZXRyeU1ldHJpY1IMbWV0cmljRmls'
    'dGVyEj0KDHdpbmRvd19zdGFydBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3'
    'dpbmRvd1N0YXJ0EjkKCndpbmRvd19lbmQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0'
    'YW1wUgl3aW5kb3dFbmQSGwoJcGFnZV9zaXplGAUgASgFUghwYWdlU2l6ZRIdCgpwYWdlX3Rva2'
    'VuGAYgASgJUglwYWdlVG9rZW4=');

@$core.Deprecated('Use listReadingsResponseDescriptor instead')
const ListReadingsResponse$json = {
  '1': 'ListReadingsResponse',
  '2': [
    {'1': 'readings', '3': 1, '4': 3, '5': 11, '6': '.telemetry.v1.SensorReading', '10': 'readings'},
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
    {'1': 'total_count', '3': 3, '4': 1, '5': 5, '10': 'totalCount'},
  ],
};

/// Descriptor for `ListReadingsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listReadingsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UmVhZGluZ3NSZXNwb25zZRI3CghyZWFkaW5ncxgBIAMoCzIbLnRlbGVtZXRyeS52MS'
    '5TZW5zb3JSZWFkaW5nUghyZWFkaW5ncxImCg9uZXh0X3BhZ2VfdG9rZW4YAiABKAlSDW5leHRQ'
    'YWdlVG9rZW4SHwoLdG90YWxfY291bnQYAyABKAVSCnRvdGFsQ291bnQ=');

@$core.Deprecated('Use getAggregatedMetricsRequestDescriptor instead')
const GetAggregatedMetricsRequest$json = {
  '1': 'GetAggregatedMetricsRequest',
  '2': [
    {'1': 'twin_id', '3': 1, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'metric', '3': 2, '4': 1, '5': 14, '6': '.telemetry.v1.TelemetryMetric', '10': 'metric'},
    {'1': 'window_start', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'windowStart'},
    {'1': 'window_end', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'windowEnd'},
  ],
};

/// Descriptor for `GetAggregatedMetricsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAggregatedMetricsRequestDescriptor = $convert.base64Decode(
    'ChtHZXRBZ2dyZWdhdGVkTWV0cmljc1JlcXVlc3QSFwoHdHdpbl9pZBgBIAEoCVIGdHdpbklkEj'
    'UKBm1ldHJpYxgCIAEoDjIdLnRlbGVtZXRyeS52MS5UZWxlbWV0cnlNZXRyaWNSBm1ldHJpYxI9'
    'Cgx3aW5kb3dfc3RhcnQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgt3aW5kb3'
    'dTdGFydBI5Cgp3aW5kb3dfZW5kGAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJ'
    'd2luZG93RW5k');

@$core.Deprecated('Use getAggregatedMetricsResponseDescriptor instead')
const GetAggregatedMetricsResponse$json = {
  '1': 'GetAggregatedMetricsResponse',
  '2': [
    {'1': 'aggregated_metric', '3': 1, '4': 1, '5': 11, '6': '.telemetry.v1.AggregatedMetric', '10': 'aggregatedMetric'},
  ],
};

/// Descriptor for `GetAggregatedMetricsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getAggregatedMetricsResponseDescriptor = $convert.base64Decode(
    'ChxHZXRBZ2dyZWdhdGVkTWV0cmljc1Jlc3BvbnNlEksKEWFnZ3JlZ2F0ZWRfbWV0cmljGAEgAS'
    'gLMh4udGVsZW1ldHJ5LnYxLkFnZ3JlZ2F0ZWRNZXRyaWNSEGFnZ3JlZ2F0ZWRNZXRyaWM=');

const $core.Map<$core.String, $core.dynamic> TelemetryServiceBase$json = {
  '1': 'TelemetryService',
  '2': [
    {'1': 'IngestReadings', '2': '.telemetry.v1.IngestReadingsRequest', '3': '.telemetry.v1.IngestReadingsResponse'},
    {'1': 'GetLatestReadings', '2': '.telemetry.v1.GetLatestReadingsRequest', '3': '.telemetry.v1.GetLatestReadingsResponse'},
    {'1': 'ListReadings', '2': '.telemetry.v1.ListReadingsRequest', '3': '.telemetry.v1.ListReadingsResponse'},
    {'1': 'GetAggregatedMetrics', '2': '.telemetry.v1.GetAggregatedMetricsRequest', '3': '.telemetry.v1.GetAggregatedMetricsResponse'},
  ],
};

@$core.Deprecated('Use telemetryServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> TelemetryServiceBase$messageJson = {
  '.telemetry.v1.IngestReadingsRequest': IngestReadingsRequest$json,
  '.telemetry.v1.SensorReading': SensorReading$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.telemetry.v1.IngestReadingsResponse': IngestReadingsResponse$json,
  '.telemetry.v1.GetLatestReadingsRequest': GetLatestReadingsRequest$json,
  '.telemetry.v1.GetLatestReadingsResponse': GetLatestReadingsResponse$json,
  '.telemetry.v1.ListReadingsRequest': ListReadingsRequest$json,
  '.telemetry.v1.ListReadingsResponse': ListReadingsResponse$json,
  '.telemetry.v1.GetAggregatedMetricsRequest': GetAggregatedMetricsRequest$json,
  '.telemetry.v1.GetAggregatedMetricsResponse': GetAggregatedMetricsResponse$json,
  '.telemetry.v1.AggregatedMetric': AggregatedMetric$json,
};

/// Descriptor for `TelemetryService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List telemetryServiceDescriptor = $convert.base64Decode(
    'ChBUZWxlbWV0cnlTZXJ2aWNlElsKDkluZ2VzdFJlYWRpbmdzEiMudGVsZW1ldHJ5LnYxLkluZ2'
    'VzdFJlYWRpbmdzUmVxdWVzdBokLnRlbGVtZXRyeS52MS5Jbmdlc3RSZWFkaW5nc1Jlc3BvbnNl'
    'EmQKEUdldExhdGVzdFJlYWRpbmdzEiYudGVsZW1ldHJ5LnYxLkdldExhdGVzdFJlYWRpbmdzUm'
    'VxdWVzdBonLnRlbGVtZXRyeS52MS5HZXRMYXRlc3RSZWFkaW5nc1Jlc3BvbnNlElUKDExpc3RS'
    'ZWFkaW5ncxIhLnRlbGVtZXRyeS52MS5MaXN0UmVhZGluZ3NSZXF1ZXN0GiIudGVsZW1ldHJ5Ln'
    'YxLkxpc3RSZWFkaW5nc1Jlc3BvbnNlEm0KFEdldEFnZ3JlZ2F0ZWRNZXRyaWNzEikudGVsZW1l'
    'dHJ5LnYxLkdldEFnZ3JlZ2F0ZWRNZXRyaWNzUmVxdWVzdBoqLnRlbGVtZXRyeS52MS5HZXRBZ2'
    'dyZWdhdGVkTWV0cmljc1Jlc3BvbnNl');

