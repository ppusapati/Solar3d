package register

import (
	"fmt"
	"net/http"
	"time"

	"github.com/rs/zerolog"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"
	projectv1connect "p9e.in/samavaya/solar3d/gen/project/v1/projectv1connect"

	"p9e.in/samavaya/solar3d/api-gateway-service/internal/handler"
	"p9e.in/samavaya/solar3d/api-gateway-service/internal/service"
)

// Register wires API Gateway workspace routes onto the shared mux.
// In monolith mode all downstream clients loop back to monolithAddr.
func Register(mux *http.ServeMux, monolithAddr string, logger zerolog.Logger) {
	httpClient := &http.Client{Timeout: 15 * time.Second}

	projects := projectv1connect.NewProjectServiceClient(httpClient, monolithAddr)
	drawings := drawingv1connect.NewDrawingRevisionServiceClient(httpClient, monolithAddr)
	cad := drawingv1connect.NewCadCoreServiceClient(httpClient, monolithAddr)
	annotation := drawingv1connect.NewCadAnnotationServiceClient(httpClient, monolithAddr)
	layerBlock := drawingv1connect.NewCadLayerBlockServiceClient(httpClient, monolithAddr)
	interop := drawingv1connect.NewInteropServiceClient(httpClient, monolithAddr)
	plotSheet := drawingv1connect.NewPlotSheetServiceClient(httpClient, monolithAddr)

	svc := service.New(
		projects,
		drawings,
		cad,
		annotation,
		layerBlock,
		interop,
		plotSheet,
		httpClient,
		monolithAddr,
		monolithAddr,
		monolithAddr,
		monolithAddr,
		monolithAddr,
		monolithAddr,
		monolithAddr,
		15*time.Second,
		logger,
	)

	h := handler.New(svc)
	h.RegisterWithoutHealth(mux)

	logger.Info().Str("monolith_addr", monolithAddr).Msg(fmt.Sprintf("registered %s", "api-gateway-service"))
}

