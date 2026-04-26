//
//  Generated code. Do not modify.
//  source: weather/v1/weather.proto
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

@$core.Deprecated('Use weatherSourceDescriptor instead')
const WeatherSource$json = {
  '1': 'WeatherSource',
  '2': [
    {'1': 'WEATHER_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'WEATHER_SOURCE_PVGIS', '2': 1},
    {'1': 'WEATHER_SOURCE_NASA_POWER', '2': 2},
    {'1': 'WEATHER_SOURCE_NSRDB', '2': 3},
    {'1': 'WEATHER_SOURCE_ERA5', '2': 4},
    {'1': 'WEATHER_SOURCE_EPW', '2': 5},
    {'1': 'WEATHER_SOURCE_TM2', '2': 6},
    {'1': 'WEATHER_SOURCE_TM3', '2': 7},
    {'1': 'WEATHER_SOURCE_CSV', '2': 8},
  ],
};

/// Descriptor for `WeatherSource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List weatherSourceDescriptor = $convert.base64Decode(
    'Cg1XZWF0aGVyU291cmNlEh4KGldFQVRIRVJfU09VUkNFX1VOU1BFQ0lGSUVEEAASGAoUV0VBVE'
    'hFUl9TT1VSQ0VfUFZHSVMQARIdChlXRUFUSEVSX1NPVVJDRV9OQVNBX1BPV0VSEAISGAoUV0VB'
    'VEhFUl9TT1VSQ0VfTlNSREIQAxIXChNXRUFUSEVSX1NPVVJDRV9FUkE1EAQSFgoSV0VBVEhFUl'
    '9TT1VSQ0VfRVBXEAUSFgoSV0VBVEhFUl9TT1VSQ0VfVE0yEAYSFgoSV0VBVEhFUl9TT1VSQ0Vf'
    'VE0zEAcSFgoSV0VBVEhFUl9TT1VSQ0VfQ1NWEAg=');

@$core.Deprecated('Use hourlyRecordDescriptor instead')
const HourlyRecord$json = {
  '1': 'HourlyRecord',
  '2': [
    {'1': 'timestamp', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    {'1': 'ghi', '3': 2, '4': 1, '5': 1, '10': 'ghi'},
    {'1': 'dni', '3': 3, '4': 1, '5': 1, '10': 'dni'},
    {'1': 'dhi', '3': 4, '4': 1, '5': 1, '10': 'dhi'},
    {'1': 'ambient_temp_c', '3': 5, '4': 1, '5': 1, '10': 'ambientTempC'},
    {'1': 'wind_speed_ms', '3': 6, '4': 1, '5': 1, '10': 'windSpeedMs'},
    {'1': 'relative_humidity_pct', '3': 7, '4': 1, '5': 1, '10': 'relativeHumidityPct'},
    {'1': 'albedo', '3': 8, '4': 1, '5': 1, '10': 'albedo'},
  ],
};

/// Descriptor for `HourlyRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List hourlyRecordDescriptor = $convert.base64Decode(
    'CgxIb3VybHlSZWNvcmQSOAoJdGltZXN0YW1wGAEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbW'
    'VzdGFtcFIJdGltZXN0YW1wEhAKA2doaRgCIAEoAVIDZ2hpEhAKA2RuaRgDIAEoAVIDZG5pEhAK'
    'A2RoaRgEIAEoAVIDZGhpEiQKDmFtYmllbnRfdGVtcF9jGAUgASgBUgxhbWJpZW50VGVtcEMSIg'
    'oNd2luZF9zcGVlZF9tcxgGIAEoAVILd2luZFNwZWVkTXMSMgoVcmVsYXRpdmVfaHVtaWRpdHlf'
    'cGN0GAcgASgBUhNyZWxhdGl2ZUh1bWlkaXR5UGN0EhYKBmFsYmVkbxgIIAEoAVIGYWxiZWRv');

@$core.Deprecated('Use siteWeatherSummaryDescriptor instead')
const SiteWeatherSummary$json = {
  '1': 'SiteWeatherSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'latitude', '3': 3, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 4, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'source', '3': 5, '4': 1, '5': 14, '6': '.weather.v1.WeatherSource', '10': 'source'},
    {'1': 'record_count', '3': 6, '4': 1, '5': 5, '10': 'recordCount'},
    {'1': 'annual_ghi_kwh_m2', '3': 7, '4': 1, '5': 1, '10': 'annualGhiKwhM2'},
    {'1': 'fetched_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'fetchedAt'},
  ],
};

