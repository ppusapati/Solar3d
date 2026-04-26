package main

import (
	"context"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	reportv1connect "p9e.in/samavaya/solar3d/gen/report/v1/reportv1connect"

	"p9e.in/samavaya/solar3d/report-service/internal/config"
	"p9e.in/samavaya/solar3d/report-service/internal/db"
	"p9e.in/samavaya/solar3d/report-service/internal/handler"
	"p9e.in/samavaya/solar3d/report-service/internal/repository"
	"p9e.in/samavaya/solar3d/report-service/internal/service"
	mw "p9e.in/samavaya/packages/httpmiddleware"
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

	logger.Info().Str("port", cfg.Port).Msg("starting report-service")

	// ── Database ──────────────────────────────────────────────────────────
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	pool, err := db.NewPool(ctx, cfg.DatabaseURL)
	if err != nil {
		logger.Fatal().Err(err).Msg("failed to connect to database")
	}
	defer pool.Close()

	// ── Application layers ────────────────────────────────────────────────
	repo := repository.NewReportRepository(pool)
	svc := service.NewReportService(repo)
	h := handler.NewReportHandler(svc)

	// ── HTTP Server ───────────────────────────────────────────────────────
	mux := http.NewServeMux()
	h.RegisterRoutes(mux)
	connectPath, connectHandler := reportv1connect.NewReportServiceHandler(handler.NewConnectReportService(svc))
	mux.Handle(connectPath, connectHandler)

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

	srv := &http.Server{
		Addr:              ":" + cfg.Port,
		Handler:           chain(mux),
		ReadHeaderTimeout: 10 * time.Second,
		ReadTimeout:       15 * time.Second,
		WriteTimeout:      60 * time.Second,
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
		if err != nil && err != http.ErrServerClosed {
			logger.Error().Err(err).Msg("server error")
		}
	}

	shutdownCtx, shutdownCancel := context.WithTimeout(ctx, 15*time.Second)
	defer shutdownCancel()

	if err := srv.Shutdown(shutdownCtx); err != nil {
		logger.Error().Err(err).Msg("forced shutdown")
	}
	logger.Info().Msg("server stopped")
}

