//
//  Generated code. Do not modify.
//  source: orchestration/v1/job_events.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use jobEventTypeDescriptor instead')
const JobEventType$json = {
  '1': 'JobEventType',
  '2': [
    {'1': 'JOB_EVENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'JOB_EVENT_TYPE_SUBMITTED', '2': 1},
    {'1': 'JOB_EVENT_TYPE_DISPATCHED', '2': 2},
    {'1': 'JOB_EVENT_TYPE_STARTED', '2': 3},
    {'1': 'JOB_EVENT_TYPE_PROGRESS', '2': 4},
    {'1': 'JOB_EVENT_TYPE_RETRY_SCHEDULED', '2': 5},
    {'1': 'JOB_EVENT_TYPE_FAILED', '2': 6},
    {'1': 'JOB_EVENT_TYPE_SUCCEEDED', '2': 7},
    {'1': 'JOB_EVENT_TYPE_CANCELED', '2': 8},
    {'1': 'JOB_EVENT_TYPE_DEAD_LETTERED', '2': 9},
  ],
};

/// Descriptor for `JobEventType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List jobEventTypeDescriptor = $convert.base64Decode(
    'CgxKb2JFdmVudFR5cGUSHgoaSk9CX0VWRU5UX1RZUEVfVU5TUEVDSUZJRUQQABIcChhKT0JfRV'
    'ZFTlRfVFlQRV9TVUJNSVRURUQQARIdChlKT0JfRVZFTlRfVFlQRV9ESVNQQVRDSEVEEAISGgoW'
    'Sk9CX0VWRU5UX1RZUEVfU1RBUlRFRBADEhsKF0pPQl9FVkVOVF9UWVBFX1BST0dSRVNTEAQSIg'
    'oeSk9CX0VWRU5UX1RZUEVfUkVUUllfU0NIRURVTEVEEAUSGQoVSk9CX0VWRU5UX1RZUEVfRkFJ'
    'TEVEEAYSHAoYSk9CX0VWRU5UX1RZUEVfU1VDQ0VFREVEEAcSGwoXSk9CX0VWRU5UX1RZUEVfQ0'
    'FOQ0VMRUQQCBIgChxKT0JfRVZFTlRfVFlQRV9ERUFEX0xFVFRFUkVEEAk=');

@$core.Deprecated('Use jobEventDescriptor instead')
const JobEvent$json = {
  '1': 'JobEvent',
  '2': [
    {'1': 'event_id', '3': 1, '4': 1, '5': 9, '10': 'eventId'},
    {'1': 'job_id', '3': 2, '4': 1, '5': 9, '10': 'jobId'},
    {'1': 'project_id', '3': 3, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'job_type', '3': 4, '4': 1, '5': 14, '6': '.orchestration.v1.JobType', '10': 'jobType'},
    {'1': 'job_status', '3': 5, '4': 1, '5': 14, '6': '.orchestration.v1.JobStatus', '10': 'jobStatus'},
    {'1': 'event_type', '3': 6, '4': 1, '5': 14, '6': '.orchestration.v1.JobEventType', '10': 'eventType'},
    {'1': 'actor', '3': 7, '4': 1, '5': 9, '10': 'actor'},
    {'1': 'message', '3': 8, '4': 1, '5': 9, '10': 'message'},
    {'1': 'attempt', '3': 9, '4': 1, '5': 5, '10': 'attempt'},
    {'1': 'tags', '3': 10, '4': 3, '5': 11, '6': '.orchestration.v1.JobEvent.TagsEntry', '10': 'tags'},
    {'1': 'artifacts', '3': 11, '4': 3, '5': 11, '6': '.orchestration.v1.Artifact', '10': 'artifacts'},
    {'1': 'payload_json', '3': 12, '4': 1, '5': 9, '10': 'payloadJson'},
    {'1': 'occurred_at', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'occurredAt'},
  ],
  '3': [JobEvent_TagsEntry$json],
};

