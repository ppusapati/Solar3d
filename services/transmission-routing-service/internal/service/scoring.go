package service

import (
	"fmt"
	"math"
	"strings"

	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/domain"
)

// ─────────────────────────────────────────────────────────────────────────────
// Scoring weights
// ─────────────────────────────────────────────────────────────────────────────

const (
	weightCost             = 0.35
	weightRisk             = 0.30
	weightConstructability = 0.20
	weightSchedule         = 0.15
)

// voltageClassBaselineCostPerKm is the expected cost-per-km for overhead line at each
// voltage class under normal terrain.  Used to normalise the cost score.
func voltageClassBaselineCostPerKm(class domain.VoltageClass) float64 {
	d := defaultsForVoltageClass(class)
	// Baseline: conductor + typical tower spacing + standard ROW (no premium)
	typicalTowers := 1000.0 / d.MaxSpanM // towers per km at max span
	return d.ConductorCostKm + typicalTowers*d.TowerUnitCost + 1000.0*d.RowWidthM*d.RowCostPerSqM
}

// ─────────────────────────────────────────────────────────────────────────────
// Single-route scoring
// ─────────────────────────────────────────────────────────────────────────────

// ScoreRoute computes a RouteScore for a single route.  The score is self-contained
// and does not depend on other routes; Pareto flags are set separately by ParetoMark.
func ScoreRoute(route *domain.TransmissionRoute) domain.RouteScore {
	if route == nil {
		return domain.RouteScore{}
	}

	costScore, costReason := scoreCostDimension(route)
	riskScore, riskReason := scoreRiskDimension(route)
	constructScore, constructReason := scoreConstructabilityDimension(route)
	scheduleScore, scheduleReason := scoreScheduleDimension(route)

	composite := weightCost*costScore +
		weightRisk*riskScore +
		weightConstructability*constructScore +
		weightSchedule*scheduleScore

	score := domain.RouteScore{
		CostScore:             costScore,
		RiskScore:             riskScore,
		ConstructabilityScore: constructScore,
		ScheduleScore:         scheduleScore,
		CompositeScore:        math.Round(composite*1000) / 1000,
		DimensionReasons: map[string]string{
			"cost":             costReason,
			"risk":             riskReason,
			"constructability": constructReason,
			"schedule":         scheduleReason,
		},
	}
	score.RecommendationReason = RecommendationReason(score, route.Name)
	return score
}

// scoreCostDimension returns a [0,1] cost efficiency score.
// 1.0 = cost/km equals or beats the baseline for this voltage class.
// 0.0 = cost/km is ≥ 3× the baseline.
func scoreCostDimension(route *domain.TransmissionRoute) (float64, string) {
	baseline := voltageClassBaselineCostPerKm(route.VoltageClass)
	if baseline <= 0 || route.CostBreakdown.CostPerKm <= 0 {
		return 0.5, "cost data unavailable; scored at neutral"
	}
	ratio := route.CostBreakdown.CostPerKm / baseline
	// score = 1 at ratio ≤ 1, = 0 at ratio ≥ 3, linear in between
	score := clamp01(1.0 - (ratio-1.0)/2.0)
	var reason string
	switch {
	case score >= 0.85:
		reason = fmt.Sprintf("Excellent cost efficiency: %.0f/km vs baseline %.0f/km (ratio %.2f×)",
			route.CostBreakdown.CostPerKm, baseline, ratio)
	case score >= 0.60:
		reason = fmt.Sprintf("Moderate cost: %.0f/km is %.2f× the voltage-class baseline of %.0f/km",
			route.CostBreakdown.CostPerKm, ratio, baseline)
	default:
		reason = fmt.Sprintf("High cost: %.0f/km is %.2f× the baseline %.0f/km; driven by crossings or underground cable",
			route.CostBreakdown.CostPerKm, ratio, baseline)
	}
	return score, reason
}

