// Package plotsheetservice exposes a Register function for monolith use.
package register

import (
	"net/http"
	"time"

	"github.com/rs/zerolog"
	drawingv1connect "github.com/solar3d/solar3d/gen/drawing/v1/drawingv1connect"

	"solar3d/plot-sheet-service/internal/handler"
	"solar3d/plot-sheet-service/internal/service"
)

// Register wires the plot-sheet-service handlers onto mux.
// The returned value implements drawingv1connect.PlotSheetServiceClient and can be
// passed to compute-orchestration-service's executor which needs it.
func Register(mux *http.ServeMux, drawingRevisionClient drawingv1connect.DrawingRevisionServiceClient, cadCoreClient drawingv1connect.CadCoreServiceClient, logger zerolog.Logger, timeout time.Duration) drawingv1connect.PlotSheetServiceClient {
	svc := service.New(drawingRevisionClient, cadCoreClient, logger, timeout)
	h := handler.NewConnectPlotSheetService(svc)
	path, connectHandler := drawingv1connect.NewPlotSheetServiceHandler(h)
	mux.Handle(path, connectHandler)
	return h
}

