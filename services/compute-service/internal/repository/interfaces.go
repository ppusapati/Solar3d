package repository

import (
	"context"

	"solar3d/compute-service/internal/models"
)

// MLInferenceRepository defines the interface for ML inference compute operations
// This layer abstracts the underlying Rust compute crates
type MLInferenceRepository interface {
	// ExtractFeatures calls the Rust ml-inference::feature_pipeline module
	ExtractFeatures(ctx context.Context, req *models.ExtractFeaturesRequest) (*models.FeatureVectorModel, error)

	// PredictYield calls the Rust ml-inference::yield_forecasting module
	PredictYield(ctx context.Context, req *models.YieldPredictionRequest) (*models.YieldPredictionResponse, error)

	// DetectAnomaly calls the Rust ml-inference::anomaly_detection module
	DetectAnomaly(ctx context.Context, req *models.AnomalyDetectionRequest) (*models.AnomalyDetectionResponse, error)

	// ForecastDegradation calls the Rust ml-inference::degradation_forecasting module
	ForecastDegradation(ctx context.Context, req *models.DegradationRequest) (*models.DegradationResponse, error)
}

// OptimizationRepository defines the interface for optimization algorithm operations
// This layer abstracts the underlying Rust compute crates
type OptimizationRepository interface {
	// ParetoFrontier calls the Rust optimization-compute::pareto module
	ParetoFrontier(ctx context.Context, req *models.ParetoFrontierRequest) (*models.ParetoFrontierResponse, error)

	// MonteCarloSampling calls the Rust optimization-compute::monte_carlo module
	MonteCarloSampling(ctx context.Context, req *models.MonteCarloRequest) (*models.MonteCarloResponse, error)

	// GeneticAlgorithm calls the Rust optimization-compute::ga module
	GeneticAlgorithm(ctx context.Context, req *models.GARequest) (*models.GAResponse, error)

	// SimulatedAnnealing calls the Rust optimization-compute::sa module
	SimulatedAnnealing(ctx context.Context, req *models.SARequest) (*models.SAResponse, error)

	// ParticleSwarmOptimization calls the Rust optimization-compute::pso module
	ParticleSwarmOptimization(ctx context.Context, req *models.PSORequest) (*models.PSOResponse, error)
}

// SimulationRepository defines the interface for solar simulation operations.
type SimulationRepository interface {
	// GetSunPosition calls the Rust solar-compute::solar_position module.
	GetSunPosition(ctx context.Context, req *models.GetSunPositionRequest) (*models.GetSunPositionResponse, error)

	// GetShadowMap calls the Rust solar-compute::shadow module.
	GetShadowMap(ctx context.Context, req *models.GetShadowMapRequest) (*models.GetShadowMapResponse, error)
}

// TerrainRepository defines the interface for terrain compute operations.
type TerrainRepository interface {
	// GetElevation calls the Rust terrain-compute::elevation module.
	GetElevation(ctx context.Context, req *models.GetElevationRequest) (*models.GetElevationResponse, error)

	// GetElevationGrid calls the Rust terrain-compute::elevation module.
	GetElevationGrid(ctx context.Context, req *models.GetElevationGridRequest) (*models.GetElevationGridResponse, error)

	// ComputeSlope calls the Rust terrain-compute::slope module.
	ComputeSlope(ctx context.Context, req *models.ComputeSlopeRequest) (*models.ComputeSlopeResponse, error)

	// ComputeAspect calls the Rust terrain-compute::aspect module.
	ComputeAspect(ctx context.Context, req *models.ComputeAspectRequest) (*models.ComputeAspectResponse, error)
}

// ExtendedRepository defines the interface for extended-compute operations.
type ExtendedRepository interface {
	SolarTransposition(ctx context.Context, req *models.SolarTranspositionRequest) (*models.SolarTranspositionResponse, error)
	FinancialMetrics(ctx context.Context, req *models.FinancialMetricsRequest) (*models.FinancialMetricsResponse, error)
	CompareFinancialScenarios(ctx context.Context, req *models.FinancialScenarioComparisonRequest) (*models.FinancialScenarioComparisonResponse, error)
	ClimateImpact(ctx context.Context, req *models.ClimateImpactRequest) (*models.ClimateImpactResponse, error)
	SaveFinancialScenarioSet(ctx context.Context, req *models.SaveFinancialScenarioSetRequest) (*models.FinancialScenarioSet, error)
	GetFinancialScenarioSet(ctx context.Context, req *models.GetFinancialScenarioSetRequest) (*models.FinancialScenarioSet, error)
	ListFinancialScenarioSets(ctx context.Context, req *models.ListFinancialScenarioSetsRequest) ([]models.FinancialScenarioSetSummary, error)
	GetFinancialScenarioSetVersions(ctx context.Context, req *models.GetFinancialScenarioSetVersionsRequest) ([]models.FinancialScenarioSetVersion, error)
	CalculateInterRowShading(ctx context.Context, req *models.InterRowShadingRequest) (*models.InterRowShadingResponse, error)
	CalculateYieldUncertainty(ctx context.Context, req *models.YieldUncertaintyRequest) (*models.YieldUncertaintyResponse, error)
}

// GraphRepository defines the interface for graph-compute operations.
type GraphRepository interface {
	MinimumSpanningTree(ctx context.Context, req *models.MinimumSpanningTreeRequest) (*models.MinimumSpanningTreeResponse, error)
	ApproximateSteinerTree(ctx context.Context, req *models.ApproximateSteinerTreeRequest) (*models.ApproximateSteinerTreeResponse, error)
}

// GeoRepository defines the interface for geo-compute operations.
type GeoRepository interface {
	BufferPoint(ctx context.Context, req *models.BufferPointRequest) (*models.BufferPointResponse, error)
	NearestPoint(ctx context.Context, req *models.NearestPointRequest) (*models.NearestPointResponse, error)
	GenerateContours(ctx context.Context, req *models.GenerateContoursRequest) (*models.GenerateContoursResponse, error)
}

