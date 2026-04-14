use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct ProjectMetrics {
    pub npv_usd: f64,
    pub irr_percent: f64,
    pub dpp_years: f64,
    pub lcoe_usd_per_mwh: f64,
    pub pi: f64,
    pub crop: f64,
}

impl ProjectMetrics {
    pub fn validate(&self) -> Result<(), String> {
        if !self.npv_usd.is_finite() {
            return Err("NPV must be finite".to_string());
        }
        if !self.irr_percent.is_finite() {
            return Err("IRR must be finite".to_string());
        }
        if !self.dpp_years.is_finite() || self.dpp_years < 0.0 {
            return Err("DPP must be non-negative".to_string());
        }
        if !self.lcoe_usd_per_mwh.is_finite() || self.lcoe_usd_per_mwh < 0.0 {
            return Err("LCOE must be non-negative".to_string());
        }
        if !self.pi.is_finite() || self.pi < 0.0 {
            return Err("PI must be non-negative".to_string());
        }
        if !self.crop.is_finite() {
            return Err("CROP must be finite".to_string());
        }
        Ok(())
    }
}

pub struct FinancialAnalyzer;

impl FinancialAnalyzer {
    pub fn calculate_npv(
        annual_cashflows: &[f64],
        initial_investment: f64,
        discount_rate: f64,
    ) -> Result<f64, String> {
        if annual_cashflows.is_empty() {
            return Err("cashflows cannot be empty".to_string());
        }
        if !initial_investment.is_finite() || initial_investment < 0.0 {
            return Err("initial investment must be non-negative".to_string());
        }
        if !discount_rate.is_finite() || discount_rate < 0.0 || discount_rate > 1.0 {
            return Err("discount rate must be 0-1".to_string());
        }

        let mut npv = -initial_investment;
        for (year, &cashflow) in annual_cashflows.iter().enumerate() {
            if !cashflow.is_finite() {
                return Err("cashflows must be finite".to_string());
            }
            let pv = cashflow / (1.0 + discount_rate).powi(year as i32 + 1);
            npv += pv;
        }

        Ok(npv)
    }

    pub fn calculate_irr(
        annual_cashflows: &[f64],
        initial_investment: f64,
    ) -> Result<f64, String> {
        if annual_cashflows.is_empty() {
            return Err("cashflows cannot be empty".to_string());
        }
        if !initial_investment.is_finite() || initial_investment < 0.0 {
            return Err("initial investment must be non-negative".to_string());
        }

        for &cf in annual_cashflows {
            if !cf.is_finite() {
                return Err("cashflows must be finite".to_string());
            }
        }

        let mut rate = 0.1;
        for _ in 0..100 {
            let mut npv = -initial_investment;
            let mut npv_derivative = 0.0;

            for (year, &cashflow) in annual_cashflows.iter().enumerate() {
                let pv = cashflow / (1.0_f64 + rate).powi(year as i32 + 1);
                let pv_prime = -cashflow * (year as f64 + 1.0)
                    / (1.0_f64 + rate).powi(year as i32 + 2);

                npv += pv;
                npv_derivative += pv_prime;
            }

            if npv.abs() < 1e-6 {
                return Ok(rate);
            }

            if npv_derivative.abs() < 1e-10 {
                return Err("IRR calculation diverged".to_string());
            }

            rate -= npv / npv_derivative;

            if rate < -0.99 || rate > 1.0 {
                return Err("IRR out of reasonable bounds".to_string());
            }
        }

        Ok(rate)
    }

    pub fn calculate_dynamic_payback(
        annual_cashflows: &[f64],
        initial_investment: f64,
        discount_rate: f64,
    ) -> Result<f64, String> {
        if annual_cashflows.is_empty() {
            return Err("cashflows cannot be empty".to_string());
        }
        if !initial_investment.is_finite() || initial_investment < 0.0 {
            return Err("initial investment must be non-negative".to_string());
        }
        if !discount_rate.is_finite() || discount_rate < 0.0 || discount_rate > 1.0 {
            return Err("discount rate must be 0-1".to_string());
        }

        let mut cumulative = -initial_investment;
        for (year, &cashflow) in annual_cashflows.iter().enumerate() {
            if !cashflow.is_finite() {
                return Err("cashflows must be finite".to_string());
            }
            let pv = cashflow / (1.0 + discount_rate).powi(year as i32 + 1);
            cumulative += pv;

            if cumulative >= 0.0 {
                if year == 0 {
                    return Ok(0.0);
                }

                let prev_cumulative =
                    cumulative - pv / (1.0 + discount_rate).powi(year as i32 + 1);
                let fraction = -prev_cumulative / pv;
                return Ok(year as f64 + fraction);
            }
        }

        Ok(f64::INFINITY)
    }

