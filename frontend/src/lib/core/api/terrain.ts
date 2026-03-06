import { api } from './client';

export interface TerrainLayer {
	id: string;
	project_id: string;
	name: string;
	layer_type: string;
	source_file: string;
	bounds: {
		min_x: number;
		min_y: number;
		max_x: number;
		max_y: number;
	};
	resolution_m: number;
	crs: string;
	min_elevation: number;
	max_elevation: number;
	created_at: string;
}

export interface ElevationGrid {
	width: number;
	height: number;
	elevations: number[];
	min_elevation: number;
	max_elevation: number;
}

export const terrainApi = {
	upload: (projectId: string, name: string, filePath: string) =>
		api.post<{ layer: TerrainLayer }>('/api/v1/terrain/upload', {
			project_id: projectId,
			name,
			file_path: filePath
		}),

	get: (id: string) => api.get<{ layer: TerrainLayer }>(`/api/v1/terrain/${id}`),

	list: (projectId: string) =>
		api.get<{ layers: TerrainLayer[] }>(`/api/v1/terrain?project_id=${projectId}`),

	getElevation: (projectId: string, lon: number, lat: number) =>
		api.get<{ elevation: number }>(
			`/api/v1/terrain/elevation?project_id=${projectId}&longitude=${lon}&latitude=${lat}`
		),

	getElevationGrid: (
		projectId: string,
		bounds: { min_x: number; min_y: number; max_x: number; max_y: number },
		resolution: number
	) =>
		api.get<ElevationGrid>(
			`/api/v1/terrain/elevation-grid?project_id=${projectId}&min_x=${bounds.min_x}&min_y=${bounds.min_y}&max_x=${bounds.max_x}&max_y=${bounds.max_y}&resolution=${resolution}`
		),

	computeSlope: (terrainLayerId: string) =>
		api.post<{ slope_layer: TerrainLayer }>(`/api/v1/terrain/${terrainLayerId}/slope`, {}),

	computeAspect: (terrainLayerId: string) =>
		api.post<{ aspect_layer: TerrainLayer }>(`/api/v1/terrain/${terrainLayerId}/aspect`, {}),

	delete: (id: string) => api.delete(`/api/v1/terrain/${id}`)
};
