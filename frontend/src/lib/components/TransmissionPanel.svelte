<script lang="ts">
	import {
		activeProject,
		activeTransmissionRouteId,
		components,
		componentEntities,
		workflowState
	} from '$lib/core/stores';
	import {
		removeTransmissionRoute,
		setTransmissionRoutes,
		transmissionRoutes,
		upsertTransmissionRoute
	} from '$lib/core/stores/transmission';
	import {
		transmissionApi,
		type ApprovalStatusValue,
		type TransmissionRoute,
		type TransmissionConstraints,
		type TransmissionProgressUpdate,
		type TransmissionVectorFeature,
		type VoltageClassValue
	} from '$lib/core/api';
	import {
		gateTransmissionApprovalAction,
		gateTransmissionReviewAction,
		transmissionWorkflowTransitions
	} from '$lib/core/domain/transmissionWorkflow';

	type OptionMeta = {
		label: string;
		pros: string;
		cons: string;
	};

	type OptionProfile = {
		label: string;
		constraints: (base: TransmissionConstraints) => TransmissionConstraints;
	};

	type RecommendationMode = 'lowest_cost' | 'shortest_distance' | 'lowest_risk';
	type RouteMode = 'overhead' | 'underground' | 'hybrid';
	type SpanBand = { min: number; max: number };
	type RouteEndpoints = { farm: { latitude: number; longitude: number }; grid: { latitude: number; longitude: number } };
	type LatLon = { latitude: number; longitude: number };

	export let drawnRoads: { lineGeojson: string; widthM: number }[] = [];

	let loading = false;
	let creating = false;
	let generatingAlternatives = false;
	let workflowBusyId = '';
	let deletingId = '';
	let errorMsg = '';
	let lastLoadedProjectId = '';
	let recommendationMode: RecommendationMode = 'lowest_cost';
	let workflowActor = 'planner-ui';
	let workflowNote = '';
	let evidenceExpandedId = '';

	let routeName = 'Grid Interconnect Route';
	let voltageClass: VoltageClassValue = '132kv';
	let routeMode: RouteMode = 'hybrid';
	let showAdvanced = false;

	let farmLongitude = 78.4867;
	let farmLatitude = 17.385;
	let gridLongitude = 78.5017;
	let gridLatitude = 17.401;
	let hasAppliedAnchorsForProject = '';

	let constraints: TransmissionConstraints = {
		min_span_m: 250,
		max_span_m: 300,
		row_width_m: 27,
		max_slope_deg: 16,
		max_deflection_deg: 40,
		slope_penalty_factor: 2,
		turn_penalty_factor: 1.8,
		water_crossing_cost_mult: 8,
		road_parallel_discount: 0.3,
		off_road_penalty: 5.0,
		road_buffer_m: 35
	};
	let previousVoltageClass: VoltageClassValue = voltageClass;

	let progress: TransmissionProgressUpdate | null = null;

	$: activeRoute = $transmissionRoutes.find((route) => route.id === $activeTransmissionRouteId) ?? null;
	$: transitionEvidence = transmissionWorkflowTransitions($workflowState.transitions);
	$: activeRouteReviewGate =
		activeRoute
			? gateTransmissionReviewAction(
					activeRoute,
					$workflowState.current_phase,
					$workflowState.active_blockers
				)
			: { allowed: false, reason: 'Select an active route first.' };
	$: activeRouteApprovalGate =
		activeRoute
			? gateTransmissionApprovalAction(
					activeRoute,
					$workflowState.current_phase,
					$workflowState.active_blockers
				)
			: { allowed: false, reason: 'Select an active route first.' };

	const enforcedSpanBands: Record<VoltageClassValue, SpanBand> = {
		'11kv': { min: 50, max: 80 },
		'33kv': { min: 80, max: 120 },
		'66kv': { min: 150, max: 200 },
		'132kv': { min: 250, max: 300 },
		'220kv': { min: 300, max: 400 },
		'400kv': { min: 300, max: 400 }
	};

	const fixedConstraintsByVoltage: Record<VoltageClassValue, TransmissionConstraints> = {
		'11kv': {
			min_span_m: 50,
			max_span_m: 80,
			row_width_m: 8,
			max_slope_deg: 20,
			max_deflection_deg: 50,
			slope_penalty_factor: 2,
			turn_penalty_factor: 1.2,
			water_crossing_cost_mult: 8,
			road_parallel_discount: 0.3,
			off_road_penalty: 5.0,
			road_buffer_m: 15
		},
		'33kv': {
			min_span_m: 80,
			max_span_m: 120,
			row_width_m: 12,
			max_slope_deg: 19,
			max_deflection_deg: 48,
			slope_penalty_factor: 2,
			turn_penalty_factor: 1.35,
			water_crossing_cost_mult: 8,
			road_parallel_discount: 0.3,
			off_road_penalty: 5.0,
			road_buffer_m: 20
		},
		'66kv': {
			min_span_m: 150,
			max_span_m: 200,
			row_width_m: 18,
			max_slope_deg: 18,
			max_deflection_deg: 45,
			slope_penalty_factor: 2,
			turn_penalty_factor: 1.5,
			water_crossing_cost_mult: 8,
			road_parallel_discount: 0.3,
			off_road_penalty: 5.0,
			road_buffer_m: 25
		},
		'132kv': {
			min_span_m: 250,
			max_span_m: 300,
			row_width_m: 27,
			max_slope_deg: 16,
			max_deflection_deg: 40,
			slope_penalty_factor: 2,
			turn_penalty_factor: 1.8,
			water_crossing_cost_mult: 8,
			road_parallel_discount: 0.3,
			off_road_penalty: 5.0,
			road_buffer_m: 35
		},
		'220kv': {
			min_span_m: 300,
			max_span_m: 400,
			row_width_m: 35,
			max_slope_deg: 14,
			max_deflection_deg: 35,
			slope_penalty_factor: 2,
			turn_penalty_factor: 2.2,
			water_crossing_cost_mult: 8,
			road_parallel_discount: 0.3,
			off_road_penalty: 5.0,
			road_buffer_m: 45
		},
		'400kv': {
			min_span_m: 300,
			max_span_m: 400,
			row_width_m: 52,
			max_slope_deg: 12,
			max_deflection_deg: 30,
			slope_penalty_factor: 2,
			turn_penalty_factor: 2.8,
			water_crossing_cost_mult: 8,
			road_parallel_discount: 0.3,
			off_road_penalty: 5.0,
			road_buffer_m: 60
		}
	};

	$: activeSpanBand = enforcedSpanBands[voltageClass];
	$: projectGridAnchor = parseGridConnectionCenter($activeProject?.notes);
	$: anchorValidationError = getAnchorValidationError();
	$: if (voltageClass !== previousVoltageClass) {
		constraints = fixedConstraintsForVoltage(voltageClass);
		previousVoltageClass = voltageClass;
	}

	const optionProfiles: OptionProfile[] = [
		{
			label: 'Option A - Shortest Corridor',
			constraints: (base) => ({
				...base,
				slope_penalty_factor: Math.max(0.5, base.slope_penalty_factor * 0.8),
				water_crossing_cost_mult: Math.max(1.5, base.water_crossing_cost_mult * 0.75),
				road_parallel_discount: Math.min(0.5, base.road_parallel_discount * 1.2),
				off_road_penalty: Math.max(2, base.off_road_penalty * 0.6)
			})
		},
		{
			label: 'Option B - Balanced Route',
			constraints: (base) => ({ ...base })
		},
		{
			label: 'Option C - Cost Optimized',
			constraints: (base) => ({
				...base,
				slope_penalty_factor: base.slope_penalty_factor * 1.6,
				water_crossing_cost_mult: base.water_crossing_cost_mult * 1.8,
				road_parallel_discount: Math.max(0.2, base.road_parallel_discount * 0.7),
				off_road_penalty: base.off_road_penalty * 1.5
			})
		}
	];

	$: if ($activeProject?.id && lastLoadedProjectId !== $activeProject.id) {
		lastLoadedProjectId = $activeProject.id;
		applyProjectAnchors();
		void refreshRoutes($activeProject.id);
	}

	function parseGridConnectionCenter(notes: string | undefined | null): { latitude: number; longitude: number } | null {
		if (!notes || !notes.trim()) {
			return null;
		}
		try {
			const parsed = JSON.parse(notes) as {
				grid_connection_center?: { latitude?: number; longitude?: number };
			};
			const latitude = parsed.grid_connection_center?.latitude;
			const longitude = parsed.grid_connection_center?.longitude;
			if (typeof latitude !== 'number' || typeof longitude !== 'number') {
				return null;
			}
			return { latitude, longitude };
		} catch {
			return null;
		}
	}

	function parseProjectLocation(notes: string | undefined | null): LatLon | null {
		if (!notes || !notes.trim()) {
			return null;
		}

		try {
			const parsed = JSON.parse(notes) as {
				project_location?: { latitude?: number; longitude?: number };
				farm_location?: { latitude?: number; longitude?: number };
				solar_farm_center?: { latitude?: number; longitude?: number };
				solar_farm_boundary_vertices?: Array<[number, number]>;
			};

			const directCandidates = [parsed.project_location, parsed.farm_location, parsed.solar_farm_center];
			for (const candidate of directCandidates) {
				if (typeof candidate?.latitude === 'number' && typeof candidate?.longitude === 'number') {
					return { latitude: candidate.latitude, longitude: candidate.longitude };
				}
			}

			const vertices = parsed.solar_farm_boundary_vertices;
			if (Array.isArray(vertices) && vertices.length >= 3) {
				let sumLon = 0;
				let sumLat = 0;
				let count = 0;

				for (const vertex of vertices) {
					if (!Array.isArray(vertex) || vertex.length < 2) {
						continue;
					}
					const lon = vertex[0];
					const lat = vertex[1];
					if (!Number.isFinite(lon) || !Number.isFinite(lat)) {
						continue;
					}
					sumLon += lon;
					sumLat += lat;
					count++;
				}

				if (count >= 3) {
					return { latitude: sumLat / count, longitude: sumLon / count };
				}
			}
		} catch {
			return null;
		}

		return null;
	}

	function getProjectFarmAnchor(): LatLon | null {
		if (!$activeProject) {
			return null;
		}

		const farmLat = $activeProject.initial_latitude;
		const farmLon = $activeProject.initial_longitude;
		if (Number.isFinite(farmLat) && Number.isFinite(farmLon) && (farmLat !== 0 || farmLon !== 0)) {
			return { latitude: farmLat, longitude: farmLon };
		}

		return parseProjectLocation($activeProject.notes);
	}

	function applyProjectAnchors() {
		if (!$activeProject?.id || hasAppliedAnchorsForProject === $activeProject.id) {
			return;
		}

		const farmAnchor = getProjectFarmAnchor();
		if (farmAnchor) {
			farmLatitude = farmAnchor.latitude;
			farmLongitude = farmAnchor.longitude;
		}

		const gridPoint = parseGridConnectionCenter($activeProject.notes);
		if (gridPoint) {
			gridLatitude = gridPoint.latitude;
			gridLongitude = gridPoint.longitude;
		}

		hasAppliedAnchorsForProject = $activeProject.id;
	}

	function getAnchoredEndpoints(): RouteEndpoints | null {
		if (!$activeProject?.id) {
			return null;
		}

		const farmAnchor = getProjectFarmAnchor();
		if (farmAnchor === null) {
			return null;
		}
		if (projectGridAnchor === null) {
			return null;
		}

		const farm = {
			latitude: farmAnchor.latitude,
			longitude: farmAnchor.longitude
		};
		const grid = projectGridAnchor;

		return { farm, grid };
	}

	function getAnchorValidationError(): string | null {
		if (!$activeProject?.id) {
			return 'Select a project before calculating transmission routes.';
		}
		if (getProjectFarmAnchor() === null) {
			return 'Project location is missing. Set the project location before routing.';
		}
		if (projectGridAnchor === null) {
			return 'Substation/grid location is missing. Set the grid/substation point before routing.';
		}
		return null;
	}

	function validateAnchoredEndpoints(): string | null {
		const endpoints = getAnchoredEndpoints();
		if (endpoints === null) {
			return anchorValidationError;
		}

		return null;
	}

	function formatCoord(value: number | undefined): string {
		if (typeof value !== 'number' || !Number.isFinite(value)) {
			return '--';
		}
		return value.toFixed(6);
	}

	async function refreshRoutes(projectId: string) {
		loading = true;
		errorMsg = '';
		try {
			const response = await transmissionApi.list(projectId);
			setTransmissionRoutes(response.routes ?? []);
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to load transmission routes';
		} finally {
			loading = false;
		}
	}

	async function calculateRoute() {
		if (!$activeProject?.id) {
			return;
		}

		const endpointError = validateAnchoredEndpoints();
		if (endpointError) {
			errorMsg = endpointError;
			return;
		}

		creating = true;
		errorMsg = '';
		progress = { phase: 'starting', percent_complete: 0, message: 'Starting route calculation...' };

		const vector_features = buildObstacleFeatures(routeMode);
		const requestConstraints = normalizedConstraintsForVoltage(constraints, voltageClass);
		const endpoints = getAnchoredEndpoints();
		if (endpoints === null) {
			errorMsg = anchorValidationError ?? 'Project and substation anchors are required.';
			return;
		}

		try {
			const route = await transmissionApi.stream(
				{
					project_id: $activeProject.id,
					name: routeName,
					voltage_class: voltageClass,
					farm_output_point: {
						longitude: endpoints.farm.longitude,
						latitude: endpoints.farm.latitude,
						elevation: 0
					},
					grid_injection_point: {
						longitude: endpoints.grid.longitude,
						latitude: endpoints.grid.latitude,
						elevation: 0
					},
					constraints: requestConstraints,
					vector_features
				},
				(update) => {
					progress = update;
				}
			);

			enforceRouteMode(route, routeMode);
			upsertTransmissionRoute(route);
			activeTransmissionRouteId.set(route.id);
			progress = { phase: 'complete', percent_complete: 100, message: 'Transmission route ready' };
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to calculate transmission route';
			progress = null;
		} finally {
			creating = false;
		}
	}

	function optionMetaForName(name: string): OptionMeta | null {
		if (name.includes('Option A')) {
			return {
				label: 'Shortest Corridor',
				pros: 'Typically shortest distance and fewer towers',
				cons: 'Can increase water crossing or terrain risk'
			};
		}
		if (name.includes('Option B')) {
			return {
				label: 'Balanced Route',
				pros: 'Balanced trade-off between cost and terrain constraints',
				cons: 'May not be best in either pure cost or pure distance'
			};
		}
		if (name.includes('Option C')) {
			return {
				label: 'Cost Optimized',
				pros: 'Usually lower crossing and terrain-adjusted risk cost',
				cons: 'Can be longer and may require more towers'
			};
		}
		return null;
	}

	function optionScore(route: TransmissionRoute, mode: RecommendationMode): number {
		const score = route.route_score;
		if (mode === 'shortest_distance') {
			return route.distance_m;
		}
		if (mode === 'lowest_risk') {
			return score ? 1 - score.risk_score : route.cost_breakdown.crossing_premium + route.cost_breakdown.row_acquisition_cost * 0.25;
		}
		return score ? 1 - score.cost_score : route.cost_breakdown.total_cost;
	}

	function dominates(a: TransmissionRoute, b: TransmissionRoute): boolean {
		if (!a.route_score || !b.route_score) return false;
		const as = a.route_score;
		const bs = b.route_score;
		const noWorse =
			as.cost_score >= bs.cost_score &&
			as.risk_score >= bs.risk_score &&
			as.constructability_score >= bs.constructability_score &&
			as.schedule_score >= bs.schedule_score;
		const strictlyBetter =
			as.cost_score > bs.cost_score ||
			as.risk_score > bs.risk_score ||
			as.constructability_score > bs.constructability_score ||
			as.schedule_score > bs.schedule_score;
		return noWorse && strictlyBetter;
	}

	function paretoFrontierIds(routes: TransmissionRoute[]): Set<string> {
		const ids = new Set<string>();
		for (const route of routes) {
			let frontier = true;
			for (const other of routes) {
				if (route.id === other.id) continue;
				if (dominates(other, route)) {
					frontier = false;
					break;
				}
			}
			if (frontier) {
				ids.add(route.id);
			}
		}
		return ids;
	}

	function recommendedRouteId(routes: TransmissionRoute[], mode: RecommendationMode): string | null {
		if (!routes.length) return null;
		const sorted = [...routes].sort((a, b) => optionScore(a, mode) - optionScore(b, mode));
		return sorted[0]?.id ?? null;
	}

	function alternativesOnly(routes: TransmissionRoute[]): TransmissionRoute[] {
		return routes.filter((route) => optionMetaForName(route.name));
	}

	async function generateAlternatives() {
		if (!$activeProject?.id) {
			return;
		}

		const endpointError = validateAnchoredEndpoints();
		if (endpointError) {
			errorMsg = endpointError;
			return;
		}

		generatingAlternatives = true;
		errorMsg = '';
		progress = { phase: 'starting', percent_complete: 0, message: 'Generating route alternatives...' };

		const generated: TransmissionRoute[] = [];

		const vector_features = buildObstacleFeatures(routeMode);
		const endpoints = getAnchoredEndpoints();
		if (endpoints === null) {
			errorMsg = anchorValidationError ?? 'Project and substation anchors are required.';
			return;
		}

		try {
			for (let i = 0; i < optionProfiles.length; i++) {
				const profile = optionProfiles[i];
				const tunedConstraints = normalizedConstraintsForVoltage(
					profile.constraints(constraints),
					voltageClass
				);
				const pct = Math.floor((i / optionProfiles.length) * 100);
				progress = {
					phase: 'alternatives',
					percent_complete: pct,
					message: `Calculating ${profile.label} (${i + 1}/${optionProfiles.length})`
				};

				const response = await transmissionApi.calculate({
					project_id: $activeProject.id,
					name: `${routeName} - ${profile.label}`,
					voltage_class: voltageClass,
					farm_output_point: {
						longitude: endpoints.farm.longitude,
						latitude: endpoints.farm.latitude,
						elevation: 0
					},
					grid_injection_point: {
						longitude: endpoints.grid.longitude,
						latitude: endpoints.grid.latitude,
						elevation: 0
					},
					constraints: tunedConstraints,
					vector_features
				});

				enforceRouteMode(response.route, routeMode);
				upsertTransmissionRoute(response.route);
				generated.push(response.route);
			}

			const best = generated.sort(
				(a, b) => a.cost_breakdown.total_cost - b.cost_breakdown.total_cost
			)[0];
			if (best) {
				activeTransmissionRouteId.set(best.id);
			}

			progress = {
				phase: 'complete',
				percent_complete: 100,
				message: `Generated ${generated.length} alternatives. Lowest-cost option selected.`
			};
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to generate alternatives';
			progress = null;
		} finally {
			generatingAlternatives = false;
		}
	}

	async function deleteRoute(id: string) {
		deletingId = id;
		errorMsg = '';
		try {
			await transmissionApi.delete(id);
			removeTransmissionRoute(id);
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to delete transmission route';
		} finally {
			deletingId = '';
		}
	}

	function approvalStatusLabel(status: ApprovalStatusValue): string {
		if (status === 'engineering_review') return 'Engineering Review';
		if (status === 'approved') return 'Approved';
		return 'Draft';
	}

	function formatDateTime(value: string): string {
		if (!value) return '—';
		const time = Date.parse(value);
		if (Number.isNaN(time)) return value;
		return new Date(time).toLocaleString();
	}

	function routeReviewGate(route: TransmissionRoute) {
		return gateTransmissionReviewAction(route, $workflowState.current_phase, $workflowState.active_blockers);
	}

	function routeApprovalGate(route: TransmissionRoute) {
		return gateTransmissionApprovalAction(route, $workflowState.current_phase, $workflowState.active_blockers);
	}

	async function submitForReview(route: TransmissionRoute) {
		workflowBusyId = route.id;
		errorMsg = '';
		try {
			const response = await transmissionApi.submitForReview(route.id, workflowActor, workflowNote);
			upsertTransmissionRoute(response.route);
			workflowNote = '';
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to submit route for review';
		} finally {
			workflowBusyId = '';
		}
	}

	async function approveRoute(route: TransmissionRoute) {
		workflowBusyId = route.id;
		errorMsg = '';
		try {
			const response = await transmissionApi.approve(route.id, workflowActor, workflowNote);
			upsertTransmissionRoute(response.route);
			workflowNote = '';
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to approve route';
		} finally {
			workflowBusyId = '';
		}
	}

	async function exportPack(route: TransmissionRoute) {
		workflowBusyId = route.id;
		errorMsg = '';
		try {
			const response = await transmissionApi.exportPack(route.id, workflowActor);
			const blob = new Blob([JSON.stringify(response.pack, null, 2)], { type: 'application/json' });
			const url = URL.createObjectURL(blob);
			const anchor = document.createElement('a');
			anchor.href = url;
			anchor.download = `${route.name.replace(/\s+/g, '_').toLowerCase()}_export_pack.json`;
			document.body.appendChild(anchor);
			anchor.click();
			anchor.remove();
			URL.revokeObjectURL(url);
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to export transmission route pack';
		} finally {
			workflowBusyId = '';
		}
	}

	async function submitActiveRouteForReview() {
		if (!activeRoute) return;
		const gate = routeReviewGate(activeRoute);
		if (!gate.allowed) {
			errorMsg = gate.reason;
			return;
		}
		await submitForReview(activeRoute);
	}

	async function approveActiveRoute() {
		if (!activeRoute) return;
		const gate = routeApprovalGate(activeRoute);
		if (!gate.allowed) {
			errorMsg = gate.reason;
			return;
		}
		await approveRoute(activeRoute);
	}

	async function refreshEvidence() {
		if (!$activeProject?.id) return;
		await refreshRoutes($activeProject.id);
	}

	function setActiveRoute(id: string) {
		activeTransmissionRouteId.set(id);
	}

	function buildObstacleFeatures(mode: RouteMode): TransmissionVectorFeature[] {
		const features: TransmissionVectorFeature[] = [];
		const seen = new Set<string>();

		for (const component of $components) {
			const polygon = circlePolygonGeoJSON(
				component.position.longitude,
				component.position.latitude,
				component.component_type === 'substation' ? 40 : 25
			);
			const key = `layout-component:${component.id}`;
			if (!seen.has(key)) {
				features.push({
					feature_type: 'building',
					geometry_geojson: polygon,
					cost_multiplier: 9999
				});
				seen.add(key);
			}
		}

		for (const entity of $componentEntities) {
			const key = `entity:${entity.id}`;
			if (seen.has(key)) {
				continue;
			}

			try {
				const parsed = JSON.parse(entity.geojson) as { type?: string; coordinates?: number[] };
				if (parsed.type === 'Point' && Array.isArray(parsed.coordinates) && parsed.coordinates.length >= 2) {
					features.push({
						feature_type: 'building',
						geometry_geojson: circlePolygonGeoJSON(parsed.coordinates[0], parsed.coordinates[1], 25),
						cost_multiplier: 9999
					});
					seen.add(key);
				}
			} catch {
				// ignore malformed entity geometry
			}
		}

		// Phase 4: user-drawn no-go zones (hard-block)
		for (const zone of userNoGoZones) {
			features.push({
				feature_type: 'no_go',
				geometry_geojson: bboxToPolygonGeoJSON(zone.minLon, zone.minLat, zone.maxLon, zone.maxLat),
				cost_multiplier: 9999
			});
		}

		// Phase 4: user-drawn preferred corridors (strong routing incentive)
		for (const zone of userCorridors) {
			features.push({
				feature_type: 'preferred_corridor',
				geometry_geojson: bboxToPolygonGeoJSON(zone.minLon, zone.minLat, zone.maxLon, zone.maxLat),
				cost_multiplier: 0.35
			});
		}

		// Drawn roads: feed as preferred routing corridors (road_parallel_discount applied by backend)
		for (const road of drawnRoads) {
			features.push({
				feature_type: 'road',
				geometry_geojson: road.lineGeojson,
				cost_multiplier: 1.0
			});
		}

		if (mode === 'underground') {
			features.push({
				feature_type: 'underground_only',
				geometry_geojson: planningEnvelopeGeoJSON(),
				cost_multiplier: 1
			});
		}

		return features;
	}

	function hasUndergroundSegments(route: TransmissionRoute): boolean {
		return route.segment_explanations.some((segment) => segment.installation_mode === 'underground');
	}

	function hasOverheadSegments(route: TransmissionRoute): boolean {
		return route.segment_explanations.some((segment) => segment.installation_mode === 'overhead');
	}

	function enforceRouteMode(route: TransmissionRoute, mode: RouteMode) {
		if (mode === 'overhead' && hasUndergroundSegments(route)) {
			throw new Error(
				'Overhead mode could not find a fully overhead corridor. Try Hybrid mode or adjust no-go/corridor constraints.'
			);
		}
		if (mode === 'underground' && hasOverheadSegments(route)) {
			throw new Error(
				'Underground mode returned overhead segments. Refine input constraints or retry with Hybrid mode.'
			);
		}
	}

	function planningEnvelopeGeoJSON(): string {
		const endpoints = getAnchoredEndpoints();
		const startLon = endpoints?.farm.longitude ?? farmLongitude;
		const endLon = endpoints?.grid.longitude ?? gridLongitude;
		const startLat = endpoints?.farm.latitude ?? farmLatitude;
		const endLat = endpoints?.grid.latitude ?? gridLatitude;
		const minLon = Math.min(startLon, endLon) - 0.1;
		const maxLon = Math.max(startLon, endLon) + 0.1;
		const minLat = Math.min(startLat, endLat) - 0.1;
		const maxLat = Math.max(startLat, endLat) + 0.1;
		return bboxToPolygonGeoJSON(minLon, minLat, maxLon, maxLat);
	}

	function circlePolygonGeoJSON(longitude: number, latitude: number, radiusMeters: number): string {
		const points = 16;
		const latStep = radiusMeters / 111320;
		const lonStep = radiusMeters / (111320 * Math.max(0.1, Math.cos((latitude * Math.PI) / 180)));
		const coordinates: number[][] = [];

		for (let i = 0; i < points; i++) {
			const theta = (2 * Math.PI * i) / points;
			coordinates.push([
				longitude + Math.cos(theta) * lonStep,
				latitude + Math.sin(theta) * latStep
			]);
		}
		coordinates.push([...coordinates[0]]);

		return JSON.stringify({ type: 'Polygon', coordinates: [coordinates] });
	}

	function focusRoute(id: string) {
		activeTransmissionRouteId.set(id);
	}

	function normalizedConstraintsForVoltage(
		input: TransmissionConstraints,
		voltage: VoltageClassValue
	): TransmissionConstraints {
		const band = enforcedSpanBands[voltage];
		const minSpan = Math.min(Math.max(input.min_span_m, band.min), band.max);
		const maxSpan = Math.min(Math.max(input.max_span_m, band.min), band.max);
		return {
			...input,
			min_span_m: Math.min(minSpan, maxSpan),
			max_span_m: Math.max(minSpan, maxSpan)
		};
	}

	function fixedConstraintsForVoltage(voltage: VoltageClassValue): TransmissionConstraints {
		return { ...fixedConstraintsByVoltage[voltage] };
	}

	// ── Phase 4: User constraint zones ─────────────────────────────────────────

	type ConstraintZone = {
		id: number;
		label: string;
		minLon: number;
		minLat: number;
		maxLon: number;
		maxLat: number;
	};

	let userNoGoZones: ConstraintZone[] = [];
	let userCorridors: ConstraintZone[] = [];
	let zoneIdCounter = 1;

	let addingNoGoZone = false;
	let addingCorridor = false;

	let newZoneMinLat = 0;
	let newZoneMinLon = 0;
	let newZoneMaxLat = 0;
	let newZoneMaxLon = 0;
	let newZoneLabel = '';

	function bboxToPolygonGeoJSON(minLon: number, minLat: number, maxLon: number, maxLat: number): string {
		const coords = [
			[minLon, minLat],
			[maxLon, minLat],
			[maxLon, maxLat],
			[minLon, maxLat],
			[minLon, minLat]
		];
		return JSON.stringify({ type: 'Polygon', coordinates: [coords] });
	}

	function commitNoGoZone() {
		if (newZoneMinLat === newZoneMaxLat || newZoneMinLon === newZoneMaxLon) return;
		userNoGoZones = [
			...userNoGoZones,
			{
				id: zoneIdCounter++,
				label: newZoneLabel || `No-Go Zone ${userNoGoZones.length + 1}`,
				minLon: Math.min(newZoneMinLon, newZoneMaxLon),
				minLat: Math.min(newZoneMinLat, newZoneMaxLat),
				maxLon: Math.max(newZoneMinLon, newZoneMaxLon),
				maxLat: Math.max(newZoneMinLat, newZoneMaxLat)
			}
		];
		resetZoneForm();
		addingNoGoZone = false;
	}

	function commitCorridor() {
		if (newZoneMinLat === newZoneMaxLat || newZoneMinLon === newZoneMaxLon) return;
		userCorridors = [
			...userCorridors,
			{
				id: zoneIdCounter++,
				label: newZoneLabel || `Corridor ${userCorridors.length + 1}`,
				minLon: Math.min(newZoneMinLon, newZoneMaxLon),
				minLat: Math.min(newZoneMinLat, newZoneMaxLat),
				maxLon: Math.max(newZoneMinLon, newZoneMaxLon),
				maxLat: Math.max(newZoneMinLat, newZoneMaxLat)
			}
		];
		resetZoneForm();
		addingCorridor = false;
	}

	function resetZoneForm() {
		newZoneMinLat = 0;
		newZoneMinLon = 0;
		newZoneMaxLat = 0;
		newZoneMaxLon = 0;
		newZoneLabel = '';
	}
