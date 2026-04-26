// Package register provides a convenience function for wiring twin-service
// into the monolith's multiplexer.
package register

import (
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"

	"p9e.in/samavaya/solar3d/twin-service/internal/handler"
	"p9e.in/samavaya/solar3d/twin-service/internal/repository"
	"p9e.in/samavaya/solar3d/twin-service/internal/service"
)

// Register mounts all twin-service handlers onto the provided mux using the
// shared database pool and logger. This is the monolith integration entry point.
func Register(mux *http.ServeMux, pool *pgxpool.Pool, logger zerolog.Logger) {
	repo := repository.NewPgRepository(pool)
	svc := service.New(repo, logger)
	h := handler.NewTwinHandler(svc, logger)
	h.Register(mux)
}
