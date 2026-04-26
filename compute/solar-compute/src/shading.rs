//! Shading Analysis
//!
//! Comprehensive shading model covering:
//! 1. Horizon profile from terrain DEM (near-field + far-field)
//! 2. 3D obstacle shadow casting (trees, buildings, structures)
//! 3. Self-shading between adjacent rows
//! 4. Hourly shading mask per panel (8760-hour annual profile)
//!
//! All geometry uses a local ENU (East-North-Up) coordinate system centred on
//! the site. Elevations are in metres. Angles are in degrees unless suffixed
//! with `_rad`.

use std::f64::consts::PI;
use serde::{Deserialize, Serialize};

const DEG_TO_RAD: f64 = PI / 180.0;
const RAD_TO_DEG: f64 = 180.0 / PI;

// ========================================================================
// 1. Horizon Profile
// ========================================================================

/// A single azimuth–elevation pair describing the horizon line.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HorizonPoint {
    /// Compass azimuth (degrees, 0=N, 90=E, 180=S, 270=W).
    pub azimuth_deg: f64,
    /// Elevation angle above the horizontal plane (degrees). 0 = flat horizon,
    /// positive = terrain rises above the observer.
    pub elevation_deg: f64,
}

/// A complete horizon profile — a sorted series of azimuth–elevation pairs
/// covering 0°–360°.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HorizonProfile {
    pub points: Vec<HorizonPoint>,
}

/// A single DEM grid cell for horizon computation.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DEMCell {
    /// Easting relative to observer (m).
    pub east_m: f64,
    /// Northing relative to observer (m).
    pub north_m: f64,
    /// Terrain elevation above sea level (m).
    pub elevation_m: f64,
}

impl HorizonProfile {
    /// Compute horizon profile from a DEM grid. The observer is at the origin
    /// (0, 0) at the given elevation. For each azimuth sector the maximum
    /// elevation angle from any DEM cell in that sector is recorded.
    ///
    /// Reference: Dozier, J., Frew, J. (1990). "Rapid Calculation of Terrain
    /// Parameters for Radiation Modeling from Digital Elevation Data". IEEE
    /// Transactions on Geoscience and Remote Sensing, 28(5), 963-969.
    ///
    /// # Arguments
    /// * `dem` — DEM cells in local ENU coordinates relative to observer.
    /// * `observer_elevation_m` — Observer (panel) elevation above sea level.
    /// * `azimuth_resolution_deg` — Angular resolution of the profile (e.g., 1.0
    ///   for 360 sectors, 5.0 for 72 sectors).
    /// * `max_distance_m` — Ignore DEM cells beyond this distance (performance).
    pub fn from_dem(
        dem: &[DEMCell],
        observer_elevation_m: f64,
        azimuth_resolution_deg: f64,
        max_distance_m: f64,
    ) -> Self {
        let n_sectors = (360.0 / azimuth_resolution_deg).ceil() as usize;
        let mut max_elev = vec![0.0_f64; n_sectors];

        for cell in dem {
            let dx = cell.east_m;
            let dy = cell.north_m;
            let dist = (dx * dx + dy * dy).sqrt();

            if dist < 1.0 || dist > max_distance_m {
                continue;
            }

            // Azimuth from observer to cell (0=N, 90=E)
            let az = dx.atan2(dy) * RAD_TO_DEG;
            let az = if az < 0.0 { az + 360.0 } else { az };

            // Elevation angle
            let dz = cell.elevation_m - observer_elevation_m;
            let elev = (dz / dist).atan() * RAD_TO_DEG;

            let sector = ((az / azimuth_resolution_deg).floor() as usize).min(n_sectors - 1);
            if elev > max_elev[sector] {
                max_elev[sector] = elev;
            }
        }

        let points = (0..n_sectors)
            .map(|i| HorizonPoint {
                azimuth_deg: i as f64 * azimuth_resolution_deg + azimuth_resolution_deg / 2.0,
                elevation_deg: max_elev[i].max(0.0),
            })
            .collect();

        HorizonProfile { points }
    }

