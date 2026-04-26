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

import 'package:protobuf/protobuf.dart' as $pb;

class JobEventType extends $pb.ProtobufEnum {
  static const JobEventType JOB_EVENT_TYPE_UNSPECIFIED = JobEventType._(0, _omitEnumNames ? '' : 'JOB_EVENT_TYPE_UNSPECIFIED');
  static const JobEventType JOB_EVENT_TYPE_SUBMITTED = JobEventType._(1, _omitEnumNames ? '' : 'JOB_EVENT_TYPE_SUBMITTED');
  static const JobEventType JOB_EVENT_TYPE_DISPATCHED = JobEventType._(2, _omitEnumNames ? '' : 'JOB_EVENT_TYPE_DISPATCHED');
  static const JobEventType JOB_EVENT_TYPE_STARTED = JobEventType._(3, _omitEnumNames ? '' : 'JOB_EVENT_TYPE_STARTED');
  static const JobEventType JOB_EVENT_TYPE_PROGRESS = JobEventType._(4, _omitEnumNames ? '' : 'JOB_EVENT_TYPE_PROGRESS');
  static const JobEventType JOB_EVENT_TYPE_RETRY_SCHEDULED = JobEventType._(5, _omitEnumNames ? '' : 'JOB_EVENT_TYPE_RETRY_SCHEDULED');
  static const JobEventType JOB_EVENT_TYPE_FAILED = JobEventType._(6, _omitEnumNames ? '' : 'JOB_EVENT_TYPE_FAILED');
  static const JobEventType JOB_EVENT_TYPE_SUCCEEDED = JobEventType._(7, _omitEnumNames ? '' : 'JOB_EVENT_TYPE_SUCCEEDED');
  static const JobEventType JOB_EVENT_TYPE_CANCELED = JobEventType._(8, _omitEnumNames ? '' : 'JOB_EVENT_TYPE_CANCELED');
  static const JobEventType JOB_EVENT_TYPE_DEAD_LETTERED = JobEventType._(9, _omitEnumNames ? '' : 'JOB_EVENT_TYPE_DEAD_LETTERED');

  static const $core.List<JobEventType> values = <JobEventType> [
    JOB_EVENT_TYPE_UNSPECIFIED,
    JOB_EVENT_TYPE_SUBMITTED,
    JOB_EVENT_TYPE_DISPATCHED,
    JOB_EVENT_TYPE_STARTED,
    JOB_EVENT_TYPE_PROGRESS,
    JOB_EVENT_TYPE_RETRY_SCHEDULED,
    JOB_EVENT_TYPE_FAILED,
    JOB_EVENT_TYPE_SUCCEEDED,
    JOB_EVENT_TYPE_CANCELED,
    JOB_EVENT_TYPE_DEAD_LETTERED,
  ];

  static final $core.Map<$core.int, JobEventType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static JobEventType? valueOf($core.int value) => _byValue[value];

  const JobEventType._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
