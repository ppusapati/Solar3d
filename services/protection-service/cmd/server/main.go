package main

import (
	"context"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"
	protectionv1connect "github.com/solar3d/solar3d/gen/protection/v1/protectionv1connect"

	"solar3d/protection-service/internal/config"
	"solar3d/protection-service/internal/handler"
	"solar3d/protection-service/internal/repository"
	"solar3d/protection-service/internal/service"
)

func main() {
	logger := zerolog.New(os.Stdout).With().Timestamp().Str("service", "protection-service").Logger()

	cfg, err := config.Load()
	if err != nil {
		logger.Fatal().Err(err).Msg("config load failed")
	}

	pool, err := pgxpool.New(context.Background(), cfg.DatabaseURL)
	if err != nil {
		logger.Fatal().Err(err).Msg("database connect failed")
	}
	defer pool.Close()

	repo := repository.New(pool)
	if err := repo.MigrateSchema(context.Background()); err != nil {
		logger.Fatal().Err(err).Msg("schema migration failed")
	}

	svc := service.New(repo)
	h := handler.New(svc, logger)

	mux := http.NewServeMux()
	h.RegisterRoutes(mux)
	connectPath, connectHandler := protectionv1connect.NewProtectionServiceHandler(handler.NewConnectProtectionService(svc))
	mux.Handle(connectPath, connectHandler)

	srv := &http.Server{
		Addr:         ":" + cfg.Port,
		Handler:      mux,
		ReadTimeout:  30 * time.Second,
		WriteTimeout: 60 * time.Second,
	}

	go func() {
		logger.Info().Str("addr", srv.Addr).Msg("protection-service listening")
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logger.Fatal().Err(err).Msg("server error")
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		logger.Error().Err(err).Msg("shutdown error")
	}
	logger.Info().Msg("protection-service stopped")
}
