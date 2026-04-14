use common::{Point2D, RasterGrid};
use std::collections::HashMap;

#[derive(Debug, Clone, PartialEq)]
pub struct ContourLine {
    pub elevation: f64,
    pub points: Vec<Point2D>,
}

pub fn generate_contours(grid: &RasterGrid, interval: f64) -> Result<Vec<ContourLine>, String> {
    if !interval.is_finite() || interval <= 0.0 {
        return Err("interval must be a finite positive value".to_string());
    }
    if grid.width < 2 || grid.height < 2 {
        return Ok(Vec::new());
    }

    let mut min_v = f64::INFINITY;
    let mut max_v = f64::NEG_INFINITY;
    for v in &grid.data {
        if (*v - grid.nodata).abs() <= f64::EPSILON {
            continue;
        }
        min_v = min_v.min(*v);
        max_v = max_v.max(*v);
    }

    if !min_v.is_finite() || !max_v.is_finite() {
        return Ok(Vec::new());
    }

    let start = (min_v / interval).floor() * interval;
    let end = (max_v / interval).ceil() * interval;

    let mut contours = Vec::new();
    let mut level = start;
    while level <= end + interval * 0.5 {
        let segments = contour_segments_for_level(grid, level);
        let polylines = stitch_segments(&segments, grid.resolution * 0.05);
        for line in polylines {
            if line.len() >= 2 {
                contours.push(ContourLine {
                    elevation: level,
                    points: line,
                });
            }
        }
        level += interval;
    }

    Ok(contours)
}

fn contour_segments_for_level(grid: &RasterGrid, level: f64) -> Vec<(Point2D, Point2D)> {
    let mut segments = Vec::new();

    for row in 0..grid.height - 1 {
        for col in 0..grid.width - 1 {
            let z00 = match grid.get(col, row) {
                Some(v) => v,
                None => continue,
            };
            let z10 = match grid.get(col + 1, row) {
                Some(v) => v,
                None => continue,
            };
            let z11 = match grid.get(col + 1, row + 1) {
                Some(v) => v,
                None => continue,
            };
            let z01 = match grid.get(col, row + 1) {
                Some(v) => v,
                None => continue,
            };

            let p00 = grid_point(grid, col, row);
            let p10 = grid_point(grid, col + 1, row);
            let p11 = grid_point(grid, col + 1, row + 1);
            let p01 = grid_point(grid, col, row + 1);

            let mut crossings = Vec::new();
            if (z00 - level) * (z10 - level) <= 0.0 && (z00 - z10).abs() > f64::EPSILON {
                crossings.push(interpolate(p00, z00, p10, z10, level));
            }
            if (z10 - level) * (z11 - level) <= 0.0 && (z10 - z11).abs() > f64::EPSILON {
                crossings.push(interpolate(p10, z10, p11, z11, level));
            }
            if (z11 - level) * (z01 - level) <= 0.0 && (z11 - z01).abs() > f64::EPSILON {
                crossings.push(interpolate(p11, z11, p01, z01, level));
            }
            if (z01 - level) * (z00 - level) <= 0.0 && (z01 - z00).abs() > f64::EPSILON {
                crossings.push(interpolate(p01, z01, p00, z00, level));
            }

            if crossings.len() == 2 {
                segments.push((crossings[0], crossings[1]));
            } else if crossings.len() == 4 {
                // Saddle point: split consistently by center value.
                let center = (z00 + z10 + z11 + z01) * 0.25;
                if center >= level {
                    segments.push((crossings[0], crossings[1]));
                    segments.push((crossings[2], crossings[3]));
                } else {
                    segments.push((crossings[0], crossings[3]));
                    segments.push((crossings[1], crossings[2]));
                }
            }
        }
    }

    segments
}

fn grid_point(grid: &RasterGrid, col: usize, row: usize) -> Point2D {
    Point2D {
        x: grid.origin_x + col as f64 * grid.resolution,
        y: grid.origin_y + row as f64 * grid.resolution,
    }
}