/// Descriptor for `SiteWeatherSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List siteWeatherSummaryDescriptor = $convert.base64Decode(
    'ChJTaXRlV2VhdGhlclN1bW1hcnkSDgoCaWQYASABKAlSAmlkEh0KCnByb2plY3RfaWQYAiABKA'
    'lSCXByb2plY3RJZBIaCghsYXRpdHVkZRgDIAEoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAQg'
    'ASgBUglsb25naXR1ZGUSMQoGc291cmNlGAUgASgOMhkud2VhdGhlci52MS5XZWF0aGVyU291cm'
    'NlUgZzb3VyY2USIQoMcmVjb3JkX2NvdW50GAYgASgFUgtyZWNvcmRDb3VudBIpChFhbm51YWxf'
    'Z2hpX2t3aF9tMhgHIAEoAVIOYW5udWFsR2hpS3doTTISOQoKZmV0Y2hlZF9hdBgIIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWZldGNoZWRBdA==');

@$core.Deprecated('Use yieldExceedanceDescriptor instead')
const YieldExceedance$json = {
  '1': 'YieldExceedance',
  '2': [
    {'1': 'percentile', '3': 1, '4': 1, '5': 5, '10': 'percentile'},
    {'1': 'annual_ghi_kwh_m2', '3': 2, '4': 1, '5': 1, '10': 'annualGhiKwhM2'},
  ],
};

/// Descriptor for `YieldExceedance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List yieldExceedanceDescriptor = $convert.base64Decode(
    'Cg9ZaWVsZEV4Y2VlZGFuY2USHgoKcGVyY2VudGlsZRgBIAEoBVIKcGVyY2VudGlsZRIpChFhbm'
    '51YWxfZ2hpX2t3aF9tMhgCIAEoAVIOYW5udWFsR2hpS3doTTI=');

@$core.Deprecated('Use fetchIrradianceRequestDescriptor instead')
const FetchIrradianceRequest$json = {
  '1': 'FetchIrradianceRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'latitude', '3': 2, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 3, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'source', '3': 4, '4': 1, '5': 14, '6': '.weather.v1.WeatherSource', '10': 'source'},
    {'1': 'api_key', '3': 5, '4': 1, '5': 9, '10': 'apiKey'},
  ],
};

/// Descriptor for `FetchIrradianceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fetchIrradianceRequestDescriptor = $convert.base64Decode(
    'ChZGZXRjaElycmFkaWFuY2VSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZB'
    'IaCghsYXRpdHVkZRgCIAEoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAMgASgBUglsb25naXR1'
    'ZGUSMQoGc291cmNlGAQgASgOMhkud2VhdGhlci52MS5XZWF0aGVyU291cmNlUgZzb3VyY2USFw'
    'oHYXBpX2tleRgFIAEoCVIGYXBpS2V5');

@$core.Deprecated('Use fetchIrradianceResponseDescriptor instead')
const FetchIrradianceResponse$json = {
  '1': 'FetchIrradianceResponse',
  '2': [
    {'1': 'summary', '3': 1, '4': 1, '5': 11, '6': '.weather.v1.SiteWeatherSummary', '10': 'summary'},
    {'1': 'records', '3': 2, '4': 3, '5': 11, '6': '.weather.v1.HourlyRecord', '10': 'records'},
  ],
};

/// Descriptor for `FetchIrradianceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fetchIrradianceResponseDescriptor = $convert.base64Decode(
    'ChdGZXRjaElycmFkaWFuY2VSZXNwb25zZRI4CgdzdW1tYXJ5GAEgASgLMh4ud2VhdGhlci52MS'
    '5TaXRlV2VhdGhlclN1bW1hcnlSB3N1bW1hcnkSMgoHcmVjb3JkcxgCIAMoCzIYLndlYXRoZXIu'
    'djEuSG91cmx5UmVjb3JkUgdyZWNvcmRz');

@$core.Deprecated('Use importTMYRequestDescriptor instead')
const ImportTMYRequest$json = {
  '1': 'ImportTMYRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'latitude', '3': 2, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 3, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'format', '3': 4, '4': 1, '5': 14, '6': '.weather.v1.WeatherSource', '10': 'format'},
    {'1': 'file_content', '3': 5, '4': 1, '5': 12, '10': 'fileContent'},
    {'1': 'file_name', '3': 6, '4': 1, '5': 9, '10': 'fileName'},
  ],
};

