package domain

import (
	"encoding/json"

	"github.com/google/uuid"
)

type RouteType string

const (
	RouteTypeCable RouteType = "cable"
	RouteTypeRoad  RouteType = "road"
	RouteTypeFence RouteType = "fence"
)

type Route struct {
	ID              uuid.UUID       `json:"id"`
	ProjectID       uuid.UUID       `json:"project_id"`
	RouteType       RouteType       `json:"route_type"`
	Name            string          `json:"name"`
	GeometryGeoJSON json.RawMessage `json:"geometry_geojson"`
	DistanceM       float64         `json:"distance_m"`
	CostEstimate    float64         `json:"cost_estimate"`
	Metadata        json.RawMessage `json:"metadata,omitempty"`
}

type Waypoint struct {
	Lon       float64 `json:"lon"`
	Lat       float64 `json:"lat"`
	Elevation float64 `json:"elevation"`
}

type RouteConstraints struct {
	MaxSlope     float64     `json:"max_slope"`
	AvoidWater   bool        `json:"avoid_water"`
	AvoidZones   [][]float64 `json:"avoid_zones"`
	SlopePenalty float64     `json:"slope_penalty"`
}

type CalculateRouteRequest struct {
	ProjectID   uuid.UUID        `json:"project_id"`
	RouteType   RouteType        `json:"route_type"`
	Name        string           `json:"name"`
	Start       Waypoint         `json:"start"`
	End         Waypoint         `json:"end"`
	Constraints RouteConstraints `json:"constraints"`
	GridSizeM   float64          `json:"grid_size_m"`
	Terrain     *TerrainGrid     `json:"terrain,omitempty"`
}

type TerrainGrid struct {
	Width      int       `json:"width"`
	Height     int       `json:"height"`
	CellSizeM  float64  `json:"cell_size_m"`
	OriginLon  float64  `json:"origin_lon"`
	OriginLat  float64  `json:"origin_lat"`
	Elevations [][]float64 `json:"elevations"`
	Obstacles  [][]bool    `json:"obstacles"`
}

type CreateRouteRequest struct {
	ProjectID       uuid.UUID       `json:"project_id"`
	RouteType       RouteType       `json:"route_type"`
	Name            string          `json:"name"`
	GeometryGeoJSON json.RawMessage `json:"geometry_geojson"`
	DistanceM       float64         `json:"distance_m"`
	CostEstimate    float64         `json:"cost_estimate"`
	Metadata        json.RawMessage `json:"metadata,omitempty"`
}
