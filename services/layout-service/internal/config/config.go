package config

import (
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
}

// Load reads configuration from environment variables with sensible defaults.
func Load() *Config {
	cfg := &Config{
		Port:        8082,
		DatabaseURL: "postgres://solar3d:solar3d@localhost:5432/solar3d_layout?sslmode=disable",
		TileSize:    100.0,
		LogLevel:    "info",
	}

	if v := os.Getenv("PORT"); v != "" {
		if p, err := strconv.Atoi(v); err == nil && p > 0 {
			cfg.Port = p
		}
	}

	if v := os.Getenv("DATABASE_URL"); v != "" {
		cfg.DatabaseURL = v
	}

	if v := os.Getenv("TILE_SIZE"); v != "" {
		if ts, err := strconv.ParseFloat(v, 64); err == nil && ts > 0 {
			cfg.TileSize = ts
		}
	}

	if v := os.Getenv("LOG_LEVEL"); v != "" {
		cfg.LogLevel = v
	}

	return cfg
}
