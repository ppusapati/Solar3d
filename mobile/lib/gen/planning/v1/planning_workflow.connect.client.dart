//
//  Generated code. Do not modify.
//  source: planning/v1/planning_workflow.proto
//

import "package:connectrpc/connect.dart" as connect;
import "planning_workflow.pb.dart" as planningv1planning_workflow;
import "planning_workflow.connect.spec.dart" as specs;

/// PlanningWorkflowService manages transitions through the planning, design,
/// validation, and approval workflow phases for solar projects.
/// The workflow is deterministic and sequential: projects progress from Planning
/// through LayoutReady, ElectricalReady, TransmissionReady, ReviewReady, Approved,
/// and finally CommissioningReady. Each transition is gated by predecessor phase
/// acceptance and validated evidence payloads.
extension type PlanningWorkflowServiceClient (connect.Transport _transport) {
  /// TransitionPhase transitions a project from its current phase to a new phase.
  /// The transition is idempotent: if already in the target phase, returns success
  /// with a "no-op" transition record. Backward transitions (rollback) are allowed
  /// only for phases before CommissioningReady.
  Future<planningv1planning_workflow.TransitionPhaseResponse> transitionPhase(
    planningv1planning_workflow.TransitionPhaseRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PlanningWorkflowService.transitionPhase,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// GetPhaseState retrieves the current phase and transition history for a project.
  Future<planningv1planning_workflow.GetPhaseStateResponse> getPhaseState(
    planningv1planning_workflow.GetPhaseStateRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PlanningWorkflowService.getPhaseState,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ListPhaseTransitions returns all phase transitions for a project (immutable history).
  Future<planningv1planning_workflow.ListPhaseTransitionsResponse> listPhaseTransitions(
    planningv1planning_workflow.ListPhaseTransitionsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PlanningWorkflowService.listPhaseTransitions,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// ValidatePhaseReadiness returns blocker reasons if a phase transition would fail,
  /// without actually performing the transition. Useful for UX validation.
  Future<planningv1planning_workflow.ValidatePhaseReadinessResponse> validatePhaseReadiness(
    planningv1planning_workflow.ValidatePhaseReadinessRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.PlanningWorkflowService.validatePhaseReadiness,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
