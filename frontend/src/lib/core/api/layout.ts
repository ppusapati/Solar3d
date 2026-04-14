import { createClient } from '@connectrpc/connect';
import { createConnectTransport } from '@connectrpc/connect-web';
import {
	ComponentType,
	LayoutService,
	type Component as ProtoComponent,
	type Layout as ProtoLayout,
	type LayoutTile as ProtoLayoutTile,
	type Panel as ProtoPanel
} from '$lib/gen/layout/v1/layout_pb.js';

import { timestampToIso } from './connect';
import { API_BASE, api } from './client';

export interface Layout {
	id: string;
	project_id: string;
	name: string;
	total_panels: number;
	total_capacity_kw: number;
	tile_count: number;
	created_at: string;
	updated_at: string;
}

export interface LayoutTile {
	id: string;
	layout_id: string;
	bbox: BoundingBox;
	lod_level: number;
	panel_count: number;
	metadata_json: string;
}

export interface Panel {
	id: string;
	tile_id: string;
	string_id: string;
	geometry_geojson: string;
	tilt: number;
	azimuth: number;
	elevation: number;
}

export interface BoundingBox {
	min_x: number;
	min_y: number;
	max_x: number;
	max_y: number;
}

export interface PanelArrayParams {
	panel_width: number;
	panel_height: number;
	tilt_angle: number;
	azimuth: number;
	row_spacing: number;
	column_spacing: number;
	panel_asset_id?: string;
	panel_model?: string;
	panel_rated_power_w?: number;
	fill_area_geojson: string;
	terrain_layer_id?: string;
}

function isUuidLike(value: string | undefined): boolean {
	if (!value) return false;
	return /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(value);
}

function finiteOr(value: number, fallback: number): number {
	return Number.isFinite(value) ? value : fallback;
}

export interface Component {
	id: string;
	layout_id: string;
	asset_id: string;
	component_type: string;
	position: { longitude: number; latitude: number; elevation: number };
	rotation: number;
	metadata_json: string;
}

export interface ZoneAllocation {
	zone_type: string;
	target_area_sqm: number;
	planned_area_sqm: number;
	coverage_percent: number;
	geometry_geojson: string;
	design_description: string;
}

export interface ZonePlanResult {
	layout_id: string;
	boundary_area_sqm: number;
	target_capacity_mw: number;
	estimated_dc_mw: number;
	recommended_ac_mw: number;
	zones: ZoneAllocation[];
	assumptions: string[];
}

const LAYOUT_API_BASE =
	import.meta.env.VITE_LAYOUT_API_BASE_URL ||
	(API_BASE.endsWith(':8080') ? API_BASE.replace(':8080', ':8082') : API_BASE);

const transport = createConnectTransport({
	baseUrl: LAYOUT_API_BASE
});

const client = createClient(LayoutService, transport);

function componentTypeFromProto(componentType: ComponentType): string {
	switch (componentType) {
		case ComponentType.PANEL:
			return 'panel';
		case ComponentType.INVERTER:
			return 'inverter';
		case ComponentType.TRANSFORMER:
			return 'transformer';
		case ComponentType.TRACKER:
			return 'tracker';
		case ComponentType.SUBSTATION:
			return 'substation';
		case ComponentType.COMBINER_BOX:
			return 'combiner_box';
		case ComponentType.JUNCTION_BOX:
			return 'combiner_box';
		default:
			return 'panel';
	}
}

function componentTypeToProto(componentType?: string): ComponentType {
	switch (componentType) {
		case 'panel':
			return ComponentType.PANEL;
		case 'inverter':
			return ComponentType.INVERTER;
		case 'transformer':
			return ComponentType.TRANSFORMER;
		case 'tracker':
			return ComponentType.TRACKER;
		case 'substation':
			return ComponentType.SUBSTATION;
		case 'combiner_box':
		case 'junction_box':
			return ComponentType.COMBINER_BOX;
		default:
			return ComponentType.UNSPECIFIED;
	}
}

function mapLayout(layout?: ProtoLayout): Layout {
	if (!layout) {
		throw new Error('Layout response was empty');
	}

	return {
		id: layout.id,
		project_id: layout.projectId,
		name: layout.name,
		total_panels: layout.totalPanels,
		total_capacity_kw: layout.totalCapacityKw,
		tile_count: layout.tileCount,
		created_at: timestampToIso(layout.createdAt),
		updated_at: timestampToIso(layout.updatedAt)
	};
}

