// Package main implements a monolithic server that combines all Solar3D services
// onto a single port using ConnectRPC, in-process databases, and Rust bridges for compute.
//
// Usage: go run ./services/monolith [flags]
//
// Environment variables:
//
//	DATABASE_URL     - PostgreSQL connection string (required for services with state)
//	LOG_LEVEL        - Logging level: debug, info, warn, error (default: info)
//	MONOLITH_PORT    - Server port (default: 8080)
//	RUST_*_BRIDGE_URL - Rust compute bridge URLs (see compute-service package)
//
// All services communicate via ConnectRPC on a single HTTP/2 multiplexed connection.
// Rust compute bridges remain as external HTTP processes.
package main

import (
	"bufio"
	"context"
	"errors"
	"flag"
	"fmt"
	"net"
	"net/http"
	"net/url"
	"os"
	"os/signal"
	"path/filepath"
	"sort"
	"strings"
	"syscall"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"
	"golang.org/x/net/http2"
	"golang.org/x/net/http2/h2c"

	mw "solar3d/shared/middleware"

	// Service register packages
	apigatewayregister "solar3d/api-gateway-service/register"
	assetregister "solar3d/asset-service/register"
	cadannotationregister "solar3d/cad-annotation-service/register"
	cadcoreregister "solar3d/cad-core-service/register"
	cadlayerblockregister "solar3d/cad-layer-block-service/register"
	computeorchestrationregister "solar3d/compute-orchestration-service/register"
	computeregister "solar3d/compute-service/register"
	drawingrevisionregister "solar3d/drawing-revision-service/register"
	electricalregister "solar3d/electrical-service/register"
	geoanalyticsregister "solar3d/geo-analytics-service/register"
	graphregister "solar3d/graph-service/register"
	interopregister "solar3d/interop-service/register"
	layoutregister "solar3d/layout-service/register"
	mlregister "solar3d/ml-service/register"
	optimizationregister "solar3d/optimization-service/register"
	plotsheetregister "solar3d/plot-sheet-service/register"
	projectregister "solar3d/project-service/register"
	reportregister "solar3d/report-service/register"
	routingregister "solar3d/routing-service/register"
	simulationregister "solar3d/simulation-service/register"
	terrainregister "solar3d/terrain-service/register"
	transmissionroutingregister "solar3d/transmission-routing-service/register"
	twinregister "solar3d/twin-service/register"
)

