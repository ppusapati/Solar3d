<script lang="ts">
	import { activeProject } from '$lib/core/stores';
	import { backendClients, protectionApi, type ProtectionStudy } from '$lib/core/api';
	import { JobStatus } from '$lib/gen/orchestration/v1/orchestration_pb.js';
	import {
		buildProtectionSubmitJobRequest,
		orchestrationStatusLabel
	} from '$lib/core/domain/engineeringWorkflow';

	let studies: ProtectionStudy[] = [];
	let selectedStudyId = '';
	let name = 'MV Feeder Study';
	let loading = false;
	let running = false;
	let statusMsg = '';
	let errorMsg = '';

	let shortCircuitKa = 0;
	let earthFaultKa = 0;
	let relayPickupA = 0;
	let relayTimeS = 0;
	let coordinationValid = true;
	let reportText = '';

	let systemVoltageKv = 33;
	let sourceImpedancePu = 0.08;
	let mvaBase = 100;
	let sourceImpedanceOhm = 1.2;
	let cableResistanceOhm = 0.3;
	let cableReactanceOhm = 0.4;
	let zeroSeqImpedanceOhm = 0.6;
	let loadCurrentA = 420;
	let latestOrchestrationJob: { id: string; status: JobStatus; error: string; artifactCount: number } | null = null;

	async function loadStudies() {
		if (!$activeProject?.id) return;
		loading = true;
		errorMsg = '';
		try {
			const resp = await protectionApi.listStudies($activeProject.id);
			studies = resp.studies;
			if (!selectedStudyId && studies[0]) {
				selectedStudyId = studies[0].id;
			}
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to load protection studies';
		} finally {
			loading = false;
		}
	}

	async function createStudy() {
		if (!$activeProject?.id) return;
		running = true;
		errorMsg = '';
		try {
			const resp = await protectionApi.createStudy({
				project_id: $activeProject.id,
				name,
				system_voltage_kv: systemVoltageKv,
				source_impedance_pu: sourceImpedancePu,
				mva_base: mvaBase
			});
			selectedStudyId = resp.study.id;
			statusMsg = 'Protection study created.';
			await loadStudies();
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to create study';
		} finally {
			running = false;
		}
	}

	async function runProtectionCalcs() {
		if (!selectedStudyId) return;
		running = true;
		errorMsg = '';
		statusMsg = '';
		try {
			const sc = await protectionApi.computeShortCircuit(selectedStudyId, {
				voltage_kv: systemVoltageKv,
				source_impedance_ohm: sourceImpedanceOhm,
				cable_resistance_ohm: cableResistanceOhm,
				cable_reactance_ohm: cableReactanceOhm,
				zero_seq_impedance_ohm: zeroSeqImpedanceOhm,
				include_single_line_to_ground: true
			});
			shortCircuitKa = sc.governingFaultKa;

			const ef = await protectionApi.computeEarthFault(selectedStudyId, {
				voltage_kv: systemVoltageKv,
				earthing_method: 2,
				ngr_resistance_ohm: 8,
				cable_resistance_ohm: cableResistanceOhm
			});
			earthFaultKa = ef.earthFaultCurrentKa;

			const relay = await protectionApi.selectRelay(selectedStudyId, {
				fault_current_ka: shortCircuitKa,
				load_current_a: loadCurrentA,
				preferred_characteristic: 1
			});
			relayPickupA = relay.relay?.pickupCurrentA ?? 0;

			const settings = await protectionApi.computeRelaySettings(selectedStudyId, {
				characteristic: 1,
				pickup_current_a: relayPickupA,
				time_dial_setting: relay.relay?.timeDialSetting ?? 0.1,
				fault_current_a: shortCircuitKa * 1000
			});
			relayTimeS = settings.operatingTimeS;

			const coord = await protectionApi.validateCoordination(
				selectedStudyId,
				[
					{
						upstream_relay_id: 'RLY-UP-01',
						downstream_relay_id: 'RLY-DN-01',
						upstream_time_s: relayTimeS + 0.35,
						downstream_time_s: relayTimeS,
						margin_s: 0.35
					}
				],
				0.3
			);
			coordinationValid = coord.valid;
			statusMsg = coord.valid ? 'Protection study checks passed.' : `Coordination has ${coord.violations.length} violation(s).`;
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed protection calculations';
		} finally {
			running = false;
		}
	}

	async function generateReport() {
		if (!selectedStudyId) return;
		running = true;
		errorMsg = '';
		try {
			const resp = await protectionApi.generateReport(selectedStudyId);
			reportText = resp.reportText;
			statusMsg = 'Protection report generated.';
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to generate protection report';
		} finally {
			running = false;
		}
	}

	async function submitProtectionOrchestration(operation: string) {
		if (!selectedStudyId || !$activeProject?.id) return;
		running = true;
		errorMsg = '';
		try {
			const request = buildProtectionSubmitJobRequest($activeProject.id, {
				operation,
				study_id: selectedStudyId,
				voltage_kv: systemVoltageKv,
				source_impedance_ohm: sourceImpedanceOhm,
				cable_resistance_ohm: cableResistanceOhm,
				cable_reactance_ohm: cableReactanceOhm,
				zero_seq_impedance_ohm: zeroSeqImpedanceOhm,
				fault_current_ka: shortCircuitKa,
				load_current_a: loadCurrentA,
				characteristic: 1,
				pickup_current_a: relayPickupA,
				time_dial_setting: 0.1,
				fault_current_a: shortCircuitKa * 1000
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
			statusMsg = `Submitted protection orchestration job for ${operation}.`;
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to submit protection orchestration job';
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
		void loadStudies();
	}
</script>

<div class="panel">
	<h4>Protection Study</h4>
	{#if errorMsg}<p class="error">{errorMsg}</p>{/if}
	{#if statusMsg}<p class="status">{statusMsg}</p>{/if}

	<div class="control-grid">
		<label><span>Study Name</span><input bind:value={name} /></label>
		<label>
			<span>Study</span>
			<select bind:value={selectedStudyId}>
				<option value="">Select Study</option>
				{#each studies as s}
					<option value={s.id}>{s.name}</option>
				{/each}
			</select>
		</label>
		<label><span>System kV</span><input type="number" min="1" step="0.1" bind:value={systemVoltageKv} /></label>
		<label><span>Load Current A</span><input type="number" min="0" step="0.1" bind:value={loadCurrentA} /></label>
	</div>
	<div class="button-row">
		<button class="btn-primary" on:click={createStudy} disabled={running || !$activeProject}>Create</button>
		<button class="btn-secondary" on:click={() => void loadStudies()} disabled={loading}>Refresh</button>
		<button class="btn-primary" on:click={runProtectionCalcs} disabled={!selectedStudyId || running}>Run Calculations</button>
		<button class="btn-secondary" on:click={generateReport} disabled={!selectedStudyId || running}>Generate Report</button>
	</div>
	<div class="button-row">
		<button class="btn-secondary" on:click={() => submitProtectionOrchestration('short_circuit')} disabled={!selectedStudyId || running}>Orchestrate Short-Circuit</button>
		<button class="btn-secondary" on:click={() => submitProtectionOrchestration('earth_fault')} disabled={!selectedStudyId || running}>Orchestrate Earth-Fault</button>
		<button class="btn-secondary" on:click={() => submitProtectionOrchestration('relay_settings')} disabled={!selectedStudyId || running}>Orchestrate Relay Settings</button>
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
		<div class="stat"><span class="stat-value">{shortCircuitKa.toFixed(2)}</span><span class="stat-label">Governing Fault kA</span></div>
		<div class="stat"><span class="stat-value">{earthFaultKa.toFixed(2)}</span><span class="stat-label">Earth Fault kA</span></div>
		<div class="stat"><span class="stat-value">{relayPickupA.toFixed(1)}</span><span class="stat-label">Relay Pickup A</span></div>
		<div class="stat"><span class="stat-value">{relayTimeS.toFixed(3)}</span><span class="stat-label">Relay Time s</span></div>
		<div class="stat"><span class="stat-value">{coordinationValid ? 'PASS' : 'FAIL'}</span><span class="stat-label">Coordination</span></div>
	</div>

	{#if reportText}
		<textarea class="report" rows="8" readonly value={reportText}></textarea>
	{/if}
</div>

<style>
	.panel { display: flex; flex-direction: column; gap: 8px; }
	h4 { margin: 0; font-size: 14px; color: #e2e8f0; }
	.control-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
	label { display: flex; flex-direction: column; gap: 4px; font-size: 11px; color: #94a3b8; }
	input, select, textarea { width: 100%; padding: 6px 8px; border: 1px solid rgba(255,255,255,0.15); border-radius: 4px; background: rgba(0,0,0,0.3); color: #e2e8f0; font-size: 12px; }
	.button-row { display: flex; gap: 8px; flex-wrap: wrap; }
	.btn-primary, .btn-secondary { padding: 7px 10px; border-radius: 6px; font-size: 12px; cursor: pointer; }
	.btn-primary { border: none; background: linear-gradient(135deg, #06b6d4, #0ea5e9); color: white; font-weight: 600; }
	.btn-secondary { border: 1px solid rgba(255,255,255,0.2); background: transparent; color: #cbd5e1; }
	.stat-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
	.stat { display: flex; flex-direction: column; padding: 8px; border-radius: 6px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); }
	.stat-value { font-size: 16px; font-weight: 700; color: #22d3ee; }
	.stat-label { font-size: 10px; color: #94a3b8; }
	.report { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
	.orchestration-card { padding: 8px; border-radius: 6px; background: rgba(6,182,212,0.08); border: 1px solid rgba(6,182,212,0.24); font-size: 12px; color: #a5f3fc; display: flex; flex-direction: column; gap: 3px; }
	.error, .status { margin: 0; font-size: 12px; }
	.error { color: #fca5a5; }
	.status { color: #93c5fd; }
</style>
