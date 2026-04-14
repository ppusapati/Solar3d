package config

import (
	"fmt"
	"os"
	"strconv"
)

// Config holds all configuration for the layout-service.
type Config struct {
	// Port is the HTTP listen port. Default: 8082.
	Port int

	// DatabaseURL is the PostgreSQL connection string (with PostGIS).
	DatabaseURL string

	// TileSize is the spatial tile edge length in meters used when
	// partitioning panel arrays for LOD and viewport queries. Default: 100.0.
	TileSize float64

	// LogLevel controls zerolog verbosity (debug, info, warn, error). Default: info.
	LogLevel string

	// MaxPanels caps generated panel count per request to prevent OOM.
	// Set to 0 to disable the cap. Default: 200000.
	MaxPanels int
}

// Load reads configuration from environment variables with sensible defaults.
// DATABASE_URL must be set via the environment; no default credentials are embedded.
func Load() (*Config, error) {
	cfg := &Config{
		Port:      8082,
		TileSize:  100.0,
		LogLevel:  "info",
		MaxPanels: 1000000,
	}

	if v := os.Getenv("PORT"); v != "" {
		if p, err := strconv.Atoi(v); err == nil && p > 0 {
			cfg.Port = p
		}
	}

	cfg.DatabaseURL = os.Getenv("DATABASE_URL")
	if cfg.DatabaseURL == "" {
		return nil, fmt.Errorf("DATABASE_URL environment variable is required")
	}

	if v := os.Getenv("TILE_SIZE"); v != "" {
		if ts, err := strconv.ParseFloat(v, 64); err == nil && ts > 0 {
			cfg.TileSize = ts
		}
	}

	if v := os.Getenv("LOG_LEVEL"); v != "" {
		cfg.LogLevel = v
	}

	if v := os.Getenv("MAX_PANELS"); v != "" {
		if maxPanels, err := strconv.Atoi(v); err == nil && maxPanels >= 0 {
			cfg.MaxPanels = maxPanels
		}
	}

	return cfg, nil
}

