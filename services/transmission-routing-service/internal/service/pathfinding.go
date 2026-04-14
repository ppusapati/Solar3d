package service

import (
	"container/heap"
	"fmt"
	"math"

	"solar3d/transmission-routing-service/internal/domain"
)

type gridNode struct {
	Row int
	Col int
}

type astarNode struct {
	pos   gridNode
	gCost float64
	fCost float64
	index int
}

type priorityQueue []*astarNode

func (pq priorityQueue) Len() int           { return len(pq) }
func (pq priorityQueue) Less(i, j int) bool { return pq[i].fCost < pq[j].fCost }
func (pq priorityQueue) Swap(i, j int) {
	pq[i], pq[j] = pq[j], pq[i]
	pq[i].index = i
	pq[j].index = j
}
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

var neighborDirections = [8][2]int{{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {-1, -1}, {-1, 1}, {1, -1}, {1, 1}}

const undergroundCableCostMultiplier = 35.0

func calculateFallbackPath(req domain.CalculateTransmissionRouteRequest, constraints domain.TransmissionConstraints, costGrid [][]float64, allowUnderground bool) ([]domain.Waypoint, float64, error) {
	start := waypointToGrid(req.ElevationRaster, req.FarmOutputPoint)
	goal := waypointToGrid(req.ElevationRaster, req.GridInjectionPoint)
	start = clampToGrid(req.ElevationRaster, start)
	goal = clampToGrid(req.ElevationRaster, goal)

	openSet := &priorityQueue{}
	heap.Init(openSet)
	heap.Push(openSet, &astarNode{pos: start, gCost: 0, fCost: fallbackHeuristic(start, goal, req.ElevationRaster.CellSizeM)})

	cameFrom := map[gridNode]gridNode{}
	gScore := map[gridNode]float64{start: 0}
	closed := map[gridNode]bool{}

	for openSet.Len() > 0 {
		current := heap.Pop(openSet).(*astarNode)
		if current.pos == goal {
			path := reconstructFallbackPath(cameFrom, current.pos)
			waypoints := gridPathToWaypoints(req.ElevationRaster, path)
			return waypoints, calculatePathDistance(waypoints), nil
		}
		if closed[current.pos] {
			continue
		}
		closed[current.pos] = true

		for _, dir := range neighborDirections {
			neighbor := gridNode{Row: current.pos.Row + dir[0], Col: current.pos.Col + dir[1]}
			if !inRasterBounds(req.ElevationRaster, neighbor) || closed[neighbor] {
				continue
			}
			moveCost := fallbackMovementCost(req.ElevationRaster, costGrid, current.pos, neighbor, constraints, allowUnderground)
			if prev, ok := cameFrom[current.pos]; ok {
				turnAngle := deflectionAngleDeg(prev, current.pos, neighbor)
				effectiveMaxDeflection := constraints.MaxDeflectionDeg
				if effectiveMaxDeflection > 0 && effectiveMaxDeflection < 45 {
					// Raster paths move in 8 directions; any non-straight turn is at least 45 deg.
					effectiveMaxDeflection = 45
				}
				if effectiveMaxDeflection > 0 && turnAngle > effectiveMaxDeflection {
					continue
				}
				moveCost += turnPenaltyCost(moveCost, turnAngle, constraints)
			}
			if moveCost < 0 {
				continue
			}
			tentativeG := gScore[current.pos] + moveCost
			if existing, ok := gScore[neighbor]; ok && tentativeG >= existing {
				continue
			}
			gScore[neighbor] = tentativeG
			cameFrom[neighbor] = current.pos
			heap.Push(openSet, &astarNode{pos: neighbor, gCost: tentativeG, fCost: tentativeG + fallbackHeuristic(neighbor, goal, req.ElevationRaster.CellSizeM)})
		}
	}

	return nil, 0, fmt.Errorf("no transmission path found")
}

func fallbackHeuristic(a, b gridNode, cellSizeM float64) float64 {
	dr := float64(a.Row - b.Row)
	dc := float64(a.Col - b.Col)
	return math.Sqrt(dr*dr+dc*dc) * cellSizeM
}

func fallbackMovementCost(raster domain.ElevationRaster, costGrid [][]float64, from, to gridNode, constraints domain.TransmissionConstraints, allowUnderground bool) float64 {
	if !inRasterBounds(raster, from) || !inRasterBounds(raster, to) {
		return -1
	}
	multiplier := costGrid[to.Row][to.Col]
	if math.IsInf(multiplier, 1) {
		if !allowUnderground {
			return -1
		}
		multiplier = undergroundCableCostMultiplier
	} else if isUndergroundRequiredCost(multiplier) {
		if !allowUnderground {
			return -1
		}
		multiplier = undergroundCableCostMultiplier
	}
	if multiplier <= 0 {
		return -1
	}
	dr := float64(to.Row - from.Row)
	dc := float64(to.Col - from.Col)
	horizontal := math.Sqrt(dr*dr+dc*dc) * raster.CellSizeM
	fromElevation := raster.Elevations[from.Row*raster.Width+from.Col]
	toElevation := raster.Elevations[to.Row*raster.Width+to.Col]
	delta := math.Abs(toElevation - fromElevation)
	slopeDeg := 0.0
	if horizontal > 0 {
		slopeDeg = math.Atan(delta/horizontal) * 180.0 / math.Pi
	}
	if constraints.MaxSlopeDeg > 0 && slopeDeg > constraints.MaxSlopeDeg {
		return -1
	}
	baseCost := math.Sqrt(horizontal*horizontal + delta*delta)
	slopePenalty := 1.0 + (slopeDeg/math.Max(constraints.MaxSlopeDeg, 1.0))*constraints.SlopePenaltyFactor
	return baseCost * multiplier * slopePenalty
}

func deflectionAngleDeg(prev, current, next gridNode) float64 {
	v1x := float64(current.Col - prev.Col)
	v1y := float64(current.Row - prev.Row)
	v2x := float64(next.Col - current.Col)
	v2y := float64(next.Row - current.Row)

	mag1 := math.Sqrt(v1x*v1x + v1y*v1y)
	mag2 := math.Sqrt(v2x*v2x + v2y*v2y)
	if mag1 == 0 || mag2 == 0 {
		return 0
	}

	cosTheta := (v1x*v2x + v1y*v2y) / (mag1 * mag2)
	if cosTheta > 1 {
		cosTheta = 1
	}
	if cosTheta < -1 {
		cosTheta = -1
	}
	return math.Acos(cosTheta) * 180 / math.Pi
}

func turnPenaltyCost(stepCost, turnAngleDeg float64, constraints domain.TransmissionConstraints) float64 {
	if turnAngleDeg <= 0 {
		return 0
	}
	factor := constraints.TurnPenaltyFactor
	if factor <= 0 {
		factor = 1
	}
	normalized := turnAngleDeg / 90.0
	return stepCost * normalized * normalized * factor
}

func reconstructFallbackPath(cameFrom map[gridNode]gridNode, current gridNode) []gridNode {
	path := []gridNode{current}
	for {
		prev, ok := cameFrom[current]
		if !ok {
			break
		}
		current = prev
		path = append([]gridNode{current}, path...)
	}
	return path
}

func gridPathToWaypoints(raster domain.ElevationRaster, path []gridNode) []domain.Waypoint {
	waypoints := make([]domain.Waypoint, 0, len(path))
	lonScale := 111320.0 * math.Cos(raster.OriginLat*math.Pi/180.0)
	for _, node := range path {
		lat := raster.OriginLat + float64(node.Row)*raster.CellSizeM/111320.0
		lon := raster.OriginLon + float64(node.Col)*raster.CellSizeM/lonScale
		elevation := raster.Elevations[node.Row*raster.Width+node.Col]
		waypoints = append(waypoints, domain.Waypoint{Lon: lon, Lat: lat, Elevation: elevation})
	}
	return waypoints
}

func calculatePathDistance(path []domain.Waypoint) float64 {
	if len(path) < 2 {
		return 0
	}
	total := 0.0
	for index := 1; index < len(path); index++ {
		dx := (path[index].Lon - path[index-1].Lon) * 111320.0 * math.Cos(path[index-1].Lat*math.Pi/180.0)
		dy := (path[index].Lat - path[index-1].Lat) * 111320.0
		dz := path[index].Elevation - path[index-1].Elevation
		total += math.Sqrt(dx*dx + dy*dy + dz*dz)
	}
	return total
}

func waypointToGrid(raster domain.ElevationRaster, wp domain.Waypoint) gridNode {
	row := int(math.Round((wp.Lat - raster.OriginLat) * 111320.0 / raster.CellSizeM))
	lonScale := 111320.0 * math.Cos(raster.OriginLat*math.Pi/180.0)
	col := int(math.Round((wp.Lon - raster.OriginLon) * lonScale / raster.CellSizeM))
	return gridNode{Row: row, Col: col}
}

func clampToGrid(raster domain.ElevationRaster, node gridNode) gridNode {
	node.Row = clampInt(node.Row, 0, raster.Height-1)
	node.Col = clampInt(node.Col, 0, raster.Width-1)
	return node
}

func inRasterBounds(raster domain.ElevationRaster, node gridNode) bool {
	return node.Row >= 0 && node.Row < raster.Height && node.Col >= 0 && node.Col < raster.Width
}

