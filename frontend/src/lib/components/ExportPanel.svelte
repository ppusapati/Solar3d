<script lang="ts">
	import { activeProject, activeLayout, visibleTiles, components, boundaryEntities, getAllEntitiesForExport } from '$lib/core/stores';
	import { generateDxf, generateKml, generateGeoJson } from '$lib/core/export/dxf';
	import { layoutApi } from '$lib/core/api';

	let exportFormat: 'dxf' | 'kml' | 'geojson' | 'csv' = 'dxf';
	let isExporting = false;
	let includeOptions = {
		panels: true,
		components: true,
		boundary: true,
		routes: true
	};

	async function handleExport() {
		if (!$activeLayout) return;
		isExporting = true;

		try {
			// Collect panel data from loaded tiles
			const panels: any[] = [];
			for (const tile of $visibleTiles) {
				try {
					const resp = await layoutApi.getTilePanels(tile.id);
					if (resp.panels) panels.push(...resp.panels);
				} catch { /* tile may not have panels yet */ }
			}

			// Collect placed components from store
			const componentsList = $components || [];

			// Get boundary from entity store
			const boundaries = $boundaryEntities;
			const boundary = boundaries.length > 0 ? JSON.parse(boundaries[0].geojson) : undefined;

			// Collect routes from entity store
			const allEntities = getAllEntitiesForExport();
			const routes = allEntities
				.filter((e) => e.type === 'component' && e.properties?.type === 'route')
				.map((e) => {
					try {
						const geojson = JSON.parse(e.geojson) as { type?: string; coordinates?: number[][] };
						if (geojson.type !== 'LineString' || !Array.isArray(geojson.coordinates)) {
							return null;
						}

						return {
							route_type: e.properties?.route_type ?? 'cable',
							waypoints: geojson.coordinates.map(([longitude, latitude]) => ({ longitude, latitude }))
						};
					} catch {
						return null;
					}
				})
				.filter((route): route is { route_type: string; waypoints: { longitude: number; latitude: number }[] } => Boolean(route));

			let content: string;
			let filename: string;
			let mimeType: string;

			const projectName = $activeProject?.name || 'Solar3D Project';

			switch (exportFormat) {
				case 'dxf':
					content = generateDxf(panels, componentsList, boundary, routes);
					filename = `${projectName}_layout.dxf`;
					mimeType = 'application/dxf';
					break;
				case 'kml':
					content = generateKml(projectName, panels, componentsList, boundary);
					filename = `${projectName}_layout.kml`;
					mimeType = 'application/vnd.google-earth.kml+xml';
					break;
				case 'geojson':
					content = generateGeoJson(panels, componentsList, boundary);
					filename = `${projectName}_layout.geojson`;
					mimeType = 'application/geo+json';
					break;
				case 'csv':
					content = generateCsv(panels, componentsList);
					filename = `${projectName}_layout.csv`;
					mimeType = 'text/csv';
					break;
				default:
					return;
			}

			downloadFile(content, filename, mimeType);
		} finally {
			isExporting = false;
		}
	}

	function generateCsv(panels: any[], components: any[]): string {
		const lines = ['Type,ID,Longitude,Latitude,Tilt,Azimuth,StringID'];
		for (const panel of panels) {
			try {
				const geojson = JSON.parse(panel.geometry_geojson);
				const centroid = getCentroid(geojson.coordinates[0]);
				lines.push(`Panel,${panel.id || ''},${centroid[0]},${centroid[1]},${panel.tilt},${panel.azimuth},${panel.string_id || ''}`);
			} catch { /* skip */ }
		}
		for (const comp of components) {
			lines.push(`${comp.component_type},${comp.id || ''},${comp.position.longitude},${comp.position.latitude},,,`);
		}
		return lines.join('\n');
	}

	function getCentroid(coords: number[][]): [number, number] {
		let sumX = 0, sumY = 0;
		for (const c of coords) {
			sumX += c[0];
			sumY += c[1];
		}
		return [sumX / coords.length, sumY / coords.length];
	}

	function downloadFile(content: string, filename: string, mimeType: string) {
		const blob = new Blob([content], { type: mimeType });
		const url = URL.createObjectURL(blob);
		const a = document.createElement('a');
		a.href = url;
		a.download = filename;
		document.body.appendChild(a);
		a.click();
		document.body.removeChild(a);
		URL.revokeObjectURL(url);
	}
</script>

<div class="export-panel">
	<h5>Export Layout</h5>

	<div class="format-grid">
		{#each [
			{ id: 'dxf', label: 'DXF', desc: 'AutoCAD / CAD software' },
			{ id: 'kml', label: 'KML', desc: 'Google Earth' },
			{ id: 'geojson', label: 'GeoJSON', desc: 'GIS applications' },
			{ id: 'csv', label: 'CSV', desc: 'Spreadsheet / data' }
		] as fmt}
			<button
				class="format-card"
				class:active={exportFormat === fmt.id}
				on:click={() => { exportFormat = fmt.id as any; }}
			>
				<span class="format-label">{fmt.label}</span>
				<span class="format-desc">{fmt.desc}</span>
			</button>
		{/each}
	</div>

	<div class="include-options">
		<label><input type="checkbox" bind:checked={includeOptions.panels} /> Panels</label>
		<label><input type="checkbox" bind:checked={includeOptions.components} /> Equipment</label>
		<label><input type="checkbox" bind:checked={includeOptions.boundary} /> Boundary</label>
		<label><input type="checkbox" bind:checked={includeOptions.routes} /> Routes</label>
	</div>

	<button
		class="btn-export"
		on:click={handleExport}
		disabled={isExporting || !$activeLayout}
	>
		{isExporting ? 'Exporting...' : `Export as ${exportFormat.toUpperCase()}`}
	</button>
</div>

<style>
	.export-panel {
		display: flex;
		flex-direction: column;
		gap: 10px;
	}

	h5 {
		margin: 0;
		font-size: 12px;
		font-weight: 600;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.format-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 6px;
	}

	.format-card {
		display: flex;
		flex-direction: column;
		gap: 2px;
		padding: 8px;
		border: 1px solid rgba(255, 255, 255, 0.1);
		border-radius: 6px;
		background: transparent;
		color: #e2e8f0;
		cursor: pointer;
		text-align: left;
		transition: all 0.15s;
	}

	.format-card:hover {
		border-color: rgba(245, 158, 11, 0.3);
	}

	.format-card.active {
		border-color: #f59e0b;
		background: rgba(245, 158, 11, 0.1);
	}

	.format-label {
		font-size: 13px;
		font-weight: 600;
	}

	.format-desc {
		font-size: 10px;
		color: #64748b;
	}

	.include-options {
		display: flex;
		flex-wrap: wrap;
		gap: 8px;
	}

	.include-options label {
		display: flex;
		align-items: center;
		gap: 4px;
		font-size: 12px;
		color: #e2e8f0;
		cursor: pointer;
	}

	.btn-export {
		padding: 8px;
		border: none;
		border-radius: 6px;
		background: linear-gradient(135deg, #22c55e, #16a34a);
		color: white;
		font-size: 13px;
		font-weight: 600;
		cursor: pointer;
	}

	.btn-export:hover:not(:disabled) {
		filter: brightness(1.1);
	}

	.btn-export:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}
</style>
