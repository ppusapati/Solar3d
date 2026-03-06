<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import { camera, isMapReady, viewport } from '$lib/core/stores';

	let container: HTMLDivElement;
	let viewer: any;

	onMount(async () => {
		const Cesium = await import('cesium');

		viewer = new Cesium.Viewer(container, {
			terrain: Cesium.Terrain.fromWorldTerrain(),
			baseLayerPicker: false,
			geocoder: false,
			homeButton: false,
			sceneModePicker: false,
			navigationHelpButton: false,
			animation: false,
			timeline: false,
			fullscreenButton: false,
			selectionIndicator: true,
			infoBox: false
		});

		// Set initial camera position
		viewer.camera.setView({
			destination: Cesium.Cartesian3.fromDegrees(
				$camera.longitude,
				$camera.latitude,
				$camera.height
			),
			orientation: {
				heading: Cesium.Math.toRadians($camera.heading),
				pitch: Cesium.Math.toRadians($camera.pitch),
				roll: 0
			}
		});

		// Update stores on camera move
		viewer.camera.changed.addEventListener(() => {
			const cartographic = viewer.camera.positionCartographic;
			camera.set({
				longitude: Cesium.Math.toDegrees(cartographic.longitude),
				latitude: Cesium.Math.toDegrees(cartographic.latitude),
				height: cartographic.height,
				heading: Cesium.Math.toDegrees(viewer.camera.heading),
				pitch: Cesium.Math.toDegrees(viewer.camera.pitch),
				roll: 0
			});

			// Update viewport bounds
			const rect = viewer.camera.computeViewRectangle();
			if (rect) {
				viewport.set({
					west: Cesium.Math.toDegrees(rect.west),
					south: Cesium.Math.toDegrees(rect.south),
					east: Cesium.Math.toDegrees(rect.east),
					north: Cesium.Math.toDegrees(rect.north)
				});
			}
		});

		isMapReady.set(true);
	});

	onDestroy(() => {
		if (viewer) {
			viewer.destroy();
		}
	});

	export function getViewer() {
		return viewer;
	}

	export function flyTo(longitude: number, latitude: number, height: number = 5000) {
		if (!viewer) return;
		import('cesium').then((Cesium) => {
			viewer.camera.flyTo({
				destination: Cesium.Cartesian3.fromDegrees(longitude, latitude, height),
				duration: 2
			});
		});
	}
</script>

<div bind:this={container} class="cesium-container"></div>

<style>
	.cesium-container {
		width: 100%;
		height: 100%;
		position: absolute;
		top: 0;
		left: 0;
	}
</style>
