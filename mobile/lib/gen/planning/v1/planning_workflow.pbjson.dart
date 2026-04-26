//
//  Generated code. Do not modify.
//  source: planning/v1/planning_workflow.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../../google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use workflowPhaseDescriptor instead')
const WorkflowPhase$json = {
  '1': 'WorkflowPhase',
  '2': [
    {'1': 'WORKFLOW_PHASE_UNSPECIFIED', '2': 0},
    {'1': 'PLANNING', '2': 1},
    {'1': 'LAYOUT_READY', '2': 2},
    {'1': 'ELECTRICAL_READY', '2': 3},
    {'1': 'TRANSMISSION_READY', '2': 4},
    {'1': 'REVIEW_READY', '2': 5},
    {'1': 'APPROVED', '2': 6},
    {'1': 'COMMISSIONING_READY', '2': 7},
    {'1': 'ARCHIVED', '2': 8},
  ],
};

/// Descriptor for `WorkflowPhase`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workflowPhaseDescriptor = $convert.base64Decode(
    'Cg1Xb3JrZmxvd1BoYXNlEh4KGldPUktGTE9XX1BIQVNFX1VOU1BFQ0lGSUVEEAASDAoIUExBTk'
    '5JTkcQARIQCgxMQVlPVVRfUkVBRFkQAhIUChBFTEVDVFJJQ0FMX1JFQURZEAMSFgoSVFJBTlNN'
    'SVNTSU9OX1JFQURZEAQSEAoMUkVWSUVXX1JFQURZEAUSDAoIQVBQUk9WRUQQBhIXChNDT01NSV'
    'NTSU9OSU5HX1JFQURZEAcSDAoIQVJDSElWRUQQCA==');

@$core.Deprecated('Use transitionEvidenceDescriptor instead')
const TransitionEvidence$json = {
  '1': 'TransitionEvidence',
  '2': [
    {'1': 'planning_acceptance', '3': 1, '4': 1, '5': 11, '6': '.planning.v1.PlanningAcceptance', '9': 0, '10': 'planningAcceptance'},
    {'1': 'layout_approval', '3': 2, '4': 1, '5': 11, '6': '.planning.v1.LayoutApproval', '9': 0, '10': 'layoutApproval'},
    {'1': 'electrical_signoff', '3': 3, '4': 1, '5': 11, '6': '.planning.v1.ElectricalSignoff', '9': 0, '10': 'electricalSignoff'},
    {'1': 'transmission_signoff', '3': 4, '4': 1, '5': 11, '6': '.planning.v1.TransmissionSignoff', '9': 0, '10': 'transmissionSignoff'},
    {'1': 'review_approval', '3': 5, '4': 1, '5': 11, '6': '.planning.v1.ReviewApproval', '9': 0, '10': 'reviewApproval'},
    {'1': 'stakeholder_approval', '3': 6, '4': 1, '5': 11, '6': '.planning.v1.StakeholderApproval', '9': 0, '10': 'stakeholderApproval'},
    {'1': 'commissioning_confirmation', '3': 7, '4': 1, '5': 11, '6': '.planning.v1.CommissioningConfirmation', '9': 0, '10': 'commissioningConfirmation'},
  ],
  '8': [
    {'1': 'evidence_type'},
  ],
};

/// Descriptor for `TransitionEvidence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transitionEvidenceDescriptor = $convert.base64Decode(
    'ChJUcmFuc2l0aW9uRXZpZGVuY2USUgoTcGxhbm5pbmdfYWNjZXB0YW5jZRgBIAEoCzIfLnBsYW'
    '5uaW5nLnYxLlBsYW5uaW5nQWNjZXB0YW5jZUgAUhJwbGFubmluZ0FjY2VwdGFuY2USRgoPbGF5'
    'b3V0X2FwcHJvdmFsGAIgASgLMhsucGxhbm5pbmcudjEuTGF5b3V0QXBwcm92YWxIAFIObGF5b3'
    'V0QXBwcm92YWwSTwoSZWxlY3RyaWNhbF9zaWdub2ZmGAMgASgLMh4ucGxhbm5pbmcudjEuRWxl'
    'Y3RyaWNhbFNpZ25vZmZIAFIRZWxlY3RyaWNhbFNpZ25vZmYSVQoUdHJhbnNtaXNzaW9uX3NpZ2'
    '5vZmYYBCABKAsyIC5wbGFubmluZy52MS5UcmFuc21pc3Npb25TaWdub2ZmSABSE3RyYW5zbWlz'
    'c2lvblNpZ25vZmYSRgoPcmV2aWV3X2FwcHJvdmFsGAUgASgLMhsucGxhbm5pbmcudjEuUmV2aW'
    'V3QXBwcm92YWxIAFIOcmV2aWV3QXBwcm92YWwSVQoUc3Rha2Vob2xkZXJfYXBwcm92YWwYBiAB'
    'KAsyIC5wbGFubmluZy52MS5TdGFrZWhvbGRlckFwcHJvdmFsSABSE3N0YWtlaG9sZGVyQXBwcm'
    '92YWwSZwoaY29tbWlzc2lvbmluZ19jb25maXJtYXRpb24YByABKAsyJi5wbGFubmluZy52MS5D'
    'b21taXNzaW9uaW5nQ29uZmlybWF0aW9uSABSGWNvbW1pc3Npb25pbmdDb25maXJtYXRpb25CDw'
    'oNZXZpZGVuY2VfdHlwZQ==');

