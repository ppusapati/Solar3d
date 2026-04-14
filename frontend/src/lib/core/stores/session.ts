import { writable } from 'svelte/store';

import type { UserRole } from '$lib/core/domain/workflowGuards';

const ROLE_KEY = 'solar3d:user-role';

function loadRole(): UserRole {
	if (typeof window === 'undefined') {
		return 'planner';
	}
	const raw = window.localStorage.getItem(ROLE_KEY);
	if (
		raw === 'planner' ||
		raw === 'engineer' ||
		raw === 'reviewer' ||
		raw === 'approver' ||
		raw === 'operator' ||
		raw === 'admin'
	) {
		return raw;
	}
	return 'planner';
}

export const userRole = writable<UserRole>(loadRole());

userRole.subscribe((role) => {
	if (typeof window === 'undefined') {
		return;
	}
	window.localStorage.setItem(ROLE_KEY, role);
});

export function setUserRole(role: UserRole) {
	userRole.set(role);
}
