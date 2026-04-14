package service

import (
	"math"
	"strings"

	"solar3d/transmission-routing-service/internal/domain"
)

type classDefaults struct {
	MinSpanM         float64
	MaxSpanM         float64
	RowWidthM        float64
	MaxSlopeDeg      float64
	MaxDeflectionDeg float64
	TurnPenalty      float64
	ConductorCostKm  float64
	TowerUnitCost    float64
	RowCostPerSqM    float64
	WaterCrossingMul float64
	RoadDiscount     float64
	OffRoadPenalty   float64
	RoadBufferM      float64
}

func defaultsForVoltageClass(class domain.VoltageClass) classDefaults {
	switch class {
	case domain.VoltageClass11kV:
		return classDefaults{MinSpanM: 50, MaxSpanM: 80, RowWidthM: 8, MaxSlopeDeg: 20, MaxDeflectionDeg: 50, TurnPenalty: 1.2, ConductorCostKm: 12000, TowerUnitCost: 2500, RowCostPerSqM: 3, WaterCrossingMul: 8, RoadDiscount: 0.3, OffRoadPenalty: 5.0, RoadBufferM: 15}
	case domain.VoltageClass33kV:
		return classDefaults{MinSpanM: 80, MaxSpanM: 120, RowWidthM: 12, MaxSlopeDeg: 19, MaxDeflectionDeg: 48, TurnPenalty: 1.35, ConductorCostKm: 22000, TowerUnitCost: 8000, RowCostPerSqM: 5, WaterCrossingMul: 8, RoadDiscount: 0.3, OffRoadPenalty: 5.0, RoadBufferM: 20}
	case domain.VoltageClass66kV:
		return classDefaults{MinSpanM: 150, MaxSpanM: 200, RowWidthM: 18, MaxSlopeDeg: 18, MaxDeflectionDeg: 45, TurnPenalty: 1.5, ConductorCostKm: 42000, TowerUnitCost: 18000, RowCostPerSqM: 7, WaterCrossingMul: 8, RoadDiscount: 0.3, OffRoadPenalty: 5.0, RoadBufferM: 25}
	case domain.VoltageClass132kV:
		return classDefaults{MinSpanM: 250, MaxSpanM: 300, RowWidthM: 27, MaxSlopeDeg: 16, MaxDeflectionDeg: 40, TurnPenalty: 1.8, ConductorCostKm: 76000, TowerUnitCost: 32000, RowCostPerSqM: 9, WaterCrossingMul: 8, RoadDiscount: 0.3, OffRoadPenalty: 5.0, RoadBufferM: 35}
	case domain.VoltageClass220kV:
		return classDefaults{MinSpanM: 300, MaxSpanM: 400, RowWidthM: 35, MaxSlopeDeg: 14, MaxDeflectionDeg: 35, TurnPenalty: 2.2, ConductorCostKm: 130000, TowerUnitCost: 52000, RowCostPerSqM: 12, WaterCrossingMul: 8, RoadDiscount: 0.3, OffRoadPenalty: 5.0, RoadBufferM: 45}
	case domain.VoltageClass400kV:
		return classDefaults{MinSpanM: 300, MaxSpanM: 400, RowWidthM: 52, MaxSlopeDeg: 12, MaxDeflectionDeg: 30, TurnPenalty: 2.8, ConductorCostKm: 220000, TowerUnitCost: 94000, RowCostPerSqM: 18, WaterCrossingMul: 8, RoadDiscount: 0.3, OffRoadPenalty: 5.0, RoadBufferM: 60}
	default:
		return classDefaults{MinSpanM: 80, MaxSpanM: 120, RowWidthM: 12, MaxSlopeDeg: 18, MaxDeflectionDeg: 45, TurnPenalty: 1.5, ConductorCostKm: 22000, TowerUnitCost: 8000, RowCostPerSqM: 5, WaterCrossingMul: 8, RoadDiscount: 0.3, OffRoadPenalty: 5.0, RoadBufferM: 20}
	}
}

