// Package simulationservice exposes a Register function for monolith use.
package register

import (
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"
	simulationv1connect "p9e.in/samavaya/solar3d/gen/simulation/v1/simulationv1connect"

	"p9e.in/samavaya/solar3d/simulation-service/internal/handler"
	"p9e.in/samavaya/solar3d/simulation-service/internal/repository"
	"p9e.in/samavaya/solar3d/simulation-service/internal/service"
)

// Register wires the simulation-service handlers onto mux.
// pool is the shared DB pool; orchestrationURL is the compute-orchestration URL
// (typically "http://localhost:PORT" in the monolith).
func Register(mux *http.ServeMux, pool *pgxpool.Pool, logger zerolog.Logger, orchestrationURL string) {
	repo := repository.NewSimulationRepository(pool)
	svc := service.NewSimulationService(repo, orchestrationURL)
	h := handler.NewSimulationHandler(svc, logger)
	connectPath, connectHandler := simulationv1connect.NewSimulationServiceHandler(handler.NewConnectSimulationService(svc))
	h.RegisterRoutes(mux)
	mux.Handle(connectPath, connectHandler)
}

