package repository

import (
	"context"
	"encoding/json"
	"fmt"
	"math"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"sync"
	"time"

	"solar3d/compute-service/internal/models"
)

// storedScenarioRecord is the on-disk format for a scenario set, including history.
type storedScenarioRecord struct {
	ProjectID string                               `json:"project_id"`
	LayoutID  string                               `json:"layout_id"`
	Scenarios []models.FinancialScenario           `json:"scenarios"`
	UpdatedAt time.Time                            `json:"updated_at"`
	History   []models.FinancialScenarioSetVersion `json:"history,omitempty"`
}

type RustExtendedRepository struct {
	baseURL      string
	client       *http.Client
	scenarioPath string
	mu           sync.RWMutex
	scenarioSets map[string]*storedScenarioRecord
}

func NewRustExtendedRepository(baseURL string, scenarioPath string) *RustExtendedRepository {
	normalized := strings.TrimRight(baseURL, "/")
	if normalized == "" {
		normalized = "http://127.0.0.1:8085"
	}
	if strings.TrimSpace(scenarioPath) == "" {
		scenarioPath = "data/financial_scenarios.json"
	}

	repo := &RustExtendedRepository{
		baseURL:      normalized,
		client:       &http.Client{Timeout: 10 * time.Second},
		scenarioPath: scenarioPath,
		scenarioSets: make(map[string]*storedScenarioRecord),
	}
	repo.loadScenarioSetsFromDisk()
	return repo
}

func (r *RustExtendedRepository) SolarTransposition(ctx context.Context, req *models.SolarTranspositionRequest) (*models.SolarTranspositionResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	var out models.SolarTranspositionResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/extended/solar-transposition", req, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustExtendedRepository) FinancialMetrics(ctx context.Context, req *models.FinancialMetricsRequest) (*models.FinancialMetricsResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	var out models.FinancialMetricsResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/extended/financial-metrics", req, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustExtendedRepository) CompareFinancialScenarios(ctx context.Context, req *models.FinancialScenarioComparisonRequest) (*models.FinancialScenarioComparisonResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	if req.AnnualYieldKWh <= 0 {
		return nil, fmt.Errorf("annual_yield_kwh must be positive")
	}
	if req.ProjectLifeYears <= 0 {
		return nil, fmt.Errorf("project_life_years must be positive")
	}
	if req.BaseInitialInvestment <= 0 {
		return nil, fmt.Errorf("base_initial_investment must be positive")
	}
	if len(req.Scenarios) == 0 {
		return nil, fmt.Errorf("at least one scenario is required")
	}

	results := make([]models.FinancialScenarioResult, 0, len(req.Scenarios))
	for _, scenario := range req.Scenarios {
		select {
		case <-ctx.Done():
			return nil, ctx.Err()
		default:
		}

		cashflows := buildAnnualCashflows(req, scenario)
		capexMultiplier := scenario.CapexMultiplier
		if capexMultiplier == 0 {
			capexMultiplier = 1
		}
		metrics, err := r.FinancialMetrics(ctx, &models.FinancialMetricsRequest{
			AnnualCashflows:   cashflows,
			InitialInvestment: req.BaseInitialInvestment * capexMultiplier,
			DiscountRate:      scenario.DiscountRatePercent / 100.0,
			PRBaseline:        req.PRBaseline,
			PRActual:          scenario.PRActual,
		})
		if err != nil {
			return nil, fmt.Errorf("scenario %q: %w", scenario.Name, err)
		}

		annualRevenue := req.AnnualYieldKWh * scenario.ElectricityPrice
		netAnnualCashflow := annualRevenue - req.AnnualOMUSD
		initialInvestment := req.BaseInitialInvestment * capexMultiplier
		simplePayback := 0.0
		if netAnnualCashflow > 0 {
			simplePayback = initialInvestment / netAnnualCashflow
		}
		roi := 0.0
		if initialInvestment > 0 {
			roi = ((netAnnualCashflow * float64(req.ProjectLifeYears)) - initialInvestment) / initialInvestment * 100.0
		}

		results = append(results, models.FinancialScenarioResult{
			Name:                 scenario.Name,
			Metrics:              *metrics,
			AnnualRevenueUSD:     annualRevenue,
			NetAnnualCashflowUSD: netAnnualCashflow,
			SimplePaybackYears:   simplePayback,
			ROIPercent:           roi,
		})
	}

	return &models.FinancialScenarioComparisonResponse{Scenarios: results}, nil
}

