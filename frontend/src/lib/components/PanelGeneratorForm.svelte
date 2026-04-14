<script lang="ts">
	import { onMount } from 'svelte';
	import { createEventDispatcher } from 'svelte';
	import { isGenerating } from '$lib/core/stores';
	import { backendClients } from '$lib/core/api';
	import { AssetCategory } from '$lib/gen/asset/v1/asset_pb.js';
	import type { Asset } from '$lib/gen/asset/v1/asset_pb.js';
	import type { PanelArrayParams } from '$lib/core/api';

	type DprPanelPreset = {
		id: string;
		manufacturer: string;
		model: string;
		name: string;
		widthMm: number;
		heightMm: number;
		ratedPowerW: number;
	};

	const indiaDprPanels: DprPanelPreset[] = [
		{
			id: 'dpr-india-jinko-650',
			manufacturer: 'JinkoSolar',
			model: 'JKM625-650N-78HL4-BDV',
			name: 'Tiger Neo 650W (DPR India)',
			widthMm: 1303,
			heightMm: 2384,
			ratedPowerW: 650
		},
		{
			id: 'dpr-india-trina-695',
			manufacturer: 'Trina Solar',
			model: 'TSM-NEG21C.20',
			name: 'Vertex N 695W (DPR India)',
			widthMm: 1303,
			heightMm: 2384,
			ratedPowerW: 695
		},
		{
			id: 'dpr-india-waaree-545',
			manufacturer: 'Waaree',
			model: 'Bi-55-545',
			name: 'Waaree 545W (DPR India)',
			widthMm: 1134,
			heightMm: 2278,
			ratedPowerW: 545
		},
		{
			id: 'dpr-india-adani-540',
			manufacturer: 'Adani Solar',
			model: 'ASB-540',
			name: 'Adani 540W (DPR India)',
			widthMm: 1134,
			heightMm: 2278,
			ratedPowerW: 540
		}
	];

	export let fillAreaGeoJson: string = '';
	export let fillAreas: string[] = [];
	export let exclusionAreas: string[] = [];
	export let boundaryGeoJson: string = '';

	// Normalise: if fillAreas not provided, fall back to legacy single-area prop
	$: resolvedAreas = fillAreas.length > 0 ? fillAreas : (fillAreaGeoJson ? [fillAreaGeoJson] : []);

	const dispatch = createEventDispatcher<{
		generate: PanelArrayParams;
		generateMany: {
			areas: string[];
			exclusionAreas: string[];
			areaOverrides: { tilt_angle: number; azimuth: number }[];
			baseParams: Omit<PanelArrayParams, 'fill_area_geojson'>;
		};
		autoGenerate: {
			areaOverrides: { tilt_angle: number; azimuth: number }[];
			baseParams: Omit<PanelArrayParams, 'fill_area_geojson'>;
		};
		cancel: void;
	}>();

	let panelWidth = 2.278;
	let panelHeight = 1.134;
	let tiltAngle = 20;
	let azimuth = 180;
	let rowSpacing = 0;
	let columnSpacing = 0.02;
	let areaOverrides: { tilt_angle: number; azimuth: number }[] = [];
	let panelAssets: Asset[] = [];
	let loadingPanelAssets = false;
	let selectedPanelAssetId = '';
	let selectedPanelAsset: Asset | null = null;
	let selectedDprPanel: DprPanelPreset | null = null;

	const MAX_PANELS = 1000_000;
	let areaSqm = 0;

	onMount(() => {
		void loadPanelAssets();
	});

	async function loadPanelAssets() {
		loadingPanelAssets = true;
		try {
			const res = await backendClients.asset.listAssets({
				categoryFilter: AssetCategory.SOLAR_PANEL,
				pageSize: 100
			});
			panelAssets = res.assets ?? [];
			if (!selectedPanelAssetId && panelAssets.length > 0) {
				selectedPanelAssetId = panelAssets[0].id;
			}
		} catch {
			panelAssets = [];
		} finally {
			loadingPanelAssets = false;
		}
	}

	$: selectedPanelAsset = panelAssets.find((a) => a.id === selectedPanelAssetId) ?? null;
	$: selectedDprPanel = indiaDprPanels.find((p) => p.id === selectedPanelAssetId) ?? null;
	$: hasAnyPanelOptions = panelAssets.length > 0 || indiaDprPanels.length > 0;

	function applySelectedPanelSpec() {
		if (selectedDprPanel) {
			const w = Number(selectedDprPanel.widthMm) / 1000;
			const h = Number(selectedDprPanel.heightMm) / 1000;
			if (Number.isFinite(w) && w > 0) panelWidth = parseFloat(w.toFixed(3));
			if (Number.isFinite(h) && h > 0) panelHeight = parseFloat(h.toFixed(3));
			return;
		}
		if (!selectedPanelAsset?.dimensions) return;
		const w = Number(selectedPanelAsset.dimensions.widthMm ?? 0) / 1000;
		const h = Number(selectedPanelAsset.dimensions.heightMm ?? 0) / 1000;
		if (Number.isFinite(w) && w > 0) panelWidth = parseFloat(w.toFixed(3));
		if (Number.isFinite(h) && h > 0) panelHeight = parseFloat(h.toFixed(3));
	}

	// Auto-calculate row spacing based on tilt for no-shading
	$: if (rowSpacing === 0) {
		rowSpacing = parseFloat((panelHeight * Math.sin((tiltAngle * Math.PI) / 180) * 2.5).toFixed(2));
	}

	// ── Estimated panel count ──────────────────────────────────────────────
	function polygonAreaSqm(geojson: string): number {
		try {
			const poly = JSON.parse(geojson) as { type: string; coordinates: number[][][] };
			if (poly.type !== 'Polygon' || !poly.coordinates?.[0]) return 0;
			const ring = poly.coordinates[0];
			if (ring.length < 3) return 0;
			const meanLat = ring.reduce((s, c) => s + c[1], 0) / ring.length;
			const mLat = 111320;
			const mLon = 111320 * Math.cos((meanLat * Math.PI) / 180);
			let sum = 0;
			for (let i = 0; i < ring.length; i++) {
				const [x1, y1] = ring[i];
				const [x2, y2] = ring[(i + 1) % ring.length];
				sum += x1 * mLon * y2 * mLat - x2 * mLon * y1 * mLat;
			}
			return Math.abs(sum) / 2;
		} catch {
			return 0;
		}
	}

	$: areaSqm = resolvedAreas.reduce((sum, g) => sum + polygonAreaSqm(g), 0);
	$: areaCount = resolvedAreas.length;
	$: hasBoundaryFallback = boundaryGeoJson.trim().length > 0;
	$: canAutoGenerate = resolvedAreas.length > 0 || hasBoundaryFallback;
	$: {
		if (areaOverrides.length !== areaCount) {
			areaOverrides = Array.from({ length: areaCount }, (_, i) => ({
				tilt_angle: areaOverrides[i]?.tilt_angle ?? tiltAngle,
				azimuth: areaOverrides[i]?.azimuth ?? azimuth
			}));
		}
	}
	$: effectiveRowSpacing = rowSpacing > 0 ? rowSpacing : parseFloat((panelHeight * Math.sin((tiltAngle * Math.PI) / 180) * 2.5).toFixed(2));
	$: effectiveColSpacing = columnSpacing > 0 ? columnSpacing : 0.02;
	$: pitchRow = panelHeight + effectiveRowSpacing;
	$: pitchCol = panelWidth + effectiveColSpacing;
	$: estimatedPanels = areaSqm > 0 && pitchRow > 0 && pitchCol > 0
			? Math.floor(areaSqm * 0.95 / (pitchRow * pitchCol))
			: 0;

	function handleGenerate() {
		if (resolvedAreas.length === 0) return;

		const baseParams: Omit<PanelArrayParams, 'fill_area_geojson'> = buildBaseParams();

		dispatch('generateMany', {
			areas: resolvedAreas,
			exclusionAreas,
			areaOverrides,
			baseParams
		});
	}

	function handleAutoGenerate() {
		if (!canAutoGenerate) return;

		dispatch('autoGenerate', {
			areaOverrides,
			baseParams: buildBaseParams()
		});
	}

	function buildBaseParams(): Omit<PanelArrayParams, 'fill_area_geojson'> {
		return {
			panel_width: panelWidth,
			panel_height: panelHeight,
			tilt_angle: tiltAngle,
			azimuth,
			row_spacing: rowSpacing,
			column_spacing: columnSpacing,
			panel_asset_id: selectedPanelAsset?.id ?? selectedDprPanel?.id ?? '',
			panel_model: selectedDprPanel
				? `${selectedDprPanel.manufacturer} ${selectedDprPanel.model}`
				: selectedPanelAsset
					? `${selectedPanelAsset.manufacturer} ${selectedPanelAsset.model || selectedPanelAsset.name}`
					: '',
			panel_rated_power_w: selectedDprPanel?.ratedPowerW ?? selectedPanelAsset?.electrical?.ratedPowerW ?? 550
		};
	}

	function handleCancel() {
		dispatch('cancel');
	}
