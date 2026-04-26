package main

import (
	"context"
	"fmt"
	"log"
	"net"
	"net/http"
	"net/url"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"p9e.in/samavaya/packages/database/pgxpostgres"
	"p9e.in/samavaya/solar3d/compute-service/internal/handler"
	"p9e.in/samavaya/solar3d/compute-service/internal/repository"
	"p9e.in/samavaya/solar3d/compute-service/internal/service"

	"connectrpc.com/connect"

	constraintv1connect "p9e.in/samavaya/solar3d/gen/constraint/v1/constraintv1connect"
	extendedv1connect "p9e.in/samavaya/solar3d/gen/extended/v1/extendedv1connect"
	geov1connect "p9e.in/samavaya/solar3d/gen/geo/v1/geov1connect"
	graphv1connect "p9e.in/samavaya/solar3d/gen/graph/v1/graphv1connect"
	ml_inferencev1connect "p9e.in/samavaya/solar3d/gen/ml_inference/v1/ml_inferencev1connect"
	optimizationv1connect "p9e.in/samavaya/solar3d/gen/optimization/v1/optimizationv1connect"
	simulationv1connect "p9e.in/samavaya/solar3d/gen/simulation/v1/simulationv1connect"
	terrainv1connect "p9e.in/samavaya/solar3d/gen/terrain/v1/terrainv1connect"
)

func ensureHTTPServiceReachable(ctx context.Context, rawURL string, serviceName string) error {
	parsed, err := url.Parse(rawURL)
	if err != nil {
		return fmt.Errorf("%s URL parse failed: %w", serviceName, err)
	}
	if parsed.Host == "" {
		return fmt.Errorf("%s URL missing host: %s", serviceName, rawURL)
	}

	hostPort := parsed.Host
	if !strings.Contains(hostPort, ":") {
		defaultPort := "80"
		if strings.EqualFold(parsed.Scheme, "https") {
			defaultPort = "443"
		}
		hostPort = net.JoinHostPort(hostPort, defaultPort)
	}

	dialer := &net.Dialer{Timeout: 3 * time.Second}
	conn, err := dialer.DialContext(ctx, "tcp", hostPort)
	if err != nil {
		return fmt.Errorf("%s not reachable at %s (%s): %w", serviceName, rawURL, hostPort, err)
	}
	if err := conn.Close(); err != nil {
		return fmt.Errorf("%s reachability close failed: %w", serviceName, err)
	}

	return nil
}