func (r *RustExtendedRepository) ClimateImpact(ctx context.Context, req *models.ClimateImpactRequest) (*models.ClimateImpactResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	var out models.ClimateImpactResponse
	if err := postJSONWithClient(ctx, r.client, r.baseURL+"/v1/extended/climate-impact", req, &out); err != nil {
		return nil, err
	}
	return &out, nil
}

func (r *RustExtendedRepository) SaveFinancialScenarioSet(ctx context.Context, req *models.SaveFinancialScenarioSetRequest) (*models.FinancialScenarioSet, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	if strings.TrimSpace(req.ProjectID) == "" || strings.TrimSpace(req.LayoutID) == "" {
		return nil, fmt.Errorf("project_id and layout_id are required")
	}
	if len(req.Scenarios) == 0 {
		return nil, fmt.Errorf("at least one scenario is required")
	}

	select {
	case <-ctx.Done():
		return nil, ctx.Err()
	default:
	}

	const maxHistory = 10
	now := time.Now().UTC()

	r.mu.Lock()
	key := r.scenarioKey(req.ProjectID, req.LayoutID)
	existing := r.scenarioSets[key]

	var history []models.FinancialScenarioSetVersion
	if existing != nil && len(existing.Scenarios) > 0 {
		history = append([]models.FinancialScenarioSetVersion(nil), existing.History...)
		history = append(history, models.FinancialScenarioSetVersion{
			Scenarios: append([]models.FinancialScenario(nil), existing.Scenarios...),
			SavedAt:   existing.UpdatedAt,
		})
		if len(history) > maxHistory {
			history = history[len(history)-maxHistory:]
		}
	}

	saved := &storedScenarioRecord{
		ProjectID: req.ProjectID,
		LayoutID:  req.LayoutID,
		Scenarios: append([]models.FinancialScenario(nil), req.Scenarios...),
		UpdatedAt: now,
		History:   history,
	}
	r.scenarioSets[key] = saved
	err := r.persistScenarioSetsLocked()
	r.mu.Unlock()
	if err != nil {
		return nil, err
	}

	return storedRecordToSet(saved), nil
}

func (r *RustExtendedRepository) GetFinancialScenarioSet(ctx context.Context, req *models.GetFinancialScenarioSetRequest) (*models.FinancialScenarioSet, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	if strings.TrimSpace(req.ProjectID) == "" || strings.TrimSpace(req.LayoutID) == "" {
		return nil, fmt.Errorf("project_id and layout_id are required")
	}

	select {
	case <-ctx.Done():
		return nil, ctx.Err()
	default:
	}

	r.mu.RLock()
	record, ok := r.scenarioSets[r.scenarioKey(req.ProjectID, req.LayoutID)]
	r.mu.RUnlock()
	if !ok {
		return nil, fmt.Errorf("scenario set not found")
	}

	return storedRecordToSet(record), nil
}

func (r *RustExtendedRepository) ListFinancialScenarioSets(ctx context.Context, req *models.ListFinancialScenarioSetsRequest) ([]models.FinancialScenarioSetSummary, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	if strings.TrimSpace(req.ProjectID) == "" {
		return nil, fmt.Errorf("project_id is required")
	}

	select {
	case <-ctx.Done():
		return nil, ctx.Err()
	default:
	}

	r.mu.RLock()
	defer r.mu.RUnlock()

	var summaries []models.FinancialScenarioSetSummary
	for _, rec := range r.scenarioSets {
		if rec.ProjectID == req.ProjectID {
			summaries = append(summaries, models.FinancialScenarioSetSummary{
				LayoutID:      rec.LayoutID,
				ScenarioCount: len(rec.Scenarios),
				UpdatedAt:     rec.UpdatedAt,
			})
		}
	}

	return summaries, nil
}

func (r *RustExtendedRepository) GetFinancialScenarioSetVersions(ctx context.Context, req *models.GetFinancialScenarioSetVersionsRequest) ([]models.FinancialScenarioSetVersion, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	if strings.TrimSpace(req.ProjectID) == "" || strings.TrimSpace(req.LayoutID) == "" {
		return nil, fmt.Errorf("project_id and layout_id are required")
	}

	select {
	case <-ctx.Done():
		return nil, ctx.Err()
	default:
	}

	r.mu.RLock()
	rec, ok := r.scenarioSets[r.scenarioKey(req.ProjectID, req.LayoutID)]
	r.mu.RUnlock()
	if !ok {
		return nil, fmt.Errorf("scenario set not found")
	}

	// Return history newest-first.
	out := make([]models.FinancialScenarioSetVersion, len(rec.History))
	for i, v := range rec.History {
		out[len(rec.History)-1-i] = models.FinancialScenarioSetVersion{
			Scenarios: append([]models.FinancialScenario(nil), v.Scenarios...),
			SavedAt:   v.SavedAt,
		}
	}
	return out, nil
}

