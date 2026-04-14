package service

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"math"
	"net/http"
	"strings"
	"time"

	"github.com/google/uuid"

	"solar3d/transmission-routing-service/internal/domain"
)

// DEMSource retrieves an elevation raster for a given geographic bounding box.
// Implementations must be safe for concurrent use.
type DEMSource interface {
	// FetchRaster returns an ElevationRaster covering [minLon,maxLon] x [minLat,maxLat]
	// at approximately requestedCellSizeM resolution.  It is permitted to return a
	// coarser raster when the requested resolution would require too many API calls.
	FetchRaster(ctx context.Context, projectID *uuid.UUID, minLon, minLat, maxLon, maxLat, requestedCellSizeM float64) (domain.ElevationRaster, string, error)
	// SourceID returns a stable identifier used for data-source snapshot versioning.
	SourceID() string
}

// ─────────────────────────────────────────────────────────────────────────────
// FlatDEMSource – zero-elevation fallback (no external dependency)
// ─────────────────────────────────────────────────────────────────────────────

// FlatDEMSource returns a flat, zero-elevation raster. Used when no real DEM
// source is configured, and as a fallback when the external API is unreachable.
type FlatDEMSource struct{}

func (f *FlatDEMSource) SourceID() string { return "flat_terrain_fallback" }

func (f *FlatDEMSource) FetchRaster(_ context.Context, _ *uuid.UUID, minLon, minLat, maxLon, maxLat, cellSizeM float64) (domain.ElevationRaster, string, error) {
	lonScale := 111320.0 * math.Cos(math.Pi*(minLat+maxLat)/360.0)
	lonSpanM := (maxLon - minLon) * lonScale
	latSpanM := (maxLat - minLat) * 111320.0
	width := int(math.Max(2, math.Ceil(lonSpanM/cellSizeM)))
	height := int(math.Max(2, math.Ceil(latSpanM/cellSizeM)))
	return domain.ElevationRaster{
		Width:      width,
		Height:     height,
		CellSizeM:  cellSizeM,
		OriginLon:  minLon,
		OriginLat:  minLat,
		Elevations: make([]float64, width*height),
	}, f.SourceID(), nil
}

// TerrainServiceDEMSource fetches DEM from terrain-service persisted layers.
// It prefers project-scoped DEM layers that are already stored in database/cache.
type TerrainServiceDEMSource struct {
	baseURL string
	client  *http.Client
}

type terrainLayerDTO struct {
	ID        uuid.UUID `json:"id"`
	LayerType string    `json:"layer_type"`
}

type terrainGridRequest struct {
	Bounds struct {
		MinX float64 `json:"min_x"`
		MinY float64 `json:"min_y"`
		MaxX float64 `json:"max_x"`
		MaxY float64 `json:"max_y"`
	} `json:"bounds"`
	Width  int `json:"width"`
	Height int `json:"height"`
}

type terrainGridResponse struct {
	Width      int       `json:"width"`
	Height     int       `json:"height"`
	Elevations []float64 `json:"elevations"`
}

func NewTerrainServiceDEMSource(baseURL string) *TerrainServiceDEMSource {
	if strings.TrimSpace(baseURL) == "" {
		baseURL = "http://127.0.0.1:8081"
	}
	return &TerrainServiceDEMSource{
		baseURL: strings.TrimRight(baseURL, "/"),
		client:  &http.Client{Timeout: 20 * time.Second},
	}
}

func (t *TerrainServiceDEMSource) SourceID() string {
	return "terrain_service_db:" + t.baseURL
}

