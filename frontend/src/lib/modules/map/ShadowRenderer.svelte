<script lang="ts">
	import { onDestroy } from 'svelte';
	import { simulationApi, type ShadowPolygon } from '$lib/core/api';

	export let viewer: any;
	export let visible: boolean = false;
	export let layoutId: string = '';
	export let latitude: number = 35;
	export let longitude: number = -120;

	let Cesium: any;
	let shadowEntities: any[] = [];
	let currentTimestamp: string = new Date().toISOString();
	let sunEntity: any = null;

	import('cesium').then((mod) => {
		Cesium = mod;
	});

	$: if (visible && layoutId && Cesium && viewer) {
		loadShadows(currentTimestamp);
	}

	$: if (!visible) {
		clearShadows();
	}

	export async function setTime(timestamp: string) {
		currentTimestamp = timestamp;
		if (visible && layoutId) {
			await loadShadows(timestamp);
		}
	}

	async function loadShadows(timestamp: string) {
		if (!Cesium || !viewer || !layoutId) return;

		clearShadows();

		try {
			const response = await simulationApi.getShadowMap(layoutId, timestamp, latitude, longitude);
			const shadows = response.shadows || [];
			const sunPos = response.sun_position;

			renderShadows(shadows);
			renderSunIndicator(sunPos);
		} catch (err) {
			console.error('Failed to load shadows:', err);
		}
	}

	function renderShadows(shadows: ShadowPolygon[]) {
		for (const shadow of shadows) {
			try {
				const geojson = JSON.parse(shadow.shadow_geojson);
				if (!geojson.coordinates || !geojson.coordinates[0]) continue;

				const coords = geojson.coordinates[0];
				const positions = coords.map((c: number[]) =>
					Cesium.Cartesian3.fromDegrees(c[0], c[1])
				);

				const entity = viewer.entities.add({
					polygon: {
						hierarchy: new Cesium.PolygonHierarchy(positions),
						material: Cesium.Color.BLACK.withAlpha(shadow.shadow_intensity * 0.4),
						classificationType: Cesium.ClassificationType.TERRAIN
					}
				});

				shadowEntities.push(entity);
			} catch (err) {
				// Skip invalid shadow geometry
			}
		}
	}

	function renderSunIndicator(sunPos: { azimuth: number; elevation: number }) {
		if (!sunPos || sunPos.elevation < 0) return;

		// No 3D sun entity needed - just a UI indicator would suffice
	}

	function clearShadows() {
		shadowEntities.forEach((e) => {
			if (viewer?.entities?.contains(e)) viewer.entities.remove(e);
		});
		shadowEntities = [];
		if (sunEntity && viewer?.entities?.contains(sunEntity)) {
			viewer.entities.remove(sunEntity);
			sunEntity = null;
		}
	}

	onDestroy(() => {
		clearShadows();
	});
</script>
