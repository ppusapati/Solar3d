<script lang="ts">
	import { activeProject } from '$lib/core/stores';
	import { backendClients, structuralApi, type StructuralDesign } from '$lib/core/api';
	import { JobStatus } from '$lib/gen/orchestration/v1/orchestration_pb.js';
	import {
		buildStructuralSubmitJobRequest,
		orchestrationStatusLabel
	} from '$lib/core/domain/engineeringWorkflow';

	let designs: StructuralDesign[] = [];
	let selectedDesignId = '';
	let name = 'Array Rack A';
	let loading = false;
	let running = false;
	let statusMsg = '';
	let errorMsg = '';

	let deadLoadKn = 0;
	let windLoadKn = 0;
	let seismicLoadKn = 0;
	let governingLoadKn = 0;
	let utilizationRatio = 0;
	let reportText = '';

	let panelCount = 1000;
	let panelMassKg = 25;
	let mountingMassPerPanelKg = 15;
	let cableMassKg = 800;
	let windSpeedMS = 42;
	let totalPanelAreaSqm = 2400;
	let sds = 0.65;
	let totalMassKg = 45000;
	let pileCapacityKn = 50;
	let reviewer = 'engineer@solar3d.local';
	let rejectionReason = 'Requires revision: load envelope exceeds acceptable margin.';
	let latestOrchestrationJob: { id: string; status: JobStatus; error: string; artifactCount: number } | null = null;

	async function loadDesigns() {
		if (!$activeProject?.id) return;
		loading = true;
		errorMsg = '';
		try {
			const resp = await structuralApi.listDesigns($activeProject.id);
			designs = resp.designs;
			if (!selectedDesignId && designs[0]) {
				selectedDesignId = designs[0].id;
			}
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to load structural designs';
		} finally {
			loading = false;
		}
	}

	async function createDesign() {
		if (!$activeProject?.id) return;
		running = true;
		errorMsg = '';
		try {
			const resp = await structuralApi.createDesign({ project_id: $activeProject.id, name });
			selectedDesignId = resp.design.id;
			statusMsg = 'Structural design created.';
			await loadDesigns();
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to create design';
		} finally {
			running = false;
		}
	}

	async function runCalculations() {
		if (!selectedDesignId) return;
		running = true;
		errorMsg = '';
		statusMsg = '';
		try {
			const dead = await structuralApi.computeDeadLoad(selectedDesignId, {
				panel_count: panelCount,
				panel_mass_kg: panelMassKg,
				mounting_mass_per_panel_kg: mountingMassPerPanelKg,
				cable_mass_kg: cableMassKg
			});
			deadLoadKn = dead.deadLoadKn;

			const wind = await structuralApi.computeWindLoad(selectedDesignId, {
				wind_speed_m_s: windSpeedMS,
				exposure: 2,
				height_m: 3,
				panel_tilt_deg: 20,
				total_panel_area_sqm: totalPanelAreaSqm
			});
			windLoadKn = wind.totalWindForceKn;

			const seismic = await structuralApi.computeSeismicLoad(selectedDesignId, {
				sds,
				total_mass_kg: totalMassKg
			});
			seismicLoadKn = seismic.baseShearKn;

			governingLoadKn = Math.max(1.2 * deadLoadKn + 1.6 * windLoadKn, deadLoadKn + seismicLoadKn);

			const foundation = await structuralApi.computeFoundation(selectedDesignId, {
				dead_load_kn: deadLoadKn,
				wind_load_kn: windLoadKn,
				seismic_load_kn: seismicLoadKn,
				foundation_type: 1,
				pile_capacity_kn: pileCapacityKn,
				total_area_sqm: totalPanelAreaSqm
			});
			void foundation;

			const validation = await structuralApi.validateDesign(selectedDesignId, {
				max_wind_pressure_pa: 2500,
				max_seismic_coefficient: 0.5
			});
			utilizationRatio = validation.utilizationRatio;
			statusMsg = validation.valid ? 'Structural validation passed.' : `Structural validation found ${validation.violations.length} issue(s).`;
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed structural calculations';
		} finally {
			running = false;
		}
	}

	async function submitForReview() {
		if (!selectedDesignId) return;
		running = true;
		errorMsg = '';
		try {
			await structuralApi.submitForReview(selectedDesignId, reviewer, 'Submitted from web panel');
			statusMsg = 'Submitted for engineering review.';
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to submit for review';
		} finally {
			running = false;
		}
	}

	async function approveDesign() {
		if (!selectedDesignId) return;
		running = true;
		errorMsg = '';
		try {
			await structuralApi.approveDesign(selectedDesignId, reviewer, 'Reviewed and approved');
			statusMsg = 'Design approved.';
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to approve design';
		} finally {
			running = false;
		}
	}

	async function rejectDesign() {
		if (!selectedDesignId) return;
		running = true;
		errorMsg = '';
		try {
			await structuralApi.rejectDesign(selectedDesignId, reviewer, rejectionReason);
			statusMsg = 'Design rejected and returned for revision.';
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to reject design';
		} finally {
			running = false;
		}
	}

	async function generateReport() {
		if (!selectedDesignId) return;
		running = true;
		errorMsg = '';
		try {
			const resp = await structuralApi.generateReport(selectedDesignId);
			reportText = resp.reportText;
			statusMsg = 'Structural report generated.';
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to generate structural report';
		} finally {
			running = false;
		}
	}

	async function submitStructuralOrchestration(operation: string) {
		if (!selectedDesignId || !$activeProject?.id) return;
		running = true;
		errorMsg = '';
		try {
			const request = buildStructuralSubmitJobRequest($activeProject.id, {
				operation,
				design_id: selectedDesignId,
				panel_count: panelCount,
				panel_mass_kg: panelMassKg,
				mounting_mass_per_panel_kg: mountingMassPerPanelKg,
				cable_mass_kg: cableMassKg,
				wind_speed_m_s: windSpeedMS,
				total_panel_area_sqm: totalPanelAreaSqm,
				sds,
				total_mass_kg: totalMassKg,
				pile_capacity_kn: pileCapacityKn
			});
			const response = await backendClients.orchestration.submitJob(request);
			if (response.job) {
				latestOrchestrationJob = {
					id: response.job.id,
					status: response.job.status,
					error: response.job.errorMessage,
					artifactCount: response.job.artifacts.length
				};
			}
			statusMsg = `Submitted structural orchestration job for ${operation}.`;
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to submit structural orchestration job';
		} finally {
			running = false;
		}
	}

	async function refreshOrchestrationJob() {
		if (!latestOrchestrationJob?.id) return;
		errorMsg = '';
		try {
			const response = await backendClients.orchestration.getJob({ id: latestOrchestrationJob.id });
			if (response.job) {
				latestOrchestrationJob = {
					id: response.job.id,
					status: response.job.status,
					error: response.job.errorMessage,
					artifactCount: response.job.artifacts.length
				};
			}
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to refresh orchestration job';
		}
	}

	$: if ($activeProject?.id) {
		void loadDesigns();
	}
