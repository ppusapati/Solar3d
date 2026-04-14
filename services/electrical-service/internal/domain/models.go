package domain

import (
	"time"

	"github.com/google/uuid"
)

// ========== Acceptance Status Enum ==========

// AcceptanceStatus represents the review/approval status of an electrical network.
type AcceptanceStatus int

const (
	AcceptanceStatusUnspecified AcceptanceStatus = iota
	AcceptanceStatusDraft
	AcceptanceStatusReviewPending
	AcceptanceStatusApproved
	AcceptanceStatusRejected
)

// String returns the human-readable status name.
func (as AcceptanceStatus) String() string {
	return map[AcceptanceStatus]string{
		AcceptanceStatusUnspecified:   "UNSPECIFIED",
		AcceptanceStatusDraft:         "DRAFT",
		AcceptanceStatusReviewPending: "REVIEW_PENDING",
		AcceptanceStatusApproved:      "APPROVED",
		AcceptanceStatusRejected:      "REJECTED",
	}[as]
}

// ReviewMetadata captures acceptance/approval workflow state.
type ReviewMetadata struct {
	Status                    AcceptanceStatus `json:"status"`
	ReviewedByActorID         string           `json:"reviewed_by_actor_id,omitempty"`
	ReviewedAt                *time.Time       `json:"reviewed_at,omitempty"`
	QualityScore              float64          `json:"quality_score"` // [0, 1]
	ReviewComments            []string         `json:"review_comments,omitempty"`
	Blockers                  []string         `json:"blockers,omitempty"` // Empty if approved
	ApprovalTimestampUnixSecs string           `json:"approval_timestamp_unix_secs,omitempty"`
}

// ========== Electrical Network Models ==========

type ElectricalNetwork struct {
	ID                         uuid.UUID       `json:"id"`
	ProjectID                  uuid.UUID       `json:"project_id"`
	LayoutID                   uuid.UUID       `json:"layout_id"`
	Name                       string          `json:"name"`
	TotalDCCapacityKW          float64         `json:"total_dc_capacity_kw"`
	TotalACCapacityKW          float64         `json:"total_ac_capacity_kw"`
	DCACRatio                  float64         `json:"dc_ac_ratio"`
	StringCount                int             `json:"string_count"`
	InverterCount              int             `json:"inverter_count"`
	ReviewMetadata             *ReviewMetadata `json:"review_metadata,omitempty"`
	ValidationViolations       []string        `json:"validation_violations,omitempty"`        // Empty if all validations pass
	ElectricalFeasibilityScore float64         `json:"electrical_feasibility_score,omitempty"` // [0, 1]
}

type PanelString struct {
	ID              uuid.UUID   `json:"id"`
	NetworkID       uuid.UUID   `json:"network_id"`
	InverterGroupID uuid.UUID   `json:"inverter_group_id"`
	PanelIDs        []uuid.UUID `json:"panel_ids"`
	PanelCount      int         `json:"panel_count"`
	Voltage         float64     `json:"voltage"`
	Current         float64     `json:"current"`
	PowerW          float64     `json:"power_w"`
}

type InverterGroup struct {
	ID              uuid.UUID   `json:"id"`
	NetworkID       uuid.UUID   `json:"network_id"`
	InverterAssetID uuid.UUID   `json:"inverter_asset_id"`
	StringIDs       []uuid.UUID `json:"string_ids"`
	DCInputKW       float64     `json:"dc_input_kw"`
	ACOutputKW      float64     `json:"ac_output_kw"`
	DCACRatio       float64     `json:"dc_ac_ratio"`
	Position        [2]float64  `json:"position"`
}

type CreateNetworkRequest struct {
	ProjectID uuid.UUID `json:"project_id"`
	LayoutID  uuid.UUID `json:"layout_id"`
	Name      string    `json:"name"`
}

type CreateStringRequest struct {
	NetworkID       uuid.UUID   `json:"network_id"`
	InverterGroupID uuid.UUID   `json:"inverter_group_id"`
	PanelIDs        []uuid.UUID `json:"panel_ids"`
	Voltage         float64     `json:"voltage"`
	Current         float64     `json:"current"`
}

type AutoGenerateRequest struct {
	NetworkID          uuid.UUID `json:"network_id"`
	PanelsPerString    int       `json:"panels_per_string"`
	StringsPerInverter int       `json:"strings_per_inverter"`
	PanelVoltage       float64   `json:"panel_voltage"`
	PanelCurrent       float64   `json:"panel_current"`
	PanelPowerW        float64   `json:"panel_power_w"`
	InverterAssetID    uuid.UUID `json:"inverter_asset_id"`
	InverterACKW       float64   `json:"inverter_ac_kw"`
	TotalPanels        int       `json:"total_panels"`
}

type AssignInverterRequest struct {
	NetworkID       uuid.UUID   `json:"network_id"`
	InverterAssetID uuid.UUID   `json:"inverter_asset_id"`
	StringIDs       []uuid.UUID `json:"string_ids"`
	Position        [2]float64  `json:"position"`
}

