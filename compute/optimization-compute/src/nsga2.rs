/// NSGA-II: Non-Dominated Sorting Genetic Algorithm II
///
/// Implements the algorithm from Deb et al. (2002) with:
/// - Fast non-dominated sorting
/// - Crowding distance tournament selection
/// - Simulated Binary Crossover (SBX)
/// - Polynomial mutation
///
/// All stochastic operations derive from a single user-supplied `seed` for
/// full reproducibility.
use crate::MultiObjective;
use rand::{rngs::SmallRng, Rng as _, SeedableRng};
use serde::{Deserialize, Serialize};

// ── Public Types ─────────────────────────────────────────────────────────────

/// Configuration for the NSGA-II run.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NSGA2Config {
    /// Number of individuals per generation (must be even and ≥ 4).
    pub population_size: usize,
    /// Number of generations to evolve.
    pub generations: usize,
    /// Probability of performing SBX crossover (0.0–1.0).
    pub crossover_rate: f64,
    /// Per-variable probability of polynomial mutation (0.0–1.0).
    pub mutation_rate: f64,
    /// Lower and upper bounds for each decision variable.
    pub variable_bounds: Vec<(f64, f64)>,
    /// Distribution index for SBX crossover (default: 15.0, range: 2–20).
    pub eta_c: f64,
    /// Distribution index for polynomial mutation (default: 20.0, range: 10–100).
    pub eta_m: f64,
}

impl NSGA2Config {
    /// Create a config with sensible defaults (eta_c=15, eta_m=20).
    pub fn new(
        population_size: usize,
        generations: usize,
        crossover_rate: f64,
        mutation_rate: f64,
        variable_bounds: Vec<(f64, f64)>,
    ) -> Self {
        Self {
            population_size,
            generations,
            crossover_rate,
            mutation_rate,
            variable_bounds,
            eta_c: 15.0,
            eta_m: 20.0,
        }
    }

    pub fn validate(&self) -> Result<(), String> {
        if self.population_size < 4 {
            return Err("population_size must be at least 4".to_string());
        }
        if self.population_size % 2 != 0 {
            return Err("population_size must be even".to_string());
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
        if self.variable_bounds.is_empty() {
            return Err("variable_bounds must not be empty".to_string());
        }
        for (i, &(lo, hi)) in self.variable_bounds.iter().enumerate() {
            if !lo.is_finite() || !hi.is_finite() || lo >= hi {
                return Err(format!(
                    "variable_bounds[{}] is invalid: ({}, {})", i, lo, hi
                ));
            }
        }
        if self.eta_c <= 0.0 || !self.eta_c.is_finite() {
            return Err("eta_c must be positive".to_string());
        }
        if self.eta_m <= 0.0 || !self.eta_m.is_finite() {
            return Err("eta_m must be positive".to_string());
        }
        Ok(())
    }
}

/// An individual in the NSGA-II population.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct NSGA2Individual {
    /// Decision variable values, one per dimension in `variable_bounds`.
    pub variables: Vec<f64>,
    /// Objective values evaluated by the user-supplied function.
    pub objectives: Vec<f64>,
    /// Domination rank (0 = first/Pareto front, higher = worse).
    pub rank: usize,
    /// Crowding distance within the individual's front.
    pub crowding_distance: f64,
}

/// Result returned by `NSGA2::evolve`.
#[derive(Debug, Clone)]
pub struct NSGA2Result {
    /// All individuals in the first (non-dominated) front of the final population.
    pub pareto_front: Vec<NSGA2Individual>,
    /// Full final population, sorted by rank then crowding distance.
    pub population: Vec<NSGA2Individual>,
}

// ── Core Algorithm ────────────────────────────────────────────────────────────

/// NSGA-II optimizer.
///
/// # Example
/// ```ignore
/// let evaluate = |x: &[f64]| vec![x[0] * x[0], (x[0] - 2.0).powi(2)];
/// let objectives = MultiObjective::new(vec![
///     Objective { name: "f1".into(), kind: ObjectiveKind::Minimize, weight: 0.5 },
///     Objective { name: "f2".into(), kind: ObjectiveKind::Minimize, weight: 0.5 },
/// ]).unwrap();
/// let config = NSGA2Config::new(100, 200, 0.9, 0.1, vec![(-3.0, 3.0)]);
/// let result = NSGA2::evolve(&evaluate, &objectives, &config, 42).unwrap();
/// ```
pub struct NSGA2;