/// Descriptor for `ImportTMYRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importTMYRequestDescriptor = $convert.base64Decode(
    'ChBJbXBvcnRUTVlSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZBIaCghsYX'
    'RpdHVkZRgCIAEoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAMgASgBUglsb25naXR1ZGUSMQoG'
    'Zm9ybWF0GAQgASgOMhkud2VhdGhlci52MS5XZWF0aGVyU291cmNlUgZmb3JtYXQSIQoMZmlsZV'
    '9jb250ZW50GAUgASgMUgtmaWxlQ29udGVudBIbCglmaWxlX25hbWUYBiABKAlSCGZpbGVOYW1l');

@$core.Deprecated('Use importTMYResponseDescriptor instead')
const ImportTMYResponse$json = {
  '1': 'ImportTMYResponse',
  '2': [
    {'1': 'summary', '3': 1, '4': 1, '5': 11, '6': '.weather.v1.SiteWeatherSummary', '10': 'summary'},
    {'1': 'records_imported', '3': 2, '4': 1, '5': 5, '10': 'recordsImported'},
  ],
};

/// Descriptor for `ImportTMYResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List importTMYResponseDescriptor = $convert.base64Decode(
    'ChFJbXBvcnRUTVlSZXNwb25zZRI4CgdzdW1tYXJ5GAEgASgLMh4ud2VhdGhlci52MS5TaXRlV2'
    'VhdGhlclN1bW1hcnlSB3N1bW1hcnkSKQoQcmVjb3Jkc19pbXBvcnRlZBgCIAEoBVIPcmVjb3Jk'
    'c0ltcG9ydGVk');

@$core.Deprecated('Use getHourlyTimeseriesRequestDescriptor instead')
const GetHourlyTimeseriesRequest$json = {
  '1': 'GetHourlyTimeseriesRequest',
  '2': [
    {'1': 'site_weather_id', '3': 1, '4': 1, '5': 9, '10': 'siteWeatherId'},
  ],
};

/// Descriptor for `GetHourlyTimeseriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHourlyTimeseriesRequestDescriptor = $convert.base64Decode(
    'ChpHZXRIb3VybHlUaW1lc2VyaWVzUmVxdWVzdBImCg9zaXRlX3dlYXRoZXJfaWQYASABKAlSDX'
    'NpdGVXZWF0aGVySWQ=');

@$core.Deprecated('Use getHourlyTimeseriesResponseDescriptor instead')
const GetHourlyTimeseriesResponse$json = {
  '1': 'GetHourlyTimeseriesResponse',
  '2': [
    {'1': 'summary', '3': 1, '4': 1, '5': 11, '6': '.weather.v1.SiteWeatherSummary', '10': 'summary'},
    {'1': 'records', '3': 2, '4': 3, '5': 11, '6': '.weather.v1.HourlyRecord', '10': 'records'},
  ],
};

/// Descriptor for `GetHourlyTimeseriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getHourlyTimeseriesResponseDescriptor = $convert.base64Decode(
    'ChtHZXRIb3VybHlUaW1lc2VyaWVzUmVzcG9uc2USOAoHc3VtbWFyeRgBIAEoCzIeLndlYXRoZX'
    'IudjEuU2l0ZVdlYXRoZXJTdW1tYXJ5UgdzdW1tYXJ5EjIKB3JlY29yZHMYAiADKAsyGC53ZWF0'
    'aGVyLnYxLkhvdXJseVJlY29yZFIHcmVjb3Jkcw==');

@$core.Deprecated('Use listSiteWeatherRequestDescriptor instead')
const ListSiteWeatherRequest$json = {
  '1': 'ListSiteWeatherRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
  ],
};

/// Descriptor for `ListSiteWeatherRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSiteWeatherRequestDescriptor = $convert.base64Decode(
    'ChZMaXN0U2l0ZVdlYXRoZXJSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZA'
    '==');

@$core.Deprecated('Use listSiteWeatherResponseDescriptor instead')
const ListSiteWeatherResponse$json = {
  '1': 'ListSiteWeatherResponse',
  '2': [
    {'1': 'summaries', '3': 1, '4': 3, '5': 11, '6': '.weather.v1.SiteWeatherSummary', '10': 'summaries'},
  ],
};

