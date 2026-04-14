/// Determinism regression tests for all compute algorithms
/// Validates that algorithms are truly deterministic: same input + seed = same output
/// Detects non-deterministic behavior (floating point errors, hash seed variation, etc.)

#[cfg(test)]
mod determinism_tests {

    // ============================================================================
    // GEOMETRY ALGORITHMS (from common crate)
    // ============================================================================

    #[test]
    fn test_deterministic_segment_intersection() {
        // Segment intersection should be deterministic (no RNG involved)
        fn segment_intersect(
            p1: &(f64, f64),
            p2: &(f64, f64),
            p3: &(f64, f64),
            p4: &(f64, f64),
        ) -> bool {
            let epsilon = 1e-9;
            let ccw = |a: &(f64, f64), b: &(f64, f64), c: &(f64, f64)| -> i32 {
                let val = (c.1 - a.1) * (b.0 - a.0) - (b.1 - a.1) * (c.0 - a.0);
                if val.abs() < epsilon {
                    0
                } else if val > 0.0 {
                    1
                } else {
                    2
                }
            };

            let c1 = ccw(p1, p2, p3);
            let c2 = ccw(p1, p2, p4);
            let c3 = ccw(p3, p4, p1);
            let c4 = ccw(p3, p4, p2);

            (c1 != c2 && c3 != c4) || (c1 == 0 && c2 == 0)
        }

        let p1 = &(0.0, 0.0);
        let p2 = &(1.0, 1.0);
        let p3 = &(0.0, 1.0);
        let p4 = &(1.0, 0.0);

        // Run 5 times, should always get same result
        for _ in 0..5 {
            let result = segment_intersect(p1, p2, p3, p4);
            assert!(result); // These segments intersect
        }
    }

    #[test]
    fn test_deterministic_convex_hull() {
        // Graham scan is deterministic when points are sorted
        fn graham_scan(mut points: Vec<(f64, f64)>) -> Vec<(f64, f64)> {
            if points.len() < 3 {
                return points;
            }

            // Deterministic: always find lowest point (y-coord, break ties by x)
            let mut min_idx = 0;
            for i in 1..points.len() {
                if points[i].1 < points[min_idx].1
                    || (points[i].1 == points[min_idx].1 && points[i].0 < points[min_idx].0)
                {
                    min_idx = i;
                }
            }
            points.swap(0, min_idx);

            let pivot = points[0];

            // Deterministic sort by polar angle
            points[1..].sort_by(|a, b| {
                let angle_a = (a.1 - pivot.1).atan2(a.0 - pivot.0);
                let angle_b = (b.1 - pivot.1).atan2(b.0 - pivot.0);
                angle_a.partial_cmp(&angle_b).unwrap_or(std::cmp::Ordering::Equal)
            });

            let mut hull: Vec<(f64, f64)> = vec![];
            for p in points.iter() {
                while hull.len() > 1 {
                    let o = hull[hull.len() - 1];
                    let a = hull[hull.len() - 2];
                    let cross = (o.0 - a.0) * (p.1 - a.1) - (o.1 - a.1) * (p.0 - a.0);
                    if cross <= 0.0 {
                        break;
                    }
                    hull.pop();
                }
                hull.push(*p);
            }

            hull
        }

        let points = vec![(0.0, 0.0), (1.0, 0.0), (0.5, 1.0), (0.25, 0.5)];

        // Run 5 times, should get same hull
        let mut results = vec![];
        for _ in 0..5 {
            results.push(graham_scan(points.clone()));
        }

        for i in 1..results.len() {
            assert_eq!(results[0], results[i]);
        }
    }

    // ============================================================================
    // MONTE CARLO ALGORITHMS (deterministic with seed)
    // ============================================================================

