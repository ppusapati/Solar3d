package service

import (
	"context"
	"errors"
	"strings"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"solar3d/compute/planning"
	"solar3d/project-service/internal/domain"
	"solar3d/project-service/internal/repository"
)

// MockProjectRepository implements repository.ProjectRepository for testing.
type MockProjectRepository struct {
	projects map[uuid.UUID]*domain.Project
}

func NewMockProjectRepository() *MockProjectRepository {
	return &MockProjectRepository{
		projects: make(map[uuid.UUID]*domain.Project),
	}
}

func (m *MockProjectRepository) CreateProject(ctx context.Context, p *domain.Project) error {
	m.projects[p.ID] = p
	return nil
}

func (m *MockProjectRepository) GetProject(ctx context.Context, id uuid.UUID) (*domain.Project, error) {
	p, ok := m.projects[id]
	if !ok {
		return nil, repository.ErrNotFound
	}
	return p, nil
}

func (m *MockProjectRepository) ListProjects(ctx context.Context, limit, offset int) ([]*domain.Project, error) {
	var result []*domain.Project
	for _, p := range m.projects {
		result = append(result, p)
	}
	return result, nil
}

func (m *MockProjectRepository) UpdateProject(ctx context.Context, p *domain.Project) error {
	m.projects[p.ID] = p
	return nil
}

func (m *MockProjectRepository) DeleteProject(ctx context.Context, id uuid.UUID) error {
	delete(m.projects, id)
	return nil
}

// Stub site/constraint methods — not exercised by workflow tests.
func (m *MockProjectRepository) CreateSite(_ context.Context, _ *domain.Site) error {
	return nil
}
func (m *MockProjectRepository) UpsertSiteBoundary(_ context.Context, _ *domain.Site) error {
	return nil
}
func (m *MockProjectRepository) GetSiteByProjectID(_ context.Context, _ uuid.UUID) (*domain.Site, error) {
	return nil, repository.ErrNotFound
}
func (m *MockProjectRepository) UpsertConstraintZones(_ context.Context, _ uuid.UUID, _ []domain.ConstraintZone) error {
	return nil
}
func (m *MockProjectRepository) GetConstraintZonesBySite(_ context.Context, _ uuid.UUID) ([]domain.ConstraintZone, error) {
	return nil, nil
}
func (m *MockProjectRepository) DeleteConstraintZonesBySite(_ context.Context, _ uuid.UUID) error {
	return nil
}

type mockOrchestrationSubmitter struct {
	called          bool
	callCount       int
	lastProjectID   string
	lastJobType     string
	lastPayload     string
	lastIdempotency string
	payloads        []string
	idempotencies   []string
	returnJobID     string
	returnErr       error
}

func (m *mockOrchestrationSubmitter) SubmitJob(ctx context.Context, projectID, jobType string, maxAttempts int32, payload string, idempotencyKey string) (string, error) {
	m.called = true
	m.callCount++
	m.lastProjectID = projectID
	m.lastJobType = jobType
	m.lastPayload = payload
	m.lastIdempotency = idempotencyKey
	m.payloads = append(m.payloads, payload)
	m.idempotencies = append(m.idempotencies, idempotencyKey)
	if m.returnErr != nil {
		return "", m.returnErr
	}
	if m.returnJobID == "" {
		m.returnJobID = "job-1"
	}
	return m.returnJobID, nil
}

// ========== Workflow Transition Tests ==========

