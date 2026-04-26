//
//  Generated code. Do not modify.
//  source: kml/v1/kml_ingestion.proto
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
import 'kml_ingestion.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'kml_ingestion.pbenum.dart';

/// Request to upload KML/KMZ file for import.
class UploadKMLRequest extends $pb.GeneratedMessage {
  factory UploadKMLRequest({
    $core.List<$core.int>? fileData,
    $core.String? fileName,
    CRSCode? sourceCrs,
    $core.String? projectId,
    $pb.PbMap<$core.String, $core.String>? tags,
  }) {
    final $result = create();
    if (fileData != null) {
      $result.fileData = fileData;
    }
    if (fileName != null) {
      $result.fileName = fileName;
    }
    if (sourceCrs != null) {
      $result.sourceCrs = sourceCrs;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (tags != null) {
      $result.tags.addAll(tags);
    }
    return $result;
  }
  UploadKMLRequest._() : super();
  factory UploadKMLRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadKMLRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadKMLRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'kml.v1'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'fileData', $pb.PbFieldType.OY)
    ..aOS(2, _omitFieldNames ? '' : 'fileName')
    ..e<CRSCode>(3, _omitFieldNames ? '' : 'sourceCrs', $pb.PbFieldType.OE, defaultOrMaker: CRSCode.CRS_UNKNOWN, valueOf: CRSCode.valueOf, enumValues: CRSCode.values)
    ..aOS(4, _omitFieldNames ? '' : 'projectId')
    ..m<$core.String, $core.String>(5, _omitFieldNames ? '' : 'tags', entryClassName: 'UploadKMLRequest.TagsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('kml.v1'))
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadKMLRequest clone() => UploadKMLRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadKMLRequest copyWith(void Function(UploadKMLRequest) updates) => super.copyWith((message) => updates(message as UploadKMLRequest)) as UploadKMLRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadKMLRequest create() => UploadKMLRequest._();
  UploadKMLRequest createEmptyInstance() => create();
  static $pb.PbList<UploadKMLRequest> createRepeated() => $pb.PbList<UploadKMLRequest>();
  @$core.pragma('dart2js:noInline')
  static UploadKMLRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadKMLRequest>(create);
  static UploadKMLRequest? _defaultInstance;

  /// File content (raw KML or zipped KMZ).
  @$pb.TagNumber(1)
  $core.List<$core.int> get fileData => $_getN(0);
  @$pb.TagNumber(1)
  set fileData($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFileData() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileData() => $_clearField(1);

  /// File name (used to determine if it's KML or KMZ).
  @$pb.TagNumber(2)
  $core.String get fileName => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFileName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileName() => $_clearField(2);

  /// Optional hint about source CRS if not detectable from KML.
  @$pb.TagNumber(3)
  CRSCode get sourceCrs => $_getN(2);
  @$pb.TagNumber(3)
  set sourceCrs(CRSCode v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSourceCrs() => $_has(2);
  @$pb.TagNumber(3)
  void clearSourceCrs() => $_clearField(3);

  /// Optional project/site ID for grouping imports.
  @$pb.TagNumber(4)
  $core.String get projectId => $_getSZ(3);
  @$pb.TagNumber(4)
  set projectId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasProjectId() => $_has(3);
  @$pb.TagNumber(4)
  void clearProjectId() => $_clearField(4);

  /// Optional metadata tags.
  @$pb.TagNumber(5)
  $pb.PbMap<$core.String, $core.String> get tags => $_getMap(4);
}

/// Response to upload request with job tracking ID.
class UploadKMLResponse extends $pb.GeneratedMessage {
  factory UploadKMLResponse({
    $core.String? uploadJobId,
    UploadStatus? status,
    $0.Timestamp? createdAt,
  }) {
    final $result = create();
    if (uploadJobId != null) {
      $result.uploadJobId = uploadJobId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  UploadKMLResponse._() : super();
  factory UploadKMLResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UploadKMLResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UploadKMLResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'kml.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uploadJobId')
    ..e<UploadStatus>(2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: UploadStatus.STATUS_UNKNOWN, valueOf: UploadStatus.valueOf, enumValues: UploadStatus.values)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UploadKMLResponse clone() => UploadKMLResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UploadKMLResponse copyWith(void Function(UploadKMLResponse) updates) => super.copyWith((message) => updates(message as UploadKMLResponse)) as UploadKMLResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadKMLResponse create() => UploadKMLResponse._();
  UploadKMLResponse createEmptyInstance() => create();
  static $pb.PbList<UploadKMLResponse> createRepeated() => $pb.PbList<UploadKMLResponse>();
  @$core.pragma('dart2js:noInline')
  static UploadKMLResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UploadKMLResponse>(create);
  static UploadKMLResponse? _defaultInstance;

  /// Unique job ID for tracking progress.
  @$pb.TagNumber(1)
  $core.String get uploadJobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set uploadJobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUploadJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUploadJobId() => $_clearField(1);

  /// Initial status.
  @$pb.TagNumber(2)
  UploadStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(UploadStatus v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  /// Timestamp when upload was created.
  @$pb.TagNumber(3)
  $0.Timestamp get createdAt => $_getN(2);
  @$pb.TagNumber(3)
  set createdAt($0.Timestamp v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasCreatedAt() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreatedAt() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureCreatedAt() => $_ensure(2);
}

/// Request to check status of upload job.
class GetUploadStatusRequest extends $pb.GeneratedMessage {
  factory GetUploadStatusRequest({
    $core.String? uploadJobId,
  }) {
    final $result = create();
    if (uploadJobId != null) {
      $result.uploadJobId = uploadJobId;
    }
    return $result;
  }
  GetUploadStatusRequest._() : super();
  factory GetUploadStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetUploadStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetUploadStatusRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'kml.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uploadJobId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetUploadStatusRequest clone() => GetUploadStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetUploadStatusRequest copyWith(void Function(GetUploadStatusRequest) updates) => super.copyWith((message) => updates(message as GetUploadStatusRequest)) as GetUploadStatusRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUploadStatusRequest create() => GetUploadStatusRequest._();
  GetUploadStatusRequest createEmptyInstance() => create();
  static $pb.PbList<GetUploadStatusRequest> createRepeated() => $pb.PbList<GetUploadStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static GetUploadStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetUploadStatusRequest>(create);
  static GetUploadStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uploadJobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set uploadJobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUploadJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUploadJobId() => $_clearField(1);
}

/// Response with upload job status and progress.
class GetUploadStatusResponse extends $pb.GeneratedMessage {
  factory GetUploadStatusResponse({
    $core.String? uploadJobId,
    UploadStatus? status,
    $core.int? featuresProcessed,
    $core.int? totalFeatures,
    $core.String? errorMessage,
    $0.Timestamp? startedAt,
    $0.Timestamp? completedAt,
    CRSCode? detectedCrs,
  }) {
    final $result = create();
    if (uploadJobId != null) {
      $result.uploadJobId = uploadJobId;
    }
    if (status != null) {
      $result.status = status;
    }
    if (featuresProcessed != null) {
      $result.featuresProcessed = featuresProcessed;
    }
    if (totalFeatures != null) {
      $result.totalFeatures = totalFeatures;
    }
    if (errorMessage != null) {
      $result.errorMessage = errorMessage;
    }
    if (startedAt != null) {
      $result.startedAt = startedAt;
    }
    if (completedAt != null) {
      $result.completedAt = completedAt;
    }
    if (detectedCrs != null) {
      $result.detectedCrs = detectedCrs;
    }
    return $result;
  }
  GetUploadStatusResponse._() : super();
  factory GetUploadStatusResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetUploadStatusResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetUploadStatusResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'kml.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uploadJobId')
    ..e<UploadStatus>(2, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: UploadStatus.STATUS_UNKNOWN, valueOf: UploadStatus.valueOf, enumValues: UploadStatus.values)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'featuresProcessed', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'totalFeatures', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'errorMessage')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'startedAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'completedAt', subBuilder: $0.Timestamp.create)
    ..e<CRSCode>(8, _omitFieldNames ? '' : 'detectedCrs', $pb.PbFieldType.OE, defaultOrMaker: CRSCode.CRS_UNKNOWN, valueOf: CRSCode.valueOf, enumValues: CRSCode.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetUploadStatusResponse clone() => GetUploadStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetUploadStatusResponse copyWith(void Function(GetUploadStatusResponse) updates) => super.copyWith((message) => updates(message as GetUploadStatusResponse)) as GetUploadStatusResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetUploadStatusResponse create() => GetUploadStatusResponse._();
  GetUploadStatusResponse createEmptyInstance() => create();
  static $pb.PbList<GetUploadStatusResponse> createRepeated() => $pb.PbList<GetUploadStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static GetUploadStatusResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetUploadStatusResponse>(create);
  static GetUploadStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uploadJobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set uploadJobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUploadJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUploadJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  UploadStatus get status => $_getN(1);
  @$pb.TagNumber(2)
  set status(UploadStatus v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatus() => $_clearField(2);

  /// Number of features parsed so far.
  @$pb.TagNumber(3)
  $core.int get featuresProcessed => $_getIZ(2);
  @$pb.TagNumber(3)
  set featuresProcessed($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFeaturesProcessed() => $_has(2);
  @$pb.TagNumber(3)
  void clearFeaturesProcessed() => $_clearField(3);

  /// Total features in file (0 if still parsing).
  @$pb.TagNumber(4)
  $core.int get totalFeatures => $_getIZ(3);
  @$pb.TagNumber(4)
  set totalFeatures($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalFeatures() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalFeatures() => $_clearField(4);

  /// Error message if status is FAILED.
  @$pb.TagNumber(5)
  $core.String get errorMessage => $_getSZ(4);
  @$pb.TagNumber(5)
  set errorMessage($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasErrorMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearErrorMessage() => $_clearField(5);

  /// Timestamp when processing started.
  @$pb.TagNumber(6)
  $0.Timestamp get startedAt => $_getN(5);
  @$pb.TagNumber(6)
  set startedAt($0.Timestamp v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasStartedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearStartedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureStartedAt() => $_ensure(5);

  /// Timestamp when processing completed (if done).
  @$pb.TagNumber(7)
  $0.Timestamp get completedAt => $_getN(6);
  @$pb.TagNumber(7)
  set completedAt($0.Timestamp v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasCompletedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearCompletedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureCompletedAt() => $_ensure(6);

  /// Detected CRS of source file.
  @$pb.TagNumber(8)
  CRSCode get detectedCrs => $_getN(7);
  @$pb.TagNumber(8)
  set detectedCrs(CRSCode v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasDetectedCrs() => $_has(7);
  @$pb.TagNumber(8)
  void clearDetectedCrs() => $_clearField(8);
}

/// Request to list imported geometries from completed upload.
class ListImportedGeometriesRequest extends $pb.GeneratedMessage {
  factory ListImportedGeometriesRequest({
    $core.String? uploadJobId,
    GeometryType? geometryType,
    $core.int? limit,
    $core.int? offset,
  }) {
    final $result = create();
    if (uploadJobId != null) {
      $result.uploadJobId = uploadJobId;
    }
    if (geometryType != null) {
      $result.geometryType = geometryType;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    if (offset != null) {
      $result.offset = offset;
    }
    return $result;
  }
  ListImportedGeometriesRequest._() : super();
  factory ListImportedGeometriesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListImportedGeometriesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListImportedGeometriesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'kml.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uploadJobId')
    ..e<GeometryType>(2, _omitFieldNames ? '' : 'geometryType', $pb.PbFieldType.OE, defaultOrMaker: GeometryType.TYPE_UNKNOWN, valueOf: GeometryType.valueOf, enumValues: GeometryType.values)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'offset', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListImportedGeometriesRequest clone() => ListImportedGeometriesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListImportedGeometriesRequest copyWith(void Function(ListImportedGeometriesRequest) updates) => super.copyWith((message) => updates(message as ListImportedGeometriesRequest)) as ListImportedGeometriesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListImportedGeometriesRequest create() => ListImportedGeometriesRequest._();
  ListImportedGeometriesRequest createEmptyInstance() => create();
  static $pb.PbList<ListImportedGeometriesRequest> createRepeated() => $pb.PbList<ListImportedGeometriesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListImportedGeometriesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListImportedGeometriesRequest>(create);
  static ListImportedGeometriesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uploadJobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set uploadJobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUploadJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUploadJobId() => $_clearField(1);

  /// Optional filter: return only geometries of this type.
  @$pb.TagNumber(2)
  GeometryType get geometryType => $_getN(1);
  @$pb.TagNumber(2)
  set geometryType(GeometryType v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasGeometryType() => $_has(1);
  @$pb.TagNumber(2)
  void clearGeometryType() => $_clearField(2);

  /// Optional pagination limit.
  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);

  /// Optional pagination offset.
  @$pb.TagNumber(4)
  $core.int get offset => $_getIZ(3);
  @$pb.TagNumber(4)
  set offset($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOffset() => $_has(3);
  @$pb.TagNumber(4)
  void clearOffset() => $_clearField(4);
}

/// Imported geometry with minimal metadata.
class ImportedGeometryStub extends $pb.GeneratedMessage {
  factory ImportedGeometryStub({
    $core.String? geometryId,
    $core.String? name,
    GeometryType? type,
    $1.BoundingBox2D? boundingBox,
    $core.int? featureCount,
  }) {
    final $result = create();
    if (geometryId != null) {
      $result.geometryId = geometryId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (type != null) {
      $result.type = type;
    }
    if (boundingBox != null) {
      $result.boundingBox = boundingBox;
    }
    if (featureCount != null) {
      $result.featureCount = featureCount;
    }
    return $result;
  }
  ImportedGeometryStub._() : super();
  factory ImportedGeometryStub.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ImportedGeometryStub.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ImportedGeometryStub', package: const $pb.PackageName(_omitMessageNames ? '' : 'kml.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'geometryId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..e<GeometryType>(3, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: GeometryType.TYPE_UNKNOWN, valueOf: GeometryType.valueOf, enumValues: GeometryType.values)
    ..aOM<$1.BoundingBox2D>(4, _omitFieldNames ? '' : 'boundingBox', subBuilder: $1.BoundingBox2D.create)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'featureCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ImportedGeometryStub clone() => ImportedGeometryStub()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ImportedGeometryStub copyWith(void Function(ImportedGeometryStub) updates) => super.copyWith((message) => updates(message as ImportedGeometryStub)) as ImportedGeometryStub;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ImportedGeometryStub create() => ImportedGeometryStub._();
  ImportedGeometryStub createEmptyInstance() => create();
  static $pb.PbList<ImportedGeometryStub> createRepeated() => $pb.PbList<ImportedGeometryStub>();
  @$core.pragma('dart2js:noInline')
  static ImportedGeometryStub getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ImportedGeometryStub>(create);
  static ImportedGeometryStub? _defaultInstance;

  /// Unique geometry ID within upload.
  @$pb.TagNumber(1)
  $core.String get geometryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set geometryId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGeometryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGeometryId() => $_clearField(1);

  /// Feature name from KML.
  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  /// Geometry type.
  @$pb.TagNumber(3)
  GeometryType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(GeometryType v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  /// Canonical bounding box (WGS84).
  @$pb.TagNumber(4)
  $1.BoundingBox2D get boundingBox => $_getN(3);
  @$pb.TagNumber(4)
  set boundingBox($1.BoundingBox2D v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasBoundingBox() => $_has(3);
  @$pb.TagNumber(4)
  void clearBoundingBox() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.BoundingBox2D ensureBoundingBox() => $_ensure(3);

  /// Feature count for multi-geometries.
  @$pb.TagNumber(5)
  $core.int get featureCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set featureCount($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasFeatureCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearFeatureCount() => $_clearField(5);
}

/// Response with list of imported geometries.
class ListImportedGeometriesResponse extends $pb.GeneratedMessage {
  factory ListImportedGeometriesResponse({
    $core.Iterable<ImportedGeometryStub>? geometries,
    $core.int? totalCount,
  }) {
    final $result = create();
    if (geometries != null) {
      $result.geometries.addAll(geometries);
    }
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    return $result;
  }
  ListImportedGeometriesResponse._() : super();
  factory ListImportedGeometriesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListImportedGeometriesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListImportedGeometriesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'kml.v1'), createEmptyInstance: create)
    ..pc<ImportedGeometryStub>(1, _omitFieldNames ? '' : 'geometries', $pb.PbFieldType.PM, subBuilder: ImportedGeometryStub.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListImportedGeometriesResponse clone() => ListImportedGeometriesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListImportedGeometriesResponse copyWith(void Function(ListImportedGeometriesResponse) updates) => super.copyWith((message) => updates(message as ListImportedGeometriesResponse)) as ListImportedGeometriesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListImportedGeometriesResponse create() => ListImportedGeometriesResponse._();
  ListImportedGeometriesResponse createEmptyInstance() => create();
  static $pb.PbList<ListImportedGeometriesResponse> createRepeated() => $pb.PbList<ListImportedGeometriesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListImportedGeometriesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListImportedGeometriesResponse>(create);
  static ListImportedGeometriesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<ImportedGeometryStub> get geometries => $_getList(0);

  /// Total count of geometries in upload.
  @$pb.TagNumber(2)
  $core.int get totalCount => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalCount($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalCount() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalCount() => $_clearField(2);
}

/// Request to retrieve full details of imported geometry.
class GetImportedGeometryRequest extends $pb.GeneratedMessage {
  factory GetImportedGeometryRequest({
    $core.String? uploadJobId,
    $core.String? geometryId,
  }) {
    final $result = create();
    if (uploadJobId != null) {
      $result.uploadJobId = uploadJobId;
    }
    if (geometryId != null) {
      $result.geometryId = geometryId;
    }
    return $result;
  }
  GetImportedGeometryRequest._() : super();
  factory GetImportedGeometryRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetImportedGeometryRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetImportedGeometryRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'kml.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uploadJobId')
    ..aOS(2, _omitFieldNames ? '' : 'geometryId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetImportedGeometryRequest clone() => GetImportedGeometryRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetImportedGeometryRequest copyWith(void Function(GetImportedGeometryRequest) updates) => super.copyWith((message) => updates(message as GetImportedGeometryRequest)) as GetImportedGeometryRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetImportedGeometryRequest create() => GetImportedGeometryRequest._();
  GetImportedGeometryRequest createEmptyInstance() => create();
  static $pb.PbList<GetImportedGeometryRequest> createRepeated() => $pb.PbList<GetImportedGeometryRequest>();
  @$core.pragma('dart2js:noInline')
  static GetImportedGeometryRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetImportedGeometryRequest>(create);
  static GetImportedGeometryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uploadJobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set uploadJobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUploadJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUploadJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get geometryId => $_getSZ(1);
  @$pb.TagNumber(2)
  set geometryId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasGeometryId() => $_has(1);
  @$pb.TagNumber(2)
  void clearGeometryId() => $_clearField(2);
}

enum GetImportedGeometryResponse_CanonicalGeometry {
  point, 
  linestring, 
  polygon, 
  multipolygon, 
  notSet
}

/// Full details of imported geometry.
class GetImportedGeometryResponse extends $pb.GeneratedMessage {
  factory GetImportedGeometryResponse({
    $core.String? geometryId,
    $core.String? name,
    $core.String? description,
    $pb.PbMap<$core.String, $core.String>? properties,
    GeometryType? type,
    $1.Point2D? point,
    $1.LineString2D? linestring,
    $1.Polygon2D? polygon,
    $1.MultiPolygon2D? multipolygon,
    CRSCode? sourceCrs,
    $1.BoundingBox2D? boundingBox,
    $core.String? geometryHash,
    $0.Timestamp? importedAt,
  }) {
    final $result = create();
    if (geometryId != null) {
      $result.geometryId = geometryId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (description != null) {
      $result.description = description;
    }
    if (properties != null) {
      $result.properties.addAll(properties);
    }
    if (type != null) {
      $result.type = type;
    }
    if (point != null) {
      $result.point = point;
    }
    if (linestring != null) {
      $result.linestring = linestring;
    }
    if (polygon != null) {
      $result.polygon = polygon;
    }
    if (multipolygon != null) {
      $result.multipolygon = multipolygon;
    }
    if (sourceCrs != null) {
      $result.sourceCrs = sourceCrs;
    }
    if (boundingBox != null) {
      $result.boundingBox = boundingBox;
    }
    if (geometryHash != null) {
      $result.geometryHash = geometryHash;
    }
    if (importedAt != null) {
      $result.importedAt = importedAt;
    }
    return $result;
  }
  GetImportedGeometryResponse._() : super();
  factory GetImportedGeometryResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetImportedGeometryResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, GetImportedGeometryResponse_CanonicalGeometry> _GetImportedGeometryResponse_CanonicalGeometryByTag = {
    6 : GetImportedGeometryResponse_CanonicalGeometry.point,
    7 : GetImportedGeometryResponse_CanonicalGeometry.linestring,
    8 : GetImportedGeometryResponse_CanonicalGeometry.polygon,
    9 : GetImportedGeometryResponse_CanonicalGeometry.multipolygon,
    0 : GetImportedGeometryResponse_CanonicalGeometry.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetImportedGeometryResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'kml.v1'), createEmptyInstance: create)
    ..oo(0, [6, 7, 8, 9])
    ..aOS(1, _omitFieldNames ? '' : 'geometryId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..m<$core.String, $core.String>(4, _omitFieldNames ? '' : 'properties', entryClassName: 'GetImportedGeometryResponse.PropertiesEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('kml.v1'))
    ..e<GeometryType>(5, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: GeometryType.TYPE_UNKNOWN, valueOf: GeometryType.valueOf, enumValues: GeometryType.values)
    ..aOM<$1.Point2D>(6, _omitFieldNames ? '' : 'point', subBuilder: $1.Point2D.create)
    ..aOM<$1.LineString2D>(7, _omitFieldNames ? '' : 'linestring', subBuilder: $1.LineString2D.create)
    ..aOM<$1.Polygon2D>(8, _omitFieldNames ? '' : 'polygon', subBuilder: $1.Polygon2D.create)
    ..aOM<$1.MultiPolygon2D>(9, _omitFieldNames ? '' : 'multipolygon', subBuilder: $1.MultiPolygon2D.create)
    ..e<CRSCode>(10, _omitFieldNames ? '' : 'sourceCrs', $pb.PbFieldType.OE, defaultOrMaker: CRSCode.CRS_UNKNOWN, valueOf: CRSCode.valueOf, enumValues: CRSCode.values)
    ..aOM<$1.BoundingBox2D>(11, _omitFieldNames ? '' : 'boundingBox', subBuilder: $1.BoundingBox2D.create)
    ..aOS(12, _omitFieldNames ? '' : 'geometryHash')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'importedAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetImportedGeometryResponse clone() => GetImportedGeometryResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetImportedGeometryResponse copyWith(void Function(GetImportedGeometryResponse) updates) => super.copyWith((message) => updates(message as GetImportedGeometryResponse)) as GetImportedGeometryResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetImportedGeometryResponse create() => GetImportedGeometryResponse._();
  GetImportedGeometryResponse createEmptyInstance() => create();
  static $pb.PbList<GetImportedGeometryResponse> createRepeated() => $pb.PbList<GetImportedGeometryResponse>();
  @$core.pragma('dart2js:noInline')
  static GetImportedGeometryResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetImportedGeometryResponse>(create);
  static GetImportedGeometryResponse? _defaultInstance;

  GetImportedGeometryResponse_CanonicalGeometry whichCanonicalGeometry() => _GetImportedGeometryResponse_CanonicalGeometryByTag[$_whichOneof(0)]!;
  void clearCanonicalGeometry() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get geometryId => $_getSZ(0);
  @$pb.TagNumber(1)
  set geometryId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasGeometryId() => $_has(0);
  @$pb.TagNumber(1)
  void clearGeometryId() => $_clearField(1);

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

  /// Original KML properties (key-value pairs).
  @$pb.TagNumber(4)
  $pb.PbMap<$core.String, $core.String> get properties => $_getMap(3);

  /// Geometry type.
  @$pb.TagNumber(5)
  GeometryType get type => $_getN(4);
  @$pb.TagNumber(5)
  set type(GeometryType v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => $_clearField(5);

  @$pb.TagNumber(6)
  $1.Point2D get point => $_getN(5);
  @$pb.TagNumber(6)
  set point($1.Point2D v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasPoint() => $_has(5);
  @$pb.TagNumber(6)
  void clearPoint() => $_clearField(6);
  @$pb.TagNumber(6)
  $1.Point2D ensurePoint() => $_ensure(5);

  @$pb.TagNumber(7)
  $1.LineString2D get linestring => $_getN(6);
  @$pb.TagNumber(7)
  set linestring($1.LineString2D v) { $_setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasLinestring() => $_has(6);
  @$pb.TagNumber(7)
  void clearLinestring() => $_clearField(7);
  @$pb.TagNumber(7)
  $1.LineString2D ensureLinestring() => $_ensure(6);

  @$pb.TagNumber(8)
  $1.Polygon2D get polygon => $_getN(7);
  @$pb.TagNumber(8)
  set polygon($1.Polygon2D v) { $_setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasPolygon() => $_has(7);
  @$pb.TagNumber(8)
  void clearPolygon() => $_clearField(8);
  @$pb.TagNumber(8)
  $1.Polygon2D ensurePolygon() => $_ensure(7);

  @$pb.TagNumber(9)
  $1.MultiPolygon2D get multipolygon => $_getN(8);
  @$pb.TagNumber(9)
  set multipolygon($1.MultiPolygon2D v) { $_setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasMultipolygon() => $_has(8);
  @$pb.TagNumber(9)
  void clearMultipolygon() => $_clearField(9);
  @$pb.TagNumber(9)
  $1.MultiPolygon2D ensureMultipolygon() => $_ensure(8);

  /// Source CRS of original geometry.
  @$pb.TagNumber(10)
  CRSCode get sourceCrs => $_getN(9);
  @$pb.TagNumber(10)
  set sourceCrs(CRSCode v) { $_setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasSourceCrs() => $_has(9);
  @$pb.TagNumber(10)
  void clearSourceCrs() => $_clearField(10);

  /// Canonical bounding box.
  @$pb.TagNumber(11)
  $1.BoundingBox2D get boundingBox => $_getN(10);
  @$pb.TagNumber(11)
  set boundingBox($1.BoundingBox2D v) { $_setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasBoundingBox() => $_has(10);
  @$pb.TagNumber(11)
  void clearBoundingBox() => $_clearField(11);
  @$pb.TagNumber(11)
  $1.BoundingBox2D ensureBoundingBox() => $_ensure(10);

  /// Checksum of geometry for validation.
  @$pb.TagNumber(12)
  $core.String get geometryHash => $_getSZ(11);
  @$pb.TagNumber(12)
  set geometryHash($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasGeometryHash() => $_has(11);
  @$pb.TagNumber(12)
  void clearGeometryHash() => $_clearField(12);

  /// Timestamp when geometry was imported.
  @$pb.TagNumber(13)
  $0.Timestamp get importedAt => $_getN(12);
  @$pb.TagNumber(13)
  set importedAt($0.Timestamp v) { $_setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasImportedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearImportedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureImportedAt() => $_ensure(12);
}

/// Request to delete upload job and all associated geometries.
class DeleteUploadRequest extends $pb.GeneratedMessage {
  factory DeleteUploadRequest({
    $core.String? uploadJobId,
  }) {
    final $result = create();
    if (uploadJobId != null) {
      $result.uploadJobId = uploadJobId;
    }
    return $result;
  }
  DeleteUploadRequest._() : super();
  factory DeleteUploadRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteUploadRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteUploadRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'kml.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uploadJobId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteUploadRequest clone() => DeleteUploadRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteUploadRequest copyWith(void Function(DeleteUploadRequest) updates) => super.copyWith((message) => updates(message as DeleteUploadRequest)) as DeleteUploadRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteUploadRequest create() => DeleteUploadRequest._();
  DeleteUploadRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteUploadRequest> createRepeated() => $pb.PbList<DeleteUploadRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteUploadRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteUploadRequest>(create);
  static DeleteUploadRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uploadJobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set uploadJobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUploadJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUploadJobId() => $_clearField(1);
}

/// Response confirming deletion.
class DeleteUploadResponse extends $pb.GeneratedMessage {
  factory DeleteUploadResponse({
    $core.String? uploadJobId,
    $core.bool? deleted,
    $core.int? geometriesDeleted,
  }) {
    final $result = create();
    if (uploadJobId != null) {
      $result.uploadJobId = uploadJobId;
    }
    if (deleted != null) {
      $result.deleted = deleted;
    }
    if (geometriesDeleted != null) {
      $result.geometriesDeleted = geometriesDeleted;
    }
    return $result;
  }
  DeleteUploadResponse._() : super();
  factory DeleteUploadResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteUploadResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeleteUploadResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'kml.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'uploadJobId')
    ..aOB(2, _omitFieldNames ? '' : 'deleted')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'geometriesDeleted', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteUploadResponse clone() => DeleteUploadResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteUploadResponse copyWith(void Function(DeleteUploadResponse) updates) => super.copyWith((message) => updates(message as DeleteUploadResponse)) as DeleteUploadResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteUploadResponse create() => DeleteUploadResponse._();
  DeleteUploadResponse createEmptyInstance() => create();
  static $pb.PbList<DeleteUploadResponse> createRepeated() => $pb.PbList<DeleteUploadResponse>();
  @$core.pragma('dart2js:noInline')
  static DeleteUploadResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteUploadResponse>(create);
  static DeleteUploadResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get uploadJobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set uploadJobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUploadJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUploadJobId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get deleted => $_getBF(1);
  @$pb.TagNumber(2)
  set deleted($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeleted() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeleted() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get geometriesDeleted => $_getIZ(2);
  @$pb.TagNumber(3)
  set geometriesDeleted($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasGeometriesDeleted() => $_has(2);
  @$pb.TagNumber(3)
  void clearGeometriesDeleted() => $_clearField(3);
}

/// KMLIngestionService exposes KML/KMZ upload, parsing, and geometry import workflows.
class KMLIngestionServiceApi {
  $pb.RpcClient _client;
  KMLIngestionServiceApi(this._client);

  /// UploadKML initiates async KML/KMZ file processing.
  $async.Future<UploadKMLResponse> uploadKML($pb.ClientContext? ctx, UploadKMLRequest request) =>
    _client.invoke<UploadKMLResponse>(ctx, 'KMLIngestionService', 'UploadKML', request, UploadKMLResponse())
  ;
  /// GetUploadStatus retrieves the status of a KML upload job.
  $async.Future<GetUploadStatusResponse> getUploadStatus($pb.ClientContext? ctx, GetUploadStatusRequest request) =>
    _client.invoke<GetUploadStatusResponse>(ctx, 'KMLIngestionService', 'GetUploadStatus', request, GetUploadStatusResponse())
  ;
  /// ListImportedGeometries retrieves geometries from a completed upload.
  $async.Future<ListImportedGeometriesResponse> listImportedGeometries($pb.ClientContext? ctx, ListImportedGeometriesRequest request) =>
    _client.invoke<ListImportedGeometriesResponse>(ctx, 'KMLIngestionService', 'ListImportedGeometries', request, ListImportedGeometriesResponse())
  ;
  /// GetImportedGeometry retrieves a single imported geometry with full details.
  $async.Future<GetImportedGeometryResponse> getImportedGeometry($pb.ClientContext? ctx, GetImportedGeometryRequest request) =>
    _client.invoke<GetImportedGeometryResponse>(ctx, 'KMLIngestionService', 'GetImportedGeometry', request, GetImportedGeometryResponse())
  ;
  /// DeleteUpload removes an upload job and associated geometries.
  $async.Future<DeleteUploadResponse> deleteUpload($pb.ClientContext? ctx, DeleteUploadRequest request) =>
    _client.invoke<DeleteUploadResponse>(ctx, 'KMLIngestionService', 'DeleteUpload', request, DeleteUploadResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
