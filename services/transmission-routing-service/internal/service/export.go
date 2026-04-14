package service

import (
	"context"
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"

	"solar3d/transmission-routing-service/internal/domain"
	"solar3d/transmission-routing-service/internal/repository"
)

func (s *TransmissionService) ExportTransmissionRoutePack(ctx context.Context, id uuid.UUID, generatedBy string) (*domain.TransmissionRouteExportPack, error) {
	route, err := s.repo.GetByID(ctx, id)
	if err != nil {
		return nil, err
	}
	if route == nil {
		return nil, repository.ErrNotFound
	}
	if route.ApprovalStatus != domain.ApprovalStatusApproved {
		return nil, fmt.Errorf("%w: only approved routes can be exported", ErrInvalidWorkflowTransition)
	}
	traceability, err := extractTraceability(route.Metadata)
	if err != nil {
		return nil, err
	}
	if err := validateTraceability(route, traceability); err != nil {
		return nil, err
	}
	pack := &domain.TransmissionRouteExportPack{
		Route:               *route,
		TowerSchedule:       buildTowerSchedule(route),
		UndergroundChainage: buildUndergroundChainage(route),
		CostBook:            buildCostBook(route),
		Traceability:        traceability,
		GeneratedAt:         time.Now().UTC(),
		GeneratedBy:         strings.TrimSpace(generatedBy),
	}
	return pack, nil
}

func buildTowerSchedule(route *domain.TransmissionRoute) []domain.TowerScheduleEntry {
	entries := make([]domain.TowerScheduleEntry, 0, len(route.TowerPositions))
	for index, tower := range route.TowerPositions {
		structureType := "suspension"
		if tower.SpanToNextM == 0 {
			structureType = "terminal"
		} else if tower.HeightM >= 30 {
			structureType = "heavy_angle"
		} else if tower.HeightM >= 22 {
			structureType = "angle"
		}
		entries = append(entries, domain.TowerScheduleEntry{
			Sequence:      index + 1,
			Longitude:     tower.Lon,
			Latitude:      tower.Lat,
			Elevation:     tower.Elevation,
			SpanToNextM:   tower.SpanToNextM,
			HeightM:       tower.HeightM,
			StructureType: structureType,
		})
	}
	return entries
}

func buildUndergroundChainage(route *domain.TransmissionRoute) []domain.UndergroundChainageEntry {
	entries := []domain.UndergroundChainageEntry{}
	if len(route.SegmentExplanations) == 0 {
		return entries
	}
	waypoints := pathWaypoints(route.PathGeoJSON)
	chainage := 0.0
	for _, segment := range route.SegmentExplanations {
		segmentLength := 0.0
		if segment.FromIndex >= 0 && segment.FromIndex+1 < len(waypoints) {
			segmentLength = segmentDistance(
				waypoints[segment.FromIndex],
				waypoints[segment.FromIndex+1],
			)
		}
		startChainage := chainage
		endChainage := chainage + segmentLength
		if strings.Contains(strings.ToLower(segment.LandType), "underground") {
			entries = append(entries, domain.UndergroundChainageEntry{
				SegmentIndex:   segment.FromIndex,
				StartChainageM: startChainage,
				EndChainageM:   endChainage,
				LengthM:        segmentLength,
				Reason:         segment.DecisionReason,
			})
		}
		chainage = endChainage
	}
	return entries
}

func pathWaypoints(pathGeoJSON string) []domain.Waypoint {
	var payload struct {
		Coordinates [][]float64 `json:"coordinates"`
	}
	if err := json.Unmarshal([]byte(pathGeoJSON), &payload); err != nil {
		return nil
	}
	waypoints := make([]domain.Waypoint, 0, len(payload.Coordinates))
	for _, coord := range payload.Coordinates {
		if len(coord) < 2 {
			continue
		}
		waypoint := domain.Waypoint{Lon: coord[0], Lat: coord[1]}
		if len(coord) > 2 {
			waypoint.Elevation = coord[2]
		}
		waypoints = append(waypoints, waypoint)
	}
	return waypoints
}

func buildCostBook(route *domain.TransmissionRoute) []domain.CostBookEntry {
	entries := []domain.CostBookEntry{
		{Category: "capex", Subcategory: "conductor", Amount: route.CostBreakdown.ConductorCost, Basis: "enterprise phase-3 conductor and cable model"},
		{Category: "capex", Subcategory: "towers_and_foundations", Amount: route.CostBreakdown.TowerCost, Basis: "tower count and engineered pole heights"},
		{Category: "land", Subcategory: "row_acquisition", Amount: route.CostBreakdown.RowAcquisitionCost, Basis: "distance x ROW width x land-cost factors"},
		{Category: "risk", Subcategory: "crossing_premium", Amount: route.CostBreakdown.CrossingPremium, Basis: "water crossings, underground sections, contingency"},
		{Category: "total", Subcategory: "project_total", Amount: route.CostBreakdown.TotalCost, Basis: "sum of capex, land, and risk allowances"},
	}
	undergroundCount := 0
	for _, segment := range route.SegmentExplanations {
		if strings.Contains(strings.ToLower(segment.LandType), "underground") {
			undergroundCount++
		}
	}
	if undergroundCount > 0 {
		entries = append(entries, domain.CostBookEntry{
			Category:    "delivery",
			Subcategory: "underground_chainage_sections",
			Amount:      float64(undergroundCount),
			Basis:       "count of underground cable sections requiring trench and joint planning",
		})
	}
	return entries
}

