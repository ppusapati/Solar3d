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
	drawingv1connect "github.com/solar3d/solar3d/gen/drawing/v1/drawingv1connect"
	projectv1connect "github.com/solar3d/solar3d/gen/project/v1/projectv1connect"

	"solar3d/api-gateway-service/internal/config"
	"solar3d/api-gateway-service/internal/handler"
	"solar3d/api-gateway-service/internal/service"
	mw "solar3d/shared/middleware"
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

	httpClient := &http.Client{Timeout: cfg.RequestTimeout}
	projects := projectv1connect.NewProjectServiceClient(httpClient, cfg.ProjectServiceURL)
	drawings := drawingv1connect.NewDrawingRevisionServiceClient(httpClient, cfg.DrawingRevisionURL)
	cad := drawingv1connect.NewCadCoreServiceClient(httpClient, cfg.CadCoreURL)
	annotation := drawingv1connect.NewCadAnnotationServiceClient(httpClient, cfg.CadAnnotationURL)
	layerBlock := drawingv1connect.NewCadLayerBlockServiceClient(httpClient, cfg.CadLayerBlockURL)
	interop := drawingv1connect.NewInteropServiceClient(httpClient, cfg.InteropURL)
	plotSheet := drawingv1connect.NewPlotSheetServiceClient(httpClient, cfg.PlotSheetURL)

	svc := service.New(projects, drawings, cad, annotation, layerBlock, interop, plotSheet, httpClient, cfg.ProjectServiceURL, cfg.DrawingRevisionURL, cfg.CadCoreURL, cfg.CadAnnotationURL, cfg.CadLayerBlockURL, cfg.InteropURL, cfg.PlotSheetURL, cfg.RequestTimeout, logger)
	h := handler.New(svc)

	mux := http.NewServeMux()
	h.Register(mux)

	limiter := mw.NewRateLimiter(200, 400)
	chain := mw.Chain(
		mw.Recovery(logger),
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
		logger.Info().Int("port", cfg.Port).Msg("api gateway listening")
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

	shutdownCtx, cancel := context.WithTimeout(context.Background(), 15*time.Second)
	defer cancel()
	if err := srv.Shutdown(shutdownCtx); err != nil {
		logger.Error().Err(err).Msg("forced shutdown")
	}
}

