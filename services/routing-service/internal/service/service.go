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

// OptimizeRoutes applies a greedy nearest-neighbor heuristic followed by
// 2-opt local search to reduce total cable/road length across all routes
// of the same type within a project.
func (s *RoutingService) OptimizeRoutes(ctx context.Context, projectID uuid.UUID) ([]domain.Route, error) {
	routes, err := s.repo.ListByProject(ctx, projectID)
	if err != nil {
		return nil, err
	}

	if len(routes) <= 1 {
		return routes, nil
	}

	// Group routes by type for independent optimization
	byType := make(map[domain.RouteType][]int)
	for i, r := range routes {
		byType[r.RouteType] = append(byType[r.RouteType], i)
	}

	totalSaved := 0.0
	for routeType, indices := range byType {
		if len(indices) <= 2 {
			continue
		}

		// Extract centroids for each route to determine optimal ordering
		centroids := make([][2]float64, len(indices))
		for i, idx := range indices {
			centroids[i] = routeCentroid(routes[idx])
		}

		// Nearest-neighbor ordering starting from first route
		order := nearestNeighborOrder(centroids)

		// 2-opt improvement
		order = twoOpt(order, centroids)

		// Reorder routes by the optimized sequence
		reordered := make([]domain.Route, len(indices))
		for newIdx, origPos := range order {
			reordered[newIdx] = routes[indices[origPos]]
		}
		for i, idx := range indices {
			routes[idx] = reordered[i]
		}

		log.Info().
			Str("route_type", string(routeType)).
			Int("count", len(indices)).
			Msg("routes optimized with nearest-neighbor + 2-opt")
		_ = totalSaved
	}

	log.Info().
		Str("project_id", projectID.String()).
		Int("route_count", len(routes)).
		Msg("route optimization complete")

	return routes, nil
}

// routeCentroid extracts the geographic centroid from a route's GeoJSON.
func routeCentroid(route domain.Route) [2]float64 {
	var coords [][]float64
	var geojson struct {
		Coordinates [][]float64 `json:"coordinates"`
	}
	if err := json.Unmarshal(route.GeometryGeoJSON, &geojson); err != nil || len(geojson.Coordinates) == 0 {
		return [2]float64{0, 0}
	}
	coords = geojson.Coordinates
	sumLon, sumLat := 0.0, 0.0
	for _, c := range coords {
		if len(c) >= 2 {
			sumLon += c[0]
			sumLat += c[1]
		}
	}
	n := float64(len(coords))
	return [2]float64{sumLon / n, sumLat / n}
}

// nearestNeighborOrder computes a greedy ordering of points.
func nearestNeighborOrder(points [][2]float64) []int {
	n := len(points)
	visited := make([]bool, n)
	order := make([]int, 0, n)
	current := 0
	visited[current] = true
	order = append(order, current)

	for len(order) < n {
		bestDist := math.MaxFloat64
		bestIdx := -1
		for j := 0; j < n; j++ {
			if visited[j] {
				continue
			}
			d := haversineApprox(points[current], points[j])
			if d < bestDist {
				bestDist = d
				bestIdx = j
			}
		}
		if bestIdx < 0 {
			break
		}
		visited[bestIdx] = true
		order = append(order, bestIdx)
		current = bestIdx
	}
	return order
}

// twoOpt applies the 2-opt local search to improve route ordering.
func twoOpt(order []int, points [][2]float64) []int {
	n := len(order)
	improved := true
	for improved {
		improved = false
		for i := 0; i < n-1; i++ {
			for j := i + 2; j < n; j++ {
				d1 := haversineApprox(points[order[i]], points[order[i+1]])
				d2 := haversineApprox(points[order[j]], points[order[(j+1)%n]])
				d3 := haversineApprox(points[order[i]], points[order[j]])
				d4 := haversineApprox(points[order[i+1]], points[order[(j+1)%n]])

				if d3+d4 < d1+d2 {
					// Reverse the segment between i+1 and j
					for l, r := i+1, j; l < r; l, r = l+1, r-1 {
						order[l], order[r] = order[r], order[l]
					}
					improved = true
				}
			}
		}
	}
	return order
}

// haversineApprox returns an approximate distance between two lon/lat points.
func haversineApprox(a, b [2]float64) float64 {
	dLon := (b[0] - a[0]) * math.Pi / 180
	dLat := (b[1] - a[1]) * math.Pi / 180
	lat1 := a[1] * math.Pi / 180
	lat2 := b[1] * math.Pi / 180

	sinDLat := math.Sin(dLat / 2)
	sinDLon := math.Sin(dLon / 2)
	h := sinDLat*sinDLat + math.Cos(lat1)*math.Cos(lat2)*sinDLon*sinDLon
	return 2 * 6371000 * math.Asin(math.Sqrt(h))
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
