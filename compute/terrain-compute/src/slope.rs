use rayon::prelude::*;
use std::f64::consts::PI;

use crate::elevation::ElevationGrid;

const RAD_TO_DEG: f64 = 180.0 / PI;

/// Compute slope grid from an elevation grid using the Horn algorithm.
///
/// Returns slope values in degrees. Uses parallel computation for performance.
pub fn compute_slope_grid(dem: &ElevationGrid) -> ElevationGrid {
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

                    // Horn's method (3x3 window)
                    let dz_dx =
                        ((z(col + 1, row - 1) + 2.0 * z(col + 1, row) + z(col + 1, row + 1))
                            - (z(col - 1, row - 1) + 2.0 * z(col - 1, row) + z(col - 1, row + 1)))
                            / (8.0 * res);

                    let dz_dy =
                        ((z(col - 1, row + 1) + 2.0 * z(col, row + 1) + z(col + 1, row + 1))
                            - (z(col - 1, row - 1) + 2.0 * z(col, row - 1) + z(col + 1, row - 1)))
                            / (8.0 * res);

                    let slope_rad = (dz_dx * dz_dx + dz_dy * dz_dy).sqrt().atan();
                    slope_rad * RAD_TO_DEG
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
    fn test_flat_terrain_slope() {
        let flat = ElevationGrid::new(5, 5, 1.0, 0.0, 0.0, vec![10.0; 25]);
        let slope = compute_slope_grid(&flat);
        // Interior cells should have zero slope
        assert!((slope.get(2, 2).unwrap()).abs() < 0.001);
    }

    #[test]
    fn test_sloped_terrain() {
        // Create a terrain with consistent east-west slope
        let mut data = vec![0.0; 25];
        for row in 0..5 {
            for col in 0..5 {
                data[row * 5 + col] = col as f64 * 10.0;
            }
        }
        let dem = ElevationGrid::new(5, 5, 1.0, 0.0, 0.0, data);
        let slope = compute_slope_grid(&dem);
        let center_slope = slope.get(2, 2).unwrap();
        assert!(
            center_slope > 80.0,
            "Steep slope expected: {}",
            center_slope
        );
    }
}
