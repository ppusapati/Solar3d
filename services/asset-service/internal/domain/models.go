package domain

import (
	"encoding/json"

	"github.com/google/uuid"
)

type AssetCategory string

const (
	AssetCategoryPanel       AssetCategory = "panel"
	AssetCategoryInverter    AssetCategory = "inverter"
	AssetCategoryTransformer AssetCategory = "transformer"
	AssetCategoryTracker     AssetCategory = "tracker"
	AssetCategoryCable       AssetCategory = "cable"
	AssetCategoryMounting    AssetCategory = "mounting"
	AssetCategoryMeter       AssetCategory = "meter"
	AssetCategoryOther       AssetCategory = "other"
)

type Asset struct {
	ID               uuid.UUID          `json:"id"`
	Name             string             `json:"name"`
	Manufacturer     string             `json:"manufacturer"`
	Model            string             `json:"model"`
	Category         AssetCategory      `json:"category"`
	Dimensions       Dimensions         `json:"dimensions"`
	ElectricalParams ElectricalParameters `json:"electrical_params"`
	Model3DPath      string             `json:"model_3d_path,omitempty"`
	DatasheetPath    string             `json:"datasheet_path,omitempty"`
	Metadata         json.RawMessage    `json:"metadata,omitempty"`
}

type Dimensions struct {
	WidthMM  float64 `json:"width_mm"`
	HeightMM float64 `json:"height_mm"`
	DepthMM  float64 `json:"depth_mm"`
	WeightKG float64 `json:"weight_kg"`
}

type ElectricalParameters struct {
	// Panel parameters
	RatedPowerW       float64 `json:"rated_power_w,omitempty"`
	VocV              float64 `json:"voc_v,omitempty"`
	IscA              float64 `json:"isc_a,omitempty"`
	VmpV              float64 `json:"vmp_v,omitempty"`
	ImpA              float64 `json:"imp_a,omitempty"`
	EfficiencyPercent float64 `json:"efficiency_percent,omitempty"`
	TempCoeffPmax     float64 `json:"temp_coeff_pmax,omitempty"`
	TempCoeffVoc      float64 `json:"temp_coeff_voc,omitempty"`
	TempCoeffIsc      float64 `json:"temp_coeff_isc,omitempty"`

	// Inverter parameters
	MaxDCInputKW    float64 `json:"max_dc_input_kw,omitempty"`
	RatedACOutputKW float64 `json:"rated_ac_output_kw,omitempty"`
	MaxACOutputKW   float64 `json:"max_ac_output_kw,omitempty"`
	MaxInputVoltage float64 `json:"max_input_voltage,omitempty"`
	MPPTRangeMinV   float64 `json:"mppt_range_min_v,omitempty"`
	MPPTRangeMaxV   float64 `json:"mppt_range_max_v,omitempty"`
	MPPTCount       int     `json:"mppt_count,omitempty"`
	MaxStringsPerMPPT int   `json:"max_strings_per_mppt,omitempty"`

	// Transformer parameters
	RatedKVA        float64 `json:"rated_kva,omitempty"`
	PrimaryVoltage  float64 `json:"primary_voltage,omitempty"`
	SecondaryVoltage float64 `json:"secondary_voltage,omitempty"`
	ImpedancePercent float64 `json:"impedance_percent,omitempty"`
}

type CreateAssetRequest struct {
	Name             string             `json:"name"`
	Manufacturer     string             `json:"manufacturer"`
	Model            string             `json:"model"`
	Category         AssetCategory      `json:"category"`
	Dimensions       Dimensions         `json:"dimensions"`
	ElectricalParams ElectricalParameters `json:"electrical_params"`
	Model3DPath      string             `json:"model_3d_path,omitempty"`
	DatasheetPath    string             `json:"datasheet_path,omitempty"`
	Metadata         json.RawMessage    `json:"metadata,omitempty"`
}

type UpdateAssetRequest struct {
	Name             *string             `json:"name,omitempty"`
	Manufacturer     *string             `json:"manufacturer,omitempty"`
	Model            *string             `json:"model,omitempty"`
	Category         *AssetCategory      `json:"category,omitempty"`
	Dimensions       *Dimensions         `json:"dimensions,omitempty"`
	ElectricalParams *ElectricalParameters `json:"electrical_params,omitempty"`
	Model3DPath      *string             `json:"model_3d_path,omitempty"`
	DatasheetPath    *string             `json:"datasheet_path,omitempty"`
	Metadata         json.RawMessage     `json:"metadata,omitempty"`
}

type AssetFilter struct {
	Category     *AssetCategory `json:"category,omitempty"`
	Manufacturer *string        `json:"manufacturer,omitempty"`
	SearchQuery  *string        `json:"search_query,omitempty"`
}
