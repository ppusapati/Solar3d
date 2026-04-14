package service_test

import (
	"context"
	"testing"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"solar3d/commissioning-service/internal/domain"
	"solar3d/commissioning-service/internal/service"
)

// ── in-memory repository stub ─────────────────────────────────────────────

type memRepo struct {
	checklists map[uuid.UUID]*domain.CommissioningChecklist
	items      map[uuid.UUID]*domain.ChecklistItem
	signoffs   map[uuid.UUID]*domain.CommissioningSignoff
	handovers  map[uuid.UUID]*domain.HandoverRecord
	artifacts  map[uuid.UUID]*domain.AsBuiltArtifact
}

func newMemRepo() *memRepo {
	return &memRepo{
		checklists: make(map[uuid.UUID]*domain.CommissioningChecklist),
		items:      make(map[uuid.UUID]*domain.ChecklistItem),
		signoffs:   make(map[uuid.UUID]*domain.CommissioningSignoff),
		handovers:  make(map[uuid.UUID]*domain.HandoverRecord),
		artifacts:  make(map[uuid.UUID]*domain.AsBuiltArtifact),
	}
}

func (m *memRepo) CreateChecklist(_ context.Context, c *domain.CommissioningChecklist) error {
	m.checklists[c.ID] = c
	return nil
}

func (m *memRepo) GetChecklistByID(_ context.Context, id uuid.UUID) (*domain.CommissioningChecklist, error) {
	c, ok := m.checklists[id]
	if !ok {
		return nil, domain.ErrNotFound
	}
	// Attach items and signoffs from memory store
	var items []domain.ChecklistItem
	for _, item := range m.items {
		if item.ChecklistID == id {
			cp := *item
			items = append(items, cp)
		}
	}
	cp := *c
	cp.Items = items
	var signoffs []domain.CommissioningSignoff
	for _, s := range m.signoffs {
		if s.ChecklistID == id {
			signoffs = append(signoffs, *s)
		}
	}
	cp.Signoffs = signoffs
	return &cp, nil
}

func (m *memRepo) ListChecklistsByProject(_ context.Context, projectID uuid.UUID) ([]domain.CommissioningChecklist, error) {
	var result []domain.CommissioningChecklist
	for _, c := range m.checklists {
		if c.ProjectID == projectID {
			result = append(result, *c)
		}
	}
	return result, nil
}

func (m *memRepo) UpdateChecklistStatus(_ context.Context, id uuid.UUID, status domain.CommissioningStatus) error {
	if c, ok := m.checklists[id]; ok {
		c.Status = status
	}
	return nil
}

func (m *memRepo) AddItem(_ context.Context, item *domain.ChecklistItem) error {
	cp := *item
	m.items[item.ID] = &cp
	return nil
}

func (m *memRepo) UpdateItem(_ context.Context, item *domain.ChecklistItem) error {
	m.items[item.ID] = item
	return nil
}

func (m *memRepo) GetItemByID(_ context.Context, id uuid.UUID) (*domain.ChecklistItem, error) {
	item, ok := m.items[id]
	if !ok {
		return nil, domain.ErrNotFound
	}
	cp := *item
	return &cp, nil
}

func (m *memRepo) ListChecklistItemsByChecklist(_ context.Context, checklistID uuid.UUID) ([]domain.ChecklistItem, error) {
	var result []domain.ChecklistItem
	for _, item := range m.items {
		if item.ChecklistID == checklistID {
			result = append(result, *item)
		}
	}
	return result, nil
}

func (m *memRepo) AddSignoff(_ context.Context, s *domain.CommissioningSignoff) error {
	cp := *s
	m.signoffs[s.ID] = &cp
	return nil
}

func (m *memRepo) ListSignoffsByChecklist(_ context.Context, checklistID uuid.UUID) ([]domain.CommissioningSignoff, error) {
	var result []domain.CommissioningSignoff
	for _, s := range m.signoffs {
		if s.ChecklistID == checklistID {
			result = append(result, *s)
		}
	}
	return result, nil
}

func (m *memRepo) CreateHandover(_ context.Context, h *domain.HandoverRecord) error {
	cp := *h
	m.handovers[h.ID] = &cp
	return nil
}

func (m *memRepo) GetHandoverByID(_ context.Context, id uuid.UUID) (*domain.HandoverRecord, error) {
	h, ok := m.handovers[id]
	if !ok {
		return nil, domain.ErrNotFound
	}
	cp := *h
	return &cp, nil
}

func (m *memRepo) RecordAsBuilt(_ context.Context, a *domain.AsBuiltArtifact) error {
	cp := *a
	m.artifacts[a.ID] = &cp
	return nil
}

func (m *memRepo) ListAsBuiltByProject(_ context.Context, projectID uuid.UUID) ([]domain.AsBuiltArtifact, error) {
	var result []domain.AsBuiltArtifact
	for _, a := range m.artifacts {
		if a.ProjectID == projectID {
			result = append(result, *a)
		}
	}
	return result, nil
}

func (m *memRepo) TouchChecklist(_ context.Context, id uuid.UUID) error {
	return nil
}

// ── Tests ─────────────────────────────────────────────────────────────────

func newTestService() *service.Service {
	return service.New(newMemRepo(), zerolog.Nop())
}

