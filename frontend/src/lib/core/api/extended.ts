import { backendClients } from './backend';

export interface FinancialMetricsInput {
	annual_cashflows: number[];
	initial_investment: number;
	discount_rate_percent: number;
	pr_baseline?: number;
	pr_actual?: number;
}

export interface FinancialMetrics {
	npv_usd: number;
	irr_percent: number;
	pi_coeff: number;
	crop_percent: number;
}

export interface FinancialScenarioInput {
	name: string;
	electricity_price: number;
	escalation_rate_percent: number;
	degradation_rate_percent: number;
	discount_rate_percent: number;
	pr_actual?: number;
	capex_multiplier?: number;
}

export interface FinancialScenarioComparisonInput {
	annual_yield_kwh: number;
	annual_om_usd: number;
	project_life_years: number;
	base_initial_investment: number;
	pr_baseline?: number;
	scenarios: FinancialScenarioInput[];
}

export interface FinancialScenarioResult {
	name: string;
	metrics: FinancialMetrics;
	annual_revenue_usd: number;
	net_annual_cashflow_usd: number;
	simple_payback_years: number;
	roi_percent: number;
}

export interface FinancialScenarioSetInput {
	project_id: string;
	layout_id: string;
	scenarios: FinancialScenarioInput[];
}

export interface FinancialScenarioSet {
	project_id: string;
	layout_id: string;
	scenarios: FinancialScenarioInput[];
	updated_at_rfc3339: string;
}

export interface FinancialScenarioSetSummary {
	layout_id: string;
	scenario_count: number;
	updated_at_rfc3339: string;
}

export interface FinancialScenarioSetVersion {
	scenarios: FinancialScenarioInput[];
	saved_at_rfc3339: string;
}

export interface ClimateImpactInput {
	temp_impact: number;
	soiling_impact: number;
	wind_impact: number;
	availability_impact: number;
}

export interface ClimateImpactMetrics {
	soiling_factor_change: number;
	efficiency_factor_change: number;
	module_temperature_increase: number;
	availability_impact_percent: number;
}

export interface InterRowShadingInput {
	tilt_deg: number;
	gcr: number;
	latitude_deg: number;
	analysis_days?: number;
	is_tracker?: boolean;
}

export interface InterRowShadingMetrics {
	annual_shading_loss_percent: number;
	near_shading_loss_percent: number;
	optimal_gcr: number;
	note: string;
}

export interface YieldUncertaintyInput {
	p50_annual_kwh: number;
	interannual_variability_pct: number;
	measurement_uncertainty_pct: number;
	model_uncertainty_pct: number;
	soiling_uncertainty_pct: number;
	degradation_uncertainty_pct: number;
}

export interface YieldUncertaintyMetrics {
	p50_kwh: number;
	p90_kwh: number;
	p99_kwh: number;
	combined_uncertainty_pct: number;
}

