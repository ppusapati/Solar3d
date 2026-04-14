import { describe, expect, it } from 'vitest';

import { buildWorkflowViewGuard, phaseAllowsView, roleAllowsView, type UserRole } from './workflowGuards';

describe('workflow guards', () => {
	it('blocks unauthorized role for transmission and allows engineer', () => {
		expect(roleAllowsView('transmission', 'planner')).toBe(false);
		expect(roleAllowsView('transmission', 'engineer')).toBe(true);
	});

	it('blocks reports before review phase and allows after review', () => {
		expect(phaseAllowsView('reports', 'TRANSMISSION_READY')).toBe(false);
		expect(phaseAllowsView('reports', 'REVIEW_READY')).toBe(true);
	});

	it('simulates e2e chain readiness across canonical phases', () => {
		const role: UserRole = 'admin';
		const blockers: string[] = [];

		const planningGuard = buildWorkflowViewGuard({ view: 'design', phase: 'PLANNING', role, blockers });
		const electricalGuardBefore = buildWorkflowViewGuard({
			view: 'electrical',
			phase: 'LAYOUT_READY',
			role,
			blockers
		});
		const electricalGuardAfter = buildWorkflowViewGuard({
			view: 'electrical',
			phase: 'ELECTRICAL_READY',
			role,
			blockers
		});
		const commissioningGuard = buildWorkflowViewGuard({
			view: 'commissioning',
			phase: 'APPROVED',
			role,
			blockers
		});

		expect(planningGuard.enabled).toBe(true);
		expect(electricalGuardBefore.enabled).toBe(false);
		expect(electricalGuardAfter.enabled).toBe(true);
		expect(commissioningGuard.enabled).toBe(true);
	});

	it('prioritizes workflow blockers over role/phase', () => {
		const guard = buildWorkflowViewGuard({
			view: 'design',
			phase: 'PLANNING',
			role: 'admin',
			blockers: ['upstream evidence missing']
		});
		expect(guard.enabled).toBe(false);
		expect(guard.reason).toContain('Blocked');
	});
});
