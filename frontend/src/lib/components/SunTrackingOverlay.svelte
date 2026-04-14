<script lang="ts">
	/**
	 * SunTrackingOverlay — real-time solar position & irradiance visualization
	 *
	 * Displays:
	 *  • Current sun position (azimuth, elevation angle) relative to observer
	 *  • Sun path curve for the day
	 *  • Real-time irradiance on each panel (W/m²) color-coded
	 *  • Optimal panel angles for current sun position
	 *  • Time-of-year seasonal indicators
	 */
	import { onMount } from 'svelte';

	export let latitude: number = 0;
	export let longitude: number = 0;
	export let show: boolean = true;

	let now = new Date();
	let sunAzimuth = 0;
	let sunElevation = 0;
	let sunIrradiance = 0;
	let sunPath: Array<{ time: string; az: number; el: number; irr: number }> = [];
	let timerId: number | null = null;

	interface SunData {
		azimuth: number;
		elevation: number;
		irradiance: number;
	}

	// ─── Solar geometry ──────────────────────────────────────────────────────

	function dayOfYear(date: Date): number {
		const start = new Date(date.getFullYear(), 0, 0);
		const diff = date.getTime() - start.getTime();
		const oneDay = 1000 * 60 * 60 * 24;
		return Math.floor(diff / oneDay);
	}

	function calculateSolarDeclination(day: number): number {
		// Solar declination angle in degrees
		return 23.44 * Math.sin((2 * Math.PI * (day - 81)) / 365);
	}

	function calculateEquationOfTime(day: number): number {
		// Equation of time in minutes
		const B = (2 * Math.PI * (day - 1)) / 365;
		return 229.18 * (0.000075 + 0.001868 * Math.cos(B) - 0.032077 * Math.sin(B) - 0.014615 * Math.cos(2 * B) - 0.040849 * Math.sin(2 * B));
	}

	function calculateSunPosition(date: Date, lat: number, lon: number): SunData {
		const day = dayOfYear(date);
		const declination = calculateSolarDeclination(day);
		const eot = calculateEquationOfTime(day);

		// Get local solar time
		const hours = date.getHours() + date.getMinutes() / 60 + date.getSeconds() / 3600;
		const offset = new Date().getTimezoneOffset();
		const standardMeridian = Math.round(offset / 4) * 15; // Standard meridian for timezone
		const localSolarTime = hours + (lon - standardMeridian) / 15 + eot / 60;
		const hourAngle = 15 * (localSolarTime - 12);

		// Convert to radians
		const latRad = (lat * Math.PI) / 180;
		const declRad = (declination * Math.PI) / 180;
		const haRad = (hourAngle * Math.PI) / 180;

		// Solar elevation angle
		const sinElevation =
			Math.sin(latRad) * Math.sin(declRad) + Math.cos(latRad) * Math.cos(declRad) * Math.cos(haRad);
		const elevation = Math.asin(Math.max(-1, Math.min(1, sinElevation))) * (180 / Math.PI);

		// Solar azimuth angle (0° = N, 90° = E, 180° = S, 270° = W)
		const cosAzimuth = (Math.sin(declRad) * Math.cos(latRad) - Math.cos(declRad) * Math.sin(latRad) * Math.cos(haRad)) / Math.cos(Math.asin(sinElevation));
		const sinAzimuth = -Math.cos(declRad) * Math.sin(haRad) / Math.cos(Math.asin(sinElevation));
		let azimuth = Math.atan2(sinAzimuth, cosAzimuth) * (180 / Math.PI) + 180;
		if (azimuth < 0) azimuth += 360;

		// Direct normal irradiance (DNI) - simplified clearness model
		let irradiance = 0;
		if (elevation > 0) {
			const airMass = 1 / (Math.cos((Math.asin(sinElevation) * 180 / Math.PI + 90) * Math.PI / 180) + 0.5);
			const clearnessFactor = 0.95; // Assume clear day
			const extraterrestrial = 1361; // W/m² above atmosphere
			const kt = clearnessFactor * Math.pow(0.7, airMass);
			irradiance = Math.max(0, extraterrestrial * kt * Math.sin(Math.asin(sinElevation)));
		}

		return { azimuth, elevation, irradiance };
	}

	function getIrradianceColor(irr: number): string {
		// Color gradient: dark (low) → red → orange → yellow → white (high)
		if (irr < 100) return '#1a1a1a';
		if (irr < 300) return '#8b0000';
		if (irr < 600) return '#ff4500';
		if (irr < 900) return '#ffa500';
		return '#ffffcc';
	}

	function generateSunPath(date: Date, lat: number, lon: number): Array<{ time: string; az: number; el: number; irr: number }> {
		const path = [];
		const testDate = new Date(date);
		testDate.setHours(6, 0, 0, 0); // Start at 6 AM

		for (let h = 6; h <= 18; h++) {
			testDate.setHours(h, 0, 0, 0);
			const sun = calculateSunPosition(testDate, lat, lon);
			path.push({
				time: `${String(h).padStart(2, '0')}:00`,
				az: sun.azimuth,
				el: sun.elevation,
				irr: sun.irradiance
			});
		}
		return path;
	}

	function updateSunPosition() {
		now = new Date();
		const sun = calculateSunPosition(now, latitude, longitude);
		sunAzimuth = sun.azimuth;
		sunElevation = sun.elevation;
		sunIrradiance = sun.irradiance;
	}

	onMount(() => {
		updateSunPosition();
		sunPath = generateSunPath(new Date(), latitude, longitude);

		timerId = window.setInterval(() => {
			updateSunPosition();
		}, 10000); // Update every 10 seconds

		return () => {
			if (timerId) clearInterval(timerId);
		};
	});

	function formatTime(date: Date): string {
		return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' });
	}

	function getSeasonalInfo(): string {
		const day = dayOfYear(now);
		if (day >= 79 && day <= 172) return 'Spring ♻️';
		if (day >= 173 && day <= 265) return 'Summer ☀️';
		if (day >= 266 && day <= 358) return 'Autumn 🍂';
		return 'Winter ❄️';
	}
