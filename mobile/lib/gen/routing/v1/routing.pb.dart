//
//  Generated code. Do not modify.
//  source: routing/v1/routing.proto
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
import '../../packages/pagination.pb.dart' as $1;
import 'routing.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'routing.pbenum.dart';

class Route extends $pb.GeneratedMessage {
  factory Route({
    $core.String? id,
    $core.String? projectId,
    RouteType? routeType,
    $core.String? name,
    $core.String? geometryGeojson,
    $core.double? distanceM,
    $core.double? costEstimate,
    RouteMetadata? metadata,
    $0.Timestamp? createdAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (routeType != null) {
      $result.routeType = routeType;
    }
    if (name != null) {
      $result.name = name;
    }
    if (geometryGeojson != null) {
      $result.geometryGeojson = geometryGeojson;
    }
    if (distanceM != null) {
      $result.distanceM = distanceM;
    }
    if (costEstimate != null) {
      $result.costEstimate = costEstimate;
    }
    if (metadata != null) {
      $result.metadata = metadata;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  Route._() : super();
  factory Route.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Route.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Route', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..e<RouteType>(3, _omitFieldNames ? '' : 'routeType', $pb.PbFieldType.OE, defaultOrMaker: RouteType.ROUTE_TYPE_UNSPECIFIED, valueOf: RouteType.valueOf, enumValues: RouteType.values)
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'geometryGeojson')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'distanceM', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'costEstimate', $pb.PbFieldType.OD)
    ..aOM<RouteMetadata>(8, _omitFieldNames ? '' : 'metadata', subBuilder: RouteMetadata.create)
    ..aOM<$0.Timestamp>(9, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Route clone() => Route()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Route copyWith(void Function(Route) updates) => super.copyWith((message) => updates(message as Route)) as Route;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Route create() => Route._();
  Route createEmptyInstance() => create();
  static $pb.PbList<Route> createRepeated() => $pb.PbList<Route>();
  @$core.pragma('dart2js:noInline')
  static Route getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Route>(create);
  static Route? _defaultInstance;

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
  RouteType get routeType => $_getN(2);
  @$pb.TagNumber(3)
  set routeType(RouteType v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRouteType() => $_has(2);
  @$pb.TagNumber(3)
  void clearRouteType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  /// GeoJSON LineString
  @$pb.TagNumber(5)
  $core.String get geometryGeojson => $_getSZ(4);
  @$pb.TagNumber(5)
  set geometryGeojson($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasGeometryGeojson() => $_has(4);
  @$pb.TagNumber(5)
  void clearGeometryGeojson() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get distanceM => $_getN(5);
  @$pb.TagNumber(6)
  set distanceM($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDistanceM() => $_has(5);
  @$pb.TagNumber(6)
  void clearDistanceM() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get costEstimate => $_getN(6);
  @$pb.TagNumber(7)
  set costEstimate($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCostEstimate() => $_has(6);
  @$pb.TagNumber(7)
  void clearCostEstimate() => $_clearField(7);

  @$pb.TagNumber(8)
  RouteMetadata get metadata => $_getN(7);
  @$pb.TagNumber(8)
  set metadata(RouteMetadata v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasMetadata() => $_has(7);
  @$pb.TagNumber(8)
  void clearMetadata() => $_clearField(8);
  @$pb.TagNumber(8)
  RouteMetadata ensureMetadata() => $_ensure(7);

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
}

class RouteMetadata extends $pb.GeneratedMessage {
  factory RouteMetadata({
    $core.String? cableType,
    $core.double? cableSizeMm2,
    $core.double? voltageDropPercent,
    $core.double? maxSlopePercent,
  }) {
    final $result = create();
    if (cableType != null) {
      $result.cableType = cableType;
    }
    if (cableSizeMm2 != null) {
      $result.cableSizeMm2 = cableSizeMm2;
    }
    if (voltageDropPercent != null) {
      $result.voltageDropPercent = voltageDropPercent;
    }
    if (maxSlopePercent != null) {
      $result.maxSlopePercent = maxSlopePercent;
    }
    return $result;
  }
  RouteMetadata._() : super();
  factory RouteMetadata.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RouteMetadata.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RouteMetadata', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'cableType')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'cableSizeMm2', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'voltageDropPercent', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'maxSlopePercent', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RouteMetadata clone() => RouteMetadata()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RouteMetadata copyWith(void Function(RouteMetadata) updates) => super.copyWith((message) => updates(message as RouteMetadata)) as RouteMetadata;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RouteMetadata create() => RouteMetadata._();
  RouteMetadata createEmptyInstance() => create();
  static $pb.PbList<RouteMetadata> createRepeated() => $pb.PbList<RouteMetadata>();
  @$core.pragma('dart2js:noInline')
  static RouteMetadata getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RouteMetadata>(create);
  static RouteMetadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cableType => $_getSZ(0);
  @$pb.TagNumber(1)
  set cableType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCableType() => $_has(0);
  @$pb.TagNumber(1)
  void clearCableType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get cableSizeMm2 => $_getN(1);
  @$pb.TagNumber(2)
  set cableSizeMm2($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCableSizeMm2() => $_has(1);
  @$pb.TagNumber(2)
  void clearCableSizeMm2() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get voltageDropPercent => $_getN(2);
  @$pb.TagNumber(3)
  set voltageDropPercent($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVoltageDropPercent() => $_has(2);
  @$pb.TagNumber(3)
  void clearVoltageDropPercent() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get maxSlopePercent => $_getN(3);
  @$pb.TagNumber(4)
  set maxSlopePercent($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMaxSlopePercent() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxSlopePercent() => $_clearField(4);
}

class Waypoint extends $pb.GeneratedMessage {
  factory Waypoint({
    $core.double? longitude,
    $core.double? latitude,
    $core.double? elevation,
  }) {
    final $result = create();
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (elevation != null) {
      $result.elevation = elevation;
    }
    return $result;
  }
  Waypoint._() : super();
  factory Waypoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Waypoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Waypoint', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'elevation', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Waypoint clone() => Waypoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Waypoint copyWith(void Function(Waypoint) updates) => super.copyWith((message) => updates(message as Waypoint)) as Waypoint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Waypoint create() => Waypoint._();
  Waypoint createEmptyInstance() => create();
  static $pb.PbList<Waypoint> createRepeated() => $pb.PbList<Waypoint>();
  @$core.pragma('dart2js:noInline')
  static Waypoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Waypoint>(create);
  static Waypoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get longitude => $_getN(0);
  @$pb.TagNumber(1)
  set longitude($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLongitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLongitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get latitude => $_getN(1);
  @$pb.TagNumber(2)
  set latitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLatitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get elevation => $_getN(2);
  @$pb.TagNumber(3)
  set elevation($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasElevation() => $_has(2);
  @$pb.TagNumber(3)
  void clearElevation() => $_clearField(3);
}

class RouteConstraints extends $pb.GeneratedMessage {
  factory RouteConstraints({
    $core.double? maxSlopePercent,
    $core.bool? avoidWater,
    $core.Iterable<$core.String>? avoidZoneGeojsons,
    $core.double? terrainSlopePenalty,
  }) {
    final $result = create();
    if (maxSlopePercent != null) {
      $result.maxSlopePercent = maxSlopePercent;
    }
    if (avoidWater != null) {
      $result.avoidWater = avoidWater;
    }
    if (avoidZoneGeojsons != null) {
      $result.avoidZoneGeojsons.addAll(avoidZoneGeojsons);
    }
    if (terrainSlopePenalty != null) {
      $result.terrainSlopePenalty = terrainSlopePenalty;
    }
    return $result;
  }
  RouteConstraints._() : super();
  factory RouteConstraints.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RouteConstraints.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RouteConstraints', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'maxSlopePercent', $pb.PbFieldType.OD)
    ..aOB(2, _omitFieldNames ? '' : 'avoidWater')
    ..pPS(3, _omitFieldNames ? '' : 'avoidZoneGeojsons')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'terrainSlopePenalty', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RouteConstraints clone() => RouteConstraints()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RouteConstraints copyWith(void Function(RouteConstraints) updates) => super.copyWith((message) => updates(message as RouteConstraints)) as RouteConstraints;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RouteConstraints create() => RouteConstraints._();
  RouteConstraints createEmptyInstance() => create();
  static $pb.PbList<RouteConstraints> createRepeated() => $pb.PbList<RouteConstraints>();
  @$core.pragma('dart2js:noInline')
  static RouteConstraints getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RouteConstraints>(create);
  static RouteConstraints? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get maxSlopePercent => $_getN(0);
  @$pb.TagNumber(1)
  set maxSlopePercent($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMaxSlopePercent() => $_has(0);
  @$pb.TagNumber(1)
  void clearMaxSlopePercent() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get avoidWater => $_getBF(1);
  @$pb.TagNumber(2)
  set avoidWater($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAvoidWater() => $_has(1);
  @$pb.TagNumber(2)
  void clearAvoidWater() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get avoidZoneGeojsons => $_getList(2);

  @$pb.TagNumber(4)
  $core.double get terrainSlopePenalty => $_getN(3);
  @$pb.TagNumber(4)
  set terrainSlopePenalty($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTerrainSlopePenalty() => $_has(3);
  @$pb.TagNumber(4)
  void clearTerrainSlopePenalty() => $_clearField(4);
}

class CreateRouteRequest extends $pb.GeneratedMessage {
  factory CreateRouteRequest({
    $core.String? projectId,
    $core.String? name,
    RouteType? routeType,
    $core.String? geometryGeojson,
    $core.double? distanceM,
    $core.double? costEstimate,
    RouteMetadata? metadata,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (routeType != null) {
      $result.routeType = routeType;
    }
    if (geometryGeojson != null) {
      $result.geometryGeojson = geometryGeojson;
    }
    if (distanceM != null) {
      $result.distanceM = distanceM;
    }
    if (costEstimate != null) {
      $result.costEstimate = costEstimate;
    }
    if (metadata != null) {
      $result.metadata = metadata;
    }
    return $result;
  }
  CreateRouteRequest._() : super();
  factory CreateRouteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRouteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateRouteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..e<RouteType>(3, _omitFieldNames ? '' : 'routeType', $pb.PbFieldType.OE, defaultOrMaker: RouteType.ROUTE_TYPE_UNSPECIFIED, valueOf: RouteType.valueOf, enumValues: RouteType.values)
    ..aOS(4, _omitFieldNames ? '' : 'geometryGeojson')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'distanceM', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'costEstimate', $pb.PbFieldType.OD)
    ..aOM<RouteMetadata>(7, _omitFieldNames ? '' : 'metadata', subBuilder: RouteMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateRouteRequest clone() => CreateRouteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateRouteRequest copyWith(void Function(CreateRouteRequest) updates) => super.copyWith((message) => updates(message as CreateRouteRequest)) as CreateRouteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRouteRequest create() => CreateRouteRequest._();
  CreateRouteRequest createEmptyInstance() => create();
  static $pb.PbList<CreateRouteRequest> createRepeated() => $pb.PbList<CreateRouteRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateRouteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRouteRequest>(create);
  static CreateRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  RouteType get routeType => $_getN(2);
  @$pb.TagNumber(3)
  set routeType(RouteType v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRouteType() => $_has(2);
  @$pb.TagNumber(3)
  void clearRouteType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get geometryGeojson => $_getSZ(3);
  @$pb.TagNumber(4)
  set geometryGeojson($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasGeometryGeojson() => $_has(3);
  @$pb.TagNumber(4)
  void clearGeometryGeojson() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get distanceM => $_getN(4);
  @$pb.TagNumber(5)
  set distanceM($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDistanceM() => $_has(4);
  @$pb.TagNumber(5)
  void clearDistanceM() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get costEstimate => $_getN(5);
  @$pb.TagNumber(6)
  set costEstimate($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCostEstimate() => $_has(5);
  @$pb.TagNumber(6)
  void clearCostEstimate() => $_clearField(6);

  @$pb.TagNumber(7)
  RouteMetadata get metadata => $_getN(6);
  @$pb.TagNumber(7)
  set metadata(RouteMetadata v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasMetadata() => $_has(6);
  @$pb.TagNumber(7)
  void clearMetadata() => $_clearField(7);
  @$pb.TagNumber(7)
  RouteMetadata ensureMetadata() => $_ensure(6);
}

class CreateRouteResponse extends $pb.GeneratedMessage {
  factory CreateRouteResponse({
    Route? route,
  }) {
    final $result = create();
    if (route != null) {
      $result.route = route;
    }
    return $result;
  }
  CreateRouteResponse._() : super();
  factory CreateRouteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRouteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateRouteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOM<Route>(1, _omitFieldNames ? '' : 'route', subBuilder: Route.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateRouteResponse clone() => CreateRouteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateRouteResponse copyWith(void Function(CreateRouteResponse) updates) => super.copyWith((message) => updates(message as CreateRouteResponse)) as CreateRouteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRouteResponse create() => CreateRouteResponse._();
  CreateRouteResponse createEmptyInstance() => create();
  static $pb.PbList<CreateRouteResponse> createRepeated() => $pb.PbList<CreateRouteResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateRouteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRouteResponse>(create);
  static CreateRouteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Route get route => $_getN(0);
  @$pb.TagNumber(1)
  set route(Route v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoute() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoute() => $_clearField(1);
  @$pb.TagNumber(1)
  Route ensureRoute() => $_ensure(0);
}

class GetRouteRequest extends $pb.GeneratedMessage {
  factory GetRouteRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetRouteRequest._() : super();
  factory GetRouteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetRouteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetRouteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetRouteRequest clone() => GetRouteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetRouteRequest copyWith(void Function(GetRouteRequest) updates) => super.copyWith((message) => updates(message as GetRouteRequest)) as GetRouteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRouteRequest create() => GetRouteRequest._();
  GetRouteRequest createEmptyInstance() => create();
  static $pb.PbList<GetRouteRequest> createRepeated() => $pb.PbList<GetRouteRequest>();
  @$core.pragma('dart2js:noInline')
  static GetRouteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetRouteRequest>(create);
  static GetRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetRouteResponse extends $pb.GeneratedMessage {
  factory GetRouteResponse({
    Route? route,
  }) {
    final $result = create();
    if (route != null) {
      $result.route = route;
    }
    return $result;
  }
  GetRouteResponse._() : super();
  factory GetRouteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetRouteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetRouteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOM<Route>(1, _omitFieldNames ? '' : 'route', subBuilder: Route.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetRouteResponse clone() => GetRouteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetRouteResponse copyWith(void Function(GetRouteResponse) updates) => super.copyWith((message) => updates(message as GetRouteResponse)) as GetRouteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetRouteResponse create() => GetRouteResponse._();
  GetRouteResponse createEmptyInstance() => create();
  static $pb.PbList<GetRouteResponse> createRepeated() => $pb.PbList<GetRouteResponse>();
  @$core.pragma('dart2js:noInline')
  static GetRouteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetRouteResponse>(create);
  static GetRouteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Route get route => $_getN(0);
  @$pb.TagNumber(1)
  set route(Route v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoute() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoute() => $_clearField(1);
  @$pb.TagNumber(1)
  Route ensureRoute() => $_ensure(0);
}

class CalculateRouteRequest extends $pb.GeneratedMessage {
  factory CalculateRouteRequest({
    $core.String? projectId,
    Waypoint? source,
    Waypoint? destination,
    RouteType? routeType,
    RouteConstraints? constraints,
    $core.String? terrainLayerId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (source != null) {
      $result.source = source;
    }
    if (destination != null) {
      $result.destination = destination;
    }
    if (routeType != null) {
      $result.routeType = routeType;
    }
    if (constraints != null) {
      $result.constraints = constraints;
    }
    if (terrainLayerId != null) {
      $result.terrainLayerId = terrainLayerId;
    }
    return $result;
  }
  CalculateRouteRequest._() : super();
  factory CalculateRouteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateRouteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateRouteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<Waypoint>(2, _omitFieldNames ? '' : 'source', subBuilder: Waypoint.create)
    ..aOM<Waypoint>(3, _omitFieldNames ? '' : 'destination', subBuilder: Waypoint.create)
    ..e<RouteType>(4, _omitFieldNames ? '' : 'routeType', $pb.PbFieldType.OE, defaultOrMaker: RouteType.ROUTE_TYPE_UNSPECIFIED, valueOf: RouteType.valueOf, enumValues: RouteType.values)
    ..aOM<RouteConstraints>(5, _omitFieldNames ? '' : 'constraints', subBuilder: RouteConstraints.create)
    ..aOS(6, _omitFieldNames ? '' : 'terrainLayerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateRouteRequest clone() => CalculateRouteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateRouteRequest copyWith(void Function(CalculateRouteRequest) updates) => super.copyWith((message) => updates(message as CalculateRouteRequest)) as CalculateRouteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateRouteRequest create() => CalculateRouteRequest._();
  CalculateRouteRequest createEmptyInstance() => create();
  static $pb.PbList<CalculateRouteRequest> createRepeated() => $pb.PbList<CalculateRouteRequest>();
  @$core.pragma('dart2js:noInline')
  static CalculateRouteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateRouteRequest>(create);
  static CalculateRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  Waypoint get source => $_getN(1);
  @$pb.TagNumber(2)
  set source(Waypoint v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => $_clearField(2);
  @$pb.TagNumber(2)
  Waypoint ensureSource() => $_ensure(1);

  @$pb.TagNumber(3)
  Waypoint get destination => $_getN(2);
  @$pb.TagNumber(3)
  set destination(Waypoint v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDestination() => $_has(2);
  @$pb.TagNumber(3)
  void clearDestination() => $_clearField(3);
  @$pb.TagNumber(3)
  Waypoint ensureDestination() => $_ensure(2);

  @$pb.TagNumber(4)
  RouteType get routeType => $_getN(3);
  @$pb.TagNumber(4)
  set routeType(RouteType v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasRouteType() => $_has(3);
  @$pb.TagNumber(4)
  void clearRouteType() => $_clearField(4);

  @$pb.TagNumber(5)
  RouteConstraints get constraints => $_getN(4);
  @$pb.TagNumber(5)
  set constraints(RouteConstraints v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasConstraints() => $_has(4);
  @$pb.TagNumber(5)
  void clearConstraints() => $_clearField(5);
  @$pb.TagNumber(5)
  RouteConstraints ensureConstraints() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get terrainLayerId => $_getSZ(5);
  @$pb.TagNumber(6)
  set terrainLayerId($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTerrainLayerId() => $_has(5);
  @$pb.TagNumber(6)
  void clearTerrainLayerId() => $_clearField(6);
}

class CalculateRouteResponse extends $pb.GeneratedMessage {
  factory CalculateRouteResponse({
    $core.Iterable<Waypoint>? waypoints,
    $core.double? distanceM,
    $core.double? costEstimate,
    $core.double? maxSlopeEncountered,
  }) {
    final $result = create();
    if (waypoints != null) {
      $result.waypoints.addAll(waypoints);
    }
    if (distanceM != null) {
      $result.distanceM = distanceM;
    }
    if (costEstimate != null) {
      $result.costEstimate = costEstimate;
    }
    if (maxSlopeEncountered != null) {
      $result.maxSlopeEncountered = maxSlopeEncountered;
    }
    return $result;
  }
  CalculateRouteResponse._() : super();
  factory CalculateRouteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CalculateRouteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CalculateRouteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..pc<Waypoint>(1, _omitFieldNames ? '' : 'waypoints', $pb.PbFieldType.PM, subBuilder: Waypoint.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'distanceM', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'costEstimate', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'maxSlopeEncountered', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CalculateRouteResponse clone() => CalculateRouteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CalculateRouteResponse copyWith(void Function(CalculateRouteResponse) updates) => super.copyWith((message) => updates(message as CalculateRouteResponse)) as CalculateRouteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CalculateRouteResponse create() => CalculateRouteResponse._();
  CalculateRouteResponse createEmptyInstance() => create();
  static $pb.PbList<CalculateRouteResponse> createRepeated() => $pb.PbList<CalculateRouteResponse>();
  @$core.pragma('dart2js:noInline')
  static CalculateRouteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CalculateRouteResponse>(create);
  static CalculateRouteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Waypoint> get waypoints => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get distanceM => $_getN(1);
  @$pb.TagNumber(2)
  set distanceM($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDistanceM() => $_has(1);
  @$pb.TagNumber(2)
  void clearDistanceM() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get costEstimate => $_getN(2);
  @$pb.TagNumber(3)
  set costEstimate($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCostEstimate() => $_has(2);
  @$pb.TagNumber(3)
  void clearCostEstimate() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get maxSlopeEncountered => $_getN(3);
  @$pb.TagNumber(4)
  set maxSlopeEncountered($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMaxSlopeEncountered() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxSlopeEncountered() => $_clearField(4);
}

class CreateCableRouteRequest extends $pb.GeneratedMessage {
  factory CreateCableRouteRequest({
    $core.String? projectId,
    $core.String? name,
    Waypoint? source,
    Waypoint? destination,
    $core.String? cableType,
    $core.double? cableSizeMm2,
    RouteConstraints? constraints,
    $core.String? terrainLayerId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (source != null) {
      $result.source = source;
    }
    if (destination != null) {
      $result.destination = destination;
    }
    if (cableType != null) {
      $result.cableType = cableType;
    }
    if (cableSizeMm2 != null) {
      $result.cableSizeMm2 = cableSizeMm2;
    }
    if (constraints != null) {
      $result.constraints = constraints;
    }
    if (terrainLayerId != null) {
      $result.terrainLayerId = terrainLayerId;
    }
    return $result;
  }
  CreateCableRouteRequest._() : super();
  factory CreateCableRouteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateCableRouteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateCableRouteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<Waypoint>(3, _omitFieldNames ? '' : 'source', subBuilder: Waypoint.create)
    ..aOM<Waypoint>(4, _omitFieldNames ? '' : 'destination', subBuilder: Waypoint.create)
    ..aOS(5, _omitFieldNames ? '' : 'cableType')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'cableSizeMm2', $pb.PbFieldType.OD)
    ..aOM<RouteConstraints>(7, _omitFieldNames ? '' : 'constraints', subBuilder: RouteConstraints.create)
    ..aOS(8, _omitFieldNames ? '' : 'terrainLayerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateCableRouteRequest clone() => CreateCableRouteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateCableRouteRequest copyWith(void Function(CreateCableRouteRequest) updates) => super.copyWith((message) => updates(message as CreateCableRouteRequest)) as CreateCableRouteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateCableRouteRequest create() => CreateCableRouteRequest._();
  CreateCableRouteRequest createEmptyInstance() => create();
  static $pb.PbList<CreateCableRouteRequest> createRepeated() => $pb.PbList<CreateCableRouteRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateCableRouteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateCableRouteRequest>(create);
  static CreateCableRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  Waypoint get source => $_getN(2);
  @$pb.TagNumber(3)
  set source(Waypoint v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);
  @$pb.TagNumber(3)
  Waypoint ensureSource() => $_ensure(2);

  @$pb.TagNumber(4)
  Waypoint get destination => $_getN(3);
  @$pb.TagNumber(4)
  set destination(Waypoint v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasDestination() => $_has(3);
  @$pb.TagNumber(4)
  void clearDestination() => $_clearField(4);
  @$pb.TagNumber(4)
  Waypoint ensureDestination() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get cableType => $_getSZ(4);
  @$pb.TagNumber(5)
  set cableType($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCableType() => $_has(4);
  @$pb.TagNumber(5)
  void clearCableType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get cableSizeMm2 => $_getN(5);
  @$pb.TagNumber(6)
  set cableSizeMm2($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCableSizeMm2() => $_has(5);
  @$pb.TagNumber(6)
  void clearCableSizeMm2() => $_clearField(6);

  @$pb.TagNumber(7)
  RouteConstraints get constraints => $_getN(6);
  @$pb.TagNumber(7)
  set constraints(RouteConstraints v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasConstraints() => $_has(6);
  @$pb.TagNumber(7)
  void clearConstraints() => $_clearField(7);
  @$pb.TagNumber(7)
  RouteConstraints ensureConstraints() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get terrainLayerId => $_getSZ(7);
  @$pb.TagNumber(8)
  set terrainLayerId($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasTerrainLayerId() => $_has(7);
  @$pb.TagNumber(8)
  void clearTerrainLayerId() => $_clearField(8);
}

class CreateCableRouteResponse extends $pb.GeneratedMessage {
  factory CreateCableRouteResponse({
    Route? route,
  }) {
    final $result = create();
    if (route != null) {
      $result.route = route;
    }
    return $result;
  }
  CreateCableRouteResponse._() : super();
  factory CreateCableRouteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateCableRouteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateCableRouteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOM<Route>(1, _omitFieldNames ? '' : 'route', subBuilder: Route.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateCableRouteResponse clone() => CreateCableRouteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateCableRouteResponse copyWith(void Function(CreateCableRouteResponse) updates) => super.copyWith((message) => updates(message as CreateCableRouteResponse)) as CreateCableRouteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateCableRouteResponse create() => CreateCableRouteResponse._();
  CreateCableRouteResponse createEmptyInstance() => create();
  static $pb.PbList<CreateCableRouteResponse> createRepeated() => $pb.PbList<CreateCableRouteResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateCableRouteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateCableRouteResponse>(create);
  static CreateCableRouteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Route get route => $_getN(0);
  @$pb.TagNumber(1)
  set route(Route v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoute() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoute() => $_clearField(1);
  @$pb.TagNumber(1)
  Route ensureRoute() => $_ensure(0);
}

class CreateRoadRouteRequest extends $pb.GeneratedMessage {
  factory CreateRoadRouteRequest({
    $core.String? projectId,
    $core.String? name,
    Waypoint? source,
    Waypoint? destination,
    $core.double? roadWidthM,
    RouteConstraints? constraints,
    $core.String? terrainLayerId,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (source != null) {
      $result.source = source;
    }
    if (destination != null) {
      $result.destination = destination;
    }
    if (roadWidthM != null) {
      $result.roadWidthM = roadWidthM;
    }
    if (constraints != null) {
      $result.constraints = constraints;
    }
    if (terrainLayerId != null) {
      $result.terrainLayerId = terrainLayerId;
    }
    return $result;
  }
  CreateRoadRouteRequest._() : super();
  factory CreateRoadRouteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRoadRouteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateRoadRouteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<Waypoint>(3, _omitFieldNames ? '' : 'source', subBuilder: Waypoint.create)
    ..aOM<Waypoint>(4, _omitFieldNames ? '' : 'destination', subBuilder: Waypoint.create)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'roadWidthM', $pb.PbFieldType.OD)
    ..aOM<RouteConstraints>(6, _omitFieldNames ? '' : 'constraints', subBuilder: RouteConstraints.create)
    ..aOS(7, _omitFieldNames ? '' : 'terrainLayerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateRoadRouteRequest clone() => CreateRoadRouteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateRoadRouteRequest copyWith(void Function(CreateRoadRouteRequest) updates) => super.copyWith((message) => updates(message as CreateRoadRouteRequest)) as CreateRoadRouteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoadRouteRequest create() => CreateRoadRouteRequest._();
  CreateRoadRouteRequest createEmptyInstance() => create();
  static $pb.PbList<CreateRoadRouteRequest> createRepeated() => $pb.PbList<CreateRoadRouteRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateRoadRouteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRoadRouteRequest>(create);
  static CreateRoadRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  Waypoint get source => $_getN(2);
  @$pb.TagNumber(3)
  set source(Waypoint v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSource() => $_has(2);
  @$pb.TagNumber(3)
  void clearSource() => $_clearField(3);
  @$pb.TagNumber(3)
  Waypoint ensureSource() => $_ensure(2);

  @$pb.TagNumber(4)
  Waypoint get destination => $_getN(3);
  @$pb.TagNumber(4)
  set destination(Waypoint v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasDestination() => $_has(3);
  @$pb.TagNumber(4)
  void clearDestination() => $_clearField(4);
  @$pb.TagNumber(4)
  Waypoint ensureDestination() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.double get roadWidthM => $_getN(4);
  @$pb.TagNumber(5)
  set roadWidthM($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasRoadWidthM() => $_has(4);
  @$pb.TagNumber(5)
  void clearRoadWidthM() => $_clearField(5);

  @$pb.TagNumber(6)
  RouteConstraints get constraints => $_getN(5);
  @$pb.TagNumber(6)
  set constraints(RouteConstraints v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasConstraints() => $_has(5);
  @$pb.TagNumber(6)
  void clearConstraints() => $_clearField(6);
  @$pb.TagNumber(6)
  RouteConstraints ensureConstraints() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get terrainLayerId => $_getSZ(6);
  @$pb.TagNumber(7)
  set terrainLayerId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTerrainLayerId() => $_has(6);
  @$pb.TagNumber(7)
  void clearTerrainLayerId() => $_clearField(7);
}

class CreateRoadRouteResponse extends $pb.GeneratedMessage {
  factory CreateRoadRouteResponse({
    Route? route,
  }) {
    final $result = create();
    if (route != null) {
      $result.route = route;
    }
    return $result;
  }
  CreateRoadRouteResponse._() : super();
  factory CreateRoadRouteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateRoadRouteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateRoadRouteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOM<Route>(1, _omitFieldNames ? '' : 'route', subBuilder: Route.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateRoadRouteResponse clone() => CreateRoadRouteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateRoadRouteResponse copyWith(void Function(CreateRoadRouteResponse) updates) => super.copyWith((message) => updates(message as CreateRoadRouteResponse)) as CreateRoadRouteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoadRouteResponse create() => CreateRoadRouteResponse._();
  CreateRoadRouteResponse createEmptyInstance() => create();
  static $pb.PbList<CreateRoadRouteResponse> createRepeated() => $pb.PbList<CreateRoadRouteResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateRoadRouteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRoadRouteResponse>(create);
  static CreateRoadRouteResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Route get route => $_getN(0);
  @$pb.TagNumber(1)
  set route(Route v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRoute() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoute() => $_clearField(1);
  @$pb.TagNumber(1)
  Route ensureRoute() => $_ensure(0);
}

class ListRoutesRequest extends $pb.GeneratedMessage {
  factory ListRoutesRequest({
    $core.String? projectId,
    RouteType? typeFilter,
    $1.PaginationRequest? pagination,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (typeFilter != null) {
      $result.typeFilter = typeFilter;
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListRoutesRequest._() : super();
  factory ListRoutesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListRoutesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListRoutesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<RouteType>(2, _omitFieldNames ? '' : 'typeFilter', $pb.PbFieldType.OE, defaultOrMaker: RouteType.ROUTE_TYPE_UNSPECIFIED, valueOf: RouteType.valueOf, enumValues: RouteType.values)
    ..aOM<$1.PaginationRequest>(3, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListRoutesRequest clone() => ListRoutesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListRoutesRequest copyWith(void Function(ListRoutesRequest) updates) => super.copyWith((message) => updates(message as ListRoutesRequest)) as ListRoutesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoutesRequest create() => ListRoutesRequest._();
  ListRoutesRequest createEmptyInstance() => create();
  static $pb.PbList<ListRoutesRequest> createRepeated() => $pb.PbList<ListRoutesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListRoutesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRoutesRequest>(create);
  static ListRoutesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  RouteType get typeFilter => $_getN(1);
  @$pb.TagNumber(2)
  set typeFilter(RouteType v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTypeFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearTypeFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.PaginationRequest get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($1.PaginationRequest v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.PaginationRequest ensurePagination() => $_ensure(2);
}

class ListRoutesResponse extends $pb.GeneratedMessage {
  factory ListRoutesResponse({
    $core.Iterable<Route>? routes,
    $1.PaginationResponse? pagination,
  }) {
    final $result = create();
    if (routes != null) {
      $result.routes.addAll(routes);
    }
    if (pagination != null) {
      $result.pagination = pagination;
    }
    return $result;
  }
  ListRoutesResponse._() : super();
  factory ListRoutesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListRoutesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListRoutesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..pc<Route>(1, _omitFieldNames ? '' : 'routes', $pb.PbFieldType.PM, subBuilder: Route.create)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListRoutesResponse clone() => ListRoutesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListRoutesResponse copyWith(void Function(ListRoutesResponse) updates) => super.copyWith((message) => updates(message as ListRoutesResponse)) as ListRoutesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListRoutesResponse create() => ListRoutesResponse._();
  ListRoutesResponse createEmptyInstance() => create();
  static $pb.PbList<ListRoutesResponse> createRepeated() => $pb.PbList<ListRoutesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListRoutesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRoutesResponse>(create);
  static ListRoutesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Route> get routes => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationResponse v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationResponse ensurePagination() => $_ensure(1);
}

class DeleteRouteRequest extends $pb.GeneratedMessage {
  factory DeleteRouteRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteRouteRequest._() : super();
  factory DeleteRouteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteRouteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteRouteRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteRouteRequest clone() => DeleteRouteRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteRouteRequest copyWith(void Function(DeleteRouteRequest) updates) => super.copyWith((message) => updates(message as DeleteRouteRequest)) as DeleteRouteRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRouteRequest create() => DeleteRouteRequest._();
  DeleteRouteRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteRouteRequest> createRepeated() => $pb.PbList<DeleteRouteRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteRouteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteRouteRequest>(create);
  static DeleteRouteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteRouteResponse extends $pb.GeneratedMessage {
  factory DeleteRouteResponse() => create();
  DeleteRouteResponse._() : super();
  factory DeleteRouteResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteRouteResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteRouteResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteRouteResponse clone() => DeleteRouteResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteRouteResponse copyWith(void Function(DeleteRouteResponse) updates) => super.copyWith((message) => updates(message as DeleteRouteResponse)) as DeleteRouteResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteRouteResponse create() => DeleteRouteResponse._();
  DeleteRouteResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteRouteResponse> createRepeated() => $pb.PbList<DeleteRouteResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteRouteResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteRouteResponse>(create);
  static DeleteRouteResponse? _defaultInstance;
}

class OptimizeRoutesRequest extends $pb.GeneratedMessage {
  factory OptimizeRoutesRequest({
    $core.String? projectId,
    RouteType? routeType,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (routeType != null) {
      $result.routeType = routeType;
    }
    return $result;
  }
  OptimizeRoutesRequest._() : super();
  factory OptimizeRoutesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OptimizeRoutesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OptimizeRoutesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<RouteType>(2, _omitFieldNames ? '' : 'routeType', $pb.PbFieldType.OE, defaultOrMaker: RouteType.ROUTE_TYPE_UNSPECIFIED, valueOf: RouteType.valueOf, enumValues: RouteType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OptimizeRoutesRequest clone() => OptimizeRoutesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OptimizeRoutesRequest copyWith(void Function(OptimizeRoutesRequest) updates) => super.copyWith((message) => updates(message as OptimizeRoutesRequest)) as OptimizeRoutesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OptimizeRoutesRequest create() => OptimizeRoutesRequest._();
  OptimizeRoutesRequest createEmptyInstance() => create();
  static $pb.PbList<OptimizeRoutesRequest> createRepeated() => $pb.PbList<OptimizeRoutesRequest>();
  @$core.pragma('dart2js:noInline')
  static OptimizeRoutesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OptimizeRoutesRequest>(create);
  static OptimizeRoutesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  RouteType get routeType => $_getN(1);
  @$pb.TagNumber(2)
  set routeType(RouteType v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRouteType() => $_has(1);
  @$pb.TagNumber(2)
  void clearRouteType() => $_clearField(2);
}

class OptimizeRoutesResponse extends $pb.GeneratedMessage {
  factory OptimizeRoutesResponse({
    $core.Iterable<Route>? optimizedRoutes,
    $core.double? totalDistanceM,
    $core.double? totalCostEstimate,
  }) {
    final $result = create();
    if (optimizedRoutes != null) {
      $result.optimizedRoutes.addAll(optimizedRoutes);
    }
    if (totalDistanceM != null) {
      $result.totalDistanceM = totalDistanceM;
    }
    if (totalCostEstimate != null) {
      $result.totalCostEstimate = totalCostEstimate;
    }
    return $result;
  }
  OptimizeRoutesResponse._() : super();
  factory OptimizeRoutesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OptimizeRoutesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OptimizeRoutesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'routing.v1'), createEmptyInstance: create)
    ..pc<Route>(1, _omitFieldNames ? '' : 'optimizedRoutes', $pb.PbFieldType.PM, subBuilder: Route.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'totalDistanceM', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'totalCostEstimate', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OptimizeRoutesResponse clone() => OptimizeRoutesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OptimizeRoutesResponse copyWith(void Function(OptimizeRoutesResponse) updates) => super.copyWith((message) => updates(message as OptimizeRoutesResponse)) as OptimizeRoutesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OptimizeRoutesResponse create() => OptimizeRoutesResponse._();
  OptimizeRoutesResponse createEmptyInstance() => create();
  static $pb.PbList<OptimizeRoutesResponse> createRepeated() => $pb.PbList<OptimizeRoutesResponse>();
  @$core.pragma('dart2js:noInline')
  static OptimizeRoutesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OptimizeRoutesResponse>(create);
  static OptimizeRoutesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Route> get optimizedRoutes => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get totalDistanceM => $_getN(1);
  @$pb.TagNumber(2)
  set totalDistanceM($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalDistanceM() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalDistanceM() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get totalCostEstimate => $_getN(2);
  @$pb.TagNumber(3)
  set totalCostEstimate($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalCostEstimate() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCostEstimate() => $_clearField(3);
}

class RoutingServiceApi {
  $pb.RpcClient _client;
  RoutingServiceApi(this._client);

  $async.Future<CreateRouteResponse> createRoute($pb.ClientContext? ctx, CreateRouteRequest request) =>
    _client.invoke<CreateRouteResponse>(ctx, 'RoutingService', 'CreateRoute', request, CreateRouteResponse())
  ;
  $async.Future<GetRouteResponse> getRoute($pb.ClientContext? ctx, GetRouteRequest request) =>
    _client.invoke<GetRouteResponse>(ctx, 'RoutingService', 'GetRoute', request, GetRouteResponse())
  ;
  $async.Future<CalculateRouteResponse> calculateRoute($pb.ClientContext? ctx, CalculateRouteRequest request) =>
    _client.invoke<CalculateRouteResponse>(ctx, 'RoutingService', 'CalculateRoute', request, CalculateRouteResponse())
  ;
  $async.Future<CreateCableRouteResponse> createCableRoute($pb.ClientContext? ctx, CreateCableRouteRequest request) =>
    _client.invoke<CreateCableRouteResponse>(ctx, 'RoutingService', 'CreateCableRoute', request, CreateCableRouteResponse())
  ;
  $async.Future<CreateRoadRouteResponse> createRoadRoute($pb.ClientContext? ctx, CreateRoadRouteRequest request) =>
    _client.invoke<CreateRoadRouteResponse>(ctx, 'RoutingService', 'CreateRoadRoute', request, CreateRoadRouteResponse())
  ;
  $async.Future<ListRoutesResponse> listRoutes($pb.ClientContext? ctx, ListRoutesRequest request) =>
    _client.invoke<ListRoutesResponse>(ctx, 'RoutingService', 'ListRoutes', request, ListRoutesResponse())
  ;
  $async.Future<DeleteRouteResponse> deleteRoute($pb.ClientContext? ctx, DeleteRouteRequest request) =>
    _client.invoke<DeleteRouteResponse>(ctx, 'RoutingService', 'DeleteRoute', request, DeleteRouteResponse())
  ;
  $async.Future<OptimizeRoutesResponse> optimizeRoutes($pb.ClientContext? ctx, OptimizeRoutesRequest request) =>
    _client.invoke<OptimizeRoutesResponse>(ctx, 'RoutingService', 'OptimizeRoutes', request, OptimizeRoutesResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
