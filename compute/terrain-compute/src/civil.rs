//! Civil / Site Engineering Models
//!
//! 1. Grading analysis (cut/fill volume from target plane)
//! 2. Setback / easement / exclusion-zone polygon operations
//! 3. Drainage flow accumulation (D8 single-flow direction)
//! 4. Access road cost-surface routing (extends existing pathfinding)

use serde::{Deserialize, Serialize};
use std::f64::consts::PI;

// ========================================================================
// 1. Grading Analysis — Cut / Fill Volume
// ========================================================================

/// Cut/fill result for a grid cell or an entire site.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CutFillResult {
    /// Volume of material to be removed (m³). Positive.
    pub cut_volume_m3: f64,
    /// Volume of material to be added (m³). Positive.
    pub fill_volume_m3: f64,
    /// Net earthwork: positive = net cut, negative = net fill.
    pub net_volume_m3: f64,
    /// Number of cells with cut.
    pub cut_cells: u64,
    /// Number of cells with fill.
    pub fill_cells: u64,
}

/// Compute cut/fill volumes between an existing terrain grid and a target
/// design plane.
///
/// The target plane is defined by an elevation at a reference point and a
/// uniform slope (grade). For a flat pad, slope = 0.
///
/// # Arguments
/// * `existing_elevations` — Row-major grid of existing terrain elevations (m).
/// * `cols`, `rows` — Grid dimensions.
/// * `cell_size_m` — Cell size in metres (assumed square).
/// * `target_elevation_m` — Design elevation at the grid origin (m).
/// * `target_slope_ns` — North-south grade (rise/run, e.g., 0.02 = 2 %).
/// * `target_slope_ew` — East-west grade (rise/run).
pub fn compute_cut_fill(
    existing_elevations: &[f64],
    cols: usize,
    rows: usize,
    cell_size_m: f64,
    target_elevation_m: f64,
    target_slope_ns: f64,
    target_slope_ew: f64,
) -> CutFillResult {
    let cell_area = cell_size_m * cell_size_m;
    let mut cut = 0.0_f64;
    let mut fill = 0.0_f64;
    let mut cut_cells = 0u64;
    let mut fill_cells = 0u64;

    for row in 0..rows {
        for col in 0..cols {
            let idx = row * cols + col;
            if idx >= existing_elevations.len() {
                continue;
            }
            let existing = existing_elevations[idx];
            if existing.is_nan() {
                continue;
            }

            let target = target_elevation_m
                + target_slope_ns * (row as f64 * cell_size_m)
                + target_slope_ew * (col as f64 * cell_size_m);

            let diff = existing - target;
            if diff > 0.0 {
                cut += diff * cell_area;
                cut_cells += 1;
            } else if diff < 0.0 {
                fill += (-diff) * cell_area;
                fill_cells += 1;
            }
        }
    }

    CutFillResult {
        cut_volume_m3: cut,
        fill_volume_m3: fill,
        net_volume_m3: cut - fill,
        cut_cells,
        fill_cells,
    }
}

// ========================================================================
// 2. Exclusion Zones / Setbacks
// ========================================================================

/// A 2D polygon defining an exclusion zone, setback, or easement.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ExclusionZone {
    pub id: String,
    pub zone_type: ExclusionType,
    /// Polygon vertices as (x, y) pairs in site-local coordinates.
    /// The polygon is implicitly closed (last vertex connects to first).
    pub vertices: Vec<(f64, f64)>,
    /// Buffer distance (m) to apply around the polygon. Positive = outward.
    pub buffer_m: f64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum ExclusionType {
    Setback,
    Easement,
    Wetland,
    Flood,
    Heritage,
    Utility,
    Access,
    Custom,
}

/// Test whether a point is inside an exclusion zone (including buffer).
/// Uses the ray-casting algorithm for point-in-polygon.
pub fn point_in_exclusion_zone(zone: &ExclusionZone, x: f64, y: f64) -> bool {
    // First check the buffered bounding box for early rejection.
    if zone.vertices.is_empty() {
        return false;
    }

    let buf = zone.buffer_m;
    let x_min = zone.vertices.iter().map(|v| v.0).fold(f64::INFINITY, f64::min) - buf;
    let x_max = zone.vertices.iter().map(|v| v.0).fold(f64::NEG_INFINITY, f64::max) + buf;
    let y_min = zone.vertices.iter().map(|v| v.1).fold(f64::INFINITY, f64::min) - buf;
    let y_max = zone.vertices.iter().map(|v| v.1).fold(f64::NEG_INFINITY, f64::max) + buf;

    if x < x_min || x > x_max || y < y_min || y > y_max {
        return false;
    }

    // If buffer > 0, check distance to polygon boundary
    if buf > 0.0 {
        let dist = distance_to_polygon(&zone.vertices, x, y);
        if dist <= buf {
            return true;
        }
    }

    // Ray-casting for point-in-polygon
    point_in_polygon(&zone.vertices, x, y)
}

