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
	ID               uuid.UUID            `json:"id"`
	Name             string               `json:"name"`
	Manufacturer     string               `json:"manufacturer"`
	Model            string               `json:"model"`
	Category         AssetCategory        `json:"category"`
	Dimensions       Dimensions           `json:"dimensions"`
	ElectricalParams ElectricalParameters `json:"electrical_params"`
	Model3DPath      *string              `json:"model_3d_path,omitempty"`
	DatasheetPath    *string              `json:"datasheet_path,omitempty"`
	Metadata         json.RawMessage      `json:"metadata,omitempty"`
}

// CellTechnology identifies the PV cell architecture of a module. Values
// mirror asset.v1.CellTechnology.
type CellTechnology string

const (
	CellTechnologyUnspecified CellTechnology = ""
	CellTechnologyMonoPERC    CellTechnology = "mono_perc"
	CellTechnologyPoly        CellTechnology = "poly"
	CellTechnologyTOPCon      CellTechnology = "topcon"
	CellTechnologyHJT         CellTechnology = "hjt"
	CellTechnologyIBC         CellTechnology = "ibc"
	CellTechnologyThinFilm    CellTechnology = "thin_film"
	CellTechnologyPERCPlus    CellTechnology = "perc_plus"
)

// FrameType identifies a panel's frame finish. Values mirror asset.v1.FrameType.
type FrameType string

const (
	FrameTypeUnspecified     FrameType = ""
	FrameTypeAnodizedAlum    FrameType = "anodized_aluminum"
	FrameTypeBlackAnodized   FrameType = "black_anodized"
	FrameTypeFrameless       FrameType = "frameless"
)

// InverterTopology mirrors asset.v1.InverterTopology.
type InverterTopology string

const (
	InverterTopologyUnspecified      InverterTopology = ""
	InverterTopologyTransformerless  InverterTopology = "transformer_less"
	InverterTopologyHFTransformer    InverterTopology = "hf_transformer"
	InverterTopologyLFTransformer    InverterTopology = "lf_transformer"
)

// InverterGridType mirrors asset.v1.InverterGridType.
type InverterGridType string

const (
	InverterGridTypeUnspecified InverterGridType = ""
	InverterGridTypeGridTied    InverterGridType = "grid_tied"
	InverterGridTypeHybrid      InverterGridType = "hybrid"
	InverterGridTypeOffGrid     InverterGridType = "off_grid"
)

type Dimensions struct {
	WidthMM  float64 `json:"width_mm"`
	HeightMM float64 `json:"height_mm"`
	DepthMM  float64 `json:"depth_mm"`
	WeightKG float64 `json:"weight_kg"`

	// Panel-specific mechanical details.
	CellCount         int            `json:"cell_count,omitempty"`
	CellTechnology    CellTechnology `json:"cell_technology,omitempty"`
	FrameType         FrameType      `json:"frame_type,omitempty"`
	MountingHoleCount int            `json:"mounting_hole_count,omitempty"`
}

