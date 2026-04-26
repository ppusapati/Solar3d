//
//  Generated code. Do not modify.
//  source: weather/v1/weather.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// WeatherSource identifies the upstream provider or file format from which
/// the weather data originates.
class WeatherSource extends $pb.ProtobufEnum {
  static const WeatherSource WEATHER_SOURCE_UNSPECIFIED = WeatherSource._(0, _omitEnumNames ? '' : 'WEATHER_SOURCE_UNSPECIFIED');
  static const WeatherSource WEATHER_SOURCE_PVGIS = WeatherSource._(1, _omitEnumNames ? '' : 'WEATHER_SOURCE_PVGIS');
  static const WeatherSource WEATHER_SOURCE_NASA_POWER = WeatherSource._(2, _omitEnumNames ? '' : 'WEATHER_SOURCE_NASA_POWER');
  static const WeatherSource WEATHER_SOURCE_NSRDB = WeatherSource._(3, _omitEnumNames ? '' : 'WEATHER_SOURCE_NSRDB');
  static const WeatherSource WEATHER_SOURCE_ERA5 = WeatherSource._(4, _omitEnumNames ? '' : 'WEATHER_SOURCE_ERA5');
  static const WeatherSource WEATHER_SOURCE_EPW = WeatherSource._(5, _omitEnumNames ? '' : 'WEATHER_SOURCE_EPW');
  static const WeatherSource WEATHER_SOURCE_TM2 = WeatherSource._(6, _omitEnumNames ? '' : 'WEATHER_SOURCE_TM2');
  static const WeatherSource WEATHER_SOURCE_TM3 = WeatherSource._(7, _omitEnumNames ? '' : 'WEATHER_SOURCE_TM3');
  static const WeatherSource WEATHER_SOURCE_CSV = WeatherSource._(8, _omitEnumNames ? '' : 'WEATHER_SOURCE_CSV');

  static const $core.List<WeatherSource> values = <WeatherSource> [
    WEATHER_SOURCE_UNSPECIFIED,
    WEATHER_SOURCE_PVGIS,
    WEATHER_SOURCE_NASA_POWER,
    WEATHER_SOURCE_NSRDB,
    WEATHER_SOURCE_ERA5,
    WEATHER_SOURCE_EPW,
    WEATHER_SOURCE_TM2,
    WEATHER_SOURCE_TM3,
    WEATHER_SOURCE_CSV,
  ];

  static final $core.Map<$core.int, WeatherSource> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WeatherSource? valueOf($core.int value) => _byValue[value];

  const WeatherSource._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
