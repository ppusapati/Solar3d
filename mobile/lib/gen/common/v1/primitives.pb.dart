//
//  Generated code. Do not modify.
//  source: common/v1/primitives.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Semantic version carried in API payloads for compatibility checks.
class ApiVersion extends $pb.GeneratedMessage {
  factory ApiVersion({
    $core.int? major,
    $core.int? minor,
    $core.int? patch,
  }) {
    final $result = create();
    if (major != null) {
      $result.major = major;
    }
    if (minor != null) {
      $result.minor = minor;
    }
    if (patch != null) {
      $result.patch = patch;
    }
    return $result;
  }
  ApiVersion._() : super();
  factory ApiVersion.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ApiVersion.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ApiVersion', package: const $pb.PackageName(_omitMessageNames ? '' : 'common.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'major', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'minor', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'patch', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ApiVersion clone() => ApiVersion()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ApiVersion copyWith(void Function(ApiVersion) updates) => super.copyWith((message) => updates(message as ApiVersion)) as ApiVersion;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ApiVersion create() => ApiVersion._();
  ApiVersion createEmptyInstance() => create();
  static $pb.PbList<ApiVersion> createRepeated() => $pb.PbList<ApiVersion>();
  @$core.pragma('dart2js:noInline')
  static ApiVersion getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ApiVersion>(create);
  static ApiVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get major => $_getIZ(0);
  @$pb.TagNumber(1)
  set major($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMajor() => $_has(0);
  @$pb.TagNumber(1)
  void clearMajor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get minor => $_getIZ(1);
  @$pb.TagNumber(2)
  set minor($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMinor() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get patch => $_getIZ(2);
  @$pb.TagNumber(3)
  set patch($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPatch() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatch() => $_clearField(3);
}

/// Metadata shared across contracts to support tracing and lineage.
class ContractMetadata extends $pb.GeneratedMessage {
  factory ContractMetadata({
    ApiVersion? schemaVersion,
    $core.String? schemaId,
    $core.String? schemaHash,
    $core.String? producer,
    $core.String? correlationId,
    $0.Timestamp? createdAt,
  }) {
    final $result = create();
    if (schemaVersion != null) {
      $result.schemaVersion = schemaVersion;
    }
    if (schemaId != null) {
      $result.schemaId = schemaId;
    }
    if (schemaHash != null) {
      $result.schemaHash = schemaHash;
    }
    if (producer != null) {
      $result.producer = producer;
    }
    if (correlationId != null) {
      $result.correlationId = correlationId;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  ContractMetadata._() : super();
  factory ContractMetadata.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ContractMetadata.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContractMetadata', package: const $pb.PackageName(_omitMessageNames ? '' : 'common.v1'), createEmptyInstance: create)
    ..aOM<ApiVersion>(1, _omitFieldNames ? '' : 'schemaVersion', subBuilder: ApiVersion.create)
    ..aOS(2, _omitFieldNames ? '' : 'schemaId')
    ..aOS(3, _omitFieldNames ? '' : 'schemaHash')
    ..aOS(4, _omitFieldNames ? '' : 'producer')
    ..aOS(5, _omitFieldNames ? '' : 'correlationId')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ContractMetadata clone() => ContractMetadata()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ContractMetadata copyWith(void Function(ContractMetadata) updates) => super.copyWith((message) => updates(message as ContractMetadata)) as ContractMetadata;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContractMetadata create() => ContractMetadata._();
  ContractMetadata createEmptyInstance() => create();
  static $pb.PbList<ContractMetadata> createRepeated() => $pb.PbList<ContractMetadata>();
  @$core.pragma('dart2js:noInline')
  static ContractMetadata getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContractMetadata>(create);
  static ContractMetadata? _defaultInstance;

  @$pb.TagNumber(1)
  ApiVersion get schemaVersion => $_getN(0);
  @$pb.TagNumber(1)
  set schemaVersion(ApiVersion v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSchemaVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchemaVersion() => $_clearField(1);
  @$pb.TagNumber(1)
  ApiVersion ensureSchemaVersion() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get schemaId => $_getSZ(1);
  @$pb.TagNumber(2)
  set schemaId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSchemaId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSchemaId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get schemaHash => $_getSZ(2);
  @$pb.TagNumber(3)
  set schemaHash($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSchemaHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearSchemaHash() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get producer => $_getSZ(3);
  @$pb.TagNumber(4)
  set producer($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProducer() => $_has(3);
  @$pb.TagNumber(4)
  void clearProducer() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get correlationId => $_getSZ(4);
  @$pb.TagNumber(5)
  set correlationId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCorrelationId() => $_has(4);
  @$pb.TagNumber(5)
  void clearCorrelationId() => $_clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($0.Timestamp v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureCreatedAt() => $_ensure(5);
}

class Point2D extends $pb.GeneratedMessage {
  factory Point2D({
    $core.double? x,
    $core.double? y,
  }) {
    final $result = create();
    if (x != null) {
      $result.x = x;
    }
    if (y != null) {
      $result.y = y;
    }
    return $result;
  }
  Point2D._() : super();
  factory Point2D.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Point2D.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Point2D', package: const $pb.PackageName(_omitMessageNames ? '' : 'common.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'x', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'y', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Point2D clone() => Point2D()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Point2D copyWith(void Function(Point2D) updates) => super.copyWith((message) => updates(message as Point2D)) as Point2D;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Point2D create() => Point2D._();
  Point2D createEmptyInstance() => create();
  static $pb.PbList<Point2D> createRepeated() => $pb.PbList<Point2D>();
  @$core.pragma('dart2js:noInline')
  static Point2D getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Point2D>(create);
  static Point2D? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);
}

class Point3D extends $pb.GeneratedMessage {
  factory Point3D({
    $core.double? x,
    $core.double? y,
    $core.double? z,
  }) {
    final $result = create();
    if (x != null) {
      $result.x = x;
    }
    if (y != null) {
      $result.y = y;
    }
    if (z != null) {
      $result.z = z;
    }
    return $result;
  }
  Point3D._() : super();
  factory Point3D.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Point3D.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Point3D', package: const $pb.PackageName(_omitMessageNames ? '' : 'common.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'x', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'y', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'z', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Point3D clone() => Point3D()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Point3D copyWith(void Function(Point3D) updates) => super.copyWith((message) => updates(message as Point3D)) as Point3D;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Point3D create() => Point3D._();
  Point3D createEmptyInstance() => create();
  static $pb.PbList<Point3D> createRepeated() => $pb.PbList<Point3D>();
  @$core.pragma('dart2js:noInline')
  static Point3D getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Point3D>(create);
  static Point3D? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get z => $_getN(2);
  @$pb.TagNumber(3)
  set z($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasZ() => $_has(2);
  @$pb.TagNumber(3)
  void clearZ() => $_clearField(3);
}

class BoundingBox2D extends $pb.GeneratedMessage {
  factory BoundingBox2D({
    $core.double? minX,
    $core.double? minY,
    $core.double? maxX,
    $core.double? maxY,
  }) {
    final $result = create();
    if (minX != null) {
      $result.minX = minX;
    }
    if (minY != null) {
      $result.minY = minY;
    }
    if (maxX != null) {
      $result.maxX = maxX;
    }
    if (maxY != null) {
      $result.maxY = maxY;
    }
    return $result;
  }
  BoundingBox2D._() : super();
  factory BoundingBox2D.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BoundingBox2D.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BoundingBox2D', package: const $pb.PackageName(_omitMessageNames ? '' : 'common.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'minX', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'minY', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'maxX', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'maxY', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BoundingBox2D clone() => BoundingBox2D()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BoundingBox2D copyWith(void Function(BoundingBox2D) updates) => super.copyWith((message) => updates(message as BoundingBox2D)) as BoundingBox2D;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BoundingBox2D create() => BoundingBox2D._();
  BoundingBox2D createEmptyInstance() => create();
  static $pb.PbList<BoundingBox2D> createRepeated() => $pb.PbList<BoundingBox2D>();
  @$core.pragma('dart2js:noInline')
  static BoundingBox2D getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BoundingBox2D>(create);
  static BoundingBox2D? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get minX => $_getN(0);
  @$pb.TagNumber(1)
  set minX($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMinX() => $_has(0);
  @$pb.TagNumber(1)
  void clearMinX() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get minY => $_getN(1);
  @$pb.TagNumber(2)
  set minY($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMinY() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinY() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get maxX => $_getN(2);
  @$pb.TagNumber(3)
  set maxX($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxX() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxX() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get maxY => $_getN(3);
  @$pb.TagNumber(4)
  set maxY($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMaxY() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxY() => $_clearField(4);
}

class LineString2D extends $pb.GeneratedMessage {
  factory LineString2D({
    $core.Iterable<Point2D>? points,
  }) {
    final $result = create();
    if (points != null) {
      $result.points.addAll(points);
    }
    return $result;
  }
  LineString2D._() : super();
  factory LineString2D.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LineString2D.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LineString2D', package: const $pb.PackageName(_omitMessageNames ? '' : 'common.v1'), createEmptyInstance: create)
    ..pc<Point2D>(1, _omitFieldNames ? '' : 'points', $pb.PbFieldType.PM, subBuilder: Point2D.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LineString2D clone() => LineString2D()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LineString2D copyWith(void Function(LineString2D) updates) => super.copyWith((message) => updates(message as LineString2D)) as LineString2D;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LineString2D create() => LineString2D._();
  LineString2D createEmptyInstance() => create();
  static $pb.PbList<LineString2D> createRepeated() => $pb.PbList<LineString2D>();
  @$core.pragma('dart2js:noInline')
  static LineString2D getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LineString2D>(create);
  static LineString2D? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Point2D> get points => $_getList(0);
}

class Polygon2D extends $pb.GeneratedMessage {
  factory Polygon2D({
    $core.Iterable<LineString2D>? rings,
  }) {
    final $result = create();
    if (rings != null) {
      $result.rings.addAll(rings);
    }
    return $result;
  }
  Polygon2D._() : super();
  factory Polygon2D.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Polygon2D.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Polygon2D', package: const $pb.PackageName(_omitMessageNames ? '' : 'common.v1'), createEmptyInstance: create)
    ..pc<LineString2D>(1, _omitFieldNames ? '' : 'rings', $pb.PbFieldType.PM, subBuilder: LineString2D.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Polygon2D clone() => Polygon2D()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Polygon2D copyWith(void Function(Polygon2D) updates) => super.copyWith((message) => updates(message as Polygon2D)) as Polygon2D;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Polygon2D create() => Polygon2D._();
  Polygon2D createEmptyInstance() => create();
  static $pb.PbList<Polygon2D> createRepeated() => $pb.PbList<Polygon2D>();
  @$core.pragma('dart2js:noInline')
  static Polygon2D getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Polygon2D>(create);
  static Polygon2D? _defaultInstance;

  /// First ring is outer shell, remaining rings are holes.
  @$pb.TagNumber(1)
  $pb.PbList<LineString2D> get rings => $_getList(0);
}

class MultiPolygon2D extends $pb.GeneratedMessage {
  factory MultiPolygon2D({
    $core.Iterable<Polygon2D>? polygons,
  }) {
    final $result = create();
    if (polygons != null) {
      $result.polygons.addAll(polygons);
    }
    return $result;
  }
  MultiPolygon2D._() : super();
  factory MultiPolygon2D.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MultiPolygon2D.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MultiPolygon2D', package: const $pb.PackageName(_omitMessageNames ? '' : 'common.v1'), createEmptyInstance: create)
    ..pc<Polygon2D>(1, _omitFieldNames ? '' : 'polygons', $pb.PbFieldType.PM, subBuilder: Polygon2D.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MultiPolygon2D clone() => MultiPolygon2D()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MultiPolygon2D copyWith(void Function(MultiPolygon2D) updates) => super.copyWith((message) => updates(message as MultiPolygon2D)) as MultiPolygon2D;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiPolygon2D create() => MultiPolygon2D._();
  MultiPolygon2D createEmptyInstance() => create();
  static $pb.PbList<MultiPolygon2D> createRepeated() => $pb.PbList<MultiPolygon2D>();
  @$core.pragma('dart2js:noInline')
  static MultiPolygon2D getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiPolygon2D>(create);
  static MultiPolygon2D? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Polygon2D> get polygons => $_getList(0);
}

class NumericRange extends $pb.GeneratedMessage {
  factory NumericRange({
    $core.double? min,
    $core.double? max,
  }) {
    final $result = create();
    if (min != null) {
      $result.min = min;
    }
    if (max != null) {
      $result.max = max;
    }
    return $result;
  }
  NumericRange._() : super();
  factory NumericRange.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NumericRange.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NumericRange', package: const $pb.PackageName(_omitMessageNames ? '' : 'common.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'min', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'max', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NumericRange clone() => NumericRange()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NumericRange copyWith(void Function(NumericRange) updates) => super.copyWith((message) => updates(message as NumericRange)) as NumericRange;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NumericRange create() => NumericRange._();
  NumericRange createEmptyInstance() => create();
  static $pb.PbList<NumericRange> createRepeated() => $pb.PbList<NumericRange>();
  @$core.pragma('dart2js:noInline')
  static NumericRange getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NumericRange>(create);
  static NumericRange? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get min => $_getN(0);
  @$pb.TagNumber(1)
  set min($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMin() => $_has(0);
  @$pb.TagNumber(1)
  void clearMin() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get max => $_getN(1);
  @$pb.TagNumber(2)
  set max($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMax() => $_has(1);
  @$pb.TagNumber(2)
  void clearMax() => $_clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
