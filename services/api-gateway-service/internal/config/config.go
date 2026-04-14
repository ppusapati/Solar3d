package config

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

type Config struct {
	Port               int
	ProjectServiceURL  string
	DrawingRevisionURL string
	CadCoreURL         string
	CadAnnotationURL   string
	CadLayerBlockURL   string
	InteropURL         string
	PlotSheetURL       string
	TwinServiceURL     string
	LogLevel           string
	RequestTimeout     time.Duration
}

func Load() (*Config, error) {
	cfg := &Config{
		Port:               8090,
		ProjectServiceURL:  "http://127.0.0.1:8080",
		DrawingRevisionURL: "http://127.0.0.1:8091",
		CadCoreURL:         "http://127.0.0.1:8092",
		CadAnnotationURL:   "http://127.0.0.1:8093",
		CadLayerBlockURL:   "http://127.0.0.1:8094",
		InteropURL:         "http://127.0.0.1:8095",
		PlotSheetURL:       "http://127.0.0.1:8096",
		TwinServiceURL:     "http://127.0.0.1:8100",
		LogLevel:           "info",
		RequestTimeout:     15 * time.Second,
	}

	if value := os.Getenv("PORT"); value != "" {
		port, err := strconv.Atoi(value)
		if err != nil {
			return nil, fmt.Errorf("invalid PORT %q: %w", value, err)
		}
		cfg.Port = port
	}
	if value := os.Getenv("PROJECT_SERVICE_URL"); value != "" {
		cfg.ProjectServiceURL = value
	}
	if value := os.Getenv("DRAWING_REVISION_URL"); value != "" {
		cfg.DrawingRevisionURL = value
	}
	if value := os.Getenv("CAD_CORE_URL"); value != "" {
		cfg.CadCoreURL = value
	}
	if value := os.Getenv("CAD_ANNOTATION_URL"); value != "" {
		cfg.CadAnnotationURL = value
	}
	if value := os.Getenv("CAD_LAYER_BLOCK_URL"); value != "" {
		cfg.CadLayerBlockURL = value
	}
	if value := os.Getenv("INTEROP_URL"); value != "" {
		cfg.InteropURL = value
	}
	if value := os.Getenv("PLOT_SHEET_URL"); value != "" {
		cfg.PlotSheetURL = value
	}
	if value := os.Getenv("TWIN_SERVICE_URL"); value != "" {
		cfg.TwinServiceURL = value
	}
	if value := os.Getenv("LOG_LEVEL"); value != "" {
		cfg.LogLevel = value
	}
	if value := os.Getenv("REQUEST_TIMEOUT_SECONDS"); value != "" {
		seconds, err := strconv.Atoi(value)
		if err != nil || seconds <= 0 {
			return nil, fmt.Errorf("invalid REQUEST_TIMEOUT_SECONDS %q", value)
		}
		cfg.RequestTimeout = time.Duration(seconds) * time.Second
	}
	return cfg, nil
}
