package models

import "time"

type SolarTranspositionRequest struct {
	GHIWM2         float64 `json:"ghi_wm2"`
	DHIWM2         float64 `json:"dhi_wm2"`
	WindSpeedMS    float64 `json:"wind_speed_ms"`
	TemperatureC   float64 `json:"temperature_c"`
	SurfaceTiltDeg float64 `json:"surface_tilt_deg"`
	SurfaceAzimuth float64 `json:"surface_azimuth"`
	SolarAltitude  float64 `json:"solar_altitude"`
	SolarAzimuth   float64 `json:"solar_azimuth"`
}

type SolarTranspositionResponse struct {
	POAIrradiance       float64 `json:"poa_irradiance"`
	AOI                 float64 `json:"aoi"`
	IncidenceModulation float64 `json:"incidence_modulation"`
}

type FinancialMetricsRequest struct {
	AnnualCashflows   []float64 `json:"annual_cashflows"`
	InitialInvestment float64   `json:"initial_investment"`
	DiscountRate      float64   `json:"discount_rate"`
	PRBaseline        float64   `json:"pr_baseline"`
	PRActual          float64   `json:"pr_actual"`
}

type FinancialMetricsResponse struct {
	NPVUSD      float64 `json:"npv_usd"`
	IRRPercent  float64 `json:"irr_percent"`
	PICoeff     float64 `json:"pi_coeff"`
	CROPPercent float64 `json:"crop_percent"`
}

type FinancialScenarioComparisonRequest struct {
	AnnualYieldKWh        float64             `json:"annual_yield_kwh"`
	AnnualOMUSD           float64             `json:"annual_om_usd"`
	ProjectLifeYears      int                 `json:"project_life_years"`
	BaseInitialInvestment float64             `json:"base_initial_investment"`
	PRBaseline            float64             `json:"pr_baseline"`
	Scenarios             []FinancialScenario `json:"scenarios"`
}

type FinancialScenarioResult struct {
	Name                 string                   `json:"name"`
	Metrics              FinancialMetricsResponse `json:"metrics"`
	AnnualRevenueUSD     float64                  `json:"annual_revenue_usd"`
	NetAnnualCashflowUSD float64                  `json:"net_annual_cashflow_usd"`
	SimplePaybackYears   float64                  `json:"simple_payback_years"`
	ROIPercent           float64                  `json:"roi_percent"`
}

type FinancialScenarioComparisonResponse struct {
	Scenarios []FinancialScenarioResult `json:"scenarios"`
}

type ClimateImpactRequest struct {
	TempImpact         float64 `json:"temp_impact"`
	SoilingImpact      float64 `json:"soiling_impact"`
	WindImpact         float64 `json:"wind_impact"`
	AvailabilityImpact float64 `json:"availability_impact"`
}

type ClimateImpactResponse struct {
	SoilingFactorChange       float64 `json:"soiling_factor_change"`
	EfficiencyFactorChange    float64 `json:"efficiency_factor_change"`
	ModuleTemperatureIncrease float64 `json:"module_temperature_increase"`
	AvailabilityImpactPercent float64 `json:"availability_impact_percent"`
}

type FinancialScenario struct {
	Name                  string  `json:"name"`
	ElectricityPrice      float64 `json:"electricity_price"`
	EscalationRatePercent float64 `json:"escalation_rate_percent"`
	DegradationRate       float64 `json:"degradation_rate_percent"`
	DiscountRatePercent   float64 `json:"discount_rate_percent"`
	PRActual              float64 `json:"pr_actual"`
	CapexMultiplier       float64 `json:"capex_multiplier"`
}

type SaveFinancialScenarioSetRequest struct {
	ProjectID string              `json:"project_id"`
	LayoutID  string              `json:"layout_id"`
	Scenarios []FinancialScenario `json:"scenarios"`
}

type GetFinancialScenarioSetRequest struct {
	ProjectID string `json:"project_id"`
	LayoutID  string `json:"layout_id"`
}

type FinancialScenarioSet struct {
	ProjectID string              `json:"project_id"`
	LayoutID  string              `json:"layout_id"`
	Scenarios []FinancialScenario `json:"scenarios"`
	UpdatedAt time.Time           `json:"updated_at"`
}

type FinancialScenarioSetVersion struct {
	Scenarios []FinancialScenario `json:"scenarios"`
	SavedAt   time.Time           `json:"saved_at"`
}

type ListFinancialScenarioSetsRequest struct {
	ProjectID string `json:"project_id"`
}

type FinancialScenarioSetSummary struct {
	LayoutID      string    `json:"layout_id"`
	ScenarioCount int       `json:"scenario_count"`
	UpdatedAt     time.Time `json:"updated_at"`
}

type GetFinancialScenarioSetVersionsRequest struct {
	ProjectID string `json:"project_id"`
	LayoutID  string `json:"layout_id"`
}

type InterRowShadingRequest struct {
	TiltDeg      float64 `json:"tilt_deg"`
	GCR          float64 `json:"gcr"`
	LatitudeDeg  float64 `json:"latitude_deg"`
	AnalysisDays int     `json:"analysis_days"`
	IsTracker    bool    `json:"is_tracker"`
}

type InterRowShadingResponse struct {
	AnnualShadingLossPercent float64 `json:"annual_shading_loss_percent"`
	NearShadingLossPercent   float64 `json:"near_shading_loss_percent"`
	OptimalGCR               float64 `json:"optimal_gcr"`
	Note                     string  `json:"note"`
}

type YieldUncertaintyRequest struct {
	P50AnnualKWh              float64 `json:"p50_annual_kwh"`
	InterannualVariabilityPct float64 `json:"interannual_variability_pct"`
	MeasurementUncertaintyPct float64 `json:"measurement_uncertainty_pct"`
	ModelUncertaintyPct       float64 `json:"model_uncertainty_pct"`
	SoilingUncertaintyPct     float64 `json:"soiling_uncertainty_pct"`
	DegradationUncertaintyPct float64 `json:"degradation_uncertainty_pct"`
}

type YieldUncertaintyResponse struct {
	P50KWh                 float64 `json:"p50_kwh"`
	P90KWh                 float64 `json:"p90_kwh"`
	P99KWh                 float64 `json:"p99_kwh"`
	CombinedUncertaintyPct float64 `json:"combined_uncertainty_pct"`
}