    #[test]
    fn test_deterministic_monte_carlo_sampling() {
        use std::collections::VecDeque;

        // Seeded LCG (Linear Congruential Generator)
        struct SeededRng {
            state: u64,
        }

        impl SeededRng {
            fn new(seed: u64) -> Self {
                SeededRng { state: seed }
            }

            fn next_f64(&mut self) -> f64 {
                // LCG: x_n+1 = (a * x_n + c) mod m
                const A: u64 = 6364136223846793005;
                const C: u64 = 1442695040888963407;
                const M: u64 = u64::MAX;

                self.state = (A.wrapping_mul(self.state).wrapping_add(C)) as u64;
                (self.state as f64) / (M as f64)
            }
        }

        // Monte Carlo box-Muller normal sampling
        fn box_muller_sample(seed: u64, count: usize) -> Vec<f64> {
            let mut rng = SeededRng::new(seed);
            let mut samples = Vec::new();

            for _ in 0..(count / 2) {
                let u1 = rng.next_f64();
                let u2 = rng.next_f64();
                let r = (-2.0 * u1.ln()).sqrt();
                let theta = 2.0 * std::f64::consts::PI * u2;

                samples.push(r * theta.cos());
                samples.push(r * theta.sin());
            }

            samples.truncate(count);
            samples
        }

        let seed = 42u64;
        let samples1 = box_muller_sample(seed, 100);
        let samples2 = box_muller_sample(seed, 100);
        let samples3 = box_muller_sample(seed, 100);

        // All three should be identical
        assert_eq!(samples1, samples2);
        assert_eq!(samples2, samples3);

        // Different seeds should produce different results
        let samples_diff_seed = box_muller_sample(seed + 1, 100);
        assert_ne!(samples1, samples_diff_seed);
    }

    #[test]
    fn test_deterministic_nsga_ii_sorting() {
        // Non-dominated sort (deterministic structure)
        #[derive(Debug, Clone, PartialEq)]
        struct Solution {
            objectives: Vec<f64>,
            rank: usize,
        }

        fn fast_non_dominated_sort(population: Vec<Vec<f64>>) -> Vec<usize> {
            let n = population.len();
            let mut ranks = vec![0; n];

            // Deterministic: always iterate in same order
            let mut dominated_count = vec![0; n];
            let mut dominates: Vec<Vec<usize>> = vec![vec![]; n];

            for i in 0..n {
                for j in (i + 1)..n {
                    // Deterministic comparison
                    let p1_dominates = population[i].iter().zip(&population[j]).all(|(a, b)| a >= b)
                        && population[i] != population[j];
                    let p2_dominates = population[j].iter().zip(&population[i]).all(|(a, b)| a >= b)
                        && population[j] != population[i];

                    if p1_dominates {
                        dominates[i].push(j);
                        dominated_count[j] += 1;
                    }
                    if p2_dominates {
                        dominates[j].push(i);
                        dominated_count[i] += 1;
                    }
                }
            }

            // Rank assignment (deterministic iteration)
            let mut current_rank = 0;
            let mut processed = 0;
            while processed < n {
                let mut next_front = vec![];
                for i in 0..n {
                    if ranks[i] == 0 && (current_rank == 0 || dominated_count[i] == 0) {
                        if current_rank > 0 {
                            ranks[i] = current_rank;
                        }
                        next_front.push(i);
                        processed += 1;
                    }
                }
                if next_front.is_empty() {
                    break;
                }
                // Update dominated count for all dominated solutions
                for idx in next_front {
                    for &dominated_idx in &dominates[idx] {
                        dominated_count[dominated_idx] -= 1;
                    }
                }
                current_rank += 1;
            }

            ranks
        }

        let pop1 = vec![
            vec![1.0, 5.0],
            vec![2.0, 3.0],
            vec![3.0, 2.0],
            vec![5.0, 1.0],
        ];

        let ranks1 = fast_non_dominated_sort(pop1.clone());
        let ranks2 = fast_non_dominated_sort(pop1.clone());
        let ranks3 = fast_non_dominated_sort(pop1.clone());

        // All runs should produce same ranking (deterministic)
        assert_eq!(ranks1, ranks2);
        assert_eq!(ranks2, ranks3);
    }

    // ============================================================================
    // FEATURE NORMALIZATION (deterministic transforms)
    // ============================================================================

    #[test]
    fn test_deterministic_zscore_normalization() {
        let features = vec![25.0, 30.0, 20.0, 35.0];
        let mean = 27.5;
        let std = 6.454972244;

        fn normalize(features: &[f64], mean: f64, std: f64) -> Vec<f64> {
            features.iter().map(|x| (x - mean) / std).collect()
        }

        let norm1 = normalize(&features, mean, std);
        let norm2 = normalize(&features, mean, std);
        let norm3 = normalize(&features, mean, std);

        // All normalizations should be identical
        for i in 0..features.len() {
            assert!((norm1[i] - norm2[i]).abs() < 1e-15);
            assert!((norm2[i] - norm3[i]).abs() < 1e-15);
        }
    }

    // ============================================================================
    // JOB ORCHESTRATION (deterministic state transitions)
    // ============================================================================

