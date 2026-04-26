//
//  Generated code. Do not modify.
//  source: orchestration/v1/job_events.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../common/v1/primitives.pb.dart' as $2;
import '../../google/protobuf/timestamp.pb.dart' as $0;
import 'job_events.pbenum.dart';
import 'orchestration.pb.dart' as $1;
import 'orchestration.pbenum.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'job_events.pbenum.dart';

class JobEvent extends $pb.GeneratedMessage {
  factory JobEvent({
    $core.String? eventId,
    $core.String? jobId,
    $core.String? projectId,
    $1.JobType? jobType,
    $1.JobStatus? jobStatus,
    JobEventType? eventType,
    $core.String? actor,
    $core.String? message,
    $core.int? attempt,
    $pb.PbMap<$core.String, $core.String>? tags,
    $core.Iterable<$1.Artifact>? artifacts,
    $core.String? payloadJson,
    $0.Timestamp? occurredAt,
  }) {
    final $result = create();
    if (eventId != null) {
      $result.eventId = eventId;
    }
    if (jobId != null) {
      $result.jobId = jobId;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (jobType != null) {
      $result.jobType = jobType;
    }
    if (jobStatus != null) {
      $result.jobStatus = jobStatus;
    }
    if (eventType != null) {
      $result.eventType = eventType;
    }
    if (actor != null) {
      $result.actor = actor;
    }
    if (message != null) {
      $result.message = message;
    }
    if (attempt != null) {
      $result.attempt = attempt;
    }
    if (tags != null) {
      $result.tags.addAll(tags);
    }
    if (artifacts != null) {
      $result.artifacts.addAll(artifacts);
    }
    if (payloadJson != null) {
      $result.payloadJson = payloadJson;
    }
    if (occurredAt != null) {
      $result.occurredAt = occurredAt;
    }
    return $result;
  }
  JobEvent._() : super();
  factory JobEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JobEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JobEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eventId')
    ..aOS(2, _omitFieldNames ? '' : 'jobId')
    ..aOS(3, _omitFieldNames ? '' : 'projectId')
    ..e<$1.JobType>(4, _omitFieldNames ? '' : 'jobType', $pb.PbFieldType.OE, defaultOrMaker: $1.JobType.JOB_TYPE_UNSPECIFIED, valueOf: $1.JobType.valueOf, enumValues: $1.JobType.values)
    ..e<$1.JobStatus>(5, _omitFieldNames ? '' : 'jobStatus', $pb.PbFieldType.OE, defaultOrMaker: $1.JobStatus.JOB_STATUS_UNSPECIFIED, valueOf: $1.JobStatus.valueOf, enumValues: $1.JobStatus.values)
    ..e<JobEventType>(6, _omitFieldNames ? '' : 'eventType', $pb.PbFieldType.OE, defaultOrMaker: JobEventType.JOB_EVENT_TYPE_UNSPECIFIED, valueOf: JobEventType.valueOf, enumValues: JobEventType.values)
    ..aOS(7, _omitFieldNames ? '' : 'actor')
    ..aOS(8, _omitFieldNames ? '' : 'message')
    ..a<$core.int>(9, _omitFieldNames ? '' : 'attempt', $pb.PbFieldType.O3)
    ..m<$core.String, $core.String>(10, _omitFieldNames ? '' : 'tags', entryClassName: 'JobEvent.TagsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('orchestration.v1'))
    ..pc<$1.Artifact>(11, _omitFieldNames ? '' : 'artifacts', $pb.PbFieldType.PM, subBuilder: $1.Artifact.create)
    ..aOS(12, _omitFieldNames ? '' : 'payloadJson')
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'occurredAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JobEvent clone() => JobEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JobEvent copyWith(void Function(JobEvent) updates) => super.copyWith((message) => updates(message as JobEvent)) as JobEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JobEvent create() => JobEvent._();
  JobEvent createEmptyInstance() => create();
  static $pb.PbList<JobEvent> createRepeated() => $pb.PbList<JobEvent>();
  @$core.pragma('dart2js:noInline')
  static JobEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JobEvent>(create);
  static JobEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eventId => $_getSZ(0);
  @$pb.TagNumber(1)
  set eventId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get jobId => $_getSZ(1);
  @$pb.TagNumber(2)
  set jobId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasJobId() => $_has(1);
  @$pb.TagNumber(2)
  void clearJobId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get projectId => $_getSZ(2);
  @$pb.TagNumber(3)
  set projectId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProjectId() => $_has(2);
  @$pb.TagNumber(3)
  void clearProjectId() => $_clearField(3);

  @$pb.TagNumber(4)
  $1.JobType get jobType => $_getN(3);
  @$pb.TagNumber(4)
  set jobType($1.JobType v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasJobType() => $_has(3);
  @$pb.TagNumber(4)
  void clearJobType() => $_clearField(4);

  @$pb.TagNumber(5)
  $1.JobStatus get jobStatus => $_getN(4);
  @$pb.TagNumber(5)
  set jobStatus($1.JobStatus v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasJobStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearJobStatus() => $_clearField(5);

  @$pb.TagNumber(6)
  JobEventType get eventType => $_getN(5);
  @$pb.TagNumber(6)
  set eventType(JobEventType v) { $_setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasEventType() => $_has(5);
  @$pb.TagNumber(6)
  void clearEventType() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get actor => $_getSZ(6);
  @$pb.TagNumber(7)
  set actor($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasActor() => $_has(6);
  @$pb.TagNumber(7)
  void clearActor() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get message => $_getSZ(7);
  @$pb.TagNumber(8)
  set message($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasMessage() => $_has(7);
  @$pb.TagNumber(8)
  void clearMessage() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.int get attempt => $_getIZ(8);
  @$pb.TagNumber(9)
  set attempt($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasAttempt() => $_has(8);
  @$pb.TagNumber(9)
  void clearAttempt() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbMap<$core.String, $core.String> get tags => $_getMap(9);

  @$pb.TagNumber(11)
  $pb.PbList<$1.Artifact> get artifacts => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get payloadJson => $_getSZ(11);
  @$pb.TagNumber(12)
  set payloadJson($core.String v) { $_setString(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasPayloadJson() => $_has(11);
  @$pb.TagNumber(12)
  void clearPayloadJson() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.Timestamp get occurredAt => $_getN(12);
  @$pb.TagNumber(13)
  set occurredAt($0.Timestamp v) { $_setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasOccurredAt() => $_has(12);
  @$pb.TagNumber(13)
  void clearOccurredAt() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureOccurredAt() => $_ensure(12);
}

class JobEventEnvelope extends $pb.GeneratedMessage {
  factory JobEventEnvelope({
    $2.ApiVersion? eventVersion,
    $fixnum.Int64? sequence,
    $core.String? correlationId,
    $core.String? causationId,
    JobEvent? event,
  }) {
    final $result = create();
    if (eventVersion != null) {
      $result.eventVersion = eventVersion;
    }
    if (sequence != null) {
      $result.sequence = sequence;
    }
    if (correlationId != null) {
      $result.correlationId = correlationId;
    }
    if (causationId != null) {
      $result.causationId = causationId;
    }
    if (event != null) {
      $result.event = event;
    }
    return $result;
  }
  JobEventEnvelope._() : super();
  factory JobEventEnvelope.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JobEventEnvelope.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JobEventEnvelope', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOM<$2.ApiVersion>(1, _omitFieldNames ? '' : 'eventVersion', subBuilder: $2.ApiVersion.create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'sequence', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, _omitFieldNames ? '' : 'correlationId')
    ..aOS(4, _omitFieldNames ? '' : 'causationId')
    ..aOM<JobEvent>(5, _omitFieldNames ? '' : 'event', subBuilder: JobEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JobEventEnvelope clone() => JobEventEnvelope()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JobEventEnvelope copyWith(void Function(JobEventEnvelope) updates) => super.copyWith((message) => updates(message as JobEventEnvelope)) as JobEventEnvelope;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JobEventEnvelope create() => JobEventEnvelope._();
  JobEventEnvelope createEmptyInstance() => create();
  static $pb.PbList<JobEventEnvelope> createRepeated() => $pb.PbList<JobEventEnvelope>();
  @$core.pragma('dart2js:noInline')
  static JobEventEnvelope getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JobEventEnvelope>(create);
  static JobEventEnvelope? _defaultInstance;

  @$pb.TagNumber(1)
  $2.ApiVersion get eventVersion => $_getN(0);
  @$pb.TagNumber(1)
  set eventVersion($2.ApiVersion v) { $_setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasEventVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventVersion() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.ApiVersion ensureEventVersion() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get sequence => $_getI64(1);
  @$pb.TagNumber(2)
  set sequence($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSequence() => $_has(1);
  @$pb.TagNumber(2)
  void clearSequence() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get correlationId => $_getSZ(2);
  @$pb.TagNumber(3)
  set correlationId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCorrelationId() => $_has(2);
  @$pb.TagNumber(3)
  void clearCorrelationId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get causationId => $_getSZ(3);
  @$pb.TagNumber(4)
  set causationId($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCausationId() => $_has(3);
  @$pb.TagNumber(4)
  void clearCausationId() => $_clearField(4);

  @$pb.TagNumber(5)
  JobEvent get event => $_getN(4);
  @$pb.TagNumber(5)
  set event(JobEvent v) { $_setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasEvent() => $_has(4);
  @$pb.TagNumber(5)
  void clearEvent() => $_clearField(5);
  @$pb.TagNumber(5)
  JobEvent ensureEvent() => $_ensure(4);
}

class JobEventBatch extends $pb.GeneratedMessage {
  factory JobEventBatch({
    $core.String? streamId,
    $core.Iterable<JobEventEnvelope>? events,
  }) {
    final $result = create();
    if (streamId != null) {
      $result.streamId = streamId;
    }
    if (events != null) {
      $result.events.addAll(events);
    }
    return $result;
  }
  JobEventBatch._() : super();
  factory JobEventBatch.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JobEventBatch.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'JobEventBatch', package: const $pb.PackageName(_omitMessageNames ? '' : 'orchestration.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'streamId')
    ..pc<JobEventEnvelope>(2, _omitFieldNames ? '' : 'events', $pb.PbFieldType.PM, subBuilder: JobEventEnvelope.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  JobEventBatch clone() => JobEventBatch()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  JobEventBatch copyWith(void Function(JobEventBatch) updates) => super.copyWith((message) => updates(message as JobEventBatch)) as JobEventBatch;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JobEventBatch create() => JobEventBatch._();
  JobEventBatch createEmptyInstance() => create();
  static $pb.PbList<JobEventBatch> createRepeated() => $pb.PbList<JobEventBatch>();
  @$core.pragma('dart2js:noInline')
  static JobEventBatch getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JobEventBatch>(create);
  static JobEventBatch? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get streamId => $_getSZ(0);
  @$pb.TagNumber(1)
  set streamId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasStreamId() => $_has(0);
  @$pb.TagNumber(1)
  void clearStreamId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<JobEventEnvelope> get events => $_getList(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
