/// 2D KD-tree built over indexed `Point2D` slices.
///
/// Build: O(n log n) — splits on alternating axes using median-of-three.
/// Single nearest-neighbor: O(log n) average, O(n) worst case.
/// k-nearest: O(k log n) average.
/// Radius search: O(k log n + n) worst case where k is the result count.
///
/// The tree stores indices into the original point slice so callers can map
/// results back to their own domain objects without copying coordinates.
use common::Point2D;
use std::cmp::Ordering;

#[derive(Debug, Clone)]
struct Node {
    /// Index into the original points slice.
    point_idx: usize,
    /// Axis this node splits on (0 = x, 1 = y).
    axis: u8,
    left: Option<Box<Node>>,
    right: Option<Box<Node>>,
}

/// A static 2D KD-tree with O(log n) expected query complexity.
#[derive(Debug, Clone)]
pub struct KdTree {
    root: Option<Box<Node>>,
    points: Vec<Point2D>,
}

/// A single query result returned by KD-tree searches.
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct KdNeighbor {
    /// Index into the slice passed to [`KdTree::build`].
    pub index: usize,
    pub distance: f64,
    pub point: Point2D,
}

impl KdTree {
    /// Build a tree from `points`.  Returns an empty tree for zero-length slices.
    pub fn build(points: &[Point2D]) -> Self {
        let pts = points.to_vec();
        let mut indices: Vec<usize> = (0..pts.len()).collect();
        let root = build_recursive(&pts, &mut indices, 0);
        Self { root, points: pts }
    }

    /// Nearest neighbor query.  Returns `None` for empty trees.
    pub fn nearest(&self, query: &Point2D) -> Option<KdNeighbor> {
        let root = self.root.as_deref()?;
        let mut best_dist = f64::INFINITY;
        let mut best_idx = 0;
        search_nearest(root, query, &self.points, &mut best_dist, &mut best_idx);
        Some(KdNeighbor {
            index: best_idx,
            distance: best_dist,
            point: self.points[best_idx],
        })
    }

    /// k-nearest neighbors in ascending distance order.
    pub fn k_nearest(&self, query: &Point2D, k: usize) -> Vec<KdNeighbor> {
        if k == 0 || self.root.is_none() {
            return Vec::new();
        }
        // Max-heap of (distance, index) limited to size k.
        let mut heap: Vec<(f64, usize)> = Vec::with_capacity(k + 1);
        if let Some(root) = self.root.as_deref() {
            search_k_nearest(root, query, &self.points, k, &mut heap);
        }
        heap.sort_by(|a, b| a.0.partial_cmp(&b.0).unwrap_or(Ordering::Equal));
        heap.into_iter()
            .map(|(dist, idx)| KdNeighbor {
                index: idx,
                distance: dist,
                point: self.points[idx],
            })
            .collect()
    }

    /// All points within `radius` of `query`, sorted by ascending distance.
    pub fn within_radius(&self, query: &Point2D, radius: f64) -> Vec<KdNeighbor> {
        let mut results = Vec::new();
        if let Some(root) = self.root.as_deref() {
            search_radius(root, query, &self.points, radius * radius, &mut results);
        }
        results.sort_by(|a, b| a.distance.partial_cmp(&b.distance).unwrap_or(Ordering::Equal));
        results
    }

    /// Number of points in the tree.
    pub fn len(&self) -> usize {
        self.points.len()
    }

    /// True if the tree contains no points.
    pub fn is_empty(&self) -> bool {
        self.points.is_empty()
    }
}

// ── Internal Build ────────────────────────────────────────────────────────────

fn build_recursive(pts: &[Point2D], indices: &mut [usize], depth: usize) -> Option<Box<Node>> {
    if indices.is_empty() {
        return None;
    }
    let axis = (depth % 2) as u8;

    // Partial sort to find the median index, avoiding full O(n log n) per level.
    let mid = indices.len() / 2;
    indices.select_nth_unstable_by(mid, |&a, &b| {
        let va = if axis == 0 { pts[a].x } else { pts[a].y };
        let vb = if axis == 0 { pts[b].x } else { pts[b].y };
        va.partial_cmp(&vb).unwrap_or(Ordering::Equal)
    });

    let point_idx = indices[mid];
    let left = build_recursive(pts, &mut indices[..mid], depth + 1);
    let right = build_recursive(pts, &mut indices[mid + 1..], depth + 1);

    Some(Box::new(Node {
        point_idx,
        axis,
        left,
        right,
    }))
}

