//
//  Generated code. Do not modify.
//  source: orchestration/v1/orchestration.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $0;
import 'orchestration.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'orchestration.pbenum.dart';

class Artifact extends $pb.GeneratedMessage {
  factory Artifact({
    $core.String? kind,
    $core.String? uri,
    $core.String? checksum,
    $fixnum.Int64? sizeBytes,
  }) {
    final $result = create();
    if (kind != null) {
      $result.kind = kind;
    }
    if (uri != null) {
      $result.uri = uri;
    }
    if (checksum != null) {
      $result.checksum = checksum;
    }
    if (sizeBytes != null) {
      $result.sizeBytes = sizeBytes;
    }
    return $result;
  }
  Artifact._() : super();
  factory Artifact.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Artifact.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Artifact', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'kind')
    ..aOS(2, _omitFieldNames ? '' : 'uri')
    ..aOS(3, _omitFieldNames ? '' : 'checksum')
    ..aInt64(4, _omitFieldNames ? '' : 'sizeBytes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Artifact clone() => Artifact()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Artifact copyWith(void Function(Artifact) updates) => super.copyWith((message) => updates(message as Artifact)) as Artifact;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Artifact create() => Artifact._();
  Artifact createEmptyInstance() => create();
  static $pb.PbList<Artifact> createRepeated() => $pb.PbList<Artifact>();
  @$core.pragma('dart2js:noInline')
  static Artifact getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Artifact>(create);
  static Artifact? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get kind => $_getSZ(0);
  @$pb.TagNumber(1)
  set kind($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get uri => $_getSZ(1);
  @$pb.TagNumber(2)
  set uri($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUri() => $_has(1);
  @$pb.TagNumber(2)
  void clearUri() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get checksum => $_getSZ(2);
  @$pb.TagNumber(3)
  set checksum($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChecksum() => $_has(2);
  @$pb.TagNumber(3)
  void clearChecksum() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get sizeBytes => $_getI64(3);
  @$pb.TagNumber(4)
  set sizeBytes($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSizeBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearSizeBytes() => $_clearField(4);
}

class Job extends $pb.GeneratedMessage {
  factory Job({
    $core.String? id,
    $core.String? projectId,
    JobType? type,
    JobStatus? status,
    $core.int? priority,
    $core.int? attempts,
    $core.int? maxAttempts,
    $core.String? payloadJson,
    $core.String? errorMessage,
    $core.Iterable<Artifact>? artifacts,
    $0.Timestamp? createdAt,
    $0.Timestamp? startedAt,
    $0.Timestamp? completedAt,
    $0.Timestamp? nextRetryAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (type != null) {
      $result.type = type;
    }
    if (status != null) {
      $result.status = status;
    }
    if (priority != null) {
      $result.priority = priority;
    }
    if (attempts != null) {
      $result.attempts = attempts;
    }
    if (maxAttempts != null) {
      $result.maxAttempts = maxAttempts;
    }
    if (payloadJson != null) {
      $result.payloadJson = payloadJson;
    }
    if (errorMessage != null) {
      $result.errorMessage = errorMessage;
    }
    if (artifacts != null) {
      $result.artifacts.addAll(artifacts);
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    if (startedAt != null) {
      $result.startedAt = startedAt;
    }
    if (completedAt != null) {
      $result.completedAt = completedAt;
    }
    if (nextRetryAt != null) {
      $result.nextRetryAt = nextRetryAt;
    }
    return $result;
  }
  Job._() : super();
  factory Job.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Job.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Job', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'projectId')
    ..e<JobType>(3, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: JobType.JOB_TYPE_UNSPECIFIED, valueOf: JobType.valueOf, enumValues: JobType.values)
    ..e<JobStatus>(4, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: JobStatus.JOB_STATUS_UNSPECIFIED, valueOf: JobStatus.valueOf, enumValues: JobStatus.values)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'priority', $pb.PbFieldType.O3)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'attempts', $pb.PbFieldType.O3)
    ..a<$core.int>(7, _omitFieldNames ? '' : 'maxAttempts', $pb.PbFieldType.O3)
    ..aOS(8, _omitFieldNames ? '' : 'payloadJson')
    ..aOS(9, _omitFieldNames ? '' : 'errorMessage')
    ..pc<Artifact>(10, _omitFieldNames ? '' : 'artifacts', $pb.PbFieldType.PM, subBuilder: Artifact.create)
    ..aOM<$0.Timestamp>(11, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'startedAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'completedAt', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(14, _omitFieldNames ? '' : 'nextRetryAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Job clone() => Job()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Job copyWith(void Function(Job) updates) => super.copyWith((message) => updates(message as Job)) as Job;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Job create() => Job._();
  Job createEmptyInstance() => create();
  static $pb.PbList<Job> createRepeated() => $pb.PbList<Job>();
  @$core.pragma('dart2js:noInline')
  static Job getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Job>(create);
  static Job? _defaultInstance;

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
  JobType get type => $_getN(2);
  @$pb.TagNumber(3)
  set type(JobType v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasType() => $_has(2);
  @$pb.TagNumber(3)
  void clearType() => $_clearField(3);

  @$pb.TagNumber(4)
  JobStatus get status => $_getN(3);
  @$pb.TagNumber(4)
  set status(JobStatus v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get priority => $_getIZ(4);
  @$pb.TagNumber(5)
  set priority($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPriority() => $_has(4);
  @$pb.TagNumber(5)
  void clearPriority() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get attempts => $_getIZ(5);
  @$pb.TagNumber(6)
  set attempts($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAttempts() => $_has(5);
  @$pb.TagNumber(6)
  void clearAttempts() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get maxAttempts => $_getIZ(6);
  @$pb.TagNumber(7)
  set maxAttempts($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMaxAttempts() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxAttempts() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get payloadJson => $_getSZ(7);
  @$pb.TagNumber(8)
  set payloadJson($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasPayloadJson() => $_has(7);
  @$pb.TagNumber(8)
  void clearPayloadJson() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get errorMessage => $_getSZ(8);
  @$pb.TagNumber(9)
  set errorMessage($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasErrorMessage() => $_has(8);
  @$pb.TagNumber(9)
  void clearErrorMessage() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<Artifact> get artifacts => $_getList(9);

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

  @$pb.TagNumber(12)
  $0.Timestamp get startedAt => $_getN(11);
  @$pb.TagNumber(12)
  set startedAt($0.Timestamp v) { $_setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasStartedAt() => $_has(11);
  @$pb.TagNumber(12)
  void clearStartedAt() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureStartedAt() => $_ensure(11);

  @$pb.TagNumber(13)
  $0.Timestamp get completedAt => $_getN(12);
  @$pb.TagNumber(13)
  set completedAt($0.Timestamp v) { $_setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasCompletedAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearCompletedAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureCompletedAt() => $_ensure(12);

  @$pb.TagNumber(14)
  $0.Timestamp get nextRetryAt => $_getN(13);
  @$pb.TagNumber(14)
  set nextRetryAt($0.Timestamp v) { $_setField(14, v); }
  @$pb.TagNumber(14)
  $core.bool hasNextRetryAt() => $_has(13);
  @$pb.TagNumber(14)
  void clearNextRetryAt() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.Timestamp ensureNextRetryAt() => $_ensure(13);
}

class SubmitJobRequest extends $pb.GeneratedMessage {
  factory SubmitJobRequest({
    $core.String? projectId,
    JobType? type,
    $core.int? priority,
    $core.int? maxAttempts,
    $core.String? payloadJson,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (type != null) {
      $result.type = type;
    }
    if (priority != null) {
      $result.priority = priority;
    }
    if (maxAttempts != null) {
      $result.maxAttempts = maxAttempts;
    }
    if (payloadJson != null) {
      $result.payloadJson = payloadJson;
    }
    return $result;
  }
  SubmitJobRequest._() : super();
  factory SubmitJobRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitJobRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitJobRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<JobType>(2, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: JobType.JOB_TYPE_UNSPECIFIED, valueOf: JobType.valueOf, enumValues: JobType.values)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'priority', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'maxAttempts', $pb.PbFieldType.O3)
    ..aOS(5, _omitFieldNames ? '' : 'payloadJson')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitJobRequest clone() => SubmitJobRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitJobRequest copyWith(void Function(SubmitJobRequest) updates) => super.copyWith((message) => updates(message as SubmitJobRequest)) as SubmitJobRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitJobRequest create() => SubmitJobRequest._();
  SubmitJobRequest createEmptyInstance() => create();
  static $pb.PbList<SubmitJobRequest> createRepeated() => $pb.PbList<SubmitJobRequest>();
  @$core.pragma('dart2js:noInline')
  static SubmitJobRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitJobRequest>(create);
  static SubmitJobRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  JobType get type => $_getN(1);
  @$pb.TagNumber(2)
  set type(JobType v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasType() => $_has(1);
  @$pb.TagNumber(2)
  void clearType() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get priority => $_getIZ(2);
  @$pb.TagNumber(3)
  set priority($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPriority() => $_has(2);
  @$pb.TagNumber(3)
  void clearPriority() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get maxAttempts => $_getIZ(3);
  @$pb.TagNumber(4)
  set maxAttempts($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMaxAttempts() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxAttempts() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get payloadJson => $_getSZ(4);
  @$pb.TagNumber(5)
  set payloadJson($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasPayloadJson() => $_has(4);
  @$pb.TagNumber(5)
  void clearPayloadJson() => $_clearField(5);
}

class SubmitJobResponse extends $pb.GeneratedMessage {
  factory SubmitJobResponse({
    Job? job,
  }) {
    final $result = create();
    if (job != null) {
      $result.job = job;
    }
    return $result;
  }
  SubmitJobResponse._() : super();
  factory SubmitJobResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SubmitJobResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SubmitJobResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOM<Job>(1, _omitFieldNames ? '' : 'job', subBuilder: Job.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SubmitJobResponse clone() => SubmitJobResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SubmitJobResponse copyWith(void Function(SubmitJobResponse) updates) => super.copyWith((message) => updates(message as SubmitJobResponse)) as SubmitJobResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SubmitJobResponse create() => SubmitJobResponse._();
  SubmitJobResponse createEmptyInstance() => create();
  static $pb.PbList<SubmitJobResponse> createRepeated() => $pb.PbList<SubmitJobResponse>();
  @$core.pragma('dart2js:noInline')
  static SubmitJobResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SubmitJobResponse>(create);
  static SubmitJobResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Job get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(Job v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  Job ensureJob() => $_ensure(0);
}

class GetJobRequest extends $pb.GeneratedMessage {
  factory GetJobRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  GetJobRequest._() : super();
  factory GetJobRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetJobRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetJobRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetJobRequest clone() => GetJobRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetJobRequest copyWith(void Function(GetJobRequest) updates) => super.copyWith((message) => updates(message as GetJobRequest)) as GetJobRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetJobRequest create() => GetJobRequest._();
  GetJobRequest createEmptyInstance() => create();
  static $pb.PbList<GetJobRequest> createRepeated() => $pb.PbList<GetJobRequest>();
  @$core.pragma('dart2js:noInline')
  static GetJobRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetJobRequest>(create);
  static GetJobRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class GetJobResponse extends $pb.GeneratedMessage {
  factory GetJobResponse({
    Job? job,
  }) {
    final $result = create();
    if (job != null) {
      $result.job = job;
    }
    return $result;
  }
  GetJobResponse._() : super();
  factory GetJobResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetJobResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetJobResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOM<Job>(1, _omitFieldNames ? '' : 'job', subBuilder: Job.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetJobResponse clone() => GetJobResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetJobResponse copyWith(void Function(GetJobResponse) updates) => super.copyWith((message) => updates(message as GetJobResponse)) as GetJobResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetJobResponse create() => GetJobResponse._();
  GetJobResponse createEmptyInstance() => create();
  static $pb.PbList<GetJobResponse> createRepeated() => $pb.PbList<GetJobResponse>();
  @$core.pragma('dart2js:noInline')
  static GetJobResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetJobResponse>(create);
  static GetJobResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Job get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(Job v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  Job ensureJob() => $_ensure(0);
}

class ListJobsRequest extends $pb.GeneratedMessage {
  factory ListJobsRequest({
    $core.String? projectId,
    JobStatus? statusFilter,
    $core.int? limit,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (statusFilter != null) {
      $result.statusFilter = statusFilter;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    return $result;
  }
  ListJobsRequest._() : super();
  factory ListJobsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListJobsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListJobsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..e<JobStatus>(2, _omitFieldNames ? '' : 'statusFilter', $pb.PbFieldType.OE, defaultOrMaker: JobStatus.JOB_STATUS_UNSPECIFIED, valueOf: JobStatus.valueOf, enumValues: JobStatus.values)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListJobsRequest clone() => ListJobsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListJobsRequest copyWith(void Function(ListJobsRequest) updates) => super.copyWith((message) => updates(message as ListJobsRequest)) as ListJobsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListJobsRequest create() => ListJobsRequest._();
  ListJobsRequest createEmptyInstance() => create();
  static $pb.PbList<ListJobsRequest> createRepeated() => $pb.PbList<ListJobsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListJobsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListJobsRequest>(create);
  static ListJobsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  JobStatus get statusFilter => $_getN(1);
  @$pb.TagNumber(2)
  set statusFilter(JobStatus v) { $_setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStatusFilter() => $_has(1);
  @$pb.TagNumber(2)
  void clearStatusFilter() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => $_clearField(3);
}

class ListJobsResponse extends $pb.GeneratedMessage {
  factory ListJobsResponse({
    $core.Iterable<Job>? jobs,
  }) {
    final $result = create();
    if (jobs != null) {
      $result.jobs.addAll(jobs);
    }
    return $result;
  }
  ListJobsResponse._() : super();
  factory ListJobsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListJobsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListJobsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..pc<Job>(1, _omitFieldNames ? '' : 'jobs', $pb.PbFieldType.PM, subBuilder: Job.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListJobsResponse clone() => ListJobsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListJobsResponse copyWith(void Function(ListJobsResponse) updates) => super.copyWith((message) => updates(message as ListJobsResponse)) as ListJobsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListJobsResponse create() => ListJobsResponse._();
  ListJobsResponse createEmptyInstance() => create();
  static $pb.PbList<ListJobsResponse> createRepeated() => $pb.PbList<ListJobsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListJobsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListJobsResponse>(create);
  static ListJobsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Job> get jobs => $_getList(0);
}

class RetryJobRequest extends $pb.GeneratedMessage {
  factory RetryJobRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  RetryJobRequest._() : super();
  factory RetryJobRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RetryJobRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RetryJobRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RetryJobRequest clone() => RetryJobRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RetryJobRequest copyWith(void Function(RetryJobRequest) updates) => super.copyWith((message) => updates(message as RetryJobRequest)) as RetryJobRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetryJobRequest create() => RetryJobRequest._();
  RetryJobRequest createEmptyInstance() => create();
  static $pb.PbList<RetryJobRequest> createRepeated() => $pb.PbList<RetryJobRequest>();
  @$core.pragma('dart2js:noInline')
  static RetryJobRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RetryJobRequest>(create);
  static RetryJobRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class RetryJobResponse extends $pb.GeneratedMessage {
  factory RetryJobResponse({
    Job? job,
  }) {
    final $result = create();
    if (job != null) {
      $result.job = job;
    }
    return $result;
  }
  RetryJobResponse._() : super();
  factory RetryJobResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RetryJobResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RetryJobResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOM<Job>(1, _omitFieldNames ? '' : 'job', subBuilder: Job.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RetryJobResponse clone() => RetryJobResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RetryJobResponse copyWith(void Function(RetryJobResponse) updates) => super.copyWith((message) => updates(message as RetryJobResponse)) as RetryJobResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RetryJobResponse create() => RetryJobResponse._();
  RetryJobResponse createEmptyInstance() => create();
  static $pb.PbList<RetryJobResponse> createRepeated() => $pb.PbList<RetryJobResponse>();
  @$core.pragma('dart2js:noInline')
  static RetryJobResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RetryJobResponse>(create);
  static RetryJobResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Job get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(Job v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  Job ensureJob() => $_ensure(0);
}

class CancelJobRequest extends $pb.GeneratedMessage {
  factory CancelJobRequest({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  CancelJobRequest._() : super();
  factory CancelJobRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CancelJobRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CancelJobRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CancelJobRequest clone() => CancelJobRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CancelJobRequest copyWith(void Function(CancelJobRequest) updates) => super.copyWith((message) => updates(message as CancelJobRequest)) as CancelJobRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelJobRequest create() => CancelJobRequest._();
  CancelJobRequest createEmptyInstance() => create();
  static $pb.PbList<CancelJobRequest> createRepeated() => $pb.PbList<CancelJobRequest>();
  @$core.pragma('dart2js:noInline')
  static CancelJobRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelJobRequest>(create);
  static CancelJobRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class CancelJobResponse extends $pb.GeneratedMessage {
  factory CancelJobResponse({
    Job? job,
  }) {
    final $result = create();
    if (job != null) {
      $result.job = job;
    }
    return $result;
  }
  CancelJobResponse._() : super();
  factory CancelJobResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CancelJobResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CancelJobResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOM<Job>(1, _omitFieldNames ? '' : 'job', subBuilder: Job.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CancelJobResponse clone() => CancelJobResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CancelJobResponse copyWith(void Function(CancelJobResponse) updates) => super.copyWith((message) => updates(message as CancelJobResponse)) as CancelJobResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelJobResponse create() => CancelJobResponse._();
  CancelJobResponse createEmptyInstance() => create();
  static $pb.PbList<CancelJobResponse> createRepeated() => $pb.PbList<CancelJobResponse>();
  @$core.pragma('dart2js:noInline')
  static CancelJobResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CancelJobResponse>(create);
  static CancelJobResponse? _defaultInstance;

  @$pb.TagNumber(1)
  Job get job => $_getN(0);
  @$pb.TagNumber(1)
  set job(Job v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasJob() => $_has(0);
  @$pb.TagNumber(1)
  void clearJob() => $_clearField(1);
  @$pb.TagNumber(1)
  Job ensureJob() => $_ensure(0);
}

class DeadLetter extends $pb.GeneratedMessage {
  factory DeadLetter({
    $core.String? id,
    $core.String? jobId,
    $core.String? reason,
    $core.String? payloadJson,
    $0.Timestamp? createdAt,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (jobId != null) {
      $result.jobId = jobId;
    }
    if (reason != null) {
      $result.reason = reason;
    }
    if (payloadJson != null) {
      $result.payloadJson = payloadJson;
    }
    if (createdAt != null) {
      $result.createdAt = createdAt;
    }
    return $result;
  }
  DeadLetter._() : super();
  factory DeadLetter.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeadLetter.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DeadLetter', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'jobId')
    ..aOS(3, _omitFieldNames ? '' : 'reason')
    ..aOS(4, _omitFieldNames ? '' : 'payloadJson')
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'createdAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeadLetter clone() => DeadLetter()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeadLetter copyWith(void Function(DeadLetter) updates) => super.copyWith((message) => updates(message as DeadLetter)) as DeadLetter;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeadLetter create() => DeadLetter._();
  DeadLetter createEmptyInstance() => create();
  static $pb.PbList<DeadLetter> createRepeated() => $pb.PbList<DeadLetter>();
  @$core.pragma('dart2js:noInline')
  static DeadLetter getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeadLetter>(create);
  static DeadLetter? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jobId => $_getSZ(1);
  @$pb.TagNumber(2)
  set jobId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get reason => $_getSZ(2);
  @$pb.TagNumber(3)
  set reason($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReason() => $_has(2);
  @$pb.TagNumber(3)
  void clearReason() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get payloadJson => $_getSZ(3);
  @$pb.TagNumber(4)
  set payloadJson($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPayloadJson() => $_has(3);
  @$pb.TagNumber(4)
  void clearPayloadJson() => $_clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get createdAt => $_getN(4);
  @$pb.TagNumber(5)
  set createdAt($0.Timestamp v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureCreatedAt() => $_ensure(4);
}

class ListDeadLettersRequest extends $pb.GeneratedMessage {
  factory ListDeadLettersRequest({
    $core.String? projectId,
    $core.int? limit,
  }) {
    final $result = create();
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (limit != null) {
      $result.limit = limit;
    }
    return $result;
  }
  ListDeadLettersRequest._() : super();
  factory ListDeadLettersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListDeadLettersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListDeadLettersRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'projectId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListDeadLettersRequest clone() => ListDeadLettersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListDeadLettersRequest copyWith(void Function(ListDeadLettersRequest) updates) => super.copyWith((message) => updates(message as ListDeadLettersRequest)) as ListDeadLettersRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDeadLettersRequest create() => ListDeadLettersRequest._();
  ListDeadLettersRequest createEmptyInstance() => create();
  static $pb.PbList<ListDeadLettersRequest> createRepeated() => $pb.PbList<ListDeadLettersRequest>();
  @$core.pragma('dart2js:noInline')
  static ListDeadLettersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDeadLettersRequest>(create);
  static ListDeadLettersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get projectId => $_getSZ(0);
  @$pb.TagNumber(1)
  set projectId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProjectId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => $_clearField(2);
}

class ListDeadLettersResponse extends $pb.GeneratedMessage {
  factory ListDeadLettersResponse({
    $core.Iterable<DeadLetter>? deadLetters,
  }) {
    final $result = create();
    if (deadLetters != null) {
      $result.deadLetters.addAll(deadLetters);
    }
    return $result;
  }
  ListDeadLettersResponse._() : super();
  factory ListDeadLettersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListDeadLettersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListDeadLettersResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..pc<DeadLetter>(1, _omitFieldNames ? '' : 'deadLetters', $pb.PbFieldType.PM, subBuilder: DeadLetter.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListDeadLettersResponse clone() => ListDeadLettersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListDeadLettersResponse copyWith(void Function(ListDeadLettersResponse) updates) => super.copyWith((message) => updates(message as ListDeadLettersResponse)) as ListDeadLettersResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListDeadLettersResponse create() => ListDeadLettersResponse._();
  ListDeadLettersResponse createEmptyInstance() => create();
  static $pb.PbList<ListDeadLettersResponse> createRepeated() => $pb.PbList<ListDeadLettersResponse>();
  @$core.pragma('dart2js:noInline')
  static ListDeadLettersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListDeadLettersResponse>(create);
  static ListDeadLettersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DeadLetter> get deadLetters => $_getList(0);
}

class GetDeadLetterRequest extends $pb.GeneratedMessage {
  factory GetDeadLetterRequest({
    $core.String? jobId,
  }) {
    final $result = create();
    if (jobId != null) {
      $result.jobId = jobId;
    }
    return $result;
  }
  GetDeadLetterRequest._() : super();
  factory GetDeadLetterRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDeadLetterRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDeadLetterRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'jobId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDeadLetterRequest clone() => GetDeadLetterRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDeadLetterRequest copyWith(void Function(GetDeadLetterRequest) updates) => super.copyWith((message) => updates(message as GetDeadLetterRequest)) as GetDeadLetterRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDeadLetterRequest create() => GetDeadLetterRequest._();
  GetDeadLetterRequest createEmptyInstance() => create();
  static $pb.PbList<GetDeadLetterRequest> createRepeated() => $pb.PbList<GetDeadLetterRequest>();
  @$core.pragma('dart2js:noInline')
  static GetDeadLetterRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDeadLetterRequest>(create);
  static GetDeadLetterRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get jobId => $_getSZ(0);
  @$pb.TagNumber(1)
  set jobId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasJobId() => $_has(0);
  @$pb.TagNumber(1)
  void clearJobId() => $_clearField(1);
}

class GetDeadLetterResponse extends $pb.GeneratedMessage {
  factory GetDeadLetterResponse({
    DeadLetter? deadLetter,
  }) {
    final $result = create();
    if (deadLetter != null) {
      $result.deadLetter = deadLetter;
    }
    return $result;
  }
  GetDeadLetterResponse._() : super();
  factory GetDeadLetterResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetDeadLetterResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetDeadLetterResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOM<DeadLetter>(1, _omitFieldNames ? '' : 'deadLetter', subBuilder: DeadLetter.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetDeadLetterResponse clone() => GetDeadLetterResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetDeadLetterResponse copyWith(void Function(GetDeadLetterResponse) updates) => super.copyWith((message) => updates(message as GetDeadLetterResponse)) as GetDeadLetterResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDeadLetterResponse create() => GetDeadLetterResponse._();
  GetDeadLetterResponse createEmptyInstance() => create();
  static $pb.PbList<GetDeadLetterResponse> createRepeated() => $pb.PbList<GetDeadLetterResponse>();
  @$core.pragma('dart2js:noInline')
  static GetDeadLetterResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetDeadLetterResponse>(create);
  static GetDeadLetterResponse? _defaultInstance;

  @$pb.TagNumber(1)
  DeadLetter get deadLetter => $_getN(0);
  @$pb.TagNumber(1)
  set deadLetter(DeadLetter v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeadLetter() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeadLetter() => $_clearField(1);
  @$pb.TagNumber(1)
  DeadLetter ensureDeadLetter() => $_ensure(0);
}

/// ComputeOrchestrationService manages long-running compute jobs, retries, and artifacts.
class ComputeOrchestrationServiceApi {
  $pb.RpcClient _client;
  ComputeOrchestrationServiceApi(this._client);

  /// SubmitJob enqueues a new compute job for asynchronous processing.
  $async.Future<SubmitJobResponse> submitJob($pb.ClientContext? ctx, SubmitJobRequest request) =>
    _client.invoke<SubmitJobResponse>(ctx, 'ComputeOrchestrationService', 'SubmitJob', request, SubmitJobResponse())
  ;
  /// GetJob returns the latest state of a compute job.
  $async.Future<GetJobResponse> getJob($pb.ClientContext? ctx, GetJobRequest request) =>
    _client.invoke<GetJobResponse>(ctx, 'ComputeOrchestrationService', 'GetJob', request, GetJobResponse())
  ;
  /// ListJobs returns jobs optionally filtered by status.
  $async.Future<ListJobsResponse> listJobs($pb.ClientContext? ctx, ListJobsRequest request) =>
    _client.invoke<ListJobsResponse>(ctx, 'ComputeOrchestrationService', 'ListJobs', request, ListJobsResponse())
  ;
  /// RetryJob retries a failed or canceled job.
  $async.Future<RetryJobResponse> retryJob($pb.ClientContext? ctx, RetryJobRequest request) =>
    _client.invoke<RetryJobResponse>(ctx, 'ComputeOrchestrationService', 'RetryJob', request, RetryJobResponse())
  ;
  /// CancelJob requests cancelation for a queued or running job.
  $async.Future<CancelJobResponse> cancelJob($pb.ClientContext? ctx, CancelJobRequest request) =>
    _client.invoke<CancelJobResponse>(ctx, 'ComputeOrchestrationService', 'CancelJob', request, CancelJobResponse())
  ;
  /// ListDeadLetters returns dead-lettered jobs for a project.
  $async.Future<ListDeadLettersResponse> listDeadLetters($pb.ClientContext? ctx, ListDeadLettersRequest request) =>
    _client.invoke<ListDeadLettersResponse>(ctx, 'ComputeOrchestrationService', 'ListDeadLetters', request, ListDeadLettersResponse())
  ;
  /// GetDeadLetter returns details of a specific dead-lettered job.
  $async.Future<GetDeadLetterResponse> getDeadLetter($pb.ClientContext? ctx, GetDeadLetterRequest request) =>
    _client.invoke<GetDeadLetterResponse>(ctx, 'ComputeOrchestrationService', 'GetDeadLetter', request, GetDeadLetterResponse())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
