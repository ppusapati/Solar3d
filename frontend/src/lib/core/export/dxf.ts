/**
 * DXF export for solar farm layouts.
 * Generates AutoCAD-compatible DXF files from panel geometry and components.
 */

interface DxfEntity {
	type: 'LWPOLYLINE' | 'TEXT' | 'CIRCLE' | 'LINE';
	layer: string;
	color?: number;
	points?: [number, number][];
	text?: string;
	position?: [number, number];
	height?: number;
	radius?: number;
}

export function generateDxf(
	panels: { geometry_geojson: string; tilt: number; azimuth: number; string_id: string }[],
	components: { component_type: string; position: { longitude: number; latitude: number } }[],
	boundary?: { type: string; coordinates: number[][][] },
	routes?: { route_type: string; waypoints: { longitude: number; latitude: number }[] }[]
): string {
	const entities: DxfEntity[] = [];

	// Site boundary
	if (boundary && boundary.coordinates?.[0]) {
		entities.push({
			type: 'LWPOLYLINE',
			layer: 'BOUNDARY',
			color: 1, // red
			points: boundary.coordinates[0].map((c) => [c[0], c[1]] as [number, number])
		});
	}

	// Panels
	for (const panel of panels) {
		try {
			const geojson = JSON.parse(panel.geometry_geojson);
			if (geojson.coordinates?.[0]) {
				entities.push({
					type: 'LWPOLYLINE',
					layer: `PANELS_STRING_${panel.string_id || 'UNASSIGNED'}`,
					color: 5, // blue
					points: geojson.coordinates[0].map((c: number[]) => [c[0], c[1]] as [number, number])
				});
			}
		} catch (err) {
			console.warn('Skipping panel with invalid GeoJSON:', err);
		}
	}

	// Components
	for (const comp of components) {
		const layerMap: Record<string, number> = {
			inverter: 3,      // green
			transformer: 6,   // magenta
			combiner_box: 2,  // yellow
			meter: 4,         // cyan
		};
		entities.push({
			type: 'CIRCLE',
			layer: `EQUIPMENT_${comp.component_type.toUpperCase()}`,
			color: layerMap[comp.component_type] || 7,
			position: [comp.position.longitude, comp.position.latitude],
			radius: 0.00005 // ~5m in degrees
		});
		entities.push({
			type: 'TEXT',
			layer: `EQUIPMENT_${comp.component_type.toUpperCase()}`,
			color: layerMap[comp.component_type] || 7,
			position: [comp.position.longitude, comp.position.latitude + 0.00006],
			text: comp.component_type.toUpperCase(),
			height: 0.00003
		});
	}

	// Routes
	if (routes) {
		for (const route of routes) {
			const colorMap: Record<string, number> = { cable: 1, road: 8, fence: 3 };
			entities.push({
				type: 'LWPOLYLINE',
				layer: `ROUTE_${route.route_type.toUpperCase()}`,
				color: colorMap[route.route_type] || 7,
				points: route.waypoints.map((wp) => [wp.longitude, wp.latitude] as [number, number])
			});
		}
	}

	return buildDxfString(entities);
}

function buildDxfString(entities: DxfEntity[]): string {
	const lines: string[] = [];

	// Header
	lines.push('0', 'SECTION', '2', 'HEADER');
	lines.push('9', '$ACADVER', '1', 'AC1027'); // AutoCAD 2013
	lines.push('9', '$INSUNITS', '70', '6'); // meters
	lines.push('0', 'ENDSEC');

	// Tables (layers)
	lines.push('0', 'SECTION', '2', 'TABLES');
	lines.push('0', 'TABLE', '2', 'LAYER', '70', '0');

	const layerSet = new Set(entities.map((e) => e.layer));
	for (const layer of layerSet) {
		lines.push('0', 'LAYER');
		lines.push('2', layer);
		lines.push('70', '0');
		lines.push('62', '7'); // white by default
		lines.push('6', 'Continuous');
	}
	lines.push('0', 'ENDTAB');
	lines.push('0', 'ENDSEC');

	// Entities
	lines.push('0', 'SECTION', '2', 'ENTITIES');

	for (const entity of entities) {
		if (entity.type === 'LWPOLYLINE' && entity.points) {
			lines.push('0', 'LWPOLYLINE');
			lines.push('8', entity.layer);
			lines.push('62', String(entity.color || 7));
			lines.push('90', String(entity.points.length));
			lines.push('70', '1'); // closed
			for (const pt of entity.points) {
				lines.push('10', String(pt[0]), '20', String(pt[1]));
			}
		} else if (entity.type === 'CIRCLE' && entity.position) {
			lines.push('0', 'CIRCLE');
			lines.push('8', entity.layer);
			lines.push('62', String(entity.color || 7));
			lines.push('10', String(entity.position[0]));
			lines.push('20', String(entity.position[1]));
			lines.push('40', String(entity.radius || 0.00005));
		} else if (entity.type === 'TEXT' && entity.position && entity.text) {
			lines.push('0', 'TEXT');
			lines.push('8', entity.layer);
			lines.push('62', String(entity.color || 7));
			lines.push('10', String(entity.position[0]));
			lines.push('20', String(entity.position[1]));
			lines.push('40', String(entity.height || 0.00003));
			lines.push('1', entity.text);
		} else if (entity.type === 'LINE' && entity.points && entity.points.length >= 2) {
			lines.push('0', 'LINE');
			lines.push('8', entity.layer);
			lines.push('62', String(entity.color || 7));
			lines.push('10', String(entity.points[0][0]));
			lines.push('20', String(entity.points[0][1]));
			lines.push('11', String(entity.points[1][0]));
			lines.push('21', String(entity.points[1][1]));
		}
	}

	lines.push('0', 'ENDSEC');
	lines.push('0', 'EOF');

	return lines.join('\n');
}

