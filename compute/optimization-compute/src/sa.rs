use rand::{rngs::SmallRng, SeedableRng};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct SAConfig {
    pub initial_temperature: f64,
    pub cooling_rate: f64,
    pub iterations: usize,
    pub perturbation_scale: f64,
}

impl SAConfig {
    pub fn validate(&self) -> Result<(), String> {
        if !self.initial_temperature.is_finite() || self.initial_temperature <= 0.0 {
            return Err("initial_temperature must be finite and positive".to_string());
        }
        if !(0.0..1.0).contains(&self.cooling_rate) {
            return Err("cooling_rate must be in (0, 1)".to_string());
        }
        if self.iterations == 0 {
            return Err("iterations must be positive".to_string());
        }
        if !self.perturbation_scale.is_finite() || self.perturbation_scale <= 0.0 {
            return Err("perturbation_scale must be finite and positive".to_string());
        }
        Ok(())
    }
}

pub trait SACandidate: Clone {
    fn perturb(&self, perturbation_scale: f64, rng: &mut SmallRng) -> Self;
    fn energy(&self) -> f64;
}

pub struct SimulatedAnnealing {
    seed: u64,
}

impl SimulatedAnnealing {
    pub fn new(seed: u64) -> Self {
        Self { seed }
    }

    pub fn optimize<C: SACandidate>(&self, initial: C, config: SAConfig) -> Result<C, String> {
        config.validate()?;

        let mut rng = SmallRng::seed_from_u64(self.seed);
        let mut current = initial;
        let mut best = current.clone();
        let mut temperature = config.initial_temperature;

        for _iteration in 0..config.iterations {
            let neighbor = current.perturb(config.perturbation_scale, &mut rng);

            let delta_e = neighbor.energy() - current.energy();

            let accept = if delta_e < 0.0 {
                true
            } else {
                let probability = (-delta_e / temperature).exp();
                rand_float(&mut rng) < probability
            };

            if accept {
                current = neighbor;

                if current.energy() < best.energy() {
                    best = current.clone();
                }
            }

            temperature *= config.cooling_rate;
        }

        Ok(best)
    }
}

fn rand_float(rng: &mut SmallRng) -> f64 {
    use rand::distributions::Distribution as RandDist;
    use rand::distributions::Uniform;
    let uniform = Uniform::new(0.0, 1.0);
    uniform.sample(rng)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[derive(Clone, Debug)]
    struct SimpleCandidate {
        x: f64,
    }

    impl SACandidate for SimpleCandidate {
        fn perturb(&self, perturbation_scale: f64, rng: &mut SmallRng) -> Self {
            use rand::distributions::Distribution as RandDist;
            use rand::distributions::Uniform;
            let uniform = Uniform::new(-perturbation_scale, perturbation_scale);
            SimpleCandidate {
                x: self.x + uniform.sample(rng),
            }
        }

        fn energy(&self) -> f64 {
            (self.x - 5.0).powi(2)
        }
    }

    #[test]
    fn sa_config_validates() {
        let config = SAConfig {
            initial_temperature: 100.0,
            cooling_rate: 0.95,
            iterations: 1000,
            perturbation_scale: 1.0,
        };
        assert!(config.validate().is_ok());

        let invalid = SAConfig {
            initial_temperature: 0.0,
            cooling_rate: 0.95,
            iterations: 1000,
            perturbation_scale: 1.0,
        };
        assert!(invalid.validate().is_err());
    }

    #[test]
    fn sa_finds_local_optimum() {
        let sa = SimulatedAnnealing::new(42);
        let config = SAConfig {
            initial_temperature: 10.0,
            cooling_rate: 0.99,
            iterations: 500,
            perturbation_scale: 2.0,
        };

        let initial = SimpleCandidate { x: 0.0 };
        let result = sa.optimize(initial, config).expect("optimization succeeds");

        assert!((result.x - 5.0).abs() < 2.0);
    }

    #[test]
    fn deterministic_with_same_seed() {
        let sa1 = SimulatedAnnealing::new(123);
        let sa2 = SimulatedAnnealing::new(123);
        let config = SAConfig {
            initial_temperature: 10.0,
            cooling_rate: 0.99,
            iterations: 100,
            perturbation_scale: 1.0,
        };

        let initial = SimpleCandidate { x: 0.0 };
        let result1 = sa1.optimize(initial.clone(), config).expect("opt1");
        let result2 = sa2.optimize(initial, config).expect("opt2");

        assert!((result1.x - result2.x).abs() < 1e-9);
    }
}
