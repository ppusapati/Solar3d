package register

import (
	"net/http"
	"os"

	"solar3d/optimization-service/internal/client"
	"solar3d/optimization-service/internal/handler"
	"solar3d/optimization-service/internal/service"
)

// Register wires optimization-service HTTP routes onto mux.
func Register(mux *http.ServeMux) {
	bridgeURL := os.Getenv("OPTIMIZATION_COMPUTE_URL")
	if bridgeURL == "" {
		bridgeURL = "http://localhost:8003"
	}

	rustClient := client.New(bridgeURL)
	svc := service.New(rustClient)
	h := handler.New(svc)
	h.RegisterHTTPRoutes(mux)
}