/**
 * Generate KML for Google Earth visualization.
 */
export function generateKml(
	projectName: string,
	panels: { geometry_geojson: string; tilt: number }[],
	components: { component_type: string; position: { longitude: number; latitude: number } }[],
	boundary?: { type: string; coordinates: number[][][] }
): string {
	const kml: string[] = [];
	kml.push('<?xml version="1.0" encoding="UTF-8"?>');
	kml.push('<kml xmlns="http://www.opengis.net/kml/2.2">');
	kml.push('<Document>');
	kml.push(`<name>${escapeXml(projectName)}</name>`);

	// Styles
	kml.push('<Style id="boundary"><LineStyle><color>ff00ffff</color><width>3</width></LineStyle><PolyStyle><color>2200ffff</color></PolyStyle></Style>');
	kml.push('<Style id="panel"><LineStyle><color>ffff6600</color><width>1</width></LineStyle><PolyStyle><color>44ff6600</color></PolyStyle></Style>');
	kml.push('<Style id="inverter"><IconStyle><color>ff0000ff</color><scale>1.2</scale></IconStyle></Style>');
	kml.push('<Style id="transformer"><IconStyle><color>ffff00ff</color><scale>1.2</scale></IconStyle></Style>');

	// Boundary
	if (boundary?.coordinates?.[0]) {
		kml.push('<Folder><name>Site Boundary</name>');
		kml.push('<Placemark><name>Boundary</name><styleUrl>#boundary</styleUrl>');
		kml.push('<Polygon><outerBoundaryIs><LinearRing><coordinates>');
		kml.push(boundary.coordinates[0].map((c) => `${c[0]},${c[1]},0`).join(' '));
		kml.push('</coordinates></LinearRing></outerBoundaryIs></Polygon>');
		kml.push('</Placemark></Folder>');
	}

	// Panels
	kml.push('<Folder><name>Solar Panels</name>');
	for (let i = 0; i < panels.length; i++) {
		try {
			const geojson = JSON.parse(panels[i].geometry_geojson);
			if (!geojson.coordinates?.[0]) continue;
			kml.push(`<Placemark><name>Panel ${i + 1}</name><styleUrl>#panel</styleUrl>`);
			kml.push('<Polygon><outerBoundaryIs><LinearRing><coordinates>');
			kml.push(geojson.coordinates[0].map((c: number[]) => `${c[0]},${c[1]},0`).join(' '));
			kml.push('</coordinates></LinearRing></outerBoundaryIs></Polygon>');
			kml.push('</Placemark>');
		} catch (err) {
			console.warn('Skipping entry with invalid GeoJSON:', err);
		}
	}
	kml.push('</Folder>');

	// Components
	kml.push('<Folder><name>Equipment</name>');
	for (const comp of components) {
		kml.push(`<Placemark><name>${escapeXml(comp.component_type)}</name>`);
		kml.push(`<styleUrl>#${comp.component_type}</styleUrl>`);
		kml.push(`<Point><coordinates>${comp.position.longitude},${comp.position.latitude},0</coordinates></Point>`);
		kml.push('</Placemark>');
	}
	kml.push('</Folder>');

	kml.push('</Document></kml>');
	return kml.join('\n');
}

function escapeXml(str: string): string {
	return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

/**
 * Generate GeoJSON export of the full layout.
 */
export function generateGeoJson(
	panels: { geometry_geojson: string; tilt: number; azimuth: number; string_id: string }[],
	components: { component_type: string; position: { longitude: number; latitude: number } }[],
	boundary?: { type: string; coordinates: number[][][] }
): string {
	const features: any[] = [];

	if (boundary) {
		features.push({
			type: 'Feature',
			properties: { layer: 'boundary' },
			geometry: boundary
		});
	}

	for (const panel of panels) {
		try {
			features.push({
				type: 'Feature',
				properties: {
					layer: 'panel',
					tilt: panel.tilt,
					azimuth: panel.azimuth,
					string_id: panel.string_id
				},
				geometry: JSON.parse(panel.geometry_geojson)
			});
		} catch (err) {
			console.warn('Skipping entry with invalid GeoJSON:', err);
		}
	}

	for (const comp of components) {
		features.push({
			type: 'Feature',
			properties: {
				layer: 'equipment',
				type: comp.component_type
			},
			geometry: {
				type: 'Point',
				coordinates: [comp.position.longitude, comp.position.latitude]
			}
		});
	}

	return JSON.stringify({ type: 'FeatureCollection', features }, null, 2);
}
