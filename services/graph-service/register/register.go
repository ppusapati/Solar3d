package register

import (
	"net/http"
	"os"

	"p9e.in/samavaya/solar3d/graph-service/internal/client"
	"p9e.in/samavaya/solar3d/graph-service/internal/handler"
	"p9e.in/samavaya/solar3d/graph-service/internal/service"
)

// Register wires graph-service HTTP routes onto mux.
func Register(mux *http.ServeMux) {
	bridgeURL := os.Getenv("GRAPH_COMPUTE_URL")
	if bridgeURL == "" {
		bridgeURL = "http://localhost:8002"
	}

	rustClient := client.New(bridgeURL)
	svc := service.New(rustClient)
	h := handler.New(svc)
	h.RegisterHTTPRoutes(mux)
}

