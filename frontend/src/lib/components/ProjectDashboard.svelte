<script lang="ts">
	import { createEventDispatcher } from 'svelte';
	import { projects, loadProjects, createProject, deleteProject, activeProjectId } from '$lib/core/stores';
	import type { Project } from '$lib/core/api';

	const dispatch = createEventDispatcher<{
		openProject: { project: Project };
		close: void;
	}>();

	export let open = false;

	let showCreateForm = false;
	let newName = '';
	let newDescription = '';
	let newCapacity = 100;
	let newLocation = '';
	let newClient = '';
	let isCreating = false;

	$: if (open) {
		loadProjects();
	}

	async function handleCreate() {
		if (!newName.trim()) return;
		isCreating = true;
		try {
			const project = await createProject(newName.trim(), newDescription.trim());
			activeProjectId.set(project.id);
			dispatch('openProject', { project });
			showCreateForm = false;
			resetForm();
		} catch (err) {
			console.error('Failed to create project:', err);
		} finally {
			isCreating = false;
		}
	}

	function handleOpen(project: Project) {
		activeProjectId.set(project.id);
		dispatch('openProject', { project });
	}

	async function handleDelete(id: string, name: string) {
		if (!confirm(`Delete project "${name}"? This cannot be undone.`)) return;
		await deleteProject(id);
	}

	function resetForm() {
		newName = '';
		newDescription = '';
		newCapacity = 100;
		newLocation = '';
		newClient = '';
	}

	function close() {
		dispatch('close');
	}

	function getStatusColor(status: string): string {
		switch (status) {
			case 'draft': return '#94a3b8';
			case 'design': return '#3b82f6';
			case 'simulation': return '#f59e0b';
			case 'review': return '#8b5cf6';
			case 'approved': return '#22c55e';
			case 'archived': return '#64748b';
			default: return '#94a3b8';
		}
	}
</script>