function mapTile(tile?: ProtoLayoutTile): LayoutTile {
	if (!tile) {
		throw new Error('Layout tile response was empty');
	}

	return {
		id: tile.id,
		layout_id: tile.layoutId,
		bbox: {
			min_x: tile.bbox?.minX ?? 0,
			min_y: tile.bbox?.minY ?? 0,
			max_x: tile.bbox?.maxX ?? 0,
			max_y: tile.bbox?.maxY ?? 0
		},
		lod_level: tile.lodLevel,
		panel_count: tile.panelCount,
		metadata_json: tile.metadataJson
	};
}

function mapPanel(panel?: ProtoPanel): Panel {
	if (!panel) {
		throw new Error('Panel response was empty');
	}

	return {
		id: panel.id,
		tile_id: panel.tileId,
		string_id: panel.stringId,
		geometry_geojson: panel.geometryGeojson,
		tilt: panel.tilt,
		azimuth: panel.azimuth,
		elevation: panel.elevation
	};
}

function mapComponent(component?: ProtoComponent): Component {
	if (!component) {
		throw new Error('Component response was empty');
	}

	return {
		id: component.id,
		layout_id: component.layoutId,
		asset_id: component.assetId,
		component_type: componentTypeFromProto(component.componentType),
		position: {
			longitude: component.position?.longitude ?? 0,
			latitude: component.position?.latitude ?? 0,
			elevation: component.position?.elevation ?? 0
		},
		rotation: component.rotation,
		metadata_json: component.metadataJson
	};
}

function parsePolygonCoordinates(fillAreaGeojson: string): [number, number][] | null {
	try {
		const parsed = JSON.parse(fillAreaGeojson) as {
			type?: string;
			coordinates?: number[][][];
		};
		if (parsed.type !== 'Polygon' || !parsed.coordinates?.[0]?.length) return null;
		return parsed.coordinates[0].map((c) => [Number(c[0]), Number(c[1])]);
	} catch {
		return null;
	}
}

function isLikelyLonLat(coords: [number, number][]): boolean {
	if (coords.length === 0) return false;
	return coords.every(([lon, lat]) => Math.abs(lon) <= 180 && Math.abs(lat) <= 90);
}

function centroidLatitude(coords: [number, number][]): number {
	const sum = coords.reduce((acc, [, lat]) => acc + lat, 0);
	return sum / coords.length;
}

function meterToDegreeScale(meters: number, latDeg: number): number {
	const degPerMeterLat = 1 / 111320;
	const cosLat = Math.max(0.1, Math.cos((latDeg * Math.PI) / 180));
	const degPerMeterLon = 1 / (111320 * cosLat);

	// Use isotropic average to keep dimensions consistent in lon/lat plane.
	const degPerMeter = (degPerMeterLat + degPerMeterLon) / 2;
	return meters * degPerMeter;
}

function normalizeGenerationParams(params: PanelArrayParams): PanelArrayParams {
	const coords = parsePolygonCoordinates(params.fill_area_geojson);
	if (!coords || !isLikelyLonLat(coords)) return params;

	const lat = centroidLatitude(coords);

	// The backend uses row_spacing and column_spacing as the full centre-to-centre
	// pitch for the grid sweep, not as the inter-panel gap.
	// Convert: pitch = panel_dimension + gap, then to degrees.
	const colPitchDeg = meterToDegreeScale(params.panel_width + params.column_spacing, lat);
	// When row_spacing is 0 the backend auto-computes it from tilt; keep it 0 so
	// that logic fires.  Otherwise send the full row pitch (panel height + gap).
	const rowPitchDeg = params.row_spacing > 0
		? meterToDegreeScale(params.panel_height + params.row_spacing, lat)
		: 0;

	return {
		...params,
		panel_width: meterToDegreeScale(params.panel_width, lat),
		panel_height: meterToDegreeScale(params.panel_height, lat),
		row_spacing: rowPitchDeg,
		column_spacing: colPitchDeg
	};
}

