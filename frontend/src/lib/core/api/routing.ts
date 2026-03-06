import { api } from './client';

export interface Route {
	id: string;
	project_id: string;
	layout_id: string;
	name: string;
	route_type: string;
	waypoints: Waypoint[];
	distance_m: number;
	cost_estimate: number;
	geojson: string;
	created_at: string;
}

export interface Waypoint {
	longitude: number;
	latitude: number;
	elevation: number;
}

export interface RouteConstraints {
	max_slope_percent: number;
	avoid_water: boolean;
	avoidance_zones_geojson: string[];
	slope_penalty: number;
}

export const routingApi = {
	create: (data: {
		project_id: string;
		layout_id: string;
		name: string;
		route_type: string;
		start: Waypoint;
		end: Waypoint;
		constraints?: RouteConstraints;
	}) => api.post<{ route: Route }>('/api/v1/routes', data),

	get: (id: string) => api.get<{ route: Route }>(`/api/v1/routes/${id}`),

	list: (projectId: string) =>
		api.get<{ routes: Route[] }>(`/api/v1/routes?project_id=${projectId}`),

	optimize: (projectId: string) =>
		api.post<{ routes: Route[] }>(`/api/v1/routes/optimize`, { project_id: projectId }),

	delete: (id: string) => api.delete(`/api/v1/routes/${id}`)
};
