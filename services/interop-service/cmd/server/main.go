package main

import (
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/rs/zerolog"
	drawingv1connect "p9e.in/samavaya/solar3d/gen/drawing/v1/drawingv1connect"

	"p9e.in/samavaya/solar3d/interop-service/internal/config"
	"p9e.in/samavaya/solar3d/interop-service/internal/handler"
	"p9e.in/samavaya/solar3d/interop-service/internal/service"
	mw "p9e.in/samavaya/packages/httpmiddleware"
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
	revisions := drawingv1connect.NewDrawingRevisionServiceClient(httpClient, cfg.DrawingRevisionURL)
	cadClient := drawingv1connect.NewCadCoreServiceClient(httpClient, cfg.CadCoreURL)
	svc := service.New(revisions, cadClient, logger, cfg.RequestTimeout)
	h := handler.NewConnectInteropService(svc)

	mux := http.NewServeMux()
	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(`{"status":"ok"}`))
	})
	path, connectHandler := drawingv1connect.NewInteropServiceHandler(h)
	mux.Handle(path, connectHandler)

	chain := mw.Chain(mw.Recovery(logger), mw.DeprecateRESTAliases(logger), mw.IDempotencyKeyMiddleware, mw.CORS, mw.Logging(logger), mw.NewRateLimiter(60, 120).Middleware)
	srv := &http.Server{Addr: fmt.Sprintf(":%d", cfg.Port), Handler: chain(mux), ReadHeaderTimeout: 10 * time.Second, ReadTimeout: 60 * time.Second, WriteTimeout: 60 * time.Second, IdleTimeout: 120 * time.Second}

	errCh := make(chan error, 1)
	go func() {
		logger.Info().Int("port", cfg.Port).Msg("interop service listening")
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
	if err := srv.Close(); err != nil {
		logger.Error().Err(err).Msg("failed to close server")
	}
}

