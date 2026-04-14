package domain

import (
	"time"

	"github.com/google/uuid"
)

// ReviewState mirrors the proto enum for review workflow.
type ReviewState int32

const (
	ReviewStateDraft     ReviewState = 1
	ReviewStateSubmitted ReviewState = 2
	ReviewStateApproved  ReviewState = 3
	ReviewStateRejected  ReviewState = 4
)

func (s ReviewState) String() string {
	switch s {
	case ReviewStateDraft:
		return "DRAFT"
	case ReviewStateSubmitted:
		return "SUBMITTED"
	case ReviewStateApproved:
		return "APPROVED"
	case ReviewStateRejected:
		return "REJECTED"
	default:
		return "UNSPECIFIED"
	}
}

// ExposureCategory (ASCE 7-16 §26.7).
type ExposureCategory int32

const (
	ExposureCategoryB ExposureCategory = 1
	ExposureCategoryC ExposureCategory = 2
	ExposureCategoryD ExposureCategory = 3
)

// FoundationType for foundation design output.
type FoundationType int32

const (
	FoundationTypeDrivenPile   FoundationType = 1
	FoundationTypeConcretePile FoundationType = 2
	FoundationTypeBallast      FoundationType = 3
	FoundationTypeScrewPile    FoundationType = 4
)

type FoundationResult struct {
	PileCount       int            `json:"pile_count"`
	DesignLoadKN    float64        `json:"design_load_kn"`
	PileSpacingM    float64        `json:"pile_spacing_m"`
	FoundationType  FoundationType `json:"foundation_type"`
	PileCapacityKN  float64        `json:"pile_capacity_kn"`
	LoadCombination string         `json:"load_combination"`
}

type StructuralDesign struct {
	ID              uuid.UUID         `json:"id"`
	ProjectID       uuid.UUID         `json:"project_id"`
	Name            string            `json:"name"`
	ReviewState     ReviewState       `json:"review_state"`
	ReviewedBy      string            `json:"reviewed_by,omitempty"`
	ReviewNotes     string            `json:"review_notes,omitempty"`
	CreatedAt       time.Time         `json:"created_at"`
	UpdatedAt       time.Time         `json:"updated_at"`
	DeadLoadKN      float64           `json:"dead_load_kn"`
	WindLoadKN      float64           `json:"wind_load_kn"`
	SeismicLoadKN   float64           `json:"seismic_load_kn"`
	GoverningLoadKN float64           `json:"governing_load_kn"`
	Foundation      *FoundationResult `json:"foundation,omitempty"`
}

// ── Request/Response types ────────────────────────────────────────────────────

type CreateDesignRequest struct {
	ProjectID uuid.UUID `json:"project_id"`
	Name      string    `json:"name"`
}

type ComputeDeadLoadRequest struct {
	DesignID             uuid.UUID `json:"design_id"`
	PanelCount           int       `json:"panel_count"`
	PanelMassKg          float64   `json:"panel_mass_kg"`
	MountingMassPerPanel float64   `json:"mounting_mass_per_panel_kg"`
	CableMassKg          float64   `json:"cable_mass_kg"`
}

type ComputeDeadLoadResponse struct {
	DesignID            uuid.UUID `json:"design_id"`
	PanelMassTotalKg    float64   `json:"panel_mass_total_kg"`
	MountingMassTotalKg float64   `json:"mounting_mass_total_kg"`
	CableMassKg         float64   `json:"cable_mass_kg"`
	TotalMassKg         float64   `json:"total_mass_kg"`
	DeadLoadKN          float64   `json:"dead_load_kn"`
	Equation            string    `json:"equation"`
}

type ComputeWindLoadRequest struct {
	DesignID          uuid.UUID        `json:"design_id"`
	WindSpeedMS       float64          `json:"wind_speed_m_s"`
	Exposure          ExposureCategory `json:"exposure"`
	HeightM           float64          `json:"height_m"`
	PanelTiltDeg      float64          `json:"panel_tilt_deg"`
	TotalPanelAreaSqm float64          `json:"total_panel_area_sqm"`
	Kzt               float64          `json:"k_zt"`        // 0 → default 1.0
	Kd                float64          `json:"k_d"`         // 0 → default 0.85
	GustFactor        float64          `json:"gust_factor"` // 0 → default 0.85
}

type ComputeWindLoadResponse struct {
	DesignID         uuid.UUID `json:"design_id"`
	Kz               float64   `json:"k_z"`
	QzPa             float64   `json:"q_z_pa"`
	Cp               float64   `json:"c_p"`
	PressurePa       float64   `json:"pressure_pa"`
	TotalWindForceKN float64   `json:"total_wind_force_kn"`
	WindUpliftKN     float64   `json:"wind_uplift_kn"`
	Equation         string    `json:"equation"`
}

type ComputeSeismicLoadRequest struct {
	DesignID         uuid.UUID `json:"design_id"`
	Sds              float64   `json:"sds"` // design spectral acceleration (g)
	TotalMassKg      float64   `json:"total_mass_kg"`
	RFactor          float64   `json:"r_factor"`          // 0 → default 1.5
	ImportanceFactor float64   `json:"importance_factor"` // 0 → default 1.0
	CsOverride       float64   `json:"cs_override"`       // 0 = auto
}

type ComputeSeismicLoadResponse struct {
	DesignID        uuid.UUID `json:"design_id"`
	Cs              float64   `json:"cs"`
	SeismicWeightKN float64   `json:"seismic_weight_kn"`
	BaseShearKN     float64   `json:"base_shear_kn"`
	Equation        string    `json:"equation"`
}

type ComputeFoundationRequirementRequest struct {
	DesignID       uuid.UUID      `json:"design_id"`
	DeadLoadKN     float64        `json:"dead_load_kn"`
	WindLoadKN     float64        `json:"wind_load_kn"`
	SeismicLoadKN  float64        `json:"seismic_load_kn"`
	FoundationType FoundationType `json:"foundation_type"`
	PileCapacityKN float64        `json:"pile_capacity_kn"` // 0 → default 50
	TotalAreaSqm   float64        `json:"total_area_sqm"`
}

type ComputeFoundationRequirementResponse struct {
	DesignID uuid.UUID        `json:"design_id"`
	Result   FoundationResult `json:"result"`
	Equation string           `json:"equation"`
}

type StructuralViolation struct {
	Code    string  `json:"code"`
	Message string  `json:"message"`
	Limit   float64 `json:"limit"`
	Actual  float64 `json:"actual"`
}

type ValidateStructuralDesignRequest struct {
	DesignID              uuid.UUID `json:"design_id"`
	MaxWindPressurePa     float64   `json:"max_wind_pressure_pa"`
	MaxSeismicCoefficient float64   `json:"max_seismic_coefficient"`
}

type ValidateStructuralDesignResponse struct {
	Valid            bool                  `json:"valid"`
	Violations       []StructuralViolation `json:"violations"`
	UtilizationRatio float64               `json:"utilization_ratio"`
}

type ReviewRequest struct {
	DesignID uuid.UUID `json:"design_id"`
	Actor    string    `json:"actor"`
	Notes    string    `json:"notes"`
}
