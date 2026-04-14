package service

import (
	"context"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog"

	"solar3d/commissioning-service/internal/domain"
)

// standardItems returns a baseline set of commissioning checklist items
// consistent with IEC 62446-1 (PV system commissioning) for utility-scale solar.
// These are seeded on every new checklist.
func standardItems() []domain.ChecklistItem {
	type itemDef struct {
		desc     string
		section  domain.ChecklistSection
		required bool
		seq      int32
	}
	defs := []itemDef{
		// Civil
		{"Ground mounting foundations meet design drawings", domain.ChecklistSectionCivil, true, 10},
		{"Drainage and grading per civil design", domain.ChecklistSectionCivil, true, 20},
		{"Perimeter fencing installed and locked", domain.ChecklistSectionCivil, true, 30},
		{"Access gates and roads complete", domain.ChecklistSectionCivil, false, 40},
		// Mechanical
		{"Module mounting torque verified per manufacturer spec", domain.ChecklistSectionMechanical, true, 50},
		{"Tracker drive units installed and aligned", domain.ChecklistSectionMechanical, false, 60},
		{"Structural grounding continuity confirmed", domain.ChecklistSectionMechanical, true, 70},
		// Electrical
		{"String OC voltage measurements within ±5% of design", domain.ChecklistSectionElectrical, true, 80},
		{"String ISC measurements within ±5% of design", domain.ChecklistSectionElectrical, true, 90},
		{"DC cable insulation resistance >1 MΩ per IEC 60364-6", domain.ChecklistSectionElectrical, true, 100},
		{"Inverter DC/AC connections verified and torqued", domain.ChecklistSectionElectrical, true, 110},
		{"AC cable insulation resistance >1 MΩ", domain.ChecklistSectionElectrical, true, 120},
		{"Earthing resistance ≤10 Ω (IEC 62305)", domain.ChecklistSectionElectrical, true, 130},
		{"Continuity of protective conductors confirmed", domain.ChecklistSectionElectrical, true, 140},
		// Protection
		{"AC overcurrent protection devices installed and tested", domain.ChecklistSectionProtection, true, 150},
		{"DC fuses/disconnects rated and installed", domain.ChecklistSectionProtection, true, 160},
		{"Anti-islanding protection configured and verified", domain.ChecklistSectionProtection, true, 170},
		{"Earth fault protection relay tested (IEC 60255)", domain.ChecklistSectionProtection, true, 180},
		{"Surge protection devices installed per IEC 61643-32", domain.ChecklistSectionProtection, false, 190},
		// SCADA
		{"Datalogger communication to inverters confirmed", domain.ChecklistSectionSCADA, true, 200},
		{"All meters calibrated and reading correctly", domain.ChecklistSectionSCADA, true, 210},
		{"Alarms and fault codes verified in SCADA", domain.ChecklistSectionSCADA, false, 220},
		// Safety
		{"Emergency stop / main AC disconnect functional", domain.ChecklistSectionSafety, true, 230},
		{"Safety signage installed per local codes", domain.ChecklistSectionSafety, true, 240},
		{"Arc flash study completed and labels posted", domain.ChecklistSectionSafety, true, 250},
		{"Fire extinguishers installed in combiner/inverter rooms", domain.ChecklistSectionSafety, false, 260},
		// Documentation
		{"As-built single-line diagram issued for record", domain.ChecklistSectionDocumentation, true, 270},
		{"O&M manuals and warranty documents delivered", domain.ChecklistSectionDocumentation, true, 280},
		{"Test records and factory acceptance certs filed", domain.ChecklistSectionDocumentation, true, 290},
		{"Grid connection approval letter received", domain.ChecklistSectionDocumentation, true, 300},
	}

	items := make([]domain.ChecklistItem, len(defs))
	for i, d := range defs {
		items[i] = domain.ChecklistItem{
			ID:          uuid.New(),
			Description: d.desc,
			Section:     d.section,
			Status:      domain.ChecklistItemStatusPending,
			Required:    d.required,
			Sequence:    d.seq,
		}
	}
	return items
}

