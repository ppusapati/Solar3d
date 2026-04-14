<script lang="ts">
	import {
		activeLayout,
		activeProject,
		activeTransmissionRoute,
		workflowState
	} from '$lib/core/stores';
	import {
		commissioningApi,
		twinApi,
		type Checklist,
		type ChecklistItem,
		type AsBuiltArtifact,
		type AssetIdentity,
		type DigitalTwin,
		type TelemetryReadingInput
	} from '$lib/core/api';
	import {
		ChecklistItemStatus,
		ChecklistSection,
		CommissioningStatus,
		AsBuiltArtifactType
	} from '$lib/core/api/commissioning';
	import { buildTwinLineageTrail, type LineageHop } from '$lib/core/domain/twinLineage';

	let checklists: Checklist[] = [];
	let artifacts: AsBuiltArtifact[] = [];
	let selectedChecklistId = '';
	let loading = false;
	let busy = false;
	let statusMsg = '';
	let errorMsg = '';

	let checklistName = 'Commissioning Checklist A';
	let operatorEmail = 'engineer@solar3d.local';
	let signoffRole = 'QA Lead';
	let signoffComment = 'All required checks completed.';
	let handoverRecipient = 'ops@solar3d.local';
	let handoverNotes = 'Handover package verified and accepted.';
	let reportText = '';

	let newItemDescription = 'Verify inverter commissioning tests and relay settings.';
	let newItemSection = ChecklistSection.ELECTRICAL;
	let newItemRequired = true;

	let artifactName = 'As-Built SLD';
	let artifactType = AsBuiltArtifactType.DRAWING;
	let artifactURL = 'https://example.local/as-built/sld-v1.pdf';
	let artifactDescription = 'Single-line diagram as commissioned';
	let artifactRevision = 'REV-A';
	let artifactFileSize = '0';

	let twin: DigitalTwin | null = null;
	let twinBusy = false;
	let twinMsg = '';
	let twinErr = '';
	let assetIdentities: AssetIdentity[] = [];
	let telemetryEvents: TelemetryReadingInput[] = [];
	let selectedTelemetryIndex = -1;
	let selectedTelemetry: TelemetryReadingInput | null = null;
	let lineageTrail: LineageHop[] = [];

	let designAssetID = '';
	let designAssetType = 'INVERTER';
	let serialNumber = '';
	let commissioningRef = 'IEC62446-LINK-1';

	let telemetrySensorID = 'INV-01';
	let telemetryMetric = 'AC_POWER_W';
	let telemetryValue = '1200';
	let telemetryUnit = 'W';
	let telemetryQuality = 'GOOD';
	let telemetryAssetIdentityID = '';

	let loadedProjectId: string | null = null;

	$: selectedChecklist = checklists.find((checklist) => checklist.id === selectedChecklistId) ?? null;

	$: if ($activeProject?.id && loadedProjectId !== $activeProject.id) {
		loadedProjectId = $activeProject.id;
		void refreshProjectData();
		loadTwinCache();
	}

	$: selectedTelemetry =
		selectedTelemetryIndex >= 0 && selectedTelemetryIndex < telemetryEvents.length
			? telemetryEvents[selectedTelemetryIndex]
			: telemetryEvents.length > 0
				? telemetryEvents[telemetryEvents.length - 1]
				: null;

	$: lineageTrail = buildTwinLineageTrail({
		telemetry: selectedTelemetry,
		identities: assetIdentities,
		artifacts,
		workflowTransitions: $workflowState.transitions
	});

	function commissioningStatusLabel(status: CommissioningStatus): string {
		switch (status) {
			case CommissioningStatus.PENDING:
				return 'Pending';
			case CommissioningStatus.IN_PROGRESS:
				return 'In Progress';
			case CommissioningStatus.COMPLETED:
				return 'Completed';
			case CommissioningStatus.SIGNED_OFF:
				return 'Signed Off';
			case CommissioningStatus.HANDED_OVER:
				return 'Handed Over';
			default:
				return 'Unspecified';
		}
	}

	function sectionLabel(section: ChecklistSection): string {
		switch (section) {
			case ChecklistSection.CIVIL:
				return 'Civil';
			case ChecklistSection.MECHANICAL:
				return 'Mechanical';
			case ChecklistSection.ELECTRICAL:
				return 'Electrical';
			case ChecklistSection.PROTECTION:
				return 'Protection';
			case ChecklistSection.SCADA:
				return 'SCADA';
			case ChecklistSection.SAFETY:
				return 'Safety';
			case ChecklistSection.DOCUMENTATION:
				return 'Documentation';
			default:
				return 'Unspecified';
		}
	}

	function itemStatusLabel(status: ChecklistItemStatus): string {
		switch (status) {
			case ChecklistItemStatus.PENDING:
				return 'Pending';
			case ChecklistItemStatus.PASS:
				return 'Pass';
			case ChecklistItemStatus.FAIL:
				return 'Fail';
			case ChecklistItemStatus.NOT_APPLICABLE:
				return 'N/A';
			default:
				return 'Unspecified';
		}
	}

	function artifactTypeLabel(kind: AsBuiltArtifactType): string {
		switch (kind) {
			case AsBuiltArtifactType.DRAWING:
				return 'Drawing';
			case AsBuiltArtifactType.REPORT:
				return 'Report';
			case AsBuiltArtifactType.SPECIFICATION:
				return 'Specification';
			case AsBuiltArtifactType.PHOTO:
				return 'Photo';
			case AsBuiltArtifactType.TEST_RECORD:
				return 'Test Record';
			case AsBuiltArtifactType.CERTIFICATE:
				return 'Certificate';
			default:
				return 'Unspecified';
		}
	}

	async function refreshProjectData() {
		if (!$activeProject?.id) return;
		loading = true;
		errorMsg = '';
		try {
			const [checklistResp, artifactResp] = await Promise.all([
				commissioningApi.listChecklists($activeProject.id),
				commissioningApi.listAsBuiltArtifacts($activeProject.id)
			]);
			checklists = checklistResp.checklists;
			artifacts = artifactResp.artifacts;
			if (!selectedChecklistId && checklists[0]) {
				selectedChecklistId = checklists[0].id;
			}
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to load commissioning data';
		} finally {
			loading = false;
		}
	}

	function twinIDStorageKey(projectID: string): string {
		return `solar3d:twin-id:${projectID}`;
	}

	function twinIdentityStorageKey(projectID: string): string {
		return `solar3d:twin-identities:${projectID}`;
	}

	function twinTelemetryStorageKey(projectID: string): string {
		return `solar3d:twin-telemetry:${projectID}`;
	}

	function hasApprovedWorkflowPhase(): boolean {
		return $workflowState.current_phase === 'APPROVED' || $workflowState.current_phase === 'COMMISSIONING_READY';
	}

	function hasSignedChecklist(): boolean {
		if (!selectedChecklist) return false;
		return (
			selectedChecklist.status === CommissioningStatus.SIGNED_OFF ||
			selectedChecklist.status === CommissioningStatus.HANDED_OVER ||
			selectedChecklist.status === CommissioningStatus.COMPLETED
		);
	}

	function canActivateTwin(): { allowed: boolean; reason: string } {
		if (!$activeProject?.id) {
			return { allowed: false, reason: 'Project is required.' };
		}
		if (!hasApprovedWorkflowPhase()) {
			return { allowed: false, reason: 'Workflow must be Approved or Commissioning Ready.' };
		}
		if (!hasSignedChecklist()) {
			return { allowed: false, reason: 'Checklist must be completed/signed off before twin activation.' };
		}
		if (artifacts.length === 0) {
			return { allowed: false, reason: 'At least one as-built artifact is required.' };
		}
		if ($workflowState.active_blockers.length > 0) {
			return { allowed: false, reason: `Workflow blocked: ${$workflowState.active_blockers[0]}` };
		}
		return { allowed: true, reason: '' };
	}

	function loadTwinCache() {
		if (!$activeProject?.id || typeof window === 'undefined') {
			return;
		}

		const identitiesRaw = window.localStorage.getItem(twinIdentityStorageKey($activeProject.id));
		if (identitiesRaw) {
			try {
				assetIdentities = JSON.parse(identitiesRaw) as AssetIdentity[];
			} catch {
				assetIdentities = [];
			}
		} else {
			assetIdentities = [];
		}

		const telemetryRaw = window.localStorage.getItem(twinTelemetryStorageKey($activeProject.id));
		if (telemetryRaw) {
			try {
				telemetryEvents = JSON.parse(telemetryRaw) as TelemetryReadingInput[];
			} catch {
				telemetryEvents = [];
			}
		} else {
			telemetryEvents = [];
		}

		const twinID = window.localStorage.getItem(twinIDStorageKey($activeProject.id));
		if (twinID) {
			void refreshTwinState(twinID);
		} else {
			twin = null;
		}
	}

	function persistTwinCache() {
		if (!$activeProject?.id || typeof window === 'undefined') {
			return;
		}
		window.localStorage.setItem(twinIdentityStorageKey($activeProject.id), JSON.stringify(assetIdentities));
		window.localStorage.setItem(twinTelemetryStorageKey($activeProject.id), JSON.stringify(telemetryEvents));
	}

	async function refreshTwinState(twinID?: string) {
		const id = twinID ?? twin?.id;
		if (!id) return;
		twinBusy = true;
		twinErr = '';
		try {
			twin = await twinApi.getTwinState(id);
		} catch (err) {
			twinErr = err instanceof Error ? err.message : 'Failed to load twin state';
		} finally {
			twinBusy = false;
		}
	}

	async function activateTwinFromApprovedRevision() {
		const gate = canActivateTwin();
		if (!gate.allowed) {
			twinErr = gate.reason;
			return;
		}
		if (!$activeProject?.id) return;

		twinBusy = true;
		twinErr = '';
		try {
			const activated = await twinApi.provisionTwin({
				project_id: $activeProject.id,
				layout_id: $activeLayout?.id,
				transmission_route_id: $activeTransmissionRoute?.id
			});
			twin = activated;
			twinMsg = 'Twin activation request accepted from approved/as-built revision context.';
			if (typeof window !== 'undefined') {
				window.localStorage.setItem(twinIDStorageKey($activeProject.id), activated.id);
			}
			await refreshTwinState(activated.id);
		} catch (err) {
			twinErr = err instanceof Error ? err.message : 'Failed to activate twin';
		} finally {
			twinBusy = false;
		}
	}

	function chooseArtifactForIdentity(artifactID: string) {
		designAssetID = artifactID;
	}

	async function linkAssetIdentityToRevision() {
		if (!twin?.id) {
			twinErr = 'Activate twin first.';
			return;
		}
		if (!designAssetID || !serialNumber.trim()) {
			twinErr = 'Design asset ID and serial number are required.';
			return;
		}
		twinBusy = true;
		twinErr = '';
		try {
			const identity = await twinApi.linkAssetIdentity(twin.id, {
				design_asset_id: designAssetID,
				design_asset_type: designAssetType,
				physical_serial_number: serialNumber.trim(),
				commissioning_ref: commissioningRef.trim()
			});
			assetIdentities = [identity, ...assetIdentities];
			telemetryAssetIdentityID = identity.id;
			persistTwinCache();
			twinMsg = 'Asset identity linked to selected design revision.';
		} catch (err) {
			twinErr = err instanceof Error ? err.message : 'Failed to link asset identity';
		} finally {
			twinBusy = false;
		}
	}

	async function ingestOperationalEvent() {
		if (!twin?.id) {
			twinErr = 'Activate twin first.';
			return;
		}
		const value = Number.parseFloat(telemetryValue);
		if (!telemetrySensorID.trim() || !Number.isFinite(value)) {
			twinErr = 'Telemetry sensor and numeric value are required.';
			return;
		}

		const reading: TelemetryReadingInput = {
			sensor_id: telemetrySensorID.trim(),
			asset_identity_id: telemetryAssetIdentityID || undefined,
			metric: telemetryMetric,
			value,
			unit: telemetryUnit,
			quality: telemetryQuality,
			recorded_at: new Date().toISOString()
		};

		twinBusy = true;
		twinErr = '';
		try {
			await twinApi.ingestTelemetry(twin.id, [reading]);
			telemetryEvents = [...telemetryEvents, reading];
			selectedTelemetryIndex = telemetryEvents.length - 1;
			persistTwinCache();
			twinMsg = 'Operational event ingested and linked into lineage.';
		} catch (err) {
			twinErr = err instanceof Error ? err.message : 'Failed to ingest telemetry';
		} finally {
			twinBusy = false;
		}
	}

	async function createChecklist() {
		if (!$activeProject?.id || !checklistName.trim()) return;
		busy = true;
		errorMsg = '';
		try {
			const resp = await commissioningApi.createChecklist({
				project_id: $activeProject.id,
				name: checklistName.trim(),
				created_by: operatorEmail
			});
			selectedChecklistId = resp.checklist.id;
			statusMsg = 'Checklist created.';
			await refreshProjectData();
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to create checklist';
		} finally {
			busy = false;
		}
	}

	async function addItem() {
		if (!selectedChecklistId || !newItemDescription.trim()) return;
		busy = true;
		errorMsg = '';
		try {
			await commissioningApi.addChecklistItem({
				checklist_id: selectedChecklistId,
				description: newItemDescription.trim(),
				section: newItemSection,
				required: newItemRequired
			});
			statusMsg = 'Checklist item added.';
			newItemDescription = '';
			await refreshProjectData();
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to add checklist item';
		} finally {
			busy = false;
		}
	}

	async function setItemStatus(item: ChecklistItem, status: ChecklistItemStatus) {
		busy = true;
		errorMsg = '';
		try {
			await commissioningApi.updateChecklistItem({
				item_id: item.id,
				status,
				completed_by: operatorEmail,
				notes: `Status set to ${itemStatusLabel(status)} by panel action`
			});
			statusMsg = `Item updated to ${itemStatusLabel(status)}.`;
			await refreshProjectData();
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to update checklist item';
		} finally {
			busy = false;
		}
	}

	async function signOffChecklist() {
		if (!selectedChecklistId) return;
		busy = true;
		errorMsg = '';
		try {
			await commissioningApi.signOffChecklist({
				checklist_id: selectedChecklistId,
				signed_by: operatorEmail,
				role: signoffRole,
				comments: signoffComment
			});
			statusMsg = 'Checklist signed off.';
			await refreshProjectData();
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to sign off checklist';
		} finally {
			busy = false;
		}
	}

	async function recordArtifact() {
		if (!$activeProject?.id || !artifactName.trim() || !artifactURL.trim()) return;
		busy = true;
		errorMsg = '';
		try {
			const size = Number.parseInt(artifactFileSize || '0', 10);
			await commissioningApi.recordAsBuilt({
				project_id: $activeProject.id,
				name: artifactName.trim(),
				artifact_type: artifactType,
				storage_url: artifactURL.trim(),
				uploaded_by: operatorEmail,
				description: artifactDescription,
				file_size_bytes: BigInt(Number.isFinite(size) && size > 0 ? size : 0),
				revision: artifactRevision
			});
			statusMsg = 'As-built artifact recorded.';
			await refreshProjectData();
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to record as-built artifact';
		} finally {
			busy = false;
		}
	}

	async function createHandover() {
		if (!$activeProject?.id || !selectedChecklistId || !handoverRecipient.trim()) return;
		busy = true;
		errorMsg = '';
		try {
			await commissioningApi.createHandover({
				project_id: $activeProject.id,
				checklist_id: selectedChecklistId,
				handed_over_by: operatorEmail,
				received_by: handoverRecipient,
				notes: handoverNotes,
				artifact_ids: artifacts.slice(0, 3).map((artifact) => artifact.id)
			});
			statusMsg = 'Handover record created.';
			await refreshProjectData();
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to create handover';
		} finally {
			busy = false;
		}
	}

	async function generateReport() {
		if (!selectedChecklistId) return;
		busy = true;
		errorMsg = '';
		try {
			const resp = await commissioningApi.generateReport(selectedChecklistId);
			reportText = resp.report_text;
			statusMsg = 'Commissioning report generated.';
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to generate report';
		} finally {
			busy = false;
		}
	}