/// Ray-casting point-in-polygon test.
fn point_in_polygon(vertices: &[(f64, f64)], px: f64, py: f64) -> bool {
    let n = vertices.len();
    if n < 3 {
        return false;
    }
    let mut inside = false;
    let mut j = n - 1;
    for i in 0..n {
        let (xi, yi) = vertices[i];
        let (xj, yj) = vertices[j];
        if ((yi > py) != (yj > py)) && (px < (xj - xi) * (py - yi) / (yj - yi) + xi) {
            inside = !inside;
        }
        j = i;
    }
    inside
}

/// Minimum distance from point (px, py) to the polygon boundary.
fn distance_to_polygon(vertices: &[(f64, f64)], px: f64, py: f64) -> f64 {
    let n = vertices.len();
    if n == 0 {
        return f64::INFINITY;
    }
    let mut min_dist = f64::INFINITY;
    for i in 0..n {
        let j = (i + 1) % n;
        let d = point_to_segment_distance(px, py, vertices[i].0, vertices[i].1, vertices[j].0, vertices[j].1);
        if d < min_dist {
            min_dist = d;
        }
    }
    min_dist
}

fn point_to_segment_distance(px: f64, py: f64, x1: f64, y1: f64, x2: f64, y2: f64) -> f64 {
    let dx = x2 - x1;
    let dy = y2 - y1;
    let len_sq = dx * dx + dy * dy;
    if len_sq < 1e-12 {
        return ((px - x1).powi(2) + (py - y1).powi(2)).sqrt();
    }
    let t = ((px - x1) * dx + (py - y1) * dy) / len_sq;
    let t = t.clamp(0.0, 1.0);
    let proj_x = x1 + t * dx;
    let proj_y = y1 + t * dy;
    ((px - proj_x).powi(2) + (py - proj_y).powi(2)).sqrt()
}

/// Filter a list of panel positions, returning only those outside all
/// exclusion zones.
pub fn filter_panels_by_exclusions(
    positions: &[(f64, f64)],
    zones: &[ExclusionZone],
) -> Vec<(f64, f64)> {
    positions
        .iter()
        .filter(|&&(x, y)| !zones.iter().any(|z| point_in_exclusion_zone(z, x, y)))
        .cloned()
        .collect()
}

// ========================================================================
// 3. Drainage / Flow Accumulation (D8)
// ========================================================================

/// D8 flow direction constants (encoded as power-of-2 bitmask).
/// Convention: 1=E, 2=SE, 4=S, 8=SW, 16=W, 32=NW, 64=N, 128=NE.
const D8_DX: [i32; 8] = [1, 1, 0, -1, -1, -1, 0, 1];
const D8_DY: [i32; 8] = [0, 1, 1, 1, 0, -1, -1, -1];

/// Compute D8 flow direction grid from an elevation grid.
///
/// Each cell is assigned the direction of steepest descent to one of its
/// 8 neighbours. Flat cells and pits are assigned direction 0 (no flow).
///
/// Reference: O'Callaghan, J.F., Mark, D.M. (1984). "The extraction of
/// drainage networks from digital elevation data". Computer Vision,
/// Graphics, and Image Processing, 28(3), 323-344.
pub fn d8_flow_direction(
    elevation: &[f64],
    cols: usize,
    rows: usize,
    cell_size_m: f64,
) -> Vec<u8> {
    let n = cols * rows;
    let mut flow_dir = vec![0u8; n];
    let diag = (2.0_f64).sqrt();

    for row in 0..rows {
        for col in 0..cols {
            let idx = row * cols + col;
            let elev = elevation[idx];
            if elev.is_nan() {
                continue;
            }

            let mut max_slope = 0.0_f64;
            let mut best_dir = 0u8;

            for d in 0..8usize {
                let nc = col as i32 + D8_DX[d];
                let nr = row as i32 + D8_DY[d];
                if nc < 0 || nr < 0 || nc >= cols as i32 || nr >= rows as i32 {
                    continue;
                }
                let nidx = nr as usize * cols + nc as usize;
                let nelev = elevation[nidx];
                if nelev.is_nan() {
                    continue;
                }
                let dist = if d % 2 == 0 { cell_size_m } else { cell_size_m * diag };
                let slope = (elev - nelev) / dist;
                if slope > max_slope {
                    max_slope = slope;
                    best_dir = 1u8 << d;
                }
            }
            flow_dir[idx] = best_dir;
        }
    }
    flow_dir
}

