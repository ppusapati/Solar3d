import type { WorkflowPhase, WorkflowTransitionRecord } from '$lib/core/api/workflow';
import type { TransmissionRoute } from '$lib/core/api/transmission';

interface RouteActionGate {
	allowed: boolean;
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

function phaseIndex(phase: WorkflowPhase): number {
	const index = PHASE_ORDER.indexOf(phase);
	return index >= 0 ? index : 0;
}

function hasTransmissionEvidence(route: TransmissionRoute): boolean {
	return route.segment_explanations.length > 0 && route.tower_positions.length > 0;
}

export function gateTransmissionReviewAction(
	route: TransmissionRoute,
	workflowPhase: WorkflowPhase,
	workflowBlockers: string[]
): RouteActionGate {
	if (route.approval_status !== 'draft') {
		return { allowed: false, reason: 'Route is not in Draft status.' };
	}
	if (workflowBlockers.length > 0) {
		return { allowed: false, reason: `Workflow blocked: ${workflowBlockers[0]}` };
	}
	if (phaseIndex(workflowPhase) < phaseIndex('ELECTRICAL_READY')) {
		return { allowed: false, reason: 'Requires Electrical Ready phase before review handoff.' };
	}
	if (!hasTransmissionEvidence(route)) {
		return { allowed: false, reason: 'Transmission evidence incomplete (segments/towers missing).' };
	}
	return { allowed: true, reason: '' };
}

export function gateTransmissionApprovalAction(
	route: TransmissionRoute,
	workflowPhase: WorkflowPhase,
	workflowBlockers: string[]
): RouteActionGate {
	if (route.approval_status !== 'engineering_review') {
		return { allowed: false, reason: 'Route is not in Engineering Review status.' };
	}
	if (workflowBlockers.length > 0) {
		return { allowed: false, reason: `Workflow blocked: ${workflowBlockers[0]}` };
	}
	if (phaseIndex(workflowPhase) < phaseIndex('TRANSMISSION_READY')) {
		return { allowed: false, reason: 'Requires Transmission Ready phase before approval.' };
	}
	return { allowed: true, reason: '' };
}

export function transmissionWorkflowTransitions(
	transitions: WorkflowTransitionRecord[]
): WorkflowTransitionRecord[] {
	return [...transitions]
		.filter((entry) => {
			const fromTransmission = entry.from_phase === 'TRANSMISSION_READY';
			const toTransmission = entry.to_phase === 'TRANSMISSION_READY';
			const toReview = entry.to_phase === 'REVIEW_READY';
			const toApproved = entry.to_phase === 'APPROVED';
			return fromTransmission || toTransmission || toReview || toApproved;
		})
		.sort((a, b) => Date.parse(b.occurred_at || '') - Date.parse(a.occurred_at || ''));
}
