use serde::{Deserialize, Serialize};
use std::f64::consts::PI;

use crate::solar_position::SunPosition;

const DEG_TO_RAD: f64 = PI / 180.0;

/// Represents a 2D point in the local coordinate system (meters).
#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct Point2D {
    pub x: f64,
    pub y: f64,
}

/// Represents a 3D point with elevation.
#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct Point3D {
    pub x: f64,
    pub y: f64,
    pub z: f64,
}

/// A panel defined by its corner points and properties.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PanelGeometry {
    pub corners: [Point3D; 4],
    pub tilt: f64,
    pub azimuth: f64,
}

/// The projected shadow of a panel on the ground plane.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ShadowPolygon {
    pub vertices: Vec<Point2D>,
    pub source_panel_index: usize,
}

pub struct ShadowProjection;

impl ShadowProjection {
    /// Project the shadow of a single panel onto the ground plane given a sun position.
    ///
    /// Uses parallel projection from the sun direction to compute
    /// where each panel corner casts its shadow on z=ground_elevation.
    pub fn project_panel_shadow(
        panel: &PanelGeometry,
        sun: &SunPosition,
        ground_elevation: f64,
    ) -> Option<ShadowPolygon> {
        if sun.elevation <= 0.0 {
            return None;
        }

        let sun_az_rad = sun.azimuth * DEG_TO_RAD;
        let sun_el_rad = sun.elevation * DEG_TO_RAD;

        // Sun direction vector (pointing toward the sun)
        let sun_dx = -sun_el_rad.cos() * sun_az_rad.sin();
        let sun_dy = -sun_el_rad.cos() * sun_az_rad.cos();
        let sun_dz = sun_el_rad.sin();

        let mut shadow_vertices = Vec::with_capacity(4);

        for corner in &panel.corners {
            let dz = corner.z - ground_elevation;
            if dz <= 0.0 {
                shadow_vertices.push(Point2D {
                    x: corner.x,
                    y: corner.y,
                });
                continue;
            }

            // t = dz / sun_dz (how far along the sun ray to reach ground)
            let t = dz / sun_dz;
            let shadow_x = corner.x - sun_dx * t;
            let shadow_y = corner.y - sun_dy * t;

            shadow_vertices.push(Point2D {
                x: shadow_x,
                y: shadow_y,
            });
        }

        Some(ShadowPolygon {
            vertices: shadow_vertices,
            source_panel_index: 0,
        })
    }

    /// Compute shadows for multiple panels in parallel using rayon.
    pub fn project_shadows_parallel(
        panels: &[PanelGeometry],
        sun: &SunPosition,
        ground_elevation: f64,
    ) -> Vec<ShadowPolygon> {
        use rayon::prelude::*;

        panels
            .par_iter()
            .enumerate()
            .filter_map(|(i, panel)| {
                let mut shadow = Self::project_panel_shadow(panel, sun, ground_elevation)?;
                shadow.source_panel_index = i;
                Some(shadow)
            })
            .collect()
    }

    /// Check if a point is inside a shadow polygon using ray casting.
    pub fn point_in_shadow(point: &Point2D, shadow: &ShadowPolygon) -> bool {
        let n = shadow.vertices.len();
        if n < 3 {
            return false;
        }

        let mut inside = false;
        let mut j = n - 1;

        for i in 0..n {
            let vi = &shadow.vertices[i];
            let vj = &shadow.vertices[j];

            if ((vi.y > point.y) != (vj.y > point.y))
                && (point.x < (vj.x - vi.x) * (point.y - vi.y) / (vj.y - vi.y) + vi.x)
            {
                inside = !inside;
            }
            j = i;
        }

        inside
    }