/// Descriptor for `ListSiteWeatherResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listSiteWeatherResponseDescriptor = $convert.base64Decode(
    'ChdMaXN0U2l0ZVdlYXRoZXJSZXNwb25zZRI8CglzdW1tYXJpZXMYASADKAsyHi53ZWF0aGVyLn'
    'YxLlNpdGVXZWF0aGVyU3VtbWFyeVIJc3VtbWFyaWVz');

@$core.Deprecated('Use calculateYieldExceedanceRequestDescriptor instead')
const CalculateYieldExceedanceRequest$json = {
  '1': 'CalculateYieldExceedanceRequest',
  '2': [
    {'1': 'site_weather_id', '3': 1, '4': 1, '5': 9, '10': 'siteWeatherId'},
    {'1': 'system_capacity_kw', '3': 2, '4': 1, '5': 1, '10': 'systemCapacityKw'},
  ],
};

/// Descriptor for `CalculateYieldExceedanceRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateYieldExceedanceRequestDescriptor = $convert.base64Decode(
    'Ch9DYWxjdWxhdGVZaWVsZEV4Y2VlZGFuY2VSZXF1ZXN0EiYKD3NpdGVfd2VhdGhlcl9pZBgBIA'
    'EoCVINc2l0ZVdlYXRoZXJJZBIsChJzeXN0ZW1fY2FwYWNpdHlfa3cYAiABKAFSEHN5c3RlbUNh'
    'cGFjaXR5S3c=');

@$core.Deprecated('Use calculateYieldExceedanceResponseDescriptor instead')
const CalculateYieldExceedanceResponse$json = {
  '1': 'CalculateYieldExceedanceResponse',
  '2': [
    {'1': 'site_weather_id', '3': 1, '4': 1, '5': 9, '10': 'siteWeatherId'},
    {'1': 'exceedances', '3': 2, '4': 3, '5': 11, '6': '.weather.v1.YieldExceedance', '10': 'exceedances'},
  ],
};

/// Descriptor for `CalculateYieldExceedanceResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List calculateYieldExceedanceResponseDescriptor = $convert.base64Decode(
    'CiBDYWxjdWxhdGVZaWVsZEV4Y2VlZGFuY2VSZXNwb25zZRImCg9zaXRlX3dlYXRoZXJfaWQYAS'
    'ABKAlSDXNpdGVXZWF0aGVySWQSPQoLZXhjZWVkYW5jZXMYAiADKAsyGy53ZWF0aGVyLnYxLllp'
    'ZWxkRXhjZWVkYW5jZVILZXhjZWVkYW5jZXM=');

@$core.Deprecated('Use deleteSiteWeatherRequestDescriptor instead')
const DeleteSiteWeatherRequest$json = {
  '1': 'DeleteSiteWeatherRequest',
  '2': [
    {'1': 'site_weather_id', '3': 1, '4': 1, '5': 9, '10': 'siteWeatherId'},
  ],
};

/// Descriptor for `DeleteSiteWeatherRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteSiteWeatherRequestDescriptor = $convert.base64Decode(
    'ChhEZWxldGVTaXRlV2VhdGhlclJlcXVlc3QSJgoPc2l0ZV93ZWF0aGVyX2lkGAEgASgJUg1zaX'
    'RlV2VhdGhlcklk');

@$core.Deprecated('Use deleteSiteWeatherResponseDescriptor instead')
const DeleteSiteWeatherResponse$json = {
  '1': 'DeleteSiteWeatherResponse',
};

/// Descriptor for `DeleteSiteWeatherResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteSiteWeatherResponseDescriptor = $convert.base64Decode(
    'ChlEZWxldGVTaXRlV2VhdGhlclJlc3BvbnNl');

