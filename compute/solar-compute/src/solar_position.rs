use serde::{Deserialize, Serialize};
use std::f64::consts::PI;

const DEG_TO_RAD: f64 = PI / 180.0;
const RAD_TO_DEG: f64 = 180.0 / PI;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SunPosition {
    pub azimuth: f64,
    pub elevation: f64,
    pub zenith: f64,
    pub hour_angle: f64,
    pub declination: f64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SolarParams {
    pub latitude: f64,
    pub longitude: f64,
    pub year: i32,
    pub month: u32,
    pub day: u32,
    pub hour: f64,
    pub timezone_offset: f64,
}

/// Calculate the sun position using the astronomical solar position algorithm.
///
/// Based on the NOAA Solar Calculator equations which provide accuracy
/// suitable for engineering applications.
pub fn calculate_sun_position(params: &SolarParams) -> SunPosition {
    let day_of_year = day_of_year(params.year, params.month, params.day);
    let fractional_year = fractional_year(day_of_year, params.hour);

    // Solar declination (radians)
    let declination = solar_declination(fractional_year);

    // Equation of time (minutes)
    let eqtime = equation_of_time(fractional_year);

    // True solar time
    let time_offset = eqtime + 4.0 * params.longitude - 60.0 * params.timezone_offset;
    let true_solar_time = params.hour * 60.0 + time_offset;

    // Hour angle (degrees)
    let hour_angle = (true_solar_time / 4.0) - 180.0;

    let lat_rad = params.latitude * DEG_TO_RAD;
    let ha_rad = hour_angle * DEG_TO_RAD;

    // Solar zenith angle
    let cos_zenith = lat_rad.sin() * declination.sin()
        + lat_rad.cos() * declination.cos() * ha_rad.cos();
    let zenith = cos_zenith.acos() * RAD_TO_DEG;
    let elevation = 90.0 - zenith;

    // Solar azimuth angle
    let azimuth = calculate_azimuth(lat_rad, declination, zenith * DEG_TO_RAD, ha_rad);

    SunPosition {
        azimuth,
        elevation,
        zenith,
        hour_angle,
        declination: declination * RAD_TO_DEG,
    }
}

/// Calculate sun positions for an entire day at given time intervals.
pub fn calculate_daily_positions(
    latitude: f64,
    longitude: f64,
    year: i32,
    month: u32,
    day: u32,
    timezone_offset: f64,
    step_minutes: u32,
) -> Vec<(f64, SunPosition)> {
    let mut positions = Vec::new();
    let steps = (24 * 60) / step_minutes;

    for i in 0..steps {
        let hour = (i * step_minutes) as f64 / 60.0;
        let params = SolarParams {
            latitude,
            longitude,
            year,
            month,
            day,
            hour,
            timezone_offset,
        };
        let pos = calculate_sun_position(&params);
        if pos.elevation > 0.0 {
            positions.push((hour, pos));
        }
    }

    positions
}

/// Calculate annual sun positions using parallel computation.
pub fn calculate_annual_positions(
    latitude: f64,
    longitude: f64,
    year: i32,
    timezone_offset: f64,
    step_minutes: u32,
) -> Vec<Vec<(f64, SunPosition)>> {
    use rayon::prelude::*;

    let days: Vec<(u32, u32)> = (1..=12)
        .flat_map(|month| {
            let days_in_month = days_in_month(year, month);
            (1..=days_in_month).map(move |day| (month, day))
        })
        .collect();

    days.par_iter()
        .map(|(month, day)| {
            calculate_daily_positions(
                latitude,
                longitude,
                year,
                *month,
                *day,
                timezone_offset,
                step_minutes,
            )
        })
        .collect()
}

fn fractional_year(day_of_year: u32, hour: f64) -> f64 {
    (2.0 * PI / 365.0) * (day_of_year as f64 - 1.0 + (hour - 12.0) / 24.0)
}

fn solar_declination(fractional_year: f64) -> f64 {
    let fy = fractional_year;
    0.006918 - 0.399912 * fy.cos() + 0.070257 * fy.sin() - 0.006758 * (2.0 * fy).cos()
        + 0.000907 * (2.0 * fy).sin()
        - 0.002697 * (3.0 * fy).cos()
        + 0.00148 * (3.0 * fy).sin()
}

fn equation_of_time(fractional_year: f64) -> f64 {
    let fy = fractional_year;
    229.18 * (0.000075 + 0.001868 * fy.cos() - 0.032077 * fy.sin()
        - 0.014615 * (2.0 * fy).cos()
        - 0.040849 * (2.0 * fy).sin())
}

fn calculate_azimuth(lat_rad: f64, declination: f64, zenith_rad: f64, ha_rad: f64) -> f64 {
    let cos_azimuth = (declination.sin() - lat_rad.sin() * zenith_rad.cos())
        / (lat_rad.cos() * zenith_rad.sin());

    let azimuth_rad = cos_azimuth.clamp(-1.0, 1.0).acos();
    let mut azimuth = azimuth_rad * RAD_TO_DEG;

    if ha_rad > 0.0 {
        azimuth = 360.0 - azimuth;
    }

    azimuth
}

fn day_of_year(year: i32, month: u32, day: u32) -> u32 {
    let days_before_month = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    let mut doy = days_before_month[(month - 1) as usize] + day;
    if month > 2 && is_leap_year(year) {
        doy += 1;
    }
    doy
}

fn is_leap_year(year: i32) -> bool {
    (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
}

fn days_in_month(year: i32, month: u32) -> u32 {
    match month {
        1 | 3 | 5 | 7 | 8 | 10 | 12 => 31,
        4 | 6 | 9 | 11 => 30,
        2 => {
            if is_leap_year(year) {
                29
            } else {
                28
            }
        }
        _ => 30,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_summer_solstice_noon() {
        let params = SolarParams {
            latitude: 35.0,
            longitude: -120.0,
            year: 2024,
            month: 6,
            day: 21,
            hour: 12.0,
            timezone_offset: -8.0,
        };
        let pos = calculate_sun_position(&params);
        assert!(pos.elevation > 70.0, "Summer solstice should have high elevation");
        assert!(pos.azimuth > 100.0 && pos.azimuth < 260.0, "Sun should be roughly south");
    }

    #[test]
    fn test_winter_solstice_noon() {
        let params = SolarParams {
            latitude: 35.0,
            longitude: -120.0,
            year: 2024,
            month: 12,
            day: 21,
            hour: 12.0,
            timezone_offset: -8.0,
        };
        let pos = calculate_sun_position(&params);
        assert!(pos.elevation > 20.0 && pos.elevation < 50.0);
    }

    #[test]
    fn test_night_time() {
        let params = SolarParams {
            latitude: 35.0,
            longitude: -120.0,
            year: 2024,
            month: 6,
            day: 21,
            hour: 2.0,
            timezone_offset: -8.0,
        };
        let pos = calculate_sun_position(&params);
        assert!(pos.elevation < 0.0, "Should be below horizon at 2 AM");
    }

    #[test]
    fn test_daily_positions() {
        let positions = calculate_daily_positions(35.0, -120.0, 2024, 6, 21, -8.0, 60);
        assert!(!positions.is_empty(), "Should have daytime positions");
        for (_, pos) in &positions {
            assert!(pos.elevation > 0.0, "All returned positions should be above horizon");
        }
    }

    #[test]
    fn test_day_of_year() {
        assert_eq!(day_of_year(2024, 1, 1), 1);
        assert_eq!(day_of_year(2024, 12, 31), 366); // 2024 is leap year
        assert_eq!(day_of_year(2023, 12, 31), 365);
    }
}
