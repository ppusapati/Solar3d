<script lang="ts">
	import { activeLayout, activeProject } from '$lib/core/stores';
	import {
		extendedApi,
		type ClimateImpactMetrics,
		type FinancialMetrics,
		type FinancialScenarioResult,
		type FinancialScenarioSetVersion,
		type InterRowShadingMetrics,
		type YieldUncertaintyMetrics
	} from '$lib/core/api';

	type ScenarioDraft = {
		name: string;
		electricity_price: number;
		escalation_rate_percent: number;
		degradation_rate_percent: number;
		discount_rate_percent: number;
		pr_actual: number;
		capex_multiplier: number;
	};

	let panelCost = 0.25;
	let inverterCostPerW = 0.05;
	let bosCostPerW = 0.15;
	let installCostPerW = 0.1;
	let landCostPerAcre = 5000;
	let acres = 0;
	let degradationRate = 0.5;
	let discountRate = 6;
	let electricityPrice = 0.06;
	let escalationRate = 2;
	let projectLife = 25;
	let annualYield = 0;
	let prBaseline = 0.82;
	let prActual = 0.78;
	let tempImpact = 2;
	let soilingImpact = 1.5;
	let windImpact = 0.8;
	let availabilityImpact = 1.2;
	let shadingTiltDeg = 20;
	let shadingGcr = 0.45;
	let shadingLatitudeDeg = 23;
	let shadingIsTracker = false;
	let uncertaintyInterannualPct = 5;
	let uncertaintyMeasurementPct = 3;
	let uncertaintyModelPct = 4;
	let uncertaintySoilingPct = 2;
	let uncertaintyDegradationPct = 1;
	let analyticsBusy = false;
	let scenarioBusy = false;
	let analyticsError = '';
	let scenarioStatus = '';
	let backendMetrics: FinancialMetrics | null = null;
	let climateMetrics: ClimateImpactMetrics | null = null;
	let shadingMetrics: InterRowShadingMetrics | null = null;
	let uncertaintyMetrics: YieldUncertaintyMetrics | null = null;
	let scenarioResults: FinancialScenarioResult[] = [];
	let baseScenario: FinancialScenarioResult | null = null;
	let loadedLayoutId: string | null = null;
	let loadedScenarioKey: string | null = null;
	let scenarioVersions: FinancialScenarioSetVersion[] = [];
	let selectedVersionIdx: number | null = null;
	let scenarioBase = {
		name: 'Base',
		electricity_price: 0,
		escalation_rate_percent: 0,
		degradation_rate_percent: 0,
		discount_rate_percent: 0,
		pr_actual: 0,
		capex_multiplier: 1
	} satisfies ScenarioDraft;
	let scenarioUpside = {
		name: 'Upside',
		electricity_price: 0,
		escalation_rate_percent: 0,
		degradation_rate_percent: 0,
		discount_rate_percent: 0,
		pr_actual: 0,
		capex_multiplier: 0.95
	} satisfies ScenarioDraft;
	let scenarioDownside = {
		name: 'Downside',
		electricity_price: 0,
		escalation_rate_percent: 0,
		degradation_rate_percent: 0,
		discount_rate_percent: 0,
		pr_actual: 0,
		capex_multiplier: 1.1
	} satisfies ScenarioDraft;

	$: capacityKw = $activeLayout?.total_capacity_kw ?? 0;
	$: capacityW = capacityKw * 1000;
	$: totalPanels = $activeLayout?.total_panels ?? 0;
	$: panelTotal = capacityW * panelCost;
	$: inverterTotal = capacityW * inverterCostPerW;
	$: bosTotal = capacityW * bosCostPerW;
	$: installTotal = capacityW * installCostPerW;
	$: landTotal = acres * landCostPerAcre;
	$: totalCapex = panelTotal + inverterTotal + bosTotal + installTotal + landTotal;
	$: costPerWatt = capacityW > 0 ? totalCapex / capacityW : 0;
	$: annualOM = capacityW * 0.01;
	$: annualRevenue = annualYield * electricityPrice;
	$: netAnnualCashflow = annualRevenue - annualOM;
	$: simplePayback = netAnnualCashflow > 0 ? totalCapex / netAnnualCashflow : 0;
	$: roi25Year = totalCapex > 0 ? ((netAnnualCashflow * projectLife - totalCapex) / totalCapex) * 100 : 0;

	function scenarioStorageKey(layoutId: string): string {
		return `solar3d:financial:scenarios:${layoutId}`;
	}

	function buildDefaultScenarios(): {
		base: ScenarioDraft;
		upside: ScenarioDraft;
		downside: ScenarioDraft;
	} {
		return {
			base: {
				name: 'Base',
				electricity_price: electricityPrice,
				escalation_rate_percent: escalationRate,
				degradation_rate_percent: degradationRate,
				discount_rate_percent: discountRate,
				pr_actual: prActual,
				capex_multiplier: 1
			},
			upside: {
				name: 'Upside',
				electricity_price: electricityPrice * 1.08,
				escalation_rate_percent: escalationRate + 0.5,
				degradation_rate_percent: Math.max(0, degradationRate - 0.1),
				discount_rate_percent: Math.max(0, discountRate - 0.5),
				pr_actual: Math.min(1, prActual + 0.02),
				capex_multiplier: 0.95
			},
			downside: {
				name: 'Downside',
				electricity_price: electricityPrice * 0.92,
				escalation_rate_percent: Math.max(0, escalationRate - 0.5),
				degradation_rate_percent: degradationRate + 0.1,
				discount_rate_percent: discountRate + 0.75,
				pr_actual: Math.max(0, prActual - 0.02),
				capex_multiplier: 1.1
			}
		};
	}

	function initializeScenarios(layoutId: string) {
		const defaults = buildDefaultScenarios();
		scenarioBase = defaults.base;
		scenarioUpside = defaults.upside;
		scenarioDownside = defaults.downside;

		if (typeof localStorage === 'undefined') {
			loadedScenarioKey = scenarioStorageKey(layoutId);
			return;
		}

		try {
			const key = scenarioStorageKey(layoutId);
			const raw = localStorage.getItem(key);
			if (!raw) {
				loadedScenarioKey = key;
				return;
			}

			const parsed = JSON.parse(raw) as {
				base?: Partial<ScenarioDraft>;
				upside?: Partial<ScenarioDraft>;
				downside?: Partial<ScenarioDraft>;
			};
			scenarioBase = { ...defaults.base, ...parsed.base, name: 'Base' };
			scenarioUpside = { ...defaults.upside, ...parsed.upside, name: 'Upside' };
			scenarioDownside = { ...defaults.downside, ...parsed.downside, name: 'Downside' };
			loadedScenarioKey = key;
		} catch {
			loadedScenarioKey = scenarioStorageKey(layoutId);
		}
	}

	function applyScenarioDrafts(scenarios: ScenarioDraft[]) {
		const defaults = buildDefaultScenarios();
		const byName = new Map(scenarios.map((scenario) => [scenario.name.toLowerCase(), scenario]));
		scenarioBase = { ...defaults.base, ...(byName.get('base') ?? {}), name: 'Base' };
		scenarioUpside = { ...defaults.upside, ...(byName.get('upside') ?? {}), name: 'Upside' };
		scenarioDownside = { ...defaults.downside, ...(byName.get('downside') ?? {}), name: 'Downside' };
	}

	async function loadServerScenarioSet() {
		if (!$activeProject?.id || !$activeLayout?.id) {
			return;
		}
		scenarioBusy = true;
		scenarioStatus = '';
		try {
			const stored = await extendedApi.getFinancialScenarioSet($activeProject.id, $activeLayout.id);
			applyScenarioDrafts(stored.scenarios as ScenarioDraft[]);
			scenarioStatus = `Loaded server scenarios (${new Date(stored.updated_at_rfc3339).toLocaleString()}).`;
		} catch {
			scenarioStatus = 'No saved server scenario set for this layout yet.';
		} finally {
			scenarioBusy = false;
		}
		await loadVersionHistory();
	}

	async function loadVersionHistory() {
		if (!$activeProject?.id || !$activeLayout?.id) {
			return;
		}
		try {
			scenarioVersions = await extendedApi.getFinancialScenarioSetVersions(
				$activeProject.id,
				$activeLayout.id
			);
			selectedVersionIdx = null;
		} catch {
			scenarioVersions = [];
		}
	}

	function restoreVersion() {
		if (selectedVersionIdx === null || selectedVersionIdx < 0 || selectedVersionIdx >= scenarioVersions.length) {
			return;
		}
		const version = scenarioVersions[selectedVersionIdx];
		applyScenarioDrafts(version.scenarios as ScenarioDraft[]);
		scenarioStatus = `Restored snapshot from ${new Date(version.saved_at_rfc3339).toLocaleString()}.`;
		selectedVersionIdx = null;
		void runBackendAnalytics();
	}

	async function saveServerScenarioSet() {		if (!$activeProject?.id || !$activeLayout?.id) {
			analyticsError = 'Select an active project/layout before saving scenarios.';
			return;
		}
		scenarioBusy = true;
		scenarioStatus = '';
		analyticsError = '';
		try {
			const saved = await extendedApi.saveFinancialScenarioSet({
				project_id: $activeProject.id,
				layout_id: $activeLayout.id,
				scenarios: [scenarioBase, scenarioUpside, scenarioDownside]
			});
			scenarioStatus = `Saved server scenarios (${new Date(saved.updated_at_rfc3339).toLocaleString()}).`;
			await loadVersionHistory();
		} catch (error: unknown) {
			analyticsError = error instanceof Error ? error.message : 'Failed to save server scenario set';
		} finally {
			scenarioBusy = false;
		}
	}

	function exportScenarioJson() {
		const payload = {
			version: 1,
			project_id: $activeProject?.id ?? '',
			layout_id: $activeLayout?.id ?? '',
			exported_at: new Date().toISOString(),
			scenarios: [scenarioBase, scenarioUpside, scenarioDownside]
		};
		const blob = new Blob([JSON.stringify(payload, null, 2)], { type: 'application/json' });
		const url = URL.createObjectURL(blob);
		const anchor = document.createElement('a');
		anchor.href = url;
		anchor.download = `financial-scenarios-${$activeLayout?.id ?? 'layout'}.json`;
		document.body.appendChild(anchor);
		anchor.click();
		anchor.remove();
		URL.revokeObjectURL(url);
		scenarioStatus = 'Scenario JSON exported.';
	}

	async function importScenarioJson(event: Event) {
		const input = event.currentTarget as HTMLInputElement | null;
		const file = input?.files?.[0];
		if (!file) {
			return;
		}

		analyticsError = '';
		scenarioStatus = '';
		try {
			const raw = await file.text();
			const parsed = JSON.parse(raw) as {
				scenarios?: Partial<ScenarioDraft>[];
			};
			if (!parsed.scenarios || parsed.scenarios.length === 0) {
				throw new Error('JSON file has no scenarios array');
			}
			const normalized = parsed.scenarios
				.filter((scenario): scenario is Partial<ScenarioDraft> & { name: string } => typeof scenario.name === 'string')
				.map((scenario) => ({
					name: scenario.name,
					electricity_price: Number(scenario.electricity_price ?? electricityPrice),
					escalation_rate_percent: Number(scenario.escalation_rate_percent ?? escalationRate),
					degradation_rate_percent: Number(scenario.degradation_rate_percent ?? degradationRate),
					discount_rate_percent: Number(scenario.discount_rate_percent ?? discountRate),
					pr_actual: Number(scenario.pr_actual ?? prActual),
					capex_multiplier: Number(scenario.capex_multiplier ?? 1)
				} satisfies ScenarioDraft));
			applyScenarioDrafts(normalized);
			scenarioStatus = `Imported ${normalized.length} scenarios from JSON.`;
			await runBackendAnalytics();
		} catch (error: unknown) {
			analyticsError = error instanceof Error ? error.message : 'Failed to import scenario JSON';
		} finally {
			if (input) {
				input.value = '';
			}
		}
	}

	function persistScenarios(layoutId: string) {
		if (typeof localStorage === 'undefined') {
			return;
		}

		try {
			localStorage.setItem(
				scenarioStorageKey(layoutId),
				JSON.stringify({
					base: scenarioBase,
					upside: scenarioUpside,
					downside: scenarioDownside
				})
			);
		} catch {
			// Ignore localStorage persistence failures.
		}
	}

	function buildAnnualCashflows(): number[] {
		const flows: number[] = [];
		for (let year = 1; year <= projectLife; year += 1) {
			const degradedYield = annualYield * Math.pow(1 - degradationRate / 100, year - 1);
			const escalatedPrice = electricityPrice * Math.pow(1 + escalationRate / 100, year - 1);
			const yearRevenue = degradedYield * escalatedPrice;
			flows.push(yearRevenue - annualOM);
		}
		return flows;
	}

	async function runBackendAnalytics() {
		analyticsBusy = true;
		analyticsError = '';
		try {
			const annual_cashflows = buildAnnualCashflows();
			const [financial, climate, shading, uncertainty] = await Promise.all([
				extendedApi.calculateFinancialMetrics({
					annual_cashflows,
					initial_investment: totalCapex,
					discount_rate_percent: discountRate,
					pr_baseline: prBaseline,
					pr_actual: prActual
				}),
				extendedApi.calculateClimateImpact({
					temp_impact: tempImpact,
					soiling_impact: soilingImpact,
					wind_impact: windImpact,
					availability_impact: availabilityImpact
				}),
				extendedApi.calculateInterRowShading({
					tilt_deg: shadingTiltDeg,
					gcr: shadingGcr,
					latitude_deg: shadingLatitudeDeg,
					analysis_days: 365,
					is_tracker: shadingIsTracker
				}),
				extendedApi.calculateYieldUncertainty({
					p50_annual_kwh: Math.max(annualYield, 1),
					interannual_variability_pct: uncertaintyInterannualPct,
					measurement_uncertainty_pct: uncertaintyMeasurementPct,
					model_uncertainty_pct: uncertaintyModelPct,
					soiling_uncertainty_pct: uncertaintySoilingPct,
					degradation_uncertainty_pct: uncertaintyDegradationPct
				})
			]);

			const comparison = await extendedApi.compareFinancialScenarios({
				annual_yield_kwh: annualYield,
				annual_om_usd: annualOM,
				project_life_years: projectLife,
				base_initial_investment: totalCapex,
				pr_baseline: prBaseline,
				scenarios: [scenarioBase, scenarioUpside, scenarioDownside]
			});

			backendMetrics = financial;
			climateMetrics = climate;
			shadingMetrics = shading;
			uncertaintyMetrics = uncertainty;
			scenarioResults = comparison.scenarios;
		} catch (error: unknown) {
			analyticsError = error instanceof Error ? error.message : 'Failed to calculate backend financial analytics';
		} finally {
			analyticsBusy = false;
		}
	}

	$: if ($activeLayout?.id && $activeLayout.id !== loadedLayoutId) {
		loadedLayoutId = $activeLayout.id;
		annualYield = Math.max(annualYield, $activeLayout.total_capacity_kw * 1800);
		initializeScenarios($activeLayout.id);
		void loadServerScenarioSet();
		void runBackendAnalytics();
	}

	$: if ($activeLayout?.id && loadedScenarioKey === scenarioStorageKey($activeLayout.id)) {
		persistScenarios($activeLayout.id);
	}

	$: baseScenario = scenarioResults.find((scenario) => scenario.name.toLowerCase() === 'base') ?? scenarioResults[0] ?? null;