func TestWorkflowService_TransitionPhase_Planning_To_LayoutReady(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.PlanningPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	evidence := &planning.PlanningAcceptanceEvidence{
		BoundaryID:      "boundary-1",
		AcceptedByActor: "user-1",
		AcceptedAt:      time.Now(),
	}

	req := &TransitionPhaseRequest{
		ProjectID:   projID,
		TargetPhase: planning.LayoutReadyPhase,
		Evidence:    evidence,
		ActorID:     "user-1",
		Reason:      "boundary accepted",
	}

	result, err := service.TransitionPhase(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if result.WasNoop {
		t.Fatal("transition should not be a no-op")
	}
	if result.CurrentPhase != planning.LayoutReadyPhase {
		t.Fatalf("expected current phase to be LayoutReady; got %v", result.CurrentPhase)
	}
	if result.PreviousPhase != planning.PlanningPhase {
		t.Fatalf("expected previous phase to be Planning; got %v", result.PreviousPhase)
	}
	if result.TransitionRecord == nil {
		t.Fatal("transition record should not be nil")
	}
}

func TestWorkflowService_TransitionPhase_LayoutReady_To_ElectricalReady_SubmitsHandoff(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})
	orch := &mockOrchestrationSubmitter{}
	service.orch = orch

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.LayoutReadyPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	evidence := &planning.LayoutApprovalEvidence{
		CandidateID:             "candidate-123",
		MLExperimentID:          "exp-9",
		ApprovedByActor:         "reviewer-1",
		ApprovedAt:              time.Now(),
		CandidateCompositeScore: 0.93,
		SelectionRationale:      "highest feasibility",
	}

	req := &TransitionPhaseRequest{
		ProjectID:   projID,
		TargetPhase: planning.ElectricalReadyPhase,
		Evidence:    evidence,
		ActorID:     "reviewer-1",
		Reason:      "layout approved",
	}

	result, err := service.TransitionPhase(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if result.CurrentPhase != planning.ElectricalReadyPhase {
		t.Fatalf("expected ElectricalReadyPhase, got %v", result.CurrentPhase)
	}
	if !orch.called {
		t.Fatal("expected orchestration handoff submission")
	}
	if orch.lastProjectID != projID.String() {
		t.Fatalf("unexpected project id: %s", orch.lastProjectID)
	}
	if orch.lastJobType != "custom" {
		t.Fatalf("unexpected job type: %s", orch.lastJobType)
	}
	if !strings.Contains(orch.lastPayload, "layout_to_electrical_handoff") {
		t.Fatalf("expected handoff operation in payload, got %s", orch.lastPayload)
	}
	if !strings.Contains(orch.lastPayload, "candidate-123") {
		t.Fatalf("expected candidate_id in payload, got %s", orch.lastPayload)
	}
	if !strings.Contains(orch.lastIdempotency, "candidate-123") {
		t.Fatalf("expected candidate in idempotency key, got %s", orch.lastIdempotency)
	}
}

func TestWorkflowService_TransitionPhase_LayoutReady_To_ElectricalReady_SubmitFailureIsNonBlocking(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})
	orch := &mockOrchestrationSubmitter{returnErr: errors.New("orchestration down")}
	service.orch = orch

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.LayoutReadyPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	req := &TransitionPhaseRequest{
		ProjectID:   projID,
		TargetPhase: planning.ElectricalReadyPhase,
		Evidence: &planning.LayoutApprovalEvidence{
			CandidateID: "candidate-456",
			ApprovedAt:  time.Now(),
		},
		ActorID: "reviewer-2",
		Reason:  "layout approved",
	}

	result, err := service.TransitionPhase(context.Background(), req)
	if err != nil {
		t.Fatalf("transition should succeed even if handoff submit fails: %v", err)
	}
	if result.CurrentPhase != planning.ElectricalReadyPhase {
		t.Fatalf("expected ElectricalReadyPhase, got %v", result.CurrentPhase)
	}
	if !orch.called {
		t.Fatal("expected handoff attempt even when submission fails")
	}
}

