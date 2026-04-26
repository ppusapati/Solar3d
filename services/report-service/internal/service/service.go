package service

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"p9e.in/samavaya/solar3d/report-service/internal/domain"
	"p9e.in/samavaya/solar3d/report-service/internal/repository"
	"p9e.in/samavaya/packages/audit"
)

type ReportService struct {
	repo *repository.ReportRepository
}

var ErrApprovalRequired = errors.New("approved engineering output is required")
var ErrLOD400GateNotPassed = errors.New("LOD 400 assessment must pass before export")

func NewReportService(repo *repository.ReportRepository) *ReportService {
	return &ReportService{repo: repo}
}

func (s *ReportService) GenerateReport(ctx context.Context, req domain.GenerateReportRequest) (*domain.Report, error) {
	var approvedAt time.Time
	if requiresApprovedOutput(req.ReportType) {
		var err error
		approvedAt, err = validateApprovedOutput(req.ApprovalStatus, req.ApprovedBy, req.ApprovedAtRFC3339)
		if err != nil {
			return nil, fmt.Errorf("%w: %v", ErrApprovalRequired, err)
		}
	}
	if requiresLOD400Gate(req.ReportType) {
		if err := validateLOD400Ready(ctx, req.LayoutID, s.repo); err != nil {
			return nil, err
		}
	}

	report := &domain.Report{
		ID:         uuid.New(),
		ProjectID:  req.ProjectID,
		Name:       req.Name,
		ReportType: req.ReportType,
		Format:     req.Format,
		Status:     domain.ReportStatusPending,
		CreatedAt:  time.Now().UTC(),
	}

	if err := s.repo.Create(ctx, report); err != nil {
		return nil, fmt.Errorf("creating report: %w", err)
	}

	log.Info().
		Str("report_id", report.ID.String()).
		Str("type", string(report.ReportType)).
		Str("format", string(report.Format)).
		Msg("report generation started")

	// Update status to running
	filePath := fmt.Sprintf("/reports/%s/%s.%s", report.ProjectID, report.ID, report.Format)
	if err := s.repo.UpdateStatus(ctx, report.ID, domain.ReportStatusRunning, ""); err != nil {
		return nil, fmt.Errorf("updating report status: %w", err)
	}

	// Mark as completed with file path
	if err := s.repo.UpdateStatus(ctx, report.ID, domain.ReportStatusCompleted, filePath); err != nil {
		return nil, fmt.Errorf("completing report: %w", err)
	}

	report.Status = domain.ReportStatusCompleted
	report.FilePath = filePath
	now := time.Now().UTC()
	report.CompletedAt = &now

	log.Info().
		Str("report_id", report.ID.String()).
		Str("file_path", filePath).
		Msg("report generation completed")

	event := audit.NewAuditEvent(audit.EventCreated, "report", report.ID.String(), actorIDFromContext(ctx, "report-service"))
	event.RecordMetadata("project_id", report.ProjectID.String())
	event.RecordMetadata("format", string(report.Format))
	event.RecordMetadata("type", string(report.ReportType))
	if requiresApprovedOutput(req.ReportType) {
		event.RecordMetadata("approval_status", strings.ToLower(strings.TrimSpace(req.ApprovalStatus)))
		event.RecordMetadata("approved_by", strings.TrimSpace(req.ApprovedBy))
		event.RecordMetadata("approved_at", approvedAt.UTC().Format(time.RFC3339))
	}
	if requiresLOD400Gate(req.ReportType) && req.LayoutID != uuid.Nil {
		event.RecordMetadata("layout_id", req.LayoutID.String())
		event.RecordMetadata("lod400_gate", "passed")
	}
	audit.LogToContext(ctx, event)

	return report, nil
}

func (s *ReportService) GetReport(ctx context.Context, id uuid.UUID) (*domain.Report, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *ReportService) ListReports(ctx context.Context, projectID uuid.UUID) ([]domain.Report, error) {
	return s.repo.ListByProject(ctx, projectID)
}

func (s *ReportService) DeleteReport(ctx context.Context, id uuid.UUID) error {
	if err := s.repo.Delete(ctx, id); err != nil {
		return err
	}
	event := audit.NewAuditEvent(audit.EventDeleted, "report", id.String(), actorIDFromContext(ctx, "report-service"))
	audit.LogToContext(ctx, event)
	return nil
}

