<script lang="ts">
	import { onMount } from 'svelte';
	import TopBar from '$lib/components/TopBar.svelte';
	import Toolbar from '$lib/components/Toolbar.svelte';
	import InspectorPanel from '$lib/components/InspectorPanel.svelte';
	import CesiumViewer from '$lib/modules/map/CesiumViewer.svelte';
	import DrawingManager from '$lib/modules/map/DrawingManager.svelte';
	import PanelRenderer from '$lib/modules/map/PanelRenderer.svelte';
	import ShadowRenderer from '$lib/modules/map/ShadowRenderer.svelte';
	import ComponentRenderer from '$lib/modules/map/ComponentRenderer.svelte';
	import RouteRenderer from '$lib/modules/map/RouteRenderer.svelte';
	import ProjectDashboard from '$lib/components/ProjectDashboard.svelte';
	import MapSearch from '$lib/components/MapSearch.svelte';
	import StatusBar from '$lib/components/StatusBar.svelte';
	import {
		isMapReady,
		activeLayout,
		activeProject,
		layerVisibility,
		camera,
		isGenerating,
		activeTool,
		undo,
		redo,
		canUndo,
		canRedo,
		pushAction
	} from '$lib/core/stores';
	import { layoutApi, type PanelArrayParams } from '$lib/core/api';
	import { loadTilesForViewport } from '$lib/core/stores';

	let cesiumViewer: CesiumViewer;
	let viewer: any;
	let fillAreaGeoJson = '';
	let showShadows = false;
	let showDashboard = true;

	$: if ($isMapReady && cesiumViewer) {
		viewer = cesiumViewer.getViewer();
	}

	// Show dashboard if no project is loaded
	$: if ($activeProject) {
		showDashboard = false;
	}

	// Keyboard shortcuts
	onMount(() => {
		function handleKeyboard(e: KeyboardEvent) {
			if ((e.metaKey || e.ctrlKey) && e.key === 'z' && !e.shiftKey) {
				e.preventDefault();
				undo();
			} else if ((e.metaKey || e.ctrlKey) && (e.key === 'y' || (e.key === 'z' && e.shiftKey))) {
				e.preventDefault();
				redo();
			}
		}
		window.addEventListener('keydown', handleKeyboard);
		return () => window.removeEventListener('keydown', handleKeyboard);
	});

	function handleBoundaryComplete(e: CustomEvent<{ positions: { longitude: number; latitude: number }[] }>) {
		const coords = e.detail.positions.map((p: any) => [p.longitude, p.latitude]);
		coords.push(coords[0]);
		const geojson = JSON.stringify({ type: 'Polygon', coordinates: [coords] });

		pushAction({
			type: 'draw-boundary',
			description: 'Draw site boundary',
			undo: () => { /* would remove the boundary entity */ },
			redo: () => { /* would re-add it */ }
		});
	}

	function handleAreaComplete(e: CustomEvent<{ positions: { longitude: number; latitude: number }[] }>) {
		const coords = e.detail.positions.map((p: any) => [p.longitude, p.latitude]);
		coords.push(coords[0]);
		fillAreaGeoJson = JSON.stringify({ type: 'Polygon', coordinates: [coords] });

		pushAction({
			type: 'draw-area',
			description: 'Draw panel area',
			undo: () => { fillAreaGeoJson = ''; },
			redo: () => { fillAreaGeoJson = JSON.stringify({ type: 'Polygon', coordinates: [coords] }); }
		});
	}

	function handleMeasureComplete(e: CustomEvent<{ distance: number }>) {
		console.log('Distance:', e.detail.distance, 'm');
	}

	function handleComponentPlace(e: CustomEvent<{ longitude: number; latitude: number }>) {
		console.log('Place component at:', e.detail);
	}

	async function handleGenerate(e: CustomEvent<PanelArrayParams>) {
		const layout = $activeLayout;
		if (!layout) return;

		isGenerating.set(true);
		try {
			await layoutApi.generatePanelArray(layout.id, e.detail);
			const cam = $camera;
			await loadTilesForViewport(layout.id, cam.longitude - 0.01, cam.latitude - 0.01, cam.longitude + 0.01, cam.latitude + 0.01, 0);
			activeTool.set('select');

			pushAction({
				type: 'generate-array',
				description: `Generate panel array`,
				undo: () => { /* would delete the generated panels */ },
				redo: () => { /* would regenerate */ }
			});
		} catch (err) {
			console.error('Panel generation failed:', err);
		} finally {
			isGenerating.set(false);
		}
	}

	function handleToggleShadows(e: CustomEvent<boolean>) {
		showShadows = e.detail;
	}

	function handleTimeChange(e: CustomEvent<string>) {
		// Shadow time change handled by ShadowRenderer props
	}

	function handleFlyTo(e: CustomEvent<{ longitude: number; latitude: number; name: string }>) {
		if (cesiumViewer) {
			cesiumViewer.flyTo(e.detail.longitude, e.detail.latitude);
		}
	}

	function handleOpenProject() {
		showDashboard = false;
	}
