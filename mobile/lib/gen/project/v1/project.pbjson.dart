//
//  Generated code. Do not modify.
//  source: project/v1/project.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../google/protobuf/field_mask.pbjson.dart' as $3;
import '../../google/protobuf/timestamp.pbjson.dart' as $0;
import '../../packages/pagination.pbjson.dart' as $1;
import '../../planning/v1/planning_workflow.pbjson.dart' as $2;

@$core.Deprecated('Use projectStatusDescriptor instead')
const ProjectStatus$json = {
  '1': 'ProjectStatus',
  '2': [
    {'1': 'PROJECT_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PROJECT_STATUS_DRAFT', '2': 1},
    {'1': 'PROJECT_STATUS_DESIGN', '2': 2},
    {'1': 'PROJECT_STATUS_SIMULATION', '2': 3},
    {'1': 'PROJECT_STATUS_REVIEW', '2': 4},
    {'1': 'PROJECT_STATUS_APPROVED', '2': 5},
    {'1': 'PROJECT_STATUS_ARCHIVED', '2': 6},
  ],
};

/// Descriptor for `ProjectStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List projectStatusDescriptor = $convert.base64Decode(
    'Cg1Qcm9qZWN0U3RhdHVzEh4KGlBST0pFQ1RfU1RBVFVTX1VOU1BFQ0lGSUVEEAASGAoUUFJPSk'
    'VDVF9TVEFUVVNfRFJBRlQQARIZChVQUk9KRUNUX1NUQVRVU19ERVNJR04QAhIdChlQUk9KRUNU'
    'X1NUQVRVU19TSU1VTEFUSU9OEAMSGQoVUFJPSkVDVF9TVEFUVVNfUkVWSUVXEAQSGwoXUFJPSk'
    'VDVF9TVEFUVVNfQVBQUk9WRUQQBRIbChdQUk9KRUNUX1NUQVRVU19BUkNISVZFRBAG');

@$core.Deprecated('Use projectDescriptor instead')
const Project$json = {
  '1': 'Project',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.project.v1.ProjectStatus', '10': 'status'},
    {'1': 'site', '3': 5, '4': 1, '5': 11, '6': '.project.v1.Site', '10': 'site'},
    {'1': 'metadata', '3': 6, '4': 1, '5': 11, '6': '.project.v1.ProjectMetadata', '10': 'metadata'},
    {'1': 'created_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'workflow_phase', '3': 9, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'workflowPhase'},
    {'1': 'phase_entered_at', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'phaseEnteredAt'},
    {'1': 'transition_history', '3': 11, '4': 3, '5': 11, '6': '.project.v1.PhaseTransitionHistoryEntry', '10': 'transitionHistory'},
    {'1': 'active_blockers', '3': 12, '4': 3, '5': 9, '10': 'activeBlockers'},
  ],
};

/// Descriptor for `Project`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectDescriptor = $convert.base64Decode(
    'CgdQcm9qZWN0Eg4KAmlkGAEgASgJUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEiAKC2Rlc2NyaX'
    'B0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhIxCgZzdGF0dXMYBCABKA4yGS5wcm9qZWN0LnYxLlBy'
    'b2plY3RTdGF0dXNSBnN0YXR1cxIkCgRzaXRlGAUgASgLMhAucHJvamVjdC52MS5TaXRlUgRzaX'
    'RlEjcKCG1ldGFkYXRhGAYgASgLMhsucHJvamVjdC52MS5Qcm9qZWN0TWV0YWRhdGFSCG1ldGFk'
    'YXRhEjkKCmNyZWF0ZWRfYXQYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcm'
    'VhdGVkQXQSOQoKdXBkYXRlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CXVwZGF0ZWRBdBJBCg53b3JrZmxvd19waGFzZRgJIAEoDjIaLnBsYW5uaW5nLnYxLldvcmtmbG'
    '93UGhhc2VSDXdvcmtmbG93UGhhc2USRAoQcGhhc2VfZW50ZXJlZF9hdBgKIAEoCzIaLmdvb2ds'
    'ZS5wcm90b2J1Zi5UaW1lc3RhbXBSDnBoYXNlRW50ZXJlZEF0ElYKEnRyYW5zaXRpb25faGlzdG'
    '9yeRgLIAMoCzInLnByb2plY3QudjEuUGhhc2VUcmFuc2l0aW9uSGlzdG9yeUVudHJ5UhF0cmFu'
    'c2l0aW9uSGlzdG9yeRInCg9hY3RpdmVfYmxvY2tlcnMYDCADKAlSDmFjdGl2ZUJsb2NrZXJz');

