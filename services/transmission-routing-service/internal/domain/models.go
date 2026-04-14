package domain

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

// ========== Review Metadata ==========

// ReviewMetadata captures acceptance/approval workflow state.
type ReviewMetadata struct {
	Status                    string     `json:"status"` // AcceptanceStatus enum value
	ReviewedByActorID         string     `json:"reviewed_by_actor_id,omitempty"`
	ReviewedAt                *time.Time `json:"reviewed_at,omitempty"`
	QualityScore              float64    `json:"quality_score"` // [0, 1]
	ReviewComments            []string   `json:"review_comments,omitempty"`
	Blockers                  []string   `json:"blockers,omitempty"` // Empty if approved
	ApprovalTimestampUnixSecs string     `json:"approval_timestamp_unix_secs,omitempty"`
}

// ========== Voltage and Installation Enums ==========

// VoltageClass represents a nominal transmission voltage tier.
type VoltageClass string

const (
	VoltageClass11kV  VoltageClass = "11kv"
	VoltageClass33kV  VoltageClass = "33kv"
	VoltageClass66kV  VoltageClass = "ht_66kv"
	VoltageClass132kV VoltageClass = "ht_132kv"
	VoltageClass220kV VoltageClass = "ht_220kv"
	VoltageClass400kV VoltageClass = "ht_400kv"
)

type Waypoint struct {
	Lon       float64 `json:"lon"`
	Lat       float64 `json:"lat"`
	Elevation float64 `json:"elevation"`
}

type TransmissionConstraints struct {
	MinSpanM              float64 `json:"min_span_m"`
	MaxSpanM              float64 `json:"max_span_m"`
	RowWidthM             float64 `json:"row_width_m"`
	MaxSlopeDeg           float64 `json:"max_slope_deg"`
	MaxDeflectionDeg      float64 `json:"max_deflection_deg"`
	SlopePenaltyFactor    float64 `json:"slope_penalty_factor"`
	TurnPenaltyFactor     float64 `json:"turn_penalty_factor"`
	WaterCrossingCostMult float64 `json:"water_crossing_cost_mult"`
	RoadParallelDiscount  float64 `json:"road_parallel_discount"`
	OffRoadPenalty        float64 `json:"off_road_penalty"`
	RoadBufferM           float64 `json:"road_buffer_m"`
}

type ElevationRaster struct {
	Width      int       `json:"width"`
	Height     int       `json:"height"`
	CellSizeM  float64   `json:"cell_size_m"`
	OriginLon  float64   `json:"origin_lon"`
	OriginLat  float64   `json:"origin_lat"`
	Elevations []float64 `json:"elevations"`
}

type ObstacleRaster struct {
	Width     int       `json:"width"`
	Height    int       `json:"height"`
	CellSizeM float64   `json:"cell_size_m"`
	OriginLon float64   `json:"origin_lon"`
	OriginLat float64   `json:"origin_lat"`
	Values    []float64 `json:"values"`
}

type VectorFeature struct {
	FeatureType     string  `json:"feature_type"`
	GeometryGeoJSON string  `json:"geometry_geojson"`
	CostMultiplier  float64 `json:"cost_multiplier"`
}

type TowerPosition struct {
	Lon         float64 `json:"lon"`
	Lat         float64 `json:"lat"`
	Elevation   float64 `json:"elevation"`
	SpanToNextM float64 `json:"span_to_next_m"`
	HeightM     float64 `json:"height_m,omitempty"`
}

type InstallationMode string

const (
	InstallationModeOverhead    InstallationMode = "overhead"
	InstallationModeUnderground InstallationMode = "underground"
)

type SegmentExplanation struct {
	FromIndex        int              `json:"from_index"`
	SlopeDeg         float64          `json:"slope_deg"`
	LandType         string           `json:"land_type"`
	CostMultiplier   float64          `json:"cost_multiplier"`
	DecisionReason   string           `json:"decision_reason"`
	InstallationMode InstallationMode `json:"installation_mode,omitempty"`
}

type CostBreakdown struct {
	ConductorCost      float64 `json:"conductor_cost"`
	TowerCost          float64 `json:"tower_cost"`
	RowAcquisitionCost float64 `json:"row_acquisition_cost"`
	CrossingPremium    float64 `json:"crossing_premium"`
	TotalCost          float64 `json:"total_cost"`
	CostPerKm          float64 `json:"cost_per_km"`
}

