use serde::{Deserialize, Serialize};

pub const EPSILON: f64 = 1e-9;

// ── Core Types ────────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Copy, PartialEq, Serialize, Deserialize)]
pub struct Point2D {
    pub x: f64,
    pub y: f64,
}

impl Point2D {
    #[inline]
    pub fn distance_to(&self, other: &Point2D) -> f64 {
        let dx = self.x - other.x;
        let dy = self.y - other.y;
        (dx * dx + dy * dy).sqrt()
    }

    /// Squared Euclidean distance — avoids sqrt, safe for ordering.
    #[inline]
    pub fn sq_distance_to(&self, other: &Point2D) -> f64 {
        let dx = self.x - other.x;
        let dy = self.y - other.y;
        dx * dx + dy * dy
    }

    #[inline]
    pub fn midpoint(&self, other: &Point2D) -> Point2D {
        Point2D {
            x: (self.x + other.x) * 0.5,
            y: (self.y + other.y) * 0.5,
        }
    }

    /// Linear interpolation: self + t*(other - self).
    #[inline]
    pub fn lerp(&self, other: &Point2D, t: f64) -> Point2D {
        Point2D {
            x: self.x + t * (other.x - self.x),
            y: self.y + t * (other.y - self.y),
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Serialize, Deserialize)]
pub struct Point3D {
    pub x: f64,
    pub y: f64,
    pub z: f64,
}

impl Point3D {
    pub fn distance_to(&self, other: &Point3D) -> f64 {
        let dx = self.x - other.x;
        let dy = self.y - other.y;
        let dz = self.z - other.z;
        (dx * dx + dy * dy + dz * dz).sqrt()
    }

    pub fn to_2d(&self) -> Point2D {
        Point2D { x: self.x, y: self.y }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Serialize, Deserialize)]
pub struct LineSegment {
    pub a: Point2D,
    pub b: Point2D,
}

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct Polygon {
    pub ring: Vec<Point2D>,
}

impl Polygon {
    pub fn sanitized_ring(&self) -> Vec<Point2D> {
        sanitize_ring(&self.ring)
    }

    pub fn is_valid(&self) -> bool {
        self.sanitized_ring().len() >= 3
    }

    pub fn centroid(&self) -> Option<Point2D> {
        polygon_centroid(self)
    }

    pub fn area(&self) -> f64 {
        polygon_area_signed(self).abs()
    }

    pub fn is_counter_clockwise(&self) -> bool {
        polygon_area_signed(self) > 0.0
    }

    pub fn is_convex(&self) -> bool {
        polygon_is_convex(self)
    }
}

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct MultiPolygon {
    pub polygons: Vec<Polygon>,
}

impl MultiPolygon {
    pub fn new(polygons: Vec<Polygon>) -> Result<Self, String> {
        if polygons.is_empty() {
            return Err("MultiPolygon must contain at least one polygon".to_string());
        }
        for (i, p) in polygons.iter().enumerate() {
            if !p.is_valid() {
                return Err(format!("polygon at index {} is not valid", i));
            }
        }
        Ok(Self { polygons })
    }

    pub fn contains_point(&self, p: Point2D) -> bool {
        self.polygons.iter().any(|poly| point_in_polygon(p, poly))
    }