func main() {
	// Load .env before flag parsing so PORT_MONOLITH can be used as the default port
	dotEnv, _ := loadDotEnv()

	defaultPort := firstNonEmpty(os.Getenv("PORT_MONOLITH"), dotEnv["PORT_MONOLITH"], "8080")

	// Parse flags (env-derived defaults can be overridden by explicit flags)
	port := flag.String("port", defaultPort, "server port")
	logLevelStr := flag.String("loglevel", "info", "log level: debug, info, warn, error")
	flag.Parse()

	// Set up logger
	logLevel, err := zerolog.ParseLevel(*logLevelStr)
	if err != nil {
		logLevel = zerolog.InfoLevel
	}
	zerolog.SetGlobalLevel(logLevel)
	logger := zerolog.New(zerolog.ConsoleWriter{Out: os.Stderr, TimeFormat: time.RFC3339}).
		With().Timestamp().Caller().Logger()

	// Database connection
	databaseURL := strings.TrimSpace(firstNonEmpty(os.Getenv("DATABASE_URL"), dotEnv["DATABASE_URL"]))
	if databaseURL == "" {
		// Build from component env vars
		user := firstNonEmpty(os.Getenv("POSTGRES_USER"), dotEnv["POSTGRES_USER"], "postgres")
		password := firstNonEmpty(os.Getenv("POSTGRES_PASSWORD"), dotEnv["POSTGRES_PASSWORD"], "postgres")
		host := firstNonEmpty(os.Getenv("POSTGRES_HOST"), dotEnv["POSTGRES_HOST"], "localhost")
		port := firstNonEmpty(os.Getenv("POSTGRES_PORT"), dotEnv["POSTGRES_PORT"], "5432")
		database := firstNonEmpty(os.Getenv("POSTGRES_DB"), dotEnv["POSTGRES_DB"], "postgres")
		sslMode := firstNonEmpty(os.Getenv("DB_SSLMODE"), dotEnv["DB_SSLMODE"], "disable")

		u := &url.URL{
			Scheme:   "postgres",
			Host:     net.JoinHostPort(host, port),
			Path:     "/" + database,
			RawQuery: "sslmode=" + url.QueryEscape(sslMode),
		}
		u.User = url.UserPassword(user, password)
		databaseURL = u.String()
	}

	if databaseURL == "" {
		logger.Fatal().Msg("DATABASE_URL environment variable or POSTGRES_* variables required in .env or environment")
	}

	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	poolCfg, err := pgxpool.ParseConfig(databaseURL)
	if err != nil {
		logger.Fatal().Err(err).Msg("invalid DATABASE_URL")
	}
	poolCfg.MaxConns = 50
	poolCfg.MinConns = 5
	poolCfg.MaxConnLifetime = 30 * time.Minute
	poolCfg.MaxConnIdleTime = 5 * time.Minute

	pool, err := pgxpool.NewWithConfig(ctx, poolCfg)
	if err != nil {
		logger.Fatal().Err(err).Msg("failed to create database connection pool")
	}
	defer pool.Close()

	if err := pool.Ping(ctx); err != nil {
		logger.Fatal().Err(err).Msg("failed to ping database")
	}
	logger.Info().Msg("database connected")

	if err := applyMigrations(ctx, pool, logger); err != nil {
		logger.Fatal().Err(err).Msg("failed to apply migrations")
	}

	// Create HTTP multiplexer
	mux := http.NewServeMux()

	// Healthz endpoint
	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, _ *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(`{"service":"solar3d-monolith","status":"ok"}`))
	})

	// Register all services in dependency order
	logger.Info().Msg("registering services")

	// Layer 1: Core data services (no external service deps)
	projectClient := projectregister.Register(mux, pool, logger)
	logger.Info().Msg("registered project-service")

	drawingRevClient := drawingrevisionregister.Register(mux, pool, logger)
	logger.Info().Msg("registered drawing-revision-service")

	assetregister.Register(mux, pool, logger)
	logger.Info().Msg("registered asset-service")

	reportregister.Register(mux, pool)
	logger.Info().Msg("registered report-service")

	// Layer 2: Compute services (call Rust bridges)
	computeregister.Register(mux, pool, logger)
	logger.Info().Msg("registered compute-service")
	geoanalyticsregister.Register(mux)
	logger.Info().Msg("registered geo-analytics-service")
	graphregister.Register(mux)
	logger.Info().Msg("registered graph-service")
	mlregister.Register(mux)
	logger.Info().Msg("registered ml-service")
	optimizationregister.Register(mux)
	logger.Info().Msg("registered optimization-service")

	// Monolith address for orchestration loopback calls
	monolithAddr := fmt.Sprintf("http://127.0.0.1:%s", *port)
	terrainBridgeURL := strings.TrimSpace(firstNonEmpty(
		os.Getenv("TRANSMISSION_TERRAIN_BRIDGE_URL"),
		dotEnv["TRANSMISSION_TERRAIN_BRIDGE_URL"],
		os.Getenv("TERRAIN_BRIDGE_URL"),
		dotEnv["TERRAIN_BRIDGE_URL"],
		"http://127.0.0.1:8084",
	))
	terrainServiceURL := strings.TrimSpace(firstNonEmpty(
		os.Getenv("TRANSMISSION_TERRAIN_SERVICE_URL"),
		dotEnv["TRANSMISSION_TERRAIN_SERVICE_URL"],
		os.Getenv("TERRAIN_SERVICE_URL"),
		dotEnv["TERRAIN_SERVICE_URL"],
		monolithAddr,
	))
	projectServiceURL := strings.TrimSpace(firstNonEmpty(
		os.Getenv("TRANSMISSION_PROJECT_SERVICE_URL"),
		dotEnv["TRANSMISSION_PROJECT_SERVICE_URL"],
		os.Getenv("PROJECT_SERVICE_URL"),
		dotEnv["PROJECT_SERVICE_URL"],
		monolithAddr,
	))

	// Layer 3: Configuration services
	layoutregister.Register(mux, pool, logger)
	logger.Info().Msg("registered layout-service")

	// Layer 4: Orchestration service (triggers compute jobs)
	computeorchestrationregister.Register(mux, monolithAddr, logger)
	logger.Info().Msg("registered compute-orchestration-service")

	// Layer 5: Services that depend on orchestration
	routingregister.Register(mux, pool, logger, monolithAddr)
	logger.Info().Msg("registered routing-service")

	if err := transmissionroutingregister.Register(mux, pool, terrainBridgeURL, terrainServiceURL, projectServiceURL); err != nil {
		logger.Fatal().Err(err).Msg("failed to register transmission-routing-service")
	}
	logger.Info().
		Str("terrain_bridge_url", terrainBridgeURL).
		Str("terrain_service_url", terrainServiceURL).
		Str("project_service_url", projectServiceURL).
		Msg("registered transmission-routing-service")

	electricalregister.Register(mux, pool, logger, monolithAddr)
	logger.Info().Msg("registered electrical-service")

	simulationregister.Register(mux, pool, logger, monolithAddr)
	logger.Info().Msg("registered simulation-service")

	terrainregister.Register(mux, pool, logger, monolithAddr)
	logger.Info().Msg("registered terrain-service")

	// Phase 0 scope boundary: dedicated commissioning/protection/structural services
	// are intentionally not registered in monolith yet. Their standalone services
	// exist in the workspace and can be integrated in a later phase once rollout
	// sequencing and ownership gates are complete.

	// Twin service - wired in-process for monolith mode
	twinregister.Register(mux, pool, logger)
	logger.Info().Msg("registered twin-service")

	// Layer 6: CAD services (drawing-revision + compute)
	cadCoreClient := cadcoreregister.Register(mux, drawingRevClient, logger, 30*time.Second)
	logger.Info().Msg("registered cad-core-service")

	cadannotationregister.Register(mux, drawingRevClient, cadCoreClient, logger, 30*time.Second)
	logger.Info().Msg("registered cad-annotation-service")

	cadlayerblockregister.Register(mux, drawingRevClient, cadCoreClient, logger, 30*time.Second)
	logger.Info().Msg("registered cad-layer-block-service")

	interopregister.Register(mux, drawingRevClient, cadCoreClient, logger, 30*time.Second)
	logger.Info().Msg("registered interop-service")

	plotSheetClient := plotsheetregister.Register(mux, drawingRevClient, cadCoreClient, logger, 30*time.Second)
	logger.Info().Msg("registered plot-sheet-service")
	apigatewayregister.Register(mux, monolithAddr, logger)
	logger.Info().Msg("registered api-gateway-service")

	// Verify all client dependencies are satisfied
	_ = projectClient    // project-service
	_ = drawingRevClient // drawing-revision-service
	_ = cadCoreClient    // cad-core-service
	_ = plotSheetClient  // plot-sheet-service

	// Apply middleware chain to the mux
	limiter := mw.NewRateLimiter(1000, 2000)
	handler := mw.Chain(
		mw.Recovery(logger),
		mw.IDempotencyKeyMiddleware,
		mw.CORS,
		mw.Logging(logger),
		limiter.Middleware,
	)(mux)

	// Wrap with h2c for HTTP/2 cleartext (required for gRPC/ConnectRPC on single port)
	h2cHandler := h2c.NewHandler(handler, &http2.Server{})

	// Create HTTP server
	srv := &http.Server{
		Addr:         ":" + *port,
		Handler:      h2cHandler,
		ReadTimeout:  30 * time.Second,
		WriteTimeout: 30 * time.Second,
		IdleTimeout:  120 * time.Second,
	}

	// Start server in goroutine
	errChan := make(chan error, 1)
	go func() {
		logger.Info().Str("addr", srv.Addr).Msg("solar3d-monolith listening - press Ctrl+C to stop")
		errChan <- srv.ListenAndServe()
	}()

	// Graceful shutdown on signal
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)

	select {
	case sig := <-quit:
		logger.Info().Str("signal", sig.String()).Msg("shutdown signal received")
		ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
		defer cancel()
		if err := srv.Shutdown(ctx); err != nil {
			logger.Error().Err(err).Msg("shutdown error")
			os.Exit(1)
		}
		logger.Info().Msg("shutdown complete")
	case err := <-errChan:
		if err != http.ErrServerClosed {
			logger.Error().Err(err).Msg("server error")
			os.Exit(1)
		}
	}
}

