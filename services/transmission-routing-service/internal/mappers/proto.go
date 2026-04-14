package mappers

import (
	"fmt"
	"math"
	"strings"
	"time"

	"github.com/google/uuid"
	transmissionv1 "github.com/solar3d/solar3d/gen/transmission/v1"
	"google.golang.org/protobuf/types/known/timestamppb"

	"solar3d/transmission-routing-service/internal/domain"
)

// buildMinimalElevationRaster creates a minimal elevation raster when none is provided.
// It covers the area between farm and grid injection points.
func buildMinimalElevationRaster(farmPoint, gridPoint *transmissionv1.Waypoint) domain.ElevationRaster {
	const cellSizeM = 100.0 // 100m cells
	const bufferM = 10000.0 // 10km buffer around the route

	farmLon, farmLat := farmPoint.GetLongitude(), farmPoint.GetLatitude()
	gridLon, gridLat := gridPoint.GetLongitude(), gridPoint.GetLatitude()

	// Find bounding box with buffer
	minLon := math.Min(farmLon, gridLon)
	maxLon := math.Max(farmLon, gridLon)
	minLat := math.Min(farmLat, gridLat)
	maxLat := math.Max(farmLat, gridLat)

	// Add buffer in degrees (roughly 1 degree = 111km at equator)
	bufferDeg := bufferM / 111000.0
	minLon -= bufferDeg
	maxLon += bufferDeg
	minLat -= bufferDeg
	maxLat += bufferDeg

	// Calculate grid dimensions
	lonSpanDeg := maxLon - minLon
	latSpanDeg := maxLat - minLat

	// Convert to meters (approximate)
	lonSpanM := lonSpanDeg * 111000.0 * math.Cos(math.Pi*(minLat+maxLat)/360.0)
	latSpanM := latSpanDeg * 111000.0

	width := int(math.Ceil(lonSpanM / cellSizeM))
	height := int(math.Ceil(latSpanM / cellSizeM))

	// Create flat terrain (all zero elevation)
	elevations := make([]float64, width*height)
	for i := range elevations {
		elevations[i] = 0.0
	}

	return domain.ElevationRaster{
		Width:      width,
		Height:     height,
		CellSizeM:  cellSizeM,
		OriginLon:  minLon,
		OriginLat:  minLat,
		Elevations: elevations,
	}
}

func ProtoToCalculateTransmissionRouteRequest(req *transmissionv1.CalculateTransmissionRouteRequest) (*domain.CalculateTransmissionRouteRequest, error) {
	if req == nil {
		return nil, fmt.Errorf("request is required")
	}
	projectID, err := uuid.Parse(req.GetProjectId())
	if err != nil {
		return nil, fmt.Errorf("invalid project_id: %w", err)
	}
	if req.GetFarmOutputPoint() == nil || req.GetGridInjectionPoint() == nil {
		return nil, fmt.Errorf("farm_output_point and grid_injection_point are required")
	}

	// If elevation_raster is not provided, build a minimal one with flat terrain
	var elevationRaster domain.ElevationRaster
	if req.GetElevationRaster() == nil {
		elevationRaster = buildMinimalElevationRaster(req.GetFarmOutputPoint(), req.GetGridInjectionPoint())
	} else {
		elevationRaster = domain.ElevationRaster{
			Width:      int(req.GetElevationRaster().GetWidth()),
			Height:     int(req.GetElevationRaster().GetHeight()),
			CellSizeM:  req.GetElevationRaster().GetCellSizeM(),
			OriginLon:  req.GetElevationRaster().GetOriginLongitude(),
			OriginLat:  req.GetElevationRaster().GetOriginLatitude(),
			Elevations: append([]float64(nil), req.GetElevationRaster().GetElevations()...),
		}
	}

	vectorFeatures := make([]domain.VectorFeature, 0, len(req.GetVectorFeatures()))
	for _, feature := range req.GetVectorFeatures() {
		vectorFeatures = append(vectorFeatures, domain.VectorFeature{
			FeatureType:     strings.ToLower(feature.GetFeatureType()),
			GeometryGeoJSON: feature.GetGeometryGeojson(),
			CostMultiplier:  feature.GetCostMultiplier(),
		})
	}

	out := &domain.CalculateTransmissionRouteRequest{
		ProjectID:          projectID,
		Name:               req.GetName(),
		VoltageClass:       ProtoVoltageClassToDomain(req.GetVoltageClass()),
		FarmOutputPoint:    ProtoWaypointToDomain(req.GetFarmOutputPoint()),
		GridInjectionPoint: ProtoWaypointToDomain(req.GetGridInjectionPoint()),
		Constraints:        ProtoConstraintsToDomain(req.GetConstraints()),
		ElevationRaster:    elevationRaster,
		VectorFeatures:     vectorFeatures,
	}

	if req.GetObstacleRaster() != nil {
		out.ObstacleRaster = &domain.ObstacleRaster{
			Width:     int(req.GetObstacleRaster().GetWidth()),
			Height:    int(req.GetObstacleRaster().GetHeight()),
			CellSizeM: req.GetObstacleRaster().GetCellSizeM(),
			OriginLon: req.GetObstacleRaster().GetOriginLongitude(),
			OriginLat: req.GetObstacleRaster().GetOriginLatitude(),
			Values:    append([]float64(nil), req.GetObstacleRaster().GetValues()...),
		}
	}

	return out, nil
}

