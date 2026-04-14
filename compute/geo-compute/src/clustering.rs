/// Spatial clustering algorithms for 2D point sets.
///
/// Two algorithms:
/// - DBSCAN: density-based, discovers clusters of arbitrary shape, labels noise.
/// - K-means (Lloyd's): centroid-based, requires `k` upfront, converges quickly.
use crate::kdtree::KdTree;
use common::Point2D;

// ── DBSCAN ────────────────────────────────────────────────────────────────────

/// DBSCAN cluster label for a single point.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ClusterLabel {
    /// Assigned to cluster with the given id (0-based).
    Cluster(usize),
    /// Not reachable from any core point — outlier.
    Noise,
}

/// Run DBSCAN on `points`.
///
/// - `eps`: neighbourhood radius.
/// - `min_pts`: minimum points (including the core point itself) in the ε-neighbourhood
///   for a point to be considered a core point.
///
/// Returns one `ClusterLabel` per input point in the same order.
///
/// Complexity: O(n log n) with the KD-tree range-query back-end.
pub fn dbscan(points: &[Point2D], eps: f64, min_pts: usize) -> Result<Vec<ClusterLabel>, String> {
    if !eps.is_finite() || eps <= 0.0 {
        return Err("eps must be finite and positive".to_string());
    }
    if min_pts == 0 {
        return Err("min_pts must be at least 1".to_string());
    }

    let n = points.len();
    if n == 0 {
        return Ok(Vec::new());
    }

    let tree = KdTree::build(points);
    // Use i64::MAX as "unvisited", -1 as "noise", ≥0 as cluster id.
    const UNVISITED: i64 = i64::MAX;
    const NOISE: i64 = -1;

    let mut labels = vec![UNVISITED; n];
    let mut next_cluster: i64 = 0;

    for i in 0..n {
        if labels[i] != UNVISITED {
            continue;
        }

        let neighbors = tree.within_radius(&points[i], eps);
        // `neighbors` includes the point itself.
        if neighbors.len() < min_pts {
            labels[i] = NOISE;
            continue;
        }

        let cluster = next_cluster;
        next_cluster += 1;
        labels[i] = cluster;

        // Seed queue with the neighbourhood minus the current point.
        let mut queue: Vec<usize> = neighbors
            .iter()
            .filter(|nb| nb.index != i)
            .map(|nb| nb.index)
            .collect();

        let mut head = 0;
        while head < queue.len() {
            let q = queue[head];
            head += 1;

            if labels[q] == NOISE {
                labels[q] = cluster;
            }
            if labels[q] != UNVISITED {
                continue;
            }
            labels[q] = cluster;

            let q_neighbors = tree.within_radius(&points[q], eps);
            if q_neighbors.len() >= min_pts {
                for nb in &q_neighbors {
                    if labels[nb.index] == UNVISITED || labels[nb.index] == NOISE {
                        queue.push(nb.index);
                    }
                }
            }
        }
    }

    Ok(labels
        .into_iter()
        .map(|l| {
            if l == NOISE {
                ClusterLabel::Noise
            } else {
                ClusterLabel::Cluster(l as usize)
            }
        })
        .collect())
}

/// Number of distinct (non-noise) clusters in a DBSCAN result.
pub fn cluster_count(labels: &[ClusterLabel]) -> usize {
    let mut max_id: Option<usize> = None;
    for &lbl in labels {
        if let ClusterLabel::Cluster(id) = lbl {
            max_id = Some(match max_id {
                None => id,
                Some(m) => m.max(id),
            });
        }
    }
    max_id.map(|m| m + 1).unwrap_or(0)
}

// ── K-means (Lloyd's algorithm) ───────────────────────────────────────────────

/// K-means result returned to callers.
#[derive(Debug, Clone)]
pub struct KMeansResult {
    /// Cluster id (0-based) for each input point, same order as input.
    pub assignments: Vec<usize>,
    /// Final centroid for each cluster.
    pub centroids: Vec<Point2D>,
    /// Total within-cluster sum-of-squares (lower is better).
    pub wcss: f64,
    /// Number of Lloyd iterations actually performed.
    pub iterations: usize,
}