@$core.Deprecated('Use siteDescriptor instead')
const Site$json = {
  '1': 'Site',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'name', '3': 3, '4': 1, '5': 9, '10': 'name'},
    {'1': 'boundary_geojson', '3': 4, '4': 1, '5': 9, '10': 'boundaryGeojson'},
    {'1': 'area_sqm', '3': 5, '4': 1, '5': 1, '10': 'areaSqm'},
    {'1': 'latitude', '3': 6, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 7, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'timezone', '3': 8, '4': 1, '5': 9, '10': 'timezone'},
    {'1': 'created_at', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
  ],
};

/// Descriptor for `Site`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List siteDescriptor = $convert.base64Decode(
    'CgRTaXRlEg4KAmlkGAEgASgJUgJpZBIdCgpwcm9qZWN0X2lkGAIgASgJUglwcm9qZWN0SWQSEg'
    'oEbmFtZRgDIAEoCVIEbmFtZRIpChBib3VuZGFyeV9nZW9qc29uGAQgASgJUg9ib3VuZGFyeUdl'
    'b2pzb24SGQoIYXJlYV9zcW0YBSABKAFSB2FyZWFTcW0SGgoIbGF0aXR1ZGUYBiABKAFSCGxhdG'
    'l0dWRlEhwKCWxvbmdpdHVkZRgHIAEoAVIJbG9uZ2l0dWRlEhoKCHRpbWV6b25lGAggASgJUgh0'
    'aW1lem9uZRI5CgpjcmVhdGVkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'IJY3JlYXRlZEF0');

@$core.Deprecated('Use projectMetadataDescriptor instead')
const ProjectMetadata$json = {
  '1': 'ProjectMetadata',
  '2': [
    {'1': 'target_capacity_mw', '3': 1, '4': 1, '5': 1, '10': 'targetCapacityMw'},
    {'1': 'location_name', '3': 2, '4': 1, '5': 9, '10': 'locationName'},
    {'1': 'client_name', '3': 3, '4': 1, '5': 9, '10': 'clientName'},
    {'1': 'notes', '3': 4, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `ProjectMetadata`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectMetadataDescriptor = $convert.base64Decode(
    'Cg9Qcm9qZWN0TWV0YWRhdGESLAoSdGFyZ2V0X2NhcGFjaXR5X213GAEgASgBUhB0YXJnZXRDYX'
    'BhY2l0eU13EiMKDWxvY2F0aW9uX25hbWUYAiABKAlSDGxvY2F0aW9uTmFtZRIfCgtjbGllbnRf'
    'bmFtZRgDIAEoCVIKY2xpZW50TmFtZRIUCgVub3RlcxgEIAEoCVIFbm90ZXM=');

@$core.Deprecated('Use createProjectRequestDescriptor instead')
const CreateProjectRequest$json = {
  '1': 'CreateProjectRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 2, '4': 1, '5': 9, '10': 'description'},
    {'1': 'metadata', '3': 3, '4': 1, '5': 11, '6': '.project.v1.ProjectMetadata', '10': 'metadata'},
  ],
};

/// Descriptor for `CreateProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createProjectRequestDescriptor = $convert.base64Decode(
    'ChRDcmVhdGVQcm9qZWN0UmVxdWVzdBISCgRuYW1lGAEgASgJUgRuYW1lEiAKC2Rlc2NyaXB0aW'
    '9uGAIgASgJUgtkZXNjcmlwdGlvbhI3CghtZXRhZGF0YRgDIAEoCzIbLnByb2plY3QudjEuUHJv'
    'amVjdE1ldGFkYXRhUghtZXRhZGF0YQ==');

@$core.Deprecated('Use createProjectResponseDescriptor instead')
const CreateProjectResponse$json = {
  '1': 'CreateProjectResponse',
  '2': [
    {'1': 'project', '3': 1, '4': 1, '5': 11, '6': '.project.v1.Project', '10': 'project'},
  ],
};

/// Descriptor for `CreateProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createProjectResponseDescriptor = $convert.base64Decode(
    'ChVDcmVhdGVQcm9qZWN0UmVzcG9uc2USLQoHcHJvamVjdBgBIAEoCzITLnByb2plY3QudjEuUH'
    'JvamVjdFIHcHJvamVjdA==');

