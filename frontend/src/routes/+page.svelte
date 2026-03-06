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
	import TiltedPanelRenderer from '$lib/modules/map/TiltedPanelRenderer.svelte';
	import TerrainHeatmap from '$lib/modules/map/TerrainHeatmap.svelte';
	import DragDropHandler from '$lib/modules/map/DragDropHandler.svelte';
	import ProjectDashboard from '$lib/components/ProjectDashboard.svelte';
	import MapSearch from '$lib/components/MapSearch.svelte';
	import StatusBar from '$lib/components/StatusBar.svelte';
	import ToastNotification from '$lib/components/ToastNotification.svelte';
	import KeyboardShortcuts from '$lib/components/KeyboardShortcuts.svelte';
	import Minimap from '$lib/components/Minimap.svelte';
	import CursorOverlay from '$lib/modules/map/CursorOverlay.svelte';
	import SnapGrid from '$lib/modules/map/SnapGrid.svelte';
	import {
		isMapReady,
		activeLayout,
		activeProject,
		layerVisibility,
		camera,
		isGenerating,
		activeTool,
		activeView,
		selectedEntityId,
		undo,
		redo,
		canUndo,
		canRedo,
		pushAction,
		toast,
		addEntity,
		removeEntity,
		getEntity,
		entities,
		type MapEntity
	} from '$lib/core/stores';
	import { layoutApi, type PanelArrayParams } from '$lib/core/api';
	import { loadTilesForViewport, visibleTiles } from '$lib/core/stores';

	let use3DPanels = true;
	let showTerrainHeatmap = false;
	let terrainHeatmapMode: 'elevation' | 'slope' | 'aspect' = 'elevation';
	let showShortcuts = false;

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
			// Skip if user is typing in an input
			const tag = (e.target as HTMLElement)?.tagName;
			if (tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT') return;

			// Undo/Redo
			if ((e.metaKey || e.ctrlKey) && e.key === 'z' && !e.shiftKey) {
				e.preventDefault();
				undo();
				return;
			}
			if ((e.metaKey || e.ctrlKey) && (e.key === 'y' || (e.key === 'z' && e.shiftKey))) {
				e.preventDefault();
				redo();
				return;
			}

			// Tool shortcuts
			switch (e.key.toLowerCase()) {
				case 'v': activeTool.set('select'); break;
				case 'h': activeTool.set('pan'); break;
				case 'b': activeTool.set('draw-boundary'); break;
				case 'a': activeTool.set('draw-area'); break;
				case 'p': activeTool.set('place-component'); break;
				case 'm': activeTool.set('measure'); break;
				// View shortcuts
				case '1': activeView.set('design'); break;
				case '2': activeView.set('simulate'); break;
				case '3': activeView.set('electrical'); break;
				case '4': activeView.set('reports'); break;
				case '5': activeView.set('financial'); break;
				// Help
				case '?': showShortcuts = !showShortcuts; break;
				// Escape
				case 'escape':
					selectedEntityId.set(null);
					activeTool.set('select');
					showShortcuts = false;
					break;
				// Delete
				case 'delete':
					if ($selectedEntityId) {
						const entityToDelete = getEntity($selectedEntityId);
						if (entityToDelete) {
							const removed = removeEntity($selectedEntityId);
							if (removed) {
								removeCesiumEntities(removed.cesiumEntityIds);
								pushAction({
									type: 'delete-entity',
									description: `Delete ${removed.type}`,
									undo: () => {
										addEntity(removed.type, removed.geojson, removed.cesiumEntityIds, removed.properties);
									},
									redo: () => {
										const re = removeEntity(removed.id);
										if (re) removeCesiumEntities(re.cesiumEntityIds);
									}
								});
								toast.success(`Deleted ${removed.type}`);
							}
						}
						selectedEntityId.set(null);
					}
					break;
				// Focus on selection
				case 'f':
					if ($selectedEntityId && cesiumViewer) {
						cesiumViewer.flyTo($camera.longitude, $camera.latitude);
					}
					break;
			}
		}
		window.addEventListener('keydown', handleKeyboard);
		return () => window.removeEventListener('keydown', handleKeyboard);
	});

	function removeCesiumEntities(cesiumIds: string[]) {
		if (!viewer) return;
		for (const cid of cesiumIds) {
			const entity = viewer.entities.getById(cid);
			if (entity) viewer.entities.remove(entity);
		}
	}

	function handleBoundaryComplete(e: CustomEvent<{ positions: { longitude: number; latitude: number }[] }>) {
		const coords = e.detail.positions.map((p: any) => [p.longitude, p.latitude]);
		coords.push(coords[0]);
		const geojson = JSON.stringify({ type: 'Polygon', coordinates: [coords] });

		const cesiumIds: string[] = [];
		if (viewer) {
			// The DrawingManager already added entities to the viewer;
			// capture IDs of the most recently added entities for tracking
			const allEntities = viewer.entities.values;
			if (allEntities.length > 0) {
				const lastEntity = allEntities[allEntities.length - 1];
				if (lastEntity?.id) cesiumIds.push(lastEntity.id);
			}
		}

		const entityId = addEntity('boundary', geojson, cesiumIds);

		pushAction({
			type: 'draw-boundary',
			description: 'Draw site boundary',
			undo: () => {
				const removed = removeEntity(entityId);
				if (removed) removeCesiumEntities(removed.cesiumEntityIds);
			},
			redo: () => {
				addEntity('boundary', geojson, cesiumIds);
			}
		});
		toast.success('Site boundary drawn');
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
		toast.success('Panel area selected - configure and generate in the Properties panel');
	}

	function handleMeasureComplete(e: CustomEvent<{ distance: number }>) {
		const dist = e.detail.distance;
		const label = dist >= 1000
			? `${(dist / 1000).toFixed(2)} km`
			: `${dist.toFixed(1)} m`;
		addEntity('measurement', '', [], { distance: dist });
		toast.info(`Measured distance: ${label}`);
	}

	function handleComponentPlace(e: CustomEvent<{ longitude: number; latitude: number }>) {
		const { longitude, latitude } = e.detail;
		const geojson = JSON.stringify({ type: 'Point', coordinates: [longitude, latitude] });
		const entityId = addEntity('component', geojson, [], { longitude, latitude });

		pushAction({
			type: 'place-component',
			description: 'Place component',
			undo: () => {
				const removed = removeEntity(entityId);
				if (removed) removeCesiumEntities(removed.cesiumEntityIds);
			},
			redo: () => {
				addEntity('component', geojson, [], { longitude, latitude });
			}
		});
		toast.info(`Component placed at ${latitude.toFixed(4)}, ${longitude.toFixed(4)}`);
	}

	function handleDrop(e: CustomEvent<{ type: string; name: string; longitude: number; latitude: number }>) {
		const { type, name, longitude, latitude } = e.detail;
		const geojson = JSON.stringify({ type: 'Point', coordinates: [longitude, latitude] });
		const entityId = addEntity('component', geojson, [], { type, name, longitude, latitude });

		pushAction({
			type: 'place-component',
			description: `Place ${name}`,
			undo: () => {
				const removed = removeEntity(entityId);
				if (removed) removeCesiumEntities(removed.cesiumEntityIds);
			},
			redo: () => {
				addEntity('component', geojson, [], { type, name, longitude, latitude });
			}
		});
		toast.success(`Placed ${name} at ${latitude.toFixed(4)}, ${longitude.toFixed(4)}`);
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

			const savedTiles = [...($visibleTiles || [])];
			pushAction({
				type: 'generate-array',
				description: 'Generate panel array',
				undo: () => {
					visibleTiles.set([]);
				},
				redo: () => {
					visibleTiles.set(savedTiles);
				}
			});
			toast.success('Panel array generated successfully');
		} catch (err) {
			console.error('Panel generation failed:', err);
			toast.error('Panel generation failed. Check console for details.');
		} finally {
			isGenerating.set(false);
		}
	}

	function handleToggleShadows(e: CustomEvent<boolean>) {
		showShadows = e.detail;
	}

	let shadowTime: string = new Date().toISOString();
	let shadowRenderer: ShadowRenderer;

	function handleTimeChange(e: CustomEvent<string>) {
		shadowTime = e.detail;
		if (shadowRenderer) {
			shadowRenderer.setTime(shadowTime);
		}
	}

	function handleFlyTo(e: CustomEvent<{ longitude: number; latitude: number; name: string }>) {
		if (cesiumViewer) {
			cesiumViewer.flyTo(e.detail.longitude, e.detail.latitude);
		}
	}

	function handleOpenProject() {
		showDashboard = false;
	}

	function handleMinimapNavigate(e: CustomEvent<{ longitude: number; latitude: number }>) {
		if (cesiumViewer) {
			cesiumViewer.flyTo(e.detail.longitude, e.detail.latitude);
		}
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
			<DragDropHandler {viewer} on:drop={handleDrop}>
				<CesiumViewer bind:this={cesiumViewer} />
			</DragDropHandler>

			{#if viewer}
				<DrawingManager
					{viewer}
					on:boundaryComplete={handleBoundaryComplete}
					on:areaComplete={handleAreaComplete}
					on:measureComplete={handleMeasureComplete}
					on:componentPlace={handleComponentPlace}
				/>

				{#if use3DPanels}
					<TiltedPanelRenderer {viewer} visible={$layerVisibility.panels} show3D={true} />
				{:else}
					<PanelRenderer {viewer} visible={$layerVisibility.panels} />
				{/if}

				<ShadowRenderer
					bind:this={shadowRenderer}
					{viewer}
					visible={showShadows && $layerVisibility.shadows}
					layoutId={$activeLayout?.id ?? ''}
					latitude={$camera.latitude}
					longitude={$camera.longitude}
				/>

				<ComponentRenderer {viewer} visible={true} />
				<RouteRenderer {viewer} visible={$layerVisibility.cables} />
				<TerrainHeatmap
					{viewer}
					visible={showTerrainHeatmap}
					projectId={$activeProject?.id ?? ''}
					mode={terrainHeatmapMode}
				/>
				<CursorOverlay {viewer} />
				<SnapGrid {viewer} />
			{/if}

			<div class="minimap-wrapper">
				<Minimap on:navigate={handleMinimapNavigate} />
			</div>
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

<ToastNotification />
<KeyboardShortcuts bind:open={showShortcuts} />

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

	.minimap-wrapper {
		position: absolute;
		bottom: 48px;
		right: 12px;
		z-index: 40;
	}
</style>