/// Run k-means (Lloyd's algorithm) on `points`.
///
/// - `k`: number of clusters (must be ≤ `points.len()`).
/// - `max_iterations`: iteration cap; 300 is a safe default.
/// - `seed`: deterministic RNG seed for initial centroid selection (k-means++ style).
///
/// Returns an error if `k == 0` or `k > n`.
pub fn kmeans(
    points: &[Point2D],
    k: usize,
    max_iterations: usize,
    seed: u64,
) -> Result<KMeansResult, String> {
    let n = points.len();
    if k == 0 {
        return Err("k must be at least 1".to_string());
    }
    if k > n {
        return Err(format!("k ({}) cannot exceed the number of points ({})", k, n));
    }
    if max_iterations == 0 {
        return Err("max_iterations must be positive".to_string());
    }

    // --- Initialise centroids using k-means++ seeding ---
    let mut centroids = kmeanspp_init(points, k, seed);
    let mut assignments = vec![0usize; n];
    let mut iterations = 0;

    loop {
        // Assignment step.
        let mut changed = false;
        for (i, p) in points.iter().enumerate() {
            let best = centroids
                .iter()
                .enumerate()
                .map(|(ci, c)| (ci, sq_dist(p, c)))
                .min_by(|a, b| a.1.partial_cmp(&b.1).unwrap_or(std::cmp::Ordering::Equal))
                .map(|(ci, _)| ci)
                .unwrap_or(0);
            if best != assignments[i] {
                assignments[i] = best;
                changed = true;
            }
        }

        iterations += 1;

        // Update step.
        let mut sums = vec![(0.0f64, 0.0f64, 0usize); k];
        for (i, p) in points.iter().enumerate() {
            let ci = assignments[i];
            sums[ci].0 += p.x;
            sums[ci].1 += p.y;
            sums[ci].2 += 1;
        }
        for (ci, c) in centroids.iter_mut().enumerate() {
            let (sx, sy, cnt) = sums[ci];
            if cnt > 0 {
                c.x = sx / cnt as f64;
                c.y = sy / cnt as f64;
            }
            // If a centroid has zero members it keeps its position (dead centroid);
            // in k-means++ seeding this is unlikely but not impossible.
        }

        if !changed || iterations >= max_iterations {
            break;
        }
    }

    // Compute final WCSS.
    let wcss: f64 = points
        .iter()
        .enumerate()
        .map(|(i, p)| sq_dist(p, &centroids[assignments[i]]))
        .sum();

    Ok(KMeansResult {
        assignments,
        centroids,
        wcss,
        iterations,
    })
}