type ApprovalStatus string

const (
	ApprovalStatusDraft             ApprovalStatus = "draft"
	ApprovalStatusEngineeringReview ApprovalStatus = "engineering_review"
	ApprovalStatusApproved          ApprovalStatus = "approved"
)

type GovernanceEvent struct {
	EventType  string         `json:"event_type"`
	Actor      string         `json:"actor"`
	Note       string         `json:"note,omitempty"`
	FromStatus ApprovalStatus `json:"from_status"`
	ToStatus   ApprovalStatus `json:"to_status"`
	OccurredAt time.Time      `json:"occurred_at"`
}

type TraceabilityBundle struct {
	AlgorithmVersion    string    `json:"algorithm_version"`
	InputFingerprint    string    `json:"input_fingerprint"`
	RouteFingerprint    string    `json:"route_fingerprint"`
	RegressionSignature string    `json:"regression_signature"`
	RequestSnapshotJSON string    `json:"request_snapshot_json,omitempty"`
	DataSnapshotID      string    `json:"data_snapshot_id,omitempty"`
	ApprovedAt          time.Time `json:"approved_at,omitempty"`
	ApprovedBy          string    `json:"approved_by,omitempty"`
}

type TowerScheduleEntry struct {
	Sequence      int     `json:"sequence"`
	Longitude     float64 `json:"longitude"`
	Latitude      float64 `json:"latitude"`
	Elevation     float64 `json:"elevation"`
	SpanToNextM   float64 `json:"span_to_next_m"`
	HeightM       float64 `json:"height_m"`
	StructureType string  `json:"structure_type"`
}

type UndergroundChainageEntry struct {
	SegmentIndex   int     `json:"segment_index"`
	StartChainageM float64 `json:"start_chainage_m"`
	EndChainageM   float64 `json:"end_chainage_m"`
	LengthM        float64 `json:"length_m"`
	Reason         string  `json:"reason"`
}

type CostBookEntry struct {
	Category    string  `json:"category"`
	Subcategory string  `json:"subcategory"`
	Amount      float64 `json:"amount"`
	Basis       string  `json:"basis"`
}

type TransmissionRouteExportPack struct {
	Route               TransmissionRoute          `json:"route"`
	TowerSchedule       []TowerScheduleEntry       `json:"tower_schedule"`
	UndergroundChainage []UndergroundChainageEntry `json:"underground_chainage"`
	CostBook            []CostBookEntry            `json:"cost_book"`
	Traceability        TraceabilityBundle         `json:"traceability"`
	GeneratedAt         time.Time                  `json:"generated_at"`
	GeneratedBy         string                     `json:"generated_by,omitempty"`
}

type TransmissionRoute struct {
	ID                    uuid.UUID              `json:"id"`
	ProjectID             uuid.UUID              `json:"project_id"`
	ElectricalNetworkID   uuid.UUID              `json:"electrical_network_id,omitempty"`
	Name                  string                 `json:"name"`
	VoltageClass          VoltageClass           `json:"voltage_class"`
	FarmOutputPoint       Waypoint               `json:"farm_output_point"`
	GridInjectionPoint    Waypoint               `json:"grid_injection_point"`
	PathGeoJSON           string                 `json:"path_geojson"`
	TowerPositions        []TowerPosition        `json:"tower_positions"`
	DistanceM             float64                `json:"distance_m"`
	CostBreakdown         CostBreakdown          `json:"cost_breakdown"`
	RouteScore            *RouteScore            `json:"route_score,omitempty"`
	ApprovalStatus        ApprovalStatus         `json:"approval_status"`
	ReviewMetadata        *ReviewMetadata        `json:"review_metadata,omitempty"`
	ProtectionDevices     []string               `json:"protection_devices,omitempty"`
	FaultIsolationPoints  int                    `json:"fault_isolation_points,omitempty"`
	RouteConflicts        []string               `json:"route_conflicts,omitempty"`         // Empty if no conflicts
	RouteFeasibilityScore float64                `json:"route_feasibility_score,omitempty"` // [0, 1]
	EngineeringReviewedAt *time.Time             `json:"engineering_reviewed_at,omitempty"`
	EngineeringReviewedBy string                 `json:"engineering_reviewed_by,omitempty"`
	ApprovedAt            *time.Time             `json:"approved_at,omitempty"`
	ApprovedBy            string                 `json:"approved_by,omitempty"`
	GovernanceEvents      []GovernanceEvent      `json:"governance_events,omitempty"`
	SegmentExplanations   []SegmentExplanation   `json:"segment_explanations"`
	RouteSummary          string                 `json:"route_summary"`
	CreatedAt             time.Time              `json:"created_at"`
	Metadata              map[string]interface{} `json:"metadata,omitempty"`
}

