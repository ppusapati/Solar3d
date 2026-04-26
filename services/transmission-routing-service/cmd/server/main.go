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
	transmissionv1connect "p9e.in/samavaya/solar3d/gen/transmission/v1/transmissionv1connect"

	mw "p9e.in/samavaya/packages/httpmiddleware"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/config"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/db"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/handler"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/repository"
	"p9e.in/samavaya/solar3d/transmission-routing-service/internal/service"
)

func main() {
	zerolog.TimeFieldFormat = time.RFC3339
	logger := zerolog.New(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: time.RFC3339}).
		With().Timestamp().Caller().Logger()
	log.Logger = logger

	cfg, err := config.Load()
	if err != nil {
		logger.Fatal().Err(err).Msg("failed to load configuration")
	}

	level, err := zerolog.ParseLevel(cfg.LogLevel)
	if err != nil {
		level = zerolog.InfoLevel
	}
	zerolog.SetGlobalLevel(level)

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	pool, err := db.NewPool(ctx, cfg.DatabaseURL)
	if err != nil {
		logger.Fatal().Err(err).Msg("failed to connect to database")
	}
	defer pool.Close()

	if err := db.EnsureSchema(ctx, pool); err != nil {
		logger.Fatal().Err(err).Msg("failed to ensure transmission schema")
	}

	repo := repository.New(db.New(pool))
	svc := service.NewTransmissionService(repo, cfg.TerrainBridgeURL, cfg.TerrainServiceURL, cfg.ProjectServiceURL)
	connectHandler := handler.NewConnectTransmissionRoutingService(svc)

	mux := http.NewServeMux()
	connectPath, connectSvcHandler := transmissionv1connect.NewTransmissionRoutingServiceHandler(connectHandler)
	mux.Handle(connectPath, connectSvcHandler)
	mux.HandleFunc("GET /healthz", mw.HealthzHandler(pool))

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
}