func (t *TerrainServiceDEMSource) FetchRaster(ctx context.Context, projectID *uuid.UUID, minLon, minLat, maxLon, maxLat, requestedCellSizeM float64) (domain.ElevationRaster, string, error) {
	if projectID == nil || *projectID == uuid.Nil {
		return domain.ElevationRaster{}, "", fmt.Errorf("project_id is required for terrain-service DEM fetch")
	}

	layersReq, err := http.NewRequestWithContext(
		ctx,
		http.MethodGet,
		fmt.Sprintf("%s/api/v1/terrain/layers?project_id=%s", t.baseURL, projectID.String()),
		nil,
	)
	if err != nil {
		return domain.ElevationRaster{}, "", fmt.Errorf("create terrain layers request: %w", err)
	}

	layersResp, err := t.client.Do(layersReq)
	if err != nil {
		return domain.ElevationRaster{}, "", fmt.Errorf("fetch terrain layers: %w", err)
	}
	defer layersResp.Body.Close()
	if layersResp.StatusCode != http.StatusOK {
		return domain.ElevationRaster{}, "", fmt.Errorf("terrain layers API returned status %d", layersResp.StatusCode)
	}

	var layers []terrainLayerDTO
	if err := json.NewDecoder(layersResp.Body).Decode(&layers); err != nil {
		return domain.ElevationRaster{}, "", fmt.Errorf("decode terrain layers response: %w", err)
	}

	var demLayerID uuid.UUID
	for _, layer := range layers {
		if strings.EqualFold(layer.LayerType, "DEM") {
			demLayerID = layer.ID
			break
		}
	}
	if demLayerID == uuid.Nil {
		return domain.ElevationRaster{}, "", fmt.Errorf("no DEM layer found for project")
	}

	cellSizeM := math.Max(requestedCellSizeM, 1)
	lonScale := 111320.0 * math.Cos(math.Pi*(minLat+maxLat)/360.0)
	lonSpanM := (maxLon - minLon) * lonScale
	latSpanM := (maxLat - minLat) * 111320.0
	width := int(math.Max(2, math.Ceil(lonSpanM/cellSizeM)))
	height := int(math.Max(2, math.Ceil(latSpanM/cellSizeM)))

	body := terrainGridRequest{Width: width, Height: height}
	body.Bounds.MinX = minLon
	body.Bounds.MinY = minLat
	body.Bounds.MaxX = maxLon
	body.Bounds.MaxY = maxLat

	rawBody, err := json.Marshal(body)
	if err != nil {
		return domain.ElevationRaster{}, "", fmt.Errorf("marshal terrain elevation-grid request: %w", err)
	}

	gridReq, err := http.NewRequestWithContext(
		ctx,
		http.MethodPost,
		fmt.Sprintf("%s/api/v1/terrain/layers/%s/elevation-grid", t.baseURL, demLayerID.String()),
		bytes.NewReader(rawBody),
	)
	if err != nil {
		return domain.ElevationRaster{}, "", fmt.Errorf("create terrain elevation-grid request: %w", err)
	}
	gridReq.Header.Set("Content-Type", "application/json")

	gridResp, err := t.client.Do(gridReq)
	if err != nil {
		return domain.ElevationRaster{}, "", fmt.Errorf("fetch terrain elevation-grid: %w", err)
	}
	defer gridResp.Body.Close()
	if gridResp.StatusCode != http.StatusOK {
		return domain.ElevationRaster{}, "", fmt.Errorf("terrain elevation-grid API returned status %d", gridResp.StatusCode)
	}

	var grid terrainGridResponse
	if err := json.NewDecoder(gridResp.Body).Decode(&grid); err != nil {
		return domain.ElevationRaster{}, "", fmt.Errorf("decode terrain elevation-grid response: %w", err)
	}

	if grid.Width <= 0 || grid.Height <= 0 || len(grid.Elevations) != grid.Width*grid.Height {
		return domain.ElevationRaster{}, "", fmt.Errorf("invalid terrain elevation-grid payload")
	}

	return domain.ElevationRaster{
		Width:      grid.Width,
		Height:     grid.Height,
		CellSizeM:  cellSizeM,
		OriginLon:  minLon,
		OriginLat:  minLat,
		Elevations: grid.Elevations,
	}, fmt.Sprintf("terrain_service_db:%s#layer=%s", t.baseURL, demLayerID.String()), nil
}

// ─────────────────────────────────────────────────────────────────────────────
// OpenElevationDEMSource – https://open-elevation.com/
// ─────────────────────────────────────────────────────────────────────────────

const (
	// demFetchCellSizeM is the minimum cell size used when auto-fetching to cap API calls.
	demFetchCellSizeM = 500.0
	// demBatchSize is the maximum number of sample points per API request.
	demBatchSize = 100
	// demMaxGridPoints caps the total grid size to avoid runaway memory / API usage.
	demMaxGridPoints = 2500
)

type openElevationPoint struct {
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
	Elevation float64 `json:"elevation,omitempty"`
}

type openElevationRequest struct {
	Locations []openElevationPoint `json:"locations"`
}

type openElevationResponse struct {
	Results []openElevationPoint `json:"results"`
}

// OpenElevationDEMSource fetches real elevation data from the Open Elevation API.
// It batches sample points and falls back to zero elevation on a per-batch basis if
// the API is unreachable or returns an error, so it never blocks route calculation.
type OpenElevationDEMSource struct {
	baseURL string
	client  *http.Client
}

// NewOpenElevationDEMSource creates a source backed by the Open Elevation API.
// Pass an empty baseURL to use the public instance at https://api.open-elevation.com.
func NewOpenElevationDEMSource(baseURL string) *OpenElevationDEMSource {
	if baseURL == "" {
		baseURL = "https://api.open-elevation.com"
	}
	return &OpenElevationDEMSource{
		baseURL: strings.TrimRight(baseURL, "/"),
		client:  &http.Client{Timeout: 10 * time.Second},
	}
}

func (o *OpenElevationDEMSource) SourceID() string {
	return "open_elevation_api:" + o.baseURL
}

