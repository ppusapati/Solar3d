package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"

	"github.com/solar3d/solar3d/services/terrain-service/internal/config"
	"github.com/solar3d/solar3d/services/terrain-service/internal/handler"
	"github.com/solar3d/solar3d/services/terrain-service/internal/repository"
	"github.com/solar3d/solar3d/services/terrain-service/internal/service"
)

func main() {
	if err := run(); err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
}

func run() error {
	// Load configuration.
	cfg, err := config.Load()
	if err != nil {
		return fmt.Errorf("load config: %w", err)
	}

	// Initialize structured logger.
	level, err := zerolog.ParseLevel(cfg.LogLevel)
	if err != nil {
		level = zerolog.InfoLevel
	}
	logger := zerolog.New(os.Stdout).
		Level(level).
		With().
		Timestamp().
		Str("service", "terrain-service").
		Logger()

	logger.Info().
		Int("port", cfg.Port).
		Str("log_level", cfg.LogLevel).
		Msg("starting terrain service")

	// Create database connection pool.
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	poolConfig, err := pgxpool.ParseConfig(cfg.DatabaseURL)
	if err != nil {
		return fmt.Errorf("parse database url: %w", err)
	}
	poolConfig.MaxConns = 20
	poolConfig.MinConns = 2

	pool, err := pgxpool.NewWithConfig(ctx, poolConfig)
	if err != nil {
		return fmt.Errorf("create connection pool: %w", err)
	}
	defer pool.Close()

	// Verify database connectivity.
	if err := pool.Ping(ctx); err != nil {
		return fmt.Errorf("ping database: %w", err)
	}
	logger.Info().Msg("database connection established")

	// Initialize layers: repository -> service -> handler.
	repo := repository.New(pool, logger)
	svc := service.New(repo, logger)
	h := handler.New(svc, logger)

	// Build HTTP server.
	mux := http.NewServeMux()

	// Health check endpoint.
	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(`{"status":"ok"}`))
	})

	// Register terrain API routes.
	h.RegisterRoutes(mux)

	server := &http.Server{
		Addr:         cfg.Addr(),
		Handler:      mux,
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 30 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	// Graceful shutdown.
	shutdownCh := make(chan os.Signal, 1)
	signal.Notify(shutdownCh, syscall.SIGINT, syscall.SIGTERM)

	errCh := make(chan error, 1)
	go func() {
		logger.Info().Str("addr", server.Addr).Msg("HTTP server listening")
		if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			errCh <- fmt.Errorf("http server: %w", err)
		}
	}()

	select {
	case sig := <-shutdownCh:
		logger.Info().Str("signal", sig.String()).Msg("shutdown signal received")
	case err := <-errCh:
		return err
	}

	// Allow 10 seconds for in-flight requests to complete.
	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer shutdownCancel()

	if err := server.Shutdown(shutdownCtx); err != nil {
		return fmt.Errorf("server shutdown: %w", err)
	}

	logger.Info().Msg("terrain service stopped")
	return nil
}
