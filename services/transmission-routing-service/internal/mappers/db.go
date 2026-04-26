package mappers

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"

	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/db"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/domain"
)

func DomainCreateParams(route *domain.TransmissionRoute) (db.CreateTransmissionRouteParams, error) {
	towers, err := json.Marshal(route.TowerPositions)
	if err != nil {
		return db.CreateTransmissionRouteParams{}, fmt.Errorf("marshal tower positions: %w", err)
	}
	segments, err := json.Marshal(route.SegmentExplanations)
	if err != nil {
		return db.CreateTransmissionRouteParams{}, fmt.Errorf("marshal segment explanations: %w", err)
	}
	routeScore, err := json.Marshal(route.RouteScore)
	if err != nil {
		return db.CreateTransmissionRouteParams{}, fmt.Errorf("marshal route score: %w", err)
	}
	governanceEvents, err := json.Marshal(route.GovernanceEvents)
	if err != nil {
		return db.CreateTransmissionRouteParams{}, fmt.Errorf("marshal governance events: %w", err)
	}
	metadata, err := json.Marshal(route.Metadata)
	if err != nil {
		return db.CreateTransmissionRouteParams{}, fmt.Errorf("marshal route metadata: %w", err)
	}
	engineeringReviewedAt := pgtype.Timestamptz{}
	if route.EngineeringReviewedAt != nil {
		engineeringReviewedAt = pgtype.Timestamptz{Time: *route.EngineeringReviewedAt, Valid: true}
	}
	approvedAt := pgtype.Timestamptz{}
	if route.ApprovedAt != nil {
		approvedAt = pgtype.Timestamptz{Time: *route.ApprovedAt, Valid: true}
	}
	approvalStatus := route.ApprovalStatus
	if approvalStatus == "" {
		approvalStatus = domain.ApprovalStatusDraft
	}
	return db.CreateTransmissionRouteParams{
		ID:                    uuidToPG(route.ID),
		ProjectID:             uuidToPG(route.ProjectID),
		Name:                  route.Name,
		VoltageClass:          string(route.VoltageClass),
		FarmOutputGeojson:     waypointToGeoJSON(route.FarmOutputPoint),
		GridInjectionGeojson:  waypointToGeoJSON(route.GridInjectionPoint),
		PathGeojson:           route.PathGeoJSON,
		TowerPositions:        towers,
		DistanceM:             route.DistanceM,
		ConductorCost:         route.CostBreakdown.ConductorCost,
		TowerCost:             route.CostBreakdown.TowerCost,
		RowAcquisitionCost:    route.CostBreakdown.RowAcquisitionCost,
		CrossingPremium:       route.CostBreakdown.CrossingPremium,
		TotalCost:             route.CostBreakdown.TotalCost,
		CostPerKm:             route.CostBreakdown.CostPerKm,
		SegmentExplanations:   segments,
		RouteScore:            routeScore,
		ApprovalStatus:        string(approvalStatus),
		EngineeringReviewedAt: engineeringReviewedAt,
		EngineeringReviewedBy: route.EngineeringReviewedBy,
		ApprovedAt:            approvedAt,
		ApprovedBy:            route.ApprovedBy,
		GovernanceEvents:      governanceEvents,
		Metadata:              metadata,
		RouteSummary:          route.RouteSummary,
	}, nil
}

func CreateTransmissionRouteRowToDomain(row db.CreateTransmissionRouteRow) (*domain.TransmissionRoute, error) {
	return rowToDomain(
		row.ID,
		row.ProjectID,
		row.Name,
		row.VoltageClass,
		row.FarmOutputGeojson,
		row.GridInjectionGeojson,
		row.PathGeojson,
		row.TowerPositionsJson,
		row.DistanceM,
		row.ConductorCost,
		row.TowerCost,
		row.RowAcquisitionCost,
		row.CrossingPremium,
		row.TotalCost,
		row.CostPerKm,
		row.SegmentExplanationsJson,
		row.RouteScoreJson,
		row.ApprovalStatus,
		row.EngineeringReviewedAt,
		row.EngineeringReviewedBy,
		row.ApprovedAt,
		row.ApprovedBy,
		row.GovernanceEventsJson,
		row.MetadataJson,
		row.RouteSummary,
		row.CreatedAt,
	)
}

func GetTransmissionRouteRowToDomain(row db.GetTransmissionRouteRow) (*domain.TransmissionRoute, error) {
	return rowToDomain(
		row.ID,
		row.ProjectID,
		row.Name,
		row.VoltageClass,
		row.FarmOutputGeojson,
		row.GridInjectionGeojson,
		row.PathGeojson,
		row.TowerPositionsJson,
		row.DistanceM,
		row.ConductorCost,
		row.TowerCost,
		row.RowAcquisitionCost,
		row.CrossingPremium,
		row.TotalCost,
		row.CostPerKm,
		row.SegmentExplanationsJson,
		row.RouteScoreJson,
		row.ApprovalStatus,
		row.EngineeringReviewedAt,
		row.EngineeringReviewedBy,
		row.ApprovedAt,
		row.ApprovedBy,
		row.GovernanceEventsJson,
		row.MetadataJson,
		row.RouteSummary,
		row.CreatedAt,
	)
}

