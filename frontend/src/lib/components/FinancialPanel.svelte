<script lang="ts">
	import { createEventDispatcher } from 'svelte';
	import { activeLayout, activeProject } from '$lib/core/stores';

	const dispatch = createEventDispatcher();

	let panelCost = 0.25; // $/W
	let inverterCostPerW = 0.05;
	let bosCostPerW = 0.15; // Balance of System
	let installCostPerW = 0.10;
	let landCostPerAcre = 5000;
	let acres = 0;
	let degradationRate = 0.5; // %/year
	let discountRate = 6; // %
	let electricityPrice = 0.06; // $/kWh
	let escalationRate = 2; // %/year
	let projectLife = 25; // years
	let annualYield = 0; // kWh - from simulation

	$: capacityKw = $activeLayout?.total_capacity_kw ?? 0;
	$: capacityW = capacityKw * 1000;
	$: totalPanels = $activeLayout?.total_panels ?? 0;

	// Cost calculations
	$: panelTotal = capacityW * panelCost;
	$: inverterTotal = capacityW * inverterCostPerW;
	$: bosTotal = capacityW * bosCostPerW;
	$: installTotal = capacityW * installCostPerW;
	$: landTotal = acres * landCostPerAcre;
	$: totalCapex = panelTotal + inverterTotal + bosTotal + installTotal + landTotal;
	$: costPerWatt = capacityW > 0 ? totalCapex / capacityW : 0;

	// LCOE calculation
	$: {
		if (annualYield > 0 && capacityW > 0) {
			let totalDiscountedEnergy = 0;
			let totalDiscountedCost = totalCapex;
			const annualOM = capacityW * 0.01; // $10/kW/year O&M

			for (let year = 1; year <= projectLife; year++) {
				const degradedYield = annualYield * Math.pow(1 - degradationRate / 100, year);
				const discountFactor = Math.pow(1 + discountRate / 100, year);
				totalDiscountedEnergy += degradedYield / discountFactor;
				totalDiscountedCost += annualOM / discountFactor;
			}
			lcoe = totalDiscountedEnergy > 0 ? totalDiscountedCost / totalDiscountedEnergy : 0;
		} else {
			lcoe = 0;
		}
	}

	let lcoe = 0;

	// ROI / Payback
	$: annualRevenue = annualYield * electricityPrice;
	$: annualOM = capacityW * 0.01;
	$: netAnnualCashflow = annualRevenue - annualOM;
	$: simplePayback = netAnnualCashflow > 0 ? totalCapex / netAnnualCashflow : 0;
	$: roi25Year = totalCapex > 0 ? ((netAnnualCashflow * projectLife - totalCapex) / totalCapex) * 100 : 0;

	// NPV
	$: {
		let npv = -totalCapex;
		for (let year = 1; year <= projectLife; year++) {
			const degradedYield = annualYield * Math.pow(1 - degradationRate / 100, year);
			const escalatedPrice = electricityPrice * Math.pow(1 + escalationRate / 100, year);
			const yearRevenue = degradedYield * escalatedPrice;
			const yearCashflow = yearRevenue - annualOM;
			npv += yearCashflow / Math.pow(1 + discountRate / 100, year);
		}
		npvResult = npv;
	}

	let npvResult = 0;
</script>

