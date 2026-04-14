use serde::{Deserialize, Serialize};
use std::cmp::Ordering;
use std::collections::HashMap;

use crate::elevation::ElevationGrid;
use crate::pathfinding::{GridCell, Waypoint};

const UNDERGROUND_REQUIRED_COST_MARKER: f64 = -1_000_000.0;
const UNDERGROUND_CABLE_PATH_MULTIPLIER: f64 = 35.0;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CostGrid {
    pub width: usize,
    pub height: usize,
    pub data: Vec<f64>,
}

impl CostGrid {
    pub fn new(width: usize, height: usize, data: Vec<f64>) -> Self {
        assert_eq!(data.len(), width * height);
        Self {
            width,
            height,
            data,
        }
    }

    pub fn get(&self, col: usize, row: usize) -> Option<f64> {
        if col >= self.width || row >= self.height {
            return None;
        }
        Some(self.data[row * self.width + col])
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TransmissionConstraints {
    pub min_span_m: f64,
    pub max_span_m: f64,
    pub row_width_m: f64,
    pub max_slope_deg: f64,
    pub max_deflection_deg: f64,
    pub slope_penalty_factor: f64,
    pub turn_penalty_factor: f64,
    pub water_crossing_cost_mult: f64,
    pub road_parallel_discount: f64,
}

impl Default for TransmissionConstraints {
    fn default() -> Self {
        Self {
            min_span_m: 80.0,
            max_span_m: 150.0,
            row_width_m: 12.0,
            max_slope_deg: 18.0,
            max_deflection_deg: 45.0,
            slope_penalty_factor: 2.0,
            turn_penalty_factor: 1.5,
            water_crossing_cost_mult: 8.0,
            road_parallel_discount: 0.7,
        }
    }
}

#[derive(Debug, Clone, Copy)]
pub enum VoltageClass {
    V11kV,
    V33kV,
    HT66kV,
    HT132kV,
    HT220kV,
    HT400kV,
}

impl VoltageClass {
    pub fn parse(value: &str) -> Self {
        match value {
            "11kv" => Self::V11kV,
            "ht_66kv" => Self::HT66kV,
            "ht_132kv" => Self::HT132kV,
            "ht_220kv" => Self::HT220kV,
            "ht_400kv" => Self::HT400kV,
            _ => Self::V33kV,
        }
    }

    fn defaults(self) -> (f64, f64, f64, f64, f64, f64, f64, f64, f64) {
        match self {
            Self::V11kV => (50.0, 100.0, 8.0, 20.0, 50.0, 1.2, 12_000.0, 2_500.0, 3.0),
            Self::V33kV => (80.0, 150.0, 12.0, 18.0, 45.0, 1.5, 22_000.0, 8_000.0, 5.0),
            Self::HT66kV => (140.0, 250.0, 18.0, 18.0, 45.0, 1.5, 42_000.0, 18_000.0, 7.0),
            Self::HT132kV => (180.0, 320.0, 27.0, 16.0, 40.0, 1.8, 76_000.0, 32_000.0, 9.0),
            Self::HT220kV => (
                220.0, 380.0, 35.0, 14.0, 35.0, 2.2, 130_000.0, 52_000.0, 12.0,
            ),
            Self::HT400kV => (
                280.0, 500.0, 52.0, 12.0, 30.0, 2.8, 220_000.0, 94_000.0, 18.0,
            ),
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TowerPosition {
    pub x: f64,
    pub y: f64,
    pub elevation: f64,
    pub span_m: f64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SegmentExplanation {
    pub from_index: i32,
    pub slope_deg: f64,
    pub land_type: String,
    pub cost_multiplier: f64,
    pub decision_reason: String,
    pub installation_mode: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TransmissionResult {
    pub waypoints: Vec<Waypoint>,
    pub tower_positions: Vec<TowerPosition>,
    pub distance_m: f64,
    pub conductor_cost: f64,
    pub tower_cost: f64,
    pub row_acquisition_cost: f64,
    pub crossing_premium: f64,
    pub total_cost: f64,
    pub cost_per_km: f64,
    pub segment_explanations: Vec<SegmentExplanation>,
    pub route_summary: String,
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

pub struct TransmissionPathfinder<'a> {
    dem: &'a ElevationGrid,
    cost_grid: &'a CostGrid,
    constraints: TransmissionConstraints,
    voltage_class: VoltageClass,
}

impl<'a> TransmissionPathfinder<'a> {
    pub fn new(
        dem: &'a ElevationGrid,
        cost_grid: &'a CostGrid,
        constraints: TransmissionConstraints,
        voltage_class: VoltageClass,
    ) -> Self {
        Self {
            dem,
            cost_grid,
            constraints: resolve_constraints(voltage_class, constraints),
            voltage_class,
        }
    }

    pub fn find_route_world(
        &self,
        source: Waypoint,
        destination: Waypoint,
    ) -> Option<TransmissionResult> {
        let src_cell = self.world_to_grid(source.x, source.y)?;
        let dst_cell = self.world_to_grid(destination.x, destination.y)?;
        self.find_route(src_cell, dst_cell)
    }

    pub fn find_route(
        &self,
        source: GridCell,
        destination: GridCell,
    ) -> Option<TransmissionResult> {
        let mut open_set = std::collections::BinaryHeap::new();
        let mut g_scores: HashMap<GridCell, f64> = HashMap::new();
        let mut came_from: HashMap<GridCell, GridCell> = HashMap::new();

        g_scores.insert(source, 0.0);
        open_set.push(AStarNode {
            cell: source,
            f_cost: self.heuristic(source, destination),
        });

        while let Some(current) = open_set.pop() {
            if current.cell == destination {
                return self.reconstruct_path(&came_from, destination);
            }

            let current_g = match g_scores.get(&current.cell) {
                Some(value) => *value,
                None => continue,
            };

            for neighbor in self.neighbors(current.cell) {
                let mut move_cost = match self.movement_cost(current.cell, neighbor) {
                    Some(value) => value,
                    None => continue,
                };
                if let Some(previous) = came_from.get(&current.cell) {
                    let turn_angle = deflection_angle_deg(*previous, current.cell, neighbor);
                    let mut effective_max_deflection = self.constraints.max_deflection_deg;
                    if effective_max_deflection > 0.0 && effective_max_deflection < 45.0 {
                        effective_max_deflection = 45.0;
                    }
                    if effective_max_deflection > 0.0 && turn_angle > effective_max_deflection {
                        continue;
                    }
                    move_cost += turn_penalty_cost(
                        move_cost,
                        turn_angle,
                        self.constraints.turn_penalty_factor,
                    );
                }
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

        None
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
        let raw_multiplier = self.cost_grid.get(to.col, to.row)?;
        if !raw_multiplier.is_finite() {
            return None;
        }
        let multiplier = if is_underground_required_cost(raw_multiplier) {
            UNDERGROUND_CABLE_PATH_MULTIPLIER
        } else {
            raw_multiplier
        };
        if multiplier <= 0.0 {
            return None;
        }

        let dx = (to.col as f64 - from.col as f64) * self.dem.resolution;
        let dy = (to.row as f64 - from.row as f64) * self.dem.resolution;
        let horizontal = (dx * dx + dy * dy).sqrt();
        let dz = (z_to - z_from).abs();
        let slope_deg = if horizontal > 0.0 {
            (dz / horizontal).atan().to_degrees()
        } else {
            0.0
        };

        if slope_deg > self.constraints.max_slope_deg {
            return None;
        }

        let base_cost = (horizontal * horizontal + dz * dz).sqrt();
        let normalized_slope = if self.constraints.max_slope_deg > 0.0 {
            slope_deg / self.constraints.max_slope_deg
        } else {
            0.0
        };
        let slope_penalty = 1.0 + normalized_slope.powi(2) * self.constraints.slope_penalty_factor;
        Some(base_cost * multiplier * slope_penalty)
    }

    fn reconstruct_path(
        &self,
        came_from: &HashMap<GridCell, GridCell>,
        destination: GridCell,
    ) -> Option<TransmissionResult> {
        let mut path = vec![destination];
        let mut current = destination;
        while let Some(prev) = came_from.get(&current) {
            current = *prev;
            path.push(current);
        }
        path.reverse();

        let mut waypoints = Vec::with_capacity(path.len());
        let mut distance_m = 0.0;
        for (index, cell) in path.iter().enumerate() {
            let point = self.grid_to_world(*cell);
            if index > 0 {
                distance_m += waypoint_distance(&waypoints[index - 1], &point);
            }
            waypoints.push(point);
        }

        let tower_positions = self.place_towers(&waypoints);
        let (segment_explanations, crossing_premium) = self.explain_segments(&waypoints);
        let (conductor_cost, tower_cost, row_acquisition_cost, total_cost, cost_per_km) =
            self.compute_costs(distance_m, tower_positions.len(), crossing_premium);
        let route_summary = format!(
            "Selected {:?} corridor over {:.2} km with {} support positions and estimated total cost {:.2}",
            self.voltage_class,
            distance_m / 1000.0,
            tower_positions.len(),
            total_cost
        );

        Some(TransmissionResult {
            waypoints,
            tower_positions,
            distance_m,
            conductor_cost,
            tower_cost,
            row_acquisition_cost,
            crossing_premium,
            total_cost,
            cost_per_km,
            segment_explanations,
            route_summary,
        })
    }

    fn place_towers(&self, waypoints: &[Waypoint]) -> Vec<TowerPosition> {
        if waypoints.is_empty() {
            return Vec::new();
        }
        let mut towers = vec![TowerPosition {
            x: waypoints[0].x,
            y: waypoints[0].y,
            elevation: waypoints[0].elevation,
            span_m: 0.0,
        }];
        let mut accumulated = 0.0;

        for index in 1..waypoints.len() {
            accumulated += waypoint_distance(&waypoints[index - 1], &waypoints[index]);
            if accumulated >= self.constraints.min_span_m || index == waypoints.len() - 1 {
                towers.push(TowerPosition {
                    x: waypoints[index].x,
                    y: waypoints[index].y,
                    elevation: waypoints[index].elevation,
                    span_m: accumulated.min(self.constraints.max_span_m),
                });
                accumulated = 0.0;
            }
        }

        towers
    }

    fn explain_segments(&self, waypoints: &[Waypoint]) -> (Vec<SegmentExplanation>, f64) {
        let mut explanations = Vec::new();
        let mut crossing_premium = 0.0;

        for index in 1..waypoints.len() {
            let previous = &waypoints[index - 1];
            let current = &waypoints[index];
            let horizontal = horizontal_distance(previous, current);
            let dz = (current.elevation - previous.elevation).abs();
            let slope_deg = if horizontal > 0.0 {
                (dz / horizontal).atan().to_degrees()
            } else {
                0.0
            };
            let cell = match self.world_to_grid(current.x, current.y) {
                Some(value) => value,
                None => continue,
            };
            let raw_multiplier = self.cost_grid.get(cell.col, cell.row).unwrap_or(1.0);
            let mut effective_multiplier = raw_multiplier;
            let (land_type, decision_reason, installation_mode) = if is_underground_required_cost(
                raw_multiplier,
            ) {
                effective_multiplier = UNDERGROUND_CABLE_PATH_MULTIPLIER;
                crossing_premium +=
                    waypoint_distance(previous, current) * (effective_multiplier - 1.0);
                (
                    "underground_required_cable".to_string(),
                    "underground-only corridor enforced by corridor policy or surface constraints"
                        .to_string(),
                    "underground".to_string(),
                )
            } else if effective_multiplier >= self.constraints.water_crossing_cost_mult {
                crossing_premium +=
                    waypoint_distance(previous, current) * (effective_multiplier - 1.0);
                (
                    "water".to_string(),
                    "water crossing accepted because alternative detours were longer or steeper"
                        .to_string(),
                    "overhead".to_string(),
                )
            } else if effective_multiplier < 1.0 {
                (
                    "road_corridor".to_string(),
                    "segment follows a lower-cost road-adjacent corridor".to_string(),
                    "overhead".to_string(),
                )
            } else if effective_multiplier > 1.5 {
                (
                    "sensitive_land".to_string(),
                    "higher-cost land crossed only where alternatives were less feasible"
                        .to_string(),
                    "overhead".to_string(),
                )
            } else {
                (
                    "open".to_string(),
                    "selected lowest integrated terrain and ROW cost corridor".to_string(),
                    "overhead".to_string(),
                )
            };
            explanations.push(SegmentExplanation {
                from_index: (index - 1) as i32,
                slope_deg,
                land_type,
                cost_multiplier: effective_multiplier,
                decision_reason,
                installation_mode,
            });
        }

        (explanations, crossing_premium)
    }

    fn compute_costs(
        &self,
        distance_m: f64,
        tower_count: usize,
        crossing_premium: f64,
    ) -> (f64, f64, f64, f64, f64) {
        let (_, _, row_width_m, _, _, _, conductor_cost_km, tower_unit_cost, row_cost_m2) =
            self.voltage_class.defaults();
        let conductor_cost = (distance_m / 1000.0) * conductor_cost_km;
        let tower_cost = tower_count as f64 * tower_unit_cost;
        let row_acquisition_cost = distance_m * row_width_m * row_cost_m2;
        let total_cost = conductor_cost + tower_cost + row_acquisition_cost + crossing_premium;
        let cost_per_km = if distance_m > 0.0 {
            total_cost / (distance_m / 1000.0)
        } else {
            0.0
        };
        (
            conductor_cost,
            tower_cost,
            row_acquisition_cost,
            total_cost,
            cost_per_km,
        )
    }
}

fn resolve_constraints(
    voltage_class: VoltageClass,
    mut constraints: TransmissionConstraints,
) -> TransmissionConstraints {
    let (
        min_span_m,
        max_span_m,
        row_width_m,
        max_slope_deg,
        max_deflection_deg,
        turn_penalty_factor,
        _,
        _,
        _,
    ) = voltage_class.defaults();
    if constraints.min_span_m <= 0.0 {
        constraints.min_span_m = min_span_m;
    }
    if constraints.max_span_m <= 0.0 {
        constraints.max_span_m = max_span_m;
    }
    if constraints.row_width_m <= 0.0 {
        constraints.row_width_m = row_width_m;
    }
    if constraints.max_slope_deg <= 0.0 {
        constraints.max_slope_deg = max_slope_deg;
    }
    if constraints.max_deflection_deg <= 0.0 {
        constraints.max_deflection_deg = max_deflection_deg;
    }
    if constraints.slope_penalty_factor <= 0.0 {
        constraints.slope_penalty_factor = 2.0;
    }
    if constraints.turn_penalty_factor <= 0.0 {
        constraints.turn_penalty_factor = turn_penalty_factor;
    }
    if constraints.water_crossing_cost_mult <= 0.0 {
        constraints.water_crossing_cost_mult = 8.0;
    }
    if constraints.road_parallel_discount <= 0.0 {
        constraints.road_parallel_discount = 0.7;
    }
    constraints
}

fn waypoint_distance(a: &Waypoint, b: &Waypoint) -> f64 {
    let horizontal = horizontal_distance(a, b);
    let dz = b.elevation - a.elevation;
    (horizontal * horizontal + dz * dz).sqrt()
}

fn deflection_angle_deg(previous: GridCell, current: GridCell, next: GridCell) -> f64 {
    let v1x = current.col as f64 - previous.col as f64;
    let v1y = current.row as f64 - previous.row as f64;
    let v2x = next.col as f64 - current.col as f64;
    let v2y = next.row as f64 - current.row as f64;
    let mag1 = (v1x * v1x + v1y * v1y).sqrt();
    let mag2 = (v2x * v2x + v2y * v2y).sqrt();
    if mag1 == 0.0 || mag2 == 0.0 {
        return 0.0;
    }
    let cos_theta = ((v1x * v2x + v1y * v2y) / (mag1 * mag2)).clamp(-1.0, 1.0);
    cos_theta.acos().to_degrees()
}

fn turn_penalty_cost(step_cost: f64, turn_angle_deg: f64, turn_penalty_factor: f64) -> f64 {
    if turn_angle_deg <= 0.0 {
        return 0.0;
    }
    let factor = if turn_penalty_factor > 0.0 {
        turn_penalty_factor
    } else {
        1.0
    };
    let normalized = turn_angle_deg / 90.0;
    step_cost * normalized * normalized * factor
}

fn horizontal_distance(a: &Waypoint, b: &Waypoint) -> f64 {
    let dx = (b.x - a.x) * 111_320.0 * a.y.to_radians().cos();
    let dy = (b.y - a.y) * 111_320.0;
    (dx * dx + dy * dy).sqrt()
}

fn is_underground_required_cost(value: f64) -> bool {
    value == UNDERGROUND_REQUIRED_COST_MARKER
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_deflection_angle_deg_for_right_turn() {
        let angle = deflection_angle_deg(
            GridCell { col: 0, row: 0 },
            GridCell { col: 1, row: 0 },
            GridCell { col: 1, row: 1 },
        );
        assert!((angle - 90.0).abs() < 1e-6);
    }

    #[test]
    fn test_turn_penalty_cost_scales_with_angle() {
        assert_eq!(turn_penalty_cost(100.0, 0.0, 1.8), 0.0);
        assert!(turn_penalty_cost(100.0, 45.0, 1.8) > 0.0);
        assert!(turn_penalty_cost(100.0, 90.0, 1.8) > turn_penalty_cost(100.0, 45.0, 1.8));
    }

    #[test]
    fn test_resolve_constraints_applies_phase2_defaults() {
        let resolved =
            resolve_constraints(VoltageClass::HT132kV, TransmissionConstraints::default());
        assert_eq!(resolved.max_deflection_deg, 45.0);
        assert_eq!(resolved.turn_penalty_factor, 1.5);

        let resolved_220 = resolve_constraints(
            VoltageClass::HT220kV,
            TransmissionConstraints {
                max_deflection_deg: 0.0,
                turn_penalty_factor: 0.0,
                ..TransmissionConstraints::default()
            },
        );
        assert_eq!(resolved_220.max_deflection_deg, 35.0);
        assert_eq!(resolved_220.turn_penalty_factor, 2.2);
    }

    #[test]
    fn test_underground_required_cost_marker_is_detected() {
        assert!(is_underground_required_cost(
            UNDERGROUND_REQUIRED_COST_MARKER
        ));
        assert!(!is_underground_required_cost(1.0));
    }
}