</script>

<div class="transmission-panel">
	<h4>Transmission Routing</h4>
	{#if !$activeProject}
		<p class="empty">Select a project to calculate transmission routes.</p>
	{:else}
		<div class="controls">
			<input bind:value={routeName} placeholder="Route name" title="Name used to save and compare this transmission route." />
			<p class="field-help">Route name for this run.</p>
			<select bind:value={voltageClass} title="Electrical class used for engineering defaults, tower sizing, and cost baselines.">
				<option value="11kv">11 kV</option>
				<option value="33kv">33 kV</option>
				<option value="66kv">66 kV</option>
				<option value="132kv">132 kV</option>
				<option value="220kv">220 kV</option>
				<option value="400kv">400 kV</option>
			</select>
			<p class="field-help">Voltage class drives span and cost behavior.</p>
			<p class="field-help">Enforced tower spacing for {voltageClass.toUpperCase()}: {activeSpanBand.min}-{activeSpanBand.max} m.</p>
			<select bind:value={routeMode} title="Overhead only rejects underground segments. Underground only enforces cable routing. Hybrid allows mixed routing.">
				<option value="overhead">Overhead Only</option>
				<option value="underground">Underground Only</option>
				<option value="hybrid">Hybrid</option>
			</select>
			<p class="field-help">Routing mode policy for this run.</p>

			<p class="field-help">Route anchors are automatic from project details (project location and saved grid/substation point).</p>
			{#if anchorValidationError}
				<p class="field-help" style="color:#fca5a5;">{anchorValidationError}</p>
			{/if}

			<button class="secondary" on:click={() => (showAdvanced = !showAdvanced)}>
				{showAdvanced ? 'Hide Advanced Constraints' : 'Show Advanced Constraints'}
			</button>
			<p class="field-help">Default engineering values come from selected voltage class. Advanced values are optional overrides.</p>
			{#if showAdvanced}
				<div class="advanced-grid">
					<label class="field">
						<span>Minimum Span (m)</span>
						<input type="number" step="1" min={activeSpanBand.min} max={activeSpanBand.max} bind:value={constraints.min_span_m} />
					</label>
					<label class="field">
						<span>Maximum Span (m)</span>
						<input type="number" step="1" min={activeSpanBand.min} max={activeSpanBand.max} bind:value={constraints.max_span_m} />
					</label>
					<label class="field">
						<span>ROW Width (m)</span>
						<input type="number" step="1" bind:value={constraints.row_width_m} />
					</label>
					<label class="field">
						<span>Maximum Slope (deg)</span>
						<input type="number" step="0.1" bind:value={constraints.max_slope_deg} />
					</label>
					<label class="field">
						<span>Maximum Deflection (deg)</span>
						<input type="number" step="1" bind:value={constraints.max_deflection_deg} />
					</label>
					<label class="field">
						<span>Slope Penalty Factor</span>
						<input type="number" step="0.1" bind:value={constraints.slope_penalty_factor} />
					</label>
					<label class="field">
						<span>Turn Penalty Factor</span>
						<input type="number" step="0.1" bind:value={constraints.turn_penalty_factor} />
					</label>
					<label class="field">
						<span>Water Crossing Cost Multiplier</span>
						<input type="number" step="0.1" bind:value={constraints.water_crossing_cost_mult} />
					</label>
					<label class="field">
						<span>Road Parallel Discount</span>
						<input type="number" step="0.1" min="0.1" max="1" bind:value={constraints.road_parallel_discount} />
					</label>
					<label class="field">
						<span>Off-Road Penalty</span>
						<input type="number" step="0.5" min="1" bind:value={constraints.off_road_penalty} />
					</label>
					<label class="field">
						<span>Road Buffer (m)</span>
						<input type="number" step="5" min="5" bind:value={constraints.road_buffer_m} />
					</label>
				</div>
			{/if}

			<!-- Phase 4: Constraint Zones -->
			<div class="zone-section">
				<p class="field-help">No-Go zones are forbidden areas. Preferred corridors are encouraged routing channels.</p>
				<div class="zone-header">
					<span class="zone-title">No-Go Zones</span>
					<button class="secondary zone-add-btn" on:click={() => { addingNoGoZone = !addingNoGoZone; addingCorridor = false; resetZoneForm(); }}>
						{addingNoGoZone ? 'Cancel' : '+ Add'}
					</button>
				</div>
				{#if addingNoGoZone}
					<div class="zone-form">
						<input placeholder="Label (optional)" bind:value={newZoneLabel} />
						<div class="coord-grid">
							<input type="number" step="0.0001" placeholder="Min lat" bind:value={newZoneMinLat} />
							<input type="number" step="0.0001" placeholder="Min lon" bind:value={newZoneMinLon} />
							<input type="number" step="0.0001" placeholder="Max lat" bind:value={newZoneMaxLat} />
							<input type="number" step="0.0001" placeholder="Max lon" bind:value={newZoneMaxLon} />
						</div>
						<button class="danger-outline" on:click={commitNoGoZone}>Add No-Go Zone</button>
					</div>
				{/if}
				{#each userNoGoZones as zone}
					<div class="zone-item zone-nogo">
						<span>{zone.label}</span>
						<button class="secondary zone-remove-btn" on:click={() => (userNoGoZones = userNoGoZones.filter((z) => z.id !== zone.id))}>✕</button>
					</div>
				{/each}

				<div class="zone-header" style="margin-top:6px">
					<span class="zone-title">Preferred Corridors</span>
					<button class="secondary zone-add-btn" on:click={() => { addingCorridor = !addingCorridor; addingNoGoZone = false; resetZoneForm(); }}>
						{addingCorridor ? 'Cancel' : '+ Add'}
					</button>
				</div>
				{#if addingCorridor}
					<div class="zone-form">
						<input placeholder="Label (optional)" bind:value={newZoneLabel} />
						<div class="coord-grid">
							<input type="number" step="0.0001" placeholder="Min lat" bind:value={newZoneMinLat} />
							<input type="number" step="0.0001" placeholder="Min lon" bind:value={newZoneMinLon} />
							<input type="number" step="0.0001" placeholder="Max lat" bind:value={newZoneMaxLat} />
							<input type="number" step="0.0001" placeholder="Max lon" bind:value={newZoneMaxLon} />
						</div>
						<button class="corridor-btn" on:click={commitCorridor}>Add Preferred Corridor</button>
					</div>
				{/if}
				{#each userCorridors as zone}
					<div class="zone-item zone-corridor">
						<span>{zone.label}</span>
						<button class="secondary zone-remove-btn" on:click={() => (userCorridors = userCorridors.filter((z) => z.id !== zone.id))}>✕</button>
					</div>
				{/each}
			</div>

			<button on:click={calculateRoute} disabled={creating || generatingAlternatives || anchorValidationError !== null} title="Compute one route using current inputs and constraints.">
				{creating ? 'Calculating...' : 'Calculate Route'}
			</button>
			<button class="secondary" on:click={generateAlternatives} disabled={creating || generatingAlternatives || anchorValidationError !== null} title="Generate Option A/B/C variants for side-by-side comparison.">
				{generatingAlternatives ? 'Generating 3 Options...' : 'Generate 3 Route Options'}
			</button>
			<label class="recommendation">
				<span>Recommendation Mode</span>
				<select bind:value={recommendationMode} title="Scoring lens used to mark the recommended route.">
					<option value="lowest_cost">Lowest Cost</option>
					<option value="shortest_distance">Shortest Distance</option>
					<option value="lowest_risk">Lowest Risk (Crossings/ROW)</option>
				</select>
			</label>
			<p class="field-help">Recommendation mode changes ranking only; it does not recalculate geometry.</p>
			<div class="workflow-card">
				<label class="field">
					<span>Workflow Actor</span>
					<input bind:value={workflowActor} placeholder="planner-ui" />
				</label>
				<label class="field">
					<span>Workflow Note</span>
					<input bind:value={workflowNote} placeholder="Optional review or approval note" />
				</label>
			</div>
			{#if activeRoute}
				<div class="handoff-card">
					<div class="handoff-head">
						<strong>Transmission Handoff Status</strong>
						<button class="secondary" on:click={refreshEvidence}>Refresh Evidence</button>
					</div>
					<div class="handoff-grid">
						<div><span>Route</span><strong>{activeRoute.name}</strong></div>
						<div><span>Status</span><strong>{approvalStatusLabel(activeRoute.approval_status)}</strong></div>
						<div><span>Voltage</span><strong>{activeRoute.voltage_class.toUpperCase()}</strong></div>
						<div><span>Towers</span><strong>{activeRoute.tower_positions.length}</strong></div>
						<div><span>Distance</span><strong>{(activeRoute.distance_m / 1000).toFixed(2)} km</strong></div>
						<div><span>Summary</span><strong>{activeRoute.route_summary || 'Not captured'}</strong></div>
						<div><span>Reviewed by</span><strong>{activeRoute.engineering_reviewed_by || '—'}</strong></div>
						<div><span>Approved by</span><strong>{activeRoute.approved_by || '—'}</strong></div>
					</div>
					<div class="handoff-actions">
						<button
							class="secondary"
							on:click={submitActiveRouteForReview}
							disabled={!activeRouteReviewGate.allowed || workflowBusyId === activeRoute.id}
							title={activeRouteReviewGate.reason}
						>
							Submit For Engineering Review
						</button>
						<button
							class="secondary"
							on:click={approveActiveRoute}
							disabled={!activeRouteApprovalGate.allowed || workflowBusyId === activeRoute.id}
							title={activeRouteApprovalGate.reason}
						>
							Approve Transmission Route
						</button>
					</div>
					{#if !activeRouteReviewGate.allowed}
						<div class="handoff-reason">Review gate: {activeRouteReviewGate.reason}</div>
					{/if}
					{#if !activeRouteApprovalGate.allowed}
						<div class="handoff-reason">Approval gate: {activeRouteApprovalGate.reason}</div>
					{/if}
				</div>
			{/if}
		</div>

		{#if progress}
			<div class="progress">
				<div class="progress-head">
					<span>{progress.phase}</span>
					<span>{progress.percent_complete}%</span>
				</div>
				<div class="progress-bar">
					<div class="progress-fill" style={`width: ${Math.max(0, Math.min(100, progress.percent_complete))}%`}></div>
				</div>
				<p class="progress-msg">{progress.message}</p>
			</div>
		{/if}

		{#if errorMsg}
			<p class="error">{errorMsg}</p>
		{/if}

		{#if loading}
			<p class="empty">Loading transmission routes...</p>
		{:else if $transmissionRoutes.length === 0}
			<p class="empty">No transmission routes yet.</p>
		{:else}
			{@const alternatives = alternativesOnly($transmissionRoutes)}
			{@const recommendedId = recommendedRouteId(alternatives, recommendationMode)}
			{@const paretoIds = paretoFrontierIds(alternatives)}
			{#if alternatives.length > 1}
				<div class="comparison-card">
					<h5>Option Comparison</h5>
					<table class="comparison-table">
						<thead>
							<tr>
								<th>Option</th>
								<th>Distance</th>
								<th>Total Cost</th>
								<th>Crossing Premium</th>
								<th>Towers</th>
								<th>Cost/km</th>
								<th>Composite</th>
								<th>Pareto</th>
								<th>Recommended</th>
								<th>Actions</th>
							</tr>
						</thead>
						<tbody>
							{#each alternatives as route}
								<tr class:recommended-row={route.id === recommendedId}>
									<td>{optionMetaForName(route.name)?.label ?? route.name}</td>
									<td>{(route.distance_m / 1000).toFixed(2)} km</td>
									<td>INR {route.cost_breakdown.total_cost.toFixed(0)}</td>
									<td>INR {route.cost_breakdown.crossing_premium.toFixed(0)}</td>
									<td>{route.tower_positions.length}</td>
									<td>INR {route.cost_breakdown.cost_per_km.toFixed(0)}</td>
									<td>{route.route_score?.composite_score?.toFixed(2) ?? '-'}</td>
									<td>{paretoIds.has(route.id) || route.route_score?.pareto_frontier ? 'Yes' : '-'}</td>
									<td>{route.id === recommendedId ? 'Yes' : '-'}</td>
									<td>
										<div class="table-actions">
											<button class="secondary" on:click={() => focusRoute(route.id)}>Focus</button>
											<button class="secondary" on:click={() => setActiveRoute(route.id)}>Set Active</button>
											<button class="danger" on:click={() => deleteRoute(route.id)} disabled={deletingId === route.id}>
												{deletingId === route.id ? 'Deleting...' : 'Delete'}
											</button>
										</div>
									</td>
								</tr>
							{/each}
						</tbody>
					</table>
				</div>
			{/if}
			<div class="route-list">
				{#each $transmissionRoutes as route}
					{@const meta = optionMetaForName(route.name)}
					{@const reviewGate = routeReviewGate(route)}
					{@const approvalGate = routeApprovalGate(route)}
					<div class="route-item" class:active={$activeTransmissionRouteId === route.id}>
						<div class="route-name">{route.name}</div>
						<div class={`route-status status-${route.approval_status}`}>{approvalStatusLabel(route.approval_status)}</div>
						{#if meta}
							<div class="route-option-tag">{meta.label}</div>
						{/if}
						{#if paretoIds.has(route.id) || route.route_score?.pareto_frontier}
							<div class="route-pareto">Pareto Frontier</div>
						{/if}
						{#if route.id === recommendedId}
							<div class="route-recommended">Recommended ({recommendationMode.replace('_', ' ')})</div>
						{/if}
						<div class="route-meta">
							{route.voltage_class.toUpperCase()} | {(route.distance_m / 1000).toFixed(2)} km
						</div>
						<div class="route-meta">
							Total INR {route.cost_breakdown.total_cost.toFixed(0)} | INR {route.cost_breakdown.cost_per_km.toFixed(0)}/km
						</div>
						{#if route.engineering_reviewed_by}
							<div class="route-meta">Reviewed by {route.engineering_reviewed_by}</div>
						{/if}
						{#if route.approved_by}
							<div class="route-meta">Approved by {route.approved_by}</div>
						{/if}
						{#if route.route_score}
							<div class="route-score-grid">
								<span>C {route.route_score.cost_score.toFixed(2)}</span>
								<span>R {route.route_score.risk_score.toFixed(2)}</span>
								<span>B {route.route_score.constructability_score.toFixed(2)}</span>
								<span>S {route.route_score.schedule_score.toFixed(2)}</span>
								<span>Composite {route.route_score.composite_score.toFixed(2)}</span>
							</div>
							<div class="route-score-reason">{route.route_score.recommendation_reason}</div>
						{/if}
						{#if meta}
							<div class="route-note route-pro">Advantage: {meta.pros}</div>
							<div class="route-note route-con">Trade-off: {meta.cons}</div>
						{/if}
						<div class="actions">
							<button class="secondary" on:click={() => focusRoute(route.id)}>Focus</button>
							<button class="secondary" on:click={() => setActiveRoute(route.id)}>Set Active</button>
							{#if route.approval_status === 'draft'}
								<button class="secondary" on:click={() => submitForReview(route)} disabled={workflowBusyId === route.id || !reviewGate.allowed} title={reviewGate.reason}>Review</button>
							{:else if route.approval_status === 'engineering_review'}
								<button class="secondary" on:click={() => approveRoute(route)} disabled={workflowBusyId === route.id || !approvalGate.allowed} title={approvalGate.reason}>Approve</button>
							{:else}
								<button class="secondary" on:click={() => exportPack(route)} disabled={workflowBusyId === route.id}>Export</button>
							{/if}
							<button class="danger" on:click={() => deleteRoute(route.id)} disabled={deletingId === route.id}>
								{deletingId === route.id ? 'Deleting...' : 'Delete'}
							</button>
						</div>
						<div class="evidence-toggle-row">
							<button class="secondary evidence-toggle" on:click={() => (evidenceExpandedId = evidenceExpandedId === route.id ? '' : route.id)}>
								{evidenceExpandedId === route.id ? 'Hide Evidence' : 'Show Evidence'}
							</button>
						</div>
						{#if evidenceExpandedId === route.id}
							<div class="evidence-card">
								<div class="evidence-title">Route Governance Timeline</div>
								{#if route.governance_events.length === 0}
									<div class="evidence-empty">No governance events recorded yet.</div>
								{:else}
									{#each route.governance_events as event}
										<div class="evidence-event">
											<div>{event.event_type} · {event.actor}</div>
											<div>{event.from_status} → {event.to_status}</div>
											<div>{formatDateTime(event.occurred_at)}</div>
											{#if event.note}
												<div class="evidence-note">{event.note}</div>
											{/if}
										</div>
									{/each}
								{/if}
								<div class="evidence-title">Segment Decision Evidence</div>
								{#if route.segment_explanations.length === 0}
									<div class="evidence-empty">No segment evidence available.</div>
								{:else}
									{#each route.segment_explanations.slice(0, 4) as segment}
										<div class="evidence-event">
											<div>Segment #{segment.from_index} · {segment.installation_mode}</div>
											<div>Land: {segment.land_type} · Slope: {segment.slope_deg.toFixed(1)}°</div>
											<div>Decision: {segment.decision_reason}</div>
										</div>
									{/each}
								{/if}
							</div>
						{/if}
					</div>
				{/each}
			</div>
			<div class="workflow-evidence">
				<div class="evidence-title">Workflow Transition Evidence</div>
				{#if transitionEvidence.length === 0}
					<div class="evidence-empty">No transmission-related workflow transitions recorded.</div>
				{:else}
					{#each transitionEvidence as transition}
						<div class="evidence-event">
							<div>{transition.from_phase} → {transition.to_phase}</div>
							<div>Actor: {transition.actor_id || 'system'}</div>
							<div>{formatDateTime(transition.occurred_at)}</div>
							{#if transition.reason}
								<div class="evidence-note">{transition.reason}</div>
							{/if}
						</div>
					{/each}
				{/if}
			</div>
		{/if}
	{/if}
</div>

<style>
	.transmission-panel { display: flex; flex-direction: column; gap: 8px; }
	h4 { margin: 0; font-size: 14px; font-weight: 600; color: #e2e8f0; }
	.controls { display: flex; flex-direction: column; gap: 6px; }
	.advanced-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
	.coord-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 6px; }
	.field { display: flex; flex-direction: column; gap: 4px; }
	.field span { font-size: 11px; color: #94a3b8; font-weight: 600; }
	.field-full { grid-column: 1 / -1; }
	.field-help { margin: -2px 0 2px; font-size: 10px; color: #94a3b8; }
	.recommendation { display: flex; flex-direction: column; gap: 4px; }
	.recommendation span { font-size: 11px; color: #94a3b8; font-weight: 600; }
	.workflow-card { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; border: 1px solid rgba(255,255,255,.08); border-radius: 6px; padding: 8px; }
	.handoff-card { border: 1px solid rgba(125,211,252,.35); border-radius: 6px; padding: 8px; background: rgba(14,116,144,.12); display: flex; flex-direction: column; gap: 8px; }
	.handoff-head { display: flex; justify-content: space-between; align-items: center; font-size: 12px; color: #bae6fd; }
	.handoff-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 6px; }
	.handoff-grid div { display: flex; flex-direction: column; gap: 2px; font-size: 11px; color: #bae6fd; }
	.handoff-grid strong { color: #e0f2fe; font-size: 11px; }
	.handoff-actions { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
	.handoff-reason { font-size: 10px; color: #fde68a; }
	input, select {
		padding: 6px 8px;
		border: 1px solid rgba(255,255,255,.16);
		border-radius: 4px;
		background: rgba(0,0,0,.25);
		color: #e2e8f0;
		font-size: 12px;
	}
	button {
		padding: 8px;
		border: none;
		border-radius: 6px;
		background: linear-gradient(135deg,#f59e0b,#d97706);
		color: #fff;
		font-size: 12px;
		font-weight: 600;
		cursor: pointer;
	}
	button.secondary {
		background: rgba(255,255,255,.08);
		border: 1px solid rgba(255,255,255,.16);
	}
	button.danger {
		background: rgba(220,38,38,.2);
		border: 1px solid rgba(220,38,38,.6);
		color: #fecaca;
	}
	button:disabled { opacity: .6; cursor: not-allowed; }
	.progress { border: 1px solid rgba(255,255,255,.1); border-radius: 6px; padding: 8px; }
	.progress-head { display: flex; justify-content: space-between; font-size: 11px; color: #cbd5e1; margin-bottom: 4px; }
	.progress-bar { height: 8px; background: rgba(255,255,255,.08); border-radius: 999px; overflow: hidden; }
	.progress-fill { height: 100%; background: linear-gradient(90deg,#f59e0b,#84cc16); }
	.progress-msg { margin: 6px 0 0; font-size: 11px; color: #94a3b8; }
	.route-list { display: flex; flex-direction: column; gap: 6px; }
	.route-item { padding: 8px; border-radius: 6px; border: 1px solid rgba(255,255,255,.08); background: rgba(255,255,255,.04); }
	.route-item.active { border-color: rgba(245,158,11,.8); }
	.route-name { font-size: 12px; color: #e2e8f0; font-weight: 600; }
	.route-status { display: inline-block; margin-top: 4px; padding: 2px 8px; border-radius: 999px; font-size: 10px; font-weight: 700; }
	.route-status.status-draft { background: rgba(148,163,184,.15); color: #cbd5e1; }
	.route-status.status-engineering_review { background: rgba(245,158,11,.15); color: #fcd34d; }
	.route-status.status-approved { background: rgba(34,197,94,.15); color: #86efac; }
	.route-option-tag { font-size: 10px; color: #fcd34d; font-weight: 700; margin-top: 2px; }
	.route-recommended { font-size: 10px; color: #86efac; font-weight: 700; margin-top: 2px; }
	.route-pareto { font-size: 10px; color: #7dd3fc; font-weight: 700; margin-top: 2px; }
	.route-meta { font-size: 11px; color: #94a3b8; }
	.route-score-grid { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 6px; font-size: 10px; color: #cbd5e1; }
	.route-score-grid span { padding: 2px 6px; border: 1px solid rgba(255,255,255,.12); border-radius: 999px; }
	.route-score-reason { margin-top: 6px; font-size: 10px; color: #cbd5e1; line-height: 1.35; }
	.route-note { font-size: 10px; margin-top: 4px; }
	.route-pro { color: #86efac; }
	.route-con { color: #fca5a5; }
	.evidence-toggle-row { margin-top: 6px; }
	.evidence-toggle { width: 100%; }
	.evidence-card,
	.workflow-evidence { margin-top: 8px; border: 1px solid rgba(255,255,255,.1); border-radius: 6px; padding: 8px; background: rgba(2,6,23,.35); }
	.evidence-title { font-size: 11px; color: #cbd5e1; font-weight: 700; margin-bottom: 6px; text-transform: uppercase; letter-spacing: .03em; }
	.evidence-event { border: 1px solid rgba(255,255,255,.08); border-radius: 6px; padding: 6px; font-size: 11px; color: #cbd5e1; margin-bottom: 6px; display: grid; gap: 2px; }
	.evidence-empty { font-size: 11px; color: #94a3b8; }
	.evidence-note { color: #e2e8f0; font-size: 10px; }
	.comparison-card {
		border: 1px solid rgba(255,255,255,.12);
		border-radius: 8px;
		padding: 8px;
		background: rgba(15, 23, 42, 0.45);
	}
	.comparison-card h5 {
		margin: 0 0 6px;
		font-size: 12px;
		color: #e2e8f0;
	}
	.comparison-table {
		width: 100%;
		border-collapse: collapse;
		font-size: 10px;
	}
	.comparison-table th,
	.comparison-table td {
		padding: 4px;
		text-align: left;
		border-bottom: 1px solid rgba(255,255,255,.08);
		color: #cbd5e1;
	}
	.comparison-table th { color: #94a3b8; }
	.recommended-row td { color: #86efac; font-weight: 700; }
	.table-actions { display: flex; gap: 4px; }
	.table-actions button { padding: 4px 6px; font-size: 10px; }
	.actions { margin-top: 6px; display: flex; gap: 6px; }
	.actions button { flex: 1; }
	.empty { color: #64748b; font-size: 12px; margin: 0; }
	.error { color: #f87171; font-size: 12px; margin: 0; }
	.zone-section { display: flex; flex-direction: column; gap: 4px; border: 1px solid rgba(255,255,255,.08); border-radius: 6px; padding: 8px; }
	.zone-header { display: flex; align-items: center; justify-content: space-between; }
	.zone-title { font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: .04em; }
	.zone-add-btn { padding: 3px 8px; font-size: 10px; }
	.zone-form { display: flex; flex-direction: column; gap: 4px; margin-top: 4px; }
	.zone-item { display: flex; align-items: center; justify-content: space-between; padding: 4px 6px; border-radius: 4px; font-size: 11px; }
	.zone-nogo { background: rgba(220,38,38,.12); border: 1px solid rgba(220,38,38,.4); color: #fca5a5; }
	.zone-corridor { background: rgba(34,197,94,.10); border: 1px solid rgba(34,197,94,.4); color: #86efac; }
	.zone-remove-btn { padding: 2px 6px; font-size: 10px; }
	.danger-outline { background: transparent; border: 1px solid rgba(220,38,38,.6); color: #fca5a5; padding: 6px; font-size: 11px; }
	.corridor-btn { background: rgba(34,197,94,.15); border: 1px solid rgba(34,197,94,.5); color: #86efac; padding: 6px; font-size: 11px; }
</style>
