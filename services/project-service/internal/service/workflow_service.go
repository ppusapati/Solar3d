package service

import (
	"context"
	"fmt"
	"strings"
	"time"

	"solar3d/compute/planning"
	"p9e.in/samavaya/solar3d/project-service/internal/domain"

	"github.com/google/uuid"
)

// TransitionPhaseRequest input for phase transitions.
type TransitionPhaseRequest struct {
	ProjectID   uuid.UUID
	TargetPhase planning.WorkflowPhase
	Evidence    planning.Evidence
	ActorID     string
	Reason      string
	// IncidentReason records why a rejected transition occurred. When provided,
	// it is persisted as a blocker for auditability and controlled remediation.
	IncidentReason string
}

// RollbackPhaseRequest input for controlled rollback transitions.
type RollbackPhaseRequest struct {
	ProjectID      uuid.UUID
	TargetPhase    planning.WorkflowPhase
	ActorID        string
	Reason         string
	IncidentReason string
}

// TransitionPhaseResult output from phase transitions.
type TransitionPhaseResult struct {
	ProjectID        uuid.UUID
	PreviousPhase    planning.WorkflowPhase
	CurrentPhase     planning.WorkflowPhase
	TransitionRecord *domain.PhaseTransitionRecord
	WasNoop          bool
}

// TransitionPhase transitions a project to a new workflow phase.
// Enforces phase sequence, validates evidence, and rejects if blockers exist.
func (s *ProjectService) TransitionPhase(ctx context.Context, req *TransitionPhaseRequest) (*TransitionPhaseResult, error) {
	if req.ProjectID == uuid.Nil {
		return nil, fmt.Errorf("%w: project_id required", ErrInvalidInput)
	}
	if req.ActorID == "" {
		return nil, fmt.Errorf("%w: actor_id required", ErrInvalidInput)
	}

	// Fetch project
	project, err := s.repo.GetProject(ctx, req.ProjectID)
	if err != nil {
		return nil, fmt.Errorf("transition phase: %w", err)
	}

	// Validate transition is legal
	validator := planning.NewWorkflowValidator(project.WorkflowState)
	blockers, valid := validator.ValidateTransition(req.TargetPhase, req.Evidence)
	if !valid && req.TargetPhase != project.WorkflowState.CurrentPhase {
		incident := strings.TrimSpace(req.IncidentReason)
		if incident == "" {
			incident = fmt.Sprintf("transition rejected: %s -> %s (%v)", project.WorkflowState.CurrentPhase, req.TargetPhase, blockers)
		}
		planning.SetBlocker(project.WorkflowState, incident, req.ActorID)
		if err := s.repo.UpdateProject(ctx, project); err != nil {
			return nil, fmt.Errorf("transition phase: persist rejection incident: %w", err)
		}
		return nil, fmt.Errorf("%w: %v", ErrInvalidInput, blockers)
	}

	// Idempotent: already in target phase
	if project.WorkflowState.CurrentPhase == req.TargetPhase {
		s.logger.Info().
			Str("project_id", req.ProjectID.String()).
			Str("phase", req.TargetPhase.String()).
			Msg("project already in target phase (idempotent)")
		return &TransitionPhaseResult{
			ProjectID:        req.ProjectID,
			PreviousPhase:    project.WorkflowState.CurrentPhase,
			CurrentPhase:     project.WorkflowState.CurrentPhase,
			TransitionRecord: nil,
			WasNoop:          true,
		}, nil
	}

	// Execute transition
	record, err := planning.ExecuteTransition(
		project.WorkflowState,
		req.TargetPhase,
		req.Evidence,
		req.ActorID,
		req.Reason,
		false, // not a rollback
	)
	if err != nil {
		s.logger.Error().Err(err).
			Str("project_id", req.ProjectID.String()).
			Str("from_phase", project.WorkflowState.CurrentPhase.String()).
			Str("to_phase", req.TargetPhase.String()).
			Msg("phase transition failed")
		return nil, fmt.Errorf("transition phase: %w", err)
	}

	// Persist updated project
	if err := s.repo.UpdateProject(ctx, project); err != nil {
		s.logger.Error().Err(err).
			Str("project_id", req.ProjectID.String()).
			Msg("failed to persist project after workflow transition")
		return nil, fmt.Errorf("transition phase: persist: %w", err)
	}

	// Convert internal record to domain record
	domainRecord := &domain.PhaseTransitionRecord{
		ID:             uuid.New().String(),
		ProjectID:      req.ProjectID,
		FromPhase:      record.FromPhase,
		ToPhase:        record.ToPhase,
		OccurredAt:     record.OccurredAt,
		ActorID:        record.ActorID,
		Reason:         record.Reason,
		IsRollback:     record.IsRollback,
		RollbackReason: record.RollbackReason,
	}

	s.logger.Info().
		Str("project_id", req.ProjectID.String()).
		Str("from_phase", record.FromPhase.String()).
		Str("to_phase", record.ToPhase.String()).
		Str("actor_id", req.ActorID).
		Msg("phase transition succeeded")

	if record.FromPhase == planning.LayoutReadyPhase && record.ToPhase == planning.ElectricalReadyPhase {
		s.submitLayoutToElectricalHandoff(req.ProjectID, req.ActorID, req.Reason, req.Evidence)
	}

	if record.FromPhase == planning.ElectricalReadyPhase && record.ToPhase == planning.TransmissionReadyPhase {
		s.submitElectricalToTransmissionHandoff(req.ProjectID, req.ActorID, req.Reason, req.Evidence)
	}

	if record.FromPhase == planning.ApprovedPhase && record.ToPhase == planning.CommissioningReadyPhase {
		s.submitApprovedToCommissioningHandoff(req.ProjectID, req.ActorID, req.Reason, req.Evidence)
	}

	return &TransitionPhaseResult{
		ProjectID:        req.ProjectID,
		PreviousPhase:    record.FromPhase,
		CurrentPhase:     record.ToPhase,
		TransitionRecord: domainRecord,
		WasNoop:          false,
	}, nil
}

