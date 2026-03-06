import { writable } from 'svelte/store';

export interface Toast {
	id: string;
	type: 'success' | 'error' | 'warning' | 'info';
	message: string;
	duration?: number;
}

export const toasts = writable<Toast[]>([]);

let counter = 0;

export function addToast(type: Toast['type'], message: string, duration = 4000) {
	const id = `toast-${++counter}`;
	const toast: Toast = { id, type, message, duration };

	toasts.update((t) => [...t, toast]);

	if (duration > 0) {
		setTimeout(() => removeToast(id), duration);
	}

	return id;
}

export function removeToast(id: string) {
	toasts.update((t) => t.filter((toast) => toast.id !== id));
}

// Convenience methods
export const toast = {
	success: (message: string, duration?: number) => addToast('success', message, duration),
	error: (message: string, duration?: number) => addToast('error', message, duration ?? 6000),
	warning: (message: string, duration?: number) => addToast('warning', message, duration),
	info: (message: string, duration?: number) => addToast('info', message, duration)
};
