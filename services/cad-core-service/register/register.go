// Package cadcoreservice exposes a Register function for monolith use.
package register

import (
	"net/http"
	"time"

	"github.com/rs/zerolog"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"

	"p9e.in/samavaya/solar3d/cad-core-service/internal/handler"
	"p9e.in/samavaya/solar3d/cad-core-service/internal/service"
)

// Register wires the cad-core-service handlers onto mux.
// drawingRevisionClient is typically the drawing-revision-service handler which
// satisfies the client interface.
func Register(mux *http.ServeMux, drawingRevisionClient drawingv1connect.DrawingRevisionServiceClient, logger zerolog.Logger, timeout time.Duration) drawingv1connect.CadCoreServiceClient {
	svc := service.New(drawingRevisionClient, logger, timeout)
	h := handler.NewConnectCadCoreService(svc)
	path, connectHandler := drawingv1connect.NewCadCoreServiceHandler(h)
	mux.Handle(path, connectHandler)
	return h
}

