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

	projectv1connect "p9e.in/samavaya/solar3d/gen/project/v1/projectv1connect"

	"p9e.in/samavaya/packages/database/pgxpostgres"
	mw "p9e.in/samavaya/packages/httpmiddleware"
	"p9e.in/samavaya/solar3d/project-service/internal/config"
	"p9e.in/samavaya/solar3d/project-service/internal/handler"
	"p9e.in/samavaya/solar3d/project-service/internal/repository"
	"p9e.in/samavaya/solar3d/project-service/internal/service"
)

func main() {
	// ── Logger ────────────────────────────────────────────────────────────
	zerolog.TimeFieldFormat = time.RFC3339
	logger := zerolog.New(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: time.RFC3339}).
		With().Timestamp().Caller().Logger()

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
		Str("log_level", cfg.LogLevel).
		Msg("starting project-service")

	// ── Database ──────────────────────────────────────────────────────────
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	pool, closePool, err := pgxpostgres.NewPgxFromDSN(ctx, cfg.DatabaseURL, pgxpostgres.DefaultPoolOptions())
	if err != nil {
		logger.Fatal().Err(err).Msg("failed to initialise database pool")
	}
	defer closePool()
	logger.Info().Msg("database connection established")

	// ── Application layers ────────────────────────────────────────────────
	repo := repository.NewPgRepository(pool)
	svc := service.New(repo, logger)
	h := handler.NewProjectHandler(svc, logger)

	// ── HTTP Server ───────────────────────────────────────────────────────
	mux := http.NewServeMux()

	// Health check endpoint.
	mux.HandleFunc("GET /healthz", mw.HealthzHandler(pool))

	// Register ConnectRPC-style routes.
	h.Register(mux)
	connectPath, connectHandler := projectv1connect.NewProjectServiceHandler(handler.NewConnectProjectService(svc))
	mux.Handle(connectPath, connectHandler)

	// Apply middleware chain: Recovery → RequestID → CORS → Logging → RateLimit
	limiter := mw.NewRateLimiter(100, 200)
	chain := mw.Chain(
		mw.Recovery(logger), mw.DeprecateRESTAliases(logger),
		mw.IDempotencyKeyMiddleware,
		mw.CORS,
		mw.Logging(logger),
		limiter.Middleware,
	)

	srv := &http.Server{
		Addr:              fmt.Sprintf(":%d", cfg.Port),
		Handler:           chain(mux),
		ReadHeaderTimeout: 10 * time.Second,
		ReadTimeout:       30 * time.Second,
		WriteTimeout:      30 * time.Second,
		IdleTimeout:       120 * time.Second,
	}

	// ── Graceful shutdown ─────────────────────────────────────────────────
	errCh := make(chan error, 1)
	go func() {
		logger.Info().Str("addr", srv.Addr).Msg("listening")
		errCh <- srv.ListenAndServe()
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)

	select {
	case sig := <-quit:
		logger.Info().Str("signal", sig.String()).Msg("shutting down")
	case err := <-errCh:
		logger.Error().Err(err).Msg("server error")
	}

	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer shutdownCancel()

	if err := srv.Shutdown(shutdownCtx); err != nil {
		logger.Error().Err(err).Msg("forced shutdown")
	}
	logger.Info().Msg("server stopped")
}

