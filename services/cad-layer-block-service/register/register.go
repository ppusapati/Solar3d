// Package cadlayerblockservice exposes a Register function for monolith use.
package register

import (
	"net/http"
	"time"

	"github.com/rs/zerolog"
	drawingv1connect "github.com/solar3d/solar3d/gen/drawing/v1/drawingv1connect"

	"solar3d/cad-layer-block-service/internal/handler"
	"solar3d/cad-layer-block-service/internal/service"
)

// Register wires the cad-layer-block-service handlers onto mux.
func Register(mux *http.ServeMux, drawingRevisionClient drawingv1connect.DrawingRevisionServiceClient, cadCoreClient drawingv1connect.CadCoreServiceClient, logger zerolog.Logger, timeout time.Duration) {
	svc := service.New(drawingRevisionClient, cadCoreClient, logger, timeout)
	h := handler.NewConnectCadLayerBlockService(svc)
	path, connectHandler := drawingv1connect.NewCadLayerBlockServiceHandler(h)
	mux.Handle(path, connectHandler)
}

