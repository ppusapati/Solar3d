import { api } from './client';

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
	fill_area_geojson: string;
	terrain_layer_id?: string;
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

export const layoutApi = {
	create: (projectId: string, name: string) =>
		api.post<{ layout: Layout }>('/api/v1/layouts', { project_id: projectId, name }),

	get: (id: string) => api.get<{ layout: Layout }>(`/api/v1/layouts/${id}`),

	list: (projectId: string) =>
		api.get<{ layouts: Layout[] }>(`/api/v1/layouts?project_id=${projectId}`),

	delete: (id: string) => api.delete(`/api/v1/layouts/${id}`),

	generatePanelArray: (layoutId: string, params: PanelArrayParams) =>
		api.post<{ panels_created: number; tiles_created: number; capacity_kw: number }>(
			`/api/v1/layouts/${layoutId}/generate-array`,
			params
		),

	getTiles: (layoutId: string, viewport: BoundingBox, lodLevel: number) =>
		api.get<{ tiles: LayoutTile[] }>(
			`/api/v1/layouts/${layoutId}/tiles?min_x=${viewport.min_x}&min_y=${viewport.min_y}&max_x=${viewport.max_x}&max_y=${viewport.max_y}&lod_level=${lodLevel}`
		),

	getTilePanels: (tileId: string) =>
		api.get<{ panels: Panel[] }>(`/api/v1/tiles/${tileId}/panels`),

	placeComponent: (layoutId: string, component: Partial<Component>) =>
		api.post<{ component: Component }>(`/api/v1/layouts/${layoutId}/components`, component),

	listComponents: (layoutId: string) =>
		api.get<{ components: Component[] }>(`/api/v1/layouts/${layoutId}/components`)
};
