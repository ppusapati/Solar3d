<script lang="ts">
	import { createEventDispatcher } from 'svelte';
	import { isGenerating } from '$lib/core/stores';
	import type { PanelArrayParams } from '$lib/core/api';

	export let fillAreaGeoJson: string = '';

	const dispatch = createEventDispatcher<{
		generate: PanelArrayParams;
		cancel: void;
	}>();

	let panelWidth = 2.278;
	let panelHeight = 1.134;
	let tiltAngle = 20;
	let azimuth = 180;
	let rowSpacing = 0;
	let columnSpacing = 0.02;

	// Auto-calculate row spacing based on tilt for no-shading
	$: if (rowSpacing === 0) {
		rowSpacing = parseFloat((panelHeight * Math.sin((tiltAngle * Math.PI) / 180) * 2.5).toFixed(2));
	}

	function handleGenerate() {
		if (!fillAreaGeoJson) return;

		dispatch('generate', {
			panel_width: panelWidth,
			panel_height: panelHeight,
			tilt_angle: tiltAngle,
			azimuth,
			row_spacing: rowSpacing,
			column_spacing: columnSpacing,
			fill_area_geojson: fillAreaGeoJson
		});
	}

	function handleCancel() {
		dispatch('cancel');
	}
</script>

<div class="panel-form">
	<h4>Generate Panel Array</h4>

	<div class="form-group">
		<label>Panel Size</label>
		<div class="input-row">
			<div class="input-field">
				<input type="number" bind:value={panelWidth} step="0.001" min="0.1" />
				<span class="unit">m W</span>
			</div>
			<span class="separator">x</span>
			<div class="input-field">
				<input type="number" bind:value={panelHeight} step="0.001" min="0.1" />
				<span class="unit">m H</span>
			</div>
		</div>
	</div>

	<div class="form-group">
		<label>Tilt Angle</label>
		<div class="input-field">
			<input type="range" bind:value={tiltAngle} min="0" max="60" step="1" />
			<span class="range-value">{tiltAngle}°</span>
		</div>
	</div>

	<div class="form-group">
		<label>Azimuth</label>
		<div class="input-field">
			<input type="range" bind:value={azimuth} min="0" max="360" step="1" />
			<span class="range-value">{azimuth}°</span>
		</div>
		<span class="hint">
			{azimuth === 180 ? 'South' : azimuth === 0 ? 'North' : azimuth === 90 ? 'East' : azimuth === 270 ? 'West' : `${azimuth}°`}
		</span>
	</div>

	<div class="form-group">
		<label>Row Spacing</label>
		<div class="input-field">
			<input type="number" bind:value={rowSpacing} step="0.1" min="0" />
			<span class="unit">m</span>
		</div>
	</div>

	<div class="form-group">
		<label>Column Spacing</label>
		<div class="input-field">
			<input type="number" bind:value={columnSpacing} step="0.01" min="0" />
			<span class="unit">m</span>
		</div>
	</div>

	{#if fillAreaGeoJson}
		<div class="area-indicator">
			<span class="dot"></span>
			Area selected
		</div>
	{:else}
		<div class="area-indicator warning">
			<span class="dot warning"></span>
			Draw an area on the map first
		</div>
	{/if}

	<div class="form-actions">
		<button class="btn-cancel" on:click={handleCancel}>Cancel</button>
		<button
			class="btn-generate"
			on:click={handleGenerate}
			disabled={!fillAreaGeoJson || $isGenerating}
		>
			{$isGenerating ? 'Generating...' : 'Generate Array'}
		</button>
	</div>
</div>

<style>
	.panel-form {
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

	.form-group {
		display: flex;
		flex-direction: column;
		gap: 4px;
	}

	.form-group label {
		font-size: 11px;
		font-weight: 500;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.input-row {
		display: flex;
		align-items: center;
		gap: 8px;
	}

	.separator {
		color: #64748b;
		font-size: 12px;
	}

	.input-field {
		display: flex;
		align-items: center;
		gap: 6px;
		flex: 1;
	}

	.input-field input[type='number'] {
		width: 100%;
		padding: 6px 8px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 4px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 13px;
		font-family: inherit;
	}

	.input-field input[type='range'] {
		flex: 1;
		accent-color: #f59e0b;
	}

	.unit {
		font-size: 11px;
		color: #64748b;
		white-space: nowrap;
	}

	.range-value {
		font-size: 13px;
		color: #f59e0b;
		font-weight: 600;
		min-width: 36px;
		text-align: right;
	}

	.hint {
		font-size: 11px;
		color: #64748b;
	}

	.area-indicator {
		display: flex;
		align-items: center;
		gap: 6px;
		padding: 8px;
		border-radius: 4px;
		background: rgba(34, 197, 94, 0.1);
		font-size: 12px;
		color: #22c55e;
	}

	.area-indicator.warning {
		background: rgba(245, 158, 11, 0.1);
		color: #f59e0b;
	}

	.dot {
		width: 6px;
		height: 6px;
		border-radius: 50%;
		background: #22c55e;
	}

	.dot.warning {
		background: #f59e0b;
	}

	.form-actions {
		display: flex;
		gap: 8px;
		margin-top: 4px;
	}

	.btn-cancel {
		flex: 1;
		padding: 8px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 6px;
		background: transparent;
		color: #94a3b8;
		font-size: 13px;
		cursor: pointer;
	}

	.btn-cancel:hover {
		background: rgba(255, 255, 255, 0.05);
	}

	.btn-generate {
		flex: 2;
		padding: 8px;
		border: none;
		border-radius: 6px;
		background: linear-gradient(135deg, #f59e0b, #d97706);
		color: #1a1a2e;
		font-size: 13px;
		font-weight: 600;
		cursor: pointer;
	}

	.btn-generate:hover:not(:disabled) {
		filter: brightness(1.1);
	}

	.btn-generate:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}
</style>
