use crate::MultiObjective;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Solution {
    pub id: usize,
    pub variables: Vec<f64>,
    pub objectives: Vec<f64>,
    pub rank: usize,
    pub crowding_distance: f64,
}

#[derive(Debug, Clone)]
pub struct ParetoFrontier {
    solutions: Vec<Solution>,
    multi_objective: MultiObjective,
}

impl ParetoFrontier {
    pub fn new(multi_objective: MultiObjective) -> Self {
        Self {
            solutions: Vec::new(),
            multi_objective,
        }
    }

    pub fn add(&mut self, solution: Solution) -> Result<(), String> {
        if solution.objectives.len() != self.multi_objective.objectives.len() {
            return Err("objective dimension mismatch".to_string());
        }

        // Remove solutions dominated by the new one
        let mut to_remove = Vec::new();
        for (i, existing) in self.solutions.iter().enumerate() {
            if self
                .multi_objective
                .dominates(&solution.objectives, &existing.objectives)?
            {
                to_remove.push(i);
            }
        }

        // Check if new solution is dominated by anything remaining
        for existing in &self.solutions {
            if to_remove.iter().any(|&idx| idx == existing.rank) {
                continue;
            }
            if self
                .multi_objective
                .dominates(&existing.objectives, &solution.objectives)?
            {
                return Ok(());
            }
        }

        // Remove dominated solutions in reverse order to avoid index shifting
        for &idx in to_remove.iter().rev() {
            if idx < self.solutions.len() {
                self.solutions.remove(idx);
            }
        }

        self.solutions.push(solution);
        self.recompute_crowding_distances();
        Ok(())
    }

    pub fn add_batch(&mut self, solutions: Vec<Solution>) -> Result<(), String> {
        for sol in solutions {
            self.add(sol)?;
        }
        Ok(())
    }

    pub fn frontier(&self) -> &[Solution] {
        &self.solutions
    }

    pub fn frontier_mut(&mut self) -> &mut [Solution] {
        &mut self.solutions
    }

    pub fn size(&self) -> usize {
        self.solutions.len()
    }

    pub fn best_by_weighted_score(&self) -> Option<&Solution> {
        self.solutions
            .iter()
            .min_by(|a, b| {
                let sa = self
                    .multi_objective
                    .weighted_score(&a.objectives)
                    .unwrap_or(f64::INFINITY);
                let sb = self
                    .multi_objective
                    .weighted_score(&b.objectives)
                    .unwrap_or(f64::INFINITY);
                sa.partial_cmp(&sb)
                    .unwrap_or(std::cmp::Ordering::Equal)
                    .then_with(|| a.id.cmp(&b.id))
            })
    }

    pub fn best_by_crowding_distance(&self) -> Option<&Solution> {
        self.solutions
            .iter()
            .max_by(|a, b| {
                a.crowding_distance
                    .partial_cmp(&b.crowding_distance)
                    .unwrap_or(std::cmp::Ordering::Equal)
                    .then_with(|| b.id.cmp(&a.id))
            })
    }

    fn recompute_crowding_distances(&mut self) {
        if self.solutions.len() <= 2 {
            for sol in &mut self.solutions {
                sol.crowding_distance = f64::INFINITY;
            }
            return;
        }

        for sol in &mut self.solutions {
            sol.crowding_distance = 0.0;
        }

        let num_objectives = self.multi_objective.objectives.len();
        for obj_idx in 0..num_objectives {
            self.solutions.sort_by(|a, b| {
                a.objectives[obj_idx]
                    .partial_cmp(&b.objectives[obj_idx])
                    .unwrap_or(std::cmp::Ordering::Equal)
            });

            let max_diff = self.solutions.last().unwrap().objectives[obj_idx]
                - self.solutions.first().unwrap().objectives[obj_idx];

            if max_diff.abs() <= f64::EPSILON {
                continue;
            }

            let len = self.solutions.len();
            self.solutions[0].crowding_distance = f64::INFINITY;
            self.solutions[len - 1].crowding_distance = f64::INFINITY;

            for i in 1..len - 1 {
                let lower = self.solutions[i - 1].objectives[obj_idx];
                let upper = self.solutions[i + 1].objectives[obj_idx];
                let distance = (upper - lower) / max_diff;
                self.solutions[i].crowding_distance += distance;
            }
        }
    }

    pub fn clear(&mut self) {
        self.solutions.clear();
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::objectives::{Objective, ObjectiveKind};

    fn test_frontier() -> ParetoFrontier {
        let mo = MultiObjective::new(vec![
            Objective {
                name: "cost".to_string(),
                kind: ObjectiveKind::Minimize,
                weight: 0.5,
            },
            Objective {
                name: "quality".to_string(),
                kind: ObjectiveKind::Maximize,
                weight: 0.5,
            },
        ])
        .expect("objectives valid");

        ParetoFrontier::new(mo)
    }

    #[test]
    fn frontier_adds_non_dominated_solutions() {
        let mut frontier = test_frontier();

        frontier
            .add(Solution {
                id: 1,
                variables: vec![1.0],
                objectives: vec![10.0, 50.0],
                rank: 0,
                crowding_distance: 0.0,
            })
            .expect("add solution 1");

        frontier
            .add(Solution {
                id: 2,
                variables: vec![2.0],
                objectives: vec![20.0, 60.0],
                rank: 0,
                crowding_distance: 0.0,
            })
            .expect("add solution 2");

        assert_eq!(frontier.size(), 2);
    }

    #[test]
    fn frontier_removes_dominated_solutions() {
        let mut frontier = test_frontier();

        frontier
            .add(Solution {
                id: 1,
                variables: vec![1.0],
                objectives: vec![20.0, 50.0],
                rank: 0,
                crowding_distance: 0.0,
            })
            .expect("add solution 1");

        frontier
            .add(Solution {
                id: 2,
                variables: vec![2.0],
                objectives: vec![10.0, 60.0],
                rank: 0,
                crowding_distance: 0.0,
            })
            .expect("add solution 2");

        assert_eq!(frontier.size(), 1);
        assert_eq!(frontier.frontier()[0].id, 2);
    }

    #[test]
    fn crowding_distance_infinite_at_extremes() {
        let mut frontier = test_frontier();

        for i in 0..5 {
            frontier
                .add(Solution {
                    id: i,
                    variables: vec![i as f64],
                    objectives: vec![10.0 + i as f64 * 10.0, 40.0 + i as f64 * 10.0],
                    rank: 0,
                    crowding_distance: 0.0,
                })
                .expect("add solution");
        }

        assert_eq!(frontier.solutions[0].crowding_distance, f64::INFINITY);
        assert_eq!(frontier.solutions[4].crowding_distance, f64::INFINITY);
    }
}
