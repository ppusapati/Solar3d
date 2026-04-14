// Package electricalservice exposes a Register function for monolith use.
package register

import (
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"
	electricalv1connect "github.com/solar3d/solar3d/gen/electrical/v1/electricalv1connect"

	"solar3d/electrical-service/internal/handler"
	"solar3d/electrical-service/internal/repository"
	"solar3d/electrical-service/internal/service"
)

// Register wires the electrical-service handlers onto mux.
func Register(mux *http.ServeMux, pool *pgxpool.Pool, logger zerolog.Logger, orchestrationURL string) {
	repo := repository.NewElectricalRepository(pool)
	svc := service.NewElectricalService(repo, orchestrationURL)
	h := handler.NewElectricalHandler(svc, logger)
	connectPath, connectHandler := electricalv1connect.NewElectricalServiceHandler(handler.NewConnectElectricalService(svc))
	h.RegisterRoutes(mux)
	mux.Handle(connectPath, connectHandler)
}

