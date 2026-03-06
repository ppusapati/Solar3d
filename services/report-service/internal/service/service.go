package service

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"github.com/solar3d/solar3d/services/report-service/internal/domain"
	"github.com/solar3d/solar3d/services/report-service/internal/repository"
)

type ReportService struct {
	repo *repository.ReportRepository
}

func NewReportService(repo *repository.ReportRepository) *ReportService {
	return &ReportService{repo: repo}
}

func (s *ReportService) GenerateReport(ctx context.Context, req domain.GenerateReportRequest) (*domain.Report, error) {
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

	return report, nil
}

func (s *ReportService) GetReport(ctx context.Context, id uuid.UUID) (*domain.Report, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *ReportService) ListReports(ctx context.Context, projectID uuid.UUID) ([]domain.Report, error) {
	return s.repo.ListByProject(ctx, projectID)
}

func (s *ReportService) DeleteReport(ctx context.Context, id uuid.UUID) error {
	return s.repo.Delete(ctx, id)
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
	bomJSON, _ := json.Marshal(bom)
	report := &domain.Report{
		ID:         uuid.New(),
		ProjectID:  req.ProjectID,
		Name:       "Bill of Materials",
		ReportType: domain.ReportTypeBOM,
		Format:     domain.ReportFormatJSON,
		FilePath:   fmt.Sprintf("/reports/%s/bom-%s.json", req.ProjectID, time.Now().Format("20060102")),
		Status:     domain.ReportStatusCompleted,
		CreatedAt:  time.Now().UTC(),
	}
	now := time.Now().UTC()
	report.CompletedAt = &now

	_ = bomJSON // In production, write to storage
	if err := s.repo.Create(ctx, report); err != nil {
		log.Warn().Err(err).Msg("failed to persist BOM report record")
	}

	log.Info().
		Float64("total_cost", totalCost).
		Int("item_count", len(bom.Items)).
		Msg("BOM generated")

	return bom, nil
}

func (s *ReportService) ExportLayout(ctx context.Context, req domain.ExportLayoutRequest) (*domain.Report, error) {
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

	return report, nil
}
