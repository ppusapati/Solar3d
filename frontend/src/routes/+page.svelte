<script lang="ts">
	import TopBar from '$lib/components/TopBar.svelte';
	import Toolbar from '$lib/components/Toolbar.svelte';
	import InspectorPanel from '$lib/components/InspectorPanel.svelte';
	import CesiumViewer from '$lib/modules/map/CesiumViewer.svelte';
	import DrawingManager from '$lib/modules/map/DrawingManager.svelte';
	import PanelRenderer from '$lib/modules/map/PanelRenderer.svelte';
	import ShadowRenderer from '$lib/modules/map/ShadowRenderer.svelte';
	import ComponentRenderer from '$lib/modules/map/ComponentRenderer.svelte';
	import {
		isMapReady,
		activeLayout,
		layerVisibility,
		camera,
		isGenerating,
		activeTool
	} from '$lib/core/stores';
	import { layoutApi, type PanelArrayParams } from '$lib/core/api';
	import { loadTilesForViewport } from '$lib/core/stores';

	let cesiumViewer: CesiumViewer;
	let viewer: any;
	let fillAreaGeoJson = '';
	let showShadows = false;

	$: if ($isMapReady && cesiumViewer) {
		viewer = cesiumViewer.getViewer();
	}

	function handleBoundaryComplete(e: CustomEvent<{ positions: { longitude: number; latitude: number }[] }>) {
		const coords = e.detail.positions.map((p: any) => [p.longitude, p.latitude]);
		coords.push(coords[0]);
		console.log('Site boundary:', JSON.stringify({ type: 'Polygon', coordinates: [coords] }));
	}

	function handleAreaComplete(e: CustomEvent<{ positions: { longitude: number; latitude: number }[] }>) {
		const coords = e.detail.positions.map((p: any) => [p.longitude, p.latitude]);
		coords.push(coords[0]);
		fillAreaGeoJson = JSON.stringify({ type: 'Polygon', coordinates: [coords] });
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
</script>

<svelte:head>
	<title>Solar3D - Solar EPC Design Platform</title>
</svelte:head>

<div class="app-container">
	<TopBar />

	<div class="main-content">
		<div class="toolbar-container">
			<Toolbar />
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
			{/if}
		</div>

		<InspectorPanel
			{fillAreaGeoJson}
			on:generate={handleGenerate}
			on:timeChange={handleTimeChange}
			on:toggleShadows={handleToggleShadows}
		/>
	</div>
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
</style>
