//
//  Generated code. Do not modify.
//  source: extended/v1/extended.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class SolarTranspositionRequest extends $pb.GeneratedMessage {
  factory SolarTranspositionRequest({
    $core.double? ghiWm2,
    $core.double? dhiWm2,
    $core.double? windSpeedMs,
    $core.double? temperatureC,
    $core.double? surfaceTiltDeg,
    $core.double? surfaceAzimuth,
    $core.double? solarAltitude,
    $core.double? solarAzimuth,
  }) {
    final $result = create();
    if (ghiWm2 != null) {
      $result.ghiWm2 = ghiWm2;
    }
    if (dhiWm2 != null) {
      $result.dhiWm2 = dhiWm2;
    }
    if (windSpeedMs != null) {
      $result.windSpeedMs = windSpeedMs;
    }
    if (temperatureC != null) {
      $result.temperatureC = temperatureC;
    }
    if (surfaceTiltDeg != null) {
      $result.surfaceTiltDeg = surfaceTiltDeg;
    }
    if (surfaceAzimuth != null) {
      $result.surfaceAzimuth = surfaceAzimuth;
    }
    if (solarAltitude != null) {
      $result.solarAltitude = solarAltitude;
    }
    if (solarAzimuth != null) {
      $result.solarAzimuth = solarAzimuth;
    }
    return $result;
  }
  SolarTranspositionRequest._() : super();
  factory SolarTranspositionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SolarTranspositionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SolarTranspositionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'ghiWm2', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'dhiWm2', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'windSpeedMs', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'temperatureC', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'surfaceTiltDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'surfaceAzimuth', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'solarAltitude', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'solarAzimuth', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SolarTranspositionRequest clone() => SolarTranspositionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SolarTranspositionRequest copyWith(void Function(SolarTranspositionRequest) updates) => super.copyWith((message) => updates(message as SolarTranspositionRequest)) as SolarTranspositionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SolarTranspositionRequest create() => SolarTranspositionRequest._();
  SolarTranspositionRequest createEmptyInstance() => create();
  static $pb.PbList<SolarTranspositionRequest> createRepeated() => $pb.PbList<SolarTranspositionRequest>();
  @$core.pragma('dart2js:noInline')
  static SolarTranspositionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SolarTranspositionRequest>(create);
  static SolarTranspositionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get ghiWm2 => $_getN(0);
  @$pb.TagNumber(1)
  set ghiWm2($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGhiWm2() => $_has(0);
  @$pb.TagNumber(1)
  void clearGhiWm2() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get dhiWm2 => $_getN(1);
  @$pb.TagNumber(2)
  set dhiWm2($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDhiWm2() => $_has(1);
  @$pb.TagNumber(2)
  void clearDhiWm2() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get windSpeedMs => $_getN(2);
  @$pb.TagNumber(3)
  set windSpeedMs($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWindSpeedMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearWindSpeedMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get temperatureC => $_getN(3);
  @$pb.TagNumber(4)
  set temperatureC($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTemperatureC() => $_has(3);
  @$pb.TagNumber(4)
  void clearTemperatureC() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get surfaceTiltDeg => $_getN(4);
  @$pb.TagNumber(5)
  set surfaceTiltDeg($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSurfaceTiltDeg() => $_has(4);
  @$pb.TagNumber(5)
  void clearSurfaceTiltDeg() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get surfaceAzimuth => $_getN(5);
  @$pb.TagNumber(6)
  set surfaceAzimuth($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSurfaceAzimuth() => $_has(5);
  @$pb.TagNumber(6)
  void clearSurfaceAzimuth() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get solarAltitude => $_getN(6);
  @$pb.TagNumber(7)
  set solarAltitude($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasSolarAltitude() => $_has(6);
  @$pb.TagNumber(7)
  void clearSolarAltitude() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get solarAzimuth => $_getN(7);
  @$pb.TagNumber(8)
  set solarAzimuth($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSolarAzimuth() => $_has(7);
  @$pb.TagNumber(8)
  void clearSolarAzimuth() => $_clearField(8);
}

class SolarTranspositionResponse extends $pb.GeneratedMessage {
  factory SolarTranspositionResponse({
    $core.double? poaIrradiance,
    $core.double? aoi,
    $core.double? incidenceModulation,
  }) {
    final $result = create();
    if (poaIrradiance != null) {
      $result.poaIrradiance = poaIrradiance;
    }
    if (aoi != null) {
      $result.aoi = aoi;
    }
    if (incidenceModulation != null) {
      $result.incidenceModulation = incidenceModulation;
    }
    return $result;
  }
  SolarTranspositionResponse._() : super();
  factory SolarTranspositionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SolarTranspositionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SolarTranspositionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'poaIrradiance', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'aoi', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'incidenceModulation', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SolarTranspositionResponse clone() => SolarTranspositionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SolarTranspositionResponse copyWith(void Function(SolarTranspositionResponse) updates) => super.copyWith((message) => updates(message as SolarTranspositionResponse)) as SolarTranspositionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SolarTranspositionResponse create() => SolarTranspositionResponse._();
  SolarTranspositionResponse createEmptyInstance() => create();
  static $pb.PbList<SolarTranspositionResponse> createRepeated() => $pb.PbList<SolarTranspositionResponse>();
  @$core.pragma('dart2js:noInline')
  static SolarTranspositionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SolarTranspositionResponse>(create);
  static SolarTranspositionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get poaIrradiance => $_getN(0);
  @$pb.TagNumber(1)
  set poaIrradiance($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPoaIrradiance() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoaIrradiance() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get aoi => $_getN(1);
  @$pb.TagNumber(2)
  set aoi($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAoi() => $_has(1);
  @$pb.TagNumber(2)
  void clearAoi() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get incidenceModulation => $_getN(2);
  @$pb.TagNumber(3)
  set incidenceModulation($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIncidenceModulation() => $_has(2);
  @$pb.TagNumber(3)
  void clearIncidenceModulation() => $_clearField(3);
}

class FinancialMetricsRequest extends $pb.GeneratedMessage {
  factory FinancialMetricsRequest({
    $core.Iterable<$core.double>? annualCashflows,
    $core.double? initialInvestment,
    $core.double? discountRate,
    $core.double? prBaseline,
    $core.double? prActual,
  }) {
    final $result = create();
    if (annualCashflows != null) {
      $result.annualCashflows.addAll(annualCashflows);
    }
    if (initialInvestment != null) {
      $result.initialInvestment = initialInvestment;
    }
    if (discountRate != null) {
      $result.discountRate = discountRate;
    }
    if (prBaseline != null) {
      $result.prBaseline = prBaseline;
    }
    if (prActual != null) {
      $result.prActual = prActual;
    }
    return $result;
  }
  FinancialMetricsRequest._() : super();
  factory FinancialMetricsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FinancialMetricsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FinancialMetricsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'annualCashflows', $pb.PbFieldType.KD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'initialInvestment', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'discountRate', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'prBaseline', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'prActual', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FinancialMetricsRequest clone() => FinancialMetricsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FinancialMetricsRequest copyWith(void Function(FinancialMetricsRequest) updates) => super.copyWith((message) => updates(message as FinancialMetricsRequest)) as FinancialMetricsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinancialMetricsRequest create() => FinancialMetricsRequest._();
  FinancialMetricsRequest createEmptyInstance() => create();
  static $pb.PbList<FinancialMetricsRequest> createRepeated() => $pb.PbList<FinancialMetricsRequest>();
  @$core.pragma('dart2js:noInline')
  static FinancialMetricsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FinancialMetricsRequest>(create);
  static FinancialMetricsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.double> get annualCashflows => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get initialInvestment => $_getN(1);
  @$pb.TagNumber(2)
  set initialInvestment($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInitialInvestment() => $_has(1);
  @$pb.TagNumber(2)
  void clearInitialInvestment() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get discountRate => $_getN(2);
  @$pb.TagNumber(3)
  set discountRate($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDiscountRate() => $_has(2);
  @$pb.TagNumber(3)
  void clearDiscountRate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get prBaseline => $_getN(3);
  @$pb.TagNumber(4)
  set prBaseline($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPrBaseline() => $_has(3);
  @$pb.TagNumber(4)
  void clearPrBaseline() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get prActual => $_getN(4);
  @$pb.TagNumber(5)
  set prActual($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrActual() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrActual() => $_clearField(5);
}

class FinancialMetricsResponse extends $pb.GeneratedMessage {
  factory FinancialMetricsResponse({
    $core.double? npvUsd,
    $core.double? irrPercent,
    $core.double? piCoeff,
    $core.double? cropPercent,
  }) {
    final $result = create();
    if (npvUsd != null) {
      $result.npvUsd = npvUsd;
    }
    if (irrPercent != null) {
      $result.irrPercent = irrPercent;
    }
    if (piCoeff != null) {
      $result.piCoeff = piCoeff;
    }
    if (cropPercent != null) {
      $result.cropPercent = cropPercent;
    }
    return $result;
  }
  FinancialMetricsResponse._() : super();
  factory FinancialMetricsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FinancialMetricsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FinancialMetricsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'npvUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'irrPercent', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'piCoeff', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'cropPercent', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FinancialMetricsResponse clone() => FinancialMetricsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FinancialMetricsResponse copyWith(void Function(FinancialMetricsResponse) updates) => super.copyWith((message) => updates(message as FinancialMetricsResponse)) as FinancialMetricsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinancialMetricsResponse create() => FinancialMetricsResponse._();
  FinancialMetricsResponse createEmptyInstance() => create();
  static $pb.PbList<FinancialMetricsResponse> createRepeated() => $pb.PbList<FinancialMetricsResponse>();
  @$core.pragma('dart2js:noInline')
  static FinancialMetricsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FinancialMetricsResponse>(create);
  static FinancialMetricsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get npvUsd => $_getN(0);
  @$pb.TagNumber(1)
  set npvUsd($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNpvUsd() => $_has(0);
  @$pb.TagNumber(1)
  void clearNpvUsd() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get irrPercent => $_getN(1);
  @$pb.TagNumber(2)
  set irrPercent($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIrrPercent() => $_has(1);
  @$pb.TagNumber(2)
  void clearIrrPercent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get piCoeff => $_getN(2);
  @$pb.TagNumber(3)
  set piCoeff($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPiCoeff() => $_has(2);
  @$pb.TagNumber(3)
  void clearPiCoeff() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get cropPercent => $_getN(3);
  @$pb.TagNumber(4)
  set cropPercent($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCropPercent() => $_has(3);
  @$pb.TagNumber(4)
  void clearCropPercent() => $_clearField(4);
}

class CompareFinancialScenariosRequest extends $pb.GeneratedMessage {
  factory CompareFinancialScenariosRequest({
    $core.double? annualYieldKwh,
    $core.double? annualOmUsd,
    $core.int? projectLifeYears,
    $core.double? baseInitialInvestment,
    $core.double? prBaseline,
    $core.Iterable<FinancialScenario>? scenarios,
  }) {
    final $result = create();
    if (annualYieldKwh != null) {
      $result.annualYieldKwh = annualYieldKwh;
    }
    if (annualOmUsd != null) {
      $result.annualOmUsd = annualOmUsd;
    }
    if (projectLifeYears != null) {
      $result.projectLifeYears = projectLifeYears;
    }
    if (baseInitialInvestment != null) {
      $result.baseInitialInvestment = baseInitialInvestment;
    }
    if (prBaseline != null) {
      $result.prBaseline = prBaseline;
    }
    if (scenarios != null) {
      $result.scenarios.addAll(scenarios);
    }
    return $result;
  }
  CompareFinancialScenariosRequest._() : super();
  factory CompareFinancialScenariosRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CompareFinancialScenariosRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CompareFinancialScenariosRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'annualYieldKwh', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'annualOmUsd', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'projectLifeYears', $pb.PbFieldType.O3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'baseInitialInvestment', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'prBaseline', $pb.PbFieldType.OD)
    ..pc<FinancialScenario>(6, _omitFieldNames ? '' : 'scenarios', $pb.PbFieldType.PM, subBuilder: FinancialScenario.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CompareFinancialScenariosRequest clone() => CompareFinancialScenariosRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CompareFinancialScenariosRequest copyWith(void Function(CompareFinancialScenariosRequest) updates) => super.copyWith((message) => updates(message as CompareFinancialScenariosRequest)) as CompareFinancialScenariosRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompareFinancialScenariosRequest create() => CompareFinancialScenariosRequest._();
  CompareFinancialScenariosRequest createEmptyInstance() => create();
  static $pb.PbList<CompareFinancialScenariosRequest> createRepeated() => $pb.PbList<CompareFinancialScenariosRequest>();
  @$core.pragma('dart2js:noInline')
  static CompareFinancialScenariosRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CompareFinancialScenariosRequest>(create);
  static CompareFinancialScenariosRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get annualYieldKwh => $_getN(0);
  @$pb.TagNumber(1)
  set annualYieldKwh($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAnnualYieldKwh() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnnualYieldKwh() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get annualOmUsd => $_getN(1);
  @$pb.TagNumber(2)
  set annualOmUsd($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAnnualOmUsd() => $_has(1);
  @$pb.TagNumber(2)
  void clearAnnualOmUsd() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get projectLifeYears => $_getIZ(2);
  @$pb.TagNumber(3)
  set projectLifeYears($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProjectLifeYears() => $_has(2);
  @$pb.TagNumber(3)
  void clearProjectLifeYears() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get baseInitialInvestment => $_getN(3);
  @$pb.TagNumber(4)
  set baseInitialInvestment($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBaseInitialInvestment() => $_has(3);
  @$pb.TagNumber(4)
  void clearBaseInitialInvestment() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get prBaseline => $_getN(4);
  @$pb.TagNumber(5)
  set prBaseline($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrBaseline() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrBaseline() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<FinancialScenario> get scenarios => $_getList(5);
}

class FinancialScenarioResult extends $pb.GeneratedMessage {
  factory FinancialScenarioResult({
    $core.String? name,
    FinancialMetricsResponse? metrics,
    $core.double? annualRevenueUsd,
    $core.double? netAnnualCashflowUsd,
    $core.double? simplePaybackYears,
    $core.double? roiPercent,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (metrics != null) {
      $result.metrics = metrics;
    }
    if (annualRevenueUsd != null) {
      $result.annualRevenueUsd = annualRevenueUsd;
    }
    if (netAnnualCashflowUsd != null) {
      $result.netAnnualCashflowUsd = netAnnualCashflowUsd;
    }
    if (simplePaybackYears != null) {
      $result.simplePaybackYears = simplePaybackYears;
    }
    if (roiPercent != null) {
      $result.roiPercent = roiPercent;
    }
    return $result;
  }
  FinancialScenarioResult._() : super();
  factory FinancialScenarioResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FinancialScenarioResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FinancialScenarioResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOM<FinancialMetricsResponse>(2, _omitFieldNames ? '' : 'metrics', subBuilder: FinancialMetricsResponse.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'annualRevenueUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'netAnnualCashflowUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'simplePaybackYears', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'roiPercent', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FinancialScenarioResult clone() => FinancialScenarioResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FinancialScenarioResult copyWith(void Function(FinancialScenarioResult) updates) => super.copyWith((message) => updates(message as FinancialScenarioResult)) as FinancialScenarioResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinancialScenarioResult create() => FinancialScenarioResult._();
  FinancialScenarioResult createEmptyInstance() => create();
  static $pb.PbList<FinancialScenarioResult> createRepeated() => $pb.PbList<FinancialScenarioResult>();
  @$core.pragma('dart2js:noInline')
  static FinancialScenarioResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FinancialScenarioResult>(create);
  static FinancialScenarioResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  FinancialMetricsResponse get metrics => $_getN(1);
  @$pb.TagNumber(2)
  set metrics(FinancialMetricsResponse v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasMetrics() => $_has(1);
  @$pb.TagNumber(2)
  void clearMetrics() => $_clearField(2);
  @$pb.TagNumber(2)
  FinancialMetricsResponse ensureMetrics() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get annualRevenueUsd => $_getN(2);
  @$pb.TagNumber(3)
  set annualRevenueUsd($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAnnualRevenueUsd() => $_has(2);
  @$pb.TagNumber(3)
  void clearAnnualRevenueUsd() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get netAnnualCashflowUsd => $_getN(3);
  @$pb.TagNumber(4)
  set netAnnualCashflowUsd($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNetAnnualCashflowUsd() => $_has(3);
  @$pb.TagNumber(4)
  void clearNetAnnualCashflowUsd() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get simplePaybackYears => $_getN(4);
  @$pb.TagNumber(5)
  set simplePaybackYears($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSimplePaybackYears() => $_has(4);
  @$pb.TagNumber(5)
  void clearSimplePaybackYears() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get roiPercent => $_getN(5);
  @$pb.TagNumber(6)
  set roiPercent($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasRoiPercent() => $_has(5);
  @$pb.TagNumber(6)
  void clearRoiPercent() => $_clearField(6);
}

class CompareFinancialScenariosResponse extends $pb.GeneratedMessage {
  factory CompareFinancialScenariosResponse({
    $core.Iterable<FinancialScenarioResult>? scenarios,
  }) {
    final $result = create();
    if (scenarios != null) {
      $result.scenarios.addAll(scenarios);
    }
    return $result;
  }
  CompareFinancialScenariosResponse._() : super();
  factory CompareFinancialScenariosResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CompareFinancialScenariosResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CompareFinancialScenariosResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..pc<FinancialScenarioResult>(1, _omitFieldNames ? '' : 'scenarios', $pb.PbFieldType.PM, subBuilder: FinancialScenarioResult.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CompareFinancialScenariosResponse clone() => CompareFinancialScenariosResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CompareFinancialScenariosResponse copyWith(void Function(CompareFinancialScenariosResponse) updates) => super.copyWith((message) => updates(message as CompareFinancialScenariosResponse)) as CompareFinancialScenariosResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CompareFinancialScenariosResponse create() => CompareFinancialScenariosResponse._();
  CompareFinancialScenariosResponse createEmptyInstance() => create();
  static $pb.PbList<CompareFinancialScenariosResponse> createRepeated() => $pb.PbList<CompareFinancialScenariosResponse>();
  @$core.pragma('dart2js:noInline')
  static CompareFinancialScenariosResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CompareFinancialScenariosResponse>(create);
  static CompareFinancialScenariosResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FinancialScenarioResult> get scenarios => $_getList(0);
}

class ClimateImpactRequest extends $pb.GeneratedMessage {
  factory ClimateImpactRequest({
    $core.double? tempImpact,
    $core.double? soilingImpact,
    $core.double? windImpact,
    $core.double? availabilityImpact,
  }) {
    final $result = create();
    if (tempImpact != null) {
      $result.tempImpact = tempImpact;
    }
    if (soilingImpact != null) {
      $result.soilingImpact = soilingImpact;
    }
    if (windImpact != null) {
      $result.windImpact = windImpact;
    }
    if (availabilityImpact != null) {
      $result.availabilityImpact = availabilityImpact;
    }
    return $result;
  }
  ClimateImpactRequest._() : super();
  factory ClimateImpactRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClimateImpactRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClimateImpactRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'tempImpact', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'soilingImpact', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'windImpact', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'availabilityImpact', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClimateImpactRequest clone() => ClimateImpactRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClimateImpactRequest copyWith(void Function(ClimateImpactRequest) updates) => super.copyWith((message) => updates(message as ClimateImpactRequest)) as ClimateImpactRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClimateImpactRequest create() => ClimateImpactRequest._();
  ClimateImpactRequest createEmptyInstance() => create();
  static $pb.PbList<ClimateImpactRequest> createRepeated() => $pb.PbList<ClimateImpactRequest>();
  @$core.pragma('dart2js:noInline')
  static ClimateImpactRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClimateImpactRequest>(create);
  static ClimateImpactRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get tempImpact => $_getN(0);
  @$pb.TagNumber(1)
  set tempImpact($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTempImpact() => $_has(0);
  @$pb.TagNumber(1)
  void clearTempImpact() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get soilingImpact => $_getN(1);
  @$pb.TagNumber(2)
  set soilingImpact($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSoilingImpact() => $_has(1);
  @$pb.TagNumber(2)
  void clearSoilingImpact() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get windImpact => $_getN(2);
  @$pb.TagNumber(3)
  set windImpact($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasWindImpact() => $_has(2);
  @$pb.TagNumber(3)
  void clearWindImpact() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get availabilityImpact => $_getN(3);
  @$pb.TagNumber(4)
  set availabilityImpact($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAvailabilityImpact() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvailabilityImpact() => $_clearField(4);
}

class ClimateImpactResponse extends $pb.GeneratedMessage {
  factory ClimateImpactResponse({
    $core.double? soilingFactorChange,
    $core.double? efficiencyFactorChange,
    $core.double? moduleTemperatureIncrease,
    $core.double? availabilityImpactPercent,
  }) {
    final $result = create();
    if (soilingFactorChange != null) {
      $result.soilingFactorChange = soilingFactorChange;
    }
    if (efficiencyFactorChange != null) {
      $result.efficiencyFactorChange = efficiencyFactorChange;
    }
    if (moduleTemperatureIncrease != null) {
      $result.moduleTemperatureIncrease = moduleTemperatureIncrease;
    }
    if (availabilityImpactPercent != null) {
      $result.availabilityImpactPercent = availabilityImpactPercent;
    }
    return $result;
  }
  ClimateImpactResponse._() : super();
  factory ClimateImpactResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ClimateImpactResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ClimateImpactResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'soilingFactorChange', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'efficiencyFactorChange', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'moduleTemperatureIncrease', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'availabilityImpactPercent', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ClimateImpactResponse clone() => ClimateImpactResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ClimateImpactResponse copyWith(void Function(ClimateImpactResponse) updates) => super.copyWith((message) => updates(message as ClimateImpactResponse)) as ClimateImpactResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ClimateImpactResponse create() => ClimateImpactResponse._();
  ClimateImpactResponse createEmptyInstance() => create();
  static $pb.PbList<ClimateImpactResponse> createRepeated() => $pb.PbList<ClimateImpactResponse>();
  @$core.pragma('dart2js:noInline')
  static ClimateImpactResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ClimateImpactResponse>(create);
  static ClimateImpactResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get soilingFactorChange => $_getN(0);
  @$pb.TagNumber(1)
  set soilingFactorChange($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSoilingFactorChange() => $_has(0);
  @$pb.TagNumber(1)
  void clearSoilingFactorChange() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get efficiencyFactorChange => $_getN(1);
  @$pb.TagNumber(2)
  set efficiencyFactorChange($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEfficiencyFactorChange() => $_has(1);
  @$pb.TagNumber(2)
  void clearEfficiencyFactorChange() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get moduleTemperatureIncrease => $_getN(2);
  @$pb.TagNumber(3)
  set moduleTemperatureIncrease($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasModuleTemperatureIncrease() => $_has(2);
  @$pb.TagNumber(3)
  void clearModuleTemperatureIncrease() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get availabilityImpactPercent => $_getN(3);
  @$pb.TagNumber(4)
  set availabilityImpactPercent($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAvailabilityImpactPercent() => $_has(3);
  @$pb.TagNumber(4)
  void clearAvailabilityImpactPercent() => $_clearField(4);
}

class FinancialScenario extends $pb.GeneratedMessage {
  factory FinancialScenario({
    $core.String? name,
    $core.double? electricityPrice,
    $core.double? escalationRatePercent,
    $core.double? degradationRatePercent,
    $core.double? discountRatePercent,
    $core.double? prActual,
    $core.double? capexMultiplier,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (electricityPrice != null) {
      $result.electricityPrice = electricityPrice;
    }
    if (escalationRatePercent != null) {
      $result.escalationRatePercent = escalationRatePercent;
    }
    if (degradationRatePercent != null) {
      $result.degradationRatePercent = degradationRatePercent;
    }
    if (discountRatePercent != null) {
      $result.discountRatePercent = discountRatePercent;
    }
    if (prActual != null) {
      $result.prActual = prActual;
    }
    if (capexMultiplier != null) {
      $result.capexMultiplier = capexMultiplier;
    }
    return $result;
  }
  FinancialScenario._() : super();
  factory FinancialScenario.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FinancialScenario.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FinancialScenario', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'electricityPrice', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'escalationRatePercent', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'degradationRatePercent', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'discountRatePercent', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'prActual', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'capexMultiplier', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FinancialScenario clone() => FinancialScenario()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FinancialScenario copyWith(void Function(FinancialScenario) updates) => super.copyWith((message) => updates(message as FinancialScenario)) as FinancialScenario;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinancialScenario create() => FinancialScenario._();
  FinancialScenario createEmptyInstance() => create();
  static $pb.PbList<FinancialScenario> createRepeated() => $pb.PbList<FinancialScenario>();
  @$core.pragma('dart2js:noInline')
  static FinancialScenario getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FinancialScenario>(create);
  static FinancialScenario? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get electricityPrice => $_getN(1);
  @$pb.TagNumber(2)
  set electricityPrice($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasElectricityPrice() => $_has(1);
  @$pb.TagNumber(2)
  void clearElectricityPrice() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get escalationRatePercent => $_getN(2);
  @$pb.TagNumber(3)
  set escalationRatePercent($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEscalationRatePercent() => $_has(2);
  @$pb.TagNumber(3)
  void clearEscalationRatePercent() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get degradationRatePercent => $_getN(3);
  @$pb.TagNumber(4)
  set degradationRatePercent($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDegradationRatePercent() => $_has(3);
  @$pb.TagNumber(4)
  void clearDegradationRatePercent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get discountRatePercent => $_getN(4);
  @$pb.TagNumber(5)
  set discountRatePercent($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDiscountRatePercent() => $_has(4);
  @$pb.TagNumber(5)
  void clearDiscountRatePercent() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get prActual => $_getN(5);
  @$pb.TagNumber(6)
  set prActual($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPrActual() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrActual() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get capexMultiplier => $_getN(6);
  @$pb.TagNumber(7)
  set capexMultiplier($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCapexMultiplier() => $_has(6);
  @$pb.TagNumber(7)
  void clearCapexMultiplier() => $_clearField(7);
}

class SaveFinancialScenarioSetRequest extends $pb.GeneratedMessage {
  factory SaveFinancialScenarioSetRequest({
    $core.String? projectId,
    $core.String? layoutId,
    $core.Iterable<FinancialScenario>? scenarios,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (scenarios != null) {
      $result.scenarios.addAll(scenarios);
    }
    return $result;
  }
  SaveFinancialScenarioSetRequest._() : super();
  factory SaveFinancialScenarioSetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SaveFinancialScenarioSetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SaveFinancialScenarioSetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..pc<FinancialScenario>(3, _omitFieldNames ? '' : 'scenarios', $pb.PbFieldType.PM, subBuilder: FinancialScenario.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SaveFinancialScenarioSetRequest clone() => SaveFinancialScenarioSetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SaveFinancialScenarioSetRequest copyWith(void Function(SaveFinancialScenarioSetRequest) updates) => super.copyWith((message) => updates(message as SaveFinancialScenarioSetRequest)) as SaveFinancialScenarioSetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SaveFinancialScenarioSetRequest create() => SaveFinancialScenarioSetRequest._();
  SaveFinancialScenarioSetRequest createEmptyInstance() => create();
  static $pb.PbList<SaveFinancialScenarioSetRequest> createRepeated() => $pb.PbList<SaveFinancialScenarioSetRequest>();
  @$core.pragma('dart2js:noInline')
  static SaveFinancialScenarioSetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SaveFinancialScenarioSetRequest>(create);
  static SaveFinancialScenarioSetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get layoutId => $_getSZ(1);
  @$pb.TagNumber(2)
  set layoutId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayoutId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayoutId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<FinancialScenario> get scenarios => $_getList(2);
}

class SaveFinancialScenarioSetResponse extends $pb.GeneratedMessage {
  factory SaveFinancialScenarioSetResponse({
    $core.String? projectId,
    $core.String? layoutId,
    $core.Iterable<FinancialScenario>? scenarios,
    $core.String? updatedAtRfc3339,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (scenarios != null) {
      $result.scenarios.addAll(scenarios);
    }
    if (updatedAtRfc3339 != null) {
      $result.updatedAtRfc3339 = updatedAtRfc3339;
    }
    return $result;
  }
  SaveFinancialScenarioSetResponse._() : super();
  factory SaveFinancialScenarioSetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SaveFinancialScenarioSetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SaveFinancialScenarioSetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..pc<FinancialScenario>(3, _omitFieldNames ? '' : 'scenarios', $pb.PbFieldType.PM, subBuilder: FinancialScenario.create)
    ..aOS(4, _omitFieldNames ? '' : 'updatedAtRfc3339')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SaveFinancialScenarioSetResponse clone() => SaveFinancialScenarioSetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SaveFinancialScenarioSetResponse copyWith(void Function(SaveFinancialScenarioSetResponse) updates) => super.copyWith((message) => updates(message as SaveFinancialScenarioSetResponse)) as SaveFinancialScenarioSetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SaveFinancialScenarioSetResponse create() => SaveFinancialScenarioSetResponse._();
  SaveFinancialScenarioSetResponse createEmptyInstance() => create();
  static $pb.PbList<SaveFinancialScenarioSetResponse> createRepeated() => $pb.PbList<SaveFinancialScenarioSetResponse>();
  @$core.pragma('dart2js:noInline')
  static SaveFinancialScenarioSetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SaveFinancialScenarioSetResponse>(create);
  static SaveFinancialScenarioSetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get layoutId => $_getSZ(1);
  @$pb.TagNumber(2)
  set layoutId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayoutId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayoutId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<FinancialScenario> get scenarios => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get updatedAtRfc3339 => $_getSZ(3);
  @$pb.TagNumber(4)
  set updatedAtRfc3339($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUpdatedAtRfc3339() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdatedAtRfc3339() => $_clearField(4);
}

class GetFinancialScenarioSetRequest extends $pb.GeneratedMessage {
  factory GetFinancialScenarioSetRequest({
    $core.String? projectId,
    $core.String? layoutId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    return $result;
  }
  GetFinancialScenarioSetRequest._() : super();
  factory GetFinancialScenarioSetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFinancialScenarioSetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetFinancialScenarioSetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFinancialScenarioSetRequest clone() => GetFinancialScenarioSetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFinancialScenarioSetRequest copyWith(void Function(GetFinancialScenarioSetRequest) updates) => super.copyWith((message) => updates(message as GetFinancialScenarioSetRequest)) as GetFinancialScenarioSetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFinancialScenarioSetRequest create() => GetFinancialScenarioSetRequest._();
  GetFinancialScenarioSetRequest createEmptyInstance() => create();
  static $pb.PbList<GetFinancialScenarioSetRequest> createRepeated() => $pb.PbList<GetFinancialScenarioSetRequest>();
  @$core.pragma('dart2js:noInline')
  static GetFinancialScenarioSetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFinancialScenarioSetRequest>(create);
  static GetFinancialScenarioSetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get layoutId => $_getSZ(1);
  @$pb.TagNumber(2)
  set layoutId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayoutId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayoutId() => $_clearField(2);
}

class GetFinancialScenarioSetResponse extends $pb.GeneratedMessage {
  factory GetFinancialScenarioSetResponse({
    $core.String? projectId,
    $core.String? layoutId,
    $core.Iterable<FinancialScenario>? scenarios,
    $core.String? updatedAtRfc3339,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (scenarios != null) {
      $result.scenarios.addAll(scenarios);
    }
    if (updatedAtRfc3339 != null) {
      $result.updatedAtRfc3339 = updatedAtRfc3339;
    }
    return $result;
  }
  GetFinancialScenarioSetResponse._() : super();
  factory GetFinancialScenarioSetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFinancialScenarioSetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetFinancialScenarioSetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..pc<FinancialScenario>(3, _omitFieldNames ? '' : 'scenarios', $pb.PbFieldType.PM, subBuilder: FinancialScenario.create)
    ..aOS(4, _omitFieldNames ? '' : 'updatedAtRfc3339')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFinancialScenarioSetResponse clone() => GetFinancialScenarioSetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFinancialScenarioSetResponse copyWith(void Function(GetFinancialScenarioSetResponse) updates) => super.copyWith((message) => updates(message as GetFinancialScenarioSetResponse)) as GetFinancialScenarioSetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFinancialScenarioSetResponse create() => GetFinancialScenarioSetResponse._();
  GetFinancialScenarioSetResponse createEmptyInstance() => create();
  static $pb.PbList<GetFinancialScenarioSetResponse> createRepeated() => $pb.PbList<GetFinancialScenarioSetResponse>();
  @$core.pragma('dart2js:noInline')
  static GetFinancialScenarioSetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFinancialScenarioSetResponse>(create);
  static GetFinancialScenarioSetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get layoutId => $_getSZ(1);
  @$pb.TagNumber(2)
  set layoutId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayoutId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayoutId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<FinancialScenario> get scenarios => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get updatedAtRfc3339 => $_getSZ(3);
  @$pb.TagNumber(4)
  set updatedAtRfc3339($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUpdatedAtRfc3339() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdatedAtRfc3339() => $_clearField(4);
}

class ListFinancialScenarioSetsRequest extends $pb.GeneratedMessage {
  factory ListFinancialScenarioSetsRequest({
    $core.String? projectId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    return $result;
  }
  ListFinancialScenarioSetsRequest._() : super();
  factory ListFinancialScenarioSetsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListFinancialScenarioSetsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListFinancialScenarioSetsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListFinancialScenarioSetsRequest clone() => ListFinancialScenarioSetsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListFinancialScenarioSetsRequest copyWith(void Function(ListFinancialScenarioSetsRequest) updates) => super.copyWith((message) => updates(message as ListFinancialScenarioSetsRequest)) as ListFinancialScenarioSetsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFinancialScenarioSetsRequest create() => ListFinancialScenarioSetsRequest._();
  ListFinancialScenarioSetsRequest createEmptyInstance() => create();
  static $pb.PbList<ListFinancialScenarioSetsRequest> createRepeated() => $pb.PbList<ListFinancialScenarioSetsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListFinancialScenarioSetsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListFinancialScenarioSetsRequest>(create);
  static ListFinancialScenarioSetsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);
}

class FinancialScenarioSetSummary extends $pb.GeneratedMessage {
  factory FinancialScenarioSetSummary({
    $core.String? layoutId,
    $core.int? scenarioCount,
    $core.String? updatedAtRfc3339,
  }) {
    final $result = create();
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (scenarioCount != null) {
      $result.scenarioCount = scenarioCount;
    }
    if (updatedAtRfc3339 != null) {
      $result.updatedAtRfc3339 = updatedAtRfc3339;
    }
    return $result;
  }
  FinancialScenarioSetSummary._() : super();
  factory FinancialScenarioSetSummary.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FinancialScenarioSetSummary.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FinancialScenarioSetSummary', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'layoutId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'scenarioCount', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'updatedAtRfc3339')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FinancialScenarioSetSummary clone() => FinancialScenarioSetSummary()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FinancialScenarioSetSummary copyWith(void Function(FinancialScenarioSetSummary) updates) => super.copyWith((message) => updates(message as FinancialScenarioSetSummary)) as FinancialScenarioSetSummary;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinancialScenarioSetSummary create() => FinancialScenarioSetSummary._();
  FinancialScenarioSetSummary createEmptyInstance() => create();
  static $pb.PbList<FinancialScenarioSetSummary> createRepeated() => $pb.PbList<FinancialScenarioSetSummary>();
  @$core.pragma('dart2js:noInline')
  static FinancialScenarioSetSummary getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FinancialScenarioSetSummary>(create);
  static FinancialScenarioSetSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layoutId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayoutId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get scenarioCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set scenarioCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasScenarioCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearScenarioCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get updatedAtRfc3339 => $_getSZ(2);
  @$pb.TagNumber(3)
  set updatedAtRfc3339($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasUpdatedAtRfc3339() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdatedAtRfc3339() => $_clearField(3);
}

class ListFinancialScenarioSetsResponse extends $pb.GeneratedMessage {
  factory ListFinancialScenarioSetsResponse({
    $core.Iterable<FinancialScenarioSetSummary>? items,
  }) {
    final $result = create();
    if (items != null) {
      $result.items.addAll(items);
    }
    return $result;
  }
  ListFinancialScenarioSetsResponse._() : super();
  factory ListFinancialScenarioSetsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListFinancialScenarioSetsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListFinancialScenarioSetsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..pc<FinancialScenarioSetSummary>(1, _omitFieldNames ? '' : 'items', $pb.PbFieldType.PM, subBuilder: FinancialScenarioSetSummary.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListFinancialScenarioSetsResponse clone() => ListFinancialScenarioSetsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListFinancialScenarioSetsResponse copyWith(void Function(ListFinancialScenarioSetsResponse) updates) => super.copyWith((message) => updates(message as ListFinancialScenarioSetsResponse)) as ListFinancialScenarioSetsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFinancialScenarioSetsResponse create() => ListFinancialScenarioSetsResponse._();
  ListFinancialScenarioSetsResponse createEmptyInstance() => create();
  static $pb.PbList<ListFinancialScenarioSetsResponse> createRepeated() => $pb.PbList<ListFinancialScenarioSetsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListFinancialScenarioSetsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListFinancialScenarioSetsResponse>(create);
  static ListFinancialScenarioSetsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FinancialScenarioSetSummary> get items => $_getList(0);
}

class FinancialScenarioSetVersion extends $pb.GeneratedMessage {
  factory FinancialScenarioSetVersion({
    $core.Iterable<FinancialScenario>? scenarios,
    $core.String? savedAtRfc3339,
  }) {
    final $result = create();
    if (scenarios != null) {
      $result.scenarios.addAll(scenarios);
    }
    if (savedAtRfc3339 != null) {
      $result.savedAtRfc3339 = savedAtRfc3339;
    }
    return $result;
  }
  FinancialScenarioSetVersion._() : super();
  factory FinancialScenarioSetVersion.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FinancialScenarioSetVersion.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FinancialScenarioSetVersion', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..pc<FinancialScenario>(1, _omitFieldNames ? '' : 'scenarios', $pb.PbFieldType.PM, subBuilder: FinancialScenario.create)
    ..aOS(2, _omitFieldNames ? '' : 'savedAtRfc3339')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FinancialScenarioSetVersion clone() => FinancialScenarioSetVersion()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FinancialScenarioSetVersion copyWith(void Function(FinancialScenarioSetVersion) updates) => super.copyWith((message) => updates(message as FinancialScenarioSetVersion)) as FinancialScenarioSetVersion;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FinancialScenarioSetVersion create() => FinancialScenarioSetVersion._();
  FinancialScenarioSetVersion createEmptyInstance() => create();
  static $pb.PbList<FinancialScenarioSetVersion> createRepeated() => $pb.PbList<FinancialScenarioSetVersion>();
  @$core.pragma('dart2js:noInline')
  static FinancialScenarioSetVersion getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FinancialScenarioSetVersion>(create);
  static FinancialScenarioSetVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FinancialScenario> get scenarios => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get savedAtRfc3339 => $_getSZ(1);
  @$pb.TagNumber(2)
  set savedAtRfc3339($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSavedAtRfc3339() => $_has(1);
  @$pb.TagNumber(2)
  void clearSavedAtRfc3339() => $_clearField(2);
}

class GetFinancialScenarioSetVersionsRequest extends $pb.GeneratedMessage {
  factory GetFinancialScenarioSetVersionsRequest({
    $core.String? projectId,
    $core.String? layoutId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    return $result;
  }
  GetFinancialScenarioSetVersionsRequest._() : super();
  factory GetFinancialScenarioSetVersionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFinancialScenarioSetVersionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetFinancialScenarioSetVersionsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFinancialScenarioSetVersionsRequest clone() => GetFinancialScenarioSetVersionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFinancialScenarioSetVersionsRequest copyWith(void Function(GetFinancialScenarioSetVersionsRequest) updates) => super.copyWith((message) => updates(message as GetFinancialScenarioSetVersionsRequest)) as GetFinancialScenarioSetVersionsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFinancialScenarioSetVersionsRequest create() => GetFinancialScenarioSetVersionsRequest._();
  GetFinancialScenarioSetVersionsRequest createEmptyInstance() => create();
  static $pb.PbList<GetFinancialScenarioSetVersionsRequest> createRepeated() => $pb.PbList<GetFinancialScenarioSetVersionsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetFinancialScenarioSetVersionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFinancialScenarioSetVersionsRequest>(create);
  static GetFinancialScenarioSetVersionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get layoutId => $_getSZ(1);
  @$pb.TagNumber(2)
  set layoutId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayoutId() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayoutId() => $_clearField(2);
}

class GetFinancialScenarioSetVersionsResponse extends $pb.GeneratedMessage {
  factory GetFinancialScenarioSetVersionsResponse({
    $core.Iterable<FinancialScenarioSetVersion>? versions,
  }) {
    final $result = create();
    if (versions != null) {
      $result.versions.addAll(versions);
    }
    return $result;
  }
  GetFinancialScenarioSetVersionsResponse._() : super();
  factory GetFinancialScenarioSetVersionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFinancialScenarioSetVersionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetFinancialScenarioSetVersionsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..pc<FinancialScenarioSetVersion>(1, _omitFieldNames ? '' : 'versions', $pb.PbFieldType.PM, subBuilder: FinancialScenarioSetVersion.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFinancialScenarioSetVersionsResponse clone() => GetFinancialScenarioSetVersionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFinancialScenarioSetVersionsResponse copyWith(void Function(GetFinancialScenarioSetVersionsResponse) updates) => super.copyWith((message) => updates(message as GetFinancialScenarioSetVersionsResponse)) as GetFinancialScenarioSetVersionsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFinancialScenarioSetVersionsResponse create() => GetFinancialScenarioSetVersionsResponse._();
  GetFinancialScenarioSetVersionsResponse createEmptyInstance() => create();
  static $pb.PbList<GetFinancialScenarioSetVersionsResponse> createRepeated() => $pb.PbList<GetFinancialScenarioSetVersionsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetFinancialScenarioSetVersionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFinancialScenarioSetVersionsResponse>(create);
  static GetFinancialScenarioSetVersionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FinancialScenarioSetVersion> get versions => $_getList(0);
}

/// Inter-row shading request for fixed-tilt or single-axis tracker arrays.
class CalculateInterRowShadingRequest extends $pb.GeneratedMessage {
  factory CalculateInterRowShadingRequest({
    $core.double? tiltDeg,
    $core.double? gcr,
    $core.double? latitudeDeg,
    $core.int? analysisDays,
    $core.bool? isTracker,
  }) {
    final $result = create();
    if (tiltDeg != null) {
      $result.tiltDeg = tiltDeg;
    }
    if (gcr != null) {
      $result.gcr = gcr;
    }
    if (latitudeDeg != null) {
      $result.latitudeDeg = latitudeDeg;
    }
    if (analysisDays != null) {
      $result.analysisDays = analysisDays;
    }
    if (isTracker != null) {
      $result.isTracker = isTracker;
    }
    return $result;
  }
  CalculateInterRowShadingRequest._() : super();
  factory CalculateInterRowShadingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateInterRowShadingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateInterRowShadingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'tiltDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'gcr', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'latitudeDeg', $pb.PbFieldType.OD)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'analysisDays', $pb.PbFieldType.O3)
    ..aOB(5, _omitFieldNames ? '' : 'isTracker')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateInterRowShadingRequest clone() => CalculateInterRowShadingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateInterRowShadingRequest copyWith(void Function(CalculateInterRowShadingRequest) updates) => super.copyWith((message) => updates(message as CalculateInterRowShadingRequest)) as CalculateInterRowShadingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateInterRowShadingRequest create() => CalculateInterRowShadingRequest._();
  CalculateInterRowShadingRequest createEmptyInstance() => create();
  static $pb.PbList<CalculateInterRowShadingRequest> createRepeated() => $pb.PbList<CalculateInterRowShadingRequest>();
  @$core.pragma('dart2js:noInline')
  static CalculateInterRowShadingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateInterRowShadingRequest>(create);
  static CalculateInterRowShadingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get tiltDeg => $_getN(0);
  @$pb.TagNumber(1)
  set tiltDeg($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTiltDeg() => $_has(0);
  @$pb.TagNumber(1)
  void clearTiltDeg() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get gcr => $_getN(1);
  @$pb.TagNumber(2)
  set gcr($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGcr() => $_has(1);
  @$pb.TagNumber(2)
  void clearGcr() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get latitudeDeg => $_getN(2);
  @$pb.TagNumber(3)
  set latitudeDeg($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLatitudeDeg() => $_has(2);
  @$pb.TagNumber(3)
  void clearLatitudeDeg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get analysisDays => $_getIZ(3);
  @$pb.TagNumber(4)
  set analysisDays($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAnalysisDays() => $_has(3);
  @$pb.TagNumber(4)
  void clearAnalysisDays() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isTracker => $_getBF(4);
  @$pb.TagNumber(5)
  set isTracker($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasIsTracker() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsTracker() => $_clearField(5);
}

class CalculateInterRowShadingResponse extends $pb.GeneratedMessage {
  factory CalculateInterRowShadingResponse({
    $core.double? annualShadingLossPercent,
    $core.double? nearShadingLossPercent,
    $core.double? optimalGcr,
    $core.String? note,
  }) {
    final $result = create();
    if (annualShadingLossPercent != null) {
      $result.annualShadingLossPercent = annualShadingLossPercent;
    }
    if (nearShadingLossPercent != null) {
      $result.nearShadingLossPercent = nearShadingLossPercent;
    }
    if (optimalGcr != null) {
      $result.optimalGcr = optimalGcr;
    }
    if (note != null) {
      $result.note = note;
    }
    return $result;
  }
  CalculateInterRowShadingResponse._() : super();
  factory CalculateInterRowShadingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateInterRowShadingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateInterRowShadingResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'annualShadingLossPercent', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'nearShadingLossPercent', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'optimalGcr', $pb.PbFieldType.OD)
    ..aOS(4, _omitFieldNames ? '' : 'note')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateInterRowShadingResponse clone() => CalculateInterRowShadingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateInterRowShadingResponse copyWith(void Function(CalculateInterRowShadingResponse) updates) => super.copyWith((message) => updates(message as CalculateInterRowShadingResponse)) as CalculateInterRowShadingResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateInterRowShadingResponse create() => CalculateInterRowShadingResponse._();
  CalculateInterRowShadingResponse createEmptyInstance() => create();
  static $pb.PbList<CalculateInterRowShadingResponse> createRepeated() => $pb.PbList<CalculateInterRowShadingResponse>();
  @$core.pragma('dart2js:noInline')
  static CalculateInterRowShadingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateInterRowShadingResponse>(create);
  static CalculateInterRowShadingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get annualShadingLossPercent => $_getN(0);
  @$pb.TagNumber(1)
  set annualShadingLossPercent($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAnnualShadingLossPercent() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnnualShadingLossPercent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get nearShadingLossPercent => $_getN(1);
  @$pb.TagNumber(2)
  set nearShadingLossPercent($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNearShadingLossPercent() => $_has(1);
  @$pb.TagNumber(2)
  void clearNearShadingLossPercent() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get optimalGcr => $_getN(2);
  @$pb.TagNumber(3)
  set optimalGcr($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOptimalGcr() => $_has(2);
  @$pb.TagNumber(3)
  void clearOptimalGcr() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get note => $_getSZ(3);
  @$pb.TagNumber(4)
  set note($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasNote() => $_has(3);
  @$pb.TagNumber(4)
  void clearNote() => $_clearField(4);
}

/// Yield uncertainty request for P-value estimation.
class CalculateYieldUncertaintyRequest extends $pb.GeneratedMessage {
  factory CalculateYieldUncertaintyRequest({
    $core.double? p50AnnualKwh,
    $core.double? interannualVariabilityPct,
    $core.double? measurementUncertaintyPct,
    $core.double? modelUncertaintyPct,
    $core.double? soilingUncertaintyPct,
    $core.double? degradationUncertaintyPct,
  }) {
    final $result = create();
    if (p50AnnualKwh != null) {
      $result.p50AnnualKwh = p50AnnualKwh;
    }
    if (interannualVariabilityPct != null) {
      $result.interannualVariabilityPct = interannualVariabilityPct;
    }
    if (measurementUncertaintyPct != null) {
      $result.measurementUncertaintyPct = measurementUncertaintyPct;
    }
    if (modelUncertaintyPct != null) {
      $result.modelUncertaintyPct = modelUncertaintyPct;
    }
    if (soilingUncertaintyPct != null) {
      $result.soilingUncertaintyPct = soilingUncertaintyPct;
    }
    if (degradationUncertaintyPct != null) {
      $result.degradationUncertaintyPct = degradationUncertaintyPct;
    }
    return $result;
  }
  CalculateYieldUncertaintyRequest._() : super();
  factory CalculateYieldUncertaintyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateYieldUncertaintyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateYieldUncertaintyRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'p50AnnualKwh', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'interannualVariabilityPct', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'measurementUncertaintyPct', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'modelUncertaintyPct', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'soilingUncertaintyPct', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'degradationUncertaintyPct', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateYieldUncertaintyRequest clone() => CalculateYieldUncertaintyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateYieldUncertaintyRequest copyWith(void Function(CalculateYieldUncertaintyRequest) updates) => super.copyWith((message) => updates(message as CalculateYieldUncertaintyRequest)) as CalculateYieldUncertaintyRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateYieldUncertaintyRequest create() => CalculateYieldUncertaintyRequest._();
  CalculateYieldUncertaintyRequest createEmptyInstance() => create();
  static $pb.PbList<CalculateYieldUncertaintyRequest> createRepeated() => $pb.PbList<CalculateYieldUncertaintyRequest>();
  @$core.pragma('dart2js:noInline')
  static CalculateYieldUncertaintyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateYieldUncertaintyRequest>(create);
  static CalculateYieldUncertaintyRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get p50AnnualKwh => $_getN(0);
  @$pb.TagNumber(1)
  set p50AnnualKwh($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasP50AnnualKwh() => $_has(0);
  @$pb.TagNumber(1)
  void clearP50AnnualKwh() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get interannualVariabilityPct => $_getN(1);
  @$pb.TagNumber(2)
  set interannualVariabilityPct($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasInterannualVariabilityPct() => $_has(1);
  @$pb.TagNumber(2)
  void clearInterannualVariabilityPct() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get measurementUncertaintyPct => $_getN(2);
  @$pb.TagNumber(3)
  set measurementUncertaintyPct($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMeasurementUncertaintyPct() => $_has(2);
  @$pb.TagNumber(3)
  void clearMeasurementUncertaintyPct() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get modelUncertaintyPct => $_getN(3);
  @$pb.TagNumber(4)
  set modelUncertaintyPct($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasModelUncertaintyPct() => $_has(3);
  @$pb.TagNumber(4)
  void clearModelUncertaintyPct() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get soilingUncertaintyPct => $_getN(4);
  @$pb.TagNumber(5)
  set soilingUncertaintyPct($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSoilingUncertaintyPct() => $_has(4);
  @$pb.TagNumber(5)
  void clearSoilingUncertaintyPct() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get degradationUncertaintyPct => $_getN(5);
  @$pb.TagNumber(6)
  set degradationUncertaintyPct($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDegradationUncertaintyPct() => $_has(5);
  @$pb.TagNumber(6)
  void clearDegradationUncertaintyPct() => $_clearField(6);
}

class CalculateYieldUncertaintyResponse extends $pb.GeneratedMessage {
  factory CalculateYieldUncertaintyResponse({
    $core.double? p50Kwh,
    $core.double? p90Kwh,
    $core.double? p99Kwh,
    $core.double? combinedUncertaintyPct,
  }) {
    final $result = create();
    if (p50Kwh != null) {
      $result.p50Kwh = p50Kwh;
    }
    if (p90Kwh != null) {
      $result.p90Kwh = p90Kwh;
    }
    if (p99Kwh != null) {
      $result.p99Kwh = p99Kwh;
    }
    if (combinedUncertaintyPct != null) {
      $result.combinedUncertaintyPct = combinedUncertaintyPct;
    }
    return $result;
  }
  CalculateYieldUncertaintyResponse._() : super();
  factory CalculateYieldUncertaintyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateYieldUncertaintyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateYieldUncertaintyResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'extended.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'p50Kwh', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'p90Kwh', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'p99Kwh', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'combinedUncertaintyPct', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateYieldUncertaintyResponse clone() => CalculateYieldUncertaintyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateYieldUncertaintyResponse copyWith(void Function(CalculateYieldUncertaintyResponse) updates) => super.copyWith((message) => updates(message as CalculateYieldUncertaintyResponse)) as CalculateYieldUncertaintyResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateYieldUncertaintyResponse create() => CalculateYieldUncertaintyResponse._();
  CalculateYieldUncertaintyResponse createEmptyInstance() => create();
  static $pb.PbList<CalculateYieldUncertaintyResponse> createRepeated() => $pb.PbList<CalculateYieldUncertaintyResponse>();
  @$core.pragma('dart2js:noInline')
  static CalculateYieldUncertaintyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateYieldUncertaintyResponse>(create);
  static CalculateYieldUncertaintyResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get p50Kwh => $_getN(0);
  @$pb.TagNumber(1)
  set p50Kwh($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasP50Kwh() => $_has(0);
  @$pb.TagNumber(1)
  void clearP50Kwh() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get p90Kwh => $_getN(1);
  @$pb.TagNumber(2)
  set p90Kwh($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasP90Kwh() => $_has(1);
  @$pb.TagNumber(2)
  void clearP90Kwh() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get p99Kwh => $_getN(2);
  @$pb.TagNumber(3)
  set p99Kwh($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasP99Kwh() => $_has(2);
  @$pb.TagNumber(3)
  void clearP99Kwh() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get combinedUncertaintyPct => $_getN(3);
  @$pb.TagNumber(4)
  set combinedUncertaintyPct($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCombinedUncertaintyPct() => $_has(3);
  @$pb.TagNumber(4)
  void clearCombinedUncertaintyPct() => $_clearField(4);
}

/// ExtendedService exposes advanced compute modules built on extended-compute.
class ExtendedServiceApi {
  $pb.RpcClient _client;
  ExtendedServiceApi(this._client);

  /// SolarTransposition computes plane-of-array irradiance and incidence terms.
  $async.Future<SolarTranspositionResponse> solarTransposition($pb.ClientContext? ctx, SolarTranspositionRequest request) =>
    _client.invoke<SolarTranspositionResponse>(ctx, 'ExtendedService', 'SolarTransposition', request, SolarTranspositionResponse())
  ;
  /// FinancialMetrics computes investment performance indicators for a project.
  $async.Future<FinancialMetricsResponse> financialMetrics($pb.ClientContext? ctx, FinancialMetricsRequest request) =>
    _client.invoke<FinancialMetricsResponse>(ctx, 'ExtendedService', 'FinancialMetrics', request, FinancialMetricsResponse())
  ;
  /// CompareFinancialScenarios evaluates a full scenario set against engineering and finance assumptions.
  $async.Future<CompareFinancialScenariosResponse> compareFinancialScenarios($pb.ClientContext? ctx, CompareFinancialScenariosRequest request) =>
    _client.invoke<CompareFinancialScenariosResponse>(ctx, 'ExtendedService', 'CompareFinancialScenarios', request, CompareFinancialScenariosResponse())
  ;
  /// ClimateImpact aggregates climate uncertainty factors into a unified impact view.
  $async.Future<ClimateImpactResponse> climateImpact($pb.ClientContext? ctx, ClimateImpactRequest request) =>
    _client.invoke<ClimateImpactResponse>(ctx, 'ExtendedService', 'ClimateImpact', request, ClimateImpactResponse())
  ;
  /// SaveFinancialScenarioSet stores scenario assumptions for a specific project/layout.
  $async.Future<SaveFinancialScenarioSetResponse> saveFinancialScenarioSet($pb.ClientContext? ctx, SaveFinancialScenarioSetRequest request) =>
    _client.invoke<SaveFinancialScenarioSetResponse>(ctx, 'ExtendedService', 'SaveFinancialScenarioSet', request, SaveFinancialScenarioSetResponse())
  ;
  /// GetFinancialScenarioSet retrieves saved scenario assumptions for a specific project/layout.
  $async.Future<GetFinancialScenarioSetResponse> getFinancialScenarioSet($pb.ClientContext? ctx, GetFinancialScenarioSetRequest request) =>
    _client.invoke<GetFinancialScenarioSetResponse>(ctx, 'ExtendedService', 'GetFinancialScenarioSet', request, GetFinancialScenarioSetResponse())
  ;
  /// ListFinancialScenarioSets lists all saved scenario sets for a project.
  $async.Future<ListFinancialScenarioSetsResponse> listFinancialScenarioSets($pb.ClientContext? ctx, ListFinancialScenarioSetsRequest request) =>
    _client.invoke<ListFinancialScenarioSetsResponse>(ctx, 'ExtendedService', 'ListFinancialScenarioSets', request, ListFinancialScenarioSetsResponse())
  ;
  /// GetFinancialScenarioSetVersions returns the version history of scenario assumptions for a layout.
  $async.Future<GetFinancialScenarioSetVersionsResponse> getFinancialScenarioSetVersions($pb.ClientContext? ctx, GetFinancialScenarioSetVersionsRequest request) =>
    _client.invoke<GetFinancialScenarioSetVersionsResponse>(ctx, 'ExtendedService', 'GetFinancialScenarioSetVersions', request, GetFinancialScenarioSetVersionsResponse())
  ;
  /// CalculateInterRowShading computes inter-row shading loss for a fixed-tilt or single-axis tracker array.
  $async.Future<CalculateInterRowShadingResponse> calculateInterRowShading($pb.ClientContext? ctx, CalculateInterRowShadingRequest request) =>
    _client.invoke<CalculateInterRowShadingResponse>(ctx, 'ExtendedService', 'CalculateInterRowShading', request, CalculateInterRowShadingResponse())
  ;
  /// CalculateYieldUncertainty estimates P50/P90/P99 annual yield from a base energy estimate and uncertainty inputs.
  $async.Future<CalculateYieldUncertaintyResponse> calculateYieldUncertainty($pb.ClientContext? ctx, CalculateYieldUncertaintyRequest request) =>
    _client.invoke<CalculateYieldUncertaintyResponse>(ctx, 'ExtendedService', 'CalculateYieldUncertainty', request, CalculateYieldUncertaintyResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
