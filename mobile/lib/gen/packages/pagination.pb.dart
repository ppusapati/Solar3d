//
//  Generated code. Do not modify.
//  source: packages/pagination.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../google/protobuf/field_mask.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Pagination extends $pb.GeneratedMessage {
  factory Pagination({
    $core.int? pageOffset,
    $core.int? pageSize,
    $core.Iterable<$core.String>? sort,
    $0.FieldMask? fields,
  }) {
    final $result = create();
    if (pageOffset != null) {
      $result.pageOffset = pageOffset;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    if (sort != null) {
      $result.sort.addAll(sort);
    }
    if (fields != null) {
      $result.fields = fields;
    }
    return $result;
  }
  Pagination._() : super();
  factory Pagination.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Pagination.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Pagination', package: const $pb.PackageName(_omitMessageNames ? '' : 'packages.api.v1.pagination'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'pageOffset', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..pPS(3, _omitFieldNames ? '' : 'sort')
    ..aOM<$0.FieldMask>(4, _omitFieldNames ? '' : 'fields', subBuilder: $0.FieldMask.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Pagination clone() => Pagination()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Pagination copyWith(void Function(Pagination) updates) => super.copyWith((message) => updates(message as Pagination)) as Pagination;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Pagination create() => Pagination._();
  Pagination createEmptyInstance() => create();
  static $pb.PbList<Pagination> createRepeated() => $pb.PbList<Pagination>();
  @$core.pragma('dart2js:noInline')
  static Pagination getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Pagination>(create);
  static Pagination? _defaultInstance;

  /// Number of items to skip for pagination
  @$pb.TagNumber(1)
  $core.int get pageOffset => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageOffset($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPageOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageOffset() => $_clearField(1);

  /// Maximum number of items to return in response
  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  /// Fields to sort by, default is id
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get sort => $_getList(2);

  /// Specific fields to include in the response
  @$pb.TagNumber(4)
  $0.FieldMask get fields => $_getN(3);
  @$pb.TagNumber(4)
  set fields($0.FieldMask v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFields() => $_has(3);
  @$pb.TagNumber(4)
  void clearFields() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.FieldMask ensureFields() => $_ensure(3);
}

/// Alias for extension/land modules that reference PaginationRequest
class PaginationRequest extends $pb.GeneratedMessage {
  factory PaginationRequest({
    $core.int? pageOffset,
    $core.int? pageSize,
    $core.Iterable<$core.String>? sort,
    $0.FieldMask? fields,
  }) {
    final $result = create();
    if (pageOffset != null) {
      $result.pageOffset = pageOffset;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    if (sort != null) {
      $result.sort.addAll(sort);
    }
    if (fields != null) {
      $result.fields = fields;
    }
    return $result;
  }
  PaginationRequest._() : super();
  factory PaginationRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PaginationRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PaginationRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'packages.api.v1.pagination'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'pageOffset', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..pPS(3, _omitFieldNames ? '' : 'sort')
    ..aOM<$0.FieldMask>(4, _omitFieldNames ? '' : 'fields', subBuilder: $0.FieldMask.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PaginationRequest clone() => PaginationRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PaginationRequest copyWith(void Function(PaginationRequest) updates) => super.copyWith((message) => updates(message as PaginationRequest)) as PaginationRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PaginationRequest create() => PaginationRequest._();
  PaginationRequest createEmptyInstance() => create();
  static $pb.PbList<PaginationRequest> createRepeated() => $pb.PbList<PaginationRequest>();
  @$core.pragma('dart2js:noInline')
  static PaginationRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaginationRequest>(create);
  static PaginationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get pageOffset => $_getIZ(0);
  @$pb.TagNumber(1)
  set pageOffset($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPageOffset() => $_has(0);
  @$pb.TagNumber(1)
  void clearPageOffset() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageSize => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageSize($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPageSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get sort => $_getList(2);

  @$pb.TagNumber(4)
  $0.FieldMask get fields => $_getN(3);
  @$pb.TagNumber(4)
  set fields($0.FieldMask v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasFields() => $_has(3);
  @$pb.TagNumber(4)
  void clearFields() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.FieldMask ensureFields() => $_ensure(3);
}

/// Paginated list response wrapper
class PaginationResponse extends $pb.GeneratedMessage {
  factory PaginationResponse({
    $core.int? totalCount,
    $core.int? pageOffset,
    $core.int? pageSize,
    $core.bool? hasNext,
  }) {
    final $result = create();
    if (totalCount != null) {
      $result.totalCount = totalCount;
    }
    if (pageOffset != null) {
      $result.pageOffset = pageOffset;
    }
    if (pageSize != null) {
      $result.pageSize = pageSize;
    }
    if (hasNext != null) {
      $result.hasNext = hasNext;
    }
    return $result;
  }
  PaginationResponse._() : super();
  factory PaginationResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PaginationResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PaginationResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'packages.api.v1.pagination'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'totalCount', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'pageOffset', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'pageSize', $pb.PbFieldType.O3)
    ..aOB(4, _omitFieldNames ? '' : 'hasNext')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PaginationResponse clone() => PaginationResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PaginationResponse copyWith(void Function(PaginationResponse) updates) => super.copyWith((message) => updates(message as PaginationResponse)) as PaginationResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PaginationResponse create() => PaginationResponse._();
  PaginationResponse createEmptyInstance() => create();
  static $pb.PbList<PaginationResponse> createRepeated() => $pb.PbList<PaginationResponse>();
  @$core.pragma('dart2js:noInline')
  static PaginationResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PaginationResponse>(create);
  static PaginationResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get totalCount => $_getIZ(0);
  @$pb.TagNumber(1)
  set totalCount($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotalCount() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotalCount() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get pageOffset => $_getIZ(1);
  @$pb.TagNumber(2)
  set pageOffset($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPageOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearPageOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get pageSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set pageSize($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPageSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearPageSize() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.bool get hasNext => $_getBF(3);
  @$pb.TagNumber(4)
  set hasNext($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHasNext() => $_has(3);
  @$pb.TagNumber(4)
  void clearHasNext() => $_clearField(4);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
