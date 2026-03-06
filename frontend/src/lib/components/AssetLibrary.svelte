<script lang="ts">
	import { createEventDispatcher } from 'svelte';

	const dispatch = createEventDispatcher<{
		selectAsset: { type: string; name: string };
	}>();

	interface AssetEntry {
		type: string;
		name: string;
		icon: string;
		specs: string;
	}

	const assetCategories: { label: string; assets: AssetEntry[] }[] = [
		{
			label: 'Solar Panels',
			assets: [
				{ type: 'panel', name: 'Mono PERC 550W', icon: '▬', specs: '2278×1134mm, 21.3%' },
				{ type: 'panel', name: 'Bifacial 600W', icon: '▬', specs: '2384×1096mm, 22.1%' },
				{ type: 'panel', name: 'Thin Film 450W', icon: '▬', specs: '2009×1232mm, 18.5%' }
			]
		},
		{
			label: 'Inverters',
			assets: [
				{ type: 'inverter', name: 'String Inverter 50kW', icon: '⚡', specs: '3-phase, 98.6%' },
				{ type: 'inverter', name: 'Central Inverter 500kW', icon: '⚡', specs: '3-phase, 98.8%' },
				{ type: 'inverter', name: 'Central Inverter 2.5MW', icon: '⚡', specs: '3-phase, 99.0%' }
			]
		},
		{
			label: 'Electrical',
			assets: [
				{ type: 'transformer', name: 'Step-up 34.5kV', icon: '⊞', specs: '2500 kVA' },
				{ type: 'combiner_box', name: 'Combiner Box 16-in', icon: '⊡', specs: '16 strings, 1500V DC' },
				{ type: 'meter', name: 'Revenue Meter', icon: '◎', specs: 'Bi-directional' }
			]
		},
		{
			label: 'Mounting',
			assets: [
				{ type: 'tracker', name: 'Single-Axis Tracker', icon: '↔', specs: '±60° rotation' },
				{ type: 'mounting', name: 'Fixed Tilt Rack', icon: '△', specs: '10-30° adjustable' },
				{ type: 'mounting', name: 'Ground Screw', icon: '⟂', specs: 'No concrete' }
			]
		}
	];

	let expandedCategory: string | null = 'Solar Panels';
	let draggedAsset: AssetEntry | null = null;

	function toggleCategory(label: string) {
		expandedCategory = expandedCategory === label ? null : label;
	}

	function handleDragStart(event: DragEvent, asset: AssetEntry) {
		draggedAsset = asset;
		event.dataTransfer?.setData('text/plain', JSON.stringify({ type: asset.type, name: asset.name }));
		if (event.dataTransfer) {
			event.dataTransfer.effectAllowed = 'copy';
		}
	}

	function handleClick(asset: AssetEntry) {
		dispatch('selectAsset', { type: asset.type, name: asset.name });
	}
</script>

<div class="asset-library">
	<div class="library-header">
		<h4>Asset Library</h4>
	</div>

	{#each assetCategories as category}
		<div class="category">
			<button class="category-header" on:click={() => toggleCategory(category.label)}>
				<span class="expand-icon">{expandedCategory === category.label ? '▾' : '▸'}</span>
				<span>{category.label}</span>
				<span class="count">{category.assets.length}</span>
			</button>

			{#if expandedCategory === category.label}
				<div class="asset-list">
					{#each category.assets as asset}
						<button
							class="asset-item"
							draggable="true"
							on:dragstart={(e) => handleDragStart(e, asset)}
							on:click={() => handleClick(asset)}
						>
							<span class="asset-icon">{asset.icon}</span>
							<div class="asset-info">
								<span class="asset-name">{asset.name}</span>
								<span class="asset-specs">{asset.specs}</span>
							</div>
						</button>
					{/each}
				</div>
			{/if}
		</div>
	{/each}
</div>

<style>
	.asset-library {
		display: flex;
		flex-direction: column;
	}

	.library-header h4 {
		margin: 0 0 8px 0;
		font-size: 12px;
		font-weight: 600;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.category {
		margin-bottom: 2px;
	}

	.category-header {
		display: flex;
		align-items: center;
		gap: 6px;
		width: 100%;
		padding: 6px 8px;
		border: none;
		border-radius: 4px;
		background: rgba(255, 255, 255, 0.04);
		color: #e2e8f0;
		font-size: 12px;
		font-weight: 500;
		cursor: pointer;
		text-align: left;
	}

	.category-header:hover {
		background: rgba(255, 255, 255, 0.08);
	}

	.expand-icon {
		font-size: 10px;
		width: 12px;
		color: #94a3b8;
	}

	.count {
		margin-left: auto;
		color: #64748b;
		font-size: 11px;
	}

	.asset-list {
		display: flex;
		flex-direction: column;
		gap: 2px;
		padding: 4px 0 4px 18px;
	}

	.asset-item {
		display: flex;
		align-items: center;
		gap: 8px;
		padding: 6px 8px;
		border: 1px solid transparent;
		border-radius: 4px;
		background: transparent;
		color: #e2e8f0;
		cursor: grab;
		text-align: left;
		transition: all 0.15s;
	}

	.asset-item:hover {
		background: rgba(245, 158, 11, 0.1);
		border-color: rgba(245, 158, 11, 0.3);
	}

	.asset-item:active {
		cursor: grabbing;
	}

	.asset-icon {
		font-size: 16px;
		width: 24px;
		text-align: center;
		flex-shrink: 0;
	}

	.asset-info {
		display: flex;
		flex-direction: column;
		min-width: 0;
	}

	.asset-name {
		font-size: 12px;
		font-weight: 500;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.asset-specs {
		font-size: 10px;
		color: #64748b;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}
</style>