func ListTransmissionRouteRowToDomain(row db.ListTransmissionRoutesRow) (*domain.TransmissionRoute, error) {
	return rowToDomain(
		row.ID,
		row.ProjectID,
		row.Name,
		row.VoltageClass,
		row.FarmOutputGeojson,
		row.GridInjectionGeojson,
		row.PathGeojson,
		row.TowerPositionsJson,
		row.DistanceM,
		row.ConductorCost,
		row.TowerCost,
		row.RowAcquisitionCost,
		row.CrossingPremium,
		row.TotalCost,
		row.CostPerKm,
		row.SegmentExplanationsJson,
		row.RouteScoreJson,
		row.ApprovalStatus,
		row.EngineeringReviewedAt,
		row.EngineeringReviewedBy,
		row.ApprovedAt,
		row.ApprovedBy,
		row.GovernanceEventsJson,
		row.MetadataJson,
		row.RouteSummary,
		row.CreatedAt,
	)
}

func SubmitTransmissionRouteForReviewRowToDomain(row db.SubmitTransmissionRouteForReviewRow) (*domain.TransmissionRoute, error) {
	return rowToDomain(
		row.ID,
		row.ProjectID,
		row.Name,
		row.VoltageClass,
		row.FarmOutputGeojson,
		row.GridInjectionGeojson,
		row.PathGeojson,
		row.TowerPositionsJson,
		row.DistanceM,
		row.ConductorCost,
		row.TowerCost,
		row.RowAcquisitionCost,
		row.CrossingPremium,
		row.TotalCost,
		row.CostPerKm,
		row.SegmentExplanationsJson,
		row.RouteScoreJson,
		row.ApprovalStatus,
		row.EngineeringReviewedAt,
		row.EngineeringReviewedBy,
		row.ApprovedAt,
		row.ApprovedBy,
		row.GovernanceEventsJson,
		row.MetadataJson,
		row.RouteSummary,
		row.CreatedAt,
	)
}

func ApproveTransmissionRouteRowToDomain(row db.ApproveTransmissionRouteRow) (*domain.TransmissionRoute, error) {
	return rowToDomain(
		row.ID,
		row.ProjectID,
		row.Name,
		row.VoltageClass,
		row.FarmOutputGeojson,
		row.GridInjectionGeojson,
		row.PathGeojson,
		row.TowerPositionsJson,
		row.DistanceM,
		row.ConductorCost,
		row.TowerCost,
		row.RowAcquisitionCost,
		row.CrossingPremium,
		row.TotalCost,
		row.CostPerKm,
		row.SegmentExplanationsJson,
		row.RouteScoreJson,
		row.ApprovalStatus,
		row.EngineeringReviewedAt,
		row.EngineeringReviewedBy,
		row.ApprovedAt,
		row.ApprovedBy,
		row.GovernanceEventsJson,
		row.MetadataJson,
		row.RouteSummary,
		row.CreatedAt,
	)
}

func RejectTransmissionRouteRowToDomain(row db.RejectTransmissionRouteRow) (*domain.TransmissionRoute, error) {
	return rowToDomain(
		row.ID,
		row.ProjectID,
		row.Name,
		row.VoltageClass,
		row.FarmOutputGeojson,
		row.GridInjectionGeojson,
		row.PathGeojson,
		row.TowerPositionsJson,
		row.DistanceM,
		row.ConductorCost,
		row.TowerCost,
		row.RowAcquisitionCost,
		row.CrossingPremium,
		row.TotalCost,
		row.CostPerKm,
		row.SegmentExplanationsJson,
		row.RouteScoreJson,
		row.ApprovalStatus,
		row.EngineeringReviewedAt,
		row.EngineeringReviewedBy,
		row.ApprovedAt,
		row.ApprovedBy,
		row.GovernanceEventsJson,
		row.MetadataJson,
		row.RouteSummary,
		row.CreatedAt,
	)
}