func spanBandForVoltageClass(class domain.VoltageClass) (float64, float64) {
	switch class {
	case domain.VoltageClass11kV:
		return 50, 80
	case domain.VoltageClass33kV:
		return 80, 120
	case domain.VoltageClass66kV:
		return 150, 200
	case domain.VoltageClass132kV:
		return 250, 300
	case domain.VoltageClass220kV, domain.VoltageClass400kV:
		return 300, 400
	default:
		return 80, 120
	}
}

func resolveConstraints(class domain.VoltageClass, in domain.TransmissionConstraints) domain.TransmissionConstraints {
	defaults := defaultsForVoltageClass(class)
	bandMin, bandMax := spanBandForVoltageClass(class)
	if in.MinSpanM <= 0 {
		in.MinSpanM = defaults.MinSpanM
	}
	if in.MaxSpanM <= 0 {
		in.MaxSpanM = defaults.MaxSpanM
	}
	in.MinSpanM = math.Max(in.MinSpanM, bandMin)
	in.MinSpanM = math.Min(in.MinSpanM, bandMax)
	in.MaxSpanM = math.Max(in.MaxSpanM, bandMin)
	in.MaxSpanM = math.Min(in.MaxSpanM, bandMax)
	if in.MaxSpanM < in.MinSpanM {
		in.MaxSpanM = in.MinSpanM
	}
	if in.RowWidthM <= 0 {
		in.RowWidthM = defaults.RowWidthM
	}
	if in.MaxSlopeDeg <= 0 {
		in.MaxSlopeDeg = defaults.MaxSlopeDeg
	}
	if in.MaxDeflectionDeg <= 0 {
		in.MaxDeflectionDeg = defaults.MaxDeflectionDeg
	}
	if in.SlopePenaltyFactor <= 0 {
		in.SlopePenaltyFactor = 2.0
	}
	if in.TurnPenaltyFactor <= 0 {
		in.TurnPenaltyFactor = defaults.TurnPenalty
	}
	if in.WaterCrossingCostMult <= 0 {
		in.WaterCrossingCostMult = defaults.WaterCrossingMul
	}
	if in.RoadParallelDiscount <= 0 {
		in.RoadParallelDiscount = defaults.RoadDiscount
	}
	if in.OffRoadPenalty <= 0 {
		in.OffRoadPenalty = defaults.OffRoadPenalty
	}
	if in.RoadBufferM <= 0 {
		in.RoadBufferM = defaults.RoadBufferM
	}
	return in
}

func undergroundCableMultiplier(class domain.VoltageClass) float64 {
	switch class {
	case domain.VoltageClass11kV:
		return 3.2
	case domain.VoltageClass33kV:
		return 3.8
	case domain.VoltageClass66kV:
		return 4.6
	case domain.VoltageClass132kV:
		return 5.4
	case domain.VoltageClass220kV:
		return 6.2
	case domain.VoltageClass400kV:
		return 7.5
	default:
		return 4.5
	}
}

func undergroundJointCost(class domain.VoltageClass) float64 {
	switch class {
	case domain.VoltageClass11kV:
		return 35000
	case domain.VoltageClass33kV:
		return 90000
	case domain.VoltageClass66kV:
		return 180000
	case domain.VoltageClass132kV:
		return 320000
	case domain.VoltageClass220kV:
		return 550000
	case domain.VoltageClass400kV:
		return 900000
	default:
		return 160000
	}
}

func estimateFoundationMultiplier(towers []domain.TowerPosition) float64 {
	if len(towers) == 0 {
		return 1.0
	}
	sum := 0.0
	for _, tower := range towers {
		mult := 1.0
		if tower.HeightM > 35 {
			mult = 1.75
		} else if tower.HeightM > 28 {
			mult = 1.45
		} else if tower.HeightM > 22 {
			mult = 1.2
		}
		sum += mult
	}
	return sum / float64(len(towers))
}

func segmentDistanceByIndex(waypoints []domain.Waypoint, fromIndex int, fallback float64) float64 {
	if fromIndex >= 0 && fromIndex+1 < len(waypoints) {
		return segmentDistance(waypoints[fromIndex], waypoints[fromIndex+1])
	}
	return fallback
}