func TestWorkflowService_TransitionPhase_ElectricalReady_To_TransmissionReady_SubmitsHandoff(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})
	orch := &mockOrchestrationSubmitter{}
	service.orch = orch

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.ElectricalReadyPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	evidence := &planning.ElectricalSignoffEvidence{
		LayoutID:                   "layout-abc",
		ElectricalAnalysisID:       "analysis-xyz",
		ValidatedByActor:           "engineer-1",
		ValidatedAt:                time.Now(),
		Violations:                 []string{},
		ElectricalFeasibilityScore: 0.91,
	}

	req := &TransitionPhaseRequest{
		ProjectID:   projID,
		TargetPhase: planning.TransmissionReadyPhase,
		Evidence:    evidence,
		ActorID:     "engineer-1",
		Reason:      "electrical validated",
	}

	result, err := service.TransitionPhase(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if result.CurrentPhase != planning.TransmissionReadyPhase {
		t.Fatalf("expected TransmissionReadyPhase, got %v", result.CurrentPhase)
	}
	if !orch.called {
		t.Fatal("expected orchestration handoff submission")
	}
	if orch.lastProjectID != projID.String() {
		t.Fatalf("unexpected project id: %s", orch.lastProjectID)
	}
	if orch.lastJobType != "custom" {
		t.Fatalf("unexpected job type: %s", orch.lastJobType)
	}
	if !strings.Contains(orch.lastPayload, "electrical_to_transmission_handoff") {
		t.Fatalf("expected handoff operation in payload, got %s", orch.lastPayload)
	}
	if !strings.Contains(orch.lastPayload, "analysis-xyz") {
		t.Fatalf("expected electrical_analysis_id in payload, got %s", orch.lastPayload)
	}
	if !strings.Contains(orch.lastIdempotency, "analysis-xyz") {
		t.Fatalf("expected analysis id in idempotency key, got %s", orch.lastIdempotency)
	}
}

func TestWorkflowService_TransitionPhase_ElectricalReady_To_TransmissionReady_SubmitFailureIsNonBlocking(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})
	orch := &mockOrchestrationSubmitter{returnErr: errors.New("orchestration down")}
	service.orch = orch

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.ElectricalReadyPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	req := &TransitionPhaseRequest{
		ProjectID:   projID,
		TargetPhase: planning.TransmissionReadyPhase,
		Evidence: &planning.ElectricalSignoffEvidence{
			LayoutID:             "layout-def",
			ElectricalAnalysisID: "analysis-fail",
			ValidatedAt:          time.Now(),
		},
		ActorID: "engineer-2",
		Reason:  "electrical validated",
	}

	result, err := service.TransitionPhase(context.Background(), req)
	if err != nil {
		t.Fatalf("transition should succeed even if handoff submit fails: %v", err)
	}
	if result.CurrentPhase != planning.TransmissionReadyPhase {
		t.Fatalf("expected TransmissionReadyPhase, got %v", result.CurrentPhase)
	}
	if !orch.called {
		t.Fatal("expected handoff attempt even when submission fails")
	}
}

func TestWorkflowService_TransitionPhase_Approved_To_CommissioningReady_SubmitsTwinHandoff(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})
	orch := &mockOrchestrationSubmitter{}
	service.orch = orch

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.ApprovedPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	evidence := &planning.StakeholderApprovalEvidence{
		ReviewApprovedLayoutID: "layout-777",
		ElectricalAnalysisID:   "analysis-888",
		TransmissionRouteID:    "route-999",
		AssetIdentityMappings: []planning.AssetIdentityMapping{
			{
				DesignAssetID:        "asset-a",
				DesignAssetType:      "INVERTER",
				PhysicalSerialNumber: "INV-SN-001",
				CommissioningRef:     "IEC62446-REF-001",
			},
		},
		ApprovedByActor: "owner-1",
		ActorRole:       "owner",
		ApprovedAt:      time.Now(),
		ApprovalNotes:   "ready for commissioning handover",
	}

	req := &TransitionPhaseRequest{
		ProjectID:   projID,
		TargetPhase: planning.CommissioningReadyPhase,
		Evidence:    evidence,
		ActorID:     "owner-1",
		Reason:      "approved for commissioning",
	}

	result, err := service.TransitionPhase(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if result.CurrentPhase != planning.CommissioningReadyPhase {
		t.Fatalf("expected CommissioningReadyPhase, got %v", result.CurrentPhase)
	}
	if !orch.called {
		t.Fatal("expected orchestration handoff submission")
	}
	if orch.lastJobType != "custom" {
		t.Fatalf("unexpected job type: %s", orch.lastJobType)
	}
	if !strings.Contains(orch.lastPayload, "approved_to_commissioning_twin_handoff") {
		t.Fatalf("expected approved->commissioning operation in payload, got %s", orch.lastPayload)
	}
	if !strings.Contains(orch.lastPayload, "asset_identity_mappings") {
		t.Fatalf("expected asset identity mappings in payload, got %s", orch.lastPayload)
	}
	if !strings.Contains(orch.lastPayload, "route-999") {
		t.Fatalf("expected transmission route linkage in payload, got %s", orch.lastPayload)
	}
	if !strings.Contains(orch.lastIdempotency, "route-999") {
		t.Fatalf("expected transmission route id in idempotency key, got %s", orch.lastIdempotency)
	}
}

