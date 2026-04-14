use common::Point2D;

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct NearestNeighbor {
    pub index: usize,
    pub distance: f64,
    pub point: Point2D,
}

pub fn nearest_point(query: Point2D, candidates: &[Point2D]) -> Option<NearestNeighbor> {
    candidates
        .iter()
        .enumerate()
        .map(|(idx, p)| NearestNeighbor {
            index: idx,
            distance: query.distance_to(p),
            point: *p,
        })
        .min_by(|a, b| {
            a.distance
                .partial_cmp(&b.distance)
                .unwrap_or(std::cmp::Ordering::Equal)
                .then_with(|| a.index.cmp(&b.index))
        })
}

pub fn k_nearest_points(query: Point2D, candidates: &[Point2D], k: usize) -> Vec<NearestNeighbor> {
    if k == 0 || candidates.is_empty() {
        return Vec::new();
    }

    let mut neighbors: Vec<NearestNeighbor> = candidates
        .iter()
        .enumerate()
        .map(|(idx, p)| NearestNeighbor {
            index: idx,
            distance: query.distance_to(p),
            point: *p,
        })
        .collect();

    neighbors.sort_by(|a, b| {
        a.distance
            .partial_cmp(&b.distance)
            .unwrap_or(std::cmp::Ordering::Equal)
            .then_with(|| a.index.cmp(&b.index))
    });
    neighbors.truncate(k.min(neighbors.len()));
    neighbors
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn nearest_point_returns_stable_index_on_tie() {
        let query = Point2D { x: 0.0, y: 0.0 };
        let candidates = vec![Point2D { x: 1.0, y: 0.0 }, Point2D { x: 0.0, y: 1.0 }];

        let nearest = nearest_point(query, &candidates).expect("neighbor exists");
        assert_eq!(nearest.index, 0);
        assert!((nearest.distance - 1.0).abs() < 1e-9);
    }

    #[test]
    fn k_nearest_points_handles_k_larger_than_population() {
        let query = Point2D { x: 0.0, y: 0.0 };
        let candidates = vec![
            Point2D { x: 3.0, y: 0.0 },
            Point2D { x: 1.0, y: 0.0 },
            Point2D { x: 2.0, y: 0.0 },
        ];

        let result = k_nearest_points(query, &candidates, 10);
        assert_eq!(result.len(), 3);
        assert_eq!(result[0].index, 1);
        assert_eq!(result[1].index, 2);
        assert_eq!(result[2].index, 0);
    }
}
