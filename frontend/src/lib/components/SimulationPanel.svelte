<script lang="ts">
	import { createEventDispatcher } from 'svelte';
	import { activeLayout } from '$lib/core/stores';
	import { simulationApi, type Simulation, type SimulationResult } from '$lib/core/api';
	import SunTrackingOverlay from './SunTrackingOverlay.svelte';
	import ShadingAnalysisPanel from './ShadingAnalysisPanel.svelte';

	const dispatch = createEventDispatcher<{
		timeChange: string;
		toggleShadows: boolean;
	}>();

	let simName = 'Annual Yield';
	let simType = 'yield';
	let startDate = '2025-01-01';
	let endDate = '2025-12-31';
	let timeStep = 60;
	let latitude = 35.0;
	let longitude = -120.0;
	let includeTerrainShading = true;
	let includePanelShading = true;

	let isRunning = false;
	let result: SimulationResult | null = null;
	let simulations: Simulation[] = [];

	// Shadow time slider
	let shadowDate = new Date().toISOString().slice(0, 10);
	let shadowHour = 12;
	let showShadows = false;
	let showSunTracking = true;
	let showShadingAnalysis = false;

	$: shadowTimestamp = `${shadowDate}T${String(shadowHour).padStart(2, '0')}:00:00Z`;
	$: if (showShadows) dispatch('timeChange', shadowTimestamp);

	function toggleShadows() {
		showShadows = !showShadows;
		dispatch('toggleShadows', showShadows);
	}

	async function runSimulation() {
		const layout = $activeLayout;
		if (!layout) return;

		isRunning = true;
		result = null;

		try {
			const createRes = await simulationApi.create({
				project_id: layout.project_id,
				layout_id: layout.id,
				name: simName,
				simulation_type: simType,
				params: {
					start_time: `${startDate}T00:00:00Z`,
					end_time: `${endDate}T23:59:59Z`,
					time_step_minutes: timeStep,
					latitude,
					longitude,
					include_terrain_shading: includeTerrainShading,
					include_panel_shading: includePanelShading
				}
			});

			const runRes = await simulationApi.run(createRes.simulation.id);
			result = runRes.simulation.result;
		} catch (err) {
			console.error('Simulation failed:', err);
		} finally {
			isRunning = false;
		}
	}
</script>

