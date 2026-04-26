//
//  Generated code. Do not modify.
//  source: weather/v1/weather.proto
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
import 'weather.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'weather.pbenum.dart';

/// HourlyRecord is a single-hour observation or modeled irradiance sample.
/// All irradiance values are in W/m². Temperature in °C. Wind speed in m/s.
class HourlyRecord extends $pb.GeneratedMessage {
  factory HourlyRecord({
    $0.Timestamp? timestamp,
    $core.double? ghi,
    $core.double? dni,
    $core.double? dhi,
    $core.double? ambientTempC,
    $core.double? windSpeedMs,
    $core.double? relativeHumidityPct,
    $core.double? albedo,
  }) {
    final $result = create();
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (ghi != null) {
      $result.ghi = ghi;
    }
    if (dni != null) {
      $result.dni = dni;
    }
    if (dhi != null) {
      $result.dhi = dhi;
    }
    if (ambientTempC != null) {
      $result.ambientTempC = ambientTempC;
    }
    if (windSpeedMs != null) {
      $result.windSpeedMs = windSpeedMs;
    }
    if (relativeHumidityPct != null) {
      $result.relativeHumidityPct = relativeHumidityPct;
    }
    if (albedo != null) {
      $result.albedo = albedo;
    }
    return $result;
  }
  HourlyRecord._() : super();
  factory HourlyRecord.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HourlyRecord.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HourlyRecord', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'ghi', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'dni', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'dhi', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'ambientTempC', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'windSpeedMs', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'relativeHumidityPct', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'albedo', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HourlyRecord clone() => HourlyRecord()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HourlyRecord copyWith(void Function(HourlyRecord) updates) => super.copyWith((message) => updates(message as HourlyRecord)) as HourlyRecord;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HourlyRecord create() => HourlyRecord._();
  HourlyRecord createEmptyInstance() => create();
  static $pb.PbList<HourlyRecord> createRepeated() => $pb.PbList<HourlyRecord>();
  @$core.pragma('dart2js:noInline')
  static HourlyRecord getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HourlyRecord>(create);
  static HourlyRecord? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get timestamp => $_getN(0);
  @$pb.TagNumber(1)
  set timestamp($0.Timestamp v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimestamp() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestamp() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureTimestamp() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get ghi => $_getN(1);
  @$pb.TagNumber(2)
  set ghi($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGhi() => $_has(1);
  @$pb.TagNumber(2)
  void clearGhi() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get dni => $_getN(2);
  @$pb.TagNumber(3)
  set dni($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDni() => $_has(2);
  @$pb.TagNumber(3)
  void clearDni() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get dhi => $_getN(3);
  @$pb.TagNumber(4)
  set dhi($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDhi() => $_has(3);
  @$pb.TagNumber(4)
  void clearDhi() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get ambientTempC => $_getN(4);
  @$pb.TagNumber(5)
  set ambientTempC($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAmbientTempC() => $_has(4);
  @$pb.TagNumber(5)
  void clearAmbientTempC() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get windSpeedMs => $_getN(5);
  @$pb.TagNumber(6)
  set windSpeedMs($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasWindSpeedMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearWindSpeedMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get relativeHumidityPct => $_getN(6);
  @$pb.TagNumber(7)
  set relativeHumidityPct($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasRelativeHumidityPct() => $_has(6);
  @$pb.TagNumber(7)
  void clearRelativeHumidityPct() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get albedo => $_getN(7);
  @$pb.TagNumber(8)
  set albedo($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasAlbedo() => $_has(7);
  @$pb.TagNumber(8)
  void clearAlbedo() => $_clearField(8);
}

/// SiteWeatherSummary is the metadata envelope for a stored weather dataset.
class SiteWeatherSummary extends $pb.GeneratedMessage {
  factory SiteWeatherSummary({
    $core.String? id,
    $core.String? projectId,
    $core.double? latitude,
    $core.double? longitude,
    WeatherSource? source,
    $core.int? recordCount,
    $core.double? annualGhiKwhM2,
    $0.Timestamp? fetchedAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (source != null) {
      $result.source = source;
    }
    if (recordCount != null) {
      $result.recordCount = recordCount;
    }
    if (annualGhiKwhM2 != null) {
      $result.annualGhiKwhM2 = annualGhiKwhM2;
    }
    if (fetchedAt != null) {
      $result.fetchedAt = fetchedAt;
    }
    return $result;
  }
  SiteWeatherSummary._() : super();
  factory SiteWeatherSummary.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SiteWeatherSummary.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SiteWeatherSummary', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..e<WeatherSource>(5, _omitFieldNames ? '' : 'source', $pb.PbFieldType.OE, defaultOrMaker: WeatherSource.WEATHER_SOURCE_UNSPECIFIED, valueOf: WeatherSource.valueOf, enumValues: WeatherSource.values)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'recordCount', $pb.PbFieldType.O3)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'annualGhiKwhM2', $pb.PbFieldType.OD)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'fetchedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SiteWeatherSummary clone() => SiteWeatherSummary()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SiteWeatherSummary copyWith(void Function(SiteWeatherSummary) updates) => super.copyWith((message) => updates(message as SiteWeatherSummary)) as SiteWeatherSummary;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SiteWeatherSummary create() => SiteWeatherSummary._();
  SiteWeatherSummary createEmptyInstance() => create();
  static $pb.PbList<SiteWeatherSummary> createRepeated() => $pb.PbList<SiteWeatherSummary>();
  @$core.pragma('dart2js:noInline')
  static SiteWeatherSummary getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SiteWeatherSummary>(create);
  static SiteWeatherSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get projectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set projectId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get latitude => $_getN(2);
  @$pb.TagNumber(3)
  set latitude($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLatitude() => $_has(2);
  @$pb.TagNumber(3)
  void clearLatitude() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get longitude => $_getN(3);
  @$pb.TagNumber(4)
  set longitude($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLongitude() => $_has(3);
  @$pb.TagNumber(4)
  void clearLongitude() => $_clearField(4);

  @$pb.TagNumber(5)
  WeatherSource get source => $_getN(4);
  @$pb.TagNumber(5)
  set source(WeatherSource v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearSource() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get recordCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set recordCount($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRecordCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearRecordCount() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get annualGhiKwhM2 => $_getN(6);
  @$pb.TagNumber(7)
  set annualGhiKwhM2($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAnnualGhiKwhM2() => $_has(6);
  @$pb.TagNumber(7)
  void clearAnnualGhiKwhM2() => $_clearField(7);

  @$pb.TagNumber(8)
  $0.Timestamp get fetchedAt => $_getN(7);
  @$pb.TagNumber(8)
  set fetchedAt($0.Timestamp v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasFetchedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearFetchedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureFetchedAt() => $_ensure(7);
}

/// YieldExceedance holds a single percentile point.
class YieldExceedance extends $pb.GeneratedMessage {
  factory YieldExceedance({
    $core.int? percentile,
    $core.double? annualGhiKwhM2,
  }) {
    final $result = create();
    if (percentile != null) {
      $result.percentile = percentile;
    }
    if (annualGhiKwhM2 != null) {
      $result.annualGhiKwhM2 = annualGhiKwhM2;
    }
    return $result;
  }
  YieldExceedance._() : super();
  factory YieldExceedance.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory YieldExceedance.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'YieldExceedance', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'percentile', $pb.PbFieldType.O3)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'annualGhiKwhM2', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  YieldExceedance clone() => YieldExceedance()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  YieldExceedance copyWith(void Function(YieldExceedance) updates) => super.copyWith((message) => updates(message as YieldExceedance)) as YieldExceedance;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YieldExceedance create() => YieldExceedance._();
  YieldExceedance createEmptyInstance() => create();
  static $pb.PbList<YieldExceedance> createRepeated() => $pb.PbList<YieldExceedance>();
  @$core.pragma('dart2js:noInline')
  static YieldExceedance getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<YieldExceedance>(create);
  static YieldExceedance? _defaultInstance;

  /// percentile is 50, 75, 90, 95, or 99.
  @$pb.TagNumber(1)
  $core.int get percentile => $_getIZ(0);
  @$pb.TagNumber(1)
  set percentile($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPercentile() => $_has(0);
  @$pb.TagNumber(1)
  void clearPercentile() => $_clearField(1);

  /// annual_ghi_kwh_m2 is the GHI value exceeded at this probability.
  @$pb.TagNumber(2)
  $core.double get annualGhiKwhM2 => $_getN(1);
  @$pb.TagNumber(2)
  set annualGhiKwhM2($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAnnualGhiKwhM2() => $_has(1);
  @$pb.TagNumber(2)
  void clearAnnualGhiKwhM2() => $_clearField(2);
}

class FetchIrradianceRequest extends $pb.GeneratedMessage {
  factory FetchIrradianceRequest({
    $core.String? projectId,
    $core.double? latitude,
    $core.double? longitude,
    WeatherSource? source,
    $core.String? apiKey,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (source != null) {
      $result.source = source;
    }
    if (apiKey != null) {
      $result.apiKey = apiKey;
    }
    return $result;
  }
  FetchIrradianceRequest._() : super();
  factory FetchIrradianceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FetchIrradianceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FetchIrradianceRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..e<WeatherSource>(4, _omitFieldNames ? '' : 'source', $pb.PbFieldType.OE, defaultOrMaker: WeatherSource.WEATHER_SOURCE_UNSPECIFIED, valueOf: WeatherSource.valueOf, enumValues: WeatherSource.values)
    ..aOS(5, _omitFieldNames ? '' : 'apiKey')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FetchIrradianceRequest clone() => FetchIrradianceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FetchIrradianceRequest copyWith(void Function(FetchIrradianceRequest) updates) => super.copyWith((message) => updates(message as FetchIrradianceRequest)) as FetchIrradianceRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FetchIrradianceRequest create() => FetchIrradianceRequest._();
  FetchIrradianceRequest createEmptyInstance() => create();
  static $pb.PbList<FetchIrradianceRequest> createRepeated() => $pb.PbList<FetchIrradianceRequest>();
  @$core.pragma('dart2js:noInline')
  static FetchIrradianceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FetchIrradianceRequest>(create);
  static FetchIrradianceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get latitude => $_getN(1);
  @$pb.TagNumber(2)
  set latitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLatitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get longitude => $_getN(2);
  @$pb.TagNumber(3)
  set longitude($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLongitude() => $_has(2);
  @$pb.TagNumber(3)
  void clearLongitude() => $_clearField(3);

  @$pb.TagNumber(4)
  WeatherSource get source => $_getN(3);
  @$pb.TagNumber(4)
  set source(WeatherSource v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSource() => $_has(3);
  @$pb.TagNumber(4)
  void clearSource() => $_clearField(4);

  /// api_key is required for NSRDB and ERA5; ignored for PVGIS and NASA POWER.
  @$pb.TagNumber(5)
  $core.String get apiKey => $_getSZ(4);
  @$pb.TagNumber(5)
  set apiKey($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasApiKey() => $_has(4);
  @$pb.TagNumber(5)
  void clearApiKey() => $_clearField(5);
}

class FetchIrradianceResponse extends $pb.GeneratedMessage {
  factory FetchIrradianceResponse({
    SiteWeatherSummary? summary,
    $core.Iterable<HourlyRecord>? records,
  }) {
    final $result = create();
    if (summary != null) {
      $result.summary = summary;
    }
    if (records != null) {
      $result.records.addAll(records);
    }
    return $result;
  }
  FetchIrradianceResponse._() : super();
  factory FetchIrradianceResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FetchIrradianceResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FetchIrradianceResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..aOM<SiteWeatherSummary>(1, _omitFieldNames ? '' : 'summary', subBuilder: SiteWeatherSummary.create)
    ..pc<HourlyRecord>(2, _omitFieldNames ? '' : 'records', $pb.PbFieldType.PM, subBuilder: HourlyRecord.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FetchIrradianceResponse clone() => FetchIrradianceResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FetchIrradianceResponse copyWith(void Function(FetchIrradianceResponse) updates) => super.copyWith((message) => updates(message as FetchIrradianceResponse)) as FetchIrradianceResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FetchIrradianceResponse create() => FetchIrradianceResponse._();
  FetchIrradianceResponse createEmptyInstance() => create();
  static $pb.PbList<FetchIrradianceResponse> createRepeated() => $pb.PbList<FetchIrradianceResponse>();
  @$core.pragma('dart2js:noInline')
  static FetchIrradianceResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FetchIrradianceResponse>(create);
  static FetchIrradianceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SiteWeatherSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(SiteWeatherSummary v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  SiteWeatherSummary ensureSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<HourlyRecord> get records => $_getList(1);
}

class ImportTMYRequest extends $pb.GeneratedMessage {
  factory ImportTMYRequest({
    $core.String? projectId,
    $core.double? latitude,
    $core.double? longitude,
    WeatherSource? format,
    $core.List<$core.int>? fileContent,
    $core.String? fileName,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (format != null) {
      $result.format = format;
    }
    if (fileContent != null) {
      $result.fileContent = fileContent;
    }
    if (fileName != null) {
      $result.fileName = fileName;
    }
    return $result;
  }
  ImportTMYRequest._() : super();
  factory ImportTMYRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImportTMYRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ImportTMYRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..e<WeatherSource>(4, _omitFieldNames ? '' : 'format', $pb.PbFieldType.OE, defaultOrMaker: WeatherSource.WEATHER_SOURCE_UNSPECIFIED, valueOf: WeatherSource.valueOf, enumValues: WeatherSource.values)
    ..a<$core.List<$core.int>>(5, _omitFieldNames ? '' : 'fileContent', $pb.PbFieldType.OY)
    ..aOS(6, _omitFieldNames ? '' : 'fileName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ImportTMYRequest clone() => ImportTMYRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ImportTMYRequest copyWith(void Function(ImportTMYRequest) updates) => super.copyWith((message) => updates(message as ImportTMYRequest)) as ImportTMYRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImportTMYRequest create() => ImportTMYRequest._();
  ImportTMYRequest createEmptyInstance() => create();
  static $pb.PbList<ImportTMYRequest> createRepeated() => $pb.PbList<ImportTMYRequest>();
  @$core.pragma('dart2js:noInline')
  static ImportTMYRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImportTMYRequest>(create);
  static ImportTMYRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get latitude => $_getN(1);
  @$pb.TagNumber(2)
  set latitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLatitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get longitude => $_getN(2);
  @$pb.TagNumber(3)
  set longitude($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLongitude() => $_has(2);
  @$pb.TagNumber(3)
  void clearLongitude() => $_clearField(3);

  @$pb.TagNumber(4)
  WeatherSource get format => $_getN(3);
  @$pb.TagNumber(4)
  set format(WeatherSource v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFormat() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormat() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get fileContent => $_getN(4);
  @$pb.TagNumber(5)
  set fileContent($core.List<$core.int> v) { $_setBytes(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFileContent() => $_has(4);
  @$pb.TagNumber(5)
  void clearFileContent() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get fileName => $_getSZ(5);
  @$pb.TagNumber(6)
  set fileName($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasFileName() => $_has(5);
  @$pb.TagNumber(6)
  void clearFileName() => $_clearField(6);
}

class ImportTMYResponse extends $pb.GeneratedMessage {
  factory ImportTMYResponse({
    SiteWeatherSummary? summary,
    $core.int? recordsImported,
  }) {
    final $result = create();
    if (summary != null) {
      $result.summary = summary;
    }
    if (recordsImported != null) {
      $result.recordsImported = recordsImported;
    }
    return $result;
  }
  ImportTMYResponse._() : super();
  factory ImportTMYResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImportTMYResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ImportTMYResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..aOM<SiteWeatherSummary>(1, _omitFieldNames ? '' : 'summary', subBuilder: SiteWeatherSummary.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'recordsImported', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ImportTMYResponse clone() => ImportTMYResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ImportTMYResponse copyWith(void Function(ImportTMYResponse) updates) => super.copyWith((message) => updates(message as ImportTMYResponse)) as ImportTMYResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImportTMYResponse create() => ImportTMYResponse._();
  ImportTMYResponse createEmptyInstance() => create();
  static $pb.PbList<ImportTMYResponse> createRepeated() => $pb.PbList<ImportTMYResponse>();
  @$core.pragma('dart2js:noInline')
  static ImportTMYResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImportTMYResponse>(create);
  static ImportTMYResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SiteWeatherSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(SiteWeatherSummary v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  SiteWeatherSummary ensureSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get recordsImported => $_getIZ(1);
  @$pb.TagNumber(2)
  set recordsImported($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRecordsImported() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordsImported() => $_clearField(2);
}

class GetHourlyTimeseriesRequest extends $pb.GeneratedMessage {
  factory GetHourlyTimeseriesRequest({
    $core.String? siteWeatherId,
  }) {
    final $result = create();
    if (siteWeatherId != null) {
      $result.siteWeatherId = siteWeatherId;
    }
    return $result;
  }
  GetHourlyTimeseriesRequest._() : super();
  factory GetHourlyTimeseriesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetHourlyTimeseriesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetHourlyTimeseriesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'siteWeatherId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetHourlyTimeseriesRequest clone() => GetHourlyTimeseriesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetHourlyTimeseriesRequest copyWith(void Function(GetHourlyTimeseriesRequest) updates) => super.copyWith((message) => updates(message as GetHourlyTimeseriesRequest)) as GetHourlyTimeseriesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHourlyTimeseriesRequest create() => GetHourlyTimeseriesRequest._();
  GetHourlyTimeseriesRequest createEmptyInstance() => create();
  static $pb.PbList<GetHourlyTimeseriesRequest> createRepeated() => $pb.PbList<GetHourlyTimeseriesRequest>();
  @$core.pragma('dart2js:noInline')
  static GetHourlyTimeseriesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetHourlyTimeseriesRequest>(create);
  static GetHourlyTimeseriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get siteWeatherId => $_getSZ(0);
  @$pb.TagNumber(1)
  set siteWeatherId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSiteWeatherId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSiteWeatherId() => $_clearField(1);
}

class GetHourlyTimeseriesResponse extends $pb.GeneratedMessage {
  factory GetHourlyTimeseriesResponse({
    SiteWeatherSummary? summary,
    $core.Iterable<HourlyRecord>? records,
  }) {
    final $result = create();
    if (summary != null) {
      $result.summary = summary;
    }
    if (records != null) {
      $result.records.addAll(records);
    }
    return $result;
  }
  GetHourlyTimeseriesResponse._() : super();
  factory GetHourlyTimeseriesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetHourlyTimeseriesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetHourlyTimeseriesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..aOM<SiteWeatherSummary>(1, _omitFieldNames ? '' : 'summary', subBuilder: SiteWeatherSummary.create)
    ..pc<HourlyRecord>(2, _omitFieldNames ? '' : 'records', $pb.PbFieldType.PM, subBuilder: HourlyRecord.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetHourlyTimeseriesResponse clone() => GetHourlyTimeseriesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetHourlyTimeseriesResponse copyWith(void Function(GetHourlyTimeseriesResponse) updates) => super.copyWith((message) => updates(message as GetHourlyTimeseriesResponse)) as GetHourlyTimeseriesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetHourlyTimeseriesResponse create() => GetHourlyTimeseriesResponse._();
  GetHourlyTimeseriesResponse createEmptyInstance() => create();
  static $pb.PbList<GetHourlyTimeseriesResponse> createRepeated() => $pb.PbList<GetHourlyTimeseriesResponse>();
  @$core.pragma('dart2js:noInline')
  static GetHourlyTimeseriesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetHourlyTimeseriesResponse>(create);
  static GetHourlyTimeseriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SiteWeatherSummary get summary => $_getN(0);
  @$pb.TagNumber(1)
  set summary(SiteWeatherSummary v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  SiteWeatherSummary ensureSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<HourlyRecord> get records => $_getList(1);
}

class ListSiteWeatherRequest extends $pb.GeneratedMessage {
  factory ListSiteWeatherRequest({
    $core.String? projectId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    return $result;
  }
  ListSiteWeatherRequest._() : super();
  factory ListSiteWeatherRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListSiteWeatherRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListSiteWeatherRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListSiteWeatherRequest clone() => ListSiteWeatherRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListSiteWeatherRequest copyWith(void Function(ListSiteWeatherRequest) updates) => super.copyWith((message) => updates(message as ListSiteWeatherRequest)) as ListSiteWeatherRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSiteWeatherRequest create() => ListSiteWeatherRequest._();
  ListSiteWeatherRequest createEmptyInstance() => create();
  static $pb.PbList<ListSiteWeatherRequest> createRepeated() => $pb.PbList<ListSiteWeatherRequest>();
  @$core.pragma('dart2js:noInline')
  static ListSiteWeatherRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListSiteWeatherRequest>(create);
  static ListSiteWeatherRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);
}

class ListSiteWeatherResponse extends $pb.GeneratedMessage {
  factory ListSiteWeatherResponse({
    $core.Iterable<SiteWeatherSummary>? summaries,
  }) {
    final $result = create();
    if (summaries != null) {
      $result.summaries.addAll(summaries);
    }
    return $result;
  }
  ListSiteWeatherResponse._() : super();
  factory ListSiteWeatherResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListSiteWeatherResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListSiteWeatherResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..pc<SiteWeatherSummary>(1, _omitFieldNames ? '' : 'summaries', $pb.PbFieldType.PM, subBuilder: SiteWeatherSummary.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListSiteWeatherResponse clone() => ListSiteWeatherResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListSiteWeatherResponse copyWith(void Function(ListSiteWeatherResponse) updates) => super.copyWith((message) => updates(message as ListSiteWeatherResponse)) as ListSiteWeatherResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSiteWeatherResponse create() => ListSiteWeatherResponse._();
  ListSiteWeatherResponse createEmptyInstance() => create();
  static $pb.PbList<ListSiteWeatherResponse> createRepeated() => $pb.PbList<ListSiteWeatherResponse>();
  @$core.pragma('dart2js:noInline')
  static ListSiteWeatherResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListSiteWeatherResponse>(create);
  static ListSiteWeatherResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<SiteWeatherSummary> get summaries => $_getList(0);
}

class CalculateYieldExceedanceRequest extends $pb.GeneratedMessage {
  factory CalculateYieldExceedanceRequest({
    $core.String? siteWeatherId,
    $core.double? systemCapacityKw,
  }) {
    final $result = create();
    if (siteWeatherId != null) {
      $result.siteWeatherId = siteWeatherId;
    }
    if (systemCapacityKw != null) {
      $result.systemCapacityKw = systemCapacityKw;
    }
    return $result;
  }
  CalculateYieldExceedanceRequest._() : super();
  factory CalculateYieldExceedanceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateYieldExceedanceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateYieldExceedanceRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'siteWeatherId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'systemCapacityKw', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateYieldExceedanceRequest clone() => CalculateYieldExceedanceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateYieldExceedanceRequest copyWith(void Function(CalculateYieldExceedanceRequest) updates) => super.copyWith((message) => updates(message as CalculateYieldExceedanceRequest)) as CalculateYieldExceedanceRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateYieldExceedanceRequest create() => CalculateYieldExceedanceRequest._();
  CalculateYieldExceedanceRequest createEmptyInstance() => create();
  static $pb.PbList<CalculateYieldExceedanceRequest> createRepeated() => $pb.PbList<CalculateYieldExceedanceRequest>();
  @$core.pragma('dart2js:noInline')
  static CalculateYieldExceedanceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateYieldExceedanceRequest>(create);
  static CalculateYieldExceedanceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get siteWeatherId => $_getSZ(0);
  @$pb.TagNumber(1)
  set siteWeatherId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSiteWeatherId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSiteWeatherId() => $_clearField(1);

  /// system_capacity_kw is the DC nameplate of the PV system, used to scale
  /// GHI into estimated annual energy yield (kWh). If 0, raw GHI exceedance
  /// is returned without system scaling.
  @$pb.TagNumber(2)
  $core.double get systemCapacityKw => $_getN(1);
  @$pb.TagNumber(2)
  set systemCapacityKw($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSystemCapacityKw() => $_has(1);
  @$pb.TagNumber(2)
  void clearSystemCapacityKw() => $_clearField(2);
}

class CalculateYieldExceedanceResponse extends $pb.GeneratedMessage {
  factory CalculateYieldExceedanceResponse({
    $core.String? siteWeatherId,
    $core.Iterable<YieldExceedance>? exceedances,
  }) {
    final $result = create();
    if (siteWeatherId != null) {
      $result.siteWeatherId = siteWeatherId;
    }
    if (exceedances != null) {
      $result.exceedances.addAll(exceedances);
    }
    return $result;
  }
  CalculateYieldExceedanceResponse._() : super();
  factory CalculateYieldExceedanceResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateYieldExceedanceResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateYieldExceedanceResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'siteWeatherId')
    ..pc<YieldExceedance>(2, _omitFieldNames ? '' : 'exceedances', $pb.PbFieldType.PM, subBuilder: YieldExceedance.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateYieldExceedanceResponse clone() => CalculateYieldExceedanceResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateYieldExceedanceResponse copyWith(void Function(CalculateYieldExceedanceResponse) updates) => super.copyWith((message) => updates(message as CalculateYieldExceedanceResponse)) as CalculateYieldExceedanceResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateYieldExceedanceResponse create() => CalculateYieldExceedanceResponse._();
  CalculateYieldExceedanceResponse createEmptyInstance() => create();
  static $pb.PbList<CalculateYieldExceedanceResponse> createRepeated() => $pb.PbList<CalculateYieldExceedanceResponse>();
  @$core.pragma('dart2js:noInline')
  static CalculateYieldExceedanceResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateYieldExceedanceResponse>(create);
  static CalculateYieldExceedanceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get siteWeatherId => $_getSZ(0);
  @$pb.TagNumber(1)
  set siteWeatherId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSiteWeatherId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSiteWeatherId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<YieldExceedance> get exceedances => $_getList(1);
}

class DeleteSiteWeatherRequest extends $pb.GeneratedMessage {
  factory DeleteSiteWeatherRequest({
    $core.String? siteWeatherId,
  }) {
    final $result = create();
    if (siteWeatherId != null) {
      $result.siteWeatherId = siteWeatherId;
    }
    return $result;
  }
  DeleteSiteWeatherRequest._() : super();
  factory DeleteSiteWeatherRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteSiteWeatherRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteSiteWeatherRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'siteWeatherId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteSiteWeatherRequest clone() => DeleteSiteWeatherRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteSiteWeatherRequest copyWith(void Function(DeleteSiteWeatherRequest) updates) => super.copyWith((message) => updates(message as DeleteSiteWeatherRequest)) as DeleteSiteWeatherRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteSiteWeatherRequest create() => DeleteSiteWeatherRequest._();
  DeleteSiteWeatherRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteSiteWeatherRequest> createRepeated() => $pb.PbList<DeleteSiteWeatherRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteSiteWeatherRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteSiteWeatherRequest>(create);
  static DeleteSiteWeatherRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get siteWeatherId => $_getSZ(0);
  @$pb.TagNumber(1)
  set siteWeatherId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSiteWeatherId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSiteWeatherId() => $_clearField(1);
}

class DeleteSiteWeatherResponse extends $pb.GeneratedMessage {
  factory DeleteSiteWeatherResponse() => create();
  DeleteSiteWeatherResponse._() : super();
  factory DeleteSiteWeatherResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteSiteWeatherResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteSiteWeatherResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'weather.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteSiteWeatherResponse clone() => DeleteSiteWeatherResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteSiteWeatherResponse copyWith(void Function(DeleteSiteWeatherResponse) updates) => super.copyWith((message) => updates(message as DeleteSiteWeatherResponse)) as DeleteSiteWeatherResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteSiteWeatherResponse create() => DeleteSiteWeatherResponse._();
  DeleteSiteWeatherResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteSiteWeatherResponse> createRepeated() => $pb.PbList<DeleteSiteWeatherResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteSiteWeatherResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteSiteWeatherResponse>(create);
  static DeleteSiteWeatherResponse? _defaultInstance;
}

/// WeatherService provides solar irradiance data from multiple upstream sources
/// (PVGIS, NASA POWER, NSRDB, ERA5) and offers TMY file ingestion, hourly
/// timeseries retrieval, and probabilistic yield exceedance calculations.
class WeatherServiceApi {
  $pb.RpcClient _client;
  WeatherServiceApi(this._client);

  /// FetchIrradiance retrieves hourly irradiance data for a location from the
  /// specified upstream source. Returns a timeseries of GHI/DNI/DHI plus
  /// ambient temperature. Results are cached server-side after the first fetch.
  $async.Future<FetchIrradianceResponse> fetchIrradiance($pb.ClientContext? ctx, FetchIrradianceRequest request) =>
    _client.invoke<FetchIrradianceResponse>(ctx, 'WeatherService', 'FetchIrradiance', request, FetchIrradianceResponse())
  ;
  /// ImportTMY ingests an uploaded TMY file (EPW, TM2, TM3, or CSV) and stores
  /// the parsed hourly records for the site.
  $async.Future<ImportTMYResponse> importTMY($pb.ClientContext? ctx, ImportTMYRequest request) =>
    _client.invoke<ImportTMYResponse>(ctx, 'WeatherService', 'ImportTMY', request, ImportTMYResponse())
  ;
  /// GetHourlyTimeseries returns previously-fetched or imported hourly
  /// irradiance data for a site.
  $async.Future<GetHourlyTimeseriesResponse> getHourlyTimeseries($pb.ClientContext? ctx, GetHourlyTimeseriesRequest request) =>
    _client.invoke<GetHourlyTimeseriesResponse>(ctx, 'WeatherService', 'GetHourlyTimeseries', request, GetHourlyTimeseriesResponse())
  ;
  /// ListSiteWeather returns all weather datasets available for a project.
  $async.Future<ListSiteWeatherResponse> listSiteWeather($pb.ClientContext? ctx, ListSiteWeatherRequest request) =>
    _client.invoke<ListSiteWeatherResponse>(ctx, 'WeatherService', 'ListSiteWeather', request, ListSiteWeatherResponse())
  ;
  /// CalculateYieldExceedance computes P50/P90/P99 exceedance probabilities
  /// for annual energy yield based on the GHI timeseries of a site.
  $async.Future<CalculateYieldExceedanceResponse> calculateYieldExceedance($pb.ClientContext? ctx, CalculateYieldExceedanceRequest request) =>
    _client.invoke<CalculateYieldExceedanceResponse>(ctx, 'WeatherService', 'CalculateYieldExceedance', request, CalculateYieldExceedanceResponse())
  ;
  /// DeleteSiteWeather removes a weather dataset for a site.
  $async.Future<DeleteSiteWeatherResponse> deleteSiteWeather($pb.ClientContext? ctx, DeleteSiteWeatherRequest request) =>
    _client.invoke<DeleteSiteWeatherResponse>(ctx, 'WeatherService', 'DeleteSiteWeather', request, DeleteSiteWeatherResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
