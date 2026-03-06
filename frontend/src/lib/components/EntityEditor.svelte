<script lang="ts">
	import { createEventDispatcher } from 'svelte';
	import { selectedEntityId } from '$lib/core/stores';

	const dispatch = createEventDispatcher<{
		update: { id: string; property: string; value: any };
		delete: { id: string };
	}>();

	export let entityType: string = '';
	export let entityData: Record<string, any> = {};

	let editingField: string | null = null;

	function startEdit(field: string) {
		editingField = field;
	}

	function finishEdit(field: string, value: any) {
		editingField = null;
		if ($selectedEntityId) {
			dispatch('update', { id: $selectedEntityId, property: field, value });
		}
	}

	function handleDelete() {
		if ($selectedEntityId && confirm('Delete this entity?')) {
			dispatch('delete', { id: $selectedEntityId });
			selectedEntityId.set(null);
		}
	}

	function handleDeselect() {
		selectedEntityId.set(null);
	}

	const typeLabels: Record<string, string> = {
		panel: 'Solar Panel',
		'panel-3d': 'Solar Panel (3D)',
		component: 'Equipment',
		route: 'Route',
		boundary: 'Site Boundary'
	};

	const editableFields: Record<string, { label: string; type: string; unit?: string }[]> = {
		panel: [
			{ label: 'Tilt', type: 'number', unit: '°' },
			{ label: 'Azimuth', type: 'number', unit: '°' },
			{ label: 'String ID', type: 'text' }
		],
		component: [
			{ label: 'Type', type: 'select' },
			{ label: 'Rotation', type: 'number', unit: '°' }
		],
		route: [
			{ label: 'Route Type', type: 'select' },
			{ label: 'Name', type: 'text' }
		]
	};

	$: fields = editableFields[entityType] || [];
</script>

{#if $selectedEntityId}
	<div class="entity-editor">
		<div class="editor-header">
			<h5>{typeLabels[entityType] || entityType}</h5>
			<button class="btn-close" on:click={handleDeselect}>x</button>
		</div>

		<div class="entity-id">
			<span class="id-label">ID</span>
			<span class="id-value">{$selectedEntityId.substring(0, 12)}...</span>
		</div>

		{#each fields as field}
			<div class="field-row">
				<span class="field-label">{field.label}</span>
				{#if editingField === field.label}
					<input
						type={field.type === 'number' ? 'number' : 'text'}
						value={entityData[field.label.toLowerCase().replace(' ', '_')] || ''}
						on:blur={(e) => finishEdit(field.label.toLowerCase().replace(' ', '_'), e.currentTarget.value)}
						on:keydown={(e) => { if (e.key === 'Enter') finishEdit(field.label.toLowerCase().replace(' ', '_'), e.currentTarget.value); }}
						autofocus
						class="field-input"
					/>
				{:else}
					<button class="field-value" on:click={() => startEdit(field.label)}>
						{entityData[field.label.toLowerCase().replace(' ', '_')] ?? '—'}
						{field.unit || ''}
					</button>
				{/if}
			</div>
		{/each}

		{#if Object.keys(entityData).length > fields.length}
			<div class="extra-props">
				{#each Object.entries(entityData) as [key, value]}
					{#if !fields.some(f => f.label.toLowerCase().replace(' ', '_') === key)}
						<div class="field-row readonly">
							<span class="field-label">{key}</span>
							<span class="field-value-ro">{value}</span>
						</div>
					{/if}
				{/each}
			</div>
		{/if}

		<div class="editor-actions">
			<button class="btn-delete" on:click={handleDelete}>Delete Entity</button>
		</div>
	</div>
{/if}

<style>
	.entity-editor {
		display: flex;
		flex-direction: column;
		gap: 8px;
		padding: 12px;
		background: rgba(0, 0, 0, 0.15);
		border-radius: 6px;
		border: 1px solid rgba(255, 255, 255, 0.08);
	}

	.editor-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.editor-header h5 {
		margin: 0;
		font-size: 13px;
		font-weight: 600;
		color: #e2e8f0;
	}

	.btn-close {
		border: none;
		background: transparent;
		color: #64748b;
		font-size: 14px;
		cursor: pointer;
		padding: 2px 4px;
	}

	.entity-id {
		display: flex;
		justify-content: space-between;
		font-size: 10px;
	}

	.id-label { color: #64748b; }
	.id-value { color: #475569; font-family: monospace; }

	.field-row {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 8px;
	}

	.field-label {
		font-size: 12px;
		color: #94a3b8;
		flex-shrink: 0;
	}

	.field-input {
		width: 80px;
		padding: 3px 6px;
		border: 1px solid #f59e0b;
		border-radius: 3px;
		background: rgba(0, 0, 0, 0.4);
		color: #e2e8f0;
		font-size: 12px;
		font-family: inherit;
		text-align: right;
	}

	.field-value {
		border: 1px solid transparent;
		border-radius: 3px;
		background: transparent;
		color: #e2e8f0;
		font-size: 12px;
		padding: 3px 6px;
		cursor: pointer;
		text-align: right;
	}

	.field-value:hover {
		border-color: rgba(255, 255, 255, 0.15);
		background: rgba(255, 255, 255, 0.04);
	}

	.field-value-ro {
		font-size: 11px;
		color: #64748b;
		text-align: right;
	}

	.field-row.readonly {
		opacity: 0.6;
	}

	.extra-props {
		border-top: 1px solid rgba(255, 255, 255, 0.06);
		padding-top: 6px;
		display: flex;
		flex-direction: column;
		gap: 4px;
	}

	.editor-actions {
		margin-top: 4px;
	}

	.btn-delete {
		width: 100%;
		padding: 6px;
		border: 1px solid rgba(239, 68, 68, 0.3);
		border-radius: 4px;
		background: transparent;
		color: #ef4444;
		font-size: 11px;
		cursor: pointer;
	}

	.btn-delete:hover {
		background: rgba(239, 68, 68, 0.1);
	}
</style>
