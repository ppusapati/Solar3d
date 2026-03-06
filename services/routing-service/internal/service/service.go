package service

import (
	"context"
	"encoding/json"
	"fmt"
	"math"

	"github.com/google/uuid"
	"github.com/rs/zerolog/log"

	"github.com/solar3d/solar3d/services/routing-service/internal/domain"
	"github.com/solar3d/solar3d/services/routing-service/internal/repository"
)

type RoutingService struct {
	repo *repository.RouteRepository
}

func NewRoutingService(repo *repository.RouteRepository) *RoutingService {
	return &RoutingService{repo: repo}
}

func (s *RoutingService) CreateRoute(ctx context.Context, req domain.CreateRouteRequest) (*domain.Route, error) {
	route := &domain.Route{
		ID:              uuid.New(),
		ProjectID:       req.ProjectID,
		RouteType:       req.RouteType,
		Name:            req.Name,
		GeometryGeoJSON: req.GeometryGeoJSON,
		DistanceM:       req.DistanceM,
		CostEstimate:    req.CostEstimate,
		Metadata:        req.Metadata,
	}

	if err := s.repo.Create(ctx, route); err != nil {
		return nil, fmt.Errorf("creating route: %w", err)
	}

	log.Info().
		Str("route_id", route.ID.String()).
		Str("type", string(route.RouteType)).
		Float64("distance_m", route.DistanceM).
		Msg("route created")

	return route, nil
}

func (s *RoutingService) GetRoute(ctx context.Context, id uuid.UUID) (*domain.Route, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *RoutingService) ListRoutes(ctx context.Context, projectID uuid.UUID) ([]domain.Route, error) {
	return s.repo.ListByProject(ctx, projectID)
}

func (s *RoutingService) DeleteRoute(ctx context.Context, id uuid.UUID) error {
	return s.repo.Delete(ctx, id)
}