    pub fn total_area(&self) -> f64 {
        self.polygons.iter().map(|p| polygon_area_signed(p).abs()).sum()
    }
}

#[derive(Debug, Clone, PartialEq)]
pub enum SegmentIntersection {
    None,
    Point(Point2D),
    Overlap(LineSegment),
}

// ── Fundamental Predicates ────────────────────────────────────────────────────

/// Signed area of triangle (a, b, c) × 2.
/// Positive → counter-clockwise, Negative → clockwise, zero → collinear.
#[inline]
pub fn orient2d(a: Point2D, b: Point2D, c: Point2D) -> f64 {
    (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
}

/// True iff a-b-c turn is strictly counter-clockwise.
#[inline]
pub fn counter_clockwise(a: Point2D, b: Point2D, c: Point2D) -> bool {
    orient2d(a, b, c) > EPSILON
}

/// True iff a-b-c are collinear.
#[inline]
pub fn collinear(a: Point2D, b: Point2D, c: Point2D) -> bool {
    orient2d(a, b, c).abs() <= EPSILON
}

// ── Polygon Algorithms ────────────────────────────────────────────────────────

pub fn polygon_area_signed(poly: &Polygon) -> f64 {
    let ring = poly.sanitized_ring();
    if ring.len() < 3 {
        return 0.0;
    }
    let mut area = 0.0;
    for i in 0..ring.len() {
        let a = ring[i];
        let b = ring[(i + 1) % ring.len()];
        area += a.x * b.y - b.x * a.y;
    }
    0.5 * area
}

/// Centroid of a simple polygon using the signed-area formula.
pub fn polygon_centroid(poly: &Polygon) -> Option<Point2D> {
    let ring = poly.sanitized_ring();
    if ring.len() < 3 {
        return None;
    }
    let mut cx = 0.0f64;
    let mut cy = 0.0f64;
    let mut area = 0.0f64;
    for i in 0..ring.len() {
        let a = ring[i];
        let b = ring[(i + 1) % ring.len()];
        let c = a.x * b.y - b.x * a.y;
        cx += (a.x + b.x) * c;
        cy += (a.y + b.y) * c;
        area += c;
    }
    if area.abs() < EPSILON {
        return None;
    }
    let inv = 1.0 / (3.0 * area);
    Some(Point2D { x: cx * inv, y: cy * inv })
}

/// True iff all vertices of the polygon ring form a convex shape (no reflex angles).
pub fn polygon_is_convex(poly: &Polygon) -> bool {
    let ring = poly.sanitized_ring();
    let n = ring.len();
    if n < 3 {
        return false;
    }
    let mut sign: Option<bool> = None;
    for i in 0..n {
        let a = ring[i];
        let b = ring[(i + 1) % n];
        let c = ring[(i + 2) % n];
        let o = orient2d(a, b, c);
        if o.abs() <= EPSILON {
            continue; // skip collinear triplets
        }
        let positive = o > 0.0;
        match sign {
            None => sign = Some(positive),
            Some(s) if s != positive => return false,
            _ => {}
        }
    }
    true
}

/// Shimrat's ray-casting point-in-polygon with the denominator sign preserved.
///
/// Returns `true` for interior AND boundary points.
/// The `.abs()` bug on the denominator (present in many textbook implementations)
/// has been removed; the sign of `(pj.y - pi.y)` is required for correctness.
pub fn point_in_polygon(p: Point2D, poly: &Polygon) -> bool {
    let ring = poly.sanitized_ring();
    if ring.len() < 3 {
        return false;
    }
    // Boundary first.
    for i in 0..ring.len() {
        let a = ring[i];
        let b = ring[(i + 1) % ring.len()];
        if point_on_segment(p, a, b) {
            return true;
        }
    }
    // Ray-cast: strict `>` comparisons ensure horizontal edges are handled
    // without double-counting shared vertices (Shimrat 1962).
    let mut inside = false;
    let mut j = ring.len() - 1;
    for i in 0..ring.len() {
        let pi = ring[i];
        let pj = ring[j];
        let crosses_y = (pi.y > p.y) != (pj.y > p.y);
        if crosses_y {
            // (pj.y - pi.y) is guaranteed non-zero and correctly signed.
            let x_cross = pi.x + (pj.x - pi.x) * (p.y - pi.y) / (pj.y - pi.y);
            if p.x < x_cross {
                inside = !inside;
            }
        }
        j = i;
    }
    inside
}

/// Winding number algorithm — more numerically stable for points near edges.
///
/// Returns 0 iff `p` is outside; non-zero (typically ±1) iff inside.
pub fn winding_number(p: Point2D, poly: &Polygon) -> i32 {
    let ring = poly.sanitized_ring();
    if ring.len() < 3 {
        return 0;
    }
    let mut wn = 0i32;
    for i in 0..ring.len() {
        let a = ring[i];
        let b = ring[(i + 1) % ring.len()];
        if a.y <= p.y {
            if b.y > p.y && orient2d(a, b, p) > 0.0 {
                wn += 1;
            }
        } else if b.y <= p.y && orient2d(a, b, p) < 0.0 {
            wn -= 1;
        }
    }
    wn
}

/// Sutherland-Hodgman polygon clipping.
///
/// Clips `subject` to the convex region defined by `clip_poly`.
/// `clip_poly` must be convex and given in counter-clockwise order.
/// Returns the vertices of the clipped polygon (≥3 vertices) or an empty
/// vec if there is no overlap.
pub fn clip_polygon_convex(subject: &Polygon, clip_poly: &Polygon) -> Vec<Point2D> {
    let clip = clip_poly.sanitized_ring();
    if clip.len() < 3 {
        return Vec::new();
    }
    let mut output: Vec<Point2D> = subject.sanitized_ring();
    if output.len() < 3 {
        return Vec::new();
    }
    let n = clip.len();
    for i in 0..n {
        if output.is_empty() {
            return Vec::new();
        }
        let edge_a = clip[i];
        let edge_b = clip[(i + 1) % n];
        let input = std::mem::take(&mut output);
        let mut s = *input.last().expect("non-empty");
        for &e in &input {
            let e_inside = orient2d(edge_a, edge_b, e) >= 0.0;
            let s_inside = orient2d(edge_a, edge_b, s) >= 0.0;
            if e_inside {
                if !s_inside {
                    if let Some(pt) = line_segment_clip_edge(s, e, edge_a, edge_b) {
                        output.push(pt);
                    }
                }
                output.push(e);
            } else if s_inside {
                if let Some(pt) = line_segment_clip_edge(s, e, edge_a, edge_b) {
                    output.push(pt);
                }
            }
            s = e;
        }
    }
    output
}

/// Graham-scan convex hull.  Returns the hull in counter-clockwise order.
pub fn convex_hull(points: &[Point2D]) -> Vec<Point2D> {
    let mut pts: Vec<Point2D> = points
        .iter()
        .copied()
        .filter(|p| p.x.is_finite() && p.y.is_finite())
        .collect();
    let n = pts.len();
    if n < 3 {
        return pts;
    }
    // Find the lowest-then-leftmost point and place it at index 0.
    let mut pivot = 0;
    for i in 1..n {
        if pts[i].y < pts[pivot].y
            || (pts[i].y == pts[pivot].y && pts[i].x < pts[pivot].x)
        {
            pivot = i;
        }
    }
    pts.swap(0, pivot);
    let origin = pts[0];
    // Sort by polar angle; break ties by keeping the farthest point last.
    pts[1..].sort_by(|&a, &b| {
        let c = orient2d(origin, a, b);
        if c.abs() <= EPSILON {
            let da = origin.sq_distance_to(&a);
            let db = origin.sq_distance_to(&b);
            da.partial_cmp(&db).unwrap_or(std::cmp::Ordering::Equal)
        } else if c > 0.0 {
            std::cmp::Ordering::Less
        } else {
            std::cmp::Ordering::Greater
        }
    });
    // Deduplicate collinear runs: keep only the farthest per angle.
    let mut filtered = vec![pts[0]];
    let mut i = 1;
    while i < n {
        let mut j = i;
        while j + 1 < n && collinear(origin, pts[j], pts[j + 1]) {
            j += 1;
        }
        filtered.push(pts[j]);
        i = j + 1;
    }
    if filtered.len() < 3 {
        return filtered;
    }
    // Graham scan proper.
    let mut hull = vec![filtered[0], filtered[1]];
    for &p in &filtered[2..] {
        while hull.len() >= 2 {
            let l = hull.len();
            if orient2d(hull[l - 2], hull[l - 1], p) <= 0.0 {
                hull.pop();
            } else {
                break;
            }
        }
        hull.push(p);
    }
    hull
}

// ── Segment API ───────────────────────────────────────────────────────────────

pub fn segment_intersection(s1: LineSegment, s2: LineSegment) -> SegmentIntersection {
    let p = s1.a;
    let r = Point2D { x: s1.b.x - s1.a.x, y: s1.b.y - s1.a.y };
    let q = s2.a;
    let s = Point2D { x: s2.b.x - s2.a.x, y: s2.b.y - s2.a.y };
    let rxs = cross(r, s);
    let q_p = Point2D { x: q.x - p.x, y: q.y - p.y };
    let q_pxr = cross(q_p, r);
    if almost_zero(rxs) && almost_zero(q_pxr) {
        let rr = dot(r, r);
        if almost_zero(rr) {
            return if almost_same_point(&s1.a, &s2.a) {
                SegmentIntersection::Point(s1.a)
            } else {
                SegmentIntersection::None
            };
        }
        let t0 = dot(q_p, r) / rr;
        let t1 = t0 + dot(s, r) / rr;
        let (t_min, t_max) = if t0 <= t1 { (t0, t1) } else { (t1, t0) };
        let start = t_min.max(0.0);
        let end = t_max.min(1.0);
        if end + EPSILON < start {
            return SegmentIntersection::None;
        }
        let start_pt = Point2D { x: p.x + start * r.x, y: p.y + start * r.y };
        let end_pt = Point2D { x: p.x + end * r.x, y: p.y + end * r.y };
        if almost_same_point(&start_pt, &end_pt) {
            SegmentIntersection::Point(start_pt)
        } else {
            SegmentIntersection::Overlap(LineSegment { a: start_pt, b: end_pt })
        }
    } else if almost_zero(rxs) {
        SegmentIntersection::None
    } else {
        let t = cross(q_p, s) / rxs;
        let u = cross(q_p, r) / rxs;
        if (-EPSILON..=1.0 + EPSILON).contains(&t) && (-EPSILON..=1.0 + EPSILON).contains(&u) {
            SegmentIntersection::Point(Point2D { x: p.x + t * r.x, y: p.y + t * r.y })
        } else {
            SegmentIntersection::None
        }
    }
}

pub fn point_on_segment(p: Point2D, a: Point2D, b: Point2D) -> bool {
    if !almost_zero(cross(
        Point2D { x: b.x - a.x, y: b.y - a.y },
        Point2D { x: p.x - a.x, y: p.y - a.y },
    )) {
        return false;
    }
    let min_x = a.x.min(b.x) - EPSILON;
    let max_x = a.x.max(b.x) + EPSILON;
    let min_y = a.y.min(b.y) - EPSILON;
    let max_y = a.y.max(b.y) + EPSILON;
    p.x >= min_x && p.x <= max_x && p.y >= min_y && p.y <= max_y
}

// ── Internal Helpers ──────────────────────────────────────────────────────────

#[inline]
fn dot(a: Point2D, b: Point2D) -> f64 {
    a.x * b.x + a.y * b.y
}

#[inline]
pub(crate) fn cross(a: Point2D, b: Point2D) -> f64 {
    a.x * b.y - a.y * b.x
}

#[inline]
fn almost_zero(v: f64) -> bool {
    v.abs() <= EPSILON
}

#[inline]
pub(crate) fn almost_same_point(a: &Point2D, b: &Point2D) -> bool {
    (a.x - b.x).abs() <= EPSILON && (a.y - b.y).abs() <= EPSILON
}

pub(crate) fn sanitize_ring(raw: &[Point2D]) -> Vec<Point2D> {
    if raw.is_empty() {
        return Vec::new();
    }
    let mut cleaned = Vec::with_capacity(raw.len());
    for p in raw {
        if cleaned
            .last()
            .map(|last: &Point2D| almost_same_point(last, p))
            .unwrap_or(false)
        {
            continue;
        }
        cleaned.push(*p);
    }
    if cleaned.len() > 1 && almost_same_point(&cleaned[0], cleaned.last().expect("non-empty")) {
        cleaned.pop();
    }
    cleaned
}

/// Compute the intersection of segment (p→q) with the infinite line (a→b).
fn line_segment_clip_edge(p: Point2D, q: Point2D, a: Point2D, b: Point2D) -> Option<Point2D> {
    let r = Point2D { x: q.x - p.x, y: q.y - p.y };
    let s = Point2D { x: b.x - a.x, y: b.y - a.y };
    let rxs = cross(r, s);
    if rxs.abs() <= EPSILON {
        return None;
    }
    // t = cross(a − p, s) / cross(r, s)  — standard parametric line-line formula
    let ap = Point2D { x: a.x - p.x, y: a.y - p.y };
    let t = cross(ap, s) / rxs;
    Some(Point2D { x: p.x + t * r.x, y: p.y + t * r.y })
}

// ── Tests ─────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    fn square() -> Polygon {
        Polygon {
            ring: vec![
                Point2D { x: 0.0, y: 0.0 },
                Point2D { x: 10.0, y: 0.0 },
                Point2D { x: 10.0, y: 10.0 },
                Point2D { x: 0.0, y: 10.0 },
                Point2D { x: 0.0, y: 0.0 },
            ],
        }
    }

