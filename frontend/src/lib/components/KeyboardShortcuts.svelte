<script lang="ts">
	export let open = false;

	const shortcuts: { category: string; items: { keys: string; action: string }[] }[] = [
		{
			category: 'General',
			items: [
				{ keys: 'Ctrl+Z', action: 'Undo' },
				{ keys: 'Ctrl+Y', action: 'Redo' },
				{ keys: 'Ctrl+Shift+Z', action: 'Redo (alt)' },
				{ keys: '?', action: 'Show shortcuts' },
				{ keys: 'Esc', action: 'Cancel / Deselect' },
				{ keys: 'Del', action: 'Delete selected' }
			]
		},
		{
			category: 'Tools',
			items: [
				{ keys: 'V', action: 'Select tool' },
				{ keys: 'H', action: 'Pan tool' },
				{ keys: 'B', action: 'Draw boundary' },
				{ keys: 'A', action: 'Draw panel area' },
				{ keys: 'P', action: 'Place component' },
				{ keys: 'M', action: 'Measure distance' }
			]
		},
		{
			category: 'Navigation',
			items: [
				{ keys: '1', action: 'Design view' },
				{ keys: '2', action: 'Simulate view' },
				{ keys: '3', action: 'Electrical view' },
				{ keys: '4', action: 'Reports view' },
				{ keys: '5', action: 'Financial view' },
				{ keys: 'F', action: 'Focus on selection' }
			]
		},
		{
			category: 'Map',
			items: [
				{ keys: 'Scroll', action: 'Zoom in/out' },
				{ keys: 'Right-drag', action: 'Rotate view' },
				{ keys: 'Middle-drag', action: 'Tilt view' },
				{ keys: 'Ctrl+/', action: 'Search location' }
			]
		}
	];

	function close() {
		open = false;
	}
</script>

{#if open}
	<div class="overlay" on:click|self={close}>
		<div class="shortcuts-modal">
			<div class="modal-header">
				<h2>Keyboard Shortcuts</h2>
				<button class="btn-close" on:click={close}>x</button>
			</div>

			<div class="shortcuts-grid">
				{#each shortcuts as category}
					<div class="shortcut-category">
						<h3>{category.category}</h3>
						{#each category.items as item}
							<div class="shortcut-item">
								<span class="shortcut-keys">
									{#each item.keys.split('+') as key, i}
										{#if i > 0}<span class="plus">+</span>{/if}
										<kbd>{key}</kbd>
									{/each}
								</span>
								<span class="shortcut-action">{item.action}</span>
							</div>
						{/each}
					</div>
				{/each}
			</div>
		</div>
	</div>
{/if}

<style>
	.overlay {
		position: fixed;
		inset: 0;
		background: rgba(0, 0, 0, 0.5);
		display: flex;
		align-items: center;
		justify-content: center;
		z-index: 250;
		backdrop-filter: blur(4px);
	}

	.shortcuts-modal {
		width: 560px;
		max-height: 80vh;
		background: #16213e;
		border-radius: 12px;
		border: 1px solid rgba(255, 255, 255, 0.1);
		overflow: hidden;
		display: flex;
		flex-direction: column;
	}

	.modal-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 16px 20px;
		border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	}

	.modal-header h2 {
		margin: 0;
		font-size: 16px;
		font-weight: 700;
		color: #e2e8f0;
	}

	.btn-close {
		width: 28px;
		height: 28px;
		border: none;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.08);
		color: #94a3b8;
		font-size: 14px;
		cursor: pointer;
	}

	.shortcuts-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 16px;
		padding: 20px;
		overflow-y: auto;
	}

	.shortcut-category h3 {
		margin: 0 0 8px 0;
		font-size: 12px;
		font-weight: 600;
		color: #f59e0b;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.shortcut-item {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 4px 0;
		font-size: 12px;
	}

	.shortcut-keys {
		display: flex;
		align-items: center;
		gap: 2px;
	}

	kbd {
		padding: 2px 6px;
		border-radius: 3px;
		background: rgba(255, 255, 255, 0.1);
		border: 1px solid rgba(255, 255, 255, 0.15);
		color: #e2e8f0;
		font-size: 11px;
		font-family: inherit;
		font-weight: 500;
	}

	.plus {
		color: #64748b;
		font-size: 10px;
		margin: 0 1px;
	}

	.shortcut-action {
		color: #94a3b8;
	}
</style>
