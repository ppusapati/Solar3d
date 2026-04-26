//
//  Generated code. Do not modify.
//  source: ml_inference/v1/ml_inference.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'features.pb.dart' as $2;
import 'ml_inference.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'ml_inference.pbenum.dart';

class WeatherFeatures extends $pb.GeneratedMessage {
  factory WeatherFeatures({
    $core.double? temperatureC,
    $core.double? irradianceWM2,
    $core.double? humidityPercent,
    $core.double? pressureMb,
    $core.double? windSpeedMS,
  }) {
    final $result = create();
    if (temperatureC != null) {
      $result.temperatureC = temperatureC;
    }
    if (irradianceWM2 != null) {
      $result.irradianceWM2 = irradianceWM2;
    }
    if (humidityPercent != null) {
      $result.humidityPercent = humidityPercent;
    }
    if (pressureMb != null) {
      $result.pressureMb = pressureMb;
    }
    if (windSpeedMS != null) {
      $result.windSpeedMS = windSpeedMS;
    }
    return $result;
  }
  WeatherFeatures._() : super();
  factory WeatherFeatures.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WeatherFeatures.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WeatherFeatures', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'temperatureC', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'irradianceWM2', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'humidityPercent', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'pressureMb', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'windSpeedMS', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WeatherFeatures clone() => WeatherFeatures()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WeatherFeatures copyWith(void Function(WeatherFeatures) updates) => super.copyWith((message) => updates(message as WeatherFeatures)) as WeatherFeatures;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WeatherFeatures create() => WeatherFeatures._();
  WeatherFeatures createEmptyInstance() => create();
  static $pb.PbList<WeatherFeatures> createRepeated() => $pb.PbList<WeatherFeatures>();
  @$core.pragma('dart2js:noInline')
  static WeatherFeatures getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WeatherFeatures>(create);
  static WeatherFeatures? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get temperatureC => $_getN(0);
  @$pb.TagNumber(1)
  set temperatureC($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTemperatureC() => $_has(0);
  @$pb.TagNumber(1)
  void clearTemperatureC() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get irradianceWM2 => $_getN(1);
  @$pb.TagNumber(2)
  set irradianceWM2($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIrradianceWM2() => $_has(1);
  @$pb.TagNumber(2)
  void clearIrradianceWM2() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get humidityPercent => $_getN(2);
  @$pb.TagNumber(3)
  set humidityPercent($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHumidityPercent() => $_has(2);
  @$pb.TagNumber(3)
  void clearHumidityPercent() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get pressureMb => $_getN(3);
  @$pb.TagNumber(4)
  set pressureMb($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPressureMb() => $_has(3);
  @$pb.TagNumber(4)
  void clearPressureMb() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get windSpeedMS => $_getN(4);
  @$pb.TagNumber(5)
  set windSpeedMS($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasWindSpeedMS() => $_has(4);
  @$pb.TagNumber(5)
  void clearWindSpeedMS() => $_clearField(5);
}

class SolarFeatures extends $pb.GeneratedMessage {
  factory SolarFeatures({
    $core.double? solarAltitudeDeg,
    $core.double? solarAzimuthDeg,
    $core.double? airMass,
    $core.double? clearnessIndex,
  }) {
    final $result = create();
    if (solarAltitudeDeg != null) {
      $result.solarAltitudeDeg = solarAltitudeDeg;
    }
    if (solarAzimuthDeg != null) {
      $result.solarAzimuthDeg = solarAzimuthDeg;
    }
    if (airMass != null) {
      $result.airMass = airMass;
    }
    if (clearnessIndex != null) {
      $result.clearnessIndex = clearnessIndex;
    }
    return $result;
  }
  SolarFeatures._() : super();
  factory SolarFeatures.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SolarFeatures.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SolarFeatures', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'solarAltitudeDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'solarAzimuthDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'airMass', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'clearnessIndex', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SolarFeatures clone() => SolarFeatures()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SolarFeatures copyWith(void Function(SolarFeatures) updates) => super.copyWith((message) => updates(message as SolarFeatures)) as SolarFeatures;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SolarFeatures create() => SolarFeatures._();
  SolarFeatures createEmptyInstance() => create();
  static $pb.PbList<SolarFeatures> createRepeated() => $pb.PbList<SolarFeatures>();
  @$core.pragma('dart2js:noInline')
  static SolarFeatures getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SolarFeatures>(create);
  static SolarFeatures? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get solarAltitudeDeg => $_getN(0);
  @$pb.TagNumber(1)
  set solarAltitudeDeg($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSolarAltitudeDeg() => $_has(0);
  @$pb.TagNumber(1)
  void clearSolarAltitudeDeg() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get solarAzimuthDeg => $_getN(1);
  @$pb.TagNumber(2)
  set solarAzimuthDeg($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSolarAzimuthDeg() => $_has(1);
  @$pb.TagNumber(2)
  void clearSolarAzimuthDeg() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get airMass => $_getN(2);
  @$pb.TagNumber(3)
  set airMass($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAirMass() => $_has(2);
  @$pb.TagNumber(3)
  void clearAirMass() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get clearnessIndex => $_getN(3);
  @$pb.TagNumber(4)
  set clearnessIndex($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasClearnessIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearClearnessIndex() => $_clearField(4);
}

class TimeFeatures extends $pb.GeneratedMessage {
  factory TimeFeatures({
    $core.int? hourOfDay,
    $core.int? dayOfYear,
    $core.int? month,
    $core.bool? isWeekend,
  }) {
    final $result = create();
    if (hourOfDay != null) {
      $result.hourOfDay = hourOfDay;
    }
    if (dayOfYear != null) {
      $result.dayOfYear = dayOfYear;
    }
    if (month != null) {
      $result.month = month;
    }
    if (isWeekend != null) {
      $result.isWeekend = isWeekend;
    }
    return $result;
  }
  TimeFeatures._() : super();
  factory TimeFeatures.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TimeFeatures.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TimeFeatures', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'hourOfDay', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'dayOfYear', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'month', $pb.PbFieldType.O3)
    ..aOB(4, _omitFieldNames ? '' : 'isWeekend')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TimeFeatures clone() => TimeFeatures()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TimeFeatures copyWith(void Function(TimeFeatures) updates) => super.copyWith((message) => updates(message as TimeFeatures)) as TimeFeatures;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TimeFeatures create() => TimeFeatures._();
  TimeFeatures createEmptyInstance() => create();
  static $pb.PbList<TimeFeatures> createRepeated() => $pb.PbList<TimeFeatures>();
  @$core.pragma('dart2js:noInline')
  static TimeFeatures getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimeFeatures>(create);
  static TimeFeatures? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get hourOfDay => $_getIZ(0);
  @$pb.TagNumber(1)
  set hourOfDay($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHourOfDay() => $_has(0);
  @$pb.TagNumber(1)
  void clearHourOfDay() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get dayOfYear => $_getIZ(1);
  @$pb.TagNumber(2)
  set dayOfYear($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDayOfYear() => $_has(1);
  @$pb.TagNumber(2)
  void clearDayOfYear() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get month => $_getIZ(2);
  @$pb.TagNumber(3)
  set month($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMonth() => $_has(2);
  @$pb.TagNumber(3)
  void clearMonth() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get isWeekend => $_getBF(3);
  @$pb.TagNumber(4)
  set isWeekend($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsWeekend() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsWeekend() => $_clearField(4);
}

class FeatureVector extends $pb.GeneratedMessage {
  factory FeatureVector({
    $core.Iterable<$core.double>? features,
    $core.Iterable<$core.String>? featureNames,
  }) {
    final $result = create();
    if (features != null) {
      $result.features.addAll(features);
    }
    if (featureNames != null) {
      $result.featureNames.addAll(featureNames);
    }
    return $result;
  }
  FeatureVector._() : super();
  factory FeatureVector.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeatureVector.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeatureVector', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'features', $pb.PbFieldType.KD)
    ..pPS(2, _omitFieldNames ? '' : 'featureNames')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeatureVector clone() => FeatureVector()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeatureVector copyWith(void Function(FeatureVector) updates) => super.copyWith((message) => updates(message as FeatureVector)) as FeatureVector;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeatureVector create() => FeatureVector._();
  FeatureVector createEmptyInstance() => create();
  static $pb.PbList<FeatureVector> createRepeated() => $pb.PbList<FeatureVector>();
  @$core.pragma('dart2js:noInline')
  static FeatureVector getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeatureVector>(create);
  static FeatureVector? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.double> get features => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get featureNames => $_getList(1);
}

class FeatureExtractionRequest extends $pb.GeneratedMessage {
  factory FeatureExtractionRequest({
    WeatherFeatures? weather,
    SolarFeatures? solar,
    TimeFeatures? time,
  }) {
    final $result = create();
    if (weather != null) {
      $result.weather = weather;
    }
    if (solar != null) {
      $result.solar = solar;
    }
    if (time != null) {
      $result.time = time;
    }
    return $result;
  }
  FeatureExtractionRequest._() : super();
  factory FeatureExtractionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeatureExtractionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeatureExtractionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOM<WeatherFeatures>(1, _omitFieldNames ? '' : 'weather', subBuilder: WeatherFeatures.create)
    ..aOM<SolarFeatures>(2, _omitFieldNames ? '' : 'solar', subBuilder: SolarFeatures.create)
    ..aOM<TimeFeatures>(3, _omitFieldNames ? '' : 'time', subBuilder: TimeFeatures.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeatureExtractionRequest clone() => FeatureExtractionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeatureExtractionRequest copyWith(void Function(FeatureExtractionRequest) updates) => super.copyWith((message) => updates(message as FeatureExtractionRequest)) as FeatureExtractionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeatureExtractionRequest create() => FeatureExtractionRequest._();
  FeatureExtractionRequest createEmptyInstance() => create();
  static $pb.PbList<FeatureExtractionRequest> createRepeated() => $pb.PbList<FeatureExtractionRequest>();
  @$core.pragma('dart2js:noInline')
  static FeatureExtractionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeatureExtractionRequest>(create);
  static FeatureExtractionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  WeatherFeatures get weather => $_getN(0);
  @$pb.TagNumber(1)
  set weather(WeatherFeatures v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasWeather() => $_has(0);
  @$pb.TagNumber(1)
  void clearWeather() => $_clearField(1);
  @$pb.TagNumber(1)
  WeatherFeatures ensureWeather() => $_ensure(0);

  @$pb.TagNumber(2)
  SolarFeatures get solar => $_getN(1);
  @$pb.TagNumber(2)
  set solar(SolarFeatures v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSolar() => $_has(1);
  @$pb.TagNumber(2)
  void clearSolar() => $_clearField(2);
  @$pb.TagNumber(2)
  SolarFeatures ensureSolar() => $_ensure(1);

  @$pb.TagNumber(3)
  TimeFeatures get time => $_getN(2);
  @$pb.TagNumber(3)
  set time(TimeFeatures v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearTime() => $_clearField(3);
  @$pb.TagNumber(3)
  TimeFeatures ensureTime() => $_ensure(2);
}

class FeatureExtractionResponse extends $pb.GeneratedMessage {
  factory FeatureExtractionResponse({
    FeatureVector? features,
    $core.int? featureCount,
    $2.FeaturePayload? payload,
  }) {
    final $result = create();
    if (features != null) {
      $result.features = features;
    }
    if (featureCount != null) {
      $result.featureCount = featureCount;
    }
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  FeatureExtractionResponse._() : super();
  factory FeatureExtractionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FeatureExtractionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FeatureExtractionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOM<FeatureVector>(1, _omitFieldNames ? '' : 'features', subBuilder: FeatureVector.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'featureCount', $pb.PbFieldType.O3)
    ..aOM<$2.FeaturePayload>(10, _omitFieldNames ? '' : 'payload', subBuilder: $2.FeaturePayload.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FeatureExtractionResponse clone() => FeatureExtractionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FeatureExtractionResponse copyWith(void Function(FeatureExtractionResponse) updates) => super.copyWith((message) => updates(message as FeatureExtractionResponse)) as FeatureExtractionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FeatureExtractionResponse create() => FeatureExtractionResponse._();
  FeatureExtractionResponse createEmptyInstance() => create();
  static $pb.PbList<FeatureExtractionResponse> createRepeated() => $pb.PbList<FeatureExtractionResponse>();
  @$core.pragma('dart2js:noInline')
  static FeatureExtractionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FeatureExtractionResponse>(create);
  static FeatureExtractionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FeatureVector get features => $_getN(0);
  @$pb.TagNumber(1)
  set features(FeatureVector v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFeatures() => $_has(0);
  @$pb.TagNumber(1)
  void clearFeatures() => $_clearField(1);
  @$pb.TagNumber(1)
  FeatureVector ensureFeatures() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get featureCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set featureCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFeatureCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearFeatureCount() => $_clearField(2);

  @$pb.TagNumber(10)
  $2.FeaturePayload get payload => $_getN(2);
  @$pb.TagNumber(10)
  set payload($2.FeaturePayload v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasPayload() => $_has(2);
  @$pb.TagNumber(10)
  void clearPayload() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.FeaturePayload ensurePayload() => $_ensure(2);
}

class YieldPredictionRequest extends $pb.GeneratedMessage {
  factory YieldPredictionRequest({
    FeatureVector? features,
    $core.double? modelOutput,
    $core.double? uncertaintyEstimate,
    $2.FeaturePayload? featurePayload,
  }) {
    final $result = create();
    if (features != null) {
      $result.features = features;
    }
    if (modelOutput != null) {
      $result.modelOutput = modelOutput;
    }
    if (uncertaintyEstimate != null) {
      $result.uncertaintyEstimate = uncertaintyEstimate;
    }
    if (featurePayload != null) {
      $result.featurePayload = featurePayload;
    }
    return $result;
  }
  YieldPredictionRequest._() : super();
  factory YieldPredictionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory YieldPredictionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'YieldPredictionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOM<FeatureVector>(1, _omitFieldNames ? '' : 'features', subBuilder: FeatureVector.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'modelOutput', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'uncertaintyEstimate', $pb.PbFieldType.OD)
    ..aOM<$2.FeaturePayload>(10, _omitFieldNames ? '' : 'featurePayload', subBuilder: $2.FeaturePayload.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  YieldPredictionRequest clone() => YieldPredictionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  YieldPredictionRequest copyWith(void Function(YieldPredictionRequest) updates) => super.copyWith((message) => updates(message as YieldPredictionRequest)) as YieldPredictionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YieldPredictionRequest create() => YieldPredictionRequest._();
  YieldPredictionRequest createEmptyInstance() => create();
  static $pb.PbList<YieldPredictionRequest> createRepeated() => $pb.PbList<YieldPredictionRequest>();
  @$core.pragma('dart2js:noInline')
  static YieldPredictionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<YieldPredictionRequest>(create);
  static YieldPredictionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  FeatureVector get features => $_getN(0);
  @$pb.TagNumber(1)
  set features(FeatureVector v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFeatures() => $_has(0);
  @$pb.TagNumber(1)
  void clearFeatures() => $_clearField(1);
  @$pb.TagNumber(1)
  FeatureVector ensureFeatures() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get modelOutput => $_getN(1);
  @$pb.TagNumber(2)
  set modelOutput($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasModelOutput() => $_has(1);
  @$pb.TagNumber(2)
  void clearModelOutput() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get uncertaintyEstimate => $_getN(2);
  @$pb.TagNumber(3)
  set uncertaintyEstimate($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUncertaintyEstimate() => $_has(2);
  @$pb.TagNumber(3)
  void clearUncertaintyEstimate() => $_clearField(3);

  @$pb.TagNumber(10)
  $2.FeaturePayload get featurePayload => $_getN(3);
  @$pb.TagNumber(10)
  set featurePayload($2.FeaturePayload v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasFeaturePayload() => $_has(3);
  @$pb.TagNumber(10)
  void clearFeaturePayload() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.FeaturePayload ensureFeaturePayload() => $_ensure(3);
}

class YieldForecast extends $pb.GeneratedMessage {
  factory YieldForecast({
    $core.double? predictedYieldKwh,
    $core.double? confidenceLower,
    $core.double? confidenceUpper,
    $core.double? expectedValue,
    $core.double? variance,
  }) {
    final $result = create();
    if (predictedYieldKwh != null) {
      $result.predictedYieldKwh = predictedYieldKwh;
    }
    if (confidenceLower != null) {
      $result.confidenceLower = confidenceLower;
    }
    if (confidenceUpper != null) {
      $result.confidenceUpper = confidenceUpper;
    }
    if (expectedValue != null) {
      $result.expectedValue = expectedValue;
    }
    if (variance != null) {
      $result.variance = variance;
    }
    return $result;
  }
  YieldForecast._() : super();
  factory YieldForecast.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory YieldForecast.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'YieldForecast', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'predictedYieldKwh', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'confidenceLower', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'confidenceUpper', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'expectedValue', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'variance', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  YieldForecast clone() => YieldForecast()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  YieldForecast copyWith(void Function(YieldForecast) updates) => super.copyWith((message) => updates(message as YieldForecast)) as YieldForecast;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YieldForecast create() => YieldForecast._();
  YieldForecast createEmptyInstance() => create();
  static $pb.PbList<YieldForecast> createRepeated() => $pb.PbList<YieldForecast>();
  @$core.pragma('dart2js:noInline')
  static YieldForecast getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<YieldForecast>(create);
  static YieldForecast? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get predictedYieldKwh => $_getN(0);
  @$pb.TagNumber(1)
  set predictedYieldKwh($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPredictedYieldKwh() => $_has(0);
  @$pb.TagNumber(1)
  void clearPredictedYieldKwh() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get confidenceLower => $_getN(1);
  @$pb.TagNumber(2)
  set confidenceLower($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasConfidenceLower() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfidenceLower() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get confidenceUpper => $_getN(2);
  @$pb.TagNumber(3)
  set confidenceUpper($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasConfidenceUpper() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfidenceUpper() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get expectedValue => $_getN(3);
  @$pb.TagNumber(4)
  set expectedValue($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasExpectedValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearExpectedValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get variance => $_getN(4);
  @$pb.TagNumber(5)
  set variance($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVariance() => $_has(4);
  @$pb.TagNumber(5)
  void clearVariance() => $_clearField(5);
}

class YieldPredictionResponse extends $pb.GeneratedMessage {
  factory YieldPredictionResponse({
    YieldForecast? forecast,
    $core.Iterable<YieldForecast>? ensembleForecasts,
  }) {
    final $result = create();
    if (forecast != null) {
      $result.forecast = forecast;
    }
    if (ensembleForecasts != null) {
      $result.ensembleForecasts.addAll(ensembleForecasts);
    }
    return $result;
  }
  YieldPredictionResponse._() : super();
  factory YieldPredictionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory YieldPredictionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'YieldPredictionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOM<YieldForecast>(1, _omitFieldNames ? '' : 'forecast', subBuilder: YieldForecast.create)
    ..pc<YieldForecast>(2, _omitFieldNames ? '' : 'ensembleForecasts', $pb.PbFieldType.PM, subBuilder: YieldForecast.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  YieldPredictionResponse clone() => YieldPredictionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  YieldPredictionResponse copyWith(void Function(YieldPredictionResponse) updates) => super.copyWith((message) => updates(message as YieldPredictionResponse)) as YieldPredictionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static YieldPredictionResponse create() => YieldPredictionResponse._();
  YieldPredictionResponse createEmptyInstance() => create();
  static $pb.PbList<YieldPredictionResponse> createRepeated() => $pb.PbList<YieldPredictionResponse>();
  @$core.pragma('dart2js:noInline')
  static YieldPredictionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<YieldPredictionResponse>(create);
  static YieldPredictionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  YieldForecast get forecast => $_getN(0);
  @$pb.TagNumber(1)
  set forecast(YieldForecast v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasForecast() => $_has(0);
  @$pb.TagNumber(1)
  void clearForecast() => $_clearField(1);
  @$pb.TagNumber(1)
  YieldForecast ensureForecast() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<YieldForecast> get ensembleForecasts => $_getList(1);
}

class AnomalyScore extends $pb.GeneratedMessage {
  factory AnomalyScore({
    $core.double? score,
    AnomalyType? anomalyType,
    $core.double? confidence,
  }) {
    final $result = create();
    if (score != null) {
      $result.score = score;
    }
    if (anomalyType != null) {
      $result.anomalyType = anomalyType;
    }
    if (confidence != null) {
      $result.confidence = confidence;
    }
    return $result;
  }
  AnomalyScore._() : super();
  factory AnomalyScore.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnomalyScore.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnomalyScore', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'score', $pb.PbFieldType.OD)
    ..e<AnomalyType>(2, _omitFieldNames ? '' : 'anomalyType', $pb.PbFieldType.OE, defaultOrMaker: AnomalyType.NORMAL, valueOf: AnomalyType.valueOf, enumValues: AnomalyType.values)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'confidence', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnomalyScore clone() => AnomalyScore()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnomalyScore copyWith(void Function(AnomalyScore) updates) => super.copyWith((message) => updates(message as AnomalyScore)) as AnomalyScore;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnomalyScore create() => AnomalyScore._();
  AnomalyScore createEmptyInstance() => create();
  static $pb.PbList<AnomalyScore> createRepeated() => $pb.PbList<AnomalyScore>();
  @$core.pragma('dart2js:noInline')
  static AnomalyScore getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnomalyScore>(create);
  static AnomalyScore? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get score => $_getN(0);
  @$pb.TagNumber(1)
  set score($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearScore() => $_clearField(1);

  @$pb.TagNumber(2)
  AnomalyType get anomalyType => $_getN(1);
  @$pb.TagNumber(2)
  set anomalyType(AnomalyType v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasAnomalyType() => $_has(1);
  @$pb.TagNumber(2)
  void clearAnomalyType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get confidence => $_getN(2);
  @$pb.TagNumber(3)
  set confidence($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasConfidence() => $_has(2);
  @$pb.TagNumber(3)
  void clearConfidence() => $_clearField(3);
}

class AnomalyDetectionRequest extends $pb.GeneratedMessage {
  factory AnomalyDetectionRequest({
    $core.double? expectedYield,
    $core.double? actualYield,
    $core.double? modelPrediction,
    $core.double? sensorVariance,
  }) {
    final $result = create();
    if (expectedYield != null) {
      $result.expectedYield = expectedYield;
    }
    if (actualYield != null) {
      $result.actualYield = actualYield;
    }
    if (modelPrediction != null) {
      $result.modelPrediction = modelPrediction;
    }
    if (sensorVariance != null) {
      $result.sensorVariance = sensorVariance;
    }
    return $result;
  }
  AnomalyDetectionRequest._() : super();
  factory AnomalyDetectionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnomalyDetectionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnomalyDetectionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'expectedYield', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'actualYield', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'modelPrediction', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'sensorVariance', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnomalyDetectionRequest clone() => AnomalyDetectionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnomalyDetectionRequest copyWith(void Function(AnomalyDetectionRequest) updates) => super.copyWith((message) => updates(message as AnomalyDetectionRequest)) as AnomalyDetectionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnomalyDetectionRequest create() => AnomalyDetectionRequest._();
  AnomalyDetectionRequest createEmptyInstance() => create();
  static $pb.PbList<AnomalyDetectionRequest> createRepeated() => $pb.PbList<AnomalyDetectionRequest>();
  @$core.pragma('dart2js:noInline')
  static AnomalyDetectionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnomalyDetectionRequest>(create);
  static AnomalyDetectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get expectedYield => $_getN(0);
  @$pb.TagNumber(1)
  set expectedYield($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasExpectedYield() => $_has(0);
  @$pb.TagNumber(1)
  void clearExpectedYield() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get actualYield => $_getN(1);
  @$pb.TagNumber(2)
  set actualYield($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasActualYield() => $_has(1);
  @$pb.TagNumber(2)
  void clearActualYield() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get modelPrediction => $_getN(2);
  @$pb.TagNumber(3)
  set modelPrediction($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasModelPrediction() => $_has(2);
  @$pb.TagNumber(3)
  void clearModelPrediction() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get sensorVariance => $_getN(3);
  @$pb.TagNumber(4)
  set sensorVariance($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSensorVariance() => $_has(3);
  @$pb.TagNumber(4)
  void clearSensorVariance() => $_clearField(4);
}

class AnomalyDetectionResponse extends $pb.GeneratedMessage {
  factory AnomalyDetectionResponse({
    AnomalyScore? score,
    $core.bool? isAnomalous,
    $core.String? recommendation,
  }) {
    final $result = create();
    if (score != null) {
      $result.score = score;
    }
    if (isAnomalous != null) {
      $result.isAnomalous = isAnomalous;
    }
    if (recommendation != null) {
      $result.recommendation = recommendation;
    }
    return $result;
  }
  AnomalyDetectionResponse._() : super();
  factory AnomalyDetectionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnomalyDetectionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnomalyDetectionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOM<AnomalyScore>(1, _omitFieldNames ? '' : 'score', subBuilder: AnomalyScore.create)
    ..aOB(2, _omitFieldNames ? '' : 'isAnomalous')
    ..aOS(3, _omitFieldNames ? '' : 'recommendation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnomalyDetectionResponse clone() => AnomalyDetectionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnomalyDetectionResponse copyWith(void Function(AnomalyDetectionResponse) updates) => super.copyWith((message) => updates(message as AnomalyDetectionResponse)) as AnomalyDetectionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnomalyDetectionResponse create() => AnomalyDetectionResponse._();
  AnomalyDetectionResponse createEmptyInstance() => create();
  static $pb.PbList<AnomalyDetectionResponse> createRepeated() => $pb.PbList<AnomalyDetectionResponse>();
  @$core.pragma('dart2js:noInline')
  static AnomalyDetectionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnomalyDetectionResponse>(create);
  static AnomalyDetectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  AnomalyScore get score => $_getN(0);
  @$pb.TagNumber(1)
  set score(AnomalyScore v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasScore() => $_has(0);
  @$pb.TagNumber(1)
  void clearScore() => $_clearField(1);
  @$pb.TagNumber(1)
  AnomalyScore ensureScore() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isAnomalous => $_getBF(1);
  @$pb.TagNumber(2)
  set isAnomalous($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsAnomalous() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsAnomalous() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get recommendation => $_getSZ(2);
  @$pb.TagNumber(3)
  set recommendation($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecommendation() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecommendation() => $_clearField(3);
}

class DegradationForecast extends $pb.GeneratedMessage {
  factory DegradationForecast({
    $core.double? currentDegradationPercent,
    $core.double? annualDegradationRate,
    $core.double? projectedDegradation5yr,
    $core.double? projectedDegradation10yr,
    $core.double? confidenceInterval,
  }) {
    final $result = create();
    if (currentDegradationPercent != null) {
      $result.currentDegradationPercent = currentDegradationPercent;
    }
    if (annualDegradationRate != null) {
      $result.annualDegradationRate = annualDegradationRate;
    }
    if (projectedDegradation5yr != null) {
      $result.projectedDegradation5yr = projectedDegradation5yr;
    }
    if (projectedDegradation10yr != null) {
      $result.projectedDegradation10yr = projectedDegradation10yr;
    }
    if (confidenceInterval != null) {
      $result.confidenceInterval = confidenceInterval;
    }
    return $result;
  }
  DegradationForecast._() : super();
  factory DegradationForecast.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DegradationForecast.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DegradationForecast', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'currentDegradationPercent', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'annualDegradationRate', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'projectedDegradation5yr', $pb.PbFieldType.OD, protoName: 'projected_degradation_5yr')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'projectedDegradation10yr', $pb.PbFieldType.OD, protoName: 'projected_degradation_10yr')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'confidenceInterval', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DegradationForecast clone() => DegradationForecast()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DegradationForecast copyWith(void Function(DegradationForecast) updates) => super.copyWith((message) => updates(message as DegradationForecast)) as DegradationForecast;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DegradationForecast create() => DegradationForecast._();
  DegradationForecast createEmptyInstance() => create();
  static $pb.PbList<DegradationForecast> createRepeated() => $pb.PbList<DegradationForecast>();
  @$core.pragma('dart2js:noInline')
  static DegradationForecast getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DegradationForecast>(create);
  static DegradationForecast? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get currentDegradationPercent => $_getN(0);
  @$pb.TagNumber(1)
  set currentDegradationPercent($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCurrentDegradationPercent() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentDegradationPercent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get annualDegradationRate => $_getN(1);
  @$pb.TagNumber(2)
  set annualDegradationRate($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAnnualDegradationRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearAnnualDegradationRate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get projectedDegradation5yr => $_getN(2);
  @$pb.TagNumber(3)
  set projectedDegradation5yr($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProjectedDegradation5yr() => $_has(2);
  @$pb.TagNumber(3)
  void clearProjectedDegradation5yr() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get projectedDegradation10yr => $_getN(3);
  @$pb.TagNumber(4)
  set projectedDegradation10yr($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProjectedDegradation10yr() => $_has(3);
  @$pb.TagNumber(4)
  void clearProjectedDegradation10yr() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get confidenceInterval => $_getN(4);
  @$pb.TagNumber(5)
  set confidenceInterval($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasConfidenceInterval() => $_has(4);
  @$pb.TagNumber(5)
  void clearConfidenceInterval() => $_clearField(5);
}

class DegradationRequest extends $pb.GeneratedMessage {
  factory DegradationRequest({
    $core.double? currentDegradation,
    $core.double? annualRate,
    $core.int? years,
  }) {
    final $result = create();
    if (currentDegradation != null) {
      $result.currentDegradation = currentDegradation;
    }
    if (annualRate != null) {
      $result.annualRate = annualRate;
    }
    if (years != null) {
      $result.years = years;
    }
    return $result;
  }
  DegradationRequest._() : super();
  factory DegradationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DegradationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DegradationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'currentDegradation', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'annualRate', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'years', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DegradationRequest clone() => DegradationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DegradationRequest copyWith(void Function(DegradationRequest) updates) => super.copyWith((message) => updates(message as DegradationRequest)) as DegradationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DegradationRequest create() => DegradationRequest._();
  DegradationRequest createEmptyInstance() => create();
  static $pb.PbList<DegradationRequest> createRepeated() => $pb.PbList<DegradationRequest>();
  @$core.pragma('dart2js:noInline')
  static DegradationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DegradationRequest>(create);
  static DegradationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get currentDegradation => $_getN(0);
  @$pb.TagNumber(1)
  set currentDegradation($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCurrentDegradation() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentDegradation() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get annualRate => $_getN(1);
  @$pb.TagNumber(2)
  set annualRate($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAnnualRate() => $_has(1);
  @$pb.TagNumber(2)
  void clearAnnualRate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get years => $_getIZ(2);
  @$pb.TagNumber(3)
  set years($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasYears() => $_has(2);
  @$pb.TagNumber(3)
  void clearYears() => $_clearField(3);
}

class DegradationResponse extends $pb.GeneratedMessage {
  factory DegradationResponse({
    DegradationForecast? forecast,
    $core.double? remainingUsefulLifeYears,
  }) {
    final $result = create();
    if (forecast != null) {
      $result.forecast = forecast;
    }
    if (remainingUsefulLifeYears != null) {
      $result.remainingUsefulLifeYears = remainingUsefulLifeYears;
    }
    return $result;
  }
  DegradationResponse._() : super();
  factory DegradationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DegradationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DegradationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOM<DegradationForecast>(1, _omitFieldNames ? '' : 'forecast', subBuilder: DegradationForecast.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'remainingUsefulLifeYears', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DegradationResponse clone() => DegradationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DegradationResponse copyWith(void Function(DegradationResponse) updates) => super.copyWith((message) => updates(message as DegradationResponse)) as DegradationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DegradationResponse create() => DegradationResponse._();
  DegradationResponse createEmptyInstance() => create();
  static $pb.PbList<DegradationResponse> createRepeated() => $pb.PbList<DegradationResponse>();
  @$core.pragma('dart2js:noInline')
  static DegradationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DegradationResponse>(create);
  static DegradationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DegradationForecast get forecast => $_getN(0);
  @$pb.TagNumber(1)
  set forecast(DegradationForecast v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasForecast() => $_has(0);
  @$pb.TagNumber(1)
  void clearForecast() => $_clearField(1);
  @$pb.TagNumber(1)
  DegradationForecast ensureForecast() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get remainingUsefulLifeYears => $_getN(1);
  @$pb.TagNumber(2)
  set remainingUsefulLifeYears($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRemainingUsefulLifeYears() => $_has(1);
  @$pb.TagNumber(2)
  void clearRemainingUsefulLifeYears() => $_clearField(2);
}

class SubmitFeedbackRequest extends $pb.GeneratedMessage {
  factory SubmitFeedbackRequest({
    $core.String? predictionId,
    $core.String? siteId,
    $core.String? taskType,
    $core.double? actualLabel,
    $core.String? notes,
    $core.String? submittedBy,
    $2.LabeledFeatureSample? sample,
  }) {
    final $result = create();
    if (predictionId != null) {
      $result.predictionId = predictionId;
    }
    if (siteId != null) {
      $result.siteId = siteId;
    }
    if (taskType != null) {
      $result.taskType = taskType;
    }
    if (actualLabel != null) {
      $result.actualLabel = actualLabel;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    if (submittedBy != null) {
      $result.submittedBy = submittedBy;
    }
    if (sample != null) {
      $result.sample = sample;
    }
    return $result;
  }
  SubmitFeedbackRequest._() : super();
  factory SubmitFeedbackRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitFeedbackRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitFeedbackRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'predictionId')
    ..aOS(2, _omitFieldNames ? '' : 'siteId')
    ..aOS(3, _omitFieldNames ? '' : 'taskType')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'actualLabel', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'notes')
    ..aOS(6, _omitFieldNames ? '' : 'submittedBy')
    ..aOM<$2.LabeledFeatureSample>(10, _omitFieldNames ? '' : 'sample', subBuilder: $2.LabeledFeatureSample.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitFeedbackRequest clone() => SubmitFeedbackRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitFeedbackRequest copyWith(void Function(SubmitFeedbackRequest) updates) => super.copyWith((message) => updates(message as SubmitFeedbackRequest)) as SubmitFeedbackRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitFeedbackRequest create() => SubmitFeedbackRequest._();
  SubmitFeedbackRequest createEmptyInstance() => create();
  static $pb.PbList<SubmitFeedbackRequest> createRepeated() => $pb.PbList<SubmitFeedbackRequest>();
  @$core.pragma('dart2js:noInline')
  static SubmitFeedbackRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitFeedbackRequest>(create);
  static SubmitFeedbackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get predictionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set predictionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPredictionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPredictionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get siteId => $_getSZ(1);
  @$pb.TagNumber(2)
  set siteId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSiteId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSiteId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get taskType => $_getSZ(2);
  @$pb.TagNumber(3)
  set taskType($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTaskType() => $_has(2);
  @$pb.TagNumber(3)
  void clearTaskType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get actualLabel => $_getN(3);
  @$pb.TagNumber(4)
  set actualLabel($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasActualLabel() => $_has(3);
  @$pb.TagNumber(4)
  void clearActualLabel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get notes => $_getSZ(4);
  @$pb.TagNumber(5)
  set notes($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasNotes() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotes() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get submittedBy => $_getSZ(5);
  @$pb.TagNumber(6)
  set submittedBy($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSubmittedBy() => $_has(5);
  @$pb.TagNumber(6)
  void clearSubmittedBy() => $_clearField(6);

  @$pb.TagNumber(10)
  $2.LabeledFeatureSample get sample => $_getN(6);
  @$pb.TagNumber(10)
  set sample($2.LabeledFeatureSample v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasSample() => $_has(6);
  @$pb.TagNumber(10)
  void clearSample() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.LabeledFeatureSample ensureSample() => $_ensure(6);
}

class SubmitFeedbackResponse extends $pb.GeneratedMessage {
  factory SubmitFeedbackResponse({
    $core.String? feedbackId,
    $core.bool? accepted,
    $core.String? message,
  }) {
    final $result = create();
    if (feedbackId != null) {
      $result.feedbackId = feedbackId;
    }
    if (accepted != null) {
      $result.accepted = accepted;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  SubmitFeedbackResponse._() : super();
  factory SubmitFeedbackResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitFeedbackResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitFeedbackResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'feedbackId')
    ..aOB(2, _omitFieldNames ? '' : 'accepted')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitFeedbackResponse clone() => SubmitFeedbackResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitFeedbackResponse copyWith(void Function(SubmitFeedbackResponse) updates) => super.copyWith((message) => updates(message as SubmitFeedbackResponse)) as SubmitFeedbackResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitFeedbackResponse create() => SubmitFeedbackResponse._();
  SubmitFeedbackResponse createEmptyInstance() => create();
  static $pb.PbList<SubmitFeedbackResponse> createRepeated() => $pb.PbList<SubmitFeedbackResponse>();
  @$core.pragma('dart2js:noInline')
  static SubmitFeedbackResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitFeedbackResponse>(create);
  static SubmitFeedbackResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get feedbackId => $_getSZ(0);
  @$pb.TagNumber(1)
  set feedbackId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFeedbackId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFeedbackId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get accepted => $_getBF(1);
  @$pb.TagNumber(2)
  set accepted($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAccepted() => $_has(1);
  @$pb.TagNumber(2)
  void clearAccepted() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);
}

class TrainingDataConfig extends $pb.GeneratedMessage {
  factory TrainingDataConfig({
    $core.String? version,
    $core.int? lookbackDays,
    $core.int? minSamplesPerSite,
    $core.double? trainSplitRatio,
    $core.double? validationSplitRatio,
    $core.double? testSplitRatio,
    $core.bool? timeAwareSplit,
    $core.String? featureSchemaHash,
    $2.FeatureSchema? featureSchema,
  }) {
    final $result = create();
    if (version != null) {
      $result.version = version;
    }
    if (lookbackDays != null) {
      $result.lookbackDays = lookbackDays;
    }
    if (minSamplesPerSite != null) {
      $result.minSamplesPerSite = minSamplesPerSite;
    }
    if (trainSplitRatio != null) {
      $result.trainSplitRatio = trainSplitRatio;
    }
    if (validationSplitRatio != null) {
      $result.validationSplitRatio = validationSplitRatio;
    }
    if (testSplitRatio != null) {
      $result.testSplitRatio = testSplitRatio;
    }
    if (timeAwareSplit != null) {
      $result.timeAwareSplit = timeAwareSplit;
    }
    if (featureSchemaHash != null) {
      $result.featureSchemaHash = featureSchemaHash;
    }
    if (featureSchema != null) {
      $result.featureSchema = featureSchema;
    }
    return $result;
  }
  TrainingDataConfig._() : super();
  factory TrainingDataConfig.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrainingDataConfig.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrainingDataConfig', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'version')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'lookbackDays', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'minSamplesPerSite', $pb.PbFieldType.O3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'trainSplitRatio', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'validationSplitRatio', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'testSplitRatio', $pb.PbFieldType.OD)
    ..aOB(7, _omitFieldNames ? '' : 'timeAwareSplit')
    ..aOS(8, _omitFieldNames ? '' : 'featureSchemaHash')
    ..aOM<$2.FeatureSchema>(10, _omitFieldNames ? '' : 'featureSchema', subBuilder: $2.FeatureSchema.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrainingDataConfig clone() => TrainingDataConfig()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrainingDataConfig copyWith(void Function(TrainingDataConfig) updates) => super.copyWith((message) => updates(message as TrainingDataConfig)) as TrainingDataConfig;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrainingDataConfig create() => TrainingDataConfig._();
  TrainingDataConfig createEmptyInstance() => create();
  static $pb.PbList<TrainingDataConfig> createRepeated() => $pb.PbList<TrainingDataConfig>();
  @$core.pragma('dart2js:noInline')
  static TrainingDataConfig getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrainingDataConfig>(create);
  static TrainingDataConfig? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get version => $_getSZ(0);
  @$pb.TagNumber(1)
  set version($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get lookbackDays => $_getIZ(1);
  @$pb.TagNumber(2)
  set lookbackDays($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLookbackDays() => $_has(1);
  @$pb.TagNumber(2)
  void clearLookbackDays() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get minSamplesPerSite => $_getIZ(2);
  @$pb.TagNumber(3)
  set minSamplesPerSite($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMinSamplesPerSite() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinSamplesPerSite() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get trainSplitRatio => $_getN(3);
  @$pb.TagNumber(4)
  set trainSplitRatio($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTrainSplitRatio() => $_has(3);
  @$pb.TagNumber(4)
  void clearTrainSplitRatio() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get validationSplitRatio => $_getN(4);
  @$pb.TagNumber(5)
  set validationSplitRatio($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasValidationSplitRatio() => $_has(4);
  @$pb.TagNumber(5)
  void clearValidationSplitRatio() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get testSplitRatio => $_getN(5);
  @$pb.TagNumber(6)
  set testSplitRatio($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTestSplitRatio() => $_has(5);
  @$pb.TagNumber(6)
  void clearTestSplitRatio() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get timeAwareSplit => $_getBF(6);
  @$pb.TagNumber(7)
  set timeAwareSplit($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTimeAwareSplit() => $_has(6);
  @$pb.TagNumber(7)
  void clearTimeAwareSplit() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get featureSchemaHash => $_getSZ(7);
  @$pb.TagNumber(8)
  set featureSchemaHash($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasFeatureSchemaHash() => $_has(7);
  @$pb.TagNumber(8)
  void clearFeatureSchemaHash() => $_clearField(8);

  @$pb.TagNumber(10)
  $2.FeatureSchema get featureSchema => $_getN(8);
  @$pb.TagNumber(10)
  set featureSchema($2.FeatureSchema v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasFeatureSchema() => $_has(8);
  @$pb.TagNumber(10)
  void clearFeatureSchema() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.FeatureSchema ensureFeatureSchema() => $_ensure(8);
}

class StartTrainingRequest extends $pb.GeneratedMessage {
  factory StartTrainingRequest({
    $core.String? taskType,
    TrainingDataConfig? config,
    $pb.PbMap<$core.String, $core.String>? hyperparams,
    $core.String? triggeredBy,
    $core.String? commitHash,
    $2.FeatureSchema? expectedSchema,
  }) {
    final $result = create();
    if (taskType != null) {
      $result.taskType = taskType;
    }
    if (config != null) {
      $result.config = config;
    }
    if (hyperparams != null) {
      $result.hyperparams.addAll(hyperparams);
    }
    if (triggeredBy != null) {
      $result.triggeredBy = triggeredBy;
    }
    if (commitHash != null) {
      $result.commitHash = commitHash;
    }
    if (expectedSchema != null) {
      $result.expectedSchema = expectedSchema;
    }
    return $result;
  }
  StartTrainingRequest._() : super();
  factory StartTrainingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StartTrainingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StartTrainingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskType')
    ..aOM<TrainingDataConfig>(2, _omitFieldNames ? '' : 'config', subBuilder: TrainingDataConfig.create)
    ..m<$core.String, $core.String>(3, _omitFieldNames ? '' : 'hyperparams', entryClassName: 'StartTrainingRequest.HyperparamsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('ml_inference.v1'))
    ..aOS(4, _omitFieldNames ? '' : 'triggeredBy')
    ..aOS(5, _omitFieldNames ? '' : 'commitHash')
    ..aOM<$2.FeatureSchema>(10, _omitFieldNames ? '' : 'expectedSchema', subBuilder: $2.FeatureSchema.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StartTrainingRequest clone() => StartTrainingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StartTrainingRequest copyWith(void Function(StartTrainingRequest) updates) => super.copyWith((message) => updates(message as StartTrainingRequest)) as StartTrainingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartTrainingRequest create() => StartTrainingRequest._();
  StartTrainingRequest createEmptyInstance() => create();
  static $pb.PbList<StartTrainingRequest> createRepeated() => $pb.PbList<StartTrainingRequest>();
  @$core.pragma('dart2js:noInline')
  static StartTrainingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StartTrainingRequest>(create);
  static StartTrainingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskType => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTaskType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskType() => $_clearField(1);

  @$pb.TagNumber(2)
  TrainingDataConfig get config => $_getN(1);
  @$pb.TagNumber(2)
  set config(TrainingDataConfig v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasConfig() => $_has(1);
  @$pb.TagNumber(2)
  void clearConfig() => $_clearField(2);
  @$pb.TagNumber(2)
  TrainingDataConfig ensureConfig() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get hyperparams => $_getMap(2);

  @$pb.TagNumber(4)
  $core.String get triggeredBy => $_getSZ(3);
  @$pb.TagNumber(4)
  set triggeredBy($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTriggeredBy() => $_has(3);
  @$pb.TagNumber(4)
  void clearTriggeredBy() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get commitHash => $_getSZ(4);
  @$pb.TagNumber(5)
  set commitHash($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCommitHash() => $_has(4);
  @$pb.TagNumber(5)
  void clearCommitHash() => $_clearField(5);

  @$pb.TagNumber(10)
  $2.FeatureSchema get expectedSchema => $_getN(5);
  @$pb.TagNumber(10)
  set expectedSchema($2.FeatureSchema v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasExpectedSchema() => $_has(5);
  @$pb.TagNumber(10)
  void clearExpectedSchema() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.FeatureSchema ensureExpectedSchema() => $_ensure(5);
}

class StartTrainingResponse extends $pb.GeneratedMessage {
  factory StartTrainingResponse({
    $core.String? trainingRunId,
    $core.String? status,
    $fixnum.Int64? queuedAtMs,
  }) {
    final $result = create();
    if (trainingRunId != null) {
      $result.trainingRunId = trainingRunId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (queuedAtMs != null) {
      $result.queuedAtMs = queuedAtMs;
    }
    return $result;
  }
  StartTrainingResponse._() : super();
  factory StartTrainingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StartTrainingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StartTrainingResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trainingRunId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aInt64(3, _omitFieldNames ? '' : 'queuedAtMs')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StartTrainingResponse clone() => StartTrainingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StartTrainingResponse copyWith(void Function(StartTrainingResponse) updates) => super.copyWith((message) => updates(message as StartTrainingResponse)) as StartTrainingResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StartTrainingResponse create() => StartTrainingResponse._();
  StartTrainingResponse createEmptyInstance() => create();
  static $pb.PbList<StartTrainingResponse> createRepeated() => $pb.PbList<StartTrainingResponse>();
  @$core.pragma('dart2js:noInline')
  static StartTrainingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StartTrainingResponse>(create);
  static StartTrainingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trainingRunId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trainingRunId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrainingRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrainingRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get queuedAtMs => $_getI64(2);
  @$pb.TagNumber(3)
  set queuedAtMs($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasQueuedAtMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearQueuedAtMs() => $_clearField(3);
}

class GetTrainingStatusRequest extends $pb.GeneratedMessage {
  factory GetTrainingStatusRequest({
    $core.String? trainingRunId,
  }) {
    final $result = create();
    if (trainingRunId != null) {
      $result.trainingRunId = trainingRunId;
    }
    return $result;
  }
  GetTrainingStatusRequest._() : super();
  factory GetTrainingStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTrainingStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetTrainingStatusRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trainingRunId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTrainingStatusRequest clone() => GetTrainingStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTrainingStatusRequest copyWith(void Function(GetTrainingStatusRequest) updates) => super.copyWith((message) => updates(message as GetTrainingStatusRequest)) as GetTrainingStatusRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTrainingStatusRequest create() => GetTrainingStatusRequest._();
  GetTrainingStatusRequest createEmptyInstance() => create();
  static $pb.PbList<GetTrainingStatusRequest> createRepeated() => $pb.PbList<GetTrainingStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTrainingStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTrainingStatusRequest>(create);
  static GetTrainingStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trainingRunId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trainingRunId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrainingRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrainingRunId() => $_clearField(1);
}

class TrainingMetrics extends $pb.GeneratedMessage {
  factory TrainingMetrics({
    $core.double? trainLoss,
    $core.double? validationLoss,
    $core.double? testLoss,
    $core.double? testMae,
    $core.double? testRmse,
    $core.double? testCoverageLower,
    $core.double? testCoverageUpper,
    $pb.PbMap<$core.String, $core.double>? customMetrics,
  }) {
    final $result = create();
    if (trainLoss != null) {
      $result.trainLoss = trainLoss;
    }
    if (validationLoss != null) {
      $result.validationLoss = validationLoss;
    }
    if (testLoss != null) {
      $result.testLoss = testLoss;
    }
    if (testMae != null) {
      $result.testMae = testMae;
    }
    if (testRmse != null) {
      $result.testRmse = testRmse;
    }
    if (testCoverageLower != null) {
      $result.testCoverageLower = testCoverageLower;
    }
    if (testCoverageUpper != null) {
      $result.testCoverageUpper = testCoverageUpper;
    }
    if (customMetrics != null) {
      $result.customMetrics.addAll(customMetrics);
    }
    return $result;
  }
  TrainingMetrics._() : super();
  factory TrainingMetrics.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrainingMetrics.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrainingMetrics', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'trainLoss', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'validationLoss', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'testLoss', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'testMae', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'testRmse', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'testCoverageLower', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'testCoverageUpper', $pb.PbFieldType.OD)
    ..m<$core.String, $core.double>(8, _omitFieldNames ? '' : 'customMetrics', entryClassName: 'TrainingMetrics.CustomMetricsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OD, packageName: const $pb.PackageName('ml_inference.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrainingMetrics clone() => TrainingMetrics()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrainingMetrics copyWith(void Function(TrainingMetrics) updates) => super.copyWith((message) => updates(message as TrainingMetrics)) as TrainingMetrics;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrainingMetrics create() => TrainingMetrics._();
  TrainingMetrics createEmptyInstance() => create();
  static $pb.PbList<TrainingMetrics> createRepeated() => $pb.PbList<TrainingMetrics>();
  @$core.pragma('dart2js:noInline')
  static TrainingMetrics getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrainingMetrics>(create);
  static TrainingMetrics? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get trainLoss => $_getN(0);
  @$pb.TagNumber(1)
  set trainLoss($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrainLoss() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrainLoss() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get validationLoss => $_getN(1);
  @$pb.TagNumber(2)
  set validationLoss($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValidationLoss() => $_has(1);
  @$pb.TagNumber(2)
  void clearValidationLoss() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get testLoss => $_getN(2);
  @$pb.TagNumber(3)
  set testLoss($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTestLoss() => $_has(2);
  @$pb.TagNumber(3)
  void clearTestLoss() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get testMae => $_getN(3);
  @$pb.TagNumber(4)
  set testMae($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTestMae() => $_has(3);
  @$pb.TagNumber(4)
  void clearTestMae() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get testRmse => $_getN(4);
  @$pb.TagNumber(5)
  set testRmse($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTestRmse() => $_has(4);
  @$pb.TagNumber(5)
  void clearTestRmse() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get testCoverageLower => $_getN(5);
  @$pb.TagNumber(6)
  set testCoverageLower($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTestCoverageLower() => $_has(5);
  @$pb.TagNumber(6)
  void clearTestCoverageLower() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get testCoverageUpper => $_getN(6);
  @$pb.TagNumber(7)
  set testCoverageUpper($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTestCoverageUpper() => $_has(6);
  @$pb.TagNumber(7)
  void clearTestCoverageUpper() => $_clearField(7);

  @$pb.TagNumber(8)
  $pb.PbMap<$core.String, $core.double> get customMetrics => $_getMap(7);
}

class GetTrainingStatusResponse extends $pb.GeneratedMessage {
  factory GetTrainingStatusResponse({
    $core.String? trainingRunId,
    $core.String? status,
    TrainingMetrics? metrics,
    $core.String? errorMessage,
    $fixnum.Int64? startedAtMs,
    $fixnum.Int64? completedAtMs,
    $core.String? modelVersionId,
    $core.double? completionProgress,
  }) {
    final $result = create();
    if (trainingRunId != null) {
      $result.trainingRunId = trainingRunId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (metrics != null) {
      $result.metrics = metrics;
    }
    if (errorMessage != null) {
      $result.errorMessage = errorMessage;
    }
    if (startedAtMs != null) {
      $result.startedAtMs = startedAtMs;
    }
    if (completedAtMs != null) {
      $result.completedAtMs = completedAtMs;
    }
    if (modelVersionId != null) {
      $result.modelVersionId = modelVersionId;
    }
    if (completionProgress != null) {
      $result.completionProgress = completionProgress;
    }
    return $result;
  }
  GetTrainingStatusResponse._() : super();
  factory GetTrainingStatusResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTrainingStatusResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetTrainingStatusResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'trainingRunId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aOM<TrainingMetrics>(3, _omitFieldNames ? '' : 'metrics', subBuilder: TrainingMetrics.create)
    ..aOS(4, _omitFieldNames ? '' : 'errorMessage')
    ..aInt64(5, _omitFieldNames ? '' : 'startedAtMs')
    ..aInt64(6, _omitFieldNames ? '' : 'completedAtMs')
    ..aOS(7, _omitFieldNames ? '' : 'modelVersionId')
    ..a<$core.double>(8, _omitFieldNames ? '' : 'completionProgress', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTrainingStatusResponse clone() => GetTrainingStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTrainingStatusResponse copyWith(void Function(GetTrainingStatusResponse) updates) => super.copyWith((message) => updates(message as GetTrainingStatusResponse)) as GetTrainingStatusResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTrainingStatusResponse create() => GetTrainingStatusResponse._();
  GetTrainingStatusResponse createEmptyInstance() => create();
  static $pb.PbList<GetTrainingStatusResponse> createRepeated() => $pb.PbList<GetTrainingStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static GetTrainingStatusResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTrainingStatusResponse>(create);
  static GetTrainingStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trainingRunId => $_getSZ(0);
  @$pb.TagNumber(1)
  set trainingRunId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrainingRunId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrainingRunId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  TrainingMetrics get metrics => $_getN(2);
  @$pb.TagNumber(3)
  set metrics(TrainingMetrics v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasMetrics() => $_has(2);
  @$pb.TagNumber(3)
  void clearMetrics() => $_clearField(3);
  @$pb.TagNumber(3)
  TrainingMetrics ensureMetrics() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get errorMessage => $_getSZ(3);
  @$pb.TagNumber(4)
  set errorMessage($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasErrorMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearErrorMessage() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get startedAtMs => $_getI64(4);
  @$pb.TagNumber(5)
  set startedAtMs($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasStartedAtMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartedAtMs() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get completedAtMs => $_getI64(5);
  @$pb.TagNumber(6)
  set completedAtMs($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCompletedAtMs() => $_has(5);
  @$pb.TagNumber(6)
  void clearCompletedAtMs() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get modelVersionId => $_getSZ(6);
  @$pb.TagNumber(7)
  set modelVersionId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasModelVersionId() => $_has(6);
  @$pb.TagNumber(7)
  void clearModelVersionId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get completionProgress => $_getN(7);
  @$pb.TagNumber(8)
  set completionProgress($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCompletionProgress() => $_has(7);
  @$pb.TagNumber(8)
  void clearCompletionProgress() => $_clearField(8);
}

class EvaluateModelRequest extends $pb.GeneratedMessage {
  factory EvaluateModelRequest({
    $core.String? modelVersionId,
    $core.String? dataset,
    $core.String? versusModelId,
  }) {
    final $result = create();
    if (modelVersionId != null) {
      $result.modelVersionId = modelVersionId;
    }
    if (dataset != null) {
      $result.dataset = dataset;
    }
    if (versusModelId != null) {
      $result.versusModelId = versusModelId;
    }
    return $result;
  }
  EvaluateModelRequest._() : super();
  factory EvaluateModelRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EvaluateModelRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EvaluateModelRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'modelVersionId')
    ..aOS(2, _omitFieldNames ? '' : 'dataset')
    ..aOS(3, _omitFieldNames ? '' : 'versusModelId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EvaluateModelRequest clone() => EvaluateModelRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EvaluateModelRequest copyWith(void Function(EvaluateModelRequest) updates) => super.copyWith((message) => updates(message as EvaluateModelRequest)) as EvaluateModelRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EvaluateModelRequest create() => EvaluateModelRequest._();
  EvaluateModelRequest createEmptyInstance() => create();
  static $pb.PbList<EvaluateModelRequest> createRepeated() => $pb.PbList<EvaluateModelRequest>();
  @$core.pragma('dart2js:noInline')
  static EvaluateModelRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EvaluateModelRequest>(create);
  static EvaluateModelRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get modelVersionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set modelVersionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasModelVersionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearModelVersionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get dataset => $_getSZ(1);
  @$pb.TagNumber(2)
  set dataset($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDataset() => $_has(1);
  @$pb.TagNumber(2)
  void clearDataset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get versusModelId => $_getSZ(2);
  @$pb.TagNumber(3)
  set versusModelId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVersusModelId() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersusModelId() => $_clearField(3);
}

class ModelEvaluation extends $pb.GeneratedMessage {
  factory ModelEvaluation({
    $core.String? modelVersionId,
    $core.String? versusModelId,
    $core.String? metricName,
    $core.double? baselineValue,
    $core.double? candidateValue,
    $core.double? improvementPercent,
    $core.bool? meetsThreshold,
  }) {
    final $result = create();
    if (modelVersionId != null) {
      $result.modelVersionId = modelVersionId;
    }
    if (versusModelId != null) {
      $result.versusModelId = versusModelId;
    }
    if (metricName != null) {
      $result.metricName = metricName;
    }
    if (baselineValue != null) {
      $result.baselineValue = baselineValue;
    }
    if (candidateValue != null) {
      $result.candidateValue = candidateValue;
    }
    if (improvementPercent != null) {
      $result.improvementPercent = improvementPercent;
    }
    if (meetsThreshold != null) {
      $result.meetsThreshold = meetsThreshold;
    }
    return $result;
  }
  ModelEvaluation._() : super();
  factory ModelEvaluation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ModelEvaluation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ModelEvaluation', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'modelVersionId')
    ..aOS(2, _omitFieldNames ? '' : 'versusModelId')
    ..aOS(3, _omitFieldNames ? '' : 'metricName')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'baselineValue', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'candidateValue', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'improvementPercent', $pb.PbFieldType.OD)
    ..aOB(7, _omitFieldNames ? '' : 'meetsThreshold')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ModelEvaluation clone() => ModelEvaluation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ModelEvaluation copyWith(void Function(ModelEvaluation) updates) => super.copyWith((message) => updates(message as ModelEvaluation)) as ModelEvaluation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ModelEvaluation create() => ModelEvaluation._();
  ModelEvaluation createEmptyInstance() => create();
  static $pb.PbList<ModelEvaluation> createRepeated() => $pb.PbList<ModelEvaluation>();
  @$core.pragma('dart2js:noInline')
  static ModelEvaluation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ModelEvaluation>(create);
  static ModelEvaluation? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get modelVersionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set modelVersionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasModelVersionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearModelVersionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get versusModelId => $_getSZ(1);
  @$pb.TagNumber(2)
  set versusModelId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVersusModelId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersusModelId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get metricName => $_getSZ(2);
  @$pb.TagNumber(3)
  set metricName($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMetricName() => $_has(2);
  @$pb.TagNumber(3)
  void clearMetricName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get baselineValue => $_getN(3);
  @$pb.TagNumber(4)
  set baselineValue($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBaselineValue() => $_has(3);
  @$pb.TagNumber(4)
  void clearBaselineValue() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get candidateValue => $_getN(4);
  @$pb.TagNumber(5)
  set candidateValue($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCandidateValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearCandidateValue() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get improvementPercent => $_getN(5);
  @$pb.TagNumber(6)
  set improvementPercent($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasImprovementPercent() => $_has(5);
  @$pb.TagNumber(6)
  void clearImprovementPercent() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get meetsThreshold => $_getBF(6);
  @$pb.TagNumber(7)
  set meetsThreshold($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMeetsThreshold() => $_has(6);
  @$pb.TagNumber(7)
  void clearMeetsThreshold() => $_clearField(7);
}

class EvaluateModelResponse extends $pb.GeneratedMessage {
  factory EvaluateModelResponse({
    $core.Iterable<ModelEvaluation>? evaluations,
    $core.bool? candidateWins,
    $core.String? recommendation,
  }) {
    final $result = create();
    if (evaluations != null) {
      $result.evaluations.addAll(evaluations);
    }
    if (candidateWins != null) {
      $result.candidateWins = candidateWins;
    }
    if (recommendation != null) {
      $result.recommendation = recommendation;
    }
    return $result;
  }
  EvaluateModelResponse._() : super();
  factory EvaluateModelResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EvaluateModelResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EvaluateModelResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..pc<ModelEvaluation>(1, _omitFieldNames ? '' : 'evaluations', $pb.PbFieldType.PM, subBuilder: ModelEvaluation.create)
    ..aOB(2, _omitFieldNames ? '' : 'candidateWins')
    ..aOS(3, _omitFieldNames ? '' : 'recommendation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EvaluateModelResponse clone() => EvaluateModelResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EvaluateModelResponse copyWith(void Function(EvaluateModelResponse) updates) => super.copyWith((message) => updates(message as EvaluateModelResponse)) as EvaluateModelResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EvaluateModelResponse create() => EvaluateModelResponse._();
  EvaluateModelResponse createEmptyInstance() => create();
  static $pb.PbList<EvaluateModelResponse> createRepeated() => $pb.PbList<EvaluateModelResponse>();
  @$core.pragma('dart2js:noInline')
  static EvaluateModelResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EvaluateModelResponse>(create);
  static EvaluateModelResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ModelEvaluation> get evaluations => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get candidateWins => $_getBF(1);
  @$pb.TagNumber(2)
  set candidateWins($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCandidateWins() => $_has(1);
  @$pb.TagNumber(2)
  void clearCandidateWins() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get recommendation => $_getSZ(2);
  @$pb.TagNumber(3)
  set recommendation($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecommendation() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecommendation() => $_clearField(3);
}

class ModelVersionInfo extends $pb.GeneratedMessage {
  factory ModelVersionInfo({
    $core.String? versionId,
    $core.String? taskType,
    $core.String? status,
    $fixnum.Int64? createdAtMs,
    $fixnum.Int64? deployedAtMs,
    TrainingMetrics? metrics,
    $core.String? artifactPath,
    $core.String? artifactHash,
    $core.String? schemaHash,
    $core.String? trainingRunId,
    $core.String? commitHash,
    $pb.PbMap<$core.String, $core.String>? metadata,
  }) {
    final $result = create();
    if (versionId != null) {
      $result.versionId = versionId;
    }
    if (taskType != null) {
      $result.taskType = taskType;
    }
    if (status != null) {
      $result.status = status;
    }
    if (createdAtMs != null) {
      $result.createdAtMs = createdAtMs;
    }
    if (deployedAtMs != null) {
      $result.deployedAtMs = deployedAtMs;
    }
    if (metrics != null) {
      $result.metrics = metrics;
    }
    if (artifactPath != null) {
      $result.artifactPath = artifactPath;
    }
    if (artifactHash != null) {
      $result.artifactHash = artifactHash;
    }
    if (schemaHash != null) {
      $result.schemaHash = schemaHash;
    }
    if (trainingRunId != null) {
      $result.trainingRunId = trainingRunId;
    }
    if (commitHash != null) {
      $result.commitHash = commitHash;
    }
    if (metadata != null) {
      $result.metadata.addAll(metadata);
    }
    return $result;
  }
  ModelVersionInfo._() : super();
  factory ModelVersionInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ModelVersionInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ModelVersionInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'versionId')
    ..aOS(2, _omitFieldNames ? '' : 'taskType')
    ..aOS(3, _omitFieldNames ? '' : 'status')
    ..aInt64(4, _omitFieldNames ? '' : 'createdAtMs')
    ..aInt64(5, _omitFieldNames ? '' : 'deployedAtMs')
    ..aOM<TrainingMetrics>(6, _omitFieldNames ? '' : 'metrics', subBuilder: TrainingMetrics.create)
    ..aOS(7, _omitFieldNames ? '' : 'artifactPath')
    ..aOS(8, _omitFieldNames ? '' : 'artifactHash')
    ..aOS(9, _omitFieldNames ? '' : 'schemaHash')
    ..aOS(10, _omitFieldNames ? '' : 'trainingRunId')
    ..aOS(11, _omitFieldNames ? '' : 'commitHash')
    ..m<$core.String, $core.String>(12, _omitFieldNames ? '' : 'metadata', entryClassName: 'ModelVersionInfo.MetadataEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('ml_inference.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ModelVersionInfo clone() => ModelVersionInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ModelVersionInfo copyWith(void Function(ModelVersionInfo) updates) => super.copyWith((message) => updates(message as ModelVersionInfo)) as ModelVersionInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ModelVersionInfo create() => ModelVersionInfo._();
  ModelVersionInfo createEmptyInstance() => create();
  static $pb.PbList<ModelVersionInfo> createRepeated() => $pb.PbList<ModelVersionInfo>();
  @$core.pragma('dart2js:noInline')
  static ModelVersionInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ModelVersionInfo>(create);
  static ModelVersionInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get versionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set versionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVersionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVersionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get taskType => $_getSZ(1);
  @$pb.TagNumber(2)
  set taskType($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTaskType() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get status => $_getSZ(2);
  @$pb.TagNumber(3)
  set status($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatus() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatus() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get createdAtMs => $_getI64(3);
  @$pb.TagNumber(4)
  set createdAtMs($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCreatedAtMs() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatedAtMs() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get deployedAtMs => $_getI64(4);
  @$pb.TagNumber(5)
  set deployedAtMs($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDeployedAtMs() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeployedAtMs() => $_clearField(5);

  @$pb.TagNumber(6)
  TrainingMetrics get metrics => $_getN(5);
  @$pb.TagNumber(6)
  set metrics(TrainingMetrics v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasMetrics() => $_has(5);
  @$pb.TagNumber(6)
  void clearMetrics() => $_clearField(6);
  @$pb.TagNumber(6)
  TrainingMetrics ensureMetrics() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get artifactPath => $_getSZ(6);
  @$pb.TagNumber(7)
  set artifactPath($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasArtifactPath() => $_has(6);
  @$pb.TagNumber(7)
  void clearArtifactPath() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get artifactHash => $_getSZ(7);
  @$pb.TagNumber(8)
  set artifactHash($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasArtifactHash() => $_has(7);
  @$pb.TagNumber(8)
  void clearArtifactHash() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get schemaHash => $_getSZ(8);
  @$pb.TagNumber(9)
  set schemaHash($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasSchemaHash() => $_has(8);
  @$pb.TagNumber(9)
  void clearSchemaHash() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get trainingRunId => $_getSZ(9);
  @$pb.TagNumber(10)
  set trainingRunId($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasTrainingRunId() => $_has(9);
  @$pb.TagNumber(10)
  void clearTrainingRunId() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get commitHash => $_getSZ(10);
  @$pb.TagNumber(11)
  set commitHash($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasCommitHash() => $_has(10);
  @$pb.TagNumber(11)
  void clearCommitHash() => $_clearField(11);

  @$pb.TagNumber(12)
  $pb.PbMap<$core.String, $core.String> get metadata => $_getMap(11);
}

class GetModelVersionsRequest extends $pb.GeneratedMessage {
  factory GetModelVersionsRequest({
    $core.String? taskType,
    $core.int? limit,
    $core.String? statusFilter,
  }) {
    final $result = create();
    if (taskType != null) {
      $result.taskType = taskType;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    if (statusFilter != null) {
      $result.statusFilter = statusFilter;
    }
    return $result;
  }
  GetModelVersionsRequest._() : super();
  factory GetModelVersionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetModelVersionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetModelVersionsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskType')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'statusFilter')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetModelVersionsRequest clone() => GetModelVersionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetModelVersionsRequest copyWith(void Function(GetModelVersionsRequest) updates) => super.copyWith((message) => updates(message as GetModelVersionsRequest)) as GetModelVersionsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetModelVersionsRequest create() => GetModelVersionsRequest._();
  GetModelVersionsRequest createEmptyInstance() => create();
  static $pb.PbList<GetModelVersionsRequest> createRepeated() => $pb.PbList<GetModelVersionsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetModelVersionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetModelVersionsRequest>(create);
  static GetModelVersionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskType => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTaskType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get statusFilter => $_getSZ(2);
  @$pb.TagNumber(3)
  set statusFilter($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStatusFilter() => $_has(2);
  @$pb.TagNumber(3)
  void clearStatusFilter() => $_clearField(3);
}

class GetModelVersionsResponse extends $pb.GeneratedMessage {
  factory GetModelVersionsResponse({
    $core.Iterable<ModelVersionInfo>? versions,
  }) {
    final $result = create();
    if (versions != null) {
      $result.versions.addAll(versions);
    }
    return $result;
  }
  GetModelVersionsResponse._() : super();
  factory GetModelVersionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetModelVersionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetModelVersionsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..pc<ModelVersionInfo>(1, _omitFieldNames ? '' : 'versions', $pb.PbFieldType.PM, subBuilder: ModelVersionInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetModelVersionsResponse clone() => GetModelVersionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetModelVersionsResponse copyWith(void Function(GetModelVersionsResponse) updates) => super.copyWith((message) => updates(message as GetModelVersionsResponse)) as GetModelVersionsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetModelVersionsResponse create() => GetModelVersionsResponse._();
  GetModelVersionsResponse createEmptyInstance() => create();
  static $pb.PbList<GetModelVersionsResponse> createRepeated() => $pb.PbList<GetModelVersionsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetModelVersionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetModelVersionsResponse>(create);
  static GetModelVersionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ModelVersionInfo> get versions => $_getList(0);
}

class DeploymentPolicy extends $pb.GeneratedMessage {
  factory DeploymentPolicy({
    $core.double? minImprovementPercent,
    $core.bool? requireManualApproval,
    $core.double? canaryTrafficPercent,
    $core.int? rollbackThresholdMinutes,
    $core.Iterable<$core.String>? alertThresholds,
  }) {
    final $result = create();
    if (minImprovementPercent != null) {
      $result.minImprovementPercent = minImprovementPercent;
    }
    if (requireManualApproval != null) {
      $result.requireManualApproval = requireManualApproval;
    }
    if (canaryTrafficPercent != null) {
      $result.canaryTrafficPercent = canaryTrafficPercent;
    }
    if (rollbackThresholdMinutes != null) {
      $result.rollbackThresholdMinutes = rollbackThresholdMinutes;
    }
    if (alertThresholds != null) {
      $result.alertThresholds.addAll(alertThresholds);
    }
    return $result;
  }
  DeploymentPolicy._() : super();
  factory DeploymentPolicy.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeploymentPolicy.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeploymentPolicy', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'minImprovementPercent', $pb.PbFieldType.OD)
    ..aOB(2, _omitFieldNames ? '' : 'requireManualApproval')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'canaryTrafficPercent', $pb.PbFieldType.OD)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'rollbackThresholdMinutes', $pb.PbFieldType.O3)
    ..pPS(5, _omitFieldNames ? '' : 'alertThresholds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeploymentPolicy clone() => DeploymentPolicy()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeploymentPolicy copyWith(void Function(DeploymentPolicy) updates) => super.copyWith((message) => updates(message as DeploymentPolicy)) as DeploymentPolicy;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeploymentPolicy create() => DeploymentPolicy._();
  DeploymentPolicy createEmptyInstance() => create();
  static $pb.PbList<DeploymentPolicy> createRepeated() => $pb.PbList<DeploymentPolicy>();
  @$core.pragma('dart2js:noInline')
  static DeploymentPolicy getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeploymentPolicy>(create);
  static DeploymentPolicy? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get minImprovementPercent => $_getN(0);
  @$pb.TagNumber(1)
  set minImprovementPercent($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMinImprovementPercent() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinImprovementPercent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get requireManualApproval => $_getBF(1);
  @$pb.TagNumber(2)
  set requireManualApproval($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRequireManualApproval() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequireManualApproval() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get canaryTrafficPercent => $_getN(2);
  @$pb.TagNumber(3)
  set canaryTrafficPercent($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCanaryTrafficPercent() => $_has(2);
  @$pb.TagNumber(3)
  void clearCanaryTrafficPercent() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get rollbackThresholdMinutes => $_getIZ(3);
  @$pb.TagNumber(4)
  set rollbackThresholdMinutes($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasRollbackThresholdMinutes() => $_has(3);
  @$pb.TagNumber(4)
  void clearRollbackThresholdMinutes() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get alertThresholds => $_getList(4);
}

class DeployModelVersionRequest extends $pb.GeneratedMessage {
  factory DeployModelVersionRequest({
    $core.String? modelVersionId,
    DeploymentPolicy? policy,
    $core.String? deployedBy,
    $core.String? approvalId,
    $core.String? notes,
  }) {
    final $result = create();
    if (modelVersionId != null) {
      $result.modelVersionId = modelVersionId;
    }
    if (policy != null) {
      $result.policy = policy;
    }
    if (deployedBy != null) {
      $result.deployedBy = deployedBy;
    }
    if (approvalId != null) {
      $result.approvalId = approvalId;
    }
    if (notes != null) {
      $result.notes = notes;
    }
    return $result;
  }
  DeployModelVersionRequest._() : super();
  factory DeployModelVersionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeployModelVersionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeployModelVersionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'modelVersionId')
    ..aOM<DeploymentPolicy>(2, _omitFieldNames ? '' : 'policy', subBuilder: DeploymentPolicy.create)
    ..aOS(3, _omitFieldNames ? '' : 'deployedBy')
    ..aOS(4, _omitFieldNames ? '' : 'approvalId')
    ..aOS(5, _omitFieldNames ? '' : 'notes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeployModelVersionRequest clone() => DeployModelVersionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeployModelVersionRequest copyWith(void Function(DeployModelVersionRequest) updates) => super.copyWith((message) => updates(message as DeployModelVersionRequest)) as DeployModelVersionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeployModelVersionRequest create() => DeployModelVersionRequest._();
  DeployModelVersionRequest createEmptyInstance() => create();
  static $pb.PbList<DeployModelVersionRequest> createRepeated() => $pb.PbList<DeployModelVersionRequest>();
  @$core.pragma('dart2js:noInline')
  static DeployModelVersionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeployModelVersionRequest>(create);
  static DeployModelVersionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get modelVersionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set modelVersionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasModelVersionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearModelVersionId() => $_clearField(1);

  @$pb.TagNumber(2)
  DeploymentPolicy get policy => $_getN(1);
  @$pb.TagNumber(2)
  set policy(DeploymentPolicy v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPolicy() => $_has(1);
  @$pb.TagNumber(2)
  void clearPolicy() => $_clearField(2);
  @$pb.TagNumber(2)
  DeploymentPolicy ensurePolicy() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get deployedBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set deployedBy($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDeployedBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeployedBy() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get approvalId => $_getSZ(3);
  @$pb.TagNumber(4)
  set approvalId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasApprovalId() => $_has(3);
  @$pb.TagNumber(4)
  void clearApprovalId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get notes => $_getSZ(4);
  @$pb.TagNumber(5)
  set notes($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasNotes() => $_has(4);
  @$pb.TagNumber(5)
  void clearNotes() => $_clearField(5);
}

class DeployModelVersionResponse extends $pb.GeneratedMessage {
  factory DeployModelVersionResponse({
    $core.String? deploymentId,
    $core.String? status,
    $fixnum.Int64? deployedAtMs,
    $core.String? message,
  }) {
    final $result = create();
    if (deploymentId != null) {
      $result.deploymentId = deploymentId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (deployedAtMs != null) {
      $result.deployedAtMs = deployedAtMs;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  DeployModelVersionResponse._() : super();
  factory DeployModelVersionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeployModelVersionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeployModelVersionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deploymentId')
    ..aOS(2, _omitFieldNames ? '' : 'status')
    ..aInt64(3, _omitFieldNames ? '' : 'deployedAtMs')
    ..aOS(4, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeployModelVersionResponse clone() => DeployModelVersionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeployModelVersionResponse copyWith(void Function(DeployModelVersionResponse) updates) => super.copyWith((message) => updates(message as DeployModelVersionResponse)) as DeployModelVersionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeployModelVersionResponse create() => DeployModelVersionResponse._();
  DeployModelVersionResponse createEmptyInstance() => create();
  static $pb.PbList<DeployModelVersionResponse> createRepeated() => $pb.PbList<DeployModelVersionResponse>();
  @$core.pragma('dart2js:noInline')
  static DeployModelVersionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeployModelVersionResponse>(create);
  static DeployModelVersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deploymentId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deploymentId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeploymentId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeploymentId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get status => $_getSZ(1);
  @$pb.TagNumber(2)
  set status($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get deployedAtMs => $_getI64(2);
  @$pb.TagNumber(3)
  set deployedAtMs($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDeployedAtMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeployedAtMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get message => $_getSZ(3);
  @$pb.TagNumber(4)
  set message($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearMessage() => $_clearField(4);
}

class GetActiveModelVersionRequest extends $pb.GeneratedMessage {
  factory GetActiveModelVersionRequest({
    $core.String? taskType,
  }) {
    final $result = create();
    if (taskType != null) {
      $result.taskType = taskType;
    }
    return $result;
  }
  GetActiveModelVersionRequest._() : super();
  factory GetActiveModelVersionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetActiveModelVersionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetActiveModelVersionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskType')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetActiveModelVersionRequest clone() => GetActiveModelVersionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetActiveModelVersionRequest copyWith(void Function(GetActiveModelVersionRequest) updates) => super.copyWith((message) => updates(message as GetActiveModelVersionRequest)) as GetActiveModelVersionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetActiveModelVersionRequest create() => GetActiveModelVersionRequest._();
  GetActiveModelVersionRequest createEmptyInstance() => create();
  static $pb.PbList<GetActiveModelVersionRequest> createRepeated() => $pb.PbList<GetActiveModelVersionRequest>();
  @$core.pragma('dart2js:noInline')
  static GetActiveModelVersionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetActiveModelVersionRequest>(create);
  static GetActiveModelVersionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskType => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTaskType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskType() => $_clearField(1);
}

class GetActiveModelVersionResponse extends $pb.GeneratedMessage {
  factory GetActiveModelVersionResponse({
    ModelVersionInfo? activeVersion,
    ModelVersionInfo? previousVersion,
  }) {
    final $result = create();
    if (activeVersion != null) {
      $result.activeVersion = activeVersion;
    }
    if (previousVersion != null) {
      $result.previousVersion = previousVersion;
    }
    return $result;
  }
  GetActiveModelVersionResponse._() : super();
  factory GetActiveModelVersionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetActiveModelVersionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetActiveModelVersionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOM<ModelVersionInfo>(1, _omitFieldNames ? '' : 'activeVersion', subBuilder: ModelVersionInfo.create)
    ..aOM<ModelVersionInfo>(2, _omitFieldNames ? '' : 'previousVersion', subBuilder: ModelVersionInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetActiveModelVersionResponse clone() => GetActiveModelVersionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetActiveModelVersionResponse copyWith(void Function(GetActiveModelVersionResponse) updates) => super.copyWith((message) => updates(message as GetActiveModelVersionResponse)) as GetActiveModelVersionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetActiveModelVersionResponse create() => GetActiveModelVersionResponse._();
  GetActiveModelVersionResponse createEmptyInstance() => create();
  static $pb.PbList<GetActiveModelVersionResponse> createRepeated() => $pb.PbList<GetActiveModelVersionResponse>();
  @$core.pragma('dart2js:noInline')
  static GetActiveModelVersionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetActiveModelVersionResponse>(create);
  static GetActiveModelVersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  ModelVersionInfo get activeVersion => $_getN(0);
  @$pb.TagNumber(1)
  set activeVersion(ModelVersionInfo v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasActiveVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearActiveVersion() => $_clearField(1);
  @$pb.TagNumber(1)
  ModelVersionInfo ensureActiveVersion() => $_ensure(0);

  @$pb.TagNumber(2)
  ModelVersionInfo get previousVersion => $_getN(1);
  @$pb.TagNumber(2)
  set previousVersion(ModelVersionInfo v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPreviousVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreviousVersion() => $_clearField(2);
  @$pb.TagNumber(2)
  ModelVersionInfo ensurePreviousVersion() => $_ensure(1);
}

class RollbackModelVersionRequest extends $pb.GeneratedMessage {
  factory RollbackModelVersionRequest({
    $core.String? taskType,
    $core.String? reason,
    $core.String? rolledBackBy,
  }) {
    final $result = create();
    if (taskType != null) {
      $result.taskType = taskType;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    if (rolledBackBy != null) {
      $result.rolledBackBy = rolledBackBy;
    }
    return $result;
  }
  RollbackModelVersionRequest._() : super();
  factory RollbackModelVersionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RollbackModelVersionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RollbackModelVersionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'taskType')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..aOS(3, _omitFieldNames ? '' : 'rolledBackBy')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RollbackModelVersionRequest clone() => RollbackModelVersionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RollbackModelVersionRequest copyWith(void Function(RollbackModelVersionRequest) updates) => super.copyWith((message) => updates(message as RollbackModelVersionRequest)) as RollbackModelVersionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RollbackModelVersionRequest create() => RollbackModelVersionRequest._();
  RollbackModelVersionRequest createEmptyInstance() => create();
  static $pb.PbList<RollbackModelVersionRequest> createRepeated() => $pb.PbList<RollbackModelVersionRequest>();
  @$core.pragma('dart2js:noInline')
  static RollbackModelVersionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RollbackModelVersionRequest>(create);
  static RollbackModelVersionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get taskType => $_getSZ(0);
  @$pb.TagNumber(1)
  set taskType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTaskType() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get rolledBackBy => $_getSZ(2);
  @$pb.TagNumber(3)
  set rolledBackBy($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRolledBackBy() => $_has(2);
  @$pb.TagNumber(3)
  void clearRolledBackBy() => $_clearField(3);
}

class RollbackModelVersionResponse extends $pb.GeneratedMessage {
  factory RollbackModelVersionResponse({
    $core.String? activeVersionId,
    $fixnum.Int64? rolledBackAtMs,
    $core.String? message,
  }) {
    final $result = create();
    if (activeVersionId != null) {
      $result.activeVersionId = activeVersionId;
    }
    if (rolledBackAtMs != null) {
      $result.rolledBackAtMs = rolledBackAtMs;
    }
    if (message != null) {
      $result.message = message;
    }
    return $result;
  }
  RollbackModelVersionResponse._() : super();
  factory RollbackModelVersionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RollbackModelVersionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RollbackModelVersionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'ml_inference.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'activeVersionId')
    ..aInt64(2, _omitFieldNames ? '' : 'rolledBackAtMs')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RollbackModelVersionResponse clone() => RollbackModelVersionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RollbackModelVersionResponse copyWith(void Function(RollbackModelVersionResponse) updates) => super.copyWith((message) => updates(message as RollbackModelVersionResponse)) as RollbackModelVersionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RollbackModelVersionResponse create() => RollbackModelVersionResponse._();
  RollbackModelVersionResponse createEmptyInstance() => create();
  static $pb.PbList<RollbackModelVersionResponse> createRepeated() => $pb.PbList<RollbackModelVersionResponse>();
  @$core.pragma('dart2js:noInline')
  static RollbackModelVersionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RollbackModelVersionResponse>(create);
  static RollbackModelVersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get activeVersionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set activeVersionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasActiveVersionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearActiveVersionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get rolledBackAtMs => $_getI64(1);
  @$pb.TagNumber(2)
  set rolledBackAtMs($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRolledBackAtMs() => $_has(1);
  @$pb.TagNumber(2)
  void clearRolledBackAtMs() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);
}

class MLInferenceServiceApi {
  $pb.RpcClient _client;
  MLInferenceServiceApi(this._client);

  /// Inference RPCs
  $async.Future<YieldPredictionResponse> predictYield($pb.ClientContext? ctx, YieldPredictionRequest request) =>
    _client.invoke<YieldPredictionResponse>(ctx, 'MLInferenceService', 'PredictYield', request, YieldPredictionResponse())
  ;
  $async.Future<AnomalyDetectionResponse> detectAnomaly($pb.ClientContext? ctx, AnomalyDetectionRequest request) =>
    _client.invoke<AnomalyDetectionResponse>(ctx, 'MLInferenceService', 'DetectAnomaly', request, AnomalyDetectionResponse())
  ;
  $async.Future<DegradationResponse> forecastDegradation($pb.ClientContext? ctx, DegradationRequest request) =>
    _client.invoke<DegradationResponse>(ctx, 'MLInferenceService', 'ForecastDegradation', request, DegradationResponse())
  ;
  $async.Future<FeatureExtractionResponse> extractFeatures($pb.ClientContext? ctx, FeatureExtractionRequest request) =>
    _client.invoke<FeatureExtractionResponse>(ctx, 'MLInferenceService', 'ExtractFeatures', request, FeatureExtractionResponse())
  ;
  /// Training & Management RPCs
  $async.Future<SubmitFeedbackResponse> submitFeedback($pb.ClientContext? ctx, SubmitFeedbackRequest request) =>
    _client.invoke<SubmitFeedbackResponse>(ctx, 'MLInferenceService', 'SubmitFeedback', request, SubmitFeedbackResponse())
  ;
  $async.Future<StartTrainingResponse> startTraining($pb.ClientContext? ctx, StartTrainingRequest request) =>
    _client.invoke<StartTrainingResponse>(ctx, 'MLInferenceService', 'StartTraining', request, StartTrainingResponse())
  ;
  $async.Future<GetTrainingStatusResponse> getTrainingStatus($pb.ClientContext? ctx, GetTrainingStatusRequest request) =>
    _client.invoke<GetTrainingStatusResponse>(ctx, 'MLInferenceService', 'GetTrainingStatus', request, GetTrainingStatusResponse())
  ;
  $async.Future<EvaluateModelResponse> evaluateModel($pb.ClientContext? ctx, EvaluateModelRequest request) =>
    _client.invoke<EvaluateModelResponse>(ctx, 'MLInferenceService', 'EvaluateModel', request, EvaluateModelResponse())
  ;
  $async.Future<GetModelVersionsResponse> getModelVersions($pb.ClientContext? ctx, GetModelVersionsRequest request) =>
    _client.invoke<GetModelVersionsResponse>(ctx, 'MLInferenceService', 'GetModelVersions', request, GetModelVersionsResponse())
  ;
  $async.Future<DeployModelVersionResponse> deployModelVersion($pb.ClientContext? ctx, DeployModelVersionRequest request) =>
    _client.invoke<DeployModelVersionResponse>(ctx, 'MLInferenceService', 'DeployModelVersion', request, DeployModelVersionResponse())
  ;
  $async.Future<GetActiveModelVersionResponse> getActiveModelVersion($pb.ClientContext? ctx, GetActiveModelVersionRequest request) =>
    _client.invoke<GetActiveModelVersionResponse>(ctx, 'MLInferenceService', 'GetActiveModelVersion', request, GetActiveModelVersionResponse())
  ;
  $async.Future<RollbackModelVersionResponse> rollbackModelVersion($pb.ClientContext? ctx, RollbackModelVersionRequest request) =>
    _client.invoke<RollbackModelVersionResponse>(ctx, 'MLInferenceService', 'RollbackModelVersion', request, RollbackModelVersionResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