    fn triangle_ccw() -> Polygon {
        Polygon {
            ring: vec![
                Point2D { x: 0.0, y: 0.0 },
                Point2D { x: 6.0, y: 0.0 },
                Point2D { x: 3.0, y: 5.0 },
            ],
        }
    }

    // ── point_in_polygon ──────────────────────────────────────────────────────

    #[test]
    fn point_in_polygon_inside_outside_boundary() {
        let poly = square();
        assert!(point_in_polygon(Point2D { x: 5.0, y: 5.0 }, &poly));
        assert!(!point_in_polygon(Point2D { x: 15.0, y: 5.0 }, &poly));
        assert!(point_in_polygon(Point2D { x: 0.0, y: 7.0 }, &poly));
    }

    /// This test exercises a non-axis-aligned polygon edge where the old
    /// `.abs()` denominator bug would produce an incorrect result.
    #[test]
    fn point_in_polygon_non_axis_aligned_triangle() {
        let tri = Polygon {
            ring: vec![
                Point2D { x: 0.0, y: 0.0 },
                Point2D { x: 10.0, y: 0.0 },
                Point2D { x: 5.0, y: 10.0 },
            ],
        };
        assert!(point_in_polygon(Point2D { x: 5.0, y: 3.0 }, &tri));
        assert!(!point_in_polygon(Point2D { x: 1.0, y: 9.0 }, &tri));
        assert!(!point_in_polygon(Point2D { x: 0.5, y: 5.0 }, &tri));
    }

