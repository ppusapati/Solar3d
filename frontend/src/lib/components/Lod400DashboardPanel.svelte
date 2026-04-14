<script lang="ts">
	import type { WorkflowPhase } from '$lib/core/api/workflow';
	import {
		computeLod400Checklist,
		type LayoutCompletenessSummary,
		type Lod400ChecklistSummary
	} from '$lib/core/domain/workflowReadiness';

	export let projectId: string | null = null;
	export let summary: LayoutCompletenessSummary;
	export let workflowBlockers: string[] = [];
	export let currentPhase: WorkflowPhase = 'UNSPECIFIED';

	let reviewer = '';
	let note = '';
	let signoffError = '';
	let signoffAt = '';
	let checklist: Lod400ChecklistSummary = computeLod400Checklist(summary, workflowBlockers);

	function signoffKey(project: string): string {
		return `solar3d:lod400-signoff:${project}`;
	}

	function loadSignoff(project: string) {
		if (typeof window === 'undefined') return;
		const raw = window.localStorage.getItem(signoffKey(project));
		if (!raw) {
			reviewer = '';
			note = '';
			signoffAt = '';
			return;
		}
		try {
			const parsed = JSON.parse(raw) as { reviewer: string; note: string; signoff_at: string };
			reviewer = parsed.reviewer;
			note = parsed.note;
			signoffAt = parsed.signoff_at;
		} catch {
			reviewer = '';
			note = '';
			signoffAt = '';
		}
	}

	function recordSignoff() {
		signoffError = '';
		if (!projectId) {
			signoffError = 'Select a project first.';
			return;
		}
		if (!checklist.pass) {
			signoffError = 'Resolve all LOD 400 blockers before reviewer signoff.';
			return;
		}
		if (!reviewer.trim()) {
			signoffError = 'Reviewer name is required.';
			return;
		}
		if (typeof window === 'undefined') return;
		const signoff = {
			reviewer: reviewer.trim(),
			note: note.trim(),
			signoff_at: new Date().toISOString(),
			phase: currentPhase,
			checklist
		};
		window.localStorage.setItem(signoffKey(projectId), JSON.stringify(signoff));
		signoffAt = signoff.signoff_at;
	}

	$: checklist = computeLod400Checklist(summary, workflowBlockers);
	$: if (projectId) {
		loadSignoff(projectId);
	}
</script>

<div class="lod-panel">
	<h5>LOD 400 Dashboard</h5>
	<div class="phase-row">
		<span>Current workflow phase</span>
		<strong>{currentPhase.replaceAll('_', ' ')}</strong>
	</div>
	{#if checklist.blocker_reasons.length > 0}
		<div class="blockers">
			{#each checklist.blocker_reasons as blocker}
				<div>{blocker}</div>
			{/each}
		</div>
	{/if}
	<div class="checklist">
		{#each checklist.items as item}
			<div class="item" class:fail={!item.pass}>
				<span>{item.label}</span>
				<strong>{item.pass ? 'Pass' : 'Blocker'}</strong>
			</div>
		{/each}
	</div>
	<div class="signoff">
		<label>
			<span>Reviewer</span>
			<input bind:value={reviewer} placeholder="Name / role" />
		</label>
		<label>
			<span>Review note</span>
			<textarea rows="2" bind:value={note} placeholder="Decision rationale"></textarea>
		</label>
		{#if signoffError}
			<p class="error">{signoffError}</p>
		{/if}
		<button on:click={recordSignoff} disabled={!checklist.pass}>Record LOD 400 Signoff</button>
		{#if signoffAt}
			<div class="signed">Signed off at {new Date(signoffAt).toLocaleString()}</div>
		{/if}
	</div>
</div>

<style>
	.lod-panel {
		display: flex;
		flex-direction: column;
		gap: 8px;
	}

	h5 {
		margin: 0;
		font-size: 12px;
		font-weight: 600;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.phase-row {
		display: flex;
		justify-content: space-between;
		font-size: 12px;
		color: #cbd5e1;
	}

	.blockers {
		display: grid;
		gap: 4px;
		padding: 7px;
		border-radius: 6px;
		border: 1px solid rgba(239, 68, 68, 0.45);
		background: rgba(239, 68, 68, 0.1);
		font-size: 11px;
		color: #fecaca;
	}

	.checklist {
		display: grid;
		gap: 5px;
	}

	.item {
		display: flex;
		justify-content: space-between;
		padding: 6px 8px;
		border-radius: 6px;
		border: 1px solid rgba(34, 197, 94, 0.35);
		background: rgba(34, 197, 94, 0.08);
		font-size: 12px;
		color: #dcfce7;
	}

	.item.fail {
		border-color: rgba(239, 68, 68, 0.45);
		background: rgba(239, 68, 68, 0.08);
		color: #fecaca;
	}

	.signoff {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	label {
		display: flex;
		flex-direction: column;
		gap: 4px;
		font-size: 11px;
		color: #94a3b8;
	}

	input,
	textarea {
		padding: 6px 8px;
		border-radius: 6px;
		border: 1px solid rgba(255, 255, 255, 0.12);
		background: rgba(2, 6, 23, 0.5);
		color: #e2e8f0;
		font-size: 12px;
	}

	button {
		padding: 7px 8px;
		border-radius: 6px;
		border: 1px solid rgba(14, 165, 233, 0.45);
		background: rgba(14, 165, 233, 0.14);
		color: #bae6fd;
		font-size: 12px;
		font-weight: 600;
		cursor: pointer;
	}

	button:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}

	.error {
		margin: 0;
		font-size: 11px;
		color: #fca5a5;
	}

	.signed {
		font-size: 11px;
		color: #86efac;
	}
</style>
