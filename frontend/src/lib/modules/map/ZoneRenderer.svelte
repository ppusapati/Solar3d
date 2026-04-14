<script lang="ts">
	import { onDestroy } from 'svelte';
	import type { ZoneAllocation } from '$lib/core/api';

	export let viewer: any;
	export let visible = true;
	export let zones: ZoneAllocation[] = [];

	let Cesium: any;
	let zoneEntities: any[] = [];

	import('cesium').then((mod) => {
		Cesium = mod;
	});

	$: if (Cesium && viewer) {
		renderZones(zones);
	}

	$: zoneEntities.forEach((e) => {
		e.show = visible;
	});

	function renderZones(items: ZoneAllocation[]) {
		clearAll();
		for (const zone of items || []) {
			try {
				const parsed = JSON.parse(zone.geometry_geojson);
				const ring = parsed?.coordinates?.[0];
				if (!ring || ring.length < 4) continue;

				const positions = ring.map((c: number[]) => Cesium.Cartesian3.fromDegrees(c[0], c[1], 0));
				const color = zoneColor(zone.zone_type);
				const centroid = ring.reduce(
					(acc: { lon: number; lat: number }, c: number[]) => ({ lon: acc.lon + c[0], lat: acc.lat + c[1] }),
					{ lon: 0, lat: 0 }
				);
				const lon = centroid.lon / ring.length;
				const lat = centroid.lat / ring.length;

				const polygonEntity = viewer.entities.add({
					polygon: {
						hierarchy: new Cesium.PolygonHierarchy(positions),
						material: Cesium.Color.fromCssColorString(color).withAlpha(0.24),
						outline: true,
						outlineColor: Cesium.Color.fromCssColorString(color).withAlpha(0.95),
						outlineWidth: 2,
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND
					},
					properties: {
						type: 'zone',
						zoneType: zone.zone_type,
						area: zone.planned_area_sqm
					}
				});
				zoneEntities.push(polygonEntity);

				const labelEntity = viewer.entities.add({
					position: Cesium.Cartesian3.fromDegrees(lon, lat, 0),
					label: {
						text: `${zone.zone_type.toUpperCase()}\n${(zone.planned_area_sqm / 10000).toFixed(2)} ha`,
						font: '12px sans-serif',
						fillColor: Cesium.Color.WHITE,
						outlineColor: Cesium.Color.BLACK,
						outlineWidth: 2,
						style: Cesium.LabelStyle.FILL_AND_OUTLINE,
						showBackground: true,
						backgroundColor: Cesium.Color.fromCssColorString('#0f172a').withAlpha(0.7),
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						disableDepthTestDistance: Number.POSITIVE_INFINITY,
						pixelOffset: new Cesium.Cartesian2(0, -10),
						scale: 0.85
					}
				});
				zoneEntities.push(labelEntity);
			} catch (err) {
				console.warn('Skipping invalid zone geometry', err);
			}
		}
	}

	function zoneColor(zoneType: string): string {
		switch (zoneType) {
			case 'panel':
				return '#22c55e';
			case 'inverter':
				return '#ef4444';
			case 'transformer':
				return '#8b5cf6';
			case 'roadway':
				return '#f59e0b';
			case 'drainage':
				return '#0ea5e9';
			case 'electrical':
				return '#94a3b8';
			default:
				return '#64748b';
		}
	}

	export function clearAll() {
		zoneEntities.forEach((e) => {
			if (viewer?.entities?.contains(e)) viewer.entities.remove(e);
		});
		zoneEntities = [];
	}

	onDestroy(() => {
		clearAll();
	});
</script>
