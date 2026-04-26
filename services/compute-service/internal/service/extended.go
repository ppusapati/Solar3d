package service

import (
	"context"
	"fmt"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
	"p9e.in/samavaya/solar3d/compute-service/internal/repository"
)

type ExtendedService struct {
	repo repository.ExtendedRepository
}

func NewExtendedService(repo repository.ExtendedRepository) *ExtendedService {
	return &ExtendedService{repo: repo}
}

func (s *ExtendedService) SolarTransposition(ctx context.Context, req *models.SolarTranspositionRequest) (*models.SolarTranspositionResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("solar transposition request is nil")
	}
	resp, err := s.repo.SolarTransposition(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("solar transposition failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("solar transposition response is nil")
	}
	return resp, nil
}

func (s *ExtendedService) FinancialMetrics(ctx context.Context, req *models.FinancialMetricsRequest) (*models.FinancialMetricsResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("financial metrics request is nil")
	}
	resp, err := s.repo.FinancialMetrics(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("financial metrics failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("financial metrics response is nil")
	}
	return resp, nil
}

func (s *ExtendedService) CompareFinancialScenarios(ctx context.Context, req *models.FinancialScenarioComparisonRequest) (*models.FinancialScenarioComparisonResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("financial scenario comparison request is nil")
	}
	resp, err := s.repo.CompareFinancialScenarios(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("financial scenario comparison failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("financial scenario comparison response is nil")
	}
	return resp, nil
}

func (s *ExtendedService) ClimateImpact(ctx context.Context, req *models.ClimateImpactRequest) (*models.ClimateImpactResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("climate impact request is nil")
	}
	resp, err := s.repo.ClimateImpact(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("climate impact failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("climate impact response is nil")
	}
	return resp, nil
}

func (s *ExtendedService) SaveFinancialScenarioSet(ctx context.Context, req *models.SaveFinancialScenarioSetRequest) (*models.FinancialScenarioSet, error) {
	if req == nil {
		return nil, fmt.Errorf("save scenario set request is nil")
	}
	resp, err := s.repo.SaveFinancialScenarioSet(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("save financial scenario set failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("save financial scenario set response is nil")
	}
	return resp, nil
}

func (s *ExtendedService) GetFinancialScenarioSet(ctx context.Context, req *models.GetFinancialScenarioSetRequest) (*models.FinancialScenarioSet, error) {
	if req == nil {
		return nil, fmt.Errorf("get scenario set request is nil")
	}
	resp, err := s.repo.GetFinancialScenarioSet(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("get financial scenario set failed: %w", err)
	}
	if resp == nil {
		return nil, fmt.Errorf("get financial scenario set response is nil")
	}
	return resp, nil
}

func (s *ExtendedService) ListFinancialScenarioSets(ctx context.Context, req *models.ListFinancialScenarioSetsRequest) ([]models.FinancialScenarioSetSummary, error) {
	if req == nil {
		return nil, fmt.Errorf("list scenario sets request is nil")
	}
	return s.repo.ListFinancialScenarioSets(ctx, req)
}

func (s *ExtendedService) GetFinancialScenarioSetVersions(ctx context.Context, req *models.GetFinancialScenarioSetVersionsRequest) ([]models.FinancialScenarioSetVersion, error) {
	if req == nil {
		return nil, fmt.Errorf("get scenario set versions request is nil")
	}
	return s.repo.GetFinancialScenarioSetVersions(ctx, req)
}

func (s *ExtendedService) CalculateInterRowShading(ctx context.Context, req *models.InterRowShadingRequest) (*models.InterRowShadingResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("inter-row shading request is nil")
	}
	resp, err := s.repo.CalculateInterRowShading(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("inter-row shading calculation failed: %w", err)
	}
	return resp, nil
}

func (s *ExtendedService) CalculateYieldUncertainty(ctx context.Context, req *models.YieldUncertaintyRequest) (*models.YieldUncertaintyResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("yield uncertainty request is nil")
	}
	resp, err := s.repo.CalculateYieldUncertainty(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("yield uncertainty calculation failed: %w", err)
	}
	return resp, nil
}

