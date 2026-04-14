use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Serialize, Deserialize)]
pub enum ObjectiveKind {
    Minimize,
    Maximize,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Objective {
    pub name: String,
    pub kind: ObjectiveKind,
    pub weight: f64,
}

#[derive(Debug, Clone)]
pub struct MultiObjective {
    pub objectives: Vec<Objective>,
}

impl MultiObjective {
    pub fn new(objectives: Vec<Objective>) -> Result<Self, String> {
        if objectives.is_empty() {
            return Err("at least one objective required".to_string());
        }

        let mut total_weight = 0.0;
        for obj in &objectives {
            if !obj.weight.is_finite() || obj.weight < 0.0 {
                return Err("objective weight must be finite and non-negative".to_string());
            }
            total_weight += obj.weight;
        }

        if total_weight <= 0.0 {
            return Err("total weight must be positive".to_string());
        }

        Ok(Self { objectives })
    }

    pub fn normalize_weights(&mut self) {
        let total: f64 = self.objectives.iter().map(|o| o.weight).sum();
        if total > 0.0 {
            for obj in &mut self.objectives {
                obj.weight /= total;
            }
        }
    }

    pub fn weighted_score(&self, values: &[f64]) -> Result<f64, String> {
        if values.len() != self.objectives.len() {
            return Err("mismatch between objectives and values".to_string());
        }

        let mut score = 0.0;
        let mut total_weight = 0.0;
        for (i, obj) in self.objectives.iter().enumerate() {
            if !values[i].is_finite() {
                return Err("non-finite objective value".to_string());
            }

            let contribution = match obj.kind {
                ObjectiveKind::Minimize => values[i],
                ObjectiveKind::Maximize => -values[i],
            };

            score += contribution * obj.weight;
            total_weight += obj.weight;
        }

        if total_weight > 0.0 {
            Ok(score / total_weight)
        } else {
            Ok(0.0)
        }
    }

    pub fn dominates(&self, a: &[f64], b: &[f64]) -> Result<bool, String> {
        if a.len() != self.objectives.len() || b.len() != self.objectives.len() {
            return Err("dimension mismatch".to_string());
        }

        let mut at_least_one_better = false;
        let mut all_worse_or_equal = true;

        for (i, obj) in self.objectives.iter().enumerate() {
            let better = match obj.kind {
                ObjectiveKind::Minimize => a[i] < b[i],
                ObjectiveKind::Maximize => a[i] > b[i],
            };

            let worse = match obj.kind {
                ObjectiveKind::Minimize => a[i] > b[i],
                ObjectiveKind::Maximize => a[i] < b[i],
            };

            if better {
                at_least_one_better = true;
            }
            if worse {
                all_worse_or_equal = false;
            }
        }

        Ok(at_least_one_better && all_worse_or_equal)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn two_obj_min_max() -> MultiObjective {
        MultiObjective::new(vec![
            Objective {
                name: "cost".to_string(),
                kind: ObjectiveKind::Minimize,
                weight: 0.5,
            },
            Objective {
                name: "efficiency".to_string(),
                kind: ObjectiveKind::Maximize,
                weight: 0.5,
            },
        ])
        .expect("valid objectives")
    }

    #[test]
    fn dominance_check_works() {
        let mo = two_obj_min_max();
        let a = vec![10.0, 90.0];
        let b = vec![20.0, 80.0];

        assert!(mo.dominates(&a, &b).expect("domination check"));
    }

    #[test]
    fn non_dominated_pair() {
        let mo = two_obj_min_max();
        let a = vec![10.0, 80.0];
        let b = vec![20.0, 90.0];

        assert!(!mo.dominates(&a, &b).expect("non-domination check"));
    }

    #[test]
    fn weighted_score_calculation() {
        let mo = two_obj_min_max();
        let values = vec![10.0, 50.0];

        let score = mo.weighted_score(&values).expect("score");
        assert!((score - (10.0 - 50.0) / 2.0).abs() < 1e-9);
    }
}
