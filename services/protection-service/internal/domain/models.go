package domain

import (
	"time"

	"github.com/google/uuid"
)

// NeutralEarthing maps to the proto enum.
type NeutralEarthing int32

const (
	NeutralEarthingSolid      NeutralEarthing = 1
	NeutralEarthingResistance NeutralEarthing = 2
	NeutralEarthingPetersen   NeutralEarthing = 3
	NeutralEarthingIsolated   NeutralEarthing = 4
)

func (n NeutralEarthing) String() string {
	switch n {
	case NeutralEarthingSolid:
		return "SOLID"
	case NeutralEarthingResistance:
		return "RESISTANCE"
	case NeutralEarthingPetersen:
		return "PETERSEN_COIL"
	case NeutralEarthingIsolated:
		return "ISOLATED"
	default:
		return "UNSPECIFIED"
	}
}

// RelayCharacteristic maps to the proto enum.
type RelayCharacteristic int32

const (
	RelayCharacteristicSI RelayCharacteristic = 1 // Standard Inverse
	RelayCharacteristicVI RelayCharacteristic = 2 // Very Inverse
	RelayCharacteristicEI RelayCharacteristic = 3 // Extremely Inverse
	RelayCharacteristicDT RelayCharacteristic = 4 // Definite Time
)

func (r RelayCharacteristic) String() string {
	switch r {
	case RelayCharacteristicSI:
		return "STANDARD_INVERSE"
	case RelayCharacteristicVI:
		return "VERY_INVERSE"
	case RelayCharacteristicEI:
		return "EXTREMELY_INVERSE"
	case RelayCharacteristicDT:
		return "DEFINITE_TIME"
	default:
		return "UNSPECIFIED"
	}
}

// ── Core entities ────────────────────────────────────────────────────────────

type ProtectionStudy struct {
	ID                uuid.UUID `json:"id"`
	ProjectID         uuid.UUID `json:"project_id"`
	Name              string    `json:"name"`
	SystemVoltageKV   float64   `json:"system_voltage_kv"`
	SourceImpedancePU float64   `json:"source_impedance_pu"`
	MVABase           float64   `json:"mva_base"`
	CreatedAt         time.Time `json:"created_at"`
}

// ── Request / Response types ─────────────────────────────────────────────────

type CreateStudyRequest struct {
	ProjectID         uuid.UUID `json:"project_id"`
	Name              string    `json:"name"`
	SystemVoltageKV   float64   `json:"system_voltage_kv"`
	SourceImpedancePU float64   `json:"source_impedance_pu"`
	MVABase           float64   `json:"mva_base"`
}

// ComputeShortCircuiRequest holds IEC 60909 inputs.
type ComputeShortCircuitRequest struct {
	StudyID                   uuid.UUID `json:"study_id"`
	VoltageKV                 float64   `json:"voltage_kv"`
	SourceImpedanceOhm        float64   `json:"source_impedance_ohm"` // Z_source (positive-seq)
	CableResistanceOhm        float64   `json:"cable_resistance_ohm"` // R_cable
	CableReactanceOhm         float64   `json:"cable_reactance_ohm"`  // X_cable
	ZeroSeqImpedanceOhm       float64   `json:"zero_seq_impedance_ohm"`
	IncludeSingleLineToGround bool      `json:"include_slg"`
}

type ComputeShortCircuitResponse struct {
	StudyID        uuid.UUID `json:"study_id"`
	VLN_KV         float64   `json:"v_ln_kv"`
	ZTotalPosSeq   float64   `json:"z_total_pos_seq_ohm"`
	IFault3Ph_KA   float64   `json:"i_fault_3ph_ka"`
	SLGComputed    bool      `json:"slg_computed"`
	ZTotalZeroSeq  float64   `json:"z_total_zero_seq_ohm"`
	IFaultSLG_KA   float64   `json:"i_fault_slg_ka"`
	GoverningFault float64   `json:"governing_fault_ka"`
	Equation       string    `json:"equation"`
}

type ComputeEarthFaultRequest struct {
	StudyID          uuid.UUID       `json:"study_id"`
	VoltageKV        float64         `json:"voltage_kv"`
	EarthingMethod   NeutralEarthing `json:"earthing_method"`
	NGRResistanceOhm float64         `json:"ngr_resistance_ohm"`
	CableResistance  float64         `json:"cable_resistance_ohm"`
}

type ComputeEarthFaultResponse struct {
	StudyID             uuid.UUID       `json:"study_id"`
	EarthingMethod      NeutralEarthing `json:"earthing_method"`
	EarthFaultCurrentKA float64         `json:"earth_fault_current_ka"`
	TouchVoltageV       float64         `json:"touch_voltage_v"`
	Equation            string          `json:"equation"`
}

type SelectRelayRequest struct {
	StudyID                 uuid.UUID           `json:"study_id"`
	FaultCurrentKA          float64             `json:"fault_current_ka"`
	LoadCurrentA            float64             `json:"load_current_a"`
	PreferredCharacteristic RelayCharacteristic `json:"preferred_characteristic"`
}

type RelaySelection struct {
	RelayID        string              `json:"relay_id"`
	MakeModel      string              `json:"make_model"`
	Characteristic RelayCharacteristic `json:"characteristic"`
	PickupCurrentA float64             `json:"pickup_current_a"`
	TimeDial       float64             `json:"time_dial_setting"`
	Rationale      string              `json:"rationale"`
}

type SelectRelayResponse struct {
	StudyID uuid.UUID      `json:"study_id"`
	Relay   RelaySelection `json:"relay"`
}

type ComputeRelaySettingsRequest struct {
	StudyID        uuid.UUID           `json:"study_id"`
	Characteristic RelayCharacteristic `json:"characteristic"`
	PickupCurrentA float64             `json:"pickup_current_a"`
	TimeDial       float64             `json:"time_dial_setting"`
	FaultCurrentA  float64             `json:"fault_current_a"`
}

type ComputeRelaySettingsResponse struct {
	StudyID        uuid.UUID           `json:"study_id"`
	Multiplier     float64             `json:"multiplier"`
	OperatingTime  float64             `json:"operating_time_s"`
	Characteristic RelayCharacteristic `json:"characteristic"`
	Equation       string              `json:"equation"`
}

type CoordinationPair struct {
	UpstreamRelayID   string  `json:"upstream_relay_id"`
	DownstreamRelayID string  `json:"downstream_relay_id"`
	UpstreamTimeS     float64 `json:"upstream_time_s"`
	DownstreamTimeS   float64 `json:"downstream_time_s"`
	MarginS           float64 `json:"margin_s"`
}

type ValidateCoordinationRequest struct {
	StudyID        uuid.UUID          `json:"study_id"`
	Pairs          []CoordinationPair `json:"pairs"`
	MinimumMarginS float64            `json:"minimum_margin_s"` // 0 → default 0.3
}

type CoordinationViolation struct {
	UpstreamRelayID   string  `json:"upstream_relay_id"`
	DownstreamRelayID string  `json:"downstream_relay_id"`
	MarginS           float64 `json:"margin_s"`
	MinimumRequiredS  float64 `json:"minimum_required_s"`
}

type ValidateCoordinationResponse struct {
	Valid      bool                    `json:"valid"`
	Violations []CoordinationViolation `json:"violations"`
}
