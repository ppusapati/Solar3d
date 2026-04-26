package worker

import (
	"bytes"
	"context"
	"encoding/binary"
	"fmt"
	"math"
	"net/http"
	"strings"
	"time"

	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/terrain-service/internal/domain"
	"p9e.in/samavaya/solar3d/terrain-service/internal/repository"
)

// CopernicusDEMWorker downloads and ingests Copernicus DEM GeoTIFF data into the cache.
type CopernicusDEMWorker struct {
	repo       *repository.Repository
	logger     zerolog.Logger
	httpClient *http.Client
	cachePath  string // Local cache directory for GeoTIFFs
	pollTicker *time.Ticker
}

// NewCopernicusDEMWorker creates a new worker for Copernicus DEM ingestion.
func NewCopernicusDEMWorker(repo *repository.Repository, logger zerolog.Logger, cachePath string) *CopernicusDEMWorker {
	return &CopernicusDEMWorker{
		repo:   repo,
		logger: logger.With().Str("component", "dem_worker").Logger(),
		httpClient: &http.Client{
			Timeout: 5 * time.Minute,
		},
		cachePath:  cachePath,
		pollTicker: time.NewTicker(30 * time.Second), // Poll every 30s
	}
}

// Start begins the worker loop that monitors and processes pending DEM jobs.
func (w *CopernicusDEMWorker) Start(ctx context.Context) {
	go func() {
		w.logger.Info().Msg("copernicus dem worker started")

		for {
			select {
			case <-ctx.Done():
				w.logger.Info().Msg("copernicus dem worker stopping")
				w.pollTicker.Stop()
				return

			case <-w.pollTicker.C:
				w.processPendingJobs(ctx)
			}
		}
	}()
}

// processPendingJobs fetches and processes all pending DEM jobs.
func (w *CopernicusDEMWorker) processPendingJobs(ctx context.Context) {
	jobs, err := w.repo.ListPendingDEMJobs(ctx)
	if err != nil {
		w.logger.Error().Err(err).Msg("failed to list pending dem jobs")
		return
	}

	for _, job := range jobs {
		w.processJob(ctx, &job)
	}
}

// processJob processes a single DEM download job.
func (w *CopernicusDEMWorker) processJob(ctx context.Context, job *domain.CopernicusDEMJob) {
	w.logger.Info().
		Str("job_id", job.ID.String()).
		Str("layer_id", job.TerrainLayerID.String()).
		Str("status", string(job.Status)).
		Msg("processing dem job")

	// Mark as downloading
	job.Status = domain.DEMJobStatusDownloading
	job.ProgressPercent = 5
	now := time.Now()
	job.StartedAt = &now

	if err := w.repo.UpdateCopernicusDEMJob(ctx, job); err != nil {
		w.logger.Error().Err(err).Msg("failed to mark job as downloading")
		return
	}

	// Parse Copernicus URI and download tiles
	tiles, err := w.downloadTiles(ctx, job)
	if err != nil {
		w.logger.Error().Err(err).Str("source_uri", job.SourceURI).Msg("failed to download copernicus tiles")
		job.Status = domain.DEMJobStatusFailed
		job.ErrorMessage = fmt.Sprintf("download failed: %v", err)
		job.RetryCount++
		if job.RetryCount < job.MaxRetries {
			// Retry in 5 minutes
			next := time.Now().Add(5 * time.Minute)
			job.NextRetryAt = &next
			job.Status = domain.DEMJobStatusPending
		}
		w.repo.UpdateCopernicusDEMJob(ctx, job)
		return
	}

	job.TotalTilesRequested = len(tiles)
	job.ProgressPercent = 30

	// Ingest tiles into cache
	job.Status = domain.DEMJobStatusIngesting
	for idx, tile := range tiles {
		if err := w.repo.CacheDEMTile(ctx, &tile); err != nil {
			w.logger.Error().Err(err).
				Int("tile_row", tile.TileRow).
				Int("tile_col", tile.TileCol).
				Msg("failed to cache dem tile")
			job.TilesFailed++
		} else {
			job.TilesIngested++
		}
		job.ProgressPercent = 30 + int(int64(idx)*70/int64(len(tiles)))
		w.repo.UpdateCopernicusDEMJob(ctx, job)
	}

	// Mark job as complete
	job.Status = domain.DEMJobStatusCompleted
	job.ProgressPercent = 100
	now = time.Now()
	job.CompletedAt = &now

	if err := w.repo.UpdateCopernicusDEMJob(ctx, job); err != nil {
		w.logger.Error().Err(err).Msg("failed to mark job as completed")
	}

	w.logger.Info().
		Str("job_id", job.ID.String()).
		Int("tiles_ingested", job.TilesIngested).
		Int("tiles_failed", job.TilesFailed).
		Msg("dem job completed")
}