func TestWorkflowService_TransitionPhase_Approved_To_CommissioningReady_SubmitFailureIsNonBlocking(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})
	orch := &mockOrchestrationSubmitter{returnErr: errors.New("orchestration down")}
	service.orch = orch

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.ApprovedPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	req := &TransitionPhaseRequest{
		ProjectID:   projID,
		TargetPhase: planning.CommissioningReadyPhase,
		Evidence: &planning.StakeholderApprovalEvidence{
			ReviewApprovedLayoutID: "layout-333",
			ApprovedAt:             time.Now(),
		},
		ActorID: "owner-2",
		Reason:  "approved for commissioning",
	}

	result, err := service.TransitionPhase(context.Background(), req)
	if err != nil {
		t.Fatalf("transition should succeed even if handoff submit fails: %v", err)
	}
	if result.CurrentPhase != planning.CommissioningReadyPhase {
		t.Fatalf("expected CommissioningReadyPhase, got %v", result.CurrentPhase)
	}
	if !orch.called {
		t.Fatal("expected handoff attempt even when submission fails")
	}
}

func TestWorkflowService_TransitionPhase_Idempotent(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:      projID.String(),
			CurrentPhase:   planning.LayoutReadyPhase,
			PhaseEnteredAt: time.Now(),
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	req := &TransitionPhaseRequest{
		ProjectID:   projID,
		TargetPhase: planning.LayoutReadyPhase,
		ActorID:     "user-1",
		Reason:      "already ready",
	}

	result, err := service.TransitionPhase(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if !result.WasNoop {
		t.Fatal("transition to current phase should be a no-op")
	}
	if result.TransitionRecord != nil {
		t.Fatal("no-op transition should not create a record")
	}
}

func TestWorkflowService_TransitionPhase_InvalidSkip_Rejected(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.PlanningPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	// Try to skip from PLANNING to ELECTRICAL_READY (illegal skip)
	req := &TransitionPhaseRequest{
		ProjectID:   projID,
		TargetPhase: planning.ElectricalReadyPhase,
		ActorID:     "user-1",
		Reason:      "invalid skip",
	}

	_, err := service.TransitionPhase(context.Background(), req)
	if err == nil {
		t.Fatal("expected error for illegal phase skip")
	}
}

func TestWorkflowService_TransitionPhase_BlockerPreventsTransition(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:      projID.String(),
			CurrentPhase:   planning.LayoutReadyPhase,
			ActiveBlockers: []string{"electrical validation pending"},
			BlockedBy:      "reviewer-1",
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	evidence := &planning.ElectricalSignoffEvidence{
		LayoutID: "layout-1",
	}

	req := &TransitionPhaseRequest{
		ProjectID:   projID,
		TargetPhase: planning.ElectricalReadyPhase,
		Evidence:    evidence,
		ActorID:     "user-1",
		Reason:      "proceed to electrical",
	}

	_, err := service.TransitionPhase(context.Background(), req)
	if err == nil {
		t.Fatal("expected error when blockers prevent transition")
	}
}

func TestWorkflowService_TransitionPhase_RejectedTransmission_PersistsIncidentReason(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.ElectricalReadyPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	incident := "transmission rejected: missing anchors"
	_, err := service.TransitionPhase(context.Background(), &TransitionPhaseRequest{
		ProjectID:      projID,
		TargetPhase:    planning.TransmissionReadyPhase,
		Evidence:       &planning.LayoutApprovalEvidence{CandidateID: "wrong-evidence"},
		ActorID:        "engineer-1",
		Reason:         "attempt transition",
		IncidentReason: incident,
	})
	if err == nil {
		t.Fatal("expected transition rejection for mismatched evidence")
	}

	updated, getErr := repo.GetProject(context.Background(), projID)
	if getErr != nil {
		t.Fatalf("failed to fetch project: %v", getErr)
	}
	if len(updated.WorkflowState.ActiveBlockers) == 0 {
		t.Fatal("expected incident blocker to be recorded")
	}
	if updated.WorkflowState.ActiveBlockers[0] != incident {
		t.Fatalf("expected incident blocker %q, got %q", incident, updated.WorkflowState.ActiveBlockers[0])
	}
}

func TestWorkflowService_TransitionPhase_RejectedReview_PersistsIncidentReason(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.TransmissionReadyPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	incident := "review rejected: required LOD 400 evidence missing"
	_, err := service.TransitionPhase(context.Background(), &TransitionPhaseRequest{
		ProjectID:      projID,
		TargetPhase:    planning.ApprovedPhase,
		ActorID:        "reviewer-1",
		Reason:         "attempt skip",
		IncidentReason: incident,
	})
	if err == nil {
		t.Fatal("expected transition rejection for illegal review skip")
	}

	updated, getErr := repo.GetProject(context.Background(), projID)
	if getErr != nil {
		t.Fatalf("failed to fetch project: %v", getErr)
	}
	if len(updated.WorkflowState.ActiveBlockers) == 0 {
		t.Fatal("expected incident blocker to be recorded")
	}
	if updated.WorkflowState.ActiveBlockers[0] != incident {
		t.Fatalf("expected incident blocker %q, got %q", incident, updated.WorkflowState.ActiveBlockers[0])
	}
}

// ========== Phase State Query Tests ==========

func TestWorkflowService_GetPhaseState_ReturnsCurrentState(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	now := time.Now()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:      projID.String(),
			CurrentPhase:   planning.LayoutReadyPhase,
			PhaseEnteredAt: now,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	req := &GetPhaseStateRequest{
		ProjectID: projID,
	}

	result, err := service.GetPhaseState(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if result.CurrentPhase != planning.LayoutReadyPhase {
		t.Fatalf("expected LayoutReadyPhase; got %v", result.CurrentPhase)
	}
	if result.PhaseEnteredAt != now {
		t.Fatal("phase entered time mismatch")
	}
}

// ========== Phase Readiness Validation Tests ==========

func TestWorkflowService_ValidatePhaseReadiness_LegalTransition(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.LayoutReadyPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	req := &ValidatePhaseReadinessRequest{
		ProjectID:   projID,
		TargetPhase: planning.ElectricalReadyPhase,
	}

	result, err := service.ValidatePhaseReadiness(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if !result.IsValid {
		t.Fatalf("expected valid transition; got blockers %v", result.BlockerReasons)
	}
	if len(result.BlockerReasons) != 0 {
		t.Fatalf("expected no blockers; got %v", result.BlockerReasons)
	}
}

func TestWorkflowService_ValidatePhaseReadiness_IllegalSkip(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.PlanningPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	req := &ValidatePhaseReadinessRequest{
		ProjectID:   projID,
		TargetPhase: planning.ElectricalReadyPhase,
	}

	result, err := service.ValidatePhaseReadiness(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if result.IsValid {
		t.Fatal("expected validation to fail for illegal skip")
	}
	if len(result.BlockerReasons) == 0 {
		t.Fatal("expected blocker reasons")
	}
}

// ========== Transition History Tests ==========

func TestWorkflowService_ListPhaseTransitions_ReturnsAll(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.ApprovedPhase,
			Transitions: []*planning.PhaseTransitionRecord{
				{
					FromPhase:  planning.PlanningPhase,
					ToPhase:    planning.LayoutReadyPhase,
					OccurredAt: time.Now().Add(-30 * time.Minute),
					ActorID:    "user-1",
					Reason:     "boundary accepted",
				},
				{
					FromPhase:  planning.LayoutReadyPhase,
					ToPhase:    planning.ElectricalReadyPhase,
					OccurredAt: time.Now().Add(-20 * time.Minute),
					ActorID:    "user-2",
					Reason:     "layout approved",
				},
			},
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	req := &ListPhaseTransitionsRequest{
		ProjectID: projID,
		Limit:     50,
		Offset:    0,
	}

	result, err := service.ListPhaseTransitions(context.Background(), req)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	if len(result.Transitions) != 2 {
		t.Fatalf("expected 2 transitions; got %d", len(result.Transitions))
	}
	if result.Total != 2 {
		t.Fatalf("expected total count 2; got %d", result.Total)
	}
}

// ========== Blocker Management Tests ==========

func TestWorkflowService_SetPhaseBlocker_AddsBlocker(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.LayoutReadyPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	err := service.SetPhaseBlocker(context.Background(), projID, "electrical validation pending", "reviewer-1")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	// Verify blocker was added
	updated, _ := repo.GetProject(context.Background(), projID)
	if len(updated.WorkflowState.ActiveBlockers) != 1 {
		t.Fatalf("expected 1 blocker; got %d", len(updated.WorkflowState.ActiveBlockers))
	}
	if updated.WorkflowState.ActiveBlockers[0] != "electrical validation pending" {
		t.Fatalf("wrong blocker: %s", updated.WorkflowState.ActiveBlockers[0])
	}
	if updated.WorkflowState.BlockedBy != "reviewer-1" {
		t.Fatalf("wrong blocked_by: %s", updated.WorkflowState.BlockedBy)
	}
}

func TestWorkflowService_ClearPhaseBlocker_RemovesSpecificBlocker(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.LayoutReadyPhase,
			ActiveBlockers: []string{
				"electrical validation pending",
				"stakeholder approval pending",
			},
			BlockedBy: "reviewer-1",
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	err := service.ClearPhaseBlocker(context.Background(), projID, "electrical validation pending")
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	// Verify blocker was removed
	updated, _ := repo.GetProject(context.Background(), projID)
	if len(updated.WorkflowState.ActiveBlockers) != 1 {
		t.Fatalf("expected 1 blocker after removal; got %d", len(updated.WorkflowState.ActiveBlockers))
	}
	if updated.WorkflowState.ActiveBlockers[0] != "stakeholder approval pending" {
		t.Fatalf("wrong remaining blocker: %s", updated.WorkflowState.ActiveBlockers[0])
	}
}

func TestWorkflowService_ClearAllPhaseBlockers_RemovesAll(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.LayoutReadyPhase,
			ActiveBlockers: []string{
				"electrical validation pending",
				"stakeholder approval pending",
			},
			BlockedBy: "reviewer-1",
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	err := service.ClearAllPhaseBlockers(context.Background(), projID)
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}

	// Verify all blockers were removed
	updated, _ := repo.GetProject(context.Background(), projID)
	if len(updated.WorkflowState.ActiveBlockers) != 0 {
		t.Fatalf("expected 0 blockers; got %d", len(updated.WorkflowState.ActiveBlockers))
	}
	if updated.WorkflowState.BlockedBy != "" {
		t.Fatal("blocked_by should be cleared")
	}
}

func TestWorkflowService_RollbackPhase_Success(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.TransmissionReadyPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	result, err := service.RollbackPhase(context.Background(), &RollbackPhaseRequest{
		ProjectID:   projID,
		TargetPhase: planning.ElectricalReadyPhase,
		ActorID:     "admin-1",
		Reason:      "transmission review failed",
	})
	if err != nil {
		t.Fatalf("unexpected rollback error: %v", err)
	}
	if result.CurrentPhase != planning.ElectricalReadyPhase {
		t.Fatalf("expected ElectricalReadyPhase after rollback, got %v", result.CurrentPhase)
	}
	if result.TransitionRecord == nil || !result.TransitionRecord.IsRollback {
		t.Fatal("expected rollback transition record")
	}
	if result.TransitionRecord.RollbackReason != "transmission review failed" {
		t.Fatalf("unexpected rollback reason: %s", result.TransitionRecord.RollbackReason)
	}
}

func TestWorkflowService_RollbackPhase_RejectedFromCommissioning_PersistsIncident(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "test-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.CommissioningReadyPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	incident := "rollback blocked: commissioning signoff finalized"
	_, err := service.RollbackPhase(context.Background(), &RollbackPhaseRequest{
		ProjectID:      projID,
		TargetPhase:    planning.ApprovedPhase,
		ActorID:        "admin-2",
		Reason:         "operator requested rollback",
		IncidentReason: incident,
	})
	if err == nil {
		t.Fatal("expected rollback rejection from commissioning phase")
	}

	updated, getErr := repo.GetProject(context.Background(), projID)
	if getErr != nil {
		t.Fatalf("failed to fetch project: %v", getErr)
	}
	if len(updated.WorkflowState.ActiveBlockers) == 0 {
		t.Fatal("expected incident blocker to be recorded")
	}
	if updated.WorkflowState.ActiveBlockers[0] != incident {
		t.Fatalf("expected incident blocker %q, got %q", incident, updated.WorkflowState.ActiveBlockers[0])
	}
}

func TestWorkflowService_EndToEnd_BoundaryToCommissioning_TwinProvisioningHandoff(t *testing.T) {
	repo := NewMockProjectRepository()
	service := New(repo, zerolog.Logger{})
	orch := &mockOrchestrationSubmitter{}
	service.orch = orch

	projID := uuid.New()
	project := &domain.Project{
		ID:   projID,
		Name: "e2e-stabilization-project",
		WorkflowState: &planning.WorkflowState{
			ProjectID:    projID.String(),
			CurrentPhase: planning.PlanningPhase,
		},
	}
	_ = repo.CreateProject(context.Background(), project)

	steps := []struct {
		target   planning.WorkflowPhase
		evidence planning.Evidence
		reason   string
		actor    string
	}{
		{
			target: planning.LayoutReadyPhase,
			evidence: &planning.PlanningAcceptanceEvidence{
				BoundaryID:      "boundary-e2e-1",
				AcceptedByActor: "planner-1",
				AcceptedAt:      time.Now(),
			},
			reason: "boundary accepted",
			actor:  "planner-1",
		},
		{
			target: planning.ElectricalReadyPhase,
			evidence: &planning.LayoutApprovalEvidence{
				CandidateID:             "cand-e2e-1",
				MLExperimentID:          "exp-e2e-1",
				ApprovedByActor:         "layout-reviewer-1",
				ApprovedAt:              time.Now(),
				CandidateCompositeScore: 0.94,
				SelectionRationale:      "highest constrained fit",
			},
			reason: "layout approved",
			actor:  "layout-reviewer-1",
		},
		{
			target: planning.TransmissionReadyPhase,
			evidence: &planning.ElectricalSignoffEvidence{
				LayoutID:                   "layout-e2e-1",
				ElectricalAnalysisID:       "elec-e2e-1",
				ValidatedByActor:           "electrical-engineer-1",
				ValidatedAt:                time.Now(),
				Violations:                 []string{},
				ElectricalFeasibilityScore: 0.92,
			},
			reason: "electrical signed off",
			actor:  "electrical-engineer-1",
		},
		{
			target: planning.ReviewReadyPhase,
			evidence: &planning.TransmissionSignoffEvidence{
				ElectricalLayoutID:   "layout-e2e-1",
				TransmissionRouteID:  "route-e2e-1",
				ApprovedByActor:      "tx-reviewer-1",
				ApprovedAt:           time.Now(),
				ProtectionDevices:    []string{"relay-a", "breaker-b"},
				FaultIsolationPoints: 3,
			},
			reason: "transmission signed off",
			actor:  "tx-reviewer-1",
		},
		{
			target: planning.ApprovedPhase,
			evidence: &planning.ReviewApprovalEvidence{
				TransmissionRouteID:    "route-e2e-1",
				LOD400ChecklistID:      "lod400-e2e-1",
				ReviewedByActor:        "qa-reviewer-1",
				ReviewedAt:             time.Now(),
				MandatoryItemsVerified: 12,
				Blockers:               []string{},
				QualityScore:           0.97,
			},
			reason: "review approved",
			actor:  "qa-reviewer-1",
		},
		{
			target: planning.CommissioningReadyPhase,
			evidence: &planning.StakeholderApprovalEvidence{
				ReviewApprovedLayoutID: "layout-e2e-1",
				ElectricalAnalysisID:   "elec-e2e-1",
				TransmissionRouteID:    "route-e2e-1",
				AssetIdentityMappings: []planning.AssetIdentityMapping{
					{
						DesignAssetID:        "asset-panel-1",
						DesignAssetType:      "PANEL",
						PhysicalSerialNumber: "SN-PANEL-0001",
						CommissioningRef:     "IEC62446-PANEL-1",
					},
					{
						DesignAssetID:        "asset-inverter-1",
						DesignAssetType:      "INVERTER",
						PhysicalSerialNumber: "SN-INV-0001",
						CommissioningRef:     "IEC62446-INV-1",
					},
				},
				ApprovedByActor: "owner-1",
				ActorRole:       "owner",
				ApprovedAt:      time.Now(),
				ApprovalNotes:   "approved for commissioning and twin provisioning",
			},
			reason: "stakeholder approval",
			actor:  "owner-1",
		},
	}

	currentPhase := planning.PlanningPhase
	for _, step := range steps {
		result, err := service.TransitionPhase(context.Background(), &TransitionPhaseRequest{
			ProjectID:   projID,
			TargetPhase: step.target,
			Evidence:    step.evidence,
			ActorID:     step.actor,
			Reason:      step.reason,
		})
		if err != nil {
			t.Fatalf("transition %s->%s failed: %v", currentPhase, step.target, err)
		}
		if result.CurrentPhase != step.target {
			t.Fatalf("expected phase %s, got %s", step.target, result.CurrentPhase)
		}
		currentPhase = step.target
	}

	updated, err := repo.GetProject(context.Background(), projID)
	if err != nil {
		t.Fatalf("failed to fetch updated project: %v", err)
	}
	if updated.WorkflowState.CurrentPhase != planning.CommissioningReadyPhase {
		t.Fatalf("expected final phase CommissioningReadyPhase, got %s", updated.WorkflowState.CurrentPhase)
	}

	if orch.callCount != 3 {
		t.Fatalf("expected 3 orchestration handoffs, got %d", orch.callCount)
	}

	payloadJoined := strings.Join(orch.payloads, "\n")
	if !strings.Contains(payloadJoined, "layout_to_electrical_handoff") {
		t.Fatal("expected layout->electrical handoff payload")
	}
	if !strings.Contains(payloadJoined, "electrical_to_transmission_handoff") {
		t.Fatal("expected electrical->transmission handoff payload")
	}
	if !strings.Contains(payloadJoined, "approved_to_commissioning_twin_handoff") {
		t.Fatal("expected approved->commissioning twin handoff payload")
	}
	if !strings.Contains(payloadJoined, "asset_identity_mappings") {
		t.Fatal("expected twin provisioning identity mappings in commissioning payload")
	}
	if !strings.Contains(payloadJoined, "route-e2e-1") || !strings.Contains(payloadJoined, "elec-e2e-1") || !strings.Contains(payloadJoined, "layout-e2e-1") {
		t.Fatal("expected full layout/electrical/transmission linkage fields in handoff payload")
	}

	idempotencyJoined := strings.Join(orch.idempotencies, "\n")
	if !strings.Contains(idempotencyJoined, "workflow:layout_to_electrical:") {
		t.Fatal("expected layout->electrical idempotency key")
	}
	if !strings.Contains(idempotencyJoined, "workflow:electrical_to_transmission:") {
		t.Fatal("expected electrical->transmission idempotency key")
	}
	if !strings.Contains(idempotencyJoined, "workflow:approved_to_commissioning_twin:") {
		t.Fatal("expected approved->commissioning twin idempotency key")
	}
}
