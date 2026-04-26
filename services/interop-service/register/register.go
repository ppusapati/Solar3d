// Package interopservice exposes a Register function for monolith use.
package register

import (
	"net/http"
	"time"

	"github.com/rs/zerolog"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"

	"p9e.in/samavaya/solar3d/interop-service/internal/handler"
	"p9e.in/samavaya/solar3d/interop-service/internal/service"
)

// Register wires the interop-service handlers onto mux.
func Register(mux *http.ServeMux, drawingRevisionClient drawingv1connect.DrawingRevisionServiceClient, cadCoreClient drawingv1connect.CadCoreServiceClient, logger zerolog.Logger, timeout time.Duration) {
	svc := service.New(drawingRevisionClient, cadCoreClient, logger, timeout)
	h := handler.NewConnectInteropService(svc)
	path, connectHandler := drawingv1connect.NewInteropServiceHandler(h)
	mux.Handle(path, connectHandler)
}

