package domain

import (
	"time"

	"github.com/google/uuid"
)

type SimulationStatus string

const (
	SimulationStatusPending   SimulationStatus = "pending"
	SimulationStatusRunning   SimulationStatus = "running"
	SimulationStatusCompleted SimulationStatus = "completed"
	SimulationStatusFailed    SimulationStatus = "failed"
)

type SimulationType string

const (
	SimulationTypeIrradiance SimulationType = "irradiance"
	SimulationTypeShadow     SimulationType = "shadow"
	SimulationTypeYield      SimulationType = "yield"
)

type Simulation struct {
	ID             uuid.UUID        `json:"id"`
	ProjectID      uuid.UUID        `json:"project_id"`
	LayoutID       uuid.UUID        `json:"layout_id"`
	Name           string           `json:"name"`
	SimulationType SimulationType   `json:"simulation_type"`
	Status         SimulationStatus `json:"status"`
	Params         SimulationParams `json:"params"`
	Result         *SimulationResult `json:"result,omitempty"`
	CreatedAt      time.Time        `json:"created_at"`
	CompletedAt    *time.Time       `json:"completed_at,omitempty"`
}

type SimulationParams struct {
	StartTime           time.Time `json:"start_time"`
	EndTime             time.Time `json:"end_time"`
	TimeStepMinutes     int       `json:"time_step_minutes"`
	Lat                 float64   `json:"lat"`
	Lon                 float64   `json:"lon"`
	IncludeTerrainShading bool    `json:"include_terrain_shading"`
	IncludePanelShading   bool    `json:"include_panel_shading"`
}

type SimulationResult struct {
	TotalIrradiance  float64 `json:"total_irradiance"`
	AnnualYield      float64 `json:"annual_yield"`
	PerformanceRatio float64 `json:"performance_ratio"`
	ShadingLoss      float64 `json:"shading_loss"`
	ResultFilePath   string  `json:"result_file_path"`
}

type SunPosition struct {
	Azimuth         float64   `json:"azimuth"`
	Elevation       float64   `json:"elevation"`
	Zenith          float64   `json:"zenith"`
	HourAngle       float64   `json:"hour_angle"`
	SunRadiusVector float64   `json:"sun_radius_vector_au"` // Earth-Sun distance in AU; used for irradiance correction (1/R^2)
	Timestamp       time.Time `json:"timestamp"`
}

type CreateSimulationRequest struct {
	ProjectID      uuid.UUID        `json:"project_id"`
	LayoutID       uuid.UUID        `json:"layout_id"`
	Name           string           `json:"name"`
	SimulationType SimulationType   `json:"simulation_type"`
	Params         SimulationParams `json:"params"`
}

type SunPositionRequest struct {
	Lat       float64   `json:"lat"`
	Lon       float64   `json:"lon"`
	Timestamp time.Time `json:"timestamp"`
}