@$core.Deprecated('Use planningAcceptanceDescriptor instead')
const PlanningAcceptance$json = {
  '1': 'PlanningAcceptance',
  '2': [
    {'1': 'boundary_id', '3': 1, '4': 1, '5': 9, '10': 'boundaryId'},
    {'1': 'accepted_by_actor_id', '3': 2, '4': 1, '5': 9, '10': 'acceptedByActorId'},
    {'1': 'accepted_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'acceptedAt'},
    {'1': 'notes', '3': 4, '4': 1, '5': 9, '10': 'notes'},
  ],
};

/// Descriptor for `PlanningAcceptance`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List planningAcceptanceDescriptor = $convert.base64Decode(
    'ChJQbGFubmluZ0FjY2VwdGFuY2USHwoLYm91bmRhcnlfaWQYASABKAlSCmJvdW5kYXJ5SWQSLw'
    'oUYWNjZXB0ZWRfYnlfYWN0b3JfaWQYAiABKAlSEWFjY2VwdGVkQnlBY3RvcklkEjsKC2FjY2Vw'
    'dGVkX2F0GAMgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIKYWNjZXB0ZWRBdBIUCg'
    'Vub3RlcxgEIAEoCVIFbm90ZXM=');

@$core.Deprecated('Use layoutApprovalDescriptor instead')
const LayoutApproval$json = {
  '1': 'LayoutApproval',
  '2': [
    {'1': 'candidate_id', '3': 1, '4': 1, '5': 9, '10': 'candidateId'},
    {'1': 'ml_experiment_id', '3': 2, '4': 1, '5': 9, '10': 'mlExperimentId'},
    {'1': 'approved_by_actor_id', '3': 3, '4': 1, '5': 9, '10': 'approvedByActorId'},
    {'1': 'approved_at', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'approvedAt'},
    {'1': 'candidate_composite_score', '3': 5, '4': 1, '5': 1, '10': 'candidateCompositeScore'},
    {'1': 'selection_rationale', '3': 6, '4': 1, '5': 9, '10': 'selectionRationale'},
  ],
};

/// Descriptor for `LayoutApproval`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List layoutApprovalDescriptor = $convert.base64Decode(
    'Cg5MYXlvdXRBcHByb3ZhbBIhCgxjYW5kaWRhdGVfaWQYASABKAlSC2NhbmRpZGF0ZUlkEigKEG'
    '1sX2V4cGVyaW1lbnRfaWQYAiABKAlSDm1sRXhwZXJpbWVudElkEi8KFGFwcHJvdmVkX2J5X2Fj'
    'dG9yX2lkGAMgASgJUhFhcHByb3ZlZEJ5QWN0b3JJZBI7CgthcHByb3ZlZF9hdBgEIAEoCzIaLm'
    'dvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmFwcHJvdmVkQXQSOgoZY2FuZGlkYXRlX2NvbXBv'
    'c2l0ZV9zY29yZRgFIAEoAVIXY2FuZGlkYXRlQ29tcG9zaXRlU2NvcmUSLwoTc2VsZWN0aW9uX3'
    'JhdGlvbmFsZRgGIAEoCVISc2VsZWN0aW9uUmF0aW9uYWxl');