    /// Check whether the sun is blocked by the horizon at a given solar position.
    ///
    /// # Arguments
    /// * `solar_azimuth_deg` — Sun azimuth (degrees, 0=N).
    /// * `solar_elevation_deg` — Sun elevation above horizon (degrees).
    ///
    /// # Returns
    /// `true` if the sun is below the horizon profile (blocked), `false` if visible.
    pub fn is_sun_blocked(&self, solar_azimuth_deg: f64, solar_elevation_deg: f64) -> bool {
        if self.points.is_empty() {
            return false;
        }
        let horizon_elev = self.interpolate_elevation(solar_azimuth_deg);
        solar_elevation_deg < horizon_elev
    }

    /// Look up the maximum horizon elevation at the given azimuth.
    /// Uses the nearest sector centre (no interpolation) to avoid diluting
    /// narrow terrain features between sector boundaries.
    fn interpolate_elevation(&self, azimuth_deg: f64) -> f64 {
        let n = self.points.len();
        if n == 0 {
            return 0.0;
        }
        let az = azimuth_deg.rem_euclid(360.0);

        // Find the sector whose centre is closest to the query azimuth.
        let mut best_idx = 0;
        let mut best_dist = 360.0_f64;
        for (i, p) in self.points.iter().enumerate() {
            let d = (p.azimuth_deg - az).abs().min((p.azimuth_deg - az + 360.0).abs()).min((p.azimuth_deg - az - 360.0).abs());
            if d < best_dist {
                best_dist = d;
                best_idx = i;
            }
        }

        // Also check the adjacent sectors and return the maximum — a
        // conservative approach that prevents the horizon from being
        // under-estimated at sector boundaries.
        let prev = if best_idx == 0 { n - 1 } else { best_idx - 1 };
        let next = (best_idx + 1) % n;

        self.points[best_idx].elevation_deg
            .max(self.points[prev].elevation_deg)
            .max(self.points[next].elevation_deg)
    }
}

// ========================================================================
// 2. 3D Obstacle Geometry
// ========================================================================

/// Axis-aligned bounding box for an obstacle in local ENU coordinates.
/// Suitable for buildings, equipment shelters, and other prismatic structures.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ObstacleBox {
    pub id: String,
    /// Centre position (E, N) relative to site origin (m).
    pub centre_east_m: f64,
    pub centre_north_m: f64,
    /// Dimensions.
    pub width_m: f64,  // E-W extent
    pub depth_m: f64,  // N-S extent
    pub height_m: f64, // vertical extent above ground
    /// Ground elevation at the obstacle base (m ASL).
    pub base_elevation_m: f64,
}

/// A cylindrical obstacle (trees, poles, tanks).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ObstacleCylinder {
    pub id: String,
    pub centre_east_m: f64,
    pub centre_north_m: f64,
    pub radius_m: f64,
    pub height_m: f64,
    pub base_elevation_m: f64,
    /// Crown radius for trees (additional shadow spread at top).
    pub crown_radius_m: f64,
}

// ========================================================================
// 3. Shadow Casting
// ========================================================================

/// Result of shadow analysis for a single point at a single timestep.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ShadowResult {
    /// Whether the point is shaded.
    pub is_shaded: bool,
    /// ID of the obstacle causing shade (empty if unshaded).
    pub obstacle_id: String,
    /// Shadow intensity (0 = full sun, 1 = full shade). Partial shading from
    /// tree crowns or diffuse edges uses values between 0 and 1.
    pub intensity: f64,
}