func computeCostBreakdown(class domain.VoltageClass, waypoints []domain.Waypoint, towers []domain.TowerPosition, rowWidthM float64, baseCrossingPremium float64, segments []domain.SegmentExplanation) (domain.CostBreakdown, float64) {
	defaults := defaultsForVoltageClass(class)
	distanceM := calculatePathDistance(waypoints)

	segmentFallback := 0.0
	if len(segments) > 0 {
		segmentFallback = distanceM / float64(len(segments))
	}

	undergroundDistance := 0.0
	waterCrossingDistance := 0.0
	sensitiveDistance := 0.0
	roadCorridorDistance := 0.0
	for _, segment := range segments {
		d := segmentDistanceByIndex(waypoints, segment.FromIndex, segmentFallback)
		land := strings.ToLower(segment.LandType)
		switch {
		case strings.Contains(land, "underground"):
			undergroundDistance += d
		case strings.Contains(land, "water"):
			waterCrossingDistance += d
		case strings.Contains(land, "sensitive"):
			sensitiveDistance += d
		case strings.Contains(land, "road_corridor"):
			roadCorridorDistance += d
		}
	}

	overheadDistance := math.Max(0, distanceM-undergroundDistance)
	overheadKm := overheadDistance / 1000.0
	undergroundKm := undergroundDistance / 1000.0

	overheadConductorCost := overheadKm * defaults.ConductorCostKm
	undergroundCableCost := undergroundKm * defaults.ConductorCostKm * undergroundCableMultiplier(class)
	jointCount := int(math.Max(0, math.Ceil(undergroundDistance/500.0)-1))
	jointingCost := float64(jointCount) * undergroundJointCost(class)
	conductorCost := overheadConductorCost + undergroundCableCost + jointingCost

	baseTowerCost := float64(len(towers)) * defaults.TowerUnitCost
	foundationMultiplier := estimateFoundationMultiplier(towers)
	foundationCost := baseTowerCost * math.Max(0, foundationMultiplier-1.0)
	towerCost := baseTowerCost + foundationCost

	baseRowCost := distanceM * rowWidthM * defaults.RowCostPerSqM
	environmentalCost := (sensitiveDistance * rowWidthM * defaults.RowCostPerSqM * 0.45) + (waterCrossingDistance * rowWidthM * defaults.RowCostPerSqM * 0.25)
	accessCost := distanceM * defaults.RowCostPerSqM * (0.08 + 0.0005*math.Max(0, float64(len(towers)-1)))
	if roadCorridorDistance > 0 {
		accessCost *= math.Max(0.5, 1.0-(roadCorridorDistance/math.Max(distanceM, 1))*0.35)
	}
	rowCost := baseRowCost + environmentalCost + accessCost

	undergroundCrossingPremium := undergroundDistance * defaults.RowCostPerSqM * 3.0
	waterCrossingPremium := waterCrossingDistance * defaults.RowCostPerSqM * 1.5
	riskBase := baseCrossingPremium + undergroundCrossingPremium + waterCrossingPremium

	riskRatio := 0.0
	if distanceM > 0 {
		riskRatio = (undergroundDistance + waterCrossingDistance + sensitiveDistance) / distanceM
	}
	uncertaintyPct := math.Min(0.35, 0.06+0.20*riskRatio+0.04*math.Min(1.0, float64(jointCount)/6.0))
	uncertaintyContingency := (conductorCost + towerCost + rowCost + riskBase) * uncertaintyPct

	crossingPremium := riskBase + uncertaintyContingency
	total := conductorCost + towerCost + rowCost + crossingPremium
	costPerKm := 0.0
	if distanceM > 0 {
		costPerKm = total / (distanceM / 1000.0)
	}
	return domain.CostBreakdown{
		ConductorCost:      conductorCost,
		TowerCost:          towerCost,
		RowAcquisitionCost: rowCost,
		CrossingPremium:    crossingPremium,
		TotalCost:          total,
		CostPerKm:          costPerKm,
	}, uncertaintyPct
}