// scoreRiskDimension returns a [0,1] risk score.
// Risk is driven by: crossing premium share of total cost, underground distance ratio,
// and sensitive-land segment count.
func scoreRiskDimension(route *domain.TransmissionRoute) (float64, string) {
	if route.CostBreakdown.TotalCost <= 0 {
		return 0.5, "risk data unavailable; scored at neutral"
	}
	crossingRatio := route.CostBreakdown.CrossingPremium / route.CostBreakdown.TotalCost

	undergroundCount, waterCount, sensitiveCount := 0, 0, 0
	for _, seg := range route.SegmentExplanations {
		land := strings.ToLower(seg.LandType)
		switch {
		case strings.Contains(land, "underground"):
			undergroundCount++
		case strings.Contains(land, "water"):
			waterCount++
		case strings.Contains(land, "sensitive"):
			sensitiveCount++
		}
	}
	totalSegs := max(1, len(route.SegmentExplanations))
	complexRatio := float64(undergroundCount+waterCount+sensitiveCount) / float64(totalSegs)

	// Combined risk penalty: 50% weight each
	penalty := 0.5*crossingRatio + 0.5*complexRatio
	// score = 1 at penalty=0, = 0 at penalty ≥ 0.5
	score := clamp01(1.0 - penalty*2.0)

	var reason string
	switch {
	case score >= 0.85:
		reason = fmt.Sprintf("Low risk: crossing premium is %.1f%% of cost; %d complex segments out of %d",
			crossingRatio*100, undergroundCount+waterCount+sensitiveCount, totalSegs)
	case score >= 0.55:
		reason = fmt.Sprintf("Moderate risk: %.1f%% premium ratio; %d underground, %d water, %d sensitive segments",
			crossingRatio*100, undergroundCount, waterCount, sensitiveCount)
	default:
		reason = fmt.Sprintf("High risk: crossing premium %.1f%% of total cost; %d of %d segments are complex terrain",
			crossingRatio*100, undergroundCount+waterCount+sensitiveCount, totalSegs)
	}
	return score, reason
}

// scoreConstructabilityDimension returns a [0,1] score for physical buildability.
// Higher tower heights and steep slopes reduce constructability.
func scoreConstructabilityDimension(route *domain.TransmissionRoute) (float64, string) {
	if len(route.TowerPositions) == 0 {
		return 0.5, "no tower data; scored at neutral"
	}
	totalHeight := 0.0
	for _, t := range route.TowerPositions {
		totalHeight += t.HeightM
	}
	avgHeight := totalHeight / float64(len(route.TowerPositions))

	maxSlopeDeg := 0.0
	for _, seg := range route.SegmentExplanations {
		if seg.SlopeDeg > maxSlopeDeg {
			maxSlopeDeg = seg.SlopeDeg
		}
	}

	// Normalise height: 15 m is easy, 45 m is very difficult
	heightPenalty := clamp01((avgHeight - 15.0) / 30.0)
	// Normalise slope: 5° is fine, 25° is difficult
	slopePenalty := clamp01((maxSlopeDeg - 5.0) / 20.0)

	score := clamp01(1.0 - 0.6*heightPenalty - 0.4*slopePenalty)
	var reason string
	switch {
	case score >= 0.85:
		reason = fmt.Sprintf("Good constructability: avg tower height %.1f m, max slope %.1f°",
			avgHeight, maxSlopeDeg)
	case score >= 0.60:
		reason = fmt.Sprintf("Moderate constructability: avg tower %.1f m (heightPenalty=%.2f), max slope %.1f°",
			avgHeight, heightPenalty, maxSlopeDeg)
	default:
		reason = fmt.Sprintf("Difficult construction: avg tower %.1f m and max slope %.1f° will require specialised equipment",
			avgHeight, maxSlopeDeg)
	}
	return score, reason
}

// scoreScheduleDimension returns a [0,1] schedule score.
// More towers and more underground segments both drive up construction schedule.
func scoreScheduleDimension(route *domain.TransmissionRoute) (float64, string) {
	if route.DistanceM <= 0 {
		return 0.5, "distance data unavailable; scored at neutral"
	}
	towersPerKm := float64(len(route.TowerPositions)) / (route.DistanceM / 1000.0)
	// Count underground segments (each requires trenching — slowest activity)
	undergroundSegs := 0
	for _, seg := range route.SegmentExplanations {
		if strings.Contains(strings.ToLower(seg.LandType), "underground") {
			undergroundSegs++
		}
	}
	undergroundRatio := float64(undergroundSegs) / float64(max(1, len(route.SegmentExplanations)))

	// Typical: 3 towers/km is easy, 8+/km is intensive; underground ratio > 0.3 is slow
	towerPenalty := clamp01((towersPerKm - 3.0) / 5.0)
	undergroundPenalty := clamp01(undergroundRatio / 0.3)

	score := clamp01(1.0 - 0.5*towerPenalty - 0.5*undergroundPenalty)
	var reason string
	switch {
	case score >= 0.85:
		reason = fmt.Sprintf("Fast schedule: %.1f towers/km, %.0f%% underground segments",
			towersPerKm, undergroundRatio*100)
	case score >= 0.55:
		reason = fmt.Sprintf("Moderate schedule: %.1f towers/km, %.0f%% underground — expect some trenching complexity",
			towersPerKm, undergroundRatio*100)
	default:
		reason = fmt.Sprintf("Slow schedule: %.1f towers/km and %.0f%% underground segments will extend construction timeline significantly",
			towersPerKm, undergroundRatio*100)
	}
	return score, reason
}

