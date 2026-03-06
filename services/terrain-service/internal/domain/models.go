package domain

import (
	"fmt"
	"time"

	"github.com/google/uuid"
)

// LayerType represents the type of terrain analysis layer.
type LayerType string

const (
	LayerTypeDEM       LayerType = "DEM"
	LayerTypeSlope     LayerType = "Slope"
	LayerTypeAspect    LayerType = "Aspect"
	LayerTypeHillshade LayerType = "Hillshade"
)

// ValidLayerTypes enumerates all accepted layer types.
var ValidLayerTypes = map[LayerType]bool{
	LayerTypeDEM:       true,
	LayerTypeSlope:     true,
	LayerTypeAspect:    true,
	LayerTypeHillshade: true,
}

// ParseLayerType converts a string to a validated LayerType.
func ParseLayerType(s string) (LayerType, error) {
	lt := LayerType(s)
	if !ValidLayerTypes[lt] {
		return "", fmt.Errorf("invalid layer type %q: must be one of DEM, Slope, Aspect, Hillshade", s)
	}
	return lt, nil
}

// BoundingBox represents a geographic bounding box in the layer's CRS.
type BoundingBox struct {
	MinX float64 `json:"min_x"`
	MinY float64 `json:"min_y"`
	MaxX float64 `json:"max_x"`
	MaxY float64 `json:"max_y"`
}

// Valid checks that the bounding box has non-zero area and correct ordering.
func (b BoundingBox) Valid() bool {
	return b.MinX < b.MaxX && b.MinY < b.MaxY
}

// TerrainLayer is the core domain entity representing a terrain data layer
// associated with a solar EPC project.
type TerrainLayer struct {
	ID           uuid.UUID   `json:"id"`
	ProjectID    uuid.UUID   `json:"project_id"`
	Name         string      `json:"name"`
	LayerType    LayerType   `json:"layer_type"`
	SourceFile   string      `json:"source_file"`
	Bounds       BoundingBox `json:"bounds"`
	ResolutionM  float64     `json:"resolution_m"`
	CRS          string      `json:"crs"`
	MinElevation float64     `json:"min_elevation"`
	MaxElevation float64     `json:"max_elevation"`
	CreatedAt    time.Time   `json:"created_at"`
}

// ElevationGrid holds a rectangular grid of elevation values, typically
// extracted from a DEM for a given bounding region.
type ElevationGrid struct {
	Width      int       `json:"width"`
	Height     int       `json:"height"`
	Elevations []float64 `json:"elevations"`
	MinElev    float64   `json:"min_elev"`
	MaxElev    float64   `json:"max_elev"`
}

// ElevationPoint represents a single elevation query result.
type ElevationPoint struct {
	X         float64 `json:"x"`
	Y         float64 `json:"y"`
	Elevation float64 `json:"elevation"`
}
