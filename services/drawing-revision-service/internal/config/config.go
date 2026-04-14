package config

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

// Config holds runtime configuration for the drawing revision service.
type Config struct {
	Port                       int
	DatabaseURL                string
	LogLevel                   string
	IntegrityAuditEnabled      bool
	IntegrityAuditInterval     time.Duration
	IntegrityAuditBatchSize    int
	IntegrityAuditStartupDelay time.Duration
}

// Load reads service configuration from environment variables.
func Load() (*Config, error) {
	cfg := &Config{
		Port:                       8091,
		LogLevel:                   "info",
		IntegrityAuditEnabled:      true,
		IntegrityAuditInterval:     5 * time.Minute,
		IntegrityAuditBatchSize:    250,
		IntegrityAuditStartupDelay: 30 * time.Second,
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
		return nil, fmt.Errorf("DATABASE_URL environment variable is required")
	}

	if value := os.Getenv("LOG_LEVEL"); value != "" {
		cfg.LogLevel = value
	}

	if value := os.Getenv("INTEGRITY_AUDIT_ENABLED"); value != "" {
		enabled, err := strconv.ParseBool(value)
		if err != nil {
			return nil, fmt.Errorf("invalid INTEGRITY_AUDIT_ENABLED %q: %w", value, err)
		}
		cfg.IntegrityAuditEnabled = enabled
	}

	if value := os.Getenv("INTEGRITY_AUDIT_INTERVAL"); value != "" {
		interval, err := time.ParseDuration(value)
		if err != nil {
			return nil, fmt.Errorf("invalid INTEGRITY_AUDIT_INTERVAL %q: %w", value, err)
		}
		if interval <= 0 {
			return nil, fmt.Errorf("INTEGRITY_AUDIT_INTERVAL must be greater than zero")
		}
		cfg.IntegrityAuditInterval = interval
	}

	if value := os.Getenv("INTEGRITY_AUDIT_BATCH_SIZE"); value != "" {
		batchSize, err := strconv.Atoi(value)
		if err != nil {
			return nil, fmt.Errorf("invalid INTEGRITY_AUDIT_BATCH_SIZE %q: %w", value, err)
		}
		if batchSize <= 0 {
			return nil, fmt.Errorf("INTEGRITY_AUDIT_BATCH_SIZE must be greater than zero")
		}
		cfg.IntegrityAuditBatchSize = batchSize
	}

	if value := os.Getenv("INTEGRITY_AUDIT_STARTUP_DELAY"); value != "" {
		startupDelay, err := time.ParseDuration(value)
		if err != nil {
			return nil, fmt.Errorf("invalid INTEGRITY_AUDIT_STARTUP_DELAY %q: %w", value, err)
		}
		if startupDelay < 0 {
			return nil, fmt.Errorf("INTEGRITY_AUDIT_STARTUP_DELAY cannot be negative")
		}
		cfg.IntegrityAuditStartupDelay = startupDelay
	}

	return cfg, nil
}

