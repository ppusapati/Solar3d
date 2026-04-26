<script lang="ts">
	import { createEventDispatcher } from 'svelte';
	import { camera } from '$lib/core/stores';
	import { toast } from '$lib/core/stores/toast';
	import { structuredLog } from '$lib/core/error-handling';

	const dispatch = createEventDispatcher<{
		irradianceData: { ghi: number; dni: number; dhi: number; temperature: number };
	}>();

	let isLoading = false;
	let weatherData: WeatherSummary | null = null;
	let monthlyGhi: number[] = [];
	let dataSource: 'pvgis' | 'nsrdb' | 'manual' = 'pvgis';

	interface WeatherSummary {
		location: string;
		annualGhi: number;
		annualDni: number;
		annualDhi: number;
		avgTemp: number;
		peakSunHours: number;
		optimalTilt: number;
	}

	async function fetchWeatherData() {
		isLoading = true;
		const lat = $camera.latitude;
		const lon = $camera.longitude;

		try {
			if (dataSource === 'pvgis') {
				await fetchPvgis(lat, lon);
			} else {
				// Manual or NSRDB - use estimates
				estimateFromLocation(lat, lon);
			}
		} catch (err) {
			structuredLog('warn', 'weather.fetch_failed', { error: String(err), lat, lon, source: dataSource });
			toast.warning('Weather data unavailable — using location estimate');
			estimateFromLocation(lat, lon);
		} finally {
			isLoading = false;
		}
	}

	async function fetchPvgis(lat: number, lon: number) {
		try {
			const url = `https://re.jrc.ec.europa.eu/api/v5_2/PVcalc?lat=${lat}&lon=${lon}&peakpower=1&loss=14&outputformat=json`;
			const response = await fetch(url);
			if (!response.ok) throw new Error('PVGIS unavailable');
			const data = await response.json();

			const monthly = data.outputs?.monthly?.fixed || [];
			monthlyGhi = monthly.map((m: any) => m.H_m || 0);

			const totals = data.outputs?.totals?.fixed || {};
			weatherData = {
				location: `${lat.toFixed(2)}, ${lon.toFixed(2)}`,
				annualGhi: totals.H_y || 0,
				annualDni: 0,
				annualDhi: 0,
				avgTemp: monthly.reduce((sum: number, m: any) => sum + (m.T2m || 0), 0) / Math.max(monthly.length, 1),
				peakSunHours: (totals.H_y || 0) / 365,
				optimalTilt: data.inputs?.mounting_system?.fixed?.slope?.value || lat * 0.76
			};
		} catch {
			estimateFromLocation(lat, lon);
		}
	}

	function estimateFromLocation(lat: number, lon: number) {
		// Simplified irradiance estimation based on latitude
		const absLat = Math.abs(lat);
		const baseGhi = 2200 - absLat * 25; // rough kWh/m2/year
		const seasonalFactor = absLat < 23.5 ? 0.95 : absLat < 40 ? 0.85 : 0.70;

		monthlyGhi = Array.from({ length: 12 }, (_, i) => {
			const monthFactor = lat >= 0
				? 1 + 0.3 * Math.cos((i - 5) * Math.PI / 6) // NH peak in June
				: 1 + 0.3 * Math.cos((i - 11) * Math.PI / 6); // SH peak in Dec
			return (baseGhi / 12) * monthFactor;
		});

		weatherData = {
			location: `${lat.toFixed(2)}, ${lon.toFixed(2)}`,
			annualGhi: baseGhi * seasonalFactor,
			annualDni: baseGhi * seasonalFactor * 0.65,
			annualDhi: baseGhi * seasonalFactor * 0.35,
			avgTemp: 30 - absLat * 0.5,
			peakSunHours: (baseGhi * seasonalFactor) / 365,
			optimalTilt: absLat * 0.76
		};
	}

	const monthLabels = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
</script>

