package domain

import (
	"encoding/json"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"
)

// ========== Acceptance Status Enum ==========

// AcceptanceStatus represents the review/approval status of a layout.
type AcceptanceStatus int

const (
	AcceptanceStatusUnspecified AcceptanceStatus = iota
	AcceptanceStatusDraft
	AcceptanceStatusReviewPending
	AcceptanceStatusApproved
	AcceptanceStatusRejected
)

// String returns the human-readable status name.
func (as AcceptanceStatus) String() string {
	return map[AcceptanceStatus]string{
		AcceptanceStatusUnspecified:   "UNSPECIFIED",
		AcceptanceStatusDraft:         "DRAFT",
		AcceptanceStatusReviewPending: "REVIEW_PENDING",
		AcceptanceStatusApproved:      "APPROVED",
		AcceptanceStatusRejected:      "REJECTED",
	}[as]
}

func acceptanceStatusFromString(value string) (AcceptanceStatus, bool) {
	switch strings.ToUpper(strings.TrimSpace(value)) {
	case "UNSPECIFIED", "":
		return AcceptanceStatusUnspecified, true
	case "DRAFT":
		return AcceptanceStatusDraft, true
	case "REVIEW_PENDING":
		return AcceptanceStatusReviewPending, true
	case "APPROVED":
		return AcceptanceStatusApproved, true
	case "REJECTED":
		return AcceptanceStatusRejected, true
	default:
		return AcceptanceStatusUnspecified, false
	}
}

// MarshalJSON emits canonical string enum values for compatibility with persisted JSONB metadata.
func (as AcceptanceStatus) MarshalJSON() ([]byte, error) {
	return json.Marshal(as.String())
}

// UnmarshalJSON accepts both string and numeric enum forms for backward compatibility.
func (as *AcceptanceStatus) UnmarshalJSON(data []byte) error {
	var asString string
	if err := json.Unmarshal(data, &asString); err == nil {
		parsed, ok := acceptanceStatusFromString(asString)
		if !ok {
			return fmt.Errorf("invalid acceptance status: %q", asString)
		}
		*as = parsed
		return nil
	}

	var asNumber int
	if err := json.Unmarshal(data, &asNumber); err == nil {
		if asNumber < int(AcceptanceStatusUnspecified) || asNumber > int(AcceptanceStatusRejected) {
			return fmt.Errorf("invalid acceptance status value: %d", asNumber)
		}
		*as = AcceptanceStatus(asNumber)
		return nil
	}

	return fmt.Errorf("invalid acceptance status payload: %s", strings.TrimSpace(string(data)))
}

// ReviewMetadata captures acceptance/approval workflow state.
type ReviewMetadata struct {
	Status                    AcceptanceStatus `json:"status"`
	ReviewedByActorID         string           `json:"reviewed_by_actor_id,omitempty"`
	ReviewedAt                *time.Time       `json:"reviewed_at,omitempty"`
	QualityScore              float64          `json:"quality_score"` // [0, 1]
	ReviewComments            []string         `json:"review_comments,omitempty"`
	Blockers                  []string         `json:"blockers,omitempty"` // Empty if approved
	ApprovalTimestampUnixSecs string           `json:"approval_timestamp_unix_secs,omitempty"`
}

// ========== Component Types ==========
type ComponentType string

const (
	ComponentTypePanel       ComponentType = "panel"
	ComponentTypeInverter    ComponentType = "inverter"
	ComponentTypeTransformer ComponentType = "transformer"
	ComponentTypeCombinerBox ComponentType = "combiner_box"
	ComponentTypeTracker     ComponentType = "tracker"
	ComponentTypeSubstation  ComponentType = "substation"
	ComponentTypeFence       ComponentType = "fence"
	ComponentTypeRoad        ComponentType = "road"
)

// Position represents a 3D coordinate in project-local space (meters).
type Position struct {
	X float64 `json:"x"`
	Y float64 `json:"y"`
	Z float64 `json:"z"`
}

// BoundingBox represents an axis-aligned bounding box for spatial queries.
type BoundingBox struct {
	MinX float64 `json:"min_x"`
	MinY float64 `json:"min_y"`
	MaxX float64 `json:"max_x"`
	MaxY float64 `json:"max_y"`
}

// Contains returns true if the point (x, y) is inside the bounding box.
func (bb BoundingBox) Contains(x, y float64) bool {
	return x >= bb.MinX && x <= bb.MaxX && y >= bb.MinY && y <= bb.MaxY
}

// Intersects returns true if the two bounding boxes overlap.
func (bb BoundingBox) Intersects(other BoundingBox) bool {
	return bb.MinX <= other.MaxX && bb.MaxX >= other.MinX &&
		bb.MinY <= other.MaxY && bb.MaxY >= other.MinY
}

// Width returns the horizontal extent.
func (bb BoundingBox) Width() float64 { return bb.MaxX - bb.MinX }

// Height returns the vertical extent.
func (bb BoundingBox) Height() float64 { return bb.MaxY - bb.MinY }

// Layout is the top-level entity representing a complete solar farm layout.
type Layout struct {
	ID              uuid.UUID       `json:"id"`
	ProjectID       uuid.UUID       `json:"project_id"`
	Name            string          `json:"name"`
	TotalPanels     int64           `json:"total_panels"`
	TotalCapacityKW float64         `json:"total_capacity_kw"`
	TileCount       int             `json:"tile_count"`
	CreatedAt       time.Time       `json:"created_at"`
	UpdatedAt       time.Time       `json:"updated_at"`
	ReviewMetadata  *ReviewMetadata `json:"review_metadata,omitempty"`
	CandidateID     *uuid.UUID      `json:"candidate_id,omitempty"` // Reference to MLCandidate if from algorithm
}

