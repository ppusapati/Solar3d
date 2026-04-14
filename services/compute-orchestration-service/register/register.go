// Package computeorchestrationservice exposes a Register function for monolith use.
package register

import (
	"context"
	"net/http"
	"os"
	"time"

	"github.com/rs/zerolog"
	orchestrationv1connect "github.com/solar3d/solar3d/gen/orchestration/v1/orchestrationv1connect"

	"solar3d/compute-orchestration-service/internal/executor"
	"solar3d/compute-orchestration-service/internal/handler"
	"solar3d/compute-orchestration-service/internal/repository"
	"solar3d/compute-orchestration-service/internal/service"
)

// Register wires the compute-orchestration-service handlers onto mux.
// monolithAddr is the base address of the monolith (e.g., "http://localhost:8080") to which
// the orchestration executor will send compute requests. Since all services are on the same server,
// this causes loopback calls through the mux which is perfectly valid and efficient for a monolith.
func Register(mux *http.ServeMux, monolithAddr string, logger zerolog.Logger) {
	// Default monolith address
	if monolithAddr == "" {
		monolithAddr = "http://127.0.0.1:8080"
	}

	// Initialize repository (postgres or in-memory based on env)
	var repo repository.Store
	databaseURL := os.Getenv("DATABASE_URL")
	if databaseURL != "" {
		pgRepo, err := repository.NewPostgresRepository(context.Background(), databaseURL)
		if err != nil {
			logger.Error().Err(err).Msg("failed to init postgres repo for orchestration, using in-memory")
			repo = repository.NewInMemoryRepository()
		} else {
			repo = pgRepo
		}
	} else {
		repo = repository.NewInMemoryRepository()
		logger.Info().Msg("using in-memory repository for compute-orchestration")
	}

	// Initialize executor with loopback URLs (all services are on the monolith)
	exec := executor.NewComputeExecutor(executor.Endpoints{
		ComputeBaseURL:      monolithAddr,
		GeoServiceURL:       monolithAddr,
		GraphServiceURL:     monolithAddr,
		OptimizationURL:     monolithAddr,
		SimulationURL:       monolithAddr,
		MLInferenceURL:      monolithAddr,
		PlotSheetServiceURL: monolithAddr,
		StructuralURL:       monolithAddr,
		ProtectionURL:       monolithAddr,
		CommissioningURL:    monolithAddr,
	}, nil)

	// Initialize service
	svc := service.New(repo, exec, 4, 100) // 4 workers, buffer size 100
	svc.Start()

	// Initialize handler and register on mux
	h := handler.NewConnectHandler(svc)
	path, connectHandler := orchestrationv1connect.NewComputeOrchestrationServiceHandler(h)
	mux.Handle(path, connectHandler)

	// Health endpoint
	mux.HandleFunc("GET /healthz/orchestration", func(w http.ResponseWriter, r *http.Request) {
		ctx, cancel := context.WithTimeout(r.Context(), 2*time.Second)
		defer cancel()
		if err := svc.Health(ctx); err != nil {
			w.Header().Set("Content-Type", "application/json")
			w.WriteHeader(http.StatusServiceUnavailable)
			_, _ = w.Write([]byte(`{"status":"degraded","error":"` + err.Error() + `"}`))
			return
		}
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(`{"status":"ok"}`))
	})
}
