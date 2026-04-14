<script lang="ts">
	import {
		cadWorkspace,
		cadReady,
		cadBusy,
		cadError,
		cadBlockDefinitions,
		selectedCadBlockDefinitionId,
		cadPendingMapInsertBlockId,
		createCadBlockDefinition,
		createCadLayer,
		createCadSheet,
		insertCadBlockReference,
		selectCadBlockDefinition,
		armCadMapBlockInsertion,
		disarmCadMapBlockInsertion,
		publishCadSheets,
		refreshCadWorkspace,
		cadElectricalDiagnosticsIntelligence,
		setCadDiagnosticsConfig,
		resetCadDiagnosticsConfig,
		applyCadDiagnosticsPreset,
		restoreCadDiagnosticsConfigHistoryEntry
	} from '$lib/core/stores/cad';
	import { tick } from 'svelte';
	import { activeTool } from '$lib/core/stores';
	import { snapEnabled, snapGridVisible, snapGridSizeM, snapDistanceM } from '$lib/core/stores';
	import { commandStack } from '$lib/core/stores/history';
	import { cadApi } from '$lib/core/api/cad';
	import { FileFormat, InteropMergeStrategy, PlotOutputFormat } from '$lib/gen/drawing/v1/drawing_pb.js';
	import { toast } from '$lib/core/stores';

	let layerName = 'Dimensions';
	let layerColorHex = '#f59e0b';
	let blockName = 'NorthArrow';
	let blockLabel = 'N';
	let insertX = 0;
	let insertY = 0;
	let sheetTitle = 'A1 General Arrangement';
	let sheetWidthMm = 841;
	let sheetHeightMm = 594;
	let sheetScale = 100;
	let publishFormat: PlotOutputFormat = PlotOutputFormat.PDF;
	let drawingName = '';
	let drawingDescription = '';
	let drawingMetadataJson = '{}';
	const metadataPlaceholder = '{}';
	let activeDrawingId = '';
	let selectedRevisionId = '';
	let loadedRevision: typeof $cadWorkspace.revision | null = null;
	let revisionSummary = 'Frontend snapshot';
	let revertSummary = 'Revert drawing revision from CAD workspace';
	let importSummary = 'Import drawing payload from CAD workspace';
	let importPayloadText = JSON.stringify({ importedBy: 'frontend-user', note: 'Paste Solar3D JSON payload here' }, null, 2);
	let importMergeStrategy: InteropMergeStrategy = InteropMergeStrategy.UPSERT;
	let roundTripFormat: FileFormat = FileFormat.SOLAR3D_JSON;
	let importFormat: FileFormat = FileFormat.SOLAR3D_JSON;
	let roundTripReport: any = null;
	let importReport: any = null;
	let revisionBusy = false;
	let revisionError = '';
	let simpleMode = true;
	let historyRunFilter = '';
	let selectedHistoryRunId = '';
	let tuningPenaltyPerViolation = 12;
	let tuningRecentAveragePenalty = 5;
	let tuningRegressionPenalty = 15;
	let tuningDepthPenalty = 4;
	let tuningDepthBaseline = 4;
	let tuningRegressionThreshold = 2;
	let tuningAverageWindow = 5;
	const diagnosticsConfigFieldLabels: Record<string, string> = {
		healthPenaltyPerViolation: 'Violation penalty',
		healthPenaltyRecentAverage: 'Average penalty',
		healthPenaltyRegression: 'Regression penalty',
		healthPenaltyExcessDepth: 'Depth penalty',
		depthBaseline: 'Depth baseline',
		regressionStreakThreshold: 'Regression threshold',
		averageWindowSize: 'Average window'
	};

	$: revisionEntities = $cadWorkspace.revision?.entities ?? [];
	$: blockReferenceCount = revisionEntities.filter((entity) => entity?.geometry?.case === 'blockReference').length;
	$: dimensionEntityCount = revisionEntities.filter((entity) => entity?.geometry?.case === 'dimension').length;
	$: latestPipeline = $cadWorkspace.lastMaterializationResults;
	$: pipelineHistory = $cadWorkspace.materializationHistory.slice(0, 5);
	$: electricalPipelineStage = latestPipeline.find((entry) => entry.stage === 'electrical');
	$: hasElectricalDiagnostics = Boolean(electricalPipelineStage?.metrics);
	$: electricalQualityViolations = electricalPipelineStage?.metrics?.qualityViolations ?? 0;
	$: diagnosticsIntelligence = $cadElectricalDiagnosticsIntelligence;
	$: tuningPenaltyPerViolation = $cadWorkspace.diagnosticsConfig.healthPenaltyPerViolation;
	$: tuningRecentAveragePenalty = $cadWorkspace.diagnosticsConfig.healthPenaltyRecentAverage;
	$: tuningRegressionPenalty = $cadWorkspace.diagnosticsConfig.healthPenaltyRegression;
	$: tuningDepthPenalty = $cadWorkspace.diagnosticsConfig.healthPenaltyExcessDepth;
	$: tuningDepthBaseline = $cadWorkspace.diagnosticsConfig.depthBaseline;
	$: tuningRegressionThreshold = $cadWorkspace.diagnosticsConfig.regressionStreakThreshold;
	$: tuningAverageWindow = $cadWorkspace.diagnosticsConfig.averageWindowSize;
	$: diagnosticsConfigMeta = $cadWorkspace.diagnosticsConfigMeta;
	$: diagnosticsConfigMetaTimeLabel = formatDiagnosticsTimestamp(diagnosticsConfigMeta.timestampMs);
	$: diagnosticsConfigSourceLabel = formatDiagnosticsSource(diagnosticsConfigMeta.source);
	$: diagnosticsConfigAuditRows = $cadWorkspace.diagnosticsConfigHistory.slice(0, 5).map((entry) => ({
		...entry,
		timeLabel: formatDiagnosticsTimestamp(entry.timestampMs),
		sourceLabel: formatDiagnosticsSource(entry.source),
		changedFieldSummary: entry.changedFields.length === 0
			? 'No value changes'
			: entry.changedFields.map((field) => diagnosticsConfigFieldLabels[field] ?? field).join(', ')
	}));
	$: normalizedHistoryFilter = historyRunFilter.trim().toLowerCase();
	$: electricalHistoryRows = pipelineHistory.map((run, index) => {
		const electrical = run.results.find((entry) => entry.stage === 'electrical');
		const violations = electrical?.metrics?.qualityViolations ?? 0;
		const prev = pipelineHistory[index + 1]?.results.find((entry) => entry.stage === 'electrical');
		const prevViolations = prev?.metrics?.qualityViolations ?? 0;
		return {
			runId: run.runId,
			timeLabel: new Date(run.timestampMs).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', second: '2-digit' }),
			violations,
			delta: index + 1 < pipelineHistory.length ? violations - prevViolations : 0,
			nodes: electrical?.metrics?.topologyNodeCount ?? 0,
			depth: electrical?.metrics?.topologyDepth ?? 0
		};
	});
	$: filteredElectricalHistoryRows = normalizedHistoryFilter.length === 0
		? electricalHistoryRows
		: electricalHistoryRows.filter((row) => row.runId.toLowerCase().includes(normalizedHistoryFilter));
	$: if (!selectedHistoryRunId && filteredElectricalHistoryRows.length > 0) {
		selectedHistoryRunId = filteredElectricalHistoryRows[0].runId;
	}
	$: if (selectedHistoryRunId && filteredElectricalHistoryRows.every((row) => row.runId !== selectedHistoryRunId)) {
		selectedHistoryRunId = filteredElectricalHistoryRows[0]?.runId ?? '';
	}
	$: selectedHistoryRun = $cadWorkspace.materializationHistory.find((run) => run.runId === selectedHistoryRunId) ?? null;
	$: selectedHistoryStages = selectedHistoryRun?.results ?? [];
	$: regressionStreak = (() => {
		let streak = 0;
		for (const row of filteredElectricalHistoryRows) {
			if (row.delta > 0) {
				streak += 1;
			} else {
				break;
			}
		}
		return streak;
	})();
	$: hasRegressionAlert = regressionStreak >= tuningRegressionThreshold;
	$: regressionMessage = hasRegressionAlert
		? `Quality regression detected: violations increased for ${regressionStreak} consecutive runs (threshold ${tuningRegressionThreshold})`
		: 'No sustained regression trend detected';
	$: sparkValues = filteredElectricalHistoryRows.slice().reverse().map((row) => row.violations);
	$: sparklinePoints = (() => {
		if (sparkValues.length <= 1) return '';
		const width = 140;
		const height = 34;
		const maxValue = Math.max(...sparkValues, 1);
		return sparkValues
			.map((value, idx) => {
				const x = (idx / (sparkValues.length - 1)) * width;
				const y = height - (value / maxValue) * height;
				return `${x.toFixed(1)},${y.toFixed(1)}`;
			})
			.join(' ');
	})();

	function downloadTextFile(fileName: string, content: string, contentType: string) {
		if (typeof window === 'undefined') return;
		const blob = new Blob([content], { type: contentType });
		const url = URL.createObjectURL(blob);
		const anchor = document.createElement('a');
		anchor.href = url;
		anchor.download = fileName;
		document.body.appendChild(anchor);
		anchor.click();
		document.body.removeChild(anchor);
		URL.revokeObjectURL(url);
	}

	function formatDiagnosticsTimestamp(timestampMs: number) {
		return new Date(timestampMs).toLocaleString([], {
			year: 'numeric',
			month: 'short',
			day: '2-digit',
			hour: '2-digit',
			minute: '2-digit',
			second: '2-digit'
		});
	}

	function formatDiagnosticsSource(source: string) {
		switch (source) {
			case 'manual':
				return 'Manual tuning';
			case 'preset-balanced':
				return 'Balanced preset';
			case 'preset-strict':
				return 'Strict preset';
			case 'preset-lenient':
				return 'Lenient preset';
			case 'reset':
				return 'Reset defaults';
			default:
				return source;
		}
	}

	function exportDiagnosticsHistoryJson() {
		const payload = {
			exportedAt: new Date().toISOString(),
			runs: $cadWorkspace.materializationHistory
		};
		downloadTextFile(
			`electrical-diagnostics-history-${Date.now()}.json`,
			JSON.stringify(payload, null, 2),
			'application/json'
		);
		toast.success('Diagnostics history exported as JSON');
	}

	function exportDiagnosticsHistoryCsv() {
		const rows = $cadWorkspace.materializationHistory.map((run) => {
			const electrical = run.results.find((entry) => entry.stage === 'electrical');
			return {
				runId: run.runId,
				timestamp: new Date(run.timestampMs).toISOString(),
				inputFingerprint: run.inputFingerprint,
				status: electrical?.status ?? 'skipped',
				qualityViolations: electrical?.metrics?.qualityViolations ?? 0,
				topologyNodeCount: electrical?.metrics?.topologyNodeCount ?? 0,
				topologyDepth: electrical?.metrics?.topologyDepth ?? 0,
				topologyRelationshipCount: electrical?.metrics?.topologyRelationshipCount ?? 0,
				inputCount: electrical?.metrics?.inputCount ?? 0,
				outputHint: electrical?.metrics?.outputHint ?? 0
			};
		});
		const header = [
			'runId',
			'timestamp',
			'inputFingerprint',
			'status',
			'qualityViolations',
			'topologyNodeCount',
			'topologyDepth',
			'topologyRelationshipCount',
			'inputCount',
			'outputHint'
		];
		const lines = [
			header.join(','),
			...rows.map((row) =>
				header
					.map((key) => {
						const raw = String((row as Record<string, unknown>)[key] ?? '');
						return `"${raw.replace(/"/g, '""')}"`;
					})
					.join(',')
			)
		];
		downloadTextFile(`electrical-diagnostics-history-${Date.now()}.csv`, lines.join('\n'), 'text/csv;charset=utf-8');
		toast.success('Diagnostics history exported as CSV');
	}

	function exportDiagnosticsConfigAuditJson() {
		const payload = {
			exportedAt: new Date().toISOString(),
			activeConfig: $cadWorkspace.diagnosticsConfig,
			meta: $cadWorkspace.diagnosticsConfigMeta,
			history: $cadWorkspace.diagnosticsConfigHistory
		};
		downloadTextFile(
			`electrical-diagnostics-config-audit-${Date.now()}.json`,
			JSON.stringify(payload, null, 2),
			'application/json'
		);
		toast.success('Diagnostics config audit exported as JSON');
	}

	function applyDiagnosticsTuning() {
		setCadDiagnosticsConfig({
			healthPenaltyPerViolation: tuningPenaltyPerViolation,
			healthPenaltyRecentAverage: tuningRecentAveragePenalty,
			healthPenaltyRegression: tuningRegressionPenalty,
			healthPenaltyExcessDepth: tuningDepthPenalty,
			depthBaseline: tuningDepthBaseline,
			regressionStreakThreshold: tuningRegressionThreshold,
			averageWindowSize: tuningAverageWindow
		});
		toast.success('Diagnostics tuning updated');
	}

	function applyDiagnosticsPreset(preset: 'balanced' | 'strict' | 'lenient') {
		applyCadDiagnosticsPreset(preset);
		toast.success(`Applied ${preset} diagnostics preset`);
	}

	function resetDiagnosticsTuning() {
		resetCadDiagnosticsConfig();
		toast.success('Diagnostics tuning reset to defaults');
	}

	function restoreDiagnosticsAuditEntry(entryId: string) {
		restoreCadDiagnosticsConfigHistoryEntry(entryId);
		toast.success('Diagnostics tuning restored from audit history');
	}

	$: if ($cadWorkspace.drawing?.drawingId && $cadWorkspace.drawing.drawingId !== activeDrawingId) {
		activeDrawingId = $cadWorkspace.drawing.drawingId;
		drawingName = $cadWorkspace.drawing.name;
		drawingDescription = $cadWorkspace.drawing.description;
		drawingMetadataJson = $cadWorkspace.drawing.metadataJson || '{}';
	}

	$: if (!selectedRevisionId && $cadWorkspace.revisions.length > 0) {
		selectedRevisionId = $cadWorkspace.revision?.pointer?.revisionId ?? $cadWorkspace.revisions[0].revisionId;
	}

	async function handleCreateLayer() {
		await createCadLayer({
			name: layerName.trim(),
			colorHex: layerColorHex,
			lineType: 'CONTINUOUS',
			lineWeightMm: 0.25,
			visible: true,
			locked: false,
			plottable: true
		});
		if (!$cadError) {
			toast.success(`Layer ${layerName} updated`);
		}
	}

	async function handleCreateBlockDefinition() {
		await createCadBlockDefinition({ name: blockName.trim(), label: blockLabel.trim() || 'BLOCK' });
		if (!$cadError) {
			await tick();
			if ($selectedCadBlockDefinitionId) {
				armCadMapBlockInsertion($selectedCadBlockDefinitionId);
				activeTool.set('insert-block');
				toast.success(`Block ${blockName} definition created. Click on map to place it.`);
			} else {
				toast.success(`Block ${blockName} definition created`);
			}
		}
	}

	async function handleInsertBlock() {
		if (!$selectedCadBlockDefinitionId) {
			toast.error('Block definition ID is required');
			return;
		}
		await insertCadBlockReference({
			blockDefinitionId: $selectedCadBlockDefinitionId,
			x: Number(insertX),
			y: Number(insertY)
		});
		if (!$cadError) {
			toast.success('Block reference inserted');
		}
	}

	function handleBlockSelection(event: Event) {
		const value = (event.currentTarget as HTMLSelectElement).value;
		selectCadBlockDefinition(value);
	}

	function handleStartMapPlacement() {
		armCadMapBlockInsertion($selectedCadBlockDefinitionId);
		if (!$cadError) {
			activeTool.set('insert-block');
			toast.info('Click the map to place the selected block definition');
		}
	}

	function handleStopMapPlacement() {
		disarmCadMapBlockInsertion();
		if ($activeTool === 'insert-block') {
			activeTool.set('select');
		}
	}

	async function handleCreateSheet() {
		await createCadSheet({
			title: sheetTitle.trim(),
			widthMm: Number(sheetWidthMm),
			heightMm: Number(sheetHeightMm),
			viewScale: Number(sheetScale)
		});
		if (!$cadError) {
			toast.success(`Sheet ${sheetTitle} created`);
		}
	}

	async function handlePublish() {
		await publishCadSheets(publishFormat);
		if (!$cadError) {
			toast.success('Publish artifacts generated');
		}
	}

	function formatBytes(bytes: number): string {
		if (bytes < 1024) return `${bytes} B`;
		if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`;
		return `${(bytes / (1024 * 1024)).toFixed(2)} MB`;
	}

	function encodePayload(text: string): string {
		const bytes = new TextEncoder().encode(text);
		let binary = '';
		for (const byte of bytes) {
			binary += String.fromCharCode(byte);
		}
		return btoa(binary);
	}

	async function runRevisionAction(action: () => Promise<void>) {
		revisionBusy = true;
		revisionError = '';
		try {
			await action();
		} catch (error: unknown) {
			revisionError = error instanceof Error ? error.message : 'CAD advanced workflow failed';
		} finally {
			revisionBusy = false;
		}
	}

	async function handleReloadDrawing() {
		if (!$cadWorkspace.drawing) return;
		await runRevisionAction(async () => {
			const drawing = await cadApi.getDrawing($cadWorkspace.drawing!.drawingId);
			drawingName = drawing.name;
			drawingDescription = drawing.description;
			drawingMetadataJson = drawing.metadataJson || '{}';
			toast.success('Drawing metadata reloaded');
		});
	}

	async function handleUpdateDrawing() {
		if (!$cadWorkspace.drawing) return;
		await runRevisionAction(async () => {
			JSON.parse(drawingMetadataJson);
			await cadApi.updateDrawing({
				drawingId: $cadWorkspace.drawing!.drawingId,
				name: drawingName.trim(),
				description: drawingDescription.trim(),
				metadataJson: drawingMetadataJson,
				status: $cadWorkspace.drawing!.status
			});
			await refreshCadWorkspace();
			toast.success('Drawing metadata updated');
		});
	}

	async function handleLoadRevision() {
		if (!$cadWorkspace.drawing || !selectedRevisionId) return;
		await runRevisionAction(async () => {
			const context = await cadApi.getDrawingRevision($cadWorkspace.drawing!.drawingId, selectedRevisionId);
			loadedRevision = context.revision;
			toast.success(`Loaded revision ${selectedRevisionId}`);
		});
	}

	async function handleSnapshotRevision() {
		if (!$cadWorkspace.drawing || !$cadWorkspace.revision) return;
		await runRevisionAction(async () => {
			await cadApi.storeDrawingRevision({
				drawingId: $cadWorkspace.drawing!.drawingId,
				summary: revisionSummary.trim() || 'Frontend snapshot',
				commandId: `frontend-snapshot-${Date.now()}`,
				entities: $cadWorkspace.revision!.entities
			});
			await refreshCadWorkspace();
			toast.success('Revision snapshot stored');
		});
	}

	async function handleRevertRevision() {
		if (!$cadWorkspace.drawing || !selectedRevisionId) return;
		await runRevisionAction(async () => {
			await cadApi.revertDrawingRevision({
				drawingId: $cadWorkspace.drawing!.drawingId,
				targetRevisionId: selectedRevisionId,
				summary: revertSummary.trim() || 'Revert drawing revision'
			});
			await refreshCadWorkspace();
			toast.success(`Reverted drawing to ${selectedRevisionId}`);
		});
	}

	async function handleValidateRoundTrip() {
		if (!$cadWorkspace.drawing || !$cadWorkspace.revision) return;
		await runRevisionAction(async () => {
			roundTripReport = await cadApi.validateDrawingRoundTrip({
				drawingId: $cadWorkspace.drawing!.drawingId,
				revision: $cadWorkspace.revision!,
				format: roundTripFormat
			});
			toast.success('Round-trip validation completed');
		});
	}

	async function handleImportDrawing() {
		if (!$cadWorkspace.drawing || !$cadWorkspace.revision) return;
		await runRevisionAction(async () => {
			const parsed = JSON.parse(importPayloadText);
			const imported = await cadApi.importDrawing({
				drawingId: $cadWorkspace.drawing!.drawingId,
				revision: $cadWorkspace.revision!,
				format: importFormat,
				mergeStrategy: importMergeStrategy,
				payload: encodePayload(JSON.stringify(parsed)),
				summary: importSummary.trim() || 'Import drawing payload'
			});
			importReport = imported.report;
			await refreshCadWorkspace();
			toast.success('Drawing import completed');
		});
	}
</script>

<div class="cad-workspace">
	<div class="cad-header">
		<h4>CAD Workspace</h4>
		<div class="header-actions">
			<button class="secondary-btn compact-btn" on:click={() => (simpleMode = !simpleMode)} title="Toggle simplified CAD workspace layout.">
				{simpleMode ? 'Full Mode' : 'Simple Mode'}
			</button>
			<button class="refresh-btn" on:click={refreshCadWorkspace} disabled={$cadBusy} title="Reload workspace state, drawing revision, and artifacts from backend.">Refresh</button>
		</div>
	</div>

	{#if !$cadReady}
		<p class="empty-state">CAD workspace is initializing for this project.</p>
	{:else}
		<div class="section">
			<div class="meta-row"><span>Drawing</span><strong>{$cadWorkspace.drawing?.name}</strong></div>
			<div class="meta-row"><span>Revision</span><strong>{$cadWorkspace.revision?.pointer?.revisionId}</strong></div>
			<div class="meta-row"><span>Placed CAD Blocks</span><strong>{blockReferenceCount}</strong></div>
			<div class="meta-row"><span>CAD Dimensions</span><strong>{dimensionEntityCount}</strong></div>
			<p class="field-help">Current drawing identity and active revision pointer.</p>
		</div>

		<div class="section">
			<h5>Electrical Diagnostics</h5>
			{#if hasElectricalDiagnostics}
				<div class="meta-row"><span>Status</span><strong class:diagnostic-ok={electricalQualityViolations === 0} class:diagnostic-warn={electricalQualityViolations > 0}>{electricalQualityViolations === 0 ? 'PASS' : 'WARN'}</strong></div>
				<div class="meta-row"><span>Health Score</span><strong>{diagnosticsIntelligence.healthScore}/100</strong></div>
				<div class="meta-row"><span>Trend</span><strong class:trend-up={diagnosticsIntelligence.trend === 'declining'} class:trend-down={diagnosticsIntelligence.trend === 'improving'}>{diagnosticsIntelligence.trend}</strong></div>
				<div class="meta-row"><span>Avg Violations (5 runs)</span><strong>{diagnosticsIntelligence.recentAverageViolations}</strong></div>
				<div class="meta-row"><span>Segments</span><strong>{electricalPipelineStage?.metrics?.inputCount ?? 0}</strong></div>
				<div class="meta-row"><span>Topology Nodes</span><strong>{electricalPipelineStage?.metrics?.topologyNodeCount ?? 0}</strong></div>
				<div class="meta-row"><span>Topology Depth</span><strong>{electricalPipelineStage?.metrics?.topologyDepth ?? 0}</strong></div>
				<div class="meta-row"><span>Relationships</span><strong>{electricalPipelineStage?.metrics?.topologyRelationshipCount ?? 0}</strong></div>
				<div class="meta-row"><span>Quality Violations</span><strong>{electricalQualityViolations}</strong></div>
				<div class="meta-row"><span>Config Source</span><strong class="diag-source-pill">{diagnosticsConfigSourceLabel}</strong></div>
				<div class="meta-row"><span>Config Applied</span><strong>{diagnosticsConfigMetaTimeLabel}</strong></div>
				<p class="field-help">{electricalPipelineStage?.message}</p>
				<div class="diag-reco-box">
					<div class="diag-reco-title">Recommendations</div>
					<ul class="diag-reco-list">
						{#each diagnosticsIntelligence.recommendations as recommendation}
							<li>{recommendation}</li>
						{/each}
					</ul>
				</div>
				<details class="diag-drawer">
					<summary>Diagnostics Tuning</summary>
					<div class="diag-tuning-presets">
						<button class="secondary-btn" on:click={() => applyDiagnosticsPreset('balanced')} disabled={$cadBusy}>Balanced</button>
						<button class="secondary-btn" on:click={() => applyDiagnosticsPreset('strict')} disabled={$cadBusy}>Strict</button>
						<button class="secondary-btn" on:click={() => applyDiagnosticsPreset('lenient')} disabled={$cadBusy}>Lenient</button>
						<button class="secondary-btn" on:click={resetDiagnosticsTuning} disabled={$cadBusy}>Reset Defaults</button>
					</div>
					<div class="diag-config-summary">
						<div class="diag-config-summary-head">
							<div>
								<div class="diag-reco-title">Current Provenance</div>
								<p class="field-help diag-config-summary-copy">{diagnosticsConfigMeta.summary}</p>
							</div>
							<button class="secondary-btn" on:click={exportDiagnosticsConfigAuditJson} disabled={$cadBusy}>Export Audit</button>
						</div>
						<div class="meta-row"><span>Source</span><strong class="diag-source-pill">{diagnosticsConfigSourceLabel}</strong></div>
						<div class="meta-row"><span>Applied</span><strong>{diagnosticsConfigMetaTimeLabel}</strong></div>
					</div>
					{#if diagnosticsConfigAuditRows.length > 0}
						<div class="diag-config-audit-list">
							<div class="diag-reco-title">Recent Config Changes</div>
							{#each diagnosticsConfigAuditRows as entry}
								<div class="diag-config-audit-item">
									<div class="diag-config-audit-row">
										<strong>{entry.sourceLabel}</strong>
										<span>{entry.timeLabel}</span>
									</div>
									<div class="diag-config-audit-row diag-config-audit-copy">
										<span>{entry.summary}</span>
										<button class="secondary-btn" on:click={() => restoreDiagnosticsAuditEntry(entry.entryId)} disabled={$cadBusy}>Restore</button>
									</div>
									<div class="diag-config-fields">{entry.changedFieldSummary}</div>
								</div>
							{/each}
						</div>
					{/if}
					<div class="diag-tuning-grid">
						<label>Violation Penalty
							<input type="number" min="1" max="50" bind:value={tuningPenaltyPerViolation} />
						</label>
						<label>Average Penalty
							<input type="number" min="0" max="25" bind:value={tuningRecentAveragePenalty} />
						</label>
						<label>Regression Penalty
							<input type="number" min="0" max="40" bind:value={tuningRegressionPenalty} />
						</label>
						<label>Depth Penalty
							<input type="number" min="0" max="20" bind:value={tuningDepthPenalty} />
						</label>
						<label>Depth Baseline
							<input type="number" min="1" max="12" bind:value={tuningDepthBaseline} />
						</label>
						<label>Regression Threshold
							<input type="number" min="1" max="5" bind:value={tuningRegressionThreshold} />
						</label>
						<label>Average Window
							<input type="number" min="1" max="12" bind:value={tuningAverageWindow} />
						</label>
					</div>
					<button class="secondary-btn" on:click={applyDiagnosticsTuning} disabled={$cadBusy}>Apply Tuning</button>
				</details>
			{:else}
				<p class="empty-state">No pipeline diagnostics yet. Run materialization pipeline to populate metrics.</p>
			{/if}
			{#if electricalHistoryRows.length > 0}
				<div class="diag-history-wrap">
					<div class="diag-history-title">Recent Runs (latest 5)</div>
					<div class="diag-regression-row">
						<span class:diag-alert-active={hasRegressionAlert} class:diag-alert-clear={!hasRegressionAlert}>{hasRegressionAlert ? 'REGRESSION ALERT' : 'Regression Clear'}</span>
						<span>{regressionMessage}</span>
					</div>
					<div class="diag-history-toolbar">
						<input class="diag-filter" bind:value={historyRunFilter} placeholder="Filter run id..." title="Filter recent runs by run id" />
						<div class="diag-export-actions">
							<button class="secondary-btn" on:click={exportDiagnosticsHistoryJson} disabled={$cadBusy} title="Download diagnostics history as JSON">Export JSON</button>
							<button class="secondary-btn" on:click={exportDiagnosticsHistoryCsv} disabled={$cadBusy} title="Download diagnostics history as CSV">Export CSV</button>
						</div>
						{#if sparklinePoints}
							<div class="diag-sparkline-wrap" title="Quality violations trend (oldest to newest)">
								<svg viewBox="0 0 140 34" class="diag-sparkline" aria-label="Quality violations sparkline">
									<polyline points={sparklinePoints} fill="none" stroke="#f59e0b" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" />
								</svg>
							</div>
						{/if}
					</div>
					<table class="diag-history-table">
						<thead>
							<tr>
								<th>Run</th>
								<th>Time</th>
								<th>Violations</th>
								<th>Delta</th>
								<th>Nodes</th>
								<th>Depth</th>
							</tr>
						</thead>
						<tbody>
							{#each filteredElectricalHistoryRows as row}
								<tr>
									<td>{row.runId}</td>
									<td>{row.timeLabel}</td>
									<td>{row.violations}</td>
									<td class:trend-up={row.delta > 0} class:trend-down={row.delta < 0}>{row.delta > 0 ? `+${row.delta}` : row.delta}</td>
									<td>{row.nodes}</td>
									<td>{row.depth}</td>
								</tr>
							{/each}
						</tbody>
					</table>
					{#if filteredElectricalHistoryRows.length === 0}
						<p class="empty-state mt8">No runs match current filter.</p>
					{/if}

					<details class="diag-drawer" open>
						<summary>Run Detail Drawer</summary>
						{#if filteredElectricalHistoryRows.length > 0}
							<div class="diag-drawer-controls">
								<select bind:value={selectedHistoryRunId}>
									{#each filteredElectricalHistoryRows as row}
										<option value={row.runId}>{row.runId} ({row.timeLabel})</option>
									{/each}
								</select>
							</div>
							{#if selectedHistoryRun}
								<div class="diag-drawer-meta">
									<span>Run: {selectedHistoryRun.runId}</span>
									<span>Fingerprint: {selectedHistoryRun.inputFingerprint || 'n/a'}</span>
								</div>
								<table class="diag-detail-table">
									<thead>
										<tr>
											<th>Stage</th>
											<th>Status</th>
											<th>Input</th>
											<th>Output</th>
											<th>Violations</th>
										</tr>
									</thead>
									<tbody>
										{#each selectedHistoryStages as stage}
											<tr>
												<td>{stage.stage}</td>
												<td>{stage.status}</td>
												<td>{stage.metrics?.inputCount ?? 0}</td>
												<td>{stage.metrics?.outputHint ?? 0}</td>
												<td>{stage.metrics?.qualityViolations ?? 0}</td>
											</tr>
										{/each}
									</tbody>
								</table>
							{/if}
						{/if}
					</details>
				</div>
			{/if}
		</div>

		<div class="section">
			<h5>Quick Start</h5>
			<ol class="quick-start">
				<li>Create a block definition (name + short label).</li>
				<li>Select the block and click Place On Map.</li>
				<li>Click the map to insert. Counter above should increase.</li>
			</ol>
			<p class="field-help">If counter increases but marker is not visible, click Refresh and zoom into the inserted coordinates.</p>
		</div>

		{#if !simpleMode}
		<div class="section">
			<h5>Drawing Metadata</h5>
			<p class="field-help">Update drawing name, description, and custom JSON metadata used by downstream workflows.</p>
			<div class="form-grid">
				<input bind:value={drawingName} placeholder="Drawing name" title="Human-readable drawing name shown across CAD workspace views." />
				<input bind:value={drawingDescription} placeholder="Drawing description" title="Short description for this drawing revision context." />
			</div>
			<textarea rows="4" bind:value={drawingMetadataJson} placeholder={metadataPlaceholder} title="Arbitrary JSON metadata persisted with the drawing."></textarea>
			<div class="publish-row">
				<button class="secondary-btn" on:click={handleReloadDrawing} disabled={$cadBusy || revisionBusy} title="Discard local edits and reload metadata from backend.">Reload Metadata</button>
				<button on:click={handleUpdateDrawing} disabled={$cadBusy || revisionBusy || !drawingName.trim()} title="Persist metadata changes to the active drawing.">Save Metadata</button>
			</div>
		</div>

		<div class="section">
			<h5>Command Stack</h5>
			<p class="field-help">Recent CAD/map actions for quick audit and undo context.</p>
			{#if $commandStack.length === 0}
				<p class="empty-state">No commands recorded yet.</p>
			{:else}
				<ul class="command-list">
					{#each [...$commandStack].reverse().slice(0, 12) as action}
						<li><span class="cmd-type">{action.type}</span><span class="cmd-desc">{action.description}</span></li>
					{/each}
				</ul>
			{/if}
		</div>

		<div class="section">
			<h5>Snapping</h5>
			<p class="field-help">Controls precision placement behavior for CAD insertion and map edits.</p>
			<div class="snap-grid">
				<label class="toggle"><input type="checkbox" bind:checked={$snapEnabled} title="Snap cursor and inserts to nearby alignment targets." /> Enable snapping</label>
				<label class="toggle"><input type="checkbox" bind:checked={$snapGridVisible} title="Display visual grid overlay in map view." /> Show snap grid</label>
				<label>Grid size (m)
					<input type="number" min="0.5" step="0.5" bind:value={$snapGridSizeM} title="Distance between grid lines in meters." />
				</label>
				<label>Snap distance (m)
					<input type="number" min="0.25" step="0.25" bind:value={$snapDistanceM} title="Capture radius used to attract points to grid/entities." />
				</label>
			</div>
		</div>

		<div class="section">
			<h5>Layers</h5>
			<p class="field-help">Create or update CAD layers for styling and visibility control.</p>
			<div class="form-grid">
				<input bind:value={layerName} placeholder="Layer name" title="Layer identifier (create or update by name)." />
				<input bind:value={layerColorHex} placeholder="#f59e0b" title="Layer color in hex format, e.g. #f59e0b." />
			</div>
			<button on:click={handleCreateLayer} disabled={$cadBusy || !layerName.trim()} title="Create layer if missing, otherwise update existing layer.">Upsert Layer</button>
		</div>
		{/if}

		<div class="section">
			<h5>Blocks</h5>
			<p class="field-help">Define reusable CAD symbols and insert them by map click or XY coordinates.</p>
			<p class="field-help">Note: Creating a definition does not draw on map until you place a block reference.</p>
			<div class="form-grid">
				<input bind:value={blockName} placeholder="Block name" title="Unique name for this reusable block definition." />
				<input bind:value={blockLabel} placeholder="Label" title="Short visual label stored with the block definition." />
			</div>
			<button on:click={handleCreateBlockDefinition} disabled={$cadBusy || !blockName.trim()} title="Register a new reusable block definition.">Create Definition</button>
			{#if $cadBlockDefinitions.length === 0}
				<p class="empty-state mt8">Create a block definition to enable map or coordinate insertion.</p>
			{:else}
				<div class="form-grid mt8 block-select-grid">
					<select value={$selectedCadBlockDefinitionId} on:change={handleBlockSelection}>
						{#each $cadBlockDefinitions as block}
							<option value={block.blockDefinitionId}>{block.name} ({block.blockDefinitionId})</option>
						{/each}
					</select>
					<button class="secondary-btn" on:click={handleStartMapPlacement} disabled={$cadBusy || !$selectedCadBlockDefinitionId} title="Arm map click placement for the selected block.">
						{$cadPendingMapInsertBlockId ? 'Placement Armed' : 'Place On Map'}
					</button>
				</div>
				{#if $cadPendingMapInsertBlockId}
					<div class="status-note">
						<span>Map placement is armed for {$cadPendingMapInsertBlockId}.</span>
						<button class="text-btn" on:click={handleStopMapPlacement}>Stop</button>
					</div>
				{/if}
				<div class="form-grid mt8">
					<input type="number" bind:value={insertX} placeholder="Insert X" />
					<input type="number" bind:value={insertY} placeholder="Insert Y" />
				</div>
				<button on:click={handleInsertBlock} disabled={$cadBusy || !$selectedCadBlockDefinitionId} title="Insert block at the X/Y coordinates above.">Insert By Coordinates</button>
			{/if}
		</div>

		{#if !simpleMode}
		<div class="section">
			<h5>Sheet Workspace</h5>
			<p class="field-help">Prepare drawing sheet geometry and publish PDF/SVG outputs.</p>
			<div class="form-grid">
				<input bind:value={sheetTitle} placeholder="Sheet title" />
				<input type="number" bind:value={sheetWidthMm} placeholder="Width mm" />
				<input type="number" bind:value={sheetHeightMm} placeholder="Height mm" />
				<input type="number" bind:value={sheetScale} placeholder="Scale" />
			</div>
			<button on:click={handleCreateSheet} disabled={$cadBusy || !sheetTitle.trim()} title="Create a sheet definition with the provided size and scale.">Create Sheet</button>
			<div class="publish-row">
				<select bind:value={publishFormat}>
					<option value={PlotOutputFormat.PDF}>PDF</option>
					<option value={PlotOutputFormat.SVG}>SVG</option>
				</select>
				<button on:click={handlePublish} disabled={$cadBusy} title="Generate publish artifacts for the selected format.">Publish Drawing</button>
			</div>
		</div>
		{/if}

		{#if !simpleMode}
		<div class="section">
			<h5>Advanced Revision Workflows</h5>
			{#if $cadWorkspace.revisions.length === 0}
				<p class="empty-state">No revisions available yet.</p>
			{:else}
				<div class="form-grid block-select-grid">
					<select bind:value={selectedRevisionId}>
						{#each $cadWorkspace.revisions as revision}
							<option value={revision.revisionId}>{revision.revisionId} ({revision.summary || 'No summary'})</option>
						{/each}
					</select>
					<button class="secondary-btn" on:click={handleLoadRevision} disabled={$cadBusy || revisionBusy || !selectedRevisionId}>Inspect Revision</button>
				</div>
			{/if}
			<input bind:value={revisionSummary} placeholder="Snapshot summary" />
			<div class="publish-row">
				<button on:click={handleSnapshotRevision} disabled={$cadBusy || revisionBusy || !$cadWorkspace.revision}>Store Snapshot</button>
			</div>
			<input bind:value={revertSummary} placeholder="Revert summary" />
			<div class="publish-row">
				<button class="secondary-btn" on:click={handleRevertRevision} disabled={$cadBusy || revisionBusy || !selectedRevisionId}>Revert To Revision</button>
			</div>
			<div class="publish-row">
				<select bind:value={roundTripFormat}>
					<option value={FileFormat.SOLAR3D_JSON}>Solar3D JSON</option>
					<option value={FileFormat.DXF_ASCII}>DXF ASCII</option>
				</select>
				<button class="secondary-btn" on:click={handleValidateRoundTrip} disabled={$cadBusy || revisionBusy || !$cadWorkspace.revision}>Validate Round Trip</button>
			</div>
			<input bind:value={importSummary} placeholder="Import summary" />
			<div class="publish-row">
				<select bind:value={importFormat}>
					<option value={FileFormat.SOLAR3D_JSON}>Solar3D JSON</option>
					<option value={FileFormat.DXF_ASCII}>DXF ASCII</option>
				</select>
				<select bind:value={importMergeStrategy}>
					<option value={InteropMergeStrategy.REPLACE}>Replace</option>
					<option value={InteropMergeStrategy.APPEND}>Append</option>
					<option value={InteropMergeStrategy.UPSERT}>Upsert</option>
				</select>
			</div>
			<textarea rows="5" bind:value={importPayloadText}></textarea>
			<button on:click={handleImportDrawing} disabled={$cadBusy || revisionBusy || !importPayloadText.trim()}>Import Drawing Payload</button>

			{#if loadedRevision}
				<div class="status-note stacked">
					<span>Loaded revision: {loadedRevision.pointer?.revisionId}</span>
					<span>Entities: {loadedRevision.entities?.length ?? 0}</span>
					<span>Summary: {loadedRevision.pointer?.summary || '—'}</span>
				</div>
			{/if}
			{#if roundTripReport}
				<div class="status-note stacked">
					<span>Round-trip source entities: {roundTripReport.sourceEntityCount}</span>
					<span>Output entities: {roundTripReport.outputEntityCount}</span>
					<span>Matched entities: {roundTripReport.matchedEntityCount}</span>
				</div>
			{/if}
			{#if importReport}
				<div class="status-note stacked">
					<span>Imported source entities: {importReport.sourceEntityCount}</span>
					<span>Output entities: {importReport.outputEntityCount}</span>
					<span>Matched entities: {importReport.matchedEntityCount}</span>
				</div>
			{/if}
		</div>
		{/if}

		{#if $cadWorkspace.publishArtifacts.length > 0}
			<div class="section">
				<h5>Publish Artifacts</h5>
				<ul class="artifact-list">
					{#each $cadWorkspace.publishArtifacts as artifact}
						<li>
							<span>{artifact.fileName}</span>
							<span>{artifact.contentType}</span>
							<span>{formatBytes(artifact.payload.length)}</span>
						</li>
					{/each}
				</ul>
			</div>
		{/if}
	{/if}

	{#if $cadBusy}
		<div class="busy">Running CAD operation...</div>
	{/if}
	{#if revisionBusy}
		<div class="busy">Running CAD revision workflow...</div>
	{/if}
	{#if $cadError}
		<div class="error">{$cadError}</div>
	{/if}
	{#if revisionError}
		<div class="error">{revisionError}</div>
	{/if}
</div>

<style>
	.cad-workspace {
		display: flex;
		flex-direction: column;
		gap: 12px;
	}
	.cad-header {
		display: flex;
		justify-content: space-between;
		align-items: center;
	}
	.header-actions {
		display: flex;
		gap: 6px;
		align-items: center;
	}
	h4 {
		margin: 0;
		font-size: 13px;
		color: #e2e8f0;
	}
	h5 {
		margin: 0 0 8px;
		font-size: 12px;
		color: #94a3b8;
		text-transform: uppercase;
	}
	.section {
		padding: 10px;
		border: 1px solid rgba(255, 255, 255, 0.08);
		border-radius: 8px;
		background: rgba(0, 0, 0, 0.2);
	}
	.meta-row {
		display: flex;
		justify-content: space-between;
		font-size: 12px;
		color: #cbd5e1;
		gap: 8px;
	}
	.diagnostic-ok {
		color: #22c55e;
	}
	.diagnostic-warn {
		color: #f59e0b;
	}
	.diag-history-wrap {
		margin-top: 10px;
		padding-top: 8px;
		border-top: 1px solid rgba(148, 163, 184, 0.2);
	}
	.diag-history-title {
		font-size: 11px;
		text-transform: uppercase;
		letter-spacing: 0.04em;
		color: #94a3b8;
		margin-bottom: 6px;
	}
	.diag-history-toolbar {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 8px;
		margin-bottom: 8px;
		flex-wrap: wrap;
	}
	.diag-regression-row {
		display: flex;
		align-items: center;
		gap: 8px;
		font-size: 11px;
		color: #cbd5e1;
		margin-bottom: 8px;
	}
	.diag-alert-active {
		display: inline-block;
		padding: 2px 6px;
		border-radius: 4px;
		background: rgba(239, 68, 68, 0.2);
		border: 1px solid rgba(239, 68, 68, 0.5);
		color: #fca5a5;
		font-weight: 700;
		text-transform: uppercase;
	}
	.diag-alert-clear {
		display: inline-block;
		padding: 2px 6px;
		border-radius: 4px;
		background: rgba(34, 197, 94, 0.18);
		border: 1px solid rgba(34, 197, 94, 0.45);
		color: #86efac;
		font-weight: 700;
		text-transform: uppercase;
	}
	.diag-export-actions {
		display: flex;
		gap: 6px;
		align-items: center;
	}
	.diag-export-actions button {
		margin-top: 0;
		padding: 4px 8px;
		font-size: 11px;
	}
	.diag-reco-box {
		margin-top: 8px;
		padding: 8px;
		border-radius: 6px;
		border: 1px solid rgba(148, 163, 184, 0.2);
		background: rgba(15, 23, 42, 0.45);
	}
	.diag-reco-title {
		font-size: 11px;
		text-transform: uppercase;
		letter-spacing: 0.04em;
		color: #94a3b8;
		margin-bottom: 6px;
	}
	.diag-reco-list {
		margin: 0;
		padding-left: 16px;
		display: flex;
		flex-direction: column;
		gap: 4px;
		font-size: 11px;
		color: #cbd5e1;
	}
	.diag-filter {
		padding: 4px 6px;
		background: rgba(15, 23, 42, 0.8);
		border: 1px solid rgba(255, 255, 255, 0.12);
		border-radius: 6px;
		color: #e2e8f0;
		font-size: 11px;
		min-width: 140px;
	}
	.diag-sparkline-wrap {
		padding: 4px 6px;
		border-radius: 6px;
		background: rgba(15, 23, 42, 0.7);
		border: 1px solid rgba(148, 163, 184, 0.2);
	}
	.diag-sparkline {
		display: block;
		width: 140px;
		height: 34px;
	}
	.diag-history-table {
		width: 100%;
		border-collapse: collapse;
		font-size: 11px;
		color: #cbd5e1;
	}
	.diag-history-table th,
	.diag-history-table td {
		padding: 4px 6px;
		text-align: left;
		border-bottom: 1px solid rgba(148, 163, 184, 0.15);
	}
	.diag-history-table th {
		color: #94a3b8;
		font-weight: 600;
	}
	.diag-history-table td:first-child {
		max-width: 120px;
		overflow: hidden;
		text-overflow: ellipsis;
		white-space: nowrap;
	}
	.diag-drawer {
		margin-top: 10px;
		border: 1px solid rgba(148, 163, 184, 0.2);
		border-radius: 6px;
		padding: 6px;
		background: rgba(15, 23, 42, 0.45);
	}
	.diag-drawer summary {
		cursor: pointer;
		color: #cbd5e1;
		font-size: 11px;
		font-weight: 600;
	}
	.diag-drawer-controls {
		margin-top: 8px;
	}
	.diag-drawer-controls select {
		width: 100%;
		padding: 5px 6px;
		background: rgba(15, 23, 42, 0.8);
		border: 1px solid rgba(255, 255, 255, 0.12);
		border-radius: 6px;
		color: #e2e8f0;
		font-size: 11px;
	}
	.diag-drawer-meta {
		margin-top: 8px;
		display: flex;
		flex-wrap: wrap;
		gap: 10px;
		font-size: 11px;
		color: #94a3b8;
	}
	.diag-detail-table {
		width: 100%;
		border-collapse: collapse;
		margin-top: 8px;
		font-size: 11px;
		color: #cbd5e1;
	}
	.diag-detail-table th,
	.diag-detail-table td {
		padding: 4px 6px;
		text-align: left;
		border-bottom: 1px solid rgba(148, 163, 184, 0.15);
	}
	.diag-detail-table th {
		color: #94a3b8;
		font-weight: 600;
	}
	.diag-tuning-grid {
		margin-top: 8px;
		display: grid;
		grid-template-columns: repeat(2, minmax(0, 1fr));
		gap: 8px;
	}
	.diag-tuning-presets {
		margin-top: 8px;
		display: flex;
		gap: 6px;
		flex-wrap: wrap;
	}
	.diag-config-summary {
		margin-top: 8px;
		margin-bottom: 10px;
		padding: 8px;
		border-radius: 6px;
		border: 1px solid rgba(148, 163, 184, 0.2);
		background: rgba(15, 23, 42, 0.35);
	}
	.diag-config-summary-head {
		display: flex;
		justify-content: space-between;
		align-items: flex-start;
		gap: 8px;
		margin-bottom: 6px;
		flex-wrap: wrap;
	}
	.diag-config-summary-copy {
		margin: 0;
	}
	.diag-source-pill {
		display: inline-flex;
		align-items: center;
		padding: 2px 8px;
		border-radius: 999px;
		background: rgba(59, 130, 246, 0.18);
		border: 1px solid rgba(96, 165, 250, 0.35);
		color: #bfdbfe;
		font-size: 11px;
	}
	.diag-config-audit-list {
		margin-bottom: 10px;
		display: flex;
		flex-direction: column;
		gap: 8px;
	}
	.diag-config-audit-item {
		padding: 8px;
		border-radius: 6px;
		border: 1px solid rgba(148, 163, 184, 0.18);
		background: rgba(2, 6, 23, 0.3);
	}
	.diag-config-audit-row {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 8px;
		font-size: 11px;
		color: #cbd5e1;
		flex-wrap: wrap;
	}
	.diag-config-audit-copy {
		margin-top: 6px;
	}
	.diag-config-audit-copy button {
		margin-top: 0;
		padding: 4px 8px;
		font-size: 11px;
	}
	.diag-config-fields {
		margin-top: 6px;
		font-size: 11px;
		color: #94a3b8;
	}
	.diag-tuning-presets button {
		margin-top: 0;
		padding: 4px 8px;
		font-size: 11px;
	}
	.diag-tuning-grid label {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 8px;
		font-size: 11px;
		color: #cbd5e1;
	}
	.diag-tuning-grid input {
		max-width: 70px;
		padding: 4px 6px;
		background: rgba(15, 23, 42, 0.8);
		border: 1px solid rgba(255, 255, 255, 0.12);
		border-radius: 6px;
		color: #e2e8f0;
	}
	.trend-up {
		color: #ef4444;
		font-weight: 600;
	}
	.trend-down {
		color: #22c55e;
		font-weight: 600;
	}
	.form-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 6px;
	}
	.form-grid input,
	.form-grid select,
	.publish-row select {
		padding: 6px 8px;
		background: rgba(15, 23, 42, 0.8);
		border: 1px solid rgba(255, 255, 255, 0.12);
		border-radius: 6px;
		color: #e2e8f0;
		font-size: 12px;
	}
	.snap-grid {
		display: grid;
		grid-template-columns: 1fr;
		gap: 8px;
		font-size: 12px;
		color: #cbd5e1;
	}
	.snap-grid label {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 8px;
	}
	.snap-grid input[type='number'] {
		max-width: 88px;
		padding: 4px 6px;
		background: rgba(15, 23, 42, 0.8);
		border: 1px solid rgba(255, 255, 255, 0.12);
		border-radius: 6px;
		color: #e2e8f0;
	}
	.toggle {
		justify-content: flex-start;
	}
	button {
		margin-top: 8px;
		padding: 6px 10px;
		background: rgba(245, 158, 11, 0.2);
		border: 1px solid rgba(245, 158, 11, 0.45);
		color: #f59e0b;
		border-radius: 6px;
		font-size: 12px;
		font-weight: 600;
		cursor: pointer;
	}
	button:disabled {
		opacity: 0.45;
		cursor: not-allowed;
	}
	.secondary-btn {
		background: rgba(59, 130, 246, 0.16);
		border-color: rgba(59, 130, 246, 0.45);
		color: #93c5fd;
	}
	.text-btn {
		margin: 0;
		padding: 0;
		background: transparent;
		border: 0;
		color: #f8fafc;
		text-decoration: underline;
	}
	.status-note {
		margin-top: 8px;
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 8px;
		font-size: 11px;
		color: #cbd5e1;
	}
	.status-note.stacked {
		flex-direction: column;
		align-items: flex-start;
	}
	.block-select-grid {
		grid-template-columns: minmax(0, 1fr) auto;
	}
	textarea {
		width: 100%;
		padding: 6px 8px;
		background: rgba(15, 23, 42, 0.8);
		border: 1px solid rgba(255, 255, 255, 0.12);
		border-radius: 6px;
		color: #e2e8f0;
		font-size: 12px;
		font-family: 'Consolas', 'Courier New', monospace;
		resize: vertical;
	}
	.command-list,
	.artifact-list {
		list-style: none;
		margin: 0;
		padding: 0;
		display: flex;
		flex-direction: column;
		gap: 6px;
	}
	.command-list li,
	.artifact-list li {
		display: grid;
		grid-template-columns: auto 1fr;
		gap: 8px;
		font-size: 11px;
		color: #cbd5e1;
	}
	.artifact-list li {
		grid-template-columns: 1fr auto auto;
	}
	.cmd-type {
		padding: 2px 6px;
		border-radius: 4px;
		background: rgba(59, 130, 246, 0.2);
		color: #93c5fd;
		text-transform: uppercase;
		font-size: 10px;
	}
	.publish-row {
		display: flex;
		gap: 8px;
		align-items: center;
	}
	.publish-row button {
		margin-top: 0;
	}
	.mt8 {
		margin-top: 8px;
	}
	.refresh-btn {
		margin-top: 0;
		padding: 4px 8px;
	}
	.compact-btn {
		margin-top: 0;
		padding: 4px 8px;
	}
	.quick-start {
		margin: 0;
		padding-left: 18px;
		display: flex;
		flex-direction: column;
		gap: 6px;
		font-size: 12px;
		color: #cbd5e1;
	}
	.busy {
		font-size: 12px;
		color: #f59e0b;
	}
	.error {
		font-size: 12px;
		color: #ef4444;
	}
	.empty-state {
		margin: 0;
		color: #94a3b8;
		font-size: 12px;
	}
	.field-help {
		margin: 0 0 8px;
		font-size: 11px;
		color: #94a3b8;
	}
</style>