<div class="weather-panel">
	<h5>Solar Resource</h5>

	<div class="source-row">
		<select bind:value={dataSource}>
			<option value="pvgis">PVGIS (EU)</option>
			<option value="nsrdb">NSRDB (US)</option>
			<option value="manual">Estimated</option>
		</select>
		<button class="btn-fetch" on:click={fetchWeatherData} disabled={isLoading}>
			{isLoading ? '...' : 'Fetch'}
		</button>
	</div>

	{#if weatherData}
		<div class="stat-row">
			<div class="stat">
				<span class="stat-value">{weatherData.annualGhi.toFixed(0)}</span>
				<span class="stat-label">GHI kWh/m2/yr</span>
			</div>
			<div class="stat">
				<span class="stat-value">{weatherData.peakSunHours.toFixed(1)}</span>
				<span class="stat-label">Peak Sun Hours</span>
			</div>
		</div>

		<div class="stat-row">
			<div class="stat">
				<span class="stat-value">{weatherData.avgTemp.toFixed(1)}°C</span>
				<span class="stat-label">Avg Temperature</span>
			</div>
			<div class="stat">
				<span class="stat-value">{weatherData.optimalTilt.toFixed(0)}°</span>
				<span class="stat-label">Optimal Tilt</span>
			</div>
		</div>

		<div class="chart">
			<div class="chart-title">Monthly GHI (kWh/m2)</div>
			<div class="bar-chart">
				{#each monthlyGhi as val, i}
					{@const maxVal = Math.max(...monthlyGhi, 1)}
					<div class="bar-col">
						<div class="bar" style="height: {(val / maxVal) * 60}px">
							<span class="bar-value">{val.toFixed(0)}</span>
						</div>
						<span class="bar-label">{monthLabels[i]}</span>
					</div>
				{/each}
			</div>
		</div>
	{:else}
		<p class="empty">Click "Fetch" to load solar resource data for the current map location.</p>
	{/if}
</div>

<style>
	.weather-panel {
		display: flex;
		flex-direction: column;
		gap: 10px;
	}

	h5 {
		margin: 0;
		font-size: 12px;
		font-weight: 600;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.source-row {
		display: flex;
		gap: 6px;
	}

	.source-row select {
		flex: 1;
		padding: 6px 8px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 4px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 12px;
		font-family: inherit;
	}

	.btn-fetch {
		padding: 6px 12px;
		border: none;
		border-radius: 4px;
		background: linear-gradient(135deg, #f59e0b, #d97706);
		color: #1a1a2e;
		font-size: 12px;
		font-weight: 600;
		cursor: pointer;
	}

	.btn-fetch:disabled {
		opacity: 0.5;
	}

	.stat-row {
		display: flex;
		gap: 6px;
	}

	.stat {
		flex: 1;
		display: flex;
		flex-direction: column;
		gap: 2px;
		padding: 6px 8px;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.08);
	}

	.stat-value {
		font-size: 14px;
		font-weight: 700;
		color: #f59e0b;
	}

	.stat-label {
		font-size: 9px;
		color: #94a3b8;
	}

	.chart {
		display: flex;
		flex-direction: column;
		gap: 4px;
	}

	.chart-title {
		font-size: 10px;
		color: #94a3b8;
		font-weight: 500;
	}

	.bar-chart {
		display: flex;
		align-items: flex-end;
		gap: 2px;
		height: 80px;
		padding-bottom: 16px;
		position: relative;
	}

	.bar-col {
		flex: 1;
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: flex-end;
	}

	.bar {
		width: 100%;
		min-height: 2px;
		background: linear-gradient(to top, #d97706, #f59e0b);
		border-radius: 2px 2px 0 0;
		position: relative;
		transition: height 0.3s;
	}

	.bar-value {
		position: absolute;
		top: -14px;
		left: 50%;
		transform: translateX(-50%);
		font-size: 8px;
		color: #94a3b8;
		white-space: nowrap;
	}

	.bar-label {
		font-size: 9px;
		color: #64748b;
		margin-top: 4px;
	}

	.empty {
		color: #64748b;
		font-size: 12px;
		text-align: center;
		padding: 16px 0;
	}
</style>
