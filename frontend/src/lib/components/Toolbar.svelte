<script lang="ts">
	import { activeTool, type MapTool } from '$lib/core/stores';

	const tools: { id: MapTool; label: string; icon: string }[] = [
		{ id: 'select', label: 'Select', icon: 'cursor' },
		{ id: 'pan', label: 'Pan', icon: 'hand' },
		{ id: 'draw-boundary', label: 'Draw Boundary', icon: 'polygon' },
		{ id: 'place-component', label: 'Place Component', icon: 'plus' },
		{ id: 'draw-area', label: 'Draw Area', icon: 'square' },
		{ id: 'measure', label: 'Measure', icon: 'ruler' }
	];

	function setTool(tool: MapTool) {
		activeTool.set(tool);
	}
</script>

<div class="toolbar">
	{#each tools as tool}
		<button
			class="tool-btn"
			class:active={$activeTool === tool.id}
			on:click={() => setTool(tool.id)}
			title={tool.label}
		>
			<span class="tool-icon">{tool.icon.charAt(0).toUpperCase()}</span>
			<span class="tool-label">{tool.label}</span>
		</button>
	{/each}
</div>

<style>
	.toolbar {
		display: flex;
		flex-direction: column;
		gap: 4px;
		padding: 8px;
		background: rgba(22, 33, 62, 0.95);
		border-radius: 8px;
		backdrop-filter: blur(8px);
		border: 1px solid rgba(255, 255, 255, 0.1);
	}

	.tool-btn {
		display: flex;
		align-items: center;
		gap: 8px;
		padding: 8px 12px;
		border: none;
		border-radius: 6px;
		background: transparent;
		color: #94a3b8;
		cursor: pointer;
		font-size: 13px;
		transition: all 0.15s;
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
		width: 20px;
		height: 20px;
		display: flex;
		align-items: center;
		justify-content: center;
		font-weight: 600;
		font-size: 12px;
	}

	.tool-label {
		white-space: nowrap;
	}
</style>
