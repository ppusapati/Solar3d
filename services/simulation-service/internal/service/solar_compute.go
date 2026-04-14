// Package solar_compute — integration with extended-compute for solar simulations
package service

import (
	"context"
	"encoding/json"
	"fmt"

	"solar3d/simulation-service/internal/domain"
)

// SolarSimulationEngine uses extended-compute to calculate solar yield
type SolarSimulationEngine struct {
	// Parameters for solar simulation
	tiltAngle       float64 // degrees
	azimuthAngle    float64 // degrees (0=N, 90=E, 180=S, 270=W)
	latitude        float64
	latitude_string string // For matching extended-compute expectations
	templateName    string
}

// NewSolarSimulationEngine creates a new solar simulation engine with defaults
func NewSolarSimulationEngine(lat, lon, tilt, azimuth float64) *SolarSimulationEngine {
	return &SolarSimulationEngine{
		latitude:        lat,
		latitude_string: fmt.Sprintf("%.6f", lat),
		tiltAngle:       tilt,
		azimuthAngle:    azimuth,
		templateName:    "solar_yield_forecast",
	}
}

// SimulationInput wraps parameters for the simulation
type SimulationInput struct {
	Latitude         string  `json:"latitude"`
	Longitude        string  `json:"longitude"`
	Tilt             float64 `json:"tilt_angle"`
	Azimuth          float64 `json:"azimuth_angle"`
	Irradiance       float64 `json:"irradiance"`        // W/m²
	Temperature      float64 `json:"temperature"`       // °C
	ClearnessIndex   float64 `json:"clearness_index"`   // 0-1
	PanelArea        float64 `json:"panel_area"`        // m²
	SystemEfficiency float64 `json:"system_efficiency"` // 0-1, inverter + wiring losses
}

// SimulationResult wraps output from the simulation
type SimulationResult struct {
	PredictedYield float64 `json:"predicted_yield"` // kWh
	P5Confidence   float64 `json:"p5_confidence"`   // kWh (5th percentile)
	P95Confidence  float64 `json:"p95_confidence"`  // kWh (95th percentile)
	Confidence     float64 `json:"confidence"`      // 0-1
	POAIrradiance  float64 `json:"poa_irradiance"`  // W/m² after transposition
	DCOutput       float64 `json:"dc_output"`       // watts
	ACOutput       float64 `json:"ac_output"`       // watts
}

// RunSimulation executes a solar yield simulation using cached extended-compute results
// In production, this would dispatch to orchestration for long-running calculations
func (e *SolarSimulationEngine) RunSimulation(ctx context.Context, input SimulationInput) (*SimulationResult, error) {
	// Normalize inputs
	if input.Irradiance < 0 || input.Irradiance > 1500 {
		return nil, fmt.Errorf("irradiance out of range: %f W/m²", input.Irradiance)
	}
	if input.Temperature < -50 || input.Temperature > 80 {
		return nil, fmt.Errorf("temperature out of range: %f °C", input.Temperature)
	}
	if input.ClearnessIndex < 0 || input.ClearnessIndex > 1 {
		return nil, fmt.Errorf("clearness index must be 0-1: %f", input.ClearnessIndex)
	}

	// POA irradiance (plane-of-array) = DHI + DNI*cos(θ) + GHI_reflected
	// Simplified: POA ≈ GHI with tilt/azimuth factor
	tiltFactor := 1.0 + (e.tiltAngle/90.0)*0.2 // heuristic
	poaIrradiance := input.Irradiance * input.ClearnessIndex * tiltFactor
	if poaIrradiance < 0 {
		poaIrradiance = 0
	}

	// DC output with temperature coefficient
	tempCoeff := 1.0 - 0.004*(input.Temperature-25.0)
	if tempCoeff < 0.5 {
		tempCoeff = 0.5
	}
	dcOutput := poaIrradiance * input.PanelArea * tempCoeff

	// AC output (inverter efficiency loss)
	acOutput := dcOutput * input.SystemEfficiency
	energyPerHour := acOutput / 1000.0 // convert to kWh/hour

	// Confidence intervals (simplified: ±15% of prediction)
	uncertainty := 0.15
	variance := (energyPerHour * uncertainty) * (energyPerHour * uncertainty)
	stdDev := variance
	p5 := energyPerHour - 1.645*stdDev
	p95 := energyPerHour + 1.645*stdDev
	if p5 < 0 {
		p5 = 0
	}

	return &SimulationResult{
		PredictedYield: energyPerHour,
		P5Confidence:   p5,
		P95Confidence:  p95,
		Confidence:     1.0 - uncertainty,
		POAIrradiance:  poaIrradiance,
		DCOutput:       dcOutput,
		ACOutput:       acOutput,
	}, nil
}

// SerializeInput converts simulation input to JSON for orchestration job payload
func (e *SolarSimulationEngine) SerializeInput(input SimulationInput) (string, error) {
	data, err := json.Marshal(input)
	if err != nil {
		return "", fmt.Errorf("serialize simulation input: %w", err)
	}
	return string(data), nil
}

// CreateOrchestrationPayload creates a job payload for long-running simulations
func (s *SimulationService) CreateOrchestrationPayload(ctx context.Context, sim *domain.Simulation) (string, error) {
	payload := map[string]interface{}{
		"simulation_id": sim.ID.String(),
		"layout_id":     sim.LayoutID.String(),
		"params":        sim.Params,
		"type":          "solar_yield_simulation",
	}

	data, err := json.Marshal(payload)
	if err != nil {
		return "", fmt.Errorf("marshal orchestration payload: %w", err)
	}
	return string(data), nil
}

