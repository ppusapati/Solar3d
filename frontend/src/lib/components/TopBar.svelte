<script lang="ts">
	import { activeProject } from '$lib/core/stores';
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
		{:else}
			<span class="no-project">No project loaded</span>
		{/if}
	</div>

	<nav class="nav-actions">
		<button class="nav-btn">Projects</button>
		<button class="nav-btn">Design</button>
		<button class="nav-btn">Simulate</button>
		<button class="nav-btn">Electrical</button>
		<button class="nav-btn">Reports</button>
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
</style>
