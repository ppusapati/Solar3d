package service

import (
	"context"
	"fmt"

	"p9e.in/samavaya/solar3d/compute-service/internal/models"
	"p9e.in/samavaya/solar3d/compute-service/internal/repository"
)

// MLInferenceService contains business logic for ML inference operations
type MLInferenceService struct {
	repo repository.MLInferenceRepository
}

// NewMLInferenceService creates a new ML inference service
func NewMLInferenceService(repo repository.MLInferenceRepository) *MLInferenceService {
	return &MLInferenceService{
		repo: repo,
	}
}

// ExtractFeatures orchestrates feature extraction
// - Validates input
// - Calls repository to extract features from Rust crate
// - Returns processed result or error
func (s *MLInferenceService) ExtractFeatures(ctx context.Context, req *models.ExtractFeaturesRequest) (*models.ExtractFeaturesResponse, error) {
	// Validate request structure
	if req == nil {
		return nil, fmt.Errorf("extract features request is nil")
	}

	// Call repository (Rust compute crate)
	features, err := s.repo.ExtractFeatures(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("failed to extract features: %w", err)
	}

	if features == nil {
		return nil, fmt.Errorf("extracted features is nil")
	}

	// Validation of extracted features
	if features.FeatureCount <= 0 {
		return nil, fmt.Errorf("no features extracted")
	}

	if int32(len(features.Features)) != features.FeatureCount {
		return nil, fmt.Errorf("feature count mismatch: expected %d, got %d", features.FeatureCount, len(features.Features))
	}

	// Return successful response
	return &models.ExtractFeaturesResponse{
		Features:     *features,
		Success:      true,
		ErrorMessage: "",
	}, nil
}

func (s *MLInferenceService) PredictYield(ctx context.Context, req *models.YieldPredictionRequest) (*models.YieldPredictionResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("predict yield request is nil")
	}

	resp, err := s.repo.PredictYield(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("failed to predict yield: %w", err)
	}

	if resp == nil {
		return nil, fmt.Errorf("predict yield response is nil")
	}

	return resp, nil
}

func (s *MLInferenceService) DetectAnomaly(ctx context.Context, req *models.AnomalyDetectionRequest) (*models.AnomalyDetectionResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("detect anomaly request is nil")
	}

	resp, err := s.repo.DetectAnomaly(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("failed to detect anomaly: %w", err)
	}

	if resp == nil {
		return nil, fmt.Errorf("detect anomaly response is nil")
	}

	return resp, nil
}

func (s *MLInferenceService) ForecastDegradation(ctx context.Context, req *models.DegradationRequest) (*models.DegradationResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("forecast degradation request is nil")
	}

	resp, err := s.repo.ForecastDegradation(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("failed to forecast degradation: %w", err)
	}

	if resp == nil {
		return nil, fmt.Errorf("forecast degradation response is nil")
	}

	return resp, nil
}