/// Cast shadows from a box obstacle onto a ground point.
///
/// Uses a simplified projection: the obstacle's top edge projects a shadow
/// in the direction opposite to the sun vector, with length proportional
/// to the obstacle height divided by tan(solar_elevation).
///
/// # Arguments
/// * `obs` — The box obstacle.
/// * `point_east_m`, `point_north_m` — The ground point to test.
/// * `point_elevation_m` — Ground elevation at the test point (m ASL).
/// * `solar_azimuth_deg` — Sun azimuth (0=N).
/// * `solar_elevation_deg` — Sun elevation above horizon (degrees).
pub fn box_shadow_at_point(
    obs: &ObstacleBox,
    point_east_m: f64,
    point_north_m: f64,
    point_elevation_m: f64,
    solar_azimuth_deg: f64,
    solar_elevation_deg: f64,
) -> ShadowResult {
    if solar_elevation_deg <= 0.0 {
        return ShadowResult { is_shaded: false, obstacle_id: String::new(), intensity: 0.0 };
    }

    let sun_az_rad = solar_azimuth_deg * DEG_TO_RAD;
    let sun_el_rad = solar_elevation_deg * DEG_TO_RAD;
    let shadow_len = (obs.height_m + obs.base_elevation_m - point_elevation_m) / sun_el_rad.tan();

    if shadow_len <= 0.0 {
        return ShadowResult { is_shaded: false, obstacle_id: String::new(), intensity: 0.0 };
    }

    // Shadow projects opposite to the sun direction
    let shadow_dir_e = -(sun_az_rad.sin());
    let shadow_dir_n = -(sun_az_rad.cos());

    // Test if point falls within the shadow footprint.
    // The shadow footprint is the obstacle's base rectangle projected along
    // the shadow direction by shadow_len.
    let hw = obs.width_m / 2.0;
    let hd = obs.depth_m / 2.0;

    // Vector from obstacle centre to point
    let dx = point_east_m - obs.centre_east_m;
    let dy = point_north_m - obs.centre_north_m;

    // Project onto shadow direction
    let along = dx * shadow_dir_e + dy * shadow_dir_n;
    if along < 0.0 || along > shadow_len {
        return ShadowResult { is_shaded: false, obstacle_id: String::new(), intensity: 0.0 };
    }

    // Cross-shadow check: perpendicular distance to shadow centreline
    let cross = (-dx * shadow_dir_n + dy * shadow_dir_e).abs();
    let effective_half_width = hw.max(hd); // conservative: use larger of width/depth

    if cross <= effective_half_width {
        ShadowResult {
            is_shaded: true,
            obstacle_id: obs.id.clone(),
            intensity: 1.0,
        }
    } else {
        ShadowResult { is_shaded: false, obstacle_id: String::new(), intensity: 0.0 }
    }
}

/// Cast shadow from a cylindrical obstacle (tree) onto a ground point.
/// The shadow footprint is an ellipse; the crown radius extends the shadow
/// width at the top.
pub fn cylinder_shadow_at_point(
    obs: &ObstacleCylinder,
    point_east_m: f64,
    point_north_m: f64,
    point_elevation_m: f64,
    solar_azimuth_deg: f64,
    solar_elevation_deg: f64,
) -> ShadowResult {
    if solar_elevation_deg <= 0.0 {
        return ShadowResult { is_shaded: false, obstacle_id: String::new(), intensity: 0.0 };
    }

    let sun_az_rad = solar_azimuth_deg * DEG_TO_RAD;
    let sun_el_rad = solar_elevation_deg * DEG_TO_RAD;
    let effective_height = obs.height_m + obs.base_elevation_m - point_elevation_m;
    let shadow_len = effective_height / sun_el_rad.tan();

    if shadow_len <= 0.0 {
        return ShadowResult { is_shaded: false, obstacle_id: String::new(), intensity: 0.0 };
    }

    let shadow_dir_e = -(sun_az_rad.sin());
    let shadow_dir_n = -(sun_az_rad.cos());

    let dx = point_east_m - obs.centre_east_m;
    let dy = point_north_m - obs.centre_north_m;

    let along = dx * shadow_dir_e + dy * shadow_dir_n;
    if along < -obs.radius_m || along > shadow_len + obs.crown_radius_m {
        return ShadowResult { is_shaded: false, obstacle_id: String::new(), intensity: 0.0 };
    }

    let cross = (-dx * shadow_dir_n + dy * shadow_dir_e).abs();

    // Shadow width: trunk radius at base, expanding to crown radius at tip.
    let frac = (along / shadow_len).clamp(0.0, 1.0);
    let effective_radius = obs.radius_m * (1.0 - frac) + obs.crown_radius_m * frac;

    if cross <= effective_radius {
        // Trees produce partial shade (canopy is semi-transparent).
        // Intensity decreases toward the crown edge.
        let edge_frac = cross / effective_radius.max(0.01);
        let intensity = if obs.crown_radius_m > 0.0 {
            (1.0 - edge_frac * 0.5).clamp(0.3, 1.0) // min 30 % shade from canopy
        } else {
            1.0 // solid obstacle
        };
        ShadowResult {
            is_shaded: true,
            obstacle_id: obs.id.clone(),
            intensity,
        }
    } else {
        ShadowResult { is_shaded: false, obstacle_id: String::new(), intensity: 0.0 }
    }
}

