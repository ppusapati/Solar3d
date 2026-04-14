<script lang="ts">
	import { onDestroy } from 'svelte';
	import { activeLayout, visibleTiles } from '$lib/core/stores';
	import { layoutApi, type Panel } from '$lib/core/api';

	export let viewer: any;
	export let visible: boolean = true;

	let Cesium: any;
	let panelPrimitive: any = null;
	let panelEntities: any[] = [];
	let loadedTileIds = new Set<string>();
	let allPanels: Panel[] = [];

	// Initialize Cesium
	import('cesium').then((mod) => {
		Cesium = mod;
	});

	// React to visible tiles changes
	$: if (Cesium && viewer && $visibleTiles.length > 0) {
		loadPanelsForTiles($visibleTiles);
	}

	// React to visibility toggle
	$: panelEntities.forEach((e) => {
		e.show = visible;
	});

	async function loadPanelsForTiles(tiles: any[]) {
		for (const tile of tiles) {
			if (loadedTileIds.has(tile.id)) continue;
			loadedTileIds.add(tile.id);

			try {
				const response = await layoutApi.getTilePanels(tile.id);
				const panels = response.panels || [];
				allPanels = [...allPanels, ...panels];
				renderPanels(panels);
			} catch (err) {
				console.error('Failed to load panels for tile', tile.id, err);
			}
		}
	}

	function renderPanels(panels: Panel[]) {
		if (!Cesium || !viewer) return;

		for (const panel of panels) {
			try {
				const geojson = JSON.parse(panel.geometry_geojson);
				if (!geojson.coordinates || !geojson.coordinates[0]) continue;

				const coords = geojson.coordinates[0];
				const centerLon = coords.reduce((sum: number, c: number[]) => sum + c[0], 0) / coords.length;
				const centerLat = coords.reduce((sum: number, c: number[]) => sum + c[1], 0) / coords.length;
				const positions = coords.map((c: number[]) =>
					Cesium.Cartesian3.fromDegrees(c[0], c[1], panel.elevation || 0)
				);

				const entity = viewer.entities.add({
					position: Cesium.Cartesian3.fromDegrees(centerLon, centerLat, panel.elevation || 0),
					polygon: {
						hierarchy: new Cesium.PolygonHierarchy(positions),
						material: getPanelColor(panel.tilt),
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						outline: true,
						outlineColor: Cesium.Color.fromCssColorString('#1e3a5f').withAlpha(0.8),
						outlineWidth: 1
					},
					point: {
						pixelSize: 2,
						color: Cesium.Color.fromCssColorString('#60a5fa').withAlpha(0.9),
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						disableDepthTestDistance: Number.POSITIVE_INFINITY
					},
					properties: {
						type: 'panel',
						panelId: panel.id,
						tilt: panel.tilt,
						azimuth: panel.azimuth,
						stringId: panel.string_id
					}
				});

				panelEntities.push(entity);
			} catch (err) {
				// Skip invalid geometry
			}
		}
	}

	function getPanelColor(tilt: number): any {
		// Color based on tilt: lighter blue at low tilt, deeper blue at high tilt
		const t = Math.min(tilt / 45, 1);
		return Cesium.Color.fromCssColorString('#2563eb').withAlpha(0.4 + t * 0.4);
	}

	export function highlightPanel(panelId: string) {
		panelEntities.forEach((e) => {
			if (e.properties?.panelId?.getValue() === panelId) {
				e.polygon.material = Cesium.Color.fromCssColorString('#f59e0b').withAlpha(0.8);
			}
		});
	}

	export function clearHighlights() {
		panelEntities.forEach((e) => {
			const tilt = e.properties?.tilt?.getValue() || 20;
			e.polygon.material = getPanelColor(tilt);
		});
	}

	export function clearAll() {
		panelEntities.forEach((e) => {
			if (viewer.entities.contains(e)) viewer.entities.remove(e);
		});
		panelEntities = [];
		allPanels = [];
		loadedTileIds.clear();
	}

	onDestroy(() => {
		clearAll();
	});
</script>
