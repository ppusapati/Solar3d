package domain

import (
	"github.com/google/uuid"
)

type ElectricalNetwork struct {
	ID               uuid.UUID       `json:"id"`
	ProjectID        uuid.UUID       `json:"project_id"`
	LayoutID         uuid.UUID       `json:"layout_id"`
	Name             string          `json:"name"`
	TotalDCCapacityKW float64        `json:"total_dc_capacity_kw"`
	TotalACCapacityKW float64        `json:"total_ac_capacity_kw"`
	DCACRatio        float64         `json:"dc_ac_ratio"`
	StringCount      int             `json:"string_count"`
	InverterCount    int             `json:"inverter_count"`
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
	NetworkID         uuid.UUID `json:"network_id"`
	PanelsPerString   int       `json:"panels_per_string"`
	StringsPerInverter int      `json:"strings_per_inverter"`
	PanelVoltage      float64   `json:"panel_voltage"`
	PanelCurrent      float64   `json:"panel_current"`
	PanelPowerW       float64   `json:"panel_power_w"`
	InverterAssetID   uuid.UUID `json:"inverter_asset_id"`
	InverterACKW      float64   `json:"inverter_ac_kw"`
	TotalPanels       int       `json:"total_panels"`
}

type LossBreakdown struct {
	SoilingLoss       float64 `json:"soiling_loss"`
	ShadingLoss       float64 `json:"shading_loss"`
	MismatchLoss      float64 `json:"mismatch_loss"`
	WiringLossDC      float64 `json:"wiring_loss_dc"`
	WiringLossAC      float64 `json:"wiring_loss_ac"`
	InverterLoss      float64 `json:"inverter_loss"`
	TransformerLoss   float64 `json:"transformer_loss"`
	TotalLossPercent  float64 `json:"total_loss_percent"`
}