// ========================================================================
// 4. Self-Shading (Inter-Row)
// ========================================================================

/// Compute the self-shading fraction for a module in a row behind another row.
///
/// When the sun is low, the front row casts a shadow on the rear row. The
/// shaded fraction depends on solar elevation, row pitch, module tilt,
/// and module height above ground.
///
/// Reference: Passias, D., Källbäck, B. (1984). "Shading effects in rows
/// of solar cell panels". Solar Cells, 11(3), 281-291.
///
/// # Arguments
/// * `solar_elevation_deg` — Sun elevation (degrees above horizon).
/// * `solar_azimuth_deg` — Sun azimuth (degrees, 0=N).
/// * `row_azimuth_deg` — Azimuth the rows face (degrees, typically 180=S).
/// * `tilt_deg` — Module tilt from horizontal (degrees).
/// * `pitch_m` — Row-to-row spacing (m).
/// * `module_height_m` — Height of module upper edge above ground (m).
/// * `module_width_m` — Module width along the slope (m).
///
/// # Returns
/// Fraction of the rear module that is shaded (0.0–1.0).
pub fn self_shading_fraction(
    solar_elevation_deg: f64,
    solar_azimuth_deg: f64,
    row_azimuth_deg: f64,
    tilt_deg: f64,
    pitch_m: f64,
    module_height_m: f64,
    module_width_m: f64,
) -> f64 {
    if solar_elevation_deg <= 0.0 || pitch_m <= 0.0 || module_width_m <= 0.0 {
        return 1.0; // fully shaded at night / invalid input
    }

    let sun_el_rad = solar_elevation_deg * DEG_TO_RAD;
    let sun_az_rad = solar_azimuth_deg * DEG_TO_RAD;
    let row_az_rad = row_azimuth_deg * DEG_TO_RAD;
    let tilt_rad = tilt_deg * DEG_TO_RAD;

    // Project shadow length along the row-normal direction.
    let az_diff = sun_az_rad - row_az_rad;
    let shadow_horizontal = module_height_m / sun_el_rad.tan();
    let shadow_along_row_normal = shadow_horizontal * az_diff.cos().abs();

    // Clear zone between the front row's trailing edge projection and the rear row.
    let clear_zone = pitch_m - module_width_m * tilt_rad.cos();

    if clear_zone <= 0.0 {
        return 1.0; // rows overlap (GCR > 1)
    }

    // Shaded height on rear module = shadow length - clear zone
    let shadow_on_rear = shadow_along_row_normal - clear_zone;
    if shadow_on_rear <= 0.0 {
        return 0.0; // no inter-row shading
    }

    // Fraction = shaded height / module projected height
    let module_proj = module_width_m * tilt_rad.sin();
    if module_proj <= 0.0 {
        return 0.0;
    }

    (shadow_on_rear / module_proj).clamp(0.0, 1.0)
}