@$core.Deprecated('Use electricalSignoffDescriptor instead')
const ElectricalSignoff$json = {
  '1': 'ElectricalSignoff',
  '2': [
    {'1': 'layout_id', '3': 1, '4': 1, '5': 9, '10': 'layoutId'},
    {'1': 'electrical_analysis_id', '3': 2, '4': 1, '5': 9, '10': 'electricalAnalysisId'},
    {'1': 'validated_by_actor_id', '3': 3, '4': 1, '5': 9, '10': 'validatedByActorId'},
    {'1': 'validated_at', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'validatedAt'},
    {'1': 'violations', '3': 5, '4': 3, '5': 9, '10': 'violations'},
    {'1': 'electrical_feasibility_score', '3': 6, '4': 1, '5': 1, '10': 'electricalFeasibilityScore'},
  ],
};

/// Descriptor for `ElectricalSignoff`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List electricalSignoffDescriptor = $convert.base64Decode(
    'ChFFbGVjdHJpY2FsU2lnbm9mZhIbCglsYXlvdXRfaWQYASABKAlSCGxheW91dElkEjQKFmVsZW'
    'N0cmljYWxfYW5hbHlzaXNfaWQYAiABKAlSFGVsZWN0cmljYWxBbmFseXNpc0lkEjEKFXZhbGlk'
    'YXRlZF9ieV9hY3Rvcl9pZBgDIAEoCVISdmFsaWRhdGVkQnlBY3RvcklkEj0KDHZhbGlkYXRlZF'
    '9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSC3ZhbGlkYXRlZEF0Eh4KCnZp'
    'b2xhdGlvbnMYBSADKAlSCnZpb2xhdGlvbnMSQAocZWxlY3RyaWNhbF9mZWFzaWJpbGl0eV9zY2'
    '9yZRgGIAEoAVIaZWxlY3RyaWNhbEZlYXNpYmlsaXR5U2NvcmU=');

@$core.Deprecated('Use transmissionSignoffDescriptor instead')
const TransmissionSignoff$json = {
  '1': 'TransmissionSignoff',
  '2': [
    {'1': 'electrical_layout_id', '3': 1, '4': 1, '5': 9, '10': 'electricalLayoutId'},
    {'1': 'transmission_route_id', '3': 2, '4': 1, '5': 9, '10': 'transmissionRouteId'},
    {'1': 'approved_by_actor_id', '3': 3, '4': 1, '5': 9, '10': 'approvedByActorId'},
    {'1': 'approved_at', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'approvedAt'},
    {'1': 'protection_devices', '3': 5, '4': 3, '5': 9, '10': 'protectionDevices'},
    {'1': 'fault_isolation_points', '3': 6, '4': 1, '5': 5, '10': 'faultIsolationPoints'},
  ],
};

/// Descriptor for `TransmissionSignoff`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transmissionSignoffDescriptor = $convert.base64Decode(
    'ChNUcmFuc21pc3Npb25TaWdub2ZmEjAKFGVsZWN0cmljYWxfbGF5b3V0X2lkGAEgASgJUhJlbG'
    'VjdHJpY2FsTGF5b3V0SWQSMgoVdHJhbnNtaXNzaW9uX3JvdXRlX2lkGAIgASgJUhN0cmFuc21p'
    'c3Npb25Sb3V0ZUlkEi8KFGFwcHJvdmVkX2J5X2FjdG9yX2lkGAMgASgJUhFhcHByb3ZlZEJ5QW'
    'N0b3JJZBI7CgthcHByb3ZlZF9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CmFwcHJvdmVkQXQSLQoScHJvdGVjdGlvbl9kZXZpY2VzGAUgAygJUhFwcm90ZWN0aW9uRGV2aW'
    'NlcxI0ChZmYXVsdF9pc29sYXRpb25fcG9pbnRzGAYgASgFUhRmYXVsdElzb2xhdGlvblBvaW50'
    'cw==');

@$core.Deprecated('Use reviewApprovalDescriptor instead')
const ReviewApproval$json = {
  '1': 'ReviewApproval',
  '2': [
    {'1': 'transmission_route_id', '3': 1, '4': 1, '5': 9, '10': 'transmissionRouteId'},
    {'1': 'lod_400_checklist_id', '3': 2, '4': 1, '5': 9, '10': 'lod400ChecklistId'},
    {'1': 'reviewed_by_actor_id', '3': 3, '4': 1, '5': 9, '10': 'reviewedByActorId'},
    {'1': 'reviewed_at', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'reviewedAt'},
    {'1': 'mandatory_items_verified', '3': 5, '4': 1, '5': 5, '10': 'mandatoryItemsVerified'},
    {'1': 'blockers', '3': 6, '4': 3, '5': 9, '10': 'blockers'},
    {'1': 'quality_score', '3': 7, '4': 1, '5': 1, '10': 'qualityScore'},
  ],
};

