use rand::{rngs::SmallRng, seq::SliceRandom, SeedableRng};
use serde::{Deserialize, Serialize};
use std::fmt::Debug;

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct GAConfig {
    pub population_size: usize,
    pub generations: usize,
    pub crossover_rate: f64,
    pub mutation_rate: f64,
    pub elite_count: usize,
}

impl GAConfig {
    pub fn validate(&self) -> Result<(), String> {
        if self.population_size < 2 {
            return Err("population_size must be at least 2".to_string());
        }
        if self.generations == 0 {
            return Err("generations must be positive".to_string());
        }
        if !(0.0..=1.0).contains(&self.crossover_rate) {
            return Err("crossover_rate must be in [0, 1]".to_string());
        }
        if !(0.0..=1.0).contains(&self.mutation_rate) {
            return Err("mutation_rate must be in [0, 1]".to_string());
        }
        if self.elite_count > self.population_size {
            return Err("elite_count cannot exceed population_size".to_string());
        }
        Ok(())
    }
}

pub trait Chromosome: Clone + Debug {
    fn crossover(&self, other: &Self, rng: &mut SmallRng) -> Self;
    fn mutate(&mut self, rng: &mut SmallRng);
    fn fitness(&self) -> f64;
}

pub struct GeneticAlgorithm {
    seed: u64,
}

impl GeneticAlgorithm {
    pub fn new(seed: u64) -> Self {
        Self { seed }
    }

    pub fn evolve<C: Chromosome + 'static>(
        &self,
        initial_population: Vec<C>,
        config: GAConfig,
    ) -> Result<C, String> {
        config.validate()?;

        if initial_population.len() != config.population_size {
            return Err("initial population size does not match config".to_string());
        }

        let mut rng = SmallRng::seed_from_u64(self.seed);
        let mut population = initial_population;

        for _generation in 0..config.generations {
            // Sort by fitness (best first)
            population.sort_by(|a, b| {
                b.fitness()
                    .partial_cmp(&a.fitness())
                    .unwrap_or(std::cmp::Ordering::Equal)
            });

            // Elitism: preserve best individuals
            let mut next_generation = population[..config.elite_count].to_vec();

            // Generate offspring
            while next_generation.len() < config.population_size {
                // Tournament selection
                let parent1 = tournament_select(&population, &mut rng);
                let parent2 = tournament_select(&population, &mut rng);

                let mut child = if rand_float(&mut rng) < config.crossover_rate {
                    parent1.crossover(&parent2, &mut rng)
                } else {
                    parent1.clone()
                };

                if rand_float(&mut rng) < config.mutation_rate {
                    child.mutate(&mut rng);
                }

                next_generation.push(child);
            }

            next_generation.truncate(config.population_size);
            population = next_generation;
        }

        population.sort_by(|a, b| {
            b.fitness()
                .partial_cmp(&a.fitness())
                .unwrap_or(std::cmp::Ordering::Equal)
        });

        Ok(population.into_iter().next().ok_or("empty population".to_string())?)
    }
}

fn tournament_select<C: Chromosome>(population: &[C], rng: &mut SmallRng) -> C {
    let tournament_size = 3.max(population.len() / 10);
    let candidates: Vec<&C> = population.choose_multiple(rng, tournament_size).collect();

    candidates
        .iter()
        .max_by(|a, b| {
            a.fitness()
                .partial_cmp(&b.fitness())
                .unwrap_or(std::cmp::Ordering::Equal)
        })
        .map(|c| (*c).clone())
        .unwrap_or_else(|| population[0].clone())
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
    struct SimpleChromosome {
        genes: Vec<f64>,
    }

    impl Chromosome for SimpleChromosome {
        fn crossover(&self, other: &Self, rng: &mut SmallRng) -> Self {
            let crossover_point = (rand_float(rng) * self.genes.len() as f64).floor() as usize;
            let mut genes = self.genes[..crossover_point].to_vec();
            genes.extend_from_slice(&other.genes[crossover_point..]);
            SimpleChromosome { genes }
        }

        fn mutate(&mut self, rng: &mut SmallRng) {
            if !self.genes.is_empty() {
                let idx = (rand_float(rng) * self.genes.len() as f64).floor() as usize;
                self.genes[idx] = rand_float(rng) * 100.0;
            }
        }

        fn fitness(&self) -> f64 {
            -self
                .genes
                .iter()
                .map(|g| (g - 50.0).powi(2))
                .sum::<f64>()
        }
    }

    #[test]
    fn ga_config_validates() {
        let config = GAConfig {
            population_size: 10,
            generations: 5,
            crossover_rate: 0.8,
            mutation_rate: 0.1,
            elite_count: 2,
        };
        assert!(config.validate().is_ok());

        let invalid = GAConfig {
            population_size: 0,
            generations: 5,
            crossover_rate: 0.8,
            mutation_rate: 0.1,
            elite_count: 2,
        };
        assert!(invalid.validate().is_err());
    }

    #[test]
    fn ga_evolves_toward_optimum() {
        let ga = GeneticAlgorithm::new(42);
        let config = GAConfig {
            population_size: 20,
            generations: 50,
            crossover_rate: 0.8,
            mutation_rate: 0.1,
            elite_count: 2,
        };

        let initial: Vec<_> = (0..20)
            .map(|_| SimpleChromosome {
                genes: vec![0.0, 0.0, 0.0],
            })
            .collect();

        let best = ga.evolve(initial, config).expect("evolution succeeds");
        let fitness = best.fitness();

        assert!(fitness > -100.0);
    }
}