// RollbackPhase performs a controlled rollback to a prior legal phase and
// records rollback reason and incident details for auditability.
func (s *ProjectService) RollbackPhase(ctx context.Context, req *RollbackPhaseRequest) (*TransitionPhaseResult, error) {
	if req.ProjectID == uuid.Nil {
		return nil, fmt.Errorf("%w: project_id required", ErrInvalidInput)
	}
	if strings.TrimSpace(req.ActorID) == "" {
		return nil, fmt.Errorf("%w: actor_id required", ErrInvalidInput)
	}
	if strings.TrimSpace(req.Reason) == "" {
		return nil, fmt.Errorf("%w: rollback reason required", ErrInvalidInput)
	}

	project, err := s.repo.GetProject(ctx, req.ProjectID)
	if err != nil {
		return nil, fmt.Errorf("rollback phase: %w", err)
	}

	current := project.WorkflowState.CurrentPhase
	if current == planning.CommissioningReadyPhase || current == planning.ArchivedPhase {
		incident := strings.TrimSpace(req.IncidentReason)
		if incident == "" {
			incident = fmt.Sprintf("rollback rejected from terminal phase %s", current)
		}
		planning.SetBlocker(project.WorkflowState, incident, req.ActorID)
		if err := s.repo.UpdateProject(ctx, project); err != nil {
			return nil, fmt.Errorf("rollback phase: persist rejection incident: %w", err)
		}
		return nil, fmt.Errorf("%w: rollback not allowed from phase %s", ErrInvalidInput, current)
	}

	record, err := planning.ExecuteTransition(
		project.WorkflowState,
		req.TargetPhase,
		nil,
		req.ActorID,
		req.Reason,
		true,
	)
	if err != nil {
		incident := strings.TrimSpace(req.IncidentReason)
		if incident == "" {
			incident = fmt.Sprintf("rollback rejected: %s -> %s (%v)", current, req.TargetPhase, err)
		}
		planning.SetBlocker(project.WorkflowState, incident, req.ActorID)
		if persistErr := s.repo.UpdateProject(ctx, project); persistErr != nil {
			return nil, fmt.Errorf("rollback phase: persist rejection incident: %w", persistErr)
		}
		return nil, fmt.Errorf("rollback phase: %w", err)
	}

	record.RollbackReason = req.Reason

	if err := s.repo.UpdateProject(ctx, project); err != nil {
		return nil, fmt.Errorf("rollback phase: persist: %w", err)
	}

	domainRecord := &domain.PhaseTransitionRecord{
		ID:             uuid.New().String(),
		ProjectID:      req.ProjectID,
		FromPhase:      record.FromPhase,
		ToPhase:        record.ToPhase,
		OccurredAt:     record.OccurredAt,
		ActorID:        record.ActorID,
		Reason:         record.Reason,
		IsRollback:     record.IsRollback,
		RollbackReason: record.RollbackReason,
	}

	s.logger.Info().
		Str("project_id", req.ProjectID.String()).
		Str("from_phase", record.FromPhase.String()).
		Str("to_phase", record.ToPhase.String()).
		Str("actor_id", req.ActorID).
		Str("rollback_reason", req.Reason).
		Msg("phase rollback succeeded")

	return &TransitionPhaseResult{
		ProjectID:        req.ProjectID,
		PreviousPhase:    record.FromPhase,
		CurrentPhase:     record.ToPhase,
		TransitionRecord: domainRecord,
		WasNoop:          false,
	}, nil
}