type LossBreakdown struct {
	SoilingLoss      float64 `json:"soiling_loss"`
	ShadingLoss      float64 `json:"shading_loss"`
	MismatchLoss     float64 `json:"mismatch_loss"`
	WiringLossDC     float64 `json:"wiring_loss_dc"`
	WiringLossAC     float64 `json:"wiring_loss_ac"`
	InverterLoss     float64 `json:"inverter_loss"`
	TransformerLoss  float64 `json:"transformer_loss"`
	TotalLossPercent float64 `json:"total_loss_percent"`
}

type SizingViolation struct {
	Code    string  `json:"code"`
	Message string  `json:"message"`
	Limit   float64 `json:"limit"`
	Actual  float64 `json:"actual"`
}

type ValidateSizingRequest struct {
	NetworkID            uuid.UUID `json:"network_id"`
	PanelVocV            float64   `json:"panel_voc_v"`
	PanelVmpV            float64   `json:"panel_vmp_v"`
	PanelIscA            float64   `json:"panel_isc_a"`
	PanelImpA            float64   `json:"panel_imp_a"`
	PanelsPerString      int       `json:"panels_per_string"`
	InverterVdcMaxV      float64   `json:"inverter_vdc_max_v"`
	InverterVmpptMinV    float64   `json:"inverter_vmppt_min_v"`
	InverterVmpptMaxV    float64   `json:"inverter_vmppt_max_v"`
	InverterIdcMaxA      float64   `json:"inverter_idc_max_a"`
	InverterACKW         float64   `json:"inverter_ac_kw"`
	DCACRatioMin         float64   `json:"dc_ac_ratio_min"`
	DCACRatioMax         float64   `json:"dc_ac_ratio_max"`
	TempCoeffVocPctPerC  float64   `json:"temp_coeff_voc_pct_per_c"`
	LowestExpectedTempC  float64   `json:"lowest_expected_temp_c"`
	HighestExpectedTempC float64   `json:"highest_expected_temp_c"`
}

type ValidateSizingResponse struct {
	Valid              bool              `json:"valid"`
	Violations         []SizingViolation `json:"violations"`
	StringVocColdV     float64           `json:"string_voc_cold_v"`
	StringVmpHotV      float64           `json:"string_vmp_hot_v"`
	DCStringPowerKW    float64           `json:"dc_string_power_kw"`
	DCACRatio          float64           `json:"dc_ac_ratio"`
	MaxPanelsPerString int               `json:"max_panels_per_string"`
	MinPanelsPerString int               `json:"min_panels_per_string"`
}

// ValidateNetworkRequest holds parameters for comprehensive network topology checking.
type ValidateNetworkRequest struct {
	NetworkID         uuid.UUID `json:"network_id"`
	InverterMPPTCount int       `json:"inverter_mppt_count"`  // 0 = skip MPPT check
	MaxStringsPerMPPT int       `json:"max_strings_per_mppt"` // 0 = skip MPPT check
}

// NetworkTopologyIssue describes a single network topology problem.
type NetworkTopologyIssue struct {
	Code     string `json:"code"`
	Message  string `json:"message"`
	EntityID string `json:"entity_id,omitempty"`
}

// ValidateNetworkResponse is the result of a full network topology validation.
type ValidateNetworkResponse struct {
	Valid              bool                   `json:"valid"`
	Issues             []NetworkTopologyIssue `json:"issues"`
	TotalStrings       int                    `json:"total_strings"`
	AssignedStrings    int                    `json:"assigned_strings"`
	UnassignedStrings  int                    `json:"unassigned_strings"`
	TotalPanels        int                    `json:"total_panels"`
	DuplicatePanelRefs int                    `json:"duplicate_panel_refs"`
	TotalDCKW          float64                `json:"total_dc_kw"`
	TotalACKW          float64                `json:"total_ac_kw"`
	DCACRatio          float64                `json:"dc_ac_ratio"`
}

// GenerateNetworkBOMRequest holds cost parameters for BOM derivation.
type GenerateNetworkBOMRequest struct {
	NetworkID            uuid.UUID `json:"network_id"`
	PanelUnitCost        float64   `json:"panel_unit_cost"`
	InverterUnitCost     float64   `json:"inverter_unit_cost"`
	CableCostPerM        float64   `json:"cable_cost_per_m"`
	MountingCostPerPanel float64   `json:"mounting_cost_per_panel"`
	CurrencyCode         string    `json:"currency_code"`
}

// NetworkBOMItem is a single BOM line derived from network topology.
type NetworkBOMItem struct {
	Category  string  `json:"category"`
	Name      string  `json:"name"`
	Quantity  int     `json:"quantity"`
	Unit      string  `json:"unit"`
	UnitCost  float64 `json:"unit_cost"`
	TotalCost float64 `json:"total_cost"`
}

// GenerateNetworkBOMResponse contains the derived BOM.
type GenerateNetworkBOMResponse struct {
	NetworkID          uuid.UUID        `json:"network_id"`
	PanelCount         int              `json:"panel_count"`
	StringCount        int              `json:"string_count"`
	InverterGroupCount int              `json:"inverter_group_count"`
	TotalDCKW          float64          `json:"total_dc_kw"`
	TotalACKW          float64          `json:"total_ac_kw"`
	Items              []NetworkBOMItem `json:"items"`
	TotalCost          float64          `json:"total_cost"`
	CurrencyCode       string           `json:"currency_code"`
}