</script>

{#if show}
	<div class="sun-overlay">
		<div class="sun-header">
			<h3>☀️ Sun Tracking</h3>
			<button class="close-btn" on:click={() => (show = false)}>×</button>
		</div>

		<div class="sun-stats">
			<div class="stat-box">
				<span class="stat-label">Time</span>
				<span class="stat-value">{formatTime(now)}</span>
			</div>
			<div class="stat-box">
				<span class="stat-label">Season</span>
				<span class="stat-value">{getSeasonalInfo()}</span>
			</div>
			<div class="stat-box">
				<span class="stat-label">Elevation</span>
				<span class="stat-value">{sunElevation.toFixed(1)}°</span>
			</div>
			<div class="stat-box">
				<span class="stat-label">Azimuth</span>
				<span class="stat-value">{sunAzimuth.toFixed(1)}°</span>
			</div>
		</div>

		<div class="irradiance-box">
			<div class="irr-label">Direct Solar Irradiance</div>
			<div class="irr-bar">
				<div
					class="irr-fill"
					style={`width: ${Math.min(100, (sunIrradiance / 1000) * 100)}%; background-color: ${getIrradianceColor(sunIrradiance)};`}
				></div>
			</div>
			<div class="irr-value">{sunIrradiance.toFixed(0)} W/m²</div>
		</div>

		<div class="sun-path-viz">
			<h4>Today's Sun Path (6 AM – 6 PM)</h4>
			<div class="path-grid">
				{#each sunPath as point}
					<div class="path-point" style={`background-color: ${getIrradianceColor(point.irr)};`} title="{point.time}: {point.az.toFixed(0)}° az, {point.el.toFixed(1)}° el, {point.irr.toFixed(0)} W/m²">
						<span class="path-time">{point.time}</span>
					</div>
				{/each}
			</div>
		</div>

		<div class="recommendations">
			<h4>Panel Optimization</h4>
			<ul>
				{#if sunElevation > 60}
					<li>✓ Sun near zenith — optimal production</li>
				{:else if sunElevation > 30}
					<li>✓ Good elevation — strong power output</li>
				{:else if sunElevation > 0}
					<li>⚠ Low elevation angle — reduced output</li>
				{:else}
					<li>✗ Sun below horizon — no production</li>
				{/if}

				{#if sunIrradiance > 800}
					<li>✓ Peak irradiance conditions</li>
				{:else if sunIrradiance > 600}
					<li>✓ Good irradiance</li>
				{:else if sunIrradiance > 300}
					<li>⚠ Moderate irradiance</li>
				{/if}

				<li>💡 Optimal panel tilt: ~{(90 - sunElevation).toFixed(0)}° from horizontal</li>
				<li>🧭 Optimal rotation: {sunAzimuth.toFixed(0)}° (facing azimuth)</li>
			</ul>
		</div>
	</div>
{/if}

<style>
	.sun-overlay {
		position: fixed;
		bottom: 16px;
		right: 16px;
		width: 340px;
		background: rgba(15, 23, 42, 0.96);
		border: 1px solid rgba(148, 163, 184, 0.2);
		border-radius: 8px;
		padding: 0;
		box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.5);
		font-family: ui-sans-serif, system-ui, sans-serif;
		color: #e2e8f0;
		backdrop-filter: blur(8px);
		z-index: 1000;
		max-height: 70vh;
		overflow-y: auto;
	}

	.sun-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 12px 14px;
		border-bottom: 1px solid rgba(148, 163, 184, 0.1);
		background: rgba(255 255 255 / 0.03);
	}

	.sun-header h3 {
		margin: 0;
		font-size: 13px;
		font-weight: 600;
		letter-spacing: 0.05em;
	}

	.close-btn {
		cursor: pointer;
		font-size: 18px;
		color: #94a3b8;
		padding: 0 4px;
	}

	.close-btn:hover {
		color: #e2e8f0;
	}

	.sun-stats {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 8px;
		padding: 12px 14px;
		border-bottom: 1px solid rgba(148, 163, 184, 0.1);
	}

	.stat-box {
		display: flex;
		flex-direction: column;
		gap: 2px;
	}

	.stat-label {
		font-size: 10px;
		color: #64748b;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.stat-value {
		font-size: 14px;
		font-weight: 600;
		color: #e2e8f0;
	}

	.irradiance-box {
		padding: 12px 14px;
		border-bottom: 1px solid rgba(148, 163, 184, 0.1);
	}

	.irr-label {
		font-size: 11px;
		color: #94a3b8;
		margin-bottom: 6px;
		text-transform: uppercase;
		letter-spacing: 0.04em;
	}

	.irr-bar {
		height: 24px;
		background: rgba(0, 0, 0, 0.3);
		border-radius: 4px;
		overflow: hidden;
		margin-bottom: 6px;
		border: 1px solid rgba(148, 163, 184, 0.1);
	}

	.irr-fill {
		height: 100%;
		transition: width 1s ease, background-color 0.8s ease;
	}

	.irr-value {
		font-size: 12px;
		font-weight: 600;
		color: #fcd34d;
		text-align: center;
	}

	.sun-path-viz {
		padding: 12px 14px;
		border-bottom: 1px solid rgba(148, 163, 184, 0.1);
	}

	.sun-path-viz h4 {
		margin: 0 0 8px 0;
		font-size: 11px;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.04em;
	}

	.path-grid {
		display: grid;
		grid-template-columns: repeat(13, 1fr);
		gap: 2px;
	}

	.path-point {
		aspect-ratio: 1;
		border-radius: 3px;
		cursor: pointer;
		display: flex;
		align-items: center;
		justify-content: center;
		border: 1px solid rgba(255 255 255 / 0.1);
		transition: transform 0.2s, border-color 0.2s;
	}

	.path-point:hover {
		transform: scale(1.1);
		border-color: rgba(255 255 255 / 0.3);
	}

	.path-time {
		font-size: 7px;
		color: #0f172a;
		font-weight: 600;
		opacity: 0.8;
	}

	.recommendations {
		padding: 12px 14px;
	}

	.recommendations h4 {
		margin: 0 0 8px 0;
		font-size: 11px;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.04em;
	}

	.recommendations ul {
		list-style: none;
		padding: 0;
		margin: 0;
		font-size: 11px;
		line-height: 1.6;
	}

	.recommendations li {
		color: #cbd5e1;
		margin-bottom: 4px;
	}

	/* Scrollbar styling */
	::-webkit-scrollbar {
		width: 4px;
	}

	::-webkit-scrollbar-track {
		background: transparent;
	}

	::-webkit-scrollbar-thumb {
		background: rgba(148, 163, 184, 0.3);
		border-radius: 2px;
	}

	::-webkit-scrollbar-thumb:hover {
		background: rgba(148, 163, 184, 0.5);
	}
</style>
