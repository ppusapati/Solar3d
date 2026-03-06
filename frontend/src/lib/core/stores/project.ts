import { writable, derived } from 'svelte/store';
import type { Project } from '../api';
import { projectsApi } from '../api';

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

export async function createProject(name: string, description?: string) {
	const response = await projectsApi.create({ name, description });
	projects.update((p) => [...p, response.project]);
	activeProjectId.set(response.project.id);
	return response.project;
}

export async function deleteProject(id: string) {
	await projectsApi.delete(id);
	projects.update((p) => p.filter((proj) => proj.id !== id));
	activeProjectId.update((current) => (current === id ? null : current));
}