@$core.Deprecated('Use jobEventDescriptor instead')
const JobEvent_TagsEntry$json = {
  '1': 'TagsEntry',
  '2': [
    {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': {'7': true},
};

/// Descriptor for `JobEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobEventDescriptor = $convert.base64Decode(
    'CghKb2JFdmVudBIZCghldmVudF9pZBgBIAEoCVIHZXZlbnRJZBIVCgZqb2JfaWQYAiABKAlSBW'
    'pvYklkEh0KCnByb2plY3RfaWQYAyABKAlSCXByb2plY3RJZBI0Cghqb2JfdHlwZRgEIAEoDjIZ'
    'Lm9yY2hlc3RyYXRpb24udjEuSm9iVHlwZVIHam9iVHlwZRI6Cgpqb2Jfc3RhdHVzGAUgASgOMh'
    'sub3JjaGVzdHJhdGlvbi52MS5Kb2JTdGF0dXNSCWpvYlN0YXR1cxI9CgpldmVudF90eXBlGAYg'
    'ASgOMh4ub3JjaGVzdHJhdGlvbi52MS5Kb2JFdmVudFR5cGVSCWV2ZW50VHlwZRIUCgVhY3Rvch'
    'gHIAEoCVIFYWN0b3ISGAoHbWVzc2FnZRgIIAEoCVIHbWVzc2FnZRIYCgdhdHRlbXB0GAkgASgF'
    'UgdhdHRlbXB0EjgKBHRhZ3MYCiADKAsyJC5vcmNoZXN0cmF0aW9uLnYxLkpvYkV2ZW50LlRhZ3'
    'NFbnRyeVIEdGFncxI4CglhcnRpZmFjdHMYCyADKAsyGi5vcmNoZXN0cmF0aW9uLnYxLkFydGlm'
    'YWN0UglhcnRpZmFjdHMSIQoMcGF5bG9hZF9qc29uGAwgASgJUgtwYXlsb2FkSnNvbhI7CgtvY2'
    'N1cnJlZF9hdBgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCm9jY3VycmVkQXQa'
    'NwoJVGFnc0VudHJ5EhAKA2tleRgBIAEoCVIDa2V5EhQKBXZhbHVlGAIgASgJUgV2YWx1ZToCOA'
    'E=');

@$core.Deprecated('Use jobEventEnvelopeDescriptor instead')
const JobEventEnvelope$json = {
  '1': 'JobEventEnvelope',
  '2': [
    {'1': 'event_version', '3': 1, '4': 1, '5': 11, '6': '.common.v1.ApiVersion', '10': 'eventVersion'},
    {'1': 'sequence', '3': 2, '4': 1, '5': 4, '10': 'sequence'},
    {'1': 'correlation_id', '3': 3, '4': 1, '5': 9, '10': 'correlationId'},
    {'1': 'causation_id', '3': 4, '4': 1, '5': 9, '10': 'causationId'},
    {'1': 'event', '3': 5, '4': 1, '5': 11, '6': '.orchestration.v1.JobEvent', '10': 'event'},
  ],
};

/// Descriptor for `JobEventEnvelope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobEventEnvelopeDescriptor = $convert.base64Decode(
    'ChBKb2JFdmVudEVudmVsb3BlEjoKDWV2ZW50X3ZlcnNpb24YASABKAsyFS5jb21tb24udjEuQX'
    'BpVmVyc2lvblIMZXZlbnRWZXJzaW9uEhoKCHNlcXVlbmNlGAIgASgEUghzZXF1ZW5jZRIlCg5j'
    'b3JyZWxhdGlvbl9pZBgDIAEoCVINY29ycmVsYXRpb25JZBIhCgxjYXVzYXRpb25faWQYBCABKA'
    'lSC2NhdXNhdGlvbklkEjAKBWV2ZW50GAUgASgLMhoub3JjaGVzdHJhdGlvbi52MS5Kb2JFdmVu'
    'dFIFZXZlbnQ=');

@$core.Deprecated('Use jobEventBatchDescriptor instead')
const JobEventBatch$json = {
  '1': 'JobEventBatch',
  '2': [
    {'1': 'stream_id', '3': 1, '4': 1, '5': 9, '10': 'streamId'},
    {'1': 'events', '3': 2, '4': 3, '5': 11, '6': '.orchestration.v1.JobEventEnvelope', '10': 'events'},
  ],
};

/// Descriptor for `JobEventBatch`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List jobEventBatchDescriptor = $convert.base64Decode(
    'Cg1Kb2JFdmVudEJhdGNoEhsKCXN0cmVhbV9pZBgBIAEoCVIIc3RyZWFtSWQSOgoGZXZlbnRzGA'
    'IgAygLMiIub3JjaGVzdHJhdGlvbi52MS5Kb2JFdmVudEVudmVsb3BlUgZldmVudHM=');

