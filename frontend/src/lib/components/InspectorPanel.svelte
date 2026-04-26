<script lang="ts">
	import {
		activeProject,
		activeLayout,
		components,
		entities,
		activeView,
		layerVisibility,
		selectedEntityId,
		updateProject,
		workflowState
	} from '$lib/core/stores';
	import AssetLibrary from './AssetLibrary.svelte';
	import PanelGeneratorForm from './PanelGeneratorForm.svelte';
	import SolarPanel3DViewer from './SolarPanel3DViewer.svelte';
	import { toast } from '$lib/core/stores/toast';
	import { structuredLog } from '$lib/core/error-handling';

	let show3dPanel = false;
	import SimulationPanel from './SimulationPanel.svelte';
	import ElectricalPanel from './ElectricalPanel.svelte';
	import StructuralPanel from './StructuralPanel.svelte';
	import ProtectionPanel from './ProtectionPanel.svelte';
	import RoutingPanel from './RoutingPanel.svelte';
	import TransmissionPanel from './TransmissionPanel.svelte';
	import CommissioningPanel from './CommissioningPanel.svelte';
	import ReportsPanel from './ReportsPanel.svelte';
	import OrchestrationPanel from './OrchestrationPanel.svelte';
	import FinancialPanel from './FinancialPanel.svelte';
	import AdvancedAnalyticsPanel from './AdvancedAnalyticsPanel.svelte';
	import WeatherOverlay from './WeatherOverlay.svelte';
	import ExportPanel from './ExportPanel.svelte';
	import EntityEditor from './EntityEditor.svelte';
	import CadWorkspacePanel from './CadWorkspacePanel.svelte';
	import { createEventDispatcher } from 'svelte';
	import type { TerrainSummary, ZonePlanResult } from '$lib/core/api';
	import PlanningInputContractPanel from './PlanningInputContractPanel.svelte';
	import LayoutCompletenessPanel from './LayoutCompletenessPanel.svelte';
	import Lod400DashboardPanel from './Lod400DashboardPanel.svelte';
	import { computeLayoutCompleteness, type LayoutCompletenessSummary } from '$lib/core/domain/workflowReadiness';

	const dispatch = createEventDispatcher();

	export let fillAreaGeoJson: string = '';
	export let fillAreas: string[] = [];
	export let boundaryGeoJson: string = '';
	export let exclusionAreas: string[] = [];
	export let drawnRoads: { lineGeojson: string; widthM: number }[] = [];
	export let terrainSummary: TerrainSummary | null = null;
	export let zonePlan: ZonePlanResult | null = null;
	export let planningBusy = false;

	let activeTab: 'properties' | 'layers' | 'components' = 'properties';
	let capacityInput = 0;
	let savingCapacity = false;
	let capacityProjectId: string | null = null;
	let completenessSummary: LayoutCompletenessSummary | null = null;

	function toRouteEntitiesCount(routeType: 'road' | 'cable'): number {
		return $entities.filter(
			(entity) =>
				entity.type === 'component' &&
				String(entity.properties?.type ?? '') === 'route' &&
				String(entity.properties?.route_type ?? '') === routeType
		).length;
	}

	$: completenessSummary = computeLayoutCompleteness({
		layout_id: $activeLayout?.id ?? 'unassigned',
		total_panels: $activeLayout?.total_panels ?? 0,
		total_capacity_kw: $activeLayout?.total_capacity_kw ?? 0,
		fill_area_count: fillAreas.length,
		drawn_road_count: drawnRoads.length + toRouteEntitiesCount('road'),
		components: $components,
		entities: $entities
	});

	$: if ($activeProject?.id !== capacityProjectId) {
		capacityProjectId = $activeProject?.id ?? null;
		capacityInput = $activeProject?.target_capacity_mw ?? 0;
	}

	function toggleLayer(key: keyof typeof $layerVisibility) {
		layerVisibility.update((v) => ({ ...v, [key]: !v[key] }));
	}

	function handleGenerate(e: CustomEvent) {
		dispatch('generate', e.detail);
	}

	function handleGenerateMany(e: CustomEvent) {
		dispatch('generateMany', e.detail);
	}

	function handleAutoGenerate(e: CustomEvent) {
		dispatch('autoGenerate', e.detail);
	}

	function handleAssetSelect(e: CustomEvent) {
		dispatch('assetSelect', e.detail);
	}

	function handleTimeChange(e: CustomEvent) {
		dispatch('timeChange', e.detail);
	}

	function handleToggleShadows(e: CustomEvent) {
		dispatch('toggleShadows', e.detail);
	}

	function requestTerrainAnalysis() {
		dispatch('analyzeTerrain');
	}

	function requestZonePlanning() {
		dispatch('planZones');
	}

	async function saveCapacity() {
		if (!$activeProject) return;
		savingCapacity = true;
		try {
			await updateProject($activeProject.id, { target_capacity_mw: capacityInput });
			toast.success('Capacity updated');
		} catch (err) {
			structuredLog('error', 'project.update_capacity_failed', { error: String(err), projectId: $activeProject.id });
			toast.error(`Failed to update capacity: ${err instanceof Error ? err.message : 'unknown error'}`);
		} finally {
			savingCapacity = false;
		}
	}