// Repo is the storage interface the service depends on.
// The concrete *repository.Repository satisfies this interface.
type Repo interface {
	CreateChecklist(ctx context.Context, c *domain.CommissioningChecklist) error
	GetChecklistByID(ctx context.Context, id uuid.UUID) (*domain.CommissioningChecklist, error)
	ListChecklistsByProject(ctx context.Context, projectID uuid.UUID) ([]domain.CommissioningChecklist, error)
	UpdateChecklistStatus(ctx context.Context, id uuid.UUID, status domain.CommissioningStatus) error
	TouchChecklist(ctx context.Context, id uuid.UUID) error
	AddItem(ctx context.Context, item *domain.ChecklistItem) error
	UpdateItem(ctx context.Context, item *domain.ChecklistItem) error
	GetItemByID(ctx context.Context, id uuid.UUID) (*domain.ChecklistItem, error)
	ListChecklistItemsByChecklist(ctx context.Context, checklistID uuid.UUID) ([]domain.ChecklistItem, error)
	AddSignoff(ctx context.Context, s *domain.CommissioningSignoff) error
	ListSignoffsByChecklist(ctx context.Context, checklistID uuid.UUID) ([]domain.CommissioningSignoff, error)
	CreateHandover(ctx context.Context, h *domain.HandoverRecord) error
	GetHandoverByID(ctx context.Context, id uuid.UUID) (*domain.HandoverRecord, error)
	RecordAsBuilt(ctx context.Context, a *domain.AsBuiltArtifact) error
	ListAsBuiltByProject(ctx context.Context, projectID uuid.UUID) ([]domain.AsBuiltArtifact, error)
}

type Service struct {
	repo   Repo
	logger zerolog.Logger
}

func New(repo Repo, logger zerolog.Logger) *Service {
	return &Service{repo: repo, logger: logger.With().Str("component", "commissioning-service").Logger()}
}

// ── Checklist lifecycle ───────────────────────────────────────────────────

// CreateChecklist creates a new checklist seeded with standard IEC 62446-1 items.
func (s *Service) CreateChecklist(ctx context.Context, req domain.CreateChecklistRequest) (*domain.CommissioningChecklist, error) {
	if req.Name == "" {
		return nil, fmt.Errorf("name is required")
	}
	if req.ProjectID == uuid.Nil {
		return nil, fmt.Errorf("project_id is required")
	}

	now := time.Now().UTC()
	cl := &domain.CommissioningChecklist{
		ID:        uuid.New(),
		ProjectID: req.ProjectID,
		Name:      req.Name,
		Status:    domain.CommissioningStatusPending,
		CreatedBy: req.CreatedBy,
		CreatedAt: now,
		UpdatedAt: now,
	}

	if err := s.repo.CreateChecklist(ctx, cl); err != nil {
		return nil, fmt.Errorf("creating checklist: %w", err)
	}

	// Seed standard items
	items := standardItems()
	for i := range items {
		items[i].ChecklistID = cl.ID
		if err := s.repo.AddItem(ctx, &items[i]); err != nil {
			return nil, fmt.Errorf("seeding checklist item: %w", err)
		}
	}
	cl.Items = items
	return cl, nil
}

func (s *Service) GetChecklist(ctx context.Context, id uuid.UUID) (*domain.CommissioningChecklist, error) {
	return s.repo.GetChecklistByID(ctx, id)
}

func (s *Service) ListChecklists(ctx context.Context, projectID uuid.UUID) ([]domain.CommissioningChecklist, error) {
	return s.repo.ListChecklistsByProject(ctx, projectID)
}

// ── ChecklistItem ─────────────────────────────────────────────────────────

