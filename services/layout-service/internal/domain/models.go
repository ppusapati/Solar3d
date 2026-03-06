package domain

import (
	"encoding/json"
	"time"

	"github.com/google/uuid"
)

// ComponentType enumerates the kinds of components placed in a layout.
type ComponentType string

const (
	ComponentTypePanel      ComponentType = "panel"
	ComponentTypeInverter   ComponentType = "inverter"
	ComponentTypeTransformer ComponentType = "transformer"
	ComponentTypeCombinerBox ComponentType = "combiner_box"
	ComponentTypeTracker    ComponentType = "tracker"
	ComponentTypeSubstation ComponentType = "substation"
	ComponentTypeFence      ComponentType = "fence"
	ComponentTypeRoad       ComponentType = "road"
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
	ID              uuid.UUID `json:"id"`
	ProjectID       uuid.UUID `json:"project_id"`
	Name            string    `json:"name"`
	TotalPanels     int64     `json:"total_panels"`
	TotalCapacityKW float64   `json:"total_capacity_kw"`
	TileCount       int       `json:"tile_count"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
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
	PanelWidth     float64         `json:"panel_width"`      // meters (e.g. 1.0)
	PanelHeight    float64         `json:"panel_height"`     // meters (e.g. 2.0)
	TiltAngle      float64         `json:"tilt_angle"`       // degrees
	Azimuth        float64         `json:"azimuth"`          // degrees from north
	RowSpacing     float64         `json:"row_spacing"`      // meters (0 = auto-compute from tilt)
	ColumnSpacing  float64         `json:"column_spacing"`   // meters
	FillAreaGeoJSON json.RawMessage `json:"fill_area_geojson"` // GeoJSON Polygon
	TerrainLayerID *uuid.UUID      `json:"terrain_layer_id,omitempty"`
}

// PanelArrayResult is returned after a successful array generation.
type PanelArrayResult struct {
	LayoutID       uuid.UUID `json:"layout_id"`
	TotalPanels    int64     `json:"total_panels"`
	TotalCapacityKW float64  `json:"total_capacity_kw"`
	TileCount      int       `json:"tile_count"`
}

// ViewportQuery defines a spatial viewport for tile retrieval.
type ViewportQuery struct {
	MinX     float64 `json:"min_x"`
	MinY     float64 `json:"min_y"`
	MaxX     float64 `json:"max_x"`
	MaxY     float64 `json:"max_y"`
	LODLevel *int    `json:"lod_level,omitempty"`
}
