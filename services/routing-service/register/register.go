// Package routingservice exposes a Register function for monolith use.
package register

import (
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"
	routingv1connect "p9e.in/samavaya/solar3d/gen/routing/v1/routingv1connect"

	"p9e.in/samavaya/solar3d/routing-service/internal/handler"
	"p9e.in/samavaya/solar3d/routing-service/internal/repository"
	"p9e.in/samavaya/solar3d/routing-service/internal/service"
)

// Register wires the routing-service handlers onto mux.
// orchestrationURL is the base URL of the compute-orchestration service; in the
// monolith this is typically the monolith's own address, e.g. "http://localhost:8080".
func Register(mux *http.ServeMux, pool *pgxpool.Pool, logger zerolog.Logger, orchestrationURL string) {
	repo := repository.NewRouteRepository(pool)
	svc := service.NewRoutingService(repo, orchestrationURL)
	h := handler.NewRoutingHandler(svc, logger)
	connectPath, connectHandler := routingv1connect.NewRoutingServiceHandler(handler.NewConnectRoutingService(svc))
	h.RegisterRoutes(mux)
	mux.Handle(connectPath, connectHandler)
}