func (s *ReportService) GenerateBOM(ctx context.Context, req domain.GenerateBOMRequest) (*domain.BillOfMaterials, error) {
	log.Info().
		Str("project_id", req.ProjectID.String()).
		Int("panels", req.PanelCount).
		Int("inverters", req.InverterCount).
		Msg("generating bill of materials")

	bom := &domain.BillOfMaterials{
		TotalPanels:       req.PanelCount,
		TotalInverters:    req.InverterCount,
		TotalTransformers: req.TransformerCount,
		TotalCableLengthM: req.CableLengthM,
	}

	// Panel items
	if req.PanelCount > 0 {
		panelName := req.PanelName
		if panelName == "" {
			panelName = "Solar Panel"
		}
		bom.Items = append(bom.Items, domain.BOMItem{
			Category:  "Panels",
			Name:      panelName,
			Spec:      req.PanelSpec,
			Quantity:  req.PanelCount,
			Unit:      "pcs",
			UnitCost:  req.PanelUnitCost,
			TotalCost: float64(req.PanelCount) * req.PanelUnitCost,
		})
	}

	// Inverter items
	if req.InverterCount > 0 {
		inverterName := req.InverterName
		if inverterName == "" {
			inverterName = "String Inverter"
		}
		bom.Items = append(bom.Items, domain.BOMItem{
			Category:  "Inverters",
			Name:      inverterName,
			Spec:      req.InverterSpec,
			Quantity:  req.InverterCount,
			Unit:      "pcs",
			UnitCost:  req.InverterUnitCost,
			TotalCost: float64(req.InverterCount) * req.InverterUnitCost,
		})
	}

	// Transformer items
	if req.TransformerCount > 0 {
		transformerName := req.TransformerName
		if transformerName == "" {
			transformerName = "Step-Up Transformer"
		}
		bom.Items = append(bom.Items, domain.BOMItem{
			Category:  "Transformers",
			Name:      transformerName,
			Spec:      req.TransformerSpec,
			Quantity:  req.TransformerCount,
			Unit:      "pcs",
			UnitCost:  req.TransformerUnitCost,
			TotalCost: float64(req.TransformerCount) * req.TransformerUnitCost,
		})
	}

	// Cabling
	if req.CableLengthM > 0 {
		costPerM := req.CableCostPerM
		if costPerM <= 0 {
			costPerM = 15.0
		}
		bom.Items = append(bom.Items, domain.BOMItem{
			Category:  "Cabling",
			Name:      "DC Cable",
			Spec:      "4mm2 solar cable",
			Quantity:  int(req.CableLengthM),
			Unit:      "m",
			UnitCost:  costPerM,
			TotalCost: req.CableLengthM * costPerM,
		})
	}

	// Mounting structure estimate: ~2 mounting rails per panel
	if req.PanelCount > 0 {
		mountingQty := req.PanelCount * 2
		mountingCost := 8.50
		bom.Items = append(bom.Items, domain.BOMItem{
			Category:  "Mounting",
			Name:      "Mounting Rail",
			Spec:      "Aluminum rail 2.1m",
			Quantity:  mountingQty,
			Unit:      "pcs",
			UnitCost:  mountingCost,
			TotalCost: float64(mountingQty) * mountingCost,
		})

		// Clamps: 4 per panel
		clampQty := req.PanelCount * 4
		clampCost := 1.20
		bom.Items = append(bom.Items, domain.BOMItem{
			Category:  "Mounting",
			Name:      "Panel Clamp",
			Spec:      "Mid/End clamp",
			Quantity:  clampQty,
			Unit:      "pcs",
			UnitCost:  clampCost,
			TotalCost: float64(clampQty) * clampCost,
		})
	}

	// Calculate total cost
	var totalCost float64
	for _, item := range bom.Items {
		totalCost += item.TotalCost
	}
	bom.TotalCost = totalCost

	// Save as a report
	bomJSON, err := json.Marshal(bom)
	if err != nil {
		return nil, fmt.Errorf("marshaling BOM: %w", err)
	}

	filePath := fmt.Sprintf("/reports/%s/bom-%s.json", req.ProjectID, time.Now().Format("20060102"))
	report := &domain.Report{
		ID:         uuid.New(),
		ProjectID:  req.ProjectID,
		Name:       "Bill of Materials",
		ReportType: domain.ReportTypeBOM,
		Format:     domain.ReportFormatJSON,
		FilePath:   filePath,
		Status:     domain.ReportStatusCompleted,
		CreatedAt:  time.Now().UTC(),
	}
	now := time.Now().UTC()
	report.CompletedAt = &now

	// Store report content via repository (written to configured storage backend)
	if err := s.repo.StoreContent(ctx, filePath, bomJSON); err != nil {
		log.Warn().Err(err).Str("path", filePath).Msg("failed to store BOM content; report metadata still persisted")
	}
	if err := s.repo.Create(ctx, report); err != nil {
		log.Warn().Err(err).Msg("failed to persist BOM report record")
	}

	log.Info().
		Float64("total_cost", totalCost).
		Int("item_count", len(bom.Items)).
		Msg("BOM generated")

	event := audit.NewAuditEvent(audit.EventCreated, "report", report.ID.String(), actorIDFromContext(ctx, "report-service"))
	event.RecordMetadata("project_id", req.ProjectID.String())
	event.RecordMetadata("report_kind", "bom")
	audit.LogToContext(ctx, event)

	return bom, nil
}

