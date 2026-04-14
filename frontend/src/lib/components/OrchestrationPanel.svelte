<script lang="ts">
	import { activeProject } from '$lib/core/stores';
	import { backendClients } from '$lib/core/api';
	import {
		JobStatus,
		JobType,
		type DeadLetter,
		type Job
	} from '$lib/gen/orchestration/v1/orchestration_pb.js';

	const jobTypeOptions: { value: string; label: string; proto: JobType }[] = [
		{ value: 'regenerate', label: 'Regenerate', proto: JobType.REGENERATE },
		{ value: 'import', label: 'Import', proto: JobType.IMPORT },
		{ value: 'publish', label: 'Publish', proto: JobType.PUBLISH },
		{ value: 'simulation', label: 'Simulation', proto: JobType.SIMULATION },
		{ value: 'optimization', label: 'Optimization', proto: JobType.OPTIMIZATION },
		{ value: 'structural', label: 'Structural Load Analysis', proto: JobType.STRUCTURAL_LOAD_ANALYSIS },
		{ value: 'protection', label: 'Protection Study', proto: JobType.PROTECTION_STUDY },
		{ value: 'commissioning', label: 'Commissioning', proto: JobType.COMMISSIONING },
		{ value: 'custom', label: 'Custom', proto: JobType.CUSTOM }
	];

	const statusOptions: { value: string; label: string; proto: JobStatus }[] = [
		{ value: 'all', label: 'All Statuses', proto: JobStatus.UNSPECIFIED },
		{ value: 'queued', label: 'Queued', proto: JobStatus.QUEUED },
		{ value: 'running', label: 'Running', proto: JobStatus.RUNNING },
		{ value: 'succeeded', label: 'Succeeded', proto: JobStatus.SUCCEEDED },
		{ value: 'failed', label: 'Failed', proto: JobStatus.FAILED },
		{ value: 'canceled', label: 'Canceled', proto: JobStatus.CANCELED },
		{ value: 'retry_pending', label: 'Retry Pending', proto: JobStatus.RETRY_PENDING }
	];

	let jobs: Job[] = [];
	let deadLetters: DeadLetter[] = [];
	let selectedJob: Job | null = null;
	let selectedDeadLetter: DeadLetter | null = null;
	let loading = false;
	let submitting = false;
	let retryingId = '';
	let cancelingId = '';
	let error = '';
	let loadedProjectId: string | null = null;
	let statusFilter = 'all';
	let submitType = 'custom';
	let priority = 50;
	let maxAttempts = 3;
	let payloadJson = '{\n  "requested_by": "frontend",\n  "note": "manual orchestration dashboard submission"\n}';

	function timestampLabel(timestamp?: { seconds: bigint | number }): string {
		if (!timestamp) return '—';
		return new Date(Number(timestamp.seconds) * 1000).toLocaleString();
	}

	function statusLabel(status: JobStatus): string {
		return statusOptions.find((option) => option.proto === status)?.label ?? `Status ${status}`;
	}

	function typeLabel(type: JobType): string {
		return jobTypeOptions.find((option) => option.proto === type)?.label ?? `Type ${type}`;
	}

	function selectedTypeProto(): JobType {
		return jobTypeOptions.find((option) => option.value === submitType)?.proto ?? JobType.CUSTOM;
	}

	function selectedStatusProto(): JobStatus {
		return statusOptions.find((option) => option.value === statusFilter)?.proto ?? JobStatus.UNSPECIFIED;
	}

	async function loadDashboard() {
		if (!$activeProject) return;
		loading = true;
		error = '';
		try {
			const [jobResponse, deadLetterResponse] = await Promise.all([
				backendClients.orchestration.listJobs({
					projectId: $activeProject.id,
					statusFilter: selectedStatusProto(),
					limit: 50
				}),
				backendClients.orchestration.listDeadLetters({
					projectId: $activeProject.id,
					limit: 20
				})
			]);

			jobs = jobResponse.jobs;
			deadLetters = deadLetterResponse.deadLetters;
			if (selectedJob) {
				selectedJob = jobResponse.jobs.find((job) => job.id === selectedJob?.id) ?? selectedJob;
			}
			if (selectedDeadLetter) {
				selectedDeadLetter = deadLetterResponse.deadLetters.find((entry) => entry.id === selectedDeadLetter?.id) ?? selectedDeadLetter;
			}
		} catch (err: unknown) {
			error = err instanceof Error ? err.message : 'Failed to load orchestration dashboard';
		} finally {
			loading = false;
		}
	}

	async function submitJob() {
		if (!$activeProject) return;
		submitting = true;
		error = '';
		try {
			JSON.parse(payloadJson);
			const response = await backendClients.orchestration.submitJob({
				projectId: $activeProject.id,
				type: selectedTypeProto(),
				priority,
				maxAttempts,
				payloadJson
			});
			selectedJob = response.job ?? null;
			await loadDashboard();
		} catch (err: unknown) {
			error = err instanceof Error ? err.message : 'Failed to submit orchestration job';
		} finally {
			submitting = false;
		}
	}

	async function selectJob(id: string) {
		error = '';
		try {
			const response = await backendClients.orchestration.getJob({ id });
			selectedJob = response.job ?? null;
		} catch (err: unknown) {
			error = err instanceof Error ? err.message : 'Failed to load job details';
		}
	}

	async function retryJob(id: string) {
		retryingId = id;
		error = '';
		try {
			const response = await backendClients.orchestration.retryJob({ id });
			selectedJob = response.job ?? selectedJob;
			await loadDashboard();
		} catch (err: unknown) {
			error = err instanceof Error ? err.message : 'Failed to retry job';
		} finally {
			retryingId = '';
		}
	}

	async function cancelJob(id: string) {
		cancelingId = id;
		error = '';
		try {
			const response = await backendClients.orchestration.cancelJob({ id });
			selectedJob = response.job ?? selectedJob;
			await loadDashboard();
		} catch (err: unknown) {
			error = err instanceof Error ? err.message : 'Failed to cancel job';
		} finally {
			cancelingId = '';
		}
	}

	async function selectDeadLetter(jobId: string) {
		error = '';
		try {
			const response = await backendClients.orchestration.getDeadLetter({ jobId });
			selectedDeadLetter = response.deadLetter ?? null;
		} catch (err: unknown) {
			error = err instanceof Error ? err.message : 'Failed to load dead letter';
		}
	}

	$: if ($activeProject?.id && $activeProject.id !== loadedProjectId) {
		loadedProjectId = $activeProject.id;
		selectedJob = null;
		selectedDeadLetter = null;
		void loadDashboard();
	}
