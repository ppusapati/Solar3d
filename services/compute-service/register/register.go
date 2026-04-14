// Package computeservice exposes a Register function for monolith use.
package register

import (
	"net/http"
	"os"
	"strings"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/rs/zerolog"
	extendedv1connect "github.com/solar3d/solar3d/gen/extended/v1/extendedv1connect"
	geov1connect "github.com/solar3d/solar3d/gen/geo/v1/geov1connect"
	graphv1connect "github.com/solar3d/solar3d/gen/graph/v1/graphv1connect"
	kmlv1connect "github.com/solar3d/solar3d/gen/kml/v1/kmlv1connect"
	ml_inferencev1connect "github.com/solar3d/solar3d/gen/ml_inference/v1/ml_inferencev1connect"
	optimizationv1connect "github.com/solar3d/solar3d/gen/optimization/v1/optimizationv1connect"
	simulationv1connect "github.com/solar3d/solar3d/gen/simulation/v1/simulationv1connect"
	terrainv1connect "github.com/solar3d/solar3d/gen/terrain/v1/terrainv1connect"

	"solar3d/compute-service/internal/handler"
	"solar3d/compute-service/internal/repository"
	"solar3d/compute-service/internal/service"
)

// Register wires the compute-service handlers (all compute operations via ConnectRPC)
// onto mux. Rust bridge URLs are read from environment variables with defaults.
func Register(mux *http.ServeMux, pool *pgxpool.Pool, logger zerolog.Logger) {
	// Read Rust bridge URLs from env with defaults
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

	// Initialize repository layer (Rust compute bindings)
	mlInferenceRepo := repository.NewRustMLInferenceRepository(mlBridgeURL)
	mlTrainingRepo := repository.NewSQLCMLTrainingRepository(pool)
	optimizationRepo := repository.NewRustOptimizationRepository(optBridgeURL)
	simulationRepo := repository.NewRustSimulationRepository(solarBridgeURL)
	terrainRepo := repository.NewRustTerrainRepository(terrainBridgeURL)
	extendedRepo := repository.NewRustExtendedRepository(extendedBridgeURL, scenarioStorePath)
	graphRepo := repository.NewRustGraphRepository(graphBridgeURL)
	geoRepo := repository.NewRustGeoRepository(geoBridgeURL)
	kmlRepo := repository.NewMockKMLRepository()

	// Initialize service layer
	mlInferenceService := service.NewMLInferenceService(mlInferenceRepo)
	mlTrainingService := service.NewMLTrainingService(mlTrainingRepo)
	optimizationService := service.NewOptimizationService(optimizationRepo)
	simulationService := service.NewSimulationService(simulationRepo)
	terrainService := service.NewTerrainService(terrainRepo)
	extendedService := service.NewExtendedService(extendedRepo)
	graphService := service.NewGraphService(graphRepo)
	geoService := service.NewGeoService(geoRepo)
	kmlService := service.NewKMLService(kmlRepo)

	// Initialize handler layer
	mlInferenceHandler := handler.NewMLInferenceServiceHandler(mlInferenceService, mlTrainingService)
	optimizationHandler := handler.NewOptimizationServiceHandler(optimizationService)
	simulationHandler := handler.NewSimulationServiceHandler(simulationService, nil)
	terrainHandler := handler.NewTerrainServiceHandler(terrainService, nil)
	extendedHandler := handler.NewExtendedServiceHandler(extendedService)
	graphHandler := handler.NewGraphServiceHandler(graphService)
	geoHandler := handler.NewGeoServiceHandler(geoService)
	kmlHandler := handler.NewKMLIngestionServiceHandler(kmlService)

	// Register Rust bridge handlers on mux.
	// By default, SimulationService and TerrainService are handled by their own Go services
	// (simulation-service and terrain-service respectively) which call compute-orchestration.
	// Set REGISTER_COMPUTE_ONLY_SIM_TERRAIN=true to expose compute-only methods from compute-service
	// while lifecycle methods return CodeUnavailable when no lifecycle client is configured.
	registerComputeOnlySimTerrain := strings.EqualFold(os.Getenv("REGISTER_COMPUTE_ONLY_SIM_TERRAIN"), "true")
	mlPath, mlConnectHandler := ml_inferencev1connect.NewMLInferenceServiceHandler(mlInferenceHandler)
	mux.Handle(mlPath, mlConnectHandler)

	optPath, optConnectHandler := optimizationv1connect.NewOptimizationServiceHandler(optimizationHandler)
	mux.Handle(optPath, optConnectHandler)

	extendedPath, extendedConnectHandler := extendedv1connect.NewExtendedServiceHandler(extendedHandler)
	mux.Handle(extendedPath, extendedConnectHandler)

	graphPath, graphConnectHandler := graphv1connect.NewGraphServiceHandler(graphHandler)
	mux.Handle(graphPath, graphConnectHandler)

	geoPath, geoConnectHandler := geov1connect.NewGeoServiceHandler(geoHandler)
	mux.Handle(geoPath, geoConnectHandler)

	kmlPath, kmlConnectHandler := kmlv1connect.NewKMLIngestionServiceHandler(kmlHandler)
	mux.Handle(kmlPath, kmlConnectHandler)

	// Always expose compute-only RPC contracts; these do not conflict with lifecycle services.
	simComputePath, simComputeConnectHandler := simulationv1connect.NewSimulationComputeServiceHandler(simulationHandler)
	mux.Handle(simComputePath, simComputeConnectHandler)

	terrainComputePath, terrainComputeConnectHandler := terrainv1connect.NewTerrainComputeServiceHandler(terrainHandler)
	mux.Handle(terrainComputePath, terrainComputeConnectHandler)

	if registerComputeOnlySimTerrain {
		simPath, simConnectHandler := simulationv1connect.NewSimulationServiceHandler(simulationHandler)
		mux.Handle(simPath, simConnectHandler)

		terrainPath, terrainConnectHandler := terrainv1connect.NewTerrainServiceHandler(terrainHandler)
		mux.Handle(terrainPath, terrainConnectHandler)

		logger.Info().Msg("registered compute-service simulation/terrain handlers in compute-only mode")
	}
}
