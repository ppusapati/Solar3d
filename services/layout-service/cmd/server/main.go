package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	layoutv1connect "p9e.in/samavaya/solar3d/gen/layout/v1/layoutv1connect"

	"p9e.in/samavaya/packages/database/pgxpostgres"
	mw "p9e.in/samavaya/packages/httpmiddleware"
	"p9e.in/samavaya/solar3d/layout-service/internal/config"
	"p9e.in/samavaya/solar3d/layout-service/internal/handler"
	"p9e.in/samavaya/solar3d/layout-service/internal/repository"
	"p9e.in/samavaya/solar3d/layout-service/internal/service"
)

func main() {
	// ── Logger ────────────────────────────────────────────────────────────
	zerolog.TimeFieldFormat = time.RFC3339
	logger := zerolog.New(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: time.RFC3339}).
		With().Timestamp().Caller().Logger()
	log.Logger = logger

	// ── Config ────────────────────────────────────────────────────────────
	cfg, err := config.Load()
	if err != nil {
		logger.Fatal().Err(err).Msg("failed to load configuration")
	}

	level, err := zerolog.ParseLevel(cfg.LogLevel)
	if err != nil {
		level = zerolog.InfoLevel
	}
	zerolog.SetGlobalLevel(level)

	logger.Info().
		Int("port", cfg.Port).
		Float64("tile_size_m", cfg.TileSize).
		Msg("starting layout-service")

	// ── Database ──────────────────────────────────────────────────────────
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// Database connection pool.
	pool, closePool, err := pgxpostgres.NewPgxFromDSN(ctx, cfg.DatabaseURL, pgxpostgres.DefaultPoolOptions())
	if err != nil {
		logger.Fatal().Err(err).Msg("failed to initialise database pool")
	}
	defer closePool()
	logger.Info().Msg("database connection established")

	// ── Application layers ────────────────────────────────────────────────
	repo := repository.New(pool)
	svc := service.New(repo, cfg)
	h := handler.New(svc, logger)

	// ── HTTP Server ───────────────────────────────────────────────────────
	mux := http.NewServeMux()
	h.RegisterRoutes(mux)
	connectPath, connectHandler := layoutv1connect.NewLayoutServiceHandler(handler.NewConnectLayoutService(svc))
	mux.Handle(connectPath, connectHandler)

	// Health check.
	mux.HandleFunc("GET /healthz", mw.HealthzHandler(pool))

	// Apply middleware chain: Recovery → RequestID → CORS → Logging → RateLimit
	limiter := mw.NewRateLimiter(100, 200)
	chain := mw.Chain(
		mw.Recovery(logger), mw.DeprecateRESTAliases(logger),
		mw.IDempotencyKeyMiddleware,
		mw.CORS,
		mw.Logging(logger),
		limiter.Middleware,
	)

	server := &http.Server{
		Addr:              fmt.Sprintf(":%d", cfg.Port),
		Handler:           chain(mux),
		ReadHeaderTimeout: 10 * time.Second,
		ReadTimeout:       30 * time.Second,
		WriteTimeout:      120 * time.Second,
		IdleTimeout:       120 * time.Second,
	}

	// ── Graceful shutdown ─────────────────────────────────────────────────
	errCh := make(chan error, 1)
	go func() {
		logger.Info().Str("addr", server.Addr).Msg("listening")
		errCh <- server.ListenAndServe()
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)

	select {
	case sig := <-quit:
		logger.Info().Str("signal", sig.String()).Msg("shutting down")
	case err := <-errCh:
		if err != nil && err != http.ErrServerClosed {
			logger.Error().Err(err).Msg("server error")
		}
	}

	shutdownCtx, shutdownCancel := context.WithTimeout(ctx, 15*time.Second)
	defer shutdownCancel()

	if err := server.Shutdown(shutdownCtx); err != nil {
		logger.Error().Err(err).Msg("forced shutdown")
	}
	logger.Info().Msg("layout-service stopped")
}