// clamp01 clamps v to [0.0, 1.0].
func clamp01(v float64) float64 {
	if v < 0 {
		return 0
	}
	if v > 1 {
		return 1
	}
	return v
}

// ─────────────────────────────────────────────────────────────────────────────
// Recommendation reason
// ─────────────────────────────────────────────────────────────────────────────

// RecommendationReason builds a human-readable explanation of why a scored route
// is recommended, given its normalised dimension scores.
func RecommendationReason(score domain.RouteScore, routeName string) string {
	strengths, weaknesses := []string{}, []string{}

	dims := map[string]float64{
		"cost":             score.CostScore,
		"risk":             score.RiskScore,
		"constructability": score.ConstructabilityScore,
		"schedule":         score.ScheduleScore,
	}
	labels := map[string]string{
		"cost":             "cost efficiency",
		"risk":             "low risk",
		"constructability": "constructability",
		"schedule":         "schedule",
	}
	for dim, s := range dims {
		if s >= 0.75 {
			strengths = append(strengths, labels[dim])
		} else if s < 0.50 {
			weaknesses = append(weaknesses, labels[dim])
		}
	}

	var parts []string
	if len(strengths) > 0 {
		parts = append(parts, fmt.Sprintf("This route scores well on %s (composite %.2f).",
			joinOr(strengths), score.CompositeScore))
	} else {
		parts = append(parts, fmt.Sprintf("This route achieves a balanced composite score of %.2f.", score.CompositeScore))
	}
	if len(weaknesses) > 0 {
		parts = append(parts, fmt.Sprintf("Trade-off: lower %s compared to the voltage-class baseline.", joinOr(weaknesses)))
	}
	if score.ParetoFrontier {
		parts = append(parts, "It lies on the Pareto frontier — no other computed route outperforms it across all dimensions simultaneously.")
	}
	return strings.Join(parts, " ")
}

func joinOr(items []string) string {
	if len(items) == 0 {
		return ""
	}
	if len(items) == 1 {
		return items[0]
	}
	return strings.Join(items[:len(items)-1], ", ") + " and " + items[len(items)-1]
}

// ─────────────────────────────────────────────────────────────────────────────
// Pareto dominance
// ─────────────────────────────────────────────────────────────────────────────

// dominates returns true when score a is Pareto-dominant over b:
// a ≥ b on every dimension and a > b on at least one.
func dominates(a, b domain.RouteScore) bool {
	if a.CostScore < b.CostScore || a.RiskScore < b.RiskScore ||
		a.ConstructabilityScore < b.ConstructabilityScore || a.ScheduleScore < b.ScheduleScore {
		return false
	}
	return a.CostScore > b.CostScore || a.RiskScore > b.RiskScore ||
		a.ConstructabilityScore > b.ConstructabilityScore || a.ScheduleScore > b.ScheduleScore
}

// ParetoMark sets ParetoFrontier on each score based on mutual dominance within the set.
// Also sets RecommendationReason on each score after frontier status is known.
func ParetoMark(scores []domain.RouteScore, names []string) []domain.RouteScore {
	n := len(scores)
	if n == 0 {
		return scores
	}
	frontier := make([]bool, n)
	for i := range scores {
		frontier[i] = true
		for j := range scores {
			if i == j {
				continue
			}
			if dominates(scores[j], scores[i]) {
				frontier[i] = false
				break
			}
		}
	}
	result := make([]domain.RouteScore, n)
	for i, s := range scores {
		s.ParetoFrontier = frontier[i]
		name := ""
		if i < len(names) {
			name = names[i]
		}
		s.RecommendationReason = RecommendationReason(s, name)
		result[i] = s
	}
	return result
}

// annotateParetoRoutes computes per-route scores if needed and marks the Pareto
// frontier across the supplied route set in-place.
func annotateParetoRoutes(routes []domain.TransmissionRoute) {
	if len(routes) == 0 {
		return
	}
	scores := make([]domain.RouteScore, len(routes))
	names := make([]string, len(routes))
	for i := range routes {
		if routes[i].RouteScore != nil {
			scores[i] = *routes[i].RouteScore
		} else {
			scores[i] = ScoreRoute(&routes[i])
		}
		names[i] = routes[i].Name
	}
	scores = ParetoMark(scores, names)
	for i := range routes {
		score := scores[i]
		routes[i].RouteScore = &score
		if routes[i].Metadata == nil {
			routes[i].Metadata = map[string]interface{}{}
		}
		routes[i].Metadata["route_score"] = score
	}
}

