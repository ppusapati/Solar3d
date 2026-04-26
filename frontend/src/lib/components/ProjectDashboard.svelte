<script lang="ts">
	import { onMount } from 'svelte';
	import {
		projects,
		loadProjects,
		createProject,
		deleteProject,
		updateProject,
		activeProjectId,
		loadError,
		isLoading
	} from '$lib/core/stores';
	import { projectsApi, terrainApi, type Site, type CadParseFeature } from '$lib/core/api';
	import type { Project } from '$lib/core/api';
	import { toast } from '$lib/core/stores/toast';
	import { confirm as confirmModal } from '$lib/core/stores/confirm';

	export let open = false;
	export let onopenProject: ((detail: { project: Project }) => void) | undefined = undefined;
	export let onclose: (() => void) | undefined = undefined;
	export let pickedLat: number | null = null;
	export let pickedLon: number | null = null;
	export let pickedBoundaryVertices: [number, number][] = [];
	import { createEventDispatcher } from 'svelte';

	const dispatch = createEventDispatcher<{
		openProject: void;
		pickFarmBoundary: void;
		pickGridConnection: void;
		previewBoundaryCandidate: {
			vertices: [number, number][];
			layer: string;
			area: number;
			entityType: string;
			sourceCrs: string;
		};
		clearBoundaryPreview: void;
		close: void;
	}>();

	let showCreateForm = false;
	let newName = '';
	let newDescription = '';
	let newCapacity = 100;
	let newLocation = '';
	let newClient = '';
	let newLat: number | null = null;
	let newLon: number | null = null;
	let isDetectingGps = false;
	let isCreating = false;
	let demCaptureMessage = '';
	let gridConnectionPickedNotification = '';
	let createBoundaryFileInput: HTMLInputElement;
	let importingCreateBoundary = false;
	let createBoundaryImportMessage = '';
	let createBoundaryImportError = '';
	type BoundaryCandidate = {
		featureName: string;
		label: string;
		layer: string;
		vertices: [number, number][];
		area: number;
		entityType: string;
		sourceCrs: string;
	};
	let createBoundaryCandidates: BoundaryCandidate[] = [];
	let selectedBoundaryCandidateIndex = -1;

	// Sync externally-picked coordinates into form fields
	$: if (pickedLat !== null && pickedLon !== null) {
		newLat = pickedLat;
		newLon = pickedLon;
		gridConnectionPickedNotification = `Grid connection picked: ${pickedLat.toFixed(5)}, ${pickedLon.toFixed(5)}`;
		// Clear notification after 4 seconds
		setTimeout(() => {
			gridConnectionPickedNotification = '';
		}, 4000);
	}
	let createError: string | null = null;
	let editProjectId: string | null = null;
	let editName = '';
	let editDescription = '';
	let editCapacity = 0;
	let editLocation = '';
	let editClient = '';
	let isSavingEdit = false;
	let siteByProjectId: Record<string, Site | null> = {};
	let zoneCountByProjectId: Record<string, number> = {};
	let importSuccessMessage = '';
	let importErrorMessage = '';
	let importTargetProjectId = '';
	let importTargetType: 'boundary' | 'zones' | null = null;
	let importFileInput: HTMLInputElement;
	let mounted = false;

	onMount(() => {
		mounted = true;
	});

	$: if (mounted && open) {
		void loadProjects();
	}

	$: if (open && $projects.length > 0) {
		void loadSiteStatusForProjects($projects);
	}

	async function loadSiteStatusForProjects(projectList: Project[]) {
		const entries = await Promise.all(
			projectList.map(async (project) => {
				try {
					const { site } = await projectsApi.getSiteByProjectId(project.id);
					const zonePayload = await projectsApi.getConstraintZonesByProjectId(project.id).catch(() => ({ count: 0 }));
					return [project.id, site ?? null, zonePayload.count ?? 0] as const;
				} catch {
					return [project.id, null, 0] as const;
				}
			})
		);

		siteByProjectId = Object.fromEntries(entries.map(([projectID, site]) => [projectID, site]));
		zoneCountByProjectId = Object.fromEntries(entries.map(([projectID, , count]) => [projectID, count]));
	}

	function openImportPicker(projectId: string, type: 'boundary' | 'zones') {
		importTargetProjectId = projectId;
		importTargetType = type;
		importErrorMessage = '';
		importSuccessMessage = '';
		if (importFileInput) {
			importFileInput.value = '';
			importFileInput.click();
		}
	}

	function pickCreateBoundaryFile() {
		createBoundaryImportMessage = '';
		createBoundaryImportError = '';
		createBoundaryCandidates = [];
		selectedBoundaryCandidateIndex = -1;
		dispatch('clearBoundaryPreview');
		if (createBoundaryFileInput) {
			createBoundaryFileInput.value = '';
			createBoundaryFileInput.click();
		}
	}

	function skipBoundaryImportAndDrawManually() {
		createBoundaryImportMessage = 'Upload skipped. Draw the boundary manually in Step 1.';
		createBoundaryImportError = '';
		createBoundaryCandidates = [];
		selectedBoundaryCandidateIndex = -1;
		dispatch('clearBoundaryPreview');
	}

	function handleBoundaryCandidateSelect(event: Event) {
		const target = event.currentTarget as HTMLSelectElement | null;
		const idx = Number(target?.value ?? '-1');
		if (!Number.isInteger(idx) || idx < 0 || idx >= createBoundaryCandidates.length) {
			selectedBoundaryCandidateIndex = -1;
			dispatch('clearBoundaryPreview');
			return;
		}
		selectedBoundaryCandidateIndex = idx;
		const candidate = createBoundaryCandidates[idx];
		dispatch('previewBoundaryCandidate', {
			vertices: candidate.vertices,
			layer: candidate.layer,
			area: candidate.area,
			entityType: candidate.entityType,
			sourceCrs: candidate.sourceCrs
		});
	}

	function applySelectedBoundaryCandidate() {
		if (selectedBoundaryCandidateIndex < 0 || selectedBoundaryCandidateIndex >= createBoundaryCandidates.length) {
			createBoundaryImportError = 'Select a boundary polygon before applying.';
			return;
		}
		const candidate = createBoundaryCandidates[selectedBoundaryCandidateIndex];
		pickedBoundaryVertices = candidate.vertices;
		dispatch('previewBoundaryCandidate', {
			vertices: candidate.vertices,
			layer: candidate.layer,
			area: candidate.area,
			entityType: candidate.entityType,
			sourceCrs: candidate.sourceCrs
		});
		createBoundaryImportMessage = `Applied boundary from ${candidate.layer} (${candidate.vertices.length} vertices).`;
		createBoundaryImportError = '';
	}

	function featurePolygonRings(feature: CadParseFeature): number[][][] {
		if (!feature.geometry || feature.geometry.type !== 'Polygon') {
			return [];
		}
		const coords = feature.geometry.coordinates;
		if (!Array.isArray(coords)) {
			return [];
		}
		return coords as number[][][];
	}

	function ringArea(ring: number[][]): number {
		if (ring.length < 3) {
			return 0;
		}
		let sum = 0;
		for (let i = 0; i < ring.length - 1; i++) {
			sum += ring[i][0] * ring[i + 1][1] - ring[i + 1][0] * ring[i][1];
		}
		return Math.abs(sum / 2);
	}

	function normalizeRing(ring: number[][]): [number, number][] {
		const normalized: [number, number][] = ring.map((pt) => [Number(pt[0]), Number(pt[1])]);
		if (normalized.length >= 3) {
			const first = normalized[0];
			const last = normalized[normalized.length - 1];
			if (first[0] === last[0] && first[1] === last[1]) {
				normalized.pop();
			}
		}
		return normalized;
	}

	async function handleCreateBoundaryFileChange(event: Event) {
		const target = event.currentTarget as HTMLInputElement | null;
		const file = target?.files?.[0];
		if (!file) {
			return;
		}

		const filename = file.name.toLowerCase();
		if (!filename.endsWith('.kml') && !filename.endsWith('.kmz') && !filename.endsWith('.dxf') && !filename.endsWith('.dwg')) {
			createBoundaryImportError = 'Unsupported file format. Use .kml, .kmz, .dxf, or .dwg.';
			return;
		}

		importingCreateBoundary = true;
		createBoundaryImportMessage = '';
		createBoundaryImportError = '';

		try {
			const parsed = await projectsApi.parseCadFile(file);
			const polygonCandidates: BoundaryCandidate[] = [];

			for (const [index, feature] of (parsed.feature_collection.features ?? []).entries()) {
				const rings = featurePolygonRings(feature);
				if (rings.length === 0 || rings[0].length < 4) {
					continue;
				}
				const ring = normalizeRing(rings[0]);
				if (ring.length < 3) {
					continue;
				}
				const layer = feature.properties?.layer ?? 'default';
				const name = feature.properties?.name ?? feature.properties?.entity_type ?? `Polygon ${index + 1}`;
				const entityType = feature.properties?.entity_type ?? feature.geometry.type;
				const area = ringArea(ring as unknown as number[][]);
				polygonCandidates.push({
					featureName: name,
					vertices: ring,
					area,
					layer,
					entityType,
					sourceCrs: parsed.source_crs,
					label: `${name} | ${layer} | area ${area.toFixed(2)}`
				});
			}

			if (polygonCandidates.length === 0) {
				createBoundaryImportError = 'No polygon boundary found in uploaded file.';
				return;
			}

			polygonCandidates.sort((a, b) => b.area - a.area);
			createBoundaryCandidates = polygonCandidates;
			selectedBoundaryCandidateIndex = 0;
			dispatch('previewBoundaryCandidate', {
				vertices: polygonCandidates[0].vertices,
				layer: polygonCandidates[0].layer,
				area: polygonCandidates[0].area,
				entityType: polygonCandidates[0].entityType,
				sourceCrs: polygonCandidates[0].sourceCrs
			});
			createBoundaryImportMessage = `Parsed ${polygonCandidates.length} polygon candidates from ${file.name}. Select one and apply.`;
		} catch (err) {
			createBoundaryImportError = err instanceof Error ? err.message : 'Failed to parse boundary file.';
			dispatch('clearBoundaryPreview');
		} finally {
			importingCreateBoundary = false;
		}
	}

	async function handleImportFileChange(event: Event) {
		const target = event.currentTarget as HTMLInputElement | null;
		const file = target?.files?.[0];
		if (!file || !importTargetProjectId || !importTargetType) {
			return;
		}

		const filename = file.name.toLowerCase();
		if (importTargetType === 'zones' && !filename.endsWith('.kml') && !filename.endsWith('.kmz')) {
			importErrorMessage = 'Only .kml or .kmz files are supported for zone import.';
			return;
		}

		if (
			importTargetType === 'boundary' &&
			!filename.endsWith('.kml') &&
			!filename.endsWith('.kmz') &&
			!filename.endsWith('.dxf') &&
			!filename.endsWith('.dwg')
		) {
			importErrorMessage = 'Boundary import supports .kml, .kmz, .dxf, or .dwg.';
			return;
		}

		try {
			if (importTargetType === 'boundary') {
				await projectsApi.importSiteBoundary(importTargetProjectId, file, {
					timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
				});
				importSuccessMessage = `Boundary imported successfully: ${file.name}`;
			} else {
				const result = await projectsApi.importConstraintZones(importTargetProjectId, file);
				importSuccessMessage = `Constraint zones imported (${result.count}): ${file.name}`;
			}
			await loadProjects();
			await loadSiteStatusForProjects($projects);
		} catch (err) {
			console.error('Import failed:', err);
			importErrorMessage = err instanceof Error ? err.message : 'Import failed.';
		} finally {
			importTargetProjectId = '';
			importTargetType = null;
		}
	}

	async function detectGpsLocation() {
		if (!navigator.geolocation) {
			toast.error('Geolocation is not supported by your browser.');
			return;
		}
		isDetectingGps = true;
		navigator.geolocation.getCurrentPosition(
			(pos) => {
				newLat = pos.coords.latitude;
				newLon = pos.coords.longitude;
				isDetectingGps = false;
			},
			() => {
				toast.error('Unable to detect location. Please allow location access.');
				isDetectingGps = false;
			},
			{ enableHighAccuracy: true, timeout: 10000 }
		);
	}

	async function handleCreate() {
		if (!newName.trim()) return;
		if (pickedBoundaryVertices.length < 3) {
			createError = 'Draw the solar farm boundary on map first (minimum 3 vertices).';
			return;
		}
		if (newLat === null || newLon === null) {
			createError = 'Pick the grid/substation connection center on map before creating project.';
			return;
		}
		isCreating = true;
		createError = null;
		demCaptureMessage = '';
		try {
			const farmCentroid = polygonCentroid(pickedBoundaryVertices);
			const boundaryGeojson = polygonGeoJSON(pickedBoundaryVertices);
			const areaSqm = polygonAreaSqm(pickedBoundaryVertices);
			const demBounds = corridorBounds(pickedBoundaryVertices, { latitude: newLat, longitude: newLon }, 0.01);

			const project = await createProject({
				name: newName.trim(),
				description: newDescription.trim(),
				target_capacity_mw: newCapacity,
				location_name: newLocation.trim() || undefined,
				client_name: newClient.trim() || undefined,
				initial_latitude: farmCentroid.latitude,
				initial_longitude: farmCentroid.longitude
			});

			await projectsApi.createSite({
				project_id: project.id,
				name: `${project.name} Solar Farm`,
				boundary_geojson: boundaryGeojson,
				area_sqm: areaSqm,
				latitude: farmCentroid.latitude,
				longitude: farmCentroid.longitude,
				timezone: Intl.DateTimeFormat().resolvedOptions().timeZone
			});

			let demStatus = 'pending_dem_upload';
			let demDetail = 'DEM capture requires an uploaded Copernicus GeoTIFF DEM layer for this project.';
			try {
				const demLayerResult = await terrainApi.ensureCopernicusDemLayer(project.id, demBounds, 30);
				await terrainApi.getElevationGrid(project.id, demBounds, 30);
				demStatus = 'captured';
				demDetail = demLayerResult.created
					? 'Copernicus GeoTIFF DEM layer auto-registered and corridor DEM sampled.'
					: 'Existing DEM layer found and corridor DEM sampled.';
				demCaptureMessage = demLayerResult.created
					? 'Copernicus DEM layer auto-created and corridor DEM capture completed.'
					: 'DEM capture completed for farm-to-grid corridor.';
			} catch (demErr) {
				demCaptureMessage = demErr instanceof Error
					? `DEM capture pending: ${demErr.message}`
					: 'DEM capture pending: Copernicus DEM bootstrap failed; upload GeoTIFF DEM layer and retry.';
			}

			await updateProject(project.id, {
				notes: JSON.stringify(
					{
						solar_farm_boundary_vertices: pickedBoundaryVertices,
						grid_connection_center: { latitude: newLat, longitude: newLon },
						dem_capture: {
							source: 'Copernicus GeoTIFF',
							status: demStatus,
							detail: demDetail,
							bounds: demBounds,
							resolution_m: 30,
							captured_at: new Date().toISOString()
						}
					},
					null,
					2
				)
			});

			activeProjectId.set(project.id);
			onopenProject?.({ project });
			showCreateForm = false;
			resetForm();
		} catch (err) {
			console.error('Failed to create project:', err);
			createError = err instanceof Error ? err.message : 'Failed to create project. Is the server running?';
		} finally {
			isCreating = false;
		}
	}

	function handleOpen(project: Project) {
		activeProjectId.set(project.id);
		onopenProject?.({ project });
	}

	async function handleDelete(id: string, name: string) {
		const ok = await confirmModal({
			title: `Delete project "${name}"?`,
			body: 'This cannot be undone. All associated layouts, simulations, and reports will also be removed.',
			confirmLabel: 'Delete',
			danger: true
		});
		if (!ok) return;
		await deleteProject(id);
	}

	function resetForm() {
		newName = '';
		newDescription = '';
		newCapacity = 100;
		newLocation = '';
		newClient = '';
		newLat = null;
		newLon = null;
		demCaptureMessage = '';
		gridConnectionPickedNotification = '';
		createBoundaryImportMessage = '';
		createBoundaryImportError = '';
		createBoundaryCandidates = [];
		selectedBoundaryCandidateIndex = -1;
		dispatch('clearBoundaryPreview');
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

	function polygonGeoJSON(coords: [number, number][]): string {
		const ring = [...coords, coords[0]];
		return JSON.stringify({ type: 'Polygon', coordinates: [ring] });
	}

	function corridorBounds(coords: [number, number][], gridPoint: { latitude: number; longitude: number }, padDeg: number) {
		const lons = coords.map(([lon]) => lon);
		const lats = coords.map(([, lat]) => lat);
		lons.push(gridPoint.longitude);
		lats.push(gridPoint.latitude);
		return {
			min_x: Math.min(...lons) - padDeg,
			min_y: Math.min(...lats) - padDeg,
			max_x: Math.max(...lons) + padDeg,
			max_y: Math.max(...lats) + padDeg
		};
	}

	function startEdit(project: Project) {
		editProjectId = project.id;
		editName = project.name;
		editDescription = project.description ?? '';
		editCapacity = project.target_capacity_mw ?? 0;
		editLocation = project.location_name ?? '';
		editClient = project.client_name ?? '';
	}

	function cancelEdit() {
		editProjectId = null;
		editName = '';
		editDescription = '';
		editCapacity = 0;
		editLocation = '';
		editClient = '';
	}

	async function handleSaveEdit() {
		if (!editProjectId || !editName.trim()) return;
		isSavingEdit = true;
		try {
			await updateProject(editProjectId, {
				name: editName.trim(),
				description: editDescription.trim(),
				target_capacity_mw: editCapacity,
				location_name: editLocation.trim(),
				client_name: editClient.trim()
			});
			cancelEdit();
		} catch (err) {
			console.error('Failed to update project:', err);
		} finally {
			isSavingEdit = false;
		}
	}

	function close() {
		onclose?.();
	}

	function handleOverlayKeydown(event: KeyboardEvent) {
		if (event.key === 'Escape') {
			close();
		}
	}

	function getStatusColor(status: string): string {
		switch (status) {
			case 'draft': return '#94a3b8';
			case 'design': return '#3b82f6';
			case 'simulation': return '#f59e0b';
			case 'review': return '#8b5cf6';
			case 'approved': return '#22c55e';
			case 'archived': return '#64748b';
			default: return '#94a3b8';
		}
	}

	function getSiteState(projectId: string): 'saved' | 'missing' {
		return siteByProjectId[projectId] ? 'saved' : 'missing';
	}

	function getZoneCount(projectId: string): number {
		return zoneCountByProjectId[projectId] ?? 0;
	}

	function formatSiteSavedAt(projectId: string): string {
		const site = siteByProjectId[projectId];
		if (!site?.created_at) return '';
		return new Date(site.created_at).toLocaleString();
	}

	function getDemStatus(project: Project): { label: string; className: 'cached' | 'ready' | 'pending' | 'unknown' } {
		if (!project.notes) {
			return { label: 'DEM unknown', className: 'unknown' };
		}

		try {
			const parsed = JSON.parse(project.notes);
			const capture = parsed?.dem_capture;
			if (!capture || typeof capture !== 'object') {
				return { label: 'DEM unknown', className: 'unknown' };
			}

			const detail = String(capture.detail ?? '').toLowerCase();
			const status = String(capture.status ?? '').toLowerCase();
			if (status === 'captured' && detail.includes('existing dem layer')) {
				return { label: 'DEM cached', className: 'cached' };
			}
			if (status === 'captured') {
				return { label: 'DEM ready', className: 'ready' };
			}
			if (status.includes('pending')) {
				return { label: 'DEM pending', className: 'pending' };
			}

			return { label: 'DEM unknown', className: 'unknown' };
		} catch {
			return { label: 'DEM unknown', className: 'unknown' };
		}
	}
</script>

{#if open}
	<div
		class="overlay"
		role="dialog"
		aria-modal="true"
		aria-labelledby="projects-dashboard-title"
		tabindex="-1"
		on:click|self={close}
		on:keydown={handleOverlayKeydown}
	>
		<div class="dashboard">
			<div class="dash-header">
				<h2 id="projects-dashboard-title">Projects</h2>
				<div class="header-actions">
					<button class="btn-new" on:click={() => { showCreateForm = !showCreateForm; }}>
						{showCreateForm ? 'Cancel' : '+ New Project'}
					</button>
					<button class="btn-close" on:click={close}>x</button>
				</div>
			</div>

			{#if $loadError}
				<div class="error-banner" role="alert">
					Could not load projects: {$loadError}
				</div>
			{/if}

			{#if importErrorMessage}
				<div class="error-banner" role="alert">{importErrorMessage}</div>
			{/if}
			{#if importSuccessMessage}
				<div class="success-banner" role="status">{importSuccessMessage}</div>
			{/if}

			{#if showCreateForm}
				<form class="create-form" on:submit|preventDefault={handleCreate}>
					<div class="form-row">
						<div class="form-group">
							<label for="create-project-name">Project Name *</label>
							<input id="create-project-name" type="text" bind:value={newName} placeholder="e.g. Riverside Solar Farm" />
						</div>
						<div class="form-group">
							<label for="create-project-capacity">Target Capacity (MW)</label>
							<input id="create-project-capacity" type="number" bind:value={newCapacity} min="0" step="0.1" />
						</div>
					</div>
					<div class="form-group">
						<label for="create-project-description">Description</label>
						<textarea id="create-project-description" bind:value={newDescription} rows="2" placeholder="Project details..."></textarea>
					</div>
					<div class="form-row">
						<div class="form-group">
							<label for="create-project-location">Location</label>
							<input id="create-project-location" type="text" bind:value={newLocation} placeholder="City, State" />
						</div>
						<div class="form-group">
							<label for="create-project-client">Client</label>
							<input id="create-project-client" type="text" bind:value={newClient} placeholder="Client name" />
						</div>
					</div>
					<p class="boundary-note"><strong>Map-First Creation:</strong> Optionally import a CAD/KML boundary first, then confirm/edit on map.</p>
					<div class="form-group gps-row">
						<span class="field-title">Step 0 (Optional): Import Boundary File</span>
						<div class="gps-detect-row">
							<button type="button" class="btn-pick-map" on:click={pickCreateBoundaryFile} disabled={importingCreateBoundary}>
								{importingCreateBoundary ? 'Importing...' : 'Upload .kml / .kmz / .dxf / .dwg'}
							</button>
							<button type="button" class="btn-skip-import" on:click={skipBoundaryImportAndDrawManually}>
								Skip and draw manually
							</button>
							{#if createBoundaryCandidates.length > 0}
								{@const selectedCandidate =
									selectedBoundaryCandidateIndex >= 0 && selectedBoundaryCandidateIndex < createBoundaryCandidates.length
										? createBoundaryCandidates[selectedBoundaryCandidateIndex]
										: null}
								<select
									class="candidate-select"
									value={selectedBoundaryCandidateIndex}
									on:change={handleBoundaryCandidateSelect}
									title="Select parsed boundary polygon"
								>
									{#each createBoundaryCandidates as candidate, index}
										<option value={index}>{candidate.label}</option>
									{/each}
								</select>
								<button type="button" class="btn-pick-map" on:click={applySelectedBoundaryCandidate}>
									Apply Selected
								</button>
								{#if selectedCandidate}
									<div class="candidate-meta" role="status" aria-label="Selected boundary metadata">
										<div><strong>Layer:</strong> {selectedCandidate.layer}</div>
										<div><strong>Area:</strong> {selectedCandidate.area.toFixed(2)}</div>
										<div><strong>Entity:</strong> {selectedCandidate.entityType}</div>
										<div><strong>CRS:</strong> {selectedCandidate.sourceCrs}</div>
									</div>
								{/if}
							{/if}
							{#if createBoundaryImportMessage}
								<span class="gps-coords">{createBoundaryImportMessage}</span>
							{/if}
							{#if createBoundaryImportError}
								<span class="gps-pending">{createBoundaryImportError}</span>
							{/if}
						</div>
					</div>
					<div class="form-group gps-row">
						<span class="field-title">Step 1: Draw or Refine Solar Farm Boundary</span>
						<div class="gps-detect-row">
							<button type="button" class="btn-pick-map" on:click={() => dispatch('pickFarmBoundary')}>
								▦ Draw Farm Boundary on Map
							</button>
							{#if pickedBoundaryVertices.length > 0}
								<span class="gps-coords">{pickedBoundaryVertices.length} vertices ✓</span>
							{:else}
								<span class="gps-pending">Click button, then draw on map. Minimum 3 vertices.</span>
							{/if}
						</div>
					</div>
					<div class="form-group gps-row">
						<span class="field-title">Step 2: Pick Grid/Substation Connection Center</span>
						<div class="gps-detect-row">
							<button type="button" class="btn-detect-gps" on:click={detectGpsLocation} disabled={isDetectingGps}>
								{isDetectingGps ? 'Detecting...' : '📍 Auto-Detect Location'}
							</button>
							<button type="button" class="btn-pick-map" on:click={() => dispatch('pickGridConnection')}>
								🗺 Pick on Map
							</button>
							{#if newLat !== null && newLon !== null}
								<span class="gps-coords">{newLat.toFixed(5)}, {newLon.toFixed(5)} ✓</span>
								<button type="button" class="btn-clear-gps" on:click={() => { newLat = null; newLon = null; }}>✕ Clear</button>
							{:else}
								<span class="gps-pending">Use map or GPS to set grid connection point</span>
							{/if}
						</div>
					</div>
					{#if gridConnectionPickedNotification}
						<div class="success-banner" role="status">{gridConnectionPickedNotification}</div>
					{/if}
					{#if demCaptureMessage}
						<div class="error-banner" role="status">{demCaptureMessage}</div>
					{/if}
					{#if createError}
						<div class="error-banner" role="alert">{createError}</div>
					{/if}
					<button type="submit" class="btn-create" disabled={!newName.trim() || isCreating || pickedBoundaryVertices.length < 3 || newLat === null || newLon === null}>
						{isCreating ? 'Creating...' : 'Create Project'}
					</button>
				</form>
			{/if}

			<div class="project-list">
				{#if editProjectId}
					<form class="create-form edit-form" on:submit|preventDefault={handleSaveEdit}>
						<div class="form-row">
							<div class="form-group">
								<label for="edit-project-name">Edit Project Name *</label>
								<input id="edit-project-name" type="text" bind:value={editName} />
							</div>
							<div class="form-group">
								<label for="edit-project-capacity">Target Capacity (MW)</label>
								<input id="edit-project-capacity" type="number" bind:value={editCapacity} min="0" step="0.1" />
							</div>
						</div>
						<div class="form-group">
							<label for="edit-project-description">Description</label>
							<textarea id="edit-project-description" bind:value={editDescription} rows="2"></textarea>
						</div>
						<div class="form-row">
							<div class="form-group">
								<label for="edit-project-location">Location</label>
								<input id="edit-project-location" type="text" bind:value={editLocation} />
							</div>
							<div class="form-group">
								<label for="edit-project-client">Client</label>
								<input id="edit-project-client" type="text" bind:value={editClient} />
							</div>
						</div>
						<div class="edit-actions">
							<button type="button" class="btn-cancel-edit" on:click={cancelEdit}>Cancel</button>
							<button type="submit" class="btn-create" disabled={!editName.trim() || isSavingEdit}>
								{isSavingEdit ? 'Saving...' : 'Save Changes'}
							</button>
						</div>
					</form>
				{/if}
				{#if $projects.length === 0}
					<div class="empty">
						<p>No projects yet. Create your first solar project to get started.</p>
					</div>
				{:else}
					   {#each $projects as project}
						   <div class="project-card" role="button" tabindex="0" on:click={() => handleOpen(project)} on:keydown={(e) => (e.key === 'Enter' || e.key === ' ') && handleOpen(project)}>
							   <div class="card-top">
								   <h3>{project.name}</h3>
								   <div class="badges">
									   <span class="status" style="color: {getStatusColor(project.status)}; background: {getStatusColor(project.status)}20;">
										   {project.status}
									   </span>
									   <span class="site-status {getSiteState(project.id)}">
										   {#if getSiteState(project.id) === 'saved'}
											   Site saved
										{:else}
											   Site missing
										{/if}
									   </span>
									   <span class="dem-status {getDemStatus(project).className}">
										   {getDemStatus(project).label}
									   </span>
									   <span class="zone-status {getZoneCount(project.id) > 0 ? 'ready' : 'empty'}">
										   Zones: {getZoneCount(project.id)}
									   </span>
								   </div>
							   </div>
							   {#if project.description}
								   <p class="description">{project.description}</p>
							   {/if}
							   <div class="card-meta">
								   {#if project.target_capacity_mw}
									   <span>{project.target_capacity_mw} MW</span>
								   {/if}
								   {#if project.location_name}
									   <span>{project.location_name}</span>
								   {/if}
								   {#if project.client_name}
									   <span>{project.client_name}</span>
								   {/if}
								   <span class="date">{new Date(project.created_at).toLocaleDateString()}</span>
								   {#if getSiteState(project.id) === 'saved'}
									   <span class="site-date">Site: {formatSiteSavedAt(project.id)}</span>
								   {/if}
							   </div>
							   <button class="btn-delete" on:click|stopPropagation={() => handleDelete(project.id, project.name)}>
								   Delete
							   </button>
							   <button class="btn-edit" on:click|stopPropagation={() => startEdit(project)}>
								   Edit
							   </button>
							   <button class="btn-import-boundary" on:click|stopPropagation={() => openImportPicker(project.id, 'boundary')}>
								   Import Boundary
							   </button>
							   <button class="btn-import-zones" on:click|stopPropagation={() => openImportPicker(project.id, 'zones')}>
								   Import Zones
							   </button>
						   </div>
					{/each}
				{/if}
			</div>
			<input
				bind:this={createBoundaryFileInput}
				type="file"
				accept=".kml,.kmz,.dxf,.dwg"
				on:change={handleCreateBoundaryFileChange}
				style="display: none"
			/>
			<input
				bind:this={importFileInput}
				type="file"
				accept=".kml,.kmz,.dxf,.dwg"
				on:change={handleImportFileChange}
				style="display: none"
			/>
		</div>
	</div>
{/if}

<style>
	.overlay {
		position: fixed;
		inset: 0;
		background: rgba(0, 0, 0, 0.6);
		display: flex;
		align-items: center;
		justify-content: center;
		z-index: 200;
		backdrop-filter: blur(4px);
	}

	.dashboard {
		width: 680px;
		max-height: 80vh;
		background: #16213e;
		border-radius: 12px;
		border: 1px solid rgba(255, 255, 255, 0.1);
		display: flex;
		flex-direction: column;
		overflow: hidden;
	}

	.dash-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 20px 24px;
		border-bottom: 1px solid rgba(255, 255, 255, 0.1);
	}

	.dash-header h2 {
		margin: 0;
		font-size: 18px;
		font-weight: 700;
		color: #e2e8f0;
	}

	.header-actions {
		display: flex;
		gap: 8px;
	}

	.btn-new {
		padding: 6px 14px;
		border: none;
		border-radius: 6px;
		background: linear-gradient(135deg, #f59e0b, #d97706);
		color: #1a1a2e;
		font-size: 13px;
		font-weight: 600;
		cursor: pointer;
	}

	.btn-close {
		width: 32px;
		height: 32px;
		border: none;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.08);
		color: #94a3b8;
		font-size: 16px;
		cursor: pointer;
	}

	.create-form {
		padding: 20px 24px;
		border-bottom: 1px solid rgba(255, 255, 255, 0.1);
		display: flex;
		flex-direction: column;
		gap: 12px;
		background: rgba(0, 0, 0, 0.15);
	}

	.gps-detect-row {
		display: flex;
		align-items: center;
		gap: 10px;
		flex-wrap: wrap;
	}

	.candidate-select {
		padding: 6px 8px;
		border: 1px solid rgba(255, 255, 255, 0.2);
		border-radius: 6px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 12px;
		min-width: 260px;
	}

	.candidate-meta {
		display: grid;
		grid-template-columns: repeat(2, minmax(140px, auto));
		gap: 4px 12px;
		padding: 6px 10px;
		border: 1px solid rgba(56, 189, 248, 0.35);
		border-radius: 6px;
		background: rgba(56, 189, 248, 0.12);
		color: #bae6fd;
		font-size: 11px;
	}

	.btn-skip-import {
		padding: 6px 12px;
		border: 1px solid rgba(148, 163, 184, 0.4);
		border-radius: 6px;
		background: rgba(148, 163, 184, 0.1);
		color: #cbd5e1;
		font-size: 12px;
		cursor: pointer;
	}

	.btn-skip-import:hover {
		background: rgba(148, 163, 184, 0.18);
	}

	.btn-detect-gps {
		padding: 6px 12px;
		border: 1px solid rgba(255, 255, 255, 0.2);
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.06);
		color: #e2e8f0;
		font-size: 12px;
		cursor: pointer;
		transition: background 0.15s;
	}

	.btn-detect-gps:hover:not(:disabled) {
		background: rgba(255, 255, 255, 0.12);
	}

	.btn-detect-gps:disabled {
		opacity: 0.55;
		cursor: not-allowed;
	}

	.btn-pick-map {
		padding: 6px 12px;
		border: 1px solid rgba(99, 179, 237, 0.4);
		border-radius: 6px;
		background: rgba(99, 179, 237, 0.1);
		color: #63b3ed;
		font-size: 12px;
		cursor: pointer;
		transition: background 0.15s;
	}

	.btn-pick-map:hover {
		background: rgba(99, 179, 237, 0.2);
	}

	.gps-coords {
		font-size: 12px;
		color: #22c55e;
		font-family: monospace;
	}

	.gps-pending {
		font-size: 12px;
		color: #fbbf24;
		font-style: italic;
	}

	.btn-clear-gps {
		border: none;
		background: transparent;
		color: #94a3b8;
		cursor: pointer;
		font-size: 13px;
		padding: 0 4px;
	}

	.boundary-note {
		margin: 0;
		font-size: 12px;
		color: #94a3b8;
	}

	.form-row {
		display: flex;
		gap: 12px;
	}

	.form-group {
		display: flex;
		flex-direction: column;
		gap: 4px;
		flex: 1;
	}

	.form-group label {
		font-size: 11px;
		font-weight: 500;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.field-title {
		font-size: 11px;
		font-weight: 500;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.form-group input,
	.form-group textarea {
		padding: 8px 10px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 6px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 13px;
		font-family: inherit;
		resize: vertical;
	}

	.form-group input:focus,
	.form-group textarea:focus {
		outline: none;
		border-color: #f59e0b;
	}

	.btn-create {
		padding: 10px;
		border: none;
		border-radius: 6px;
		background: linear-gradient(135deg, #f59e0b, #d97706);
		color: #1a1a2e;
		font-size: 14px;
		font-weight: 600;
		cursor: pointer;
	}

	.btn-create:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}

	.project-list {
		flex: 1;
		overflow-y: auto;
		padding: 16px 24px;
		display: flex;
		flex-direction: column;
		gap: 8px;
	}

	.error-banner {
		background: rgba(239, 68, 68, 0.15);
		border: 1px solid rgba(239, 68, 68, 0.4);
		border-radius: 6px;
		color: #fca5a5;
		font-size: 13px;
		padding: 8px 12px;
		margin-bottom: 8px;
	}

	.success-banner {
		background: rgba(34, 197, 94, 0.15);
		border: 1px solid rgba(34, 197, 94, 0.4);
		border-radius: 6px;
		color: #86efac;
		font-size: 13px;
		padding: 8px 12px;
		margin-bottom: 8px;
	}

	.empty {
		text-align: center;
		padding: 40px 0;
		color: #64748b;
		font-size: 14px;
	}

	.project-card {
		display: flex;
		flex-direction: column;
		gap: 6px;
		padding: 14px 16px;
		border: 1px solid rgba(255, 255, 255, 0.08);
		border-radius: 8px;
		background: rgba(255, 255, 255, 0.03);
		cursor: pointer;
		text-align: left;
		color: inherit;
		position: relative;
		transition: all 0.15s;
	}

	.project-card:hover {
		border-color: rgba(245, 158, 11, 0.3);
		background: rgba(245, 158, 11, 0.05);
	}

	.card-top {
		display: flex;
		align-items: center;
		justify-content: space-between;
		gap: 8px;
	}

	.badges {
		display: flex;
		align-items: center;
		gap: 6px;
	}

	.card-top h3 {
		margin: 0;
		font-size: 14px;
		font-weight: 600;
		color: #e2e8f0;
	}

	.status {
		padding: 2px 8px;
		border-radius: 4px;
		font-size: 11px;
		font-weight: 500;
		text-transform: capitalize;
	}

	.site-status {
		padding: 2px 8px;
		border-radius: 4px;
		font-size: 11px;
		font-weight: 600;
	}

	.site-status.saved {
		color: #22c55e;
		background: rgba(34, 197, 94, 0.14);
	}


	.dem-status {
		font-size: 11px;
		padding: 3px 8px;
		border-radius: 999px;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.03em;
	}

	.dem-status.cached {
		background: rgba(56, 189, 248, 0.2);
		color: #7dd3fc;
	}

	.dem-status.ready {
		background: rgba(34, 197, 94, 0.18);
		color: #86efac;
	}

	.dem-status.pending {
		background: rgba(251, 191, 36, 0.2);
		color: #fde68a;
	}

	.dem-status.unknown {
		background: rgba(148, 163, 184, 0.2);
		color: #cbd5e1;
	}

	.zone-status {
		font-size: 11px;
		padding: 3px 8px;
		border-radius: 999px;
		font-weight: 600;
		letter-spacing: 0.03em;
	}

	.zone-status.ready {
		background: rgba(34, 197, 94, 0.18);
		color: #86efac;
	}

	.zone-status.empty {
		background: rgba(148, 163, 184, 0.2);
		color: #cbd5e1;
	}
	.site-status.missing {
		color: #f59e0b;
		background: rgba(245, 158, 11, 0.14);
	}

	.site-date {
		color: #94a3b8;
	}

	.description {
		margin: 0;
		font-size: 12px;
		color: #94a3b8;
		line-height: 1.4;
	}

	.card-meta {
		display: flex;
		gap: 12px;
		font-size: 11px;
		color: #64748b;
	}

	.card-meta span {
		display: flex;
		align-items: center;
		gap: 4px;
	}

	.btn-delete {
		position: absolute;
		top: 12px;
		right: 12px;
		padding: 2px 8px;
		border: 1px solid rgba(239, 68, 68, 0.3);
		border-radius: 4px;
		background: transparent;
		color: #ef4444;
		font-size: 11px;
		cursor: pointer;
		opacity: 0;
		transition: opacity 0.15s;
	}

	.project-card:hover .btn-delete {
		opacity: 1;
	}

	.btn-edit {
		position: absolute;
		top: 12px;
		right: 64px;
		padding: 2px 8px;
		border: 1px solid rgba(59, 130, 246, 0.4);
		border-radius: 4px;
		background: transparent;
		color: #60a5fa;
		font-size: 11px;
		cursor: pointer;
		opacity: 0;
		transition: opacity 0.15s;
	}

	.project-card:hover .btn-edit {
		opacity: 1;
	}

	.btn-edit:hover {
		background: rgba(59, 130, 246, 0.12);
	}

	.btn-import-boundary {
		position: absolute;
		top: 12px;
		right: 112px;
		padding: 2px 8px;
		border: 1px solid rgba(34, 197, 94, 0.4);
		border-radius: 4px;
		background: transparent;
		color: #86efac;
		font-size: 11px;
		cursor: pointer;
		opacity: 0;
		transition: opacity 0.15s;
	}

	.btn-import-zones {
		position: absolute;
		top: 12px;
		right: 215px;
		padding: 2px 8px;
		border: 1px solid rgba(245, 158, 11, 0.45);
		border-radius: 4px;
		background: transparent;
		color: #fbbf24;
		font-size: 11px;
		cursor: pointer;
		opacity: 0;
		transition: opacity 0.15s;
	}

	.project-card:hover .btn-import-boundary,
	.project-card:hover .btn-import-zones {
		opacity: 1;
	}

	.btn-import-boundary:hover {
		background: rgba(34, 197, 94, 0.14);
	}

	.btn-import-zones:hover {
		background: rgba(245, 158, 11, 0.14);
	}

	.edit-form {
		margin-bottom: 12px;
	}

	.edit-actions {
		display: flex;
		justify-content: flex-end;
		gap: 8px;
	}

	.btn-cancel-edit {
		padding: 10px 12px;
		border: 1px solid rgba(148, 163, 184, 0.35);
		border-radius: 6px;
		background: transparent;
		color: #cbd5e1;
		font-size: 13px;
		cursor: pointer;
	}

	.btn-delete:hover {
		background: rgba(239, 68, 68, 0.1);
	}
</style>