@$core.Deprecated('Use getProjectRequestDescriptor instead')
const GetProjectRequest$json = {
  '1': 'GetProjectRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProjectRequestDescriptor = $convert.base64Decode(
    'ChFHZXRQcm9qZWN0UmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use getProjectResponseDescriptor instead')
const GetProjectResponse$json = {
  '1': 'GetProjectResponse',
  '2': [
    {'1': 'project', '3': 1, '4': 1, '5': 11, '6': '.project.v1.Project', '10': 'project'},
  ],
};

/// Descriptor for `GetProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getProjectResponseDescriptor = $convert.base64Decode(
    'ChJHZXRQcm9qZWN0UmVzcG9uc2USLQoHcHJvamVjdBgBIAEoCzITLnByb2plY3QudjEuUHJvam'
    'VjdFIHcHJvamVjdA==');

@$core.Deprecated('Use listProjectsRequestDescriptor instead')
const ListProjectsRequest$json = {
  '1': 'ListProjectsRequest',
  '2': [
    {'1': 'status_filter', '3': 1, '4': 1, '5': 14, '6': '.project.v1.ProjectStatus', '10': 'statusFilter'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `ListProjectsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsRequestDescriptor = $convert.base64Decode(
    'ChNMaXN0UHJvamVjdHNSZXF1ZXN0Ej4KDXN0YXR1c19maWx0ZXIYASABKA4yGS5wcm9qZWN0Ln'
    'YxLlByb2plY3RTdGF0dXNSDHN0YXR1c0ZpbHRlchJNCgpwYWdpbmF0aW9uGAIgASgLMi0ucGFj'
    'a2FnZXMuYXBpLnYxLnBhZ2luYXRpb24uUGFnaW5hdGlvblJlcXVlc3RSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use listProjectsResponseDescriptor instead')
const ListProjectsResponse$json = {
  '1': 'ListProjectsResponse',
  '2': [
    {'1': 'projects', '3': 1, '4': 3, '5': 11, '6': '.project.v1.Project', '10': 'projects'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `ListProjectsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listProjectsResponseDescriptor = $convert.base64Decode(
    'ChRMaXN0UHJvamVjdHNSZXNwb25zZRIvCghwcm9qZWN0cxgBIAMoCzITLnByb2plY3QudjEuUH'
    'JvamVjdFIIcHJvamVjdHMSTgoKcGFnaW5hdGlvbhgCIAEoCzIuLnBhY2thZ2VzLmFwaS52MS5w'
    'YWdpbmF0aW9uLlBhZ2luYXRpb25SZXNwb25zZVIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use updateProjectRequestDescriptor instead')
const UpdateProjectRequest$json = {
  '1': 'UpdateProjectRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.project.v1.ProjectStatus', '10': 'status'},
    {'1': 'metadata', '3': 5, '4': 1, '5': 11, '6': '.project.v1.ProjectMetadata', '10': 'metadata'},
  ],
};

/// Descriptor for `UpdateProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProjectRequestDescriptor = $convert.base64Decode(
    'ChRVcGRhdGVQcm9qZWN0UmVxdWVzdBIOCgJpZBgBIAEoCVICaWQSEgoEbmFtZRgCIAEoCVIEbm'
    'FtZRIgCgtkZXNjcmlwdGlvbhgDIAEoCVILZGVzY3JpcHRpb24SMQoGc3RhdHVzGAQgASgOMhku'
    'cHJvamVjdC52MS5Qcm9qZWN0U3RhdHVzUgZzdGF0dXMSNwoIbWV0YWRhdGEYBSABKAsyGy5wcm'
    '9qZWN0LnYxLlByb2plY3RNZXRhZGF0YVIIbWV0YWRhdGE=');