const $core.Map<$core.String, $core.dynamic> WeatherServiceBase$json = {
  '1': 'WeatherService',
  '2': [
    {'1': 'FetchIrradiance', '2': '.weather.v1.FetchIrradianceRequest', '3': '.weather.v1.FetchIrradianceResponse'},
    {'1': 'ImportTMY', '2': '.weather.v1.ImportTMYRequest', '3': '.weather.v1.ImportTMYResponse'},
    {'1': 'GetHourlyTimeseries', '2': '.weather.v1.GetHourlyTimeseriesRequest', '3': '.weather.v1.GetHourlyTimeseriesResponse'},
    {'1': 'ListSiteWeather', '2': '.weather.v1.ListSiteWeatherRequest', '3': '.weather.v1.ListSiteWeatherResponse'},
    {'1': 'CalculateYieldExceedance', '2': '.weather.v1.CalculateYieldExceedanceRequest', '3': '.weather.v1.CalculateYieldExceedanceResponse'},
    {'1': 'DeleteSiteWeather', '2': '.weather.v1.DeleteSiteWeatherRequest', '3': '.weather.v1.DeleteSiteWeatherResponse'},
  ],
};

@$core.Deprecated('Use weatherServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> WeatherServiceBase$messageJson = {
  '.weather.v1.FetchIrradianceRequest': FetchIrradianceRequest$json,
  '.weather.v1.FetchIrradianceResponse': FetchIrradianceResponse$json,
  '.weather.v1.SiteWeatherSummary': SiteWeatherSummary$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.weather.v1.HourlyRecord': HourlyRecord$json,
  '.weather.v1.ImportTMYRequest': ImportTMYRequest$json,
  '.weather.v1.ImportTMYResponse': ImportTMYResponse$json,
  '.weather.v1.GetHourlyTimeseriesRequest': GetHourlyTimeseriesRequest$json,
  '.weather.v1.GetHourlyTimeseriesResponse': GetHourlyTimeseriesResponse$json,
  '.weather.v1.ListSiteWeatherRequest': ListSiteWeatherRequest$json,
  '.weather.v1.ListSiteWeatherResponse': ListSiteWeatherResponse$json,
  '.weather.v1.CalculateYieldExceedanceRequest': CalculateYieldExceedanceRequest$json,
  '.weather.v1.CalculateYieldExceedanceResponse': CalculateYieldExceedanceResponse$json,
  '.weather.v1.YieldExceedance': YieldExceedance$json,
  '.weather.v1.DeleteSiteWeatherRequest': DeleteSiteWeatherRequest$json,
  '.weather.v1.DeleteSiteWeatherResponse': DeleteSiteWeatherResponse$json,
};

/// Descriptor for `WeatherService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List weatherServiceDescriptor = $convert.base64Decode(
    'Cg5XZWF0aGVyU2VydmljZRJaCg9GZXRjaElycmFkaWFuY2USIi53ZWF0aGVyLnYxLkZldGNoSX'
    'JyYWRpYW5jZVJlcXVlc3QaIy53ZWF0aGVyLnYxLkZldGNoSXJyYWRpYW5jZVJlc3BvbnNlEkgK'
    'CUltcG9ydFRNWRIcLndlYXRoZXIudjEuSW1wb3J0VE1ZUmVxdWVzdBodLndlYXRoZXIudjEuSW'
    '1wb3J0VE1ZUmVzcG9uc2USZgoTR2V0SG91cmx5VGltZXNlcmllcxImLndlYXRoZXIudjEuR2V0'
    'SG91cmx5VGltZXNlcmllc1JlcXVlc3QaJy53ZWF0aGVyLnYxLkdldEhvdXJseVRpbWVzZXJpZX'
    'NSZXNwb25zZRJaCg9MaXN0U2l0ZVdlYXRoZXISIi53ZWF0aGVyLnYxLkxpc3RTaXRlV2VhdGhl'
    'clJlcXVlc3QaIy53ZWF0aGVyLnYxLkxpc3RTaXRlV2VhdGhlclJlc3BvbnNlEnUKGENhbGN1bG'
    'F0ZVlpZWxkRXhjZWVkYW5jZRIrLndlYXRoZXIudjEuQ2FsY3VsYXRlWWllbGRFeGNlZWRhbmNl'
    'UmVxdWVzdBosLndlYXRoZXIudjEuQ2FsY3VsYXRlWWllbGRFeGNlZWRhbmNlUmVzcG9uc2USYA'
    'oRRGVsZXRlU2l0ZVdlYXRoZXISJC53ZWF0aGVyLnYxLkRlbGV0ZVNpdGVXZWF0aGVyUmVxdWVz'
    'dBolLndlYXRoZXIudjEuRGVsZXRlU2l0ZVdlYXRoZXJSZXNwb25zZQ==');