</script>

<div class="finance-panel">
	<h4>Financial Model</h4>

	{#if analyticsError}
		<div class="error">{analyticsError}</div>
	{/if}
	{#if scenarioStatus}
		<div class="status">{scenarioStatus}</div>
	{/if}

	<div class="section">
		<h5>Capital Costs</h5>
		<div class="cost-item"><span class="cost-label">Panels ({totalPanels})</span><div class="cost-input"><input type="number" bind:value={panelCost} step="0.01" min="0" /><span class="unit">$/W</span></div><span class="cost-total">${(panelTotal / 1000).toFixed(0)}k</span></div>
		<div class="cost-item"><span class="cost-label">Inverters</span><div class="cost-input"><input type="number" bind:value={inverterCostPerW} step="0.01" min="0" /><span class="unit">$/W</span></div><span class="cost-total">${(inverterTotal / 1000).toFixed(0)}k</span></div>
		<div class="cost-item"><span class="cost-label">BOS</span><div class="cost-input"><input type="number" bind:value={bosCostPerW} step="0.01" min="0" /><span class="unit">$/W</span></div><span class="cost-total">${(bosTotal / 1000).toFixed(0)}k</span></div>
		<div class="cost-item"><span class="cost-label">Install</span><div class="cost-input"><input type="number" bind:value={installCostPerW} step="0.01" min="0" /><span class="unit">$/W</span></div><span class="cost-total">${(installTotal / 1000).toFixed(0)}k</span></div>
		<div class="cost-item"><span class="cost-label">Land</span><div class="cost-input"><input type="number" bind:value={acres} step="1" min="0" /><span class="unit">acres</span></div><span class="cost-total">${(landTotal / 1000).toFixed(0)}k</span></div>
		<div class="cost-total-row"><span>Total CAPEX</span><span class="total-value">${(totalCapex / 1000000).toFixed(2)}M</span></div>
		<div class="cost-total-row sub"><span>Cost per Watt</span><span>${costPerWatt.toFixed(2)}/W</span></div>
	</div>

	<div class="divider"></div>

	<div class="section">
		<h5>Backend Analytics Inputs</h5>
		<div class="assumption-row"><label for="financial-annual-yield">Annual Yield (kWh)</label><input id="financial-annual-yield" type="number" bind:value={annualYield} step="1000" /></div>
		<div class="assumption-row"><label for="financial-electricity-price">Electricity Price</label><div class="input-unit"><input id="financial-electricity-price" type="number" bind:value={electricityPrice} step="0.005" min="0" /><span>$/kWh</span></div></div>
		<div class="assumption-row"><label for="financial-escalation-rate">Escalation</label><div class="input-unit"><input id="financial-escalation-rate" type="number" bind:value={escalationRate} step="0.5" /><span>%/yr</span></div></div>
		<div class="assumption-row"><label for="financial-degradation-rate">Degradation</label><div class="input-unit"><input id="financial-degradation-rate" type="number" bind:value={degradationRate} step="0.1" min="0" /><span>%/yr</span></div></div>
		<div class="assumption-row"><label for="financial-discount-rate">Discount Rate</label><div class="input-unit"><input id="financial-discount-rate" type="number" bind:value={discountRate} step="0.5" min="0" /><span>%</span></div></div>
		<div class="assumption-row"><label for="financial-pr-baseline">PR Baseline</label><div class="input-unit"><input id="financial-pr-baseline" type="number" bind:value={prBaseline} step="0.01" min="0" max="1" /><span>0-1</span></div></div>
		<div class="assumption-row"><label for="financial-pr-actual">PR Actual</label><div class="input-unit"><input id="financial-pr-actual" type="number" bind:value={prActual} step="0.01" min="0" max="1" /><span>0-1</span></div></div>
		<button class="btn-run" on:click={runBackendAnalytics} disabled={analyticsBusy || !$activeLayout}>{analyticsBusy ? 'Calculating…' : 'Run Backend Analytics'}</button>
	</div>

	<div class="divider"></div>

	<div class="section">
		<h5>Scenario Assumptions</h5>
		<div class="button-row compact">
			<button class="btn-secondary" on:click={saveServerScenarioSet} disabled={scenarioBusy || !$activeProject || !$activeLayout}>Save To Server</button>
			<button class="btn-secondary" on:click={() => void loadServerScenarioSet()} disabled={scenarioBusy || !$activeProject || !$activeLayout}>Load From Server</button>
			<button class="btn-secondary" on:click={exportScenarioJson} disabled={!$activeLayout}>Export JSON</button>
			<label class="btn-secondary file-btn">
				Import JSON
				<input type="file" accept="application/json" on:change={importScenarioJson} />
			</label>
		</div>
		<table class="scenario-input-table">
			<thead>
				<tr>
					<th>Scenario</th>
					<th>Price</th>
					<th>Esc %</th>
					<th>Deg %</th>
					<th>Disc %</th>
					<th>PR</th>
					<th>Capex x</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>Base</td>
					<td><input type="number" bind:value={scenarioBase.electricity_price} step="0.001" min="0" /></td>
					<td><input type="number" bind:value={scenarioBase.escalation_rate_percent} step="0.1" /></td>
					<td><input type="number" bind:value={scenarioBase.degradation_rate_percent} step="0.1" min="0" /></td>
					<td><input type="number" bind:value={scenarioBase.discount_rate_percent} step="0.1" min="0" /></td>
					<td><input type="number" bind:value={scenarioBase.pr_actual} step="0.01" min="0" max="1" /></td>
					<td><input type="number" bind:value={scenarioBase.capex_multiplier} step="0.01" min="0" /></td>
				</tr>
				<tr>
					<td>Upside</td>
					<td><input type="number" bind:value={scenarioUpside.electricity_price} step="0.001" min="0" /></td>
					<td><input type="number" bind:value={scenarioUpside.escalation_rate_percent} step="0.1" /></td>
					<td><input type="number" bind:value={scenarioUpside.degradation_rate_percent} step="0.1" min="0" /></td>
					<td><input type="number" bind:value={scenarioUpside.discount_rate_percent} step="0.1" min="0" /></td>
					<td><input type="number" bind:value={scenarioUpside.pr_actual} step="0.01" min="0" max="1" /></td>
					<td><input type="number" bind:value={scenarioUpside.capex_multiplier} step="0.01" min="0" /></td>
				</tr>
				<tr>
					<td>Downside</td>
					<td><input type="number" bind:value={scenarioDownside.electricity_price} step="0.001" min="0" /></td>
					<td><input type="number" bind:value={scenarioDownside.escalation_rate_percent} step="0.1" /></td>
					<td><input type="number" bind:value={scenarioDownside.degradation_rate_percent} step="0.1" min="0" /></td>
					<td><input type="number" bind:value={scenarioDownside.discount_rate_percent} step="0.1" min="0" /></td>
					<td><input type="number" bind:value={scenarioDownside.pr_actual} step="0.01" min="0" max="1" /></td>
					<td><input type="number" bind:value={scenarioDownside.capex_multiplier} step="0.01" min="0" /></td>
				</tr>
			</tbody>
		</table>
	</div>

	<div class="divider"></div>

	<div class="section">
		<h5>Climate Inputs</h5>
		<div class="assumption-row"><label for="financial-temp-impact">Temp Impact</label><div class="input-unit"><input id="financial-temp-impact" type="number" bind:value={tempImpact} step="0.1" /><span>%</span></div></div>
		<div class="assumption-row"><label for="financial-soiling-impact">Soiling Impact</label><div class="input-unit"><input id="financial-soiling-impact" type="number" bind:value={soilingImpact} step="0.1" /><span>%</span></div></div>
		<div class="assumption-row"><label for="financial-wind-impact">Wind Impact</label><div class="input-unit"><input id="financial-wind-impact" type="number" bind:value={windImpact} step="0.1" /><span>%</span></div></div>
		<div class="assumption-row"><label for="financial-availability-impact">Availability Impact</label><div class="input-unit"><input id="financial-availability-impact" type="number" bind:value={availabilityImpact} step="0.1" /><span>%</span></div></div>
	</div>

	<div class="divider"></div>

	<div class="section">
		<h5>Backend Fidelity Inputs</h5>
		<div class="assumption-row"><label for="financial-shading-tilt">Shading Tilt</label><div class="input-unit"><input id="financial-shading-tilt" type="number" bind:value={shadingTiltDeg} step="1" min="0" max="90" /><span>deg</span></div></div>
		<div class="assumption-row"><label for="financial-shading-gcr">Ground Coverage Ratio</label><div class="input-unit"><input id="financial-shading-gcr" type="number" bind:value={shadingGcr} step="0.01" min="0.1" max="0.95" /><span>0-1</span></div></div>
		<div class="assumption-row"><label for="financial-shading-latitude">Latitude</label><div class="input-unit"><input id="financial-shading-latitude" type="number" bind:value={shadingLatitudeDeg} step="0.1" min="-90" max="90" /><span>deg</span></div></div>
		<div class="assumption-row"><label for="financial-tracker-flag">Tracker</label><input id="financial-tracker-flag" type="checkbox" bind:checked={shadingIsTracker} /></div>
		<div class="assumption-row"><label for="financial-uncertainty-interannual">Interannual Uncertainty</label><div class="input-unit"><input id="financial-uncertainty-interannual" type="number" bind:value={uncertaintyInterannualPct} step="0.1" min="0" /><span>%</span></div></div>
		<div class="assumption-row"><label for="financial-uncertainty-measurement">Measurement Uncertainty</label><div class="input-unit"><input id="financial-uncertainty-measurement" type="number" bind:value={uncertaintyMeasurementPct} step="0.1" min="0" /><span>%</span></div></div>
		<div class="assumption-row"><label for="financial-uncertainty-model">Model Uncertainty</label><div class="input-unit"><input id="financial-uncertainty-model" type="number" bind:value={uncertaintyModelPct} step="0.1" min="0" /><span>%</span></div></div>
		<div class="assumption-row"><label for="financial-uncertainty-soiling">Soiling Uncertainty</label><div class="input-unit"><input id="financial-uncertainty-soiling" type="number" bind:value={uncertaintySoilingPct} step="0.1" min="0" /><span>%</span></div></div>
		<div class="assumption-row"><label for="financial-uncertainty-degradation">Degradation Uncertainty</label><div class="input-unit"><input id="financial-uncertainty-degradation" type="number" bind:value={uncertaintyDegradationPct} step="0.1" min="0" /><span>%</span></div></div>
	</div>

	<div class="divider"></div>

	<div class="section results">
		<h5>Key Metrics</h5>
		<div class="metric-grid">
			<div class="metric" class:positive={simplePayback > 0 && simplePayback < 8} class:warning={simplePayback >= 8 && simplePayback < 12}><span class="metric-value">{simplePayback > 0 ? `${simplePayback.toFixed(1)} yr` : '—'}</span><span class="metric-label">Simple Payback</span></div>
			<div class="metric" class:positive={roi25Year > 100} class:warning={roi25Year > 0 && roi25Year <= 100} class:negative={roi25Year <= 0}><span class="metric-value">{roi25Year !== 0 ? `${roi25Year.toFixed(0)}%` : '—'}</span><span class="metric-label">25-Year ROI</span></div>
			<div class="metric" class:positive={!!backendMetrics && backendMetrics.npv_usd > 0} class:negative={!!backendMetrics && backendMetrics.npv_usd < 0}><span class="metric-value">{backendMetrics ? `$${(backendMetrics.npv_usd / 1000000).toFixed(2)}M` : '—'}</span><span class="metric-label">Backend NPV</span></div>
			<div class="metric" class:positive={!!backendMetrics && backendMetrics.irr_percent > 10} class:warning={!!backendMetrics && backendMetrics.irr_percent > 0 && backendMetrics.irr_percent <= 10}><span class="metric-value">{backendMetrics ? `${backendMetrics.irr_percent.toFixed(2)}%` : '—'}</span><span class="metric-label">Backend IRR</span></div>
			<div class="metric"><span class="metric-value">{backendMetrics ? backendMetrics.pi_coeff.toFixed(2) : '—'}</span><span class="metric-label">Profitability Index</span></div>
			<div class="metric"><span class="metric-value">{backendMetrics ? `${backendMetrics.crop_percent.toFixed(2)}%` : '—'}</span><span class="metric-label">CROP</span></div>
			<div class="metric"><span class="metric-value">{climateMetrics ? `${climateMetrics.soiling_factor_change.toFixed(2)}%` : '—'}</span><span class="metric-label">Soiling Factor Change</span></div>
			<div class="metric"><span class="metric-value">{climateMetrics ? `${climateMetrics.module_temperature_increase.toFixed(2)}°C` : '—'}</span><span class="metric-label">Module Temp Increase</span></div>
			<div class="metric"><span class="metric-value">{climateMetrics ? `${climateMetrics.efficiency_factor_change.toFixed(2)}%` : '—'}</span><span class="metric-label">Efficiency Factor Change</span></div>
			<div class="metric"><span class="metric-value">{climateMetrics ? `${climateMetrics.availability_impact_percent.toFixed(2)}%` : '—'}</span><span class="metric-label">Availability Impact</span></div>
			<div class="metric"><span class="metric-value">{shadingMetrics ? `${shadingMetrics.annual_shading_loss_percent.toFixed(2)}%` : '—'}</span><span class="metric-label">Inter-row Shading Loss</span></div>
			<div class="metric"><span class="metric-value">{shadingMetrics ? shadingMetrics.optimal_gcr.toFixed(2) : '—'}</span><span class="metric-label">Optimal GCR</span></div>
			<div class="metric"><span class="metric-value">{uncertaintyMetrics ? `${uncertaintyMetrics.combined_uncertainty_pct.toFixed(2)}%` : '—'}</span><span class="metric-label">Combined Yield Uncertainty</span></div>
			<div class="metric"><span class="metric-value">{uncertaintyMetrics ? `${(uncertaintyMetrics.p90_kwh / 1000).toFixed(0)} MWh` : '—'}</span><span class="metric-label">P90 Annual Yield</span></div>
			<div class="metric"><span class="metric-value">{uncertaintyMetrics ? `${(uncertaintyMetrics.p99_kwh / 1000).toFixed(0)} MWh` : '—'}</span><span class="metric-label">P99 Annual Yield</span></div>
		</div>
	</div>

	<div class="divider"></div>

	<div class="section results">
		<h5>Scenario Comparison</h5>
		{#if scenarioResults.length === 0}
			<div class="metric">Run backend analytics to generate scenario comparison.</div>
		{:else}
			<table class="scenario-table">
				<thead>
					<tr>
						<th>Scenario</th>
						<th>NPV (M)</th>
						<th>IRR %</th>
						<th>PI</th>
						<th>Payback (yr)</th>
						<th>Delta Payback</th>
						<th>Delta NPV (M)</th>
						<th>Delta IRR %</th>
						<th>ROI %</th>
					</tr>
				</thead>
				<tbody>
					{#each scenarioResults as scenario}
						<tr>
							<td>{scenario.name}</td>
							<td>{(scenario.metrics.npv_usd / 1000000).toFixed(2)}</td>
							<td>{scenario.metrics.irr_percent.toFixed(2)}</td>
							<td>{scenario.metrics.pi_coeff.toFixed(2)}</td>
							<td>{scenario.simple_payback_years > 0 ? scenario.simple_payback_years.toFixed(1) : '—'}</td>
							<td>{baseScenario && scenario.simple_payback_years > 0 ? `${(scenario.simple_payback_years - baseScenario.simple_payback_years).toFixed(1)}` : '—'}</td>
							<td>{baseScenario ? `${((scenario.metrics.npv_usd - baseScenario.metrics.npv_usd) / 1000000).toFixed(2)}` : '—'}</td>
							<td>{baseScenario ? `${(scenario.metrics.irr_percent - baseScenario.metrics.irr_percent).toFixed(2)}` : '—'}</td>
							<td>{scenario.roi_percent.toFixed(1)}</td>
						</tr>
					{/each}
				</tbody>
			</table>
		{/if}
	</div>

	{#if scenarioVersions.length > 0}
		<div class="divider"></div>
		<div class="section">
			<h5>Version History</h5>
			<div class="version-row">
				<select class="version-select" bind:value={selectedVersionIdx}>
					<option value={null}>— select a snapshot —</option>
					{#each scenarioVersions as version, i}
						<option value={i}>{new Date(version.saved_at_rfc3339).toLocaleString()}</option>
					{/each}
				</select>
				<button
					class="btn-secondary"
					on:click={restoreVersion}
					disabled={selectedVersionIdx === null}
				>Restore</button>
			</div>
		</div>
	{/if}
</div>

<style>
	.finance-panel {
		display: flex;
		flex-direction: column;
		gap: 12px;
	}

	h4 {
		margin: 0;
		font-size: 14px;
		font-weight: 600;
		color: #e2e8f0;
	}

	h5 {
		margin: 0 0 8px 0;
		font-size: 12px;
		font-weight: 600;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.section {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	.divider {
		height: 1px;
		background: rgba(255, 255, 255, 0.1);
		margin: 4px 0;
	}

	.error {
		padding: 6px 8px;
		border-radius: 4px;
		background: rgba(239, 68, 68, 0.15);
		border: 1px solid rgba(239, 68, 68, 0.3);
		color: #fca5a5;
		font-size: 11px;
	}

	.status {
		padding: 6px 8px;
		border-radius: 4px;
		background: rgba(34, 197, 94, 0.12);
		border: 1px solid rgba(34, 197, 94, 0.35);
		color: #86efac;
		font-size: 11px;
	}

	.button-row {
		display: flex;
		gap: 8px;
		flex-wrap: wrap;
	}

	.button-row.compact {
		margin-bottom: 4px;
	}

	.btn-secondary {
		padding: 6px 8px;
		border: 1px solid rgba(255, 255, 255, 0.2);
		border-radius: 4px;
		background: rgba(15, 23, 42, 0.7);
		color: #dbeafe;
		font-size: 11px;
		cursor: pointer;
	}

	.btn-secondary:disabled {
		opacity: 0.6;
		cursor: not-allowed;
	}

	.file-btn {
		position: relative;
		overflow: hidden;
		display: inline-flex;
		align-items: center;
	}

	.file-btn input {
		position: absolute;
		opacity: 0;
		inset: 0;
		cursor: pointer;
	}

	.cost-item {
		display: flex;
		align-items: center;
		gap: 6px;
		font-size: 12px;
	}

	.cost-label {
		width: 70px;
		color: #94a3b8;
		flex-shrink: 0;
	}

	.cost-input {
		display: flex;
		align-items: center;
		gap: 4px;
		flex: 1;
	}

	.cost-input input,
	.assumption-row input {
		width: 70px;
		padding: 3px 6px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 3px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 11px;
		font-family: inherit;
		text-align: right;
	}

	.unit {
		font-size: 10px;
		color: #64748b;
		white-space: nowrap;
	}

	.cost-total {
		width: 50px;
		text-align: right;
		color: #e2e8f0;
		font-weight: 500;
		font-size: 11px;
	}

	.cost-total-row {
		display: flex;
		justify-content: space-between;
		padding-top: 6px;
		border-top: 1px solid rgba(255, 255, 255, 0.08);
		font-size: 13px;
		font-weight: 600;
		color: #e2e8f0;
	}

	.cost-total-row.sub {
		border: none;
		padding: 0;
		font-size: 11px;
		font-weight: 500;
		color: #94a3b8;
	}

	.total-value {
		color: #f59e0b;
	}

	.assumption-row {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 8px;
		font-size: 12px;
	}

	.assumption-row label {
		color: #94a3b8;
	}

	.input-unit {
		display: flex;
		align-items: center;
		gap: 4px;
	}

	.input-unit span {
		font-size: 10px;
		color: #64748b;
	}

	.btn-run {
		padding: 8px;
		border: none;
		border-radius: 6px;
		background: linear-gradient(135deg, #f59e0b, #d97706);
		color: #1a1a2e;
		font-size: 13px;
		font-weight: 700;
		cursor: pointer;
	}

	.btn-run:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}

	.metric-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 8px;
	}

	.metric {
		display: flex;
		flex-direction: column;
		gap: 2px;
		padding: 8px;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.08);
	}

	.metric.positive {
		border-color: rgba(34, 197, 94, 0.3);
		background: rgba(34, 197, 94, 0.05);
	}

	.metric.positive .metric-value {
		color: #22c55e;
	}

	.metric.warning {
		border-color: rgba(245, 158, 11, 0.3);
		background: rgba(245, 158, 11, 0.05);
	}

	.metric.warning .metric-value {
		color: #f59e0b;
	}

	.metric.negative {
		border-color: rgba(239, 68, 68, 0.3);
		background: rgba(239, 68, 68, 0.05);
	}

	.metric.negative .metric-value {
		color: #ef4444;
	}

	.metric-value {
		font-size: 16px;
		font-weight: 700;
		color: #e2e8f0;
	}

	.metric-label {
		font-size: 10px;
		color: #94a3b8;
	}

	.scenario-table {
		width: 100%;
		border-collapse: collapse;
		font-size: 11px;
	}

	.scenario-input-table {
		width: 100%;
		border-collapse: collapse;
		font-size: 11px;
	}

	.scenario-input-table th,
	.scenario-input-table td {
		padding: 6px;
		text-align: right;
		border-bottom: 1px solid rgba(255, 255, 255, 0.08);
		color: #cbd5e1;
	}

	.scenario-input-table th:first-child,
	.scenario-input-table td:first-child {
		text-align: left;
		color: #e2e8f0;
	}

	.scenario-input-table thead th {
		color: #94a3b8;
		font-weight: 600;
	}

	.scenario-input-table input {
		width: 68px;
		padding: 3px 6px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 3px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 11px;
		font-family: inherit;
		text-align: right;
	}

	.scenario-table th,
	.scenario-table td {
		padding: 6px;
		text-align: right;
		border-bottom: 1px solid rgba(255, 255, 255, 0.08);
		color: #cbd5e1;
	}

	.scenario-table th:first-child,
	.scenario-table td:first-child {
		text-align: left;
		color: #e2e8f0;
	}

	.scenario-table thead th {
		color: #94a3b8;
		font-weight: 600;
	}

	.version-row {
		display: flex;
		align-items: center;
		gap: 8px;
	}

	.version-select {
		flex: 1;
		padding: 5px 6px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 4px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 11px;
	}
</style>