@$core.Deprecated('Use updateProjectResponseDescriptor instead')
const UpdateProjectResponse$json = {
  '1': 'UpdateProjectResponse',
  '2': [
    {'1': 'project', '3': 1, '4': 1, '5': 11, '6': '.project.v1.Project', '10': 'project'},
  ],
};

/// Descriptor for `UpdateProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateProjectResponseDescriptor = $convert.base64Decode(
    'ChVVcGRhdGVQcm9qZWN0UmVzcG9uc2USLQoHcHJvamVjdBgBIAEoCzITLnByb2plY3QudjEuUH'
    'JvamVjdFIHcHJvamVjdA==');

@$core.Deprecated('Use deleteProjectRequestDescriptor instead')
const DeleteProjectRequest$json = {
  '1': 'DeleteProjectRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteProjectRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProjectRequestDescriptor = $convert.base64Decode(
    'ChREZWxldGVQcm9qZWN0UmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use deleteProjectResponseDescriptor instead')
const DeleteProjectResponse$json = {
  '1': 'DeleteProjectResponse',
};

/// Descriptor for `DeleteProjectResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteProjectResponseDescriptor = $convert.base64Decode(
    'ChVEZWxldGVQcm9qZWN0UmVzcG9uc2U=');

@$core.Deprecated('Use phaseTransitionHistoryEntryDescriptor instead')
const PhaseTransitionHistoryEntry$json = {
  '1': 'PhaseTransitionHistoryEntry',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'from_phase', '3': 2, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'fromPhase'},
    {'1': 'to_phase', '3': 3, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'toPhase'},
    {'1': 'occurred_at', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'occurredAt'},
    {'1': 'actor_id', '3': 5, '4': 1, '5': 9, '10': 'actorId'},
    {'1': 'reason', '3': 6, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'is_rollback', '3': 7, '4': 1, '5': 8, '10': 'isRollback'},
    {'1': 'rollback_reason', '3': 8, '4': 1, '5': 9, '10': 'rollbackReason'},
  ],
};

/// Descriptor for `PhaseTransitionHistoryEntry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phaseTransitionHistoryEntryDescriptor = $convert.base64Decode(
    'ChtQaGFzZVRyYW5zaXRpb25IaXN0b3J5RW50cnkSDgoCaWQYASABKAlSAmlkEjkKCmZyb21fcG'
    'hhc2UYAiABKA4yGi5wbGFubmluZy52MS5Xb3JrZmxvd1BoYXNlUglmcm9tUGhhc2USNQoIdG9f'
    'cGhhc2UYAyABKA4yGi5wbGFubmluZy52MS5Xb3JrZmxvd1BoYXNlUgd0b1BoYXNlEjsKC29jY3'
    'VycmVkX2F0GAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKb2NjdXJyZWRBdBIZ'
    'CghhY3Rvcl9pZBgFIAEoCVIHYWN0b3JJZBIWCgZyZWFzb24YBiABKAlSBnJlYXNvbhIfCgtpc1'
    '9yb2xsYmFjaxgHIAEoCFIKaXNSb2xsYmFjaxInCg9yb2xsYmFja19yZWFzb24YCCABKAlSDnJv'
    'bGxiYWNrUmVhc29u');