/// Optimize row pitch to keep self-shading below a target maximum for a
/// given design sun elevation (typically winter solstice at 9 AM or 3 PM).
///
/// # Arguments
/// * `target_max_shade` — Maximum acceptable shade fraction (e.g., 0.0 for no shade).
/// * `design_solar_elevation_deg` — Worst-case solar elevation to design for.
/// * `design_solar_azimuth_deg` — Worst-case solar azimuth.
/// * `row_azimuth_deg` — Row facing direction.
/// * `tilt_deg` — Module tilt (degrees).
/// * `module_height_m` — Module upper edge height (m).
/// * `module_width_m` — Module width along slope (m).
///
/// # Returns
/// Minimum row pitch (m) to achieve the target shade constraint.
pub fn optimal_row_pitch(
    target_max_shade: f64,
    design_solar_elevation_deg: f64,
    design_solar_azimuth_deg: f64,
    row_azimuth_deg: f64,
    tilt_deg: f64,
    module_height_m: f64,
    module_width_m: f64,
) -> f64 {
    // Binary search for minimum pitch
    let mut lo = module_width_m * (tilt_deg * DEG_TO_RAD).cos();
    let mut hi = lo * 5.0; // upper bound: 5× module projection

    for _ in 0..50 {
        let mid = (lo + hi) / 2.0;
        let shade = self_shading_fraction(
            design_solar_elevation_deg,
            design_solar_azimuth_deg,
            row_azimuth_deg,
            tilt_deg,
            mid,
            module_height_m,
            module_width_m,
        );
        if shade > target_max_shade {
            lo = mid;
        } else {
            hi = mid;
        }
    }
    hi
}

// ========================================================================
// 5. Hourly Shading Mask
// ========================================================================

/// An hourly shading mask for a single panel across 8760 hours. Each element
/// is the shading derate (0.0 = fully shaded, 1.0 = unshaded) for that hour.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HourlyShadingMask {
    pub panel_id: String,
    /// 8760 derate factors (1.0 = unshaded). Index 0 = Jan 1 00:00 UTC.
    pub hourly_derate: Vec<f64>,
    /// Annual shade-loss fraction (1 - mean of hourly derates weighted by GHI).
    pub annual_shade_loss_pct: f64,
}

/// Solar position for a single hour (pre-computed by the solar position engine).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HourlySunPosition {
    pub azimuth_deg: f64,
    pub elevation_deg: f64,
    pub ghi_wm2: f64, // used for GHI-weighted annual loss
}

