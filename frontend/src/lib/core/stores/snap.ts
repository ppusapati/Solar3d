import { writable } from 'svelte/store';

export const snapEnabled = writable(true);
export const snapGridVisible = writable(false);
export const snapGridSizeM = writable(5);
export const snapDistanceM = writable(2);
