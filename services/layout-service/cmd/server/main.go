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
	"github.com/rs/zerolog/log"

	"github.com/solar3d/solar3d/services/layout-service/internal/config"
	"github.com/solar3d/solar3d/services/layout-service/internal/handler"
	"github.com/solar3d/solar3d/services/layout-service/internal/repository"
	"github.com/solar3d/solar3d/services/layout-service/internal/service"
)

func main() {
	cfg := config.Load()

	level, err := zerolog.ParseLevel(cfg.LogLevel)
	if err != nil {
		level = zerolog.InfoLevel
	}
	zerolog.SetGlobalLevel(level)
	log.Logger = zerolog.New(os.Stdout).With().
		Timestamp().
		Str("service", "layout-service").
		Logger()

	log.Info().
		Int("port", cfg.Port).
		Float64("tile_size_m", cfg.TileSize).
		Msg("starting layout-service")

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// Database connection pool.
	poolCfg, err := pgxpool.ParseConfig(cfg.DatabaseURL)
	if err != nil {
		log.Fatal().Err(err).Msg("failed to parse database URL")
	}
	poolCfg.MaxConns = 20
	poolCfg.MinConns = 4

	pool, err := pgxpool.NewWithConfig(ctx, poolCfg)
	if err != nil {
		log.Fatal().Err(err).Msg("failed to create database pool")
	}
	defer pool.Close()

	if err := pool.Ping(ctx); err != nil {
		log.Fatal().Err(err).Msg("failed to ping database")
	}
	log.Info().Msg("database connection established")

	// Wire up layers.
	repo := repository.New(pool)
	svc := service.New(repo, cfg)
	h := handler.New(svc)

	mux := http.NewServeMux()
	h.RegisterRoutes(mux)

	// Health check.
	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, r *http.Request) {
		if err := pool.Ping(r.Context()); err != nil {
			http.Error(w, "database unreachable", http.StatusServiceUnavailable)
			return
		}
		w.WriteHeader(http.StatusOK)
		fmt.Fprintln(w, `{"status":"ok"}`)
	})

	server := &http.Server{
		Addr:         fmt.Sprintf(":%d", cfg.Port),
		Handler:      mux,
		ReadTimeout:  30 * time.Second,
		WriteTimeout: 120 * time.Second,
		IdleTimeout:  120 * time.Second,
	}

	// Graceful shutdown.
	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, syscall.SIGINT, syscall.SIGTERM)

	go func() {
		log.Info().Str("addr", server.Addr).Msg("listening")
		if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatal().Err(err).Msg("server error")
		}
	}()

	sig := <-sigCh
	log.Info().Str("signal", sig.String()).Msg("shutting down")

	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer shutdownCancel()

	if err := server.Shutdown(shutdownCtx); err != nil {
		log.Error().Err(err).Msg("shutdown error")
	}
	log.Info().Msg("layout-service stopped")
}