type CalculateTransmissionRouteRequest struct {
	ProjectID          uuid.UUID               `json:"project_id"`
	Name               string                  `json:"name"`
	VoltageClass       VoltageClass            `json:"voltage_class"`
	FarmOutputPoint    Waypoint                `json:"farm_output_point"`
	GridInjectionPoint Waypoint                `json:"grid_injection_point"`
	Constraints        TransmissionConstraints `json:"constraints"`
	ElevationRaster    ElevationRaster         `json:"elevation_raster"`
	ObstacleRaster     *ObstacleRaster         `json:"obstacle_raster,omitempty"`
	VectorFeatures     []VectorFeature         `json:"vector_features,omitempty"`
}

type ProgressUpdate struct {
	Phase           string             `json:"phase"`
	PercentComplete int32              `json:"percent_complete"`
	Message         string             `json:"message"`
	Route           *TransmissionRoute `json:"route,omitempty"`
}

// RouteScore holds the multi-objective decision intelligence scoring for a route.
// All dimension scores are in [0.0, 1.0] where 1.0 is best.
// Stored in TransmissionRoute.Metadata["route_score"].
type RouteScore struct {
	// CostScore measures cost efficiency vs voltage-class baseline cost/km.
	CostScore float64 `json:"cost_score"`
	// RiskScore measures construction + regulatory risk (crossings, underground ratio, sensitive land).
	RiskScore float64 `json:"risk_score"`
	// ConstructabilityScore measures physical buildability (tower heights, slope, deflections).
	ConstructabilityScore float64 `json:"constructability_score"`
	// ScheduleScore measures expected construction schedule impact (tower count, underground length).
	ScheduleScore float64 `json:"schedule_score"`
	// CompositeScore is a weighted aggregate: cost 35% + risk 30% + constructability 20% + schedule 15%.
	CompositeScore float64 `json:"composite_score"`
	// ParetoFrontier is true when no other simultaneously-considered route dominates this one.
	ParetoFrontier bool `json:"pareto_frontier"`
	// RecommendationReason is one or two sentences explaining why this route was scored this way.
	RecommendationReason string `json:"recommendation_reason"`
	// DimensionReasons provides a per-dimension explanation for the score.
	DimensionReasons map[string]string `json:"dimension_reasons,omitempty"`
}

// DataSourceSnapshot records which data sources were used to compute a route.
// Stored in TransmissionRoute.Metadata["data_source_snapshot"] for reproducibility.
type DataSourceSnapshot struct {
	SnapshotID             string    `json:"snapshot_id"`
	SnapshotAt             time.Time `json:"snapshot_at"`
	DEMSource              string    `json:"dem_source"`
	DEMCellSizeM           float64   `json:"dem_cell_size_m"`
	DEMAutoFetched         bool      `json:"dem_auto_fetched"`
	VectorFeatureCount     int       `json:"vector_feature_count"`
	NoGoZoneCount          int       `json:"no_go_zone_count"`
	PreferredCorridorCount int       `json:"preferred_corridor_count"`
	ProtectedAreaCount     int       `json:"protected_area_count"`
}

func (r TransmissionRoute) MarshalMetadata() json.RawMessage {
	if len(r.Metadata) == 0 {
		return nil
	}
	payload, _ := json.Marshal(r.Metadata)
	return payload
}

func (r TransmissionRoute) MarshalGovernanceEvents() ([]byte, error) {
	if len(r.GovernanceEvents) == 0 {
		return []byte("[]"), nil
	}
	return json.Marshal(r.GovernanceEvents)
}