</script>

<div class="inspector">
	<div class="inspector-header">
		<h3>Inspector</h3>
	</div>

	{#if $activeView === 'design'}
		<div class="tabs">
			<button class:active={activeTab === 'properties'} on:click={() => (activeTab = 'properties')}>
				Properties
			</button>
			<button class:active={activeTab === 'layers'} on:click={() => (activeTab = 'layers')}>
				Layers
			</button>
			<button class:active={activeTab === 'components'} on:click={() => (activeTab = 'components')}>
				Components
			</button>
		</div>

		<div class="inspector-content">
			{#if activeTab === 'properties'}
				{#if $selectedEntityId}
					<EntityEditor entityType="panel" entityData={{}} />
					<div class="divider"></div>
				{/if}
				{#if $activeProject}
					<div class="property-group">
						<h4>Project</h4>
						<div class="property">
							<span class="label">Name</span>
							<span class="value">{$activeProject.name}</span>
						</div>
						<div class="property">
							<span class="label">Status</span>
							<span class="value badge">{$activeProject.status}</span>
						</div>
						<div class="property">
							<span class="label">Capacity</span>
							<div class="capacity-editor">
								<input type="number" min="0" step="0.1" bind:value={capacityInput} />
								<button on:click={saveCapacity} disabled={savingCapacity}>
									{savingCapacity ? 'Saving...' : 'Save'}
								</button>
							</div>
						</div>
					</div>
				{:else}
					<p class="empty-state">No project selected</p>
				{/if}

				{#if $activeLayout}
					<div class="property-group">
						<h4>Layout</h4>
						<div class="property">
							<span class="label">Panels</span>
							<span class="value">{$activeLayout.total_panels.toLocaleString()}</span>
						</div>
						<div class="property">
							<span class="label">Capacity</span>
							<span class="value">{$activeLayout.total_capacity_kw.toFixed(1)} kW</span>
						</div>
						<div class="property">
							<span class="label">Tiles</span>
							<span class="value">{$activeLayout.tile_count}</span>
						</div>
					</div>
				{/if}

				<div class="property-group">
					<PanelGeneratorForm
						{fillAreaGeoJson}
						{fillAreas}
						{boundaryGeoJson}
						{exclusionAreas}
						on:generate={handleGenerate}
						on:generateMany={handleGenerateMany}
						on:autoGenerate={handleAutoGenerate}
						on:cancel
					/>
				</div>

				<div class="property-group panel-3d-group">
					<button
						class="section-toggle"
						on:click={() => (show3dPanel = !show3dPanel)}
					>
						<span class="section-toggle-label">&#9654; Solar Panel 3D</span>
						<span class="section-toggle-arrow">{show3dPanel ? '▲' : '▼'}</span>
					</button>
					{#if show3dPanel}
						<div class="panel-3d-host">
							<SolarPanel3DViewer
								widthMm={$activeLayout ? 1134 : 1000}
								heightMm={$activeLayout ? 2382 : 1650}
								tiltDeg={30}
							/>
						</div>
					{/if}
				</div>

				<div class="property-group planning-group">
					<h4>Site Planning</h4>
					<div class="planning-actions">
						<button on:click={requestTerrainAnalysis} disabled={planningBusy || !$activeProject || fillAreas.length === 0}>
							Analyze Terrain
						</button>
						<button on:click={requestZonePlanning} disabled={planningBusy || !$activeLayout || fillAreas.length === 0 || capacityInput <= 0}>
							Plan Zones
						</button>
					</div>
					{#if terrainSummary}
						<div class="planning-metrics">
							<div>Flat: {(terrainSummary.flat_area_sqm / 10000).toFixed(2)} ha</div>
							<div>Moderate: {(terrainSummary.moderate_slope_area_sqm / 10000).toFixed(2)} ha</div>
							<div>Steep: {(terrainSummary.steep_area_sqm / 10000).toFixed(2)} ha</div>
							<div>Depressions: {(terrainSummary.depression_area_sqm / 10000).toFixed(2)} ha</div>
							<div>Estimated trees: {terrainSummary.estimated_trees.toLocaleString()}</div>
						</div>
					{/if}
					{#if zonePlan}
						<div class="planning-metrics">
							<div>DC target: {zonePlan.estimated_dc_mw.toFixed(2)} MW</div>
							<div>Recommended AC: {zonePlan.recommended_ac_mw.toFixed(2)} MW</div>
							<div>Planned zones: {zonePlan.zones.length}</div>
						</div>
					{/if}
				</div>

				<div class="property-group">
					<PlanningInputContractPanel projectId={$activeProject?.id ?? null} targetCapacityMw={capacityInput} />
				</div>

				{#if completenessSummary}
					<div class="property-group">
						<LayoutCompletenessPanel summary={completenessSummary} />
					</div>
				{/if}
			{:else if activeTab === 'layers'}
				<div class="layer-list">
					<div class="layer-item">
						<input type="checkbox" checked={$layerVisibility.satellite} on:change={() => toggleLayer('satellite')} />
						<span>Satellite Imagery</span>
					</div>
					<div class="layer-item">
						<input type="checkbox" checked={$layerVisibility.terrain} on:change={() => toggleLayer('terrain')} />
						<span>Terrain</span>
					</div>
					<div class="layer-item">
						<input type="checkbox" checked={$layerVisibility.boundary} on:change={() => toggleLayer('boundary')} />
						<span>Site Boundary</span>
					</div>
					<div class="layer-item">
						<input type="checkbox" checked={$layerVisibility.panels} on:change={() => toggleLayer('panels')} />
						<span>Panel Layout</span>
					</div>
					<div class="layer-item">
						<input type="checkbox" checked={$layerVisibility.shadows} on:change={() => toggleLayer('shadows')} />
						<span>Shadows</span>
					</div>
					<div class="layer-item">
						<input type="checkbox" checked={$layerVisibility.cables} on:change={() => toggleLayer('cables')} />
						<span>Road / Cable Routes</span>
					</div>
					<div class="layer-item">
						<input
							type="checkbox"
							checked={$layerVisibility.transmissionLines}
							on:change={() => toggleLayer('transmissionLines')}
						/>
						<span>Transmission Lines</span>
					</div>
					<div class="layer-item">
						<input type="checkbox" checked={$layerVisibility.zones} on:change={() => toggleLayer('zones')} />
						<span>Infrastructure Zones</span>
					</div>
				</div>
			{:else if activeTab === 'components'}
				<AssetLibrary on:selectAsset={handleAssetSelect} />
			{/if}
		</div>
	{:else if $activeView === 'cad'}
		<div class="inspector-content">
			<CadWorkspacePanel />
		</div>
	{:else if $activeView === 'simulate'}
		<div class="inspector-content">
			<SimulationPanel on:timeChange={handleTimeChange} on:toggleShadows={handleToggleShadows} />
			<div class="divider"></div>
			<WeatherOverlay />
		</div>
	{:else if $activeView === 'electrical'}
		<div class="inspector-content">
			<ElectricalPanel />
			<div class="divider"></div>
			<StructuralPanel />
			<div class="divider"></div>
			<ProtectionPanel />
			<div class="divider"></div>
			<RoutingPanel />
		</div>
	{:else if $activeView === 'transmission'}
		<div class="inspector-content">
			<TransmissionPanel {drawnRoads} />
		</div>
	{:else if $activeView === 'commissioning'}
		<div class="inspector-content">
			<CommissioningPanel />
		</div>
	{:else if $activeView === 'reports'}
		<div class="inspector-content">
			{#if completenessSummary}
				<Lod400DashboardPanel
					projectId={$activeProject?.id ?? null}
					summary={completenessSummary}
					workflowBlockers={$workflowState.active_blockers}
					currentPhase={$workflowState.current_phase}
				/>
				<div class="divider"></div>
			{/if}
			<ReportsPanel />
			<div class="divider"></div>
			<OrchestrationPanel />
			<div class="divider"></div>
			<ExportPanel />
		</div>
	{:else if $activeView === 'financial'}
		<div class="inspector-content">
			<FinancialPanel />
			<div class="divider"></div>
			<AdvancedAnalyticsPanel />
		</div>
	{/if}

</div>

<style>
	.inspector {
		width: 300px;
		height: 100%;
		background: rgba(22, 33, 62, 0.95);
		backdrop-filter: blur(8px);
		border-left: 1px solid rgba(255, 255, 255, 0.1);
		display: flex;
		flex-direction: column;
		overflow-y: auto;
	}

	.inspector-header {
		padding: 16px;
		border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	}

	.inspector-header h3 {
		margin: 0;
		font-size: 14px;
		font-weight: 600;
		color: #e2e8f0;
	}

	.tabs {
		display: flex;
		border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	}

	.tabs button {
		flex: 1;
		padding: 8px;
		border: none;
		background: transparent;
		color: #94a3b8;
		font-size: 12px;
		cursor: pointer;
		border-bottom: 2px solid transparent;
	}

	.tabs button.active {
		color: #f59e0b;
		border-bottom-color: #f59e0b;
	}

	.inspector-content {
		padding: 16px;
		flex: 1;
	}

	.property-group {
		margin-bottom: 16px;
	}

	.property-group h4 {
		margin: 0 0 8px 0;
		font-size: 12px;
		font-weight: 600;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.property {
		display: flex;
		justify-content: space-between;
		padding: 6px 0;
		font-size: 13px;
	}

	.label {
		color: #94a3b8;
	}

	.value {
		color: #e2e8f0;
		font-weight: 500;
	}

	.capacity-editor {
		display: flex;
		align-items: center;
		gap: 6px;
	}

	.capacity-editor input {
		width: 76px;
		padding: 4px 6px;
		border-radius: 4px;
		border: 1px solid rgba(255, 255, 255, 0.14);
		background: rgba(0, 0, 0, 0.24);
		color: #e2e8f0;
		font-size: 12px;
	}

	.capacity-editor button {
		padding: 4px 8px;
		border-radius: 4px;
		border: 1px solid rgba(255, 255, 255, 0.14);
		background: rgba(245, 158, 11, 0.2);
		color: #f59e0b;
		font-size: 11px;
		font-weight: 600;
		cursor: pointer;
	}

	.capacity-editor button:disabled {
		opacity: 0.7;
		cursor: not-allowed;
	}

	.planning-group {
		padding-top: 10px;
		border-top: 1px solid rgba(255, 255, 255, 0.08);
	}

	.planning-actions {
		display: flex;
		gap: 8px;
	}

	.planning-actions button {
		flex: 1;
		padding: 7px 8px;
		border-radius: 6px;
		border: 1px solid rgba(255, 255, 255, 0.14);
		background: rgba(30, 41, 59, 0.75);
		color: #e2e8f0;
		font-size: 12px;
		font-weight: 600;
		cursor: pointer;
	}

	.planning-actions button:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}

	.planning-metrics {
		margin-top: 10px;
		display: grid;
		gap: 5px;
		font-size: 12px;
		color: #cbd5e1;
	}

	.badge {
		background: rgba(245, 158, 11, 0.2);
		color: #f59e0b;
		padding: 2px 8px;
		border-radius: 4px;
		font-size: 11px;
	}

	.layer-list {
		display: flex;
		flex-direction: column;
		gap: 8px;
	}

	.layer-item {
		display: flex;
		align-items: center;
		gap: 8px;
		font-size: 13px;
		color: #e2e8f0;
	}

	.divider {
		height: 1px;
		background: rgba(255, 255, 255, 0.1);
		margin: 16px 0;
	}

	.empty-state {
		color: #64748b;
		font-size: 13px;
		text-align: center;
		padding: 24px 0;
	}

	.divider {
		height: 1px;
		background: rgba(255, 255, 255, 0.1);
		margin: 12px 0;
	}

	/* ── Solar Panel 3D section ── */
	.panel-3d-group {
		padding: 0;
	}

	.section-toggle {
		display: flex;
		align-items: center;
		justify-content: space-between;
		width: 100%;
		padding: 7px 10px;
		background: rgba(255 255 255 / 0.04);
		border: 1px solid rgba(255 255 255 / 0.08);
		border-radius: 6px;
		cursor: pointer;
		color: #8fbbd8;
		font-size: 11.5px;
		font-weight: 600;
		letter-spacing: 0.04em;
		text-transform: uppercase;
	}

	.section-toggle:hover {
		background: rgba(255 255 255 / 0.07);
	}

	.section-toggle-label {
		flex: 1;
		text-align: left;
	}

	.section-toggle-arrow {
		font-size: 9px;
		color: #4a6580;
	}

	.panel-3d-host {
		height: 260px;
		border-radius: 0 0 6px 6px;
		overflow: hidden;
		border: 1px solid rgba(255 255 255 / 0.07);
		border-top: none;
	}
</style>