func (o *OpenElevationDEMSource) FetchRaster(ctx context.Context, _ *uuid.UUID, minLon, minLat, maxLon, maxLat, requestedCellSizeM float64) (domain.ElevationRaster, string, error) {
	// Use a coarser grid to limit the number of API requests.
	cellSizeM := math.Max(requestedCellSizeM, demFetchCellSizeM)

	lonScale := 111320.0 * math.Cos(math.Pi*(minLat+maxLat)/360.0)
	lonSpanM := (maxLon - minLon) * lonScale
	latSpanM := (maxLat - minLat) * 111320.0
	width := int(math.Max(2, math.Ceil(lonSpanM/cellSizeM)))
	height := int(math.Max(2, math.Ceil(latSpanM/cellSizeM)))

	// Enforce hard cap on total points to protect against large bounding boxes.
	if width*height > demMaxGridPoints {
		scale := math.Sqrt(float64(width*height) / float64(demMaxGridPoints))
		width = max(2, int(float64(width)/scale))
		height = max(2, int(float64(height)/scale))
		cellSizeM = lonSpanM / float64(width)
	}

	// Build grid sample points (cell centres).
	adjustedLonScale := 111320.0 * math.Cos(math.Pi*(minLat+maxLat)/360.0)
	points := make([]openElevationPoint, 0, width*height)
	for row := 0; row < height; row++ {
		for col := 0; col < width; col++ {
			lat := minLat + (float64(row)+0.5)*cellSizeM/111320.0
			lon := minLon + (float64(col)+0.5)*cellSizeM/adjustedLonScale
			points = append(points, openElevationPoint{Latitude: lat, Longitude: lon})
		}
	}

	// Fetch in batches; zero-fill on per-batch errors so routing still proceeds.
	elevations := make([]float64, width*height)
	for i := 0; i < len(points); i += demBatchSize {
		end := i + demBatchSize
		if end > len(points) {
			end = len(points)
		}
		results, err := o.fetchBatch(ctx, points[i:end])
		if err != nil {
			// Best-effort: leave this batch as zero elevation rather than failing the
			// whole route calculation.
			continue
		}
		for j, r := range results {
			if i+j < len(elevations) {
				elevations[i+j] = r.Elevation
			}
		}
	}

	return domain.ElevationRaster{
		Width:      width,
		Height:     height,
		CellSizeM:  cellSizeM,
		OriginLon:  minLon,
		OriginLat:  minLat,
		Elevations: elevations,
	}, o.SourceID(), nil
}

func (o *OpenElevationDEMSource) fetchBatch(ctx context.Context, points []openElevationPoint) ([]openElevationPoint, error) {
	body, err := json.Marshal(openElevationRequest{Locations: points})
	if err != nil {
		return nil, fmt.Errorf("marshal dem request: %w", err)
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, o.baseURL+"/api/v1/lookup", bytes.NewReader(body))
	if err != nil {
		return nil, fmt.Errorf("create dem request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	resp, err := o.client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("fetch elevation: %w", err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("open-elevation API returned status %d", resp.StatusCode)
	}
	var out openElevationResponse
	if err := json.NewDecoder(resp.Body).Decode(&out); err != nil {
		return nil, fmt.Errorf("decode elevation response: %w", err)
	}
	return out.Results, nil
}

// ─────────────────────────────────────────────────────────────────────────────
// Raster helpers
// ─────────────────────────────────────────────────────────────────────────────

// isRasterFlat returns true when every elevation value in the raster is zero,
// indicating the raster was synthesised as flat terrain rather than ingested from
// a real DEM.
func isRasterFlat(raster domain.ElevationRaster) bool {
	for _, e := range raster.Elevations {
		if e != 0 {
			return false
		}
	}
	return true
}

// rasterMaxLon returns the eastern longitude bound of the raster.
func rasterMaxLon(raster domain.ElevationRaster) float64 {
	lonScale := 111320.0 * math.Cos(math.Pi*raster.OriginLat/180.0)
	return raster.OriginLon + float64(raster.Width)*raster.CellSizeM/lonScale
}

// rasterMaxLat returns the northern latitude bound of the raster.
func rasterMaxLat(raster domain.ElevationRaster) float64 {
	return raster.OriginLat + float64(raster.Height)*raster.CellSizeM/111320.0
}

// ─────────────────────────────────────────────────────────────────────────────
// Data source snapshot
// ─────────────────────────────────────────────────────────────────────────────

// buildDataSourceSnapshot catalogues what data sources were used for this route
// calculation run so the result can be reproduced later from the same snapshot.
func buildDataSourceSnapshot(req domain.CalculateTransmissionRouteRequest, autoFetched bool, demSourceID string) domain.DataSourceSnapshot {
	noGoCount, corridorCount, protectedCount := 0, 0, 0
	for _, f := range req.VectorFeatures {
		ft := strings.ToLower(f.FeatureType)
		switch {
		case strings.Contains(ft, "no_go") || strings.Contains(ft, "no-go") || ft == "forbidden":
			noGoCount++
		case strings.Contains(ft, "corridor") || ft == "preferred_corridor":
			corridorCount++
		case strings.Contains(ft, "protected_area"):
			protectedCount++
		}
	}
	return domain.DataSourceSnapshot{
		SnapshotID:             uuid.New().String(),
		SnapshotAt:             time.Now().UTC(),
		DEMSource:              demSourceID,
		DEMCellSizeM:           req.ElevationRaster.CellSizeM,
		DEMAutoFetched:         autoFetched,
		VectorFeatureCount:     len(req.VectorFeatures),
		NoGoZoneCount:          noGoCount,
		PreferredCorridorCount: corridorCount,
		ProtectedAreaCount:     protectedCount,
	}
}