func main() {
	port := ":50051"
	mlBridgeURL := os.Getenv("RUST_ML_BRIDGE_URL")
	if mlBridgeURL == "" {
		mlBridgeURL = "http://127.0.0.1:8081"
	}

	optBridgeURL := os.Getenv("RUST_OPT_BRIDGE_URL")
	if optBridgeURL == "" {
		optBridgeURL = "http://127.0.0.1:8082"
	}

	solarBridgeURL := os.Getenv("RUST_SOLAR_BRIDGE_URL")
	if solarBridgeURL == "" {
		solarBridgeURL = "http://127.0.0.1:8083"
	}

	terrainBridgeURL := os.Getenv("RUST_TERRAIN_BRIDGE_URL")
	if terrainBridgeURL == "" {
		terrainBridgeURL = "http://127.0.0.1:8084"
	}

	extendedBridgeURL := os.Getenv("RUST_EXTENDED_BRIDGE_URL")
	if extendedBridgeURL == "" {
		extendedBridgeURL = "http://127.0.0.1:8085"
	}

	scenarioStorePath := os.Getenv("SCENARIO_STORE_FILE")
	if scenarioStorePath == "" {
		scenarioStorePath = "data/financial_scenarios.json"
	}

	graphBridgeURL := os.Getenv("RUST_GRAPH_BRIDGE_URL")
	if graphBridgeURL == "" {
		graphBridgeURL = "http://127.0.0.1:8086"
	}

	geoBridgeURL := os.Getenv("RUST_GEO_BRIDGE_URL")
	if geoBridgeURL == "" {
		geoBridgeURL = "http://127.0.0.1:8087"
	}

	terrainServiceURL := os.Getenv("TERRAIN_SERVICE_URL")
	if terrainServiceURL == "" {
		terrainServiceURL = "http://127.0.0.1:8081"
	}

	simulationServiceURL := os.Getenv("SIMULATION_SERVICE_URL")
	if simulationServiceURL == "" {
		simulationServiceURL = "http://127.0.0.1:8083"
	}

	databaseURL := os.Getenv("DATABASE_URL")
	if databaseURL == "" {
		log.Fatal("DATABASE_URL is required")
	}

	startupCtx, startupCancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer startupCancel()

	if err := ensureHTTPServiceReachable(startupCtx, terrainServiceURL, "terrain-service"); err != nil {
		log.Fatalf("startup dependency check failed: %v", err)
	}
	if err := ensureHTTPServiceReachable(startupCtx, simulationServiceURL, "simulation-service"); err != nil {
		log.Fatalf("startup dependency check failed: %v", err)
	}

	pool, closePool, err := pgxpostgres.NewPgxFromDSN(startupCtx, databaseURL, pgxpostgres.DefaultPoolOptions())
	if err != nil {
		log.Fatalf("failed to initialise database pool: %v", err)
	}
	defer closePool()

	// Initialize repository layer (Rust compute bindings)
	mlInferenceRepo := repository.NewRustMLInferenceRepository(mlBridgeURL)
	mlTrainingRepo := repository.NewSQLCMLTrainingRepository(pool)
	optimizationRepo := repository.NewRustOptimizationRepository(optBridgeURL)
	simulationRepo := repository.NewRustSimulationRepository(solarBridgeURL)
	terrainRepo := repository.NewRustTerrainRepository(terrainBridgeURL)
	extendedRepo := repository.NewRustExtendedRepository(extendedBridgeURL, scenarioStorePath)
	graphRepo := repository.NewRustGraphRepository(graphBridgeURL)
	geoRepo := repository.NewRustGeoRepository(geoBridgeURL)
	constraintRepo := repository.NewPgConstraintRepository(pool)

	// Initialize service layer (business logic)
	mlInferenceService := service.NewMLInferenceService(mlInferenceRepo)
	mlTrainingService := service.NewMLTrainingService(mlTrainingRepo)
	optimizationService := service.NewOptimizationService(optimizationRepo)
	simulationService := service.NewSimulationService(simulationRepo)
	terrainService := service.NewTerrainService(terrainRepo)
	extendedService := service.NewExtendedService(extendedRepo)
	graphService := service.NewGraphService(graphRepo)
	geoService := service.NewGeoService(geoRepo)
	constraintZoneService := service.NewConstraintZoneService(constraintRepo)

	httpClient := &http.Client{Timeout: 45 * time.Second}
	terrainLifecycleClient := terrainv1connect.NewTerrainServiceClient(httpClient, terrainServiceURL, connect.WithGRPC())
	simulationLifecycleClient := simulationv1connect.NewSimulationServiceClient(httpClient, simulationServiceURL, connect.WithGRPC())

	// Initialize handler layer (connectRPC interface implementation)
	mlInferenceHandler := handler.NewMLInferenceServiceHandler(mlInferenceService, mlTrainingService)
	optimizationHandler := handler.NewOptimizationServiceHandler(optimizationService)
	simulationHandler := handler.NewSimulationServiceHandler(simulationService, simulationLifecycleClient)
	terrainHandler := handler.NewTerrainServiceHandler(terrainService, terrainLifecycleClient)
	extendedHandler := handler.NewExtendedServiceHandler(extendedService)
	graphHandler := handler.NewGraphServiceHandler(graphService)
	geoHandler := handler.NewGeoServiceHandler(geoService)
	constraintHandler := handler.NewConstraintZoneHandler(constraintZoneService)

	// Create HTTP multiplexer for connectRPC
	mux := http.NewServeMux()

	// Register ML Inference service
	mlPath, mlConnectHandler := ml_inferencev1connect.NewMLInferenceServiceHandler(mlInferenceHandler)
	mux.Handle(mlPath, mlConnectHandler)

	// Register Optimization service
	optPath, optConnectHandler := optimizationv1connect.NewOptimizationServiceHandler(optimizationHandler)
	mux.Handle(optPath, optConnectHandler)

	// Register Simulation service
	simPath, simConnectHandler := simulationv1connect.NewSimulationServiceHandler(simulationHandler)
	mux.Handle(simPath, simConnectHandler)

	// Register Terrain service
	terrainPath, terrainConnectHandler := terrainv1connect.NewTerrainServiceHandler(terrainHandler)
	mux.Handle(terrainPath, terrainConnectHandler)

	// Register Extended service
	extendedPath, extendedConnectHandler := extendedv1connect.NewExtendedServiceHandler(extendedHandler)
	mux.Handle(extendedPath, extendedConnectHandler)

	// Register Graph service
	graphPath, graphConnectHandler := graphv1connect.NewGraphServiceHandler(graphHandler)
	mux.Handle(graphPath, graphConnectHandler)

	// Register Geo service
	geoPath, geoConnectHandler := geov1connect.NewGeoServiceHandler(geoHandler)
	mux.Handle(geoPath, geoConnectHandler)

	// Register ConstraintZone service (PostGIS-backed CRUD + siting analysis)
	constraintPath, constraintConnectHandler := constraintv1connect.NewConstraintZoneServiceHandler(constraintHandler)
	mux.Handle(constraintPath, constraintConnectHandler)

	// Create HTTP server with connectRPC support
	httpServer := &http.Server{
		Addr:         port,
		Handler:      http.MaxBytesHandler(mux, 512*1024*1024), // 512MB max
		ReadTimeout:  30 * time.Second,
		WriteTimeout: 30 * time.Second,
		IdleTimeout:  120 * time.Second,
	}

	log.Printf(
		"Compute Service listening on %s with connectRPC (ML: %s, OPT: %s, SOLAR: %s, TERRAIN: %s, EXTENDED: %s, GRAPH: %s, GEO: %s, terrain-service: %s, simulation-service: %s)",
		port,
		mlBridgeURL,
		optBridgeURL,
		solarBridgeURL,
		terrainBridgeURL,
		extendedBridgeURL,
		graphBridgeURL,
		geoBridgeURL,
		terrainServiceURL,
		simulationServiceURL,
	)

	// Start server in background
	go func() {
		if err := httpServer.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("failed to serve: %v", err)
		}
	}()

	// Graceful shutdown handling
	sigCh := make(chan os.Signal, 1)
	signal.Notify(sigCh, syscall.SIGINT, syscall.SIGTERM)
	<-sigCh

	log.Println("Shutting down compute service...")
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	if err := httpServer.Shutdown(ctx); err != nil {
		log.Fatalf("shutdown error: %v", err)
	}
}
