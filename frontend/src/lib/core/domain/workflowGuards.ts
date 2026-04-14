import type { WorkflowPhase } from '$lib/core/api/workflow';
import type { AppView } from '$lib/core/stores/map';

export type UserRole = 'planner' | 'engineer' | 'reviewer' | 'approver' | 'operator' | 'admin';

export interface ViewGuard {
	enabled: boolean;
	reason: string;
}

const PHASE_ORDER: WorkflowPhase[] = [
	'UNSPECIFIED',
	'PLANNING',
	'LAYOUT_READY',
	'ELECTRICAL_READY',
	'TRANSMISSION_READY',
	'REVIEW_READY',
	'APPROVED',
	'COMMISSIONING_READY',
	'ARCHIVED'
];

const VIEW_PHASE_REQUIREMENT: Record<AppView, WorkflowPhase> = {
	design: 'PLANNING',
	cad: 'PLANNING',
	simulate: 'LAYOUT_READY',
	electrical: 'ELECTRICAL_READY',
	transmission: 'TRANSMISSION_READY',
	reports: 'REVIEW_READY',
	financial: 'REVIEW_READY',
	commissioning: 'APPROVED'
};

const VIEW_ROLE_REQUIREMENT: Record<AppView, UserRole[]> = {
	design: ['planner', 'engineer', 'admin'],
	cad: ['planner', 'engineer', 'admin'],
	simulate: ['planner', 'engineer', 'admin'],
	electrical: ['engineer', 'admin'],
	transmission: ['engineer', 'admin'],
	reports: ['reviewer', 'approver', 'admin'],
	financial: ['approver', 'admin'],
	commissioning: ['operator', 'approver', 'admin']
};

function phaseIndex(phase: WorkflowPhase): number {
	const index = PHASE_ORDER.indexOf(phase);
	return index >= 0 ? index : 0;
}

export function roleAllowsView(view: AppView, role: UserRole): boolean {
	return VIEW_ROLE_REQUIREMENT[view].includes(role);
}

export function phaseAllowsView(view: AppView, phase: WorkflowPhase): boolean {
	return phaseIndex(phase) >= phaseIndex(VIEW_PHASE_REQUIREMENT[view]);
}

export function buildWorkflowViewGuard(input: {
	view: AppView;
	phase: WorkflowPhase;
	role: UserRole;
	blockers: string[];
}): ViewGuard {
	if (input.blockers.length > 0) {
		return { enabled: false, reason: `Blocked: ${input.blockers[0]}` };
	}
	if (!roleAllowsView(input.view, input.role)) {
		return {
			enabled: false,
			reason: `Requires role ${VIEW_ROLE_REQUIREMENT[input.view].join(' or ')}.`
		};
	}
	if (!phaseAllowsView(input.view, input.phase)) {
		return {
			enabled: false,
			reason: `Requires ${VIEW_PHASE_REQUIREMENT[input.view].replaceAll('_', ' ')} phase.`
		};
	}
	return { enabled: true, reason: '' };
}
