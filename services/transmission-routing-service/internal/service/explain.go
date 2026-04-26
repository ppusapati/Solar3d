package service

import (
	"fmt"
	"strings"

	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/domain"
)

func buildRouteSummary(route *domain.TransmissionRoute) string {
	if route == nil {
		return ""
	}
	parts := []string{
		fmt.Sprintf("Selected %s route over %.1f km", string(route.VoltageClass), route.DistanceM/1000.0),
		fmt.Sprintf("using %d support positions", len(route.TowerPositions)),
		fmt.Sprintf("for a total estimated cost of %.2f", route.CostBreakdown.TotalCost),
	}
	if len(route.SegmentExplanations) > 0 {
		parts = append(parts, route.SegmentExplanations[0].DecisionReason)
	}
	return strings.Join(parts, ", ")
}