// GetPhaseStateRequest input for phase state queries.
type GetPhaseStateRequest struct {
	ProjectID uuid.UUID
}

// GetPhaseStateResult output from phase state queries.
type GetPhaseStateResult struct {
	ProjectID      uuid.UUID
	CurrentPhase   planning.WorkflowPhase
	PhaseEnteredAt time.Time
	LastTransition *domain.PhaseTransitionRecord
}

// GetPhaseState retrieves the current phase and most recent transition for a project.
func (s *ProjectService) GetPhaseState(ctx context.Context, req *GetPhaseStateRequest) (*GetPhaseStateResult, error) {
	if req.ProjectID == uuid.Nil {
		return nil, fmt.Errorf("%w: project_id required", ErrInvalidInput)
	}

	project, err := s.repo.GetProject(ctx, req.ProjectID)
	if err != nil {
		return nil, fmt.Errorf("get phase state: %w", err)
	}

	var lastTransition *domain.PhaseTransitionRecord
	if len(project.WorkflowState.Transitions) > 0 {
		tx := project.WorkflowState.Transitions[len(project.WorkflowState.Transitions)-1]
		lastTransition = &domain.PhaseTransitionRecord{
			ID:             fmt.Sprintf("trans-%d", len(project.WorkflowState.Transitions)),
			ProjectID:      req.ProjectID,
			FromPhase:      tx.FromPhase,
			ToPhase:        tx.ToPhase,
			OccurredAt:     tx.OccurredAt,
			ActorID:        tx.ActorID,
			Reason:         tx.Reason,
			IsRollback:     tx.IsRollback,
			RollbackReason: tx.RollbackReason,
		}
	}

	return &GetPhaseStateResult{
		ProjectID:      req.ProjectID,
		CurrentPhase:   project.WorkflowState.CurrentPhase,
		PhaseEnteredAt: project.WorkflowState.PhaseEnteredAt,
		LastTransition: lastTransition,
	}, nil
}

// ValidatePhaseReadinessRequest input for transition validation.
type ValidatePhaseReadinessRequest struct {
	ProjectID   uuid.UUID
	TargetPhase planning.WorkflowPhase
	Evidence    planning.Evidence
}

// ValidatePhaseReadinessResult output from transition validation.
type ValidatePhaseReadinessResult struct {
	ProjectID          uuid.UUID
	CurrentPhase       planning.WorkflowPhase
	TargetPhase        planning.WorkflowPhase
	IsValid            bool
	BlockerReasons     []string
	CanTransitionAfter time.Time // Optional
}

// ValidatePhaseReadiness checks if a transition is allowed without performing it.
// Returns blocker reasons if blocked.
func (s *ProjectService) ValidatePhaseReadiness(ctx context.Context, req *ValidatePhaseReadinessRequest) (*ValidatePhaseReadinessResult, error) {
	if req.ProjectID == uuid.Nil {
		return nil, fmt.Errorf("%w: project_id required", ErrInvalidInput)
	}

	project, err := s.repo.GetProject(ctx, req.ProjectID)
	if err != nil {
		return nil, fmt.Errorf("validate readiness: %w", err)
	}

	validator := planning.NewWorkflowValidator(project.WorkflowState)
	blockers, valid := validator.ValidateTransition(req.TargetPhase, req.Evidence)

	return &ValidatePhaseReadinessResult{
		ProjectID:      req.ProjectID,
		CurrentPhase:   project.WorkflowState.CurrentPhase,
		TargetPhase:    req.TargetPhase,
		IsValid:        valid,
		BlockerReasons: blockers,
	}, nil
}