func (s *Service) AddChecklistItem(ctx context.Context, req domain.AddChecklistItemRequest) (*domain.ChecklistItem, error) {
	if req.Description == "" {
		return nil, fmt.Errorf("description is required")
	}
	item := &domain.ChecklistItem{
		ID:          uuid.New(),
		ChecklistID: req.ChecklistID,
		Description: req.Description,
		Section:     req.Section,
		Status:      domain.ChecklistItemStatusPending,
		Required:    req.Required,
		Sequence:    req.Sequence,
	}
	if err := s.repo.AddItem(ctx, item); err != nil {
		return nil, fmt.Errorf("adding item: %w", err)
	}
	if err := s.repo.TouchChecklist(ctx, req.ChecklistID); err != nil {
		return nil, err
	}
	return item, nil
}

func (s *Service) UpdateChecklistItem(ctx context.Context, req domain.UpdateChecklistItemRequest) (*domain.ChecklistItem, error) {
	item, err := s.repo.GetItemByID(ctx, req.ItemID)
	if err != nil {
		return nil, fmt.Errorf("item not found: %w", err)
	}
	item.Status = req.Status
	item.CompletedBy = req.CompletedBy
	item.Notes = req.Notes

	if req.Status == domain.ChecklistItemStatusPass || req.Status == domain.ChecklistItemStatusFail ||
		req.Status == domain.ChecklistItemStatusNotApplicable {
		now := time.Now().UTC()
		item.CompletedAt = &now
	}

	if err := s.repo.UpdateItem(ctx, item); err != nil {
		return nil, fmt.Errorf("updating item: %w", err)
	}

	// Recompute checklist status
	if err := s.recomputeStatus(ctx, item.ChecklistID); err != nil {
		s.logger.Warn().Err(err).Msg("recompute status failed")
	}
	return item, nil
}

// recomputeStatus examines all items and advances the checklist status when
// all required items are resolved.
func (s *Service) recomputeStatus(ctx context.Context, checklistID uuid.UUID) error {
	items, err := s.repo.ListChecklistItemsByChecklist(ctx, checklistID)
	if err != nil {
		return err
	}

	allResolved := true
	for _, item := range items {
		if item.Required && item.Status == domain.ChecklistItemStatusPending {
			allResolved = false
			break
		}
	}

	if allResolved && len(items) > 0 {
		return s.repo.UpdateChecklistStatus(ctx, checklistID, domain.CommissioningStatusCompleted)
	}
	return s.repo.UpdateChecklistStatus(ctx, checklistID, domain.CommissioningStatusInProgress)
}

// ── Signoff ───────────────────────────────────────────────────────────────

// SignOffChecklist records a signoff and advances the checklist to SIGNED_OFF
// once at least one signoff exists (business rule: at least one engineer signoff required).
func (s *Service) SignOffChecklist(ctx context.Context, req domain.SignOffChecklistRequest) (*domain.CommissioningSignoff, *domain.CommissioningChecklist, error) {
	if req.SignedBy == "" {
		return nil, nil, fmt.Errorf("signed_by is required")
	}
	if req.Role == "" {
		return nil, nil, fmt.Errorf("role is required")
	}

	cl, err := s.repo.GetChecklistByID(ctx, req.ChecklistID)
	if err != nil {
		return nil, nil, fmt.Errorf("checklist not found: %w", err)
	}
	if cl.Status < domain.CommissioningStatusCompleted {
		return nil, nil, fmt.Errorf("checklist must be COMPLETED before signing off (current: %s)", cl.Status)
	}

	signoff := &domain.CommissioningSignoff{
		ID:          uuid.New(),
		ChecklistID: req.ChecklistID,
		SignedBy:    req.SignedBy,
		Role:        req.Role,
		Comments:    req.Comments,
		SignedAt:    time.Now().UTC(),
	}
	if err := s.repo.AddSignoff(ctx, signoff); err != nil {
		return nil, nil, fmt.Errorf("recording signoff: %w", err)
	}
	if err := s.repo.UpdateChecklistStatus(ctx, req.ChecklistID, domain.CommissioningStatusSignedOff); err != nil {
		return nil, nil, err
	}

	updated, err := s.repo.GetChecklistByID(ctx, req.ChecklistID)
	if err != nil {
		return signoff, nil, err
	}
	return signoff, updated, nil
}

