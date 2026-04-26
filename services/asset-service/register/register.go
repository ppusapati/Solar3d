// Package assetservice exposes a Register function for monolith use.
package register

import (
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"
	assetv1connect "p9e.in/samavaya/solar3d/gen/asset/v1/assetv1connect"

	"p9e.in/samavaya/solar3d/asset-service/internal/handler"
	"p9e.in/samavaya/solar3d/asset-service/internal/repository"
	"p9e.in/samavaya/solar3d/asset-service/internal/service"
)

// Register wires the asset-service handlers onto mux.
func Register(mux *http.ServeMux, pool *pgxpool.Pool, logger zerolog.Logger) {
	repo := repository.NewAssetRepository(pool)
	svc := service.NewAssetService(repo)
	h := handler.NewConnectAssetService(svc)
	path, connectHandler := assetv1connect.NewAssetServiceHandler(h)
	mux.Handle(path, connectHandler)
}

