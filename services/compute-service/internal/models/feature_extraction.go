package models

// Domain model for feature extraction (proto-independent)
type WeatherFeaturesModel struct {
	TemperatureCelsius float64
	IrradianceWM2      float64
	HumidityPercent    float64
	PressureMb         float64
	WindSpeedMS        float64
}

type SolarFeaturesModel struct {
	SolarAltitudeDeg float64
	SolarAzimuthDeg  float64
	AirMass          float64
	ClearnessIndex   float64
}

type TimeFeaturesModel struct {
	HourOfDay int32
	DayOfYear int32
	Month     int32
	IsWeekend bool
}

// Normalized feature vector after processing
type FeatureVectorModel struct {
	Features     []float64
	FeatureNames []string
	FeatureCount int32
	ExtractedAt  int64 // Unix timestamp in milliseconds
}

// Feature extraction request model
type ExtractFeaturesRequest struct {
	Weather WeatherFeaturesModel
	Solar   SolarFeaturesModel
	Time    TimeFeaturesModel
}

// Feature extraction response model
type ExtractFeaturesResponse struct {
	Features     FeatureVectorModel
	Success      bool
	ErrorMessage string
}

type YieldPredictionRequest struct {
	Features            []float64
	ModelOutput         float64
	UncertaintyEstimate float64
}

type YieldForecastModel struct {
	PredictedYieldKwh float64
	ConfidenceLower   float64
	ConfidenceUpper   float64
	ExpectedValue     float64
	Variance          float64
}

type YieldPredictionResponse struct {
	Forecast          YieldForecastModel
	EnsembleForecasts []YieldForecastModel
}

type AnomalyDetectionRequest struct {
	ExpectedYield   float64
	ActualYield     float64
	ModelPrediction float64
	SensorVariance  float64
}

type AnomalyScoreModel struct {
	Score       float64
	AnomalyType string
	Confidence  float64
}

type AnomalyDetectionResponse struct {
	Score          AnomalyScoreModel
	IsAnomalous    bool
	Recommendation string
}

type DegradationRequest struct {
	CurrentDegradation float64
	AnnualRate         float64
	Years              int32
	EndOfLifeThreshold float64
}

type DegradationForecastModel struct {
	CurrentDegradationPercent float64
	AnnualDegradationRate     float64
	ProjectedDegradation5Yr   float64
	ProjectedDegradation10Yr  float64
	ConfidenceInterval        float64
}

type DegradationResponse struct {
	Forecast                 DegradationForecastModel
	RemainingUsefulLifeYears float64
}

type ObjectiveModel struct {
	Name   string
	Kind   string
	Weight float64
}

type SolutionModel struct {
	ID               int32
	Variables        []float64
	Objectives       []float64
	Rank             float64
	CrowdingDistance float64
}

type ParetoFrontierRequest struct {
	Objectives  []ObjectiveModel
	NewSolution SolutionModel
}

type ParetoFrontierResponse struct {
	Solutions    []SolutionModel
	FrontierSize int32
	SolutionIDs  []int32
}

type DistributionModel struct {
	Mean   float64
	StdDev float64
}

type MonteCarloRequest struct {
	Distributions []DistributionModel
	NumSamples    int32
	Seed          int64
}

type MonteCarloResponse struct {
	Mean     float64
	StdDev   float64
	P10      float64
	P50      float64
	P90      float64
	MinValue float64
	MaxValue float64
}

type GARequest struct {
	PopulationSize    int32
	Generations       int32
	CrossoverRate     float64
	MutationRate      float64
	EliteCount        int32
	Seed              int64
	InitialPopulation []float64
}

type GAResponse struct {
	BestFitness          float64
	BestGenes            []float64
	GenerationsCompleted int32
}

type SARequest struct {
	InitialTemperature float64
	CoolingRate        float64
	Iterations         int32
	PerturbationScale  float64
	Seed               int64
	InitialSolution    []float64
}

type SAResponse struct {
	BestEnergy       float64
	BestSolution     []float64
	FinalTemperature float64
}

type PSORequest struct {
	NumParticles int32
	Iterations   int32
	C1           float64
	C2           float64
	W            float64
	BoundaryMin  float64
	BoundaryMax  float64
	Seed         int64
}

type PSOResponse struct {
	BestPosition        float64
	BestValue           float64
	IterationsCompleted int32
}

