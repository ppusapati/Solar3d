// Package projectservice exposes a single Register function that wires the
// project service onto an existing http.ServeMux for use in a monolith binary.
// Because register.go lives inside the solar3d/project-service module it is
// allowed to import the internal packages below.
package register

import (
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"
	projectv1connect "github.com/solar3d/solar3d/gen/project/v1/projectv1connect"

	"solar3d/project-service/internal/handler"
	"solar3d/project-service/internal/repository"
	"solar3d/project-service/internal/service"
)

// Register wires the project-service handlers onto mux.
// The returned value implements projectv1connect.ProjectServiceClient and can
// be passed directly to other in-process services that depend on it.
func Register(mux *http.ServeMux, pool *pgxpool.Pool, logger zerolog.Logger) projectv1connect.ProjectServiceClient {
	repo := repository.NewPgRepository(pool)
	svc := service.New(repo, logger)

	// ConnectRPC handler for the five core RPCs (CreateProject, GetProject, etc.)
	h := handler.NewConnectProjectService(svc)
	path, connectHandler := projectv1connect.NewProjectServiceHandler(h)
	mux.Handle(path, connectHandler)

	// Legacy HTTP handlers for site operations not yet in the ConnectRPC proto,
	// and the REST routes used by older client code.
	legacyH := handler.NewProjectHandler(svc, logger)
	legacyH.Register(mux)

	return h
}

