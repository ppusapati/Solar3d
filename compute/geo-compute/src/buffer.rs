use common::{point_in_polygon, LineSegment, Point2D, Polygon};

pub fn buffer_point(center: Point2D, radius: f64, segments: usize) -> Result<Polygon, String> {
    if !radius.is_finite() || radius <= 0.0 {
        return Err("radius must be a finite positive value".to_string());
    }
    if segments < 8 {
        return Err("segments must be at least 8 for stable circular approximation".to_string());
    }

    let mut ring = Vec::with_capacity(segments);
    for i in 0..segments {
        let theta = 2.0 * std::f64::consts::PI * i as f64 / segments as f64;
        ring.push(Point2D {
            x: center.x + radius * theta.cos(),
            y: center.y + radius * theta.sin(),
        });
    }
    Ok(Polygon { ring })
}

pub fn buffer_polyline(line: &[Point2D], distance: f64, resolution: usize) -> Result<Vec<Polygon>, String> {
    if line.len() < 2 {
        return Err("polyline requires at least 2 points".to_string());
    }
    if !distance.is_finite() || distance <= 0.0 {
        return Err("distance must be a finite positive value".to_string());
    }
    if resolution < 16 {
        return Err("resolution must be at least 16".to_string());
    }

    let mut min_x = f64::INFINITY;
    let mut max_x = f64::NEG_INFINITY;
    let mut min_y = f64::INFINITY;
    let mut max_y = f64::NEG_INFINITY;
    for p in line {
        min_x = min_x.min(p.x);
        min_y = min_y.min(p.y);
        max_x = max_x.max(p.x);
        max_y = max_y.max(p.y);
    }

    let pad = distance * 1.2;
    min_x -= pad;
    min_y -= pad;
    max_x += pad;
    max_y += pad;

    let width = max_x - min_x;
    let height = max_y - min_y;
    let denom = (resolution as f64).max(1.0);
    let step = (width.max(height) / denom).max(distance / 4.0);

    extract_isocontours(min_x, min_y, max_x, max_y, step, |x, y| {
        point_to_polyline_distance(Point2D { x, y }, line) <= distance
    })
}

pub fn buffer_polygon(poly: &Polygon, distance: f64, resolution: usize) -> Result<Vec<Polygon>, String> {
    if !poly.is_valid() {
        return Err("polygon ring is not valid".to_string());
    }
    if !distance.is_finite() || distance <= 0.0 {
        return Err("distance must be a finite positive value".to_string());
    }
    if resolution < 16 {
        return Err("resolution must be at least 16".to_string());
    }

    let ring = poly.sanitized_ring();
    let mut min_x = f64::INFINITY;
    let mut max_x = f64::NEG_INFINITY;
    let mut min_y = f64::INFINITY;
    let mut max_y = f64::NEG_INFINITY;
    for p in &ring {
        min_x = min_x.min(p.x);
        min_y = min_y.min(p.y);
        max_x = max_x.max(p.x);
        max_y = max_y.max(p.y);
    }

    let pad = distance * 1.2;
    min_x -= pad;
    min_y -= pad;
    max_x += pad;
    max_y += pad;

    let width = max_x - min_x;
    let height = max_y - min_y;
    let denom = (resolution as f64).max(1.0);
    let step = (width.max(height) / denom).max(distance / 4.0);

    extract_isocontours(min_x, min_y, max_x, max_y, step, |x, y| {
        let p = Point2D { x, y };
        if point_in_polygon(p, poly) {
            true
        } else {
            point_to_polygon_boundary_distance(p, &ring) <= distance
        }
    })
}

fn point_to_polyline_distance(p: Point2D, line: &[Point2D]) -> f64 {
    let mut best = f64::INFINITY;
    for seg in line.windows(2) {
        let d = point_to_segment_distance(
            p,
            LineSegment {
                a: seg[0],
                b: seg[1],
            },
        );
        best = best.min(d);
    }
    best
}

fn point_to_polygon_boundary_distance(p: Point2D, ring: &[Point2D]) -> f64 {
    let mut best = f64::INFINITY;
    for i in 0..ring.len() {
        let a = ring[i];
        let b = ring[(i + 1) % ring.len()];
        let d = point_to_segment_distance(p, LineSegment { a, b });
        best = best.min(d);
    }
    best
}

fn point_to_segment_distance(p: Point2D, s: LineSegment) -> f64 {
    let dx = s.b.x - s.a.x;
    let dy = s.b.y - s.a.y;
    let len2 = dx * dx + dy * dy;

    if len2 <= f64::EPSILON {
        return p.distance_to(&s.a);
    }

    let t = ((p.x - s.a.x) * dx + (p.y - s.a.y) * dy) / len2;
    if t <= 0.0 {
        return p.distance_to(&s.a);
    }
    if t >= 1.0 {
        return p.distance_to(&s.b);
    }

    let proj = Point2D {
        x: s.a.x + t * dx,
        y: s.a.y + t * dy,
    };
    p.distance_to(&proj)
}