fn interpolate(p1: Point2D, z1: f64, p2: Point2D, z2: f64, level: f64) -> Point2D {
    if (z2 - z1).abs() <= f64::EPSILON {
        return Point2D {
            x: (p1.x + p2.x) * 0.5,
            y: (p1.y + p2.y) * 0.5,
        };
    }
    let t = ((level - z1) / (z2 - z1)).clamp(0.0, 1.0);
    Point2D {
        x: p1.x + t * (p2.x - p1.x),
        y: p1.y + t * (p2.y - p1.y),
    }
}

fn stitch_segments(segments: &[(Point2D, Point2D)], tolerance: f64) -> Vec<Vec<Point2D>> {
    if segments.is_empty() {
        return Vec::new();
    }

    let mut adjacency: HashMap<(i64, i64), Vec<(Point2D, Point2D)>> = HashMap::new();
    for &(a, b) in segments {
        let ka = key(a, tolerance);
        let kb = key(b, tolerance);
        adjacency.entry(ka).or_default().push((a, b));
        adjacency.entry(kb).or_default().push((b, a));
    }

    let mut used = vec![false; segments.len()];
    let mut lines = Vec::new();

    for (idx, &(a, b)) in segments.iter().enumerate() {
        if used[idx] {
            continue;
        }
        used[idx] = true;

        let mut line = vec![a, b];

        extend_line(&mut line, segments, &adjacency, &mut used, true, tolerance);
        extend_line(&mut line, segments, &adjacency, &mut used, false, tolerance);

        lines.push(line);
    }

    lines
}

fn extend_line(
    line: &mut Vec<Point2D>,
    segments: &[(Point2D, Point2D)],
    adjacency: &HashMap<(i64, i64), Vec<(Point2D, Point2D)>>,
    used: &mut [bool],
    append: bool,
    tolerance: f64,
) {
    loop {
        let endpoint = if append {
            *line.last().expect("line has at least one point")
        } else {
            line[0]
        };
        let k = key(endpoint, tolerance);

        let Some(neighbors) = adjacency.get(&k) else {
            break;
        };

        let mut found = None;
        'outer: for (from, to) in neighbors {
            for (i, (a, b)) in segments.iter().enumerate() {
                if used[i] {
                    continue;
                }
                if almost_same(*a, *from, tolerance) && almost_same(*b, *to, tolerance)
                    || almost_same(*a, *to, tolerance) && almost_same(*b, *from, tolerance)
                {
                    found = Some((i, *from, *to));
                    break 'outer;
                }
            }
        }

        match found {
            Some((i, from, to)) => {
                used[i] = true;
                let next = if almost_same(from, endpoint, tolerance) {
                    to
                } else {
                    from
                };
                if append {
                    line.push(next);
                } else {
                    line.insert(0, next);
                }
            }
            None => break,
        }
    }
}

fn key(p: Point2D, tolerance: f64) -> (i64, i64) {
    let inv = 1.0 / tolerance.max(1e-9);
    ((p.x * inv).round() as i64, (p.y * inv).round() as i64)
}

fn almost_same(a: Point2D, b: Point2D, tolerance: f64) -> bool {
    (a.x - b.x).abs() <= tolerance && (a.y - b.y).abs() <= tolerance
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn contour_generation_returns_lines() {
        let grid = RasterGrid::new(
            4,
            4,
            1.0,
            0.0,
            0.0,
            -9999.0,
            vec![
                0.0, 1.0, 2.0, 3.0, 1.0, 2.0, 3.0, 4.0, 2.0, 3.0, 4.0, 5.0, 3.0, 4.0, 5.0, 6.0,
            ],
        )
        .expect("valid raster");

        let lines = generate_contours(&grid, 2.0).expect("contours generated");
        assert!(!lines.is_empty());
        assert!(lines.iter().all(|l| l.points.len() >= 2));
    }

    #[test]
    fn contour_generation_handles_invalid_interval() {
        let grid = RasterGrid::new(2, 2, 1.0, 0.0, 0.0, -9999.0, vec![1.0, 2.0, 3.0, 4.0])
            .expect("valid raster");
        let err = generate_contours(&grid, 0.0).unwrap_err();
        assert!(err.contains("positive"));
    }
}
