package config

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

type Config struct {
	Port               int
	DrawingRevisionURL string
	CadCoreURL         string
	LogLevel           string
	RequestTimeout     time.Duration
}

func Load() (*Config, error) {
	cfg := &Config{
		Port:               8093,
		DrawingRevisionURL: "http://127.0.0.1:8091",
		CadCoreURL:         "http://127.0.0.1:8092",
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
	if value := os.Getenv("DRAWING_REVISION_URL"); value != "" {
		cfg.DrawingRevisionURL = value
	}
	if value := os.Getenv("CAD_CORE_URL"); value != "" {
		cfg.CadCoreURL = value
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

