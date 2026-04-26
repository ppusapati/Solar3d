//
//  Generated code. Do not modify.
//  source: drawing/v1/drawing.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/v1/primitives.pb.dart' as $1;
import '../../google/protobuf/timestamp.pb.dart' as $0;
import 'drawing.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'drawing.pbenum.dart';

class LayerRef extends $pb.GeneratedMessage {
  factory LayerRef({
    $core.String? layerId,
    $core.String? layerName,
  }) {
    final $result = create();
    if (layerId != null) {
      $result.layerId = layerId;
    }
    if (layerName != null) {
      $result.layerName = layerName;
    }
    return $result;
  }
  LayerRef._() : super();
  factory LayerRef.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LayerRef.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LayerRef', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'layerId')
    ..aOS(2, _omitFieldNames ? '' : 'layerName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LayerRef clone() => LayerRef()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LayerRef copyWith(void Function(LayerRef) updates) => super.copyWith((message) => updates(message as LayerRef)) as LayerRef;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LayerRef create() => LayerRef._();
  LayerRef createEmptyInstance() => create();
  static $pb.PbList<LayerRef> createRepeated() => $pb.PbList<LayerRef>();
  @$core.pragma('dart2js:noInline')
  static LayerRef getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LayerRef>(create);
  static LayerRef? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get layerName => $_getSZ(1);
  @$pb.TagNumber(2)
  set layerName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLayerName() => $_has(1);
  @$pb.TagNumber(2)
  void clearLayerName() => $_clearField(2);
}

class StyleRef extends $pb.GeneratedMessage {
  factory StyleRef({
    $core.String? styleId,
    $core.String? styleName,
  }) {
    final $result = create();
    if (styleId != null) {
      $result.styleId = styleId;
    }
    if (styleName != null) {
      $result.styleName = styleName;
    }
    return $result;
  }
  StyleRef._() : super();
  factory StyleRef.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StyleRef.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StyleRef', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'styleId')
    ..aOS(2, _omitFieldNames ? '' : 'styleName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StyleRef clone() => StyleRef()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StyleRef copyWith(void Function(StyleRef) updates) => super.copyWith((message) => updates(message as StyleRef)) as StyleRef;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StyleRef create() => StyleRef._();
  StyleRef createEmptyInstance() => create();
  static $pb.PbList<StyleRef> createRepeated() => $pb.PbList<StyleRef>();
  @$core.pragma('dart2js:noInline')
  static StyleRef getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StyleRef>(create);
  static StyleRef? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get styleId => $_getSZ(0);
  @$pb.TagNumber(1)
  set styleId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStyleId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStyleId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get styleName => $_getSZ(1);
  @$pb.TagNumber(2)
  set styleName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasStyleName() => $_has(1);
  @$pb.TagNumber(2)
  void clearStyleName() => $_clearField(2);
}

class EntityHeader extends $pb.GeneratedMessage {
  factory EntityHeader({
    $core.String? entityId,
    $core.String? drawingId,
    DrawingEntityType? entityType,
    LayerRef? layer,
    StyleRef? style,
    $core.String? metadataJson,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (entityId != null) {
      $result.entityId = entityId;
    }
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (entityType != null) {
      $result.entityType = entityType;
    }
    if (layer != null) {
      $result.layer = layer;
    }
    if (style != null) {
      $result.style = style;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  EntityHeader._() : super();
  factory EntityHeader.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EntityHeader.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EntityHeader', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entityId')
    ..aOS(2, _omitFieldNames ? '' : 'drawingId')
    ..e<DrawingEntityType>(3, _omitFieldNames ? '' : 'entityType', $pb.PbFieldType.OE, defaultOrMaker: DrawingEntityType.DRAWING_ENTITY_TYPE_UNSPECIFIED, valueOf: DrawingEntityType.valueOf, enumValues: DrawingEntityType.values)
    ..aOM<LayerRef>(4, _omitFieldNames ? '' : 'layer', subBuilder: LayerRef.create)
    ..aOM<StyleRef>(5, _omitFieldNames ? '' : 'style', subBuilder: StyleRef.create)
    ..aOS(6, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..aOM<$1.ContractMetadata>(9, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EntityHeader clone() => EntityHeader()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EntityHeader copyWith(void Function(EntityHeader) updates) => super.copyWith((message) => updates(message as EntityHeader)) as EntityHeader;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EntityHeader create() => EntityHeader._();
  EntityHeader createEmptyInstance() => create();
  static $pb.PbList<EntityHeader> createRepeated() => $pb.PbList<EntityHeader>();
  @$core.pragma('dart2js:noInline')
  static EntityHeader getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EntityHeader>(create);
  static EntityHeader? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entityId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEntityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get drawingId => $_getSZ(1);
  @$pb.TagNumber(2)
  set drawingId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDrawingId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDrawingId() => $_clearField(2);

  @$pb.TagNumber(3)
  DrawingEntityType get entityType => $_getN(2);
  @$pb.TagNumber(3)
  set entityType(DrawingEntityType v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasEntityType() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntityType() => $_clearField(3);

  @$pb.TagNumber(4)
  LayerRef get layer => $_getN(3);
  @$pb.TagNumber(4)
  set layer(LayerRef v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLayer() => $_has(3);
  @$pb.TagNumber(4)
  void clearLayer() => $_clearField(4);
  @$pb.TagNumber(4)
  LayerRef ensureLayer() => $_ensure(3);

  @$pb.TagNumber(5)
  StyleRef get style => $_getN(4);
  @$pb.TagNumber(5)
  set style(StyleRef v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasStyle() => $_has(4);
  @$pb.TagNumber(5)
  void clearStyle() => $_clearField(5);
  @$pb.TagNumber(5)
  StyleRef ensureStyle() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get metadataJson => $_getSZ(5);
  @$pb.TagNumber(6)
  set metadataJson($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMetadataJson() => $_has(5);
  @$pb.TagNumber(6)
  void clearMetadataJson() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get createdAt => $_getN(6);
  @$pb.TagNumber(7)
  set createdAt($0.Timestamp v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasCreatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCreatedAt() => $_ensure(6);

  @$pb.TagNumber(8)
  $0.Timestamp get updatedAt => $_getN(7);
  @$pb.TagNumber(8)
  set updatedAt($0.Timestamp v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasUpdatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearUpdatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureUpdatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $1.ContractMetadata get contract => $_getN(8);
  @$pb.TagNumber(9)
  set contract($1.ContractMetadata v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasContract() => $_has(8);
  @$pb.TagNumber(9)
  void clearContract() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.ContractMetadata ensureContract() => $_ensure(8);
}

class PolylineEntity extends $pb.GeneratedMessage {
  factory PolylineEntity({
    $core.Iterable<$1.Point2D>? vertices,
    $core.bool? closed,
  }) {
    final $result = create();
    if (vertices != null) {
      $result.vertices.addAll(vertices);
    }
    if (closed != null) {
      $result.closed = closed;
    }
    return $result;
  }
  PolylineEntity._() : super();
  factory PolylineEntity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PolylineEntity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PolylineEntity', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..pc<$1.Point2D>(1, _omitFieldNames ? '' : 'vertices', $pb.PbFieldType.PM, subBuilder: $1.Point2D.create)
    ..aOB(2, _omitFieldNames ? '' : 'closed')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PolylineEntity clone() => PolylineEntity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PolylineEntity copyWith(void Function(PolylineEntity) updates) => super.copyWith((message) => updates(message as PolylineEntity)) as PolylineEntity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PolylineEntity create() => PolylineEntity._();
  PolylineEntity createEmptyInstance() => create();
  static $pb.PbList<PolylineEntity> createRepeated() => $pb.PbList<PolylineEntity>();
  @$core.pragma('dart2js:noInline')
  static PolylineEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PolylineEntity>(create);
  static PolylineEntity? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.Point2D> get vertices => $_getList(0);

  @$pb.TagNumber(2)
  $core.bool get closed => $_getBF(1);
  @$pb.TagNumber(2)
  set closed($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasClosed() => $_has(1);
  @$pb.TagNumber(2)
  void clearClosed() => $_clearField(2);
}

class PolygonEntity extends $pb.GeneratedMessage {
  factory PolygonEntity({
    $1.Polygon2D? geometry,
  }) {
    final $result = create();
    if (geometry != null) {
      $result.geometry = geometry;
    }
    return $result;
  }
  PolygonEntity._() : super();
  factory PolygonEntity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PolygonEntity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PolygonEntity', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<$1.Polygon2D>(1, _omitFieldNames ? '' : 'geometry', subBuilder: $1.Polygon2D.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PolygonEntity clone() => PolygonEntity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PolygonEntity copyWith(void Function(PolygonEntity) updates) => super.copyWith((message) => updates(message as PolygonEntity)) as PolygonEntity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PolygonEntity create() => PolygonEntity._();
  PolygonEntity createEmptyInstance() => create();
  static $pb.PbList<PolygonEntity> createRepeated() => $pb.PbList<PolygonEntity>();
  @$core.pragma('dart2js:noInline')
  static PolygonEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PolygonEntity>(create);
  static PolygonEntity? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Polygon2D get geometry => $_getN(0);
  @$pb.TagNumber(1)
  set geometry($1.Polygon2D v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasGeometry() => $_has(0);
  @$pb.TagNumber(1)
  void clearGeometry() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Polygon2D ensureGeometry() => $_ensure(0);
}

class TextEntity extends $pb.GeneratedMessage {
  factory TextEntity({
    $1.Point2D? anchor,
    $core.String? text,
    $core.double? rotationDeg,
    $core.double? height,
    $core.String? fontFamily,
  }) {
    final $result = create();
    if (anchor != null) {
      $result.anchor = anchor;
    }
    if (text != null) {
      $result.text = text;
    }
    if (rotationDeg != null) {
      $result.rotationDeg = rotationDeg;
    }
    if (height != null) {
      $result.height = height;
    }
    if (fontFamily != null) {
      $result.fontFamily = fontFamily;
    }
    return $result;
  }
  TextEntity._() : super();
  factory TextEntity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TextEntity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TextEntity', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<$1.Point2D>(1, _omitFieldNames ? '' : 'anchor', subBuilder: $1.Point2D.create)
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'rotationDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'fontFamily')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TextEntity clone() => TextEntity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TextEntity copyWith(void Function(TextEntity) updates) => super.copyWith((message) => updates(message as TextEntity)) as TextEntity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextEntity create() => TextEntity._();
  TextEntity createEmptyInstance() => create();
  static $pb.PbList<TextEntity> createRepeated() => $pb.PbList<TextEntity>();
  @$core.pragma('dart2js:noInline')
  static TextEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextEntity>(create);
  static TextEntity? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Point2D get anchor => $_getN(0);
  @$pb.TagNumber(1)
  set anchor($1.Point2D v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAnchor() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnchor() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Point2D ensureAnchor() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get rotationDeg => $_getN(2);
  @$pb.TagNumber(3)
  set rotationDeg($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRotationDeg() => $_has(2);
  @$pb.TagNumber(3)
  void clearRotationDeg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get height => $_getN(3);
  @$pb.TagNumber(4)
  set height($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get fontFamily => $_getSZ(4);
  @$pb.TagNumber(5)
  set fontFamily($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFontFamily() => $_has(4);
  @$pb.TagNumber(5)
  void clearFontFamily() => $_clearField(5);
}

class DimensionEntity extends $pb.GeneratedMessage {
  factory DimensionEntity({
    $1.Point2D? start,
    $1.Point2D? end,
    $1.Point2D? textAnchor,
    $core.String? unit,
    $core.double? precision,
  }) {
    final $result = create();
    if (start != null) {
      $result.start = start;
    }
    if (end != null) {
      $result.end = end;
    }
    if (textAnchor != null) {
      $result.textAnchor = textAnchor;
    }
    if (unit != null) {
      $result.unit = unit;
    }
    if (precision != null) {
      $result.precision = precision;
    }
    return $result;
  }
  DimensionEntity._() : super();
  factory DimensionEntity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DimensionEntity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DimensionEntity', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<$1.Point2D>(1, _omitFieldNames ? '' : 'start', subBuilder: $1.Point2D.create)
    ..aOM<$1.Point2D>(2, _omitFieldNames ? '' : 'end', subBuilder: $1.Point2D.create)
    ..aOM<$1.Point2D>(3, _omitFieldNames ? '' : 'textAnchor', subBuilder: $1.Point2D.create)
    ..aOS(4, _omitFieldNames ? '' : 'unit')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'precision', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DimensionEntity clone() => DimensionEntity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DimensionEntity copyWith(void Function(DimensionEntity) updates) => super.copyWith((message) => updates(message as DimensionEntity)) as DimensionEntity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DimensionEntity create() => DimensionEntity._();
  DimensionEntity createEmptyInstance() => create();
  static $pb.PbList<DimensionEntity> createRepeated() => $pb.PbList<DimensionEntity>();
  @$core.pragma('dart2js:noInline')
  static DimensionEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DimensionEntity>(create);
  static DimensionEntity? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Point2D get start => $_getN(0);
  @$pb.TagNumber(1)
  set start($1.Point2D v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Point2D ensureStart() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Point2D get end => $_getN(1);
  @$pb.TagNumber(2)
  set end($1.Point2D v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Point2D ensureEnd() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Point2D get textAnchor => $_getN(2);
  @$pb.TagNumber(3)
  set textAnchor($1.Point2D v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTextAnchor() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextAnchor() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Point2D ensureTextAnchor() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get unit => $_getSZ(3);
  @$pb.TagNumber(4)
  set unit($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUnit() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get precision => $_getN(4);
  @$pb.TagNumber(5)
  set precision($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrecision() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrecision() => $_clearField(5);
}

class BlockReferenceEntity extends $pb.GeneratedMessage {
  factory BlockReferenceEntity({
    $core.String? blockDefinitionId,
    $1.Point2D? insertionPoint,
    $core.double? rotationDeg,
    $core.double? scaleX,
    $core.double? scaleY,
    $pb.PbMap<$core.String, $core.String>? attributes,
  }) {
    final $result = create();
    if (blockDefinitionId != null) {
      $result.blockDefinitionId = blockDefinitionId;
    }
    if (insertionPoint != null) {
      $result.insertionPoint = insertionPoint;
    }
    if (rotationDeg != null) {
      $result.rotationDeg = rotationDeg;
    }
    if (scaleX != null) {
      $result.scaleX = scaleX;
    }
    if (scaleY != null) {
      $result.scaleY = scaleY;
    }
    if (attributes != null) {
      $result.attributes.addAll(attributes);
    }
    return $result;
  }
  BlockReferenceEntity._() : super();
  factory BlockReferenceEntity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BlockReferenceEntity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BlockReferenceEntity', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'blockDefinitionId')
    ..aOM<$1.Point2D>(2, _omitFieldNames ? '' : 'insertionPoint', subBuilder: $1.Point2D.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'rotationDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'scaleX', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'scaleY', $pb.PbFieldType.OD)
    ..m<$core.String, $core.String>(6, _omitFieldNames ? '' : 'attributes', entryClassName: 'BlockReferenceEntity.AttributesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('drawing.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BlockReferenceEntity clone() => BlockReferenceEntity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BlockReferenceEntity copyWith(void Function(BlockReferenceEntity) updates) => super.copyWith((message) => updates(message as BlockReferenceEntity)) as BlockReferenceEntity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockReferenceEntity create() => BlockReferenceEntity._();
  BlockReferenceEntity createEmptyInstance() => create();
  static $pb.PbList<BlockReferenceEntity> createRepeated() => $pb.PbList<BlockReferenceEntity>();
  @$core.pragma('dart2js:noInline')
  static BlockReferenceEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BlockReferenceEntity>(create);
  static BlockReferenceEntity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get blockDefinitionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set blockDefinitionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBlockDefinitionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlockDefinitionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.Point2D get insertionPoint => $_getN(1);
  @$pb.TagNumber(2)
  set insertionPoint($1.Point2D v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasInsertionPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearInsertionPoint() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Point2D ensureInsertionPoint() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get rotationDeg => $_getN(2);
  @$pb.TagNumber(3)
  set rotationDeg($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRotationDeg() => $_has(2);
  @$pb.TagNumber(3)
  void clearRotationDeg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get scaleX => $_getN(3);
  @$pb.TagNumber(4)
  set scaleX($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasScaleX() => $_has(3);
  @$pb.TagNumber(4)
  void clearScaleX() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get scaleY => $_getN(4);
  @$pb.TagNumber(5)
  set scaleY($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasScaleY() => $_has(4);
  @$pb.TagNumber(5)
  void clearScaleY() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbMap<$core.String, $core.String> get attributes => $_getMap(5);
}

class LayerDefinitionEntity extends $pb.GeneratedMessage {
  factory LayerDefinitionEntity({
    $core.String? layerId,
    $core.String? name,
    $core.String? colorHex,
    $core.String? lineType,
    $core.double? lineWeightMm,
    $core.bool? visible,
    $core.bool? locked,
    $core.bool? plottable,
  }) {
    final $result = create();
    if (layerId != null) {
      $result.layerId = layerId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (colorHex != null) {
      $result.colorHex = colorHex;
    }
    if (lineType != null) {
      $result.lineType = lineType;
    }
    if (lineWeightMm != null) {
      $result.lineWeightMm = lineWeightMm;
    }
    if (visible != null) {
      $result.visible = visible;
    }
    if (locked != null) {
      $result.locked = locked;
    }
    if (plottable != null) {
      $result.plottable = plottable;
    }
    return $result;
  }
  LayerDefinitionEntity._() : super();
  factory LayerDefinitionEntity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LayerDefinitionEntity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LayerDefinitionEntity', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'layerId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'colorHex')
    ..aOS(4, _omitFieldNames ? '' : 'lineType')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'lineWeightMm', $pb.PbFieldType.OD)
    ..aOB(6, _omitFieldNames ? '' : 'visible')
    ..aOB(7, _omitFieldNames ? '' : 'locked')
    ..aOB(8, _omitFieldNames ? '' : 'plottable')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LayerDefinitionEntity clone() => LayerDefinitionEntity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LayerDefinitionEntity copyWith(void Function(LayerDefinitionEntity) updates) => super.copyWith((message) => updates(message as LayerDefinitionEntity)) as LayerDefinitionEntity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LayerDefinitionEntity create() => LayerDefinitionEntity._();
  LayerDefinitionEntity createEmptyInstance() => create();
  static $pb.PbList<LayerDefinitionEntity> createRepeated() => $pb.PbList<LayerDefinitionEntity>();
  @$core.pragma('dart2js:noInline')
  static LayerDefinitionEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LayerDefinitionEntity>(create);
  static LayerDefinitionEntity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get layerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set layerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get colorHex => $_getSZ(2);
  @$pb.TagNumber(3)
  set colorHex($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasColorHex() => $_has(2);
  @$pb.TagNumber(3)
  void clearColorHex() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get lineType => $_getSZ(3);
  @$pb.TagNumber(4)
  set lineType($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLineType() => $_has(3);
  @$pb.TagNumber(4)
  void clearLineType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get lineWeightMm => $_getN(4);
  @$pb.TagNumber(5)
  set lineWeightMm($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLineWeightMm() => $_has(4);
  @$pb.TagNumber(5)
  void clearLineWeightMm() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get visible => $_getBF(5);
  @$pb.TagNumber(6)
  set visible($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasVisible() => $_has(5);
  @$pb.TagNumber(6)
  void clearVisible() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get locked => $_getBF(6);
  @$pb.TagNumber(7)
  set locked($core.bool v) { $_setBool(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasLocked() => $_has(6);
  @$pb.TagNumber(7)
  void clearLocked() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get plottable => $_getBF(7);
  @$pb.TagNumber(8)
  set plottable($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasPlottable() => $_has(7);
  @$pb.TagNumber(8)
  void clearPlottable() => $_clearField(8);
}

class BlockDefinitionEntity extends $pb.GeneratedMessage {
  factory BlockDefinitionEntity({
    $core.String? blockDefinitionId,
    $core.String? name,
    $1.Point2D? basePoint,
    $core.Iterable<DrawingEntity>? entities,
    $pb.PbMap<$core.String, $core.String>? defaultAttributes,
  }) {
    final $result = create();
    if (blockDefinitionId != null) {
      $result.blockDefinitionId = blockDefinitionId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (basePoint != null) {
      $result.basePoint = basePoint;
    }
    if (entities != null) {
      $result.entities.addAll(entities);
    }
    if (defaultAttributes != null) {
      $result.defaultAttributes.addAll(defaultAttributes);
    }
    return $result;
  }
  BlockDefinitionEntity._() : super();
  factory BlockDefinitionEntity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BlockDefinitionEntity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BlockDefinitionEntity', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'blockDefinitionId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<$1.Point2D>(3, _omitFieldNames ? '' : 'basePoint', subBuilder: $1.Point2D.create)
    ..pc<DrawingEntity>(4, _omitFieldNames ? '' : 'entities', $pb.PbFieldType.PM, subBuilder: DrawingEntity.create)
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'defaultAttributes', entryClassName: 'BlockDefinitionEntity.DefaultAttributesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('drawing.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BlockDefinitionEntity clone() => BlockDefinitionEntity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BlockDefinitionEntity copyWith(void Function(BlockDefinitionEntity) updates) => super.copyWith((message) => updates(message as BlockDefinitionEntity)) as BlockDefinitionEntity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BlockDefinitionEntity create() => BlockDefinitionEntity._();
  BlockDefinitionEntity createEmptyInstance() => create();
  static $pb.PbList<BlockDefinitionEntity> createRepeated() => $pb.PbList<BlockDefinitionEntity>();
  @$core.pragma('dart2js:noInline')
  static BlockDefinitionEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BlockDefinitionEntity>(create);
  static BlockDefinitionEntity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get blockDefinitionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set blockDefinitionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBlockDefinitionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBlockDefinitionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Point2D get basePoint => $_getN(2);
  @$pb.TagNumber(3)
  set basePoint($1.Point2D v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBasePoint() => $_has(2);
  @$pb.TagNumber(3)
  void clearBasePoint() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Point2D ensureBasePoint() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<DrawingEntity> get entities => $_getList(3);

  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get defaultAttributes => $_getMap(4);
}

class LeaderEntity extends $pb.GeneratedMessage {
  factory LeaderEntity({
    $core.Iterable<$1.Point2D>? vertices,
    $core.String? text,
    $core.double? textHeight,
    $core.String? arrowHead,
  }) {
    final $result = create();
    if (vertices != null) {
      $result.vertices.addAll(vertices);
    }
    if (text != null) {
      $result.text = text;
    }
    if (textHeight != null) {
      $result.textHeight = textHeight;
    }
    if (arrowHead != null) {
      $result.arrowHead = arrowHead;
    }
    return $result;
  }
  LeaderEntity._() : super();
  factory LeaderEntity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LeaderEntity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LeaderEntity', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..pc<$1.Point2D>(1, _omitFieldNames ? '' : 'vertices', $pb.PbFieldType.PM, subBuilder: $1.Point2D.create)
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'textHeight', $pb.PbFieldType.OD)
    ..aOS(4, _omitFieldNames ? '' : 'arrowHead')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LeaderEntity clone() => LeaderEntity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LeaderEntity copyWith(void Function(LeaderEntity) updates) => super.copyWith((message) => updates(message as LeaderEntity)) as LeaderEntity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LeaderEntity create() => LeaderEntity._();
  LeaderEntity createEmptyInstance() => create();
  static $pb.PbList<LeaderEntity> createRepeated() => $pb.PbList<LeaderEntity>();
  @$core.pragma('dart2js:noInline')
  static LeaderEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LeaderEntity>(create);
  static LeaderEntity? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.Point2D> get vertices => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get textHeight => $_getN(2);
  @$pb.TagNumber(3)
  set textHeight($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTextHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextHeight() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get arrowHead => $_getSZ(3);
  @$pb.TagNumber(4)
  set arrowHead($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasArrowHead() => $_has(3);
  @$pb.TagNumber(4)
  void clearArrowHead() => $_clearField(4);
}

class SheetEntity extends $pb.GeneratedMessage {
  factory SheetEntity({
    $core.String? sheetId,
    $core.String? title,
    $core.double? pageWidthMm,
    $core.double? pageHeightMm,
    $core.double? viewScale,
    $core.Iterable<$core.String>? viewportEntityIds,
    $core.String? titleBlockName,
    $core.String? metadataJson,
  }) {
    final $result = create();
    if (sheetId != null) {
      $result.sheetId = sheetId;
    }
    if (title != null) {
      $result.title = title;
    }
    if (pageWidthMm != null) {
      $result.pageWidthMm = pageWidthMm;
    }
    if (pageHeightMm != null) {
      $result.pageHeightMm = pageHeightMm;
    }
    if (viewScale != null) {
      $result.viewScale = viewScale;
    }
    if (viewportEntityIds != null) {
      $result.viewportEntityIds.addAll(viewportEntityIds);
    }
    if (titleBlockName != null) {
      $result.titleBlockName = titleBlockName;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    return $result;
  }
  SheetEntity._() : super();
  factory SheetEntity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SheetEntity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SheetEntity', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sheetId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'pageWidthMm', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'pageHeightMm', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'viewScale', $pb.PbFieldType.OD)
    ..pPS(6, _omitFieldNames ? '' : 'viewportEntityIds')
    ..aOS(7, _omitFieldNames ? '' : 'titleBlockName')
    ..aOS(8, _omitFieldNames ? '' : 'metadataJson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SheetEntity clone() => SheetEntity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SheetEntity copyWith(void Function(SheetEntity) updates) => super.copyWith((message) => updates(message as SheetEntity)) as SheetEntity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SheetEntity create() => SheetEntity._();
  SheetEntity createEmptyInstance() => create();
  static $pb.PbList<SheetEntity> createRepeated() => $pb.PbList<SheetEntity>();
  @$core.pragma('dart2js:noInline')
  static SheetEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SheetEntity>(create);
  static SheetEntity? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sheetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sheetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSheetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSheetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get pageWidthMm => $_getN(2);
  @$pb.TagNumber(3)
  set pageWidthMm($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPageWidthMm() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageWidthMm() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get pageHeightMm => $_getN(3);
  @$pb.TagNumber(4)
  set pageHeightMm($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPageHeightMm() => $_has(3);
  @$pb.TagNumber(4)
  void clearPageHeightMm() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get viewScale => $_getN(4);
  @$pb.TagNumber(5)
  set viewScale($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasViewScale() => $_has(4);
  @$pb.TagNumber(5)
  void clearViewScale() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get viewportEntityIds => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get titleBlockName => $_getSZ(6);
  @$pb.TagNumber(7)
  set titleBlockName($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasTitleBlockName() => $_has(6);
  @$pb.TagNumber(7)
  void clearTitleBlockName() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get metadataJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set metadataJson($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMetadataJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearMetadataJson() => $_clearField(8);
}

enum DrawingEntity_Geometry {
  polyline, 
  polygon, 
  text, 
  dimension, 
  blockReference, 
  layerDefinition, 
  blockDefinition, 
  leader, 
  sheet, 
  notSet
}

class DrawingEntity extends $pb.GeneratedMessage {
  factory DrawingEntity({
    EntityHeader? header,
    PolylineEntity? polyline,
    PolygonEntity? polygon,
    TextEntity? text,
    DimensionEntity? dimension,
    BlockReferenceEntity? blockReference,
    LayerDefinitionEntity? layerDefinition,
    BlockDefinitionEntity? blockDefinition,
    LeaderEntity? leader,
    SheetEntity? sheet,
  }) {
    final $result = create();
    if (header != null) {
      $result.header = header;
    }
    if (polyline != null) {
      $result.polyline = polyline;
    }
    if (polygon != null) {
      $result.polygon = polygon;
    }
    if (text != null) {
      $result.text = text;
    }
    if (dimension != null) {
      $result.dimension = dimension;
    }
    if (blockReference != null) {
      $result.blockReference = blockReference;
    }
    if (layerDefinition != null) {
      $result.layerDefinition = layerDefinition;
    }
    if (blockDefinition != null) {
      $result.blockDefinition = blockDefinition;
    }
    if (leader != null) {
      $result.leader = leader;
    }
    if (sheet != null) {
      $result.sheet = sheet;
    }
    return $result;
  }
  DrawingEntity._() : super();
  factory DrawingEntity.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DrawingEntity.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, DrawingEntity_Geometry> _DrawingEntity_GeometryByTag = {
    2 : DrawingEntity_Geometry.polyline,
    3 : DrawingEntity_Geometry.polygon,
    4 : DrawingEntity_Geometry.text,
    5 : DrawingEntity_Geometry.dimension,
    6 : DrawingEntity_Geometry.blockReference,
    7 : DrawingEntity_Geometry.layerDefinition,
    8 : DrawingEntity_Geometry.blockDefinition,
    9 : DrawingEntity_Geometry.leader,
    10 : DrawingEntity_Geometry.sheet,
    0 : DrawingEntity_Geometry.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DrawingEntity', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5, 6, 7, 8, 9, 10])
    ..aOM<EntityHeader>(1, _omitFieldNames ? '' : 'header', subBuilder: EntityHeader.create)
    ..aOM<PolylineEntity>(2, _omitFieldNames ? '' : 'polyline', subBuilder: PolylineEntity.create)
    ..aOM<PolygonEntity>(3, _omitFieldNames ? '' : 'polygon', subBuilder: PolygonEntity.create)
    ..aOM<TextEntity>(4, _omitFieldNames ? '' : 'text', subBuilder: TextEntity.create)
    ..aOM<DimensionEntity>(5, _omitFieldNames ? '' : 'dimension', subBuilder: DimensionEntity.create)
    ..aOM<BlockReferenceEntity>(6, _omitFieldNames ? '' : 'blockReference', subBuilder: BlockReferenceEntity.create)
    ..aOM<LayerDefinitionEntity>(7, _omitFieldNames ? '' : 'layerDefinition', subBuilder: LayerDefinitionEntity.create)
    ..aOM<BlockDefinitionEntity>(8, _omitFieldNames ? '' : 'blockDefinition', subBuilder: BlockDefinitionEntity.create)
    ..aOM<LeaderEntity>(9, _omitFieldNames ? '' : 'leader', subBuilder: LeaderEntity.create)
    ..aOM<SheetEntity>(10, _omitFieldNames ? '' : 'sheet', subBuilder: SheetEntity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DrawingEntity clone() => DrawingEntity()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DrawingEntity copyWith(void Function(DrawingEntity) updates) => super.copyWith((message) => updates(message as DrawingEntity)) as DrawingEntity;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DrawingEntity create() => DrawingEntity._();
  DrawingEntity createEmptyInstance() => create();
  static $pb.PbList<DrawingEntity> createRepeated() => $pb.PbList<DrawingEntity>();
  @$core.pragma('dart2js:noInline')
  static DrawingEntity getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DrawingEntity>(create);
  static DrawingEntity? _defaultInstance;

  DrawingEntity_Geometry whichGeometry() => _DrawingEntity_GeometryByTag[$_whichOneof(0)]!;
  void clearGeometry() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  EntityHeader get header => $_getN(0);
  @$pb.TagNumber(1)
  set header(EntityHeader v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasHeader() => $_has(0);
  @$pb.TagNumber(1)
  void clearHeader() => $_clearField(1);
  @$pb.TagNumber(1)
  EntityHeader ensureHeader() => $_ensure(0);

  @$pb.TagNumber(2)
  PolylineEntity get polyline => $_getN(1);
  @$pb.TagNumber(2)
  set polyline(PolylineEntity v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPolyline() => $_has(1);
  @$pb.TagNumber(2)
  void clearPolyline() => $_clearField(2);
  @$pb.TagNumber(2)
  PolylineEntity ensurePolyline() => $_ensure(1);

  @$pb.TagNumber(3)
  PolygonEntity get polygon => $_getN(2);
  @$pb.TagNumber(3)
  set polygon(PolygonEntity v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPolygon() => $_has(2);
  @$pb.TagNumber(3)
  void clearPolygon() => $_clearField(3);
  @$pb.TagNumber(3)
  PolygonEntity ensurePolygon() => $_ensure(2);

  @$pb.TagNumber(4)
  TextEntity get text => $_getN(3);
  @$pb.TagNumber(4)
  set text(TextEntity v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasText() => $_has(3);
  @$pb.TagNumber(4)
  void clearText() => $_clearField(4);
  @$pb.TagNumber(4)
  TextEntity ensureText() => $_ensure(3);

  @$pb.TagNumber(5)
  DimensionEntity get dimension => $_getN(4);
  @$pb.TagNumber(5)
  set dimension(DimensionEntity v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasDimension() => $_has(4);
  @$pb.TagNumber(5)
  void clearDimension() => $_clearField(5);
  @$pb.TagNumber(5)
  DimensionEntity ensureDimension() => $_ensure(4);

  @$pb.TagNumber(6)
  BlockReferenceEntity get blockReference => $_getN(5);
  @$pb.TagNumber(6)
  set blockReference(BlockReferenceEntity v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasBlockReference() => $_has(5);
  @$pb.TagNumber(6)
  void clearBlockReference() => $_clearField(6);
  @$pb.TagNumber(6)
  BlockReferenceEntity ensureBlockReference() => $_ensure(5);

  @$pb.TagNumber(7)
  LayerDefinitionEntity get layerDefinition => $_getN(6);
  @$pb.TagNumber(7)
  set layerDefinition(LayerDefinitionEntity v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasLayerDefinition() => $_has(6);
  @$pb.TagNumber(7)
  void clearLayerDefinition() => $_clearField(7);
  @$pb.TagNumber(7)
  LayerDefinitionEntity ensureLayerDefinition() => $_ensure(6);

  @$pb.TagNumber(8)
  BlockDefinitionEntity get blockDefinition => $_getN(7);
  @$pb.TagNumber(8)
  set blockDefinition(BlockDefinitionEntity v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasBlockDefinition() => $_has(7);
  @$pb.TagNumber(8)
  void clearBlockDefinition() => $_clearField(8);
  @$pb.TagNumber(8)
  BlockDefinitionEntity ensureBlockDefinition() => $_ensure(7);

  @$pb.TagNumber(9)
  LeaderEntity get leader => $_getN(8);
  @$pb.TagNumber(9)
  set leader(LeaderEntity v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasLeader() => $_has(8);
  @$pb.TagNumber(9)
  void clearLeader() => $_clearField(9);
  @$pb.TagNumber(9)
  LeaderEntity ensureLeader() => $_ensure(8);

  @$pb.TagNumber(10)
  SheetEntity get sheet => $_getN(9);
  @$pb.TagNumber(10)
  set sheet(SheetEntity v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasSheet() => $_has(9);
  @$pb.TagNumber(10)
  void clearSheet() => $_clearField(10);
  @$pb.TagNumber(10)
  SheetEntity ensureSheet() => $_ensure(9);
}

class RevisionPointer extends $pb.GeneratedMessage {
  factory RevisionPointer({
    $core.String? revisionId,
    $core.String? parentRevisionId,
    $core.String? author,
    $core.String? summary,
    $0.Timestamp? committedAt,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (revisionId != null) {
      $result.revisionId = revisionId;
    }
    if (parentRevisionId != null) {
      $result.parentRevisionId = parentRevisionId;
    }
    if (author != null) {
      $result.author = author;
    }
    if (summary != null) {
      $result.summary = summary;
    }
    if (committedAt != null) {
      $result.committedAt = committedAt;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  RevisionPointer._() : super();
  factory RevisionPointer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RevisionPointer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RevisionPointer', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'revisionId')
    ..aOS(2, _omitFieldNames ? '' : 'parentRevisionId')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'committedAt', subBuilder: $0.Timestamp.create)
    ..aOM<$1.ContractMetadata>(6, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RevisionPointer clone() => RevisionPointer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RevisionPointer copyWith(void Function(RevisionPointer) updates) => super.copyWith((message) => updates(message as RevisionPointer)) as RevisionPointer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevisionPointer create() => RevisionPointer._();
  RevisionPointer createEmptyInstance() => create();
  static $pb.PbList<RevisionPointer> createRepeated() => $pb.PbList<RevisionPointer>();
  @$core.pragma('dart2js:noInline')
  static RevisionPointer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RevisionPointer>(create);
  static RevisionPointer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get revisionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set revisionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRevisionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRevisionId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get parentRevisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set parentRevisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasParentRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearParentRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get author => $_getSZ(2);
  @$pb.TagNumber(3)
  set author($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get committedAt => $_getN(4);
  @$pb.TagNumber(5)
  set committedAt($0.Timestamp v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCommittedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCommittedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureCommittedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.ContractMetadata get contract => $_getN(5);
  @$pb.TagNumber(6)
  set contract($1.ContractMetadata v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasContract() => $_has(5);
  @$pb.TagNumber(6)
  void clearContract() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.ContractMetadata ensureContract() => $_ensure(5);
}

class DrawingMutation extends $pb.GeneratedMessage {
  factory DrawingMutation({
    RevisionAction? action,
    $core.String? entityId,
    DrawingEntity? before,
    DrawingEntity? after,
  }) {
    final $result = create();
    if (action != null) {
      $result.action = action;
    }
    if (entityId != null) {
      $result.entityId = entityId;
    }
    if (before != null) {
      $result.before = before;
    }
    if (after != null) {
      $result.after = after;
    }
    return $result;
  }
  DrawingMutation._() : super();
  factory DrawingMutation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DrawingMutation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DrawingMutation', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..e<RevisionAction>(1, _omitFieldNames ? '' : 'action', $pb.PbFieldType.OE, defaultOrMaker: RevisionAction.REVISION_ACTION_UNSPECIFIED, valueOf: RevisionAction.valueOf, enumValues: RevisionAction.values)
    ..aOS(2, _omitFieldNames ? '' : 'entityId')
    ..aOM<DrawingEntity>(3, _omitFieldNames ? '' : 'before', subBuilder: DrawingEntity.create)
    ..aOM<DrawingEntity>(4, _omitFieldNames ? '' : 'after', subBuilder: DrawingEntity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DrawingMutation clone() => DrawingMutation()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DrawingMutation copyWith(void Function(DrawingMutation) updates) => super.copyWith((message) => updates(message as DrawingMutation)) as DrawingMutation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DrawingMutation create() => DrawingMutation._();
  DrawingMutation createEmptyInstance() => create();
  static $pb.PbList<DrawingMutation> createRepeated() => $pb.PbList<DrawingMutation>();
  @$core.pragma('dart2js:noInline')
  static DrawingMutation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DrawingMutation>(create);
  static DrawingMutation? _defaultInstance;

  @$pb.TagNumber(1)
  RevisionAction get action => $_getN(0);
  @$pb.TagNumber(1)
  set action(RevisionAction v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAction() => $_has(0);
  @$pb.TagNumber(1)
  void clearAction() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get entityId => $_getSZ(1);
  @$pb.TagNumber(2)
  set entityId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEntityId() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntityId() => $_clearField(2);

  @$pb.TagNumber(3)
  DrawingEntity get before => $_getN(2);
  @$pb.TagNumber(3)
  set before(DrawingEntity v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBefore() => $_has(2);
  @$pb.TagNumber(3)
  void clearBefore() => $_clearField(3);
  @$pb.TagNumber(3)
  DrawingEntity ensureBefore() => $_ensure(2);

  @$pb.TagNumber(4)
  DrawingEntity get after => $_getN(3);
  @$pb.TagNumber(4)
  set after(DrawingEntity v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasAfter() => $_has(3);
  @$pb.TagNumber(4)
  void clearAfter() => $_clearField(4);
  @$pb.TagNumber(4)
  DrawingEntity ensureAfter() => $_ensure(3);
}

class DrawingCommand extends $pb.GeneratedMessage {
  factory DrawingCommand({
    $core.String? commandId,
    $core.String? drawingId,
    $core.String? actor,
    $core.Iterable<DrawingMutation>? mutations,
    $0.Timestamp? issuedAt,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (commandId != null) {
      $result.commandId = commandId;
    }
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (actor != null) {
      $result.actor = actor;
    }
    if (mutations != null) {
      $result.mutations.addAll(mutations);
    }
    if (issuedAt != null) {
      $result.issuedAt = issuedAt;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  DrawingCommand._() : super();
  factory DrawingCommand.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DrawingCommand.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DrawingCommand', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'commandId')
    ..aOS(2, _omitFieldNames ? '' : 'drawingId')
    ..aOS(3, _omitFieldNames ? '' : 'actor')
    ..pc<DrawingMutation>(4, _omitFieldNames ? '' : 'mutations', $pb.PbFieldType.PM, subBuilder: DrawingMutation.create)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'issuedAt', subBuilder: $0.Timestamp.create)
    ..aOM<$1.ContractMetadata>(6, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DrawingCommand clone() => DrawingCommand()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DrawingCommand copyWith(void Function(DrawingCommand) updates) => super.copyWith((message) => updates(message as DrawingCommand)) as DrawingCommand;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DrawingCommand create() => DrawingCommand._();
  DrawingCommand createEmptyInstance() => create();
  static $pb.PbList<DrawingCommand> createRepeated() => $pb.PbList<DrawingCommand>();
  @$core.pragma('dart2js:noInline')
  static DrawingCommand getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DrawingCommand>(create);
  static DrawingCommand? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get commandId => $_getSZ(0);
  @$pb.TagNumber(1)
  set commandId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCommandId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommandId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get drawingId => $_getSZ(1);
  @$pb.TagNumber(2)
  set drawingId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDrawingId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDrawingId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get actor => $_getSZ(2);
  @$pb.TagNumber(3)
  set actor($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasActor() => $_has(2);
  @$pb.TagNumber(3)
  void clearActor() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<DrawingMutation> get mutations => $_getList(3);

  @$pb.TagNumber(5)
  $0.Timestamp get issuedAt => $_getN(4);
  @$pb.TagNumber(5)
  set issuedAt($0.Timestamp v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasIssuedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearIssuedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureIssuedAt() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.ContractMetadata get contract => $_getN(5);
  @$pb.TagNumber(6)
  set contract($1.ContractMetadata v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasContract() => $_has(5);
  @$pb.TagNumber(6)
  void clearContract() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.ContractMetadata ensureContract() => $_ensure(5);
}

class Drawing extends $pb.GeneratedMessage {
  factory Drawing({
    $core.String? drawingId,
    $core.String? projectId,
    $core.String? name,
    $core.String? description,
    $core.String? metadataJson,
    DrawingStatus? status,
    $core.String? currentRevisionId,
    $core.int? revisionCount,
    $core.int? entityCount,
    $0.Timestamp? createdAt,
    $0.Timestamp? updatedAt,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (status != null) {
      $result.status = status;
    }
    if (currentRevisionId != null) {
      $result.currentRevisionId = currentRevisionId;
    }
    if (revisionCount != null) {
      $result.revisionCount = revisionCount;
    }
    if (entityCount != null) {
      $result.entityCount = entityCount;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      $result.updatedAt = updatedAt;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  Drawing._() : super();
  factory Drawing.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Drawing.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Drawing', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'description')
    ..aOS(5, _omitFieldNames ? '' : 'metadataJson')
    ..e<DrawingStatus>(6, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: DrawingStatus.DRAWING_STATUS_UNSPECIFIED, valueOf: DrawingStatus.valueOf, enumValues: DrawingStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'currentRevisionId')
    ..a<$core.int>(8, _omitFieldNames ? '' : 'revisionCount', $pb.PbFieldType.OU3)
    ..a<$core.int>(9, _omitFieldNames ? '' : 'entityCount', $pb.PbFieldType.OU3)
    ..aOM<$0.Timestamp>(10, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..aOM<$1.ContractMetadata>(12, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Drawing clone() => Drawing()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Drawing copyWith(void Function(Drawing) updates) => super.copyWith((message) => updates(message as Drawing)) as Drawing;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Drawing create() => Drawing._();
  Drawing createEmptyInstance() => create();
  static $pb.PbList<Drawing> createRepeated() => $pb.PbList<Drawing>();
  @$core.pragma('dart2js:noInline')
  static Drawing getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Drawing>(create);
  static Drawing? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get projectId => $_getSZ(1);
  @$pb.TagNumber(2)
  set projectId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get metadataJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set metadataJson($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMetadataJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearMetadataJson() => $_clearField(5);

  @$pb.TagNumber(6)
  DrawingStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(DrawingStatus v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get currentRevisionId => $_getSZ(6);
  @$pb.TagNumber(7)
  set currentRevisionId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCurrentRevisionId() => $_has(6);
  @$pb.TagNumber(7)
  void clearCurrentRevisionId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get revisionCount => $_getIZ(7);
  @$pb.TagNumber(8)
  set revisionCount($core.int v) { $_setUnsignedInt32(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasRevisionCount() => $_has(7);
  @$pb.TagNumber(8)
  void clearRevisionCount() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get entityCount => $_getIZ(8);
  @$pb.TagNumber(9)
  set entityCount($core.int v) { $_setUnsignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasEntityCount() => $_has(8);
  @$pb.TagNumber(9)
  void clearEntityCount() => $_clearField(9);

  @$pb.TagNumber(10)
  $0.Timestamp get createdAt => $_getN(9);
  @$pb.TagNumber(10)
  set createdAt($0.Timestamp v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasCreatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $0.Timestamp ensureCreatedAt() => $_ensure(9);

  @$pb.TagNumber(11)
  $0.Timestamp get updatedAt => $_getN(10);
  @$pb.TagNumber(11)
  set updatedAt($0.Timestamp v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasUpdatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearUpdatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureUpdatedAt() => $_ensure(10);

  @$pb.TagNumber(12)
  $1.ContractMetadata get contract => $_getN(11);
  @$pb.TagNumber(12)
  set contract($1.ContractMetadata v) { $_setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasContract() => $_has(11);
  @$pb.TagNumber(12)
  void clearContract() => $_clearField(12);
  @$pb.TagNumber(12)
  $1.ContractMetadata ensureContract() => $_ensure(11);
}

class DrawingRevision extends $pb.GeneratedMessage {
  factory DrawingRevision({
    RevisionPointer? pointer,
    $core.String? drawingId,
    $core.String? commandId,
    $core.Iterable<DrawingEntity>? entities,
  }) {
    final $result = create();
    if (pointer != null) {
      $result.pointer = pointer;
    }
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (commandId != null) {
      $result.commandId = commandId;
    }
    if (entities != null) {
      $result.entities.addAll(entities);
    }
    return $result;
  }
  DrawingRevision._() : super();
  factory DrawingRevision.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DrawingRevision.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DrawingRevision', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<RevisionPointer>(1, _omitFieldNames ? '' : 'pointer', subBuilder: RevisionPointer.create)
    ..aOS(2, _omitFieldNames ? '' : 'drawingId')
    ..aOS(3, _omitFieldNames ? '' : 'commandId')
    ..pc<DrawingEntity>(4, _omitFieldNames ? '' : 'entities', $pb.PbFieldType.PM, subBuilder: DrawingEntity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DrawingRevision clone() => DrawingRevision()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DrawingRevision copyWith(void Function(DrawingRevision) updates) => super.copyWith((message) => updates(message as DrawingRevision)) as DrawingRevision;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DrawingRevision create() => DrawingRevision._();
  DrawingRevision createEmptyInstance() => create();
  static $pb.PbList<DrawingRevision> createRepeated() => $pb.PbList<DrawingRevision>();
  @$core.pragma('dart2js:noInline')
  static DrawingRevision getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DrawingRevision>(create);
  static DrawingRevision? _defaultInstance;

  @$pb.TagNumber(1)
  RevisionPointer get pointer => $_getN(0);
  @$pb.TagNumber(1)
  set pointer(RevisionPointer v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPointer() => $_has(0);
  @$pb.TagNumber(1)
  void clearPointer() => $_clearField(1);
  @$pb.TagNumber(1)
  RevisionPointer ensurePointer() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get drawingId => $_getSZ(1);
  @$pb.TagNumber(2)
  set drawingId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDrawingId() => $_has(1);
  @$pb.TagNumber(2)
  void clearDrawingId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get commandId => $_getSZ(2);
  @$pb.TagNumber(3)
  set commandId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCommandId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommandId() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<DrawingEntity> get entities => $_getList(3);
}

class CreateDrawingRequest extends $pb.GeneratedMessage {
  factory CreateDrawingRequest({
    $core.String? projectId,
    $core.String? name,
    $core.String? description,
    $core.String? metadataJson,
    $core.String? author,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (author != null) {
      $result.author = author;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  CreateDrawingRequest._() : super();
  factory CreateDrawingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateDrawingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateDrawingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'metadataJson')
    ..aOS(5, _omitFieldNames ? '' : 'author')
    ..aOM<$1.ContractMetadata>(6, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateDrawingRequest clone() => CreateDrawingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateDrawingRequest copyWith(void Function(CreateDrawingRequest) updates) => super.copyWith((message) => updates(message as CreateDrawingRequest)) as CreateDrawingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateDrawingRequest create() => CreateDrawingRequest._();
  CreateDrawingRequest createEmptyInstance() => create();
  static $pb.PbList<CreateDrawingRequest> createRepeated() => $pb.PbList<CreateDrawingRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateDrawingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateDrawingRequest>(create);
  static CreateDrawingRequest? _defaultInstance;

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
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get metadataJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set metadataJson($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMetadataJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetadataJson() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get author => $_getSZ(4);
  @$pb.TagNumber(5)
  set author($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAuthor() => $_has(4);
  @$pb.TagNumber(5)
  void clearAuthor() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.ContractMetadata get contract => $_getN(5);
  @$pb.TagNumber(6)
  set contract($1.ContractMetadata v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasContract() => $_has(5);
  @$pb.TagNumber(6)
  void clearContract() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.ContractMetadata ensureContract() => $_ensure(5);
}

class CreateDrawingResponse extends $pb.GeneratedMessage {
  factory CreateDrawingResponse({
    Drawing? drawing,
    DrawingRevision? revision,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    return $result;
  }
  CreateDrawingResponse._() : super();
  factory CreateDrawingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateDrawingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateDrawingResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateDrawingResponse clone() => CreateDrawingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateDrawingResponse copyWith(void Function(CreateDrawingResponse) updates) => super.copyWith((message) => updates(message as CreateDrawingResponse)) as CreateDrawingResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateDrawingResponse create() => CreateDrawingResponse._();
  CreateDrawingResponse createEmptyInstance() => create();
  static $pb.PbList<CreateDrawingResponse> createRepeated() => $pb.PbList<CreateDrawingResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateDrawingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateDrawingResponse>(create);
  static CreateDrawingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);
}

class GetDrawingRequest extends $pb.GeneratedMessage {
  factory GetDrawingRequest({
    $core.String? drawingId,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    return $result;
  }
  GetDrawingRequest._() : super();
  factory GetDrawingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDrawingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDrawingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDrawingRequest clone() => GetDrawingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDrawingRequest copyWith(void Function(GetDrawingRequest) updates) => super.copyWith((message) => updates(message as GetDrawingRequest)) as GetDrawingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDrawingRequest create() => GetDrawingRequest._();
  GetDrawingRequest createEmptyInstance() => create();
  static $pb.PbList<GetDrawingRequest> createRepeated() => $pb.PbList<GetDrawingRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDrawingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDrawingRequest>(create);
  static GetDrawingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);
}

class GetDrawingResponse extends $pb.GeneratedMessage {
  factory GetDrawingResponse({
    Drawing? drawing,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    return $result;
  }
  GetDrawingResponse._() : super();
  factory GetDrawingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDrawingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDrawingResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDrawingResponse clone() => GetDrawingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDrawingResponse copyWith(void Function(GetDrawingResponse) updates) => super.copyWith((message) => updates(message as GetDrawingResponse)) as GetDrawingResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDrawingResponse create() => GetDrawingResponse._();
  GetDrawingResponse createEmptyInstance() => create();
  static $pb.PbList<GetDrawingResponse> createRepeated() => $pb.PbList<GetDrawingResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDrawingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDrawingResponse>(create);
  static GetDrawingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);
}

class ListDrawingsRequest extends $pb.GeneratedMessage {
  factory ListDrawingsRequest({
    $core.String? projectId,
    $core.int? pageSize,
    $core.String? pageToken,
    $core.bool? includeArchived,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    if (pageToken != null) {
      $result.pageToken = pageToken;
    }
    if (includeArchived != null) {
      $result.includeArchived = includeArchived;
    }
    return $result;
  }
  ListDrawingsRequest._() : super();
  factory ListDrawingsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListDrawingsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListDrawingsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'pageToken')
    ..aOB(4, _omitFieldNames ? '' : 'includeArchived')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListDrawingsRequest clone() => ListDrawingsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListDrawingsRequest copyWith(void Function(ListDrawingsRequest) updates) => super.copyWith((message) => updates(message as ListDrawingsRequest)) as ListDrawingsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDrawingsRequest create() => ListDrawingsRequest._();
  ListDrawingsRequest createEmptyInstance() => create();
  static $pb.PbList<ListDrawingsRequest> createRepeated() => $pb.PbList<ListDrawingsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListDrawingsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDrawingsRequest>(create);
  static ListDrawingsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pageToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set pageToken($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPageToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageToken() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get includeArchived => $_getBF(3);
  @$pb.TagNumber(4)
  set includeArchived($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIncludeArchived() => $_has(3);
  @$pb.TagNumber(4)
  void clearIncludeArchived() => $_clearField(4);
}

class ListDrawingsResponse extends $pb.GeneratedMessage {
  factory ListDrawingsResponse({
    $core.Iterable<Drawing>? drawings,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final $result = create();
    if (drawings != null) {
      $result.drawings.addAll(drawings);
    }
    if (nextPageToken != null) {
      $result.nextPageToken = nextPageToken;
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    return $result;
  }
  ListDrawingsResponse._() : super();
  factory ListDrawingsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListDrawingsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListDrawingsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..pc<Drawing>(1, _omitFieldNames ? '' : 'drawings', $pb.PbFieldType.PM, subBuilder: Drawing.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListDrawingsResponse clone() => ListDrawingsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListDrawingsResponse copyWith(void Function(ListDrawingsResponse) updates) => super.copyWith((message) => updates(message as ListDrawingsResponse)) as ListDrawingsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDrawingsResponse create() => ListDrawingsResponse._();
  ListDrawingsResponse createEmptyInstance() => create();
  static $pb.PbList<ListDrawingsResponse> createRepeated() => $pb.PbList<ListDrawingsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListDrawingsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDrawingsResponse>(create);
  static ListDrawingsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Drawing> get drawings => $_getList(0);

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
  set totalCount($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);
}

class UpdateDrawingRequest extends $pb.GeneratedMessage {
  factory UpdateDrawingRequest({
    $core.String? drawingId,
    $core.String? name,
    $core.String? description,
    $core.String? metadataJson,
    DrawingStatus? status,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (status != null) {
      $result.status = status;
    }
    return $result;
  }
  UpdateDrawingRequest._() : super();
  factory UpdateDrawingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateDrawingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateDrawingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOS(4, _omitFieldNames ? '' : 'metadataJson')
    ..e<DrawingStatus>(5, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: DrawingStatus.DRAWING_STATUS_UNSPECIFIED, valueOf: DrawingStatus.valueOf, enumValues: DrawingStatus.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateDrawingRequest clone() => UpdateDrawingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateDrawingRequest copyWith(void Function(UpdateDrawingRequest) updates) => super.copyWith((message) => updates(message as UpdateDrawingRequest)) as UpdateDrawingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateDrawingRequest create() => UpdateDrawingRequest._();
  UpdateDrawingRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateDrawingRequest> createRepeated() => $pb.PbList<UpdateDrawingRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateDrawingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateDrawingRequest>(create);
  static UpdateDrawingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get metadataJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set metadataJson($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMetadataJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearMetadataJson() => $_clearField(4);

  @$pb.TagNumber(5)
  DrawingStatus get status => $_getN(4);
  @$pb.TagNumber(5)
  set status(DrawingStatus v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => $_clearField(5);
}

class UpdateDrawingResponse extends $pb.GeneratedMessage {
  factory UpdateDrawingResponse({
    Drawing? drawing,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    return $result;
  }
  UpdateDrawingResponse._() : super();
  factory UpdateDrawingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateDrawingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateDrawingResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateDrawingResponse clone() => UpdateDrawingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateDrawingResponse copyWith(void Function(UpdateDrawingResponse) updates) => super.copyWith((message) => updates(message as UpdateDrawingResponse)) as UpdateDrawingResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateDrawingResponse create() => UpdateDrawingResponse._();
  UpdateDrawingResponse createEmptyInstance() => create();
  static $pb.PbList<UpdateDrawingResponse> createRepeated() => $pb.PbList<UpdateDrawingResponse>();
  @$core.pragma('dart2js:noInline')
  static UpdateDrawingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateDrawingResponse>(create);
  static UpdateDrawingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);
}

class GetDrawingStateRequest extends $pb.GeneratedMessage {
  factory GetDrawingStateRequest({
    $core.String? drawingId,
    $core.String? revisionId,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (revisionId != null) {
      $result.revisionId = revisionId;
    }
    return $result;
  }
  GetDrawingStateRequest._() : super();
  factory GetDrawingStateRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDrawingStateRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDrawingStateRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'revisionId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDrawingStateRequest clone() => GetDrawingStateRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDrawingStateRequest copyWith(void Function(GetDrawingStateRequest) updates) => super.copyWith((message) => updates(message as GetDrawingStateRequest)) as GetDrawingStateRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDrawingStateRequest create() => GetDrawingStateRequest._();
  GetDrawingStateRequest createEmptyInstance() => create();
  static $pb.PbList<GetDrawingStateRequest> createRepeated() => $pb.PbList<GetDrawingStateRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDrawingStateRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDrawingStateRequest>(create);
  static GetDrawingStateRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get revisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set revisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevisionId() => $_clearField(2);
}

class GetDrawingStateResponse extends $pb.GeneratedMessage {
  factory GetDrawingStateResponse({
    Drawing? drawing,
    DrawingRevision? revision,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    return $result;
  }
  GetDrawingStateResponse._() : super();
  factory GetDrawingStateResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDrawingStateResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDrawingStateResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDrawingStateResponse clone() => GetDrawingStateResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDrawingStateResponse copyWith(void Function(GetDrawingStateResponse) updates) => super.copyWith((message) => updates(message as GetDrawingStateResponse)) as GetDrawingStateResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDrawingStateResponse create() => GetDrawingStateResponse._();
  GetDrawingStateResponse createEmptyInstance() => create();
  static $pb.PbList<GetDrawingStateResponse> createRepeated() => $pb.PbList<GetDrawingStateResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDrawingStateResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDrawingStateResponse>(create);
  static GetDrawingStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);
}

class ListDrawingRevisionsRequest extends $pb.GeneratedMessage {
  factory ListDrawingRevisionsRequest({
    $core.String? drawingId,
    $core.int? pageSize,
    $core.String? pageToken,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    if (pageToken != null) {
      $result.pageToken = pageToken;
    }
    return $result;
  }
  ListDrawingRevisionsRequest._() : super();
  factory ListDrawingRevisionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListDrawingRevisionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListDrawingRevisionsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.OU3)
    ..aOS(3, _omitFieldNames ? '' : 'pageToken')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListDrawingRevisionsRequest clone() => ListDrawingRevisionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListDrawingRevisionsRequest copyWith(void Function(ListDrawingRevisionsRequest) updates) => super.copyWith((message) => updates(message as ListDrawingRevisionsRequest)) as ListDrawingRevisionsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDrawingRevisionsRequest create() => ListDrawingRevisionsRequest._();
  ListDrawingRevisionsRequest createEmptyInstance() => create();
  static $pb.PbList<ListDrawingRevisionsRequest> createRepeated() => $pb.PbList<ListDrawingRevisionsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListDrawingRevisionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDrawingRevisionsRequest>(create);
  static ListDrawingRevisionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get pageToken => $_getSZ(2);
  @$pb.TagNumber(3)
  set pageToken($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPageToken() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageToken() => $_clearField(3);
}

class ListDrawingRevisionsResponse extends $pb.GeneratedMessage {
  factory ListDrawingRevisionsResponse({
    $core.Iterable<RevisionPointer>? revisions,
    $core.String? nextPageToken,
    $core.int? totalCount,
  }) {
    final $result = create();
    if (revisions != null) {
      $result.revisions.addAll(revisions);
    }
    if (nextPageToken != null) {
      $result.nextPageToken = nextPageToken;
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    return $result;
  }
  ListDrawingRevisionsResponse._() : super();
  factory ListDrawingRevisionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListDrawingRevisionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListDrawingRevisionsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..pc<RevisionPointer>(1, _omitFieldNames ? '' : 'revisions', $pb.PbFieldType.PM, subBuilder: RevisionPointer.create)
    ..aOS(2, _omitFieldNames ? '' : 'nextPageToken')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListDrawingRevisionsResponse clone() => ListDrawingRevisionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListDrawingRevisionsResponse copyWith(void Function(ListDrawingRevisionsResponse) updates) => super.copyWith((message) => updates(message as ListDrawingRevisionsResponse)) as ListDrawingRevisionsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDrawingRevisionsResponse create() => ListDrawingRevisionsResponse._();
  ListDrawingRevisionsResponse createEmptyInstance() => create();
  static $pb.PbList<ListDrawingRevisionsResponse> createRepeated() => $pb.PbList<ListDrawingRevisionsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListDrawingRevisionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDrawingRevisionsResponse>(create);
  static ListDrawingRevisionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RevisionPointer> get revisions => $_getList(0);

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
  set totalCount($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTotalCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalCount() => $_clearField(3);
}

class GetDrawingRevisionRequest extends $pb.GeneratedMessage {
  factory GetDrawingRevisionRequest({
    $core.String? drawingId,
    $core.String? revisionId,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (revisionId != null) {
      $result.revisionId = revisionId;
    }
    return $result;
  }
  GetDrawingRevisionRequest._() : super();
  factory GetDrawingRevisionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDrawingRevisionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDrawingRevisionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'revisionId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDrawingRevisionRequest clone() => GetDrawingRevisionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDrawingRevisionRequest copyWith(void Function(GetDrawingRevisionRequest) updates) => super.copyWith((message) => updates(message as GetDrawingRevisionRequest)) as GetDrawingRevisionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDrawingRevisionRequest create() => GetDrawingRevisionRequest._();
  GetDrawingRevisionRequest createEmptyInstance() => create();
  static $pb.PbList<GetDrawingRevisionRequest> createRepeated() => $pb.PbList<GetDrawingRevisionRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDrawingRevisionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDrawingRevisionRequest>(create);
  static GetDrawingRevisionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get revisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set revisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevisionId() => $_clearField(2);
}

class GetDrawingRevisionResponse extends $pb.GeneratedMessage {
  factory GetDrawingRevisionResponse({
    Drawing? drawing,
    DrawingRevision? revision,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    return $result;
  }
  GetDrawingRevisionResponse._() : super();
  factory GetDrawingRevisionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDrawingRevisionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDrawingRevisionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDrawingRevisionResponse clone() => GetDrawingRevisionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDrawingRevisionResponse copyWith(void Function(GetDrawingRevisionResponse) updates) => super.copyWith((message) => updates(message as GetDrawingRevisionResponse)) as GetDrawingRevisionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDrawingRevisionResponse create() => GetDrawingRevisionResponse._();
  GetDrawingRevisionResponse createEmptyInstance() => create();
  static $pb.PbList<GetDrawingRevisionResponse> createRepeated() => $pb.PbList<GetDrawingRevisionResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDrawingRevisionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDrawingRevisionResponse>(create);
  static GetDrawingRevisionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);
}

class StoreDrawingRevisionRequest extends $pb.GeneratedMessage {
  factory StoreDrawingRevisionRequest({
    $core.String? drawingId,
    $core.String? author,
    $core.String? summary,
    $core.String? commandId,
    $core.Iterable<DrawingEntity>? entities,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (author != null) {
      $result.author = author;
    }
    if (summary != null) {
      $result.summary = summary;
    }
    if (commandId != null) {
      $result.commandId = commandId;
    }
    if (entities != null) {
      $result.entities.addAll(entities);
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  StoreDrawingRevisionRequest._() : super();
  factory StoreDrawingRevisionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StoreDrawingRevisionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StoreDrawingRevisionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'author')
    ..aOS(3, _omitFieldNames ? '' : 'summary')
    ..aOS(4, _omitFieldNames ? '' : 'commandId')
    ..pc<DrawingEntity>(5, _omitFieldNames ? '' : 'entities', $pb.PbFieldType.PM, subBuilder: DrawingEntity.create)
    ..aOM<$1.ContractMetadata>(6, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StoreDrawingRevisionRequest clone() => StoreDrawingRevisionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StoreDrawingRevisionRequest copyWith(void Function(StoreDrawingRevisionRequest) updates) => super.copyWith((message) => updates(message as StoreDrawingRevisionRequest)) as StoreDrawingRevisionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StoreDrawingRevisionRequest create() => StoreDrawingRevisionRequest._();
  StoreDrawingRevisionRequest createEmptyInstance() => create();
  static $pb.PbList<StoreDrawingRevisionRequest> createRepeated() => $pb.PbList<StoreDrawingRevisionRequest>();
  @$core.pragma('dart2js:noInline')
  static StoreDrawingRevisionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StoreDrawingRevisionRequest>(create);
  static StoreDrawingRevisionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get author => $_getSZ(1);
  @$pb.TagNumber(2)
  set author($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasAuthor() => $_has(1);
  @$pb.TagNumber(2)
  void clearAuthor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get summary => $_getSZ(2);
  @$pb.TagNumber(3)
  set summary($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSummary() => $_has(2);
  @$pb.TagNumber(3)
  void clearSummary() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get commandId => $_getSZ(3);
  @$pb.TagNumber(4)
  set commandId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCommandId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCommandId() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<DrawingEntity> get entities => $_getList(4);

  @$pb.TagNumber(6)
  $1.ContractMetadata get contract => $_getN(5);
  @$pb.TagNumber(6)
  set contract($1.ContractMetadata v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasContract() => $_has(5);
  @$pb.TagNumber(6)
  void clearContract() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.ContractMetadata ensureContract() => $_ensure(5);
}

class StoreDrawingRevisionResponse extends $pb.GeneratedMessage {
  factory StoreDrawingRevisionResponse({
    Drawing? drawing,
    DrawingRevision? revision,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    return $result;
  }
  StoreDrawingRevisionResponse._() : super();
  factory StoreDrawingRevisionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StoreDrawingRevisionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StoreDrawingRevisionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StoreDrawingRevisionResponse clone() => StoreDrawingRevisionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StoreDrawingRevisionResponse copyWith(void Function(StoreDrawingRevisionResponse) updates) => super.copyWith((message) => updates(message as StoreDrawingRevisionResponse)) as StoreDrawingRevisionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StoreDrawingRevisionResponse create() => StoreDrawingRevisionResponse._();
  StoreDrawingRevisionResponse createEmptyInstance() => create();
  static $pb.PbList<StoreDrawingRevisionResponse> createRepeated() => $pb.PbList<StoreDrawingRevisionResponse>();
  @$core.pragma('dart2js:noInline')
  static StoreDrawingRevisionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StoreDrawingRevisionResponse>(create);
  static StoreDrawingRevisionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);
}

class ValidateDrawingCommandRequest extends $pb.GeneratedMessage {
  factory ValidateDrawingCommandRequest({
    DrawingCommand? command,
    $core.String? baseRevisionId,
  }) {
    final $result = create();
    if (command != null) {
      $result.command = command;
    }
    if (baseRevisionId != null) {
      $result.baseRevisionId = baseRevisionId;
    }
    return $result;
  }
  ValidateDrawingCommandRequest._() : super();
  factory ValidateDrawingCommandRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateDrawingCommandRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateDrawingCommandRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<DrawingCommand>(1, _omitFieldNames ? '' : 'command', subBuilder: DrawingCommand.create)
    ..aOS(2, _omitFieldNames ? '' : 'baseRevisionId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateDrawingCommandRequest clone() => ValidateDrawingCommandRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateDrawingCommandRequest copyWith(void Function(ValidateDrawingCommandRequest) updates) => super.copyWith((message) => updates(message as ValidateDrawingCommandRequest)) as ValidateDrawingCommandRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateDrawingCommandRequest create() => ValidateDrawingCommandRequest._();
  ValidateDrawingCommandRequest createEmptyInstance() => create();
  static $pb.PbList<ValidateDrawingCommandRequest> createRepeated() => $pb.PbList<ValidateDrawingCommandRequest>();
  @$core.pragma('dart2js:noInline')
  static ValidateDrawingCommandRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateDrawingCommandRequest>(create);
  static ValidateDrawingCommandRequest? _defaultInstance;

  @$pb.TagNumber(1)
  DrawingCommand get command => $_getN(0);
  @$pb.TagNumber(1)
  set command(DrawingCommand v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCommand() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommand() => $_clearField(1);
  @$pb.TagNumber(1)
  DrawingCommand ensureCommand() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get baseRevisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseRevisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseRevisionId() => $_clearField(2);
}

class ValidateDrawingCommandResponse extends $pb.GeneratedMessage {
  factory ValidateDrawingCommandResponse({
    $core.bool? valid,
    $core.Iterable<$core.String>? violations,
    $core.Iterable<DrawingEntity>? resultingEntities,
  }) {
    final $result = create();
    if (valid != null) {
      $result.valid = valid;
    }
    if (violations != null) {
      $result.violations.addAll(violations);
    }
    if (resultingEntities != null) {
      $result.resultingEntities.addAll(resultingEntities);
    }
    return $result;
  }
  ValidateDrawingCommandResponse._() : super();
  factory ValidateDrawingCommandResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateDrawingCommandResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateDrawingCommandResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'valid')
    ..pPS(2, _omitFieldNames ? '' : 'violations')
    ..pc<DrawingEntity>(3, _omitFieldNames ? '' : 'resultingEntities', $pb.PbFieldType.PM, subBuilder: DrawingEntity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateDrawingCommandResponse clone() => ValidateDrawingCommandResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateDrawingCommandResponse copyWith(void Function(ValidateDrawingCommandResponse) updates) => super.copyWith((message) => updates(message as ValidateDrawingCommandResponse)) as ValidateDrawingCommandResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateDrawingCommandResponse create() => ValidateDrawingCommandResponse._();
  ValidateDrawingCommandResponse createEmptyInstance() => create();
  static $pb.PbList<ValidateDrawingCommandResponse> createRepeated() => $pb.PbList<ValidateDrawingCommandResponse>();
  @$core.pragma('dart2js:noInline')
  static ValidateDrawingCommandResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateDrawingCommandResponse>(create);
  static ValidateDrawingCommandResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get valid => $_getBF(0);
  @$pb.TagNumber(1)
  set valid($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValid() => $_has(0);
  @$pb.TagNumber(1)
  void clearValid() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get violations => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<DrawingEntity> get resultingEntities => $_getList(2);
}

class CommitDrawingCommandRequest extends $pb.GeneratedMessage {
  factory CommitDrawingCommandRequest({
    DrawingCommand? command,
    $core.String? baseRevisionId,
    $core.String? summary,
  }) {
    final $result = create();
    if (command != null) {
      $result.command = command;
    }
    if (baseRevisionId != null) {
      $result.baseRevisionId = baseRevisionId;
    }
    if (summary != null) {
      $result.summary = summary;
    }
    return $result;
  }
  CommitDrawingCommandRequest._() : super();
  factory CommitDrawingCommandRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommitDrawingCommandRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommitDrawingCommandRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<DrawingCommand>(1, _omitFieldNames ? '' : 'command', subBuilder: DrawingCommand.create)
    ..aOS(2, _omitFieldNames ? '' : 'baseRevisionId')
    ..aOS(3, _omitFieldNames ? '' : 'summary')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommitDrawingCommandRequest clone() => CommitDrawingCommandRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommitDrawingCommandRequest copyWith(void Function(CommitDrawingCommandRequest) updates) => super.copyWith((message) => updates(message as CommitDrawingCommandRequest)) as CommitDrawingCommandRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommitDrawingCommandRequest create() => CommitDrawingCommandRequest._();
  CommitDrawingCommandRequest createEmptyInstance() => create();
  static $pb.PbList<CommitDrawingCommandRequest> createRepeated() => $pb.PbList<CommitDrawingCommandRequest>();
  @$core.pragma('dart2js:noInline')
  static CommitDrawingCommandRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommitDrawingCommandRequest>(create);
  static CommitDrawingCommandRequest? _defaultInstance;

  @$pb.TagNumber(1)
  DrawingCommand get command => $_getN(0);
  @$pb.TagNumber(1)
  set command(DrawingCommand v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCommand() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommand() => $_clearField(1);
  @$pb.TagNumber(1)
  DrawingCommand ensureCommand() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get baseRevisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseRevisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get summary => $_getSZ(2);
  @$pb.TagNumber(3)
  set summary($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSummary() => $_has(2);
  @$pb.TagNumber(3)
  void clearSummary() => $_clearField(3);
}

class CommitDrawingCommandResponse extends $pb.GeneratedMessage {
  factory CommitDrawingCommandResponse({
    Drawing? drawing,
    DrawingRevision? revision,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    return $result;
  }
  CommitDrawingCommandResponse._() : super();
  factory CommitDrawingCommandResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CommitDrawingCommandResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CommitDrawingCommandResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CommitDrawingCommandResponse clone() => CommitDrawingCommandResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CommitDrawingCommandResponse copyWith(void Function(CommitDrawingCommandResponse) updates) => super.copyWith((message) => updates(message as CommitDrawingCommandResponse)) as CommitDrawingCommandResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommitDrawingCommandResponse create() => CommitDrawingCommandResponse._();
  CommitDrawingCommandResponse createEmptyInstance() => create();
  static $pb.PbList<CommitDrawingCommandResponse> createRepeated() => $pb.PbList<CommitDrawingCommandResponse>();
  @$core.pragma('dart2js:noInline')
  static CommitDrawingCommandResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CommitDrawingCommandResponse>(create);
  static CommitDrawingCommandResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);
}

class RevertDrawingRevisionRequest extends $pb.GeneratedMessage {
  factory RevertDrawingRevisionRequest({
    $core.String? drawingId,
    $core.String? targetRevisionId,
    $core.String? author,
    $core.String? summary,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (targetRevisionId != null) {
      $result.targetRevisionId = targetRevisionId;
    }
    if (author != null) {
      $result.author = author;
    }
    if (summary != null) {
      $result.summary = summary;
    }
    return $result;
  }
  RevertDrawingRevisionRequest._() : super();
  factory RevertDrawingRevisionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RevertDrawingRevisionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RevertDrawingRevisionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'targetRevisionId')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RevertDrawingRevisionRequest clone() => RevertDrawingRevisionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RevertDrawingRevisionRequest copyWith(void Function(RevertDrawingRevisionRequest) updates) => super.copyWith((message) => updates(message as RevertDrawingRevisionRequest)) as RevertDrawingRevisionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevertDrawingRevisionRequest create() => RevertDrawingRevisionRequest._();
  RevertDrawingRevisionRequest createEmptyInstance() => create();
  static $pb.PbList<RevertDrawingRevisionRequest> createRepeated() => $pb.PbList<RevertDrawingRevisionRequest>();
  @$core.pragma('dart2js:noInline')
  static RevertDrawingRevisionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RevertDrawingRevisionRequest>(create);
  static RevertDrawingRevisionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get targetRevisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set targetRevisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get author => $_getSZ(2);
  @$pb.TagNumber(3)
  set author($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);
}

class RevertDrawingRevisionResponse extends $pb.GeneratedMessage {
  factory RevertDrawingRevisionResponse({
    Drawing? drawing,
    DrawingRevision? revision,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    return $result;
  }
  RevertDrawingRevisionResponse._() : super();
  factory RevertDrawingRevisionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RevertDrawingRevisionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RevertDrawingRevisionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RevertDrawingRevisionResponse clone() => RevertDrawingRevisionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RevertDrawingRevisionResponse copyWith(void Function(RevertDrawingRevisionResponse) updates) => super.copyWith((message) => updates(message as RevertDrawingRevisionResponse)) as RevertDrawingRevisionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RevertDrawingRevisionResponse create() => RevertDrawingRevisionResponse._();
  RevertDrawingRevisionResponse createEmptyInstance() => create();
  static $pb.PbList<RevertDrawingRevisionResponse> createRepeated() => $pb.PbList<RevertDrawingRevisionResponse>();
  @$core.pragma('dart2js:noInline')
  static RevertDrawingRevisionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RevertDrawingRevisionResponse>(create);
  static RevertDrawingRevisionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);
}

class AnnotationReference extends $pb.GeneratedMessage {
  factory AnnotationReference({
    $core.String? entityId,
    DrawingEntityType? entityType,
  }) {
    final $result = create();
    if (entityId != null) {
      $result.entityId = entityId;
    }
    if (entityType != null) {
      $result.entityType = entityType;
    }
    return $result;
  }
  AnnotationReference._() : super();
  factory AnnotationReference.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnnotationReference.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnnotationReference', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'entityId')
    ..e<DrawingEntityType>(2, _omitFieldNames ? '' : 'entityType', $pb.PbFieldType.OE, defaultOrMaker: DrawingEntityType.DRAWING_ENTITY_TYPE_UNSPECIFIED, valueOf: DrawingEntityType.valueOf, enumValues: DrawingEntityType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnnotationReference clone() => AnnotationReference()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnnotationReference copyWith(void Function(AnnotationReference) updates) => super.copyWith((message) => updates(message as AnnotationReference)) as AnnotationReference;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnnotationReference create() => AnnotationReference._();
  AnnotationReference createEmptyInstance() => create();
  static $pb.PbList<AnnotationReference> createRepeated() => $pb.PbList<AnnotationReference>();
  @$core.pragma('dart2js:noInline')
  static AnnotationReference getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnnotationReference>(create);
  static AnnotationReference? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get entityId => $_getSZ(0);
  @$pb.TagNumber(1)
  set entityId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEntityId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEntityId() => $_clearField(1);

  @$pb.TagNumber(2)
  DrawingEntityType get entityType => $_getN(1);
  @$pb.TagNumber(2)
  set entityType(DrawingEntityType v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasEntityType() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntityType() => $_clearField(2);
}

class AnnotationTextSpec extends $pb.GeneratedMessage {
  factory AnnotationTextSpec({
    $1.Point2D? anchor,
    $core.String? text,
    $core.double? rotationDeg,
    $core.double? height,
    $core.String? fontFamily,
  }) {
    final $result = create();
    if (anchor != null) {
      $result.anchor = anchor;
    }
    if (text != null) {
      $result.text = text;
    }
    if (rotationDeg != null) {
      $result.rotationDeg = rotationDeg;
    }
    if (height != null) {
      $result.height = height;
    }
    if (fontFamily != null) {
      $result.fontFamily = fontFamily;
    }
    return $result;
  }
  AnnotationTextSpec._() : super();
  factory AnnotationTextSpec.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnnotationTextSpec.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnnotationTextSpec', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<$1.Point2D>(1, _omitFieldNames ? '' : 'anchor', subBuilder: $1.Point2D.create)
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'rotationDeg', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OD)
    ..aOS(5, _omitFieldNames ? '' : 'fontFamily')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnnotationTextSpec clone() => AnnotationTextSpec()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnnotationTextSpec copyWith(void Function(AnnotationTextSpec) updates) => super.copyWith((message) => updates(message as AnnotationTextSpec)) as AnnotationTextSpec;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnnotationTextSpec create() => AnnotationTextSpec._();
  AnnotationTextSpec createEmptyInstance() => create();
  static $pb.PbList<AnnotationTextSpec> createRepeated() => $pb.PbList<AnnotationTextSpec>();
  @$core.pragma('dart2js:noInline')
  static AnnotationTextSpec getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnnotationTextSpec>(create);
  static AnnotationTextSpec? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Point2D get anchor => $_getN(0);
  @$pb.TagNumber(1)
  set anchor($1.Point2D v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAnchor() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnchor() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Point2D ensureAnchor() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get rotationDeg => $_getN(2);
  @$pb.TagNumber(3)
  set rotationDeg($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRotationDeg() => $_has(2);
  @$pb.TagNumber(3)
  void clearRotationDeg() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get height => $_getN(3);
  @$pb.TagNumber(4)
  set height($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeight() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get fontFamily => $_getSZ(4);
  @$pb.TagNumber(5)
  set fontFamily($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFontFamily() => $_has(4);
  @$pb.TagNumber(5)
  void clearFontFamily() => $_clearField(5);
}

class AnnotationDimensionSpec extends $pb.GeneratedMessage {
  factory AnnotationDimensionSpec({
    $1.Point2D? start,
    $1.Point2D? end,
    $1.Point2D? textAnchor,
    $core.String? unit,
    $core.double? precision,
    $core.Iterable<AnnotationReference>? associations,
  }) {
    final $result = create();
    if (start != null) {
      $result.start = start;
    }
    if (end != null) {
      $result.end = end;
    }
    if (textAnchor != null) {
      $result.textAnchor = textAnchor;
    }
    if (unit != null) {
      $result.unit = unit;
    }
    if (precision != null) {
      $result.precision = precision;
    }
    if (associations != null) {
      $result.associations.addAll(associations);
    }
    return $result;
  }
  AnnotationDimensionSpec._() : super();
  factory AnnotationDimensionSpec.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnnotationDimensionSpec.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnnotationDimensionSpec', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<$1.Point2D>(1, _omitFieldNames ? '' : 'start', subBuilder: $1.Point2D.create)
    ..aOM<$1.Point2D>(2, _omitFieldNames ? '' : 'end', subBuilder: $1.Point2D.create)
    ..aOM<$1.Point2D>(3, _omitFieldNames ? '' : 'textAnchor', subBuilder: $1.Point2D.create)
    ..aOS(4, _omitFieldNames ? '' : 'unit')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'precision', $pb.PbFieldType.OD)
    ..pc<AnnotationReference>(6, _omitFieldNames ? '' : 'associations', $pb.PbFieldType.PM, subBuilder: AnnotationReference.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnnotationDimensionSpec clone() => AnnotationDimensionSpec()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnnotationDimensionSpec copyWith(void Function(AnnotationDimensionSpec) updates) => super.copyWith((message) => updates(message as AnnotationDimensionSpec)) as AnnotationDimensionSpec;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnnotationDimensionSpec create() => AnnotationDimensionSpec._();
  AnnotationDimensionSpec createEmptyInstance() => create();
  static $pb.PbList<AnnotationDimensionSpec> createRepeated() => $pb.PbList<AnnotationDimensionSpec>();
  @$core.pragma('dart2js:noInline')
  static AnnotationDimensionSpec getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnnotationDimensionSpec>(create);
  static AnnotationDimensionSpec? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Point2D get start => $_getN(0);
  @$pb.TagNumber(1)
  set start($1.Point2D v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStart() => $_has(0);
  @$pb.TagNumber(1)
  void clearStart() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Point2D ensureStart() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Point2D get end => $_getN(1);
  @$pb.TagNumber(2)
  set end($1.Point2D v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasEnd() => $_has(1);
  @$pb.TagNumber(2)
  void clearEnd() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Point2D ensureEnd() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Point2D get textAnchor => $_getN(2);
  @$pb.TagNumber(3)
  set textAnchor($1.Point2D v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTextAnchor() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextAnchor() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Point2D ensureTextAnchor() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get unit => $_getSZ(3);
  @$pb.TagNumber(4)
  set unit($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUnit() => $_has(3);
  @$pb.TagNumber(4)
  void clearUnit() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get precision => $_getN(4);
  @$pb.TagNumber(5)
  set precision($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPrecision() => $_has(4);
  @$pb.TagNumber(5)
  void clearPrecision() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<AnnotationReference> get associations => $_getList(5);
}

class AnnotationLeaderSpec extends $pb.GeneratedMessage {
  factory AnnotationLeaderSpec({
    $core.Iterable<$1.Point2D>? vertices,
    $core.String? text,
    $core.double? textHeight,
    $core.String? arrowHead,
    $core.Iterable<AnnotationReference>? associations,
  }) {
    final $result = create();
    if (vertices != null) {
      $result.vertices.addAll(vertices);
    }
    if (text != null) {
      $result.text = text;
    }
    if (textHeight != null) {
      $result.textHeight = textHeight;
    }
    if (arrowHead != null) {
      $result.arrowHead = arrowHead;
    }
    if (associations != null) {
      $result.associations.addAll(associations);
    }
    return $result;
  }
  AnnotationLeaderSpec._() : super();
  factory AnnotationLeaderSpec.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnnotationLeaderSpec.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnnotationLeaderSpec', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..pc<$1.Point2D>(1, _omitFieldNames ? '' : 'vertices', $pb.PbFieldType.PM, subBuilder: $1.Point2D.create)
    ..aOS(2, _omitFieldNames ? '' : 'text')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'textHeight', $pb.PbFieldType.OD)
    ..aOS(4, _omitFieldNames ? '' : 'arrowHead')
    ..pc<AnnotationReference>(5, _omitFieldNames ? '' : 'associations', $pb.PbFieldType.PM, subBuilder: AnnotationReference.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnnotationLeaderSpec clone() => AnnotationLeaderSpec()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnnotationLeaderSpec copyWith(void Function(AnnotationLeaderSpec) updates) => super.copyWith((message) => updates(message as AnnotationLeaderSpec)) as AnnotationLeaderSpec;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnnotationLeaderSpec create() => AnnotationLeaderSpec._();
  AnnotationLeaderSpec createEmptyInstance() => create();
  static $pb.PbList<AnnotationLeaderSpec> createRepeated() => $pb.PbList<AnnotationLeaderSpec>();
  @$core.pragma('dart2js:noInline')
  static AnnotationLeaderSpec getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnnotationLeaderSpec>(create);
  static AnnotationLeaderSpec? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$1.Point2D> get vertices => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get text => $_getSZ(1);
  @$pb.TagNumber(2)
  set text($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasText() => $_has(1);
  @$pb.TagNumber(2)
  void clearText() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get textHeight => $_getN(2);
  @$pb.TagNumber(3)
  set textHeight($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTextHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearTextHeight() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get arrowHead => $_getSZ(3);
  @$pb.TagNumber(4)
  set arrowHead($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasArrowHead() => $_has(3);
  @$pb.TagNumber(4)
  void clearArrowHead() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<AnnotationReference> get associations => $_getList(4);
}

enum AnnotationSpec_Kind {
  text, 
  dimension, 
  leader, 
  notSet
}

class AnnotationSpec extends $pb.GeneratedMessage {
  factory AnnotationSpec({
    AnnotationTextSpec? text,
    AnnotationDimensionSpec? dimension,
    AnnotationLeaderSpec? leader,
  }) {
    final $result = create();
    if (text != null) {
      $result.text = text;
    }
    if (dimension != null) {
      $result.dimension = dimension;
    }
    if (leader != null) {
      $result.leader = leader;
    }
    return $result;
  }
  AnnotationSpec._() : super();
  factory AnnotationSpec.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnnotationSpec.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, AnnotationSpec_Kind> _AnnotationSpec_KindByTag = {
    1 : AnnotationSpec_Kind.text,
    2 : AnnotationSpec_Kind.dimension,
    3 : AnnotationSpec_Kind.leader,
    0 : AnnotationSpec_Kind.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnnotationSpec', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<AnnotationTextSpec>(1, _omitFieldNames ? '' : 'text', subBuilder: AnnotationTextSpec.create)
    ..aOM<AnnotationDimensionSpec>(2, _omitFieldNames ? '' : 'dimension', subBuilder: AnnotationDimensionSpec.create)
    ..aOM<AnnotationLeaderSpec>(3, _omitFieldNames ? '' : 'leader', subBuilder: AnnotationLeaderSpec.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnnotationSpec clone() => AnnotationSpec()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnnotationSpec copyWith(void Function(AnnotationSpec) updates) => super.copyWith((message) => updates(message as AnnotationSpec)) as AnnotationSpec;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnnotationSpec create() => AnnotationSpec._();
  AnnotationSpec createEmptyInstance() => create();
  static $pb.PbList<AnnotationSpec> createRepeated() => $pb.PbList<AnnotationSpec>();
  @$core.pragma('dart2js:noInline')
  static AnnotationSpec getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnnotationSpec>(create);
  static AnnotationSpec? _defaultInstance;

  AnnotationSpec_Kind whichKind() => _AnnotationSpec_KindByTag[$_whichOneof(0)]!;
  void clearKind() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  AnnotationTextSpec get text => $_getN(0);
  @$pb.TagNumber(1)
  set text(AnnotationTextSpec v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);
  @$pb.TagNumber(1)
  AnnotationTextSpec ensureText() => $_ensure(0);

  @$pb.TagNumber(2)
  AnnotationDimensionSpec get dimension => $_getN(1);
  @$pb.TagNumber(2)
  set dimension(AnnotationDimensionSpec v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDimension() => $_has(1);
  @$pb.TagNumber(2)
  void clearDimension() => $_clearField(2);
  @$pb.TagNumber(2)
  AnnotationDimensionSpec ensureDimension() => $_ensure(1);

  @$pb.TagNumber(3)
  AnnotationLeaderSpec get leader => $_getN(2);
  @$pb.TagNumber(3)
  set leader(AnnotationLeaderSpec v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLeader() => $_has(2);
  @$pb.TagNumber(3)
  void clearLeader() => $_clearField(3);
  @$pb.TagNumber(3)
  AnnotationLeaderSpec ensureLeader() => $_ensure(2);
}

class CreateAnnotationRequest extends $pb.GeneratedMessage {
  factory CreateAnnotationRequest({
    $core.String? drawingId,
    $core.String? baseRevisionId,
    $core.String? author,
    $core.String? summary,
    $core.String? layerId,
    $core.String? layerName,
    $core.String? styleId,
    $core.String? styleName,
    $core.String? metadataJson,
    AnnotationSpec? annotation,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (baseRevisionId != null) {
      $result.baseRevisionId = baseRevisionId;
    }
    if (author != null) {
      $result.author = author;
    }
    if (summary != null) {
      $result.summary = summary;
    }
    if (layerId != null) {
      $result.layerId = layerId;
    }
    if (layerName != null) {
      $result.layerName = layerName;
    }
    if (styleId != null) {
      $result.styleId = styleId;
    }
    if (styleName != null) {
      $result.styleName = styleName;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (annotation != null) {
      $result.annotation = annotation;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  CreateAnnotationRequest._() : super();
  factory CreateAnnotationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateAnnotationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateAnnotationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'baseRevisionId')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aOS(5, _omitFieldNames ? '' : 'layerId')
    ..aOS(6, _omitFieldNames ? '' : 'layerName')
    ..aOS(7, _omitFieldNames ? '' : 'styleId')
    ..aOS(8, _omitFieldNames ? '' : 'styleName')
    ..aOS(9, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<AnnotationSpec>(10, _omitFieldNames ? '' : 'annotation', subBuilder: AnnotationSpec.create)
    ..aOM<$1.ContractMetadata>(11, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateAnnotationRequest clone() => CreateAnnotationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateAnnotationRequest copyWith(void Function(CreateAnnotationRequest) updates) => super.copyWith((message) => updates(message as CreateAnnotationRequest)) as CreateAnnotationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateAnnotationRequest create() => CreateAnnotationRequest._();
  CreateAnnotationRequest createEmptyInstance() => create();
  static $pb.PbList<CreateAnnotationRequest> createRepeated() => $pb.PbList<CreateAnnotationRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateAnnotationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateAnnotationRequest>(create);
  static CreateAnnotationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get baseRevisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseRevisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get author => $_getSZ(2);
  @$pb.TagNumber(3)
  set author($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get layerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set layerId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLayerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLayerId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get layerName => $_getSZ(5);
  @$pb.TagNumber(6)
  set layerName($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLayerName() => $_has(5);
  @$pb.TagNumber(6)
  void clearLayerName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get styleId => $_getSZ(6);
  @$pb.TagNumber(7)
  set styleId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasStyleId() => $_has(6);
  @$pb.TagNumber(7)
  void clearStyleId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get styleName => $_getSZ(7);
  @$pb.TagNumber(8)
  set styleName($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasStyleName() => $_has(7);
  @$pb.TagNumber(8)
  void clearStyleName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get metadataJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set metadataJson($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMetadataJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearMetadataJson() => $_clearField(9);

  @$pb.TagNumber(10)
  AnnotationSpec get annotation => $_getN(9);
  @$pb.TagNumber(10)
  set annotation(AnnotationSpec v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasAnnotation() => $_has(9);
  @$pb.TagNumber(10)
  void clearAnnotation() => $_clearField(10);
  @$pb.TagNumber(10)
  AnnotationSpec ensureAnnotation() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.ContractMetadata get contract => $_getN(10);
  @$pb.TagNumber(11)
  set contract($1.ContractMetadata v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasContract() => $_has(10);
  @$pb.TagNumber(11)
  void clearContract() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.ContractMetadata ensureContract() => $_ensure(10);
}

class CreateAnnotationResponse extends $pb.GeneratedMessage {
  factory CreateAnnotationResponse({
    Drawing? drawing,
    DrawingRevision? revision,
    DrawingEntity? annotationEntity,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    if (annotationEntity != null) {
      $result.annotationEntity = annotationEntity;
    }
    return $result;
  }
  CreateAnnotationResponse._() : super();
  factory CreateAnnotationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateAnnotationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateAnnotationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..aOM<DrawingEntity>(3, _omitFieldNames ? '' : 'annotationEntity', subBuilder: DrawingEntity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateAnnotationResponse clone() => CreateAnnotationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateAnnotationResponse copyWith(void Function(CreateAnnotationResponse) updates) => super.copyWith((message) => updates(message as CreateAnnotationResponse)) as CreateAnnotationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateAnnotationResponse create() => CreateAnnotationResponse._();
  CreateAnnotationResponse createEmptyInstance() => create();
  static $pb.PbList<CreateAnnotationResponse> createRepeated() => $pb.PbList<CreateAnnotationResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateAnnotationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateAnnotationResponse>(create);
  static CreateAnnotationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);

  @$pb.TagNumber(3)
  DrawingEntity get annotationEntity => $_getN(2);
  @$pb.TagNumber(3)
  set annotationEntity(DrawingEntity v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasAnnotationEntity() => $_has(2);
  @$pb.TagNumber(3)
  void clearAnnotationEntity() => $_clearField(3);
  @$pb.TagNumber(3)
  DrawingEntity ensureAnnotationEntity() => $_ensure(2);
}

class RegenerateAssociativeAnnotationsRequest extends $pb.GeneratedMessage {
  factory RegenerateAssociativeAnnotationsRequest({
    $core.String? drawingId,
    $core.String? baseRevisionId,
    $core.String? author,
    $core.String? summary,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (baseRevisionId != null) {
      $result.baseRevisionId = baseRevisionId;
    }
    if (author != null) {
      $result.author = author;
    }
    if (summary != null) {
      $result.summary = summary;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  RegenerateAssociativeAnnotationsRequest._() : super();
  factory RegenerateAssociativeAnnotationsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegenerateAssociativeAnnotationsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegenerateAssociativeAnnotationsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'baseRevisionId')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aOM<$1.ContractMetadata>(5, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegenerateAssociativeAnnotationsRequest clone() => RegenerateAssociativeAnnotationsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegenerateAssociativeAnnotationsRequest copyWith(void Function(RegenerateAssociativeAnnotationsRequest) updates) => super.copyWith((message) => updates(message as RegenerateAssociativeAnnotationsRequest)) as RegenerateAssociativeAnnotationsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegenerateAssociativeAnnotationsRequest create() => RegenerateAssociativeAnnotationsRequest._();
  RegenerateAssociativeAnnotationsRequest createEmptyInstance() => create();
  static $pb.PbList<RegenerateAssociativeAnnotationsRequest> createRepeated() => $pb.PbList<RegenerateAssociativeAnnotationsRequest>();
  @$core.pragma('dart2js:noInline')
  static RegenerateAssociativeAnnotationsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegenerateAssociativeAnnotationsRequest>(create);
  static RegenerateAssociativeAnnotationsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get baseRevisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseRevisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get author => $_getSZ(2);
  @$pb.TagNumber(3)
  set author($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.ContractMetadata get contract => $_getN(4);
  @$pb.TagNumber(5)
  set contract($1.ContractMetadata v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasContract() => $_has(4);
  @$pb.TagNumber(5)
  void clearContract() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.ContractMetadata ensureContract() => $_ensure(4);
}

class RegenerateAssociativeAnnotationsResponse extends $pb.GeneratedMessage {
  factory RegenerateAssociativeAnnotationsResponse({
    Drawing? drawing,
    DrawingRevision? revision,
    $core.Iterable<DrawingEntity>? updatedAnnotations,
    $core.Iterable<$core.String>? violations,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    if (updatedAnnotations != null) {
      $result.updatedAnnotations.addAll(updatedAnnotations);
    }
    if (violations != null) {
      $result.violations.addAll(violations);
    }
    return $result;
  }
  RegenerateAssociativeAnnotationsResponse._() : super();
  factory RegenerateAssociativeAnnotationsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegenerateAssociativeAnnotationsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RegenerateAssociativeAnnotationsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..pc<DrawingEntity>(3, _omitFieldNames ? '' : 'updatedAnnotations', $pb.PbFieldType.PM, subBuilder: DrawingEntity.create)
    ..pPS(4, _omitFieldNames ? '' : 'violations')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RegenerateAssociativeAnnotationsResponse clone() => RegenerateAssociativeAnnotationsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RegenerateAssociativeAnnotationsResponse copyWith(void Function(RegenerateAssociativeAnnotationsResponse) updates) => super.copyWith((message) => updates(message as RegenerateAssociativeAnnotationsResponse)) as RegenerateAssociativeAnnotationsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RegenerateAssociativeAnnotationsResponse create() => RegenerateAssociativeAnnotationsResponse._();
  RegenerateAssociativeAnnotationsResponse createEmptyInstance() => create();
  static $pb.PbList<RegenerateAssociativeAnnotationsResponse> createRepeated() => $pb.PbList<RegenerateAssociativeAnnotationsResponse>();
  @$core.pragma('dart2js:noInline')
  static RegenerateAssociativeAnnotationsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegenerateAssociativeAnnotationsResponse>(create);
  static RegenerateAssociativeAnnotationsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<DrawingEntity> get updatedAnnotations => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get violations => $_getList(3);
}

class UpsertLayerRequest extends $pb.GeneratedMessage {
  factory UpsertLayerRequest({
    $core.String? drawingId,
    $core.String? baseRevisionId,
    $core.String? author,
    $core.String? summary,
    $core.String? metadataJson,
    LayerDefinitionEntity? layer,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (baseRevisionId != null) {
      $result.baseRevisionId = baseRevisionId;
    }
    if (author != null) {
      $result.author = author;
    }
    if (summary != null) {
      $result.summary = summary;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (layer != null) {
      $result.layer = layer;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  UpsertLayerRequest._() : super();
  factory UpsertLayerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertLayerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertLayerRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'baseRevisionId')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aOS(5, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<LayerDefinitionEntity>(6, _omitFieldNames ? '' : 'layer', subBuilder: LayerDefinitionEntity.create)
    ..aOM<$1.ContractMetadata>(7, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertLayerRequest clone() => UpsertLayerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertLayerRequest copyWith(void Function(UpsertLayerRequest) updates) => super.copyWith((message) => updates(message as UpsertLayerRequest)) as UpsertLayerRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertLayerRequest create() => UpsertLayerRequest._();
  UpsertLayerRequest createEmptyInstance() => create();
  static $pb.PbList<UpsertLayerRequest> createRepeated() => $pb.PbList<UpsertLayerRequest>();
  @$core.pragma('dart2js:noInline')
  static UpsertLayerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertLayerRequest>(create);
  static UpsertLayerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get baseRevisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseRevisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get author => $_getSZ(2);
  @$pb.TagNumber(3)
  set author($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get metadataJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set metadataJson($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMetadataJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearMetadataJson() => $_clearField(5);

  @$pb.TagNumber(6)
  LayerDefinitionEntity get layer => $_getN(5);
  @$pb.TagNumber(6)
  set layer(LayerDefinitionEntity v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasLayer() => $_has(5);
  @$pb.TagNumber(6)
  void clearLayer() => $_clearField(6);
  @$pb.TagNumber(6)
  LayerDefinitionEntity ensureLayer() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.ContractMetadata get contract => $_getN(6);
  @$pb.TagNumber(7)
  set contract($1.ContractMetadata v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasContract() => $_has(6);
  @$pb.TagNumber(7)
  void clearContract() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.ContractMetadata ensureContract() => $_ensure(6);
}

class UpsertLayerResponse extends $pb.GeneratedMessage {
  factory UpsertLayerResponse({
    Drawing? drawing,
    DrawingRevision? revision,
    DrawingEntity? layerEntity,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    if (layerEntity != null) {
      $result.layerEntity = layerEntity;
    }
    return $result;
  }
  UpsertLayerResponse._() : super();
  factory UpsertLayerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpsertLayerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpsertLayerResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..aOM<DrawingEntity>(3, _omitFieldNames ? '' : 'layerEntity', subBuilder: DrawingEntity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpsertLayerResponse clone() => UpsertLayerResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpsertLayerResponse copyWith(void Function(UpsertLayerResponse) updates) => super.copyWith((message) => updates(message as UpsertLayerResponse)) as UpsertLayerResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpsertLayerResponse create() => UpsertLayerResponse._();
  UpsertLayerResponse createEmptyInstance() => create();
  static $pb.PbList<UpsertLayerResponse> createRepeated() => $pb.PbList<UpsertLayerResponse>();
  @$core.pragma('dart2js:noInline')
  static UpsertLayerResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpsertLayerResponse>(create);
  static UpsertLayerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);

  @$pb.TagNumber(3)
  DrawingEntity get layerEntity => $_getN(2);
  @$pb.TagNumber(3)
  set layerEntity(DrawingEntity v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLayerEntity() => $_has(2);
  @$pb.TagNumber(3)
  void clearLayerEntity() => $_clearField(3);
  @$pb.TagNumber(3)
  DrawingEntity ensureLayerEntity() => $_ensure(2);
}

class CreateBlockDefinitionRequest extends $pb.GeneratedMessage {
  factory CreateBlockDefinitionRequest({
    $core.String? drawingId,
    $core.String? baseRevisionId,
    $core.String? author,
    $core.String? summary,
    $core.String? layerId,
    $core.String? layerName,
    $core.String? styleId,
    $core.String? styleName,
    $core.String? metadataJson,
    BlockDefinitionEntity? block,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (baseRevisionId != null) {
      $result.baseRevisionId = baseRevisionId;
    }
    if (author != null) {
      $result.author = author;
    }
    if (summary != null) {
      $result.summary = summary;
    }
    if (layerId != null) {
      $result.layerId = layerId;
    }
    if (layerName != null) {
      $result.layerName = layerName;
    }
    if (styleId != null) {
      $result.styleId = styleId;
    }
    if (styleName != null) {
      $result.styleName = styleName;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (block != null) {
      $result.block = block;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  CreateBlockDefinitionRequest._() : super();
  factory CreateBlockDefinitionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateBlockDefinitionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateBlockDefinitionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'baseRevisionId')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aOS(5, _omitFieldNames ? '' : 'layerId')
    ..aOS(6, _omitFieldNames ? '' : 'layerName')
    ..aOS(7, _omitFieldNames ? '' : 'styleId')
    ..aOS(8, _omitFieldNames ? '' : 'styleName')
    ..aOS(9, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<BlockDefinitionEntity>(10, _omitFieldNames ? '' : 'block', subBuilder: BlockDefinitionEntity.create)
    ..aOM<$1.ContractMetadata>(11, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateBlockDefinitionRequest clone() => CreateBlockDefinitionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateBlockDefinitionRequest copyWith(void Function(CreateBlockDefinitionRequest) updates) => super.copyWith((message) => updates(message as CreateBlockDefinitionRequest)) as CreateBlockDefinitionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateBlockDefinitionRequest create() => CreateBlockDefinitionRequest._();
  CreateBlockDefinitionRequest createEmptyInstance() => create();
  static $pb.PbList<CreateBlockDefinitionRequest> createRepeated() => $pb.PbList<CreateBlockDefinitionRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateBlockDefinitionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateBlockDefinitionRequest>(create);
  static CreateBlockDefinitionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get baseRevisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseRevisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get author => $_getSZ(2);
  @$pb.TagNumber(3)
  set author($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get layerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set layerId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLayerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLayerId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get layerName => $_getSZ(5);
  @$pb.TagNumber(6)
  set layerName($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLayerName() => $_has(5);
  @$pb.TagNumber(6)
  void clearLayerName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get styleId => $_getSZ(6);
  @$pb.TagNumber(7)
  set styleId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasStyleId() => $_has(6);
  @$pb.TagNumber(7)
  void clearStyleId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get styleName => $_getSZ(7);
  @$pb.TagNumber(8)
  set styleName($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasStyleName() => $_has(7);
  @$pb.TagNumber(8)
  void clearStyleName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get metadataJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set metadataJson($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMetadataJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearMetadataJson() => $_clearField(9);

  @$pb.TagNumber(10)
  BlockDefinitionEntity get block => $_getN(9);
  @$pb.TagNumber(10)
  set block(BlockDefinitionEntity v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasBlock() => $_has(9);
  @$pb.TagNumber(10)
  void clearBlock() => $_clearField(10);
  @$pb.TagNumber(10)
  BlockDefinitionEntity ensureBlock() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.ContractMetadata get contract => $_getN(10);
  @$pb.TagNumber(11)
  set contract($1.ContractMetadata v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasContract() => $_has(10);
  @$pb.TagNumber(11)
  void clearContract() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.ContractMetadata ensureContract() => $_ensure(10);
}

class CreateBlockDefinitionResponse extends $pb.GeneratedMessage {
  factory CreateBlockDefinitionResponse({
    Drawing? drawing,
    DrawingRevision? revision,
    DrawingEntity? blockEntity,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    if (blockEntity != null) {
      $result.blockEntity = blockEntity;
    }
    return $result;
  }
  CreateBlockDefinitionResponse._() : super();
  factory CreateBlockDefinitionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateBlockDefinitionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateBlockDefinitionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..aOM<DrawingEntity>(3, _omitFieldNames ? '' : 'blockEntity', subBuilder: DrawingEntity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateBlockDefinitionResponse clone() => CreateBlockDefinitionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateBlockDefinitionResponse copyWith(void Function(CreateBlockDefinitionResponse) updates) => super.copyWith((message) => updates(message as CreateBlockDefinitionResponse)) as CreateBlockDefinitionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateBlockDefinitionResponse create() => CreateBlockDefinitionResponse._();
  CreateBlockDefinitionResponse createEmptyInstance() => create();
  static $pb.PbList<CreateBlockDefinitionResponse> createRepeated() => $pb.PbList<CreateBlockDefinitionResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateBlockDefinitionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateBlockDefinitionResponse>(create);
  static CreateBlockDefinitionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);

  @$pb.TagNumber(3)
  DrawingEntity get blockEntity => $_getN(2);
  @$pb.TagNumber(3)
  set blockEntity(DrawingEntity v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBlockEntity() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlockEntity() => $_clearField(3);
  @$pb.TagNumber(3)
  DrawingEntity ensureBlockEntity() => $_ensure(2);
}

class InsertBlockReferenceRequest extends $pb.GeneratedMessage {
  factory InsertBlockReferenceRequest({
    $core.String? drawingId,
    $core.String? baseRevisionId,
    $core.String? author,
    $core.String? summary,
    $core.String? layerId,
    $core.String? layerName,
    $core.String? styleId,
    $core.String? styleName,
    $core.String? metadataJson,
    BlockReferenceEntity? blockReference,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (baseRevisionId != null) {
      $result.baseRevisionId = baseRevisionId;
    }
    if (author != null) {
      $result.author = author;
    }
    if (summary != null) {
      $result.summary = summary;
    }
    if (layerId != null) {
      $result.layerId = layerId;
    }
    if (layerName != null) {
      $result.layerName = layerName;
    }
    if (styleId != null) {
      $result.styleId = styleId;
    }
    if (styleName != null) {
      $result.styleName = styleName;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (blockReference != null) {
      $result.blockReference = blockReference;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  InsertBlockReferenceRequest._() : super();
  factory InsertBlockReferenceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InsertBlockReferenceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InsertBlockReferenceRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'baseRevisionId')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aOS(5, _omitFieldNames ? '' : 'layerId')
    ..aOS(6, _omitFieldNames ? '' : 'layerName')
    ..aOS(7, _omitFieldNames ? '' : 'styleId')
    ..aOS(8, _omitFieldNames ? '' : 'styleName')
    ..aOS(9, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<BlockReferenceEntity>(10, _omitFieldNames ? '' : 'blockReference', subBuilder: BlockReferenceEntity.create)
    ..aOM<$1.ContractMetadata>(11, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InsertBlockReferenceRequest clone() => InsertBlockReferenceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InsertBlockReferenceRequest copyWith(void Function(InsertBlockReferenceRequest) updates) => super.copyWith((message) => updates(message as InsertBlockReferenceRequest)) as InsertBlockReferenceRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InsertBlockReferenceRequest create() => InsertBlockReferenceRequest._();
  InsertBlockReferenceRequest createEmptyInstance() => create();
  static $pb.PbList<InsertBlockReferenceRequest> createRepeated() => $pb.PbList<InsertBlockReferenceRequest>();
  @$core.pragma('dart2js:noInline')
  static InsertBlockReferenceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InsertBlockReferenceRequest>(create);
  static InsertBlockReferenceRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get baseRevisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseRevisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get author => $_getSZ(2);
  @$pb.TagNumber(3)
  set author($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get layerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set layerId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLayerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLayerId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get layerName => $_getSZ(5);
  @$pb.TagNumber(6)
  set layerName($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLayerName() => $_has(5);
  @$pb.TagNumber(6)
  void clearLayerName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get styleId => $_getSZ(6);
  @$pb.TagNumber(7)
  set styleId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasStyleId() => $_has(6);
  @$pb.TagNumber(7)
  void clearStyleId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get styleName => $_getSZ(7);
  @$pb.TagNumber(8)
  set styleName($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasStyleName() => $_has(7);
  @$pb.TagNumber(8)
  void clearStyleName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get metadataJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set metadataJson($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMetadataJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearMetadataJson() => $_clearField(9);

  @$pb.TagNumber(10)
  BlockReferenceEntity get blockReference => $_getN(9);
  @$pb.TagNumber(10)
  set blockReference(BlockReferenceEntity v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasBlockReference() => $_has(9);
  @$pb.TagNumber(10)
  void clearBlockReference() => $_clearField(10);
  @$pb.TagNumber(10)
  BlockReferenceEntity ensureBlockReference() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.ContractMetadata get contract => $_getN(10);
  @$pb.TagNumber(11)
  set contract($1.ContractMetadata v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasContract() => $_has(10);
  @$pb.TagNumber(11)
  void clearContract() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.ContractMetadata ensureContract() => $_ensure(10);
}

class InsertBlockReferenceResponse extends $pb.GeneratedMessage {
  factory InsertBlockReferenceResponse({
    Drawing? drawing,
    DrawingRevision? revision,
    DrawingEntity? blockReferenceEntity,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    if (blockReferenceEntity != null) {
      $result.blockReferenceEntity = blockReferenceEntity;
    }
    return $result;
  }
  InsertBlockReferenceResponse._() : super();
  factory InsertBlockReferenceResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InsertBlockReferenceResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InsertBlockReferenceResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..aOM<DrawingEntity>(3, _omitFieldNames ? '' : 'blockReferenceEntity', subBuilder: DrawingEntity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InsertBlockReferenceResponse clone() => InsertBlockReferenceResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InsertBlockReferenceResponse copyWith(void Function(InsertBlockReferenceResponse) updates) => super.copyWith((message) => updates(message as InsertBlockReferenceResponse)) as InsertBlockReferenceResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InsertBlockReferenceResponse create() => InsertBlockReferenceResponse._();
  InsertBlockReferenceResponse createEmptyInstance() => create();
  static $pb.PbList<InsertBlockReferenceResponse> createRepeated() => $pb.PbList<InsertBlockReferenceResponse>();
  @$core.pragma('dart2js:noInline')
  static InsertBlockReferenceResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InsertBlockReferenceResponse>(create);
  static InsertBlockReferenceResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);

  @$pb.TagNumber(3)
  DrawingEntity get blockReferenceEntity => $_getN(2);
  @$pb.TagNumber(3)
  set blockReferenceEntity(DrawingEntity v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasBlockReferenceEntity() => $_has(2);
  @$pb.TagNumber(3)
  void clearBlockReferenceEntity() => $_clearField(3);
  @$pb.TagNumber(3)
  DrawingEntity ensureBlockReferenceEntity() => $_ensure(2);
}

class FidelityReport extends $pb.GeneratedMessage {
  factory FidelityReport({
    $core.int? sourceEntityCount,
    $core.int? outputEntityCount,
    $core.int? matchedEntityCount,
    $core.Iterable<$core.String>? warnings,
  }) {
    final $result = create();
    if (sourceEntityCount != null) {
      $result.sourceEntityCount = sourceEntityCount;
    }
    if (outputEntityCount != null) {
      $result.outputEntityCount = outputEntityCount;
    }
    if (matchedEntityCount != null) {
      $result.matchedEntityCount = matchedEntityCount;
    }
    if (warnings != null) {
      $result.warnings.addAll(warnings);
    }
    return $result;
  }
  FidelityReport._() : super();
  factory FidelityReport.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FidelityReport.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FidelityReport', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'sourceEntityCount', $pb.PbFieldType.OU3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'outputEntityCount', $pb.PbFieldType.OU3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'matchedEntityCount', $pb.PbFieldType.OU3)
    ..pPS(4, _omitFieldNames ? '' : 'warnings')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FidelityReport clone() => FidelityReport()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FidelityReport copyWith(void Function(FidelityReport) updates) => super.copyWith((message) => updates(message as FidelityReport)) as FidelityReport;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FidelityReport create() => FidelityReport._();
  FidelityReport createEmptyInstance() => create();
  static $pb.PbList<FidelityReport> createRepeated() => $pb.PbList<FidelityReport>();
  @$core.pragma('dart2js:noInline')
  static FidelityReport getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FidelityReport>(create);
  static FidelityReport? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get sourceEntityCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set sourceEntityCount($core.int v) { $_setUnsignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSourceEntityCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourceEntityCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get outputEntityCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set outputEntityCount($core.int v) { $_setUnsignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasOutputEntityCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearOutputEntityCount() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get matchedEntityCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set matchedEntityCount($core.int v) { $_setUnsignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMatchedEntityCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearMatchedEntityCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get warnings => $_getList(3);
}

class ExportDrawingRequest extends $pb.GeneratedMessage {
  factory ExportDrawingRequest({
    $core.String? drawingId,
    $core.String? revisionId,
    FileFormat? format,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (revisionId != null) {
      $result.revisionId = revisionId;
    }
    if (format != null) {
      $result.format = format;
    }
    return $result;
  }
  ExportDrawingRequest._() : super();
  factory ExportDrawingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportDrawingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExportDrawingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'revisionId')
    ..e<FileFormat>(3, _omitFieldNames ? '' : 'format', $pb.PbFieldType.OE, defaultOrMaker: FileFormat.FILE_FORMAT_UNSPECIFIED, valueOf: FileFormat.valueOf, enumValues: FileFormat.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportDrawingRequest clone() => ExportDrawingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportDrawingRequest copyWith(void Function(ExportDrawingRequest) updates) => super.copyWith((message) => updates(message as ExportDrawingRequest)) as ExportDrawingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExportDrawingRequest create() => ExportDrawingRequest._();
  ExportDrawingRequest createEmptyInstance() => create();
  static $pb.PbList<ExportDrawingRequest> createRepeated() => $pb.PbList<ExportDrawingRequest>();
  @$core.pragma('dart2js:noInline')
  static ExportDrawingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportDrawingRequest>(create);
  static ExportDrawingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get revisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set revisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  FileFormat get format => $_getN(2);
  @$pb.TagNumber(3)
  set format(FileFormat v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFormat() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormat() => $_clearField(3);
}

class ExportDrawingResponse extends $pb.GeneratedMessage {
  factory ExportDrawingResponse({
    Drawing? drawing,
    DrawingRevision? revision,
    FileFormat? format,
    $core.String? fileName,
    $core.String? contentType,
    $core.List<$core.int>? payload,
    FidelityReport? report,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    if (format != null) {
      $result.format = format;
    }
    if (fileName != null) {
      $result.fileName = fileName;
    }
    if (contentType != null) {
      $result.contentType = contentType;
    }
    if (payload != null) {
      $result.payload = payload;
    }
    if (report != null) {
      $result.report = report;
    }
    return $result;
  }
  ExportDrawingResponse._() : super();
  factory ExportDrawingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ExportDrawingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ExportDrawingResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..e<FileFormat>(3, _omitFieldNames ? '' : 'format', $pb.PbFieldType.OE, defaultOrMaker: FileFormat.FILE_FORMAT_UNSPECIFIED, valueOf: FileFormat.valueOf, enumValues: FileFormat.values)
    ..aOS(4, _omitFieldNames ? '' : 'fileName')
    ..aOS(5, _omitFieldNames ? '' : 'contentType')
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'payload', $pb.PbFieldType.OY)
    ..aOM<FidelityReport>(7, _omitFieldNames ? '' : 'report', subBuilder: FidelityReport.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ExportDrawingResponse clone() => ExportDrawingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ExportDrawingResponse copyWith(void Function(ExportDrawingResponse) updates) => super.copyWith((message) => updates(message as ExportDrawingResponse)) as ExportDrawingResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ExportDrawingResponse create() => ExportDrawingResponse._();
  ExportDrawingResponse createEmptyInstance() => create();
  static $pb.PbList<ExportDrawingResponse> createRepeated() => $pb.PbList<ExportDrawingResponse>();
  @$core.pragma('dart2js:noInline')
  static ExportDrawingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ExportDrawingResponse>(create);
  static ExportDrawingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);

  @$pb.TagNumber(3)
  FileFormat get format => $_getN(2);
  @$pb.TagNumber(3)
  set format(FileFormat v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFormat() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormat() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get fileName => $_getSZ(3);
  @$pb.TagNumber(4)
  set fileName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFileName() => $_has(3);
  @$pb.TagNumber(4)
  void clearFileName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contentType => $_getSZ(4);
  @$pb.TagNumber(5)
  set contentType($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasContentType() => $_has(4);
  @$pb.TagNumber(5)
  void clearContentType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get payload => $_getN(5);
  @$pb.TagNumber(6)
  set payload($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPayload() => $_has(5);
  @$pb.TagNumber(6)
  void clearPayload() => $_clearField(6);

  @$pb.TagNumber(7)
  FidelityReport get report => $_getN(6);
  @$pb.TagNumber(7)
  set report(FidelityReport v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasReport() => $_has(6);
  @$pb.TagNumber(7)
  void clearReport() => $_clearField(7);
  @$pb.TagNumber(7)
  FidelityReport ensureReport() => $_ensure(6);
}

class ImportDrawingRequest extends $pb.GeneratedMessage {
  factory ImportDrawingRequest({
    $core.String? drawingId,
    $core.String? baseRevisionId,
    $core.String? author,
    $core.String? summary,
    FileFormat? format,
    $core.List<$core.int>? payload,
    InteropMergeStrategy? mergeStrategy,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (baseRevisionId != null) {
      $result.baseRevisionId = baseRevisionId;
    }
    if (author != null) {
      $result.author = author;
    }
    if (summary != null) {
      $result.summary = summary;
    }
    if (format != null) {
      $result.format = format;
    }
    if (payload != null) {
      $result.payload = payload;
    }
    if (mergeStrategy != null) {
      $result.mergeStrategy = mergeStrategy;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  ImportDrawingRequest._() : super();
  factory ImportDrawingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImportDrawingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ImportDrawingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'baseRevisionId')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..e<FileFormat>(5, _omitFieldNames ? '' : 'format', $pb.PbFieldType.OE, defaultOrMaker: FileFormat.FILE_FORMAT_UNSPECIFIED, valueOf: FileFormat.valueOf, enumValues: FileFormat.values)
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'payload', $pb.PbFieldType.OY)
    ..e<InteropMergeStrategy>(7, _omitFieldNames ? '' : 'mergeStrategy', $pb.PbFieldType.OE, defaultOrMaker: InteropMergeStrategy.INTEROP_MERGE_STRATEGY_UNSPECIFIED, valueOf: InteropMergeStrategy.valueOf, enumValues: InteropMergeStrategy.values)
    ..aOM<$1.ContractMetadata>(8, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ImportDrawingRequest clone() => ImportDrawingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ImportDrawingRequest copyWith(void Function(ImportDrawingRequest) updates) => super.copyWith((message) => updates(message as ImportDrawingRequest)) as ImportDrawingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImportDrawingRequest create() => ImportDrawingRequest._();
  ImportDrawingRequest createEmptyInstance() => create();
  static $pb.PbList<ImportDrawingRequest> createRepeated() => $pb.PbList<ImportDrawingRequest>();
  @$core.pragma('dart2js:noInline')
  static ImportDrawingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImportDrawingRequest>(create);
  static ImportDrawingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get baseRevisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseRevisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get author => $_getSZ(2);
  @$pb.TagNumber(3)
  set author($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  FileFormat get format => $_getN(4);
  @$pb.TagNumber(5)
  set format(FileFormat v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasFormat() => $_has(4);
  @$pb.TagNumber(5)
  void clearFormat() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get payload => $_getN(5);
  @$pb.TagNumber(6)
  set payload($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPayload() => $_has(5);
  @$pb.TagNumber(6)
  void clearPayload() => $_clearField(6);

  @$pb.TagNumber(7)
  InteropMergeStrategy get mergeStrategy => $_getN(6);
  @$pb.TagNumber(7)
  set mergeStrategy(InteropMergeStrategy v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasMergeStrategy() => $_has(6);
  @$pb.TagNumber(7)
  void clearMergeStrategy() => $_clearField(7);

  @$pb.TagNumber(8)
  $1.ContractMetadata get contract => $_getN(7);
  @$pb.TagNumber(8)
  set contract($1.ContractMetadata v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasContract() => $_has(7);
  @$pb.TagNumber(8)
  void clearContract() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.ContractMetadata ensureContract() => $_ensure(7);
}

class ImportDrawingResponse extends $pb.GeneratedMessage {
  factory ImportDrawingResponse({
    Drawing? drawing,
    DrawingRevision? revision,
    FidelityReport? report,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    if (report != null) {
      $result.report = report;
    }
    return $result;
  }
  ImportDrawingResponse._() : super();
  factory ImportDrawingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImportDrawingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ImportDrawingResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..aOM<FidelityReport>(3, _omitFieldNames ? '' : 'report', subBuilder: FidelityReport.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ImportDrawingResponse clone() => ImportDrawingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ImportDrawingResponse copyWith(void Function(ImportDrawingResponse) updates) => super.copyWith((message) => updates(message as ImportDrawingResponse)) as ImportDrawingResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImportDrawingResponse create() => ImportDrawingResponse._();
  ImportDrawingResponse createEmptyInstance() => create();
  static $pb.PbList<ImportDrawingResponse> createRepeated() => $pb.PbList<ImportDrawingResponse>();
  @$core.pragma('dart2js:noInline')
  static ImportDrawingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImportDrawingResponse>(create);
  static ImportDrawingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);

  @$pb.TagNumber(3)
  FidelityReport get report => $_getN(2);
  @$pb.TagNumber(3)
  set report(FidelityReport v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasReport() => $_has(2);
  @$pb.TagNumber(3)
  void clearReport() => $_clearField(3);
  @$pb.TagNumber(3)
  FidelityReport ensureReport() => $_ensure(2);
}

class ValidateDrawingRoundTripRequest extends $pb.GeneratedMessage {
  factory ValidateDrawingRoundTripRequest({
    $core.String? drawingId,
    $core.String? revisionId,
    FileFormat? format,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (revisionId != null) {
      $result.revisionId = revisionId;
    }
    if (format != null) {
      $result.format = format;
    }
    return $result;
  }
  ValidateDrawingRoundTripRequest._() : super();
  factory ValidateDrawingRoundTripRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateDrawingRoundTripRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateDrawingRoundTripRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'revisionId')
    ..e<FileFormat>(3, _omitFieldNames ? '' : 'format', $pb.PbFieldType.OE, defaultOrMaker: FileFormat.FILE_FORMAT_UNSPECIFIED, valueOf: FileFormat.valueOf, enumValues: FileFormat.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateDrawingRoundTripRequest clone() => ValidateDrawingRoundTripRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateDrawingRoundTripRequest copyWith(void Function(ValidateDrawingRoundTripRequest) updates) => super.copyWith((message) => updates(message as ValidateDrawingRoundTripRequest)) as ValidateDrawingRoundTripRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateDrawingRoundTripRequest create() => ValidateDrawingRoundTripRequest._();
  ValidateDrawingRoundTripRequest createEmptyInstance() => create();
  static $pb.PbList<ValidateDrawingRoundTripRequest> createRepeated() => $pb.PbList<ValidateDrawingRoundTripRequest>();
  @$core.pragma('dart2js:noInline')
  static ValidateDrawingRoundTripRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateDrawingRoundTripRequest>(create);
  static ValidateDrawingRoundTripRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get revisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set revisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  FileFormat get format => $_getN(2);
  @$pb.TagNumber(3)
  set format(FileFormat v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFormat() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormat() => $_clearField(3);
}

class ValidateDrawingRoundTripResponse extends $pb.GeneratedMessage {
  factory ValidateDrawingRoundTripResponse({
    FidelityReport? report,
  }) {
    final $result = create();
    if (report != null) {
      $result.report = report;
    }
    return $result;
  }
  ValidateDrawingRoundTripResponse._() : super();
  factory ValidateDrawingRoundTripResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ValidateDrawingRoundTripResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ValidateDrawingRoundTripResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<FidelityReport>(1, _omitFieldNames ? '' : 'report', subBuilder: FidelityReport.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ValidateDrawingRoundTripResponse clone() => ValidateDrawingRoundTripResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ValidateDrawingRoundTripResponse copyWith(void Function(ValidateDrawingRoundTripResponse) updates) => super.copyWith((message) => updates(message as ValidateDrawingRoundTripResponse)) as ValidateDrawingRoundTripResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ValidateDrawingRoundTripResponse create() => ValidateDrawingRoundTripResponse._();
  ValidateDrawingRoundTripResponse createEmptyInstance() => create();
  static $pb.PbList<ValidateDrawingRoundTripResponse> createRepeated() => $pb.PbList<ValidateDrawingRoundTripResponse>();
  @$core.pragma('dart2js:noInline')
  static ValidateDrawingRoundTripResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ValidateDrawingRoundTripResponse>(create);
  static ValidateDrawingRoundTripResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FidelityReport get report => $_getN(0);
  @$pb.TagNumber(1)
  set report(FidelityReport v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasReport() => $_has(0);
  @$pb.TagNumber(1)
  void clearReport() => $_clearField(1);
  @$pb.TagNumber(1)
  FidelityReport ensureReport() => $_ensure(0);
}

class CreateSheetRequest extends $pb.GeneratedMessage {
  factory CreateSheetRequest({
    $core.String? drawingId,
    $core.String? baseRevisionId,
    $core.String? author,
    $core.String? summary,
    $core.String? layerId,
    $core.String? layerName,
    $core.String? styleId,
    $core.String? styleName,
    $core.String? metadataJson,
    SheetEntity? sheet,
    $1.ContractMetadata? contract,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (baseRevisionId != null) {
      $result.baseRevisionId = baseRevisionId;
    }
    if (author != null) {
      $result.author = author;
    }
    if (summary != null) {
      $result.summary = summary;
    }
    if (layerId != null) {
      $result.layerId = layerId;
    }
    if (layerName != null) {
      $result.layerName = layerName;
    }
    if (styleId != null) {
      $result.styleId = styleId;
    }
    if (styleName != null) {
      $result.styleName = styleName;
    }
    if (metadataJson != null) {
      $result.metadataJson = metadataJson;
    }
    if (sheet != null) {
      $result.sheet = sheet;
    }
    if (contract != null) {
      $result.contract = contract;
    }
    return $result;
  }
  CreateSheetRequest._() : super();
  factory CreateSheetRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateSheetRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateSheetRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'baseRevisionId')
    ..aOS(3, _omitFieldNames ? '' : 'author')
    ..aOS(4, _omitFieldNames ? '' : 'summary')
    ..aOS(5, _omitFieldNames ? '' : 'layerId')
    ..aOS(6, _omitFieldNames ? '' : 'layerName')
    ..aOS(7, _omitFieldNames ? '' : 'styleId')
    ..aOS(8, _omitFieldNames ? '' : 'styleName')
    ..aOS(9, _omitFieldNames ? '' : 'metadataJson')
    ..aOM<SheetEntity>(10, _omitFieldNames ? '' : 'sheet', subBuilder: SheetEntity.create)
    ..aOM<$1.ContractMetadata>(11, _omitFieldNames ? '' : 'contract', subBuilder: $1.ContractMetadata.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateSheetRequest clone() => CreateSheetRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateSheetRequest copyWith(void Function(CreateSheetRequest) updates) => super.copyWith((message) => updates(message as CreateSheetRequest)) as CreateSheetRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateSheetRequest create() => CreateSheetRequest._();
  CreateSheetRequest createEmptyInstance() => create();
  static $pb.PbList<CreateSheetRequest> createRepeated() => $pb.PbList<CreateSheetRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateSheetRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateSheetRequest>(create);
  static CreateSheetRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get baseRevisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set baseRevisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBaseRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearBaseRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get author => $_getSZ(2);
  @$pb.TagNumber(3)
  set author($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasAuthor() => $_has(2);
  @$pb.TagNumber(3)
  void clearAuthor() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get summary => $_getSZ(3);
  @$pb.TagNumber(4)
  set summary($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSummary() => $_has(3);
  @$pb.TagNumber(4)
  void clearSummary() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get layerId => $_getSZ(4);
  @$pb.TagNumber(5)
  set layerId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasLayerId() => $_has(4);
  @$pb.TagNumber(5)
  void clearLayerId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get layerName => $_getSZ(5);
  @$pb.TagNumber(6)
  set layerName($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasLayerName() => $_has(5);
  @$pb.TagNumber(6)
  void clearLayerName() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get styleId => $_getSZ(6);
  @$pb.TagNumber(7)
  set styleId($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasStyleId() => $_has(6);
  @$pb.TagNumber(7)
  void clearStyleId() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get styleName => $_getSZ(7);
  @$pb.TagNumber(8)
  set styleName($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasStyleName() => $_has(7);
  @$pb.TagNumber(8)
  void clearStyleName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get metadataJson => $_getSZ(8);
  @$pb.TagNumber(9)
  set metadataJson($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMetadataJson() => $_has(8);
  @$pb.TagNumber(9)
  void clearMetadataJson() => $_clearField(9);

  @$pb.TagNumber(10)
  SheetEntity get sheet => $_getN(9);
  @$pb.TagNumber(10)
  set sheet(SheetEntity v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasSheet() => $_has(9);
  @$pb.TagNumber(10)
  void clearSheet() => $_clearField(10);
  @$pb.TagNumber(10)
  SheetEntity ensureSheet() => $_ensure(9);

  @$pb.TagNumber(11)
  $1.ContractMetadata get contract => $_getN(10);
  @$pb.TagNumber(11)
  set contract($1.ContractMetadata v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasContract() => $_has(10);
  @$pb.TagNumber(11)
  void clearContract() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.ContractMetadata ensureContract() => $_ensure(10);
}

class CreateSheetResponse extends $pb.GeneratedMessage {
  factory CreateSheetResponse({
    Drawing? drawing,
    DrawingRevision? revision,
    DrawingEntity? sheetEntity,
  }) {
    final $result = create();
    if (drawing != null) {
      $result.drawing = drawing;
    }
    if (revision != null) {
      $result.revision = revision;
    }
    if (sheetEntity != null) {
      $result.sheetEntity = sheetEntity;
    }
    return $result;
  }
  CreateSheetResponse._() : super();
  factory CreateSheetResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateSheetResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateSheetResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOM<Drawing>(1, _omitFieldNames ? '' : 'drawing', subBuilder: Drawing.create)
    ..aOM<DrawingRevision>(2, _omitFieldNames ? '' : 'revision', subBuilder: DrawingRevision.create)
    ..aOM<DrawingEntity>(3, _omitFieldNames ? '' : 'sheetEntity', subBuilder: DrawingEntity.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateSheetResponse clone() => CreateSheetResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateSheetResponse copyWith(void Function(CreateSheetResponse) updates) => super.copyWith((message) => updates(message as CreateSheetResponse)) as CreateSheetResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateSheetResponse create() => CreateSheetResponse._();
  CreateSheetResponse createEmptyInstance() => create();
  static $pb.PbList<CreateSheetResponse> createRepeated() => $pb.PbList<CreateSheetResponse>();
  @$core.pragma('dart2js:noInline')
  static CreateSheetResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateSheetResponse>(create);
  static CreateSheetResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Drawing get drawing => $_getN(0);
  @$pb.TagNumber(1)
  set drawing(Drawing v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawing() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawing() => $_clearField(1);
  @$pb.TagNumber(1)
  Drawing ensureDrawing() => $_ensure(0);

  @$pb.TagNumber(2)
  DrawingRevision get revision => $_getN(1);
  @$pb.TagNumber(2)
  set revision(DrawingRevision v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevision() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevision() => $_clearField(2);
  @$pb.TagNumber(2)
  DrawingRevision ensureRevision() => $_ensure(1);

  @$pb.TagNumber(3)
  DrawingEntity get sheetEntity => $_getN(2);
  @$pb.TagNumber(3)
  set sheetEntity(DrawingEntity v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSheetEntity() => $_has(2);
  @$pb.TagNumber(3)
  void clearSheetEntity() => $_clearField(3);
  @$pb.TagNumber(3)
  DrawingEntity ensureSheetEntity() => $_ensure(2);
}

class PlotOptions extends $pb.GeneratedMessage {
  factory PlotOptions({
    $core.bool? monochrome,
    $core.bool? includeMetadata,
    $core.double? strokeWidthMm,
  }) {
    final $result = create();
    if (monochrome != null) {
      $result.monochrome = monochrome;
    }
    if (includeMetadata != null) {
      $result.includeMetadata = includeMetadata;
    }
    if (strokeWidthMm != null) {
      $result.strokeWidthMm = strokeWidthMm;
    }
    return $result;
  }
  PlotOptions._() : super();
  factory PlotOptions.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PlotOptions.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PlotOptions', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'monochrome')
    ..aOB(2, _omitFieldNames ? '' : 'includeMetadata')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'strokeWidthMm', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PlotOptions clone() => PlotOptions()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PlotOptions copyWith(void Function(PlotOptions) updates) => super.copyWith((message) => updates(message as PlotOptions)) as PlotOptions;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PlotOptions create() => PlotOptions._();
  PlotOptions createEmptyInstance() => create();
  static $pb.PbList<PlotOptions> createRepeated() => $pb.PbList<PlotOptions>();
  @$core.pragma('dart2js:noInline')
  static PlotOptions getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PlotOptions>(create);
  static PlotOptions? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get monochrome => $_getBF(0);
  @$pb.TagNumber(1)
  set monochrome($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMonochrome() => $_has(0);
  @$pb.TagNumber(1)
  void clearMonochrome() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get includeMetadata => $_getBF(1);
  @$pb.TagNumber(2)
  set includeMetadata($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIncludeMetadata() => $_has(1);
  @$pb.TagNumber(2)
  void clearIncludeMetadata() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get strokeWidthMm => $_getN(2);
  @$pb.TagNumber(3)
  set strokeWidthMm($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasStrokeWidthMm() => $_has(2);
  @$pb.TagNumber(3)
  void clearStrokeWidthMm() => $_clearField(3);
}

class PublishedSheetArtifact extends $pb.GeneratedMessage {
  factory PublishedSheetArtifact({
    $core.String? sheetId,
    $core.String? title,
    PlotOutputFormat? format,
    $core.String? fileName,
    $core.String? contentType,
    $core.List<$core.int>? payload,
  }) {
    final $result = create();
    if (sheetId != null) {
      $result.sheetId = sheetId;
    }
    if (title != null) {
      $result.title = title;
    }
    if (format != null) {
      $result.format = format;
    }
    if (fileName != null) {
      $result.fileName = fileName;
    }
    if (contentType != null) {
      $result.contentType = contentType;
    }
    if (payload != null) {
      $result.payload = payload;
    }
    return $result;
  }
  PublishedSheetArtifact._() : super();
  factory PublishedSheetArtifact.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublishedSheetArtifact.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PublishedSheetArtifact', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'sheetId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..e<PlotOutputFormat>(3, _omitFieldNames ? '' : 'format', $pb.PbFieldType.OE, defaultOrMaker: PlotOutputFormat.PLOT_OUTPUT_FORMAT_UNSPECIFIED, valueOf: PlotOutputFormat.valueOf, enumValues: PlotOutputFormat.values)
    ..aOS(4, _omitFieldNames ? '' : 'fileName')
    ..aOS(5, _omitFieldNames ? '' : 'contentType')
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'payload', $pb.PbFieldType.OY)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PublishedSheetArtifact clone() => PublishedSheetArtifact()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PublishedSheetArtifact copyWith(void Function(PublishedSheetArtifact) updates) => super.copyWith((message) => updates(message as PublishedSheetArtifact)) as PublishedSheetArtifact;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishedSheetArtifact create() => PublishedSheetArtifact._();
  PublishedSheetArtifact createEmptyInstance() => create();
  static $pb.PbList<PublishedSheetArtifact> createRepeated() => $pb.PbList<PublishedSheetArtifact>();
  @$core.pragma('dart2js:noInline')
  static PublishedSheetArtifact getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublishedSheetArtifact>(create);
  static PublishedSheetArtifact? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sheetId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sheetId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSheetId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSheetId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  PlotOutputFormat get format => $_getN(2);
  @$pb.TagNumber(3)
  set format(PlotOutputFormat v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasFormat() => $_has(2);
  @$pb.TagNumber(3)
  void clearFormat() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get fileName => $_getSZ(3);
  @$pb.TagNumber(4)
  set fileName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFileName() => $_has(3);
  @$pb.TagNumber(4)
  void clearFileName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get contentType => $_getSZ(4);
  @$pb.TagNumber(5)
  set contentType($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasContentType() => $_has(4);
  @$pb.TagNumber(5)
  void clearContentType() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get payload => $_getN(5);
  @$pb.TagNumber(6)
  set payload($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPayload() => $_has(5);
  @$pb.TagNumber(6)
  void clearPayload() => $_clearField(6);
}

class PublishDrawingRequest extends $pb.GeneratedMessage {
  factory PublishDrawingRequest({
    $core.String? drawingId,
    $core.String? revisionId,
    $core.Iterable<$core.String>? sheetIds,
    PlotOutputFormat? format,
    PlotOptions? options,
  }) {
    final $result = create();
    if (drawingId != null) {
      $result.drawingId = drawingId;
    }
    if (revisionId != null) {
      $result.revisionId = revisionId;
    }
    if (sheetIds != null) {
      $result.sheetIds.addAll(sheetIds);
    }
    if (format != null) {
      $result.format = format;
    }
    if (options != null) {
      $result.options = options;
    }
    return $result;
  }
  PublishDrawingRequest._() : super();
  factory PublishDrawingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublishDrawingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PublishDrawingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'drawingId')
    ..aOS(2, _omitFieldNames ? '' : 'revisionId')
    ..pPS(3, _omitFieldNames ? '' : 'sheetIds')
    ..e<PlotOutputFormat>(4, _omitFieldNames ? '' : 'format', $pb.PbFieldType.OE, defaultOrMaker: PlotOutputFormat.PLOT_OUTPUT_FORMAT_UNSPECIFIED, valueOf: PlotOutputFormat.valueOf, enumValues: PlotOutputFormat.values)
    ..aOM<PlotOptions>(5, _omitFieldNames ? '' : 'options', subBuilder: PlotOptions.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PublishDrawingRequest clone() => PublishDrawingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PublishDrawingRequest copyWith(void Function(PublishDrawingRequest) updates) => super.copyWith((message) => updates(message as PublishDrawingRequest)) as PublishDrawingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishDrawingRequest create() => PublishDrawingRequest._();
  PublishDrawingRequest createEmptyInstance() => create();
  static $pb.PbList<PublishDrawingRequest> createRepeated() => $pb.PbList<PublishDrawingRequest>();
  @$core.pragma('dart2js:noInline')
  static PublishDrawingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublishDrawingRequest>(create);
  static PublishDrawingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get drawingId => $_getSZ(0);
  @$pb.TagNumber(1)
  set drawingId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDrawingId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDrawingId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get revisionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set revisionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRevisionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevisionId() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get sheetIds => $_getList(2);

  @$pb.TagNumber(4)
  PlotOutputFormat get format => $_getN(3);
  @$pb.TagNumber(4)
  set format(PlotOutputFormat v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFormat() => $_has(3);
  @$pb.TagNumber(4)
  void clearFormat() => $_clearField(4);

  @$pb.TagNumber(5)
  PlotOptions get options => $_getN(4);
  @$pb.TagNumber(5)
  set options(PlotOptions v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasOptions() => $_has(4);
  @$pb.TagNumber(5)
  void clearOptions() => $_clearField(5);
  @$pb.TagNumber(5)
  PlotOptions ensureOptions() => $_ensure(4);
}

class PublishDrawingResponse extends $pb.GeneratedMessage {
  factory PublishDrawingResponse({
    $core.Iterable<PublishedSheetArtifact>? artifacts,
    $core.String? manifestJson,
  }) {
    final $result = create();
    if (artifacts != null) {
      $result.artifacts.addAll(artifacts);
    }
    if (manifestJson != null) {
      $result.manifestJson = manifestJson;
    }
    return $result;
  }
  PublishDrawingResponse._() : super();
  factory PublishDrawingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublishDrawingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PublishDrawingResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'drawing.v1'), createEmptyInstance: create)
    ..pc<PublishedSheetArtifact>(1, _omitFieldNames ? '' : 'artifacts', $pb.PbFieldType.PM, subBuilder: PublishedSheetArtifact.create)
    ..aOS(2, _omitFieldNames ? '' : 'manifestJson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PublishDrawingResponse clone() => PublishDrawingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PublishDrawingResponse copyWith(void Function(PublishDrawingResponse) updates) => super.copyWith((message) => updates(message as PublishDrawingResponse)) as PublishDrawingResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PublishDrawingResponse create() => PublishDrawingResponse._();
  PublishDrawingResponse createEmptyInstance() => create();
  static $pb.PbList<PublishDrawingResponse> createRepeated() => $pb.PbList<PublishDrawingResponse>();
  @$core.pragma('dart2js:noInline')
  static PublishDrawingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublishDrawingResponse>(create);
  static PublishDrawingResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PublishedSheetArtifact> get artifacts => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get manifestJson => $_getSZ(1);
  @$pb.TagNumber(2)
  set manifestJson($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasManifestJson() => $_has(1);
  @$pb.TagNumber(2)
  void clearManifestJson() => $_clearField(2);
}

/// DrawingRevisionService manages drawing metadata and immutable revision snapshots.
class DrawingRevisionServiceApi {
  $pb.RpcClient _client;
  DrawingRevisionServiceApi(this._client);

  /// CreateDrawing creates a new drawing and its initial empty revision.
  $async.Future<CreateDrawingResponse> createDrawing($pb.ClientContext? ctx, CreateDrawingRequest request) =>
    _client.invoke<CreateDrawingResponse>(ctx, 'DrawingRevisionService', 'CreateDrawing', request, CreateDrawingResponse())
  ;
  /// GetDrawing returns drawing metadata without materializing entity state.
  $async.Future<GetDrawingResponse> getDrawing($pb.ClientContext? ctx, GetDrawingRequest request) =>
    _client.invoke<GetDrawingResponse>(ctx, 'DrawingRevisionService', 'GetDrawing', request, GetDrawingResponse())
  ;
  /// ListDrawings returns drawings for a project in descending update order.
  $async.Future<ListDrawingsResponse> listDrawings($pb.ClientContext? ctx, ListDrawingsRequest request) =>
    _client.invoke<ListDrawingsResponse>(ctx, 'DrawingRevisionService', 'ListDrawings', request, ListDrawingsResponse())
  ;
  /// UpdateDrawing updates mutable drawing metadata and archive status.
  $async.Future<UpdateDrawingResponse> updateDrawing($pb.ClientContext? ctx, UpdateDrawingRequest request) =>
    _client.invoke<UpdateDrawingResponse>(ctx, 'DrawingRevisionService', 'UpdateDrawing', request, UpdateDrawingResponse())
  ;
  /// GetDrawingState returns a materialized snapshot for the requested revision or current head.
  $async.Future<GetDrawingStateResponse> getDrawingState($pb.ClientContext? ctx, GetDrawingStateRequest request) =>
    _client.invoke<GetDrawingStateResponse>(ctx, 'DrawingRevisionService', 'GetDrawingState', request, GetDrawingStateResponse())
  ;
  /// ListDrawingRevisions returns revision pointers for a drawing head history.
  $async.Future<ListDrawingRevisionsResponse> listDrawingRevisions($pb.ClientContext? ctx, ListDrawingRevisionsRequest request) =>
    _client.invoke<ListDrawingRevisionsResponse>(ctx, 'DrawingRevisionService', 'ListDrawingRevisions', request, ListDrawingRevisionsResponse())
  ;
  /// GetDrawingRevision returns a specific immutable drawing revision snapshot.
  $async.Future<GetDrawingRevisionResponse> getDrawingRevision($pb.ClientContext? ctx, GetDrawingRevisionRequest request) =>
    _client.invoke<GetDrawingRevisionResponse>(ctx, 'DrawingRevisionService', 'GetDrawingRevision', request, GetDrawingRevisionResponse())
  ;
  /// StoreDrawingRevision persists a new immutable snapshot and advances the drawing head.
  $async.Future<StoreDrawingRevisionResponse> storeDrawingRevision($pb.ClientContext? ctx, StoreDrawingRevisionRequest request) =>
    _client.invoke<StoreDrawingRevisionResponse>(ctx, 'DrawingRevisionService', 'StoreDrawingRevision', request, StoreDrawingRevisionResponse())
  ;
}

/// CadCoreService validates and applies drawing commands on top of revision storage.
class CadCoreServiceApi {
  $pb.RpcClient _client;
  CadCoreServiceApi(this._client);

  /// ValidateDrawingCommand validates a command against a drawing revision without persisting it.
  $async.Future<ValidateDrawingCommandResponse> validateDrawingCommand($pb.ClientContext? ctx, ValidateDrawingCommandRequest request) =>
    _client.invoke<ValidateDrawingCommandResponse>(ctx, 'CadCoreService', 'ValidateDrawingCommand', request, ValidateDrawingCommandResponse())
  ;
  /// CommitDrawingCommand validates and persists a command as a new drawing revision.
  $async.Future<CommitDrawingCommandResponse> commitDrawingCommand($pb.ClientContext? ctx, CommitDrawingCommandRequest request) =>
    _client.invoke<CommitDrawingCommandResponse>(ctx, 'CadCoreService', 'CommitDrawingCommand', request, CommitDrawingCommandResponse())
  ;
  /// RevertDrawingRevision promotes a previous revision snapshot as the new drawing head.
  $async.Future<RevertDrawingRevisionResponse> revertDrawingRevision($pb.ClientContext? ctx, RevertDrawingRevisionRequest request) =>
    _client.invoke<RevertDrawingRevisionResponse>(ctx, 'CadCoreService', 'RevertDrawingRevision', request, RevertDrawingRevisionResponse())
  ;
}

/// CadAnnotationService manages associative drafting annotations layered on CadCoreService.
class CadAnnotationServiceApi {
  $pb.RpcClient _client;
  CadAnnotationServiceApi(this._client);

  /// CreateAnnotation creates a text, dimension, or leader annotation entity on a drawing revision.
  $async.Future<CreateAnnotationResponse> createAnnotation($pb.ClientContext? ctx, CreateAnnotationRequest request) =>
    _client.invoke<CreateAnnotationResponse>(ctx, 'CadAnnotationService', 'CreateAnnotation', request, CreateAnnotationResponse())
  ;
  /// RegenerateAssociativeAnnotations recalculates associative annotations from their referenced source geometry.
  $async.Future<RegenerateAssociativeAnnotationsResponse> regenerateAssociativeAnnotations($pb.ClientContext? ctx, RegenerateAssociativeAnnotationsRequest request) =>
    _client.invoke<RegenerateAssociativeAnnotationsResponse>(ctx, 'CadAnnotationService', 'RegenerateAssociativeAnnotations', request, RegenerateAssociativeAnnotationsResponse())
  ;
}

/// CadLayerBlockService manages layer standards, block definitions, and block inserts.
class CadLayerBlockServiceApi {
  $pb.RpcClient _client;
  CadLayerBlockServiceApi(this._client);

  /// UpsertLayer creates or updates a managed layer definition entity in the drawing model.
  $async.Future<UpsertLayerResponse> upsertLayer($pb.ClientContext? ctx, UpsertLayerRequest request) =>
    _client.invoke<UpsertLayerResponse>(ctx, 'CadLayerBlockService', 'UpsertLayer', request, UpsertLayerResponse())
  ;
  /// CreateBlockDefinition stores a reusable block definition with embedded drafting geometry.
  $async.Future<CreateBlockDefinitionResponse> createBlockDefinition($pb.ClientContext? ctx, CreateBlockDefinitionRequest request) =>
    _client.invoke<CreateBlockDefinitionResponse>(ctx, 'CadLayerBlockService', 'CreateBlockDefinition', request, CreateBlockDefinitionResponse())
  ;
  /// InsertBlockReference places a block reference instance for an existing block definition.
  $async.Future<InsertBlockReferenceResponse> insertBlockReference($pb.ClientContext? ctx, InsertBlockReferenceRequest request) =>
    _client.invoke<InsertBlockReferenceResponse>(ctx, 'CadLayerBlockService', 'InsertBlockReference', request, InsertBlockReferenceResponse())
  ;
}

/// InteropService imports, exports, and validates round-trips for supported CAD exchange formats.
class InteropServiceApi {
  $pb.RpcClient _client;
  InteropServiceApi(this._client);

  /// ExportDrawing serializes a drawing revision into a supported exchange format.
  $async.Future<ExportDrawingResponse> exportDrawing($pb.ClientContext? ctx, ExportDrawingRequest request) =>
    _client.invoke<ExportDrawingResponse>(ctx, 'InteropService', 'ExportDrawing', request, ExportDrawingResponse())
  ;
  /// ImportDrawing materializes exchange-format payloads into drawing entities and commits them.
  $async.Future<ImportDrawingResponse> importDrawing($pb.ClientContext? ctx, ImportDrawingRequest request) =>
    _client.invoke<ImportDrawingResponse>(ctx, 'InteropService', 'ImportDrawing', request, ImportDrawingResponse())
  ;
  /// ValidateDrawingRoundTrip exports and reimports a drawing revision to measure fidelity.
  $async.Future<ValidateDrawingRoundTripResponse> validateDrawingRoundTrip($pb.ClientContext? ctx, ValidateDrawingRoundTripRequest request) =>
    _client.invoke<ValidateDrawingRoundTripResponse>(ctx, 'InteropService', 'ValidateDrawingRoundTrip', request, ValidateDrawingRoundTripResponse())
  ;
}

/// PlotSheetService manages sheet definitions and publish artifacts.
class PlotSheetServiceApi {
  $pb.RpcClient _client;
  PlotSheetServiceApi(this._client);

  /// CreateSheet persists a sheet definition entity for later publishing.
  $async.Future<CreateSheetResponse> createSheet($pb.ClientContext? ctx, CreateSheetRequest request) =>
    _client.invoke<CreateSheetResponse>(ctx, 'PlotSheetService', 'CreateSheet', request, CreateSheetResponse())
  ;
  /// PublishDrawing renders selected sheets as SVG or PDF publish artifacts.
  $async.Future<PublishDrawingResponse> publishDrawing($pb.ClientContext? ctx, PublishDrawingRequest request) =>
    _client.invoke<PublishDrawingResponse>(ctx, 'PlotSheetService', 'PublishDrawing', request, PublishDrawingResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
