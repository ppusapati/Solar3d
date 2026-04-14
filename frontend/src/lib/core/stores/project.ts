import { writable, derived } from 'svelte/store';
import type { Project } from '../api';
import { projectsApi } from '../api';

type CreateProjectInput = {
	name: string;
	description?: string;
	target_capacity_mw?: number;
	location_name?: string;
	client_name?: string;
	notes?: string;
	initial_latitude?: number;
	initial_longitude?: number;
};

export const projects = writable<Project[]>([]);
export const activeProjectId = writable<string | null>(null);
export const isLoading = writable(false);
export const loadError = writable<string | null>(null);

export const activeProject = derived(
	[projects, activeProjectId],
	([$projects, $activeProjectId]) => {
		if (!$activeProjectId) return null;
		return $projects.find((p) => p.id === $activeProjectId) ?? null;
	}
);

export async function loadProjects() {
	isLoading.set(true);
	loadError.set(null);
	try {
		const response = await projectsApi.list();
		projects.set(response.projects || []);
	} catch (err) {
		const message = err instanceof Error ? err.message : 'Failed to load projects';
		loadError.set(message);
		console.error('loadProjects failed:', err);
	} finally {
		isLoading.set(false);
	}
}

export async function createProject(input: CreateProjectInput) {
	const response = await projectsApi.create(input);
	projects.update((p) => [...p, response.project]);
	activeProjectId.set(response.project.id);
	return response.project;
}

export async function deleteProject(id: string) {
	await projectsApi.delete(id);
	projects.update((p) => p.filter((proj) => proj.id !== id));
	activeProjectId.update((current) => (current === id ? null : current));
}

export async function updateProject(id: string, data: Partial<Project>) {
	const response = await projectsApi.update(id, data);
	projects.update((items) => items.map((p) => (p.id === id ? response.project : p)));
	return response.project;
}
