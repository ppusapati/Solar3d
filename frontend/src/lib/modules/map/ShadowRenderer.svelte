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
		if (!sunPos || sunPos.elevation < 0 || !Cesium || !viewer) return;

		// Remove existing sun entity
		if (sunEntity && viewer.entities.contains(sunEntity)) {
			viewer.entities.remove(sunEntity);
			sunEntity = null;
		}

		// Project sun position to a point offset from the site center
		// The sun indicator is placed at a distance proportional to its elevation
		const azRad = (sunPos.azimuth * Math.PI) / 180;
		const elRad = (sunPos.elevation * Math.PI) / 180;

		// Place sun marker ~500m away in the direction of the sun azimuth
		const dist = 0.005; // ~500m in degrees
		const sunLon = longitude + Math.sin(azRad) * dist;
		const sunLat = latitude + Math.cos(azRad) * dist;
		const sunHeight = Math.tan(elRad) * 500; // Height based on elevation angle

		sunEntity = viewer.entities.add({
			position: Cesium.Cartesian3.fromDegrees(sunLon, sunLat, Math.max(sunHeight, 50)),
			billboard: {
				image: buildSunIcon(),
				width: 24,
				height: 24,
				verticalOrigin: Cesium.VerticalOrigin.CENTER,
				disableDepthTestDistance: Number.POSITIVE_INFINITY
			},
			label: {
				text: `Sun: ${sunPos.elevation.toFixed(1)}° el`,
				font: '10px sans-serif',
				fillColor: Cesium.Color.fromCssColorString('#fbbf24'),
				outlineColor: Cesium.Color.BLACK,
				outlineWidth: 2,
				style: Cesium.LabelStyle.FILL_AND_OUTLINE,
				verticalOrigin: Cesium.VerticalOrigin.BOTTOM,
				pixelOffset: new Cesium.Cartesian2(0, -16),
				disableDepthTestDistance: Number.POSITIVE_INFINITY,
				scale: 0.9
			}
		});
	}

	function buildSunIcon(): string {
		const canvas = document.createElement('canvas');
		canvas.width = 48;
		canvas.height = 48;
		const ctx = canvas.getContext('2d')!;

		// Sun circle
		ctx.fillStyle = '#fbbf24';
		ctx.beginPath();
		ctx.arc(24, 24, 10, 0, Math.PI * 2);
		ctx.fill();

		// Rays
		ctx.strokeStyle = '#fbbf24';
		ctx.lineWidth = 2;
		for (let i = 0; i < 8; i++) {
			const angle = (i * Math.PI) / 4;
			ctx.beginPath();
			ctx.moveTo(24 + Math.cos(angle) * 14, 24 + Math.sin(angle) * 14);
			ctx.lineTo(24 + Math.cos(angle) * 20, 24 + Math.sin(angle) * 20);
			ctx.stroke();
		}

		return canvas.toDataURL();
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