func (s *RoutingService) CalculateRoute(ctx context.Context, req domain.CalculateRouteRequest) (*domain.Route, error) {
	terrain := req.Terrain
	if terrain == nil {
		// Generate a flat default terrain grid if none provided
		gridSize := req.GridSizeM
		if gridSize <= 0 {
			gridSize = 5.0
		}

		// Create a simple grid spanning start to end
		dlat := math.Abs(req.End.Lat-req.Start.Lat) * 111320.0
		dlon := math.Abs(req.End.Lon-req.Start.Lon) * 111320.0 * math.Cos(req.Start.Lat*math.Pi/180.0)
		maxDist := math.Max(dlat, dlon)
		if maxDist < gridSize*10 {
			maxDist = gridSize * 10
		}

		gridCols := int(math.Ceil(dlon/gridSize)) + 2
		gridRows := int(math.Ceil(dlat/gridSize)) + 2
		if gridCols < 3 {
			gridCols = 3
		}
		if gridRows < 3 {
			gridRows = 3
		}
		if gridCols > 1000 {
			gridCols = 1000
		}
		if gridRows > 1000 {
			gridRows = 1000
		}

		terrain = &domain.TerrainGrid{
			Width:     gridCols,
			Height:    gridRows,
			CellSizeM: gridSize,
			OriginLon: math.Min(req.Start.Lon, req.End.Lon),
			OriginLat: math.Min(req.Start.Lat, req.End.Lat),
		}

		terrain.Elevations = make([][]float64, terrain.Height)
		terrain.Obstacles = make([][]bool, terrain.Height)
		for r := 0; r < terrain.Height; r++ {
			terrain.Elevations[r] = make([]float64, terrain.Width)
			terrain.Obstacles[r] = make([]bool, terrain.Width)
			for c := 0; c < terrain.Width; c++ {
				// Interpolate elevation between start and end
				t := float64(r) / float64(terrain.Height-1)
				terrain.Elevations[r][c] = req.Start.Elevation*(1-t) + req.End.Elevation*t
			}
		}
	}

	// Convert start/end to grid coordinates
	startNode := waypointToGrid(terrain, req.Start)
	goalNode := waypointToGrid(terrain, req.End)

	// Clamp to grid bounds
	startNode = clampToGrid(terrain, startNode)
	goalNode = clampToGrid(terrain, goalNode)

	log.Info().
		Int("start_row", startNode.Row).Int("start_col", startNode.Col).
		Int("goal_row", goalNode.Row).Int("goal_col", goalNode.Col).
		Int("grid_w", terrain.Width).Int("grid_h", terrain.Height).
		Msg("running A* pathfinding")

	path, err := FindPath(terrain, startNode, goalNode, req.Constraints)
	if err != nil {
		return nil, fmt.Errorf("pathfinding failed: %w", err)
	}

	waypoints := GridPathToWaypoints(terrain, path)
	distance := CalculatePathDistance(terrain, path)

	// Build GeoJSON LineString
	coordinates := make([][]float64, len(waypoints))
	for i, wp := range waypoints {
		coordinates[i] = []float64{wp.Lon, wp.Lat, wp.Elevation}
	}
	geojson, _ := json.Marshal(map[string]interface{}{
		"type":        "LineString",
		"coordinates": coordinates,
	})

	// Cost estimate based on route type
	costPerMeter := 25.0 // Default cable cost per meter
	switch req.RouteType {
	case domain.RouteTypeRoad:
		costPerMeter = 150.0
	case domain.RouteTypeFence:
		costPerMeter = 50.0
	}

	route := &domain.Route{
		ID:              uuid.New(),
		ProjectID:       req.ProjectID,
		RouteType:       req.RouteType,
		Name:            req.Name,
		GeometryGeoJSON: geojson,
		DistanceM:       distance,
		CostEstimate:    distance * costPerMeter,
	}

	if err := s.repo.Create(ctx, route); err != nil {
		return nil, fmt.Errorf("saving route: %w", err)
	}

	log.Info().
		Str("route_id", route.ID.String()).
		Float64("distance_m", distance).
		Float64("cost", route.CostEstimate).
		Int("waypoints", len(waypoints)).
		Msg("route calculated and saved")

	return route, nil
}

func (s *RoutingService) CreateCableRoute(ctx context.Context, req domain.CalculateRouteRequest) (*domain.Route, error) {
	req.RouteType = domain.RouteTypeCable
	return s.CalculateRoute(ctx, req)
}

func (s *RoutingService) CreateRoadRoute(ctx context.Context, req domain.CalculateRouteRequest) (*domain.Route, error) {
	req.RouteType = domain.RouteTypeRoad
	return s.CalculateRoute(ctx, req)
}

func (s *RoutingService) OptimizeRoutes(ctx context.Context, projectID uuid.UUID) ([]domain.Route, error) {
	routes, err := s.repo.ListByProject(ctx, projectID)
	if err != nil {
		return nil, err
	}

	log.Info().
		Str("project_id", projectID.String()).
		Int("route_count", len(routes)).
		Msg("routes retrieved for optimization (optimization is a no-op placeholder)")

	return routes, nil
}

func waypointToGrid(terrain *domain.TerrainGrid, wp domain.Waypoint) GridNode {
	row := int(math.Round((wp.Lat - terrain.OriginLat) * 111320.0 / terrain.CellSizeM))
	lon_scale := 111320.0 * math.Cos(terrain.OriginLat*math.Pi/180.0)
	col := int(math.Round((wp.Lon - terrain.OriginLon) * lon_scale / terrain.CellSizeM))
	return GridNode{Row: row, Col: col}
}

func clampToGrid(terrain *domain.TerrainGrid, n GridNode) GridNode {
	if n.Row < 0 {
		n.Row = 0
	}
	if n.Row >= terrain.Height {
		n.Row = terrain.Height - 1
	}
	if n.Col < 0 {
		n.Col = 0
	}
	if n.Col >= terrain.Width {
		n.Col = terrain.Width - 1
	}
	return n
}