@$core.Deprecated('Use transitionPhaseRequestDescriptor instead')
const TransitionPhaseRequest$json = {
  '1': 'TransitionPhaseRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'target_phase', '3': 2, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'targetPhase'},
    {'1': 'evidence', '3': 3, '4': 1, '5': 11, '6': '.planning.v1.TransitionEvidence', '10': 'evidence'},
    {'1': 'actor_id', '3': 4, '4': 1, '5': 9, '10': 'actorId'},
    {'1': 'reason', '3': 5, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `TransitionPhaseRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transitionPhaseRequestDescriptor = $convert.base64Decode(
    'ChZUcmFuc2l0aW9uUGhhc2VSZXF1ZXN0Eh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZB'
    'I9Cgx0YXJnZXRfcGhhc2UYAiABKA4yGi5wbGFubmluZy52MS5Xb3JrZmxvd1BoYXNlUgt0YXJn'
    'ZXRQaGFzZRI7CghldmlkZW5jZRgDIAEoCzIfLnBsYW5uaW5nLnYxLlRyYW5zaXRpb25FdmlkZW'
    '5jZVIIZXZpZGVuY2USGQoIYWN0b3JfaWQYBCABKAlSB2FjdG9ySWQSFgoGcmVhc29uGAUgASgJ'
    'UgZyZWFzb24=');

@$core.Deprecated('Use transitionPhaseResponseDescriptor instead')
const TransitionPhaseResponse$json = {
  '1': 'TransitionPhaseResponse',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'previous_phase', '3': 2, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'previousPhase'},
    {'1': 'current_phase', '3': 3, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'currentPhase'},
    {'1': 'transition_record', '3': 4, '4': 1, '5': 11, '6': '.project.v1.PhaseTransitionHistoryEntry', '10': 'transitionRecord'},
    {'1': 'was_noop', '3': 5, '4': 1, '5': 8, '10': 'wasNoop'},
  ],
};

/// Descriptor for `TransitionPhaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transitionPhaseResponseDescriptor = $convert.base64Decode(
    'ChdUcmFuc2l0aW9uUGhhc2VSZXNwb25zZRIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SW'
    'QSQQoOcHJldmlvdXNfcGhhc2UYAiABKA4yGi5wbGFubmluZy52MS5Xb3JrZmxvd1BoYXNlUg1w'
    'cmV2aW91c1BoYXNlEj8KDWN1cnJlbnRfcGhhc2UYAyABKA4yGi5wbGFubmluZy52MS5Xb3JrZm'
    'xvd1BoYXNlUgxjdXJyZW50UGhhc2USVAoRdHJhbnNpdGlvbl9yZWNvcmQYBCABKAsyJy5wcm9q'
    'ZWN0LnYxLlBoYXNlVHJhbnNpdGlvbkhpc3RvcnlFbnRyeVIQdHJhbnNpdGlvblJlY29yZBIZCg'
    'h3YXNfbm9vcBgFIAEoCFIHd2FzTm9vcA==');

@$core.Deprecated('Use getPhaseStateRequestDescriptor instead')
const GetPhaseStateRequest$json = {
  '1': 'GetPhaseStateRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
  ],
};

/// Descriptor for `GetPhaseStateRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPhaseStateRequestDescriptor = $convert.base64Decode(
    'ChRHZXRQaGFzZVN0YXRlUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SWQ=');

@$core.Deprecated('Use getPhaseStateResponseDescriptor instead')
const GetPhaseStateResponse$json = {
  '1': 'GetPhaseStateResponse',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'current_phase', '3': 2, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'currentPhase'},
    {'1': 'phase_entered_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'phaseEnteredAt'},
    {'1': 'last_transition', '3': 4, '4': 1, '5': 11, '6': '.project.v1.PhaseTransitionHistoryEntry', '10': 'lastTransition'},
  ],
};

/// Descriptor for `GetPhaseStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPhaseStateResponseDescriptor = $convert.base64Decode(
    'ChVHZXRQaGFzZVN0YXRlUmVzcG9uc2USHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElkEj'
    '8KDWN1cnJlbnRfcGhhc2UYAiABKA4yGi5wbGFubmluZy52MS5Xb3JrZmxvd1BoYXNlUgxjdXJy'
    'ZW50UGhhc2USRAoQcGhhc2VfZW50ZXJlZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW'
    '1lc3RhbXBSDnBoYXNlRW50ZXJlZEF0ElAKD2xhc3RfdHJhbnNpdGlvbhgEIAEoCzInLnByb2pl'
    'Y3QudjEuUGhhc2VUcmFuc2l0aW9uSGlzdG9yeUVudHJ5Ug5sYXN0VHJhbnNpdGlvbg==');