/// Compute an annual hourly shading mask for a panel, considering horizon,
/// obstacles, and self-shading.
///
/// # Arguments
/// * `panel_id` — Identifier for the panel.
/// * `panel_east_m`, `panel_north_m`, `panel_elevation_m` — Panel position.
/// * `sun_positions` — 8760-element array of hourly solar positions.
/// * `horizon` — Terrain horizon profile (pass empty profile to skip).
/// * `boxes` — Box obstacles (buildings, structures).
/// * `cylinders` — Cylindrical obstacles (trees, poles).
/// * `self_shade_params` — If `Some`, evaluate inter-row self-shading.
pub fn compute_hourly_mask(
    panel_id: &str,
    panel_east_m: f64,
    panel_north_m: f64,
    panel_elevation_m: f64,
    sun_positions: &[HourlySunPosition],
    horizon: &HorizonProfile,
    boxes: &[ObstacleBox],
    cylinders: &[ObstacleCylinder],
    self_shade_params: Option<&SelfShadeParams>,
) -> HourlyShadingMask {
    let n = sun_positions.len();
    let mut hourly_derate = Vec::with_capacity(n);
    let mut ghi_weighted_shade = 0.0_f64;
    let mut ghi_total = 0.0_f64;

    for sp in sun_positions {
        if sp.elevation_deg <= 0.0 || sp.ghi_wm2 <= 0.0 {
            hourly_derate.push(1.0); // nighttime — no loss
            continue;
        }

        let mut shade_intensity = 0.0_f64;

        // Horizon check
        if horizon.is_sun_blocked(sp.azimuth_deg, sp.elevation_deg) {
            shade_intensity = 1.0;
        }

        // Obstacle shadows (take maximum shade intensity)
        if shade_intensity < 1.0 {
            for obs in boxes {
                let sr = box_shadow_at_point(
                    obs, panel_east_m, panel_north_m, panel_elevation_m,
                    sp.azimuth_deg, sp.elevation_deg,
                );
                if sr.intensity > shade_intensity {
                    shade_intensity = sr.intensity;
                }
            }
            for obs in cylinders {
                let sr = cylinder_shadow_at_point(
                    obs, panel_east_m, panel_north_m, panel_elevation_m,
                    sp.azimuth_deg, sp.elevation_deg,
                );
                if sr.intensity > shade_intensity {
                    shade_intensity = sr.intensity;
                }
            }
        }

        // Self-shading
        if shade_intensity < 1.0 {
            if let Some(params) = self_shade_params {
                let sf = self_shading_fraction(
                    sp.elevation_deg, sp.azimuth_deg,
                    params.row_azimuth_deg, params.tilt_deg,
                    params.pitch_m, params.module_height_m, params.module_width_m,
                );
                if sf > shade_intensity {
                    shade_intensity = sf;
                }
            }
        }

        let derate = (1.0 - shade_intensity).clamp(0.0, 1.0);
        hourly_derate.push(derate);
        ghi_weighted_shade += (1.0 - derate) * sp.ghi_wm2;
        ghi_total += sp.ghi_wm2;
    }

    let annual_shade_loss_pct = if ghi_total > 0.0 {
        ghi_weighted_shade / ghi_total * 100.0
    } else {
        0.0
    };

    HourlyShadingMask {
        panel_id: panel_id.to_string(),
        hourly_derate,
        annual_shade_loss_pct,
    }
}