func ProtoWaypointToDomain(in *transmissionv1.Waypoint) domain.Waypoint {
	if in == nil {
		return domain.Waypoint{}
	}
	return domain.Waypoint{Lon: in.GetLongitude(), Lat: in.GetLatitude(), Elevation: in.GetElevation()}
}

func ProtoConstraintsToDomain(in *transmissionv1.TransmissionConstraints) domain.TransmissionConstraints {
	if in == nil {
		return domain.TransmissionConstraints{}
	}
	return domain.TransmissionConstraints{
		MinSpanM:              in.GetMinSpanM(),
		MaxSpanM:              in.GetMaxSpanM(),
		RowWidthM:             in.GetRowWidthM(),
		MaxSlopeDeg:           in.GetMaxSlopeDeg(),
		MaxDeflectionDeg:      in.GetMaxDeflectionDeg(),
		SlopePenaltyFactor:    in.GetSlopePenaltyFactor(),
		TurnPenaltyFactor:     in.GetTurnPenaltyFactor(),
		WaterCrossingCostMult: in.GetWaterCrossingCostMult(),
		RoadParallelDiscount:  in.GetRoadParallelDiscount(),
		OffRoadPenalty:        in.GetOffRoadPenalty(),
		RoadBufferM:           in.GetRoadBufferM(),
	}
}

func ProtoVoltageClassToDomain(in transmissionv1.VoltageClass) domain.VoltageClass {
	switch in {
	case transmissionv1.VoltageClass_VOLTAGE_CLASS_11KV:
		return domain.VoltageClass11kV
	case transmissionv1.VoltageClass_VOLTAGE_CLASS_33KV:
		return domain.VoltageClass33kV
	case transmissionv1.VoltageClass_VOLTAGE_CLASS_HT_66KV:
		return domain.VoltageClass66kV
	case transmissionv1.VoltageClass_VOLTAGE_CLASS_HT_132KV:
		return domain.VoltageClass132kV
	case transmissionv1.VoltageClass_VOLTAGE_CLASS_HT_220KV:
		return domain.VoltageClass220kV
	case transmissionv1.VoltageClass_VOLTAGE_CLASS_HT_400KV:
		return domain.VoltageClass400kV
	default:
		return domain.VoltageClass33kV
	}
}

func DomainVoltageClassToProto(in domain.VoltageClass) transmissionv1.VoltageClass {
	switch in {
	case domain.VoltageClass11kV:
		return transmissionv1.VoltageClass_VOLTAGE_CLASS_11KV
	case domain.VoltageClass33kV:
		return transmissionv1.VoltageClass_VOLTAGE_CLASS_33KV
	case domain.VoltageClass66kV:
		return transmissionv1.VoltageClass_VOLTAGE_CLASS_HT_66KV
	case domain.VoltageClass132kV:
		return transmissionv1.VoltageClass_VOLTAGE_CLASS_HT_132KV
	case domain.VoltageClass220kV:
		return transmissionv1.VoltageClass_VOLTAGE_CLASS_HT_220KV
	case domain.VoltageClass400kV:
		return transmissionv1.VoltageClass_VOLTAGE_CLASS_HT_400KV
	default:
		return transmissionv1.VoltageClass_VOLTAGE_CLASS_UNSPECIFIED
	}
}