@$core.Deprecated('Use listPhaseTransitionsRequestDescriptor instead')
const ListPhaseTransitionsRequest$json = {
  '1': 'ListPhaseTransitionsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `ListPhaseTransitionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPhaseTransitionsRequestDescriptor = $convert.base64Decode(
    'ChtMaXN0UGhhc2VUcmFuc2l0aW9uc1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvam'
    'VjdElkEk0KCnBhZ2luYXRpb24YAiABKAsyLS5wYWNrYWdlcy5hcGkudjEucGFnaW5hdGlvbi5Q'
    'YWdpbmF0aW9uUmVxdWVzdFIKcGFnaW5hdGlvbg==');

@$core.Deprecated('Use listPhaseTransitionsResponseDescriptor instead')
const ListPhaseTransitionsResponse$json = {
  '1': 'ListPhaseTransitionsResponse',
  '2': [
    {'1': 'transitions', '3': 1, '4': 3, '5': 11, '6': '.project.v1.PhaseTransitionHistoryEntry', '10': 'transitions'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.packages.api.v1.pagination.PaginationResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `ListPhaseTransitionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPhaseTransitionsResponseDescriptor = $convert.base64Decode(
    'ChxMaXN0UGhhc2VUcmFuc2l0aW9uc1Jlc3BvbnNlEkkKC3RyYW5zaXRpb25zGAEgAygLMicucH'
    'JvamVjdC52MS5QaGFzZVRyYW5zaXRpb25IaXN0b3J5RW50cnlSC3RyYW5zaXRpb25zEk4KCnBh'
    'Z2luYXRpb24YAiABKAsyLi5wYWNrYWdlcy5hcGkudjEucGFnaW5hdGlvbi5QYWdpbmF0aW9uUm'
    'VzcG9uc2VSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use validatePhaseReadinessRequestDescriptor instead')
const ValidatePhaseReadinessRequest$json = {
  '1': 'ValidatePhaseReadinessRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'target_phase', '3': 2, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'targetPhase'},
    {'1': 'evidence', '3': 3, '4': 1, '5': 11, '6': '.planning.v1.TransitionEvidence', '10': 'evidence'},
  ],
};

/// Descriptor for `ValidatePhaseReadinessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validatePhaseReadinessRequestDescriptor = $convert.base64Decode(
    'Ch1WYWxpZGF0ZVBoYXNlUmVhZGluZXNzUmVxdWVzdBIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm'
    '9qZWN0SWQSPQoMdGFyZ2V0X3BoYXNlGAIgASgOMhoucGxhbm5pbmcudjEuV29ya2Zsb3dQaGFz'
    'ZVILdGFyZ2V0UGhhc2USOwoIZXZpZGVuY2UYAyABKAsyHy5wbGFubmluZy52MS5UcmFuc2l0aW'
    '9uRXZpZGVuY2VSCGV2aWRlbmNl');

@$core.Deprecated('Use validatePhaseReadinessResponseDescriptor instead')
const ValidatePhaseReadinessResponse$json = {
  '1': 'ValidatePhaseReadinessResponse',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'current_phase', '3': 2, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'currentPhase'},
    {'1': 'target_phase', '3': 3, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'targetPhase'},
    {'1': 'is_valid', '3': 4, '4': 1, '5': 8, '10': 'isValid'},
    {'1': 'blocker_reasons', '3': 5, '4': 3, '5': 9, '10': 'blockerReasons'},
    {'1': 'can_transition_after', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'canTransitionAfter'},
  ],
};

/// Descriptor for `ValidatePhaseReadinessResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validatePhaseReadinessResponseDescriptor = $convert.base64Decode(
    'Ch5WYWxpZGF0ZVBoYXNlUmVhZGluZXNzUmVzcG9uc2USHQoKcHJvamVjdF9pZBgBIAEoCVIJcH'
    'JvamVjdElkEj8KDWN1cnJlbnRfcGhhc2UYAiABKA4yGi5wbGFubmluZy52MS5Xb3JrZmxvd1Bo'
    'YXNlUgxjdXJyZW50UGhhc2USPQoMdGFyZ2V0X3BoYXNlGAMgASgOMhoucGxhbm5pbmcudjEuV2'
    '9ya2Zsb3dQaGFzZVILdGFyZ2V0UGhhc2USGQoIaXNfdmFsaWQYBCABKAhSB2lzVmFsaWQSJwoP'
    'YmxvY2tlcl9yZWFzb25zGAUgAygJUg5ibG9ja2VyUmVhc29ucxJMChRjYW5fdHJhbnNpdGlvbl'
    '9hZnRlchgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSEmNhblRyYW5zaXRpb25B'
    'ZnRlcg==');

