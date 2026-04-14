use serde::{Deserialize, Serialize};
use std::cmp::Ordering;
use std::collections::{BinaryHeap, HashMap};

use crate::elevation::ElevationGrid;

/// A point on the routing grid.
#[derive(Debug, Clone, Copy, Hash, Eq, PartialEq, Serialize, Deserialize)]
pub struct GridCell {
    pub col: usize,
    pub row: usize,
}

/// A waypoint in world coordinates.
#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct Waypoint {
    pub x: f64,
    pub y: f64,
    pub elevation: f64,
}

/// Route constraints for pathfinding.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RouteConstraints {
    pub max_slope_percent: f64,
    pub slope_penalty_factor: f64,
    pub avoid_cells: Vec<GridCell>,
}

impl Default for RouteConstraints {
    fn default() -> Self {
        Self {
            max_slope_percent: 15.0,
            slope_penalty_factor: 2.0,
            avoid_cells: Vec::new(),
        }
    }
}

/// Result of a pathfinding operation.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RouteResult {
    pub waypoints: Vec<Waypoint>,
    pub total_distance: f64,
    pub max_slope_encountered: f64,
    pub cells_visited: usize,
}

#[derive(Debug, Clone)]
struct AStarNode {
    cell: GridCell,
    f_cost: f64,
}

impl PartialEq for AStarNode {
    fn eq(&self, other: &Self) -> bool {
        self.f_cost == other.f_cost
    }
}

impl Eq for AStarNode {}

impl Ord for AStarNode {
    fn cmp(&self, other: &Self) -> Ordering {
        other
            .f_cost
            .partial_cmp(&self.f_cost)
            .unwrap_or(Ordering::Equal)
    }
}

impl PartialOrd for AStarNode {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

/// A* pathfinding router that works on elevation grids.
pub struct AStarRouter<'a> {
    dem: &'a ElevationGrid,
    constraints: RouteConstraints,
}

impl<'a> AStarRouter<'a> {
    pub fn new(dem: &'a ElevationGrid, constraints: RouteConstraints) -> Self {
        Self { dem, constraints }
    }

    /// Find the optimal route from source to destination using A* with terrain penalties.
    pub fn find_route(&self, source: GridCell, destination: GridCell) -> Option<RouteResult> {
        let avoid_set: std::collections::HashSet<GridCell> =
            self.constraints.avoid_cells.iter().cloned().collect();

        let mut open_set = BinaryHeap::new();
        let mut g_scores: HashMap<GridCell, f64> = HashMap::new();
        let mut came_from: HashMap<GridCell, GridCell> = HashMap::new();
        let mut cells_visited = 0;

        g_scores.insert(source, 0.0);
        open_set.push(AStarNode {
            cell: source,
            f_cost: self.heuristic(source, destination),
        });

        while let Some(current) = open_set.pop() {
            cells_visited += 1;

            if current.cell == destination {
                return Some(self.reconstruct_path(&came_from, destination, cells_visited));
            }

            let current_g = g_scores[&current.cell];

            for neighbor in self.neighbors(current.cell) {
                if avoid_set.contains(&neighbor) {
                    continue;
                }

                let move_cost = self.movement_cost(current.cell, neighbor)?;
                let tentative_g = current_g + move_cost;

                if tentative_g < *g_scores.get(&neighbor).unwrap_or(&f64::MAX) {
                    came_from.insert(neighbor, current.cell);
                    g_scores.insert(neighbor, tentative_g);

                    open_set.push(AStarNode {
                        cell: neighbor,
                        f_cost: tentative_g + self.heuristic(neighbor, destination),
                    });
                }
            }
        }

        None // No path found
    }

    /// Find a route using world coordinates.
    pub fn find_route_world(&self, source: Waypoint, destination: Waypoint) -> Option<RouteResult> {
        let src_cell = self.world_to_grid(source.x, source.y)?;
        let dst_cell = self.world_to_grid(destination.x, destination.y)?;
        self.find_route(src_cell, dst_cell)
    }

    fn world_to_grid(&self, x: f64, y: f64) -> Option<GridCell> {
        let col = ((x - self.dem.origin_x) / self.dem.resolution).floor() as isize;
        let row = ((y - self.dem.origin_y) / self.dem.resolution).floor() as isize;

        if col >= 0
            && row >= 0
            && (col as usize) < self.dem.width
            && (row as usize) < self.dem.height
        {
            Some(GridCell {
                col: col as usize,
                row: row as usize,
            })
        } else {
            None
        }
    }

    fn grid_to_world(&self, cell: GridCell) -> Waypoint {
        let x = self.dem.origin_x + (cell.col as f64 + 0.5) * self.dem.resolution;
        let y = self.dem.origin_y + (cell.row as f64 + 0.5) * self.dem.resolution;
        let elevation = self.dem.get(cell.col, cell.row).unwrap_or(0.0);
        Waypoint { x, y, elevation }
    }

    fn heuristic(&self, from: GridCell, to: GridCell) -> f64 {
        let dx = (from.col as f64 - to.col as f64).abs();
        let dy = (from.row as f64 - to.row as f64).abs();
        (dx * dx + dy * dy).sqrt() * self.dem.resolution
    }

