package models

// BoundingBoxModel describes an axis-aligned bounding box.
type BoundingBoxModel struct {
	MinX float64
	MinY float64
	MaxX float64
	MaxY float64
}

// TerrainLayerModel is the domain representation of terrain metadata.
type TerrainLayerModel struct {
	ID           string
	Name         string
	LayerType    string
	SourceFile   string
	Bounds       BoundingBoxModel
	ResolutionM  float64
	CRS          string
	MinElevation float64
	MaxElevation float64
}

// GetElevationRequest is the domain request for a single-point elevation query.
type GetElevationRequest struct {
	ProjectID string
	Longitude float64
	Latitude  float64
}

// GetElevationResponse is the domain response for a single-point elevation query.
type GetElevationResponse struct {
	Elevation float64
}

// GetElevationGridRequest is the domain request for grid elevation query.
type GetElevationGridRequest struct {
	ProjectID   string
	Bounds      BoundingBoxModel
	ResolutionM float64
}

// GetElevationGridResponse is the domain response for grid elevation query.
type GetElevationGridResponse struct {
	Width        int32
	Height       int32
	Elevations   []float64
	MinElevation float64
	MaxElevation float64
}

// ComputeSlopeRequest is the domain request for slope compute.
type ComputeSlopeRequest struct {
	TerrainLayerID string
}

// ComputeSlopeResponse is the domain response for slope compute.
type ComputeSlopeResponse struct {
	SlopeLayer TerrainLayerModel
}

// ComputeAspectRequest is the domain request for aspect compute.
type ComputeAspectRequest struct {
	TerrainLayerID string
}

// ComputeAspectResponse is the domain response for aspect compute.
type ComputeAspectResponse struct {
	AspectLayer TerrainLayerModel
}