// ── Internal Search Helpers ───────────────────────────────────────────────────

fn search_nearest(
    node: &Node,
    query: &Point2D,
    pts: &[Point2D],
    best_dist: &mut f64,
    best_idx: &mut usize,
) {
    let p = &pts[node.point_idx];
    let dist = sq_dist(query, p);
    if dist < *best_dist {
        *best_dist = dist;
        *best_idx = node.point_idx;
    }

    let diff = if node.axis == 0 { query.x - p.x } else { query.y - p.y };
    let (near, far) = if diff <= 0.0 {
        (node.left.as_deref(), node.right.as_deref())
    } else {
        (node.right.as_deref(), node.left.as_deref())
    };

    if let Some(n) = near {
        search_nearest(n, query, pts, best_dist, best_idx);
    }
    // Only search the far subtree if the splitting plane is closer than current best.
    if diff * diff < *best_dist {
        if let Some(f) = far {
            search_nearest(f, query, pts, best_dist, best_idx);
        }
    }
}

fn search_k_nearest(
    node: &Node,
    query: &Point2D,
    pts: &[Point2D],
    k: usize,
    heap: &mut Vec<(f64, usize)>,
) {
    let p = &pts[node.point_idx];
    let dist = sq_dist(query, p);

    // Maintain max-heap of size k (heap[0] is the worst/largest distance).
    if heap.len() < k {
        heap.push((dist, node.point_idx));
        // Bubble up to maintain max-heap property.
        let mut i = heap.len() - 1;
        while i > 0 {
            let parent = (i - 1) / 2;
            if heap[i].0 > heap[parent].0 {
                heap.swap(i, parent);
                i = parent;
            } else {
                break;
            }
        }
    } else if dist < heap[0].0 {
        heap[0] = (dist, node.point_idx);
        // Sift down.
        sift_down(heap, 0);
    }

    let diff = if node.axis == 0 { query.x - p.x } else { query.y - p.y };
    let worst = if heap.len() == k { heap[0].0 } else { f64::INFINITY };

    let (near, far) = if diff <= 0.0 {
        (node.left.as_deref(), node.right.as_deref())
    } else {
        (node.right.as_deref(), node.left.as_deref())
    };

    if let Some(n) = near {
        search_k_nearest(n, query, pts, k, heap);
    }
    let worst = if heap.len() == k { heap[0].0 } else { f64::INFINITY };
    if diff * diff < worst {
        if let Some(f) = far {
            search_k_nearest(f, query, pts, k, heap);
        }
    }
}

fn sift_down(heap: &mut Vec<(f64, usize)>, mut i: usize) {
    let len = heap.len();
    loop {
        let left = 2 * i + 1;
        let right = 2 * i + 2;
        let mut largest = i;
        if left < len && heap[left].0 > heap[largest].0 {
            largest = left;
        }
        if right < len && heap[right].0 > heap[largest].0 {
            largest = right;
        }
        if largest == i {
            break;
        }
        heap.swap(i, largest);
        i = largest;
    }
}

fn search_radius(
    node: &Node,
    query: &Point2D,
    pts: &[Point2D],
    sq_radius: f64,
    results: &mut Vec<KdNeighbor>,
) {
    let p = &pts[node.point_idx];
    let dist_sq = sq_dist(query, p);
    if dist_sq <= sq_radius {
        results.push(KdNeighbor {
            index: node.point_idx,
            distance: dist_sq.sqrt(),
            point: *p,
        });
    }

    let diff = if node.axis == 0 { query.x - p.x } else { query.y - p.y };

    if let Some(near) = if diff <= 0.0 { node.left.as_deref() } else { node.right.as_deref() } {
        search_radius(near, query, pts, sq_radius, results);
    }
    if diff * diff <= sq_radius {
        if let Some(far) = if diff <= 0.0 { node.right.as_deref() } else { node.left.as_deref() } {
            search_radius(far, query, pts, sq_radius, results);
        }
    }
}

