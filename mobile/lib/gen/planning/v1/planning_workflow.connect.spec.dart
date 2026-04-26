//
//  Generated code. Do not modify.
//  source: planning/v1/planning_workflow.proto
//

import "package:connectrpc/connect.dart" as connect;
import "planning_workflow.pb.dart" as planningv1planning_workflow;

/// PlanningWorkflowService manages transitions through the planning, design,
/// validation, and approval workflow phases for solar projects.
/// The workflow is deterministic and sequential: projects progress from Planning
/// through LayoutReady, ElectricalReady, TransmissionReady, ReviewReady, Approved,
/// and finally CommissioningReady. Each transition is gated by predecessor phase
/// acceptance and validated evidence payloads.
abstract final class PlanningWorkflowService {
  /// Fully-qualified name of the PlanningWorkflowService service.
  static const name = 'planning.v1.PlanningWorkflowService';

  /// TransitionPhase transitions a project from its current phase to a new phase.
  /// The transition is idempotent: if already in the target phase, returns success
  /// with a "no-op" transition record. Backward transitions (rollback) are allowed
  /// only for phases before CommissioningReady.
  static const transitionPhase = connect.Spec(
    '/$name/TransitionPhase',
    connect.StreamType.unary,
    planningv1planning_workflow.TransitionPhaseRequest.new,
    planningv1planning_workflow.TransitionPhaseResponse.new,
  );

  /// GetPhaseState retrieves the current phase and transition history for a project.
  static const getPhaseState = connect.Spec(
    '/$name/GetPhaseState',
    connect.StreamType.unary,
    planningv1planning_workflow.GetPhaseStateRequest.new,
    planningv1planning_workflow.GetPhaseStateResponse.new,
  );

  /// ListPhaseTransitions returns all phase transitions for a project (immutable history).
  static const listPhaseTransitions = connect.Spec(
    '/$name/ListPhaseTransitions',
    connect.StreamType.unary,
    planningv1planning_workflow.ListPhaseTransitionsRequest.new,
    planningv1planning_workflow.ListPhaseTransitionsResponse.new,
  );

  /// ValidatePhaseReadiness returns blocker reasons if a phase transition would fail,
  /// without actually performing the transition. Useful for UX validation.
  static const validatePhaseReadiness = connect.Spec(
    '/$name/ValidatePhaseReadiness',
    connect.StreamType.unary,
    planningv1planning_workflow.ValidatePhaseReadinessRequest.new,
    planningv1planning_workflow.ValidatePhaseReadinessResponse.new,
  );
}