func (s *Service) ListSignoffs(ctx context.Context, checklistID uuid.UUID) ([]domain.CommissioningSignoff, error) {
	return s.repo.ListSignoffsByChecklist(ctx, checklistID)
}

// ── Handover ──────────────────────────────────────────────────────────────

// CreateHandover creates a formal handover record. The checklist must be SIGNED_OFF.
func (s *Service) CreateHandover(ctx context.Context, req domain.CreateHandoverRequest) (*domain.HandoverRecord, error) {
	if req.HandedOverBy == "" {
		return nil, fmt.Errorf("handed_over_by is required")
	}
	if req.ReceivedBy == "" {
		return nil, fmt.Errorf("received_by is required")
	}

	cl, err := s.repo.GetChecklistByID(ctx, req.ChecklistID)
	if err != nil {
		return nil, fmt.Errorf("checklist not found: %w", err)
	}
	if cl.Status < domain.CommissioningStatusSignedOff {
		return nil, fmt.Errorf("checklist must be SIGNED_OFF before handover (current: %s)", cl.Status)
	}

	now := time.Now().UTC()
	h := &domain.HandoverRecord{
		ID:           uuid.New(),
		ProjectID:    req.ProjectID,
		ChecklistID:  req.ChecklistID,
		HandedOverBy: req.HandedOverBy,
		ReceivedBy:   req.ReceivedBy,
		Notes:        req.Notes,
		ArtifactIDs:  req.ArtifactIDs,
		HandoverDate: now,
		CreatedAt:    now,
	}
	if err := s.repo.CreateHandover(ctx, h); err != nil {
		return nil, fmt.Errorf("creating handover: %w", err)
	}
	if err := s.repo.UpdateChecklistStatus(ctx, req.ChecklistID, domain.CommissioningStatusHandedOver); err != nil {
		return nil, err
	}
	return h, nil
}

func (s *Service) GetHandover(ctx context.Context, id uuid.UUID) (*domain.HandoverRecord, error) {
	return s.repo.GetHandoverByID(ctx, id)
}

// ── AsBuilt ───────────────────────────────────────────────────────────────

func (s *Service) RecordAsBuilt(ctx context.Context, req domain.RecordAsBuiltRequest) (*domain.AsBuiltArtifact, error) {
	if req.Name == "" {
		return nil, fmt.Errorf("name is required")
	}
	if req.StorageURL == "" {
		return nil, fmt.Errorf("storage_url is required")
	}
	if req.UploadedBy == "" {
		return nil, fmt.Errorf("uploaded_by is required")
	}

	a := &domain.AsBuiltArtifact{
		ID:            uuid.New(),
		ProjectID:     req.ProjectID,
		Name:          req.Name,
		ArtifactType:  req.ArtifactType,
		StorageURL:    req.StorageURL,
		UploadedBy:    req.UploadedBy,
		UploadedAt:    time.Now().UTC(),
		Description:   req.Description,
		FileSizeBytes: req.FileSizeBytes,
		Revision:      req.Revision,
	}
	if err := s.repo.RecordAsBuilt(ctx, a); err != nil {
		return nil, fmt.Errorf("recording as-built: %w", err)
	}
	return a, nil
}

func (s *Service) ListAsBuiltArtifacts(ctx context.Context, projectID uuid.UUID) ([]domain.AsBuiltArtifact, error) {
	return s.repo.ListAsBuiltByProject(ctx, projectID)
}

// ── Report ─────────────────────────────────────────────────────────────────