type ElectricalParameters struct {
	// ========== Panel parameters (STC: 1000 W/m², 25°C, AM1.5) ==========
	RatedPowerW       float64 `json:"rated_power_w,omitempty"`
	VocV              float64 `json:"voc_v,omitempty"`
	IscA              float64 `json:"isc_a,omitempty"`
	VmpV              float64 `json:"vmp_v,omitempty"`
	ImpA              float64 `json:"imp_a,omitempty"`
	EfficiencyPercent float64 `json:"efficiency_percent,omitempty"`
	TempCoeffPmax     float64 `json:"temp_coeff_pmax,omitempty"` // γ (%/°C), typically negative
	TempCoeffVoc      float64 `json:"temp_coeff_voc,omitempty"`  // β (%/°C), typically negative
	TempCoeffIsc      float64 `json:"temp_coeff_isc,omitempty"`  // α (%/°C), small positive

	// Inverter parameters
	MaxDCInputKW      float64 `json:"max_dc_input_kw,omitempty"`
	RatedACOutputKW   float64 `json:"rated_ac_output_kw,omitempty"`
	MaxACOutputKW     float64 `json:"max_ac_output_kw,omitempty"`
	MaxInputVoltage   float64 `json:"max_input_voltage,omitempty"`
	MPPTRangeMinV     float64 `json:"mppt_range_min_v,omitempty"`
	MPPTRangeMaxV     float64 `json:"mppt_range_max_v,omitempty"`
	MPPTCount         int     `json:"mppt_count,omitempty"`
	MaxStringsPerMPPT int     `json:"max_strings_per_mppt,omitempty"`

	// Transformer parameters
	RatedKVA         float64 `json:"rated_kva,omitempty"`
	PrimaryVoltage   float64 `json:"primary_voltage,omitempty"`
	SecondaryVoltage float64 `json:"secondary_voltage,omitempty"`
	ImpedancePercent float64 `json:"impedance_percent,omitempty"`

	// ========== Extended panel parameters (PAN-sourced) ==========
	NOCTCelsius               float64 `json:"noct_c,omitempty"`                    // Nominal Operating Cell Temp (°C)
	BifacialFactor            float64 `json:"bifacial_factor,omitempty"`           // 0 for mono-facial
	MaxSystemVoltage          float64 `json:"max_system_voltage,omitempty"`        // e.g. 1500
	SeriesFuseRatingA         float64 `json:"series_fuse_rating_a,omitempty"`
	NominalPowerTolerancePct  float64 `json:"nominal_power_tolerance_pct,omitempty"`
	CellsInSeries             int     `json:"cells_in_series,omitempty"`
	CellsInParallel           int     `json:"cells_in_parallel,omitempty"`

	// ========== Extended inverter parameters (OND-sourced) ==========
	EuroEfficiency        float64          `json:"euro_efficiency,omitempty"`
	CECEfficiency         float64          `json:"cec_efficiency,omitempty"`
	MaxEfficiency         float64          `json:"max_efficiency,omitempty"`
	StartupVoltage        float64          `json:"startup_voltage,omitempty"`
	MaxDCInputCurrentA    float64          `json:"max_dc_input_current_a,omitempty"`
	MaxOutputCurrentA     float64          `json:"max_output_current_a,omitempty"`
	RatedACOutputW        float64          `json:"rated_ac_output_w,omitempty"`
	ACPhaseCount          int              `json:"ac_phase_count,omitempty"`
	ACFrequencyHz         float64          `json:"ac_frequency_hz,omitempty"`
	NominalACVoltage      float64          `json:"nominal_ac_voltage,omitempty"`
	NightConsumptionW     float64          `json:"night_consumption_w,omitempty"`
	OperatingTempMinC     float64          `json:"operating_temp_min_c,omitempty"`
	OperatingTempMaxC     float64          `json:"operating_temp_max_c,omitempty"`
	Topology              InverterTopology `json:"topology,omitempty"`
	GridType              InverterGridType `json:"grid_type,omitempty"`
}

type CreateAssetRequest struct {
	Name             string               `json:"name"`
	Manufacturer     string               `json:"manufacturer"`
	Model            string               `json:"model"`
	Category         AssetCategory        `json:"category"`
	Dimensions       Dimensions           `json:"dimensions"`
	ElectricalParams ElectricalParameters `json:"electrical_params"`
	Model3DPath      *string              `json:"model_3d_path,omitempty"`
	DatasheetPath    *string              `json:"datasheet_path,omitempty"`
	Metadata         json.RawMessage      `json:"metadata,omitempty"`
}

type UpdateAssetRequest struct {
	Name             *string               `json:"name,omitempty"`
	Manufacturer     *string               `json:"manufacturer,omitempty"`
	Model            *string               `json:"model,omitempty"`
	Category         *AssetCategory        `json:"category,omitempty"`
	Dimensions       *Dimensions           `json:"dimensions,omitempty"`
	ElectricalParams *ElectricalParameters `json:"electrical_params,omitempty"`
	Model3DPath      *string               `json:"model_3d_path,omitempty"`
	DatasheetPath    *string               `json:"datasheet_path,omitempty"`
	Metadata         json.RawMessage       `json:"metadata,omitempty"`
}

type AssetFilter struct {
	Category     *AssetCategory `json:"category,omitempty"`
	Manufacturer *string        `json:"manufacturer,omitempty"`
	SearchQuery  *string        `json:"search_query,omitempty"`
}

