use serde::{Deserialize, Serialize};

/// A grid of elevation values representing terrain.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ElevationGrid {
    pub width: usize,
    pub height: usize,
    pub resolution: f64,
    pub origin_x: f64,
    pub origin_y: f64,
    pub data: Vec<f64>,
    pub nodata: f64,
}

impl ElevationGrid {
    pub fn new(
        width: usize,
        height: usize,
        resolution: f64,
        origin_x: f64,
        origin_y: f64,
        data: Vec<f64>,
    ) -> Self {
        assert_eq!(data.len(), width * height);
        Self {
            width,
            height,
            resolution,
            origin_x,
            origin_y,
            data,
            nodata: -9999.0,
        }
    }

    /// Get elevation at grid coordinates.
    pub fn get(&self, col: usize, row: usize) -> Option<f64> {
        if col >= self.width || row >= self.height {
            return None;
        }
        let val = self.data[row * self.width + col];
        if (val - self.nodata).abs() < f64::EPSILON {
            None
        } else {
            Some(val)
        }
    }

    /// Get elevation at world coordinates using bilinear interpolation.
    pub fn get_interpolated(&self, x: f64, y: f64) -> Option<f64> {
        let col_f = (x - self.origin_x) / self.resolution;
        let row_f = (y - self.origin_y) / self.resolution;

        let col0 = col_f.floor() as isize;
        let row0 = row_f.floor() as isize;

        if col0 < 0 || row0 < 0 {
            return None;
        }

        let col0 = col0 as usize;
        let row0 = row0 as usize;
        let col1 = col0 + 1;
        let row1 = row0 + 1;

        let z00 = self.get(col0, row0)?;
        let z10 = self.get(col1, row0)?;
        let z01 = self.get(col0, row1)?;
        let z11 = self.get(col1, row1)?;

        let fx = col_f - col0 as f64;
        let fy = row_f - row0 as f64;

        Some(
            z00 * (1.0 - fx) * (1.0 - fy)
                + z10 * fx * (1.0 - fy)
                + z01 * (1.0 - fx) * fy
                + z11 * fx * fy,
        )
    }

    pub fn min_elevation(&self) -> f64 {
        self.data
            .iter()
            .filter(|v| (**v - self.nodata).abs() > f64::EPSILON)
            .cloned()
            .fold(f64::MAX, f64::min)
    }

    pub fn max_elevation(&self) -> f64 {
        self.data
            .iter()
            .filter(|v| (**v - self.nodata).abs() > f64::EPSILON)
            .cloned()
            .fold(f64::MIN, f64::max)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn make_test_grid() -> ElevationGrid {
        // 3x3 grid: 0,1,2 / 3,4,5 / 6,7,8
        ElevationGrid::new(
            3,
            3,
            1.0,
            0.0,
            0.0,
            vec![0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0],
        )
    }

    #[test]
    fn test_grid_get() {
        let grid = make_test_grid();
        assert_eq!(grid.get(0, 0), Some(0.0));
        assert_eq!(grid.get(1, 1), Some(4.0));
        assert_eq!(grid.get(2, 2), Some(8.0));
        assert_eq!(grid.get(3, 0), None);
    }

    #[test]
    fn test_interpolation() {
        let grid = make_test_grid();
        let val = grid.get_interpolated(0.5, 0.5).unwrap();
        assert!((val - 2.0).abs() < 0.01);
    }

    #[test]
    fn test_min_max() {
        let grid = make_test_grid();
        assert_eq!(grid.min_elevation(), 0.0);
        assert_eq!(grid.max_elevation(), 8.0);
    }
}