func rowToDomain(
	id string,
	projectID pgtype.UUID,
	name string,
	voltageClass string,
	farmOutputGeojson string,
	gridInjectionGeojson string,
	pathGeojson string,
	towerPositionsJSON string,
	distanceM float64,
	conductorCost float64,
	towerCost float64,
	rowAcquisitionCost float64,
	crossingPremium float64,
	totalCost float64,
	costPerKm float64,
	segmentExplanationsJSON string,
	routeScoreJSON string,
	approvalStatus string,
	engineeringReviewedAt pgtype.Timestamptz,
	engineeringReviewedBy string,
	approvedAt pgtype.Timestamptz,
	approvedBy string,
	governanceEventsJSON string,
	metadataJSON string,
	routeSummary string,
	createdAt pgtype.Timestamptz,
) (*domain.TransmissionRoute, error) {
	parsedID, err := uuid.Parse(id)
	if err != nil {
		return nil, fmt.Errorf("parse route id: %w", err)
	}
	if !projectID.Valid {
		return nil, fmt.Errorf("parse project id: invalid uuid")
	}
	projectUUID := uuid.UUID(projectID.Bytes)
	var towers []domain.TowerPosition
	if towerPositionsJSON != "" {
		if err := json.Unmarshal([]byte(towerPositionsJSON), &towers); err != nil {
			return nil, fmt.Errorf("unmarshal tower positions: %w", err)
		}
	}
	var segments []domain.SegmentExplanation
	if segmentExplanationsJSON != "" {
		if err := json.Unmarshal([]byte(segmentExplanationsJSON), &segments); err != nil {
			return nil, fmt.Errorf("unmarshal segment explanations: %w", err)
		}
	}
	var routeScore *domain.RouteScore
	if routeScoreJSON != "" && routeScoreJSON != "null" && routeScoreJSON != "{}" {
		var parsed domain.RouteScore
		if err := json.Unmarshal([]byte(routeScoreJSON), &parsed); err != nil {
			return nil, fmt.Errorf("unmarshal route score: %w", err)
		}
		routeScore = &parsed
	}
	var governanceEvents []domain.GovernanceEvent
	if governanceEventsJSON != "" && governanceEventsJSON != "null" && governanceEventsJSON != "[]" {
		if err := json.Unmarshal([]byte(governanceEventsJSON), &governanceEvents); err != nil {
			return nil, fmt.Errorf("unmarshal governance events: %w", err)
		}
	}
	var metadata map[string]interface{}
	if metadataJSON != "" && metadataJSON != "null" && metadataJSON != "{}" {
		if err := json.Unmarshal([]byte(metadataJSON), &metadata); err != nil {
			return nil, fmt.Errorf("unmarshal route metadata: %w", err)
		}
	}
	resolvedCreatedAt := time.Now().UTC()
	if createdAt.Valid {
		resolvedCreatedAt = createdAt.Time
	}
	var resolvedEngineeringReviewedAt *time.Time
	if engineeringReviewedAt.Valid {
		value := engineeringReviewedAt.Time
		resolvedEngineeringReviewedAt = &value
	}
	var resolvedApprovedAt *time.Time
	if approvedAt.Valid {
		value := approvedAt.Time
		resolvedApprovedAt = &value
	}
	return &domain.TransmissionRoute{
		ID:                 parsedID,
		ProjectID:          projectUUID,
		Name:               name,
		VoltageClass:       domain.VoltageClass(voltageClass),
		FarmOutputPoint:    geoJSONToWaypoint(farmOutputGeojson),
		GridInjectionPoint: geoJSONToWaypoint(gridInjectionGeojson),
		PathGeoJSON:        pathGeojson,
		TowerPositions:     towers,
		DistanceM:          distanceM,
		CostBreakdown: domain.CostBreakdown{
			ConductorCost:      conductorCost,
			TowerCost:          towerCost,
			RowAcquisitionCost: rowAcquisitionCost,
			CrossingPremium:    crossingPremium,
			TotalCost:          totalCost,
			CostPerKm:          costPerKm,
		},
		RouteScore:            routeScore,
		ApprovalStatus:        domain.ApprovalStatus(approvalStatus),
		EngineeringReviewedAt: resolvedEngineeringReviewedAt,
		EngineeringReviewedBy: engineeringReviewedBy,
		ApprovedAt:            resolvedApprovedAt,
		ApprovedBy:            approvedBy,
		GovernanceEvents:      governanceEvents,
		SegmentExplanations:   segments,
		RouteSummary:          routeSummary,
		CreatedAt:             resolvedCreatedAt,
		Metadata:              metadata,
	}, nil
}

func uuidToPG(id uuid.UUID) pgtype.UUID {
	return pgtype.UUID{Bytes: id, Valid: true}
}
func waypointToGeoJSON(point domain.Waypoint) string {
	payload, _ := json.Marshal(map[string]interface{}{
		"type":        "Point",
		"coordinates": []float64{point.Lon, point.Lat, point.Elevation},
	})
	return string(payload)
}

func geoJSONToWaypoint(raw string) domain.Waypoint {
	var payload struct {
		Coordinates []float64 `json:"coordinates"`
	}
	if err := json.Unmarshal([]byte(raw), &payload); err != nil || len(payload.Coordinates) < 2 {
		return domain.Waypoint{}
	}
	waypoint := domain.Waypoint{Lon: payload.Coordinates[0], Lat: payload.Coordinates[1]}
	if len(payload.Coordinates) > 2 {
		waypoint.Elevation = payload.Coordinates[2]
	}
	return waypoint
}

