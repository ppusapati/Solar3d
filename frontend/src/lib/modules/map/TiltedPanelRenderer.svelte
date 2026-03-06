<script lang="ts">
	/**
	 * Enhanced panel renderer that shows actual 3D tilted panels.
	 * Uses extruded polygons at correct tilt angles with realistic solar panel appearance.
	 */
	import { onDestroy } from 'svelte';
	import { activeLayout, visibleTiles } from '$lib/core/stores';
	import { layoutApi, type Panel } from '$lib/core/api';

	export let viewer: any;
	export let visible: boolean = true;
	export let show3D: boolean = true;

	let Cesium: any;
	let panelEntities: any[] = [];
	let loadedTileIds = new Set<string>();

	import('cesium').then((mod) => {
		Cesium = mod;
	});

	$: if (Cesium && viewer && $visibleTiles.length > 0 && visible) {
		loadPanelsForTiles($visibleTiles);
	}

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
				renderPanels3D(panels);
			} catch (err) {
				console.error('Failed to load tile panels:', err);
			}
		}
	}

	function renderPanels3D(panels: Panel[]) {
		if (!Cesium || !viewer) return;

		for (const panel of panels) {
			try {
				const geojson = JSON.parse(panel.geometry_geojson);
				if (!geojson.coordinates?.[0]) continue;

				const coords = geojson.coordinates[0];

				if (show3D && panel.tilt > 0) {
					// 3D tilted panel: compute raised back edge based on tilt
					renderTiltedPanel(panel, coords);
				} else {
					// Flat panel on ground
					renderFlatPanel(panel, coords);
				}
			} catch {
				// skip invalid
			}
		}
	}

	function renderTiltedPanel(panel: Panel, coords: number[][]) {
		// Panel has 4 corners: [front-left, front-right, back-right, back-left]
		// The back edge is raised by panel_height * sin(tilt)
		const tiltRad = (panel.tilt * Math.PI) / 180;
		const panelHeight = estimatePanelHeight(coords);
		const riseM = panelHeight * Math.sin(tiltRad);

		const baseElev = panel.elevation || 0.5; // mounting height above ground

		// Front edge at base elevation, back edge raised
		const positions = [];
		const len = Math.min(coords.length, 5);
		for (let i = 0; i < len - 1; i++) {
			const isBackEdge = i >= 2; // indices 2,3 are back edge
			const elev = isBackEdge ? baseElev + riseM : baseElev;
			positions.push(
				Cesium.Cartesian3.fromDegrees(coords[i][0], coords[i][1], elev)
			);
		}

		// Create as a polygon wall
		const entity = viewer.entities.add({
			polygon: {
				hierarchy: new Cesium.PolygonHierarchy(positions),
				material: getPanelMaterial(panel.tilt),
				perPositionHeight: true,
				outline: true,
				outlineColor: Cesium.Color.fromCssColorString('#0f172a').withAlpha(0.6),
				outlineWidth: 1
			},
			properties: {
				type: 'panel-3d',
				panelId: panel.id,
				tilt: panel.tilt,
				azimuth: panel.azimuth,
				stringId: panel.string_id
			}
		});
		panelEntities.push(entity);

		// Add thin mounting post at center
		const centerLon = coords.reduce((s, c) => s + c[0], 0) / (coords.length - 1);
		const centerLat = coords.reduce((s, c) => s + c[1], 0) / (coords.length - 1);

		const post = viewer.entities.add({
			position: Cesium.Cartesian3.fromDegrees(centerLon, centerLat, 0),
			polyline: {
				positions: [
					Cesium.Cartesian3.fromDegrees(centerLon, centerLat, 0),
					Cesium.Cartesian3.fromDegrees(centerLon, centerLat, baseElev + riseM / 2)
				],
				width: 2,
				material: Cesium.Color.fromCssColorString('#475569').withAlpha(0.5)
			}
		});
		panelEntities.push(post);
	}

	function renderFlatPanel(panel: Panel, coords: number[][]) {
		const positions = coords.map((c: number[]) =>
			Cesium.Cartesian3.fromDegrees(c[0], c[1], panel.elevation || 0.5)
		);

		const entity = viewer.entities.add({
			polygon: {
				hierarchy: new Cesium.PolygonHierarchy(positions),
				material: getPanelMaterial(panel.tilt),
				heightReference: Cesium.HeightReference.RELATIVE_TO_GROUND,
				extrudedHeight: (panel.elevation || 0.5) + 0.05,
				height: panel.elevation || 0.5,
				outline: true,
				outlineColor: Cesium.Color.fromCssColorString('#0f172a').withAlpha(0.4),
				outlineWidth: 1
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
	}

	function getPanelMaterial(tilt: number): any {
		// Realistic dark blue solar panel appearance
		const t = Math.min(tilt / 45, 1);
		return Cesium.Color.fromCssColorString('#1e3a5f').withAlpha(0.7 + t * 0.2);
	}

	function estimatePanelHeight(coords: number[][]): number {
		// Estimate panel height from coordinate extent
		if (coords.length < 4) return 1.1;
		const dy = Math.abs(coords[2][1] - coords[0][1]);
		// Rough meters from degrees
		return dy * 111320;
	}

	export function highlightString(stringId: string) {
		panelEntities.forEach((e) => {
			if (e.properties?.stringId?.getValue() === stringId) {
				e.polygon.material = Cesium.Color.fromCssColorString('#f59e0b').withAlpha(0.8);
			}
		});
	}

	export function clearHighlights() {
		panelEntities.forEach((e) => {
			const tilt = e.properties?.tilt?.getValue();
			if (tilt !== undefined) {
				e.polygon.material = getPanelMaterial(tilt);
			}
		});
	}

	export function clearAll() {
		panelEntities.forEach((e) => {
			if (viewer?.entities?.contains(e)) viewer.entities.remove(e);
		});
		panelEntities = [];
		loadedTileIds.clear();
	}

	onDestroy(() => clearAll());
</script>
