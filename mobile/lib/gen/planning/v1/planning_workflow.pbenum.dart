//
//  Generated code. Do not modify.
//  source: planning/v1/planning_workflow.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class WorkflowPhase extends $pb.ProtobufEnum {
  static const WorkflowPhase WORKFLOW_PHASE_UNSPECIFIED = WorkflowPhase._(0, _omitEnumNames ? '' : 'WORKFLOW_PHASE_UNSPECIFIED');
  /// PLANNING: Initial state. Project captures boundary and planning parameters.
  /// No validation or synthesis has occurred yet.
  /// Gate: No predecessors. User provides planning inputs.
  static const WorkflowPhase PLANNING = WorkflowPhase._(1, _omitEnumNames ? '' : 'PLANNING');
  /// LAYOUT_READY: ML/algorithm phase complete. Candidate set synthesized, ranked,
  /// and a preferred candidate selected or approved by user.
  /// Gate: Requires PLANNING acceptance + ML candidate approval.
  static const WorkflowPhase LAYOUT_READY = WorkflowPhase._(2, _omitEnumNames ? '' : 'LAYOUT_READY');
  /// ELECTRICAL_READY: Electrical validation complete. Layout passed electrical
  /// feasibility checks (stringing, transformer, cable, voltage constraints).
  /// Gate: Requires LAYOUT_READY acceptance + electrical service sign-off.
  static const WorkflowPhase ELECTRICAL_READY = WorkflowPhase._(3, _omitEnumNames ? '' : 'ELECTRICAL_READY');
  /// TRANSMISSION_READY: Transmission routing complete. Route anchors, protection
  /// devices, and fault isolation validated. No conflicts with electrical grid.
  /// Gate: Requires ELECTRICAL_READY acceptance + transmission service sign-off.
  static const WorkflowPhase TRANSMISSION_READY = WorkflowPhase._(4, _omitEnumNames ? '' : 'TRANSMISSION_READY');
  /// REVIEW_READY: LOD 400 detail checklist cleared and quality gate passed.
  /// All mandatory asset-class requirements verified.
  /// Gate: Requires TRANSMISSION_READY acceptance + LOD gate pass.
  static const WorkflowPhase REVIEW_READY = WorkflowPhase._(5, _omitEnumNames ? '' : 'REVIEW_READY');
  /// APPROVED: Project approved for commissioning handover. All stakeholder
  /// signoffs collected. Ready for twin provisioning and asset linkage.
  /// Gate: Requires REVIEW_READY acceptance + reviewer/manager approval.
  static const WorkflowPhase APPROVED = WorkflowPhase._(6, _omitEnumNames ? '' : 'APPROVED');
  /// COMMISSIONING_READY: Twin provisioned, asset identities linked, commissioning
  /// handover complete. System transitions to operational state.
  /// Gate: Requires APPROVED acceptance + twin provisioning confirmation.
  static const WorkflowPhase COMMISSIONING_READY = WorkflowPhase._(7, _omitEnumNames ? '' : 'COMMISSIONING_READY');
  /// ARCHIVED: Project closed (past final, no longer active planning). Cannot be
  /// transitioned out of without explicit override.
  static const WorkflowPhase ARCHIVED = WorkflowPhase._(8, _omitEnumNames ? '' : 'ARCHIVED');

  static const $core.List<WorkflowPhase> values = <WorkflowPhase> [
    WORKFLOW_PHASE_UNSPECIFIED,
    PLANNING,
    LAYOUT_READY,
    ELECTRICAL_READY,
    TRANSMISSION_READY,
    REVIEW_READY,
    APPROVED,
    COMMISSIONING_READY,
    ARCHIVED,
  ];

  static final $core.Map<$core.int, WorkflowPhase> _byValue = $pb.ProtobufEnum.initByValue(values);
  static WorkflowPhase? valueOf($core.int value) => _byValue[value];

  const WorkflowPhase._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
