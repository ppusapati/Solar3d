import { writable, derived } from 'svelte/store';
import type { Layout, LayoutTile, Component } from '../api';
import { layoutApi } from '../api';

export const layouts = writable<Layout[]>([]);
export const activeLayoutId = writable<string | null>(null);
export const visibleTiles = writable<LayoutTile[]>([]);
export const components = writable<Component[]>([]);
export const isGenerating = writable(false);

export const activeLayout = derived([layouts, activeLayoutId], ([$layouts, $activeLayoutId]) => {
	if (!$activeLayoutId) return null;
	return $layouts.find((l) => l.id === $activeLayoutId) ?? null;
});

export async function loadLayouts(projectId: string) {
	const response = await layoutApi.list(projectId);
	layouts.set(response.layouts || []);
}

export async function createLayout(projectId: string, name: string) {
	const response = await layoutApi.create(projectId, name);
	layouts.update((l) => [...l, response.layout]);
	activeLayoutId.set(response.layout.id);
	return response.layout;
}

export async function loadTilesForViewport(
	layoutId: string,
	minX: number,
	minY: number,
	maxX: number,
	maxY: number,
	lodLevel: number
) {
	const response = await layoutApi.getTiles(
		layoutId,
		{ min_x: minX, min_y: minY, max_x: maxX, max_y: maxY },
		lodLevel
	);
	visibleTiles.set(response.tiles || []);
}

export async function loadComponents(layoutId: string) {
	const response = await layoutApi.listComponents(layoutId);
	components.set(response.components || []);
}
