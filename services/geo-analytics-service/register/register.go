package register

import (
	"net/http"
	"os"

	"p9e.in/samavaya/solar3d/geo-analytics-service/internal/client"
	"p9e.in/samavaya/solar3d/geo-analytics-service/internal/handler"
	"p9e.in/samavaya/solar3d/geo-analytics-service/internal/service"
)

// Register wires geo-analytics HTTP routes onto mux.
func Register(mux *http.ServeMux) {
	bridgeURL := os.Getenv("GEO_COMPUTE_URL")
	if bridgeURL == "" {
		bridgeURL = "http://localhost:8001"
	}

	rustClient := client.NewGeoComputeClient(bridgeURL)
	svc := service.New(rustClient)
	h := handler.New(svc)
	h.RegisterHTTPRoutes(mux)
}