impl NSGA2 {
    /// Run NSGA-II evolutionary optimization.
    ///
    /// * `evaluate` — pure function: variable vector → objective vector.  Must
    ///   return a `Vec<f64>` with the same length as `objectives.objectives`.
    /// * `objectives` — specifies minimize/maximize per dimension.
    /// * `config` — algorithm hyperparameters and variable bounds.
    /// * `seed` — deterministic PRNG seed.
    pub fn evolve<F>(
        evaluate: &F,
        objectives: &MultiObjective,
        config: &NSGA2Config,
        seed: u64,
    ) -> Result<NSGA2Result, String>
    where
        F: Fn(&[f64]) -> Vec<f64>,
    {
        config.validate()?;
        let _n_vars = config.variable_bounds.len();
        let n_obj = objectives.objectives.len();

        let mut rng = SmallRng::seed_from_u64(seed);

        // ── Initialise population ──────────────────────────────────────────────
        let mut population: Vec<NSGA2Individual> = (0..config.population_size)
            .map(|_| {
                let vars: Vec<f64> = config
                    .variable_bounds
                    .iter()
                    .map(|&(lo, hi)| rng.gen_range(lo..=hi))
                    .collect();
                let objs = evaluate(&vars);
                NSGA2Individual {
                    variables: vars,
                    objectives: objs,
                    rank: 0,
                    crowding_distance: 0.0,
                }
            })
            .collect();

        // Validate objective dimensions.
        for ind in &population {
            if ind.objectives.len() != n_obj {
                return Err(format!(
                    "evaluate returned {} objectives but MultiObjective has {}",
                    ind.objectives.len(), n_obj
                ));
            }
        }

        fast_non_dominated_sort_and_crowding(&mut population, objectives)?;

        // ── Generation loop ────────────────────────────────────────────────────
        for _ in 0..config.generations {
            let mut offspring = create_offspring(&population, config, &mut rng);

            // Evaluate offspring objectives.
            for ind in &mut offspring {
                ind.objectives = evaluate(&ind.variables);
            }

            // Combined population R = P ∪ Q.
            population.extend(offspring);

            // Sort combined population.
            fast_non_dominated_sort_and_crowding(&mut population, objectives)?;

            // Select the best N individuals by (rank ASC, crowding_distance DESC).
            population.sort_by(|a, b| {
                a.rank
                    .cmp(&b.rank)
                    .then_with(|| {
                        b.crowding_distance
                            .partial_cmp(&a.crowding_distance)
                            .unwrap_or(std::cmp::Ordering::Equal)
                    })
            });
            population.truncate(config.population_size);
        }

        let pareto_front: Vec<NSGA2Individual> =
            population.iter().filter(|ind| ind.rank == 0).cloned().collect();

        Ok(NSGA2Result { pareto_front, population })
    }
}

// ── Fast Non-Dominated Sorting ─────────────────────────────────────────────

/// Assign `rank` and `crowding_distance` to every individual in `pop` in-place.
///
/// Front 0 = first Pareto front (non-dominated by anyone).
pub(crate) fn fast_non_dominated_sort_and_crowding(
    pop: &mut Vec<NSGA2Individual>,
    objectives: &MultiObjective,
) -> Result<(), String> {
    let n = pop.len();
    // domination_count[i] = how many individuals dominate i
    let mut dom_count = vec![0usize; n];
    // dominated_by[i] = indices of individuals i dominates
    let mut dominated_by: Vec<Vec<usize>> = vec![Vec::new(); n];

    for i in 0..n {
        for j in 0..n {
            if i == j {
                continue;
            }
            if objectives.dominates(&pop[i].objectives, &pop[j].objectives)? {
                dominated_by[i].push(j);
            } else if objectives.dominates(&pop[j].objectives, &pop[i].objectives)? {
                dom_count[i] += 1;
            }
        }
    }

    // Iteratively build fronts.
    // NOTE: Do NOT use pop[i].rank for membership tracking — initial rank is 0
    //       which equals the first front rank and would cause a false retain.
    //       Use an explicit `assigned` bitvector instead.
    let mut assigned = vec![false; n];
    let mut unassigned_count = n;
    let mut current_rank = 0;

    while unassigned_count > 0 {
        // Current front: all unassigned individuals with dom_count == 0.
        let front: Vec<usize> = (0..n)
            .filter(|&i| !assigned[i] && dom_count[i] == 0)
            .collect();

        if front.is_empty() {
            // Degenerate case (e.g. numerical ties): assign all remaining.
            for i in 0..n {
                if !assigned[i] {
                    pop[i].rank = current_rank;
                    assigned[i] = true;
                    unassigned_count -= 1;
                }
            }
            break;
        }

        for &i in &front {
            pop[i].rank = current_rank;
            assigned[i] = true;
            unassigned_count -= 1;
        }

        // Decrement dom_count for every solution that this front's members dominate.
        for &i in &front {
            for &j in &dominated_by[i] {
                if dom_count[j] > 0 {
                    dom_count[j] -= 1;
                }
            }
        }

        assign_crowding_distances_for_front(&front, pop, objectives);
        current_rank += 1;
    }

    Ok(())
}

