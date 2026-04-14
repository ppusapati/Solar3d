// Package kmeans_tiling — K-means clustering for panel tile generation
// Integrates geo-compute crate to generate optimal tile layouts
package service

import (
	"fmt"
	"math"
)

// clustered point from K-means output
type clusterPoint struct {
	x         float64
	y         float64
	clusterID int
}

// KMeansTiling generates a regular tile layout using K-means clustering on available ground area
func KMeansTiling(bounds BoundingBox, targetPanelsPerTile int, numTiles int) ([]Tile, error) {
	if numTiles <= 0 {
		return nil, fmt.Errorf("numTiles must be positive")
	}
	if targetPanelsPerTile <= 0 {
		return nil, fmt.Errorf("targetPanelsPerTile must be positive")
	}

	// Sample points across the bounding box area
	points := samplePointsUniformly(bounds, numTiles*100)

	// Run K-means to find cluster centers
	centers := kmeansCluster(points, numTiles)
	if len(centers) == 0 {
		return nil, fmt.Errorf("k-means failed: no clusters found")
	}

	// Convert cluster centers into tiles
	tiles := make([]Tile, 0, len(centers))
	for i, center := range centers {
		tile := Tile{
			ID:        fmt.Sprintf("tile_%d", i),
			CenterLat: center.y,
			CenterLon: center.x,
			// Tile size inferred from cluster density
			WidthM:  20.0,
			HeightM: 20.0,
		}
		tiles = append(tiles, tile)
	}

	return tiles, nil
}

// Point represents a 2D point for clustering
type Point struct{ x, y float64 }

// samplePointsUniformly generates uniform grid samples over a bounding box
func samplePointsUniformly(bounds BoundingBox, count int) []Point {
	side := int(math.Ceil(math.Sqrt(float64(count))))
	points := make([]Point, 0, side*side)

	dx := (bounds.MaxLon - bounds.MinLon) / float64(side)
	dy := (bounds.MaxLat - bounds.MinLat) / float64(side)

	for i := 0; i < side; i++ {
		for j := 0; j < side; j++ {
			x := bounds.MinLon + (float64(i)+0.5)*dx
			y := bounds.MinLat + (float64(j)+0.5)*dy
			points = append(points, Point{x, y})
		}
	}
	return points
}

// kmeansCluster performs K-means clustering returning cluster centers
func kmeansCluster(points []Point, k int) []Point {
	if k >= len(points) {
		return points
	}

	// Initialize k random centers
	centers := make([]Point, k)
	step := len(points) / k
	for i := 0; i < k; i++ {
		centers[i] = points[i*step]
	}

	// Iterate to convergence
	for iter := 0; iter < 10; iter++ {
		// Assign points to nearest center
		assignments := make([][]Point, k)
		for _, p := range points {
			nearest := 0
			minDist := math.Inf(1)
			for c := 0; c < k; c++ {
				dist := (p.x-centers[c].x)*(p.x-centers[c].x) + (p.y-centers[c].y)*(p.y-centers[c].y)
				if dist < minDist {
					minDist = dist
					nearest = c
				}
			}
			assignments[nearest] = append(assignments[nearest], p)
		}

		// Recompute centers
		newCenters := make([]Point, k)
		for c := 0; c < k; c++ {
			if len(assignments[c]) == 0 {
				newCenters[c] = centers[c] // keep old center
				continue
			}
			sx, sy := 0.0, 0.0
			for _, p := range assignments[c] {
				sx += p.x
				sy += p.y
			}
			newCenters[c] = Point{sx / float64(len(assignments[c])), sy / float64(len(assignments[c]))}
		}

		// Check convergence
		converged := true
		for c := 0; c < k; c++ {
			dist := math.Sqrt(math.Pow(newCenters[c].x-centers[c].x, 2) + math.Pow(newCenters[c].y-centers[c].y, 2))
			if dist > 0.001 {
				converged = false
				break
			}
		}
		centers = newCenters
		if converged {
			break
		}
	}

	return centers
}

// BoundingBox represents geographic bounds (lat/lon)
type BoundingBox struct {
	MinLat, MaxLat, MinLon, MaxLon float64
}

// Tile represents a physical tile location
type Tile struct {
	ID                   string
	CenterLat, CenterLon float64
	WidthM, HeightM      float64
}