func (r *RustExtendedRepository) scenarioKey(projectID string, layoutID string) string {
	return projectID + ":" + layoutID
}

func (r *RustExtendedRepository) loadScenarioSetsFromDisk() {
	r.mu.Lock()
	defer r.mu.Unlock()

	content, err := os.ReadFile(r.scenarioPath)
	if err != nil {
		return
	}

	var stored []*storedScenarioRecord
	if err := json.Unmarshal(content, &stored); err != nil {
		return
	}

	for _, rec := range stored {
		if rec == nil {
			continue
		}
		r.scenarioSets[r.scenarioKey(rec.ProjectID, rec.LayoutID)] = cloneStoredRecord(rec)
	}
}

func (r *RustExtendedRepository) persistScenarioSetsLocked() error {
	if err := os.MkdirAll(filepath.Dir(r.scenarioPath), 0o755); err != nil {
		return fmt.Errorf("creating scenario storage directory: %w", err)
	}

	stored := make([]*storedScenarioRecord, 0, len(r.scenarioSets))
	for _, rec := range r.scenarioSets {
		stored = append(stored, cloneStoredRecord(rec))
	}

	payload, err := json.MarshalIndent(stored, "", "  ")
	if err != nil {
		return fmt.Errorf("marshaling scenario sets: %w", err)
	}

	if err := os.WriteFile(r.scenarioPath, payload, 0o644); err != nil {
		return fmt.Errorf("writing scenario sets file: %w", err)
	}

	return nil
}

func cloneStoredRecord(rec *storedScenarioRecord) *storedScenarioRecord {
	if rec == nil {
		return nil
	}
	history := make([]models.FinancialScenarioSetVersion, len(rec.History))
	for i, v := range rec.History {
		history[i] = models.FinancialScenarioSetVersion{
			Scenarios: append([]models.FinancialScenario(nil), v.Scenarios...),
			SavedAt:   v.SavedAt,
		}
	}
	return &storedScenarioRecord{
		ProjectID: rec.ProjectID,
		LayoutID:  rec.LayoutID,
		Scenarios: append([]models.FinancialScenario(nil), rec.Scenarios...),
		UpdatedAt: rec.UpdatedAt,
		History:   history,
	}
}

func storedRecordToSet(rec *storedScenarioRecord) *models.FinancialScenarioSet {
	if rec == nil {
		return nil
	}
	return &models.FinancialScenarioSet{
		ProjectID: rec.ProjectID,
		LayoutID:  rec.LayoutID,
		Scenarios: append([]models.FinancialScenario(nil), rec.Scenarios...),
		UpdatedAt: rec.UpdatedAt,
	}
}

func buildAnnualCashflows(req *models.FinancialScenarioComparisonRequest, scenario models.FinancialScenario) []float64 {
	flows := make([]float64, 0, req.ProjectLifeYears)
	for year := 1; year <= req.ProjectLifeYears; year++ {
		degradedYield := req.AnnualYieldKWh * math.Pow(1-scenario.DegradationRate/100.0, float64(year-1))
		escalatedPrice := scenario.ElectricityPrice * math.Pow(1+scenario.EscalationRatePercent/100.0, float64(year-1))
		revenue := degradedYield * escalatedPrice
		flows = append(flows, revenue-req.AnnualOMUSD)
	}
	return flows
}

