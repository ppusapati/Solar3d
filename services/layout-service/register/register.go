// Package layoutservice exposes a Register function for monolith use.
package register

import (
	"net/http"
	"os"
	"strconv"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"
	layoutv1connect "p9e.in/samavaya/solar3d/gen/layout/v1/layoutv1connect"

	"p9e.in/samavaya/solar3d/layout-service/internal/config"
	"p9e.in/samavaya/solar3d/layout-service/internal/handler"
	"p9e.in/samavaya/solar3d/layout-service/internal/repository"
	"p9e.in/samavaya/solar3d/layout-service/internal/service"
)

// Register wires the layout-service handlers onto mux.
func Register(mux *http.ServeMux, pool *pgxpool.Pool, logger zerolog.Logger) {
	cfg := &config.Config{
		TileSize:  100.0,
		MaxPanels: 1000000,
		LogLevel:  "info",
	}
	if v := os.Getenv("TILE_SIZE"); v != "" {
		if ts, err := strconv.ParseFloat(v, 64); err == nil && ts > 0 {
			cfg.TileSize = ts
		}
	}
	if v := os.Getenv("MAX_PANELS"); v != "" {
		if maxPanels, err := strconv.Atoi(v); err == nil && maxPanels >= 0 {
			cfg.MaxPanels = maxPanels
		}
	}

	repo := repository.New(pool)
	svc := service.New(repo, cfg)
	h := handler.New(svc, logger)
	connectPath, connectHandler := layoutv1connect.NewLayoutServiceHandler(handler.NewConnectLayoutService(svc))
	h.RegisterRoutes(mux)
	mux.Handle(connectPath, connectHandler)
}

