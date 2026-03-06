package config

import (
	"fmt"
	"os"
	"strconv"
)

// Config holds all configuration for the terrain service.
type Config struct {
	Port        int    `json:"port"`
	DatabaseURL string `json:"database_url"`
	S3Endpoint  string `json:"s3_endpoint"`
	S3Bucket    string `json:"s3_bucket"`
	LogLevel    string `json:"log_level"`
}

// Load reads configuration from environment variables with sensible defaults.
func Load() (*Config, error) {
	cfg := &Config{
		Port:        8081,
		DatabaseURL: getEnv("DATABASE_URL", "postgres://postgres:postgres@localhost:5432/solar3d?sslmode=disable"),
		S3Endpoint:  getEnv("S3_ENDPOINT", "http://localhost:9000"),
		S3Bucket:    getEnv("S3_BUCKET", "terrain-data"),
		LogLevel:    getEnv("LOG_LEVEL", "info"),
	}

	if portStr := os.Getenv("PORT"); portStr != "" {
		p, err := strconv.Atoi(portStr)
		if err != nil {
			return nil, fmt.Errorf("invalid PORT %q: %w", portStr, err)
		}
		if p < 1 || p > 65535 {
			return nil, fmt.Errorf("PORT %d out of range 1-65535", p)
		}
		cfg.Port = p
	}

	if cfg.DatabaseURL == "" {
		return nil, fmt.Errorf("DATABASE_URL is required")
	}

	return cfg, nil
}

// Addr returns the listen address string for the HTTP server.
func (c *Config) Addr() string {
	return fmt.Sprintf(":%d", c.Port)
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}
