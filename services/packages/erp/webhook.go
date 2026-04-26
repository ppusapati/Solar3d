package erp

import (
	"encoding/json"
	"fmt"
	"time"
)

// ========================================================================
// ERP Webhook Receiver
// ========================================================================

// WebhookEvent represents an inbound event from the ERP system. ERPs push
// status updates (PO issued, shipment dispatched, material received) to
// Solar3D so the construction phase gate can track procurement readiness.
type WebhookEvent struct {
	EventID     string          `json:"event_id"`
	EventType   WebhookEventType `json:"event_type"`
	ProjectID   string          `json:"project_id"`
	PONumber    string          `json:"po_number,omitempty"`
	MaterialCode string         `json:"material_code,omitempty"`
	Quantity    int             `json:"quantity,omitempty"`
	Status      string          `json:"status"`       // ERP-specific status string
	Timestamp   time.Time       `json:"timestamp"`
	Metadata    json.RawMessage `json:"metadata,omitempty"`
}

// WebhookEventType identifies the category of ERP callback.
type WebhookEventType string

const (
	EventPOIssued         WebhookEventType = "po_issued"
	EventPOShipped        WebhookEventType = "po_shipped"
	EventPOReceived       WebhookEventType = "po_received"
	EventPOCancelled      WebhookEventType = "po_cancelled"
	EventInventoryUpdate  WebhookEventType = "inventory_update"
	EventPriceUpdate      WebhookEventType = "price_update"
)

// ========================================================================
// Material Reconciliation
// ========================================================================

// ERPInventoryItem represents a single material's current ERP inventory state.
type ERPInventoryItem struct {
	MaterialCode  string  `json:"material_code"`
	Description   string  `json:"description"`
	OnHandQty     int     `json:"on_hand_qty"`
	OnOrderQty    int     `json:"on_order_qty"`
	AllocatedQty  int     `json:"allocated_qty"`   // reserved for other projects
	AvailableQty  int     `json:"available_qty"`   // on_hand - allocated
	UnitCostUSD   float64 `json:"unit_cost_usd"`
	LeadTimeDays  int     `json:"lead_time_days"`
}

// ReconciliationResult compares BOM requirements against ERP inventory.
type ReconciliationResult struct {
	ProjectID     string              `json:"project_id"`
	CheckedAt     time.Time           `json:"checked_at"`
	TotalLines    int                 `json:"total_lines"`
	Fulfilled     int                 `json:"fulfilled"`     // lines with sufficient inventory
	Shortages     int                 `json:"shortages"`     // lines with insufficient inventory
	Lines         []ReconciliationLine `json:"lines"`
	ReadyForConstruction bool         `json:"ready_for_construction"`
}

// ReconciliationLine is the per-item result.
type ReconciliationLine struct {
	LineNumber      int    `json:"line_number"`
	MaterialCode    string `json:"material_code"`
	Description     string `json:"description"`
	RequiredQty     int    `json:"required_qty"`    // from BOM (including spares)
	AvailableQty    int    `json:"available_qty"`   // from ERP
	ShortageQty     int    `json:"shortage_qty"`    // max(0, required - available)
	OnOrderQty      int    `json:"on_order_qty"`
	EstDeliveryDays int    `json:"est_delivery_days"`
	CriticalPath    bool   `json:"critical_path"`
	Status          string `json:"status"`          // "fulfilled", "shortage", "on_order"
}

// Reconcile compares BOM export items against ERP inventory and returns
// a detailed reconciliation report.
func Reconcile(bom *BOMExport, inventory []ERPInventoryItem) *ReconciliationResult {
	invMap := make(map[string]*ERPInventoryItem, len(inventory))
	for i := range inventory {
		invMap[inventory[i].MaterialCode] = &inventory[i]
	}

	result := &ReconciliationResult{
		ProjectID:  bom.ProjectID,
		CheckedAt:  time.Now().UTC(),
		TotalLines: len(bom.Items),
		Lines:      make([]ReconciliationLine, 0, len(bom.Items)),
		ReadyForConstruction: true,
	}

	for _, item := range bom.Items {
		line := ReconciliationLine{
			LineNumber:   item.LineNumber,
			MaterialCode: item.ERPMaterialCode,
			Description:  fmt.Sprintf("%s %s", item.Manufacturer, item.Model),
			RequiredQty:  item.TotalWithSpares,
			CriticalPath: item.CriticalPath,
		}

		if inv, ok := invMap[item.ERPMaterialCode]; ok {
			line.AvailableQty = inv.AvailableQty
			line.OnOrderQty = inv.OnOrderQty
			line.EstDeliveryDays = inv.LeadTimeDays
		}

		line.ShortageQty = line.RequiredQty - line.AvailableQty
		if line.ShortageQty < 0 {
			line.ShortageQty = 0
		}

		if line.ShortageQty == 0 {
			line.Status = "fulfilled"
			result.Fulfilled++
		} else if line.OnOrderQty >= line.ShortageQty {
			line.Status = "on_order"
			result.Fulfilled++ // will be fulfilled
		} else {
			line.Status = "shortage"
			result.Shortages++
			if line.CriticalPath {
				result.ReadyForConstruction = false
			}
		}

		result.Lines = append(result.Lines, line)
	}

	// If there are no critical shortages but some non-critical ones,
	// construction can still proceed with substitutions.
	if result.Shortages > 0 && result.ReadyForConstruction {
		// Still ready if no critical-path items are short
		for _, l := range result.Lines {
			if l.Status == "shortage" && l.CriticalPath {
				result.ReadyForConstruction = false
				break
			}
		}
	}

	return result
}

// ========================================================================
// Procurement Gate
// ========================================================================

// ProcurementGateStatus summarises whether procurement is complete enough
// to advance to the construction phase.
type ProcurementGateStatus struct {
	ProjectID         string   `json:"project_id"`
	CanProceed        bool     `json:"can_proceed"`
	BlockerReasons    []string `json:"blocker_reasons,omitempty"`
	FulfilledPct      float64  `json:"fulfilled_pct"`
	CriticalShortages int      `json:"critical_shortages"`
}

// EvaluateProcurementGate checks whether the procurement gate allows
// construction to start. Requires all critical-path materials fulfilled.
func EvaluateProcurementGate(recon *ReconciliationResult) *ProcurementGateStatus {
	gate := &ProcurementGateStatus{
		ProjectID: recon.ProjectID,
		CanProceed: recon.ReadyForConstruction,
	}

	if recon.TotalLines > 0 {
		gate.FulfilledPct = float64(recon.Fulfilled) / float64(recon.TotalLines) * 100.0
	}

	for _, line := range recon.Lines {
		if line.Status == "shortage" && line.CriticalPath {
			gate.CriticalShortages++
			gate.BlockerReasons = append(gate.BlockerReasons,
				fmt.Sprintf("critical material shortage: %s (%s) — need %d, available %d",
					line.Description, line.MaterialCode, line.RequiredQty, line.AvailableQty))
		}
	}

	return gate
}
