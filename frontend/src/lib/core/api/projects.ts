import { api } from './client';

export interface Project {
	id: string;
	name: string;
	description: string;
	status: string;
	target_capacity_mw: number;
	location_name: string;
	client_name: string;
	notes: string;
	created_at: string;
	updated_at: string;
}

export interface Site {
	id: string;
	project_id: string;
	name: string;
	boundary_geojson: string;
	area_sqm: number;
	latitude: number;
	longitude: number;
	timezone: string;
	created_at: string;
}

export interface CreateProjectRequest {
	name: string;
	description?: string;
	target_capacity_mw?: number;
	location_name?: string;
	client_name?: string;
}

export const projectsApi = {
	create: (req: CreateProjectRequest) => api.post<{ project: Project }>('/api/v1/projects', req),

	get: (id: string) => api.get<{ project: Project }>(`/api/v1/projects/${id}`),

	list: (pageSize = 20, pageToken = '') =>
		api.get<{ projects: Project[]; next_page_token: string; total_count: number }>(
			`/api/v1/projects?page_size=${pageSize}&page_token=${pageToken}`
		),

	update: (id: string, data: Partial<Project>) =>
		api.put<{ project: Project }>(`/api/v1/projects/${id}`, data),

	delete: (id: string) => api.delete(`/api/v1/projects/${id}`)
};
