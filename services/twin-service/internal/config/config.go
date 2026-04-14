package config

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

// Config holds all runtime configuration for twin-service.
type Config struct {
	Port        int
	DatabaseURL string
	LogLevel    string
	ReadTimeout time.Duration
}

// Load reads configuration from environment variables with safe defaults.
func Load() (*Config, error) {
	cfg := &Config{
		Port:        8100,
		LogLevel:    "info",
		ReadTimeout: 30 * time.Second,
	}

	if value := os.Getenv("PORT"); value != "" {
		port, err := strconv.Atoi(value)
		if err != nil {
			return nil, fmt.Errorf("invalid PORT %q: %w", value, err)
		}
		cfg.Port = port
	}

	cfg.DatabaseURL = os.Getenv("DATABASE_URL")
	if cfg.DatabaseURL == "" {
		return nil, fmt.Errorf("DATABASE_URL is required")
	}

	if value := os.Getenv("LOG_LEVEL"); value != "" {
		cfg.LogLevel = value
	}

	return cfg, nil
}
