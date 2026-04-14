// Package drawingrevisionservice exposes a Register function for monolith use.
package register

import (
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"
	drawingv1connect "github.com/solar3d/solar3d/gen/drawing/v1/drawingv1connect"

	"solar3d/drawing-revision-service/internal/handler"
	"solar3d/drawing-revision-service/internal/repository"
	"solar3d/drawing-revision-service/internal/service"
)

// Register wires the drawing-revision-service handlers onto mux.
// The returned handler also satisfies drawingv1connect.DrawingRevisionServiceClient
// and can be passed to in-process services that need it as a client.
func Register(mux *http.ServeMux, pool *pgxpool.Pool, logger zerolog.Logger) drawingv1connect.DrawingRevisionServiceClient {
	repo := repository.NewPgRepository(pool)
	svc := service.New(repo, logger)
	h := handler.NewConnectDrawingRevisionService(svc)
	path, connectHandler := drawingv1connect.NewDrawingRevisionServiceHandler(h)
	mux.Handle(path, connectHandler)
	return h
}

