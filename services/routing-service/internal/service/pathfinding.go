package service

import (
	"container/heap"
	"fmt"
	"math"

	"p9e.in/samavaya/solar3d/routing-service/internal/domain"
)

// GridNode represents a position on the terrain grid.
type GridNode struct {
	Row, Col int
}

// astarNode is a node in the A* priority queue.
type astarNode struct {
	pos   GridNode
	gCost float64 // Cost from start to this node
	fCost float64 // gCost + heuristic estimate to goal
	index int     // Index in the priority queue
}

// priorityQueue implements heap.Interface for A* open set.
type priorityQueue []*astarNode

func (pq priorityQueue) Len() int           { return len(pq) }
func (pq priorityQueue) Less(i, j int) bool { return pq[i].fCost < pq[j].fCost }
func (pq priorityQueue) Swap(i, j int)      { pq[i], pq[j] = pq[j], pq[i]; pq[i].index = i; pq[j].index = j }
func (pq *priorityQueue) Push(x interface{}) {
	n := x.(*astarNode)
	n.index = len(*pq)
	*pq = append(*pq, n)
}
func (pq *priorityQueue) Pop() interface{} {
	old := *pq
	n := old[len(old)-1]
	old[len(old)-1] = nil
	n.index = -1
	*pq = old[:len(old)-1]
	return n
}

// neighbors returns the 8-connected grid neighbors of a node.
var directions = [8][2]int{
	{-1, 0}, {1, 0}, {0, -1}, {0, 1}, // Cardinal
	{-1, -1}, {-1, 1}, {1, -1}, {1, 1}, // Diagonal
}

// FindPath implements A* pathfinding on a terrain grid with slope penalties and obstacle avoidance.
// Returns a slice of grid positions from start to goal, or an error if no path exists.
func FindPath(terrain *domain.TerrainGrid, start, goal GridNode, constraints domain.RouteConstraints) ([]GridNode, error) {
	if terrain == nil {
		return nil, fmt.Errorf("terrain grid is nil")
	}
	if !inBounds(terrain, start) || !inBounds(terrain, goal) {
		return nil, fmt.Errorf("start or goal out of bounds")
	}
	if terrain.Obstacles != nil && terrain.Obstacles[start.Row][start.Col] {
		return nil, fmt.Errorf("start position is an obstacle")
	}
	if terrain.Obstacles != nil && terrain.Obstacles[goal.Row][goal.Col] {
		return nil, fmt.Errorf("goal position is an obstacle")
	}

	openSet := &priorityQueue{}
	heap.Init(openSet)

	startNode := &astarNode{
		pos:   start,
		gCost: 0,
		fCost: heuristic(start, goal, terrain.CellSizeM),
	}
	heap.Push(openSet, startNode)

	cameFrom := make(map[GridNode]GridNode)
	gScore := make(map[GridNode]float64)
	gScore[start] = 0

	closed := make(map[GridNode]bool)

	for openSet.Len() > 0 {
		current := heap.Pop(openSet).(*astarNode)

		if current.pos == goal {
			return reconstructPath(cameFrom, current.pos), nil
		}

		if closed[current.pos] {
			continue
		}
		closed[current.pos] = true

		for _, dir := range directions {
			neighbor := GridNode{
				Row: current.pos.Row + dir[0],
				Col: current.pos.Col + dir[1],
			}

			if !inBounds(terrain, neighbor) {
				continue
			}
			if closed[neighbor] {
				continue
			}
			if terrain.Obstacles != nil && terrain.Obstacles[neighbor.Row][neighbor.Col] {
				continue
			}

			// Check if neighbor is in an avoidance zone
			if isInAvoidZone(terrain, neighbor, constraints.AvoidZones) {
				continue
			}

			// Calculate movement cost
			moveCost := movementCost(terrain, current.pos, neighbor, constraints)
			if moveCost < 0 {
				// Slope exceeds maximum, skip
				continue
			}

			tentativeG := gScore[current.pos] + moveCost

			if existing, ok := gScore[neighbor]; ok && tentativeG >= existing {
				continue
			}

			gScore[neighbor] = tentativeG
			cameFrom[neighbor] = current.pos

			h := heuristic(neighbor, goal, terrain.CellSizeM)
			heap.Push(openSet, &astarNode{
				pos:   neighbor,
				gCost: tentativeG,
				fCost: tentativeG + h,
			})
		}
	}

	return nil, fmt.Errorf("no path found from (%d,%d) to (%d,%d)", start.Row, start.Col, goal.Row, goal.Col)
}

