<script lang="ts">
	import { activeProject, activeLayout } from '$lib/core/stores';

	let activeTab: 'properties' | 'layers' | 'components' = 'properties';
</script>

<div class="inspector">
	<div class="inspector-header">
		<h3>Inspector</h3>
	</div>

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
						<span class="value">{$activeProject.target_capacity_mw ?? '—'} MW</span>
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
		{:else if activeTab === 'layers'}
			<div class="layer-list">
				<div class="layer-item">
					<input type="checkbox" checked />
					<span>Satellite Imagery</span>
				</div>
				<div class="layer-item">
					<input type="checkbox" checked />
					<span>Terrain</span>
				</div>
				<div class="layer-item">
					<input type="checkbox" checked />
					<span>Site Boundary</span>
				</div>
				<div class="layer-item">
					<input type="checkbox" checked />
					<span>Panel Layout</span>
				</div>
				<div class="layer-item">
					<input type="checkbox" />
					<span>Shadows</span>
				</div>
				<div class="layer-item">
					<input type="checkbox" />
					<span>Cable Routes</span>
				</div>
			</div>
		{:else if activeTab === 'components'}
			<p class="empty-state">Drag components from the asset library to place them on the map.</p>
		{/if}
	</div>
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

	.empty-state {
		color: #64748b;
		font-size: 13px;
		text-align: center;
		padding: 24px 0;
	}
</style>