/// K-means++ centroid initialisation.
///
/// Deterministic: uses a linear congruential generator seeded from `seed`.
/// Complexity: O(k · n).
fn kmeanspp_init(points: &[Point2D], k: usize, seed: u64) -> Vec<Point2D> {
    let n = points.len();
    // LCG state for deterministic "random" without pulling in a full RNG dependency here.
    let mut state = seed.wrapping_add(1);

    let lcg_next = |s: &mut u64| -> f64 {
        // Multiplier and increment from Numerical Recipes.
        *s = s.wrapping_mul(6364136223846793005).wrapping_add(1442695040888963407);
        // Use upper 53 bits for f64.
        (*s >> 11) as f64 / (1u64 << 53) as f64
    };

    let first = (lcg_next(&mut state) * n as f64) as usize % n;
    let mut centroids = vec![points[first]];

    for _ in 1..k {
        // For each point, compute squared distance to the nearest chosen centroid.
        let distances: Vec<f64> = points
            .iter()
            .map(|p| {
                centroids
                    .iter()
                    .map(|c| sq_dist(p, c))
                    .fold(f64::INFINITY, f64::min)
            })
            .collect();

        let total: f64 = distances.iter().sum();
        let mut r = lcg_next(&mut state) * total;

        let mut chosen = 0;
        for (i, &d) in distances.iter().enumerate() {
            r -= d;
            if r <= 0.0 {
                chosen = i;
                break;
            }
            chosen = i;
        }
        centroids.push(points[chosen]);
    }

    centroids
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

    fn two_blobs() -> Vec<Point2D> {
        // Cluster A around (0,0), cluster B around (20,20).
        let mut pts = Vec::new();
        for i in 0..5 {
            for j in 0..5 {
                pts.push(Point2D { x: i as f64, y: j as f64 });
                pts.push(Point2D { x: 20.0 + i as f64, y: 20.0 + j as f64 });
            }
        }
        pts
    }

    // ── DBSCAN tests ──────────────────────────────────────────────────────────

    #[test]
    fn dbscan_finds_two_blobs() {
        let pts = two_blobs();
        let labels = dbscan(&pts, 2.0, 3).expect("dbscan succeeds");
        assert_eq!(labels.len(), pts.len());
        let n_clusters = cluster_count(&labels);
        assert_eq!(n_clusters, 2);
        // No point should be noise in the dense blobs.
        assert!(labels.iter().all(|l| *l != ClusterLabel::Noise));
    }

    #[test]
    fn dbscan_marks_isolated_point_as_noise() {
        let mut pts = Vec::new();
        // Dense core cluster.
        for i in 0..5 {
            pts.push(Point2D { x: i as f64, y: 0.0 });
        }
        // Isolated outlier far away.
        pts.push(Point2D { x: 100.0, y: 100.0 });

        let labels = dbscan(&pts, 1.5, 2).expect("dbscan succeeds");
        assert_eq!(labels.last(), Some(&ClusterLabel::Noise));
    }

    #[test]
    fn dbscan_rejects_invalid_eps() {
        let pts = vec![Point2D { x: 0.0, y: 0.0 }];
        assert!(dbscan(&pts, -1.0, 1).is_err());
        assert!(dbscan(&pts, 0.0, 1).is_err());
    }

    #[test]
    fn dbscan_empty_input() {
        let labels = dbscan(&[], 1.0, 2).expect("empty succeeds");
        assert!(labels.is_empty());
    }

    // ── K-means tests ─────────────────────────────────────────────────────────

    #[test]
    fn kmeans_separates_two_blobs() {
        let pts = two_blobs();
        let result = kmeans(&pts, 2, 100, 42).expect("kmeans succeeds");
        assert_eq!(result.assignments.len(), pts.len());
        assert_eq!(result.centroids.len(), 2);
        assert!(result.iterations >= 1);

        // Both centroids should be near the blob centres (0,0) and (20,20).
        let mut has_origin_cluster = false;
        let mut has_far_cluster = false;
        for c in &result.centroids {
            if c.x < 10.0 && c.y < 10.0 {
                has_origin_cluster = true;
            }
            if c.x > 10.0 && c.y > 10.0 {
                has_far_cluster = true;
            }
        }
        assert!(has_origin_cluster);
        assert!(has_far_cluster);
    }

    #[test]
    fn kmeans_deterministic_with_same_seed() {
        let pts = two_blobs();
        let r1 = kmeans(&pts, 2, 100, 99).unwrap();
        let r2 = kmeans(&pts, 2, 100, 99).unwrap();
        assert_eq!(r1.assignments, r2.assignments);
        for (c1, c2) in r1.centroids.iter().zip(r2.centroids.iter()) {
            assert!((c1.x - c2.x).abs() < 1e-10);
            assert!((c1.y - c2.y).abs() < 1e-10);
        }
    }

    #[test]
    fn kmeans_k_equals_n_assigns_each_point_uniquely() {
        let pts = vec![
            Point2D { x: 0.0, y: 0.0 },
            Point2D { x: 5.0, y: 0.0 },
            Point2D { x: 10.0, y: 0.0 },
        ];
        let result = kmeans(&pts, 3, 100, 7).expect("kmeans k=n");
        // Each cluster should contain exactly one point.
        let mut counts = vec![0usize; 3];
        for &a in &result.assignments {
            counts[a] += 1;
        }
        assert!(counts.iter().all(|&c| c == 1));
    }

    #[test]
    fn kmeans_rejects_k_greater_than_n() {
        let pts = vec![Point2D { x: 0.0, y: 0.0 }];
        assert!(kmeans(&pts, 5, 100, 0).is_err());
    }

    #[test]
    fn kmeans_rejects_k_zero() {
        let pts = vec![Point2D { x: 0.0, y: 0.0 }];
        assert!(kmeans(&pts, 0, 100, 0).is_err());
    }

    #[test]
    fn kmeans_wcss_is_non_negative() {
        let pts = two_blobs();
        let result = kmeans(&pts, 3, 200, 13).unwrap();
        assert!(result.wcss >= 0.0);
    }
}
