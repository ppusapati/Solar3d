package models

// GetSunPositionRequest is the domain request for sun position compute.
type GetSunPositionRequest struct {
	Latitude      float64
	Longitude     float64
	TimestampUnix int64
}

// SunPositionModel is the domain model for solar position.
type SunPositionModel struct {
	Azimuth       float64
	Elevation     float64
	Zenith        float64
	HourAngle     float64
	TimestampUnix int64
}

// GetSunPositionResponse is the domain response for sun position compute.
type GetSunPositionResponse struct {
	Position SunPositionModel
}

// GetShadowMapRequest is the domain request for shadow projection compute.
type GetShadowMapRequest struct {
	LayoutID      string
	Latitude      float64
	Longitude     float64
	TimestampUnix int64
}

// ShadowPolygonModel captures a computed shadow polygon.
type ShadowPolygonModel struct {
	SourcePanelID   string
	ShadowGeoJSON   string
	ShadowIntensity float64
}

// GetShadowMapResponse is the domain response for shadow map compute.
type GetShadowMapResponse struct {
	Shadows     []ShadowPolygonModel
	SunPosition SunPositionModel
}

