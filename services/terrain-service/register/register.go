// Package terrainservice exposes a Register function for monolith use.
package register

import (
	"context"
	"net/http"
	"os"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"
	terrainv1connect "github.com/solar3d/solar3d/gen/terrain/v1/terrainv1connect"

	"solar3d/terrain-service/internal/handler"
	"solar3d/terrain-service/internal/repository"
	"solar3d/terrain-service/internal/service"
	"solar3d/terrain-service/internal/worker"
)

// Register wires the terrain-service handlers onto mux and starts background workers.
func Register(mux *http.ServeMux, pool *pgxpool.Pool, logger zerolog.Logger, orchestrationURL string) {
	RegisterWithContext(context.Background(), mux, pool, logger, orchestrationURL)
}

// RegisterWithContext wires the terrain-service handlers onto mux and starts background workers
// with the given context for lifecycle management.
func RegisterWithContext(ctx context.Context, mux *http.ServeMux, pool *pgxpool.Pool, logger zerolog.Logger, orchestrationURL string) {
	repo := repository.New(pool, logger)

	// Initialize Copernicus DEM worker
	cachePath := os.Getenv("COPERNICUS_CACHE_PATH")
	if cachePath == "" {
		cachePath = "/tmp/copernicus-dem-cache"
		os.MkdirAll(cachePath, 0755)
	}
	demWorker := worker.NewCopernicusDEMWorker(repo, logger, cachePath)

	// Start the DEM worker background loop
	demWorker.Start(ctx)
	demWorker.MonitorLayersForDEMJobs(ctx)

	svc := service.New(repo, logger, orchestrationURL, demWorker)
	h := handler.New(svc, logger)
	connectPath, connectHandler := terrainv1connect.NewTerrainServiceHandler(handler.NewConnectTerrainService(svc))
	h.RegisterRoutes(mux)
	mux.Handle(connectPath, connectHandler)
}