<div class="sim-panel">
	<h4>Simulation</h4>

	<div class="section">
		<h5>Shadow Analysis</h5>
		<div class="shadow-controls">
			<button class="toggle-btn" class:active={showShadows} on:click={toggleShadows}>
				{showShadows ? 'Hide Shadows' : 'Show Shadows'}
			</button>

			{#if showShadows}
				<div class="form-group">
					<label for="shadow-date">Date</label>
					<input id="shadow-date" type="date" bind:value={shadowDate} />
				</div>
				<div class="form-group">
					<label for="shadow-hour">Time: {String(shadowHour).padStart(2, '0')}:00</label>
					<input id="shadow-hour" type="range" bind:value={shadowHour} min="5" max="20" step="1" />
				</div>
			{/if}
		</div>
	</div>

	<div class="divider"></div>

	<div class="section">
		<h5>Yield Simulation</h5>

		<div class="form-group">
			<label for="simulation-type">Type</label>
			<select id="simulation-type" bind:value={simType}>
				<option value="yield">Annual Yield</option>
				<option value="irradiance">Irradiance Analysis</option>
				<option value="shadow">Shadow Study</option>
			</select>
		</div>

		<div class="form-row">
			<div class="form-group">
				<label for="simulation-start">Start</label>
				<input id="simulation-start" type="date" bind:value={startDate} />
			</div>
			<div class="form-group">
				<label for="simulation-end">End</label>
				<input id="simulation-end" type="date" bind:value={endDate} />
			</div>
		</div>

		<div class="form-row">
			<div class="form-group">
				<label for="simulation-latitude">Latitude</label>
				<input id="simulation-latitude" type="number" bind:value={latitude} step="0.01" />
			</div>
			<div class="form-group">
				<label for="simulation-longitude">Longitude</label>
				<input id="simulation-longitude" type="number" bind:value={longitude} step="0.01" />
			</div>
		</div>

		<div class="checkbox-row">
			<label>
				<input type="checkbox" bind:checked={includeTerrainShading} />
				Terrain Shading
			</label>
			<label>
				<input type="checkbox" bind:checked={includePanelShading} />
				Panel Shading
			</label>
		</div>

		<button
			class="btn-run"
			on:click={runSimulation}
			disabled={isRunning || !$activeLayout}
		>
			{isRunning ? 'Running...' : 'Run Simulation'}
		</button>
	</div>

	{#if result}
		<div class="divider"></div>
		<div class="section results">
			<h5>Results</h5>
			<div class="result-grid">
				<div class="result-card">
					<span class="result-value">{result.annual_yield_kwh.toLocaleString()}</span>
					<span class="result-label">Annual Yield (kWh)</span>
				</div>
				<div class="result-card">
					<span class="result-value">{result.total_irradiance_kwh_m2.toFixed(1)}</span>
					<span class="result-label">Irradiance (kWh/m2)</span>
				</div>
				<div class="result-card">
					<span class="result-value">{(result.performance_ratio * 100).toFixed(1)}%</span>
					<span class="result-label">Performance Ratio</span>
				</div>
				<div class="result-card">
					<span class="result-value">{result.shading_loss_percent.toFixed(1)}%</span>
					<span class="result-label">Shading Loss</span>
				</div>
			</div>
		</div>
	{/if}

	<div class="divider"></div>

	<div class="section overlays">
		<h5>Visualization Overlays</h5>
		<div class="button-row">
			<button class="toggle-btn" class:active={showSunTracking} on:click={() => (showSunTracking = !showSunTracking)}>
				☀️ Sun Tracking
			</button>
			<button class="toggle-btn" class:active={showShadingAnalysis} on:click={() => (showShadingAnalysis = !showShadingAnalysis)}>
				🌑 Shading Analysis
			</button>
		</div>
	</div>
</div>

{#if showSunTracking}
	<SunTrackingOverlay
		latitude={latitude}
		longitude={longitude}
		show={showSunTracking}
	/>
{/if}

{#if showShadingAnalysis}
	<div class="analysis-panel-container">
		<ShadingAnalysisPanel
			latitude={latitude}
			longitude={longitude}
			visible={showShadingAnalysis}
		/>
	</div>
{/if}

<style>
	.sim-panel {
		display: flex;
		flex-direction: column;
		gap: 12px;
	}

	.analysis-panel-container {
		margin-top: 16px;
		padding: 16px 0;
		border-top: 1px solid rgba(148, 163, 184, 0.1);
	}

	.button-row {
		display: flex;
		gap: 8px;
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
		gap: 8px;
	}

	.divider {
		height: 1px;
		background: rgba(255, 255, 255, 0.1);
		margin: 4px 0;
	}

	.form-group {
		display: flex;
		flex-direction: column;
		gap: 4px;
	}

	.form-group label {
		font-size: 11px;
		color: #94a3b8;
	}

	.form-row {
		display: flex;
		gap: 8px;
	}

	.form-row .form-group {
		flex: 1;
	}

	input[type='date'],
	input[type='number'],
	select {
		width: 100%;
		padding: 6px 8px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 4px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 12px;
		font-family: inherit;
	}

	select {
		cursor: pointer;
	}

	input[type='range'] {
		width: 100%;
		accent-color: #f59e0b;
	}

	.checkbox-row {
		display: flex;
		gap: 12px;
	}

	.checkbox-row label {
		display: flex;
		align-items: center;
		gap: 4px;
		font-size: 12px;
		color: #e2e8f0;
		cursor: pointer;
	}

	.toggle-btn {
		padding: 6px 12px;
		border: 1px solid rgba(245, 158, 11, 0.3);
		border-radius: 4px;
		background: transparent;
		color: #f59e0b;
		font-size: 12px;
		cursor: pointer;
	}

	.toggle-btn.active {
		background: rgba(245, 158, 11, 0.15);
	}

	.shadow-controls {
		display: flex;
		flex-direction: column;
		gap: 8px;
	}

	.btn-run {
		padding: 8px;
		border: none;
		border-radius: 6px;
		background: linear-gradient(135deg, #3b82f6, #2563eb);
		color: white;
		font-size: 13px;
		font-weight: 600;
		cursor: pointer;
	}

	.btn-run:hover:not(:disabled) {
		filter: brightness(1.1);
	}

	.btn-run:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}

	.result-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 8px;
	}

	.result-card {
		display: flex;
		flex-direction: column;
		gap: 2px;
		padding: 8px;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.08);
	}

	.result-value {
		font-size: 16px;
		font-weight: 700;
		color: #f59e0b;
	}

	.result-label {
		font-size: 10px;
		color: #94a3b8;
	}
</style>