</script>

<div class="panel">
	<h4>Commissioning</h4>
	{#if !$activeProject}
		<p class="empty">Select a project to manage commissioning.</p>
	{:else}
		{#if errorMsg}<p class="error">{errorMsg}</p>{/if}
		{#if statusMsg}<p class="status">{statusMsg}</p>{/if}
		{#if twinErr}<p class="error">{twinErr}</p>{/if}
		{#if twinMsg}<p class="status">{twinMsg}</p>{/if}

		<div class="group">
			<label><span>Checklist Name</span><input bind:value={checklistName} /></label>
			<label><span>Operator</span><input bind:value={operatorEmail} /></label>
			<div class="row">
				<button class="btn-primary" on:click={createChecklist} disabled={busy || loading}>Create Checklist</button>
				<button class="btn-secondary" on:click={() => void refreshProjectData()} disabled={busy || loading}>Refresh</button>
			</div>
		</div>

		<div class="group">
			<label>
				<span>Checklist</span>
				<select bind:value={selectedChecklistId}>
					<option value="">Select checklist</option>
					{#each checklists as checklist}
						<option value={checklist.id}>{checklist.name} ({commissioningStatusLabel(checklist.status)})</option>
					{/each}
				</select>
			</label>
			{#if selectedChecklist}
				<div class="meta-grid">
					<div>Items: {selectedChecklist.completed_items}/{selectedChecklist.total_items}</div>
					<div>Failed: {selectedChecklist.failed_items}</div>
					<div>Status: {commissioningStatusLabel(selectedChecklist.status)}</div>
				</div>
			{/if}
		</div>

		<div class="group">
			<h5>Add Checklist Item</h5>
			<label><span>Description</span><input bind:value={newItemDescription} /></label>
			<div class="cols">
				<label>
					<span>Section</span>
					<select bind:value={newItemSection}>
						<option value={ChecklistSection.CIVIL}>Civil</option>
						<option value={ChecklistSection.MECHANICAL}>Mechanical</option>
						<option value={ChecklistSection.ELECTRICAL}>Electrical</option>
						<option value={ChecklistSection.PROTECTION}>Protection</option>
						<option value={ChecklistSection.SCADA}>SCADA</option>
						<option value={ChecklistSection.SAFETY}>Safety</option>
						<option value={ChecklistSection.DOCUMENTATION}>Documentation</option>
					</select>
				</label>
				<label class="inline-check"><input type="checkbox" bind:checked={newItemRequired} /> Required</label>
			</div>
			<button class="btn-secondary" on:click={addItem} disabled={busy || !selectedChecklistId}>Add Item</button>

			{#if selectedChecklist?.items?.length}
				<div class="list">
					{#each selectedChecklist.items as item (item.id)}
						<div class="list-item">
							<div class="line-1">{item.description}</div>
							<div class="line-2">{sectionLabel(item.section)} • {itemStatusLabel(item.status)}</div>
							<div class="row">
								<button class="mini" on:click={() => setItemStatus(item, ChecklistItemStatus.PASS)} disabled={busy}>Pass</button>
								<button class="mini" on:click={() => setItemStatus(item, ChecklistItemStatus.FAIL)} disabled={busy}>Fail</button>
								<button class="mini" on:click={() => setItemStatus(item, ChecklistItemStatus.NOT_APPLICABLE)} disabled={busy}>N/A</button>
							</div>
						</div>
					{/each}
				</div>
			{/if}
		</div>

		<div class="group">
			<h5>Signoff & Handover</h5>
			<label><span>Signoff Role</span><input bind:value={signoffRole} /></label>
			<label><span>Signoff Comment</span><input bind:value={signoffComment} /></label>
			<div class="row">
				<button class="btn-secondary" on:click={signOffChecklist} disabled={busy || !selectedChecklistId}>Sign Off</button>
				<button class="btn-secondary" on:click={generateReport} disabled={busy || !selectedChecklistId}>Generate Report</button>
			</div>

			<label><span>Handover Recipient</span><input bind:value={handoverRecipient} /></label>
			<label><span>Handover Notes</span><input bind:value={handoverNotes} /></label>
			<button class="btn-secondary" on:click={createHandover} disabled={busy || !selectedChecklistId}>Create Handover</button>
		</div>

		<div class="group">
			<h5>Twin Activation</h5>
			<div class="meta-grid">
				<div>Workflow Phase: {$workflowState.current_phase.replaceAll('_', ' ')}</div>
				<div>Checklist Signed: {hasSignedChecklist() ? 'Yes' : 'No'}</div>
				<div>As-Built Artifacts: {artifacts.length}</div>
				<div>Twin State: {twin?.status || 'Not Activated'}</div>
			</div>
			<button class="btn-primary" on:click={activateTwinFromApprovedRevision} disabled={twinBusy || !canActivateTwin().allowed} title={canActivateTwin().reason}>
				{twinBusy ? 'Activating...' : 'Activate Twin From Approved Revision'}
			</button>
			{#if twin}
				<div class="meta-grid">
					<div>Twin ID: {twin.id}</div>
					<div>Health Score: {twin.operational.health_score.toFixed(2)}</div>
					<div>Availability: {twin.operational.availability_pct.toFixed(1)}%</div>
					<div>Active Faults: {twin.operational.active_fault_count}</div>
				</div>
				<button class="btn-secondary" on:click={() => void refreshTwinState()} disabled={twinBusy}>Refresh Twin State</button>
			{/if}
		</div>

		<div class="group">
			<h5>Lineage Mapping</h5>
			<label>
				<span>Design Asset Revision</span>
				<select bind:value={designAssetID}>
					<option value="">Select as-built artifact</option>
					{#each artifacts as artifact}
						<option value={artifact.id}>{artifact.name} ({artifact.revision || 'rev-na'})</option>
					{/each}
				</select>
			</label>
			{#if artifacts.length > 0}
				<div class="row">
					{#each artifacts.slice(0, 3) as artifact}
						<button class="mini" on:click={() => chooseArtifactForIdentity(artifact.id)} disabled={twinBusy}>
							Use {artifact.revision || artifact.name}
						</button>
					{/each}
				</div>
			{/if}
			<div class="cols">
				<label>
					<span>Asset Type</span>
					<select bind:value={designAssetType}>
						<option value="PANEL">Panel</option>
						<option value="INVERTER">Inverter</option>
						<option value="TRANSFORMER">Transformer</option>
						<option value="CABLE">Cable</option>
						<option value="METER">Meter</option>
						<option value="PROTECTION">Protection</option>
					</select>
				</label>
				<label>
					<span>Physical Serial</span>
					<input bind:value={serialNumber} placeholder="Serial/Tag" />
				</label>
			</div>
			<label><span>Commissioning Reference</span><input bind:value={commissioningRef} /></label>
			<button class="btn-secondary" on:click={linkAssetIdentityToRevision} disabled={twinBusy || !twin}>Link Asset Identity</button>
			{#if assetIdentities.length > 0}
				<div class="list compact">
					{#each assetIdentities as identity (identity.id)}
						<div class="list-item">
							<div class="line-1">{identity.design_asset_type} -> {identity.physical_serial_number}</div>
							<div class="line-2">Design asset: {identity.design_asset_id}</div>
						</div>
					{/each}
				</div>
			{/if}
		</div>

		<div class="group">
			<h5>Operational Event To Design Revision</h5>
			<div class="cols">
				<label><span>Sensor ID</span><input bind:value={telemetrySensorID} /></label>
				<label><span>Metric</span><input bind:value={telemetryMetric} /></label>
			</div>
			<div class="cols">
				<label><span>Value</span><input bind:value={telemetryValue} /></label>
				<label><span>Unit</span><input bind:value={telemetryUnit} /></label>
			</div>
			<div class="cols">
				<label><span>Quality</span><input bind:value={telemetryQuality} /></label>
				<label>
					<span>Linked Asset Identity</span>
					<select bind:value={telemetryAssetIdentityID}>
						<option value="">None</option>
						{#each assetIdentities as identity}
							<option value={identity.id}>{identity.design_asset_type} / {identity.physical_serial_number}</option>
						{/each}
					</select>
				</label>
			</div>
			<button class="btn-secondary" on:click={ingestOperationalEvent} disabled={twinBusy || !twin}>Ingest Operational Event</button>

			{#if telemetryEvents.length > 0}
				<label>
					<span>Select Event For Lineage Trace</span>
					<select bind:value={selectedTelemetryIndex}>
						{#each telemetryEvents as event, index}
							<option value={index}>{event.metric} {event.value} {event.unit} ({event.sensor_id})</option>
						{/each}
					</select>
				</label>
			{/if}

			<div class="lineage">
				<h6>Lineage Explorer</h6>
				{#if lineageTrail.length === 0}
					<p class="empty">No lineage path yet. Activate twin, link identity, then ingest an event.</p>
				{:else}
					{#each lineageTrail as hop, index}
						<div class="lineage-hop">
							<div class="line-1">{index + 1}. {hop.stage}</div>
							<div class="line-2">{hop.detail}</div>
							<div class="line-2">{hop.timestamp || 'timestamp unavailable'}</div>
						</div>
					{/each}
				{/if}
			</div>
		</div>

		<div class="group">
			<h5>As-Built Artifacts</h5>
			<label><span>Name</span><input bind:value={artifactName} /></label>
			<label>
				<span>Type</span>
				<select bind:value={artifactType}>
					<option value={AsBuiltArtifactType.DRAWING}>Drawing</option>
					<option value={AsBuiltArtifactType.REPORT}>Report</option>
					<option value={AsBuiltArtifactType.SPECIFICATION}>Specification</option>
					<option value={AsBuiltArtifactType.PHOTO}>Photo</option>
					<option value={AsBuiltArtifactType.TEST_RECORD}>Test Record</option>
					<option value={AsBuiltArtifactType.CERTIFICATE}>Certificate</option>
				</select>
			</label>
			<label><span>Storage URL</span><input bind:value={artifactURL} /></label>
			<label><span>Description</span><input bind:value={artifactDescription} /></label>
			<div class="cols">
				<label><span>Revision</span><input bind:value={artifactRevision} /></label>
				<label><span>File Size (bytes)</span><input bind:value={artifactFileSize} /></label>
			</div>
			<button class="btn-secondary" on:click={recordArtifact} disabled={busy}>Record Artifact</button>

			{#if artifacts.length > 0}
				<div class="list compact">
					{#each artifacts.slice(0, 5) as artifact (artifact.id)}
						<div class="list-item">
							<div class="line-1">{artifact.name}</div>
							<div class="line-2">{artifactTypeLabel(artifact.artifact_type)} • {artifact.revision || 'rev-na'}</div>
						</div>
					{/each}
				</div>
			{/if}
		</div>

		{#if reportText}
			<textarea class="report" rows="10" readonly value={reportText}></textarea>
		{/if}
	{/if}
</div>

<style>
	.panel { display: flex; flex-direction: column; gap: 8px; }
	h4 { margin: 0; font-size: 14px; color: #e2e8f0; }
	h5 { margin: 0 0 6px; font-size: 11px; text-transform: uppercase; letter-spacing: .04em; color: #94a3b8; }
	.empty, .error, .status { margin: 0; font-size: 12px; }
	.empty { color: #94a3b8; }
	.error { color: #fca5a5; }
	.status { color: #93c5fd; }
	.group { padding: 8px; border-radius: 6px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08); display: flex; flex-direction: column; gap: 6px; }
	label { display: flex; flex-direction: column; gap: 4px; font-size: 11px; color: #94a3b8; }
	input, select, textarea { width: 100%; padding: 6px 8px; border: 1px solid rgba(255,255,255,0.15); border-radius: 4px; background: rgba(0,0,0,0.3); color: #e2e8f0; font-size: 12px; }
	.row { display: flex; gap: 8px; flex-wrap: wrap; }
	.cols { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
	.inline-check { flex-direction: row; align-items: center; gap: 6px; }
	.btn-primary, .btn-secondary, .mini { padding: 7px 10px; border-radius: 6px; font-size: 12px; cursor: pointer; }
	.btn-primary { border: none; background: linear-gradient(135deg, #0ea5e9, #2563eb); color: white; font-weight: 600; }
	.btn-secondary, .mini { border: 1px solid rgba(255,255,255,0.2); background: transparent; color: #cbd5e1; }
	button:disabled { opacity: 0.6; cursor: not-allowed; }
	.list { display: flex; flex-direction: column; gap: 6px; margin-top: 4px; }
	.list.compact { max-height: 160px; overflow: auto; }
	.list-item { padding: 6px; border-radius: 6px; border: 1px solid rgba(148,163,184,0.2); background: rgba(15,23,42,0.4); }
	.line-1 { font-size: 12px; color: #e2e8f0; }
	.line-2 { font-size: 11px; color: #94a3b8; margin-top: 2px; }
	.report { font-family: ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
	.meta-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 6px; font-size: 11px; color: #cbd5e1; }
	.lineage { margin-top: 6px; border: 1px solid rgba(125,211,252,0.3); border-radius: 6px; background: rgba(14,116,144,0.12); padding: 8px; }
	h6 { margin: 0 0 6px; font-size: 11px; text-transform: uppercase; letter-spacing: .04em; color: #bae6fd; }
	.lineage-hop { border: 1px solid rgba(186,230,253,0.3); border-radius: 6px; padding: 6px; margin-bottom: 6px; background: rgba(2,6,23,0.3); }
</style>