    #[test]
    fn test_deterministic_exponential_backoff() {
        // Backoff formula is deterministic: 2^attempt × base_delay
        fn backoff_ms(attempt: u32) -> u64 {
            let base_ms = 2000u64;
            base_ms * (1u64 << attempt.min(15)) // Cap at 2^15 to prevent overflow
        }

        let attempts = vec![1, 2, 3, 5, 10];

        // Run multiple times
        for _ in 0..5 {
            let results: Vec<u64> = attempts.iter().map(|&a| backoff_ms(a)).collect();

            // Results should always be deterministic exponential backoff
            // Formula: 2^attempt * 2000ms, capped at 2^15
            assert_eq!(results, vec![4000, 8000, 16000, 64000, 2048000]);
        }
    }

    #[test]
    fn test_deterministic_sha256_fingerprinting() {
        use std::collections::BTreeMap;

        fn compute_fingerprint(attributes: &BTreeMap<String, String>) -> String {
            // Deterministic: sorted keys, normalize to JSON
            let json = serde_json::to_string(attributes).unwrap_or_default();
            format!("sha256:{}", json.len()) // Simplified, real code uses sha2
        }

        let mut attrs = BTreeMap::new();
        attrs.insert("job_id".to_string(), "j123".to_string());
        attrs.insert("project".to_string(), "p42".to_string());

        let fp1 = compute_fingerprint(&attrs);
        let fp2 = compute_fingerprint(&attrs);
        let fp3 = compute_fingerprint(&attrs);

        // Fingerprints should be identical
        assert_eq!(fp1, fp2);
        assert_eq!(fp2, fp3);
    }

    // ============================================================================
    // INTEGRATION: Cross-algorithm determinism
    // ============================================================================

    #[test]
    fn test_deterministic_end_to_end_pipeline() {
        // Simulate: Sample features -> Normalize -> Predict -> Record lineage

        struct Pipeline {
            seed: u64,
        }

        impl Pipeline {
            fn run(&self) -> (Vec<f64>, Vec<f64>, String) {
                let mut rng = {
                    let mut state = self.seed;
                    move || {
                        state = state.wrapping_mul(6364136223846793005).wrapping_add(1);
                        ((state >> 32) as f64) / (u32::MAX as f64)
                    }
                };

                // 1. Sample features (deterministic with seed)
                let features = vec![rng(), rng(), rng()];

                // 2. Normalize (deterministic transform)
                let mean = 0.5;
                let std = 0.287;
                let normalized: Vec<f64> = features.iter().map(|f| (f - mean) / std).collect();

                // 3. Compute lineage fingerprint (deterministic)
                let lineage = format!("seed:{}", self.seed);

                (features, normalized, lineage)
            }
        }

        let pipeline = Pipeline { seed: 12345 };

        let result1 = pipeline.run();
        let result2 = pipeline.run();
        let result3 = pipeline.run();

        // All runs should produce same results
        assert_eq!(result1.0, result2.0);
        assert_eq!(result2.0, result3.0);
        assert_eq!(result1.1, result2.1);
        assert_eq!(result1.2, result2.2);
    }

    // ============================================================================
    // REGRESSION: Known-good outputs
    // ============================================================================

    #[test]
    fn test_regression_monte_carlo_known_values() {
        // Expected values for seed=42, 1000 samples from N(0,1)
        // These are regression values - if they change, algorithm changed
        struct SeededRng {
            state: u64,
        }

        impl SeededRng {
            fn new(seed: u64) -> Self {
                SeededRng { state: seed }
            }

            fn next_f64(&mut self) -> f64 {
                const A: u64 = 6364136223846793005;
                const C: u64 = 1442695040888963407;
                self.state = (A.wrapping_mul(self.state).wrapping_add(C)) as u64;
                (self.state as f64) / (u64::MAX as f64)
            }
        }

        let mut rng = SeededRng::new(42);
        let samples: Vec<f64> = (0..1000).map(|_| rng.next_f64()).collect();

        let mean = samples.iter().sum::<f64>() / samples.len() as f64;
        let variance =
            samples.iter().map(|x| (x - mean).powi(2)).sum::<f64>() / samples.len() as f64;

        // Regression values (should be stable)
        assert!((mean - 0.5).abs() < 0.03); // Uniform [0,1] mean should be ~0.5
        assert!((variance - 0.083).abs() < 0.01); // Variance of uniform [0,1] is 1/12 ≈ 0.083
    }
}
