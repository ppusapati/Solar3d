//
//  Generated code. Do not modify.
//  source: solar/v1/solar.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/v1/primitives.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Describes sun position in sky (equatorial coordinates).
class SolarPosition extends $pb.GeneratedMessage {
  factory SolarPosition({
    $core.double? elevationAngleDeg,
    $core.double? azimuthAngleDeg,
    $core.double? airMass,
    $core.double? zenithAngleDeg,
  }) {
    final $result = create();
    if (elevationAngleDeg != null) {
      $result.elevationAngleDeg = elevationAngleDeg;
    }
    if (azimuthAngleDeg != null) {
      $result.azimuthAngleDeg = azimuthAngleDeg;
    }
    if (airMass != null) {
      $result.airMass = airMass;
    }
    if (zenithAngleDeg != null) {
      $result.zenithAngleDeg = zenithAngleDeg;
    }
    return $result;
  }
  SolarPosition._() : super();
  factory SolarPosition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SolarPosition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SolarPosition', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'elevationAngleDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'azimuthAngleDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'airMass', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'zenithAngleDeg', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SolarPosition clone() => SolarPosition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SolarPosition copyWith(void Function(SolarPosition) updates) => super.copyWith((message) => updates(message as SolarPosition)) as SolarPosition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SolarPosition create() => SolarPosition._();
  SolarPosition createEmptyInstance() => create();
  static $pb.PbList<SolarPosition> createRepeated() => $pb.PbList<SolarPosition>();
  @$core.pragma('dart2js:noInline')
  static SolarPosition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SolarPosition>(create);
  static SolarPosition? _defaultInstance;

