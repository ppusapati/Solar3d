use rayon::prelude::*;
use std::f64::consts::PI;

use crate::elevation::ElevationGrid;

const RAD_TO_DEG: f64 = 180.0 / PI;

/// Compute aspect grid from an elevation grid.
///
/// Returns aspect in degrees clockwise from north (0-360).
/// Uses Horn's method for gradient computation.
pub fn compute_aspect_grid(dem: &ElevationGrid) -> ElevationGrid {
    let width = dem.width;
    let height = dem.height;
    let res = dem.resolution;

    let data: Vec<f64> = (0..height)
        .into_par_iter()
        .flat_map(|row| {
            (0..width)
                .map(|col| {
                    if row == 0 || row == height - 1 || col == 0 || col == width - 1 {
                        return dem.nodata;
                    }

                    let z = |c: usize, r: usize| -> f64 { dem.get(c, r).unwrap_or(dem.nodata) };

                    let dz_dx =
                        ((z(col + 1, row - 1) + 2.0 * z(col + 1, row) + z(col + 1, row + 1))
                            - (z(col - 1, row - 1) + 2.0 * z(col - 1, row) + z(col - 1, row + 1)))
                            / (8.0 * res);

                    let dz_dy =
                        ((z(col - 1, row + 1) + 2.0 * z(col, row + 1) + z(col + 1, row + 1))
                            - (z(col - 1, row - 1) + 2.0 * z(col, row - 1) + z(col + 1, row - 1)))
                            / (8.0 * res);

                    if dz_dx.abs() < f64::EPSILON && dz_dy.abs() < f64::EPSILON {
                        return -1.0; // Flat area
                    }

                    // Compute aspect: angle from north, clockwise
                    let mut aspect = dz_dy.atan2(-dz_dx) * RAD_TO_DEG;
                    if aspect < 0.0 {
                        aspect += 360.0;
                    }
                    // Convert from mathematical angle to compass bearing
                    aspect = 90.0 - aspect;
                    if aspect < 0.0 {
                        aspect += 360.0;
                    }
                    aspect
                })
                .collect::<Vec<f64>>()
        })
        .collect();

    ElevationGrid {
        width,
        height,
        resolution: res,
        origin_x: dem.origin_x,
        origin_y: dem.origin_y,
        data,
        nodata: dem.nodata,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_flat_terrain_aspect() {
        let flat = ElevationGrid::new(5, 5, 1.0, 0.0, 0.0, vec![10.0; 25]);
        let aspect = compute_aspect_grid(&flat);
        assert_eq!(aspect.get(2, 2), Some(-1.0)); // Flat
    }
}
