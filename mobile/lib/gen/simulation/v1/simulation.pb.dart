//
//  Generated code. Do not modify.
//  source: simulation/v1/simulation.proto
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
import 'simulation.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'simulation.pbenum.dart';

class Simulation extends $pb.GeneratedMessage {
  factory Simulation({
    $core.String? id,
    $core.String? projectId,
    $core.String? layoutId,
    $core.String? name,
    SimulationType? simulationType,
    SimulationStatus? status,
    SimulationParams? params,
    SimulationResult? result,
    $0.Timestamp? createdAt,
    $0.Timestamp? completedAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (simulationType != null) {
      $result.simulationType = simulationType;
    }
    if (status != null) {
      $result.status = status;
    }
    if (params != null) {
      $result.params = params;
    }
    if (result != null) {
      $result.result = result;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (completedAt != null) {
      $result.completedAt = completedAt;
    }
    return $result;
  }
  Simulation._() : super();
  factory Simulation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Simulation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Simulation', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'layoutId')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..e<SimulationType>(5, _omitFieldNames ? '' : 'simulationType', $pb.PbFieldType.OE, defaultOrMaker: SimulationType.SIMULATION_TYPE_UNSPECIFIED, valueOf: SimulationType.valueOf, enumValues: SimulationType.values)
    ..e<SimulationStatus>(6, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: SimulationStatus.SIMULATION_STATUS_UNSPECIFIED, valueOf: SimulationStatus.valueOf, enumValues: SimulationStatus.values)
    ..aOM<SimulationParams>(7, _omitFieldNames ? '' : 'params', subBuilder: SimulationParams.create)
    ..aOM<SimulationResult>(8, _omitFieldNames ? '' : 'result', subBuilder: SimulationResult.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'completedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Simulation clone() => Simulation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Simulation copyWith(void Function(Simulation) updates) => super.copyWith((message) => updates(message as Simulation)) as Simulation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Simulation create() => Simulation._();
  Simulation createEmptyInstance() => create();
  static $pb.PbList<Simulation> createRepeated() => $pb.PbList<Simulation>();
  @$core.pragma('dart2js:noInline')
  static Simulation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Simulation>(create);
  static Simulation? _defaultInstance;

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
  $core.String get layoutId => $_getSZ(2);
  @$pb.TagNumber(3)
  set layoutId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLayoutId() => $_has(2);
  @$pb.TagNumber(3)
  void clearLayoutId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  SimulationType get simulationType => $_getN(4);
  @$pb.TagNumber(5)
  set simulationType(SimulationType v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasSimulationType() => $_has(4);
  @$pb.TagNumber(5)
  void clearSimulationType() => $_clearField(5);

  @$pb.TagNumber(6)
  SimulationStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(SimulationStatus v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  SimulationParams get params => $_getN(6);
  @$pb.TagNumber(7)
  set params(SimulationParams v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasParams() => $_has(6);
  @$pb.TagNumber(7)
  void clearParams() => $_clearField(7);
  @$pb.TagNumber(7)
  SimulationParams ensureParams() => $_ensure(6);

  @$pb.TagNumber(8)
  SimulationResult get result => $_getN(7);
  @$pb.TagNumber(8)
  set result(SimulationResult v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasResult() => $_has(7);
  @$pb.TagNumber(8)
  void clearResult() => $_clearField(8);
  @$pb.TagNumber(8)
  SimulationResult ensureResult() => $_ensure(7);

  @$pb.TagNumber(9)
  $0.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($0.Timestamp v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $0.Timestamp ensureCreatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $0.Timestamp get completedAt => $_getN(9);
  @$pb.TagNumber(10)
  set completedAt($0.Timestamp v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasCompletedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCompletedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureCompletedAt() => $_ensure(9);
}

class SimulationParams extends $pb.GeneratedMessage {
  factory SimulationParams({
    $0.Timestamp? startTime,
    $0.Timestamp? endTime,
    $core.int? timeStepMinutes,
    $core.double? latitude,
    $core.double? longitude,
    $core.bool? includeTerrainShading,
    $core.bool? includePanelShading,
  }) {
    final $result = create();
    if (startTime != null) {
      $result.startTime = startTime;
    }
    if (endTime != null) {
      $result.endTime = endTime;
    }
    if (timeStepMinutes != null) {
      $result.timeStepMinutes = timeStepMinutes;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (includeTerrainShading != null) {
      $result.includeTerrainShading = includeTerrainShading;
    }
    if (includePanelShading != null) {
      $result.includePanelShading = includePanelShading;
    }
    return $result;
  }
  SimulationParams._() : super();
  factory SimulationParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SimulationParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SimulationParams', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOM<$0.Timestamp>(1, _omitFieldNames ? '' : 'startTime', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'endTime', subBuilder: $0.Timestamp.create)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'timeStepMinutes', $pb.PbFieldType.O3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..aOB(6, _omitFieldNames ? '' : 'includeTerrainShading')
    ..aOB(7, _omitFieldNames ? '' : 'includePanelShading')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SimulationParams clone() => SimulationParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SimulationParams copyWith(void Function(SimulationParams) updates) => super.copyWith((message) => updates(message as SimulationParams)) as SimulationParams;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SimulationParams create() => SimulationParams._();
  SimulationParams createEmptyInstance() => create();
  static $pb.PbList<SimulationParams> createRepeated() => $pb.PbList<SimulationParams>();
  @$core.pragma('dart2js:noInline')
  static SimulationParams getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SimulationParams>(create);
  static SimulationParams? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Timestamp get startTime => $_getN(0);
  @$pb.TagNumber(1)
  set startTime($0.Timestamp v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStartTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartTime() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.Timestamp ensureStartTime() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.Timestamp get endTime => $_getN(1);
  @$pb.TagNumber(2)
  set endTime($0.Timestamp v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasEndTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndTime() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureEndTime() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get timeStepMinutes => $_getIZ(2);
  @$pb.TagNumber(3)
  set timeStepMinutes($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimeStepMinutes() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimeStepMinutes() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get latitude => $_getN(3);
  @$pb.TagNumber(4)
  set latitude($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLatitude() => $_has(3);
  @$pb.TagNumber(4)
  void clearLatitude() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get longitude => $_getN(4);
  @$pb.TagNumber(5)
  set longitude($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLongitude() => $_has(4);
  @$pb.TagNumber(5)
  void clearLongitude() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get includeTerrainShading => $_getBF(5);
  @$pb.TagNumber(6)
  set includeTerrainShading($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasIncludeTerrainShading() => $_has(5);
  @$pb.TagNumber(6)
  void clearIncludeTerrainShading() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get includePanelShading => $_getBF(6);
  @$pb.TagNumber(7)
  set includePanelShading($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasIncludePanelShading() => $_has(6);
  @$pb.TagNumber(7)
  void clearIncludePanelShading() => $_clearField(7);
}

class SimulationResult extends $pb.GeneratedMessage {
  factory SimulationResult({
    $core.double? totalIrradianceKwhM2,
    $core.double? annualYieldKwh,
    $core.double? performanceRatio,
    $core.double? shadingLossPercent,
    $core.String? resultFilePath,
  }) {
    final $result = create();
    if (totalIrradianceKwhM2 != null) {
      $result.totalIrradianceKwhM2 = totalIrradianceKwhM2;
    }
    if (annualYieldKwh != null) {
      $result.annualYieldKwh = annualYieldKwh;
    }
    if (performanceRatio != null) {
      $result.performanceRatio = performanceRatio;
    }
    if (shadingLossPercent != null) {
      $result.shadingLossPercent = shadingLossPercent;
    }
    if (resultFilePath != null) {
      $result.resultFilePath = resultFilePath;
    }
    return $result;
  }
  SimulationResult._() : super();
  factory SimulationResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SimulationResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SimulationResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'totalIrradianceKwhM2', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'annualYieldKwh', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'performanceRatio', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'shadingLossPercent', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'resultFilePath')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SimulationResult clone() => SimulationResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SimulationResult copyWith(void Function(SimulationResult) updates) => super.copyWith((message) => updates(message as SimulationResult)) as SimulationResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SimulationResult create() => SimulationResult._();
  SimulationResult createEmptyInstance() => create();
  static $pb.PbList<SimulationResult> createRepeated() => $pb.PbList<SimulationResult>();
  @$core.pragma('dart2js:noInline')
  static SimulationResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SimulationResult>(create);
  static SimulationResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get totalIrradianceKwhM2 => $_getN(0);
  @$pb.TagNumber(1)
  set totalIrradianceKwhM2($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotalIrradianceKwhM2() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalIrradianceKwhM2() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get annualYieldKwh => $_getN(1);
  @$pb.TagNumber(2)
  set annualYieldKwh($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAnnualYieldKwh() => $_has(1);
  @$pb.TagNumber(2)
  void clearAnnualYieldKwh() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get performanceRatio => $_getN(2);
  @$pb.TagNumber(3)
  set performanceRatio($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPerformanceRatio() => $_has(2);
  @$pb.TagNumber(3)
  void clearPerformanceRatio() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get shadingLossPercent => $_getN(3);
  @$pb.TagNumber(4)
  set shadingLossPercent($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasShadingLossPercent() => $_has(3);
  @$pb.TagNumber(4)
  void clearShadingLossPercent() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get resultFilePath => $_getSZ(4);
  @$pb.TagNumber(5)
  set resultFilePath($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasResultFilePath() => $_has(4);
  @$pb.TagNumber(5)
  void clearResultFilePath() => $_clearField(5);
}

class SunPosition extends $pb.GeneratedMessage {
  factory SunPosition({
    $core.double? azimuth,
    $core.double? elevation,
    $core.double? zenith,
    $core.double? hourAngle,
    $0.Timestamp? timestamp,
  }) {
    final $result = create();
    if (azimuth != null) {
      $result.azimuth = azimuth;
    }
    if (elevation != null) {
      $result.elevation = elevation;
    }
    if (zenith != null) {
      $result.zenith = zenith;
    }
    if (hourAngle != null) {
      $result.hourAngle = hourAngle;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    return $result;
  }
  SunPosition._() : super();
  factory SunPosition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SunPosition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SunPosition', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'azimuth', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'elevation', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'zenith', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'hourAngle', $pb.PbFieldType.OD)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SunPosition clone() => SunPosition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SunPosition copyWith(void Function(SunPosition) updates) => super.copyWith((message) => updates(message as SunPosition)) as SunPosition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SunPosition create() => SunPosition._();
  SunPosition createEmptyInstance() => create();
  static $pb.PbList<SunPosition> createRepeated() => $pb.PbList<SunPosition>();
  @$core.pragma('dart2js:noInline')
  static SunPosition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SunPosition>(create);
  static SunPosition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get azimuth => $_getN(0);
  @$pb.TagNumber(1)
  set azimuth($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAzimuth() => $_has(0);
  @$pb.TagNumber(1)
  void clearAzimuth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get elevation => $_getN(1);
  @$pb.TagNumber(2)
  set elevation($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasElevation() => $_has(1);
  @$pb.TagNumber(2)
  void clearElevation() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get zenith => $_getN(2);
  @$pb.TagNumber(3)
  set zenith($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasZenith() => $_has(2);
  @$pb.TagNumber(3)
  void clearZenith() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get hourAngle => $_getN(3);
  @$pb.TagNumber(4)
  set hourAngle($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHourAngle() => $_has(3);
  @$pb.TagNumber(4)
  void clearHourAngle() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get timestamp => $_getN(4);
  @$pb.TagNumber(5)
  set timestamp($0.Timestamp v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasTimestamp() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimestamp() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureTimestamp() => $_ensure(4);
}

class ShadowPolygon extends $pb.GeneratedMessage {
  factory ShadowPolygon({
    $core.String? sourcePanelId,
    $core.String? shadowGeojson,
    $core.double? shadowIntensity,
  }) {
    final $result = create();
    if (sourcePanelId != null) {
      $result.sourcePanelId = sourcePanelId;
    }
    if (shadowGeojson != null) {
      $result.shadowGeojson = shadowGeojson;
    }
    if (shadowIntensity != null) {
      $result.shadowIntensity = shadowIntensity;
    }
    return $result;
  }
  ShadowPolygon._() : super();
  factory ShadowPolygon.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ShadowPolygon.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ShadowPolygon', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sourcePanelId')
    ..aOS(2, _omitFieldNames ? '' : 'shadowGeojson')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'shadowIntensity', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ShadowPolygon clone() => ShadowPolygon()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ShadowPolygon copyWith(void Function(ShadowPolygon) updates) => super.copyWith((message) => updates(message as ShadowPolygon)) as ShadowPolygon;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ShadowPolygon create() => ShadowPolygon._();
  ShadowPolygon createEmptyInstance() => create();
  static $pb.PbList<ShadowPolygon> createRepeated() => $pb.PbList<ShadowPolygon>();
  @$core.pragma('dart2js:noInline')
  static ShadowPolygon getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ShadowPolygon>(create);
  static ShadowPolygon? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sourcePanelId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sourcePanelId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSourcePanelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourcePanelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get shadowGeojson => $_getSZ(1);
  @$pb.TagNumber(2)
  set shadowGeojson($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasShadowGeojson() => $_has(1);
  @$pb.TagNumber(2)
  void clearShadowGeojson() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get shadowIntensity => $_getN(2);
  @$pb.TagNumber(3)
  set shadowIntensity($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasShadowIntensity() => $_has(2);
  @$pb.TagNumber(3)
  void clearShadowIntensity() => $_clearField(3);
}

class CreateSimulationRequest extends $pb.GeneratedMessage {
  factory CreateSimulationRequest({
    $core.String? projectId,
    $core.String? layoutId,
    $core.String? name,
    SimulationType? simulationType,
    SimulationParams? params,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (simulationType != null) {
      $result.simulationType = simulationType;
    }
    if (params != null) {
      $result.params = params;
    }
    return $result;
  }
  CreateSimulationRequest._() : super();
  factory CreateSimulationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateSimulationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateSimulationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'layoutId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..e<SimulationType>(4, _omitFieldNames ? '' : 'simulationType', $pb.PbFieldType.OE, defaultOrMaker: SimulationType.SIMULATION_TYPE_UNSPECIFIED, valueOf: SimulationType.valueOf, enumValues: SimulationType.values)
    ..aOM<SimulationParams>(5, _omitFieldNames ? '' : 'params', subBuilder: SimulationParams.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateSimulationRequest clone() => CreateSimulationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateSimulationRequest copyWith(void Function(CreateSimulationRequest) updates) => super.copyWith((message) => updates(message as CreateSimulationRequest)) as CreateSimulationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateSimulationRequest create() => CreateSimulationRequest._();
  CreateSimulationRequest createEmptyInstance() => create();
  static $pb.PbList<CreateSimulationRequest> createRepeated() => $pb.PbList<CreateSimulationRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateSimulationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateSimulationRequest>(create);
  static CreateSimulationRequest? _defaultInstance;

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
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  SimulationType get simulationType => $_getN(3);
  @$pb.TagNumber(4)
  set simulationType(SimulationType v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSimulationType() => $_has(3);
  @$pb.TagNumber(4)
  void clearSimulationType() => $_clearField(4);

  @$pb.TagNumber(5)
  SimulationParams get params => $_getN(4);
  @$pb.TagNumber(5)
  set params(SimulationParams v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasParams() => $_has(4);
  @$pb.TagNumber(5)
  void clearParams() => $_clearField(5);
  @$pb.TagNumber(5)
  SimulationParams ensureParams() => $_ensure(4);
}

class CreateSimulationResponse extends $pb.GeneratedMessage {
  factory CreateSimulationResponse({
    Simulation? simulation,
  }) {
    final $result = create();
    if (simulation != null) {
      $result.simulation = simulation;
    }
    return $result;
  }
  CreateSimulationResponse._() : super();
  factory CreateSimulationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateSimulationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateSimulationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOM<Simulation>(1, _omitFieldNames ? '' : 'simulation', subBuilder: Simulation.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateSimulationResponse clone() => CreateSimulationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateSimulationResponse copyWith(void Function(CreateSimulationResponse) updates) => super.copyWith((message) => updates(message as CreateSimulationResponse)) as CreateSimulationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateSimulationResponse create() => CreateSimulationResponse._();
  CreateSimulationResponse createEmptyInstance() => create();
  static $pb.PbList<CreateSimulationResponse> createRepeated() => $pb.PbList<CreateSimulationResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateSimulationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateSimulationResponse>(create);
  static CreateSimulationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Simulation get simulation => $_getN(0);
  @$pb.TagNumber(1)
  set simulation(Simulation v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSimulation() => $_has(0);
  @$pb.TagNumber(1)
  void clearSimulation() => $_clearField(1);
  @$pb.TagNumber(1)
  Simulation ensureSimulation() => $_ensure(0);
}

class GetSimulationRequest extends $pb.GeneratedMessage {
  factory GetSimulationRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetSimulationRequest._() : super();
  factory GetSimulationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSimulationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSimulationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSimulationRequest clone() => GetSimulationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSimulationRequest copyWith(void Function(GetSimulationRequest) updates) => super.copyWith((message) => updates(message as GetSimulationRequest)) as GetSimulationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSimulationRequest create() => GetSimulationRequest._();
  GetSimulationRequest createEmptyInstance() => create();
  static $pb.PbList<GetSimulationRequest> createRepeated() => $pb.PbList<GetSimulationRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSimulationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSimulationRequest>(create);
  static GetSimulationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetSimulationResponse extends $pb.GeneratedMessage {
  factory GetSimulationResponse({
    Simulation? simulation,
  }) {
    final $result = create();
    if (simulation != null) {
      $result.simulation = simulation;
    }
    return $result;
  }
  GetSimulationResponse._() : super();
  factory GetSimulationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSimulationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSimulationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOM<Simulation>(1, _omitFieldNames ? '' : 'simulation', subBuilder: Simulation.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSimulationResponse clone() => GetSimulationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSimulationResponse copyWith(void Function(GetSimulationResponse) updates) => super.copyWith((message) => updates(message as GetSimulationResponse)) as GetSimulationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSimulationResponse create() => GetSimulationResponse._();
  GetSimulationResponse createEmptyInstance() => create();
  static $pb.PbList<GetSimulationResponse> createRepeated() => $pb.PbList<GetSimulationResponse>();
  @$core.pragma('dart2js:noInline')
  static GetSimulationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSimulationResponse>(create);
  static GetSimulationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Simulation get simulation => $_getN(0);
  @$pb.TagNumber(1)
  set simulation(Simulation v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSimulation() => $_has(0);
  @$pb.TagNumber(1)
  void clearSimulation() => $_clearField(1);
  @$pb.TagNumber(1)
  Simulation ensureSimulation() => $_ensure(0);
}

class ListSimulationsRequest extends $pb.GeneratedMessage {
  factory ListSimulationsRequest({
    $core.String? projectId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    return $result;
  }
  ListSimulationsRequest._() : super();
  factory ListSimulationsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListSimulationsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListSimulationsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListSimulationsRequest clone() => ListSimulationsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListSimulationsRequest copyWith(void Function(ListSimulationsRequest) updates) => super.copyWith((message) => updates(message as ListSimulationsRequest)) as ListSimulationsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSimulationsRequest create() => ListSimulationsRequest._();
  ListSimulationsRequest createEmptyInstance() => create();
  static $pb.PbList<ListSimulationsRequest> createRepeated() => $pb.PbList<ListSimulationsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListSimulationsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListSimulationsRequest>(create);
  static ListSimulationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);
}

class ListSimulationsResponse extends $pb.GeneratedMessage {
  factory ListSimulationsResponse({
    $core.Iterable<Simulation>? simulations,
  }) {
    final $result = create();
    if (simulations != null) {
      $result.simulations.addAll(simulations);
    }
    return $result;
  }
  ListSimulationsResponse._() : super();
  factory ListSimulationsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListSimulationsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListSimulationsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..pc<Simulation>(1, _omitFieldNames ? '' : 'simulations', $pb.PbFieldType.PM, subBuilder: Simulation.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListSimulationsResponse clone() => ListSimulationsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListSimulationsResponse copyWith(void Function(ListSimulationsResponse) updates) => super.copyWith((message) => updates(message as ListSimulationsResponse)) as ListSimulationsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListSimulationsResponse create() => ListSimulationsResponse._();
  ListSimulationsResponse createEmptyInstance() => create();
  static $pb.PbList<ListSimulationsResponse> createRepeated() => $pb.PbList<ListSimulationsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListSimulationsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListSimulationsResponse>(create);
  static ListSimulationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Simulation> get simulations => $_getList(0);
}

class RunSimulationRequest extends $pb.GeneratedMessage {
  factory RunSimulationRequest({
    $core.String? simulationId,
  }) {
    final $result = create();
    if (simulationId != null) {
      $result.simulationId = simulationId;
    }
    return $result;
  }
  RunSimulationRequest._() : super();
  factory RunSimulationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RunSimulationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RunSimulationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'simulationId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RunSimulationRequest clone() => RunSimulationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RunSimulationRequest copyWith(void Function(RunSimulationRequest) updates) => super.copyWith((message) => updates(message as RunSimulationRequest)) as RunSimulationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RunSimulationRequest create() => RunSimulationRequest._();
  RunSimulationRequest createEmptyInstance() => create();
  static $pb.PbList<RunSimulationRequest> createRepeated() => $pb.PbList<RunSimulationRequest>();
  @$core.pragma('dart2js:noInline')
  static RunSimulationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RunSimulationRequest>(create);
  static RunSimulationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get simulationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set simulationId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSimulationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSimulationId() => $_clearField(1);
}

class RunSimulationResponse extends $pb.GeneratedMessage {
  factory RunSimulationResponse({
    Simulation? simulation,
  }) {
    final $result = create();
    if (simulation != null) {
      $result.simulation = simulation;
    }
    return $result;
  }
  RunSimulationResponse._() : super();
  factory RunSimulationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RunSimulationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RunSimulationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOM<Simulation>(1, _omitFieldNames ? '' : 'simulation', subBuilder: Simulation.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RunSimulationResponse clone() => RunSimulationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RunSimulationResponse copyWith(void Function(RunSimulationResponse) updates) => super.copyWith((message) => updates(message as RunSimulationResponse)) as RunSimulationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RunSimulationResponse create() => RunSimulationResponse._();
  RunSimulationResponse createEmptyInstance() => create();
  static $pb.PbList<RunSimulationResponse> createRepeated() => $pb.PbList<RunSimulationResponse>();
  @$core.pragma('dart2js:noInline')
  static RunSimulationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RunSimulationResponse>(create);
  static RunSimulationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Simulation get simulation => $_getN(0);
  @$pb.TagNumber(1)
  set simulation(Simulation v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSimulation() => $_has(0);
  @$pb.TagNumber(1)
  void clearSimulation() => $_clearField(1);
  @$pb.TagNumber(1)
  Simulation ensureSimulation() => $_ensure(0);
}

class GetSunPositionRequest extends $pb.GeneratedMessage {
  factory GetSunPositionRequest({
    $core.double? latitude,
    $core.double? longitude,
    $0.Timestamp? timestamp,
  }) {
    final $result = create();
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    return $result;
  }
  GetSunPositionRequest._() : super();
  factory GetSunPositionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSunPositionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSunPositionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSunPositionRequest clone() => GetSunPositionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSunPositionRequest copyWith(void Function(GetSunPositionRequest) updates) => super.copyWith((message) => updates(message as GetSunPositionRequest)) as GetSunPositionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSunPositionRequest create() => GetSunPositionRequest._();
  GetSunPositionRequest createEmptyInstance() => create();
  static $pb.PbList<GetSunPositionRequest> createRepeated() => $pb.PbList<GetSunPositionRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSunPositionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSunPositionRequest>(create);
  static GetSunPositionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get latitude => $_getN(0);
  @$pb.TagNumber(1)
  set latitude($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLatitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $0.Timestamp get timestamp => $_getN(2);
  @$pb.TagNumber(3)
  set timestamp($0.Timestamp v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureTimestamp() => $_ensure(2);
}

class GetSunPositionResponse extends $pb.GeneratedMessage {
  factory GetSunPositionResponse({
    SunPosition? position,
  }) {
    final $result = create();
    if (position != null) {
      $result.position = position;
    }
    return $result;
  }
  GetSunPositionResponse._() : super();
  factory GetSunPositionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSunPositionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSunPositionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOM<SunPosition>(1, _omitFieldNames ? '' : 'position', subBuilder: SunPosition.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSunPositionResponse clone() => GetSunPositionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSunPositionResponse copyWith(void Function(GetSunPositionResponse) updates) => super.copyWith((message) => updates(message as GetSunPositionResponse)) as GetSunPositionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSunPositionResponse create() => GetSunPositionResponse._();
  GetSunPositionResponse createEmptyInstance() => create();
  static $pb.PbList<GetSunPositionResponse> createRepeated() => $pb.PbList<GetSunPositionResponse>();
  @$core.pragma('dart2js:noInline')
  static GetSunPositionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSunPositionResponse>(create);
  static GetSunPositionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SunPosition get position => $_getN(0);
  @$pb.TagNumber(1)
  set position(SunPosition v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosition() => $_clearField(1);
  @$pb.TagNumber(1)
  SunPosition ensurePosition() => $_ensure(0);
}

class GetShadowMapRequest extends $pb.GeneratedMessage {
  factory GetShadowMapRequest({
    $core.String? layoutId,
    $0.Timestamp? timestamp,
    $core.double? latitude,
    $core.double? longitude,
  }) {
    final $result = create();
    if (layoutId != null) {
      $result.layoutId = layoutId;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    return $result;
  }
  GetShadowMapRequest._() : super();
  factory GetShadowMapRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetShadowMapRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetShadowMapRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'layoutId')
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetShadowMapRequest clone() => GetShadowMapRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetShadowMapRequest copyWith(void Function(GetShadowMapRequest) updates) => super.copyWith((message) => updates(message as GetShadowMapRequest)) as GetShadowMapRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetShadowMapRequest create() => GetShadowMapRequest._();
  GetShadowMapRequest createEmptyInstance() => create();
  static $pb.PbList<GetShadowMapRequest> createRepeated() => $pb.PbList<GetShadowMapRequest>();
  @$core.pragma('dart2js:noInline')
  static GetShadowMapRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetShadowMapRequest>(create);
  static GetShadowMapRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layoutId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layoutId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayoutId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayoutId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get timestamp => $_getN(1);
  @$pb.TagNumber(2)
  set timestamp($0.Timestamp v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureTimestamp() => $_ensure(1);

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
}

class GetShadowMapResponse extends $pb.GeneratedMessage {
  factory GetShadowMapResponse({
    $core.Iterable<ShadowPolygon>? shadows,
    SunPosition? sunPosition,
  }) {
    final $result = create();
    if (shadows != null) {
      $result.shadows.addAll(shadows);
    }
    if (sunPosition != null) {
      $result.sunPosition = sunPosition;
    }
    return $result;
  }
  GetShadowMapResponse._() : super();
  factory GetShadowMapResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetShadowMapResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetShadowMapResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..pc<ShadowPolygon>(1, _omitFieldNames ? '' : 'shadows', $pb.PbFieldType.PM, subBuilder: ShadowPolygon.create)
    ..aOM<SunPosition>(2, _omitFieldNames ? '' : 'sunPosition', subBuilder: SunPosition.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetShadowMapResponse clone() => GetShadowMapResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetShadowMapResponse copyWith(void Function(GetShadowMapResponse) updates) => super.copyWith((message) => updates(message as GetShadowMapResponse)) as GetShadowMapResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetShadowMapResponse create() => GetShadowMapResponse._();
  GetShadowMapResponse createEmptyInstance() => create();
  static $pb.PbList<GetShadowMapResponse> createRepeated() => $pb.PbList<GetShadowMapResponse>();
  @$core.pragma('dart2js:noInline')
  static GetShadowMapResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetShadowMapResponse>(create);
  static GetShadowMapResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ShadowPolygon> get shadows => $_getList(0);

  @$pb.TagNumber(2)
  SunPosition get sunPosition => $_getN(1);
  @$pb.TagNumber(2)
  set sunPosition(SunPosition v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSunPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearSunPosition() => $_clearField(2);
  @$pb.TagNumber(2)
  SunPosition ensureSunPosition() => $_ensure(1);
}

class DeleteSimulationRequest extends $pb.GeneratedMessage {
  factory DeleteSimulationRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteSimulationRequest._() : super();
  factory DeleteSimulationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteSimulationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteSimulationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteSimulationRequest clone() => DeleteSimulationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteSimulationRequest copyWith(void Function(DeleteSimulationRequest) updates) => super.copyWith((message) => updates(message as DeleteSimulationRequest)) as DeleteSimulationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteSimulationRequest create() => DeleteSimulationRequest._();
  DeleteSimulationRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteSimulationRequest> createRepeated() => $pb.PbList<DeleteSimulationRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteSimulationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteSimulationRequest>(create);
  static DeleteSimulationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteSimulationResponse extends $pb.GeneratedMessage {
  factory DeleteSimulationResponse() => create();
  DeleteSimulationResponse._() : super();
  factory DeleteSimulationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteSimulationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteSimulationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'simulation.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteSimulationResponse clone() => DeleteSimulationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteSimulationResponse copyWith(void Function(DeleteSimulationResponse) updates) => super.copyWith((message) => updates(message as DeleteSimulationResponse)) as DeleteSimulationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteSimulationResponse create() => DeleteSimulationResponse._();
  DeleteSimulationResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteSimulationResponse> createRepeated() => $pb.PbList<DeleteSimulationResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteSimulationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteSimulationResponse>(create);
  static DeleteSimulationResponse? _defaultInstance;
}

class SimulationServiceApi {
  $pb.RpcClient _client;
  SimulationServiceApi(this._client);

  $async.Future<CreateSimulationResponse> createSimulation($pb.ClientContext? ctx, CreateSimulationRequest request) =>
    _client.invoke<CreateSimulationResponse>(ctx, 'SimulationService', 'CreateSimulation', request, CreateSimulationResponse())
  ;
  $async.Future<GetSimulationResponse> getSimulation($pb.ClientContext? ctx, GetSimulationRequest request) =>
    _client.invoke<GetSimulationResponse>(ctx, 'SimulationService', 'GetSimulation', request, GetSimulationResponse())
  ;
  $async.Future<ListSimulationsResponse> listSimulations($pb.ClientContext? ctx, ListSimulationsRequest request) =>
    _client.invoke<ListSimulationsResponse>(ctx, 'SimulationService', 'ListSimulations', request, ListSimulationsResponse())
  ;
  $async.Future<RunSimulationResponse> runSimulation($pb.ClientContext? ctx, RunSimulationRequest request) =>
    _client.invoke<RunSimulationResponse>(ctx, 'SimulationService', 'RunSimulation', request, RunSimulationResponse())
  ;
  $async.Future<GetSunPositionResponse> getSunPosition($pb.ClientContext? ctx, GetSunPositionRequest request) =>
    _client.invoke<GetSunPositionResponse>(ctx, 'SimulationService', 'GetSunPosition', request, GetSunPositionResponse())
  ;
  $async.Future<GetShadowMapResponse> getShadowMap($pb.ClientContext? ctx, GetShadowMapRequest request) =>
    _client.invoke<GetShadowMapResponse>(ctx, 'SimulationService', 'GetShadowMap', request, GetShadowMapResponse())
  ;
  $async.Future<DeleteSimulationResponse> deleteSimulation($pb.ClientContext? ctx, DeleteSimulationRequest request) =>
    _client.invoke<DeleteSimulationResponse>(ctx, 'SimulationService', 'DeleteSimulation', request, DeleteSimulationResponse())
  ;
}

/// SimulationComputeService exposes only stateless compute-style simulation operations.
/// Lifecycle/storage operations remain in SimulationService.
class SimulationComputeServiceApi {
  $pb.RpcClient _client;
  SimulationComputeServiceApi(this._client);

  $async.Future<GetSunPositionResponse> getSunPosition($pb.ClientContext? ctx, GetSunPositionRequest request) =>
    _client.invoke<GetSunPositionResponse>(ctx, 'SimulationComputeService', 'GetSunPosition', request, GetSunPositionResponse())
  ;
  $async.Future<GetShadowMapResponse> getShadowMap($pb.ClientContext? ctx, GetShadowMapRequest request) =>
    _client.invoke<GetShadowMapResponse>(ctx, 'SimulationComputeService', 'GetShadowMap', request, GetShadowMapResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
