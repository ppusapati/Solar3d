//
//  Generated code. Do not modify.
//  source: terrain/v1/terrain.proto
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
import 'terrain.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'terrain.pbenum.dart';

class TerrainLayer extends $pb.GeneratedMessage {
  factory TerrainLayer({
    $core.String? id,
    $core.String? projectId,
    $core.String? name,
    TerrainLayerType? layerType,
    $core.String? sourceFile,
    BoundingBox? bounds,
    $core.double? resolutionM,
    $core.String? crs,
    $core.double? minElevation,
    $core.double? maxElevation,
    $0.Timestamp? createdAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (layerType != null) {
      $result.layerType = layerType;
    }
    if (sourceFile != null) {
      $result.sourceFile = sourceFile;
    }
    if (bounds != null) {
      $result.bounds = bounds;
    }
    if (resolutionM != null) {
      $result.resolutionM = resolutionM;
    }
    if (crs != null) {
      $result.crs = crs;
    }
    if (minElevation != null) {
      $result.minElevation = minElevation;
    }
    if (maxElevation != null) {
      $result.maxElevation = maxElevation;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  TerrainLayer._() : super();
  factory TerrainLayer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TerrainLayer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TerrainLayer', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..e<TerrainLayerType>(4, _omitFieldNames ? '' : 'layerType', $pb.PbFieldType.OE, defaultOrMaker: TerrainLayerType.TERRAIN_LAYER_TYPE_UNSPECIFIED, valueOf: TerrainLayerType.valueOf, enumValues: TerrainLayerType.values)
    ..aOS(5, _omitFieldNames ? '' : 'sourceFile')
    ..aOM<BoundingBox>(6, _omitFieldNames ? '' : 'bounds', subBuilder: BoundingBox.create)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'resolutionM', $pb.PbFieldType.OD)
    ..aOS(8, _omitFieldNames ? '' : 'crs')
    ..a<$core.double>(9, _omitFieldNames ? '' : 'minElevation', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'maxElevation', $pb.PbFieldType.OD)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TerrainLayer clone() => TerrainLayer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TerrainLayer copyWith(void Function(TerrainLayer) updates) => super.copyWith((message) => updates(message as TerrainLayer)) as TerrainLayer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TerrainLayer create() => TerrainLayer._();
  TerrainLayer createEmptyInstance() => create();
  static $pb.PbList<TerrainLayer> createRepeated() => $pb.PbList<TerrainLayer>();
  @$core.pragma('dart2js:noInline')
  static TerrainLayer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TerrainLayer>(create);
  static TerrainLayer? _defaultInstance;

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
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => $_clearField(3);

  @$pb.TagNumber(4)
  TerrainLayerType get layerType => $_getN(3);
  @$pb.TagNumber(4)
  set layerType(TerrainLayerType v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLayerType() => $_has(3);
  @$pb.TagNumber(4)
  void clearLayerType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get sourceFile => $_getSZ(4);
  @$pb.TagNumber(5)
  set sourceFile($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSourceFile() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceFile() => $_clearField(5);

  @$pb.TagNumber(6)
  BoundingBox get bounds => $_getN(5);
  @$pb.TagNumber(6)
  set bounds(BoundingBox v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasBounds() => $_has(5);
  @$pb.TagNumber(6)
  void clearBounds() => $_clearField(6);
  @$pb.TagNumber(6)
  BoundingBox ensureBounds() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.double get resolutionM => $_getN(6);
  @$pb.TagNumber(7)
  set resolutionM($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasResolutionM() => $_has(6);
  @$pb.TagNumber(7)
  void clearResolutionM() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get crs => $_getSZ(7);
  @$pb.TagNumber(8)
  set crs($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCrs() => $_has(7);
  @$pb.TagNumber(8)
  void clearCrs() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get minElevation => $_getN(8);
  @$pb.TagNumber(9)
  set minElevation($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasMinElevation() => $_has(8);
  @$pb.TagNumber(9)
  void clearMinElevation() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get maxElevation => $_getN(9);
  @$pb.TagNumber(10)
  set maxElevation($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasMaxElevation() => $_has(9);
  @$pb.TagNumber(10)
  void clearMaxElevation() => $_clearField(10);

  @$pb.TagNumber(11)
  $0.Timestamp get createdAt => $_getN(10);
  @$pb.TagNumber(11)
  set createdAt($0.Timestamp v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasCreatedAt() => $_has(10);
  @$pb.TagNumber(11)
  void clearCreatedAt() => $_clearField(11);
  @$pb.TagNumber(11)
  $0.Timestamp ensureCreatedAt() => $_ensure(10);
}

class BoundingBox extends $pb.GeneratedMessage {
  factory BoundingBox({
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
  BoundingBox._() : super();
  factory BoundingBox.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BoundingBox.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BoundingBox', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
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
  BoundingBox clone() => BoundingBox()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BoundingBox copyWith(void Function(BoundingBox) updates) => super.copyWith((message) => updates(message as BoundingBox)) as BoundingBox;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BoundingBox create() => BoundingBox._();
  BoundingBox createEmptyInstance() => create();
  static $pb.PbList<BoundingBox> createRepeated() => $pb.PbList<BoundingBox>();
  @$core.pragma('dart2js:noInline')
  static BoundingBox getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BoundingBox>(create);
  static BoundingBox? _defaultInstance;

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

class UploadTerrainRequest extends $pb.GeneratedMessage {
  factory UploadTerrainRequest({
    $core.String? projectId,
    $core.String? name,
    $core.String? filePath,
    $core.String? crs,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (filePath != null) {
      $result.filePath = filePath;
    }
    if (crs != null) {
      $result.crs = crs;
    }
    return $result;
  }
  UploadTerrainRequest._() : super();
  factory UploadTerrainRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadTerrainRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadTerrainRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'filePath')
    ..aOS(4, _omitFieldNames ? '' : 'crs')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadTerrainRequest clone() => UploadTerrainRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadTerrainRequest copyWith(void Function(UploadTerrainRequest) updates) => super.copyWith((message) => updates(message as UploadTerrainRequest)) as UploadTerrainRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadTerrainRequest create() => UploadTerrainRequest._();
  UploadTerrainRequest createEmptyInstance() => create();
  static $pb.PbList<UploadTerrainRequest> createRepeated() => $pb.PbList<UploadTerrainRequest>();
  @$core.pragma('dart2js:noInline')
  static UploadTerrainRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadTerrainRequest>(create);
  static UploadTerrainRequest? _defaultInstance;

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
  $core.String get filePath => $_getSZ(2);
  @$pb.TagNumber(3)
  set filePath($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFilePath() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilePath() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get crs => $_getSZ(3);
  @$pb.TagNumber(4)
  set crs($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCrs() => $_has(3);
  @$pb.TagNumber(4)
  void clearCrs() => $_clearField(4);
}

class UploadTerrainResponse extends $pb.GeneratedMessage {
  factory UploadTerrainResponse({
    TerrainLayer? layer,
  }) {
    final $result = create();
    if (layer != null) {
      $result.layer = layer;
    }
    return $result;
  }
  UploadTerrainResponse._() : super();
  factory UploadTerrainResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadTerrainResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadTerrainResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOM<TerrainLayer>(1, _omitFieldNames ? '' : 'layer', subBuilder: TerrainLayer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadTerrainResponse clone() => UploadTerrainResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadTerrainResponse copyWith(void Function(UploadTerrainResponse) updates) => super.copyWith((message) => updates(message as UploadTerrainResponse)) as UploadTerrainResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadTerrainResponse create() => UploadTerrainResponse._();
  UploadTerrainResponse createEmptyInstance() => create();
  static $pb.PbList<UploadTerrainResponse> createRepeated() => $pb.PbList<UploadTerrainResponse>();
  @$core.pragma('dart2js:noInline')
  static UploadTerrainResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadTerrainResponse>(create);
  static UploadTerrainResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TerrainLayer get layer => $_getN(0);
  @$pb.TagNumber(1)
  set layer(TerrainLayer v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayer() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayer() => $_clearField(1);
  @$pb.TagNumber(1)
  TerrainLayer ensureLayer() => $_ensure(0);
}

class GetTerrainLayerRequest extends $pb.GeneratedMessage {
  factory GetTerrainLayerRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetTerrainLayerRequest._() : super();
  factory GetTerrainLayerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTerrainLayerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetTerrainLayerRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTerrainLayerRequest clone() => GetTerrainLayerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTerrainLayerRequest copyWith(void Function(GetTerrainLayerRequest) updates) => super.copyWith((message) => updates(message as GetTerrainLayerRequest)) as GetTerrainLayerRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTerrainLayerRequest create() => GetTerrainLayerRequest._();
  GetTerrainLayerRequest createEmptyInstance() => create();
  static $pb.PbList<GetTerrainLayerRequest> createRepeated() => $pb.PbList<GetTerrainLayerRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTerrainLayerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTerrainLayerRequest>(create);
  static GetTerrainLayerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetTerrainLayerResponse extends $pb.GeneratedMessage {
  factory GetTerrainLayerResponse({
    TerrainLayer? layer,
  }) {
    final $result = create();
    if (layer != null) {
      $result.layer = layer;
    }
    return $result;
  }
  GetTerrainLayerResponse._() : super();
  factory GetTerrainLayerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTerrainLayerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetTerrainLayerResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOM<TerrainLayer>(1, _omitFieldNames ? '' : 'layer', subBuilder: TerrainLayer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTerrainLayerResponse clone() => GetTerrainLayerResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTerrainLayerResponse copyWith(void Function(GetTerrainLayerResponse) updates) => super.copyWith((message) => updates(message as GetTerrainLayerResponse)) as GetTerrainLayerResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTerrainLayerResponse create() => GetTerrainLayerResponse._();
  GetTerrainLayerResponse createEmptyInstance() => create();
  static $pb.PbList<GetTerrainLayerResponse> createRepeated() => $pb.PbList<GetTerrainLayerResponse>();
  @$core.pragma('dart2js:noInline')
  static GetTerrainLayerResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTerrainLayerResponse>(create);
  static GetTerrainLayerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TerrainLayer get layer => $_getN(0);
  @$pb.TagNumber(1)
  set layer(TerrainLayer v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLayer() => $_has(0);
  @$pb.TagNumber(1)
  void clearLayer() => $_clearField(1);
  @$pb.TagNumber(1)
  TerrainLayer ensureLayer() => $_ensure(0);
}

class ListTerrainLayersRequest extends $pb.GeneratedMessage {
  factory ListTerrainLayersRequest({
    $core.String? projectId,
    TerrainLayerType? typeFilter,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (typeFilter != null) {
      $result.typeFilter = typeFilter;
    }
    return $result;
  }
  ListTerrainLayersRequest._() : super();
  factory ListTerrainLayersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListTerrainLayersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListTerrainLayersRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<TerrainLayerType>(2, _omitFieldNames ? '' : 'typeFilter', $pb.PbFieldType.OE, defaultOrMaker: TerrainLayerType.TERRAIN_LAYER_TYPE_UNSPECIFIED, valueOf: TerrainLayerType.valueOf, enumValues: TerrainLayerType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListTerrainLayersRequest clone() => ListTerrainLayersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListTerrainLayersRequest copyWith(void Function(ListTerrainLayersRequest) updates) => super.copyWith((message) => updates(message as ListTerrainLayersRequest)) as ListTerrainLayersRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTerrainLayersRequest create() => ListTerrainLayersRequest._();
  ListTerrainLayersRequest createEmptyInstance() => create();
  static $pb.PbList<ListTerrainLayersRequest> createRepeated() => $pb.PbList<ListTerrainLayersRequest>();
  @$core.pragma('dart2js:noInline')
  static ListTerrainLayersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTerrainLayersRequest>(create);
  static ListTerrainLayersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  TerrainLayerType get typeFilter => $_getN(1);
  @$pb.TagNumber(2)
  set typeFilter(TerrainLayerType v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTypeFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearTypeFilter() => $_clearField(2);
}

class ListTerrainLayersResponse extends $pb.GeneratedMessage {
  factory ListTerrainLayersResponse({
    $core.Iterable<TerrainLayer>? layers,
  }) {
    final $result = create();
    if (layers != null) {
      $result.layers.addAll(layers);
    }
    return $result;
  }
  ListTerrainLayersResponse._() : super();
  factory ListTerrainLayersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListTerrainLayersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListTerrainLayersResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..pc<TerrainLayer>(1, _omitFieldNames ? '' : 'layers', $pb.PbFieldType.PM, subBuilder: TerrainLayer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListTerrainLayersResponse clone() => ListTerrainLayersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListTerrainLayersResponse copyWith(void Function(ListTerrainLayersResponse) updates) => super.copyWith((message) => updates(message as ListTerrainLayersResponse)) as ListTerrainLayersResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTerrainLayersResponse create() => ListTerrainLayersResponse._();
  ListTerrainLayersResponse createEmptyInstance() => create();
  static $pb.PbList<ListTerrainLayersResponse> createRepeated() => $pb.PbList<ListTerrainLayersResponse>();
  @$core.pragma('dart2js:noInline')
  static ListTerrainLayersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTerrainLayersResponse>(create);
  static ListTerrainLayersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<TerrainLayer> get layers => $_getList(0);
}

class GetElevationRequest extends $pb.GeneratedMessage {
  factory GetElevationRequest({
    $core.String? projectId,
    $core.double? longitude,
    $core.double? latitude,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    return $result;
  }
  GetElevationRequest._() : super();
  factory GetElevationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetElevationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetElevationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetElevationRequest clone() => GetElevationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetElevationRequest copyWith(void Function(GetElevationRequest) updates) => super.copyWith((message) => updates(message as GetElevationRequest)) as GetElevationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetElevationRequest create() => GetElevationRequest._();
  GetElevationRequest createEmptyInstance() => create();
  static $pb.PbList<GetElevationRequest> createRepeated() => $pb.PbList<GetElevationRequest>();
  @$core.pragma('dart2js:noInline')
  static GetElevationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetElevationRequest>(create);
  static GetElevationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get latitude => $_getN(2);
  @$pb.TagNumber(3)
  set latitude($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLatitude() => $_has(2);
  @$pb.TagNumber(3)
  void clearLatitude() => $_clearField(3);
}

class GetElevationResponse extends $pb.GeneratedMessage {
  factory GetElevationResponse({
    $core.double? elevation,
  }) {
    final $result = create();
    if (elevation != null) {
      $result.elevation = elevation;
    }
    return $result;
  }
  GetElevationResponse._() : super();
  factory GetElevationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetElevationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetElevationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'elevation', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetElevationResponse clone() => GetElevationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetElevationResponse copyWith(void Function(GetElevationResponse) updates) => super.copyWith((message) => updates(message as GetElevationResponse)) as GetElevationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetElevationResponse create() => GetElevationResponse._();
  GetElevationResponse createEmptyInstance() => create();
  static $pb.PbList<GetElevationResponse> createRepeated() => $pb.PbList<GetElevationResponse>();
  @$core.pragma('dart2js:noInline')
  static GetElevationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetElevationResponse>(create);
  static GetElevationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get elevation => $_getN(0);
  @$pb.TagNumber(1)
  set elevation($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasElevation() => $_has(0);
  @$pb.TagNumber(1)
  void clearElevation() => $_clearField(1);
}

class GetElevationGridRequest extends $pb.GeneratedMessage {
  factory GetElevationGridRequest({
    $core.String? projectId,
    BoundingBox? bounds,
    $core.double? resolutionM,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (bounds != null) {
      $result.bounds = bounds;
    }
    if (resolutionM != null) {
      $result.resolutionM = resolutionM;
    }
    return $result;
  }
  GetElevationGridRequest._() : super();
  factory GetElevationGridRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetElevationGridRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetElevationGridRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..aOM<BoundingBox>(2, _omitFieldNames ? '' : 'bounds', subBuilder: BoundingBox.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'resolutionM', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetElevationGridRequest clone() => GetElevationGridRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetElevationGridRequest copyWith(void Function(GetElevationGridRequest) updates) => super.copyWith((message) => updates(message as GetElevationGridRequest)) as GetElevationGridRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetElevationGridRequest create() => GetElevationGridRequest._();
  GetElevationGridRequest createEmptyInstance() => create();
  static $pb.PbList<GetElevationGridRequest> createRepeated() => $pb.PbList<GetElevationGridRequest>();
  @$core.pragma('dart2js:noInline')
  static GetElevationGridRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetElevationGridRequest>(create);
  static GetElevationGridRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  BoundingBox get bounds => $_getN(1);
  @$pb.TagNumber(2)
  set bounds(BoundingBox v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasBounds() => $_has(1);
  @$pb.TagNumber(2)
  void clearBounds() => $_clearField(2);
  @$pb.TagNumber(2)
  BoundingBox ensureBounds() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get resolutionM => $_getN(2);
  @$pb.TagNumber(3)
  set resolutionM($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasResolutionM() => $_has(2);
  @$pb.TagNumber(3)
  void clearResolutionM() => $_clearField(3);
}

class GetElevationGridResponse extends $pb.GeneratedMessage {
  factory GetElevationGridResponse({
    $core.int? width,
    $core.int? height,
    $core.Iterable<$core.double>? elevations,
    $core.double? minElevation,
    $core.double? maxElevation,
  }) {
    final $result = create();
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (elevations != null) {
      $result.elevations.addAll(elevations);
    }
    if (minElevation != null) {
      $result.minElevation = minElevation;
    }
    if (maxElevation != null) {
      $result.maxElevation = maxElevation;
    }
    return $result;
  }
  GetElevationGridResponse._() : super();
  factory GetElevationGridResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetElevationGridResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetElevationGridResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'width', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'height', $pb.PbFieldType.O3)
    ..p<$core.double>(3, _omitFieldNames ? '' : 'elevations', $pb.PbFieldType.KD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'minElevation', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'maxElevation', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetElevationGridResponse clone() => GetElevationGridResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetElevationGridResponse copyWith(void Function(GetElevationGridResponse) updates) => super.copyWith((message) => updates(message as GetElevationGridResponse)) as GetElevationGridResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetElevationGridResponse create() => GetElevationGridResponse._();
  GetElevationGridResponse createEmptyInstance() => create();
  static $pb.PbList<GetElevationGridResponse> createRepeated() => $pb.PbList<GetElevationGridResponse>();
  @$core.pragma('dart2js:noInline')
  static GetElevationGridResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetElevationGridResponse>(create);
  static GetElevationGridResponse? _defaultInstance;

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
  $pb.PbList<$core.double> get elevations => $_getList(2);

  @$pb.TagNumber(4)
  $core.double get minElevation => $_getN(3);
  @$pb.TagNumber(4)
  set minElevation($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMinElevation() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinElevation() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get maxElevation => $_getN(4);
  @$pb.TagNumber(5)
  set maxElevation($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMaxElevation() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxElevation() => $_clearField(5);
}

class AnalyzeEarthworkRequest extends $pb.GeneratedMessage {
  factory AnalyzeEarthworkRequest({
    $core.String? terrainLayerId,
    $core.double? targetElevationM,
    $core.String? boundaryGeojson,
    $core.double? minDeltaM,
    $core.double? haulFactor,
    $core.int? gridWidth,
    $core.int? gridHeight,
  }) {
    final $result = create();
    if (terrainLayerId != null) {
      $result.terrainLayerId = terrainLayerId;
    }
    if (targetElevationM != null) {
      $result.targetElevationM = targetElevationM;
    }
    if (boundaryGeojson != null) {
      $result.boundaryGeojson = boundaryGeojson;
    }
    if (minDeltaM != null) {
      $result.minDeltaM = minDeltaM;
    }
    if (haulFactor != null) {
      $result.haulFactor = haulFactor;
    }
    if (gridWidth != null) {
      $result.gridWidth = gridWidth;
    }
    if (gridHeight != null) {
      $result.gridHeight = gridHeight;
    }
    return $result;
  }
  AnalyzeEarthworkRequest._() : super();
  factory AnalyzeEarthworkRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnalyzeEarthworkRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnalyzeEarthworkRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'terrainLayerId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'targetElevationM', $pb.PbFieldType.OD)
    ..aOS(3, _omitFieldNames ? '' : 'boundaryGeojson')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'minDeltaM', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'haulFactor', $pb.PbFieldType.OD)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'gridWidth', $pb.PbFieldType.O3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'gridHeight', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnalyzeEarthworkRequest clone() => AnalyzeEarthworkRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnalyzeEarthworkRequest copyWith(void Function(AnalyzeEarthworkRequest) updates) => super.copyWith((message) => updates(message as AnalyzeEarthworkRequest)) as AnalyzeEarthworkRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnalyzeEarthworkRequest create() => AnalyzeEarthworkRequest._();
  AnalyzeEarthworkRequest createEmptyInstance() => create();
  static $pb.PbList<AnalyzeEarthworkRequest> createRepeated() => $pb.PbList<AnalyzeEarthworkRequest>();
  @$core.pragma('dart2js:noInline')
  static AnalyzeEarthworkRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnalyzeEarthworkRequest>(create);
  static AnalyzeEarthworkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get terrainLayerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set terrainLayerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTerrainLayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTerrainLayerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get targetElevationM => $_getN(1);
  @$pb.TagNumber(2)
  set targetElevationM($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetElevationM() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetElevationM() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get boundaryGeojson => $_getSZ(2);
  @$pb.TagNumber(3)
  set boundaryGeojson($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBoundaryGeojson() => $_has(2);
  @$pb.TagNumber(3)
  void clearBoundaryGeojson() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get minDeltaM => $_getN(3);
  @$pb.TagNumber(4)
  set minDeltaM($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMinDeltaM() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinDeltaM() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get haulFactor => $_getN(4);
  @$pb.TagNumber(5)
  set haulFactor($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHaulFactor() => $_has(4);
  @$pb.TagNumber(5)
  void clearHaulFactor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get gridWidth => $_getIZ(5);
  @$pb.TagNumber(6)
  set gridWidth($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasGridWidth() => $_has(5);
  @$pb.TagNumber(6)
  void clearGridWidth() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get gridHeight => $_getIZ(6);
  @$pb.TagNumber(7)
  set gridHeight($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasGridHeight() => $_has(6);
  @$pb.TagNumber(7)
  void clearGridHeight() => $_clearField(7);
}

class AnalyzeEarthworkResponse extends $pb.GeneratedMessage {
  factory AnalyzeEarthworkResponse({
    $core.String? demSourceLayerId,
    $core.int? gridWidth,
    $core.int? gridHeight,
    $core.double? cellAreaSqm,
    $core.double? meanElevationM,
    $core.double? targetElevationM,
    $core.double? cutVolumeM3,
    $core.double? fillVolumeM3,
    $core.double? netVolumeM3,
    $core.double? imbalanceVolumeM3,
    $core.double? balancedVolumeRatio,
    $core.double? affectedAreaSqm,
    $core.double? averageAbsoluteDeltaM,
    $core.double? maximumAbsoluteDeltaM,
    $core.int? includedCellCount,
    $core.double? clippedAreaSqm,
    $core.double? haulDistanceM,
    $core.double? haulEffortM3m,
    $core.double? recommendedTargetMinM,
    $core.double? recommendedTargetMaxM,
  }) {
    final $result = create();
    if (demSourceLayerId != null) {
      $result.demSourceLayerId = demSourceLayerId;
    }
    if (gridWidth != null) {
      $result.gridWidth = gridWidth;
    }
    if (gridHeight != null) {
      $result.gridHeight = gridHeight;
    }
    if (cellAreaSqm != null) {
      $result.cellAreaSqm = cellAreaSqm;
    }
    if (meanElevationM != null) {
      $result.meanElevationM = meanElevationM;
    }
    if (targetElevationM != null) {
      $result.targetElevationM = targetElevationM;
    }
    if (cutVolumeM3 != null) {
      $result.cutVolumeM3 = cutVolumeM3;
    }
    if (fillVolumeM3 != null) {
      $result.fillVolumeM3 = fillVolumeM3;
    }
    if (netVolumeM3 != null) {
      $result.netVolumeM3 = netVolumeM3;
    }
    if (imbalanceVolumeM3 != null) {
      $result.imbalanceVolumeM3 = imbalanceVolumeM3;
    }
    if (balancedVolumeRatio != null) {
      $result.balancedVolumeRatio = balancedVolumeRatio;
    }
    if (affectedAreaSqm != null) {
      $result.affectedAreaSqm = affectedAreaSqm;
    }
    if (averageAbsoluteDeltaM != null) {
      $result.averageAbsoluteDeltaM = averageAbsoluteDeltaM;
    }
    if (maximumAbsoluteDeltaM != null) {
      $result.maximumAbsoluteDeltaM = maximumAbsoluteDeltaM;
    }
    if (includedCellCount != null) {
      $result.includedCellCount = includedCellCount;
    }
    if (clippedAreaSqm != null) {
      $result.clippedAreaSqm = clippedAreaSqm;
    }
    if (haulDistanceM != null) {
      $result.haulDistanceM = haulDistanceM;
    }
    if (haulEffortM3m != null) {
      $result.haulEffortM3m = haulEffortM3m;
    }
    if (recommendedTargetMinM != null) {
      $result.recommendedTargetMinM = recommendedTargetMinM;
    }
    if (recommendedTargetMaxM != null) {
      $result.recommendedTargetMaxM = recommendedTargetMaxM;
    }
    return $result;
  }
  AnalyzeEarthworkResponse._() : super();
  factory AnalyzeEarthworkResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AnalyzeEarthworkResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AnalyzeEarthworkResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'demSourceLayerId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'gridWidth', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'gridHeight', $pb.PbFieldType.O3)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'cellAreaSqm', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'meanElevationM', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'targetElevationM', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'cutVolumeM3', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'fillVolumeM3', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'netVolumeM3', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'imbalanceVolumeM3', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'balancedVolumeRatio', $pb.PbFieldType.OD)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'affectedAreaSqm', $pb.PbFieldType.OD)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'averageAbsoluteDeltaM', $pb.PbFieldType.OD)
    ..a<$core.double>(14, _omitFieldNames ? '' : 'maximumAbsoluteDeltaM', $pb.PbFieldType.OD)
    ..a<$core.int>(15, _omitFieldNames ? '' : 'includedCellCount', $pb.PbFieldType.O3)
    ..a<$core.double>(16, _omitFieldNames ? '' : 'clippedAreaSqm', $pb.PbFieldType.OD)
    ..a<$core.double>(17, _omitFieldNames ? '' : 'haulDistanceM', $pb.PbFieldType.OD)
    ..a<$core.double>(18, _omitFieldNames ? '' : 'haulEffortM3m', $pb.PbFieldType.OD)
    ..a<$core.double>(19, _omitFieldNames ? '' : 'recommendedTargetMinM', $pb.PbFieldType.OD)
    ..a<$core.double>(20, _omitFieldNames ? '' : 'recommendedTargetMaxM', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AnalyzeEarthworkResponse clone() => AnalyzeEarthworkResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AnalyzeEarthworkResponse copyWith(void Function(AnalyzeEarthworkResponse) updates) => super.copyWith((message) => updates(message as AnalyzeEarthworkResponse)) as AnalyzeEarthworkResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AnalyzeEarthworkResponse create() => AnalyzeEarthworkResponse._();
  AnalyzeEarthworkResponse createEmptyInstance() => create();
  static $pb.PbList<AnalyzeEarthworkResponse> createRepeated() => $pb.PbList<AnalyzeEarthworkResponse>();
  @$core.pragma('dart2js:noInline')
  static AnalyzeEarthworkResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AnalyzeEarthworkResponse>(create);
  static AnalyzeEarthworkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get demSourceLayerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set demSourceLayerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDemSourceLayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDemSourceLayerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get gridWidth => $_getIZ(1);
  @$pb.TagNumber(2)
  set gridWidth($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGridWidth() => $_has(1);
  @$pb.TagNumber(2)
  void clearGridWidth() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get gridHeight => $_getIZ(2);
  @$pb.TagNumber(3)
  set gridHeight($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGridHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearGridHeight() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get cellAreaSqm => $_getN(3);
  @$pb.TagNumber(4)
  set cellAreaSqm($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCellAreaSqm() => $_has(3);
  @$pb.TagNumber(4)
  void clearCellAreaSqm() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get meanElevationM => $_getN(4);
  @$pb.TagNumber(5)
  set meanElevationM($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMeanElevationM() => $_has(4);
  @$pb.TagNumber(5)
  void clearMeanElevationM() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get targetElevationM => $_getN(5);
  @$pb.TagNumber(6)
  set targetElevationM($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTargetElevationM() => $_has(5);
  @$pb.TagNumber(6)
  void clearTargetElevationM() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get cutVolumeM3 => $_getN(6);
  @$pb.TagNumber(7)
  set cutVolumeM3($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCutVolumeM3() => $_has(6);
  @$pb.TagNumber(7)
  void clearCutVolumeM3() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get fillVolumeM3 => $_getN(7);
  @$pb.TagNumber(8)
  set fillVolumeM3($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasFillVolumeM3() => $_has(7);
  @$pb.TagNumber(8)
  void clearFillVolumeM3() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get netVolumeM3 => $_getN(8);
  @$pb.TagNumber(9)
  set netVolumeM3($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasNetVolumeM3() => $_has(8);
  @$pb.TagNumber(9)
  void clearNetVolumeM3() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get imbalanceVolumeM3 => $_getN(9);
  @$pb.TagNumber(10)
  set imbalanceVolumeM3($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasImbalanceVolumeM3() => $_has(9);
  @$pb.TagNumber(10)
  void clearImbalanceVolumeM3() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get balancedVolumeRatio => $_getN(10);
  @$pb.TagNumber(11)
  set balancedVolumeRatio($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasBalancedVolumeRatio() => $_has(10);
  @$pb.TagNumber(11)
  void clearBalancedVolumeRatio() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get affectedAreaSqm => $_getN(11);
  @$pb.TagNumber(12)
  set affectedAreaSqm($core.double v) { $_setDouble(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasAffectedAreaSqm() => $_has(11);
  @$pb.TagNumber(12)
  void clearAffectedAreaSqm() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get averageAbsoluteDeltaM => $_getN(12);
  @$pb.TagNumber(13)
  set averageAbsoluteDeltaM($core.double v) { $_setDouble(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasAverageAbsoluteDeltaM() => $_has(12);
  @$pb.TagNumber(13)
  void clearAverageAbsoluteDeltaM() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get maximumAbsoluteDeltaM => $_getN(13);
  @$pb.TagNumber(14)
  set maximumAbsoluteDeltaM($core.double v) { $_setDouble(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasMaximumAbsoluteDeltaM() => $_has(13);
  @$pb.TagNumber(14)
  void clearMaximumAbsoluteDeltaM() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.int get includedCellCount => $_getIZ(14);
  @$pb.TagNumber(15)
  set includedCellCount($core.int v) { $_setSignedInt32(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasIncludedCellCount() => $_has(14);
  @$pb.TagNumber(15)
  void clearIncludedCellCount() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.double get clippedAreaSqm => $_getN(15);
  @$pb.TagNumber(16)
  set clippedAreaSqm($core.double v) { $_setDouble(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasClippedAreaSqm() => $_has(15);
  @$pb.TagNumber(16)
  void clearClippedAreaSqm() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.double get haulDistanceM => $_getN(16);
  @$pb.TagNumber(17)
  set haulDistanceM($core.double v) { $_setDouble(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasHaulDistanceM() => $_has(16);
  @$pb.TagNumber(17)
  void clearHaulDistanceM() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.double get haulEffortM3m => $_getN(17);
  @$pb.TagNumber(18)
  set haulEffortM3m($core.double v) { $_setDouble(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasHaulEffortM3m() => $_has(17);
  @$pb.TagNumber(18)
  void clearHaulEffortM3m() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.double get recommendedTargetMinM => $_getN(18);
  @$pb.TagNumber(19)
  set recommendedTargetMinM($core.double v) { $_setDouble(18, v); }
  @$pb.TagNumber(19)
  $core.bool hasRecommendedTargetMinM() => $_has(18);
  @$pb.TagNumber(19)
  void clearRecommendedTargetMinM() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.double get recommendedTargetMaxM => $_getN(19);
  @$pb.TagNumber(20)
  set recommendedTargetMaxM($core.double v) { $_setDouble(19, v); }
  @$pb.TagNumber(20)
  $core.bool hasRecommendedTargetMaxM() => $_has(19);
  @$pb.TagNumber(20)
  void clearRecommendedTargetMaxM() => $_clearField(20);
}

class ComputeSlopeRequest extends $pb.GeneratedMessage {
  factory ComputeSlopeRequest({
    $core.String? terrainLayerId,
  }) {
    final $result = create();
    if (terrainLayerId != null) {
      $result.terrainLayerId = terrainLayerId;
    }
    return $result;
  }
  ComputeSlopeRequest._() : super();
  factory ComputeSlopeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeSlopeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeSlopeRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'terrainLayerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeSlopeRequest clone() => ComputeSlopeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeSlopeRequest copyWith(void Function(ComputeSlopeRequest) updates) => super.copyWith((message) => updates(message as ComputeSlopeRequest)) as ComputeSlopeRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeSlopeRequest create() => ComputeSlopeRequest._();
  ComputeSlopeRequest createEmptyInstance() => create();
  static $pb.PbList<ComputeSlopeRequest> createRepeated() => $pb.PbList<ComputeSlopeRequest>();
  @$core.pragma('dart2js:noInline')
  static ComputeSlopeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeSlopeRequest>(create);
  static ComputeSlopeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get terrainLayerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set terrainLayerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTerrainLayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTerrainLayerId() => $_clearField(1);
}

class ComputeSlopeResponse extends $pb.GeneratedMessage {
  factory ComputeSlopeResponse({
    TerrainLayer? slopeLayer,
  }) {
    final $result = create();
    if (slopeLayer != null) {
      $result.slopeLayer = slopeLayer;
    }
    return $result;
  }
  ComputeSlopeResponse._() : super();
  factory ComputeSlopeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeSlopeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeSlopeResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOM<TerrainLayer>(1, _omitFieldNames ? '' : 'slopeLayer', subBuilder: TerrainLayer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeSlopeResponse clone() => ComputeSlopeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeSlopeResponse copyWith(void Function(ComputeSlopeResponse) updates) => super.copyWith((message) => updates(message as ComputeSlopeResponse)) as ComputeSlopeResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeSlopeResponse create() => ComputeSlopeResponse._();
  ComputeSlopeResponse createEmptyInstance() => create();
  static $pb.PbList<ComputeSlopeResponse> createRepeated() => $pb.PbList<ComputeSlopeResponse>();
  @$core.pragma('dart2js:noInline')
  static ComputeSlopeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeSlopeResponse>(create);
  static ComputeSlopeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TerrainLayer get slopeLayer => $_getN(0);
  @$pb.TagNumber(1)
  set slopeLayer(TerrainLayer v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSlopeLayer() => $_has(0);
  @$pb.TagNumber(1)
  void clearSlopeLayer() => $_clearField(1);
  @$pb.TagNumber(1)
  TerrainLayer ensureSlopeLayer() => $_ensure(0);
}

class ComputeAspectRequest extends $pb.GeneratedMessage {
  factory ComputeAspectRequest({
    $core.String? terrainLayerId,
  }) {
    final $result = create();
    if (terrainLayerId != null) {
      $result.terrainLayerId = terrainLayerId;
    }
    return $result;
  }
  ComputeAspectRequest._() : super();
  factory ComputeAspectRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeAspectRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeAspectRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'terrainLayerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeAspectRequest clone() => ComputeAspectRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeAspectRequest copyWith(void Function(ComputeAspectRequest) updates) => super.copyWith((message) => updates(message as ComputeAspectRequest)) as ComputeAspectRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeAspectRequest create() => ComputeAspectRequest._();
  ComputeAspectRequest createEmptyInstance() => create();
  static $pb.PbList<ComputeAspectRequest> createRepeated() => $pb.PbList<ComputeAspectRequest>();
  @$core.pragma('dart2js:noInline')
  static ComputeAspectRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeAspectRequest>(create);
  static ComputeAspectRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get terrainLayerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set terrainLayerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTerrainLayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTerrainLayerId() => $_clearField(1);
}

class ComputeAspectResponse extends $pb.GeneratedMessage {
  factory ComputeAspectResponse({
    TerrainLayer? aspectLayer,
  }) {
    final $result = create();
    if (aspectLayer != null) {
      $result.aspectLayer = aspectLayer;
    }
    return $result;
  }
  ComputeAspectResponse._() : super();
  factory ComputeAspectResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputeAspectResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ComputeAspectResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOM<TerrainLayer>(1, _omitFieldNames ? '' : 'aspectLayer', subBuilder: TerrainLayer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputeAspectResponse clone() => ComputeAspectResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputeAspectResponse copyWith(void Function(ComputeAspectResponse) updates) => super.copyWith((message) => updates(message as ComputeAspectResponse)) as ComputeAspectResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ComputeAspectResponse create() => ComputeAspectResponse._();
  ComputeAspectResponse createEmptyInstance() => create();
  static $pb.PbList<ComputeAspectResponse> createRepeated() => $pb.PbList<ComputeAspectResponse>();
  @$core.pragma('dart2js:noInline')
  static ComputeAspectResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputeAspectResponse>(create);
  static ComputeAspectResponse? _defaultInstance;

  @$pb.TagNumber(1)
  TerrainLayer get aspectLayer => $_getN(0);
  @$pb.TagNumber(1)
  set aspectLayer(TerrainLayer v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAspectLayer() => $_has(0);
  @$pb.TagNumber(1)
  void clearAspectLayer() => $_clearField(1);
  @$pb.TagNumber(1)
  TerrainLayer ensureAspectLayer() => $_ensure(0);
}

class DeleteTerrainLayerRequest extends $pb.GeneratedMessage {
  factory DeleteTerrainLayerRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  DeleteTerrainLayerRequest._() : super();
  factory DeleteTerrainLayerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteTerrainLayerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteTerrainLayerRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteTerrainLayerRequest clone() => DeleteTerrainLayerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteTerrainLayerRequest copyWith(void Function(DeleteTerrainLayerRequest) updates) => super.copyWith((message) => updates(message as DeleteTerrainLayerRequest)) as DeleteTerrainLayerRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteTerrainLayerRequest create() => DeleteTerrainLayerRequest._();
  DeleteTerrainLayerRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteTerrainLayerRequest> createRepeated() => $pb.PbList<DeleteTerrainLayerRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteTerrainLayerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteTerrainLayerRequest>(create);
  static DeleteTerrainLayerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class DeleteTerrainLayerResponse extends $pb.GeneratedMessage {
  factory DeleteTerrainLayerResponse() => create();
  DeleteTerrainLayerResponse._() : super();
  factory DeleteTerrainLayerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteTerrainLayerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteTerrainLayerResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteTerrainLayerResponse clone() => DeleteTerrainLayerResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteTerrainLayerResponse copyWith(void Function(DeleteTerrainLayerResponse) updates) => super.copyWith((message) => updates(message as DeleteTerrainLayerResponse)) as DeleteTerrainLayerResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteTerrainLayerResponse create() => DeleteTerrainLayerResponse._();
  DeleteTerrainLayerResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteTerrainLayerResponse> createRepeated() => $pb.PbList<DeleteTerrainLayerResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteTerrainLayerResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteTerrainLayerResponse>(create);
  static DeleteTerrainLayerResponse? _defaultInstance;
}

class DiffTerrainLayersRequest extends $pb.GeneratedMessage {
  factory DiffTerrainLayersRequest({
    $core.String? baseLayerId,
    $core.String? compareLayerId,
    $core.int? gridWidth,
    $core.int? gridHeight,
  }) {
    final $result = create();
    if (baseLayerId != null) {
      $result.baseLayerId = baseLayerId;
    }
    if (compareLayerId != null) {
      $result.compareLayerId = compareLayerId;
    }
    if (gridWidth != null) {
      $result.gridWidth = gridWidth;
    }
    if (gridHeight != null) {
      $result.gridHeight = gridHeight;
    }
    return $result;
  }
  DiffTerrainLayersRequest._() : super();
  factory DiffTerrainLayersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DiffTerrainLayersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DiffTerrainLayersRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'baseLayerId')
    ..aOS(2, _omitFieldNames ? '' : 'compareLayerId')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'gridWidth', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'gridHeight', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DiffTerrainLayersRequest clone() => DiffTerrainLayersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DiffTerrainLayersRequest copyWith(void Function(DiffTerrainLayersRequest) updates) => super.copyWith((message) => updates(message as DiffTerrainLayersRequest)) as DiffTerrainLayersRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiffTerrainLayersRequest create() => DiffTerrainLayersRequest._();
  DiffTerrainLayersRequest createEmptyInstance() => create();
  static $pb.PbList<DiffTerrainLayersRequest> createRepeated() => $pb.PbList<DiffTerrainLayersRequest>();
  @$core.pragma('dart2js:noInline')
  static DiffTerrainLayersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DiffTerrainLayersRequest>(create);
  static DiffTerrainLayersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get baseLayerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set baseLayerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBaseLayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseLayerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get compareLayerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set compareLayerId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCompareLayerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompareLayerId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get gridWidth => $_getIZ(2);
  @$pb.TagNumber(3)
  set gridWidth($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGridWidth() => $_has(2);
  @$pb.TagNumber(3)
  void clearGridWidth() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get gridHeight => $_getIZ(3);
  @$pb.TagNumber(4)
  set gridHeight($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasGridHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearGridHeight() => $_clearField(4);
}

/// DiffTerrainLayersResponse carries the per-cell elevation delta between two
/// DEM layers over their overlapping extent, together with aggregate statistics.
class DiffTerrainLayersResponse extends $pb.GeneratedMessage {
  factory DiffTerrainLayersResponse({
    $core.String? baseLayerId,
    $core.String? compareLayerId,
    BoundingBox? overlapBounds,
    $core.int? gridWidth,
    $core.int? gridHeight,
    $core.double? cellAreaSqm,
    $core.Iterable<$core.double>? deltaElevations,
    $core.double? meanDeltaM,
    $core.double? rmsDeltaM,
    $core.double? maxAbsDeltaM,
    $core.double? volumeAddedM3,
    $core.double? volumeRemovedM3,
    $core.double? netVolumeM3,
    $core.int? validCellCount,
  }) {
    final $result = create();
    if (baseLayerId != null) {
      $result.baseLayerId = baseLayerId;
    }
    if (compareLayerId != null) {
      $result.compareLayerId = compareLayerId;
    }
    if (overlapBounds != null) {
      $result.overlapBounds = overlapBounds;
    }
    if (gridWidth != null) {
      $result.gridWidth = gridWidth;
    }
    if (gridHeight != null) {
      $result.gridHeight = gridHeight;
    }
    if (cellAreaSqm != null) {
      $result.cellAreaSqm = cellAreaSqm;
    }
    if (deltaElevations != null) {
      $result.deltaElevations.addAll(deltaElevations);
    }
    if (meanDeltaM != null) {
      $result.meanDeltaM = meanDeltaM;
    }
    if (rmsDeltaM != null) {
      $result.rmsDeltaM = rmsDeltaM;
    }
    if (maxAbsDeltaM != null) {
      $result.maxAbsDeltaM = maxAbsDeltaM;
    }
    if (volumeAddedM3 != null) {
      $result.volumeAddedM3 = volumeAddedM3;
    }
    if (volumeRemovedM3 != null) {
      $result.volumeRemovedM3 = volumeRemovedM3;
    }
    if (netVolumeM3 != null) {
      $result.netVolumeM3 = netVolumeM3;
    }
    if (validCellCount != null) {
      $result.validCellCount = validCellCount;
    }
    return $result;
  }
  DiffTerrainLayersResponse._() : super();
  factory DiffTerrainLayersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DiffTerrainLayersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DiffTerrainLayersResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'baseLayerId')
    ..aOS(2, _omitFieldNames ? '' : 'compareLayerId')
    ..aOM<BoundingBox>(3, _omitFieldNames ? '' : 'overlapBounds', subBuilder: BoundingBox.create)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'gridWidth', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'gridHeight', $pb.PbFieldType.O3)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'cellAreaSqm', $pb.PbFieldType.OD)
    ..p<$core.double>(7, _omitFieldNames ? '' : 'deltaElevations', $pb.PbFieldType.KD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'meanDeltaM', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'rmsDeltaM', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'maxAbsDeltaM', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'volumeAddedM3', $pb.PbFieldType.OD)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'volumeRemovedM3', $pb.PbFieldType.OD)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'netVolumeM3', $pb.PbFieldType.OD)
    ..a<$core.int>(14, _omitFieldNames ? '' : 'validCellCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DiffTerrainLayersResponse clone() => DiffTerrainLayersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DiffTerrainLayersResponse copyWith(void Function(DiffTerrainLayersResponse) updates) => super.copyWith((message) => updates(message as DiffTerrainLayersResponse)) as DiffTerrainLayersResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiffTerrainLayersResponse create() => DiffTerrainLayersResponse._();
  DiffTerrainLayersResponse createEmptyInstance() => create();
  static $pb.PbList<DiffTerrainLayersResponse> createRepeated() => $pb.PbList<DiffTerrainLayersResponse>();
  @$core.pragma('dart2js:noInline')
  static DiffTerrainLayersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DiffTerrainLayersResponse>(create);
  static DiffTerrainLayersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get baseLayerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set baseLayerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBaseLayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearBaseLayerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get compareLayerId => $_getSZ(1);
  @$pb.TagNumber(2)
  set compareLayerId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCompareLayerId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompareLayerId() => $_clearField(2);

  @$pb.TagNumber(3)
  BoundingBox get overlapBounds => $_getN(2);
  @$pb.TagNumber(3)
  set overlapBounds(BoundingBox v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasOverlapBounds() => $_has(2);
  @$pb.TagNumber(3)
  void clearOverlapBounds() => $_clearField(3);
  @$pb.TagNumber(3)
  BoundingBox ensureOverlapBounds() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get gridWidth => $_getIZ(3);
  @$pb.TagNumber(4)
  set gridWidth($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasGridWidth() => $_has(3);
  @$pb.TagNumber(4)
  void clearGridWidth() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get gridHeight => $_getIZ(4);
  @$pb.TagNumber(5)
  set gridHeight($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasGridHeight() => $_has(4);
  @$pb.TagNumber(5)
  void clearGridHeight() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get cellAreaSqm => $_getN(5);
  @$pb.TagNumber(6)
  set cellAreaSqm($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCellAreaSqm() => $_has(5);
  @$pb.TagNumber(6)
  void clearCellAreaSqm() => $_clearField(6);

  /// delta_elevations[row*width+col] = compare − base (m). Row-major order.
  @$pb.TagNumber(7)
  $pb.PbList<$core.double> get deltaElevations => $_getList(6);

  @$pb.TagNumber(8)
  $core.double get meanDeltaM => $_getN(7);
  @$pb.TagNumber(8)
  set meanDeltaM($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMeanDeltaM() => $_has(7);
  @$pb.TagNumber(8)
  void clearMeanDeltaM() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get rmsDeltaM => $_getN(8);
  @$pb.TagNumber(9)
  set rmsDeltaM($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasRmsDeltaM() => $_has(8);
  @$pb.TagNumber(9)
  void clearRmsDeltaM() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get maxAbsDeltaM => $_getN(9);
  @$pb.TagNumber(10)
  set maxAbsDeltaM($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasMaxAbsDeltaM() => $_has(9);
  @$pb.TagNumber(10)
  void clearMaxAbsDeltaM() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get volumeAddedM3 => $_getN(10);
  @$pb.TagNumber(11)
  set volumeAddedM3($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasVolumeAddedM3() => $_has(10);
  @$pb.TagNumber(11)
  void clearVolumeAddedM3() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get volumeRemovedM3 => $_getN(11);
  @$pb.TagNumber(12)
  set volumeRemovedM3($core.double v) { $_setDouble(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasVolumeRemovedM3() => $_has(11);
  @$pb.TagNumber(12)
  void clearVolumeRemovedM3() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get netVolumeM3 => $_getN(12);
  @$pb.TagNumber(13)
  set netVolumeM3($core.double v) { $_setDouble(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasNetVolumeM3() => $_has(12);
  @$pb.TagNumber(13)
  void clearNetVolumeM3() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.int get validCellCount => $_getIZ(13);
  @$pb.TagNumber(14)
  set validCellCount($core.int v) { $_setSignedInt32(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasValidCellCount() => $_has(13);
  @$pb.TagNumber(14)
  void clearValidCellCount() => $_clearField(14);
}

class GenerateGradingPlanRequest extends $pb.GeneratedMessage {
  factory GenerateGradingPlanRequest({
    $core.String? terrainLayerId,
    $core.double? targetElevationM,
    $core.String? boundaryGeojson,
    $core.double? minDeltaM,
    $core.double? haulFactor,
    $core.int? gridWidth,
    $core.int? gridHeight,
    $core.double? cutRatePerM3,
    $core.double? fillRatePerM3,
    $core.double? haulRatePerM3m,
    $core.double? importRatePerM3,
    $core.double? exportRatePerM3,
    $core.double? compactionFactor,
    $core.String? currencyCode,
  }) {
    final $result = create();
    if (terrainLayerId != null) {
      $result.terrainLayerId = terrainLayerId;
    }
    if (targetElevationM != null) {
      $result.targetElevationM = targetElevationM;
    }
    if (boundaryGeojson != null) {
      $result.boundaryGeojson = boundaryGeojson;
    }
    if (minDeltaM != null) {
      $result.minDeltaM = minDeltaM;
    }
    if (haulFactor != null) {
      $result.haulFactor = haulFactor;
    }
    if (gridWidth != null) {
      $result.gridWidth = gridWidth;
    }
    if (gridHeight != null) {
      $result.gridHeight = gridHeight;
    }
    if (cutRatePerM3 != null) {
      $result.cutRatePerM3 = cutRatePerM3;
    }
    if (fillRatePerM3 != null) {
      $result.fillRatePerM3 = fillRatePerM3;
    }
    if (haulRatePerM3m != null) {
      $result.haulRatePerM3m = haulRatePerM3m;
    }
    if (importRatePerM3 != null) {
      $result.importRatePerM3 = importRatePerM3;
    }
    if (exportRatePerM3 != null) {
      $result.exportRatePerM3 = exportRatePerM3;
    }
    if (compactionFactor != null) {
      $result.compactionFactor = compactionFactor;
    }
    if (currencyCode != null) {
      $result.currencyCode = currencyCode;
    }
    return $result;
  }
  GenerateGradingPlanRequest._() : super();
  factory GenerateGradingPlanRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateGradingPlanRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateGradingPlanRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'terrainLayerId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'targetElevationM', $pb.PbFieldType.OD)
    ..aOS(3, _omitFieldNames ? '' : 'boundaryGeojson')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'minDeltaM', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'haulFactor', $pb.PbFieldType.OD)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'gridWidth', $pb.PbFieldType.O3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'gridHeight', $pb.PbFieldType.O3)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'cutRatePerM3', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'fillRatePerM3', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'haulRatePerM3m', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'importRatePerM3', $pb.PbFieldType.OD)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'exportRatePerM3', $pb.PbFieldType.OD)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'compactionFactor', $pb.PbFieldType.OD)
    ..aOS(14, _omitFieldNames ? '' : 'currencyCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateGradingPlanRequest clone() => GenerateGradingPlanRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateGradingPlanRequest copyWith(void Function(GenerateGradingPlanRequest) updates) => super.copyWith((message) => updates(message as GenerateGradingPlanRequest)) as GenerateGradingPlanRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateGradingPlanRequest create() => GenerateGradingPlanRequest._();
  GenerateGradingPlanRequest createEmptyInstance() => create();
  static $pb.PbList<GenerateGradingPlanRequest> createRepeated() => $pb.PbList<GenerateGradingPlanRequest>();
  @$core.pragma('dart2js:noInline')
  static GenerateGradingPlanRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateGradingPlanRequest>(create);
  static GenerateGradingPlanRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get terrainLayerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set terrainLayerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTerrainLayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTerrainLayerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get targetElevationM => $_getN(1);
  @$pb.TagNumber(2)
  set targetElevationM($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetElevationM() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetElevationM() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get boundaryGeojson => $_getSZ(2);
  @$pb.TagNumber(3)
  set boundaryGeojson($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBoundaryGeojson() => $_has(2);
  @$pb.TagNumber(3)
  void clearBoundaryGeojson() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get minDeltaM => $_getN(3);
  @$pb.TagNumber(4)
  set minDeltaM($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMinDeltaM() => $_has(3);
  @$pb.TagNumber(4)
  void clearMinDeltaM() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get haulFactor => $_getN(4);
  @$pb.TagNumber(5)
  set haulFactor($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHaulFactor() => $_has(4);
  @$pb.TagNumber(5)
  void clearHaulFactor() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get gridWidth => $_getIZ(5);
  @$pb.TagNumber(6)
  set gridWidth($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasGridWidth() => $_has(5);
  @$pb.TagNumber(6)
  void clearGridWidth() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get gridHeight => $_getIZ(6);
  @$pb.TagNumber(7)
  set gridHeight($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasGridHeight() => $_has(6);
  @$pb.TagNumber(7)
  void clearGridHeight() => $_clearField(7);

  /// Unit rates for cost estimation. Zero values disable that cost component.
  @$pb.TagNumber(8)
  $core.double get cutRatePerM3 => $_getN(7);
  @$pb.TagNumber(8)
  set cutRatePerM3($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCutRatePerM3() => $_has(7);
  @$pb.TagNumber(8)
  void clearCutRatePerM3() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get fillRatePerM3 => $_getN(8);
  @$pb.TagNumber(9)
  set fillRatePerM3($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasFillRatePerM3() => $_has(8);
  @$pb.TagNumber(9)
  void clearFillRatePerM3() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get haulRatePerM3m => $_getN(9);
  @$pb.TagNumber(10)
  set haulRatePerM3m($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasHaulRatePerM3m() => $_has(9);
  @$pb.TagNumber(10)
  void clearHaulRatePerM3m() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get importRatePerM3 => $_getN(10);
  @$pb.TagNumber(11)
  set importRatePerM3($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasImportRatePerM3() => $_has(10);
  @$pb.TagNumber(11)
  void clearImportRatePerM3() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get exportRatePerM3 => $_getN(11);
  @$pb.TagNumber(12)
  set exportRatePerM3($core.double v) { $_setDouble(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasExportRatePerM3() => $_has(11);
  @$pb.TagNumber(12)
  void clearExportRatePerM3() => $_clearField(12);

  /// compaction_factor: ratio of in-situ cut volume to compacted fill volume.
  /// 1.0 = no shrinkage or bulking. Typical 1.1–1.3 for granular soils.
  @$pb.TagNumber(13)
  $core.double get compactionFactor => $_getN(12);
  @$pb.TagNumber(13)
  set compactionFactor($core.double v) { $_setDouble(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasCompactionFactor() => $_has(12);
  @$pb.TagNumber(13)
  void clearCompactionFactor() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get currencyCode => $_getSZ(13);
  @$pb.TagNumber(14)
  set currencyCode($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasCurrencyCode() => $_has(13);
  @$pb.TagNumber(14)
  void clearCurrencyCode() => $_clearField(14);
}

/// GradingPlanCostBreakdown contains all derived volumes and costs traceable to
/// the input unit rates and earthwork engine output.
class GradingPlanCostBreakdown extends $pb.GeneratedMessage {
  factory GradingPlanCostBreakdown({
    $core.double? cutVolumeM3,
    $core.double? fillVolumeM3,
    $core.double? fillDemandM3,
    $core.double? exportVolumeM3,
    $core.double? importVolumeM3,
    $core.double? hauledVolumeM3,
    $core.double? haulDistanceM,
    $core.double? haulEffortM3m,
    $core.double? cutCost,
    $core.double? fillCost,
    $core.double? haulCost,
    $core.double? importCost,
    $core.double? exportCost,
    $core.double? totalCost,
    $core.String? currencyCode,
  }) {
    final $result = create();
    if (cutVolumeM3 != null) {
      $result.cutVolumeM3 = cutVolumeM3;
    }
    if (fillVolumeM3 != null) {
      $result.fillVolumeM3 = fillVolumeM3;
    }
    if (fillDemandM3 != null) {
      $result.fillDemandM3 = fillDemandM3;
    }
    if (exportVolumeM3 != null) {
      $result.exportVolumeM3 = exportVolumeM3;
    }
    if (importVolumeM3 != null) {
      $result.importVolumeM3 = importVolumeM3;
    }
    if (hauledVolumeM3 != null) {
      $result.hauledVolumeM3 = hauledVolumeM3;
    }
    if (haulDistanceM != null) {
      $result.haulDistanceM = haulDistanceM;
    }
    if (haulEffortM3m != null) {
      $result.haulEffortM3m = haulEffortM3m;
    }
    if (cutCost != null) {
      $result.cutCost = cutCost;
    }
    if (fillCost != null) {
      $result.fillCost = fillCost;
    }
    if (haulCost != null) {
      $result.haulCost = haulCost;
    }
    if (importCost != null) {
      $result.importCost = importCost;
    }
    if (exportCost != null) {
      $result.exportCost = exportCost;
    }
    if (totalCost != null) {
      $result.totalCost = totalCost;
    }
    if (currencyCode != null) {
      $result.currencyCode = currencyCode;
    }
    return $result;
  }
  GradingPlanCostBreakdown._() : super();
  factory GradingPlanCostBreakdown.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GradingPlanCostBreakdown.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GradingPlanCostBreakdown', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'cutVolumeM3', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'fillVolumeM3', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'fillDemandM3', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'exportVolumeM3', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'importVolumeM3', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'hauledVolumeM3', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'haulDistanceM', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'haulEffortM3m', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'cutCost', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'fillCost', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'haulCost', $pb.PbFieldType.OD)
    ..a<$core.double>(12, _omitFieldNames ? '' : 'importCost', $pb.PbFieldType.OD)
    ..a<$core.double>(13, _omitFieldNames ? '' : 'exportCost', $pb.PbFieldType.OD)
    ..a<$core.double>(14, _omitFieldNames ? '' : 'totalCost', $pb.PbFieldType.OD)
    ..aOS(15, _omitFieldNames ? '' : 'currencyCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GradingPlanCostBreakdown clone() => GradingPlanCostBreakdown()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GradingPlanCostBreakdown copyWith(void Function(GradingPlanCostBreakdown) updates) => super.copyWith((message) => updates(message as GradingPlanCostBreakdown)) as GradingPlanCostBreakdown;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GradingPlanCostBreakdown create() => GradingPlanCostBreakdown._();
  GradingPlanCostBreakdown createEmptyInstance() => create();
  static $pb.PbList<GradingPlanCostBreakdown> createRepeated() => $pb.PbList<GradingPlanCostBreakdown>();
  @$core.pragma('dart2js:noInline')
  static GradingPlanCostBreakdown getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GradingPlanCostBreakdown>(create);
  static GradingPlanCostBreakdown? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get cutVolumeM3 => $_getN(0);
  @$pb.TagNumber(1)
  set cutVolumeM3($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCutVolumeM3() => $_has(0);
  @$pb.TagNumber(1)
  void clearCutVolumeM3() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get fillVolumeM3 => $_getN(1);
  @$pb.TagNumber(2)
  set fillVolumeM3($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFillVolumeM3() => $_has(1);
  @$pb.TagNumber(2)
  void clearFillVolumeM3() => $_clearField(2);

  /// fill_demand_m3 = fill_volume_m3 * compaction_factor (in-situ cut m3 needed)
  @$pb.TagNumber(3)
  $core.double get fillDemandM3 => $_getN(2);
  @$pb.TagNumber(3)
  set fillDemandM3($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFillDemandM3() => $_has(2);
  @$pb.TagNumber(3)
  void clearFillDemandM3() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get exportVolumeM3 => $_getN(3);
  @$pb.TagNumber(4)
  set exportVolumeM3($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasExportVolumeM3() => $_has(3);
  @$pb.TagNumber(4)
  void clearExportVolumeM3() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get importVolumeM3 => $_getN(4);
  @$pb.TagNumber(5)
  set importVolumeM3($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasImportVolumeM3() => $_has(4);
  @$pb.TagNumber(5)
  void clearImportVolumeM3() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get hauledVolumeM3 => $_getN(5);
  @$pb.TagNumber(6)
  set hauledVolumeM3($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasHauledVolumeM3() => $_has(5);
  @$pb.TagNumber(6)
  void clearHauledVolumeM3() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get haulDistanceM => $_getN(6);
  @$pb.TagNumber(7)
  set haulDistanceM($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasHaulDistanceM() => $_has(6);
  @$pb.TagNumber(7)
  void clearHaulDistanceM() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get haulEffortM3m => $_getN(7);
  @$pb.TagNumber(8)
  set haulEffortM3m($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasHaulEffortM3m() => $_has(7);
  @$pb.TagNumber(8)
  void clearHaulEffortM3m() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get cutCost => $_getN(8);
  @$pb.TagNumber(9)
  set cutCost($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCutCost() => $_has(8);
  @$pb.TagNumber(9)
  void clearCutCost() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get fillCost => $_getN(9);
  @$pb.TagNumber(10)
  set fillCost($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasFillCost() => $_has(9);
  @$pb.TagNumber(10)
  void clearFillCost() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get haulCost => $_getN(10);
  @$pb.TagNumber(11)
  set haulCost($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasHaulCost() => $_has(10);
  @$pb.TagNumber(11)
  void clearHaulCost() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.double get importCost => $_getN(11);
  @$pb.TagNumber(12)
  set importCost($core.double v) { $_setDouble(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasImportCost() => $_has(11);
  @$pb.TagNumber(12)
  void clearImportCost() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get exportCost => $_getN(12);
  @$pb.TagNumber(13)
  set exportCost($core.double v) { $_setDouble(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasExportCost() => $_has(12);
  @$pb.TagNumber(13)
  void clearExportCost() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.double get totalCost => $_getN(13);
  @$pb.TagNumber(14)
  set totalCost($core.double v) { $_setDouble(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasTotalCost() => $_has(13);
  @$pb.TagNumber(14)
  void clearTotalCost() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get currencyCode => $_getSZ(14);
  @$pb.TagNumber(15)
  set currencyCode($core.String v) { $_setString(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasCurrencyCode() => $_has(14);
  @$pb.TagNumber(15)
  void clearCurrencyCode() => $_clearField(15);
}

class GenerateGradingPlanResponse extends $pb.GeneratedMessage {
  factory GenerateGradingPlanResponse({
    $core.String? demLayerId,
    $core.double? targetElevationM,
    $core.double? meanElevationM,
    $core.double? affectedAreaSqm,
    $core.double? balancedVolumeRatio,
    $core.double? compactionFactor,
    $core.double? cutRatePerM3,
    $core.double? fillRatePerM3,
    $core.double? haulRatePerM3m,
    $core.double? importRatePerM3,
    $core.double? exportRatePerM3,
    GradingPlanCostBreakdown? cost,
  }) {
    final $result = create();
    if (demLayerId != null) {
      $result.demLayerId = demLayerId;
    }
    if (targetElevationM != null) {
      $result.targetElevationM = targetElevationM;
    }
    if (meanElevationM != null) {
      $result.meanElevationM = meanElevationM;
    }
    if (affectedAreaSqm != null) {
      $result.affectedAreaSqm = affectedAreaSqm;
    }
    if (balancedVolumeRatio != null) {
      $result.balancedVolumeRatio = balancedVolumeRatio;
    }
    if (compactionFactor != null) {
      $result.compactionFactor = compactionFactor;
    }
    if (cutRatePerM3 != null) {
      $result.cutRatePerM3 = cutRatePerM3;
    }
    if (fillRatePerM3 != null) {
      $result.fillRatePerM3 = fillRatePerM3;
    }
    if (haulRatePerM3m != null) {
      $result.haulRatePerM3m = haulRatePerM3m;
    }
    if (importRatePerM3 != null) {
      $result.importRatePerM3 = importRatePerM3;
    }
    if (exportRatePerM3 != null) {
      $result.exportRatePerM3 = exportRatePerM3;
    }
    if (cost != null) {
      $result.cost = cost;
    }
    return $result;
  }
  GenerateGradingPlanResponse._() : super();
  factory GenerateGradingPlanResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenerateGradingPlanResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GenerateGradingPlanResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'terrain.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'demLayerId')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'targetElevationM', $pb.PbFieldType.OD)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'meanElevationM', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'affectedAreaSqm', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'balancedVolumeRatio', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'compactionFactor', $pb.PbFieldType.OD)
    ..a<$core.double>(7, _omitFieldNames ? '' : 'cutRatePerM3', $pb.PbFieldType.OD)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'fillRatePerM3', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'haulRatePerM3m', $pb.PbFieldType.OD)
    ..a<$core.double>(10, _omitFieldNames ? '' : 'importRatePerM3', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'exportRatePerM3', $pb.PbFieldType.OD)
    ..aOM<GradingPlanCostBreakdown>(12, _omitFieldNames ? '' : 'cost', subBuilder: GradingPlanCostBreakdown.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenerateGradingPlanResponse clone() => GenerateGradingPlanResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenerateGradingPlanResponse copyWith(void Function(GenerateGradingPlanResponse) updates) => super.copyWith((message) => updates(message as GenerateGradingPlanResponse)) as GenerateGradingPlanResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenerateGradingPlanResponse create() => GenerateGradingPlanResponse._();
  GenerateGradingPlanResponse createEmptyInstance() => create();
  static $pb.PbList<GenerateGradingPlanResponse> createRepeated() => $pb.PbList<GenerateGradingPlanResponse>();
  @$core.pragma('dart2js:noInline')
  static GenerateGradingPlanResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenerateGradingPlanResponse>(create);
  static GenerateGradingPlanResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get demLayerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set demLayerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDemLayerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDemLayerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get targetElevationM => $_getN(1);
  @$pb.TagNumber(2)
  set targetElevationM($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTargetElevationM() => $_has(1);
  @$pb.TagNumber(2)
  void clearTargetElevationM() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get meanElevationM => $_getN(2);
  @$pb.TagNumber(3)
  set meanElevationM($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMeanElevationM() => $_has(2);
  @$pb.TagNumber(3)
  void clearMeanElevationM() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get affectedAreaSqm => $_getN(3);
  @$pb.TagNumber(4)
  set affectedAreaSqm($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAffectedAreaSqm() => $_has(3);
  @$pb.TagNumber(4)
  void clearAffectedAreaSqm() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get balancedVolumeRatio => $_getN(4);
  @$pb.TagNumber(5)
  set balancedVolumeRatio($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasBalancedVolumeRatio() => $_has(4);
  @$pb.TagNumber(5)
  void clearBalancedVolumeRatio() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get compactionFactor => $_getN(5);
  @$pb.TagNumber(6)
  set compactionFactor($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCompactionFactor() => $_has(5);
  @$pb.TagNumber(6)
  void clearCompactionFactor() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get cutRatePerM3 => $_getN(6);
  @$pb.TagNumber(7)
  set cutRatePerM3($core.double v) { $_setDouble(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCutRatePerM3() => $_has(6);
  @$pb.TagNumber(7)
  void clearCutRatePerM3() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.double get fillRatePerM3 => $_getN(7);
  @$pb.TagNumber(8)
  set fillRatePerM3($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasFillRatePerM3() => $_has(7);
  @$pb.TagNumber(8)
  void clearFillRatePerM3() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get haulRatePerM3m => $_getN(8);
  @$pb.TagNumber(9)
  set haulRatePerM3m($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasHaulRatePerM3m() => $_has(8);
  @$pb.TagNumber(9)
  void clearHaulRatePerM3m() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get importRatePerM3 => $_getN(9);
  @$pb.TagNumber(10)
  set importRatePerM3($core.double v) { $_setDouble(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasImportRatePerM3() => $_has(9);
  @$pb.TagNumber(10)
  void clearImportRatePerM3() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get exportRatePerM3 => $_getN(10);
  @$pb.TagNumber(11)
  set exportRatePerM3($core.double v) { $_setDouble(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasExportRatePerM3() => $_has(10);
  @$pb.TagNumber(11)
  void clearExportRatePerM3() => $_clearField(11);

  @$pb.TagNumber(12)
  GradingPlanCostBreakdown get cost => $_getN(11);
  @$pb.TagNumber(12)
  set cost(GradingPlanCostBreakdown v) { $_setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasCost() => $_has(11);
  @$pb.TagNumber(12)
  void clearCost() => $_clearField(12);
  @$pb.TagNumber(12)
  GradingPlanCostBreakdown ensureCost() => $_ensure(11);
}

/// TerrainService manages terrain layer lifecycle and terrain analytics operations.
class TerrainServiceApi {
  $pb.RpcClient _client;
  TerrainServiceApi(this._client);

  /// UploadTerrain ingests a terrain file and creates a terrain layer.
  $async.Future<UploadTerrainResponse> uploadTerrain($pb.ClientContext? ctx, UploadTerrainRequest request) =>
    _client.invoke<UploadTerrainResponse>(ctx, 'TerrainService', 'UploadTerrain', request, UploadTerrainResponse())
  ;
  /// GetTerrainLayer returns a terrain layer by ID.
  $async.Future<GetTerrainLayerResponse> getTerrainLayer($pb.ClientContext? ctx, GetTerrainLayerRequest request) =>
    _client.invoke<GetTerrainLayerResponse>(ctx, 'TerrainService', 'GetTerrainLayer', request, GetTerrainLayerResponse())
  ;
  /// ListTerrainLayers lists terrain layers for a project.
  $async.Future<ListTerrainLayersResponse> listTerrainLayers($pb.ClientContext? ctx, ListTerrainLayersRequest request) =>
    _client.invoke<ListTerrainLayersResponse>(ctx, 'TerrainService', 'ListTerrainLayers', request, ListTerrainLayersResponse())
  ;
  /// GetElevation returns elevation at a single coordinate.
  $async.Future<GetElevationResponse> getElevation($pb.ClientContext? ctx, GetElevationRequest request) =>
    _client.invoke<GetElevationResponse>(ctx, 'TerrainService', 'GetElevation', request, GetElevationResponse())
  ;
  /// GetElevationGrid returns elevation values for a bounding box grid.
  $async.Future<GetElevationGridResponse> getElevationGrid($pb.ClientContext? ctx, GetElevationGridRequest request) =>
    _client.invoke<GetElevationGridResponse>(ctx, 'TerrainService', 'GetElevationGrid', request, GetElevationGridResponse())
  ;
  /// AnalyzeEarthwork computes cut/fill and related earthwork metrics.
  $async.Future<AnalyzeEarthworkResponse> analyzeEarthwork($pb.ClientContext? ctx, AnalyzeEarthworkRequest request) =>
    _client.invoke<AnalyzeEarthworkResponse>(ctx, 'TerrainService', 'AnalyzeEarthwork', request, AnalyzeEarthworkResponse())
  ;
  /// DiffTerrainLayers computes differences between two terrain layers.
  $async.Future<DiffTerrainLayersResponse> diffTerrainLayers($pb.ClientContext? ctx, DiffTerrainLayersRequest request) =>
    _client.invoke<DiffTerrainLayersResponse>(ctx, 'TerrainService', 'DiffTerrainLayers', request, DiffTerrainLayersResponse())
  ;
  /// GenerateGradingPlan generates grading recommendations from terrain constraints.
  $async.Future<GenerateGradingPlanResponse> generateGradingPlan($pb.ClientContext? ctx, GenerateGradingPlanRequest request) =>
    _client.invoke<GenerateGradingPlanResponse>(ctx, 'TerrainService', 'GenerateGradingPlan', request, GenerateGradingPlanResponse())
  ;
  /// ComputeSlope computes slope values from terrain data.
  $async.Future<ComputeSlopeResponse> computeSlope($pb.ClientContext? ctx, ComputeSlopeRequest request) =>
    _client.invoke<ComputeSlopeResponse>(ctx, 'TerrainService', 'ComputeSlope', request, ComputeSlopeResponse())
  ;
  /// ComputeAspect computes aspect values from terrain data.
  $async.Future<ComputeAspectResponse> computeAspect($pb.ClientContext? ctx, ComputeAspectRequest request) =>
    _client.invoke<ComputeAspectResponse>(ctx, 'TerrainService', 'ComputeAspect', request, ComputeAspectResponse())
  ;
  /// DeleteTerrainLayer deletes a terrain layer by ID.
  $async.Future<DeleteTerrainLayerResponse> deleteTerrainLayer($pb.ClientContext? ctx, DeleteTerrainLayerRequest request) =>
    _client.invoke<DeleteTerrainLayerResponse>(ctx, 'TerrainService', 'DeleteTerrainLayer', request, DeleteTerrainLayerResponse())
  ;
}

/// TerrainComputeService exposes only stateless compute-style terrain operations.
/// Lifecycle/storage operations remain in TerrainService.
class TerrainComputeServiceApi {
  $pb.RpcClient _client;
  TerrainComputeServiceApi(this._client);

  /// GetElevation returns elevation at a single coordinate.
  $async.Future<GetElevationResponse> getElevation($pb.ClientContext? ctx, GetElevationRequest request) =>
    _client.invoke<GetElevationResponse>(ctx, 'TerrainComputeService', 'GetElevation', request, GetElevationResponse())
  ;
  /// GetElevationGrid returns elevation values for a bounding box grid.
  $async.Future<GetElevationGridResponse> getElevationGrid($pb.ClientContext? ctx, GetElevationGridRequest request) =>
    _client.invoke<GetElevationGridResponse>(ctx, 'TerrainComputeService', 'GetElevationGrid', request, GetElevationGridResponse())
  ;
  /// ComputeSlope computes slope values from terrain data.
  $async.Future<ComputeSlopeResponse> computeSlope($pb.ClientContext? ctx, ComputeSlopeRequest request) =>
    _client.invoke<ComputeSlopeResponse>(ctx, 'TerrainComputeService', 'ComputeSlope', request, ComputeSlopeResponse())
  ;
  /// ComputeAspect computes aspect values from terrain data.
  $async.Future<ComputeAspectResponse> computeAspect($pb.ClientContext? ctx, ComputeAspectRequest request) =>
    _client.invoke<ComputeAspectResponse>(ctx, 'TerrainComputeService', 'ComputeAspect', request, ComputeAspectResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