<div class="finance-panel">
	<h4>Financial Model</h4>

	<div class="section">
		<h5>Capital Costs</h5>
		<div class="cost-item">
			<span class="cost-label">Panels ({totalPanels})</span>
			<div class="cost-input">
				<input type="number" bind:value={panelCost} step="0.01" min="0" />
				<span class="unit">$/W</span>
			</div>
			<span class="cost-total">${(panelTotal / 1000).toFixed(0)}k</span>
		</div>
		<div class="cost-item">
			<span class="cost-label">Inverters</span>
			<div class="cost-input">
				<input type="number" bind:value={inverterCostPerW} step="0.01" min="0" />
				<span class="unit">$/W</span>
			</div>
			<span class="cost-total">${(inverterTotal / 1000).toFixed(0)}k</span>
		</div>
		<div class="cost-item">
			<span class="cost-label">BOS</span>
			<div class="cost-input">
				<input type="number" bind:value={bosCostPerW} step="0.01" min="0" />
				<span class="unit">$/W</span>
			</div>
			<span class="cost-total">${(bosTotal / 1000).toFixed(0)}k</span>
		</div>
		<div class="cost-item">
			<span class="cost-label">Install</span>
			<div class="cost-input">
				<input type="number" bind:value={installCostPerW} step="0.01" min="0" />
				<span class="unit">$/W</span>
			</div>
			<span class="cost-total">${(installTotal / 1000).toFixed(0)}k</span>
		</div>
		<div class="cost-item">
			<span class="cost-label">Land</span>
			<div class="cost-input">
				<input type="number" bind:value={acres} step="1" min="0" />
				<span class="unit">acres</span>
			</div>
			<span class="cost-total">${(landTotal / 1000).toFixed(0)}k</span>
		</div>
		<div class="cost-total-row">
			<span>Total CAPEX</span>
			<span class="total-value">${(totalCapex / 1000000).toFixed(2)}M</span>
		</div>
		<div class="cost-total-row sub">
			<span>Cost per Watt</span>
			<span>${costPerWatt.toFixed(2)}/W</span>
		</div>
	</div>

	<div class="divider"></div>

	<div class="section">
		<h5>Revenue Assumptions</h5>
		<div class="assumption-row">
			<label>Annual Yield (kWh)</label>
			<input type="number" bind:value={annualYield} step="1000" />
		</div>
		<div class="assumption-row">
			<label>Electricity Price</label>
			<div class="input-unit">
				<input type="number" bind:value={electricityPrice} step="0.005" min="0" />
				<span>$/kWh</span>
			</div>
		</div>
		<div class="assumption-row">
			<label>Escalation</label>
			<div class="input-unit">
				<input type="number" bind:value={escalationRate} step="0.5" />
				<span>%/yr</span>
			</div>
		</div>
		<div class="assumption-row">
			<label>Degradation</label>
			<div class="input-unit">
				<input type="number" bind:value={degradationRate} step="0.1" min="0" />
				<span>%/yr</span>
			</div>
		</div>
		<div class="assumption-row">
			<label>Discount Rate</label>
			<div class="input-unit">
				<input type="number" bind:value={discountRate} step="0.5" min="0" />
				<span>%</span>
			</div>
		</div>
	</div>

	<div class="divider"></div>

	<div class="section results">
		<h5>Key Metrics</h5>
		<div class="metric-grid">
			<div class="metric" class:positive={lcoe > 0 && lcoe < 0.05} class:warning={lcoe >= 0.05 && lcoe < 0.08} class:negative={lcoe >= 0.08}>
				<span class="metric-value">{lcoe > 0 ? `$${lcoe.toFixed(3)}` : '—'}</span>
				<span class="metric-label">LCOE ($/kWh)</span>
			</div>
			<div class="metric" class:positive={simplePayback > 0 && simplePayback < 8} class:warning={simplePayback >= 8 && simplePayback < 12}>
				<span class="metric-value">{simplePayback > 0 ? `${simplePayback.toFixed(1)} yr` : '—'}</span>
				<span class="metric-label">Simple Payback</span>
			</div>
			<div class="metric" class:positive={roi25Year > 100} class:warning={roi25Year > 0 && roi25Year <= 100} class:negative={roi25Year <= 0}>
				<span class="metric-value">{roi25Year !== 0 ? `${roi25Year.toFixed(0)}%` : '—'}</span>
				<span class="metric-label">25-Year ROI</span>
			</div>
			<div class="metric" class:positive={npvResult > 0} class:negative={npvResult < 0}>
				<span class="metric-value">{npvResult !== 0 ? `$${(npvResult / 1000000).toFixed(2)}M` : '—'}</span>
				<span class="metric-label">NPV</span>
			</div>
		</div>
	</div>
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

	.cost-input input {
		width: 60px;
		padding: 3px 6px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 3px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 11px;
		font-family: inherit;
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

	.input-unit {
		display: flex;
		align-items: center;
		gap: 4px;
	}

	.input-unit span {
		font-size: 10px;
		color: #64748b;
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
</style>