// GenerateReport produces a plain-text commissioning report for a checklist.
// All sections, item statuses, and signoffs are included so the report is
// self-contained and traceable.
func (s *Service) GenerateReport(ctx context.Context, req domain.GenerateReportRequest) (string, error) {
	cl, err := s.repo.GetChecklistByID(ctx, req.ChecklistID)
	if err != nil {
		return "", fmt.Errorf("checklist not found: %w", err)
	}

	var sb strings.Builder
	sb.WriteString("COMMISSIONING REPORT\n")
	sb.WriteString("====================\n\n")
	sb.WriteString(fmt.Sprintf("Checklist : %s\n", cl.Name))
	sb.WriteString(fmt.Sprintf("ID        : %s\n", cl.ID))
	sb.WriteString(fmt.Sprintf("Project   : %s\n", cl.ProjectID))
	sb.WriteString(fmt.Sprintf("Status    : %s\n", cl.Status))
	sb.WriteString(fmt.Sprintf("Created   : %s\n", cl.CreatedAt.Format(time.RFC3339)))
	sb.WriteString(fmt.Sprintf("Updated   : %s\n", cl.UpdatedAt.Format(time.RFC3339)))

	total, completed, failed := cl.DerivedCounts()
	sb.WriteString(fmt.Sprintf("Items     : %d total, %d resolved, %d failed\n\n", total, completed, failed))

	// Group items by section
	sections := []domain.ChecklistSection{
		domain.ChecklistSectionCivil,
		domain.ChecklistSectionMechanical,
		domain.ChecklistSectionElectrical,
		domain.ChecklistSectionProtection,
		domain.ChecklistSectionSCADA,
		domain.ChecklistSectionSafety,
		domain.ChecklistSectionDocumentation,
	}
	sectionNames := map[domain.ChecklistSection]string{
		domain.ChecklistSectionCivil:         "Civil",
		domain.ChecklistSectionMechanical:    "Mechanical",
		domain.ChecklistSectionElectrical:    "Electrical",
		domain.ChecklistSectionProtection:    "Protection",
		domain.ChecklistSectionSCADA:         "SCADA",
		domain.ChecklistSectionSafety:        "Safety",
		domain.ChecklistSectionDocumentation: "Documentation",
	}

	for _, sec := range sections {
		var secItems []domain.ChecklistItem
		for _, item := range cl.Items {
			if item.Section == sec {
				secItems = append(secItems, item)
			}
		}
		if len(secItems) == 0 {
			continue
		}
		sb.WriteString(fmt.Sprintf("— %s —\n", sectionNames[sec]))
		for _, item := range secItems {
			req := "  "
			if item.Required {
				req = "* "
			}
			statusStr := itemStatusString(item.Status)
			sb.WriteString(fmt.Sprintf("  %s[%s] %s\n", req, statusStr, item.Description))
			if item.Notes != "" {
				sb.WriteString(fmt.Sprintf("       Notes: %s\n", item.Notes))
			}
			if item.CompletedBy != "" {
				sb.WriteString(fmt.Sprintf("       By: %s\n", item.CompletedBy))
			}
		}
		sb.WriteString("\n")
	}

	// Signoffs
	if len(cl.Signoffs) > 0 {
		sb.WriteString("SIGNOFFS\n")
		sb.WriteString("--------\n")
		for _, sig := range cl.Signoffs {
			sb.WriteString(fmt.Sprintf("  %s (%s) — %s\n", sig.SignedBy, sig.Role, sig.SignedAt.Format("2006-01-02 15:04")))
			if sig.Comments != "" {
				sb.WriteString(fmt.Sprintf("    Comment: %s\n", sig.Comments))
			}
		}
		sb.WriteString("\n")
	}

	sb.WriteString("* required items\n")
	sb.WriteString(fmt.Sprintf("\nGenerated: %s\n", time.Now().UTC().Format(time.RFC3339)))
	return sb.String(), nil
}

func itemStatusString(s domain.ChecklistItemStatus) string {
	switch s {
	case domain.ChecklistItemStatusPass:
		return "PASS"
	case domain.ChecklistItemStatusFail:
		return "FAIL"
	case domain.ChecklistItemStatusNotApplicable:
		return "N/A "
	default:
		return "    "
	}
}
