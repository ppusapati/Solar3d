//
//  Generated code. Do not modify.
//  source: telemetry/v1/telemetry.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// TelemetryMetric enumerates the measurable quantities producible by solar plant
/// sensors, SCADA systems, and protection relays.  Aligned with IEC 61724-1
/// performance monitoring terminology where applicable.
class TelemetryMetric extends $pb.ProtobufEnum {
  static const TelemetryMetric TELEMETRY_METRIC_UNSPECIFIED = TelemetryMetric._(0, _omitEnumNames ? '' : 'TELEMETRY_METRIC_UNSPECIFIED');
  /// AC power output of inverter or plant aggregate (kW).
  static const TelemetryMetric TELEMETRY_METRIC_POWER_KW = TelemetryMetric._(1, _omitEnumNames ? '' : 'TELEMETRY_METRIC_POWER_KW');
  /// Cumulative energy production (kWh).
  static const TelemetryMetric TELEMETRY_METRIC_ENERGY_KWH = TelemetryMetric._(2, _omitEnumNames ? '' : 'TELEMETRY_METRIC_ENERGY_KWH');
  /// Global horizontal or plane-of-array irradiance (W/m²).
  static const TelemetryMetric TELEMETRY_METRIC_IRRADIANCE_W_M2 = TelemetryMetric._(3, _omitEnumNames ? '' : 'TELEMETRY_METRIC_IRRADIANCE_W_M2');
  /// Ambient air temperature (°C).
  static const TelemetryMetric TELEMETRY_METRIC_AMBIENT_TEMP_C = TelemetryMetric._(4, _omitEnumNames ? '' : 'TELEMETRY_METRIC_AMBIENT_TEMP_C');
  /// PV module back-sheet temperature (°C).
  static const TelemetryMetric TELEMETRY_METRIC_MODULE_TEMP_C = TelemetryMetric._(5, _omitEnumNames ? '' : 'TELEMETRY_METRIC_MODULE_TEMP_C');
  /// Wind speed at hub height (m/s).
  static const TelemetryMetric TELEMETRY_METRIC_WIND_SPEED_MS = TelemetryMetric._(6, _omitEnumNames ? '' : 'TELEMETRY_METRIC_WIND_SPEED_MS');
  /// DC string or combiner bus voltage (V).
  static const TelemetryMetric TELEMETRY_METRIC_DC_VOLTAGE_V = TelemetryMetric._(7, _omitEnumNames ? '' : 'TELEMETRY_METRIC_DC_VOLTAGE_V');
  /// DC string current (A).
  static const TelemetryMetric TELEMETRY_METRIC_DC_CURRENT_A = TelemetryMetric._(8, _omitEnumNames ? '' : 'TELEMETRY_METRIC_DC_CURRENT_A');
  /// AC bus voltage (V).
  static const TelemetryMetric TELEMETRY_METRIC_AC_VOLTAGE_V = TelemetryMetric._(9, _omitEnumNames ? '' : 'TELEMETRY_METRIC_AC_VOLTAGE_V');
  /// AC output current (A).
  static const TelemetryMetric TELEMETRY_METRIC_AC_CURRENT_A = TelemetryMetric._(10, _omitEnumNames ? '' : 'TELEMETRY_METRIC_AC_CURRENT_A');
  /// Inverter conversion efficiency [0, 1].
  static const TelemetryMetric TELEMETRY_METRIC_INVERTER_EFFICIENCY = TelemetryMetric._(11, _omitEnumNames ? '' : 'TELEMETRY_METRIC_INVERTER_EFFICIENCY');
  /// Plant availability fraction [0, 1] per IEC 61724-1.
  static const TelemetryMetric TELEMETRY_METRIC_AVAILABILITY = TelemetryMetric._(12, _omitEnumNames ? '' : 'TELEMETRY_METRIC_AVAILABILITY');

  static const $core.List<TelemetryMetric> values = <TelemetryMetric> [
    TELEMETRY_METRIC_UNSPECIFIED,
    TELEMETRY_METRIC_POWER_KW,
    TELEMETRY_METRIC_ENERGY_KWH,
    TELEMETRY_METRIC_IRRADIANCE_W_M2,
    TELEMETRY_METRIC_AMBIENT_TEMP_C,
    TELEMETRY_METRIC_MODULE_TEMP_C,
    TELEMETRY_METRIC_WIND_SPEED_MS,
    TELEMETRY_METRIC_DC_VOLTAGE_V,
    TELEMETRY_METRIC_DC_CURRENT_A,
    TELEMETRY_METRIC_AC_VOLTAGE_V,
    TELEMETRY_METRIC_AC_CURRENT_A,
    TELEMETRY_METRIC_INVERTER_EFFICIENCY,
    TELEMETRY_METRIC_AVAILABILITY,
  ];

  static final $core.Map<$core.int, TelemetryMetric> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TelemetryMetric? valueOf($core.int value) => _byValue[value];

  const TelemetryMetric._(super.v, super.n);
}

/// ReadingQuality indicates the confidence level of individual sensor readings.
/// Aligned with IEC 61968 data quality classifications.
class ReadingQuality extends $pb.ProtobufEnum {
  static const ReadingQuality READING_QUALITY_UNSPECIFIED = ReadingQuality._(0, _omitEnumNames ? '' : 'READING_QUALITY_UNSPECIFIED');
  /// READING_QUALITY_GOOD: Reading within expected sensor range; no anomalies detected.
  static const ReadingQuality READING_QUALITY_GOOD = ReadingQuality._(1, _omitEnumNames ? '' : 'READING_QUALITY_GOOD');
  /// READING_QUALITY_SUSPECT: Reading is outside expected range or came from a
  /// sensor with a recent calibration gap; use with caution.
  static const ReadingQuality READING_QUALITY_SUSPECT = ReadingQuality._(2, _omitEnumNames ? '' : 'READING_QUALITY_SUSPECT');
  /// READING_QUALITY_BAD: Sensor hardware fault or communication error; value unreliable.
  static const ReadingQuality READING_QUALITY_BAD = ReadingQuality._(3, _omitEnumNames ? '' : 'READING_QUALITY_BAD');

  static const $core.List<ReadingQuality> values = <ReadingQuality> [
    READING_QUALITY_UNSPECIFIED,
    READING_QUALITY_GOOD,
    READING_QUALITY_SUSPECT,
    READING_QUALITY_BAD,
  ];

  static final $core.Map<$core.int, ReadingQuality> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ReadingQuality? valueOf($core.int value) => _byValue[value];

  const ReadingQuality._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