/// Descriptor for `ReviewApproval`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reviewApprovalDescriptor = $convert.base64Decode(
    'Cg5SZXZpZXdBcHByb3ZhbBIyChV0cmFuc21pc3Npb25fcm91dGVfaWQYASABKAlSE3RyYW5zbW'
    'lzc2lvblJvdXRlSWQSLwoUbG9kXzQwMF9jaGVja2xpc3RfaWQYAiABKAlSEWxvZDQwMENoZWNr'
    'bGlzdElkEi8KFHJldmlld2VkX2J5X2FjdG9yX2lkGAMgASgJUhFyZXZpZXdlZEJ5QWN0b3JJZB'
    'I7CgtyZXZpZXdlZF9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnJldmll'
    'd2VkQXQSOAoYbWFuZGF0b3J5X2l0ZW1zX3ZlcmlmaWVkGAUgASgFUhZtYW5kYXRvcnlJdGVtc1'
    'ZlcmlmaWVkEhoKCGJsb2NrZXJzGAYgAygJUghibG9ja2VycxIjCg1xdWFsaXR5X3Njb3JlGAcg'
    'ASgBUgxxdWFsaXR5U2NvcmU=');

@$core.Deprecated('Use stakeholderApprovalDescriptor instead')
const StakeholderApproval$json = {
  '1': 'StakeholderApproval',
  '2': [
    {'1': 'review_approved_layout_id', '3': 1, '4': 1, '5': 9, '10': 'reviewApprovedLayoutId'},
    {'1': 'approved_by_actor_id', '3': 2, '4': 1, '5': 9, '10': 'approvedByActorId'},
    {'1': 'actor_role', '3': 3, '4': 1, '5': 9, '10': 'actorRole'},
    {'1': 'approved_at', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'approvedAt'},
    {'1': 'approval_notes', '3': 5, '4': 1, '5': 9, '10': 'approvalNotes'},
  ],
};

/// Descriptor for `StakeholderApproval`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stakeholderApprovalDescriptor = $convert.base64Decode(
    'ChNTdGFrZWhvbGRlckFwcHJvdmFsEjkKGXJldmlld19hcHByb3ZlZF9sYXlvdXRfaWQYASABKA'
    'lSFnJldmlld0FwcHJvdmVkTGF5b3V0SWQSLwoUYXBwcm92ZWRfYnlfYWN0b3JfaWQYAiABKAlS'
    'EWFwcHJvdmVkQnlBY3RvcklkEh0KCmFjdG9yX3JvbGUYAyABKAlSCWFjdG9yUm9sZRI7CgthcH'
    'Byb3ZlZF9hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCmFwcHJvdmVkQXQS'
    'JQoOYXBwcm92YWxfbm90ZXMYBSABKAlSDWFwcHJvdmFsTm90ZXM=');

@$core.Deprecated('Use commissioningConfirmationDescriptor instead')
const CommissioningConfirmation$json = {
  '1': 'CommissioningConfirmation',
  '2': [
    {'1': 'approved_project_id', '3': 1, '4': 1, '5': 9, '10': 'approvedProjectId'},
    {'1': 'twin_id', '3': 2, '4': 1, '5': 9, '10': 'twinId'},
    {'1': 'provisioned_by_actor_id', '3': 3, '4': 1, '5': 9, '10': 'provisionedByActorId'},
    {'1': 'provisioned_at', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'provisionedAt'},
    {'1': 'asset_identity_links', '3': 5, '4': 1, '5': 5, '10': 'assetIdentityLinks'},
  ],
};

