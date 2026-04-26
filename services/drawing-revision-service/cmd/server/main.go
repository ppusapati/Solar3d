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
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"

	"p9e.in/samavaya/packages/database/pgxpostgres"
	mw "p9e.in/samavaya/packages/httpmiddleware"
	"p9e.in/samavaya/solar3d/drawing-revision-service/internal/config"
	"p9e.in/samavaya/solar3d/drawing-revision-service/internal/handler"
	"p9e.in/samavaya/solar3d/drawing-revision-service/internal/repository"
	"p9e.in/samavaya/solar3d/drawing-revision-service/internal/service"
)

func main() {
	zerolog.TimeFieldFormat = time.RFC3339
	logger := zerolog.New(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: time.RFC3339}).With().Timestamp().Caller().Logger()

	cfg, err := config.Load()
	if err != nil {
		logger.Fatal().Err(err).Msg("failed to load configuration")
	}

	level, err := zerolog.ParseLevel(cfg.LogLevel)
	if err != nil {
		level = zerolog.InfoLevel
	}
	zerolog.SetGlobalLevel(level)

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	pool, closePool, err := pgxpostgres.NewPgxFromDSN(ctx, cfg.DatabaseURL, pgxpostgres.DefaultPoolOptions())
	if err != nil {
		logger.Fatal().Err(err).Msg("failed to initialise database pool")
	}
	defer closePool()

	repo := repository.NewPgRepository(pool)
	serviceCtx, serviceCancel := context.WithCancel(context.Background())
	defer serviceCancel()
	startIntegrityAuditLoop(serviceCtx, logger, cfg, repo)
	svc := service.New(repo, logger)
	h := handler.NewConnectDrawingRevisionService(svc)

	mux := http.NewServeMux()
	mux.HandleFunc("GET /healthz", mw.HealthzHandler(pool))

	connectPath, connectHandler := drawingv1connect.NewDrawingRevisionServiceHandler(h)
	mux.Handle(connectPath, connectHandler)

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

	errCh := make(chan error, 1)
	go func() {
		logger.Info().Int("port", cfg.Port).Msg("drawing revision service listening")
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
	serviceCancel()

	shutdownCtx, shutdownCancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer shutdownCancel()

	if err := srv.Shutdown(shutdownCtx); err != nil {
		logger.Error().Err(err).Msg("forced shutdown")
	}
	logger.Info().Msg("server stopped")
}

