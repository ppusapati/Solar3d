<script lang="ts">
	import { onMount } from 'svelte';
	import { get } from 'svelte/store';
	import TopBar from '$lib/components/TopBar.svelte';
	import Toolbar from '$lib/components/Toolbar.svelte';
	import InspectorPanel from '$lib/components/InspectorPanel.svelte';
	import CesiumViewer from '$lib/modules/map/CesiumViewer.svelte';
	import DrawingManager from '$lib/modules/map/DrawingManager.svelte';
	import PanelRenderer from '$lib/modules/map/PanelRenderer.svelte';
	import ShadowRenderer from '$lib/modules/map/ShadowRenderer.svelte';
	import ComponentRenderer from '$lib/modules/map/ComponentRenderer.svelte';
	import RouteRenderer from '$lib/modules/map/RouteRenderer.svelte';
	import TransmissionRenderer from '$lib/modules/map/TransmissionRenderer.svelte';
	import ZoneRenderer from '$lib/modules/map/ZoneRenderer.svelte';
	import TiltedPanelRenderer from '$lib/modules/map/TiltedPanelRenderer.svelte';
	import TerrainHeatmap from '$lib/modules/map/TerrainHeatmap.svelte';
	import DragDropHandler from '$lib/modules/map/DragDropHandler.svelte';
	import CadEntityRenderer from '$lib/modules/map/CadEntityRenderer.svelte';
	import ProjectDashboard from '$lib/components/ProjectDashboard.svelte';
	import MapSearch from '$lib/components/MapSearch.svelte';
	import StatusBar from '$lib/components/StatusBar.svelte';
	import ToastNotification from '$lib/components/ToastNotification.svelte';
	import ConfirmModal from '$lib/components/ConfirmModal.svelte';
	import KeyboardShortcuts from '$lib/components/KeyboardShortcuts.svelte';
	import Minimap from '$lib/components/Minimap.svelte';
	import SnapGrid from '$lib/modules/map/SnapGrid.svelte';
	import {
		isMapReady,
		activeLayout,
		activeLayoutId,
		layouts,
		activeProject,
		updateProject,
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
		loadLayouts,
		createLayout,
		loadComponents,
		applyLayoutGenerationSummary,
		components,
		entities,
		cadWorkspace,
		getCadBlockDefinitions,
		workflowState,
		userRole,
		type MapEntity
	} from '$lib/core/stores';