/// Descriptor for `CommissioningConfirmation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List commissioningConfirmationDescriptor = $convert.base64Decode(
    'ChlDb21taXNzaW9uaW5nQ29uZmlybWF0aW9uEi4KE2FwcHJvdmVkX3Byb2plY3RfaWQYASABKA'
    'lSEWFwcHJvdmVkUHJvamVjdElkEhcKB3R3aW5faWQYAiABKAlSBnR3aW5JZBI1Chdwcm92aXNp'
    'b25lZF9ieV9hY3Rvcl9pZBgDIAEoCVIUcHJvdmlzaW9uZWRCeUFjdG9ySWQSQQoOcHJvdmlzaW'
    '9uZWRfYXQYBCABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg1wcm92aXNpb25lZEF0'
    'EjAKFGFzc2V0X2lkZW50aXR5X2xpbmtzGAUgASgFUhJhc3NldElkZW50aXR5TGlua3M=');

@$core.Deprecated('Use phaseTransitionDescriptor instead')
const PhaseTransition$json = {
  '1': 'PhaseTransition',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'from_phase', '3': 3, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'fromPhase'},
    {'1': 'to_phase', '3': 4, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'toPhase'},
    {'1': 'evidence', '3': 5, '4': 1, '5': 11, '6': '.planning.v1.TransitionEvidence', '10': 'evidence'},
    {'1': 'occurred_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'occurredAt'},
    {'1': 'actor_id', '3': 7, '4': 1, '5': 9, '10': 'actorId'},
    {'1': 'reason', '3': 8, '4': 1, '5': 9, '10': 'reason'},
    {'1': 'is_rollback', '3': 9, '4': 1, '5': 8, '10': 'isRollback'},
    {'1': 'rollback_reason', '3': 10, '4': 1, '5': 9, '10': 'rollbackReason'},
  ],
};

/// Descriptor for `PhaseTransition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phaseTransitionDescriptor = $convert.base64Decode(
    'Cg9QaGFzZVRyYW5zaXRpb24SDgoCaWQYASABKAlSAmlkEh0KCnByb2plY3RfaWQYAiABKAlSCX'
    'Byb2plY3RJZBI5Cgpmcm9tX3BoYXNlGAMgASgOMhoucGxhbm5pbmcudjEuV29ya2Zsb3dQaGFz'
    'ZVIJZnJvbVBoYXNlEjUKCHRvX3BoYXNlGAQgASgOMhoucGxhbm5pbmcudjEuV29ya2Zsb3dQaG'
    'FzZVIHdG9QaGFzZRI7CghldmlkZW5jZRgFIAEoCzIfLnBsYW5uaW5nLnYxLlRyYW5zaXRpb25F'
    'dmlkZW5jZVIIZXZpZGVuY2USOwoLb2NjdXJyZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idW'
    'YuVGltZXN0YW1wUgpvY2N1cnJlZEF0EhkKCGFjdG9yX2lkGAcgASgJUgdhY3RvcklkEhYKBnJl'
    'YXNvbhgIIAEoCVIGcmVhc29uEh8KC2lzX3JvbGxiYWNrGAkgASgIUgppc1JvbGxiYWNrEicKD3'
    'JvbGxiYWNrX3JlYXNvbhgKIAEoCVIOcm9sbGJhY2tSZWFzb24=');

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
    {'1': 'transition_record', '3': 4, '4': 1, '5': 11, '6': '.planning.v1.PhaseTransition', '10': 'transitionRecord'},
    {'1': 'was_noop', '3': 5, '4': 1, '5': 8, '10': 'wasNoop'},
  ],
};

/// Descriptor for `TransitionPhaseResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transitionPhaseResponseDescriptor = $convert.base64Decode(
    'ChdUcmFuc2l0aW9uUGhhc2VSZXNwb25zZRIdCgpwcm9qZWN0X2lkGAEgASgJUglwcm9qZWN0SW'
    'QSQQoOcHJldmlvdXNfcGhhc2UYAiABKA4yGi5wbGFubmluZy52MS5Xb3JrZmxvd1BoYXNlUg1w'
    'cmV2aW91c1BoYXNlEj8KDWN1cnJlbnRfcGhhc2UYAyABKA4yGi5wbGFubmluZy52MS5Xb3JrZm'
    'xvd1BoYXNlUgxjdXJyZW50UGhhc2USSQoRdHJhbnNpdGlvbl9yZWNvcmQYBCABKAsyHC5wbGFu'
    'bmluZy52MS5QaGFzZVRyYW5zaXRpb25SEHRyYW5zaXRpb25SZWNvcmQSGQoId2FzX25vb3AYBS'
    'ABKAhSB3dhc05vb3A=');

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
    {'1': 'last_transition', '3': 4, '4': 1, '5': 11, '6': '.planning.v1.PhaseTransition', '10': 'lastTransition'},
  ],
};