/// Assign crowding distances to one front of objective vectors.
///
/// Boundary individuals (extreme on any objective) receive `f64::INFINITY`.
fn assign_crowding_distances_for_front(
    front: &[usize],
    pop: &mut Vec<NSGA2Individual>,
    objectives: &MultiObjective,
) {
    let m = front.len();
    if m == 0 {
        return;
    }
    // Reset.
    for &i in front {
        pop[i].crowding_distance = 0.0;
    }
    if m <= 2 {
        for &i in front {
            pop[i].crowding_distance = f64::INFINITY;
        }
        return;
    }

    let n_obj = objectives.objectives.len();

    for obj_idx in 0..n_obj {
        // Sort front by this objective.
        let mut sorted = front.to_vec();
        sorted.sort_by(|&a, &b| {
            pop[a].objectives[obj_idx]
                .partial_cmp(&pop[b].objectives[obj_idx])
                .unwrap_or(std::cmp::Ordering::Equal)
        });

        // Mark boundary individuals.
        pop[*sorted.first().unwrap()].crowding_distance = f64::INFINITY;
        pop[*sorted.last().unwrap()].crowding_distance = f64::INFINITY;

        let f_min = pop[sorted[0]].objectives[obj_idx];
        let f_max = pop[sorted[m - 1]].objectives[obj_idx];
        let range = f_max - f_min;
        if range < 1e-12 {
            continue; // All values identical; skip to avoid dividing by zero.
        }

        for k in 1..(m - 1) {
            if pop[sorted[k]].crowding_distance.is_infinite() {
                continue;
            }
            let delta = pop[sorted[k + 1]].objectives[obj_idx]
                - pop[sorted[k - 1]].objectives[obj_idx];
            pop[sorted[k]].crowding_distance += delta / range;
        }
    }
}

// ── Variation Operators ────────────────────────────────────────────────────

/// Binary tournament selection: returns index of winner.
///
/// Prefers lower rank; breaks ties by higher crowding distance.
fn tournament(pop: &[NSGA2Individual], i: usize, j: usize) -> usize {
    if pop[i].rank < pop[j].rank {
        i
    } else if pop[j].rank < pop[i].rank {
        j
    } else if pop[i].crowding_distance >= pop[j].crowding_distance {
        i
    } else {
        j
    }
}

/// Create an offspring population of size N using tournament + SBX + polynomial mutation.
fn create_offspring(
    pop: &[NSGA2Individual],
    config: &NSGA2Config,
    rng: &mut SmallRng,
) -> Vec<NSGA2Individual> {
    let n = pop.len();
    let mut offspring = Vec::with_capacity(n);

    while offspring.len() < n {
        // Binary tournament for parent 1.
        let a1 = rng.gen_range(0..n);
        let b1 = rng.gen_range(0..n);
        let p1 = tournament(pop, a1, b1);

        // Binary tournament for parent 2 (ensure different).
        let a2 = rng.gen_range(0..n);
        let b2 = rng.gen_range(0..n);
        let p2 = tournament(pop, a2, b2);

        let (mut child1, mut child2) = if rng.gen::<f64>() < config.crossover_rate {
            sbx_crossover(&pop[p1].variables, &pop[p2].variables, config, rng)
        } else {
            (pop[p1].variables.clone(), pop[p2].variables.clone())
        };

        polynomial_mutation(&mut child1, config, rng);
        polynomial_mutation(&mut child2, config, rng);

        offspring.push(NSGA2Individual {
            variables: child1,
            objectives: Vec::new(), // filled by caller
            rank: 0,
            crowding_distance: 0.0,
        });
        if offspring.len() < n {
            offspring.push(NSGA2Individual {
                variables: child2,
                objectives: Vec::new(),
                rank: 0,
                crowding_distance: 0.0,
            });
        }
    }

    offspring
}