    #[test]
    fn point_in_polygon_diamond() {
        let diamond = Polygon {
            ring: vec![
                Point2D { x: 5.0, y: 0.0 },
                Point2D { x: 10.0, y: 5.0 },
                Point2D { x: 5.0, y: 10.0 },
                Point2D { x: 0.0, y: 5.0 },
            ],
        };
        assert!(point_in_polygon(Point2D { x: 5.0, y: 5.0 }, &diamond));
        assert!(point_in_polygon(Point2D { x: 3.0, y: 5.0 }, &diamond));
        assert!(!point_in_polygon(Point2D { x: 0.0, y: 0.0 }, &diamond));
        assert!(!point_in_polygon(Point2D { x: 10.0, y: 10.0 }, &diamond));
    }

    // ── winding_number ────────────────────────────────────────────────────────

    #[test]
    fn winding_number_agrees_with_pip() {
        let poly = square();
        assert_ne!(winding_number(Point2D { x: 5.0, y: 5.0 }, &poly), 0);
        assert_eq!(winding_number(Point2D { x: 15.0, y: 5.0 }, &poly), 0);
    }

    // ── orient2d ─────────────────────────────────────────────────────────────

    #[test]
    fn orient2d_signs_correct() {
        let a = Point2D { x: 0.0, y: 0.0 };
        let b = Point2D { x: 1.0, y: 0.0 };
        assert!(orient2d(a, b, Point2D { x: 0.5, y: 1.0 }) > 0.0);
        assert!(orient2d(a, b, Point2D { x: 0.5, y: -1.0 }) < 0.0);
        assert!(collinear(a, b, Point2D { x: 2.0, y: 0.0 }));
    }

