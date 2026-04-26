//
//  Generated code. Do not modify.
//  source: orchestration/v1/orchestration.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class JobType extends $pb.ProtobufEnum {
  static const JobType JOB_TYPE_UNSPECIFIED = JobType._(0, _omitEnumNames ? '' : 'JOB_TYPE_UNSPECIFIED');
  static const JobType JOB_TYPE_REGENERATE = JobType._(1, _omitEnumNames ? '' : 'JOB_TYPE_REGENERATE');
  static const JobType JOB_TYPE_IMPORT = JobType._(2, _omitEnumNames ? '' : 'JOB_TYPE_IMPORT');
  static const JobType JOB_TYPE_PUBLISH = JobType._(3, _omitEnumNames ? '' : 'JOB_TYPE_PUBLISH');
  static const JobType JOB_TYPE_SIMULATION = JobType._(4, _omitEnumNames ? '' : 'JOB_TYPE_SIMULATION');
  static const JobType JOB_TYPE_OPTIMIZATION = JobType._(5, _omitEnumNames ? '' : 'JOB_TYPE_OPTIMIZATION');
  static const JobType JOB_TYPE_CUSTOM = JobType._(6, _omitEnumNames ? '' : 'JOB_TYPE_CUSTOM');
  static const JobType JOB_TYPE_STRUCTURAL_LOAD_ANALYSIS = JobType._(7, _omitEnumNames ? '' : 'JOB_TYPE_STRUCTURAL_LOAD_ANALYSIS');
  static const JobType JOB_TYPE_PROTECTION_STUDY = JobType._(8, _omitEnumNames ? '' : 'JOB_TYPE_PROTECTION_STUDY');
  static const JobType JOB_TYPE_COMMISSIONING = JobType._(9, _omitEnumNames ? '' : 'JOB_TYPE_COMMISSIONING');

  static const $core.List<JobType> values = <JobType> [
    JOB_TYPE_UNSPECIFIED,
    JOB_TYPE_REGENERATE,
    JOB_TYPE_IMPORT,
    JOB_TYPE_PUBLISH,
    JOB_TYPE_SIMULATION,
    JOB_TYPE_OPTIMIZATION,
    JOB_TYPE_CUSTOM,
    JOB_TYPE_STRUCTURAL_LOAD_ANALYSIS,
    JOB_TYPE_PROTECTION_STUDY,
    JOB_TYPE_COMMISSIONING,
  ];

  static final $core.Map<$core.int, JobType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static JobType? valueOf($core.int value) => _byValue[value];

  const JobType._(super.v, super.n);
}

class JobStatus extends $pb.ProtobufEnum {
  static const JobStatus JOB_STATUS_UNSPECIFIED = JobStatus._(0, _omitEnumNames ? '' : 'JOB_STATUS_UNSPECIFIED');
  static const JobStatus JOB_STATUS_QUEUED = JobStatus._(1, _omitEnumNames ? '' : 'JOB_STATUS_QUEUED');
  static const JobStatus JOB_STATUS_RUNNING = JobStatus._(2, _omitEnumNames ? '' : 'JOB_STATUS_RUNNING');
  static const JobStatus JOB_STATUS_SUCCEEDED = JobStatus._(3, _omitEnumNames ? '' : 'JOB_STATUS_SUCCEEDED');
  static const JobStatus JOB_STATUS_FAILED = JobStatus._(4, _omitEnumNames ? '' : 'JOB_STATUS_FAILED');
  static const JobStatus JOB_STATUS_CANCELED = JobStatus._(5, _omitEnumNames ? '' : 'JOB_STATUS_CANCELED');
  static const JobStatus JOB_STATUS_RETRY_PENDING = JobStatus._(6, _omitEnumNames ? '' : 'JOB_STATUS_RETRY_PENDING');

  static const $core.List<JobStatus> values = <JobStatus> [
    JOB_STATUS_UNSPECIFIED,
    JOB_STATUS_QUEUED,
    JOB_STATUS_RUNNING,
    JOB_STATUS_SUCCEEDED,
    JOB_STATUS_FAILED,
    JOB_STATUS_CANCELED,
    JOB_STATUS_RETRY_PENDING,
  ];

  static final $core.Map<$core.int, JobStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static JobStatus? valueOf($core.int value) => _byValue[value];

  const JobStatus._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