func (s *ReportService) ExportLayout(ctx context.Context, req domain.ExportLayoutRequest) (*domain.Report, error) {
	approvedAt, err := validateApprovedOutput(req.ApprovalStatus, req.ApprovedBy, req.ApprovedAtRFC3339)
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrApprovalRequired, err)
	}
	if err := validateLOD400Ready(ctx, req.LayoutID, s.repo); err != nil {
		return nil, err
	}

	report := &domain.Report{
		ID:         uuid.New(),
		ProjectID:  req.ProjectID,
		Name:       "Layout Export",
		ReportType: domain.ReportTypeLayout,
		Format:     req.Format,
		FilePath:   fmt.Sprintf("/reports/%s/layout-%s.%s", req.ProjectID, time.Now().Format("20060102"), req.Format),
		Status:     domain.ReportStatusCompleted,
		CreatedAt:  time.Now().UTC(),
	}
	now := time.Now().UTC()
	report.CompletedAt = &now

	if err := s.repo.Create(ctx, report); err != nil {
		return nil, fmt.Errorf("creating layout export report: %w", err)
	}

	log.Info().
		Str("report_id", report.ID.String()).
		Str("format", string(req.Format)).
		Msg("layout exported")

	event := audit.NewAuditEvent(audit.EventCreated, "report", report.ID.String(), actorIDFromContext(ctx, "report-service"))
	event.RecordMetadata("project_id", req.ProjectID.String())
	event.RecordMetadata("report_kind", "layout_export")
	event.RecordMetadata("approval_status", strings.ToLower(strings.TrimSpace(req.ApprovalStatus)))
	event.RecordMetadata("approved_by", strings.TrimSpace(req.ApprovedBy))
	event.RecordMetadata("approved_at", approvedAt.UTC().Format(time.RFC3339))
	if req.LayoutID != uuid.Nil {
		event.RecordMetadata("layout_id", req.LayoutID.String())
		event.RecordMetadata("lod400_gate", "passed")
	}
	audit.LogToContext(ctx, event)

	return report, nil
}

func actorIDFromContext(ctx context.Context, fallback string) string {
	if v, ok := ctx.Value("actor_id").(string); ok && v != "" {
		return v
	}
	return fallback
}

func requiresApprovedOutput(reportType domain.ReportType) bool {
	return reportType != domain.ReportTypeBOM
}

func requiresLOD400Gate(reportType domain.ReportType) bool {
	return reportType != domain.ReportTypeBOM
}

// validateLOD400Ready checks that the most recent LOD 400 assessment for the given
// layout has is_lod400_ready = true.  If layoutID is uuid.Nil, the check is skipped
// for backward compatibility with callers that have not yet wired a layout_id.
func validateLOD400Ready(ctx context.Context, layoutID uuid.UUID, repo *repository.ReportRepository) error {
	if layoutID == uuid.Nil {
		return nil
	}
	ready, err := repo.GetLatestLOD400ReadyStatus(ctx, layoutID)
	if err != nil {
		if errors.Is(err, repository.ErrNoLOD400Assessment) {
			return fmt.Errorf("%w: no LOD 400 assessment found for layout %s", ErrLOD400GateNotPassed, layoutID)
		}
		return fmt.Errorf("querying LOD 400 status: %w", err)
	}
	if !ready {
		return fmt.Errorf("%w: layout %s has not passed LOD 400 assessment", ErrLOD400GateNotPassed, layoutID)
	}
	return nil
}

func validateApprovedOutput(status string, approvedBy string, approvedAtRFC3339 string) (time.Time, error) {
	if strings.ToLower(strings.TrimSpace(status)) != "approved" {
		return time.Time{}, fmt.Errorf("approval_status must be approved")
	}
	if strings.TrimSpace(approvedBy) == "" {
		return time.Time{}, fmt.Errorf("approved_by is required")
	}
	approvedAt, err := time.Parse(time.RFC3339, strings.TrimSpace(approvedAtRFC3339))
	if err != nil {
		return time.Time{}, fmt.Errorf("approved_at_rfc3339 must be RFC3339")
	}
	return approvedAt.UTC(), nil
}
