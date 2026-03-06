<script lang="ts">
	import { onMount, onDestroy, createEventDispatcher } from 'svelte';
	import { activeTool } from '$lib/core/stores';

	export let viewer: any;

	const dispatch = createEventDispatcher<{
		boundaryComplete: { positions: { longitude: number; latitude: number }[] };
		areaComplete: { positions: { longitude: number; latitude: number }[] };
		measureComplete: { distance: number };
		componentPlace: { longitude: number; latitude: number };
	}>();

	let Cesium: any;
	let handler: any;
	let drawingPositions: any[] = [];
	let drawingEntities: any[] = [];
	let activePolyline: any = null;
	let activePolygon: any = null;
	let measureLabel: any = null;

	onMount(async () => {
		Cesium = await import('cesium');
		setupHandler();
	});

	onDestroy(() => {
		cleanupDrawing();
		if (handler) {
			handler.destroy();
		}
	});

	function setupHandler() {
		if (!viewer || !Cesium) return;

		handler = new Cesium.ScreenSpaceEventHandler(viewer.scene.canvas);

		// Left click
		handler.setInputAction((event: any) => {
			const tool = getCurrentTool();
			if (tool === 'select') {
				handleSelect(event.position);
			} else if (tool === 'draw-boundary' || tool === 'draw-area') {
				handleDrawClick(event.position);
			} else if (tool === 'measure') {
				handleMeasureClick(event.position);
			} else if (tool === 'place-component') {
				handlePlaceClick(event.position);
			}
		}, Cesium.ScreenSpaceEventType.LEFT_CLICK);

		// Mouse move for drawing preview
		handler.setInputAction((event: any) => {
			const tool = getCurrentTool();
			if ((tool === 'draw-boundary' || tool === 'draw-area' || tool === 'measure') && drawingPositions.length > 0) {
				handleDrawMove(event.endPosition);
			}
		}, Cesium.ScreenSpaceEventType.MOUSE_MOVE);

		// Double click to finish
		handler.setInputAction((event: any) => {
			const tool = getCurrentTool();
			if (tool === 'draw-boundary' || tool === 'draw-area') {
				finishDrawing();
			} else if (tool === 'measure') {
				finishMeasure();
			}
		}, Cesium.ScreenSpaceEventType.LEFT_DOUBLE_CLICK);

		// Right click to cancel
		handler.setInputAction(() => {
			cleanupDrawing();
		}, Cesium.ScreenSpaceEventType.RIGHT_CLICK);
	}

	let currentTool = 'select';
	$: currentTool = $activeTool;

	function getCurrentTool(): string {
		return currentTool;
	}

	function pickPosition(screenPos: any): any | null {
		const ray = viewer.camera.getPickRay(screenPos);
		if (!ray) return null;
		return viewer.scene.globe.pick(ray, viewer.scene);
	}

	function cartesianToLonLat(cartesian: any): { longitude: number; latitude: number } {
		const carto = Cesium.Cartographic.fromCartesian(cartesian);
		return {
			longitude: Cesium.Math.toDegrees(carto.longitude),
			latitude: Cesium.Math.toDegrees(carto.latitude)
		};
	}

	function handleSelect(screenPos: any) {
		const picked = viewer.scene.pick(screenPos);
		if (Cesium.defined(picked) && picked.id) {
			dispatch('componentPlace', { longitude: 0, latitude: 0 }); // selection event
		}
	}

	function handleDrawClick(screenPos: any) {
		const position = pickPosition(screenPos);
		if (!position) return;

		drawingPositions.push(position);

		// Add point marker
		const entity = viewer.entities.add({
			position,
			point: {
				pixelSize: 8,
				color: Cesium.Color.fromCssColorString('#f59e0b'),
				outlineColor: Cesium.Color.WHITE,
				outlineWidth: 2,
				heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
				disableDepthTestDistance: Number.POSITIVE_INFINITY
			}
		});
		drawingEntities.push(entity);

		// Create or update polyline
		if (drawingPositions.length >= 2) {
			if (activePolyline) {
				viewer.entities.remove(activePolyline);
			}
			activePolyline = viewer.entities.add({
				polyline: {
					positions: new Cesium.CallbackProperty(() => {
						return [...drawingPositions];
					}, false),
					width: 3,
					material: new Cesium.ColorMaterialProperty(
						Cesium.Color.fromCssColorString('#f59e0b').withAlpha(0.8)
					),
					clampToGround: true
				}
			});
		}

		// Create fill polygon preview
		if (drawingPositions.length >= 3) {
			if (activePolygon) {
				viewer.entities.remove(activePolygon);
			}
			activePolygon = viewer.entities.add({
				polygon: {
					hierarchy: new Cesium.CallbackProperty(() => {
						return new Cesium.PolygonHierarchy([...drawingPositions]);
					}, false),
					material: Cesium.Color.fromCssColorString('#f59e0b').withAlpha(0.15),
					outline: false,
					classificationType: Cesium.ClassificationType.TERRAIN
				}
			});
		}
	}

	function handleDrawMove(screenPos: any) {
		// Preview: update the last position for live feedback
		const position = pickPosition(screenPos);
		if (!position || drawingPositions.length === 0) return;

		// Temporarily add preview position for polyline
		if (activePolyline) {
			activePolyline.polyline.positions = new Cesium.CallbackProperty(() => {
				return [...drawingPositions, position];
			}, false);
		}
	}

	function handleMeasureClick(screenPos: any) {
		const position = pickPosition(screenPos);
		if (!position) return;

		drawingPositions.push(position);

		const entity = viewer.entities.add({
			position,
			point: {
				pixelSize: 8,
				color: Cesium.Color.fromCssColorString('#3b82f6'),
				outlineColor: Cesium.Color.WHITE,
				outlineWidth: 2,
				heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
				disableDepthTestDistance: Number.POSITIVE_INFINITY
			}
		});
		drawingEntities.push(entity);

		if (drawingPositions.length >= 2) {
			if (activePolyline) viewer.entities.remove(activePolyline);
			activePolyline = viewer.entities.add({
				polyline: {
					positions: [...drawingPositions],
					width: 3,
					material: new Cesium.PolylineDashMaterialProperty({
						color: Cesium.Color.fromCssColorString('#3b82f6')
					}),
					clampToGround: true
				}
			});

			// Show distance label
			const totalDist = calculateTotalDistance();
			if (measureLabel) viewer.entities.remove(measureLabel);
			const midIdx = Math.floor(drawingPositions.length / 2);
			measureLabel = viewer.entities.add({
				position: drawingPositions[midIdx],
				label: {
					text: formatDistance(totalDist),
					font: '14px sans-serif',
					fillColor: Cesium.Color.WHITE,
					outlineColor: Cesium.Color.BLACK,
					outlineWidth: 2,
					style: Cesium.LabelStyle.FILL_AND_OUTLINE,
					verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
					pixelOffset: new Cesium.Cartesian2(0, -15),
					heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
					disableDepthTestDistance: Number.POSITIVE_INFINITY
				}
			});
			drawingEntities.push(measureLabel);
		}
	}

	function handlePlaceClick(screenPos: any) {
		const position = pickPosition(screenPos);
		if (!position) return;
		const lonLat = cartesianToLonLat(position);
		dispatch('componentPlace', lonLat);
	}

	function finishDrawing() {
		if (drawingPositions.length < 3) return;

		const positions = drawingPositions.map(cartesianToLonLat);
		const tool = getCurrentTool();

		if (tool === 'draw-boundary') {
			dispatch('boundaryComplete', { positions });
		} else if (tool === 'draw-area') {
			dispatch('areaComplete', { positions });
		}

		// Keep the polygon visible but clean up drawing state
		const finalPositions = [...drawingPositions];
		cleanupDrawing();

		// Add permanent polygon
		viewer.entities.add({
			polygon: {
				hierarchy: new Cesium.PolygonHierarchy(finalPositions),
				material: tool === 'draw-boundary'
					? Cesium.Color.fromCssColorString('#f59e0b').withAlpha(0.1)
					: Cesium.Color.fromCssColorString('#22c55e').withAlpha(0.15),
				outline: true,
				outlineColor: tool === 'draw-boundary'
					? Cesium.Color.fromCssColorString('#f59e0b')
					: Cesium.Color.fromCssColorString('#22c55e'),
				outlineWidth: 2,
				classificationType: Cesium.ClassificationType.TERRAIN
			}
		});

		activeTool.set('select');
	}

	function finishMeasure() {
		if (drawingPositions.length < 2) return;
		const totalDist = calculateTotalDistance();
		dispatch('measureComplete', { distance: totalDist });
		// Keep measure visible, reset drawing state
		drawingPositions = [];
		activeTool.set('select');
	}

	function calculateTotalDistance(): number {
		let total = 0;
		for (let i = 1; i < drawingPositions.length; i++) {
			const geodesic = new Cesium.EllipsoidGeodesic(
				Cesium.Cartographic.fromCartesian(drawingPositions[i - 1]),
				Cesium.Cartographic.fromCartesian(drawingPositions[i])
			);
			total += geodesic.surfaceDistance;
		}
		return total;
	}

	function formatDistance(meters: number): string {
		if (meters >= 1000) {
			return `${(meters / 1000).toFixed(2)} km`;
		}
		return `${meters.toFixed(1)} m`;
	}

	function cleanupDrawing() {
		drawingEntities.forEach((e) => {
			if (viewer.entities.contains(e)) viewer.entities.remove(e);
		});
		drawingEntities = [];
		if (activePolyline && viewer.entities.contains(activePolyline)) {
			viewer.entities.remove(activePolyline);
		}
		if (activePolygon && viewer.entities.contains(activePolygon)) {
			viewer.entities.remove(activePolygon);
		}
		if (measureLabel && viewer.entities.contains(measureLabel)) {
			viewer.entities.remove(measureLabel);
		}
		activePolyline = null;
		activePolygon = null;
		measureLabel = null;
		drawingPositions = [];
	}

	export function clearAll() {
		cleanupDrawing();
		viewer.entities.removeAll();
	}
</script>

<div class="drawing-hint">
	{#if $activeTool === 'draw-boundary'}
		<span>Click to draw boundary. Double-click to finish. Right-click to cancel.</span>
	{:else if $activeTool === 'draw-area'}
		<span>Click to draw panel area. Double-click to finish. Right-click to cancel.</span>
	{:else if $activeTool === 'measure'}
		<span>Click points to measure. Double-click to finish.</span>
	{:else if $activeTool === 'place-component'}
		<span>Click on the map to place a component.</span>
	{/if}
</div>

<style>
	.drawing-hint {
		position: absolute;
		bottom: 24px;
		left: 50%;
		transform: translateX(-50%);
		z-index: 60;
	}

	.drawing-hint span {
		background: rgba(22, 33, 62, 0.9);
		color: #e2e8f0;
		padding: 8px 16px;
		border-radius: 6px;
		font-size: 13px;
		backdrop-filter: blur(8px);
		border: 1px solid rgba(255, 255, 255, 0.1);
	}
</style>
