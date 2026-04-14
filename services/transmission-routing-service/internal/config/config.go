package config

import (
	"fmt"
	"os"
)

type Config struct {
	Port              string
	DatabaseURL       string
	TerrainBridgeURL  string
	TerrainServiceURL string
	ProjectServiceURL string
	LogLevel          string
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

	return cfg, nil
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}