func DomainApprovalStatusToProto(in domain.ApprovalStatus) transmissionv1.ApprovalStatus {
	switch in {
	case domain.ApprovalStatusDraft:
		return transmissionv1.ApprovalStatus_APPROVAL_STATUS_DRAFT
	case domain.ApprovalStatusEngineeringReview:
		return transmissionv1.ApprovalStatus_APPROVAL_STATUS_ENGINEERING_REVIEW
	case domain.ApprovalStatusApproved:
		return transmissionv1.ApprovalStatus_APPROVAL_STATUS_APPROVED
	default:
		return transmissionv1.ApprovalStatus_APPROVAL_STATUS_UNSPECIFIED
	}
}

func DomainInstallationModeToProto(in domain.InstallationMode) transmissionv1.InstallationMode {
	switch in {
	case domain.InstallationModeUnderground:
		return transmissionv1.InstallationMode_INSTALLATION_MODE_UNDERGROUND
	case domain.InstallationModeOverhead:
		return transmissionv1.InstallationMode_INSTALLATION_MODE_OVERHEAD
	default:
		return transmissionv1.InstallationMode_INSTALLATION_MODE_UNSPECIFIED
	}
}

func RouteToProto(route *domain.TransmissionRoute) *transmissionv1.TransmissionRoute {
	if route == nil {
		return nil
	}
	towers := make([]*transmissionv1.TowerPosition, 0, len(route.TowerPositions))
	for _, tower := range route.TowerPositions {
		towers = append(towers, &transmissionv1.TowerPosition{
			Longitude:   tower.Lon,
			Latitude:    tower.Lat,
			Elevation:   tower.Elevation,
			SpanToNextM: tower.SpanToNextM,
			HeightM:     tower.HeightM,
		})
	}
	segments := make([]*transmissionv1.SegmentExplanation, 0, len(route.SegmentExplanations))
	for _, segment := range route.SegmentExplanations {
		segments = append(segments, &transmissionv1.SegmentExplanation{
			FromIndex:        int32(segment.FromIndex),
			SlopeDeg:         segment.SlopeDeg,
			LandType:         segment.LandType,
			CostMultiplier:   segment.CostMultiplier,
			DecisionReason:   segment.DecisionReason,
			InstallationMode: DomainInstallationModeToProto(segment.InstallationMode),
		})
	}
	governanceEvents := make([]*transmissionv1.GovernanceEvent, 0, len(route.GovernanceEvents))
	for _, event := range route.GovernanceEvents {
		governanceEvents = append(governanceEvents, GovernanceEventToProto(event))
	}
	return &transmissionv1.TransmissionRoute{
		Id:                 route.ID.String(),
		ProjectId:          route.ProjectID.String(),
		Name:               route.Name,
		VoltageClass:       DomainVoltageClassToProto(route.VoltageClass),
		PathGeojson:        route.PathGeoJSON,
		FarmOutputPoint:    WaypointToProto(route.FarmOutputPoint),
		GridInjectionPoint: WaypointToProto(route.GridInjectionPoint),
		TowerPositions:     towers,
		DistanceM:          route.DistanceM,
		CostBreakdown: &transmissionv1.CostBreakdown{
			ConductorCost:      route.CostBreakdown.ConductorCost,
			TowerCost:          route.CostBreakdown.TowerCost,
			RowAcquisitionCost: route.CostBreakdown.RowAcquisitionCost,
			CrossingPremium:    route.CostBreakdown.CrossingPremium,
			TotalCost:          route.CostBreakdown.TotalCost,
			CostPerKm:          route.CostBreakdown.CostPerKm,
		},
		RouteScore:            RouteScoreToProto(route.RouteScore),
		ApprovalStatus:        DomainApprovalStatusToProto(route.ApprovalStatus),
		EngineeringReviewedAt: timePtrToProto(route.EngineeringReviewedAt),
		EngineeringReviewedBy: route.EngineeringReviewedBy,
		ApprovedAt:            timePtrToProto(route.ApprovedAt),
		ApprovedBy:            route.ApprovedBy,
		GovernanceEvents:      governanceEvents,
		SegmentExplanations:   segments,
		RouteSummary:          route.RouteSummary,
		CreatedAt:             timestamppb.New(route.CreatedAt),
	}
}

func RouteScoreToProto(score *domain.RouteScore) *transmissionv1.RouteScore {
	if score == nil {
		return nil
	}
	dimensionReasons := map[string]string{}
	for key, value := range score.DimensionReasons {
		dimensionReasons[key] = value
	}
	return &transmissionv1.RouteScore{
		CostScore:             score.CostScore,
		RiskScore:             score.RiskScore,
		ConstructabilityScore: score.ConstructabilityScore,
		ScheduleScore:         score.ScheduleScore,
		CompositeScore:        score.CompositeScore,
		ParetoFrontier:        score.ParetoFrontier,
		RecommendationReason:  score.RecommendationReason,
		DimensionReasons:      dimensionReasons,
	}
}