// ListPhaseTransitionsRequest input for transition history queries.
type ListPhaseTransitionsRequest struct {
	ProjectID uuid.UUID
	Limit     int
	Offset    int
}

// ListPhaseTransitionsResult output from transition history queries.
type ListPhaseTransitionsResult struct {
	ProjectID   uuid.UUID
	Transitions []*domain.PhaseTransitionRecord
	Total       int
}

// ListPhaseTransitions returns the immutable transition history for a project.
func (s *ProjectService) ListPhaseTransitions(ctx context.Context, req *ListPhaseTransitionsRequest) (*ListPhaseTransitionsResult, error) {
	if req.ProjectID == uuid.Nil {
		return nil, fmt.Errorf("%w: project_id required", ErrInvalidInput)
	}
	if req.Limit <= 0 {
		req.Limit = 50
	}
	if req.Offset < 0 {
		req.Offset = 0
	}

	project, err := s.repo.GetProject(ctx, req.ProjectID)
	if err != nil {
		return nil, fmt.Errorf("list transitions: %w", err)
	}

	// Convert internal transitions to domain records
	var result []*domain.PhaseTransitionRecord
	for i, tx := range project.WorkflowState.Transitions {
		if i < req.Offset {
			continue
		}
		if i >= req.Offset+req.Limit {
			break
		}
		result = append(result, &domain.PhaseTransitionRecord{
			ID:             fmt.Sprintf("trans-%d", i+1),
			ProjectID:      req.ProjectID,
			FromPhase:      tx.FromPhase,
			ToPhase:        tx.ToPhase,
			OccurredAt:     tx.OccurredAt,
			ActorID:        tx.ActorID,
			Reason:         tx.Reason,
			IsRollback:     tx.IsRollback,
			RollbackReason: tx.RollbackReason,
		})
	}

	return &ListPhaseTransitionsResult{
		ProjectID:   req.ProjectID,
		Transitions: result,
		Total:       len(project.WorkflowState.Transitions),
	}, nil
}

// SetPhaseBlocker adds a blocker reason to a project's workflow state.
func (s *ProjectService) SetPhaseBlocker(ctx context.Context, projectID uuid.UUID, reason string, actor string) error {
	if projectID == uuid.Nil {
		return fmt.Errorf("%w: project_id required", ErrInvalidInput)
	}

	project, err := s.repo.GetProject(ctx, projectID)
	if err != nil {
		return fmt.Errorf("set blocker: %w", err)
	}

	planning.SetBlocker(project.WorkflowState, reason, actor)

	if err := s.repo.UpdateProject(ctx, project); err != nil {
		return fmt.Errorf("set blocker: persist: %w", err)
	}

	s.logger.Info().
		Str("project_id", projectID.String()).
		Str("blocker", reason).
		Str("actor", actor).
		Msg("phase blocker set")

	return nil
}

// ClearPhaseBlocker removes a specific blocker reason from a project's workflow state.
func (s *ProjectService) ClearPhaseBlocker(ctx context.Context, projectID uuid.UUID, reason string) error {
	if projectID == uuid.Nil {
		return fmt.Errorf("%w: project_id required", ErrInvalidInput)
	}

	project, err := s.repo.GetProject(ctx, projectID)
	if err != nil {
		return fmt.Errorf("clear blocker: %w", err)
	}

	planning.ClearBlocker(project.WorkflowState, reason)

	if err := s.repo.UpdateProject(ctx, project); err != nil {
		return fmt.Errorf("clear blocker: persist: %w", err)
	}

	s.logger.Info().
		Str("project_id", projectID.String()).
		Str("blocker", reason).
		Msg("phase blocker cleared")

	return nil
}

// ClearAllPhaseBlockers removes all blockers from a project's workflow state.
func (s *ProjectService) ClearAllPhaseBlockers(ctx context.Context, projectID uuid.UUID) error {
	if projectID == uuid.Nil {
		return fmt.Errorf("%w: project_id required", ErrInvalidInput)
	}

	project, err := s.repo.GetProject(ctx, projectID)
	if err != nil {
		return fmt.Errorf("clear all blockers: %w", err)
	}

	planning.ClearAllBlockers(project.WorkflowState)

	if err := s.repo.UpdateProject(ctx, project); err != nil {
		return fmt.Errorf("clear all blockers: persist: %w", err)
	}

	s.logger.Info().
		Str("project_id", projectID.String()).
		Msg("all phase blockers cleared")

	return nil
}
