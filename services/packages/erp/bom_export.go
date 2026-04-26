// Package erp provides BOM export format adapters and ERP integration utilities
// for bridging Solar3D engineering data with external procurement systems.
package erp

import (
	"encoding/csv"
	"encoding/json"
	"fmt"
	"io"
	"strings"
	"time"
)

// BOMLineItem is the canonical export representation of a single BOM entry.
// It is richer than the internal report-service BOMItem, carrying fields that
// ERPs need for automated PO creation.
type BOMLineItem struct {
	LineNumber       int     `json:"line_number"`
	Category         string  `json:"category"`           // "panel", "inverter", "transformer", "cable", "combiner", "fuse", "mounting", "other"
	Manufacturer     string  `json:"manufacturer"`
	Model            string  `json:"model"`
	Description      string  `json:"description"`
	Quantity         int     `json:"quantity"`
	Unit             string  `json:"unit"`               // "ea", "m", "kg"
	UnitCostUSD      float64 `json:"unit_cost_usd"`
	TotalCostUSD     float64 `json:"total_cost_usd"`
	LeadTimeDays     int     `json:"lead_time_days"`     // 0 = unknown
	SparePct         float64 `json:"spare_pct"`          // spare parts percentage (e.g., 2.0 = 2%)
	SpareQuantity    int     `json:"spare_quantity"`
	TotalWithSpares  int     `json:"total_with_spares"`
	CriticalPath     bool    `json:"critical_path"`      // blocks construction start?
	ERPMaterialCode  string  `json:"erp_material_code"`  // mapped from ERP master data
	ProjectID        string  `json:"project_id"`
	ExportedAt       string  `json:"exported_at"`
}

// BOMExport is the complete export package.
type BOMExport struct {
	ProjectID     string        `json:"project_id"`
	ProjectName   string        `json:"project_name"`
	ExportedAt    time.Time     `json:"exported_at"`
	ExportFormat  string        `json:"export_format"`
	TotalLines    int           `json:"total_lines"`
	TotalCostUSD  float64       `json:"total_cost_usd"`
	Items         []BOMLineItem `json:"items"`
}

// ApplySpares adds spare parts quantities to each BOM line based on the
// spare percentage. Panels and fuses typically get 2–3% spares; inverters
// and transformers get 0% (replaced under warranty).
func (b *BOMExport) ApplySpares() {
	for i := range b.Items {
		item := &b.Items[i]
		if item.SparePct <= 0 {
			item.SparePct = defaultSparePct(item.Category)
		}
		item.SpareQuantity = int(float64(item.Quantity) * item.SparePct / 100.0)
		item.TotalWithSpares = item.Quantity + item.SpareQuantity
	}
}

func defaultSparePct(category string) float64 {
	switch category {
	case "panel":
		return 2.0
	case "fuse":
		return 5.0
	case "cable":
		return 3.0
	case "combiner":
		return 2.0
	case "mounting":
		return 2.0
	default:
		return 0.0 // inverters, transformers — warranty-covered
	}
}

// ========================================================================
// Format Adapters
// ========================================================================

// ExportFormat identifies the target ERP system format.
type ExportFormat string

const (
	FormatJSON    ExportFormat = "json"
	FormatCSV     ExportFormat = "csv"
	FormatSAP     ExportFormat = "sap_idoc"     // SAP IDoc MATMAS/BOMMAT
	FormatNetSuite ExportFormat = "netsuite_csv" // NetSuite CSV import
)

// ToJSON exports the BOM as indented JSON.
func (b *BOMExport) ToJSON(w io.Writer) error {
	enc := json.NewEncoder(w)
	enc.SetIndent("", "  ")
	return enc.Encode(b)
}

// ToCSV exports the BOM as a standard CSV with headers.
func (b *BOMExport) ToCSV(w io.Writer) error {
	cw := csv.NewWriter(w)
	defer cw.Flush()

	// Header
	if err := cw.Write([]string{
		"Line", "Category", "Manufacturer", "Model", "Description",
		"Qty", "Unit", "Unit Cost (USD)", "Total Cost (USD)",
		"Lead Time (days)", "Spare %", "Spare Qty", "Total w/ Spares",
		"Critical Path", "ERP Material Code", "Project ID", "Exported At",
	}); err != nil {
		return err
	}

	for _, item := range b.Items {
		if err := cw.Write([]string{
			fmt.Sprintf("%d", item.LineNumber),
			item.Category,
			item.Manufacturer,
			item.Model,
			item.Description,
			fmt.Sprintf("%d", item.Quantity),
			item.Unit,
			fmt.Sprintf("%.2f", item.UnitCostUSD),
			fmt.Sprintf("%.2f", item.TotalCostUSD),
			fmt.Sprintf("%d", item.LeadTimeDays),
			fmt.Sprintf("%.1f", item.SparePct),
			fmt.Sprintf("%d", item.SpareQuantity),
			fmt.Sprintf("%d", item.TotalWithSpares),
			fmt.Sprintf("%t", item.CriticalPath),
			item.ERPMaterialCode,
			item.ProjectID,
			item.ExportedAt,
		}); err != nil {
			return err
		}
	}
	return nil
}

// ToSAPIDoc exports the BOM in SAP IDoc BOMMAT-compatible flat format.
// Each line is a segment: E1STPOM (BOM item), E1STZOM (BOM header).
func (b *BOMExport) ToSAPIDoc(w io.Writer) error {
	var sb strings.Builder

	// Header segment
	sb.WriteString(fmt.Sprintf("E1STZOM|%s|%s|%s|%d\n",
		b.ProjectID, b.ProjectName, b.ExportedAt.Format("20060102"), b.TotalLines))

	// Item segments
	for _, item := range b.Items {
		sb.WriteString(fmt.Sprintf("E1STPOM|%04d|%s|%s|%s|%d|%s|%.2f|%.2f|%s\n",
			item.LineNumber, item.Category, item.Manufacturer, item.Model,
			item.TotalWithSpares, item.Unit, item.UnitCostUSD, item.TotalCostUSD,
			item.ERPMaterialCode))
	}

	_, err := io.WriteString(w, sb.String())
	return err
}

// ToNetSuiteCSV exports the BOM in NetSuite's standard CSV import format
// for Inventory Items / Purchase Orders.
func (b *BOMExport) ToNetSuiteCSV(w io.Writer) error {
	cw := csv.NewWriter(w)
	defer cw.Flush()

	// NetSuite standard import columns
	if err := cw.Write([]string{
		"External ID", "Item Name/Number", "Display Name", "Vendor Name",
		"Purchase Description", "Quantity", "Rate", "Amount",
		"Unit", "Lead Time", "Class",
	}); err != nil {
		return err
	}

	for _, item := range b.Items {
		extID := fmt.Sprintf("S3D-%s-%04d", b.ProjectID[:8], item.LineNumber)
		displayName := fmt.Sprintf("%s %s", item.Manufacturer, item.Model)
		class := "Solar - " + strings.Title(item.Category)

		if err := cw.Write([]string{
			extID,
			item.ERPMaterialCode,
			displayName,
			item.Manufacturer,
			item.Description,
			fmt.Sprintf("%d", item.TotalWithSpares),
			fmt.Sprintf("%.2f", item.UnitCostUSD),
			fmt.Sprintf("%.2f", item.TotalCostUSD),
			item.Unit,
			fmt.Sprintf("%d", item.LeadTimeDays),
			class,
		}); err != nil {
			return err
		}
	}
	return nil
}
