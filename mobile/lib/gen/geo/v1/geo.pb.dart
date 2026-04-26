//
//  Generated code. Do not modify.
//  source: geo/v1/geo.proto
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

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Point2D', package: const $pb.PackageName(_omitMessageNames ? '' : 'geo.v1'), createEmptyInstance: create)
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

class Polygon extends $pb.GeneratedMessage {
  factory Polygon({
    $core.Iterable<Point2D>? ring,
  }) {
    final $result = create();
    if (ring != null) {
      $result.ring.addAll(ring);
    }
    return $result;
  }
  Polygon._() : super();
  factory Polygon.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Polygon.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Polygon', package: const $pb.PackageName(_omitMessageNames ? '' : 'geo.v1'), createEmptyInstance: create)
    ..pc<Point2D>(1, _omitFieldNames ? '' : 'ring', $pb.PbFieldType.PM, subBuilder: Point2D.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Polygon clone() => Polygon()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Polygon copyWith(void Function(Polygon) updates) => super.copyWith((message) => updates(message as Polygon)) as Polygon;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Polygon create() => Polygon._();
  Polygon createEmptyInstance() => create();
  static $pb.PbList<Polygon> createRepeated() => $pb.PbList<Polygon>();
  @$core.pragma('dart2js:noInline')
  static Polygon getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Polygon>(create);
  static Polygon? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Point2D> get ring => $_getList(0);
}

class BufferPointRequest extends $pb.GeneratedMessage {
  factory BufferPointRequest({
    Point2D? center,
    $core.double? radius,
    $core.int? segments,
  }) {
    final $result = create();
    if (center != null) {
      $result.center = center;
    }
    if (radius != null) {
      $result.radius = radius;
    }
    if (segments != null) {
      $result.segments = segments;
    }
    return $result;
  }
  BufferPointRequest._() : super();
  factory BufferPointRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BufferPointRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BufferPointRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'geo.v1'), createEmptyInstance: create)
    ..aOM<Point2D>(1, _omitFieldNames ? '' : 'center', subBuilder: Point2D.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'radius', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'segments', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BufferPointRequest clone() => BufferPointRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BufferPointRequest copyWith(void Function(BufferPointRequest) updates) => super.copyWith((message) => updates(message as BufferPointRequest)) as BufferPointRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BufferPointRequest create() => BufferPointRequest._();
  BufferPointRequest createEmptyInstance() => create();
  static $pb.PbList<BufferPointRequest> createRepeated() => $pb.PbList<BufferPointRequest>();
  @$core.pragma('dart2js:noInline')
  static BufferPointRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BufferPointRequest>(create);
  static BufferPointRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Point2D get center => $_getN(0);
  @$pb.TagNumber(1)
  set center(Point2D v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCenter() => $_has(0);
  @$pb.TagNumber(1)
  void clearCenter() => $_clearField(1);
  @$pb.TagNumber(1)
  Point2D ensureCenter() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get radius => $_getN(1);
  @$pb.TagNumber(2)
  set radius($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRadius() => $_has(1);
  @$pb.TagNumber(2)
  void clearRadius() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get segments => $_getIZ(2);
  @$pb.TagNumber(3)
  set segments($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSegments() => $_has(2);
  @$pb.TagNumber(3)
  void clearSegments() => $_clearField(3);
}

class BufferPointResponse extends $pb.GeneratedMessage {
  factory BufferPointResponse({
    Polygon? polygon,
  }) {
    final $result = create();
    if (polygon != null) {
      $result.polygon = polygon;
    }
    return $result;
  }
  BufferPointResponse._() : super();
  factory BufferPointResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BufferPointResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BufferPointResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'geo.v1'), createEmptyInstance: create)
    ..aOM<Polygon>(1, _omitFieldNames ? '' : 'polygon', subBuilder: Polygon.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BufferPointResponse clone() => BufferPointResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BufferPointResponse copyWith(void Function(BufferPointResponse) updates) => super.copyWith((message) => updates(message as BufferPointResponse)) as BufferPointResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BufferPointResponse create() => BufferPointResponse._();
  BufferPointResponse createEmptyInstance() => create();
  static $pb.PbList<BufferPointResponse> createRepeated() => $pb.PbList<BufferPointResponse>();
  @$core.pragma('dart2js:noInline')
  static BufferPointResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BufferPointResponse>(create);
  static BufferPointResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Polygon get polygon => $_getN(0);
  @$pb.TagNumber(1)
  set polygon(Polygon v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPolygon() => $_has(0);
  @$pb.TagNumber(1)
  void clearPolygon() => $_clearField(1);
  @$pb.TagNumber(1)
  Polygon ensurePolygon() => $_ensure(0);
}

class NearestPointRequest extends $pb.GeneratedMessage {
  factory NearestPointRequest({
    Point2D? query,
    $core.Iterable<Point2D>? candidates,
  }) {
    final $result = create();
    if (query != null) {
      $result.query = query;
    }
    if (candidates != null) {
      $result.candidates.addAll(candidates);
    }
    return $result;
  }
  NearestPointRequest._() : super();
  factory NearestPointRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NearestPointRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NearestPointRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'geo.v1'), createEmptyInstance: create)
    ..aOM<Point2D>(1, _omitFieldNames ? '' : 'query', subBuilder: Point2D.create)
    ..pc<Point2D>(2, _omitFieldNames ? '' : 'candidates', $pb.PbFieldType.PM, subBuilder: Point2D.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NearestPointRequest clone() => NearestPointRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NearestPointRequest copyWith(void Function(NearestPointRequest) updates) => super.copyWith((message) => updates(message as NearestPointRequest)) as NearestPointRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NearestPointRequest create() => NearestPointRequest._();
  NearestPointRequest createEmptyInstance() => create();
  static $pb.PbList<NearestPointRequest> createRepeated() => $pb.PbList<NearestPointRequest>();
  @$core.pragma('dart2js:noInline')
  static NearestPointRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NearestPointRequest>(create);
  static NearestPointRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Point2D get query => $_getN(0);
  @$pb.TagNumber(1)
  set query(Point2D v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => $_clearField(1);
  @$pb.TagNumber(1)
  Point2D ensureQuery() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<Point2D> get candidates => $_getList(1);
}

class NearestPointResponse extends $pb.GeneratedMessage {
  factory NearestPointResponse({
    $core.int? index,
    $core.double? distance,
    Point2D? point,
  }) {
    final $result = create();
    if (index != null) {
      $result.index = index;
    }
    if (distance != null) {
      $result.distance = distance;
    }
    if (point != null) {
      $result.point = point;
    }
    return $result;
  }
  NearestPointResponse._() : super();
  factory NearestPointResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NearestPointResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NearestPointResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'geo.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'index', $pb.PbFieldType.O3)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'distance', $pb.PbFieldType.OD)
    ..aOM<Point2D>(3, _omitFieldNames ? '' : 'point', subBuilder: Point2D.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NearestPointResponse clone() => NearestPointResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NearestPointResponse copyWith(void Function(NearestPointResponse) updates) => super.copyWith((message) => updates(message as NearestPointResponse)) as NearestPointResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NearestPointResponse create() => NearestPointResponse._();
  NearestPointResponse createEmptyInstance() => create();
  static $pb.PbList<NearestPointResponse> createRepeated() => $pb.PbList<NearestPointResponse>();
  @$core.pragma('dart2js:noInline')
  static NearestPointResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NearestPointResponse>(create);
  static NearestPointResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get distance => $_getN(1);
  @$pb.TagNumber(2)
  set distance($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDistance() => $_has(1);
  @$pb.TagNumber(2)
  void clearDistance() => $_clearField(2);

  @$pb.TagNumber(3)
  Point2D get point => $_getN(2);
  @$pb.TagNumber(3)
  set point(Point2D v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearPoint() => $_clearField(3);
  @$pb.TagNumber(3)
  Point2D ensurePoint() => $_ensure(2);
}

class GenerateContoursRequest extends $pb.GeneratedMessage {
  factory GenerateContoursRequest({
    $core.int? width,
    $core.int? height,
    $core.double? resolution,
    $core.double? originX,
    $core.double? originY,
    $core.double? noData,
    $core.Iterable<$core.double>? data,
    $core.double? interval,
  }) {
    final $result = create();
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (resolution != null) {
      $result.resolution = resolution;
    }
    if (originX != null) {
      $result.originX = originX;
    }
    if (originY != null) {
      $result.originY = originY;
    }
    if (noData != null) {
      $result.noData = noData;
    }
    if (data != null) {
      $result.data.addAll(data);
    }
    if (interval != null) {
      $result.interval = interval;
    }
    return $result;
  }
  GenerateContoursRequest._() : super();
  factory GenerateContoursRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateContoursRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateContoursRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'geo.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'width', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'height', $pb.PbFieldType.O3)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'resolution', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'originX', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'originY', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'noData', $pb.PbFieldType.OD)
    ..p<$core.double>(7, _omitFieldNames ? '' : 'data', $pb.PbFieldType.KD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'interval', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateContoursRequest clone() => GenerateContoursRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateContoursRequest copyWith(void Function(GenerateContoursRequest) updates) => super.copyWith((message) => updates(message as GenerateContoursRequest)) as GenerateContoursRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateContoursRequest create() => GenerateContoursRequest._();
  GenerateContoursRequest createEmptyInstance() => create();
  static $pb.PbList<GenerateContoursRequest> createRepeated() => $pb.PbList<GenerateContoursRequest>();
  @$core.pragma('dart2js:noInline')
  static GenerateContoursRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateContoursRequest>(create);
  static GenerateContoursRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get width => $_getIZ(0);
  @$pb.TagNumber(1)
  set width($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get height => $_getIZ(1);
  @$pb.TagNumber(2)
  set height($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get resolution => $_getN(2);
  @$pb.TagNumber(3)
  set resolution($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasResolution() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolution() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get originX => $_getN(3);
  @$pb.TagNumber(4)
  set originX($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOriginX() => $_has(3);
  @$pb.TagNumber(4)
  void clearOriginX() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get originY => $_getN(4);
  @$pb.TagNumber(5)
  set originY($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasOriginY() => $_has(4);
  @$pb.TagNumber(5)
  void clearOriginY() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get noData => $_getN(5);
  @$pb.TagNumber(6)
  set noData($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasNoData() => $_has(5);
  @$pb.TagNumber(6)
  void clearNoData() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.double> get data => $_getList(6);

  @$pb.TagNumber(8)
  $core.double get interval => $_getN(7);
  @$pb.TagNumber(8)
  set interval($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasInterval() => $_has(7);
  @$pb.TagNumber(8)
  void clearInterval() => $_clearField(8);
}

class ContourLine extends $pb.GeneratedMessage {
  factory ContourLine({
    $core.double? elevation,
    $core.Iterable<Point2D>? points,
  }) {
    final $result = create();
    if (elevation != null) {
      $result.elevation = elevation;
    }
    if (points != null) {
      $result.points.addAll(points);
    }
    return $result;
  }
  ContourLine._() : super();
  factory ContourLine.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ContourLine.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContourLine', package: const $pb.PackageName(_omitMessageNames ? '' : 'geo.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'elevation', $pb.PbFieldType.OD)
    ..pc<Point2D>(2, _omitFieldNames ? '' : 'points', $pb.PbFieldType.PM, subBuilder: Point2D.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ContourLine clone() => ContourLine()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ContourLine copyWith(void Function(ContourLine) updates) => super.copyWith((message) => updates(message as ContourLine)) as ContourLine;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContourLine create() => ContourLine._();
  ContourLine createEmptyInstance() => create();
  static $pb.PbList<ContourLine> createRepeated() => $pb.PbList<ContourLine>();
  @$core.pragma('dart2js:noInline')
  static ContourLine getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContourLine>(create);
  static ContourLine? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get elevation => $_getN(0);
  @$pb.TagNumber(1)
  set elevation($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasElevation() => $_has(0);
  @$pb.TagNumber(1)
  void clearElevation() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<Point2D> get points => $_getList(1);
}

class GenerateContoursResponse extends $pb.GeneratedMessage {
  factory GenerateContoursResponse({
    $core.Iterable<ContourLine>? contours,
  }) {
    final $result = create();
    if (contours != null) {
      $result.contours.addAll(contours);
    }
    return $result;
  }
  GenerateContoursResponse._() : super();
  factory GenerateContoursResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateContoursResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateContoursResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'geo.v1'), createEmptyInstance: create)
    ..pc<ContourLine>(1, _omitFieldNames ? '' : 'contours', $pb.PbFieldType.PM, subBuilder: ContourLine.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateContoursResponse clone() => GenerateContoursResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateContoursResponse copyWith(void Function(GenerateContoursResponse) updates) => super.copyWith((message) => updates(message as GenerateContoursResponse)) as GenerateContoursResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateContoursResponse create() => GenerateContoursResponse._();
  GenerateContoursResponse createEmptyInstance() => create();
  static $pb.PbList<GenerateContoursResponse> createRepeated() => $pb.PbList<GenerateContoursResponse>();
  @$core.pragma('dart2js:noInline')
  static GenerateContoursResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateContoursResponse>(create);
  static GenerateContoursResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ContourLine> get contours => $_getList(0);
}

/// GeoService exposes geometry and raster algorithms built on geo-compute.
class GeoServiceApi {
  $pb.RpcClient _client;
  GeoServiceApi(this._client);

  /// BufferPoint generates a polygonal buffer around a point.
  $async.Future<BufferPointResponse> bufferPoint($pb.ClientContext? ctx, BufferPointRequest request) =>
    _client.invoke<BufferPointResponse>(ctx, 'GeoService', 'BufferPoint', request, BufferPointResponse())
  ;
  /// NearestPoint returns the closest candidate point to the query point.
  $async.Future<NearestPointResponse> nearestPoint($pb.ClientContext? ctx, NearestPointRequest request) =>
    _client.invoke<NearestPointResponse>(ctx, 'GeoService', 'NearestPoint', request, NearestPointResponse())
  ;
  /// GenerateContours derives contour lines from an input raster grid.
  $async.Future<GenerateContoursResponse> generateContours($pb.ClientContext? ctx, GenerateContoursRequest request) =>
    _client.invoke<GenerateContoursResponse>(ctx, 'GeoService', 'GenerateContours', request, GenerateContoursResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
