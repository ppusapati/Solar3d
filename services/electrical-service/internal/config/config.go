package config

import (
	"fmt"
	"os"
)

type Config struct {
	Port             string
	DatabaseURL      string
	OrchestrationURL string
	LogLevel         string
}

func Load() (*Config, error) {
	cfg := &Config{
		Port:             getEnv("PORT", "8084"),
		DatabaseURL:      getEnv("DATABASE_URL", ""),
		OrchestrationURL: getEnv("ORCHESTRATION_URL", "http://127.0.0.1:50059"),
		LogLevel:         getEnv("LOG_LEVEL", "info"),
	}

	if cfg.DatabaseURL == "" {
		return nil, fmt.Errorf("DATABASE_URL environment variable is required")
	}

	return cfg, nil
}

func getEnv(key, fallback string) string {
	if val, ok := os.LookupEnv(key); ok {
		return val
	}
	return fallback
}