// heuristic computes the Euclidean distance in meters between two grid nodes.
func heuristic(a, b GridNode, cellSizeM float64) float64 {
	dr := float64(a.Row - b.Row)
	dc := float64(a.Col - b.Col)
	return math.Sqrt(dr*dr+dc*dc) * cellSizeM
}

// movementCost calculates the cost to move between adjacent cells,
// incorporating distance and terrain slope penalties.
func movementCost(terrain *domain.TerrainGrid, from, to GridNode, constraints domain.RouteConstraints) float64 {
	dr := float64(to.Row - from.Row)
	dc := float64(to.Col - from.Col)
	horizontalDist := math.Sqrt(dr*dr+dc*dc) * terrain.CellSizeM

	baseCost := horizontalDist

	// Calculate slope if elevation data is available
	if terrain.Elevations != nil {
		elevFrom := terrain.Elevations[from.Row][from.Col]
		elevTo := terrain.Elevations[to.Row][to.Col]
		elevDiff := math.Abs(elevTo - elevFrom)

		if horizontalDist > 0 {
			slopePercent := (elevDiff / horizontalDist) * 100.0

			// Reject paths that exceed maximum slope
			if constraints.MaxSlope > 0 && slopePercent > constraints.MaxSlope {
				return -1
			}

			// Apply slope penalty: cost increases with slope
			slopePenalty := constraints.SlopePenalty
			if slopePenalty <= 0 {
				slopePenalty = 1.0 // Default penalty multiplier
			}
			baseCost += elevDiff * slopePenalty
		}
	}

	return baseCost
}

// inBounds checks whether a grid node is within the terrain bounds.
func inBounds(terrain *domain.TerrainGrid, n GridNode) bool {
	return n.Row >= 0 && n.Row < terrain.Height && n.Col >= 0 && n.Col < terrain.Width
}

// isInAvoidZone checks if a grid node falls within any avoidance zone.
// Each zone is defined as [minRow, minCol, maxRow, maxCol].
func isInAvoidZone(terrain *domain.TerrainGrid, n GridNode, zones [][]float64) bool {
	for _, zone := range zones {
		if len(zone) < 4 {
			continue
		}
		if float64(n.Row) >= zone[0] && float64(n.Col) >= zone[1] &&
			float64(n.Row) <= zone[2] && float64(n.Col) <= zone[3] {
			return true
		}
	}
	return false
}

// reconstructPath traces back from the goal to the start using the cameFrom map.
func reconstructPath(cameFrom map[GridNode]GridNode, current GridNode) []GridNode {
	var path []GridNode
	for {
		path = append([]GridNode{current}, path...)
		prev, ok := cameFrom[current]
		if !ok {
			break
		}
		current = prev
	}
	return path
}

// GridPathToWaypoints converts a grid path to geographic waypoints.
func GridPathToWaypoints(terrain *domain.TerrainGrid, path []GridNode) []domain.Waypoint {
	waypoints := make([]domain.Waypoint, len(path))
	for i, node := range path {
		lat := terrain.OriginLat + float64(node.Row)*terrain.CellSizeM/111320.0
		lon := terrain.OriginLon + float64(node.Col)*terrain.CellSizeM/(111320.0*math.Cos(terrain.OriginLat*math.Pi/180.0))
		elev := 0.0
		if terrain.Elevations != nil {
			elev = terrain.Elevations[node.Row][node.Col]
		}
		waypoints[i] = domain.Waypoint{
			Lon:       lon,
			Lat:       lat,
			Elevation: elev,
		}
	}
	return waypoints
}

// CalculatePathDistance computes the total path distance in meters.
func CalculatePathDistance(terrain *domain.TerrainGrid, path []GridNode) float64 {
	if len(path) < 2 {
		return 0
	}
	var total float64
	for i := 1; i < len(path); i++ {
		dr := float64(path[i].Row - path[i-1].Row)
		dc := float64(path[i].Col - path[i-1].Col)
		horz := math.Sqrt(dr*dr+dc*dc) * terrain.CellSizeM
		vert := 0.0
		if terrain.Elevations != nil {
			vert = terrain.Elevations[path[i].Row][path[i].Col] -
				terrain.Elevations[path[i-1].Row][path[i-1].Col]
		}
		total += math.Sqrt(horz*horz + vert*vert)
	}
	return total
}

