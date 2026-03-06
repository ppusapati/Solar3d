import { writable } from 'svelte/store';

export interface CameraState {
	longitude: number;
	latitude: number;
	height: number;
	heading: number;
	pitch: number;
	roll: number;
}

export interface ViewportBounds {
	west: number;
	south: number;
	east: number;
	north: number;
}

export type MapTool =
	| 'select'
	| 'pan'
	| 'draw-boundary'
	| 'place-component'
	| 'draw-area'
	| 'measure';

export const camera = writable<CameraState>({
	longitude: -120.0,
	latitude: 35.0,
	height: 5000,
	heading: 0,
	pitch: -45,
	roll: 0
});

export const viewport = writable<ViewportBounds>({
	west: -121,
	south: 34,
	east: -119,
	north: 36
});

export const activeTool = writable<MapTool>('select');
export const selectedEntityId = writable<string | null>(null);
export const isMapReady = writable(false);
