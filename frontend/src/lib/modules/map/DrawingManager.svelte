<script lang="ts">
	import { onMount, onDestroy, createEventDispatcher } from 'svelte';
	import { activeTool } from '$lib/core/stores';

	export let viewer: any;

	const dispatch = createEventDispatcher<{
		boundaryComplete: { positions: { longitude: number; latitude: number }[] };
		areaComplete: { positions: { longitude: number; latitude: number }[] };
		exclusionComplete: { positions: { longitude: number; latitude: number }[] };
		roadComplete: { positions: { longitude: number; latitude: number }[] };
		measureComplete: { distance: number };
		dimensionComplete: {
			start: { longitude: number; latitude: number };
			end: { longitude: number; latitude: number };
			distance: number;
		};
		blockInsertPlace: { longitude: number; latitude: number };
		componentPlace: { longitude: number; latitude: number };
		pinPlace: { longitude: number; latitude: number };
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
			} else if (tool === 'draw-boundary' || tool === 'draw-area' || tool === 'draw-exclusion') {
				handleDrawClick(event.position);
			} else if (tool === 'draw-road') {
				handleRoadClick(event.position);
			} else if (tool === 'measure' || tool === 'draw-dimension') {
				handleMeasureClick(event.position);
			} else if (tool === 'place-component') {
				handlePlaceClick(event.position);
			} else if (tool === 'place-pin') {
				handlePinPlaceClick(event.position);
			} else if (tool === 'insert-block') {
				handleBlockInsertClick(event.position);
			}
		}, Cesium.ScreenSpaceEventType.LEFT_CLICK);

		// Mouse move for drawing preview
		handler.setInputAction((event: any) => {
			const tool = getCurrentTool();
			if ((tool === 'draw-boundary' || tool === 'draw-area' || tool === 'draw-exclusion' || tool === 'draw-road' || tool === 'measure' || tool === 'draw-dimension') && drawingPositions.length > 0) {
				handleDrawMove(event.endPosition);
			}
		}, Cesium.ScreenSpaceEventType.MOUSE_MOVE);

		// Double click to finish
		handler.setInputAction((event: any) => {
			const tool = getCurrentTool();
			if (tool === 'draw-boundary' || tool === 'draw-area' || tool === 'draw-exclusion') {
				finishDrawing();
			} else if (tool === 'draw-road') {
				finishRoad();
			} else if (tool === 'measure' || tool === 'draw-dimension') {
				finishMeasure();
			}
		}, Cesium.ScreenSpaceEventType.LEFT_DOUBLE_CLICK);

		// Right click to cancel
		handler.setInputAction(() => {
			cleanupDrawing();
		}, Cesium.ScreenSpaceEventType.RIGHT_CLICK);
	}

	let currentTool = 'select';
	let previewPosition: any = null;

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
			// Selection is handled by renderers/tools; do not emit placement events here.
		}
	}

	function handleDrawClick(screenPos: any) {
		const position = pickPosition(screenPos);
		if (!position) return;

		drawingPositions.push(position);
		const tool = getCurrentTool();
		const dotColor = tool === 'draw-exclusion'
			? '#ef4444'
			: tool === 'draw-area' ? '#22c55e' : '#f59e0b';

		// Add point marker
		const entity = viewer.entities.add({
			position,
			point: {
				pixelSize: 8,
				color: Cesium.Color.fromCssColorString(dotColor),
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
					}, true),
					width: 3,
					material: new Cesium.ColorMaterialProperty(
						Cesium.Color.fromCssColorString('#f59e0b').withAlpha(0.8)
					),
					clampToGround: true,
					zIndex: 100,
					disableDepthTestDistance: Number.POSITIVE_INFINITY
				}
			});
			drawingEntities.push(activePolyline);
		}

		// Create fill polygon preview
		if (drawingPositions.length >= 3) {
			const polyColorHex = tool === 'draw-exclusion' ? '#ef4444' : '#22c55e';
			if (activePolygon) {
				viewer.entities.remove(activePolygon);
			}
			activePolygon = viewer.entities.add({
				polygon: {
					hierarchy: new Cesium.CallbackProperty(() => {
						if (drawingPositions.length >= 3) {
							return new Cesium.PolygonHierarchy([...drawingPositions]);
						}
						return null;
					}, true),
					material: Cesium.Color.fromCssColorString(polyColorHex).withAlpha(0.15),
					outline: true,
					outlineColor: Cesium.Color.fromCssColorString(polyColorHex).withAlpha(0.8),
					outlineWidth: 2,
					outlinePercentage: 0.5,
					classificationType: Cesium.ClassificationType.TERRAIN,
					disableDepthTestDistance: Number.POSITIVE_INFINITY
				}
			});
			drawingEntities.push(activePolygon);
		}
	}

	let roadDrawingPositions: any[] = [];
	let roadDrawingEntities: any[] = [];
	let activeRoadPolyline: any = null;

	function handleRoadClick(screenPos: any) {
		const position = pickPosition(screenPos);
		if (!position) return;

		roadDrawingPositions.push(position);

		const entity = viewer.entities.add({
			position,
			point: {
				pixelSize: 8,
				color: Cesium.Color.fromCssColorString('#a78bfa'),
				outlineColor: Cesium.Color.WHITE,
				outlineWidth: 2,
				heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
				disableDepthTestDistance: Number.POSITIVE_INFINITY
			}
		});
		roadDrawingEntities.push(entity);

		if (roadDrawingPositions.length >= 2) {
			if (activeRoadPolyline) viewer.entities.remove(activeRoadPolyline);
			activeRoadPolyline = viewer.entities.add({
				polyline: {
					positions: new Cesium.CallbackProperty(() => [...roadDrawingPositions], true),
					width: 5,
					material: new Cesium.PolylineOutlineMaterialProperty({
						color: Cesium.Color.fromCssColorString('#a78bfa').withAlpha(0.9),
						outlineColor: Cesium.Color.fromCssColorString('#7c3aed').withAlpha(0.7),
						outlineWidth: 2
					}),
					clampToGround: true,
					disableDepthTestDistance: Number.POSITIVE_INFINITY
				}
			});
			roadDrawingEntities.push(activeRoadPolyline);
		}
	}

	function finishRoad() {
		if (roadDrawingPositions.length < 2) {
			cleanupRoadDrawing();
			return;
		}
		const positions = roadDrawingPositions.map(cartesianToLonLat);
		dispatch('roadComplete', { positions });
		cleanupRoadDrawing();
		activeTool.set('select');
	}

	function cleanupRoadDrawing() {
		roadDrawingPositions = [];
		roadDrawingEntities.forEach((e) => {
			if (viewer && viewer.entities.contains(e)) viewer.entities.remove(e);
		});
		roadDrawingEntities = [];
		if (activeRoadPolyline && viewer && viewer.entities.contains(activeRoadPolyline)) {
			viewer.entities.remove(activeRoadPolyline);
		}
		activeRoadPolyline = null;
	}

	function handleDrawMove(screenPos: any) {
		// Preview: update the preview position for live feedback
		if (!viewer || drawingPositions.length === 0) {
			previewPosition = null;
			return;
		}

		const position = pickPosition(screenPos);
		previewPosition = position;
		
		// Update polyline to show preview with mouse position
		if (activePolyline && position) {
			activePolyline.polyline.positions = new Cesium.CallbackProperty(() => {
				return [...drawingPositions, previewPosition];
			}, true);
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
					clampToGround: true,
					disableDepthTestDistance: Number.POSITIVE_INFINITY
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

	function handlePinPlaceClick(screenPos: any) {
		const position = pickPosition(screenPos);
		if (!position) return;
		const lonLat = cartesianToLonLat(position);
		dispatch('pinPlace', lonLat);
	}

	function handleBlockInsertClick(screenPos: any) {
		const position = pickPosition(screenPos);
		if (!position) return;
		const lonLat = cartesianToLonLat(position);
		dispatch('blockInsertPlace', lonLat);
	}

	function finishDrawing() {
		if (drawingPositions.length < 3) {
			cleanupDrawing();
			return;
		}

		const positions = drawingPositions.map(cartesianToLonLat);
		const tool = getCurrentTool();
		const color = tool === 'draw-boundary' ? '#f59e0b' : '#22c55e';
		const finalPositions = [...drawingPositions];

		const fillColor = tool === 'draw-exclusion' ? '#ef4444' : color;
		// Add permanent polygon
		viewer.entities.add({
			polygon: {
				hierarchy: new Cesium.PolygonHierarchy(finalPositions),
				material: Cesium.Color.fromCssColorString(fillColor).withAlpha(0.2),
				outline: true,
				outlineColor: Cesium.Color.fromCssColorString(fillColor).withAlpha(0.9),
				outlineWidth: 2,
				outlinePercentage: 0.5,
				classificationType: Cesium.ClassificationType.TERRAIN,
				disableDepthTestDistance: Number.POSITIVE_INFINITY
			}
		});

		// Dispatch event
		if (tool === 'draw-boundary') {
			dispatch('boundaryComplete', { positions });
		} else if (tool === 'draw-area') {
			dispatch('areaComplete', { positions });
		} else if (tool === 'draw-exclusion') {
			dispatch('exclusionComplete', { positions });
		}

		cleanupDrawing();
		activeTool.set('select');
	}

	function finishMeasure() {
		if (drawingPositions.length < 2) return;
		const totalDist = calculateTotalDistance();
		const tool = getCurrentTool();
		if (tool === 'draw-dimension') {
			dispatch('dimensionComplete', {
				start: cartesianToLonLat(drawingPositions[0]),
				end: cartesianToLonLat(drawingPositions[drawingPositions.length - 1]),
				distance: totalDist
			});
		} else {
			dispatch('measureComplete', { distance: totalDist });
		}
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
		previewPosition = null;
		drawingPositions = [];
		drawingEntities.forEach((e) => {
			if (viewer && viewer.entities.contains(e)) {
				viewer.entities.remove(e);
			}
		});
		drawingEntities = [];
		if (activePolyline && viewer && viewer.entities.contains(activePolyline)) {
			viewer.entities.remove(activePolyline);
		}
		if (activePolygon && viewer && viewer.entities.contains(activePolygon)) {
			viewer.entities.remove(activePolygon);
		}
		if (measureLabel && viewer && viewer.entities.contains(measureLabel)) {
			viewer.entities.remove(measureLabel);
		}
		activePolyline = null;
		activePolygon = null;
		measureLabel = null;
		cleanupRoadDrawing();
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
		<span>Click to draw solar panel area. Double-click to finish. Right-click to cancel.</span>
	{:else if $activeTool === 'draw-exclusion'}
		<span>Click to draw exclusion zone (lake, obstacle). Double-click to finish. Right-click to cancel.</span>
	{:else if $activeTool === 'draw-road'}
		<span>Click to add road waypoints. Double-click to finish. Right-click to cancel.</span>
	{:else if $activeTool === 'measure'}
		<span>Click points to measure. Double-click to finish.</span>
	{:else if $activeTool === 'draw-dimension'}
		<span>Click two points to place a CAD dimension. Double-click to finish.</span>
	{:else if $activeTool === 'insert-block'}
		<span>Click in the workspace to place a block insertion point.</span>
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