func GovernanceEventToProto(event domain.GovernanceEvent) *transmissionv1.GovernanceEvent {
	return &transmissionv1.GovernanceEvent{
		EventType:  event.EventType,
		Actor:      event.Actor,
		Note:       event.Note,
		FromStatus: DomainApprovalStatusToProto(event.FromStatus),
		ToStatus:   DomainApprovalStatusToProto(event.ToStatus),
		OccurredAt: timestamppb.New(event.OccurredAt),
	}
}

func TraceabilityBundleToProto(traceability domain.TraceabilityBundle) *transmissionv1.TraceabilityBundle {
	return &transmissionv1.TraceabilityBundle{
		AlgorithmVersion:    traceability.AlgorithmVersion,
		InputFingerprint:    traceability.InputFingerprint,
		RouteFingerprint:    traceability.RouteFingerprint,
		RegressionSignature: traceability.RegressionSignature,
		RequestSnapshotJson: traceability.RequestSnapshotJSON,
		DataSnapshotId:      traceability.DataSnapshotID,
		ApprovedAt:          timePtrToProto(optionalTime(traceability.ApprovedAt)),
		ApprovedBy:          traceability.ApprovedBy,
	}
}

func ExportPackToProto(pack *domain.TransmissionRouteExportPack) *transmissionv1.TransmissionRouteExportPack {
	if pack == nil {
		return nil
	}
	towerSchedule := make([]*transmissionv1.TowerScheduleEntry, 0, len(pack.TowerSchedule))
	for _, entry := range pack.TowerSchedule {
		towerSchedule = append(towerSchedule, &transmissionv1.TowerScheduleEntry{
			Sequence:      int32(entry.Sequence),
			Longitude:     entry.Longitude,
			Latitude:      entry.Latitude,
			Elevation:     entry.Elevation,
			SpanToNextM:   entry.SpanToNextM,
			HeightM:       entry.HeightM,
			StructureType: entry.StructureType,
		})
	}
	undergroundChainage := make([]*transmissionv1.UndergroundChainageEntry, 0, len(pack.UndergroundChainage))
	for _, entry := range pack.UndergroundChainage {
		undergroundChainage = append(undergroundChainage, &transmissionv1.UndergroundChainageEntry{
			SegmentIndex:   int32(entry.SegmentIndex),
			StartChainageM: entry.StartChainageM,
			EndChainageM:   entry.EndChainageM,
			LengthM:        entry.LengthM,
			Reason:         entry.Reason,
		})
	}
	costBook := make([]*transmissionv1.CostBookEntry, 0, len(pack.CostBook))
	for _, entry := range pack.CostBook {
		costBook = append(costBook, &transmissionv1.CostBookEntry{
			Category:    entry.Category,
			Subcategory: entry.Subcategory,
			Amount:      entry.Amount,
			Basis:       entry.Basis,
		})
	}
	return &transmissionv1.TransmissionRouteExportPack{
		Route:               RouteToProto(&pack.Route),
		TowerSchedule:       towerSchedule,
		UndergroundChainage: undergroundChainage,
		CostBook:            costBook,
		Traceability:        TraceabilityBundleToProto(pack.Traceability),
		GeneratedAt:         timestamppb.New(pack.GeneratedAt),
		GeneratedBy:         pack.GeneratedBy,
	}
}

func timePtrToProto(value *time.Time) *timestamppb.Timestamp {
	if value == nil || value.IsZero() {
		return nil
	}
	return timestamppb.New(*value)
}

func optionalTime(value time.Time) *time.Time {
	if value.IsZero() {
		return nil
	}
	copyValue := value
	return &copyValue
}

func ProgressUpdateToProto(update *domain.ProgressUpdate) *transmissionv1.StreamTransmissionRouteResponse {
	if update == nil {
		return &transmissionv1.StreamTransmissionRouteResponse{}
	}
	return &transmissionv1.StreamTransmissionRouteResponse{
		Phase:           update.Phase,
		PercentComplete: update.PercentComplete,
		Message:         update.Message,
		Route:           RouteToProto(update.Route),
	}
}

func WaypointToProto(in domain.Waypoint) *transmissionv1.Waypoint {
	return &transmissionv1.Waypoint{Longitude: in.Lon, Latitude: in.Lat, Elevation: in.Elevation}
}