export const layoutApi = {
	create: async (projectId: string, name: string) => {
		const response = await client.createLayout({ projectId, name });
		return { layout: mapLayout(response.layout) };
	},

	get: async (id: string) => {
		const response = await client.getLayout({ id });
		return { layout: mapLayout(response.layout) };
	},

	list: async (projectId: string) => {
		const response = await client.listLayouts({ projectId });
		return { layouts: response.layouts.map(mapLayout) };
	},

	delete: async (id: string) => {
		await client.deleteLayout({ id });
		return {};
	},

	generatePanelArray: async (layoutId: string, params: PanelArrayParams) => {
		const normalized = normalizeGenerationParams(params);
		let fillAreaPayload: unknown = normalized.fill_area_geojson;
		try {
			fillAreaPayload = JSON.parse(normalized.fill_area_geojson);
		} catch {
			fillAreaPayload = normalized.fill_area_geojson;
		}
		const body: Record<string, unknown> = {
			panel_width: finiteOr(normalized.panel_width, 0),
			panel_height: finiteOr(normalized.panel_height, 0),
			tilt_angle: finiteOr(normalized.tilt_angle, 20),
			azimuth: finiteOr(normalized.azimuth, 180),
			row_spacing: finiteOr(normalized.row_spacing, 0),
			column_spacing: finiteOr(normalized.column_spacing, 0),
			fill_area_geojson: fillAreaPayload
		};

		if (normalized.panel_asset_id && normalized.panel_asset_id.trim().length > 0) {
			body.panel_asset_id = normalized.panel_asset_id;
		}
		if (normalized.panel_model && normalized.panel_model.trim().length > 0) {
			body.panel_model = normalized.panel_model;
		}
		if ((normalized.panel_rated_power_w ?? 0) > 0) {
			body.panel_rated_power_w = normalized.panel_rated_power_w;
		}
		if (isUuidLike(normalized.terrain_layer_id)) {
			body.terrain_layer_id = normalized.terrain_layer_id;
		}

		const response = await api.post<{
			total_panels: number;
			tile_count: number;
			total_capacity_kw: number;
		}>(`/api/v1/layouts/${layoutId}/generate-array`, body);

		return {
			panels_created: response.total_panels,
			tiles_created: response.tile_count,
			capacity_kw: response.total_capacity_kw
		};
	},

	planZones: async (layoutId: string, boundaryGeojson: string, targetCapacityMw: number) => {
		return api.post<ZonePlanResult>(`/api/v1/layouts/${layoutId}/plan-zones`, {
			boundary_geojson: boundaryGeojson,
			target_capacity_mw: targetCapacityMw
		});
	},

	getTiles: async (layoutId: string, viewport: BoundingBox, lodLevel: number) => {
		const response = await client.getTiles({
			layoutId,
			viewport: {
				minX: viewport.min_x,
				minY: viewport.min_y,
				maxX: viewport.max_x,
				maxY: viewport.max_y
			},
			lodLevel
		});

		return { tiles: response.tiles.map(mapTile) };
	},

	getTilePanels: async (tileId: string) => {
		const response = await client.getTilePanels({ tileId });
		return { panels: response.panels.map(mapPanel) };
	},

	placeComponent: async (layoutId: string, component: Partial<Component>) => {
		const response = await client.placeComponent({
			layoutId,
			assetId: component.asset_id ?? '',
			componentType: componentTypeToProto(component.component_type),
			position: {
				longitude: component.position?.longitude ?? 0,
				latitude: component.position?.latitude ?? 0,
				elevation: component.position?.elevation ?? 0
			},
			rotation: component.rotation ?? 0,
			metadataJson: component.metadata_json ?? ''
		});

		return { component: mapComponent(response.component) };
	},

	moveComponent: async (componentId: string, position: { longitude: number; latitude: number; elevation: number }, rotation = 0) => {
		const response = await client.moveComponent({
			componentId,
			position,
			rotation
		});
		return { component: mapComponent(response.component) };
	},

	removeComponent: async (componentId: string) => {
		await client.removeComponent({ componentId });
		return {};
	},

	listComponents: async (layoutId: string) => {
		const response = await client.listComponents({ layoutId });
		return { components: response.components.map(mapComponent) };
	}
};