{#if open}
	<div class="overlay" on:click|self={close}>
		<div class="dashboard">
			<div class="dash-header">
				<h2>Projects</h2>
				<div class="header-actions">
					<button class="btn-new" on:click={() => { showCreateForm = !showCreateForm; }}>
						{showCreateForm ? 'Cancel' : '+ New Project'}
					</button>
					<button class="btn-close" on:click={close}>x</button>
				</div>
			</div>

			{#if showCreateForm}
				<form class="create-form" on:submit|preventDefault={handleCreate}>
					<div class="form-row">
						<div class="form-group">
							<label>Project Name *</label>
							<input type="text" bind:value={newName} placeholder="e.g. Riverside Solar Farm" autofocus />
						</div>
						<div class="form-group">
							<label>Target Capacity (MW)</label>
							<input type="number" bind:value={newCapacity} min="0" step="0.1" />
						</div>
					</div>
					<div class="form-group">
						<label>Description</label>
						<textarea bind:value={newDescription} rows="2" placeholder="Project details..."></textarea>
					</div>
					<div class="form-row">
						<div class="form-group">
							<label>Location</label>
							<input type="text" bind:value={newLocation} placeholder="City, State" />
						</div>
						<div class="form-group">
							<label>Client</label>
							<input type="text" bind:value={newClient} placeholder="Client name" />
						</div>
					</div>
					<button type="submit" class="btn-create" disabled={!newName.trim() || isCreating}>
						{isCreating ? 'Creating...' : 'Create Project'}
					</button>
				</form>
			{/if}

			<div class="project-list">
				{#if $projects.length === 0}
					<div class="empty">
						<p>No projects yet. Create your first solar project to get started.</p>
					</div>
				{:else}
					{#each $projects as project}
						<button class="project-card" on:click={() => handleOpen(project)}>
							<div class="card-top">
								<h3>{project.name}</h3>
								<span class="status" style="color: {getStatusColor(project.status)}; background: {getStatusColor(project.status)}20;">
									{project.status}
								</span>
							</div>
							{#if project.description}
								<p class="description">{project.description}</p>
							{/if}
							<div class="card-meta">
								{#if project.target_capacity_mw}
									<span>{project.target_capacity_mw} MW</span>
								{/if}
								{#if project.location_name}
									<span>{project.location_name}</span>
								{/if}
								{#if project.client_name}
									<span>{project.client_name}</span>
								{/if}
								<span class="date">{new Date(project.created_at).toLocaleDateString()}</span>
							</div>
							<button class="btn-delete" on:click|stopPropagation={() => handleDelete(project.id, project.name)}>
								Delete
							</button>
						</button>
					{/each}
				{/if}
			</div>
		</div>
	</div>
{/if}

<style>
	.overlay {
		position: fixed;
		inset: 0;
		background: rgba(0, 0, 0, 0.6);
		display: flex;
		align-items: center;
		justify-content: center;
		z-index: 200;
		backdrop-filter: blur(4px);
	}

	.dashboard {
		width: 680px;
		max-height: 80vh;
		background: #16213e;
		border-radius: 12px;
		border: 1px solid rgba(255, 255, 255, 0.1);
		display: flex;
		flex-direction: column;
		overflow: hidden;
	}

	.dash-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 20px 24px;
		border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	}

	.dash-header h2 {
		margin: 0;
		font-size: 18px;
		font-weight: 700;
		color: #e2e8f0;
	}

	.header-actions {
		display: flex;
		gap: 8px;
	}

	.btn-new {
		padding: 6px 14px;
		border: none;
		border-radius: 6px;
		background: linear-gradient(135deg, #f59e0b, #d97706);
		color: #1a1a2e;
		font-size: 13px;
		font-weight: 600;
		cursor: pointer;
	}

	.btn-close {
		width: 32px;
		height: 32px;
		border: none;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.08);
		color: #94a3b8;
		font-size: 16px;
		cursor: pointer;
	}

	.create-form {
		padding: 20px 24px;
		border-bottom: 1px solid rgba(255, 255, 255, 0.1);
		display: flex;
		flex-direction: column;
		gap: 12px;
		background: rgba(0, 0, 0, 0.15);
	}

	.form-row {
		display: flex;
		gap: 12px;
	}

	.form-group {
		display: flex;
		flex-direction: column;
		gap: 4px;
		flex: 1;
	}

	.form-group label {
		font-size: 11px;
		font-weight: 500;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.form-group input,
	.form-group textarea {
		padding: 8px 10px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 6px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 13px;
		font-family: inherit;
		resize: vertical;
	}

	.form-group input:focus,
	.form-group textarea:focus {
		outline: none;
		border-color: #f59e0b;
	}

	.btn-create {
		padding: 10px;
		border: none;
		border-radius: 6px;
		background: linear-gradient(135deg, #f59e0b, #d97706);
		color: #1a1a2e;
		font-size: 14px;
		font-weight: 600;
		cursor: pointer;
	}

	.btn-create:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}

	.project-list {
		flex: 1;
		overflow-y: auto;
		padding: 16px 24px;
		display: flex;
		flex-direction: column;
		gap: 8px;
	}

	.empty {
		text-align: center;
		padding: 40px 0;
		color: #64748b;
		font-size: 14px;
	}

	.project-card {
		display: flex;
		flex-direction: column;
		gap: 6px;
		padding: 14px 16px;
		border: 1px solid rgba(255, 255, 255, 0.08);
		border-radius: 8px;
		background: rgba(255, 255, 255, 0.03);
		cursor: pointer;
		text-align: left;
		color: inherit;
		position: relative;
		transition: all 0.15s;
	}

	.project-card:hover {
		border-color: rgba(245, 158, 11, 0.3);
		background: rgba(245, 158, 11, 0.05);
	}

	.card-top {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.card-top h3 {
		margin: 0;
		font-size: 14px;
		font-weight: 600;
		color: #e2e8f0;
	}

	.status {
		padding: 2px 8px;
		border-radius: 4px;
		font-size: 11px;
		font-weight: 500;
		text-transform: capitalize;
	}

	.description {
		margin: 0;
		font-size: 12px;
		color: #94a3b8;
		line-height: 1.4;
	}

	.card-meta {
		display: flex;
		gap: 12px;
		font-size: 11px;
		color: #64748b;
	}

	.card-meta span {
		display: flex;
		align-items: center;
		gap: 4px;
	}

	.btn-delete {
		position: absolute;
		top: 12px;
		right: 12px;
		padding: 2px 8px;
		border: 1px solid rgba(239, 68, 68, 0.3);
		border-radius: 4px;
		background: transparent;
		color: #ef4444;
		font-size: 11px;
		cursor: pointer;
		opacity: 0;
		transition: opacity 0.15s;
	}

	.project-card:hover .btn-delete {
		opacity: 1;
	}

	.btn-delete:hover {
		background: rgba(239, 68, 68, 0.1);
	}
</style>