</script>

<div class="panel-form">
	<h4>Layout Generation</h4>
	<div class="panel-spec-note">
		Panel spec used:
		{#if selectedDprPanel}
			{selectedDprPanel.manufacturer} {selectedDprPanel.model}
			({panelWidth.toFixed(3)}m x {panelHeight.toFixed(3)}m, {selectedDprPanel.ratedPowerW}W)
		{:else if selectedPanelAsset}
			{selectedPanelAsset.manufacturer} {selectedPanelAsset.model || selectedPanelAsset.name}
			({panelWidth.toFixed(3)}m x {panelHeight.toFixed(3)}m, {selectedPanelAsset.electrical?.ratedPowerW || 550}W)
		{:else}
			Generic module ({panelWidth.toFixed(3)}m x {panelHeight.toFixed(3)}m, approx 550W)
		{/if}
	</div>

	<div class="form-group">
		<label for="panel-model">Panel Model</label>
		<div class="input-field">
			<select id="panel-model" bind:value={selectedPanelAssetId} on:change={applySelectedPanelSpec} disabled={loadingPanelAssets && panelAssets.length === 0 && !hasAnyPanelOptions}>
				<option value="">{loadingPanelAssets ? 'Loading panel catalog…' : hasAnyPanelOptions ? 'Select panel model' : 'No panel assets available'}</option>
				{#if indiaDprPanels.length > 0}
					<optgroup label="India DPR Presets">
						{#each indiaDprPanels as preset}
							<option value={preset.id}>{preset.manufacturer} {preset.model} ({preset.ratedPowerW}W)</option>
						{/each}
					</optgroup>
				{/if}
				{#if panelAssets.length > 0}
					<optgroup label="Asset Library">
				{#each panelAssets as panel}
					<option value={panel.id}>{panel.manufacturer} {panel.model || panel.name}</option>
				{/each}
					</optgroup>
				{/if}
			</select>
		</div>
	</div>

	<div class="form-group">
		<label for="panel-width">Panel Size</label>
		<div class="input-row">
			<div class="input-field">
				<input id="panel-width" type="number" bind:value={panelWidth} step="0.001" min="0.1" />
				<span class="unit">m W</span>
			</div>
			<span class="separator">x</span>
			<div class="input-field">
				<input id="panel-height" type="number" bind:value={panelHeight} step="0.001" min="0.1" />
				<span class="unit">m H</span>
			</div>
		</div>
	</div>

	<div class="form-group">
		<label for="panel-tilt-angle">Tilt Angle</label>
		<div class="input-field">
			<input id="panel-tilt-angle" type="range" bind:value={tiltAngle} min="0" max="60" step="1" />
			<span class="range-value">{tiltAngle}°</span>
		</div>
	</div>

	<div class="form-group">
		<label for="panel-azimuth">Azimuth</label>
		<div class="input-field">
			<input id="panel-azimuth" type="range" bind:value={azimuth} min="0" max="360" step="1" />
			<span class="range-value">{azimuth}°</span>
		</div>
		<span class="hint">
			{azimuth === 180 ? 'South' : azimuth === 0 ? 'North' : azimuth === 90 ? 'East' : azimuth === 270 ? 'West' : `${azimuth}°`}
		</span>
	</div>

	{#if areaCount > 1}
		<div class="form-group area-overrides-group">
			<div class="subheading">Per-Area Tilt / Azimuth</div>
			<div class="area-overrides-list">
				{#each areaOverrides as area, i}
					<div class="area-row">
						<span class="area-name">Area {i + 1}</span>
						<input type="number" min="0" max="60" step="1" bind:value={areaOverrides[i].tilt_angle} />
						<span class="tiny-unit">tilt°</span>
						<input type="number" min="0" max="360" step="1" bind:value={areaOverrides[i].azimuth} />
						<span class="tiny-unit">az°</span>
					</div>
				{/each}
			</div>
			<span class="hint">Each area can use different tilt and azimuth; row/column spacing remain common.</span>
		</div>
	{/if}

	<div class="form-group">
		<label for="panel-row-spacing">Row Spacing</label>
		<div class="input-field">
			<input id="panel-row-spacing" type="number" bind:value={rowSpacing} step="0.1" min="0" />
			<span class="unit">m</span>
		</div>
	</div>

	<div class="form-group">
		<label for="panel-column-spacing">Column Spacing</label>
		<div class="input-field">
			<input id="panel-column-spacing" type="number" bind:value={columnSpacing} step="0.01" min="0" />
			<span class="unit">m</span>
		</div>
	</div>

	{#if resolvedAreas.length > 0}
		<div class="area-indicator {estimatedPanels > MAX_PANELS ? 'over-limit' : estimatedPanels > MAX_PANELS * 0.75 ? 'near-limit' : ''}">
			<span class="dot {estimatedPanels > MAX_PANELS ? 'over-limit' : estimatedPanels > MAX_PANELS * 0.75 ? 'near-limit' : ''}"></span>
			{areaCount} solar area{areaCount === 1 ? '' : 's'} drawn
			{#if exclusionAreas.length > 0}
				<span class="excl-badge">{exclusionAreas.length} exclusion{exclusionAreas.length === 1 ? '' : 's'}</span>
			{/if}
			{#if estimatedPanels > 0}
				<span class="est-count">
					≈ {estimatedPanels.toLocaleString()} panels total
					{#if estimatedPanels > MAX_PANELS}
						<span class="limit-warn">— exceeds limit, increase spacing or shrink areas</span>
					{:else if estimatedPanels > MAX_PANELS * 0.75}
						<span class="limit-warn near">— approaching limit</span>
					{/if}
				</span>
			{/if}
		</div>
	{:else if hasBoundaryFallback}
		<div class="area-indicator warning fallback">
			<span class="dot warning"></span>
			No solar area drawn. Auto mode will use the site boundary as a provisional solar envelope.
		</div>
	{:else}
		<div class="area-indicator warning">
			<span class="dot warning"></span>
			Draw a solar area on the map first
		</div>
	{/if}

	<div class="form-actions">
		<button class="btn-cancel" on:click={handleCancel}>Cancel</button>
		<button
			class="btn-auto"
			on:click={handleAutoGenerate}
			disabled={!canAutoGenerate || $isGenerating || estimatedPanels > MAX_PANELS}
		>
			{$isGenerating ? 'Generating...' : 'Auto Generate Layout'}
		</button>
		<button
			class="btn-generate"
			on:click={handleGenerate}
			disabled={resolvedAreas.length === 0 || $isGenerating || estimatedPanels > MAX_PANELS}
		>
			{$isGenerating ? 'Generating...' : 'Generate Panels Only'}
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

	.panel-spec-note {
		font-size: 11px;
		color: #94a3b8;
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

	.input-field select {
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

	.area-overrides-list {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	.area-row {
		display: grid;
		grid-template-columns: 1fr 70px 42px 70px 32px;
		gap: 6px;
		align-items: center;
	}

	.area-name {
		font-size: 12px;
		color: #cbd5e1;
	}

	.tiny-unit {
		font-size: 10px;
		color: #94a3b8;
	}

	.subheading {
		font-size: 11px;
		font-weight: 500;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
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

	.area-indicator.fallback {
		align-items: flex-start;
		line-height: 1.4;
	}

	.area-indicator.near-limit {
		background: rgba(245, 158, 11, 0.12);
		color: #f59e0b;
	}

	.area-indicator.over-limit {
		background: rgba(239, 68, 68, 0.12);
		color: #f87171;
	}

	.dot {
		width: 6px;
		height: 6px;
		border-radius: 50%;
		background: #22c55e;
		flex-shrink: 0;
	}

	.dot.warning {
		background: #f59e0b;
	}

	.form-actions {
		display: flex;
		gap: 8px;
	}

	.form-actions button {
		flex: 1;
	}

	.btn-auto {
		padding: 10px 12px;
		border: 0;
		border-radius: 6px;
		background: linear-gradient(135deg, #f59e0b, #f97316);
		color: #0f172a;
		font-weight: 700;
		cursor: pointer;
	}

	.btn-auto:disabled {
		opacity: 0.55;
		cursor: not-allowed;
	}

	.dot.near-limit {
		background: #f59e0b;
	}

	.dot.over-limit {
		background: #ef4444;
	}

	.excl-badge {
		margin-left: 6px;
		padding: 1px 5px;
		border-radius: 3px;
		background: rgba(239, 68, 68, 0.2);
		color: #fca5a5;
		font-size: 10px;
		font-weight: 600;
	}

	.est-count {
		margin-left: 4px;
		font-weight: 600;
	}

	.limit-warn {
		font-weight: 400;
		color: #ef4444;
	}

	.limit-warn.near {
		color: #f59e0b;
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