/// Parameters for self-shading evaluation within the hourly mask.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SelfShadeParams {
    pub row_azimuth_deg: f64,
    pub tilt_deg: f64,
    pub pitch_m: f64,
    pub module_height_m: f64,
    pub module_width_m: f64,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn horizon_flat_terrain() {
        let dem = vec![
            DEMCell { east_m: 100.0, north_m: 0.0, elevation_m: 100.0 },
            DEMCell { east_m: -100.0, north_m: 0.0, elevation_m: 100.0 },
            DEMCell { east_m: 0.0, north_m: 100.0, elevation_m: 100.0 },
            DEMCell { east_m: 0.0, north_m: -100.0, elevation_m: 100.0 },
        ];
        let profile = HorizonProfile::from_dem(&dem, 100.0, 5.0, 500.0);
        // Flat terrain at same elevation → horizon ≈ 0°
        for p in &profile.points {
            assert!(p.elevation_deg <= 1.0, "flat terrain: elev={} at az={}", p.elevation_deg, p.azimuth_deg);
        }
    }

    #[test]
    fn horizon_hill_blocks_sun() {
        // Wide hill spanning multiple DEM cells to cover several azimuth sectors
        let dem = vec![
            DEMCell { east_m: -20.0, north_m: -200.0, elevation_m: 150.0 },
            DEMCell { east_m: 0.0, north_m: -200.0, elevation_m: 150.0 },
            DEMCell { east_m: 20.0, north_m: -200.0, elevation_m: 150.0 },
        ];
        let profile = HorizonProfile::from_dem(&dem, 100.0, 5.0, 500.0);
        // Hill elevation angle: atan(50/200) ≈ 14°
        let blocked = profile.is_sun_blocked(180.0, 10.0);
        assert!(blocked, "10° sun should be blocked by ~14° hill");
        let visible = profile.is_sun_blocked(180.0, 20.0);
        assert!(!visible, "20° sun should clear ~14° hill");
    }

    #[test]
    fn box_shadow_projects_correctly() {
        let obs = ObstacleBox {
            id: "building-1".into(),
            centre_east_m: 0.0,
            centre_north_m: 0.0,
            width_m: 10.0,
            depth_m: 10.0,
            height_m: 5.0,
            base_elevation_m: 0.0,
        };
        // Sun from south (180°), 30° elevation → shadow projects north
        let shaded = box_shadow_at_point(&obs, 0.0, 7.0, 0.0, 180.0, 30.0);
        assert!(shaded.is_shaded, "point north of building should be shaded");

        let unshaded = box_shadow_at_point(&obs, 0.0, -7.0, 0.0, 180.0, 30.0);
        assert!(!unshaded.is_shaded, "point south of building (sun side) should not be shaded");
    }

    #[test]
    fn cylinder_tree_shadow() {
        let tree = ObstacleCylinder {
            id: "tree-1".into(),
            centre_east_m: 0.0,
            centre_north_m: 0.0,
            radius_m: 0.3,
            height_m: 8.0,
            base_elevation_m: 0.0,
            crown_radius_m: 3.0,
        };
        // Sun from south, 45° → shadow 8m north
        let sr = cylinder_shadow_at_point(&tree, 0.0, 5.0, 0.0, 180.0, 45.0);
        assert!(sr.is_shaded, "should be in tree shadow");
        assert!(sr.intensity < 1.0, "tree shadow should be partial: got {}", sr.intensity);
    }

    #[test]
    fn self_shading_at_high_sun_is_zero() {
        let sf = self_shading_fraction(60.0, 180.0, 180.0, 25.0, 5.0, 2.0, 2.0);
        assert!(sf < 0.01, "high sun should produce no inter-row shade: got {sf}");
    }

    #[test]
    fn self_shading_at_low_sun() {
        let sf = self_shading_fraction(10.0, 180.0, 180.0, 25.0, 4.0, 2.5, 2.0);
        assert!(sf > 0.1, "low sun should produce inter-row shade: got {sf}");
    }

    #[test]
    fn optimal_pitch_wider_at_low_sun() {
        let pitch_high = optimal_row_pitch(0.0, 30.0, 180.0, 180.0, 25.0, 2.5, 2.0);
        let pitch_low = optimal_row_pitch(0.0, 15.0, 180.0, 180.0, 25.0, 2.5, 2.0);
        assert!(pitch_low > pitch_high, "lower design sun needs wider pitch: low={pitch_low} high={pitch_high}");
    }

    #[test]
    fn hourly_mask_nighttime_unshaded() {
        let sun = vec![
            HourlySunPosition { azimuth_deg: 0.0, elevation_deg: -10.0, ghi_wm2: 0.0 },
            HourlySunPosition { azimuth_deg: 180.0, elevation_deg: 45.0, ghi_wm2: 800.0 },
        ];
        let horizon = HorizonProfile { points: vec![] };
        let mask = compute_hourly_mask("p1", 10.0, 20.0, 0.0, &sun, &horizon, &[], &[], None);
        assert_eq!(mask.hourly_derate[0], 1.0, "nighttime should be unshaded");
        assert_eq!(mask.hourly_derate[1], 1.0, "daytime no obstacles should be unshaded");
        assert!(mask.annual_shade_loss_pct < 0.01);
    }

    #[test]
    fn hourly_mask_with_obstacle() {
        let sun = vec![
            HourlySunPosition { azimuth_deg: 180.0, elevation_deg: 30.0, ghi_wm2: 600.0 },
        ];
        let horizon = HorizonProfile { points: vec![] };
        let obs = ObstacleBox {
            id: "shed".into(),
            centre_east_m: 0.0,
            centre_north_m: 0.0,
            width_m: 6.0,
            depth_m: 6.0,
            height_m: 4.0,
            base_elevation_m: 0.0,
        };
        // Panel is north of the shed → shaded when sun is from south
        let mask = compute_hourly_mask("p2", 0.0, 5.0, 0.0, &sun, &horizon, &[obs], &[], None);
        assert!(mask.hourly_derate[0] < 1.0, "should be shaded: derate={}", mask.hourly_derate[0]);
        assert!(mask.annual_shade_loss_pct > 0.0);
    }
}