import type { AppView } from '$lib/core/stores/map';
	import {
		initializeCadWorkspace,
		createCadDimensionFromMap,
		insertCadBlockReference,
		disarmCadMapBlockInsertion
	} from '$lib/core/stores/cad';
	import { isCableType, isPanelType, normalizeAssetType } from '$lib/core/domain/assetPlacement';
	import {
		layoutApi,
		projectsApi,
		terrainApi,
		type PanelArrayParams,
		type TerrainSummary,
		type ZonePlanResult
	} from '$lib/core/api';
	import { buildWorkflowViewGuard, type ViewGuard } from '$lib/core/domain/workflowGuards';
	import { buildInfrastructureAwareGenerationAreas } from '$lib/core/domain/sitePlanning';
	import { loadTilesForViewport, visibleTiles } from '$lib/core/stores';

	let use3DPanels = true;  // Enable 3D tilted panels by default
	let showTerrainHeatmap = false;
	let terrainHeatmapMode: 'elevation' | 'slope' | 'aspect' = 'elevation';
	let showShortcuts = false;

	let cesiumViewer: CesiumViewer;
	let viewer: any;
	let panelRendererRef: PanelRenderer | null = null;
	let panelRenderer3DRef: any = null;  // Reference to TiltedPanelRenderer

	// ── Multiple solar areas ──────────────────────────────────────────────
	let fillAreas: string[] = [];           // array of GeoJSON Polygon strings
	let fillAreaEntities: any[] = [];       // matching Cesium entities

	// ── Exclusion zones (lakes, obstacles) ────────────────────────────────
	let exclusionAreas: string[] = [];
	let exclusionEntities: any[] = [];

	// ── Drawn roads ───────────────────────────────────────────────────────
	type DrawnRoad = { lineGeojson: string; widthM: number };
	let drawnRoads: DrawnRoad[] = [];
	let roadEntities: any[] = [];
	let pendingRoadPositions: { longitude: number; latitude: number }[] | null = null;
	let showRoadWidthDialog = false;
	let pendingRoadWidthM = 8;

	// ── Backwards-compat single-area accessor used by tile loading ────────
	$: fillAreaGeoJson = fillAreas[0] ?? '';
	let siteBoundaryGeoJson = '';

	let persistedSiteEntity: any = null;
	let persistedBoundaryEntity: any = null;
	let showShadows = false;
	let showDashboard = true;
	let initializedLayoutProjectId: string | null = null;
	let initializedCadProjectId: string | null = null;
	let loadedSiteProjectId: string | null = null;
	let hydratedTilesLayoutId: string | null = null;
	let terrainSummary: TerrainSummary | null = null;
	let zonePlan: ZonePlanResult | null = null;
	let planningBusy = false;
	let pickingProjectFarmBoundary = false;
	let pickingProjectGridConnection = false;
	let pickedProjectLat: number | null = null;
	let pickedProjectLon: number | null = null;
	let pickedProjectBoundaryVertices: [number, number][] = [];
	let previewProjectBoundaryVertices: [number, number][] = [];
	let previewBoundaryEntity: any = null;
	let pendingCableStart: { longitude: number; latitude: number; name: string } | null = null;
	let pendingCableAssetName = '';
	let pendingAssetType = '';
	let pendingAssetName = '';
	let pendingAssetId = '';
	let pendingAssetModel3dPath = '';
	let pendingAssetDimensions = { widthMm: 0, heightMm: 0, depthMm: 0 };

	type WorkflowPhaseName =
		| 'UNSPECIFIED'
		| 'PLANNING'
		| 'LAYOUT_READY'
		| 'ELECTRICAL_READY'
		| 'TRANSMISSION_READY'
		| 'REVIEW_READY'
		| 'APPROVED'
		| 'COMMISSIONING_READY'
		| 'ARCHIVED';

	type PhaseStep = {
		id: string;
		label: string;
		description: string;
		phase: WorkflowPhaseName;
		view: AppView;
	};

	const phaseOrder: WorkflowPhaseName[] = [
		'UNSPECIFIED',
		'PLANNING',
		'LAYOUT_READY',
		'ELECTRICAL_READY',
		'TRANSMISSION_READY',
		'REVIEW_READY',
		'APPROVED',
		'COMMISSIONING_READY',
		'ARCHIVED'
	];

	const phaseSteps: PhaseStep[] = [
		{
			id: 'planning',
			label: 'Planning',
			description: 'Capture boundary and baseline project inputs.',
			phase: 'PLANNING',
			view: 'design'
		},
		{
			id: 'layout',
			label: 'Layout Ready',
			description: 'Generate and validate panel layout candidates.',
			phase: 'LAYOUT_READY',
			view: 'simulate'
		},
		{
			id: 'electrical',
			label: 'Electrical Ready',
			description: 'Stringing and electrical feasibility validation.',
			phase: 'ELECTRICAL_READY',
			view: 'electrical'
		},
		{
			id: 'transmission',
			label: 'Transmission Ready',
			description: 'Route design and protection handoff readiness.',
			phase: 'TRANSMISSION_READY',
			view: 'transmission'
		},
		{
			id: 'lod400',
			label: 'LOD 400 Review',
			description: 'Quality gate and review readiness checks.',
			phase: 'REVIEW_READY',
			view: 'reports'
		},
		{
			id: 'approved',
			label: 'Approved',
			description: 'Stakeholder approval and export/report enablement.',
			phase: 'APPROVED',
			view: 'reports'
		},
		{
			id: 'twin',
			label: 'Twin Activated',
			description: 'Commissioning handoff and twin activation pathway.',
			phase: 'COMMISSIONING_READY',
			view: 'commissioning'
		}
	];

	const viewPhaseRequirement: Record<AppView, WorkflowPhaseName> = {
		design: 'PLANNING',
		cad: 'PLANNING',
		simulate: 'LAYOUT_READY',
		electrical: 'ELECTRICAL_READY',
		transmission: 'TRANSMISSION_READY',
		commissioning: 'APPROVED',
		reports: 'REVIEW_READY',
		financial: 'REVIEW_READY'
	};

	let workflowPhaseLabel = 'UNSPECIFIED';
	let workflowContextDescription = 'Select a project to begin phase-driven workflow.';
	let workflowBlockers: string[] = [];
	let workflowViewGuards: Partial<Record<AppView, ViewGuard>> = {};
	let forcedViewWarningKey = '';

	function phaseIndex(phase: WorkflowPhaseName): number {
		const idx = phaseOrder.indexOf(phase);
		return idx >= 0 ? idx : 0;
	}

	function isPhaseReached(requiredPhase: WorkflowPhaseName): boolean {
		const current = ($workflowState.current_phase as WorkflowPhaseName) ?? 'UNSPECIFIED';
		return phaseIndex(current) >= phaseIndex(requiredPhase);
	}

	function buildGuard(view: AppView): ViewGuard {
		return buildWorkflowViewGuard({
			view,
			phase: $workflowState.current_phase,
			role: $userRole,
			blockers: $workflowState.active_blockers ?? []
		});
	}

	function handleBlockedNavigation(event: CustomEvent<{ view: AppView; reason: string }>) {
		const message = event.detail.reason || 'Action blocked by workflow prerequisites.';
		toast.error(message);
	}

	$: workflowPhaseLabel = (($workflowState.current_phase as WorkflowPhaseName) ?? 'UNSPECIFIED').replaceAll('_', ' ');
	$: workflowBlockers = $workflowState.active_blockers ?? [];
	$: {
		const current = ($workflowState.current_phase as WorkflowPhaseName) ?? 'UNSPECIFIED';
		const step = phaseSteps.find((s) => s.phase === current);
		workflowContextDescription = step
			? step.description
			: 'Workflow phase metadata unavailable. Continue from planning baseline.';
	}
	$: workflowViewGuards = {
		design: buildGuard('design'),
		cad: buildGuard('cad'),
		simulate: buildGuard('simulate'),
		electrical: buildGuard('electrical'),
		transmission: buildGuard('transmission'),
		commissioning: buildGuard('commissioning'),
		reports: buildGuard('reports'),
		financial: buildGuard('financial')
	};
	$: {
		const guard = workflowViewGuards[$activeView as AppView];
		if (guard && !guard.enabled) {
			const warningKey = `${$activeView}:${guard.reason}`;
			if (forcedViewWarningKey !== warningKey) {
				forcedViewWarningKey = warningKey;
				toast.error(`Redirected to Design: ${guard.reason}`);
			}
			activeView.set('design');
		}
	}

	function buildComponentMetadataJson() {
		return JSON.stringify({
			dimensionsMm: {
				width: pendingAssetDimensions.widthMm,
				height: pendingAssetDimensions.heightMm,
				depth: pendingAssetDimensions.depthMm
			},
			model3dPath: pendingAssetModel3dPath
		});
	}

	function clearPendingAssetPlacement() {
		pendingCableStart = null;
		pendingCableAssetName = '';
		pendingAssetType = '';
		pendingAssetName = '';
		pendingAssetId = '';
		pendingAssetModel3dPath = '';
		pendingAssetDimensions = { widthMm: 0, heightMm: 0, depthMm: 0 };
	}

	$: if ($isMapReady && cesiumViewer) {
		viewer = cesiumViewer.getViewer();
	}

	$: if (persistedBoundaryEntity) {
		persistedBoundaryEntity.show = $layerVisibility.boundary;
	}

	$: if (previewBoundaryEntity) {
		previewBoundaryEntity.show = $layerVisibility.boundary;
	}

	$: for (const entity of fillAreaEntities) {
		if (entity) entity.show = $layerVisibility.boundary;
	}

	$: for (const entity of exclusionEntities) {
		if (entity) entity.show = $layerVisibility.boundary;
	}

	$: for (const entity of roadEntities) {
		if (entity) entity.show = $layerVisibility.boundary || $layerVisibility.cables;
	}

	// Show dashboard if no project is loaded
	$: if ($activeProject) {
		showDashboard = false;
	}

	async function drawCableConnection(
		start: { longitude: number; latitude: number; name: string },
		end: { longitude: number; latitude: number }
	) {
		const v = viewer ?? cesiumViewer?.getViewer();
		if (!v) return;

		try {
			const Cesium = await import('cesium');
			const positions = [
				Cesium.Cartesian3.fromDegrees(start.longitude, start.latitude, 0),
				Cesium.Cartesian3.fromDegrees(end.longitude, end.latitude, 0)
			];

			v.entities.add({
				polyline: {
					positions,
					width: 3,
					material: Cesium.Color.fromCssColorString('#ef4444').withAlpha(0.9),
					clampToGround: true
				},
				properties: {
					type: 'route',
					routeType: 'cable',
					assetName: start.name
				}
			});
		} catch (err) {
			console.error('Failed to render cable connection:', err);
		}
	}
	$: if ($activeProject?.id && initializedLayoutProjectId !== $activeProject.id) {
		initializedLayoutProjectId = $activeProject.id;
		void initializeLayoutForProject($activeProject.id);
	}

	$: if ($activeProject?.id && initializedCadProjectId !== $activeProject.id) {
		initializedCadProjectId = $activeProject.id;
		void initializeCadWorkspace($activeProject.id, $activeProject.name);
	}

	// Load persisted components whenever the active layout changes
	$: if ($activeLayoutId) {
		void loadComponents($activeLayoutId);
	}

	$: if ($activeProject?.id && loadedSiteProjectId !== $activeProject.id) {
		loadedSiteProjectId = $activeProject.id;
		hydratedTilesLayoutId = null;
		void loadSiteForProject($activeProject.id);
	}

	$: if (viewer && $activeLayout?.id && hydratedTilesLayoutId !== $activeLayout.id) {
		hydratedTilesLayoutId = $activeLayout.id;
		void loadTilesForAllAreas($activeLayout.id);
	}

	async function initializeLayoutForProject(projectId: string) {
		try {
			await loadLayouts(projectId);
			const loadedLayouts = get(layouts);
			if (loadedLayouts.length === 0) {
				await createLayout(projectId, 'Default Layout');
			} else if (!get(activeLayout)) {
				activeLayoutId.set(loadedLayouts[0].id);
			}
		} catch (err) {
			console.error('Failed to initialize layout:', err);
			toast.error('Unable to initialize project layout. Please retry.');
		}
	}

	async function ensureActiveLayout() {
		if ($activeLayout) return $activeLayout;

		const projectId = $activeProject?.id;
		if (!projectId) return null;

		await loadLayouts(projectId);
		const loadedLayouts = get(layouts);

		if (loadedLayouts.length > 0) {
			activeLayoutId.set(loadedLayouts[0].id);
			return loadedLayouts[0];
		}

		return await createLayout(projectId, 'Default Layout');
	}

	function polygonAreaSqm(coords: [number, number][]): number {
		if (coords.length < 3) return 0;
		const meanLat = coords.reduce((acc, [, lat]) => acc + lat, 0) / coords.length;
		const metersPerDegLat = 111320;
		const metersPerDegLon = 111320 * Math.cos((meanLat * Math.PI) / 180);
		let sum = 0;
		for (let i = 0; i < coords.length; i++) {
			const [lon1, lat1] = coords[i];
			const [lon2, lat2] = coords[(i + 1) % coords.length];
			const x1 = lon1 * metersPerDegLon;
			const y1 = lat1 * metersPerDegLat;
			const x2 = lon2 * metersPerDegLon;
			const y2 = lat2 * metersPerDegLat;
			sum += x1 * y2 - x2 * y1;
		}
		return Math.abs(sum) / 2;
	}

	function polygonCentroid(coords: [number, number][]) {
		if (coords.length === 0) return { longitude: 0, latitude: 0 };
		const sum = coords.reduce(
			(acc, [lon, lat]) => ({ longitude: acc.longitude + lon, latitude: acc.latitude + lat }),
			{ longitude: 0, latitude: 0 }
		);
		return {
			longitude: sum.longitude / coords.length,
			latitude: sum.latitude / coords.length
		};
	}

	function sanitizePolygonCoords(coords: [number, number][]): [number, number][] {
		const cleaned: [number, number][] = [];
		for (const [lon, lat] of coords) {
			if (!Number.isFinite(lon) || !Number.isFinite(lat)) continue;
			if (Math.abs(lon) > 180 || Math.abs(lat) > 90) continue;
			const normalized: [number, number] = [Number(lon.toFixed(8)), Number(lat.toFixed(8))];
			const prev = cleaned[cleaned.length - 1];
			if (!prev || prev[0] !== normalized[0] || prev[1] !== normalized[1]) {
				cleaned.push(normalized);
			}
		}
		if (cleaned.length >= 2) {
			const first = cleaned[0];
			const last = cleaned[cleaned.length - 1];
			if (first[0] === last[0] && first[1] === last[1]) {
				cleaned.pop();
			}
		}
		return cleaned;
	}

	async function setProjectPin(longitude: number, latitude: number) {
		cesiumViewer?.addGpsPin(longitude, latitude);
		if ($activeProject?.id) {
			try {
				await updateProject($activeProject.id, {
					initial_latitude: latitude,
					initial_longitude: longitude
				});
			} catch (err) {
				console.warn('Failed to persist manual project pin:', err);
			}
		}
	}

	async function saveSitePolygon(coords: [number, number][], nameSuffix: string) {
		if (!$activeProject?.id || coords.length < 3) return;
		const ring = [...coords, coords[0]];
		const boundaryGeojson = JSON.stringify({ type: 'Polygon', coordinates: [ring] });
		const centroid = polygonCentroid(coords);
		const areaSqm = polygonAreaSqm(coords);
		try {
			await projectsApi.createSite({
				project_id: $activeProject.id,
				name: `${$activeProject.name} ${nameSuffix}`,
				boundary_geojson: boundaryGeojson,
				area_sqm: areaSqm,
				latitude: centroid.latitude,
				longitude: centroid.longitude,
				timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
			});
			// Remove GPS pin now that a polygon boundary has been saved.
			cesiumViewer?.removeGpsPin();
		} catch (err) {
			console.error('Failed to persist site polygon:', err);
			toast.error('Failed to save polygon to database');
		}
	}

	function saveFillAreasToLocalStorage(projectId: string) {
		if (typeof localStorage === 'undefined') return;
		localStorage.setItem(`fill-areas-${projectId}`, JSON.stringify(fillAreas));
	}

	function saveExclusionAreasToLocalStorage(projectId: string) {
		if (typeof localStorage === 'undefined') return;
		localStorage.setItem(`exclusion-areas-${projectId}`, JSON.stringify(exclusionAreas));
	}

	function saveRoadsToLocalStorage(projectId: string) {
		if (typeof localStorage === 'undefined') return;
		localStorage.setItem(`drawn-roads-${projectId}`, JSON.stringify(drawnRoads));
	}

	function loadFillAreasFromLocalStorage(projectId: string): string[] {
		if (typeof localStorage === 'undefined') return [];
		// Support legacy single-area key
		const legacySingle = localStorage.getItem(`fill-area-${projectId}`);
		const multi = localStorage.getItem(`fill-areas-${projectId}`);
		if (multi) {
			try { return JSON.parse(multi) as string[]; } catch { return []; }
		}
		if (legacySingle) return [legacySingle];
		return [];
	}

	function loadExclusionAreasFromLocalStorage(projectId: string): string[] {
		if (typeof localStorage === 'undefined') return [];
		try { return JSON.parse(localStorage.getItem(`exclusion-areas-${projectId}`) ?? 'null') ?? []; } catch { return []; }
	}

	function loadRoadsFromLocalStorage(projectId: string): DrawnRoad[] {
		if (typeof localStorage === 'undefined') return [];
		try { return JSON.parse(localStorage.getItem(`drawn-roads-${projectId}`) ?? 'null') ?? []; } catch { return []; }
	}

	async function loadSiteForProject(projectId: string) {
		fillAreas = [];
		exclusionAreas = [];
		drawnRoads = [];
		siteBoundaryGeoJson = '';
		terrainSummary = null;
		zonePlan = null;
		panelRendererRef?.clearAll();
		visibleTiles.set([]);
		if (viewer && persistedSiteEntity) {
			viewer.entities.remove(persistedSiteEntity);
			persistedSiteEntity = null;
		}
		if (viewer && persistedBoundaryEntity) {
			viewer.entities.remove(persistedBoundaryEntity);
			persistedBoundaryEntity = null;
		}

		const savedBoundaryGeojson = typeof localStorage !== 'undefined'
			? localStorage.getItem(`site-boundary-${projectId}`)
			: null;
		siteBoundaryGeoJson = savedBoundaryGeojson ?? '';
		const savedFillAreas = loadFillAreasFromLocalStorage(projectId);
		const savedExclusions = loadExclusionAreasFromLocalStorage(projectId);
		const savedRoads = loadRoadsFromLocalStorage(projectId);

		if (savedBoundaryGeojson) {
			renderBoundaryPolygon(savedBoundaryGeojson);
			try {
				const poly = JSON.parse(savedBoundaryGeojson) as { coordinates: number[][][] };
				if (poly.coordinates?.[0]) {
					const ring = poly.coordinates[0] as [number, number][];
					const areaSqm = polygonAreaSqm(ring);
					flyToSite(savedBoundaryGeojson, 0, 0, areaSqm);
				}
			} catch { /* ignore malformed geojson */ }
		}

		if (savedFillAreas.length > 0) {
			fillAreas = savedFillAreas;
		}
		if (savedExclusions.length > 0) {
			exclusionAreas = savedExclusions;
		}
		if (savedRoads.length > 0) {
			drawnRoads = savedRoads;
		}
		if (savedFillAreas.length > 0 || savedExclusions.length > 0 || savedRoads.length > 0) {
			rerenderAllMapOverlays();
		}

		try {
			const { site } = await projectsApi.getSiteByProjectId(projectId);
			if (site?.boundary_geojson) {
				siteBoundaryGeoJson = site.boundary_geojson;
				if (!savedBoundaryGeojson) {
					renderBoundaryPolygon(site.boundary_geojson);
					if (typeof localStorage !== 'undefined') {
						localStorage.setItem(`site-boundary-${projectId}`, site.boundary_geojson);
					}
				}
				if (savedFillAreas.length === 0) {
					fillAreas = [site.boundary_geojson];
					rerenderAllMapOverlays();
				}
				// If we previously showed a GPS pin, remove it now that a site exists.
				cesiumViewer?.removeGpsPin();
				// Always fly using the authoritative DB data (overrides the localStorage fly).
				flyToSite(site.boundary_geojson, site.latitude, site.longitude, site.area_sqm);
				if ($activeLayout?.id && fillAreas.length > 0) {
					await loadTilesForAllAreas($activeLayout.id);
				}
			} else if (site?.latitude && site?.longitude) {
				// Site row exists but has no polygon yet — fly to its stored coordinates.
				flyToSite('', site.latitude, site.longitude, 10000);
			}
		} catch {
			// Site doesn't exist in DB yet. If we already flew from localStorage above, do nothing.
			// Otherwise try to fly to the project's initial GPS pin.
			if (!savedBoundaryGeojson) {
				const lat = $activeProject?.initial_latitude;
				const lon = $activeProject?.initial_longitude;
				if (lat && lon) {
					const attempt = (tries: number) => {
						if (cesiumViewer?.getViewer()) {
							cesiumViewer.flyTo(lon, lat, 2000);
							cesiumViewer.addGpsPin(lon, lat);
						} else if (tries > 0) {
							setTimeout(() => attempt(tries - 1), 300);
						}
					};
					attempt(30);
				}
			}
		}
	}

	function parsePolygonBounds(geojson: string) {
		try {
			const poly = JSON.parse(geojson) as { type: string; coordinates: number[][][] };
			const ring = poly?.coordinates?.[0];
			if (poly.type !== 'Polygon' || !ring?.length) return null;

			let minLon = Number.POSITIVE_INFINITY;
			let minLat = Number.POSITIVE_INFINITY;
			let maxLon = Number.NEGATIVE_INFINITY;
			let maxLat = Number.NEGATIVE_INFINITY;

			for (const [lon, lat] of ring) {
				if (lon < minLon) minLon = lon;
				if (lon > maxLon) maxLon = lon;
				if (lat < minLat) minLat = lat;
				if (lat > maxLat) maxLat = lat;
			}

			if (!Number.isFinite(minLon) || !Number.isFinite(minLat) || !Number.isFinite(maxLon) || !Number.isFinite(maxLat)) {
				return null;
			}

			return { minLon, minLat, maxLon, maxLat };
		} catch {
			return null;
		}
	}

	function isPointInPolygonGeojson(geojson: string, longitude: number, latitude: number): boolean {
		try {
			const poly = JSON.parse(geojson) as { type: string; coordinates: number[][][] };
			const ring = poly?.coordinates?.[0];
			if (poly.type !== 'Polygon' || !ring || ring.length < 3) return false;
			let inside = false;
			for (let i = 0, j = ring.length - 1; i < ring.length; j = i++) {
				const xi = ring[i][0], yi = ring[i][1];
				const xj = ring[j][0], yj = ring[j][1];
				const intersects = yi > latitude !== yj > latitude &&
					longitude < ((xj - xi) * (latitude - yi)) / ((yj - yi) || Number.EPSILON) + xi;
				if (intersects) inside = !inside;
			}
			return inside;
		} catch {
			return false;
		}
	}

	function isPointInFillArea(longitude: number, latitude: number): boolean {
		if (fillAreas.length === 0) return false;
		return fillAreas.some((geojson) => isPointInPolygonGeojson(geojson, longitude, latitude));
	}

	function renderFillAreaPolygon(geojson: string, Cesium: any, v: any): any {
		try {
			const poly = JSON.parse(geojson) as { coordinates: number[][][] };
			const ring = poly.coordinates[0];
			const positions = ring.map(([lon, lat]: number[]) => Cesium.Cartesian3.fromDegrees(lon, lat, 0));
			return v.entities.add({
				polygon: {
					hierarchy: new Cesium.PolygonHierarchy(positions),
					material: Cesium.Color.fromCssColorString('#22c55e').withAlpha(0.22),
					outline: true,
					outlineColor: Cesium.Color.fromCssColorString('#22c55e').withAlpha(0.95),
					outlineWidth: 2
				}
			});
		} catch (err) {
			console.warn('Failed to render fill area polygon', err);
			return null;
		}
	}

	function renderExclusionAreaPolygon(geojson: string, Cesium: any, v: any): any {
		try {
			const poly = JSON.parse(geojson) as { coordinates: number[][][] };
			const ring = poly.coordinates[0];
			const positions = ring.map(([lon, lat]: number[]) => Cesium.Cartesian3.fromDegrees(lon, lat, 0));
			return v.entities.add({
				polygon: {
					hierarchy: new Cesium.PolygonHierarchy(positions),
					material: Cesium.Color.fromCssColorString('#ef4444').withAlpha(0.25),
					outline: true,
					outlineColor: Cesium.Color.fromCssColorString('#ef4444').withAlpha(0.95),
					outlineWidth: 2
				}
			});
		} catch (err) {
			console.warn('Failed to render exclusion area polygon', err);
			return null;
		}
	}

	function renderRoadPolyline(road: DrawnRoad, Cesium: any, v: any): any {
		try {
			const line = JSON.parse(road.lineGeojson) as { coordinates: number[][] };
			const coords = line.coordinates;
			if (!Array.isArray(coords) || coords.length < 2) return null;

			const entities: any[] = [];
			const halfWidthM = Math.max(0.5, road.widthM / 2);

			for (let i = 0; i < coords.length - 1; i++) {
				const a = coords[i];
				const b = coords[i + 1];
				const aLon = a[0], aLat = a[1], bLon = b[0], bLat = b[1];

				const meanLatRad = ((aLat + bLat) / 2) * Math.PI / 180;
				const metersPerDegLat = 111320;
				const metersPerDegLon = 111320 * Math.cos(meanLatRad);

				const dx = (bLon - aLon) * metersPerDegLon;
				const dy = (bLat - aLat) * metersPerDegLat;
				const segLen = Math.hypot(dx, dy);
				if (segLen < 0.001) continue;

				// Unit normal gives left/right offsets from the centerline.
				const nx = -dy / segLen;
				const ny = dx / segLen;

				const offLon = (nx * halfWidthM) / metersPerDegLon;
				const offLat = (ny * halfWidthM) / metersPerDegLat;

				const leftA: [number, number] = [aLon + offLon, aLat + offLat];
				const leftB: [number, number] = [bLon + offLon, bLat + offLat];
				const rightB: [number, number] = [bLon - offLon, bLat - offLat];
				const rightA: [number, number] = [aLon - offLon, aLat - offLat];

				const ring = [leftA, leftB, rightB, rightA, leftA];
				entities.push(v.entities.add({
					polygon: {
						hierarchy: new Cesium.PolygonHierarchy(
							ring.map(([lon, lat]) => Cesium.Cartesian3.fromDegrees(lon, lat, 0))
						),
						material: Cesium.Color.fromCssColorString('#c4b5fd').withAlpha(0.45),
						height: 0,
						heightReference: Cesium.HeightReference.CLAMP_TO_GROUND,
						outline: false
					}
				}));
			}

			const centerPositions = coords.map(([lon, lat]: number[]) => Cesium.Cartesian3.fromDegrees(lon, lat, 0));
			entities.push(v.entities.add({
				polyline: {
					positions: centerPositions,
					width: 4,
					material: Cesium.Color.fromCssColorString('#6d28d9').withAlpha(0.9),
					clampToGround: true,
					zIndex: 10
				}
			}));

			return entities;
		} catch (err) {
			console.warn('Failed to render road polyline', err);
			return null;
		}
	}

	function rerenderAllMapOverlays() {
		const doRender = (tries: number) => {
			const v = viewer ?? cesiumViewer?.getViewer();
			if (!v) {
				if (tries > 0) setTimeout(() => doRender(tries - 1), 300);
				return;
			}
			import('cesium').then((Cesium) => {
				// Clear old fill area entities
				for (const e of fillAreaEntities) {
					if (v.entities.contains(e)) v.entities.remove(e);
				}
				fillAreaEntities = fillAreas.map((g) => renderFillAreaPolygon(g, Cesium, v)).filter(Boolean);

				// Clear old exclusion entities
				for (const e of exclusionEntities) {
					if (v.entities.contains(e)) v.entities.remove(e);
				}
				exclusionEntities = exclusionAreas.map((g) => renderExclusionAreaPolygon(g, Cesium, v)).filter(Boolean);

				// Clear old road entities
				for (const e of roadEntities) {
					if (v.entities.contains(e)) v.entities.remove(e);
				}
				roadEntities = drawnRoads.flatMap((r) => {
					const rendered = renderRoadPolyline(r, Cesium, v);
					if (!rendered) return [];
					return Array.isArray(rendered) ? rendered : [rendered];
				});
			});
		};
		doRender(30);
	}

	// legacy single-polygon render kept for boundary display
	function renderPersistedSitePolygon(geojson: string) {
		const bounds = parsePolygonBounds(geojson);
		if (!bounds) return;

		const doRender = (tries: number) => {
			const v = viewer ?? cesiumViewer?.getViewer();
			if (!v) {
				if (tries > 0) setTimeout(() => doRender(tries - 1), 300);
				return;
			}
			import('cesium').then((Cesium) => {
				try {
					const poly = JSON.parse(geojson) as { coordinates: number[][][] };
					const ring = poly.coordinates[0];
					const positions = ring.map(([lon, lat]) => Cesium.Cartesian3.fromDegrees(lon, lat, 0));

					if (persistedSiteEntity && v.entities.contains(persistedSiteEntity)) {
						v.entities.remove(persistedSiteEntity);
					}

					persistedSiteEntity = v.entities.add({
						polygon: {
							hierarchy: new Cesium.PolygonHierarchy(positions),
							material: Cesium.Color.fromCssColorString('#22c55e').withAlpha(0.22),
							outline: true,
							outlineColor: Cesium.Color.fromCssColorString('#22c55e').withAlpha(0.95),
							outlineWidth: 2
						}
					});
				} catch (err) {
					console.warn('Failed to render persisted site polygon', err);
				}
			});
		};
		doRender(30);
	}

	function renderBoundaryPolygon(geojson: string) {
		const bounds = parsePolygonBounds(geojson);
		if (!bounds) return;

		const doRender = (tries: number) => {
			const v = viewer ?? cesiumViewer?.getViewer();
			if (!v) {
				if (tries > 0) setTimeout(() => doRender(tries - 1), 300);
				return;
			}
			import('cesium').then((Cesium) => {
				try {
					const poly = JSON.parse(geojson) as { coordinates: number[][][] };
					const ring = poly.coordinates[0];
					const positions = ring.map(([lon, lat]) => Cesium.Cartesian3.fromDegrees(lon, lat, 0));

					if (persistedBoundaryEntity && v.entities.contains(persistedBoundaryEntity)) {
						v.entities.remove(persistedBoundaryEntity);
					}

					persistedBoundaryEntity = v.entities.add({
						polyline: {
							positions,
							width: 3,
							material: Cesium.Color.fromCssColorString('#f59e0b').withAlpha(0.95),
							clampToGround: true
						}
					});
				} catch (err) {
					console.warn('Failed to render persisted boundary polygon', err);
				}
			});
		};
		doRender(30);
	}

	async function loadTilesForCurrentSite(layoutId: string, polygonGeojson: string) {
		const bounds = parsePolygonBounds(polygonGeojson);
		if (bounds) {
			const padLon = Math.max((bounds.maxLon - bounds.minLon) * 0.15, 0.0015);
			const padLat = Math.max((bounds.maxLat - bounds.minLat) * 0.15, 0.0015);
			await loadTilesForViewport(
				layoutId,
				bounds.minLon - padLon,
				bounds.minLat - padLat,
				bounds.maxLon + padLon,
				bounds.maxLat + padLat,
				0
			);
			return;
		}

		const cam = $camera;
		await loadTilesForViewport(layoutId, cam.longitude - 0.02, cam.latitude - 0.02, cam.longitude + 0.02, cam.latitude + 0.02, 0);
	}

	async function loadTilesForAllAreas(layoutId: string) {
		if (fillAreas.length === 0) {
			const cam = $camera;
			await loadTilesForViewport(layoutId, cam.longitude - 0.02, cam.latitude - 0.02, cam.longitude + 0.02, cam.latitude + 0.02, 0);
			return;
		}
		// Union bounds across all fill areas
		let minLon = Number.POSITIVE_INFINITY, minLat = Number.POSITIVE_INFINITY;
		let maxLon = Number.NEGATIVE_INFINITY, maxLat = Number.NEGATIVE_INFINITY;
		for (const geojson of fillAreas) {
			const b = parsePolygonBounds(geojson);
			if (!b) continue;
			if (b.minLon < minLon) minLon = b.minLon;
			if (b.minLat < minLat) minLat = b.minLat;
			if (b.maxLon > maxLon) maxLon = b.maxLon;
			if (b.maxLat > maxLat) maxLat = b.maxLat;
		}
		if (!Number.isFinite(minLon)) {
			const cam = $camera;
			await loadTilesForViewport(layoutId, cam.longitude - 0.02, cam.latitude - 0.02, cam.longitude + 0.02, cam.latitude + 0.02, 0);
			return;
		}
		const padLon = Math.max((maxLon - minLon) * 0.15, 0.0015);
		const padLat = Math.max((maxLat - minLat) * 0.15, 0.0015);
		await loadTilesForViewport(layoutId, minLon - padLon, minLat - padLat, maxLon + padLon, maxLat + padLat, 0);
	}

	function flyToSite(geojson: string, lat: number, lon: number, areaSqm: number) {
		// Derive a camera height that frames the site polygon comfortably.
		// area in m² → side ≈ sqrt(area), then multiply by ~2 to add margin.
		const side = Math.sqrt(Math.max(areaSqm, 10000));
		const height = Math.max(side * 2, 500);

		// Prefer centroid from geojson if lat/lon stored on site are valid,
		// fall back to computing from the polygon ring.
		let flyLon = lon;
		let flyLat = lat;
		// Use polygon centroid when the provided coords are missing (0 or unset).
		if ((!flyLon && !flyLat) || (flyLon === 0 && flyLat === 0)) {
			try {
				const poly = JSON.parse(geojson) as { type: string; coordinates: number[][][] };
				if (poly.type === 'Polygon' && poly.coordinates?.[0]?.length) {
					const ring = poly.coordinates[0];
					flyLon = ring.reduce((s, c) => s + c[0], 0) / ring.length;
					flyLat = ring.reduce((s, c) => s + c[1], 0) / ring.length;
				}
			} catch { /* ignore */ }
		}

		if (!flyLon && !flyLat) return;

		// The viewer may not be mounted yet (map is still initialising).
		// Retry until the Cesium viewer itself is initialised (not just the component binding),
		// because flyTo silently returns when the inner viewer is null.
		const attempt = (tries: number) => {
			if (cesiumViewer?.getViewer()) {
				cesiumViewer.flyTo(flyLon, flyLat, height);
			} else if (tries > 0) {
				setTimeout(() => attempt(tries - 1), 300);
			}
		};
		attempt(30); // up to ~9 s
	}

	// Keyboard shortcuts
	onMount(() => {
		async function handleKeyboard(e: KeyboardEvent) {
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
					case 'g': activeTool.set('place-pin'); break;
				case 'b': activeTool.set('draw-boundary'); break;
				case 'a': activeTool.set('draw-area'); break;
				case 'x': activeTool.set('draw-exclusion'); break;
				case 'r': activeTool.set('draw-road'); break;
				case 'p': activeTool.set('place-component'); break;
				case 'm': activeTool.set('measure'); break;
				case 'd': activeTool.set('draw-dimension'); break;
				case 'i': activeTool.set('insert-block'); break;
				// View shortcuts
				case '1': activeView.set('design'); break;
				case '2': activeView.set('cad'); break;
				case '3': activeView.set('simulate'); break;
				case '4': activeView.set('electrical'); break;
				case '7': activeView.set('transmission'); break;
				case '8': activeView.set('commissioning'); break;
				case '5': activeView.set('reports'); break;
				case '6': activeView.set('financial'); break;
				// Help
				case '?': showShortcuts = !showShortcuts; break;
				// Escape
				case 'escape':
					selectedEntityId.set(null);
					activeTool.set('select');
					disarmCadMapBlockInsertion();
					clearPendingAssetPlacement();
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
					} else if (!(await deleteMostRecentOverlay())) {
						toast.info('Nothing to delete. Select an item, or press Ctrl+Z to undo your last action.');
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

	async function deleteMostRecentOverlay(): Promise<boolean> {
		const projectId = $activeProject?.id;
		const layoutId = $activeLayoutId;

		if ($components.length > 0) {
			const lastComponent = $components[$components.length - 1];
			try {
				await layoutApi.removeComponent(lastComponent.id);
				if (layoutId) await loadComponents(layoutId);
				toast.success('Deleted last placed component');
				return true;
			} catch (err) {
				console.error('Failed to delete component:', err);
				toast.error('Failed to delete last component');
				return false;
			}
		}

		if (drawnRoads.length > 0) {
			const removedRoad = drawnRoads[drawnRoads.length - 1];
			drawnRoads = drawnRoads.slice(0, -1);
			if (projectId) saveRoadsToLocalStorage(projectId);
			rerenderAllMapOverlays();
			pushAction({
				type: 'delete-entity',
				description: 'Delete road',
				undo: () => {
					drawnRoads = [...drawnRoads, removedRoad];
					if (projectId) saveRoadsToLocalStorage(projectId);
					rerenderAllMapOverlays();
				},
				redo: () => {
					drawnRoads = drawnRoads.slice(0, -1);
					if (projectId) saveRoadsToLocalStorage(projectId);
					rerenderAllMapOverlays();
				}
			});
			toast.success('Deleted last road');
			return true;
		}

		if (exclusionAreas.length > 0) {
			const removedExclusion = exclusionAreas[exclusionAreas.length - 1];
			exclusionAreas = exclusionAreas.slice(0, -1);
			if (projectId) saveExclusionAreasToLocalStorage(projectId);
			rerenderAllMapOverlays();
			pushAction({
				type: 'delete-entity',
				description: 'Delete exclusion zone',
				undo: () => {
					exclusionAreas = [...exclusionAreas, removedExclusion];
					if (projectId) saveExclusionAreasToLocalStorage(projectId);
					rerenderAllMapOverlays();
				},
				redo: () => {
					exclusionAreas = exclusionAreas.slice(0, -1);
					if (projectId) saveExclusionAreasToLocalStorage(projectId);
					rerenderAllMapOverlays();
				}
			});
			toast.success('Deleted last exclusion zone');
			return true;
		}

		if (fillAreas.length > 0) {
			const removedArea = fillAreas[fillAreas.length - 1];
			fillAreas = fillAreas.slice(0, -1);
			if (projectId) saveFillAreasToLocalStorage(projectId);
			rerenderAllMapOverlays();
			pushAction({
				type: 'delete-entity',
				description: 'Delete solar area',
				undo: () => {
					fillAreas = [...fillAreas, removedArea];
					if (projectId) saveFillAreasToLocalStorage(projectId);
					rerenderAllMapOverlays();
				},
				redo: () => {
					fillAreas = fillAreas.slice(0, -1);
					if (projectId) saveFillAreasToLocalStorage(projectId);
					rerenderAllMapOverlays();
				}
			});
			toast.success('Deleted last solar area');
			return true;
		}

		return false;
	}

	function handleBoundaryComplete(e: CustomEvent<{ positions: { longitude: number; latitude: number }[] }>) {
		const coords = sanitizePolygonCoords(
			e.detail.positions.map((p: any) => [p.longitude, p.latitude] as [number, number])
		);
		if (coords.length < 3) {
			toast.error('Boundary requires at least 3 valid points');
			return;
		}
		if (pickingProjectFarmBoundary) {
			pickedProjectBoundaryVertices = coords;
			clearPreviewBoundaryPolygon();
			pickingProjectFarmBoundary = false;
			showDashboard = true;
			activeTool.set('select');
			toast.success(`Farm boundary captured (${coords.length} vertices)`);
			return;
		}
		const ring = [...coords, coords[0]];
		const geojson = JSON.stringify({ type: 'Polygon', coordinates: [ring] });
		siteBoundaryGeoJson = geojson;
		if ($activeProject?.id && typeof localStorage !== 'undefined') {
			localStorage.setItem(`site-boundary-${$activeProject.id}`, geojson);
		}
		renderBoundaryPolygon(geojson);
		void saveSitePolygon(coords, 'Boundary');

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
		zonePlan = null;
		const coords = sanitizePolygonCoords(
			e.detail.positions.map((p: any) => [p.longitude, p.latitude] as [number, number])
		);
		if (coords.length < 3) {
			toast.error('Panel area requires at least 3 valid points');
			return;
		}
		const ring = [...coords, coords[0]];
		const newAreaGeojson = JSON.stringify({ type: 'Polygon', coordinates: [ring] });
		const prevAreas = [...fillAreas];
		fillAreas = [...fillAreas, newAreaGeojson];
		if ($activeProject?.id) saveFillAreasToLocalStorage($activeProject.id);
		rerenderAllMapOverlays();

		pushAction({
			type: 'draw-area',
			description: `Draw solar area #${fillAreas.length}`,
			undo: () => { fillAreas = prevAreas; rerenderAllMapOverlays(); },
			redo: () => { fillAreas = [...prevAreas, newAreaGeojson]; rerenderAllMapOverlays(); }
		});

		// Immediately move to road drawing workflow after area selection.
		activeTool.set('draw-road');
		toast.success(`Solar area #${fillAreas.length} added. Now mark Road A -> B; width prompt will appear automatically.`);
	}

	function handleExclusionComplete(e: CustomEvent<{ positions: { longitude: number; latitude: number }[] }>) {
		const coords = sanitizePolygonCoords(
			e.detail.positions.map((p: any) => [p.longitude, p.latitude] as [number, number])
		);
		if (coords.length < 3) {
			toast.error('Exclusion zone requires at least 3 valid points');
			return;
		}
		const ring = [...coords, coords[0]];
		const newExclusionGeojson = JSON.stringify({ type: 'Polygon', coordinates: [ring] });
		const prevExclusions = [...exclusionAreas];
		exclusionAreas = [...exclusionAreas, newExclusionGeojson];
		layerVisibility.update((current) => ({ ...current, boundary: true }));
		if ($activeProject?.id) saveExclusionAreasToLocalStorage($activeProject.id);
		rerenderAllMapOverlays();

		pushAction({
			type: 'draw-area',
			description: `Draw exclusion zone #${exclusionAreas.length}`,
			undo: () => { exclusionAreas = prevExclusions; rerenderAllMapOverlays(); },
			redo: () => { exclusionAreas = [...prevExclusions, newExclusionGeojson]; rerenderAllMapOverlays(); }
		});
		toast.success(`Exclusion zone #${exclusionAreas.length} added (panels will skip this area).`);
	}

	function handleRoadComplete(e: CustomEvent<{ positions: { longitude: number; latitude: number }[] }>) {
		if (e.detail.positions.length < 2) return;
		pendingRoadPositions = e.detail.positions;
		pendingRoadWidthM = 8;
		showRoadWidthDialog = true;
	}

	function confirmRoadWidth() {
		if (!pendingRoadPositions) return;
		showRoadWidthDialog = false;
		const lineGeojson = JSON.stringify({
			type: 'LineString',
			coordinates: pendingRoadPositions.map((p) => [p.longitude, p.latitude])
		});
		const newRoad: DrawnRoad = { lineGeojson, widthM: pendingRoadWidthM };
		const prevRoads = [...drawnRoads];
		drawnRoads = [...drawnRoads, newRoad];
		layerVisibility.update((current) => ({ ...current, boundary: true, cables: true }));
		if ($activeProject?.id) saveRoadsToLocalStorage($activeProject.id);
		rerenderAllMapOverlays();
		pushAction({
			type: 'draw-area',
			description: `Draw road ${pendingRoadWidthM}m wide`,
			undo: () => { drawnRoads = prevRoads; rerenderAllMapOverlays(); },
			redo: () => { drawnRoads = [...prevRoads, newRoad]; rerenderAllMapOverlays(); }
		});
		toast.success(`Road added (${pendingRoadWidthM}m wide, ${drawnRoads.length} road(s) total). Will be used by transmission routing.`);
		pendingRoadPositions = null;
	}

	function handleMeasureComplete(e: CustomEvent<{ distance: number }>) {
		const dist = e.detail.distance;
		const label = dist >= 1000
			? `${(dist / 1000).toFixed(2)} km`
			: `${dist.toFixed(1)} m`;
		addEntity('measurement', '', [], { distance: dist });
		toast.info(`Measured distance: ${label}`);
	}

	async function handleDimensionComplete(e: CustomEvent<{ start: { longitude: number; latitude: number }; end: { longitude: number; latitude: number }; distance: number }>) {
		const { start, end, distance } = e.detail;
		const text = distance >= 1000 ? `${(distance / 1000).toFixed(2)} km` : `${distance.toFixed(2)} m`;

		const geojson = JSON.stringify({
			type: 'LineString',
			coordinates: [
				[start.longitude, start.latitude],
				[end.longitude, end.latitude]
			]
		});
		const entityId = addEntity('measurement', geojson, [], { distance, kind: 'dimension', label: text });

		pushAction({
			type: 'draw-dimension',
			description: `Dimension ${text}`,
			undo: () => {
				removeEntity(entityId);
			},
			redo: () => {
				addEntity('measurement', geojson, [], { distance, kind: 'dimension', label: text });
			}
		});

		try {
			await createCadDimensionFromMap({
				start: { x: start.longitude, y: start.latitude },
				end: { x: end.longitude, y: end.latitude }
			});
			toast.success(`Dimension committed: ${text}`);
		} catch (err) {
			console.error('Failed to commit CAD dimension:', err);
			toast.error('Dimension drawn locally but CAD commit failed');
		}
	}

	function handleComponentPlace(e: CustomEvent<{ longitude: number; latitude: number }>) {
		const { longitude, latitude } = e.detail;

		if (pendingCableStart) {
			const start = pendingCableStart;
			clearPendingAssetPlacement();
			void drawCableConnection(start, { longitude, latitude });
			activeTool.set('select');
			toast.success(
				`Cable routed from (${start.latitude.toFixed(4)}, ${start.longitude.toFixed(4)}) to (${latitude.toFixed(4)}, ${longitude.toFixed(4)})`
			);
			return;
		}

		if (pendingCableAssetName) {
			pendingCableStart = { longitude, latitude, name: pendingCableAssetName };
			toast.info('Cable start point set. Click second point to complete A to B connection.');
			return;
		}

		if (isPanelType(pendingAssetType)) {
			if (fillAreas.length === 0) {
				toast.error('Draw solar area first. Panels can only be placed inside the selected area.');
				return;
			}
			if (!isPointInFillArea(longitude, latitude)) {
				toast.error('Panel placement is restricted to the drawn solar areas.');
				return;
			}
		}

		const geojson = JSON.stringify({ type: 'Point', coordinates: [longitude, latitude] });
		const assetType = normalizeAssetType(pendingAssetType);
		const assetName = pendingAssetName || 'component';
		const metadataJson = buildComponentMetadataJson();
		const entityId = addEntity('component', geojson, [], {
			type: assetType,
			name: assetName,
			longitude,
			latitude,
			metadata_json: metadataJson
		});

		pushAction({
			type: 'place-component',
			description: `Place ${assetName}`,
			undo: () => {
				const removed = removeEntity(entityId);
				if (removed) removeCesiumEntities(removed.cesiumEntityIds);
			},
			redo: () => {
				addEntity('component', geojson, [], {
					type: assetType,
					name: assetName,
					longitude,
					latitude,
					metadata_json: metadataJson
				});
			}
		});

		const layoutId = $activeLayoutId;
		if (layoutId) {
			void layoutApi.placeComponent(layoutId, {
				asset_id: pendingAssetId,
				component_type: assetType,
				position: { longitude, latitude, elevation: 0 },
				rotation: 0,
				metadata_json: metadataJson
			}).then(() => loadComponents(layoutId)).catch((err) => {
				console.error('Failed to persist placed component:', err);
			});
		}

		activeTool.set('select');
		clearPendingAssetPlacement();
		toast.info(`${assetName} placed at ${latitude.toFixed(4)}, ${longitude.toFixed(4)}`);
	}

	function handlePinPlace(e: CustomEvent<{ longitude: number; latitude: number }>) {
		if (pickingProjectGridConnection) {
			pickedProjectLat = e.detail.latitude;
			pickedProjectLon = e.detail.longitude;
			pickingProjectGridConnection = false;
			showDashboard = true;
			activeTool.set('select');
			toast.success(`Grid connection picked: ${e.detail.latitude.toFixed(5)}, ${e.detail.longitude.toFixed(5)}`);
		} else {
			void setProjectPin(e.detail.longitude, e.detail.latitude);
			toast.success(`Project pin set at ${e.detail.latitude.toFixed(4)}, ${e.detail.longitude.toFixed(4)}`);
			activeTool.set('select');
		}
	}

	async function handleBlockInsertPlace(e: CustomEvent<{ longitude: number; latitude: number }>) {
		const { longitude, latitude } = e.detail;
		const { pendingMapInsertBlockId } = get(cadWorkspace);
		const blockDefinitionId = pendingMapInsertBlockId;

		if (!blockDefinitionId) {
			toast.error('Select a block definition before placing it on the map');
			activeTool.set('select');
			disarmCadMapBlockInsertion();
			return;
		}

		try {
			await insertCadBlockReference({ blockDefinitionId, x: longitude, y: latitude });
			cesiumViewer?.flyTo(longitude, latitude, 1200);
			const matchedBlock = getCadBlockDefinitions(get(cadWorkspace).revision ?? null)
				.find((candidate) => candidate.blockDefinitionId === blockDefinitionId);
			const blockName = matchedBlock ? matchedBlock.name : 'block';
			toast.success(`Placed ${blockName} at ${latitude.toFixed(4)}, ${longitude.toFixed(4)}`);
		} catch (err) {
			console.error('Failed to insert CAD block reference:', err);
			toast.error('Map placement failed for the selected block definition');
		} finally {
			disarmCadMapBlockInsertion();
			activeTool.set('select');
		}
	}

	async function handleAssetSelect(
		e: CustomEvent<{
			type: string;
			name: string;
			id: string;
			model3dPath: string;
			dimensions: { widthMm: number; heightMm: number; depthMm: number };
		}>
	) {
		const type = normalizeAssetType(e.detail.type);
		const { name, id, model3dPath, dimensions } = e.detail;
		pendingAssetType = type;
		pendingAssetName = name;
		pendingAssetId = id;
		pendingAssetModel3dPath = model3dPath;
		pendingAssetDimensions = {
			widthMm: Number(dimensions?.widthMm ?? 0),
			heightMm: Number(dimensions?.heightMm ?? 0),
			depthMm: Number(dimensions?.depthMm ?? 0)
		};
		if (isCableType(type)) {
			pendingCableStart = null;
			pendingCableAssetName = name;
			activeTool.set('place-component');
			toast.info('Cable mode armed. Click map for Point A, then Point B.');
			return;
		}
		pendingCableAssetName = '';
		// Arm the tool to place the asset on the map
		activeTool.set('place-component');
		toast.info(`Click on the map to place ${name}`);
	}

	async function handleDrop(
		e: CustomEvent<{
			type: string;
			name: string;
			id: string;
			model3dPath: string;
			dimensions: { widthMm: number; heightMm: number; depthMm: number };
			longitude: number;
			latitude: number;
		}>
	) {
		const type = normalizeAssetType(e.detail.type);
		const { name, id, model3dPath, dimensions, longitude, latitude } = e.detail;

		if (isCableType(type)) {
			pendingCableStart = { longitude, latitude, name };
			pendingCableAssetName = name;
			pendingAssetType = type;
			pendingAssetName = name;
			pendingAssetId = id;
			pendingAssetModel3dPath = model3dPath;
			pendingAssetDimensions = {
				widthMm: Number(dimensions?.widthMm ?? 0),
				heightMm: Number(dimensions?.heightMm ?? 0),
				depthMm: Number(dimensions?.depthMm ?? 0)
			};
			activeTool.set('place-component');
			toast.info('Cable start point set. Click second point to complete A to B connection.');
			return;
		}

		pendingCableAssetName = '';
		pendingAssetType = type;
		pendingAssetName = name;
		pendingAssetId = id;
		pendingAssetModel3dPath = model3dPath;
		pendingAssetDimensions = {
			widthMm: Number(dimensions?.widthMm ?? 0),
			heightMm: Number(dimensions?.heightMm ?? 0),
			depthMm: Number(dimensions?.depthMm ?? 0)
		};

		if (isPanelType(type)) {
			if (fillAreas.length === 0) {
				toast.error('Draw solar area first. Panels can only be placed inside the selected area.');
				return;
			}
			if (!isPointInFillArea(longitude, latitude)) {
				toast.error('Panel placement is restricted to the drawn solar areas.');
				return;
			}
		}

		const geojson = JSON.stringify({ type: 'Point', coordinates: [longitude, latitude] });
		const metadataJson = buildComponentMetadataJson();
		const entityId = addEntity('component', geojson, [], {
			type,
			name,
			longitude,
			latitude,
			metadata_json: metadataJson
		});

		pushAction({
			type: 'place-component',
			description: `Place ${name}`,
			undo: () => {
				const removed = removeEntity(entityId);
				if (removed) removeCesiumEntities(removed.cesiumEntityIds);
			},
			redo: () => {
				addEntity('component', geojson, [], {
					type,
					name,
					longitude,
					latitude,
					metadata_json: metadataJson
				});
			}
		});

		// Persist to backend and refresh the components layer
		const layoutId = $activeLayoutId;
		if (layoutId) {
			try {
				await layoutApi.placeComponent(layoutId, {
					asset_id: id,
					component_type: type,
					position: { longitude, latitude, elevation: 0 },
					rotation: 0,
					metadata_json: metadataJson
				});
				await loadComponents(layoutId);
			} catch (err) {
				console.error('Failed to persist placed component:', err);
			}
		}
		toast.success(`Placed ${name} at ${latitude.toFixed(4)}, ${longitude.toFixed(4)}`);
		clearPendingAssetPlacement();
	}

	async function runSingleGeneration(layout: NonNullable<typeof $activeLayout>, params: PanelArrayParams): Promise<{ panels: number; capacityKw: number }> {
		const generation = await layoutApi.generatePanelArray(layout.id, params);
		applyLayoutGenerationSummary(layout.id, {
			panels: generation.panels_created,
			capacityKw: generation.capacity_kw,
			tiles: generation.tiles_created
		});
		return { panels: generation.panels_created, capacityKw: generation.capacity_kw };
	}

	type PanelGenerationBatch = {
		areas: string[];
		areaOverrides?: { tilt_angle: number; azimuth: number }[];
		baseParams: Omit<PanelArrayParams, 'fill_area_geojson'>;
	};

	type PlanningContractBaseline = {
		row_spacing_m?: number;
	};

	function readPlanningContractBaseline(projectId: string): PlanningContractBaseline | null {
		if (typeof localStorage === 'undefined') return null;
		const raw = localStorage.getItem(`solar3d:planning-contract:${projectId}`);
		if (!raw) return null;
		try {
			return JSON.parse(raw) as PlanningContractBaseline;
		} catch {
			return null;
		}
	}

	function normalizeGenerationBaseParams(projectId: string, baseParams: Omit<PanelArrayParams, 'fill_area_geojson'>): Omit<PanelArrayParams, 'fill_area_geojson'> {
		const baseline = readPlanningContractBaseline(projectId);
		if ((baseParams.row_spacing ?? 0) > 0 || (baseline?.row_spacing_m ?? 0) <= 0) {
			return baseParams;
		}

		return {
			...baseParams,
			row_spacing: Number(baseline?.row_spacing_m ?? baseParams.row_spacing ?? 0)
		};
	}

	function resolveAutoGenerationTarget(projectId: string): { areas: string[]; boundaryGeojson: string; usedBoundaryFallback: boolean } | null {
		if (fillAreas.length > 0) {
			return {
				areas: fillAreas,
				boundaryGeojson: siteBoundaryGeoJson || fillAreas[0],
				usedBoundaryFallback: false
			};
		}

		const boundaryGeojson = siteBoundaryGeoJson || (typeof localStorage !== 'undefined'
			? localStorage.getItem(`site-boundary-${projectId}`) ?? ''
			: '');

		if (!boundaryGeojson) return null;

		return {
			areas: [boundaryGeojson],
			boundaryGeojson,
			usedBoundaryFallback: true
		};
	}

	function deriveInfrastructureAwareAreas(input: {
		baseAreas: string[];
		boundaryGeojson: string;
		plannedZones: ZonePlanResult | null;
		exclusionAreaGeojsons: string[];
	}): string[] {
		const masks = input.plannedZones?.zones ?? [];
		const sourceAreas = input.baseAreas.length > 0 ? input.baseAreas : [input.boundaryGeojson];
		const clippedAreas = sourceAreas.flatMap((area) =>
			buildInfrastructureAwareGenerationAreas({
				baseAreaGeojson: area,
				plannedZones: masks,
				exclusionAreaGeojsons: input.exclusionAreaGeojsons
			})
		);

		return clippedAreas.length > 0 ? clippedAreas : sourceAreas;
	}

	async function executePanelGeneration(layout: NonNullable<typeof $activeLayout>, request: PanelGenerationBatch): Promise<{ totalPanels: number; totalCapacityKw: number }> {
		const { areas, baseParams, areaOverrides } = request;

		if (areas.length === 0) {
			throw new Error('No solar areas drawn. Use the Solar Area tool first.');
		}

		if (use3DPanels && panelRenderer3DRef?.clearAll) panelRenderer3DRef.clearAll();
		else if (panelRendererRef?.clearAll) panelRendererRef.clearAll();
		visibleTiles.set([]);

		let totalPanels = 0;
		let totalCapacityKw = 0;
		for (let i = 0; i < areas.length; i++) {
			toast.info(`Generating area ${i + 1} of ${areas.length}…`);
			const perArea = areaOverrides?.[i];
			const result = await runSingleGeneration(layout, {
				...baseParams,
				tilt_angle: Number.isFinite(perArea?.tilt_angle) ? perArea!.tilt_angle : baseParams.tilt_angle,
				azimuth: Number.isFinite(perArea?.azimuth) ? perArea!.azimuth : baseParams.azimuth,
				fill_area_geojson: areas[i],
				terrain_layer_id: i === 0 ? '' : '00000000-0000-0000-0000-00000000a11e'
			});
			totalPanels += result.panels;
			totalCapacityKw += result.capacityKw;
		}

		await loadTilesForAllAreas(layout.id);
		activeTool.set('select');

		const savedTiles = [...($visibleTiles || [])];
		pushAction({
			type: 'generate-array',
			description: `Generate ${areas.length} panel area(s)`,
			undo: () => { visibleTiles.set([]); },
			redo: () => { visibleTiles.set(savedTiles); }
		});

		return { totalPanels, totalCapacityKw };
	}

	async function handleGenerateMany(e: CustomEvent<{ areas: string[]; exclusionAreas?: string[]; areaOverrides?: { tilt_angle: number; azimuth: number }[]; baseParams: Omit<PanelArrayParams, 'fill_area_geojson'> }>) {
		let layout = $activeLayout;
		if (!layout) {
			try { layout = await ensureActiveLayout(); } catch (err) {
				const message = err instanceof Error ? err.message : 'Unknown error';
				toast.error(`Layout service error: ${message}`);
				return;
			}
		}
		if (!layout) { toast.error('No active layout found.'); return; }

		const { areas, baseParams, areaOverrides } = e.detail;
		if (areas.length === 0) { toast.error('No solar areas drawn. Use the Solar Area tool first.'); return; }

		isGenerating.set(true);
		const l = layout;
		try {
			const { totalPanels, totalCapacityKw } = await executePanelGeneration(l, {
				areas,
				areaOverrides,
				baseParams
			});
			toast.success(`Generated ${totalPanels.toLocaleString()} panels (${(totalCapacityKw / 1000).toFixed(2)} MW) across ${areas.length} area(s)`);
		} catch (err) {
			console.error('Panel generation failed:', err);
			const message = err instanceof Error ? err.message : String(err);
			if (message.toLowerCase().includes('no panels fit within the fill area')) {
				toast.error('No panels fit in one or more areas. Try larger areas or reduce spacing.');
			} else if (message.toLowerCase().includes('exceeds maximum allowed panel count')) {
				toast.error('Area too large: would exceed 200 000 panels. Increase spacing or draw smaller areas.');
			} else {
				toast.error(`Panel generation failed: ${message}`);
			}
		} finally {
			isGenerating.set(false);
		}
	}

	async function handleAutoGenerateLayout(e: CustomEvent<{ areaOverrides?: { tilt_angle: number; azimuth: number }[]; baseParams: Omit<PanelArrayParams, 'fill_area_geojson'> }>) {
		const projectId = $activeProject?.id;
		if (!projectId) {
			toast.error('Select a project before auto-generating layout');
			return;
		}

		const targetCapacityMw = getTargetCapacityMw();
		if (targetCapacityMw <= 0) {
			toast.error('Set project capacity in MW before auto-generating layout');
			return;
		}

		const target = resolveAutoGenerationTarget(projectId);
		if (!target) {
			toast.error('Draw a site boundary or solar area before auto-generating layout');
			return;
		}

		let layout = $activeLayout;
		if (!layout) {
			try { layout = await ensureActiveLayout(); } catch (err) {
				const message = err instanceof Error ? err.message : 'Unknown error';
				toast.error(`Layout service error: ${message}`);
				return;
			}
		}
		if (!layout) {
			toast.error('No active layout found.');
			return;
		}

		const normalizedBaseParams = normalizeGenerationBaseParams(projectId, e.detail.baseParams);
		planningBusy = true;
		isGenerating.set(true);
		try {
			if (target.usedBoundaryFallback) {
				toast.info('No solar area drawn. Using the site boundary as a provisional solar envelope.');
			}

			try {
				terrainSummary = await terrainApi.analyzeSite(projectId, target.boundaryGeojson);
				showTerrainHeatmap = true;
				terrainHeatmapMode = 'slope';
			} catch (err) {
				console.warn('Automatic terrain analysis failed:', err);
			}

			try {
				zonePlan = await layoutApi.planZones(layout.id, target.boundaryGeojson, targetCapacityMw);
			} catch (err) {
				console.warn('Automatic zone planning failed:', err);
				zonePlan = null;
			}


			const generationAreas = deriveInfrastructureAwareAreas({
				baseAreas: target.areas,
				boundaryGeojson: target.boundaryGeojson,
				plannedZones: zonePlan,
				exclusionAreaGeojsons: exclusionAreas
			});

			const { totalPanels, totalCapacityKw } = await executePanelGeneration(layout, {
				areas: generationAreas,
				areaOverrides: e.detail.areaOverrides,
				baseParams: normalizedBaseParams
			});

			const zoneSummary = zonePlan ? ` and ${zonePlan.zones.length} infrastructure zone(s)` : '';
			toast.success(`Auto-generated ${totalPanels.toLocaleString()} panels (${(totalCapacityKw / 1000).toFixed(2)} MW)${zoneSummary}`);
		} catch (err) {
			console.error('Automatic layout generation failed:', err);
			const message = err instanceof Error ? err.message : String(err);
			if (message.toLowerCase().includes('no panels fit within the fill area')) {
				toast.error('No panels fit in the selected planning envelope. Try a larger boundary or reduce spacing.');
			} else if (message.toLowerCase().includes('exceeds maximum allowed panel count')) {
				toast.error('Planning envelope too large: generation would exceed 200 000 panels. Increase spacing or define solar areas.');
			} else {
				toast.error(`Automatic layout generation failed: ${message}`);
			}
		} finally {
			planningBusy = false;
			isGenerating.set(false);
		}
	}

	async function handleGenerate(e: CustomEvent<PanelArrayParams>) {
		// Single-area generate (kept for backwards compatibility if called directly)
		await handleGenerateMany(new CustomEvent('generateMany', {
			detail: { areas: [e.detail.fill_area_geojson], baseParams: e.detail }
		}));
	}

	function handleToggleShadows(e: CustomEvent<boolean>) {
		showShadows = e.detail;
		layerVisibility.update((current) => ({ ...current, shadows: e.detail }));
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

	function handleSearchPinPlace(e: CustomEvent<{ longitude: number; latitude: number; name: string }>) {
		void setProjectPin(e.detail.longitude, e.detail.latitude);
		toast.success(`Pinned ${e.detail.name}`);
	}

	function getTargetCapacityMw(): number {
		return Number($activeProject?.target_capacity_mw ?? 0);
	}

	async function handleAnalyzeTerrain() {
		if (!$activeProject?.id || fillAreas.length === 0) {
			toast.error('Draw/select area boundary before terrain analysis');
			return;
		}
		planningBusy = true;
		try {
			terrainSummary = await terrainApi.analyzeSite($activeProject.id, fillAreas[0]);
			showTerrainHeatmap = true;
			terrainHeatmapMode = 'slope';
			toast.success('Terrain analysis complete');
		} catch (err) {
			console.error('Terrain analysis failed:', err);
			toast.error('Terrain analysis failed. Upload DEM terrain data and retry.');
		} finally {
			planningBusy = false;
		}
	}

	async function handlePlanZones() {
		if (!$activeLayout?.id || fillAreas.length === 0) {
			toast.error('Select area boundary before zone planning');
			return;
		}
		const capacityMw = getTargetCapacityMw();
		if (capacityMw <= 0) {
			toast.error('Set project capacity in MW before planning zones');
			return;
		}
		planningBusy = true;
		try {
			zonePlan = await layoutApi.planZones($activeLayout.id, fillAreas[0], capacityMw);
			toast.success('Infrastructure zone plan generated');
		} catch (err) {
			console.error('Zone planning failed:', err);
			toast.error('Zone planning failed. Verify capacity and boundary geometry.');
		} finally {
			planningBusy = false;
		}
	}

	function handleOpenProject() {
		showDashboard = false;
		pickedProjectLat = null;
		pickedProjectLon = null;
		pickedProjectBoundaryVertices = [];
		clearPreviewBoundaryPolygon();
		pickingProjectFarmBoundary = false;
		pickingProjectGridConnection = false;
	}

	function clearPreviewBoundaryPolygon() {
		previewProjectBoundaryVertices = [];
		const v = viewer ?? cesiumViewer?.getViewer();
		if (v && previewBoundaryEntity && v.entities.contains(previewBoundaryEntity)) {
			v.entities.remove(previewBoundaryEntity);
		}
		previewBoundaryEntity = null;
	}

	function layerPreviewColor(layer: string) {
		const palette = ['#38bdf8', '#f59e0b', '#22c55e', '#ef4444', '#a78bfa', '#14b8a6', '#eab308'];
		let hash = 0;
		for (let i = 0; i < layer.length; i++) {
			hash = (hash*31 + layer.charCodeAt(i)) >>> 0;
		}
		return palette[hash % palette.length];
	}

	function flyToBoundaryBounds(coords: [number, number][]) {
		if (!cesiumViewer || coords.length < 3) return;
		let minLon = Number.POSITIVE_INFINITY;
		let minLat = Number.POSITIVE_INFINITY;
		let maxLon = Number.NEGATIVE_INFINITY;
		let maxLat = Number.NEGATIVE_INFINITY;
		for (const [lon, lat] of coords) {
			if (lon < minLon) minLon = lon;
			if (lon > maxLon) maxLon = lon;
			if (lat < minLat) minLat = lat;
			if (lat > maxLat) maxLat = lat;
		}
		const centerLon = (minLon + maxLon) / 2;
		const centerLat = (minLat + maxLat) / 2;
		const spanDeg = Math.max(maxLon - minLon, maxLat - minLat, 0.001);
		const approxHeight = Math.min(Math.max(spanDeg * 180000, 800), 12000);
		cesiumViewer.flyTo(centerLon, centerLat, approxHeight);
	}

	function renderPreviewBoundaryPolygon(coords: [number, number][], layer: string) {
		const ring = [...coords, coords[0]];
		const geojson = JSON.stringify({ type: 'Polygon', coordinates: [ring] });
		const bounds = parsePolygonBounds(geojson);
		if (!bounds) return;

		previewProjectBoundaryVertices = coords;

		const doRender = (tries: number) => {
			const v = viewer ?? cesiumViewer?.getViewer();
			if (!v) {
				if (tries > 0) setTimeout(() => doRender(tries - 1), 300);
				return;
			}
			import('cesium').then((Cesium) => {
				try {
					const positions = ring.map(([lon, lat]) => Cesium.Cartesian3.fromDegrees(lon, lat, 0));
					const colorHex = layerPreviewColor(layer);
					const fill = Cesium.Color.fromCssColorString(colorHex).withAlpha(0.18);
					const outline = Cesium.Color.fromCssColorString(colorHex).withAlpha(0.95);

					if (previewBoundaryEntity && v.entities.contains(previewBoundaryEntity)) {
						v.entities.remove(previewBoundaryEntity);
					}

					previewBoundaryEntity = v.entities.add({
						polygon: {
							hierarchy: new Cesium.PolygonHierarchy(positions),
							material: fill,
							outline: true,
							outlineColor: outline,
							outlineWidth: 2,
							height: 0,
							heightReference: Cesium.HeightReference.CLAMP_TO_GROUND
						}
					});

					flyToBoundaryBounds(coords);
				} catch (err) {
					console.warn('Failed to render preview boundary polygon', err);
				}
			});
		};
		doRender(30);
	}

	function handlePreviewBoundaryCandidate(
		e: CustomEvent<{
			vertices: [number, number][];
			layer: string;
			area: number;
			entityType: string;
			sourceCrs: string;
		}>
	) {
		const coords = sanitizePolygonCoords(e.detail.vertices ?? []);
		if (coords.length < 3) {
			clearPreviewBoundaryPolygon();
			return;
		}
		renderPreviewBoundaryPolygon(coords, e.detail.layer || 'default');
	}

	function handlePickFarmBoundaryForProject() {
		showDashboard = false;
		clearPreviewBoundaryPolygon();
		pickingProjectFarmBoundary = true;
		activeTool.set('draw-boundary');
		toast.info('Draw the solar farm boundary on map and complete the polygon');
	}

	function handlePickGridConnectionForProject() {
		showDashboard = false;
		pickingProjectGridConnection = true;
		activeTool.set('place-pin');
		toast.info('Click on the map to set the grid/substation connection center');
	}

	function handleMinimapNavigate(e: CustomEvent<{ longitude: number; latitude: number }>) {
		if (cesiumViewer) {
			cesiumViewer.flyTo(e.detail.longitude, e.detail.latitude);
		}
	}

	function rotateLeft() {
		cesiumViewer?.adjustView(-10, 0);
	}

	function rotateRight() {
		cesiumViewer?.adjustView(10, 0);
	}

	function tiltUp() {
		cesiumViewer?.adjustView(0, 6);
	}

	function tiltDown() {
		cesiumViewer?.adjustView(0, -6);
	}
</script>

<svelte:head>
	<title>Solar3D - Solar EPC Design Platform</title>
</svelte:head>

	<ProjectDashboard
		open={showDashboard}
		pickedLat={pickedProjectLat}
		pickedLon={pickedProjectLon}
		pickedBoundaryVertices={pickedProjectBoundaryVertices}
		on:openProject={handleOpenProject}
		on:pickFarmBoundary={handlePickFarmBoundaryForProject}
		on:pickGridConnection={handlePickGridConnectionForProject}
		on:previewBoundaryCandidate={handlePreviewBoundaryCandidate}
		on:clearBoundaryPreview={() => clearPreviewBoundaryPolygon()}
		on:close={() => {
			showDashboard = false;
			pickedProjectLat = null;
			pickedProjectLon = null;
			pickedProjectBoundaryVertices = [];
			clearPreviewBoundaryPolygon();
			pickingProjectFarmBoundary = false;
			pickingProjectGridConnection = false;
		}}
	/>

<div class="app-container">
	<TopBar viewGuards={workflowViewGuards} phaseLabel={workflowPhaseLabel} on:blockedNav={handleBlockedNavigation} />

	<div class="main-content">
		<div class="toolbar-container">
			<Toolbar />
			<div class="phase-rail" aria-label="Workflow phase rail">
				<div class="phase-rail-header">
					<h4>Workflow Rail</h4>
					<span class="phase-badge">{workflowPhaseLabel}</span>
				</div>
				<div class="phase-context">{workflowContextDescription}</div>
				{#if workflowBlockers.length > 0}
					<div class="phase-blockers">
						{#each workflowBlockers as blocker}
							<div class="phase-blocker">{blocker}</div>
						{/each}
					</div>
				{/if}
				<div class="phase-steps">
					{#each phaseSteps as step}
						{@const stepReached = isPhaseReached(step.phase)}
						{@const stepCurrent = (($workflowState.current_phase as WorkflowPhaseName) ?? 'UNSPECIFIED') === step.phase}
						<div class="phase-step" class:reached={stepReached} class:current={stepCurrent}>
							<div class="phase-step-title">{step.label}</div>
							<div class="phase-step-desc">{step.description}</div>
						</div>
					{/each}
				</div>
			</div>
			<div class="camera-controls" aria-label="Map camera controls">
				<button class="camera-btn" on:click={rotateLeft} title="Rotate left">L</button>
				<button class="camera-btn" on:click={rotateRight} title="Rotate right">R</button>
				<button class="camera-btn" on:click={tiltUp} title="Tilt up">TU</button>
				<button class="camera-btn" on:click={tiltDown} title="Tilt down">TD</button>
			</div>
			{#if $canUndo || $canRedo}
				<div class="undo-redo">
					<button class="ur-btn" disabled={!$canUndo} on:click={() => undo()} title="Undo (Ctrl+Z)">U</button>
					<button class="ur-btn" disabled={!$canRedo} on:click={() => redo()} title="Redo (Ctrl+Y)">R</button>
				</div>
			{/if}
		</div>

		<div class="search-container">
			<MapSearch on:flyTo={handleFlyTo} on:placePin={handleSearchPinPlace} />
		</div>

		<div class="map-container" class:pan-mode={$activeTool === 'pan'}>
			<DragDropHandler {viewer} on:drop={handleDrop}>
				<CesiumViewer
					bind:this={cesiumViewer}
					satelliteEnabled={$layerVisibility.satellite}
					terrainEnabled={$layerVisibility.terrain}
				/>
			</DragDropHandler>

			{#if viewer}
				<DrawingManager
					{viewer}
					on:boundaryComplete={handleBoundaryComplete}
					on:areaComplete={handleAreaComplete}
					on:exclusionComplete={handleExclusionComplete}
					on:roadComplete={handleRoadComplete}
					on:measureComplete={handleMeasureComplete}
					on:dimensionComplete={handleDimensionComplete}
					on:blockInsertPlace={handleBlockInsertPlace}
					on:componentPlace={handleComponentPlace}
					on:pinPlace={handlePinPlace}
				/>

				{#if use3DPanels}
					<TiltedPanelRenderer bind:this={panelRenderer3DRef} {viewer} visible={$layerVisibility.panels} show3D={true} />
				{:else}
					<PanelRenderer bind:this={panelRendererRef} {viewer} visible={$layerVisibility.panels} />
				{/if}

				<ShadowRenderer
					bind:this={shadowRenderer}
					{viewer}
					visible={$layerVisibility.shadows && ($activeView !== 'simulate' || showShadows)}
					layoutId={$activeLayout?.id ?? ''}
					latitude={$camera.latitude}
					longitude={$camera.longitude}
				/>

				<ComponentRenderer {viewer} visible={true} />
				<RouteRenderer {viewer} visible={$layerVisibility.cables} />
				<TransmissionRenderer {viewer} visible={$layerVisibility.transmissionLines} />
				<ZoneRenderer {viewer} visible={$layerVisibility.zones} zones={zonePlan?.zones ?? []} />
				<TerrainHeatmap
					{viewer}
					visible={showTerrainHeatmap && $layerVisibility.terrain}
					projectId={$activeProject?.id ?? ''}
					mode={terrainHeatmapMode}
				/>
				<CadEntityRenderer {viewer} visible={true} />
				<SnapGrid {viewer} />
			{/if}

			<div class="minimap-wrapper">
				<Minimap on:navigate={handleMinimapNavigate} />
			</div>
		</div>

		<InspectorPanel
			{fillAreaGeoJson}
			{fillAreas}
			boundaryGeoJson={siteBoundaryGeoJson}
			{exclusionAreas}
			{drawnRoads}
			{terrainSummary}
			{zonePlan}
			planningBusy={planningBusy}
			on:generate={handleGenerate}
			on:generateMany={handleGenerateMany}
			on:autoGenerate={handleAutoGenerateLayout}
			on:analyzeTerrain={handleAnalyzeTerrain}
			on:planZones={handlePlanZones}
			on:timeChange={handleTimeChange}
			on:toggleShadows={handleToggleShadows}
			on:assetSelect={handleAssetSelect}
		/>
	</div>

	<StatusBar />
</div>

<ToastNotification />
<ConfirmModal />
<KeyboardShortcuts bind:open={showShortcuts} />

{#if showRoadWidthDialog}
	<div class="modal-overlay" role="dialog" aria-modal="true" aria-label="Road width">
		<div class="modal-box">
			<h3>Road Width</h3>
			<p>Enter the road width in metres. This will be used for map rendering and transmission routing.</p>
			<div class="modal-field">
				<label for="road-width-input">Width (m)</label>
				<input id="road-width-input" type="number" min="1" max="200" step="1" bind:value={pendingRoadWidthM} />
			</div>
			<div class="modal-actions">
				<button class="btn-cancel" on:click={() => { showRoadWidthDialog = false; pendingRoadPositions = null; }}>Cancel</button>
				<button class="btn-confirm" on:click={confirmRoadWidth}>Add Road</button>
			</div>
		</div>
	</div>
{/if}

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
		display: flex;
		flex-direction: column;
		gap: 8px;
	}

	.phase-rail {
		width: 260px;
		padding: 10px;
		background: rgba(22, 33, 62, 0.94);
		border: 1px solid rgba(148, 163, 184, 0.25);
		border-radius: 12px;
		backdrop-filter: blur(8px);
		box-shadow: 0 14px 32px rgba(2, 6, 23, 0.3);
	}

	.phase-rail-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		margin-bottom: 8px;
	}

	.phase-rail-header h4 {
		margin: 0;
		font-size: 12px;
		text-transform: uppercase;
		letter-spacing: 0.08em;
		color: #cbd5e1;
	}

	.phase-badge {
		font-size: 10px;
		padding: 2px 6px;
		border-radius: 4px;
		background: rgba(59, 130, 246, 0.2);
		color: #93c5fd;
	}

	.phase-context {
		font-size: 12px;
		line-height: 1.4;
		color: #cbd5e1;
		margin-bottom: 8px;
	}

	.phase-blockers {
		display: flex;
		flex-direction: column;
		gap: 4px;
		margin-bottom: 8px;
	}

	.phase-blocker {
		font-size: 11px;
		padding: 6px;
		border-radius: 6px;
		background: rgba(239, 68, 68, 0.2);
		color: #fecaca;
	}

	.phase-steps {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	.phase-step {
		padding: 7px;
		border-radius: 8px;
		border: 1px solid rgba(148, 163, 184, 0.25);
		background: rgba(15, 23, 42, 0.55);
	}

	.phase-step.reached {
		border-color: rgba(34, 197, 94, 0.45);
		background: rgba(34, 197, 94, 0.12);
	}

	.phase-step.current {
		border-color: rgba(245, 158, 11, 0.6);
		background: rgba(245, 158, 11, 0.16);
	}

	.phase-step-title {
		font-size: 12px;
		font-weight: 600;
		color: #e2e8f0;
	}

	.phase-step-desc {
		font-size: 11px;
		color: #94a3b8;
		line-height: 1.35;
	}

	.map-container {
		flex: 1;
		position: relative;
	}

	.map-container.pan-mode :global(canvas) {
		cursor: grab;
	}

	.map-container.pan-mode :global(canvas:active) {
		cursor: grabbing;
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

	.camera-controls {
		display: grid;
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 4px;
		margin-top: 8px;
		padding: 6px;
		background: rgba(22, 33, 62, 0.92);
		border: 1px solid rgba(148, 163, 184, 0.25);
		border-radius: 8px;
	}

	.camera-btn {
		height: 30px;
		border: 1px solid rgba(148, 163, 184, 0.35);
		border-radius: 6px;
		background: rgba(15, 23, 42, 0.7);
		color: #e2e8f0;
		font-size: 11px;
		font-weight: 700;
		cursor: pointer;
	}

	.camera-btn:hover {
		background: rgba(245, 158, 11, 0.2);
		border-color: rgba(245, 158, 11, 0.55);
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

	/* Road width dialog */
	.modal-overlay {
		position: fixed;
		inset: 0;
		background: rgba(0, 0, 0, 0.55);
		display: flex;
		align-items: center;
		justify-content: center;
		z-index: 9999;
	}

	.modal-box {
		background: rgba(15, 23, 42, 0.98);
		border: 1px solid rgba(148, 163, 184, 0.25);
		border-radius: 10px;
		padding: 24px;
		min-width: 300px;
		display: flex;
		flex-direction: column;
		gap: 12px;
	}

	.modal-box h3 {
		margin: 0;
		font-size: 15px;
		font-weight: 600;
		color: #e2e8f0;
	}

	.modal-box p {
		margin: 0;
		font-size: 12px;
		color: #94a3b8;
	}

	.modal-field {
		display: flex;
		flex-direction: column;
		gap: 4px;
	}

	.modal-field label {
		font-size: 11px;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		font-weight: 500;
	}

	.modal-field input {
		padding: 8px 10px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 6px;
		background: rgba(0, 0, 0, 0.4);
		color: #e2e8f0;
		font-size: 14px;
		font-family: inherit;
	}

	.modal-actions {
		display: flex;
		gap: 8px;
		justify-content: flex-end;
	}

	.btn-cancel {
		padding: 7px 14px;
		border: 1px solid rgba(148, 163, 184, 0.3);
		border-radius: 6px;
		background: transparent;
		color: #94a3b8;
		font-size: 13px;
		cursor: pointer;
	}

	.btn-confirm {
		padding: 7px 14px;
		border: none;
		border-radius: 6px;
		background: rgba(124, 58, 237, 0.85);
		color: #fff;
		font-size: 13px;
		font-weight: 600;
		cursor: pointer;
	}

	.btn-confirm:hover {
		background: rgba(124, 58, 237, 1);
	}
</style>
