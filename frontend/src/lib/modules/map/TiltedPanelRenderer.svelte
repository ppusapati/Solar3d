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

			try {
				const response = await layoutApi.getTilePanels(tile.id);
				const panels = response.panels || [];
				renderPanels3D(panels);
				loadedTileIds.add(tile.id);
			} catch (err) {
				loadedTileIds.delete(tile.id);
				console.error('Failed to load tile panels:', err);
			}
		}
	}

	async function renderPanels3D(panels: Panel[]) {
		if (!Cesium || !viewer) return;

		// ── 1. Parse panel geometries ──────────────────────────────────────────
		type PanelEntry = { panel: Panel; coords: number[][] };
		const entries: PanelEntry[] = [];
		for (const panel of panels) {
			try {
				const ring = extractPanelRing(panel.geometry_geojson);
				if (!ring) continue;
				const coords = normalizePanelCorners(ring);
				if (coords.length < 4) continue;
				entries.push({ panel, coords });
			} catch (err) {
				console.warn('Skipping panel with invalid geometry:', err);
			}
		}
		if (entries.length === 0) return;

		// ── 2. Build flat cartographic array for batch terrain sampling ────────
		// Layout: 4 corner positions + 1 center position per panel (stride = 5)
		const STRIDE = 5;
		const cartographics: any[] = [];
		for (const { coords } of entries) {
			for (const [lon, lat] of coords) {
				cartographics.push(Cesium.Cartographic.fromDegrees(lon, lat));
			}
			// center position for mast bottom
			const cLon = (coords[0][0] + coords[1][0] + coords[2][0] + coords[3][0]) / 4;
			const cLat = (coords[0][1] + coords[1][1] + coords[2][1] + coords[3][1]) / 4;
			cartographics.push(Cesium.Cartographic.fromDegrees(cLon, cLat));
		}

		// ── 3. Georeference: sample actual terrain heights async ────────────────
		let sampled = cartographics;
		try {
			sampled = await Cesium.sampleTerrainMostDetailed(
				viewer.terrainProvider,
				cartographics
			);
		} catch {
			// EllipsoidTerrainProvider or network error — fall back to cached globe height
			for (const c of cartographics) {
				const h = viewer.scene?.globe?.getHeight(c);
				c.height = Number.isFinite(h) ? (h as number) : 0;
			}
		}

		// ── 4. Render panels with real terrain heights ─────────────────────────
		let i = 0;
		for (const { panel, coords } of entries) {
			const terrainH: number[] = [
				sampled[i]?.height ?? 0,
				sampled[i + 1]?.height ?? 0,
				sampled[i + 2]?.height ?? 0,
				sampled[i + 3]?.height ?? 0
			];
			const centerTerrainH: number = sampled[i + 4]?.height ?? 0;
			i += STRIDE;

			try {
				if (show3D && panel.tilt > 0) {
					renderTiltedPanel(panel, coords, terrainH, centerTerrainH);
				} else {
					renderFlatPanel(panel, coords, terrainH);
				}
			} catch (err) {
				console.warn('Failed to render panel:', err);
			}
		}
	}

	function extractPanelRing(rawGeometry: unknown): number[][] | null {
		if (!rawGeometry) return null;

		let parsed: any = rawGeometry;
		if (typeof rawGeometry === 'string') {
			try {
				parsed = JSON.parse(rawGeometry);
			} catch {
				return null;
			}
		}

		if (Array.isArray(parsed?.coordinates?.[0])) {
			return parsed.coordinates[0] as number[][];
		}

		if (parsed?.type === 'Feature' && Array.isArray(parsed?.geometry?.coordinates?.[0])) {
			return parsed.geometry.coordinates[0] as number[][];
		}

		if (parsed?.type === 'FeatureCollection' && Array.isArray(parsed?.features)) {
			for (const feature of parsed.features) {
				if (Array.isArray(feature?.geometry?.coordinates?.[0])) {
					return feature.geometry.coordinates[0] as number[][];
				}
			}
		}

		return null;
	}

	function normalizePanelCorners(rawCoords: number[][]): number[][] {
		if (!Array.isArray(rawCoords) || rawCoords.length < 4) return [];

		// Handle GeoJSON rings that may repeat the first point as the last point.
		const isClosedRing =
			rawCoords.length >= 5 &&
			rawCoords[0][0] === rawCoords[rawCoords.length - 1][0] &&
			rawCoords[0][1] === rawCoords[rawCoords.length - 1][1];

		const ring = isClosedRing ? rawCoords.slice(0, rawCoords.length - 1) : rawCoords;
		return ring.slice(0, 4);
	}

	function renderTiltedPanel(
		panel: Panel,
		coords: number[][],
		cornerTerrainHeights: number[],
		centerTerrainH: number
	) {
		// Panel has 4 corners: [front-left, front-right, back-right, back-left]
		// The back edge is raised by panel_height * sin(tilt)
		const tiltRad = (panel.tilt * Math.PI) / 180;
		const panelHeight = estimatePanelHeight(coords);
		const panelWidth = estimatePanelWidth(coords);
		const riseM = panelHeight * Math.sin(tiltRad);

		const baseElev = panel.elevation || 0.5; // mounting height above ground

		// Compute altitude offset to simulate tilted mounting structure
		// Back edge gets raised for tilt
		const positions = [];
		for (let i = 0; i < 4; i++) {
			const isBackEdge = i >= 2; // indices 2,3 are back edge
			const elev = cornerTerrainHeights[i] + (isBackEdge ? baseElev + riseM : baseElev);
			positions.push(
				Cesium.Cartesian3.fromDegrees(coords[i][0], coords[i][1], elev)
			);
		}

		// Create main panel polygon with realistic coloring
		const panelEntity = viewer.entities.add({
			polygon: {
				hierarchy: new Cesium.PolygonHierarchy(positions),
				material: getPanelMaterial(panel.tilt),
				perPositionHeight: true,
				outline: true,
				outlineColor: Cesium.Color.fromCssColorString('#0f172a').withAlpha(0.7),
				outlineWidth: 2
			},
			properties: {
				type: 'panel-3d',
				panelId: panel.id,
				tilt: panel.tilt,
				azimuth: panel.azimuth,
				stringId: panel.string_id
			}
		});
		panelEntities.push(panelEntity);

		// Compute center and quarter points for mounting geometry
		const centerLon = (coords[0][0] + coords[1][0] + coords[2][0] + coords[3][0]) / 4;
		const centerLat = (coords[0][1] + coords[1][1] + coords[2][1] + coords[3][1]) / 4;
		
		// Approximate front and back edge centers
		const frontLon = (coords[0][0] + coords[1][0]) / 2;
		const frontLat = (coords[0][1] + coords[1][1]) / 2;
		const backLon = (coords[3][0] + coords[2][0]) / 2;
		const backLat = (coords[3][1] + coords[2][1]) / 2;
		const quarterLon = coords[1][0] - coords[0][0];
		const quarterLat = coords[1][1] - coords[0][1];

		// ─── Rear horizontal rails (aluminum) ───
		const railHeight = 0.05;
		const railDist = panelHeight * 0.35;
		
		// Left mounting rail
		const leftRailStart = Cesium.Cartesian3.fromDegrees(
			coords[3][0] - quarterLon * 0.25,
			coords[3][1] - quarterLat * 0.25,
			cornerTerrainHeights[3] + baseElev + riseM
		);
		const leftRailEnd = Cesium.Cartesian3.fromDegrees(
			coords[0][0] - quarterLon * 0.25,
			coords[0][1] - quarterLat * 0.25,
			cornerTerrainHeights[0] + baseElev
		);
		const leftRail = viewer.entities.add({
			polyline: {
				positions: [leftRailStart, leftRailEnd],
				width: 4,
				material: Cesium.Color.fromCssColorString('#7b8a9e').withAlpha(0.8),
				clampToGround: false
			}
		});
		panelEntities.push(leftRail);

		// Right mounting rail
		const rightRailStart = Cesium.Cartesian3.fromDegrees(
			coords[2][0] + quarterLon * 0.25,
			coords[2][1] + quarterLat * 0.25,
			cornerTerrainHeights[2] + baseElev + riseM
		);
		const rightRailEnd = Cesium.Cartesian3.fromDegrees(
			coords[1][0] + quarterLon * 0.25,
			coords[1][1] + quarterLat * 0.25,
			cornerTerrainHeights[1] + baseElev
		);
		const rightRail = viewer.entities.add({
			polyline: {
				positions: [rightRailStart, rightRailEnd],
				width: 4,
				material: Cesium.Color.fromCssColorString('#7b8a9e').withAlpha(0.8),
				clampToGround: false
			}
		});
		panelEntities.push(rightRail);

		// ─── Single-post mount with saddle beam + braces ───
		const postMaterial = Cesium.Color.fromCssColorString('#3f4d61');
		const centerGround = centerTerrainH;
		const centerTop = centerGround + baseElev + riseM * 0.45;
		const mast = viewer.entities.add({
			polyline: {
				positions: [
					Cesium.Cartesian3.fromDegrees(centerLon, centerLat, centerGround),
					Cesium.Cartesian3.fromDegrees(centerLon, centerLat, centerTop)
				],
				width: 4,
				material: postMaterial,
				clampToGround: false
			}
		});
		panelEntities.push(mast);

		const saddleBeam = viewer.entities.add({
			polyline: {
				positions: [
					Cesium.Cartesian3.fromDegrees(frontLon + quarterLon * 0.08, frontLat + quarterLat * 0.08, centerTop),
					Cesium.Cartesian3.fromDegrees(backLon - quarterLon * 0.08, backLat - quarterLat * 0.08, centerTop + riseM * 0.08)
				],
				width: 4,
				material: postMaterial,
				clampToGround: false
			}
		});
		panelEntities.push(saddleBeam);

		const braceTargets = [
			{
				lon: coords[3][0] - quarterLon * 0.18,
				lat: coords[3][1] - quarterLat * 0.18,
				elev: cornerTerrainHeights[3] + baseElev + riseM * 0.82
			},
			{
				lon: coords[2][0] + quarterLon * 0.18,
				lat: coords[2][1] + quarterLat * 0.18,
				elev: cornerTerrainHeights[2] + baseElev + riseM * 0.82
			}
		];

		for (const target of braceTargets) {
			const brace = viewer.entities.add({
				polyline: {
					positions: [
						Cesium.Cartesian3.fromDegrees(centerLon, centerLat, centerTop - 0.04),
						Cesium.Cartesian3.fromDegrees(target.lon, target.lat, target.elev)
					],
					width: 2,
					material: postMaterial,
					clampToGround: false
				}
			});
			panelEntities.push(brace);
		}

		// ─── Junction box indicator (small marker at bottom-center-back) ───
		const jboxLon = (backLon + centerLon) / 2;
		const jboxLat = (backLat + centerLat) / 2;
		const backGround = (cornerTerrainHeights[2] + cornerTerrainHeights[3]) / 2;
		const jbox = viewer.entities.add({
			position: Cesium.Cartesian3.fromDegrees(jboxLon, jboxLat, backGround + baseElev + riseM - 0.1),
			point: {
				pixelSize: 5,
				color: Cesium.Color.fromCssColorString('#1a1f2d'),
				outlineColor: Cesium.Color.fromCssColorString('#f59e0b'),
				outlineWidth: 1
			}
		});
		panelEntities.push(jbox);
	}

	function renderFlatPanel(panel: Panel, coords: number[][], terrainHeights: number[]) {
		const mountH = panel.elevation || 0.5;
		// Place each corner at its exact sampled terrain height + mounting offset
		const positions = coords.map((c: number[], idx: number) =>
			Cesium.Cartesian3.fromDegrees(c[0], c[1], (terrainHeights[idx] ?? 0) + mountH)
		);

		const entity = viewer.entities.add({
			polygon: {
				hierarchy: new Cesium.PolygonHierarchy(positions),
				material: getPanelMaterial(panel.tilt),
				perPositionHeight: true,
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

	function estimatePanelWidth(coords: number[][]): number {
		// Estimate panel width from coordinate extent
		if (coords.length < 2) return 2.0;
		const dx = Math.abs(coords[1][0] - coords[0][0]);
		// Rough meters from degrees (accounts for latitude)
		const lat = (coords[0][1] + coords[1][1]) / 2;
		const latCos = Math.cos((lat * Math.PI) / 180);
		return dx * 111320 * latCos;
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