const $core.Map<$core.String, $core.dynamic> ProjectServiceBase$json = {
  '1': 'ProjectService',
  '2': [
    {'1': 'CreateProject', '2': '.project.v1.CreateProjectRequest', '3': '.project.v1.CreateProjectResponse'},
    {'1': 'GetProject', '2': '.project.v1.GetProjectRequest', '3': '.project.v1.GetProjectResponse'},
    {'1': 'ListProjects', '2': '.project.v1.ListProjectsRequest', '3': '.project.v1.ListProjectsResponse'},
    {'1': 'UpdateProject', '2': '.project.v1.UpdateProjectRequest', '3': '.project.v1.UpdateProjectResponse'},
    {'1': 'DeleteProject', '2': '.project.v1.DeleteProjectRequest', '3': '.project.v1.DeleteProjectResponse'},
    {'1': 'TransitionPhase', '2': '.project.v1.TransitionPhaseRequest', '3': '.project.v1.TransitionPhaseResponse'},
    {'1': 'GetPhaseState', '2': '.project.v1.GetPhaseStateRequest', '3': '.project.v1.GetPhaseStateResponse'},
    {'1': 'ListPhaseTransitions', '2': '.project.v1.ListPhaseTransitionsRequest', '3': '.project.v1.ListPhaseTransitionsResponse'},
    {'1': 'ValidatePhaseReadiness', '2': '.project.v1.ValidatePhaseReadinessRequest', '3': '.project.v1.ValidatePhaseReadinessResponse'},
  ],
};

@$core.Deprecated('Use projectServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> ProjectServiceBase$messageJson = {
  '.project.v1.CreateProjectRequest': CreateProjectRequest$json,
  '.project.v1.ProjectMetadata': ProjectMetadata$json,
  '.project.v1.CreateProjectResponse': CreateProjectResponse$json,
  '.project.v1.Project': Project$json,
  '.project.v1.Site': Site$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.project.v1.PhaseTransitionHistoryEntry': PhaseTransitionHistoryEntry$json,
  '.project.v1.GetProjectRequest': GetProjectRequest$json,
  '.project.v1.GetProjectResponse': GetProjectResponse$json,
  '.project.v1.ListProjectsRequest': ListProjectsRequest$json,
  '.packages.api.v1.pagination.PaginationRequest': $1.PaginationRequest$json,
  '.google.protobuf.FieldMask': $3.FieldMask$json,
  '.project.v1.ListProjectsResponse': ListProjectsResponse$json,
  '.packages.api.v1.pagination.PaginationResponse': $1.PaginationResponse$json,
  '.project.v1.UpdateProjectRequest': UpdateProjectRequest$json,
  '.project.v1.UpdateProjectResponse': UpdateProjectResponse$json,
  '.project.v1.DeleteProjectRequest': DeleteProjectRequest$json,
  '.project.v1.DeleteProjectResponse': DeleteProjectResponse$json,
  '.project.v1.TransitionPhaseRequest': TransitionPhaseRequest$json,
  '.planning.v1.TransitionEvidence': $2.TransitionEvidence$json,
  '.planning.v1.PlanningAcceptance': $2.PlanningAcceptance$json,
  '.planning.v1.LayoutApproval': $2.LayoutApproval$json,
  '.planning.v1.ElectricalSignoff': $2.ElectricalSignoff$json,
  '.planning.v1.TransmissionSignoff': $2.TransmissionSignoff$json,
  '.planning.v1.ReviewApproval': $2.ReviewApproval$json,
  '.planning.v1.StakeholderApproval': $2.StakeholderApproval$json,
  '.planning.v1.CommissioningConfirmation': $2.CommissioningConfirmation$json,
  '.project.v1.TransitionPhaseResponse': TransitionPhaseResponse$json,
  '.project.v1.GetPhaseStateRequest': GetPhaseStateRequest$json,
  '.project.v1.GetPhaseStateResponse': GetPhaseStateResponse$json,
  '.project.v1.ListPhaseTransitionsRequest': ListPhaseTransitionsRequest$json,
  '.project.v1.ListPhaseTransitionsResponse': ListPhaseTransitionsResponse$json,
  '.project.v1.ValidatePhaseReadinessRequest': ValidatePhaseReadinessRequest$json,
  '.project.v1.ValidatePhaseReadinessResponse': ValidatePhaseReadinessResponse$json,
};

