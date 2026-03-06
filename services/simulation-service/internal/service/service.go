package service

import (
	"context"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"github.com/solar3d/solar3d/services/simulation-service/internal/domain"
	"github.com/solar3d/solar3d/services/simulation-service/internal/repository"
)

type SimulationService struct {
	repo *repository.SimulationRepository
}

func NewSimulationService(repo *repository.SimulationRepository) *SimulationService {
	return &SimulationService{repo: repo}
}

func (s *SimulationService) Create(ctx context.Context, req domain.CreateSimulationRequest) (*domain.Simulation, error) {
	sim := &domain.Simulation{
		ID:             uuid.New(),
		ProjectID:      req.ProjectID,
		LayoutID:       req.LayoutID,
		Name:           req.Name,
		SimulationType: req.SimulationType,
		Status:         domain.SimulationStatusPending,
		Params:         req.Params,
		CreatedAt:      time.Now().UTC(),
	}

	if err := s.repo.Create(ctx, sim); err != nil {
		return nil, fmt.Errorf("creating simulation: %w", err)
	}

	log.Info().
		Str("simulation_id", sim.ID.String()).
		Str("type", string(sim.SimulationType)).
		Msg("simulation created")

	return sim, nil
}

func (s *SimulationService) GetByID(ctx context.Context, id uuid.UUID) (*domain.Simulation, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *SimulationService) ListByProject(ctx context.Context, projectID uuid.UUID) ([]domain.Simulation, error) {
	return s.repo.ListByProject(ctx, projectID)
}

func (s *SimulationService) Delete(ctx context.Context, id uuid.UUID) error {
	return s.repo.Delete(ctx, id)
}

func (s *SimulationService) RunSimulation(ctx context.Context, id uuid.UUID) (*domain.Simulation, error) {
	sim, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}

	if err := s.repo.UpdateStatus(ctx, id, domain.SimulationStatusRunning); err != nil {
		return nil, fmt.Errorf("updating status to running: %w", err)
	}

	log.Info().
		Str("simulation_id", id.String()).
		Str("type", string(sim.SimulationType)).
		Msg("starting simulation")

	result, err := s.computeSimulation(sim)
	if err != nil {
		if statusErr := s.repo.UpdateStatus(ctx, id, domain.SimulationStatusFailed); statusErr != nil {
			log.Error().Err(statusErr).Str("simulation_id", id.String()).Msg("failed to update simulation status to failed")
		}
		return nil, fmt.Errorf("computing simulation: %w", err)
	}

	if err := s.repo.UpdateResult(ctx, id, result); err != nil {
		return nil, fmt.Errorf("saving result: %w", err)
	}

	sim.Result = result
	sim.Status = domain.SimulationStatusCompleted
	now := time.Now().UTC()
	sim.CompletedAt = &now

	log.Info().
		Str("simulation_id", id.String()).
		Float64("annual_yield", result.AnnualYield).
		Msg("simulation completed")

	return sim, nil
}

func (s *SimulationService) computeSimulation(sim *domain.Simulation) (*domain.SimulationResult, error) {
	params := sim.Params
	stepDuration := time.Duration(params.TimeStepMinutes) * time.Minute
	if stepDuration <= 0 {
		stepDuration = 60 * time.Minute
	}

	var totalIrradiance float64
	var shadedSteps, totalSteps int

	current := params.StartTime
	for current.Before(params.EndTime) {
		pos := CalculateSunPosition(params.Lat, params.Lon, current)
		totalSteps++

		if pos.Elevation > 0 {
			// Clear-sky GHI model using solar elevation
			airmass := 1.0 / (sinDeg(pos.Elevation) + 0.50572*pow(pos.Elevation+6.07995, -1.6364))
			if airmass < 0 {
				airmass = 40.0
			}
			if airmass > 40 {
				airmass = 40.0
			}
			// Simplified Ineichen-Perez clear sky model
			directNormal := 1361.0 * 0.7 * pow(0.678, airmass)
			ghi := directNormal * sinDeg(pos.Elevation)
			if ghi < 0 {
				ghi = 0
			}
			totalIrradiance += ghi * (float64(params.TimeStepMinutes) / 60.0)

			if params.IncludePanelShading && pos.Elevation < 15 {
				shadedSteps++
			}
		}
		current = current.Add(stepDuration)
	}

	shadingLoss := 0.0
	if totalSteps > 0 {
		shadingLoss = float64(shadedSteps) / float64(totalSteps) * 100.0
	}

	// Estimate annual yield assuming 1 kWp system
	totalHours := params.EndTime.Sub(params.StartTime).Hours()
	annualFactor := 8760.0 / totalHours
	if totalHours <= 0 {
		annualFactor = 1.0
	}
	annualYield := totalIrradiance * annualFactor * 0.001 // kWh/kWp

	performanceRatio := 0.80 // Typical PR
	if shadingLoss > 0 {
		performanceRatio -= shadingLoss / 100.0 * 0.5
	}

	return &domain.SimulationResult{
		TotalIrradiance:  totalIrradiance,
		AnnualYield:      annualYield * performanceRatio,
		PerformanceRatio: performanceRatio,
		ShadingLoss:      shadingLoss,
		ResultFilePath:   fmt.Sprintf("/results/%s.json", sim.ID.String()),
	}, nil
}

func (s *SimulationService) GetSunPosition(lat, lon float64, ts time.Time) *domain.SunPosition {
	pos := CalculateSunPosition(lat, lon, ts)
	return &pos
}

func (s *SimulationService) GetShadowMap(ctx context.Context, lat, lon float64, ts time.Time) ([]domain.SunPosition, error) {
	var positions []domain.SunPosition
	startOfDay := time.Date(ts.Year(), ts.Month(), ts.Day(), 0, 0, 0, 0, ts.Location())

	for h := 0; h < 24; h++ {
		t := startOfDay.Add(time.Duration(h) * time.Hour)
		pos := CalculateSunPosition(lat, lon, t)
		if pos.Elevation > 0 {
			positions = append(positions, pos)
		}
	}
	return positions, nil
}