</script>

<div class="orchestration-panel">
	<h5>Compute Orchestration</h5>

	{#if error}
		<div class="error">{error}</div>
	{/if}

	{#if !$activeProject}
		<p class="empty">Select a project to monitor asynchronous jobs.</p>
	{:else}
		<div class="section">
			<div class="form-grid">
				<label>
					<span>Job Type</span>
					<select bind:value={submitType}>
						{#each jobTypeOptions as option}
							<option value={option.value}>{option.label}</option>
						{/each}
					</select>
				</label>
				<label>
					<span>Status Filter</span>
					<select bind:value={statusFilter} on:change={() => void loadDashboard()}>
						{#each statusOptions as option}
							<option value={option.value}>{option.label}</option>
						{/each}
					</select>
				</label>
				<label>
					<span>Priority</span>
					<input type="number" min="0" max="100" bind:value={priority} />
				</label>
				<label>
					<span>Max Attempts</span>
					<input type="number" min="1" max="10" bind:value={maxAttempts} />
				</label>
				<label class="full-width">
					<span>Payload JSON</span>
					<textarea bind:value={payloadJson} rows="4"></textarea>
				</label>
			</div>
			<div class="button-row">
				<button class="btn-primary" on:click={submitJob} disabled={submitting}>{submitting ? 'Submitting…' : 'Submit Job'}</button>
				<button class="btn-secondary" on:click={() => void loadDashboard()} disabled={loading}>{loading ? 'Refreshing…' : 'Refresh'}</button>
			</div>
		</div>

		<div class="divider"></div>

		<div class="section">
			<h6>Jobs ({jobs.length})</h6>
			{#if jobs.length === 0}
				<p class="empty compact">No jobs found for the current filter.</p>
			{:else}
				<div class="list">
					{#each jobs as job (job.id)}
						<div class="list-item" class:selected={selectedJob?.id === job.id}>
							<button class="list-button" on:click={() => void selectJob(job.id)}>
								<span>{typeLabel(job.type)} · {statusLabel(job.status)}</span>
								<small>{job.id.slice(0, 8)} · attempts {job.attempts}/{job.maxAttempts}</small>
							</button>
							<div class="inline-actions">
								<button class="btn-secondary compact" on:click={() => void retryJob(job.id)} disabled={retryingId === job.id || !(job.status === JobStatus.FAILED || job.status === JobStatus.CANCELED)}>{retryingId === job.id ? 'Retrying…' : 'Retry'}</button>
								<button class="btn-danger compact" on:click={() => void cancelJob(job.id)} disabled={cancelingId === job.id || !(job.status === JobStatus.QUEUED || job.status === JobStatus.RUNNING)}>{cancelingId === job.id ? 'Canceling…' : 'Cancel'}</button>
							</div>
						</div>
					{/each}
				</div>
			{/if}
		</div>

		{#if selectedJob}
			<div class="divider"></div>
			<div class="section">
				<h6>Selected Job</h6>
				<div class="detail-card">
					<div class="detail-row"><span>Type</span><strong>{typeLabel(selectedJob.type)}</strong></div>
					<div class="detail-row"><span>Status</span><strong>{statusLabel(selectedJob.status)}</strong></div>
					<div class="detail-row"><span>Priority</span><strong>{selectedJob.priority}</strong></div>
					<div class="detail-row"><span>Created</span><strong>{timestampLabel(selectedJob.createdAt)}</strong></div>
					<div class="detail-row"><span>Started</span><strong>{timestampLabel(selectedJob.startedAt)}</strong></div>
					<div class="detail-row"><span>Completed</span><strong>{timestampLabel(selectedJob.completedAt)}</strong></div>
					{#if selectedJob.errorMessage}
						<div class="payload-block error-block">{selectedJob.errorMessage}</div>
					{/if}
					<div class="payload-block">{selectedJob.payloadJson || 'No payload'}</div>
					{#if selectedJob.artifacts.length > 0}
						<div class="artifact-list">
							{#each selectedJob.artifacts as artifact}
								<a class="artifact-link" href={artifact.uri} target="_blank" rel="noreferrer">{artifact.kind} · {artifact.uri}</a>
							{/each}
						</div>
					{/if}
				</div>
			</div>
		{/if}

		<div class="divider"></div>

		<div class="section">
			<h6>Dead Letters ({deadLetters.length})</h6>
			{#if deadLetters.length === 0}
				<p class="empty compact">No dead letters for the current project.</p>
			{:else}
				<div class="list">
					{#each deadLetters as deadLetter (deadLetter.id)}
						<button class="list-button standalone" on:click={() => void selectDeadLetter(deadLetter.jobId)}>
							<span>{deadLetter.reason}</span>
							<small>{deadLetter.jobId.slice(0, 8)} · {timestampLabel(deadLetter.createdAt)}</small>
						</button>
					{/each}
				</div>
			{/if}
		</div>

		{#if selectedDeadLetter}
			<div class="divider"></div>
			<div class="section">
				<h6>Selected Dead Letter</h6>
				<div class="detail-card">
					<div class="detail-row"><span>Reason</span><strong>{selectedDeadLetter.reason}</strong></div>
					<div class="detail-row"><span>Created</span><strong>{timestampLabel(selectedDeadLetter.createdAt)}</strong></div>
					<div class="payload-block">{selectedDeadLetter.payloadJson || 'No payload'}</div>
				</div>
			</div>
		{/if}
	{/if}
</div>

<style>
	.orchestration-panel {
		display: flex;
		flex-direction: column;
		gap: 10px;
	}

	h5,
	h6 {
		margin: 0;
		font-size: 12px;
		font-weight: 600;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.section {
		display: flex;
		flex-direction: column;
		gap: 8px;
	}

	.form-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 8px;
	}

	.form-grid label {
		display: flex;
		flex-direction: column;
		gap: 4px;
		font-size: 11px;
		color: #94a3b8;
	}

	.full-width {
		grid-column: 1 / -1;
	}

	input,
	select,
	textarea {
		width: 100%;
		padding: 6px 8px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 4px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 12px;
		font-family: inherit;
	}

	textarea {
		resize: vertical;
	}

	.button-row,
	.inline-actions {
		display: flex;
		gap: 8px;
		flex-wrap: wrap;
	}

	.list {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	.list-item {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 8px;
		padding: 8px;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.08);
	}

	.list-item.selected {
		border-color: rgba(245, 158, 11, 0.35);
		background: rgba(245, 158, 11, 0.08);
	}

	.list-button {
		flex: 1;
		display: flex;
		flex-direction: column;
		gap: 2px;
		align-items: flex-start;
		border: none;
		background: transparent;
		color: #e2e8f0;
		padding: 0;
		cursor: pointer;
		text-align: left;
	}

	.list-button.standalone {
		padding: 8px;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.08);
	}

	.list-button small {
		color: #94a3b8;
	}

	.detail-card {
		display: flex;
		flex-direction: column;
		gap: 6px;
		padding: 8px;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.08);
	}

	.detail-row {
		display: flex;
		justify-content: space-between;
		gap: 8px;
		font-size: 12px;
		color: #94a3b8;
	}

	.detail-row strong {
		color: #e2e8f0;
		text-align: right;
	}

	.payload-block {
		padding: 8px;
		border-radius: 6px;
		background: rgba(0, 0, 0, 0.24);
		color: #cbd5e1;
		font-size: 11px;
		white-space: pre-wrap;
		word-break: break-word;
	}

	.error-block {
		background: rgba(239, 68, 68, 0.12);
		color: #fecaca;
	}

	.artifact-list {
		display: flex;
		flex-direction: column;
		gap: 4px;
	}

	.artifact-link {
		font-size: 11px;
		color: #f59e0b;
		text-decoration: none;
	}

	.artifact-link:hover {
		text-decoration: underline;
	}

	.btn-primary,
	.btn-secondary,
	.btn-danger {
		padding: 8px;
		border-radius: 6px;
		font-size: 12px;
		cursor: pointer;
	}

	.btn-primary {
		border: none;
		background: linear-gradient(135deg, #3b82f6, #2563eb);
		color: white;
		font-weight: 600;
	}

	.btn-secondary {
		border: 1px solid rgba(255, 255, 255, 0.15);
		background: transparent;
		color: #94a3b8;
	}

	.btn-danger {
		border: 1px solid rgba(239, 68, 68, 0.3);
		background: rgba(239, 68, 68, 0.08);
		color: #fca5a5;
	}

	.compact {
		padding: 4px 8px;
		font-size: 11px;
	}

	.error,
	.empty {
		font-size: 12px;
		margin: 0;
	}

	.error {
		color: #fca5a5;
	}

	.empty {
		color: #64748b;
	}

	.empty.compact {
		text-align: left;
	}

	.divider {
		height: 1px;
		background: rgba(255, 255, 255, 0.1);
		margin: 2px 0;
	}
</style>