/// Simulated Binary Crossover (SBX) for real-valued variables.
///
/// Returns two children. Both are guaranteed to lie within `config.variable_bounds`.
fn sbx_crossover(
    x1: &[f64],
    x2: &[f64],
    config: &NSGA2Config,
    rng: &mut SmallRng,
) -> (Vec<f64>, Vec<f64>) {
    let eta = config.eta_c;
    let mut c1 = x1.to_vec();
    let mut c2 = x2.to_vec();

    for k in 0..x1.len() {
        let (lo, hi) = config.variable_bounds[k];
        if (x1[k] - x2[k]).abs() < 1e-14 {
            continue;
        }
        let u: f64 = rng.gen();
        let beta = if u <= 0.5 {
            (2.0 * u).powf(1.0 / (eta + 1.0))
        } else {
            (1.0 / (2.0 * (1.0 - u))).powf(1.0 / (eta + 1.0))
        };

        let (lo_v, hi_v) = if x1[k] < x2[k] {
            (x1[k], x2[k])
        } else {
            (x2[k], x1[k])
        };

        c1[k] = (0.5 * ((lo_v + hi_v) - beta * (hi_v - lo_v))).clamp(lo, hi);
        c2[k] = (0.5 * ((lo_v + hi_v) + beta * (hi_v - lo_v))).clamp(lo, hi);
    }

    (c1, c2)
}

/// Polynomial mutation for real-valued variables.
fn polynomial_mutation(vars: &mut Vec<f64>, config: &NSGA2Config, rng: &mut SmallRng) {
    let eta = config.eta_m;
    for k in 0..vars.len() {
        if rng.gen::<f64>() >= config.mutation_rate {
            continue;
        }
        let (lo, hi) = config.variable_bounds[k];
        let r: f64 = rng.gen();
        let delta = if r < 0.5 {
            (2.0 * r).powf(1.0 / (eta + 1.0)) - 1.0
        } else {
            1.0 - (2.0 * (1.0 - r)).powf(1.0 / (eta + 1.0))
        };
        vars[k] = (vars[k] + delta * (hi - lo)).clamp(lo, hi);
    }
}

// ── Tests ─────────────────────────────────────────────────────────────────────

#[cfg(test)]
mod tests {
    use super::*;
    use crate::objectives::ObjectiveKind;
    use crate::Objective;

    fn two_min_objectives() -> MultiObjective {
        MultiObjective::new(vec![
            Objective { name: "f1".into(), kind: ObjectiveKind::Minimize, weight: 0.5 },
            Objective { name: "f2".into(), kind: ObjectiveKind::Minimize, weight: 0.5 },
        ])
        .unwrap()
    }

    /// Classic ZDT1 test problem on x ∈ [0,1]^n.
    /// True Pareto front: f1 ∈ [0,1], f2 = 1 - sqrt(f1).
    fn zdt1(x: &[f64]) -> Vec<f64> {
        let f1 = x[0];
        let n = x.len() as f64;
        let g = 1.0 + 9.0 * x[1..].iter().sum::<f64>() / (n - 1.0);
        let f2 = g * (1.0 - (f1 / g).sqrt());
        vec![f1, f2]
    }

    #[test]
    fn nsga2_config_validates_correctly() {
        let config = NSGA2Config::new(100, 100, 0.9, 0.05, vec![(0.0, 1.0); 5]);
        assert!(config.validate().is_ok());

        let bad = NSGA2Config::new(3, 100, 0.9, 0.05, vec![(0.0, 1.0)]);
        assert!(bad.validate().is_err());

        let odd = NSGA2Config::new(5, 100, 0.9, 0.05, vec![(0.0, 1.0)]);
        assert!(odd.validate().is_err());
    }

    #[test]
    fn config_rejects_invalid_bounds() {
        let config = NSGA2Config::new(8, 10, 0.9, 0.1, vec![(1.0, 0.0)]); // lo > hi
        assert!(config.validate().is_err());
    }

