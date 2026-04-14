import { derived, writable } from 'svelte/store';

import type { TransmissionRoute } from '$lib/core/api/transmission';

export const transmissionRoutes = writable<TransmissionRoute[]>([]);
export const activeTransmissionRouteId = writable<string | null>(null);

export const activeTransmissionRoute = derived(
	[transmissionRoutes, activeTransmissionRouteId],
	([$routes, $activeId]) => $routes.find((route) => route.id === $activeId) ?? null
);

export function setTransmissionRoutes(routes: TransmissionRoute[]) {
	transmissionRoutes.set(routes);
}

export function upsertTransmissionRoute(route: TransmissionRoute) {
	transmissionRoutes.update((routes) => {
		const existingIndex = routes.findIndex((entry) => entry.id === route.id);
		if (existingIndex < 0) {
			return [route, ...routes];
		}
		const next = [...routes];
		next[existingIndex] = route;
		return next;
	});
}

export function removeTransmissionRoute(id: string) {
	transmissionRoutes.update((routes) => routes.filter((route) => route.id !== id));
	activeTransmissionRouteId.update((activeId) => (activeId === id ? null : activeId));
}