export const extendedApi = {
	calculateFinancialMetrics: async (input: FinancialMetricsInput) => {
		const response = await backendClients.extended.financialMetrics({
			annualCashflows: input.annual_cashflows,
			initialInvestment: input.initial_investment,
			discountRate: input.discount_rate_percent / 100,
			prBaseline: input.pr_baseline ?? 1,
			prActual: input.pr_actual ?? 1
		});

		return {
			npv_usd: response.npvUsd,
			irr_percent: response.irrPercent,
			pi_coeff: response.piCoeff,
			crop_percent: response.cropPercent
		} satisfies FinancialMetrics;
	},

	calculateClimateImpact: async (input: ClimateImpactInput) => {
		const response = await backendClients.extended.climateImpact({
			tempImpact: input.temp_impact,
			soilingImpact: input.soiling_impact,
			windImpact: input.wind_impact,
			availabilityImpact: input.availability_impact
		});

		return {
			soiling_factor_change: response.soilingFactorChange,
			efficiency_factor_change: response.efficiencyFactorChange,
			module_temperature_increase: response.moduleTemperatureIncrease,
			availability_impact_percent: response.availabilityImpactPercent
		} satisfies ClimateImpactMetrics;
	},

	calculateInterRowShading: async (input: InterRowShadingInput) => {
		const response = await backendClients.extended.calculateInterRowShading({
			tiltDeg: input.tilt_deg,
			gcr: input.gcr,
			latitudeDeg: input.latitude_deg,
			analysisDays: input.analysis_days ?? 0,
			isTracker: input.is_tracker ?? false
		});

		return {
			annual_shading_loss_percent: response.annualShadingLossPercent,
			near_shading_loss_percent: response.nearShadingLossPercent,
			optimal_gcr: response.optimalGcr,
			note: response.note
		} satisfies InterRowShadingMetrics;
	},

	calculateYieldUncertainty: async (input: YieldUncertaintyInput) => {
		const response = await backendClients.extended.calculateYieldUncertainty({
			p50AnnualKwh: input.p50_annual_kwh,
			interannualVariabilityPct: input.interannual_variability_pct,
			measurementUncertaintyPct: input.measurement_uncertainty_pct,
			modelUncertaintyPct: input.model_uncertainty_pct,
			soilingUncertaintyPct: input.soiling_uncertainty_pct,
			degradationUncertaintyPct: input.degradation_uncertainty_pct
		});

		return {
			p50_kwh: response.p50Kwh,
			p90_kwh: response.p90Kwh,
			p99_kwh: response.p99Kwh,
			combined_uncertainty_pct: response.combinedUncertaintyPct
		} satisfies YieldUncertaintyMetrics;
	},

	compareFinancialScenarios: async (input: FinancialScenarioComparisonInput) => {
		const response = await backendClients.extended.compareFinancialScenarios({
			annualYieldKwh: input.annual_yield_kwh,
			annualOmUsd: input.annual_om_usd,
			projectLifeYears: input.project_life_years,
			baseInitialInvestment: input.base_initial_investment,
			prBaseline: input.pr_baseline ?? 1,
			scenarios: input.scenarios.map((scenario) => ({
				name: scenario.name,
				electricityPrice: scenario.electricity_price,
				escalationRatePercent: scenario.escalation_rate_percent,
				degradationRatePercent: scenario.degradation_rate_percent,
				discountRatePercent: scenario.discount_rate_percent,
				prActual: scenario.pr_actual ?? 0,
				capexMultiplier: scenario.capex_multiplier ?? 1
			}))
		});

		return {
			scenarios: (response.scenarios ?? []).map((scenario) => ({
				name: scenario.name,
				metrics: {
					npv_usd: scenario.metrics?.npvUsd ?? 0,
					irr_percent: scenario.metrics?.irrPercent ?? 0,
					pi_coeff: scenario.metrics?.piCoeff ?? 0,
					crop_percent: scenario.metrics?.cropPercent ?? 0
				},
				annual_revenue_usd: scenario.annualRevenueUsd,
				net_annual_cashflow_usd: scenario.netAnnualCashflowUsd,
				simple_payback_years: scenario.simplePaybackYears,
				roi_percent: scenario.roiPercent
			}))
		};
	},

	saveFinancialScenarioSet: async (input: FinancialScenarioSetInput) => {
		const response = await backendClients.extended.saveFinancialScenarioSet({
			projectId: input.project_id,
			layoutId: input.layout_id,
			scenarios: input.scenarios.map((scenario) => ({
				name: scenario.name,
				electricityPrice: scenario.electricity_price,
				escalationRatePercent: scenario.escalation_rate_percent,
				degradationRatePercent: scenario.degradation_rate_percent,
				discountRatePercent: scenario.discount_rate_percent,
				prActual: scenario.pr_actual ?? 0,
				capexMultiplier: scenario.capex_multiplier ?? 1
			}))
		});

		return {
			project_id: response.projectId,
			layout_id: response.layoutId,
			scenarios: response.scenarios.map((scenario) => ({
				name: scenario.name,
				electricity_price: scenario.electricityPrice,
				escalation_rate_percent: scenario.escalationRatePercent,
				degradation_rate_percent: scenario.degradationRatePercent,
				discount_rate_percent: scenario.discountRatePercent,
				pr_actual: scenario.prActual,
				capex_multiplier: scenario.capexMultiplier
			})),
			updated_at_rfc3339: response.updatedAtRfc3339
		} satisfies FinancialScenarioSet;
	},

	getFinancialScenarioSet: async (projectId: string, layoutId: string) => {
		const response = await backendClients.extended.getFinancialScenarioSet({
			projectId,
			layoutId
		});

		return {
			project_id: response.projectId,
			layout_id: response.layoutId,
			scenarios: response.scenarios.map((scenario) => ({
				name: scenario.name,
				electricity_price: scenario.electricityPrice,
				escalation_rate_percent: scenario.escalationRatePercent,
				degradation_rate_percent: scenario.degradationRatePercent,
				discount_rate_percent: scenario.discountRatePercent,
				pr_actual: scenario.prActual,
				capex_multiplier: scenario.capexMultiplier
			})),
			updated_at_rfc3339: response.updatedAtRfc3339
		} satisfies FinancialScenarioSet;
	},

	listFinancialScenarioSets: async (projectId: string): Promise<FinancialScenarioSetSummary[]> => {
		const response = await backendClients.extended.listFinancialScenarioSets({ projectId });
		return response.items.map((item) => ({
			layout_id: item.layoutId,
			scenario_count: item.scenarioCount,
			updated_at_rfc3339: item.updatedAtRfc3339
		}));
	},

	getFinancialScenarioSetVersions: async (projectId: string, layoutId: string): Promise<FinancialScenarioSetVersion[]> => {
		const response = await backendClients.extended.getFinancialScenarioSetVersions({ projectId, layoutId });
		return response.versions.map((v) => ({
			scenarios: v.scenarios.map((scenario) => ({
				name: scenario.name,
				electricity_price: scenario.electricityPrice,
				escalation_rate_percent: scenario.escalationRatePercent,
				degradation_rate_percent: scenario.degradationRatePercent,
				discount_rate_percent: scenario.discountRatePercent,
				pr_actual: scenario.prActual,
				capex_multiplier: scenario.capexMultiplier
			})),
			saved_at_rfc3339: v.savedAtRfc3339
		}));
	}
};