// Component is a placed object within a layout (inverter, transformer, etc.).
type Component struct {
	ID            uuid.UUID       `json:"id"`
	LayoutID      uuid.UUID       `json:"layout_id"`
	AssetID       uuid.UUID       `json:"asset_id"`
	ComponentType ComponentType   `json:"component_type"`
	Position      Position        `json:"position"`
	Rotation      Position        `json:"rotation"` // Euler angles (degrees)
	Metadata      json.RawMessage `json:"metadata,omitempty"`
	CreatedAt     time.Time       `json:"created_at"`
}

// LayoutTile is a spatial tile that holds a subset of panels for LOD/viewport queries.
type LayoutTile struct {
	ID         uuid.UUID       `json:"id"`
	LayoutID   uuid.UUID       `json:"layout_id"`
	BBox       BoundingBox     `json:"bbox"`
	LODLevel   int             `json:"lod_level"`
	PanelCount int             `json:"panel_count"`
	Metadata   json.RawMessage `json:"metadata,omitempty"`
	CreatedAt  time.Time       `json:"created_at"`
}

// Panel is an individual solar panel within a tile.
type Panel struct {
	ID              uuid.UUID       `json:"id"`
	TileID          uuid.UUID       `json:"tile_id"`
	StringID        string          `json:"string_id"` // Electrical string identifier
	GeometryGeoJSON json.RawMessage `json:"geometry_geojson"`
	Tilt            float64         `json:"tilt"`      // degrees
	Azimuth         float64         `json:"azimuth"`   // degrees from north
	Elevation       float64         `json:"elevation"` // meters above terrain
	Metadata        json.RawMessage `json:"metadata,omitempty"`
}

// PanelArrayParams defines parameters for auto-generating a panel array.
type PanelArrayParams struct {
	PanelWidth       float64         `json:"panel_width"`    // meters (e.g. 1.0)
	PanelHeight      float64         `json:"panel_height"`   // meters (e.g. 2.0)
	TiltAngle        float64         `json:"tilt_angle"`     // degrees
	Azimuth          float64         `json:"azimuth"`        // degrees from north
	RowSpacing       float64         `json:"row_spacing"`    // meters (0 = auto-compute from tilt)
	ColumnSpacing    float64         `json:"column_spacing"` // meters
	PanelAssetID     string          `json:"panel_asset_id,omitempty"`
	PanelModel       string          `json:"panel_model,omitempty"`
	PanelRatedPowerW float64         `json:"panel_rated_power_w,omitempty"`
	FillAreaGeoJSON  json.RawMessage `json:"fill_area_geojson"` // GeoJSON Polygon
	TerrainLayerID   *uuid.UUID      `json:"terrain_layer_id,omitempty"`
}

// PanelArrayResult is returned after a successful array generation.
type PanelArrayResult struct {
	LayoutID        uuid.UUID `json:"layout_id"`
	TotalPanels     int64     `json:"total_panels"`
	TotalCapacityKW float64   `json:"total_capacity_kw"`
	TileCount       int       `json:"tile_count"`
}

// CandidateImportResult is returned after importing a frozen ML candidate
// artifact graph into layout tiles/panels for downstream services.
type CandidateImportResult struct {
	LayoutID              uuid.UUID `json:"layout_id"`
	CandidateID           uuid.UUID `json:"candidate_id"`
	ArtifactGraphLayoutID uuid.UUID `json:"artifact_graph_layout_id"`
	ImportedPanels        int64     `json:"imported_panels"`
	ImportedTiles         int       `json:"imported_tiles"`
	TotalCapacityKW       float64   `json:"total_capacity_kw"`
	SelectionReason       string    `json:"selection_reason,omitempty"`
}

// ZonePlanRequest defines inputs for infrastructure zone planning.
type ZonePlanRequest struct {
	BoundaryGeoJSON  string  `json:"boundary_geojson"`
	TargetCapacityMW float64 `json:"target_capacity_mw"`
}

// ZoneAllocation describes one planned zone and its geometry.
type ZoneAllocation struct {
	ZoneType          string  `json:"zone_type"`
	TargetAreaSqm     float64 `json:"target_area_sqm"`
	PlannedAreaSqm    float64 `json:"planned_area_sqm"`
	CoveragePercent   float64 `json:"coverage_percent"`
	GeometryGeoJSON   string  `json:"geometry_geojson"`
	DesignDescription string  `json:"design_description"`
}

// ZonePlanResult contains all calculated zone allocations.
type ZonePlanResult struct {
	LayoutID         uuid.UUID        `json:"layout_id"`
	BoundaryAreaSqm  float64          `json:"boundary_area_sqm"`
	TargetCapacityMW float64          `json:"target_capacity_mw"`
	EstimatedDcMw    float64          `json:"estimated_dc_mw"`
	RecommendedAcMw  float64          `json:"recommended_ac_mw"`
	Zones            []ZoneAllocation `json:"zones"`
	Assumptions      []string         `json:"assumptions"`
}

// ViewportQuery defines a spatial viewport for tile retrieval.
type ViewportQuery struct {
	MinX     float64 `json:"min_x"`
	MinY     float64 `json:"min_y"`
	MaxX     float64 `json:"max_x"`
	MaxY     float64 `json:"max_y"`
	LODLevel *int    `json:"lod_level,omitempty"`
}
