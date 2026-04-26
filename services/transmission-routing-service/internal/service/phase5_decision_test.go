package service

import (
	"testing"

	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/domain"
)

func makeScoredTestRoute(name string, totalCost, costPerKm, crossingPremium, distanceM float64, towers []domain.TowerPosition, segments []domain.SegmentExplanation) domain.TransmissionRoute {
	return domain.TransmissionRoute{
		Name:           name,
		VoltageClass:   domain.VoltageClass132kV,
		DistanceM:      distanceM,
		TowerPositions: towers,
		CostBreakdown: domain.CostBreakdown{
			TotalCost:       totalCost,
			CostPerKm:       costPerKm,
			CrossingPremium: crossingPremium,
		},
		SegmentExplanations: segments,
	}
}

func TestPhase5ScoreRouteRewardsLowerCostAndRisk(t *testing.T) {
	cheap := makeScoredTestRoute(
		"cheap",
		120000,
		110000,
		5000,
		1000,
		[]domain.TowerPosition{{HeightM: 18}, {HeightM: 20}, {HeightM: 19}},
		[]domain.SegmentExplanation{{LandType: "overhead", SlopeDeg: 4}, {LandType: "road_corridor_overhead", SlopeDeg: 3}},
	)
	risky := makeScoredTestRoute(
		"risky",
		980000,
		780000,
		120000,
		1000,
		[]domain.TowerPosition{{HeightM: 33}, {HeightM: 35}, {HeightM: 36}, {HeightM: 34}},
		[]domain.SegmentExplanation{{LandType: "underground_cable", SlopeDeg: 18}, {LandType: "water_crossing_overhead", SlopeDeg: 14}},
	)

	cheapScore := ScoreRoute(&cheap)
	riskyScore := ScoreRoute(&risky)

	if cheapScore.CostScore <= riskyScore.CostScore {
		t.Fatalf("expected cheap route cost score %.3f to exceed risky route %.3f", cheapScore.CostScore, riskyScore.CostScore)
	}
	if cheapScore.RiskScore <= riskyScore.RiskScore {
		t.Fatalf("expected cheap route risk score %.3f to exceed risky route %.3f", cheapScore.RiskScore, riskyScore.RiskScore)
	}
	if cheapScore.CompositeScore <= riskyScore.CompositeScore {
		t.Fatalf("expected cheap route composite %.3f to exceed risky route %.3f", cheapScore.CompositeScore, riskyScore.CompositeScore)
	}
	if cheapScore.RecommendationReason == "" {
		t.Fatal("expected recommendation reason to be populated")
	}
}

func TestPhase5ParetoMarkFlagsDominatedRoute(t *testing.T) {
	scores := []domain.RouteScore{
		{CostScore: 0.9, RiskScore: 0.9, ConstructabilityScore: 0.8, ScheduleScore: 0.8},
		{CostScore: 0.7, RiskScore: 0.6, ConstructabilityScore: 0.6, ScheduleScore: 0.7},
		{CostScore: 0.8, RiskScore: 0.95, ConstructabilityScore: 0.7, ScheduleScore: 0.5},
	}
	marked := ParetoMark(scores, []string{"A", "B", "C"})

	if !marked[0].ParetoFrontier {
		t.Fatal("route A should be on frontier")
	}
	if marked[1].ParetoFrontier {
		t.Fatal("route B should be dominated and not on frontier")
	}
	if !marked[2].ParetoFrontier {
		t.Fatal("route C should remain on frontier due to stronger risk score")
	}
}

func TestPhase5AnnotateParetoRoutesPopulatesScores(t *testing.T) {
	routes := []domain.TransmissionRoute{
		makeScoredTestRoute(
			"Option A",
			150000,
			130000,
			10000,
			1000,
			[]domain.TowerPosition{{HeightM: 20}, {HeightM: 21}, {HeightM: 20}},
			[]domain.SegmentExplanation{{LandType: "overhead", SlopeDeg: 4}},
		),
		makeScoredTestRoute(
			"Option B",
			240000,
			200000,
			70000,
			1000,
			[]domain.TowerPosition{{HeightM: 31}, {HeightM: 32}, {HeightM: 33}, {HeightM: 31}},
			[]domain.SegmentExplanation{{LandType: "underground_cable", SlopeDeg: 14}, {LandType: "water_crossing_overhead", SlopeDeg: 11}},
		),
	}

	annotateParetoRoutes(routes)

	for i := range routes {
		if routes[i].RouteScore == nil {
			t.Fatalf("route %d missing route score after annotation", i)
		}
		if routes[i].RouteScore.RecommendationReason == "" {
			t.Fatalf("route %d missing recommendation reason", i)
		}
	}
	if routes[0].RouteScore.CompositeScore <= routes[1].RouteScore.CompositeScore {
		t.Fatalf("expected Option A composite %.3f to exceed Option B %.3f", routes[0].RouteScore.CompositeScore, routes[1].RouteScore.CompositeScore)
	}
}