/// Compute flow accumulation from a D8 flow direction grid.
///
/// Each cell's accumulation value = number of upstream cells that drain
/// through it (including itself). High-accumulation cells indicate
/// drainage channels.
pub fn flow_accumulation(
    flow_dir: &[u8],
    cols: usize,
    rows: usize,
) -> Vec<u32> {
    let n = cols * rows;
    let mut acc = vec![1u32; n]; // each cell counts itself
    let mut in_degree = vec![0u32; n];

    // Compute in-degrees
    for row in 0..rows {
        for col in 0..cols {
            let idx = row * cols + col;
            let dir = flow_dir[idx];
            if dir == 0 { continue; }
            let d = dir.trailing_zeros() as usize;
            if d >= 8 { continue; }
            let nc = col as i32 + D8_DX[d];
            let nr = row as i32 + D8_DY[d];
            if nc >= 0 && nr >= 0 && (nc as usize) < cols && (nr as usize) < rows {
                let nidx = nr as usize * cols + nc as usize;
                in_degree[nidx] += 1;
            }
        }
    }

    // Topological sort (Kahn's algorithm)
    let mut queue: Vec<usize> = (0..n).filter(|&i| in_degree[i] == 0).collect();
    while let Some(idx) = queue.pop() {
        let dir = flow_dir[idx];
        if dir == 0 { continue; }
        let d = dir.trailing_zeros() as usize;
        if d >= 8 { continue; }
        let col = idx % cols;
        let row = idx / cols;
        let nc = col as i32 + D8_DX[d];
        let nr = row as i32 + D8_DY[d];
        if nc >= 0 && nr >= 0 && (nc as usize) < cols && (nr as usize) < rows {
            let nidx = nr as usize * cols + nc as usize;
            acc[nidx] += acc[idx];
            in_degree[nidx] -= 1;
            if in_degree[nidx] == 0 {
                queue.push(nidx);
            }
        }
    }
    acc
}

/// Identify drainage risk cells: cells with flow accumulation above a threshold.
pub fn drainage_risk_cells(
    accumulation: &[u32],
    threshold: u32,
) -> Vec<usize> {
    accumulation.iter().enumerate()
        .filter(|&(_, &acc)| acc >= threshold)
        .map(|(i, _)| i)
        .collect()
}

// ========================================================================
// 4. Access Road Designer
// ========================================================================

