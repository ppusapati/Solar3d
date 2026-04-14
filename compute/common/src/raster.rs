use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct RasterGrid {
    pub width: usize,
    pub height: usize,
    pub resolution: f64,
    pub origin_x: f64,
    pub origin_y: f64,
    pub nodata: f64,
    pub data: Vec<f64>,
}

impl RasterGrid {
    pub fn new(
        width: usize,
        height: usize,
        resolution: f64,
        origin_x: f64,
        origin_y: f64,
        nodata: f64,
        data: Vec<f64>,
    ) -> Result<Self, String> {
        if width == 0 || height == 0 {
            return Err("width and height must be positive".to_string());
        }
        if !resolution.is_finite() || resolution <= 0.0 {
            return Err("resolution must be a finite positive value".to_string());
        }
        if data.len() != width * height {
            return Err("data length does not match width*height".to_string());
        }

        Ok(Self {
            width,
            height,
            resolution,
            origin_x,
            origin_y,
            nodata,
            data,
        })
    }

    pub fn get(&self, col: usize, row: usize) -> Option<f64> {
        if col >= self.width || row >= self.height {
            return None;
        }
        let v = self.data[row * self.width + col];
        if (v - self.nodata).abs() <= f64::EPSILON {
            None
        } else {
            Some(v)
        }
    }

    pub fn get_interpolated(&self, x: f64, y: f64) -> Option<f64> {
        let col_f = (x - self.origin_x) / self.resolution;
        let row_f = (y - self.origin_y) / self.resolution;

        if !col_f.is_finite() || !row_f.is_finite() {
            return None;
        }

        let col0 = col_f.floor() as isize;
        let row0 = row_f.floor() as isize;
        if col0 < 0 || row0 < 0 {
            return None;
        }

        let col0 = col0 as usize;
        let row0 = row0 as usize;
        let col1 = col0 + 1;
        let row1 = row0 + 1;

        if col1 >= self.width || row1 >= self.height {
            return None;
        }

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
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn raster_grid_validates_shape() {
        let err = RasterGrid::new(2, 2, 1.0, 0.0, 0.0, -9999.0, vec![1.0]).unwrap_err();
        assert!(err.contains("data length"));
    }

    #[test]
    fn raster_grid_interpolation_works() {
        let grid = RasterGrid::new(
            3,
            3,
            1.0,
            0.0,
            0.0,
            -9999.0,
            vec![0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0],
        )
        .expect("valid grid");

        let value = grid.get_interpolated(0.5, 0.5).expect("interpolated value");
        assert!((value - 2.0).abs() < 1e-6);
    }
}
