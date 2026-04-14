import { api } from './client';

export type WorkflowPhase =
	| 'UNSPECIFIED'
	| 'PLANNING'
	| 'LAYOUT_READY'
	| 'ELECTRICAL_READY'
	| 'TRANSMISSION_READY'
	| 'REVIEW_READY'
	| 'APPROVED'
	| 'COMMISSIONING_READY'
	| 'ARCHIVED';

export interface WorkflowTransitionRecord {
	id: string;
	project_id: string;
	from_phase: WorkflowPhase;
	to_phase: WorkflowPhase;
	occurred_at: string;
	actor_id: string;
	reason: string;
	is_rollback: boolean;
	rollback_reason: string;
}

export interface WorkflowState {
	project_id: string;
	current_phase: WorkflowPhase;
	phase_entered_at: string;
	active_blockers: string[];
	blocked_by: string;
	blockers_since_time: string;
	transitions: WorkflowTransitionRecord[];
}

interface RawWorkflowTransitionRecord {
	id?: string;
	project_id?: string;
	from_phase?: number;
	to_phase?: number;
	occurred_at?: string;
	actor_id?: string;
	reason?: string;
	is_rollback?: boolean;
	rollback_reason?: string;
}

interface RawWorkflowState {
	project_id?: string;
	current_phase?: number;
	phase_entered_at?: string;
	active_blockers?: string[];
	blocked_by?: string;
	blockers_since_time?: string;
	transitions?: RawWorkflowTransitionRecord[];
}

interface RawProjectResponse {
	id?: string;
	workflow_state?: RawWorkflowState;
}

const PHASE_BY_CODE: Record<number, WorkflowPhase> = {
	0: 'UNSPECIFIED',
	1: 'PLANNING',
	2: 'LAYOUT_READY',
	3: 'ELECTRICAL_READY',
	4: 'TRANSMISSION_READY',
	5: 'REVIEW_READY',
	6: 'APPROVED',
	7: 'COMMISSIONING_READY',
	8: 'ARCHIVED'
};

function phaseFromCode(code: number | undefined): WorkflowPhase {
	if (typeof code !== 'number') {
		return 'UNSPECIFIED';
	}
	return PHASE_BY_CODE[code] ?? 'UNSPECIFIED';
}

function mapTransition(raw: RawWorkflowTransitionRecord, fallbackProjectId: string): WorkflowTransitionRecord {
	return {
		id: raw.id ?? '',
		project_id: raw.project_id ?? fallbackProjectId,
		from_phase: phaseFromCode(raw.from_phase),
		to_phase: phaseFromCode(raw.to_phase),
		occurred_at: raw.occurred_at ?? '',
		actor_id: raw.actor_id ?? '',
		reason: raw.reason ?? '',
		is_rollback: Boolean(raw.is_rollback),
		rollback_reason: raw.rollback_reason ?? ''
	};
}

function mapState(projectId: string, raw?: RawWorkflowState): WorkflowState {
	return {
		project_id: raw?.project_id ?? projectId,
		current_phase: phaseFromCode(raw?.current_phase),
		phase_entered_at: raw?.phase_entered_at ?? '',
		active_blockers: raw?.active_blockers ?? [],
		blocked_by: raw?.blocked_by ?? '',
		blockers_since_time: raw?.blockers_since_time ?? '',
		transitions: (raw?.transitions ?? []).map((t) => mapTransition(t, projectId))
	};
}

export const workflowApi = {
	getState: async (projectId: string): Promise<{ state: WorkflowState }> => {
		if (!projectId) {
			throw new Error('projectId is required');
		}
		const project = await api.get<RawProjectResponse>(`/api/v1/projects/${projectId}`);
		return { state: mapState(project.id ?? projectId, project.workflow_state) };
	}
};
