// Package cadannotationservice exposes a Register function for monolith use.
package register

import (
	"net/http"
	"time"

	"github.com/rs/zerolog"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"

	"p9e.in/samavaya/solar3d/cad-annotation-service/internal/handler"
	"p9e.in/samavaya/solar3d/cad-annotation-service/internal/service"
)

// Register wires the cad-annotation-service handlers onto mux.
func Register(mux *http.ServeMux, drawingRevisionClient drawingv1connect.DrawingRevisionServiceClient, cadCoreClient drawingv1connect.CadCoreServiceClient, logger zerolog.Logger, timeout time.Duration) {
	svc := service.New(drawingRevisionClient, cadCoreClient, logger, timeout)
	h := handler.NewConnectCadAnnotationService(svc)
	path, connectHandler := drawingv1connect.NewCadAnnotationServiceHandler(h)
	mux.Handle(path, connectHandler)
}