    // ── convex_hull ───────────────────────────────────────────────────────────

    #[test]
    fn convex_hull_square_with_interior_point() {
        let pts = vec![
            Point2D { x: 0.0, y: 0.0 },
            Point2D { x: 1.0, y: 0.0 },
            Point2D { x: 1.0, y: 1.0 },
            Point2D { x: 0.0, y: 1.0 },
            Point2D { x: 0.5, y: 0.5 },
        ];
        let hull = convex_hull(&pts);
        assert_eq!(hull.len(), 4);
    }

    #[test]
    fn convex_hull_is_counter_clockwise() {
        let pts = vec![
            Point2D { x: 0.0, y: 0.0 },
            Point2D { x: 4.0, y: 0.0 },
            Point2D { x: 4.0, y: 3.0 },
            Point2D { x: 0.0, y: 3.0 },
            Point2D { x: 2.0, y: 1.5 },
        ];
        let hull = convex_hull(&pts);
        let n = hull.len();
        let area: f64 = {
            let mut a = 0.0;
            for i in 0..n {
                let p = hull[i];
                let q = hull[(i + 1) % n];
                a += p.x * q.y - q.x * p.y;
            }
            0.5 * a
        };
        assert!(area > 0.0, "hull must be CCW, got area={}", area);
    }

