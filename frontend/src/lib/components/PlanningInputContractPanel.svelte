<script lang="ts">
	interface PlanningContract {
		target_mw: number;
		row_spacing_m: number;
		panel_strategy: string;
		inverter_strategy: string;
		route_constraints: string;
		fault_coverage_profile: string;
		standards_profile: string;
		national_grid_code: string;
		captured_at: string;
		captured_by: string;
	}

	export let projectId: string | null = null;
	export let targetCapacityMw = 0;

	let initializedProjectId: string | null = null;
	let baselineLocked = false;
	let lockError = '';
	let baseline: PlanningContract | null = null;
	let form = {
		target_mw: 0,
		row_spacing_m: 4.8,
		panel_strategy: 'Fixed tilt rows with deterministic spacing envelope',
		inverter_strategy: 'Block-level inverter zoning with N+1 resilience',
		route_constraints: 'Avoid exclusion zones and preserve utility corridor access',
		fault_coverage_profile: 'Per block fault markers with string-level traceability',
		standards_profile: 'IEC 62446-1, IEC 61724-1, ISO 19650, IEC 60909, IEC 60255',
		national_grid_code: ''
	};

	function storageKey(project: string): string {
		return `solar3d:planning-contract:${project}`;
	}

	function hydrateForProject(project: string) {
		if (typeof window === 'undefined') return;
		const raw = window.localStorage.getItem(storageKey(project));
		if (!raw) {
			baselineLocked = false;
			baseline = null;
			form.target_mw = targetCapacityMw;
			return;
		}
		try {
			baseline = JSON.parse(raw) as PlanningContract;
			baselineLocked = true;
			lockError = '';
		} catch {
			baselineLocked = false;
			baseline = null;
		}
	}

	function lockBaseline() {
		if (!projectId) return;
		lockError = '';
		if (form.target_mw <= 0) {
			lockError = 'Target MW must be greater than zero.';
			return;
		}
		if (!form.national_grid_code.trim()) {
			lockError = 'National grid code reference is required for baseline capture.';
			return;
		}
		if (typeof window === 'undefined') return;
		const next: PlanningContract = {
			...form,
			captured_at: new Date().toISOString(),
			captured_by: 'frontend-operator'
		};
		window.localStorage.setItem(storageKey(projectId), JSON.stringify(next));
		baseline = next;
		baselineLocked = true;
	}

	$: if (projectId && projectId !== initializedProjectId) {
		initializedProjectId = projectId;
		form.target_mw = targetCapacityMw;
		hydrateForProject(projectId);
	}
</script>

<div class="planning-contract">
	<h5>Planning Input Baseline</h5>
	{#if !projectId}
		<p class="empty">Select a project to capture planning baseline inputs.</p>
	{:else if baselineLocked && baseline}
		<div class="lock-chip">Immutable baseline locked for downstream stages</div>
		<div class="field"><span>Target MW</span><strong>{baseline.target_mw.toFixed(2)} MW</strong></div>
		<div class="field"><span>Row spacing</span><strong>{baseline.row_spacing_m.toFixed(2)} m</strong></div>
		<div class="field stack"><span>Panel strategy</span><strong>{baseline.panel_strategy}</strong></div>
		<div class="field stack"><span>Inverter strategy</span><strong>{baseline.inverter_strategy}</strong></div>
		<div class="field stack"><span>Route constraints</span><strong>{baseline.route_constraints}</strong></div>
		<div class="field stack"><span>Fault coverage</span><strong>{baseline.fault_coverage_profile}</strong></div>
		<div class="field stack"><span>Standards profile</span><strong>{baseline.standards_profile}</strong></div>
		<div class="field stack"><span>National grid code</span><strong>{baseline.national_grid_code}</strong></div>
		<div class="captured">Captured: {new Date(baseline.captured_at).toLocaleString()}</div>
	{:else}
		<div class="grid two-col">
			<label>
				<span>Target MW</span>
				<input type="number" min="0" step="0.1" bind:value={form.target_mw} />
			</label>
			<label>
				<span>Row spacing (m)</span>
				<input type="number" min="0" step="0.1" bind:value={form.row_spacing_m} />
			</label>
		</div>
		<label>
			<span>Panel strategy</span>
			<textarea bind:value={form.panel_strategy} rows="2"></textarea>
		</label>
		<label>
			<span>Inverter strategy</span>
			<textarea bind:value={form.inverter_strategy} rows="2"></textarea>
		</label>
		<label>
			<span>Route constraints</span>
			<textarea bind:value={form.route_constraints} rows="2"></textarea>
		</label>
		<label>
			<span>Fault coverage profile</span>
			<textarea bind:value={form.fault_coverage_profile} rows="2"></textarea>
		</label>
		<label>
			<span>Standards profile</span>
			<textarea bind:value={form.standards_profile} rows="2"></textarea>
		</label>
		<label>
			<span>National grid code requirement</span>
			<input bind:value={form.national_grid_code} placeholder="Enter local grid code reference" />
		</label>
		{#if lockError}
			<p class="error">{lockError}</p>
		{/if}
		<button class="lock" on:click={lockBaseline}>Lock Baseline</button>
	{/if}
</div>

<style>
	.planning-contract {
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

	.grid {
		display: grid;
		gap: 8px;
	}

	.two-col {
		grid-template-columns: 1fr 1fr;
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

	textarea {
		resize: vertical;
	}

	.lock {
		padding: 7px 8px;
		border-radius: 6px;
		border: 1px solid rgba(34, 197, 94, 0.5);
		background: rgba(34, 197, 94, 0.15);
		color: #86efac;
		font-size: 12px;
		font-weight: 600;
		cursor: pointer;
	}

	.lock-chip {
		padding: 6px 8px;
		border: 1px solid rgba(14, 165, 233, 0.5);
		background: rgba(14, 165, 233, 0.12);
		color: #7dd3fc;
		font-size: 11px;
		border-radius: 6px;
	}

	.field {
		display: flex;
		justify-content: space-between;
		gap: 8px;
		font-size: 12px;
		color: #cbd5e1;
	}

	.field.stack {
		flex-direction: column;
	}

	.field strong {
		color: #f8fafc;
		font-weight: 600;
	}

	.captured {
		font-size: 11px;
		color: #94a3b8;
	}

	.error {
		margin: 0;
		font-size: 11px;
		color: #fca5a5;
	}

	.empty {
		margin: 0;
		font-size: 12px;
		color: #64748b;
	}
</style>
