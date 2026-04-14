<script lang="ts">
	import { createEventDispatcher } from 'svelte';
import { activeProject, activeView, userRole, setUserRole, type AppView } from '$lib/core/stores';
import type { UserRole } from '$lib/core/domain/workflowGuards';

	type ViewGuard = { enabled: boolean; reason: string };

	export let viewGuards: Partial<Record<AppView, ViewGuard>> = {};
	export let phaseLabel = '';

	const dispatch = createEventDispatcher<{ blockedNav: { view: AppView; reason: string } }>();

	const views: { id: AppView; label: string }[] = [
		{ id: 'design', label: 'Design' },
		{ id: 'cad', label: 'CAD' },
		{ id: 'simulate', label: 'Simulate' },
		{ id: 'electrical', label: 'Electrical' },
		{ id: 'transmission', label: 'Transmission' },
		{ id: 'commissioning', label: 'Commissioning' },
		{ id: 'reports', label: 'Reports' },
		{ id: 'financial', label: 'Financial' }
	];

	function setView(id: AppView) {
		const guard = viewGuards[id];
		if (guard && !guard.enabled) {
			dispatch('blockedNav', { view: id, reason: guard.reason });
			return;
		}
		activeView.set(id);
	}

	function isEnabled(id: AppView): boolean {
		return viewGuards[id]?.enabled ?? true;
	}

	function guardReason(id: AppView): string {
		const reason = viewGuards[id]?.reason;
		if (!reason) return '';
		return reason;
	}

	function onRoleChange(event: Event) {
		const value = (event.target as HTMLSelectElement).value as UserRole;
		setUserRole(value);
	}
</script>

<header class="topbar">
	<div class="logo">
		<span class="logo-icon">S</span>
		<span class="logo-text">Solar3D</span>
	</div>

	<div class="project-info">
		{#if $activeProject}
			<span class="project-name">{$activeProject.name}</span>
			<span class="project-status">{$activeProject.status}</span>
			{#if phaseLabel}
				<span class="phase-status">{phaseLabel}</span>
			{/if}
			<select class="role-select" value={$userRole} on:change={onRoleChange} title="Operator role for UI access guard validation">
				<option value="planner">Planner</option>
				<option value="engineer">Engineer</option>
				<option value="reviewer">Reviewer</option>
				<option value="approver">Approver</option>
				<option value="operator">Operator</option>
				<option value="admin">Admin</option>
			</select>
		{:else}
			<span class="no-project">No project loaded</span>
		{/if}
	</div>

	<nav class="nav-actions">
		{#each views as view}
			<button
				class="nav-btn"
				class:active={$activeView === view.id}
				disabled={!isEnabled(view.id)}
				title={isEnabled(view.id) ? view.label : guardReason(view.id)}
				on:click={() => setView(view.id)}
			>
				{view.label}
			</button>
		{/each}
	</nav>
</header>

<style>
	.topbar {
		display: flex;
		align-items: center;
		height: 48px;
		padding: 0 16px;
		background: rgba(22, 33, 62, 0.98);
		border-bottom: 1px solid rgba(255, 255, 255, 0.1);
		z-index: 100;
	}

	.logo {
		display: flex;
		align-items: center;
		gap: 8px;
		margin-right: 24px;
	}

	.logo-icon {
		width: 28px;
		height: 28px;
		display: flex;
		align-items: center;
		justify-content: center;
		background: linear-gradient(135deg, #f59e0b, #d97706);
		border-radius: 6px;
		font-weight: 700;
		font-size: 16px;
		color: #1a1a2e;
	}

	.logo-text {
		font-weight: 700;
		font-size: 16px;
		color: #e2e8f0;
	}

	.project-info {
		display: flex;
		align-items: center;
		gap: 8px;
		margin-right: auto;
	}

	.project-name {
		color: #e2e8f0;
		font-size: 14px;
		font-weight: 500;
	}

	.project-status {
		background: rgba(245, 158, 11, 0.2);
		color: #f59e0b;
		padding: 2px 8px;
		border-radius: 4px;
		font-size: 11px;
		font-weight: 500;
	}

	.phase-status {
		background: rgba(59, 130, 246, 0.2);
		color: #93c5fd;
		padding: 2px 8px;
		border-radius: 4px;
		font-size: 11px;
		font-weight: 500;
	}

	.role-select {
		padding: 2px 6px;
		border: 1px solid rgba(148, 163, 184, 0.35);
		background: rgba(15, 23, 42, 0.55);
		color: #cbd5e1;
		border-radius: 4px;
		font-size: 11px;
	}

	.no-project {
		color: #64748b;
		font-size: 14px;
	}

	.nav-actions {
		display: flex;
		gap: 4px;
	}

	.nav-btn {
		padding: 6px 12px;
		border: none;
		border-radius: 6px;
		background: transparent;
		color: #94a3b8;
		font-size: 13px;
		cursor: pointer;
		transition: all 0.15s;
	}

	.nav-btn:hover {
		background: rgba(255, 255, 255, 0.08);
		color: #e2e8f0;
	}

	.nav-btn.active {
		background: rgba(245, 158, 11, 0.2);
		color: #f59e0b;
	}

	.nav-btn:disabled {
		opacity: 0.45;
		cursor: not-allowed;
		background: transparent;
		color: #64748b;
	}
</style>
