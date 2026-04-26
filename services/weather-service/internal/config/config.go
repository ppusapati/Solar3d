package config

import (
	"fmt"
	"os"
	"strconv"
)

type Config struct {
	Port        int
	LogLevel    string
	DatabaseURL string
	NSRDBApiKey string // NREL NSRDB — optional, enables NSRDB adapter
	ERA5ApiKey  string // ECMWF CDS  — optional, enables ERA5 adapter
}

func Load() (*Config, error) {
	port := 8088
	if v := os.Getenv("PORT"); v != "" {
		p, err := strconv.Atoi(v)
		if err != nil {
			return nil, fmt.Errorf("invalid PORT: %w", err)
		}
		port = p
	}
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		return nil, fmt.Errorf("DATABASE_URL is required")
	}
	return &Config{
		Port:        port,
		LogLevel:    envOr("LOG_LEVEL", "info"),
		DatabaseURL: dbURL,
		NSRDBApiKey: os.Getenv("NSRDB_API_KEY"),
		ERA5ApiKey:  os.Getenv("ERA5_API_KEY"),
	}, nil
}

func envOr(key, def string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return def
}