/// Descriptor for `GetPhaseStateResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPhaseStateResponseDescriptor = $convert.base64Decode(
    'ChVHZXRQaGFzZVN0YXRlUmVzcG9uc2USHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvamVjdElkEj'
    '8KDWN1cnJlbnRfcGhhc2UYAiABKA4yGi5wbGFubmluZy52MS5Xb3JrZmxvd1BoYXNlUgxjdXJy'
    'ZW50UGhhc2USRAoQcGhhc2VfZW50ZXJlZF9hdBgDIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW'
    '1lc3RhbXBSDnBoYXNlRW50ZXJlZEF0EkUKD2xhc3RfdHJhbnNpdGlvbhgEIAEoCzIcLnBsYW5u'
    'aW5nLnYxLlBoYXNlVHJhbnNpdGlvblIObGFzdFRyYW5zaXRpb24=');

@$core.Deprecated('Use listPhaseTransitionsRequestDescriptor instead')
const ListPhaseTransitionsRequest$json = {
  '1': 'ListPhaseTransitionsRequest',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'page_token', '3': 3, '4': 1, '5': 9, '10': 'pageToken'},
  ],
};

/// Descriptor for `ListPhaseTransitionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPhaseTransitionsRequestDescriptor = $convert.base64Decode(
    'ChtMaXN0UGhhc2VUcmFuc2l0aW9uc1JlcXVlc3QSHQoKcHJvamVjdF9pZBgBIAEoCVIJcHJvam'
    'VjdElkEhsKCXBhZ2Vfc2l6ZRgCIAEoBVIIcGFnZVNpemUSHQoKcGFnZV90b2tlbhgDIAEoCVIJ'
    'cGFnZVRva2Vu');

@$core.Deprecated('Use listPhaseTransitionsResponseDescriptor instead')
const ListPhaseTransitionsResponse$json = {
  '1': 'ListPhaseTransitionsResponse',
  '2': [
    {'1': 'transitions', '3': 1, '4': 3, '5': 11, '6': '.planning.v1.PhaseTransition', '10': 'transitions'},
    {'1': 'next_page_token', '3': 2, '4': 1, '5': 9, '10': 'nextPageToken'},
  ],
};

/// Descriptor for `ListPhaseTransitionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPhaseTransitionsResponseDescriptor = $convert.base64Decode(
    'ChxMaXN0UGhhc2VUcmFuc2l0aW9uc1Jlc3BvbnNlEj4KC3RyYW5zaXRpb25zGAEgAygLMhwucG'
    'xhbm5pbmcudjEuUGhhc2VUcmFuc2l0aW9uUgt0cmFuc2l0aW9ucxImCg9uZXh0X3BhZ2VfdG9r'
    'ZW4YAiABKAlSDW5leHRQYWdlVG9rZW4=');

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

@$core.Deprecated('Use workflowStateDescriptor instead')
const WorkflowState$json = {
  '1': 'WorkflowState',
  '2': [
    {'1': 'project_id', '3': 1, '4': 1, '5': 9, '10': 'projectId'},
    {'1': 'current_phase', '3': 2, '4': 1, '5': 14, '6': '.planning.v1.WorkflowPhase', '10': 'currentPhase'},
    {'1': 'phase_entered_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'phaseEnteredAt'},
    {'1': 'total_transitions', '3': 4, '4': 1, '5': 5, '10': 'totalTransitions'},
    {'1': 'active_blockers', '3': 5, '4': 3, '5': 9, '10': 'activeBlockers'},
    {'1': 'actor_blocked_since', '3': 6, '4': 1, '5': 9, '10': 'actorBlockedSince'},
  ],
};

/// Descriptor for `WorkflowState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workflowStateDescriptor = $convert.base64Decode(
    'Cg1Xb3JrZmxvd1N0YXRlEh0KCnByb2plY3RfaWQYASABKAlSCXByb2plY3RJZBI/Cg1jdXJyZW'
    '50X3BoYXNlGAIgASgOMhoucGxhbm5pbmcudjEuV29ya2Zsb3dQaGFzZVIMY3VycmVudFBoYXNl'
    'EkQKEHBoYXNlX2VudGVyZWRfYXQYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    '5waGFzZUVudGVyZWRBdBIrChF0b3RhbF90cmFuc2l0aW9ucxgEIAEoBVIQdG90YWxUcmFuc2l0'
    'aW9ucxInCg9hY3RpdmVfYmxvY2tlcnMYBSADKAlSDmFjdGl2ZUJsb2NrZXJzEi4KE2FjdG9yX2'
    'Jsb2NrZWRfc2luY2UYBiABKAlSEWFjdG9yQmxvY2tlZFNpbmNl');