func TestCreateChecklistSeedsStandardItems(t *testing.T) {
	svc := newTestService()
	cl, err := svc.CreateChecklist(context.Background(), domain.CreateChecklistRequest{
		ProjectID: uuid.New(),
		Name:      "Test Plant Commissioning",
		CreatedBy: "engineer@example.com",
	})
	if err != nil {
		t.Fatalf("CreateChecklist failed: %v", err)
	}
	if cl.ID == uuid.Nil {
		t.Fatal("expected non-nil checklist ID")
	}
	if cl.Status != domain.CommissioningStatusPending {
		t.Errorf("expected PENDING, got %s", cl.Status)
	}
	// Standard items should be seeded (at least 10)
	if len(cl.Items) < 10 {
		t.Errorf("expected at least 10 seeded items, got %d", len(cl.Items))
	}
	// Verify at least one required item exists
	hasRequired := false
	for _, item := range cl.Items {
		if item.Required {
			hasRequired = true
			break
		}
	}
	if !hasRequired {
		t.Error("expected at least one required item")
	}
}

func TestUpdateChecklistItemAdvancesStatus(t *testing.T) {
	svc := newTestService()
	pid := uuid.New()
	cl, err := svc.CreateChecklist(context.Background(), domain.CreateChecklistRequest{
		ProjectID: pid,
		Name:      "Status Advance Test",
	})
	if err != nil {
		t.Fatalf("CreateChecklist: %v", err)
	}

	// Mark all required items as PASS, non-required as NOT_APPLICABLE
	for _, item := range cl.Items {
		status := domain.ChecklistItemStatusPass
		if !item.Required {
			status = domain.ChecklistItemStatusNotApplicable
		}
		_, err := svc.UpdateChecklistItem(context.Background(), domain.UpdateChecklistItemRequest{
			ItemID:      item.ID,
			Status:      status,
			CompletedBy: "engineer@example.com",
		})
		if err != nil {
			t.Fatalf("UpdateChecklistItem(%s): %v", item.ID, err)
		}
	}

	updated, err := svc.GetChecklist(context.Background(), cl.ID)
	if err != nil {
		t.Fatalf("GetChecklist: %v", err)
	}
	if updated.Status != domain.CommissioningStatusCompleted {
		t.Errorf("expected COMPLETED after all required pass, got %s", updated.Status)
	}
}

func TestSignOffRequiresCompleted(t *testing.T) {
	svc := newTestService()
	cl, err := svc.CreateChecklist(context.Background(), domain.CreateChecklistRequest{
		ProjectID: uuid.New(),
		Name:      "Signoff Guard Test",
	})
	if err != nil {
		t.Fatalf("CreateChecklist: %v", err)
	}

	// Try to sign off before COMPLETED — should fail
	_, _, err = svc.SignOffChecklist(context.Background(), domain.SignOffChecklistRequest{
		ChecklistID: cl.ID,
		SignedBy:    "engineer@example.com",
		Role:        "EPC_ENGINEER",
	})
	if err == nil {
		t.Fatal("expected error signing off a PENDING checklist")
	}
}

func TestHandoverRequiresSignedOff(t *testing.T) {
	svc := newTestService()
	pid := uuid.New()
	cl, err := svc.CreateChecklist(context.Background(), domain.CreateChecklistRequest{
		ProjectID: pid, Name: "Handover Guard Test",
	})
	if err != nil {
		t.Fatalf("CreateChecklist: %v", err)
	}

	// Mark all required items pass
	for _, item := range cl.Items {
		if item.Required {
			_, _ = svc.UpdateChecklistItem(context.Background(), domain.UpdateChecklistItemRequest{
				ItemID: item.ID, Status: domain.ChecklistItemStatusPass, CompletedBy: "eng",
			})
		}
	}

	// Handover without signing off should fail
	_, err = svc.CreateHandover(context.Background(), domain.CreateHandoverRequest{
		ProjectID:    pid,
		ChecklistID:  cl.ID,
		HandedOverBy: "contractor@example.com",
		ReceivedBy:   "owner@example.com",
	})
	if err == nil {
		t.Fatal("expected error on handover without signoff")
	}
}

func TestRecordAsBuiltAndReport(t *testing.T) {
	svc := newTestService()
	pid := uuid.New()
	cl, err := svc.CreateChecklist(context.Background(), domain.CreateChecklistRequest{
		ProjectID: pid, Name: "Report Test Checklist",
	})
	if err != nil {
		t.Fatalf("CreateChecklist: %v", err)
	}

	// Record an as-built artifact
	art, err := svc.RecordAsBuilt(context.Background(), domain.RecordAsBuiltRequest{
		ProjectID:     pid,
		Name:          "Single-Line Diagram Rev3",
		ArtifactType:  domain.AsBuiltArtifactTypeDrawing,
		StorageURL:    "s3://solar3d-docs/sld-rev3.pdf",
		UploadedBy:    "designer@example.com",
		Revision:      "Rev.3",
		FileSizeBytes: 2048000,
	})
	if err != nil {
		t.Fatalf("RecordAsBuilt: %v", err)
	}
	if art.ID == uuid.Nil {
		t.Fatal("expected artifact ID")
	}

	// List artifacts
	arts, err := svc.ListAsBuiltArtifacts(context.Background(), pid)
	if err != nil {
		t.Fatalf("ListAsBuiltArtifacts: %v", err)
	}
	if len(arts) != 1 {
		t.Errorf("expected 1 artifact, got %d", len(arts))
	}

	// Generate report on a partial checklist (should succeed without error)
	report, err := svc.GenerateReport(context.Background(), domain.GenerateReportRequest{
		ChecklistID: cl.ID,
	})
	if err != nil {
		t.Fatalf("GenerateReport: %v", err)
	}
	if len(report) == 0 {
		t.Error("expected non-empty report")
	}
	// Report should reference the checklist name
	if !containsStr(report, cl.Name) {
		t.Errorf("report does not mention checklist name %q", cl.Name)
	}
}

func containsStr(s, sub string) bool {
	return len(s) >= len(sub) && (s == sub || len(sub) == 0 ||
		func() bool {
			for i := 0; i <= len(s)-len(sub); i++ {
				if s[i:i+len(sub)] == sub {
					return true
				}
			}
			return false
		}())
}