</script>

<svelte:head>
	<title>Solar3D - Solar EPC Design Platform</title>
</svelte:head>

<ProjectDashboard
	open={showDashboard}
	on:openProject={handleOpenProject}
	on:close={() => { showDashboard = false; }}
/>

<div class="app-container">
	<TopBar />

	<div class="main-content">
		<div class="toolbar-container">
			<Toolbar />
			{#if $canUndo || $canRedo}
				<div class="undo-redo">
					<button class="ur-btn" disabled={!$canUndo} on:click={() => undo()} title="Undo (Ctrl+Z)">U</button>
					<button class="ur-btn" disabled={!$canRedo} on:click={() => redo()} title="Redo (Ctrl+Y)">R</button>
				</div>
			{/if}
		</div>

		<div class="search-container">
			<MapSearch on:flyTo={handleFlyTo} />
		</div>

		<div class="map-container">
			<CesiumViewer bind:this={cesiumViewer} />

			{#if viewer}
				<DrawingManager
					{viewer}
					on:boundaryComplete={handleBoundaryComplete}
					on:areaComplete={handleAreaComplete}
					on:measureComplete={handleMeasureComplete}
					on:componentPlace={handleComponentPlace}
				/>

				<PanelRenderer {viewer} visible={$layerVisibility.panels} />

				<ShadowRenderer
					{viewer}
					visible={showShadows && $layerVisibility.shadows}
					layoutId={$activeLayout?.id ?? ''}
					latitude={$camera.latitude}
					longitude={$camera.longitude}
				/>

				<ComponentRenderer {viewer} visible={true} />
				<RouteRenderer {viewer} visible={$layerVisibility.cables} />
			{/if}
		</div>

		<InspectorPanel
			{fillAreaGeoJson}
			on:generate={handleGenerate}
			on:timeChange={handleTimeChange}
			on:toggleShadows={handleToggleShadows}
		/>
	</div>

	<StatusBar />
</div>

<style>
	.app-container {
		display: flex;
		flex-direction: column;
		height: 100vh;
		width: 100vw;
		overflow: hidden;
	}

	.main-content {
		display: flex;
		flex: 1;
		position: relative;
		overflow: hidden;
	}

	.toolbar-container {
		position: absolute;
		top: 12px;
		left: 12px;
		z-index: 50;
	}

	.map-container {
		flex: 1;
		position: relative;
	}

	.search-container {
		position: absolute;
		top: 12px;
		left: 50%;
		transform: translateX(-50%);
		z-index: 50;
	}

	.undo-redo {
		display: flex;
		gap: 2px;
		margin-top: 4px;
	}

	.ur-btn {
		width: 32px;
		height: 32px;
		border: none;
		border-radius: 6px;
		background: rgba(22, 33, 62, 0.95);
		color: #94a3b8;
		font-size: 12px;
		font-weight: 700;
		cursor: pointer;
		border: 1px solid rgba(255, 255, 255, 0.1);
	}

	.ur-btn:hover:not(:disabled) {
		background: rgba(255, 255, 255, 0.08);
		color: #e2e8f0;
	}

	.ur-btn:disabled {
		opacity: 0.3;
		cursor: not-allowed;
	}
</style>