    #[test]
    fn nsga2_returns_non_dominated_front_for_zdt1() {
        let config = NSGA2Config::new(40, 50, 0.9, 0.1, vec![(0.0, 1.0); 5]);
        let objectives = two_min_objectives();
        let result = NSGA2::evolve(&zdt1, &objectives, &config, 42).unwrap();

        // All front members should have rank 0.
        for ind in &result.pareto_front {
            assert_eq!(ind.rank, 0);
        }
        assert!(!result.pareto_front.is_empty());
    }

    #[test]
    fn nsga2_pareto_front_is_non_dominated() {
        let config = NSGA2Config::new(40, 30, 0.9, 0.1, vec![(0.0, 1.0); 3]);
        let objectives = two_min_objectives();
        let result = NSGA2::evolve(&zdt1, &objectives, &config, 7).unwrap();

        // Verify no front member is dominated by another front member.
        let front = &result.pareto_front;
        for i in 0..front.len() {
            for j in 0..front.len() {
                if i == j { continue; }
                let dominated = objectives
                    .dominates(&front[j].objectives, &front[i].objectives)
                    .unwrap();
                assert!(!dominated, "individual {} dominates {}", j, i);
            }
        }
    }

    #[test]
    fn nsga2_deterministic_with_same_seed() {
        let config = NSGA2Config::new(20, 20, 0.9, 0.1, vec![(0.0, 1.0); 3]);
        let objectives = two_min_objectives();
        let r1 = NSGA2::evolve(&zdt1, &objectives, &config, 99).unwrap();
        let r2 = NSGA2::evolve(&zdt1, &objectives, &config, 99).unwrap();

        assert_eq!(r1.population.len(), r2.population.len());
        for (a, b) in r1.population.iter().zip(r2.population.iter()) {
            for (va, vb) in a.variables.iter().zip(b.variables.iter()) {
                assert!((va - vb).abs() < 1e-12);
            }
        }
    }

    #[test]
    fn nsga2_different_seeds_produce_different_results() {
        let config = NSGA2Config::new(20, 20, 0.9, 0.1, vec![(0.0, 1.0); 3]);
        let objectives = two_min_objectives();
        let r1 = NSGA2::evolve(&zdt1, &objectives, &config, 1).unwrap();
        let r2 = NSGA2::evolve(&zdt1, &objectives, &config, 2).unwrap();
        // Extremely unlikely to be identical
        let all_same = r1.population.iter().zip(r2.population.iter()).all(|(a, b)| {
            a.variables.iter().zip(b.variables.iter()).all(|(va, vb)| (va - vb).abs() < 1e-12)
        });
        assert!(!all_same);
    }

    #[test]
    fn fast_non_dominated_sort_correctly_ranks() {
        // Three objectives, all minimize.
        let objectives = MultiObjective::new(vec![
            Objective { name: "f1".into(), kind: ObjectiveKind::Minimize, weight: 1.0 },
        ])
        .unwrap();
        let mut pop = vec![
            NSGA2Individual { variables: vec![1.0], objectives: vec![3.0], rank: 0, crowding_distance: 0.0 },
            NSGA2Individual { variables: vec![2.0], objectives: vec![1.0], rank: 0, crowding_distance: 0.0 },
            NSGA2Individual { variables: vec![3.0], objectives: vec![2.0], rank: 0, crowding_distance: 0.0 },
        ];
        fast_non_dominated_sort_and_crowding(&mut pop, &objectives).unwrap();
        // Best is objectives[1]=1.0 → rank 0
        assert_eq!(pop[1].rank, 0);
        assert_eq!(pop[2].rank, 1);
        assert_eq!(pop[0].rank, 2);
    }

    #[test]
    fn crowding_distances_boundary_are_infinite() {
        let objectives = two_min_objectives();
        let mut pop: Vec<NSGA2Individual> = vec![
            NSGA2Individual { variables: vec![], objectives: vec![0.0, 1.0], rank: 0, crowding_distance: 0.0 },
            NSGA2Individual { variables: vec![], objectives: vec![0.5, 0.5], rank: 0, crowding_distance: 0.0 },
            NSGA2Individual { variables: vec![], objectives: vec![1.0, 0.0], rank: 0, crowding_distance: 0.0 },
        ];
        let front = vec![0, 1, 2];
        assign_crowding_distances_for_front(&front, &mut pop, &objectives);
        assert!(pop[0].crowding_distance.is_infinite());
        assert!(pop[2].crowding_distance.is_infinite());
        assert!(pop[1].crowding_distance.is_finite());
    }
}