    /// Calculate the shading factor for a panel (0.0 = no shade, 1.0 = full shade).
    ///
    /// Samples multiple points on the panel surface and checks shadow intersection.
    pub fn calculate_shading_factor(
        panel: &PanelGeometry,
        shadows: &[ShadowPolygon],
        panel_index: usize,
        sample_points: usize,
    ) -> f64 {
        if shadows.is_empty() {
            return 0.0;
        }

        let samples = sample_points.max(4);
        let grid_size = (samples as f64).sqrt().ceil() as usize;
        let mut shaded_count = 0;
        let total_samples = grid_size * grid_size;

        for i in 0..grid_size {
            for j in 0..grid_size {
                let u = (i as f64 + 0.5) / grid_size as f64;
                let v = (j as f64 + 0.5) / grid_size as f64;

                // Bilinear interpolation on panel surface
                let p = bilinear_interpolate(&panel.corners, u, v);
                let point = Point2D { x: p.x, y: p.y };

                for shadow in shadows {
                    if shadow.source_panel_index == panel_index {
                        continue; // Skip self-shading
                    }
                    if Self::point_in_shadow(&point, shadow) {
                        shaded_count += 1;
                        break;
                    }
                }
            }
        }

        shaded_count as f64 / total_samples as f64
    }
}

fn bilinear_interpolate(corners: &[Point3D; 4], u: f64, v: f64) -> Point3D {
    let p00 = corners[0];
    let p10 = corners[1];
    let p11 = corners[2];
    let p01 = corners[3];

    Point3D {
        x: p00.x * (1.0 - u) * (1.0 - v)
            + p10.x * u * (1.0 - v)
            + p11.x * u * v
            + p01.x * (1.0 - u) * v,
        y: p00.y * (1.0 - u) * (1.0 - v)
            + p10.y * u * (1.0 - v)
            + p11.y * u * v
            + p01.y * (1.0 - u) * v,
        z: p00.z * (1.0 - u) * (1.0 - v)
            + p10.z * u * (1.0 - v)
            + p11.z * u * v
            + p01.z * (1.0 - u) * v,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn make_test_panel(x: f64, y: f64, height: f64) -> PanelGeometry {
        PanelGeometry {
            corners: [
                Point3D { x, y, z: height },
                Point3D {
                    x: x + 2.0,
                    y,
                    z: height,
                },
                Point3D {
                    x: x + 2.0,
                    y: y + 1.0,
                    z: height + 0.5,
                },
                Point3D {
                    x,
                    y: y + 1.0,
                    z: height + 0.5,
                },
            ],
            tilt: 25.0,
            azimuth: 180.0,
        }
    }

    #[test]
    fn test_shadow_projection() {
        let panel = make_test_panel(0.0, 0.0, 1.0);
        let sun = SunPosition {
            azimuth: 180.0,
            elevation: 45.0,
            zenith: 45.0,
            hour_angle: 0.0,
            declination: 23.0,
        };

        let shadow = ShadowProjection::project_panel_shadow(&panel, &sun, 0.0);
        assert!(shadow.is_some());
        assert_eq!(shadow.unwrap().vertices.len(), 4);
    }

    #[test]
    fn test_no_shadow_at_night() {
        let panel = make_test_panel(0.0, 0.0, 1.0);
        let sun = SunPosition {
            azimuth: 0.0,
            elevation: -10.0,
            zenith: 100.0,
            hour_angle: 0.0,
            declination: 0.0,
        };

        let shadow = ShadowProjection::project_panel_shadow(&panel, &sun, 0.0);
        assert!(shadow.is_none());
    }

    #[test]
    fn test_point_in_shadow() {
        let shadow = ShadowPolygon {
            vertices: vec![
                Point2D { x: 0.0, y: 0.0 },
                Point2D { x: 4.0, y: 0.0 },
                Point2D { x: 4.0, y: 4.0 },
                Point2D { x: 0.0, y: 4.0 },
            ],
            source_panel_index: 0,
        };

        assert!(ShadowProjection::point_in_shadow(
            &Point2D { x: 2.0, y: 2.0 },
            &shadow
        ));
        assert!(!ShadowProjection::point_in_shadow(
            &Point2D { x: 5.0, y: 5.0 },
            &shadow
        ));
    }

    #[test]
    fn test_parallel_shadow_computation() {
        let panels: Vec<PanelGeometry> = (0..100)
            .map(|i| make_test_panel(i as f64 * 3.0, 0.0, 1.0))
            .collect();

        let sun = SunPosition {
            azimuth: 180.0,
            elevation: 45.0,
            zenith: 45.0,
            hour_angle: 0.0,
            declination: 23.0,
        };

        let shadows = ShadowProjection::project_shadows_parallel(&panels, &sun, 0.0);
        assert_eq!(shadows.len(), 100);
    }
}
