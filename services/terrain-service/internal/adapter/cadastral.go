package adapter

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

// CadastralClient fetches parcel boundary data from county GIS / ArcGIS
// REST services. Most US counties expose parcel data via Esri ArcGIS Server
// feature services.
//
// The client queries feature layers using the ArcGIS REST API query endpoint
// with a spatial filter (envelope intersect) and returns GeoJSON features.
type CadastralClient struct {
	client *http.Client
}

// CadastralParcel is a single parcel boundary with attributes.
type CadastralParcel struct {
	ParcelID    string          `json:"parcel_id"`
	APN         string          `json:"apn"`         // Assessor Parcel Number
	Owner       string          `json:"owner"`
	Address     string          `json:"address"`
	AreaSqM     float64         `json:"area_sq_m"`
	GeoJSON     json.RawMessage `json:"geojson"`     // Polygon geometry
}

func NewCadastralClient() *CadastralClient {
	return &CadastralClient{
		client: &http.Client{Timeout: 30 * time.Second},
	}
}

// FetchParcels queries an ArcGIS feature service for parcels intersecting
// the given bounding box.
//
// featureServiceURL: full URL to the ArcGIS feature layer query endpoint, e.g.,
// "https://gis.county.gov/arcgis/rest/services/Parcels/FeatureServer/0/query"
func (c *CadastralClient) FetchParcels(
	ctx context.Context,
	featureServiceURL string,
	xMin, yMin, xMax, yMax float64,
) ([]CadastralParcel, error) {
	// ArcGIS REST API query with spatial filter
	url := fmt.Sprintf(
		"%s?where=1%%3D1&geometry=%f,%f,%f,%f&geometryType=esriGeometryEnvelope"+
			"&inSR=4326&spatialRel=esriSpatialRelIntersects"+
			"&outFields=PARCELID,APN,OWNER,SITEADDR,Shape_Area"+
			"&returnGeometry=true&outSR=4326&f=geojson",
		featureServiceURL, xMin, yMin, xMax, yMax,
	)

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("cadastral: build request: %w", err)
	}

	resp, err := c.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("cadastral: http: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
		return nil, fmt.Errorf("cadastral: HTTP %d: %s", resp.StatusCode, string(body))
	}

	var fc geojsonFeatureCollection
	if err := json.NewDecoder(resp.Body).Decode(&fc); err != nil {
		return nil, fmt.Errorf("cadastral: decode GeoJSON: %w", err)
	}

	parcels := make([]CadastralParcel, 0, len(fc.Features))
	for _, f := range fc.Features {
		geom, _ := json.Marshal(f.Geometry)
		p := CadastralParcel{
			ParcelID: stringProp(f.Properties, "PARCELID"),
			APN:      stringProp(f.Properties, "APN"),
			Owner:    stringProp(f.Properties, "OWNER"),
			Address:  stringProp(f.Properties, "SITEADDR"),
			AreaSqM:  floatProp(f.Properties, "Shape_Area"),
			GeoJSON:  geom,
		}
		parcels = append(parcels, p)
	}
	return parcels, nil
}

type geojsonFeatureCollection struct {
	Type     string           `json:"type"`
	Features []geojsonFeature `json:"features"`
}

type geojsonFeature struct {
	Type       string                 `json:"type"`
	Geometry   json.RawMessage        `json:"geometry"`
	Properties map[string]interface{} `json:"properties"`
}

func stringProp(props map[string]interface{}, key string) string {
	if v, ok := props[key]; ok {
		if s, ok := v.(string); ok {
			return s
		}
	}
	return ""
}

func floatProp(props map[string]interface{}, key string) float64 {
	if v, ok := props[key]; ok {
		switch n := v.(type) {
		case float64:
			return n
		case int:
			return float64(n)
		}
	}
	return 0
}
