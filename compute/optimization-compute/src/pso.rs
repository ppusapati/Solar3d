use rand::{rngs::SmallRng, SeedableRng};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct PSOConfig {
    pub num_particles: usize,
    pub iterations: usize,
    pub c1: f64,
    pub c2: f64,
    pub w: f64,
    pub boundary_min: f64,
    pub boundary_max: f64,
}

impl PSOConfig {
    pub fn validate(&self) -> Result<(), String> {
        if self.num_particles == 0 {
            return Err("num_particles must be positive".to_string());
        }
        if self.iterations == 0 {
            return Err("iterations must be positive".to_string());
        }
        if !self.c1.is_finite() || self.c1 < 0.0 {
            return Err("c1 (cognitive coefficient) must be non-negative and finite".to_string());
        }
        if !self.c2.is_finite() || self.c2 < 0.0 {
            return Err("c2 (social coefficient) must be non-negative and finite".to_string());
        }
        if !(0.0..1.0).contains(&self.w) {
            return Err("w (inertia) must be in [0, 1)".to_string());
        }
        if !self.boundary_min.is_finite() || !self.boundary_max.is_finite() {
            return Err("boundary_min and boundary_max must be finite".to_string());
        }
        if self.boundary_min >= self.boundary_max {
            return Err("boundary_min must be less than boundary_max".to_string());
        }
        Ok(())
    }
}

pub trait PSO1DObjective {
    fn evaluate(&self, x: f64) -> f64;
    fn is_minimization(&self) -> bool {
        true
    }
}

struct Particle {
    position: f64,
    velocity: f64,
    best_position: f64,
    best_value: f64,
}

pub struct ParticleSwarmOptimizer {
    seed: u64,
}

impl ParticleSwarmOptimizer {
    pub fn new(seed: u64) -> Self {
        Self { seed }
    }

    pub fn optimize<O: PSO1DObjective>(
        &self,
        objective: &O,
        config: PSOConfig,
    ) -> Result<(f64, f64), String> {
        config.validate()?;

        let mut rng = SmallRng::seed_from_u64(self.seed);

        let init_pos_range = config.boundary_max - config.boundary_min;
        let mut particles = Vec::with_capacity(config.num_particles);

        for _ in 0..config.num_particles {
            let position = config.boundary_min + rand_float(&mut rng) * init_pos_range;
            let position = position.clamp(config.boundary_min, config.boundary_max);
            let value = objective.evaluate(position);

            particles.push(Particle {
                position,
                velocity: (rand_float(&mut rng) - 0.5) * init_pos_range,
                best_position: position,
                best_value: value,
            });
        }

        let mut best_position = particles[0].best_position;
        let mut best_value = particles[0].best_value;

        for particle in &particles[1..] {
            if is_better(particle.best_value, best_value, objective.is_minimization()) {
                best_value = particle.best_value;
                best_position = particle.best_position;
            }
        }

        for _iteration in 0..config.iterations {
            for particle in &mut particles {
                let r1 = rand_float(&mut rng);
                let r2 = rand_float(&mut rng);

                let cognitive = config.c1 * r1 * (particle.best_position - particle.position);
                let social = config.c2 * r2 * (best_position - particle.position);

                particle.velocity = config.w * particle.velocity + cognitive + social;
                particle.velocity = particle.velocity.clamp(-init_pos_range * 0.5, init_pos_range * 0.5);

                particle.position += particle.velocity;
                particle.position = particle.position.clamp(config.boundary_min, config.boundary_max);

                let value = objective.evaluate(particle.position);

                if is_better(value, particle.best_value, objective.is_minimization()) {
                    particle.best_value = value;
                    particle.best_position = particle.position;

                    if is_better(value, best_value, objective.is_minimization()) {
                        best_value = value;
                        best_position = particle.position;
                    }
                }
            }
        }

        Ok((best_position, best_value))
    }
}

fn is_better(value_a: f64, value_b: f64, is_minimization: bool) -> bool {
    if is_minimization {
        value_a < value_b
    } else {
        value_a > value_b
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

    struct SphereObjective;

    impl PSO1DObjective for SphereObjective {
        fn evaluate(&self, x: f64) -> f64 {
            x.powi(2)
        }

        fn is_minimization(&self) -> bool {
            true
        }
    }

    struct InvertedQuadraticObjective;

    impl PSO1DObjective for InvertedQuadraticObjective {
        fn evaluate(&self, x: f64) -> f64 {
            -(x - 3.0).powi(2) + 10.0
        }

        fn is_minimization(&self) -> bool {
            false
        }
    }

    #[test]
    fn pso_config_validates() {
        let config = PSOConfig {
            num_particles: 30,
            iterations: 100,
            c1: 2.0,
            c2: 2.0,
            w: 0.7,
            boundary_min: -10.0,
            boundary_max: 10.0,
        };
        assert!(config.validate().is_ok());

        let invalid = PSOConfig {
            num_particles: 0,
            iterations: 100,
            c1: 2.0,
            c2: 2.0,
            w: 0.7,
            boundary_min: -10.0,
            boundary_max: 10.0,
        };
        assert!(invalid.validate().is_err());
    }

    #[test]
    fn pso_minimizes_quadratic() {
        let pso = ParticleSwarmOptimizer::new(42);
        let config = PSOConfig {
            num_particles: 20,
            iterations: 200,
            c1: 2.0,
            c2: 2.0,
            w: 0.7,
            boundary_min: -10.0,
            boundary_max: 10.0,
        };

        let objective = SphereObjective;
        let (best_x, best_value) = pso
            .optimize(&objective, config)
            .expect("optimization succeeds");

        assert!(best_value < 0.5);
        assert!(best_x.abs() < 1.0);
    }

    #[test]
    fn pso_maximizes_inverted_quadratic() {
        let pso = ParticleSwarmOptimizer::new(123);
        let config = PSOConfig {
            num_particles: 25,
            iterations: 150,
            c1: 2.0,
            c2: 2.0,
            w: 0.75,
            boundary_min: 0.0,
            boundary_max: 6.0,
        };

        let objective = InvertedQuadraticObjective;
        let (best_x, best_value) = pso
            .optimize(&objective, config)
            .expect("optimization succeeds");

        assert!(best_value > 9.5);
        assert!((best_x - 3.0).abs() < 0.5);
    }

    #[test]
    fn pso_deterministic_with_same_seed() {
        let pso1 = ParticleSwarmOptimizer::new(456);
        let pso2 = ParticleSwarmOptimizer::new(456);
        let config = PSOConfig {
            num_particles: 15,
            iterations: 100,
            c1: 2.0,
            c2: 2.0,
            w: 0.7,
            boundary_min: -10.0,
            boundary_max: 10.0,
        };

        let objective = SphereObjective;
        let (x1, v1) = pso1.optimize(&objective, config).expect("opt1");
        let (x2, v2) = pso2.optimize(&objective, config).expect("opt2");

        assert!((x1 - x2).abs() < 1e-9);
        assert!((v1 - v2).abs() < 1e-9);
    }
}
