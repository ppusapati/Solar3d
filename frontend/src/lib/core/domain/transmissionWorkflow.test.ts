import { describe, expect, it } from 'vitest';

import type { TransmissionRoute } from '$lib/core/api/transmission';
import type { WorkflowTransitionRecord } from '$lib/core/api/workflow';

import {
	gateTransmissionApprovalAction,
	gateTransmissionReviewAction,
	transmissionWorkflowTransitions
} from './transmissionWorkflow';

function routeFixture(overrides: Partial<TransmissionRoute> = {}): TransmissionRoute {
	return {
		id: 'route-1',
		project_id: 'project-1',
		name: 'Route 1',
		voltage_class: '132kv',
		path_geojson: '{}',
		farm_output_point: { longitude: 1, latitude: 1, elevation: 0 },
		grid_injection_point: { longitude: 2, latitude: 2, elevation: 0 },
		tower_positions: [{ longitude: 1, latitude: 1, elevation: 0, span_to_next_m: 250, height_m: 30 }],
		distance_m: 1000,
		cost_breakdown: {
			conductor_cost: 1,
			tower_cost: 1,
			row_acquisition_cost: 1,
			crossing_premium: 1,
			total_cost: 4,
			cost_per_km: 4
		},
		approval_status: 'draft',
		engineering_reviewed_at: '',
		engineering_reviewed_by: '',
		approved_at: '',
		approved_by: '',
		governance_events: [],
		segment_explanations: [
			{
				from_index: 0,
				slope_deg: 1,
				land_type: 'road',
				cost_multiplier: 1,
				decision_reason: 'ok',
				installation_mode: 'overhead'
			}
		],
		route_summary: 'summary',
		created_at: '2026-01-01T00:00:00Z',
		...overrides
	};
}

describe('transmission workflow gating helpers', () => {
	it('blocks review when workflow is not yet electrical ready', () => {
		const gate = gateTransmissionReviewAction(routeFixture(), 'LAYOUT_READY', []);
		expect(gate.allowed).toBe(false);
		expect(gate.reason).toContain('Electrical Ready');
	});

	it('allows approval only from engineering review at transmission-ready phase', () => {
		const gate = gateTransmissionApprovalAction(
			routeFixture({ approval_status: 'engineering_review' }),
			'TRANSMISSION_READY',
			[]
		);
		expect(gate.allowed).toBe(true);
	});

	it('filters workflow transitions to transmission handoff chain', () => {
		const transitions: WorkflowTransitionRecord[] = [
			{
				id: '1',
				project_id: 'project-1',
				from_phase: 'ELECTRICAL_READY',
				to_phase: 'TRANSMISSION_READY',
				occurred_at: '2026-01-01T00:00:00Z',
				actor_id: 'u1',
				reason: '',
				is_rollback: false,
				rollback_reason: ''
			},
			{
				id: '2',
				project_id: 'project-1',
				from_phase: 'TRANSMISSION_READY',
				to_phase: 'REVIEW_READY',
				occurred_at: '2026-01-02T00:00:00Z',
				actor_id: 'u2',
				reason: '',
				is_rollback: false,
				rollback_reason: ''
			},
			{
				id: '3',
				project_id: 'project-1',
				from_phase: 'PLANNING',
				to_phase: 'LAYOUT_READY',
				occurred_at: '2026-01-03T00:00:00Z',
				actor_id: 'u3',
				reason: '',
				is_rollback: false,
				rollback_reason: ''
			}
		];

		const filtered = transmissionWorkflowTransitions(transitions);
		expect(filtered).toHaveLength(2);
		expect(filtered[0].id).toBe('2');
	});
});
