package register

import (
	"context"
	"log"
	"net/http"
	"os"
	"strings"
	"time"

	"p9e.in/samavaya/solar3d/ml-service/internal/client"
	"p9e.in/samavaya/solar3d/ml-service/internal/handler"
	"p9e.in/samavaya/solar3d/ml-service/internal/service"
)

// Register wires ml-service HTTP routes onto mux.
func Register(mux *http.ServeMux) {
	bridgeURL := os.Getenv("ML_INFERENCE_URL")
	if bridgeURL == "" {
		bridgeURL = "http://localhost:8004"
	}

	backendMode := strings.ToLower(strings.TrimSpace(os.Getenv("ML_BACKEND")))
	if backendMode == "" {
		backendMode = "auto"
	}

	var backend service.MLBackend
	switch backendMode {
	case "go":
		backend = service.NewGoBackend()
		log.Printf("ml-service register: using pure-go backend (ML_BACKEND=go)")
	case "rust":
		rustClient := client.New(bridgeURL)
		backend = rustClient
		log.Printf("ml-service register: using rust bridge backend (ML_BACKEND=rust, url=%s)", bridgeURL)
	default:
		rustClient := client.New(bridgeURL)
		healthCtx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
		err := rustClient.Health(healthCtx)
		cancel()
		if err != nil {
			backend = service.NewGoBackend()
			log.Printf("ml-service register: rust bridge unhealthy (%v); falling back to pure-go backend", err)
		} else {
			backend = rustClient
			log.Printf("ml-service register: rust bridge healthy; using rust backend (url=%s)", bridgeURL)
		}
	}

	svc := service.New(backend)
	h := handler.New(svc)
	h.RegisterHTTPRoutes(mux)
}