#[inline]
fn sq_dist(a: &Point2D, b: &Point2D) -> f64 {
    let dx = a.x - b.x;
    let dy = a.y - b.y;
    dx * dx + dy * dy
}

// ── Tests ─────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;

    fn points_grid(n: usize) -> Vec<Point2D> {
        let mut pts = Vec::with_capacity(n * n);
        for i in 0..n {
            for j in 0..n {
                pts.push(Point2D { x: i as f64, y: j as f64 });
            }
        }
        pts
    }

    #[test]
    fn nearest_finds_exact_match() {
        let pts = points_grid(10);
        let tree = KdTree::build(&pts);
        let query = Point2D { x: 3.0, y: 7.0 };
        let result = tree.nearest(&query).unwrap();
        assert_eq!(result.point.x, 3.0);
        assert_eq!(result.point.y, 7.0);
        assert!(result.distance < 1e-10);
    }

    #[test]
    fn nearest_finds_closest_among_candidates() {
        let pts = vec![
            Point2D { x: 0.0, y: 0.0 },
            Point2D { x: 10.0, y: 0.0 },
            Point2D { x: 3.0, y: 4.0 },
        ];
        let tree = KdTree::build(&pts);
        let query = Point2D { x: 3.5, y: 3.5 };
        let result = tree.nearest(&query).unwrap();
        // closest to (3,4): distance = sqrt(0.5) ≈ 0.707
        assert_eq!(result.index, 2);
    }

    #[test]
    fn k_nearest_returns_k_in_order() {
        let pts = points_grid(5);
        let tree = KdTree::build(&pts);
        let query = Point2D { x: 2.0, y: 2.0 };
        let result = tree.k_nearest(&query, 4);
        assert_eq!(result.len(), 4);
        // First result is the point itself (distance 0).
        assert!(result[0].distance < 1e-10);
        // Results are sorted by ascending distance.
        for w in result.windows(2) {
            assert!(w[0].distance <= w[1].distance + 1e-10);
        }
    }

    #[test]
    fn within_radius_returns_all_within() {
        let pts = vec![
            Point2D { x: 0.0, y: 0.0 },
            Point2D { x: 1.0, y: 0.0 },
            Point2D { x: 5.0, y: 0.0 },
        ];
        let tree = KdTree::build(&pts);
        let query = Point2D { x: 0.0, y: 0.0 };
        let results = tree.within_radius(&query, 2.0);
        assert_eq!(results.len(), 2); // (0,0) and (1,0)
        assert!(results.iter().all(|r| r.distance <= 2.0 + 1e-10));
    }

    #[test]
    fn empty_tree_returns_none() {
        let tree = KdTree::build(&[]);
        assert!(tree.nearest(&Point2D { x: 0.0, y: 0.0 }).is_none());
        assert!(tree.k_nearest(&Point2D { x: 0.0, y: 0.0 }, 3).is_empty());
        assert!(tree.within_radius(&Point2D { x: 0.0, y: 0.0 }, 10.0).is_empty());
    }

    #[test]
    fn single_point_tree() {
        let pts = vec![Point2D { x: 3.14, y: 2.71 }];
        let tree = KdTree::build(&pts);
        let r = tree.nearest(&Point2D { x: 0.0, y: 0.0 }).unwrap();
        assert_eq!(r.index, 0);
    }

    /// Verify against brute-force for a random-ish layout.
    #[test]
    fn nearest_agrees_with_brute_force() {
        // Deterministic "random" points
        let pts: Vec<Point2D> = (0..200)
            .map(|i| Point2D {
                x: ((i * 7 + 13) % 100) as f64,
                y: ((i * 11 + 3) % 100) as f64,
            })
            .collect();
        let tree = KdTree::build(&pts);
        let query = Point2D { x: 42.5, y: 37.5 };

        let kd_result = tree.nearest(&query).unwrap();

        // Brute force
        let bf_result = pts
            .iter()
            .enumerate()
            .min_by(|(_, a), (_, b)| {
                let da = sq_dist(&query, a);
                let db = sq_dist(&query, b);
                da.partial_cmp(&db).unwrap()
            })
            .unwrap();

        assert_eq!(kd_result.index, bf_result.0);
    }
}