// loadDotEnv loads environment variables from .env file in current or parent directories
func loadDotEnv() (map[string]string, error) {
	result := make(map[string]string)

	// Try to find .env in current directory or parent directories
	paths := []string{
		".env",
		filepath.Join("..", ".env"),
		filepath.Join("..", "..", ".env"),
		filepath.Join("..", "..", "..", ".env"),
	}

	var file *os.File
	for _, path := range paths {
		f, err := os.Open(path)
		if err == nil {
			file = f
			break
		}
	}

	if file == nil {
		return result, nil // .env is optional
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}

		parts := strings.SplitN(line, "=", 2)
		if len(parts) == 2 {
			key := strings.TrimSpace(parts[0])
			value := strings.TrimSpace(parts[1])
			result[key] = value
		}
	}

	return result, scanner.Err()
}

// firstNonEmpty returns the first non-empty trimmed string from the provided values
func firstNonEmpty(values ...string) string {
	for _, v := range values {
		if trimmed := strings.TrimSpace(v); trimmed != "" {
			return trimmed
		}
	}
	return ""
}

func applyMigrations(ctx context.Context, pool *pgxpool.Pool, logger zerolog.Logger) error {
	if _, err := pool.Exec(ctx, `
		CREATE TABLE IF NOT EXISTS schema_migrations (
			name TEXT PRIMARY KEY,
			applied_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)
	`); err != nil {
		return fmt.Errorf("ensure schema_migrations table: %w", err)
	}

	migrationDir, err := resolveMigrationDir()
	if err != nil {
		return err
	}

	logger.Info().Str("dir", migrationDir).Msg("using migration directory")

	entries, err := os.ReadDir(migrationDir)
	if err != nil {
		return fmt.Errorf("read migrations dir: %w", err)
	}

	var files []string
	for _, entry := range entries {
		if entry.IsDir() {
			continue
		}
		name := entry.Name()
		if strings.HasSuffix(strings.ToLower(name), ".sql") {
			files = append(files, name)
		}
	}
	sort.Strings(files)

	for _, name := range files {
		var applied bool
		if err := pool.QueryRow(ctx, `SELECT EXISTS(SELECT 1 FROM schema_migrations WHERE name = $1)`, name).Scan(&applied); err != nil {
			return fmt.Errorf("check migration %s: %w", name, err)
		}
		if applied {
			continue
		}

		content, err := os.ReadFile(filepath.Join(migrationDir, name))
		if err != nil {
			return fmt.Errorf("read migration %s: %w", name, err)
		}

		tx, err := pool.BeginTx(ctx, pgx.TxOptions{})
		if err != nil {
			return fmt.Errorf("begin migration tx %s: %w", name, err)
		}

		if _, err := tx.Exec(ctx, string(content)); err != nil {
			if isAlreadyExistsMigrationError(err) {
				_ = tx.Rollback(ctx)
				if _, recErr := pool.Exec(ctx, `INSERT INTO schema_migrations (name) VALUES ($1)`, name); recErr != nil {
					return fmt.Errorf("record baseline migration %s: %w", name, recErr)
				}
				logger.Warn().Str("migration", name).Err(err).Msg("migration appears already applied; recording baseline")
				continue
			} else {
				_ = tx.Rollback(ctx)
				return fmt.Errorf("apply migration %s: %w", name, err)
			}
		}
		if _, err := tx.Exec(ctx, `INSERT INTO schema_migrations (name) VALUES ($1)`, name); err != nil {
			_ = tx.Rollback(ctx)
			return fmt.Errorf("record migration %s: %w", name, err)
		}
		if err := tx.Commit(ctx); err != nil {
			return fmt.Errorf("commit migration %s: %w", name, err)
		}

		logger.Info().Str("migration", name).Msg("migration applied")
	}

	return nil
}

func isAlreadyExistsMigrationError(err error) bool {
	var pgErr *pgconn.PgError
	if !errors.As(err, &pgErr) {
		return false
	}
	switch pgErr.Code {
	case "42P07", // duplicate_table
		"42701", // duplicate_column
		"42710", // duplicate_object
		"42P16": // invalid_table_definition (often duplicate PK/constraint while bootstrapping)
		return true
	default:
		return false
	}
}

func resolveMigrationDir() (string, error) {
	candidates := []string{
		"migrations",
		filepath.Join("..", "migrations"),
		filepath.Join("..", "..", "migrations"),
		filepath.Join("..", "..", "..", "migrations"),
	}

	for _, candidate := range candidates {
		if info, err := os.Stat(candidate); err == nil && info.IsDir() {
			abs, absErr := filepath.Abs(candidate)
			if absErr != nil {
				return candidate, nil
			}
			return abs, nil
		}
	}

	return "", fmt.Errorf("read migrations dir: no migrations directory found in known locations")
}
