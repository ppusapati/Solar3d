<script lang="ts">
	import { camera, activeLayout, activeTool, activeView } from '$lib/core/stores';
	import { writable } from 'svelte/store';

	/** Store for live cursor geo-coordinates, updated by map mouse-move handlers. */
	export const cursorPosition = writable<{ longitude: number; latitude: number }>({
		longitude: 0, latitude: 0
	});

	let cursorLon = 0;
	let cursorLat = 0;

	// Use live cursor when available, otherwise fall back to camera center
	$: {
		const pos = $cursorPosition;
		if (pos.longitude !== 0 || pos.latitude !== 0) {
			cursorLon = pos.longitude;
			cursorLat = pos.latitude;
		} else {
			cursorLon = $camera.longitude;
			cursorLat = $camera.latitude;
		}
	}

	function formatCoord(value: number, isLat: boolean): string {
		const dir = isLat
			? value >= 0 ? 'N' : 'S'
			: value >= 0 ? 'E' : 'W';
		const abs = Math.abs(value);
		const deg = Math.floor(abs);
		const min = Math.floor((abs - deg) * 60);
		const sec = ((abs - deg - min / 60) * 3600).toFixed(1);
		return `${deg}° ${min}' ${sec}" ${dir}`;
	}
</script>

<div class="statusbar">
	<div class="status-section coords">
		<span class="status-label">Lat</span>
		<span class="status-value">{formatCoord($camera.latitude, true)}</span>
		<span class="status-sep">|</span>
		<span class="status-label">Lon</span>
		<span class="status-value">{formatCoord($camera.longitude, false)}</span>
	</div>

	<div class="status-section">
		<span class="status-label">Alt</span>
		<span class="status-value">{($camera.height / 1000).toFixed(1)} km</span>
	</div>

	<div class="status-section">
		<span class="status-label">Heading</span>
		<span class="status-value">{$camera.heading.toFixed(0)}°</span>
	</div>

	{#if $activeLayout}
		<div class="status-sep-v"></div>
		<div class="status-section">
			<span class="status-label">Panels</span>
			<span class="status-value highlight">{$activeLayout.total_panels.toLocaleString()}</span>
		</div>
		<div class="status-section">
			<span class="status-label">Capacity</span>
			<span class="status-value highlight">{$activeLayout.total_capacity_kw.toFixed(0)} kW</span>
		</div>
	{/if}

	<div class="status-right">
		<span class="tool-indicator">{$activeTool}</span>
		<span class="view-indicator">{$activeView}</span>
	</div>
</div>

<style>
	.statusbar {
		display: flex;
		align-items: center;
		height: 28px;
		padding: 0 12px;
		background: rgba(22, 33, 62, 0.98);
		border-top: 1px solid rgba(255, 255, 255, 0.08);
		gap: 16px;
		font-size: 11px;
		z-index: 100;
		flex-shrink: 0;
	}

	.status-section {
		display: flex;
		align-items: center;
		gap: 4px;
	}

	.status-label {
		color: #64748b;
		font-weight: 500;
	}

	.status-value {
		color: #94a3b8;
		font-family: 'SF Mono', 'Fira Code', monospace;
		font-size: 10px;
	}

	.status-value.highlight {
		color: #f59e0b;
		font-weight: 600;
	}

	.status-sep {
		color: #334155;
		margin: 0 2px;
	}

	.status-sep-v {
		width: 1px;
		height: 14px;
		background: rgba(255, 255, 255, 0.1);
	}

	.status-right {
		margin-left: auto;
		display: flex;
		gap: 8px;
	}

	.tool-indicator {
		padding: 1px 6px;
		border-radius: 3px;
		background: rgba(59, 130, 246, 0.15);
		color: #3b82f6;
		font-size: 10px;
		font-weight: 500;
		text-transform: capitalize;
	}

	.view-indicator {
		padding: 1px 6px;
		border-radius: 3px;
		background: rgba(245, 158, 11, 0.15);
		color: #f59e0b;
		font-size: 10px;
		font-weight: 500;
		text-transform: capitalize;
	}
</style>