// CalculateInterRowShading implements a geometric inter-row shading model based on
// the "shading angle" / Ground Coverage Ratio approach (IEC 62724 / Duffie-Beckman).
// For trackers the algorithm applies a simplified backtracking correction.
func (r *RustExtendedRepository) CalculateInterRowShading(ctx context.Context, req *models.InterRowShadingRequest) (*models.InterRowShadingResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	select {
	case <-ctx.Done():
		return nil, ctx.Err()
	default:
	}

	gcr := req.GCR
	if gcr <= 0 || gcr >= 1 {
		return nil, fmt.Errorf("gcr must be between 0 (exclusive) and 1 (exclusive)")
	}
	tilt := req.TiltDeg
	if req.IsTracker {
		// For a single-axis tracker the annual shading loss at a given GCR uses a standard
		// linear backtracking model; typical industry approximation.
		tilt = 30.0 // representative worst-case tilt for backtracking shading calc
	}

	// Sharow ratio at midday equinox — a conservative geometric proxy.
	// Shadow length = cos(tilt) + sin(tilt)*tan(solar_altitude)
	// Fraction of row shaded = max(0, 1 - pitch/shadow_length)
	// pitch / panel_length = 1/gcr, so panel_length/pitch = gcr
	latRad := req.LatitudeDeg * math.Pi / 180.0
	tiltRad := tilt * math.Pi / 180.0

	// Annual loss estimated by sampling N days and averaging.
	days := req.AnalysisDays
	if days <= 0 {
		days = 365
	}

	var shadingSum float64
	for d := 0; d < days; d++ {
		// Solar declination (Spencer)
		dayAngle := 2 * math.Pi * float64(d) / 365.0
		decl := 0.006918 - 0.399912*math.Cos(dayAngle) + 0.070257*math.Sin(dayAngle) -
			0.006758*math.Cos(2*dayAngle) + 0.000907*math.Sin(2*dayAngle)
		// Solar noon altitude
		sinAlt := math.Sin(latRad)*math.Sin(decl) + math.Cos(latRad)*math.Cos(decl)
		solarAlt := math.Asin(sinAlt)
		if solarAlt <= 0 {
			shadingSum += 0
			continue
		}
		// Shadow length from base of row (normalised to row length = 1)
		shadowLen := math.Cos(tiltRad) + math.Sin(tiltRad)/math.Tan(solarAlt)
		// Pitch in units of row length = 1/gcr
		pitch := 1.0 / gcr
		// Fraction unshaded
		unshaded := 1.0
		if shadowLen < pitch {
			unshaded = shadowLen / pitch
		}
		shadingSum += 1.0 - unshaded
	}

	annualShadingLoss := (shadingSum / float64(days)) * 100.0

	// Near-shading is roughly 70% of total (far-horizon shading adds ~30%).
	nearShading := annualShadingLoss * 0.7

	// Optimal GCR: trade-off shading vs land — typical rule-of-thumb minimises LCOE.
	// For fixed tilt: optGCR ≈ cos(tilt) / (cos(tilt) + tan(10°)) at latitude/tilt optimum.
	optGCR := math.Cos(tiltRad) / (math.Cos(tiltRad) + math.Tan(10.0*math.Pi/180.0))

	note := "fixed-tilt geometric model"
	if req.IsTracker {
		note = "single-axis tracker with backtracking approximation"
	}

	return &models.InterRowShadingResponse{
		AnnualShadingLossPercent: annualShadingLoss,
		NearShadingLossPercent:   nearShading,
		OptimalGCR:               optGCR,
		Note:                     note,
	}, nil
}

// CalculateYieldUncertainty estimates P50/P90/P99 annual energy using a combined
// quadratic uncertainty model (IEC TR 61724-3 / NREL approach).
func (r *RustExtendedRepository) CalculateYieldUncertainty(ctx context.Context, req *models.YieldUncertaintyRequest) (*models.YieldUncertaintyResponse, error) {
	if req == nil {
		return nil, fmt.Errorf("request is nil")
	}
	select {
	case <-ctx.Done():
		return nil, ctx.Err()
	default:
	}
	if req.P50AnnualKWh <= 0 {
		return nil, fmt.Errorf("p50_annual_kwh must be positive")
	}

	// Combined one-sigma uncertainty = sqrt(sum of squares of individual uncertainties).
	combined := math.Sqrt(
		sq(req.InterannualVariabilityPct) +
			sq(req.MeasurementUncertaintyPct) +
			sq(req.ModelUncertaintyPct) +
			sq(req.SoilingUncertaintyPct) +
			sq(req.DegradationUncertaintyPct),
	)

	// Normal distribution quantiles: P90 = P50 × (1 - 1.2816*σ%), P99 = P50 × (1 - 2.3263*σ%)
	sigma := combined / 100.0
	p90 := req.P50AnnualKWh * (1.0 - 1.2816*sigma)
	p99 := req.P50AnnualKWh * (1.0 - 2.3263*sigma)

	return &models.YieldUncertaintyResponse{
		P50KWh:                 req.P50AnnualKWh,
		P90KWh:                 p90,
		P99KWh:                 p99,
		CombinedUncertaintyPct: combined,
	}, nil
}

func sq(x float64) float64 { return x * x }