    fn neighbors(&self, cell: GridCell) -> Vec<GridCell> {
        let directions: [(isize, isize); 8] = [
            (-1, -1),
            (0, -1),
            (1, -1),
            (-1, 0),
            (1, 0),
            (-1, 1),
            (0, 1),
            (1, 1),
        ];

        directions
            .iter()
            .filter_map(|(dc, dr)| {
                let nc = cell.col as isize + dc;
                let nr = cell.row as isize + dr;
                if nc >= 0
                    && nr >= 0
                    && (nc as usize) < self.dem.width
                    && (nr as usize) < self.dem.height
                {
                    Some(GridCell {
                        col: nc as usize,
                        row: nr as usize,
                    })
                } else {
                    None
                }
            })
            .collect()
    }

    fn movement_cost(&self, from: GridCell, to: GridCell) -> Option<f64> {
        let z_from = self.dem.get(from.col, from.row)?;
        let z_to = self.dem.get(to.col, to.row)?;

        let dx = (to.col as f64 - from.col as f64) * self.dem.resolution;
        let dy = (to.row as f64 - from.row as f64) * self.dem.resolution;
        let horizontal_dist = (dx * dx + dy * dy).sqrt();
        let dz = (z_to - z_from).abs();

        let slope_percent = if horizontal_dist > 0.0 {
            (dz / horizontal_dist) * 100.0
        } else {
            0.0
        };

        // Reject paths that exceed max slope
        if slope_percent > self.constraints.max_slope_percent {
            return None;
        }

        // Base cost is the 3D distance
        let base_cost = (horizontal_dist * horizontal_dist + dz * dz).sqrt();

        // Add slope penalty
        let penalty = 1.0 + (slope_percent / 100.0) * self.constraints.slope_penalty_factor;

        Some(base_cost * penalty)
    }

    fn reconstruct_path(
        &self,
        came_from: &HashMap<GridCell, GridCell>,
        destination: GridCell,
        cells_visited: usize,
    ) -> RouteResult {
        let mut path = vec![destination];
        let mut current = destination;

        while let Some(&prev) = came_from.get(&current) {
            path.push(prev);
            current = prev;
        }

        path.reverse();

        let mut total_distance = 0.0;
        let mut max_slope: f64 = 0.0;
        let mut waypoints: Vec<Waypoint> = Vec::with_capacity(path.len());

        for (i, cell) in path.iter().enumerate() {
            waypoints.push(self.grid_to_world(*cell));

            if i > 0 {
                let prev = &waypoints[i - 1];
                let curr = &waypoints[i];
                let dx = curr.x - prev.x;
                let dy = curr.y - prev.y;
                let dz = curr.elevation - prev.elevation;
                let horiz = (dx * dx + dy * dy).sqrt();
                total_distance += (horiz * horiz + dz * dz).sqrt();

                if horiz > 0.0 {
                    let slope = (dz.abs() / horiz) * 100.0;
                    max_slope = max_slope.max(slope);
                }
            }
        }

        RouteResult {
            waypoints,
            total_distance,
            max_slope_encountered: max_slope,
            cells_visited,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn make_flat_grid() -> ElevationGrid {
        ElevationGrid::new(10, 10, 1.0, 0.0, 0.0, vec![100.0; 100])
    }

    #[test]
    fn test_simple_route() {
        let grid = make_flat_grid();
        let router = AStarRouter::new(&grid, RouteConstraints::default());

        let result = router.find_route(GridCell { col: 0, row: 0 }, GridCell { col: 9, row: 9 });

        assert!(result.is_some());
        let route = result.unwrap();
        assert!(route.waypoints.len() >= 2);
        assert!(route.total_distance > 0.0);
    }

    #[test]
    fn test_route_with_obstacle() {
        let grid = make_flat_grid();
        let constraints = RouteConstraints {
            max_slope_percent: 15.0,
            slope_penalty_factor: 2.0,
            avoid_cells: vec![
                GridCell { col: 5, row: 0 },
                GridCell { col: 5, row: 1 },
                GridCell { col: 5, row: 2 },
                GridCell { col: 5, row: 3 },
                GridCell { col: 5, row: 4 },
                GridCell { col: 5, row: 5 },
                GridCell { col: 5, row: 6 },
                GridCell { col: 5, row: 7 },
                GridCell { col: 5, row: 8 },
            ],
        };

        let router = AStarRouter::new(&grid, constraints);
        let result = router.find_route(GridCell { col: 0, row: 5 }, GridCell { col: 9, row: 5 });

        assert!(result.is_some());
        let route = result.unwrap();
        // Route should go around the obstacle
        for wp in &route.waypoints {
            let col = ((wp.x - grid.origin_x) / grid.resolution).floor() as usize;
            let row = ((wp.y - grid.origin_y) / grid.resolution).floor() as usize;
            if col == 5 && row <= 8 {
                // Route should only pass through col=5 at row=9 (the gap)
                assert_eq!(row, 9, "Route went through obstacle");
            }
        }
    }

    #[test]
    fn test_steep_terrain_avoidance() {
        let mut data = vec![100.0; 100];
        // Create a steep wall at col=5 with a one-cell gap at the bottom.
        for row in 0..9 {
            data[row * 10 + 5] = 200.0;
        }

        let grid = ElevationGrid::new(10, 10, 1.0, 0.0, 0.0, data);
        let constraints = RouteConstraints {
            max_slope_percent: 50.0, // Allow some slope but penalize it
            slope_penalty_factor: 10.0,
            avoid_cells: Vec::new(),
        };

        let router = AStarRouter::new(&grid, constraints);
        let result = router.find_route(GridCell { col: 0, row: 5 }, GridCell { col: 9, row: 5 });

        // Every crossing from col=4 to col=5 exceeds max_slope_percent, so no route should exist.
        assert!(result.is_none());
    }
}