/// Compute road construction cost surface from terrain slope.
///
/// Steeper slopes cost more to grade for road construction. The cost surface
/// can be fed into the existing A* pathfinder to find minimum-cost access
/// road routes.
///
/// # Arguments
/// * `slope_degrees` — Grid of terrain slope in degrees (from `compute_slope_grid`).
/// * `cols`, `rows` — Grid dimensions.
/// * `base_cost_per_m` — Flat-terrain road cost per metre ($/m).
/// * `slope_multiplier` — Cost multiplier per degree of slope.
///   E.g., 0.05 → a 10° slope costs 1 + 0.05 × 10 = 1.5× base cost.
/// * `max_grade_pct` — Maximum allowable road grade (%). Cells exceeding
///   this are assigned infinite cost (impassable).
///
/// # Returns
/// Cost grid suitable for pathfinding (row-major, same dimensions as input).
pub fn road_cost_surface(
    slope_degrees: &[f64],
    _cols: usize,
    _rows: usize,
    base_cost_per_m: f64,
    slope_multiplier: f64,
    max_grade_pct: f64,
) -> Vec<f64> {
    let max_slope_deg = (max_grade_pct / 100.0).atan() * 180.0 / PI;
    slope_degrees.iter().map(|&slope| {
        if slope.is_nan() || slope > max_slope_deg {
            f64::INFINITY
        } else {
            base_cost_per_m * (1.0 + slope_multiplier * slope)
        }
    }).collect()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn cut_fill_flat_target() {
        // 3×3 grid, existing terrain slopes from 100 to 104
        let existing = vec![
            100.0, 101.0, 102.0,
            101.0, 102.0, 103.0,
            102.0, 103.0, 104.0,
        ];
        let result = compute_cut_fill(&existing, 3, 3, 1.0, 102.0, 0.0, 0.0);
        // Cells above 102: 103(×2), 104(×1) → cut = (1+1+2) = 4 m³
        // Cells below 102: 100(×1), 101(×2) → fill = (2+1+1) = 4 m³
        assert!((result.cut_volume_m3 - 4.0).abs() < 0.01, "cut={}", result.cut_volume_m3);
        assert!((result.fill_volume_m3 - 4.0).abs() < 0.01, "fill={}", result.fill_volume_m3);
        assert!((result.net_volume_m3).abs() < 0.01, "net should be ~0");
    }

    #[test]
    fn exclusion_zone_point_inside() {
        let zone = ExclusionZone {
            id: "setback-1".into(),
            zone_type: ExclusionType::Setback,
            vertices: vec![(0.0, 0.0), (10.0, 0.0), (10.0, 10.0), (0.0, 10.0)],
            buffer_m: 0.0,
        };
        assert!(point_in_exclusion_zone(&zone, 5.0, 5.0));
        assert!(!point_in_exclusion_zone(&zone, 15.0, 5.0));
    }

    #[test]
    fn exclusion_zone_with_buffer() {
        let zone = ExclusionZone {
            id: "easement-1".into(),
            zone_type: ExclusionType::Easement,
            vertices: vec![(0.0, 0.0), (10.0, 0.0), (10.0, 10.0), (0.0, 10.0)],
            buffer_m: 2.0,
        };
        // Point just outside the polygon but within buffer
        assert!(point_in_exclusion_zone(&zone, 11.0, 5.0));
        // Point far outside
        assert!(!point_in_exclusion_zone(&zone, 20.0, 5.0));
    }

    #[test]
    fn filter_panels() {
        let panels = vec![(5.0, 5.0), (15.0, 5.0), (25.0, 5.0)];
        let zones = vec![ExclusionZone {
            id: "z1".into(),
            zone_type: ExclusionType::Wetland,
            vertices: vec![(0.0, 0.0), (10.0, 0.0), (10.0, 10.0), (0.0, 10.0)],
            buffer_m: 0.0,
        }];
        let kept = filter_panels_by_exclusions(&panels, &zones);
        assert_eq!(kept.len(), 2); // (5,5) excluded, (15,5) and (25,5) kept
    }

    #[test]
    fn d8_simple_slope() {
        // 3×3 grid sloping from NW to SE
        let elev = vec![
            9.0, 8.0, 7.0,
            6.0, 5.0, 4.0,
            3.0, 2.0, 1.0,
        ];
        let fdir = d8_flow_direction(&elev, 3, 3, 1.0);
        // Centre cell (5.0): steepest descent is S to cell value 2.0
        // (slope 3.0/1m) vs SE to 1.0 (slope 4.0/1.414m = 2.83).
        // S = index 2 = bit 2 = value 4.
        assert_eq!(fdir[4], 4, "centre should flow S, got {}", fdir[4]);
    }

    #[test]
    fn flow_accumulation_simple() {
        // Linear slope: 3 → 2 → 1 (3 cells in a row)
        let elev = vec![3.0, 2.0, 1.0];
        let fdir = d8_flow_direction(&elev, 3, 1, 1.0);
        let acc = flow_accumulation(&fdir, 3, 1);
        // Cell 0 drains to cell 1, cell 1 drains to cell 2
        // acc[0]=1, acc[1]=2, acc[2]=3
        assert_eq!(acc[0], 1);
        assert_eq!(acc[1], 2);
        assert_eq!(acc[2], 3);
    }

    #[test]
    fn drainage_risk() {
        let acc = vec![1, 2, 5, 10, 1, 1, 3, 20, 2];
        let risk = drainage_risk_cells(&acc, 5);
        assert_eq!(risk, vec![2, 3, 7]);
    }

    #[test]
    fn road_cost_impassable() {
        let slopes = vec![5.0, 15.0, 25.0];
        let costs = road_cost_surface(&slopes, 3, 1, 100.0, 0.05, 20.0);
        // 20% grade = atan(0.20) ≈ 11.3° — so 25° exceeds max
        assert!(costs[2].is_infinite(), "25° should be impassable");
        assert!(costs[0].is_finite(), "5° should be passable");
    }
}