    pub fn calculate_lcoe(
        annual_energy_mwh: &[f64],
        annual_opex_usd: &[f64],
        initial_capex_usd: f64,
        discount_rate: f64,
        project_life_years: usize,
    ) -> Result<f64, String> {
        if annual_energy_mwh.is_empty() || annual_opex_usd.is_empty() {
            return Err("arrays cannot be empty".to_string());
        }
        if annual_energy_mwh.len() != annual_opex_usd.len()
            || annual_energy_mwh.len() < project_life_years
        {
            return Err("array lengths must match project life".to_string());
        }

        let mut pv_cost = initial_capex_usd;
        let mut pv_energy = 0.0;

        for year in 0..project_life_years {
            if !annual_energy_mwh[year].is_finite()
                || annual_energy_mwh[year] < 0.0
                || !annual_opex_usd[year].is_finite()
                || annual_opex_usd[year] < 0.0
            {
                return Err("invalid annual values".to_string());
            }

            let discount_factor = 1.0 / (1.0 + discount_rate).powi(year as i32 + 1);
            pv_cost += annual_opex_usd[year] * discount_factor;
            pv_energy += annual_energy_mwh[year] * discount_factor;
        }

        if pv_energy < 1e-6 {
            return Err("total PV energy too small".to_string());
        }

        Ok(pv_cost / pv_energy)
    }

    pub fn calculate_profitability_index(
        annual_cashflows: &[f64],
        initial_investment: f64,
        discount_rate: f64,
    ) -> Result<f64, String> {
        if annual_cashflows.is_empty() {
            return Err("cashflows cannot be empty".to_string());
        }
        if !initial_investment.is_finite() || initial_investment < 0.0 {
            return Err("initial investment must be non-negative".to_string());
        }

        let mut pv_inflows = 0.0;
        for (year, &cashflow) in annual_cashflows.iter().enumerate() {
            if !cashflow.is_finite() {
                return Err("cashflows must be finite".to_string());
            }
            if cashflow > 0.0 {
                pv_inflows +=
                    cashflow / (1.0 + discount_rate).powi(year as i32 + 1);
            }
        }

        if initial_investment < 1e-6 {
            return Ok(f64::INFINITY);
        }

        Ok(pv_inflows / initial_investment)
    }

    pub fn calculate_crop(
        pr_baseline: f64,
        pr_actual: f64,
    ) -> Result<f64, String> {
        if !pr_baseline.is_finite() || pr_baseline <= 0.0 {
            return Err("baseline PR must be positive".to_string());
        }
        if !pr_actual.is_finite() || pr_actual < 0.0 {
            return Err("actual PR must be non-negative".to_string());
        }

        Ok((pr_actual - pr_baseline) / pr_baseline * 100.0)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn npv_calculation_correct() {
        let cashflows = vec![1000.0, 1000.0, 1000.0, 1000.0, 1000.0];
        let npv = FinancialAnalyzer::calculate_npv(&cashflows, 3000.0, 0.1)
            .expect("NPV calculation succeeds");

        assert!(npv > 500.0);
    }

    #[test]
    fn irr_calculation_converges() {
        let cashflows = vec![1500.0, 1500.0, 1500.0];
        let irr = FinancialAnalyzer::calculate_irr(&cashflows, 3000.0)
            .expect("IRR calculation succeeds");

        assert!(irr > 0.0 && irr < 1.0);
    }

    #[test]
    fn dynamic_payback_correct() {
        let cashflows = vec![1000.0, 1000.0, 1000.0, 1000.0];
        let dpp = FinancialAnalyzer::calculate_dynamic_payback(&cashflows, 2500.0, 0.1)
            .expect("DPP calculation succeeds");

        assert!(dpp > 2.0 && dpp < 3.0);
    }

    #[test]
    fn lcoe_calculation_reasonable() {
        let energy = vec![100.0, 100.0, 100.0, 100.0, 100.0];
        let opex = vec![50.0, 50.0, 50.0, 50.0, 50.0];
        let lcoe = FinancialAnalyzer::calculate_lcoe(&energy, &opex, 10000.0, 0.08, 5)
            .expect("LCOE calculation succeeds");

        assert!(lcoe > 0.0 && lcoe < 200.0);
    }

    #[test]
    fn project_metrics_validate() {
        let mut metrics = ProjectMetrics {
            npv_usd: 100000.0,
            irr_percent: 12.5,
            dpp_years: 7.5,
            lcoe_usd_per_mwh: 45.0,
            pi: 1.3,
            crop: -2.5,
        };
        assert!(metrics.validate().is_ok());

        metrics.npv_usd = f64::NAN;
        assert!(metrics.validate().is_err());

        metrics.npv_usd = 100000.0;
        metrics.dpp_years = -1.0;
        assert!(metrics.validate().is_err());
    }
}
