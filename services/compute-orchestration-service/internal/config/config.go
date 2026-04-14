package config

import (
	"os"
	"strconv"
)

type Config struct {
	Port                    string
	WorkerCount             int
	QueueBufferSize         int
	DatabaseURL             string
	ComputeServiceURL       string
	GeoServiceURL           string
	GraphServiceURL         string
	OptimizationServiceURL  string
	SimulationServiceURL    string
	MLInferenceServiceURL   string
	PlotSheetServiceURL     string
	StructuralServiceURL    string
	ProtectionServiceURL    string
	CommissioningServiceURL string
}

func Load() Config {
	cfg := Config{
		Port:                    envOrDefault("PORT", ":50059"),
		WorkerCount:             envIntOrDefault("WORKER_COUNT", 2),
		QueueBufferSize:         envIntOrDefault("QUEUE_BUFFER_SIZE", 256),
		DatabaseURL:             os.Getenv("DATABASE_URL"),
		ComputeServiceURL:       envOrDefault("COMPUTE_SERVICE_URL", "http://127.0.0.1:50051"),
		GeoServiceURL:           os.Getenv("GEO_SERVICE_URL"),
		GraphServiceURL:         os.Getenv("GRAPH_SERVICE_URL"),
		OptimizationServiceURL:  os.Getenv("OPTIMIZATION_SERVICE_URL"),
		SimulationServiceURL:    os.Getenv("SIMULATION_SERVICE_URL"),
		MLInferenceServiceURL:   os.Getenv("ML_INFERENCE_SERVICE_URL"),
		PlotSheetServiceURL:     os.Getenv("PLOT_SHEET_SERVICE_URL"),
		StructuralServiceURL:    os.Getenv("STRUCTURAL_SERVICE_URL"),
		ProtectionServiceURL:    os.Getenv("PROTECTION_SERVICE_URL"),
		CommissioningServiceURL: os.Getenv("COMMISSIONING_SERVICE_URL"),
	}
	if cfg.WorkerCount < 1 {
		cfg.WorkerCount = 1
	}
	if cfg.QueueBufferSize < 16 {
		cfg.QueueBufferSize = 16
	}
	return cfg
}

func envOrDefault(key, fallback string) string {
	v := os.Getenv(key)
	if v == "" {
		return fallback
	}
	return v
}

func envIntOrDefault(key string, fallback int) int {
	v := os.Getenv(key)
	if v == "" {
		return fallback
	}
	n, err := strconv.Atoi(v)
	if err != nil {
		return fallback
	}
	return n
}
