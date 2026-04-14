package service

// Unit tests for the LOD 400 gate helpers wired into the report service.
//
// Coverage strategy:
//   - requiresLOD400Gate: all five ReportType values.
//   - validateLOD400Ready: uuid.Nil short-circuit (no DB needed).
//   - ExportLayout: nil LayoutID + missing approval → ErrApprovalRequired
//     (confirms LOD gate is skipped for nil LayoutID, approval still enforced).
//   - GenerateReport: non-BOM type, nil LayoutID, missing approval → ErrApprovalRequired.
//
// Note: paths that query lod400_checklist_results require a real DB and are
// out of scope here; the nil-UUID short-circuit covers the non-DB portion.

import (
	"context"
	"errors"
	"testing"

	"github.com/google/uuid"

	"solar3d/report-service/internal/domain"
)

// ─────────────────────────────────────────────────────────────────────────────
// requiresLOD400Gate
// ─────────────────────────────────────────────────────────────────────────────

func TestRequiresLOD400Gate_BOM_ReturnsFalse(t *testing.T) {
	if requiresLOD400Gate(domain.ReportTypeBOM) {
		t.Error("BOM reports must not require LOD 400 gate")
	}
}

func TestRequiresLOD400Gate_Layout_ReturnsTrue(t *testing.T) {
	if !requiresLOD400Gate(domain.ReportTypeLayout) {
		t.Error("Layout reports must require LOD 400 gate")
	}
}

func TestRequiresLOD400Gate_Electrical_ReturnsTrue(t *testing.T) {
	if !requiresLOD400Gate(domain.ReportTypeElectrical) {
		t.Error("Electrical reports must require LOD 400 gate")
	}
}

func TestRequiresLOD400Gate_Simulation_ReturnsTrue(t *testing.T) {
	if !requiresLOD400Gate(domain.ReportTypeSimulation) {
		t.Error("Simulation reports must require LOD 400 gate")
	}
}

func TestRequiresLOD400Gate_Full_ReturnsTrue(t *testing.T) {
	if !requiresLOD400Gate(domain.ReportTypeFull) {
		t.Error("Full reports must require LOD 400 gate")
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// validateLOD400Ready — uuid.Nil short-circuit (no DB path exercised)
// ─────────────────────────────────────────────────────────────────────────────

func TestValidateLOD400Ready_NilLayoutID_ReturnsNil(t *testing.T) {
	// nil repo is safe: uuid.Nil causes early return before any repo call.
	err := validateLOD400Ready(context.Background(), uuid.Nil, nil)
	if err != nil {
		t.Errorf("expected nil for nil layout_id, got %v", err)
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// ExportLayout — approval gate still fires when LayoutID is nil
// ─────────────────────────────────────────────────────────────────────────────

func TestExportLayout_NilLayoutID_MissingApproval_ReturnsApprovalError(t *testing.T) {
	// nil repo is safe: LayoutID == uuid.Nil skips the LOD gate entirely;
	// the approval check fires before any repo access.
	svc := &ReportService{repo: nil}
	_, err := svc.ExportLayout(context.Background(), domain.ExportLayoutRequest{
		ProjectID: uuid.New(),
		LayoutID:  uuid.Nil,
		Format:    domain.ReportFormatJSON,
		// ApprovalStatus intentionally omitted
	})
	if err == nil {
		t.Fatal("expected ErrApprovalRequired, got nil")
	}
	if !errors.Is(err, ErrApprovalRequired) {
		t.Errorf("expected ErrApprovalRequired, got %v", err)
	}
}

func TestExportLayout_NilLayoutID_InvalidApprovalStatus_ReturnsApprovalError(t *testing.T) {
	svc := &ReportService{repo: nil}
	_, err := svc.ExportLayout(context.Background(), domain.ExportLayoutRequest{
		ProjectID:      uuid.New(),
		LayoutID:       uuid.Nil,
		Format:         domain.ReportFormatPDF,
		ApprovalStatus: "pending",
		ApprovedBy:     "eng-01",
	})
	if err == nil {
		t.Fatal("expected ErrApprovalRequired, got nil")
	}
	if !errors.Is(err, ErrApprovalRequired) {
		t.Errorf("expected ErrApprovalRequired, got %v", err)
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// GenerateReport — LOD gate fires for non-BOM types with nil LayoutID
// still returns ErrApprovalRequired (approval checked first)
// ─────────────────────────────────────────────────────────────────────────────

func TestGenerateReport_LayoutType_NilLayoutID_MissingApproval_ReturnsApprovalError(t *testing.T) {
	// LayoutID == uuid.Nil skips the LOD repo call; approval check fires first.
	svc := &ReportService{repo: nil}
	_, err := svc.GenerateReport(context.Background(), domain.GenerateReportRequest{
		ProjectID:  uuid.New(),
		LayoutID:   uuid.Nil,
		ReportType: domain.ReportTypeLayout,
		Format:     domain.ReportFormatPDF,
		Name:       "Layout Report",
		// ApprovalStatus intentionally omitted
	})
	if err == nil {
		t.Fatal("expected ErrApprovalRequired, got nil")
	}
	if !errors.Is(err, ErrApprovalRequired) {
		t.Errorf("expected ErrApprovalRequired, got %v", err)
	}
}

func TestGenerateReport_FullType_NilLayoutID_MissingApproval_ReturnsApprovalError(t *testing.T) {
	svc := &ReportService{repo: nil}
	_, err := svc.GenerateReport(context.Background(), domain.GenerateReportRequest{
		ProjectID:  uuid.New(),
		LayoutID:   uuid.Nil,
		ReportType: domain.ReportTypeFull,
		Format:     domain.ReportFormatJSON,
		Name:       "Full Report",
	})
	if err == nil {
		t.Fatal("expected ErrApprovalRequired, got nil")
	}
	if !errors.Is(err, ErrApprovalRequired) {
		t.Errorf("expected ErrApprovalRequired, got %v", err)
	}
}

// ─────────────────────────────────────────────────────────────────────────────
// ErrLOD400GateNotPassed — sentinel exists and is distinct from ErrApprovalRequired
// ─────────────────────────────────────────────────────────────────────────────

func TestErrLOD400GateNotPassed_IsDistinctFromErrApprovalRequired(t *testing.T) {
	if errors.Is(ErrLOD400GateNotPassed, ErrApprovalRequired) {
		t.Error("ErrLOD400GateNotPassed must not unwrap to ErrApprovalRequired")
	}
	if ErrLOD400GateNotPassed == nil {
		t.Error("ErrLOD400GateNotPassed sentinel must not be nil")
	}
}
