/**
 * Branded confirmation modal store. Replaces native window.confirm() so
 * destructive actions get consistent UX, are themable, and work inside
 * Cesium iframes / portals where the browser dialog is unreliable.
 *
 * Usage:
 *   const ok = await confirm({ title: 'Delete project?', danger: true });
 *   if (ok) { ... }
 *
 * The promise resolves true on confirm, false on cancel (including
 * dismissal by Esc / backdrop click).
 */
import { writable } from 'svelte/store';

export interface ConfirmRequest {
	id: string;
	title: string;
	body?: string;
	confirmLabel?: string;
	cancelLabel?: string;
	danger?: boolean;
	resolve: (ok: boolean) => void;
}

export const activeConfirm = writable<ConfirmRequest | null>(null);

let counter = 0;

export function confirm(opts: Omit<ConfirmRequest, 'id' | 'resolve'>): Promise<boolean> {
	return new Promise((resolve) => {
		const id = `confirm-${++counter}`;
		activeConfirm.set({ id, ...opts, resolve });
	});
}

export function resolveActiveConfirm(ok: boolean) {
	activeConfirm.update((current) => {
		if (current) current.resolve(ok);
		return null;
	});
}
