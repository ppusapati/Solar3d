package config

import (
	"fmt"
	"os"
	"strings"
)

type Config struct {
	Port              string
	DatabaseURL       string
	TerrainBridgeURL  string
	TerrainServiceURL string
	ProjectServiceURL string
	LogLevel          string
}

// requiredInProduction enumerates env vars that must be set explicitly when
// SOLAR3D_ENV=production. The localhost defaults below are only acceptable
// for local development and CI.
var requiredInProduction = []string{
	"DATABASE_URL",
	"TERRAIN_BRIDGE_URL",
	"TERRAIN_SERVICE_URL",
	"PROJECT_SERVICE_URL",
}

func Load() (*Config, error) {
	cfg := &Config{
		Port:              getEnv("PORT", "8098"),
		DatabaseURL:       getEnv("DATABASE_URL", ""),
		TerrainBridgeURL:  getEnv("TERRAIN_BRIDGE_URL", "http://127.0.0.1:8084"),
		TerrainServiceURL: getEnv("TERRAIN_SERVICE_URL", "http://127.0.0.1:8081"),
		ProjectServiceURL: getEnv("PROJECT_SERVICE_URL", "http://127.0.0.1:8080"),
		LogLevel:          getEnv("LOG_LEVEL", "info"),
	}

	if cfg.DatabaseURL == "" {
		return nil, fmt.Errorf("DATABASE_URL environment variable is required")
	}

	if strings.EqualFold(os.Getenv("SOLAR3D_ENV"), "production") {
		var missing []string
		for _, name := range requiredInProduction {
			if v, ok := os.LookupEnv(name); !ok || v == "" {
				missing = append(missing, name)
			}
		}
		if len(missing) > 0 {
			return nil, fmt.Errorf("SOLAR3D_ENV=production but required env vars unset: %s", strings.Join(missing, ", "))
		}
	}

	return cfg, nil
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}
