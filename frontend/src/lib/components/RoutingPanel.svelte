<script lang="ts">
	import { activeProject } from '$lib/core/stores';
	import { routingApi } from '$lib/core/api';

	type RouteView = {
		id: string;
		name: string;
		type: string;
		distanceM: number;
		cost: number;
	};

	let routes: RouteView[] = [];
	let loading = false;
	let creating = false;
	let optimizing = false;
	let errorMsg = '';
	let routeName = 'Internal Access Road';
	let routeType: 'road' | 'cable' | 'fence' = 'road';

	$: if ($activeProject?.id) {
		void refreshRoutes($activeProject.id);
	}

	async function refreshRoutes(projectId: string) {
		loading = true;
		errorMsg = '';
		try {
			const resp = await routingApi.list(projectId);
			routes = (resp.routes ?? []).map((route) => ({
				id: route.id,
				name: route.name,
				type: route.route_type,
				distanceM: route.distance_m,
				cost: route.cost_estimate
			}));
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to load routes';
		} finally {
			loading = false;
		}
	}

	async function createSampleRoute() {
		if (!$activeProject?.id) return;
		creating = true;
		errorMsg = '';
		try {
			const baseLat = $activeProject.initial_latitude || 17.385;
			const baseLon = $activeProject.initial_longitude || 78.4867;
			await routingApi.create({
				project_id: $activeProject.id,
				layout_id: '',
				name: routeName,
				route_type: routeType,
				start: { latitude: baseLat, longitude: baseLon, elevation: 0 },
				end: { latitude: baseLat + 0.002, longitude: baseLon + 0.002, elevation: 0 }
			});
			await refreshRoutes($activeProject.id);
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to create route';
		} finally {
			creating = false;
		}
	}

	async function optimizeAllRoutes() {
		if (!$activeProject?.id) return;
		optimizing = true;
		errorMsg = '';
		try {
			const resp = await routingApi.optimize($activeProject.id);
			routes = (resp.routes ?? []).map((route) => ({
				id: route.id,
				name: route.name,
				type: route.route_type,
				distanceM: route.distance_m,
				cost: route.cost_estimate
			}));
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to optimize routes';
		} finally {
			optimizing = false;
		}
	}
</script>

<div class="routing-panel">
	<h4>Internal Routing</h4>
	<p class="internal-note">
		Within-farm only: use this for site roads, internal cables, and fencing. Use Transmission view for grid interconnect routing.
	</p>
	{#if !$activeProject}
		<p class="empty">Select a project to manage internal farm routes.</p>
	{:else}
		<div class="controls">
			<input bind:value={routeName} placeholder="Route name" />
			<select bind:value={routeType}>
				<option value="road">Access Road (Within Farm)</option>
				<option value="cable">Cable Trench (Within Farm)</option>
				<option value="fence">Fence Alignment (Within Farm)</option>
			</select>
			<button on:click={createSampleRoute} disabled={creating}>
				{creating ? 'Creating...' : 'Create Route'}
			</button>
			<button class="secondary" on:click={optimizeAllRoutes} disabled={optimizing}>
				{optimizing ? 'Optimizing...' : 'Optimize Routes'}
			</button>
		</div>

		{#if errorMsg}
			<p class="error">{errorMsg}</p>
		{/if}

		{#if loading}
			<p class="empty">Loading routes...</p>
		{:else if routes.length === 0}
			<p class="empty">No routes yet.</p>
		{:else}
			<div class="route-list">
				{#each routes as route}
					<div class="route-item">
						<div class="route-name">{route.name}</div>
						<div class="route-meta">{route.type} • {(route.distanceM / 1000).toFixed(2)} km • ${route.cost.toFixed(0)}</div>
					</div>
				{/each}
			</div>
		{/if}
	{/if}
</div>

<style>
	.routing-panel { display: flex; flex-direction: column; gap: 8px; }
	h4 { margin: 0; font-size: 14px; font-weight: 600; color: #e2e8f0; }
	.internal-note { color: #94a3b8; font-size: 11px; line-height: 1.4; margin: 0; }
	.controls { display: flex; flex-direction: column; gap: 6px; }
	input, select { padding: 6px 8px; border: 1px solid rgba(255,255,255,.16); border-radius: 4px; background: rgba(0,0,0,.25); color: #e2e8f0; font-size: 12px; }
	button { padding: 8px; border: none; border-radius: 6px; background: linear-gradient(135deg,#10b981,#059669); color: #fff; font-size: 12px; font-weight: 600; cursor: pointer; }
	button.secondary { background: rgba(255,255,255,.08); border: 1px solid rgba(255,255,255,.16); }
	button:disabled { opacity: .6; cursor: not-allowed; }
	.route-list { display: flex; flex-direction: column; gap: 6px; }
	.route-item { padding: 8px; border-radius: 6px; border: 1px solid rgba(255,255,255,.08); background: rgba(255,255,255,.04); }
	.route-name { font-size: 12px; color: #e2e8f0; font-weight: 600; }
	.route-meta { font-size: 11px; color: #94a3b8; }
	.empty { color: #64748b; font-size: 12px; margin: 0; }
	.error { color: #f87171; font-size: 12px; margin: 0; }
</style>