</script>

<div class="panel">
	<h4>Structural Study</h4>
	{#if errorMsg}<p class="error">{errorMsg}</p>{/if}
	{#if statusMsg}<p class="status">{statusMsg}</p>{/if}

	<div class="control-grid">
		<label><span>Design Name</span><input bind:value={name} /></label>
		<label>
			<span>Design</span>
			<select bind:value={selectedDesignId}>
				<option value="">Select Design</option>
				{#each designs as d}
					<option value={d.id}>{d.name}</option>
				{/each}
			</select>
		</label>
	</div>
	<div class="button-row">
		<button class="btn-primary" on:click={createDesign} disabled={running || !$activeProject}>Create</button>
		<button class="btn-secondary" on:click={() => void loadDesigns()} disabled={loading}>Refresh</button>
	</div>

	<div class="control-grid">
		<label><span>Panel Count</span><input type="number" min="1" bind:value={panelCount} /></label>
		<label><span>Wind Speed m/s</span><input type="number" min="0" step="0.1" bind:value={windSpeedMS} /></label>
		<label><span>SDS</span><input type="number" min="0" step="0.01" bind:value={sds} /></label>
		<label><span>Pile Capacity kN</span><input type="number" min="1" step="0.1" bind:value={pileCapacityKn} /></label>
		<label class="full-span"><span>Reject Reason</span><input bind:value={rejectionReason} /></label>
	</div>
	<div class="button-row">
		<button class="btn-primary" on:click={runCalculations} disabled={!selectedDesignId || running}>Run Calculations</button>
		<button class="btn-secondary" on:click={submitForReview} disabled={!selectedDesignId || running}>Submit Review</button>
		<button class="btn-secondary" on:click={approveDesign} disabled={!selectedDesignId || running}>Approve</button>
		<button class="btn-secondary" on:click={rejectDesign} disabled={!selectedDesignId || running}>Reject</button>
		<button class="btn-secondary" on:click={generateReport} disabled={!selectedDesignId || running}>Generate Report</button>
	</div>
	<div class="button-row">
		<button class="btn-secondary" on:click={() => submitStructuralOrchestration('dead_load')} disabled={!selectedDesignId || running}>Orchestrate Dead Load</button>
		<button class="btn-secondary" on:click={() => submitStructuralOrchestration('wind_load')} disabled={!selectedDesignId || running}>Orchestrate Wind Load</button>
		<button class="btn-secondary" on:click={() => submitStructuralOrchestration('seismic_load')} disabled={!selectedDesignId || running}>Orchestrate Seismic Load</button>
		<button class="btn-secondary" on:click={refreshOrchestrationJob} disabled={!latestOrchestrationJob}>Refresh Job</button>
	</div>

	{#if latestOrchestrationJob}
		<div class="orchestration-card">
			<div><strong>Orchestration Job:</strong> {latestOrchestrationJob.id.slice(0, 8)}</div>
			<div><strong>Status:</strong> {orchestrationStatusLabel(latestOrchestrationJob.status)}</div>
			<div><strong>Artifacts:</strong> {latestOrchestrationJob.artifactCount}</div>
			{#if latestOrchestrationJob.error}
				<div class="error">{latestOrchestrationJob.error}</div>
			{/if}
		</div>
	{/if}

	<div class="stat-grid">
		<div class="stat"><span class="stat-value">{deadLoadKn.toFixed(2)}</span><span class="stat-label">Dead kN</span></div>
		<div class="stat"><span class="stat-value">{windLoadKn.toFixed(2)}</span><span class="stat-label">Wind kN</span></div>
		<div class="stat"><span class="stat-value">{seismicLoadKn.toFixed(2)}</span><span class="stat-label">Seismic kN</span></div>
		<div class="stat"><span class="stat-value">{governingLoadKn.toFixed(2)}</span><span class="stat-label">Governing kN</span></div>
		<div class="stat"><span class="stat-value">{utilizationRatio.toFixed(3)}</span><span class="stat-label">Utilization</span></div>
	</div>

	{#if reportText}
		<textarea class="report" rows="8" readonly value={reportText}></textarea>
	{/if}
</div>

<style>
	.panel { display: flex; flex-direction: column; gap: 8px; }
	h4 { margin: 0; font-size: 14px; color: #e2e8f0; }
	.control-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
	.full-span { grid-column: 1 / -1; }
	label { display: flex; flex-direction: column; gap: 4px; font-size: 11px; color: #94a3b8; }
	input, select, textarea { width: 100%; padding: 6px 8px; border: 1px solid rgba(255,255,255,0.15); border-radius: 4px; background: rgba(0,0,0,0.3); color: #e2e8f0; font-size: 12px; }
	.button-row { display: flex; gap: 8px; flex-wrap: wrap; }
	.btn-primary, .btn-secondary { padding: 7px 10px; border-radius: 6px; font-size: 12px; cursor: pointer; }
	.btn-primary { border: none; background: linear-gradient(135deg, #0ea5e9, #2563eb); color: white; font-weight: 600; }
	.btn-secondary { border: 1px solid rgba(255,255,255,0.2); background: transparent; color: #cbd5e1; }
	.stat-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
	.stat { display: flex; flex-direction: column; padding: 8px; border-radius: 6px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); }
	.stat-value { font-size: 16px; font-weight: 700; color: #38bdf8; }
	.stat-label { font-size: 10px; color: #94a3b8; }
	.report { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
	.orchestration-card { padding: 8px; border-radius: 6px; background: rgba(59,130,246,0.08); border: 1px solid rgba(59,130,246,0.24); font-size: 12px; color: #bfdbfe; display: flex; flex-direction: column; gap: 3px; }
	.error, .status { margin: 0; font-size: 12px; }
	.error { color: #fca5a5; }
	.status { color: #93c5fd; }
</style>
