import { derived, writable } from 'svelte/store';

import { workflowApi, type WorkflowState } from '../api/workflow';
import { activeProjectId } from './project';

interface WorkflowStoreState {
	project_id: string;
	current_phase: WorkflowState['current_phase'];
	phase_entered_at: string;
	active_blockers: string[];
	blocked_by: string;
	blockers_since_time: string;
	transitions: WorkflowState['transitions'];
	is_loading: boolean;
	sync_error: string;
	last_synced_at: string;
	polling_enabled: boolean;
}

const DEFAULT_POLL_INTERVAL_MS = 5000;
const HIDDEN_POLL_INTERVAL_MS = 30000;

const initialState: WorkflowStoreState = {
	project_id: '',
	current_phase: 'UNSPECIFIED',
	phase_entered_at: '',
	active_blockers: [],
	blocked_by: '',
	blockers_since_time: '',
	transitions: [],
	is_loading: false,
	sync_error: '',
	last_synced_at: '',
	polling_enabled: true
};

export const workflowState = writable<WorkflowStoreState>({ ...initialState });

export const isWorkflowBlocked = derived(workflowState, ($workflowState) =>
	$workflowState.active_blockers.length > 0
);

let syncTimer: ReturnType<typeof setInterval> | null = null;
let currentProjectId = '';
let visibilityListenerAttached = false;

function getPollIntervalMs(): number {
	if (typeof document === 'undefined') {
		return DEFAULT_POLL_INTERVAL_MS;
	}
	return document.visibilityState === 'hidden' ? HIDDEN_POLL_INTERVAL_MS : DEFAULT_POLL_INTERVAL_MS;
}

function attachVisibilityListener() {
	if (visibilityListenerAttached || typeof document === 'undefined') {
		return;
	}
	document.addEventListener('visibilitychange', () => {
		if (!currentProjectId) {
			return;
		}
		let enabled = true;
		workflowState.update((current) => {
			enabled = current.polling_enabled;
			return current;
		});
		if (enabled) {
			startRealtimeSync();
		}
	});
	visibilityListenerAttached = true;
}

function applyState(state: WorkflowState) {
	workflowState.update((current) => ({
		...current,
		project_id: state.project_id,
		current_phase: state.current_phase,
		phase_entered_at: state.phase_entered_at,
		active_blockers: state.active_blockers,
		blocked_by: state.blocked_by,
		blockers_since_time: state.blockers_since_time,
		transitions: state.transitions,
		sync_error: '',
		last_synced_at: new Date().toISOString()
	}));
}

function clearWorkflowState() {
	workflowState.set({ ...initialState });
	currentProjectId = '';
}

function stopRealtimeSync() {
	if (syncTimer) {
		clearInterval(syncTimer);
		syncTimer = null;
	}
}

function startRealtimeSync(intervalMs = getPollIntervalMs()) {
	stopRealtimeSync();
	if (!currentProjectId) return;
	syncTimer = setInterval(() => {
		void refreshWorkflowState();
	}, intervalMs);
}

export async function refreshWorkflowState() {
	if (!currentProjectId) {
		return;
	}

	workflowState.update((current) => ({ ...current, is_loading: true }));
	try {
		const { state } = await workflowApi.getState(currentProjectId);
		applyState(state);
	} catch (err) {
		const message = err instanceof Error ? err.message : 'Failed to sync workflow state';
		workflowState.update((current) => ({
			...current,
			sync_error: message
		}));
	} finally {
		workflowState.update((current) => ({ ...current, is_loading: false }));
	}
}

export async function bindWorkflowProject(projectId: string | null) {
	const normalized = projectId ?? '';
	if (!normalized) {
		stopRealtimeSync();
		clearWorkflowState();
		return;
	}

	if (currentProjectId !== normalized) {
		currentProjectId = normalized;
		workflowState.update((current) => ({
			...current,
			project_id: normalized,
			transitions: [],
			active_blockers: [],
			sync_error: ''
		}));
	}

	await refreshWorkflowState();
	attachVisibilityListener();
	startRealtimeSync();
}

export function setWorkflowRealtimeSync(enabled: boolean) {
	workflowState.update((current) => ({ ...current, polling_enabled: enabled }));
	if (!enabled) {
		stopRealtimeSync();
		return;
	}
	if (currentProjectId) {
		startRealtimeSync();
	}
}

// Keep workflow sync aligned with whichever project is active in the UI.
activeProjectId.subscribe((projectId) => {
	void bindWorkflowProject(projectId);
});