/// Descriptor for `ProjectService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List projectServiceDescriptor = $convert.base64Decode(
    'Cg5Qcm9qZWN0U2VydmljZRJUCg1DcmVhdGVQcm9qZWN0EiAucHJvamVjdC52MS5DcmVhdGVQcm'
    '9qZWN0UmVxdWVzdBohLnByb2plY3QudjEuQ3JlYXRlUHJvamVjdFJlc3BvbnNlEksKCkdldFBy'
    'b2plY3QSHS5wcm9qZWN0LnYxLkdldFByb2plY3RSZXF1ZXN0Gh4ucHJvamVjdC52MS5HZXRQcm'
    '9qZWN0UmVzcG9uc2USUQoMTGlzdFByb2plY3RzEh8ucHJvamVjdC52MS5MaXN0UHJvamVjdHNS'
    'ZXF1ZXN0GiAucHJvamVjdC52MS5MaXN0UHJvamVjdHNSZXNwb25zZRJUCg1VcGRhdGVQcm9qZW'
    'N0EiAucHJvamVjdC52MS5VcGRhdGVQcm9qZWN0UmVxdWVzdBohLnByb2plY3QudjEuVXBkYXRl'
    'UHJvamVjdFJlc3BvbnNlElQKDURlbGV0ZVByb2plY3QSIC5wcm9qZWN0LnYxLkRlbGV0ZVByb2'
    'plY3RSZXF1ZXN0GiEucHJvamVjdC52MS5EZWxldGVQcm9qZWN0UmVzcG9uc2USWgoPVHJhbnNp'
    'dGlvblBoYXNlEiIucHJvamVjdC52MS5UcmFuc2l0aW9uUGhhc2VSZXF1ZXN0GiMucHJvamVjdC'
    '52MS5UcmFuc2l0aW9uUGhhc2VSZXNwb25zZRJUCg1HZXRQaGFzZVN0YXRlEiAucHJvamVjdC52'
    'MS5HZXRQaGFzZVN0YXRlUmVxdWVzdBohLnByb2plY3QudjEuR2V0UGhhc2VTdGF0ZVJlc3Bvbn'
    'NlEmkKFExpc3RQaGFzZVRyYW5zaXRpb25zEicucHJvamVjdC52MS5MaXN0UGhhc2VUcmFuc2l0'
    'aW9uc1JlcXVlc3QaKC5wcm9qZWN0LnYxLkxpc3RQaGFzZVRyYW5zaXRpb25zUmVzcG9uc2USbw'
    'oWVmFsaWRhdGVQaGFzZVJlYWRpbmVzcxIpLnByb2plY3QudjEuVmFsaWRhdGVQaGFzZVJlYWRp'
    'bmVzc1JlcXVlc3QaKi5wcm9qZWN0LnYxLlZhbGlkYXRlUGhhc2VSZWFkaW5lc3NSZXNwb25zZQ'
    '==');