fn extract_isocontours<F>(
    min_x: f64,
    min_y: f64,
    max_x: f64,
    max_y: f64,
    step: f64,
    predicate: F,
) -> Result<Vec<Polygon>, String>
where
    F: Fn(f64, f64) -> bool,
{
    if !step.is_finite() || step <= 0.0 {
        return Err("invalid sampling step".to_string());
    }

    let cols = (((max_x - min_x) / step).ceil() as usize).max(2);
    let rows = (((max_y - min_y) / step).ceil() as usize).max(2);

    let mut grid = vec![false; cols * rows];
    for row in 0..rows {
        for col in 0..cols {
            let x = min_x + col as f64 * step;
            let y = min_y + row as f64 * step;
            grid[row * cols + col] = predicate(x, y);
        }
    }

    let mut segments: Vec<(Point2D, Point2D)> = Vec::new();
    for row in 0..rows - 1 {
        for col in 0..cols - 1 {
            let v00 = grid[row * cols + col];
            let v10 = grid[row * cols + col + 1];
            let v11 = grid[(row + 1) * cols + col + 1];
            let v01 = grid[(row + 1) * cols + col];

            let idx = (v00 as u8) | ((v10 as u8) << 1) | ((v11 as u8) << 2) | ((v01 as u8) << 3);
            if idx == 0 || idx == 15 {
                continue;
            }

            let x = min_x + col as f64 * step;
            let y = min_y + row as f64 * step;

            let left = Point2D { x, y: y + 0.5 * step };
            let right = Point2D {
                x: x + step,
                y: y + 0.5 * step,
            };
            let bottom = Point2D { x: x + 0.5 * step, y };
            let top = Point2D {
                x: x + 0.5 * step,
                y: y + step,
            };

            match idx {
                1 | 14 => segments.push((left, bottom)),
                2 | 13 => segments.push((bottom, right)),
                3 | 12 => segments.push((left, right)),
                4 | 11 => segments.push((right, top)),
                5 => {
                    segments.push((left, top));
                    segments.push((bottom, right));
                }
                6 | 9 => segments.push((bottom, top)),
                7 | 8 => segments.push((left, top)),
                10 => {
                    segments.push((left, bottom));
                    segments.push((right, top));
                }
                _ => {}
            }
        }
    }

    Ok(stitch_segments(segments, step * 0.75))
}

fn stitch_segments(segments: Vec<(Point2D, Point2D)>, tol: f64) -> Vec<Polygon> {
    if segments.is_empty() {
        return Vec::new();
    }

    let mut unused = segments;
    let mut polygons = Vec::new();

    while let Some((start_a, start_b)) = unused.pop() {
        let mut ring = vec![start_a, start_b];

        loop {
            let last = *ring.last().expect("ring is never empty");
            let mut found_idx = None;
            let mut next = None;

            for (i, (a, b)) in unused.iter().enumerate() {
                if last.distance_to(a) <= tol {
                    found_idx = Some(i);
                    next = Some(*b);
                    break;
                }
                if last.distance_to(b) <= tol {
                    found_idx = Some(i);
                    next = Some(*a);
                    break;
                }
            }

            match (found_idx, next) {
                (Some(i), Some(n)) => {
                    unused.swap_remove(i);
                    ring.push(n);
                    if n.distance_to(&ring[0]) <= tol {
                        break;
                    }
                }
                _ => break,
            }
        }

        if ring.len() >= 4 {
            ring.pop();
            polygons.push(Polygon { ring });
        }
    }

    polygons
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn point_buffer_approximates_circle() {
        let center = Point2D { x: 10.0, y: 5.0 };
        let poly = buffer_point(center, 2.0, 32).expect("buffer generated");
        assert_eq!(poly.ring.len(), 32);
        let r = center.distance_to(&poly.ring[0]);
        assert!((r - 2.0).abs() < 1e-6);
    }

    #[test]
    fn polyline_buffer_produces_polygon() {
        let line = vec![Point2D { x: 0.0, y: 0.0 }, Point2D { x: 10.0, y: 0.0 }];
        let buffered = buffer_polyline(&line, 1.0, 64).expect("buffer generated");
        assert!(!buffered.is_empty());
        assert!(buffered.iter().any(|p| p.ring.len() >= 4));
    }

    #[test]
    fn polygon_buffer_expands_square() {
        let square = Polygon {
            ring: vec![
                Point2D { x: 0.0, y: 0.0 },
                Point2D { x: 4.0, y: 0.0 },
                Point2D { x: 4.0, y: 4.0 },
                Point2D { x: 0.0, y: 4.0 },
            ],
        };

        let buffered = buffer_polygon(&square, 1.0, 80).expect("buffer generated");
        assert!(!buffered.is_empty());

        let mut min_x = f64::INFINITY;
        let mut max_x = f64::NEG_INFINITY;
        for poly in &buffered {
            for p in &poly.ring {
                min_x = min_x.min(p.x);
                max_x = max_x.max(p.x);
            }
        }

        assert!(min_x < -0.5);
        assert!(max_x > 4.5);
    }
}