const $core.Map<$core.String, $core.dynamic> PlanningWorkflowServiceBase$json = {
  '1': 'PlanningWorkflowService',
  '2': [
    {'1': 'TransitionPhase', '2': '.planning.v1.TransitionPhaseRequest', '3': '.planning.v1.TransitionPhaseResponse'},
    {'1': 'GetPhaseState', '2': '.planning.v1.GetPhaseStateRequest', '3': '.planning.v1.GetPhaseStateResponse'},
    {'1': 'ListPhaseTransitions', '2': '.planning.v1.ListPhaseTransitionsRequest', '3': '.planning.v1.ListPhaseTransitionsResponse'},
    {'1': 'ValidatePhaseReadiness', '2': '.planning.v1.ValidatePhaseReadinessRequest', '3': '.planning.v1.ValidatePhaseReadinessResponse'},
  ],
};

@$core.Deprecated('Use planningWorkflowServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> PlanningWorkflowServiceBase$messageJson = {
  '.planning.v1.TransitionPhaseRequest': TransitionPhaseRequest$json,
  '.planning.v1.TransitionEvidence': TransitionEvidence$json,
  '.planning.v1.PlanningAcceptance': PlanningAcceptance$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.planning.v1.LayoutApproval': LayoutApproval$json,
  '.planning.v1.ElectricalSignoff': ElectricalSignoff$json,
  '.planning.v1.TransmissionSignoff': TransmissionSignoff$json,
  '.planning.v1.ReviewApproval': ReviewApproval$json,
  '.planning.v1.StakeholderApproval': StakeholderApproval$json,
  '.planning.v1.CommissioningConfirmation': CommissioningConfirmation$json,
  '.planning.v1.TransitionPhaseResponse': TransitionPhaseResponse$json,
  '.planning.v1.PhaseTransition': PhaseTransition$json,
  '.planning.v1.GetPhaseStateRequest': GetPhaseStateRequest$json,
  '.planning.v1.GetPhaseStateResponse': GetPhaseStateResponse$json,
  '.planning.v1.ListPhaseTransitionsRequest': ListPhaseTransitionsRequest$json,
  '.planning.v1.ListPhaseTransitionsResponse': ListPhaseTransitionsResponse$json,
  '.planning.v1.ValidatePhaseReadinessRequest': ValidatePhaseReadinessRequest$json,
  '.planning.v1.ValidatePhaseReadinessResponse': ValidatePhaseReadinessResponse$json,
};

/// Descriptor for `PlanningWorkflowService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List planningWorkflowServiceDescriptor = $convert.base64Decode(
    'ChdQbGFubmluZ1dvcmtmbG93U2VydmljZRJcCg9UcmFuc2l0aW9uUGhhc2USIy5wbGFubmluZy'
    '52MS5UcmFuc2l0aW9uUGhhc2VSZXF1ZXN0GiQucGxhbm5pbmcudjEuVHJhbnNpdGlvblBoYXNl'
    'UmVzcG9uc2USVgoNR2V0UGhhc2VTdGF0ZRIhLnBsYW5uaW5nLnYxLkdldFBoYXNlU3RhdGVSZX'
    'F1ZXN0GiIucGxhbm5pbmcudjEuR2V0UGhhc2VTdGF0ZVJlc3BvbnNlEmsKFExpc3RQaGFzZVRy'
    'YW5zaXRpb25zEigucGxhbm5pbmcudjEuTGlzdFBoYXNlVHJhbnNpdGlvbnNSZXF1ZXN0GikucG'
    'xhbm5pbmcudjEuTGlzdFBoYXNlVHJhbnNpdGlvbnNSZXNwb25zZRJxChZWYWxpZGF0ZVBoYXNl'
    'UmVhZGluZXNzEioucGxhbm5pbmcudjEuVmFsaWRhdGVQaGFzZVJlYWRpbmVzc1JlcXVlc3QaKy'
    '5wbGFubmluZy52MS5WYWxpZGF0ZVBoYXNlUmVhZGluZXNzUmVzcG9uc2U=');