    // ── clip_polygon_convex ───────────────────────────────────────────────────

    #[test]
    fn clip_polygon_overlapping_squares() {
        let subject = Polygon {
            ring: vec![
                Point2D { x: 0.0, y: 0.0 },
                Point2D { x: 10.0, y: 0.0 },
                Point2D { x: 10.0, y: 10.0 },
                Point2D { x: 0.0, y: 10.0 },
            ],
        };
        let clip = Polygon {
            ring: vec![
                Point2D { x: 5.0, y: 5.0 },
                Point2D { x: 15.0, y: 5.0 },
                Point2D { x: 15.0, y: 15.0 },
                Point2D { x: 5.0, y: 15.0 },
            ],
        };
        let result = clip_polygon_convex(&subject, &clip);
        assert!(result.len() >= 4);
        for p in &result {
            assert!(p.x >= 5.0 - 1e-9);
            assert!(p.y >= 5.0 - 1e-9);
        }
    }

    #[test]
    fn clip_polygon_no_overlap_returns_empty() {
        let subject = Polygon {
            ring: vec![
                Point2D { x: 0.0, y: 0.0 },
                Point2D { x: 3.0, y: 0.0 },
                Point2D { x: 3.0, y: 3.0 },
                Point2D { x: 0.0, y: 3.0 },
            ],
        };
        let clip = Polygon {
            ring: vec![
                Point2D { x: 5.0, y: 5.0 },
                Point2D { x: 8.0, y: 5.0 },
                Point2D { x: 8.0, y: 8.0 },
                Point2D { x: 5.0, y: 8.0 },
            ],
        };
        assert!(clip_polygon_convex(&subject, &clip).is_empty());
    }

    // ── polygon_is_convex ─────────────────────────────────────────────────────

    #[test]
    fn square_is_convex() {
        assert!(polygon_is_convex(&square()));
    }

    #[test]
    fn l_shape_is_not_convex() {
        let l = Polygon {
            ring: vec![
                Point2D { x: 0.0, y: 0.0 },
                Point2D { x: 4.0, y: 0.0 },
                Point2D { x: 4.0, y: 2.0 },
                Point2D { x: 2.0, y: 2.0 },
                Point2D { x: 2.0, y: 4.0 },
                Point2D { x: 0.0, y: 4.0 },
            ],
        };
        assert!(!polygon_is_convex(&l));
    }

