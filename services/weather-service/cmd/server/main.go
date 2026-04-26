package main

import (
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/rs/zerolog"

	mw "p9e.in/samavaya/packages/httpmiddleware"
	weatherv1connect "p9e.in/samavaya/solar3d/gen/weather/v1/weatherv1connect"

	"p9e.in/samavaya/solar3d/weather-service/internal/adapter/era5"
	"p9e.in/samavaya/solar3d/weather-service/internal/adapter/nasapower"
	"p9e.in/samavaya/solar3d/weather-service/internal/adapter/nsrdb"
	"p9e.in/samavaya/solar3d/weather-service/internal/adapter/pvgis"
	"p9e.in/samavaya/solar3d/weather-service/internal/config"
	"p9e.in/samavaya/solar3d/weather-service/internal/handler"
	"p9e.in/samavaya/solar3d/weather-service/internal/repository"
	"p9e.in/samavaya/solar3d/weather-service/internal/tmy"
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
	logger.Info().Int("port", cfg.Port).Msg("starting weather-service")

	// ── Application layers ────────────────────────────────────────────────
	repo := repository.New()

	adapters := []handler.Adapter{
		pvgis.New(),
		nasapower.New(),
		nsrdb.New(),
		era5.New(),
	}
	parsers := []handler.TMYParser{
		tmy.NewEPWParser(),
		tmy.NewTM2Parser(),
		tmy.NewTM3Parser(),
		tmy.NewCSVParser(),
	}

	svc := handler.NewWeatherService(repo, adapters, parsers, logger)
	connectSvc := handler.NewConnectWeatherService(svc)

	// ── HTTP Server ───────────────────────────────────────────────────────
	mux := http.NewServeMux()

	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(`{"status":"ok"}`))
	})

	connectPath, connectHandler := weatherv1connect.NewWeatherServiceHandler(connectSvc)
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
		WriteTimeout:      120 * time.Second, // weather fetches can be slow
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

	logger.Info().Msg("weather-service stopped")
}
