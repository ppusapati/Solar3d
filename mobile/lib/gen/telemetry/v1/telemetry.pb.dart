//
//  Generated code. Do not modify.
//  source: telemetry/v1/telemetry.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $0;
import 'telemetry.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'telemetry.pbenum.dart';

/// SensorReading is a single time-stamped measurement from a physical or virtual
/// sensor associated with a digital twin.
class SensorReading extends $pb.GeneratedMessage {
  factory SensorReading({
    $core.String? id,
    $core.String? twinId,
    $core.String? sensorId,
    $core.String? assetIdentityId,
    TelemetryMetric? metric,
    $core.double? value,
    $core.String? unit,
    ReadingQuality? quality,
    $0.Timestamp? recordedAt,
    $0.Timestamp? ingestedAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (sensorId != null) {
      $result.sensorId = sensorId;
    }
    if (assetIdentityId != null) {
      $result.assetIdentityId = assetIdentityId;
    }
    if (metric != null) {
      $result.metric = metric;
    }
    if (value != null) {
      $result.value = value;
    }
    if (unit != null) {
      $result.unit = unit;
    }
    if (quality != null) {
      $result.quality = quality;
    }
    if (recordedAt != null) {
      $result.recordedAt = recordedAt;
    }
    if (ingestedAt != null) {
      $result.ingestedAt = ingestedAt;
    }
    return $result;
  }
  SensorReading._() : super();
  factory SensorReading.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SensorReading.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SensorReading', package: const $pb.PackageName(_omitMessageNames ? '' : 'telemetry.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'twinId')
    ..aOS(3, _omitFieldNames ? '' : 'sensorId')
    ..aOS(4, _omitFieldNames ? '' : 'assetIdentityId')
    ..e<TelemetryMetric>(5, _omitFieldNames ? '' : 'metric', $pb.PbFieldType.OE, defaultOrMaker: TelemetryMetric.TELEMETRY_METRIC_UNSPECIFIED, valueOf: TelemetryMetric.valueOf, enumValues: TelemetryMetric.values)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'value', $pb.PbFieldType.OD)
    ..aOS(7, _omitFieldNames ? '' : 'unit')
    ..e<ReadingQuality>(8, _omitFieldNames ? '' : 'quality', $pb.PbFieldType.OE, defaultOrMaker: ReadingQuality.READING_QUALITY_UNSPECIFIED, valueOf: ReadingQuality.valueOf, enumValues: ReadingQuality.values)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'recordedAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'ingestedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SensorReading clone() => SensorReading()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SensorReading copyWith(void Function(SensorReading) updates) => super.copyWith((message) => updates(message as SensorReading)) as SensorReading;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SensorReading create() => SensorReading._();
  SensorReading createEmptyInstance() => create();
  static $pb.PbList<SensorReading> createRepeated() => $pb.PbList<SensorReading>();
  @$core.pragma('dart2js:noInline')
  static SensorReading getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SensorReading>(create);
  static SensorReading? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// twin_id: The digital twin this reading belongs to.
  @$pb.TagNumber(2)
  $core.String get twinId => $_getSZ(1);
  @$pb.TagNumber(2)
  set twinId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTwinId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTwinId() => $_clearField(2);

  /// sensor_id: Physical sensor identifier (e.g., SCADA tag, meter serial + channel).
  @$pb.TagNumber(3)
  $core.String get sensorId => $_getSZ(2);
  @$pb.TagNumber(3)
  set sensorId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSensorId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSensorId() => $_clearField(3);

  /// asset_identity_id: Optional link to the AssetIdentity record for the physical asset.
  @$pb.TagNumber(4)
  $core.String get assetIdentityId => $_getSZ(3);
  @$pb.TagNumber(4)
  set assetIdentityId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAssetIdentityId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAssetIdentityId() => $_clearField(4);

  @$pb.TagNumber(5)
  TelemetryMetric get metric => $_getN(4);
  @$pb.TagNumber(5)
  set metric(TelemetryMetric v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasMetric() => $_has(4);
  @$pb.TagNumber(5)
  void clearMetric() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get value => $_getN(5);
  @$pb.TagNumber(6)
  set value($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearValue() => $_clearField(6);

  /// unit: SI unit string (e.g., "kW", "kWh", "°C", "V", "A", "W/m²").
  @$pb.TagNumber(7)
  $core.String get unit => $_getSZ(6);
  @$pb.TagNumber(7)
  set unit($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasUnit() => $_has(6);
  @$pb.TagNumber(7)
  void clearUnit() => $_clearField(7);

  @$pb.TagNumber(8)
  ReadingQuality get quality => $_getN(7);
  @$pb.TagNumber(8)
  set quality(ReadingQuality v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasQuality() => $_has(7);
  @$pb.TagNumber(8)
  void clearQuality() => $_clearField(8);

  /// recorded_at: When the physical sensor captured the measurement.
  @$pb.TagNumber(9)
  $0.Timestamp get recordedAt => $_getN(8);
  @$pb.TagNumber(9)
  set recordedAt($0.Timestamp v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasRecordedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearRecordedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureRecordedAt() => $_ensure(8);

  /// ingested_at: Server receive timestamp; set by the service on write.
  @$pb.TagNumber(10)
  $0.Timestamp get ingestedAt => $_getN(9);
  @$pb.TagNumber(10)
  set ingestedAt($0.Timestamp v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasIngestedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearIngestedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureIngestedAt() => $_ensure(9);
}

/// AggregatedMetric holds pre-computed statistics for a metric over a time window.
class AggregatedMetric extends $pb.GeneratedMessage {
  factory AggregatedMetric({
    $core.String? twinId,
    TelemetryMetric? metric,
    $0.Timestamp? windowStart,
    $0.Timestamp? windowEnd,
    $core.double? minValue,
    $core.double? maxValue,
    $core.double? avgValue,
    $core.double? sumValue,
    $core.int? readingCount,
  }) {
    final $result = create();
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (metric != null) {
      $result.metric = metric;
    }
    if (windowStart != null) {
      $result.windowStart = windowStart;
    }
    if (windowEnd != null) {
      $result.windowEnd = windowEnd;
    }
    if (minValue != null) {
      $result.minValue = minValue;
    }
    if (maxValue != null) {
      $result.maxValue = maxValue;
    }
    if (avgValue != null) {
      $result.avgValue = avgValue;
    }
    if (sumValue != null) {
      $result.sumValue = sumValue;
    }
    if (readingCount != null) {
      $result.readingCount = readingCount;
    }
    return $result;
  }
  AggregatedMetric._() : super();
  factory AggregatedMetric.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AggregatedMetric.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AggregatedMetric', package: const $pb.PackageName(_omitMessageNames ? '' : 'telemetry.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'twinId')
    ..e<TelemetryMetric>(2, _omitFieldNames ? '' : 'metric', $pb.PbFieldType.OE, defaultOrMaker: TelemetryMetric.TELEMETRY_METRIC_UNSPECIFIED, valueOf: TelemetryMetric.valueOf, enumValues: TelemetryMetric.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'windowStart', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'windowEnd', subBuilder: $0.Timestamp.create)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'minValue', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'maxValue', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'avgValue', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'sumValue', $pb.PbFieldType.OD)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'readingCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AggregatedMetric clone() => AggregatedMetric()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AggregatedMetric copyWith(void Function(AggregatedMetric) updates) => super.copyWith((message) => updates(message as AggregatedMetric)) as AggregatedMetric;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AggregatedMetric create() => AggregatedMetric._();
  AggregatedMetric createEmptyInstance() => create();
  static $pb.PbList<AggregatedMetric> createRepeated() => $pb.PbList<AggregatedMetric>();
  @$core.pragma('dart2js:noInline')
  static AggregatedMetric getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AggregatedMetric>(create);
  static AggregatedMetric? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get twinId => $_getSZ(0);
  @$pb.TagNumber(1)
  set twinId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwinId() => $_clearField(1);

  @$pb.TagNumber(2)
  TelemetryMetric get metric => $_getN(1);
  @$pb.TagNumber(2)
  set metric(TelemetryMetric v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasMetric() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetric() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get windowStart => $_getN(2);
  @$pb.TagNumber(3)
  set windowStart($0.Timestamp v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasWindowStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearWindowStart() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureWindowStart() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get windowEnd => $_getN(3);
  @$pb.TagNumber(4)
  set windowEnd($0.Timestamp v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasWindowEnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearWindowEnd() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureWindowEnd() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.double get minValue => $_getN(4);
  @$pb.TagNumber(5)
  set minValue($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMinValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearMinValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get maxValue => $_getN(5);
  @$pb.TagNumber(6)
  set maxValue($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMaxValue() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxValue() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get avgValue => $_getN(6);
  @$pb.TagNumber(7)
  set avgValue($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAvgValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearAvgValue() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get sumValue => $_getN(7);
  @$pb.TagNumber(8)
  set sumValue($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSumValue() => $_has(7);
  @$pb.TagNumber(8)
  void clearSumValue() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get readingCount => $_getIZ(8);
  @$pb.TagNumber(9)
  set readingCount($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasReadingCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearReadingCount() => $_clearField(9);
}

class IngestReadingsRequest extends $pb.GeneratedMessage {
  factory IngestReadingsRequest({
    $core.String? twinId,
    $core.Iterable<SensorReading>? readings,
  }) {
    final $result = create();
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (readings != null) {
      $result.readings.addAll(readings);
    }
    return $result;
  }
  IngestReadingsRequest._() : super();
  factory IngestReadingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IngestReadingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'IngestReadingsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'telemetry.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'twinId')
    ..pc<SensorReading>(2, _omitFieldNames ? '' : 'readings', $pb.PbFieldType.PM, subBuilder: SensorReading.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IngestReadingsRequest clone() => IngestReadingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IngestReadingsRequest copyWith(void Function(IngestReadingsRequest) updates) => super.copyWith((message) => updates(message as IngestReadingsRequest)) as IngestReadingsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngestReadingsRequest create() => IngestReadingsRequest._();
  IngestReadingsRequest createEmptyInstance() => create();
  static $pb.PbList<IngestReadingsRequest> createRepeated() => $pb.PbList<IngestReadingsRequest>();
  @$core.pragma('dart2js:noInline')
  static IngestReadingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IngestReadingsRequest>(create);
  static IngestReadingsRequest? _defaultInstance;

  /// twin_id: Must correspond to an ACTIVE DigitalTwin; rejected otherwise.
  @$pb.TagNumber(1)
  $core.String get twinId => $_getSZ(0);
  @$pb.TagNumber(1)
  set twinId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwinId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<SensorReading> get readings => $_getList(1);
}

class IngestReadingsResponse extends $pb.GeneratedMessage {
  factory IngestReadingsResponse({
    $core.int? acceptedCount,
    $core.int? rejectedCount,
  }) {
    final $result = create();
    if (acceptedCount != null) {
      $result.acceptedCount = acceptedCount;
    }
    if (rejectedCount != null) {
      $result.rejectedCount = rejectedCount;
    }
    return $result;
  }
  IngestReadingsResponse._() : super();
  factory IngestReadingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory IngestReadingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'IngestReadingsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'telemetry.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'acceptedCount', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'rejectedCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  IngestReadingsResponse clone() => IngestReadingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  IngestReadingsResponse copyWith(void Function(IngestReadingsResponse) updates) => super.copyWith((message) => updates(message as IngestReadingsResponse)) as IngestReadingsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IngestReadingsResponse create() => IngestReadingsResponse._();
  IngestReadingsResponse createEmptyInstance() => create();
  static $pb.PbList<IngestReadingsResponse> createRepeated() => $pb.PbList<IngestReadingsResponse>();
  @$core.pragma('dart2js:noInline')
  static IngestReadingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IngestReadingsResponse>(create);
  static IngestReadingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get acceptedCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set acceptedCount($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAcceptedCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearAcceptedCount() => $_clearField(1);

  /// rejected_count: Readings that failed validation (bad format, unknown metric).
  /// Partial failures are not supported; if any reading is invalid the entire batch
  /// is rejected and accepted_count = 0.
  @$pb.TagNumber(2)
  $core.int get rejectedCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set rejectedCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRejectedCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearRejectedCount() => $_clearField(2);
}

class GetLatestReadingsRequest extends $pb.GeneratedMessage {
  factory GetLatestReadingsRequest({
    $core.String? twinId,
    $core.Iterable<TelemetryMetric>? metricFilter,
  }) {
    final $result = create();
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (metricFilter != null) {
      $result.metricFilter.addAll(metricFilter);
    }
    return $result;
  }
  GetLatestReadingsRequest._() : super();
  factory GetLatestReadingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetLatestReadingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetLatestReadingsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'telemetry.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'twinId')
    ..pc<TelemetryMetric>(2, _omitFieldNames ? '' : 'metricFilter', $pb.PbFieldType.KE, valueOf: TelemetryMetric.valueOf, enumValues: TelemetryMetric.values, defaultEnumValue: TelemetryMetric.TELEMETRY_METRIC_UNSPECIFIED)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetLatestReadingsRequest clone() => GetLatestReadingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetLatestReadingsRequest copyWith(void Function(GetLatestReadingsRequest) updates) => super.copyWith((message) => updates(message as GetLatestReadingsRequest)) as GetLatestReadingsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLatestReadingsRequest create() => GetLatestReadingsRequest._();
  GetLatestReadingsRequest createEmptyInstance() => create();
  static $pb.PbList<GetLatestReadingsRequest> createRepeated() => $pb.PbList<GetLatestReadingsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetLatestReadingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLatestReadingsRequest>(create);
  static GetLatestReadingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get twinId => $_getSZ(0);
  @$pb.TagNumber(1)
  set twinId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwinId() => $_clearField(1);

  /// metric_filter: If empty, returns latest reading for all available metrics.
  @$pb.TagNumber(2)
  $pb.PbList<TelemetryMetric> get metricFilter => $_getList(1);
}

class GetLatestReadingsResponse extends $pb.GeneratedMessage {
  factory GetLatestReadingsResponse({
    $core.Iterable<SensorReading>? readings,
  }) {
    final $result = create();
    if (readings != null) {
      $result.readings.addAll(readings);
    }
    return $result;
  }
  GetLatestReadingsResponse._() : super();
  factory GetLatestReadingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetLatestReadingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetLatestReadingsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'telemetry.v1'), createEmptyInstance: create)
    ..pc<SensorReading>(1, _omitFieldNames ? '' : 'readings', $pb.PbFieldType.PM, subBuilder: SensorReading.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetLatestReadingsResponse clone() => GetLatestReadingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetLatestReadingsResponse copyWith(void Function(GetLatestReadingsResponse) updates) => super.copyWith((message) => updates(message as GetLatestReadingsResponse)) as GetLatestReadingsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetLatestReadingsResponse create() => GetLatestReadingsResponse._();
  GetLatestReadingsResponse createEmptyInstance() => create();
  static $pb.PbList<GetLatestReadingsResponse> createRepeated() => $pb.PbList<GetLatestReadingsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetLatestReadingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLatestReadingsResponse>(create);
  static GetLatestReadingsResponse? _defaultInstance;

  /// readings: One entry per distinct metric; ordered by metric enum value.
  @$pb.TagNumber(1)
  $pb.PbList<SensorReading> get readings => $_getList(0);
}

class ListReadingsRequest extends $pb.GeneratedMessage {
  factory ListReadingsRequest({
    $core.String? twinId,
    TelemetryMetric? metricFilter,
    $0.Timestamp? windowStart,
    $0.Timestamp? windowEnd,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final $result = create();
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (metricFilter != null) {
      $result.metricFilter = metricFilter;
    }
    if (windowStart != null) {
      $result.windowStart = windowStart;
    }
    if (windowEnd != null) {
      $result.windowEnd = windowEnd;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    if (pageToken != null) {
      $result.pageToken = pageToken;
    }
    return $result;
  }
  ListReadingsRequest._() : super();
  factory ListReadingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListReadingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListReadingsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'telemetry.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'twinId')
    ..e<TelemetryMetric>(2, _omitFieldNames ? '' : 'metricFilter', $pb.PbFieldType.OE, defaultOrMaker: TelemetryMetric.TELEMETRY_METRIC_UNSPECIFIED, valueOf: TelemetryMetric.valueOf, enumValues: TelemetryMetric.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'windowStart', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'windowEnd', subBuilder: $0.Timestamp.create)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOS(6, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListReadingsRequest clone() => ListReadingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListReadingsRequest copyWith(void Function(ListReadingsRequest) updates) => super.copyWith((message) => updates(message as ListReadingsRequest)) as ListReadingsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReadingsRequest create() => ListReadingsRequest._();
  ListReadingsRequest createEmptyInstance() => create();
  static $pb.PbList<ListReadingsRequest> createRepeated() => $pb.PbList<ListReadingsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListReadingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListReadingsRequest>(create);
  static ListReadingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get twinId => $_getSZ(0);
  @$pb.TagNumber(1)
  set twinId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwinId() => $_clearField(1);

  /// metric_filter: If empty, returns readings for all metrics in window.
  @$pb.TagNumber(2)
  TelemetryMetric get metricFilter => $_getN(1);
  @$pb.TagNumber(2)
  set metricFilter(TelemetryMetric v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasMetricFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetricFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get windowStart => $_getN(2);
  @$pb.TagNumber(3)
  set windowStart($0.Timestamp v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasWindowStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearWindowStart() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureWindowStart() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get windowEnd => $_getN(3);
  @$pb.TagNumber(4)
  set windowEnd($0.Timestamp v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasWindowEnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearWindowEnd() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureWindowEnd() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get pageSize => $_getIZ(4);
  @$pb.TagNumber(5)
  set pageSize($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPageSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearPageSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get pageToken => $_getSZ(5);
  @$pb.TagNumber(6)
  set pageToken($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPageToken() => $_has(5);
  @$pb.TagNumber(6)
  void clearPageToken() => $_clearField(6);
}

class ListReadingsResponse extends $pb.GeneratedMessage {
  factory ListReadingsResponse({
    $core.Iterable<SensorReading>? readings,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final $result = create();
    if (readings != null) {
      $result.readings.addAll(readings);
    }
    if (nextPageToken != null) {
      $result.nextPageToken = nextPageToken;
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    return $result;
  }
  ListReadingsResponse._() : super();
  factory ListReadingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListReadingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListReadingsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'telemetry.v1'), createEmptyInstance: create)
    ..pc<SensorReading>(1, _omitFieldNames ? '' : 'readings', $pb.PbFieldType.PM, subBuilder: SensorReading.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListReadingsResponse clone() => ListReadingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListReadingsResponse copyWith(void Function(ListReadingsResponse) updates) => super.copyWith((message) => updates(message as ListReadingsResponse)) as ListReadingsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListReadingsResponse create() => ListReadingsResponse._();
  ListReadingsResponse createEmptyInstance() => create();
  static $pb.PbList<ListReadingsResponse> createRepeated() => $pb.PbList<ListReadingsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListReadingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListReadingsResponse>(create);
  static ListReadingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SensorReading> get readings => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get nextPageToken => $_getSZ(1);
  @$pb.TagNumber(2)
  set nextPageToken($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNextPageToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearNextPageToken() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalCount($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);
}

class GetAggregatedMetricsRequest extends $pb.GeneratedMessage {
  factory GetAggregatedMetricsRequest({
    $core.String? twinId,
    TelemetryMetric? metric,
    $0.Timestamp? windowStart,
    $0.Timestamp? windowEnd,
  }) {
    final $result = create();
    if (twinId != null) {
      $result.twinId = twinId;
    }
    if (metric != null) {
      $result.metric = metric;
    }
    if (windowStart != null) {
      $result.windowStart = windowStart;
    }
    if (windowEnd != null) {
      $result.windowEnd = windowEnd;
    }
    return $result;
  }
  GetAggregatedMetricsRequest._() : super();
  factory GetAggregatedMetricsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetAggregatedMetricsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetAggregatedMetricsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'telemetry.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'twinId')
    ..e<TelemetryMetric>(2, _omitFieldNames ? '' : 'metric', $pb.PbFieldType.OE, defaultOrMaker: TelemetryMetric.TELEMETRY_METRIC_UNSPECIFIED, valueOf: TelemetryMetric.valueOf, enumValues: TelemetryMetric.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'windowStart', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'windowEnd', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetAggregatedMetricsRequest clone() => GetAggregatedMetricsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetAggregatedMetricsRequest copyWith(void Function(GetAggregatedMetricsRequest) updates) => super.copyWith((message) => updates(message as GetAggregatedMetricsRequest)) as GetAggregatedMetricsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAggregatedMetricsRequest create() => GetAggregatedMetricsRequest._();
  GetAggregatedMetricsRequest createEmptyInstance() => create();
  static $pb.PbList<GetAggregatedMetricsRequest> createRepeated() => $pb.PbList<GetAggregatedMetricsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetAggregatedMetricsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetAggregatedMetricsRequest>(create);
  static GetAggregatedMetricsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get twinId => $_getSZ(0);
  @$pb.TagNumber(1)
  set twinId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTwinId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTwinId() => $_clearField(1);

  @$pb.TagNumber(2)
  TelemetryMetric get metric => $_getN(1);
  @$pb.TagNumber(2)
  set metric(TelemetryMetric v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasMetric() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetric() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get windowStart => $_getN(2);
  @$pb.TagNumber(3)
  set windowStart($0.Timestamp v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasWindowStart() => $_has(2);
  @$pb.TagNumber(3)
  void clearWindowStart() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureWindowStart() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Timestamp get windowEnd => $_getN(3);
  @$pb.TagNumber(4)
  set windowEnd($0.Timestamp v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasWindowEnd() => $_has(3);
  @$pb.TagNumber(4)
  void clearWindowEnd() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureWindowEnd() => $_ensure(3);
}

class GetAggregatedMetricsResponse extends $pb.GeneratedMessage {
  factory GetAggregatedMetricsResponse({
    AggregatedMetric? aggregatedMetric,
  }) {
    final $result = create();
    if (aggregatedMetric != null) {
      $result.aggregatedMetric = aggregatedMetric;
    }
    return $result;
  }
  GetAggregatedMetricsResponse._() : super();
  factory GetAggregatedMetricsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetAggregatedMetricsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetAggregatedMetricsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'telemetry.v1'), createEmptyInstance: create)
    ..aOM<AggregatedMetric>(1, _omitFieldNames ? '' : 'aggregatedMetric', subBuilder: AggregatedMetric.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetAggregatedMetricsResponse clone() => GetAggregatedMetricsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetAggregatedMetricsResponse copyWith(void Function(GetAggregatedMetricsResponse) updates) => super.copyWith((message) => updates(message as GetAggregatedMetricsResponse)) as GetAggregatedMetricsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetAggregatedMetricsResponse create() => GetAggregatedMetricsResponse._();
  GetAggregatedMetricsResponse createEmptyInstance() => create();
  static $pb.PbList<GetAggregatedMetricsResponse> createRepeated() => $pb.PbList<GetAggregatedMetricsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetAggregatedMetricsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetAggregatedMetricsResponse>(create);
  static GetAggregatedMetricsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AggregatedMetric get aggregatedMetric => $_getN(0);
  @$pb.TagNumber(1)
  set aggregatedMetric(AggregatedMetric v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAggregatedMetric() => $_has(0);
  @$pb.TagNumber(1)
  void clearAggregatedMetric() => $_clearField(1);
  @$pb.TagNumber(1)
  AggregatedMetric ensureAggregatedMetric() => $_ensure(0);
}

/// TelemetryService manages ingestion and retrieval of time-series sensor readings
/// from provisioned digital twins.  Storage backend uses PostgreSQL with a
/// TimescaleDB hypertable partitioned on recorded_at (Option A per Pre-Implementation
/// Locked Decisions).  Ingest batches are atomic: all readings succeed or none persist.
class TelemetryServiceApi {
  $pb.RpcClient _client;
  TelemetryServiceApi(this._client);

  /// IngestReadings stores a batch of sensor readings for a twin in a single
  /// atomic transaction.  Returns the count of accepted readings.
  /// Returns NOT_FOUND if the twin_id does not correspond to an ACTIVE twin.
  $async.Future<IngestReadingsResponse> ingestReadings($pb.ClientContext? ctx, IngestReadingsRequest request) =>
    _client.invoke<IngestReadingsResponse>(ctx, 'TelemetryService', 'IngestReadings', request, IngestReadingsResponse())
  ;
  /// GetLatestReadings returns the single most recent reading per metric for a twin.
  /// Useful for dashboard snapshots; does not paginate.
  $async.Future<GetLatestReadingsResponse> getLatestReadings($pb.ClientContext? ctx, GetLatestReadingsRequest request) =>
    _client.invoke<GetLatestReadingsResponse>(ctx, 'TelemetryService', 'GetLatestReadings', request, GetLatestReadingsResponse())
  ;
  /// ListReadings returns readings for a twin within a time window, optionally
  /// filtered by metric. Results are ordered by recorded_at ascending.
  /// Maximum 1000 readings per call; use page_token for continuation.
  $async.Future<ListReadingsResponse> listReadings($pb.ClientContext? ctx, ListReadingsRequest request) =>
    _client.invoke<ListReadingsResponse>(ctx, 'TelemetryService', 'ListReadings', request, ListReadingsResponse())
  ;
  /// GetAggregatedMetrics returns min/max/avg/sum aggregates over a time window
  /// for a specified metric and twin.  Window is inclusive on both ends.
  $async.Future<GetAggregatedMetricsResponse> getAggregatedMetrics($pb.ClientContext? ctx, GetAggregatedMetricsRequest request) =>
    _client.invoke<GetAggregatedMetricsResponse>(ctx, 'TelemetryService', 'GetAggregatedMetrics', request, GetAggregatedMetricsResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