  /// Elevation angle above horizon (degrees, 0-90).
  @$pb.TagNumber(1)
  $core.double get elevationAngleDeg => $_getN(0);
  @$pb.TagNumber(1)
  set elevationAngleDeg($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasElevationAngleDeg() => $_has(0);
  @$pb.TagNumber(1)
  void clearElevationAngleDeg() => $_clearField(1);

  /// Azimuth angle measured from North clockwise (degrees, 0-360).
  @$pb.TagNumber(2)
  $core.double get azimuthAngleDeg => $_getN(1);
  @$pb.TagNumber(2)
  set azimuthAngleDeg($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAzimuthAngleDeg() => $_has(1);
  @$pb.TagNumber(2)
  void clearAzimuthAngleDeg() => $_clearField(2);

  /// Air mass index (> 1.0 when sun below overhead).
  @$pb.TagNumber(3)
  $core.double get airMass => $_getN(2);
  @$pb.TagNumber(3)
  set airMass($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAirMass() => $_has(2);
  @$pb.TagNumber(3)
  void clearAirMass() => $_clearField(3);

  /// Zenith angle from observer vertical (degrees, 0-90).
  @$pb.TagNumber(4)
  $core.double get zenithAngleDeg => $_getN(3);
  @$pb.TagNumber(4)
  set zenithAngleDeg($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasZenithAngleDeg() => $_has(3);
  @$pb.TagNumber(4)
  void clearZenithAngleDeg() => $_clearField(4);
}

class SolarPositionRequest extends $pb.GeneratedMessage {
  factory SolarPositionRequest({
    $core.double? timestampSeconds,
    $core.double? latitudeDeg,
    $core.double? longitudeDeg,
    $core.double? utcOffsetHours,
  }) {
    final $result = create();
    if (timestampSeconds != null) {
      $result.timestampSeconds = timestampSeconds;
    }
    if (latitudeDeg != null) {
      $result.latitudeDeg = latitudeDeg;
    }
    if (longitudeDeg != null) {
      $result.longitudeDeg = longitudeDeg;
    }
    if (utcOffsetHours != null) {
      $result.utcOffsetHours = utcOffsetHours;
    }
    return $result;
  }
  SolarPositionRequest._() : super();
  factory SolarPositionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SolarPositionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SolarPositionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'timestampSeconds', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'latitudeDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'longitudeDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'utcOffsetHours', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SolarPositionRequest clone() => SolarPositionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SolarPositionRequest copyWith(void Function(SolarPositionRequest) updates) => super.copyWith((message) => updates(message as SolarPositionRequest)) as SolarPositionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SolarPositionRequest create() => SolarPositionRequest._();
  SolarPositionRequest createEmptyInstance() => create();
  static $pb.PbList<SolarPositionRequest> createRepeated() => $pb.PbList<SolarPositionRequest>();
  @$core.pragma('dart2js:noInline')
  static SolarPositionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SolarPositionRequest>(create);
  static SolarPositionRequest? _defaultInstance;

  /// Unix timestamp (seconds since epoch).
  @$pb.TagNumber(1)
  $core.double get timestampSeconds => $_getN(0);
  @$pb.TagNumber(1)
  set timestampSeconds($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimestampSeconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestampSeconds() => $_clearField(1);

  /// Observer latitude (degrees, -90 to 90).
  @$pb.TagNumber(2)
  $core.double get latitudeDeg => $_getN(1);
  @$pb.TagNumber(2)
  set latitudeDeg($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLatitudeDeg() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatitudeDeg() => $_clearField(2);

  /// Observer longitude (degrees, -180 to 180).
  @$pb.TagNumber(3)
  $core.double get longitudeDeg => $_getN(2);
  @$pb.TagNumber(3)
  set longitudeDeg($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLongitudeDeg() => $_has(2);
  @$pb.TagNumber(3)
  void clearLongitudeDeg() => $_clearField(3);

  /// UTC offset in hours for local time.
  @$pb.TagNumber(4)
  $core.double get utcOffsetHours => $_getN(3);
  @$pb.TagNumber(4)
  set utcOffsetHours($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUtcOffsetHours() => $_has(3);
  @$pb.TagNumber(4)
  void clearUtcOffsetHours() => $_clearField(4);
}

class SolarPositionResponse extends $pb.GeneratedMessage {
  factory SolarPositionResponse({
    SolarPosition? position,
    $core.bool? isNight,
    $0.ContractMetadata? contract,
  }) {
    final $result = create();
    if (position != null) {
      $result.position = position;
    }
    if (isNight != null) {
      $result.isNight = isNight;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  SolarPositionResponse._() : super();
  factory SolarPositionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SolarPositionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SolarPositionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..aOM<SolarPosition>(1, _omitFieldNames ? '' : 'position', subBuilder: SolarPosition.create)
    ..aOB(2, _omitFieldNames ? '' : 'isNight')
    ..aOM<$0.ContractMetadata>(10, _omitFieldNames ? '' : 'contract', subBuilder: $0.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SolarPositionResponse clone() => SolarPositionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SolarPositionResponse copyWith(void Function(SolarPositionResponse) updates) => super.copyWith((message) => updates(message as SolarPositionResponse)) as SolarPositionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SolarPositionResponse create() => SolarPositionResponse._();
  SolarPositionResponse createEmptyInstance() => create();
  static $pb.PbList<SolarPositionResponse> createRepeated() => $pb.PbList<SolarPositionResponse>();
  @$core.pragma('dart2js:noInline')
  static SolarPositionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SolarPositionResponse>(create);
  static SolarPositionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SolarPosition get position => $_getN(0);
  @$pb.TagNumber(1)
  set position(SolarPosition v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosition() => $_clearField(1);
  @$pb.TagNumber(1)
  SolarPosition ensurePosition() => $_ensure(0);

  /// True if sun is below horizon (night time).
  @$pb.TagNumber(2)
  $core.bool get isNight => $_getBF(1);
  @$pb.TagNumber(2)
  set isNight($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsNight() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsNight() => $_clearField(2);

  /// Correlation ID for tracing.
  @$pb.TagNumber(10)
  $0.ContractMetadata get contract => $_getN(2);
  @$pb.TagNumber(10)
  set contract($0.ContractMetadata v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasContract() => $_has(2);
  @$pb.TagNumber(10)
  void clearContract() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.ContractMetadata ensureContract() => $_ensure(2);
}

/// Obstacle geometry in site coordinates.
class Obstacle extends $pb.GeneratedMessage {
  factory Obstacle({
    $core.String? id,
    $0.Point3D? base,
    $core.double? heightM,
    $core.double? extentM,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (base != null) {
      $result.base = base;
    }
    if (heightM != null) {
      $result.heightM = heightM;
    }
    if (extentM != null) {
      $result.extentM = extentM;
    }
    return $result;
  }
  Obstacle._() : super();
  factory Obstacle.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Obstacle.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Obstacle', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<$0.Point3D>(2, _omitFieldNames ? '' : 'base', subBuilder: $0.Point3D.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'heightM', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'extentM', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Obstacle clone() => Obstacle()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Obstacle copyWith(void Function(Obstacle) updates) => super.copyWith((message) => updates(message as Obstacle)) as Obstacle;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Obstacle create() => Obstacle._();
  Obstacle createEmptyInstance() => create();
  static $pb.PbList<Obstacle> createRepeated() => $pb.PbList<Obstacle>();
  @$core.pragma('dart2js:noInline')
  static Obstacle getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Obstacle>(create);
  static Obstacle? _defaultInstance;

  /// Obstacle identifier.
  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// Base position (x, y, elevation_m).
  @$pb.TagNumber(2)
  $0.Point3D get base => $_getN(1);
  @$pb.TagNumber(2)
  set base($0.Point3D v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasBase() => $_has(1);
  @$pb.TagNumber(2)
  void clearBase() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Point3D ensureBase() => $_ensure(1);

  /// Height above base (meters).
  @$pb.TagNumber(3)
  $core.double get heightM => $_getN(2);
  @$pb.TagNumber(3)
  set heightM($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasHeightM() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeightM() => $_clearField(3);

  /// Optional max extent radius for culling (meters).
  @$pb.TagNumber(4)
  $core.double get extentM => $_getN(3);
  @$pb.TagNumber(4)
  set extentM($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasExtentM() => $_has(3);
  @$pb.TagNumber(4)
  void clearExtentM() => $_clearField(4);
}

class ShadowPolygon extends $pb.GeneratedMessage {
  factory ShadowPolygon({
    $core.String? obstacleId,
    $core.Iterable<$0.Point2D>? shadowVertices,
    $core.double? shadowLengthM,
    $core.double? sunElevationDeg,
  }) {
    final $result = create();
    if (obstacleId != null) {
      $result.obstacleId = obstacleId;
    }
    if (shadowVertices != null) {
      $result.shadowVertices.addAll(shadowVertices);
    }
    if (shadowLengthM != null) {
      $result.shadowLengthM = shadowLengthM;
    }
    if (sunElevationDeg != null) {
      $result.sunElevationDeg = sunElevationDeg;
    }
    return $result;
  }
  ShadowPolygon._() : super();
  factory ShadowPolygon.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ShadowPolygon.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ShadowPolygon', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'obstacleId')
    ..pc<$0.Point2D>(2, _omitFieldNames ? '' : 'shadowVertices', $pb.PbFieldType.PM, subBuilder: $0.Point2D.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'shadowLengthM', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'sunElevationDeg', $pb.PbFieldType.OD)
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

  /// Obstacle receiving shadow.
  @$pb.TagNumber(1)
  $core.String get obstacleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set obstacleId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasObstacleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearObstacleId() => $_clearField(1);

  /// Ground projection of shadow (2D polygon).
  @$pb.TagNumber(2)
  $pb.PbList<$0.Point2D> get shadowVertices => $_getList(1);

  /// Shadow length from obstacle base (meters).
  @$pb.TagNumber(3)
  $core.double get shadowLengthM => $_getN(2);
  @$pb.TagNumber(3)
  set shadowLengthM($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasShadowLengthM() => $_has(2);
  @$pb.TagNumber(3)
  void clearShadowLengthM() => $_clearField(3);

  /// Sun elevation when cast (degrees).
  @$pb.TagNumber(4)
  $core.double get sunElevationDeg => $_getN(3);
  @$pb.TagNumber(4)
  set sunElevationDeg($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSunElevationDeg() => $_has(3);
  @$pb.TagNumber(4)
  void clearSunElevationDeg() => $_clearField(4);
}

class CastShadowsRequest extends $pb.GeneratedMessage {
  factory CastShadowsRequest({
    $core.Iterable<Obstacle>? obstacles,
    $core.double? sunElevationDeg,
    $core.double? sunAzimuthDeg,
    $core.double? exaggeration,
  }) {
    final $result = create();
    if (obstacles != null) {
      $result.obstacles.addAll(obstacles);
    }
    if (sunElevationDeg != null) {
      $result.sunElevationDeg = sunElevationDeg;
    }
    if (sunAzimuthDeg != null) {
      $result.sunAzimuthDeg = sunAzimuthDeg;
    }
    if (exaggeration != null) {
      $result.exaggeration = exaggeration;
    }
    return $result;
  }
  CastShadowsRequest._() : super();
  factory CastShadowsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CastShadowsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CastShadowsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..pc<Obstacle>(1, _omitFieldNames ? '' : 'obstacles', $pb.PbFieldType.PM, subBuilder: Obstacle.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'sunElevationDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'sunAzimuthDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'exaggeration', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CastShadowsRequest clone() => CastShadowsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CastShadowsRequest copyWith(void Function(CastShadowsRequest) updates) => super.copyWith((message) => updates(message as CastShadowsRequest)) as CastShadowsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CastShadowsRequest create() => CastShadowsRequest._();
  CastShadowsRequest createEmptyInstance() => create();
  static $pb.PbList<CastShadowsRequest> createRepeated() => $pb.PbList<CastShadowsRequest>();
  @$core.pragma('dart2js:noInline')
  static CastShadowsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CastShadowsRequest>(create);
  static CastShadowsRequest? _defaultInstance;

  /// List of obstacles in scene.
  @$pb.TagNumber(1)
  $pb.PbList<Obstacle> get obstacles => $_getList(0);

  /// Current sun elevation (degrees).
  @$pb.TagNumber(2)
  $core.double get sunElevationDeg => $_getN(1);
  @$pb.TagNumber(2)
  set sunElevationDeg($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSunElevationDeg() => $_has(1);
  @$pb.TagNumber(2)
  void clearSunElevationDeg() => $_clearField(2);

  /// Current sun azimuth (degrees from North).
  @$pb.TagNumber(3)
  $core.double get sunAzimuthDeg => $_getN(2);
  @$pb.TagNumber(3)
  set sunAzimuthDeg($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSunAzimuthDeg() => $_has(2);
  @$pb.TagNumber(3)
  void clearSunAzimuthDeg() => $_clearField(3);

  /// Vertical exaggeration for visualization (default 1.0).
  @$pb.TagNumber(4)
  $core.double get exaggeration => $_getN(3);
  @$pb.TagNumber(4)
  set exaggeration($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasExaggeration() => $_has(3);
  @$pb.TagNumber(4)
  void clearExaggeration() => $_clearField(4);
}

class CastShadowsResponse extends $pb.GeneratedMessage {
  factory CastShadowsResponse({
    $core.Iterable<ShadowPolygon>? shadows,
    $core.int? shadowCount,
    $0.ContractMetadata? contract,
  }) {
    final $result = create();
    if (shadows != null) {
      $result.shadows.addAll(shadows);
    }
    if (shadowCount != null) {
      $result.shadowCount = shadowCount;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  CastShadowsResponse._() : super();
  factory CastShadowsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CastShadowsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CastShadowsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..pc<ShadowPolygon>(1, _omitFieldNames ? '' : 'shadows', $pb.PbFieldType.PM, subBuilder: ShadowPolygon.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'shadowCount', $pb.PbFieldType.O3)
    ..aOM<$0.ContractMetadata>(10, _omitFieldNames ? '' : 'contract', subBuilder: $0.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CastShadowsResponse clone() => CastShadowsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CastShadowsResponse copyWith(void Function(CastShadowsResponse) updates) => super.copyWith((message) => updates(message as CastShadowsResponse)) as CastShadowsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CastShadowsResponse create() => CastShadowsResponse._();
  CastShadowsResponse createEmptyInstance() => create();
  static $pb.PbList<CastShadowsResponse> createRepeated() => $pb.PbList<CastShadowsResponse>();
  @$core.pragma('dart2js:noInline')
  static CastShadowsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CastShadowsResponse>(create);
  static CastShadowsResponse? _defaultInstance;

  /// Shadow polygons one per obstacle.
  @$pb.TagNumber(1)
  $pb.PbList<ShadowPolygon> get shadows => $_getList(0);

  /// Number of shadows cast (> 0 only if sun above horizon).
  @$pb.TagNumber(2)
  $core.int get shadowCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set shadowCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasShadowCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearShadowCount() => $_clearField(2);

  /// Tracing/versioning.
  @$pb.TagNumber(10)
  $0.ContractMetadata get contract => $_getN(2);
  @$pb.TagNumber(10)
  set contract($0.ContractMetadata v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasContract() => $_has(2);
  @$pb.TagNumber(10)
  void clearContract() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.ContractMetadata ensureContract() => $_ensure(2);
}

class DNIRequest extends $pb.GeneratedMessage {
  factory DNIRequest({
    $core.double? airMass,
    $core.double? zenithAngleDeg,
    $core.double? turbidity,
  }) {
    final $result = create();
    if (airMass != null) {
      $result.airMass = airMass;
    }
    if (zenithAngleDeg != null) {
      $result.zenithAngleDeg = zenithAngleDeg;
    }
    if (turbidity != null) {
      $result.turbidity = turbidity;
    }
    return $result;
  }
  DNIRequest._() : super();
  factory DNIRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DNIRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DNIRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'airMass', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'zenithAngleDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'turbidity', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DNIRequest clone() => DNIRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DNIRequest copyWith(void Function(DNIRequest) updates) => super.copyWith((message) => updates(message as DNIRequest)) as DNIRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DNIRequest create() => DNIRequest._();
  DNIRequest createEmptyInstance() => create();
  static $pb.PbList<DNIRequest> createRepeated() => $pb.PbList<DNIRequest>();
  @$core.pragma('dart2js:noInline')
  static DNIRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DNIRequest>(create);
  static DNIRequest? _defaultInstance;

  /// Air mass factor (typically 1.0 - 6.0).
  @$pb.TagNumber(1)
  $core.double get airMass => $_getN(0);
  @$pb.TagNumber(1)
  set airMass($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAirMass() => $_has(0);
  @$pb.TagNumber(1)
  void clearAirMass() => $_clearField(1);

  /// Sun zenith angle (0-90 degrees).
  @$pb.TagNumber(2)
  $core.double get zenithAngleDeg => $_getN(1);
  @$pb.TagNumber(2)
  set zenithAngleDeg($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasZenithAngleDeg() => $_has(1);
  @$pb.TagNumber(2)
  void clearZenithAngleDeg() => $_clearField(2);

  /// Atmospheric turbidity factor (optional, default 2.0).
  @$pb.TagNumber(3)
  $core.double get turbidity => $_getN(2);
  @$pb.TagNumber(3)
  set turbidity($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTurbidity() => $_has(2);
  @$pb.TagNumber(3)
  void clearTurbidity() => $_clearField(3);
}

class DNIResponse extends $pb.GeneratedMessage {
  factory DNIResponse({
    $core.double? dniWM2,
    $core.bool? valid,
  }) {
    final $result = create();
    if (dniWM2 != null) {
      $result.dniWM2 = dniWM2;
    }
    if (valid != null) {
      $result.valid = valid;
    }
    return $result;
  }
  DNIResponse._() : super();
  factory DNIResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DNIResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DNIResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'dniWM2', $pb.PbFieldType.OD)
    ..aOB(2, _omitFieldNames ? '' : 'valid')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DNIResponse clone() => DNIResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DNIResponse copyWith(void Function(DNIResponse) updates) => super.copyWith((message) => updates(message as DNIResponse)) as DNIResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DNIResponse create() => DNIResponse._();
  DNIResponse createEmptyInstance() => create();
  static $pb.PbList<DNIResponse> createRepeated() => $pb.PbList<DNIResponse>();
  @$core.pragma('dart2js:noInline')
  static DNIResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DNIResponse>(create);
  static DNIResponse? _defaultInstance;

  /// Direct normal irradiance (W/m²).
  @$pb.TagNumber(1)
  $core.double get dniWM2 => $_getN(0);
  @$pb.TagNumber(1)
  set dniWM2($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDniWM2() => $_has(0);
  @$pb.TagNumber(1)
  void clearDniWM2() => $_clearField(1);

  /// True if calculation succeeded.
  @$pb.TagNumber(2)
  $core.bool get valid => $_getBF(1);
  @$pb.TagNumber(2)
  set valid($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValid() => $_has(1);
  @$pb.TagNumber(2)
  void clearValid() => $_clearField(2);
}

class DHIRequest extends $pb.GeneratedMessage {
  factory DHIRequest({
    $core.double? zenithAngleDeg,
    $core.double? clearnessIndex,
  }) {
    final $result = create();
    if (zenithAngleDeg != null) {
      $result.zenithAngleDeg = zenithAngleDeg;
    }
    if (clearnessIndex != null) {
      $result.clearnessIndex = clearnessIndex;
    }
    return $result;
  }
  DHIRequest._() : super();
  factory DHIRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DHIRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DHIRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'zenithAngleDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'clearnessIndex', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DHIRequest clone() => DHIRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DHIRequest copyWith(void Function(DHIRequest) updates) => super.copyWith((message) => updates(message as DHIRequest)) as DHIRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DHIRequest create() => DHIRequest._();
  DHIRequest createEmptyInstance() => create();
  static $pb.PbList<DHIRequest> createRepeated() => $pb.PbList<DHIRequest>();
  @$core.pragma('dart2js:noInline')
  static DHIRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DHIRequest>(create);
  static DHIRequest? _defaultInstance;

  /// Sun zenith angle (0-90 degrees).
  @$pb.TagNumber(1)
  $core.double get zenithAngleDeg => $_getN(0);
  @$pb.TagNumber(1)
  set zenithAngleDeg($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasZenithAngleDeg() => $_has(0);
  @$pb.TagNumber(1)
  void clearZenithAngleDeg() => $_clearField(1);

  /// Clearness index empirical factor (0-1).
  @$pb.TagNumber(2)
  $core.double get clearnessIndex => $_getN(1);
  @$pb.TagNumber(2)
  set clearnessIndex($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasClearnessIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearClearnessIndex() => $_clearField(2);
}

class DHIResponse extends $pb.GeneratedMessage {
  factory DHIResponse({
    $core.double? dhiWM2,
    $core.bool? valid,
  }) {
    final $result = create();
    if (dhiWM2 != null) {
      $result.dhiWM2 = dhiWM2;
    }
    if (valid != null) {
      $result.valid = valid;
    }
    return $result;
  }
  DHIResponse._() : super();
  factory DHIResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DHIResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DHIResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'dhiWM2', $pb.PbFieldType.OD)
    ..aOB(2, _omitFieldNames ? '' : 'valid')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DHIResponse clone() => DHIResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DHIResponse copyWith(void Function(DHIResponse) updates) => super.copyWith((message) => updates(message as DHIResponse)) as DHIResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DHIResponse create() => DHIResponse._();
  DHIResponse createEmptyInstance() => create();
  static $pb.PbList<DHIResponse> createRepeated() => $pb.PbList<DHIResponse>();
  @$core.pragma('dart2js:noInline')
  static DHIResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DHIResponse>(create);
  static DHIResponse? _defaultInstance;

  /// Diffuse horizontal irradiance (W/m²).
  @$pb.TagNumber(1)
  $core.double get dhiWM2 => $_getN(0);
  @$pb.TagNumber(1)
  set dhiWM2($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDhiWM2() => $_has(0);
  @$pb.TagNumber(1)
  void clearDhiWM2() => $_clearField(1);

  /// True if calculation succeeded.
  @$pb.TagNumber(2)
  $core.bool get valid => $_getBF(1);
  @$pb.TagNumber(2)
  set valid($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasValid() => $_has(1);
  @$pb.TagNumber(2)
  void clearValid() => $_clearField(2);
}

class TimestampPosition extends $pb.GeneratedMessage {
  factory TimestampPosition({
    $core.double? timestampSeconds,
    SolarPosition? position,
  }) {
    final $result = create();
    if (timestampSeconds != null) {
      $result.timestampSeconds = timestampSeconds;
    }
    if (position != null) {
      $result.position = position;
    }
    return $result;
  }
  TimestampPosition._() : super();
  factory TimestampPosition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TimestampPosition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TimestampPosition', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'timestampSeconds', $pb.PbFieldType.OD)
    ..aOM<SolarPosition>(2, _omitFieldNames ? '' : 'position', subBuilder: SolarPosition.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TimestampPosition clone() => TimestampPosition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TimestampPosition copyWith(void Function(TimestampPosition) updates) => super.copyWith((message) => updates(message as TimestampPosition)) as TimestampPosition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TimestampPosition create() => TimestampPosition._();
  TimestampPosition createEmptyInstance() => create();
  static $pb.PbList<TimestampPosition> createRepeated() => $pb.PbList<TimestampPosition>();
  @$core.pragma('dart2js:noInline')
  static TimestampPosition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TimestampPosition>(create);
  static TimestampPosition? _defaultInstance;

  /// Input timestamp.
  @$pb.TagNumber(1)
  $core.double get timestampSeconds => $_getN(0);
  @$pb.TagNumber(1)
  set timestampSeconds($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTimestampSeconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestampSeconds() => $_clearField(1);

  /// Computed solar position.
  @$pb.TagNumber(2)
  SolarPosition get position => $_getN(1);
  @$pb.TagNumber(2)
  set position(SolarPosition v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearPosition() => $_clearField(2);
  @$pb.TagNumber(2)
  SolarPosition ensurePosition() => $_ensure(1);
}

class BulkSolarPositionRequest extends $pb.GeneratedMessage {
  factory BulkSolarPositionRequest({
    $core.Iterable<$core.double>? timestampSeconds,
    $core.double? latitudeDeg,
    $core.double? longitudeDeg,
    $core.double? utcOffsetHours,
  }) {
    final $result = create();
    if (timestampSeconds != null) {
      $result.timestampSeconds.addAll(timestampSeconds);
    }
    if (latitudeDeg != null) {
      $result.latitudeDeg = latitudeDeg;
    }
    if (longitudeDeg != null) {
      $result.longitudeDeg = longitudeDeg;
    }
    if (utcOffsetHours != null) {
      $result.utcOffsetHours = utcOffsetHours;
    }
    return $result;
  }
  BulkSolarPositionRequest._() : super();
  factory BulkSolarPositionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BulkSolarPositionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BulkSolarPositionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'timestampSeconds', $pb.PbFieldType.KD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'latitudeDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'longitudeDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'utcOffsetHours', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BulkSolarPositionRequest clone() => BulkSolarPositionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BulkSolarPositionRequest copyWith(void Function(BulkSolarPositionRequest) updates) => super.copyWith((message) => updates(message as BulkSolarPositionRequest)) as BulkSolarPositionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BulkSolarPositionRequest create() => BulkSolarPositionRequest._();
  BulkSolarPositionRequest createEmptyInstance() => create();
  static $pb.PbList<BulkSolarPositionRequest> createRepeated() => $pb.PbList<BulkSolarPositionRequest>();
  @$core.pragma('dart2js:noInline')
  static BulkSolarPositionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BulkSolarPositionRequest>(create);
  static BulkSolarPositionRequest? _defaultInstance;

  /// Timestamps to compute (must be sorted).
  @$pb.TagNumber(1)
  $pb.PbList<$core.double> get timestampSeconds => $_getList(0);

  /// Observer latitude (degrees).
  @$pb.TagNumber(2)
  $core.double get latitudeDeg => $_getN(1);
  @$pb.TagNumber(2)
  set latitudeDeg($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLatitudeDeg() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatitudeDeg() => $_clearField(2);

  /// Observer longitude (degrees).
  @$pb.TagNumber(3)
  $core.double get longitudeDeg => $_getN(2);
  @$pb.TagNumber(3)
  set longitudeDeg($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLongitudeDeg() => $_has(2);
  @$pb.TagNumber(3)
  void clearLongitudeDeg() => $_clearField(3);

  /// UTC offset hours.
  @$pb.TagNumber(4)
  $core.double get utcOffsetHours => $_getN(3);
  @$pb.TagNumber(4)
  set utcOffsetHours($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUtcOffsetHours() => $_has(3);
  @$pb.TagNumber(4)
  void clearUtcOffsetHours() => $_clearField(4);
}

class BulkSolarPositionResponse extends $pb.GeneratedMessage {
  factory BulkSolarPositionResponse({
    $core.Iterable<TimestampPosition>? results,
    $core.int? nightCount,
    $0.ContractMetadata? contract,
  }) {
    final $result = create();
    if (results != null) {
      $result.results.addAll(results);
    }
    if (nightCount != null) {
      $result.nightCount = nightCount;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  BulkSolarPositionResponse._() : super();
  factory BulkSolarPositionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BulkSolarPositionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BulkSolarPositionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'solar.v1'), createEmptyInstance: create)
    ..pc<TimestampPosition>(1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM, subBuilder: TimestampPosition.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'nightCount', $pb.PbFieldType.O3)
    ..aOM<$0.ContractMetadata>(10, _omitFieldNames ? '' : 'contract', subBuilder: $0.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BulkSolarPositionResponse clone() => BulkSolarPositionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BulkSolarPositionResponse copyWith(void Function(BulkSolarPositionResponse) updates) => super.copyWith((message) => updates(message as BulkSolarPositionResponse)) as BulkSolarPositionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BulkSolarPositionResponse create() => BulkSolarPositionResponse._();
  BulkSolarPositionResponse createEmptyInstance() => create();
  static $pb.PbList<BulkSolarPositionResponse> createRepeated() => $pb.PbList<BulkSolarPositionResponse>();
  @$core.pragma('dart2js:noInline')
  static BulkSolarPositionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BulkSolarPositionResponse>(create);
  static BulkSolarPositionResponse? _defaultInstance;

  /// Positions in same order as request timestamps.
  @$pb.TagNumber(1)
  $pb.PbList<TimestampPosition> get results => $_getList(0);

  /// Count of night timestamps (sun below horizon).
  @$pb.TagNumber(2)
  $core.int get nightCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set nightCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNightCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearNightCount() => $_clearField(2);

  /// Contract metadata.
  @$pb.TagNumber(10)
  $0.ContractMetadata get contract => $_getN(2);
  @$pb.TagNumber(10)
  set contract($0.ContractMetadata v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasContract() => $_has(2);
  @$pb.TagNumber(10)
  void clearContract() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.ContractMetadata ensureContract() => $_ensure(2);
}

/// SolarService exposes solar position, irradiance, and shadow algorithms.
class SolarServiceApi {
  $pb.RpcClient _client;
  SolarServiceApi(this._client);

  /// CalculateSolarPosition computes elevation and azimuth angles.
  $async.Future<SolarPositionResponse> calculateSolarPosition($pb.ClientContext? ctx, SolarPositionRequest request) =>
    _client.invoke<SolarPositionResponse>(ctx, 'SolarService', 'CalculateSolarPosition', request, SolarPositionResponse())
  ;
  /// CastShadows projects shadows from obstacles given sun position.
  $async.Future<CastShadowsResponse> castShadows($pb.ClientContext? ctx, CastShadowsRequest request) =>
    _client.invoke<CastShadowsResponse>(ctx, 'SolarService', 'CastShadows', request, CastShadowsResponse())
  ;
  /// CalculateDNI computes direct normal irradiance.
  $async.Future<DNIResponse> calculateDNI($pb.ClientContext? ctx, DNIRequest request) =>
    _client.invoke<DNIResponse>(ctx, 'SolarService', 'CalculateDNI', request, DNIResponse())
  ;
  /// CalculateDHI computes diffuse horizontal irradiance.
  $async.Future<DHIResponse> calculateDHI($pb.ClientContext? ctx, DHIRequest request) =>
    _client.invoke<DHIResponse>(ctx, 'SolarService', 'CalculateDHI', request, DHIResponse())
  ;
  /// BulkSolarPosition computes positions for multiple timestamps (optimized).
  $async.Future<BulkSolarPositionResponse> bulkSolarPosition($pb.ClientContext? ctx, BulkSolarPositionRequest request) =>
    _client.invoke<BulkSolarPositionResponse>(ctx, 'SolarService', 'BulkSolarPosition', request, BulkSolarPositionResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