// downloadTiles downloads Copernicus GeoTIFF tiles based on the job's source URI.
// Example source_uri: "copernicus://dem/geotiff?bbox=8.0,45.0,8.5,45.5&resolution_m=30"
func (w *CopernicusDEMWorker) downloadTiles(ctx context.Context, job *domain.CopernicusDEMJob) ([]domain.DEMTileCache, error) {
	var tiles []domain.DEMTileCache

	// Parse the bounding box from job bounds
	// For now, we'll create a synthetic tile response
	// In production, this would call Copernicus API/OpenSearch with:
	//   POST https://catalogue.dataspace.copernicus.eu/odata/v1/Products
	//   with parameters to query DEM products over the bounding box

	// Synthetic implementation: create one tile per 1-degree segment
	tileRow := int(job.Bounds.MinY)
	tileCol := int(job.Bounds.MinX)

	// Create synthetic elevation grid (30m resolution)
	width := int((job.Bounds.MaxX - job.Bounds.MinX) * 120) // ~120 pixels per 0.5 degrees at 30m
	if width < 100 {
		width = 100
	}
	height := int((job.Bounds.MaxY - job.Bounds.MinY) * 120)
	if height < 100 {
		height = 100
	}

	elevations := w.generateSyntheticElevations(width, height)

	tile := domain.DEMTileCache{
		ProjectID:      job.ProjectID,
		TerrainLayerID: job.TerrainLayerID,
		TileRow:        tileRow,
		TileCol:        tileCol,
		SourceURI:      job.SourceURI,
		Bounds:         job.Bounds,
		Width:          width,
		Height:         height,
		ResolutionM:    job.ResolutionM,
	}

	// Compute min/max elevation
	minElev := float64(9999)
	maxElev := float64(-9999)
	for _, elev := range elevations {
		if elev < minElev {
			minElev = elev
		}
		if elev > maxElev {
			maxElev = elev
		}
	}
	tile.MinElevation = minElev
	tile.MaxElevation = maxElev

	// Serialize elevation data as GeoTIFF (simplified: just store as binary float32 for now)
	var evalBuf bytes.Buffer
	for _, e := range elevations {
		binary.Write(&evalBuf, binary.LittleEndian, float32(e))
	}
	tile.ElevationData = evalBuf.Bytes()

	tiles = append(tiles, tile)
	return tiles, nil
}

// generateSyntheticElevations creates synthetic elevation data for testing.
// In production, this would parse actual GeoTIFF binary data.
func (w *CopernicusDEMWorker) generateSyntheticElevations(width, height int) []float64 {
	elevations := make([]float64, width*height)

	// Multi-frequency sinusoidal terrain (same as before)
	for y := 0; y < height; y++ {
		for x := 0; x < width; x++ {
			fx := float64(x) / float64(width)
			fy := float64(y) / float64(height)

			e1 := 100 * (0.5 + 0.5*math.Sin(2*math.Pi*fx))
			e2 := 80 * (0.5 + 0.5*math.Cos(3*math.Pi*fy))
			e3 := 60 * (0.5 + 0.5*math.Sin(4*math.Pi*fx*fy))

			base := 500 + e1 + e2 + e3
			noise := math.Sin(float64(x)*0.01) * math.Cos(float64(y)*0.01)
			elev := base + noise*20

			elevations[y*width+x] = elev
		}
	}

	return elevations
}

// MonitorLayersForDEMJobs watches for new terrain layers with copernicus:// source URIs
// and automatically creates DEM download jobs for them.
func (w *CopernicusDEMWorker) MonitorLayersForDEMJobs(ctx context.Context) {
	go func() {
		monitorTicker := time.NewTicker(1 * time.Minute)
		defer monitorTicker.Stop()

		w.logger.Info().Msg("terrain layer monitor started")

		for {
			select {
			case <-ctx.Done():
				return
			case <-monitorTicker.C:
				// In production, query all terrain layers with status='pending' or
				// explicitly query for layers with source_file LIKE 'copernicus://%'
				// For now, this is called when new layers are created via the API
			}
		}
	}()
}

// CreateJobForCopernicusLayer creates a DEM download job for a terrain layer
// with a Copernicus source URI.
func (w *CopernicusDEMWorker) CreateJobForCopernicusLayer(ctx context.Context, layer *domain.TerrainLayer) (*domain.CopernicusDEMJob, error) {
	if !strings.HasPrefix(layer.SourceFile, "copernicus://") {
		return nil, fmt.Errorf("layer source file is not a copernicus URI: %s", layer.SourceFile)
	}

	job := &domain.CopernicusDEMJob{
		TerrainLayerID:      layer.ID,
		ProjectID:           layer.ProjectID,
		Status:              domain.DEMJobStatusPending,
		SourceURI:           layer.SourceFile,
		Bounds:              layer.Bounds,
		ResolutionM:         layer.ResolutionM,
		TotalTilesRequested: 0,
		MaxRetries:          3,
	}

	created, err := w.repo.CreateCopernicusDEMJob(ctx, job)
	if err != nil {
		return nil, fmt.Errorf("create dem job: %w", err)
	}

	w.logger.Info().
		Str("job_id", created.ID.String()).
		Str("layer_id", layer.ID.String()).
		Msg("created dem job for copernicus layer")

	return created, nil
}

