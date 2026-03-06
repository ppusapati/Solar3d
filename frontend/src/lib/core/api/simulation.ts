import { api } from './client';

export interface Simulation {
	id: string;
	project_id: string;
	layout_id: string;
	name: string;
	simulation_type: string;
	status: string;
	params: SimulationParams;
	result: SimulationResult | null;
	created_at: string;
	completed_at: string | null;
}

export interface SimulationParams {
	start_time: string;
	end_time: string;
	time_step_minutes: number;
	latitude: number;
	longitude: number;
	include_terrain_shading: boolean;
	include_panel_shading: boolean;
}

export interface SimulationResult {
	total_irradiance_kwh_m2: number;
	annual_yield_kwh: number;
	performance_ratio: number;
	shading_loss_percent: number;
	result_file_path: string;
}

export interface SunPosition {
	azimuth: number;
	elevation: number;
	zenith: number;
	hour_angle: number;
}

export interface ShadowPolygon {
	source_panel_id: string;
	shadow_geojson: string;
	shadow_intensity: number;
}

export const simulationApi = {
	create: (data: {
		project_id: string;
		layout_id: string;
		name: string;
		simulation_type: string;
		params: SimulationParams;
	}) => api.post<{ simulation: Simulation }>('/api/v1/simulations', data),

	get: (id: string) => api.get<{ simulation: Simulation }>(`/api/v1/simulations/${id}`),

	list: (projectId: string) =>
		api.get<{ simulations: Simulation[] }>(`/api/v1/simulations?project_id=${projectId}`),

	run: (id: string) => api.post<{ simulation: Simulation }>(`/api/v1/simulations/${id}/run`, {}),

	getSunPosition: (lat: number, lon: number, timestamp: string) =>
		api.get<{ position: SunPosition }>(
			`/api/v1/sun-position?latitude=${lat}&longitude=${lon}&timestamp=${timestamp}`
		),

	getShadowMap: (layoutId: string, timestamp: string, lat: number, lon: number) =>
		api.get<{ shadows: ShadowPolygon[]; sun_position: SunPosition }>(
			`/api/v1/shadows?layout_id=${layoutId}&timestamp=${timestamp}&latitude=${lat}&longitude=${lon}`
		),

	delete: (id: string) => api.delete(`/api/v1/simulations/${id}`)
};
