package adapter

// ImageryProvider configures the base map tile source for the frontend
// 3D viewer. This is consumed by the web and mobile clients to construct
// tile URLs at runtime.

// ImagerySource identifies a tile map provider.
type ImagerySource string

const (
	ImageryGoogle ImagerySource = "google"
	ImageryBing   ImagerySource = "bing"
	ImageryMapbox ImagerySource = "mapbox"
	ImageryOSM    ImagerySource = "osm"
	ImageryCustom ImagerySource = "custom"
)

// ImageryConfig holds the configuration for an imagery tile provider.
// Serialised to JSON and served to the frontend via a config endpoint.
type ImageryConfig struct {
	Source    ImagerySource `json:"source"`
	// URLTemplate is the tile URL pattern with {z}/{x}/{y} placeholders.
	// For providers requiring an API key, {key} is replaced at serving time.
	URLTemplate string `json:"url_template"`
	// APIKey is stored server-side and injected into the URL template by the
	// backend. Never sent to the frontend directly.
	APIKey string `json:"-"`
	// Attribution string required by the provider's terms of service.
	Attribution string `json:"attribution"`
	// MaxZoom is the maximum zoom level supported.
	MaxZoom int `json:"max_zoom"`
}

// DefaultImageryConfigs returns the standard set of imagery providers.
// API keys must be populated from environment variables before serving.
func DefaultImageryConfigs() []ImageryConfig {
	return []ImageryConfig{
		{
			Source:      ImageryGoogle,
			URLTemplate: "https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}",
			Attribution: "© Google",
			MaxZoom:     21,
		},
		{
			Source:      ImageryBing,
			URLTemplate: "https://ecn.t{s}.tiles.virtualearth.net/tiles/a{quadkey}.jpeg?g=587&mkt=en-US&key={key}",
			Attribution: "© Microsoft",
			MaxZoom:     19,
		},
		{
			Source:      ImageryMapbox,
			URLTemplate: "https://api.mapbox.com/v4/mapbox.satellite/{z}/{x}/{y}@2x.jpg90?access_token={key}",
			Attribution: "© Mapbox © OpenStreetMap",
			MaxZoom:     22,
		},
		{
			Source:      ImageryOSM,
			URLTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
			Attribution: "© OpenStreetMap contributors",
			MaxZoom:     19,
		},
	}
}