    // ── polygon_centroid ──────────────────────────────────────────────────────

    #[test]
    fn centroid_of_square_is_center() {
        let c = polygon_centroid(&square()).unwrap();
        assert!((c.x - 5.0).abs() < 1e-9);
        assert!((c.y - 5.0).abs() < 1e-9);
    }

    #[test]
    fn centroid_of_triangle() {
        let tri = triangle_ccw();
        let c = polygon_centroid(&tri).unwrap();
        // (0+6+3)/3=3, (0+0+5)/3=5/3
        assert!((c.x - 3.0).abs() < 1e-9);
        assert!((c.y - 5.0 / 3.0).abs() < 1e-9);
    }

    // ── polygon_area_signed ───────────────────────────────────────────────────

    #[test]
    fn polygon_area_signed_direction() {
        let poly = square();
        assert!((polygon_area_signed(&poly) - 100.0).abs() < 1e-6);
        let reverse = Polygon { ring: poly.ring.into_iter().rev().collect() };
        assert!((polygon_area_signed(&reverse) + 100.0).abs() < 1e-6);
    }

    // ── segment_intersection ─────────────────────────────────────────────────

    #[test]
    fn segment_intersection_crossing_and_overlap() {
        let crossing = segment_intersection(
            LineSegment { a: Point2D { x: 0.0, y: 0.0 }, b: Point2D { x: 2.0, y: 2.0 } },
            LineSegment { a: Point2D { x: 0.0, y: 2.0 }, b: Point2D { x: 2.0, y: 0.0 } },
        );
        match crossing {
            SegmentIntersection::Point(p) => {
                assert!((p.x - 1.0).abs() < 1e-6);
                assert!((p.y - 1.0).abs() < 1e-6);
            }
            _ => panic!("expected point intersection"),
        }

        let overlap = segment_intersection(
            LineSegment { a: Point2D { x: 0.0, y: 0.0 }, b: Point2D { x: 4.0, y: 0.0 } },
            LineSegment { a: Point2D { x: 2.0, y: 0.0 }, b: Point2D { x: 6.0, y: 0.0 } },
        );
        match overlap {
            SegmentIntersection::Overlap(seg) => {
                assert!((seg.a.x - 2.0).abs() < 1e-6);
                assert!((seg.b.x - 4.0).abs() < 1e-6);
            }
            _ => panic!("expected overlap"),
        }
    }

    // ── sanitize_ring ─────────────────────────────────────────────────────────

    #[test]
    fn sanitize_ring_removes_duplicates_and_closing_vertex() {
        let poly = Polygon {
            ring: vec![
                Point2D { x: 0.0, y: 0.0 },
                Point2D { x: 0.0, y: 0.0 },
                Point2D { x: 1.0, y: 0.0 },
                Point2D { x: 1.0, y: 1.0 },
                Point2D { x: 0.0, y: 0.0 },
            ],
        };
        assert_eq!(poly.sanitized_ring().len(), 3);
    }

    // ── MultiPolygon ──────────────────────────────────────────────────────────

    #[test]
    fn multi_polygon_contains_point() {
        let mp = MultiPolygon::new(vec![square()]).unwrap();
        assert!(mp.contains_point(Point2D { x: 5.0, y: 5.0 }));
        assert!(!mp.contains_point(Point2D { x: 20.0, y: 5.0 }));
    }

    // ── Point2D helpers ───────────────────────────────────────────────────────

    #[test]
    fn midpoint_and_lerp() {
        let a = Point2D { x: 0.0, y: 0.0 };
        let b = Point2D { x: 4.0, y: 2.0 };
        let mid = a.midpoint(&b);
        assert!((mid.x - 2.0).abs() < 1e-10);
        assert!((mid.y - 1.0).abs() < 1e-10);
        let lerp = a.lerp(&b, 0.25);
        assert!((lerp.x - 1.0).abs() < 1e-10);
        assert!((lerp.y - 0.5).abs() < 1e-10);
    }
}
