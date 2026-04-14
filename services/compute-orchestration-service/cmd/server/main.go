package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	orchestrationv1connect "github.com/solar3d/solar3d/gen/orchestration/v1/orchestrationv1connect"

	"solar3d/compute-orchestration-service/internal/config"
	"solar3d/compute-orchestration-service/internal/executor"
	"solar3d/compute-orchestration-service/internal/handler"
	"solar3d/compute-orchestration-service/internal/repository"
	"solar3d/compute-orchestration-service/internal/service"
)

func main() {
	cfg := config.Load()

	var repo repository.Store
	var cleanup func()
	if cfg.DatabaseURL != "" {
		pgRepo, err := repository.NewPostgresRepository(context.Background(), cfg.DatabaseURL)
		if err != nil {
			log.Fatalf("failed to initialize postgres repository: %v", err)
		}
		repo = pgRepo
		cleanup = pgRepo.Close
		log.Println("Using postgres-backed repository")
	} else {
		repo = repository.NewInMemoryRepository()
		cleanup = func() {}
		log.Println("Using in-memory repository")
	}
	defer cleanup()

	exec := executor.NewComputeExecutor(executor.Endpoints{
		ComputeBaseURL:      cfg.ComputeServiceURL,
		GeoServiceURL:       cfg.GeoServiceURL,
		GraphServiceURL:     cfg.GraphServiceURL,
		OptimizationURL:     cfg.OptimizationServiceURL,
		SimulationURL:       cfg.SimulationServiceURL,
		MLInferenceURL:      cfg.MLInferenceServiceURL,
		PlotSheetServiceURL: cfg.PlotSheetServiceURL,
		StructuralURL:       cfg.StructuralServiceURL,
		ProtectionURL:       cfg.ProtectionServiceURL,
		CommissioningURL:    cfg.CommissioningServiceURL,
	}, nil)
	svc := service.New(repo, exec, cfg.WorkerCount, cfg.QueueBufferSize)
	svc.Start()
	defer svc.Stop()

	h := handler.NewConnectHandler(svc)
	mux := http.NewServeMux()
	path, connectHandler := orchestrationv1connect.NewComputeOrchestrationServiceHandler(h)
	mux.Handle(path, connectHandler)
	mux.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		ctx, cancel := context.WithTimeout(r.Context(), 2*time.Second)
		defer cancel()
		if err := svc.Health(ctx); err != nil {
			w.WriteHeader(http.StatusServiceUnavailable)
			_ = json.NewEncoder(w).Encode(map[string]string{"status": "degraded", "error": err.Error()})
			return
		}
		w.WriteHeader(http.StatusOK)
		_ = json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
	})
	mux.HandleFunc("/metrics", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(svc.SnapshotMetrics())
	})

	httpServer := &http.Server{
		Addr:         cfg.Port,
		Handler:      http.MaxBytesHandler(mux, 32*1024*1024),
		ReadTimeout:  30 * time.Second,
		WriteTimeout: 30 * time.Second,
		IdleTimeout:  120 * time.Second,
	}

	log.Printf("Compute Orchestration Service listening on %s (workers=%d queue=%d)", cfg.Port, cfg.WorkerCount, cfg.QueueBufferSize)

	go func() {
		if err := httpServer.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("failed to serve: %v", err)
		}
	}()

	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, syscall.SIGINT, syscall.SIGTERM)
	<-sigCh

	log.Println("Shutting down compute orchestration service...")
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	if err := httpServer.Shutdown(ctx); err != nil {
		log.Fatalf("shutdown error: %v", err)
	}
}
