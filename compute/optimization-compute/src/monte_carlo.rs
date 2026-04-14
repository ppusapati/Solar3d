use rand::{rngs::SmallRng, SeedableRng};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Distribution {
    pub mean: f64,
    pub std_dev: f64,
}

impl Distribution {
    pub fn new(mean: f64, std_dev: f64) -> Result<Self, String> {
        if !mean.is_finite() {
            return Err("mean must be finite".to_string());
        }
        if !std_dev.is_finite() || std_dev < 0.0 {
            return Err("std_dev must be finite and non-negative".to_string());
        }
        Ok(Self { mean, std_dev })
    }
}

#[derive(Debug, Clone)]
pub struct MonteCarloResult {
    pub samples: Vec<f64>,
    pub mean: f64,
    pub std_dev: f64,
    pub p10: f64,
    pub p50: f64,
    pub p90: f64,
    pub min: f64,
    pub max: f64,
}

pub struct MonteCarloEngine {
    seed: u64,
}

impl MonteCarloEngine {
    pub fn new(seed: u64) -> Self {
        Self { seed }
    }

    pub fn sample_normal(
        &self,
        distribution: &Distribution,
        num_samples: usize,
    ) -> Result<MonteCarloResult, String> {
        if num_samples == 0 {
            return Err("num_samples must be positive".to_string());
        }

        let mut rng = SmallRng::seed_from_u64(self.seed);
        let mut samples = Vec::with_capacity(num_samples);

        // Box-Muller transform for normal distribution
        for _ in (0..num_samples).step_by(2) {
            let u1: f64 = rand_float(&mut rng);
            let u2: f64 = rand_float(&mut rng);

            let z0 = (-2.0 * u1.ln()).sqrt() * (2.0 * std::f64::consts::PI * u2).cos();
            let z1 = (-2.0 * u1.ln()).sqrt() * (2.0 * std::f64::consts::PI * u2).sin();

            samples.push(distribution.mean + z0 * distribution.std_dev);
            if samples.len() < num_samples {
                samples.push(distribution.mean + z1 * distribution.std_dev);
            }
        }

        samples.truncate(num_samples);

        self.compute_statistics(&samples)
    }

    pub fn sample_uniform(
        &self,
        lower: f64,
        upper: f64,
        num_samples: usize,
    ) -> Result<MonteCarloResult, String> {
        if num_samples == 0 {
            return Err("num_samples must be positive".to_string());
        }
        if !lower.is_finite() || !upper.is_finite() {
            return Err("bounds must be finite".to_string());
        }
        if lower >= upper {
            return Err("lower must be less than upper".to_string());
        }

        let mut rng = SmallRng::seed_from_u64(self.seed);
        let mut samples = Vec::with_capacity(num_samples);

        let range = upper - lower;
        for _ in 0..num_samples {
            samples.push(lower + rand_float(&mut rng) * range);
        }

        self.compute_statistics(&samples)
    }

    pub fn sample_mixed(
        &self,
        base: f64,
        uncertainties: &[Distribution],
        num_samples: usize,
    ) -> Result<MonteCarloResult, String> {
        if num_samples == 0 {
            return Err("num_samples must be positive".to_string());
        }
        if uncertainties.is_empty() {
            return Err("at least one uncertainty distribution required".to_string());
        }

        let mut rng = SmallRng::seed_from_u64(self.seed);
        let mut samples = Vec::with_capacity(num_samples);

        for _ in 0..num_samples {
            let mut value = base;
            for dist in uncertainties {
                let u1: f64 = rand_float(&mut rng);
                let u2: f64 = rand_float(&mut rng);
                let z = (-2.0 * u1.ln()).sqrt() * (2.0 * std::f64::consts::PI * u2).cos();
                value += z * dist.std_dev;
            }
            samples.push(value);
        }

        self.compute_statistics(&samples)
    }

    fn compute_statistics(&self, samples: &[f64]) -> Result<MonteCarloResult, String> {
        if samples.is_empty() {
            return Err("empty samples".to_string());
        }

        let sum: f64 = samples.iter().sum();
        let mean = sum / samples.len() as f64;

        let variance: f64 = samples
            .iter()
            .map(|x| (x - mean).powi(2))
            .sum::<f64>()
            / samples.len() as f64;
        let std_dev = variance.sqrt();

        let mut sorted = samples.to_vec();
        sorted.sort_by(|a, b| a.partial_cmp(b).unwrap_or(std::cmp::Ordering::Equal));

        let percentile = |p: f64| -> f64 {
            let idx = ((p / 100.0) * (sorted.len() - 1) as f64).floor() as usize;
            sorted[idx]
        };

        Ok(MonteCarloResult {
            samples: samples.to_vec(),
            mean,
            std_dev,
            p10: percentile(10.0),
            p50: percentile(50.0),
            p90: percentile(90.0),
            min: *sorted.first().expect("non-empty"),
            max: *sorted.last().expect("non-empty"),
        })
    }
}

fn rand_float<R: rand::Rng>(rng: &mut R) -> f64 {
    use rand::distributions::Distribution as RandDist;
    use rand::distributions::Uniform;
    let uniform = Uniform::new(0.0, 1.0);
    uniform.sample(rng)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn normal_distribution_sampling() {
        let engine = MonteCarloEngine::new(42);
        let dist = Distribution::new(100.0, 10.0).expect("valid distribution");

        let result = engine
            .sample_normal(&dist, 1000)
            .expect("sampling succeeds");

        assert!((result.mean - 100.0).abs() < 5.0);
        assert!((result.std_dev - 10.0).abs() < 5.0);
        assert!((result.p50 - 100.0).abs() < 5.0);
    }

    #[test]
    fn uniform_distribution_sampling() {
        let engine = MonteCarloEngine::new(42);
        let result = engine.sample_uniform(0.0, 100.0, 1000).expect("sampling");

        assert!((result.mean - 50.0).abs() < 10.0);
        assert!(result.min >= 0.0);
        assert!(result.max <= 100.0);
    }

    #[test]
    fn deterministic_with_same_seed() {
        let engine1 = MonteCarloEngine::new(123);
        let engine2 = MonteCarloEngine::new(123);
        let dist = Distribution::new(50.0, 5.0).expect("valid");

        let result1 = engine1.sample_normal(&dist, 100).expect("sampling");
        let result2 = engine2.sample_normal(&dist, 100).expect("sampling");

        assert_eq!(result1.samples, result2.samples);
    }

    #[test]
    fn different_seeds_produce_different_samples() {
        let engine1 = MonteCarloEngine::new(123);
        let engine2 = MonteCarloEngine::new(456);
        let dist = Distribution::new(50.0, 5.0).expect("valid");

        let result1 = engine1.sample_normal(&dist, 100).expect("sampling");
        let result2 = engine2.sample_normal(&dist, 100).expect("sampling");

        assert_ne!(result1.samples, result2.samples);
    }

    #[test]
    fn percentiles_are_ordered() {
        let engine = MonteCarloEngine::new(42);
        let dist = Distribution::new(100.0, 20.0).expect("valid");

        let result = engine.sample_normal(&dist, 1000).expect("sampling");

        assert!(result.p10 <= result.p50);
        assert!(result.p50 <= result.p90);
    }
}
