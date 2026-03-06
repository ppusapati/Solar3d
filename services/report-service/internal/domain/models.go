package domain

import (
	"time"

	"github.com/google/uuid"
)

type ReportStatus string

const (
	ReportStatusPending   ReportStatus = "pending"
	ReportStatusRunning   ReportStatus = "running"
	ReportStatusCompleted ReportStatus = "completed"
	ReportStatusFailed    ReportStatus = "failed"
)

type ReportType string

const (
	ReportTypeBOM        ReportType = "bom"
	ReportTypeLayout     ReportType = "layout"
	ReportTypeElectrical ReportType = "electrical"
	ReportTypeSimulation ReportType = "simulation"
	ReportTypeFull       ReportType = "full"
)

type ReportFormat string

const (
	ReportFormatJSON ReportFormat = "json"
	ReportFormatCSV  ReportFormat = "csv"
	ReportFormatPDF  ReportFormat = "pdf"
)

type Report struct {
	ID          uuid.UUID    `json:"id"`
	ProjectID   uuid.UUID    `json:"project_id"`
	Name        string       `json:"name"`
	ReportType  ReportType   `json:"report_type"`
	Format      ReportFormat `json:"format"`
	FilePath    string       `json:"file_path"`
	Status      ReportStatus `json:"status"`
	CreatedAt   time.Time    `json:"created_at"`
	CompletedAt *time.Time   `json:"completed_at,omitempty"`
}

type BOMItem struct {
	Category  string  `json:"category"`
	Name      string  `json:"name"`
	Spec      string  `json:"spec"`
	Quantity  int     `json:"quantity"`
	Unit      string  `json:"unit"`
	UnitCost  float64 `json:"unit_cost"`
	TotalCost float64 `json:"total_cost"`
}

type BillOfMaterials struct {
	Items               []BOMItem `json:"items"`
	TotalCost           float64   `json:"total_cost"`
	TotalPanels         int       `json:"total_panels"`
	TotalInverters      int       `json:"total_inverters"`
	TotalTransformers   int       `json:"total_transformers"`
	TotalCableLengthM   float64   `json:"total_cable_length_m"`
}

type GenerateReportRequest struct {
	ProjectID  uuid.UUID    `json:"project_id"`
	Name       string       `json:"name"`
	ReportType ReportType   `json:"report_type"`
	Format     ReportFormat `json:"format"`
}

type GenerateBOMRequest struct {
	ProjectID        uuid.UUID `json:"project_id"`
	PanelCount       int       `json:"panel_count"`
	PanelName        string    `json:"panel_name"`
	PanelSpec        string    `json:"panel_spec"`
	PanelUnitCost    float64   `json:"panel_unit_cost"`
	InverterCount    int       `json:"inverter_count"`
	InverterName     string    `json:"inverter_name"`
	InverterSpec     string    `json:"inverter_spec"`
	InverterUnitCost float64   `json:"inverter_unit_cost"`
	TransformerCount int       `json:"transformer_count"`
	TransformerName  string    `json:"transformer_name"`
	TransformerSpec  string    `json:"transformer_spec"`
	TransformerUnitCost float64 `json:"transformer_unit_cost"`
	CableLengthM     float64  `json:"cable_length_m"`
	CableCostPerM    float64  `json:"cable_cost_per_m"`
}

type ExportLayoutRequest struct {
	ProjectID uuid.UUID    `json:"project_id"`
	Format    ReportFormat `json:"format"`
}
