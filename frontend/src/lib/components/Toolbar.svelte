<script lang="ts">
	import { onMount } from 'svelte';
	import { activeTool, type MapTool } from '$lib/core/stores';

	type ToolDef = { id: MapTool; label: string; badge: string; shortcut: string };
	type ToolGroup = { title: string; tools: ToolDef[] };

	const groups: ToolGroup[] = [
		{
			title: 'Navigate',
			tools: [
				{ id: 'select', label: 'Select', badge: 'SE', shortcut: 'V' },
				{ id: 'pan', label: 'Pan', badge: 'PA', shortcut: 'H' },
				{ id: 'place-pin', label: 'Place Pin', badge: 'PI', shortcut: 'G' }
			]
		},
		{
			title: 'Draw',
			tools: [
				{ id: 'draw-boundary', label: 'Boundary', badge: 'BO', shortcut: 'B' },
				{ id: 'draw-area', label: 'Solar Area', badge: 'SA', shortcut: 'A' },
				{ id: 'draw-exclusion', label: 'Exclusion', badge: 'EX', shortcut: 'X' },
				{ id: 'draw-road', label: 'Road', badge: 'RD', shortcut: 'R' },
				{ id: 'measure', label: 'Measure', badge: 'ME', shortcut: 'M' }
			]
		},
		{
			title: 'Assets',
			tools: [
				{ id: 'place-component', label: 'Component', badge: 'CO', shortcut: 'P' },
				{ id: 'draw-dimension', label: 'Dimension', badge: 'DI', shortcut: 'D' },
				{ id: 'insert-block', label: 'Insert Block', badge: 'IB', shortcut: 'I' }
			]
		}
	];

	function setTool(tool: MapTool) {
		activeTool.set(tool);
	}

	let compactMode = false;
	const compactStorageKey = 'map-toolbar-compact-mode';

	onMount(() => {
		if (typeof localStorage === 'undefined') return;
		compactMode = localStorage.getItem(compactStorageKey) === '1';
	});

	function toggleCompactMode() {
		compactMode = !compactMode;
		if (typeof localStorage !== 'undefined') {
			localStorage.setItem(compactStorageKey, compactMode ? '1' : '0');
		}
	}
</script>

<div class="toolbar" class:compact={compactMode}>
	<div class="toolbar-header">
		<div class="toolbar-title">Map Tools</div>
		<button
			type="button"
			class="compact-toggle"
			on:click={toggleCompactMode}
			title={compactMode ? 'Expand toolbar' : 'Collapse toolbar'}
		>
			{compactMode ? '>' : '<'}
		</button>
	</div>
	{#each groups as group, index}
		<div class="tool-group" class:group-separator={index > 0}>
			{#if !compactMode}
				<div class="group-title">{group.title}</div>
			{/if}
			{#each group.tools as tool}
				<button
					class="tool-btn"
					class:active={$activeTool === tool.id}
					on:click={() => setTool(tool.id)}
					title={`${tool.label} (${tool.shortcut})`}
				>
					<span class="tool-icon">{tool.badge}</span>
					{#if !compactMode}
						<span class="tool-label">{tool.label}</span>
						<span class="shortcut">{tool.shortcut}</span>
					{/if}
				</button>
			{/each}
		</div>
	{/each}
</div>

<style>
	.toolbar {
		display: flex;
		flex-direction: column;
		gap: 10px;
		padding: 10px;
		background: rgba(22, 33, 62, 0.95);
		border-radius: 12px;
		backdrop-filter: blur(8px);
		border: 1px solid rgba(255, 255, 255, 0.1);
		min-width: 208px;
		box-shadow: 0 16px 36px rgba(2, 6, 23, 0.35);
	}

	.toolbar.compact {
		min-width: 74px;
		padding: 8px;
		gap: 8px;
	}

	.toolbar-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 8px;
	}

	.compact-toggle {
		width: 24px;
		height: 24px;
		border: 1px solid rgba(148, 163, 184, 0.35);
		border-radius: 6px;
		background: rgba(15, 23, 42, 0.7);
		color: #e2e8f0;
		font-weight: 700;
		cursor: pointer;
	}

	.compact-toggle:hover {
		border-color: rgba(245, 158, 11, 0.55);
		background: rgba(245, 158, 11, 0.18);
	}

	.toolbar-title {
		font-size: 11px;
		text-transform: uppercase;
		letter-spacing: 0.08em;
		color: #cbd5e1;
		font-weight: 700;
	}

	.tool-group {
		display: flex;
		flex-direction: column;
		gap: 4px;
	}

	.tool-group.group-separator {
		padding-top: 8px;
		border-top: 1px solid rgba(148, 163, 184, 0.2);
	}

	.toolbar.compact .tool-group.group-separator {
		padding-top: 6px;
	}

	.group-title {
		font-size: 10px;
		text-transform: uppercase;
		letter-spacing: 0.08em;
		color: #94a3b8;
		font-weight: 700;
	}

	.tool-btn {
		display: flex;
		align-items: center;
		gap: 8px;
		padding: 8px;
		border: none;
		border-radius: 6px;
		background: transparent;
		color: #94a3b8;
		cursor: pointer;
		font-size: 13px;
		transition: all 0.15s;
		text-align: left;
	}

	.toolbar.compact .tool-btn {
		justify-content: center;
		padding: 7px 6px;
	}

	.tool-btn:hover {
		background: rgba(255, 255, 255, 0.08);
		color: #e2e8f0;
	}

	.tool-btn.active {
		background: rgba(245, 158, 11, 0.2);
		color: #f59e0b;
	}

	.tool-icon {
		width: 22px;
		height: 22px;
		display: flex;
		align-items: center;
		justify-content: center;
		font-weight: 600;
		font-size: 10px;
		letter-spacing: 0.02em;
		border-radius: 4px;
		border: 1px solid rgba(148, 163, 184, 0.35);
		background: rgba(15, 23, 42, 0.55);
	}

	.toolbar.compact .tool-icon {
		width: 26px;
		height: 26px;
		font-size: 9px;
	}

	.tool-label {
		white-space: nowrap;
		flex: 1;
	}

	.shortcut {
		font-size: 10px;
		font-weight: 700;
		padding: 2px 6px;
		border-radius: 4px;
		border: 1px solid rgba(148, 163, 184, 0.4);
		color: #cbd5e1;
		background: rgba(15, 23, 42, 0.6);
	}

	@media (max-width: 980px) {
		.toolbar {
			min-width: 176px;
			padding: 8px;
		}

		.tool-label {
			font-size: 12px;
		}
	}
</style>
