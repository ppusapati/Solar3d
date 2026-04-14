<script lang="ts">
	import { activeLayout, activeProject } from '$lib/core/stores';
	import { backendClients, protectionApi, structuralApi, type ProtectionStudy, type StructuralDesign } from '$lib/core/api';
	import { JobType } from '$lib/gen/orchestration/v1/orchestration_pb.js';
	import { summarizeEngineeringSnapshot } from '$lib/core/domain/engineeringWorkflow';
	import { ReportType, ReportFormat, ReportStatus } from '$lib/gen/report/v1/report_pb.js';
	import type { Report } from '$lib/gen/report/v1/report_pb.js';

	let reportTypeSel = 'site_layout';
	let reportFormat = 'pdf';
	let isGenerating = false;
	let isLoadingBom = false;
	let isExportingLayout = false;
	let isLoadingReport = false;
	let reports: Report[] = [];
	let error = '';
	let bomSummary: { totalPanels: number; totalInverters: number; totalCost: number } | null = null;
	let selectedReport: Report | null = null;
	let exportLayoutPath = '';
	let loadedProjectId: string | null = null;
	let structuralDesigns: StructuralDesign[] = [];
	let protectionStudies: ProtectionStudy[] = [];
	let structuralJobs = 0;
	let protectionJobs = 0;

	const reportTypeOptions: { value: string; label: string; proto: ReportType }[] = [
		{ value: 'site_layout', label: 'Site Layout', proto: ReportType.SITE_LAYOUT },
		{ value: 'panel_layout', label: 'Panel Layout', proto: ReportType.PANEL_LAYOUT },
		{ value: 'system_capacity', label: 'System Capacity', proto: ReportType.SYSTEM_CAPACITY },
		{ value: 'electrical_diagram', label: 'Electrical Diagram', proto: ReportType.ELECTRICAL_DIAGRAM },
		{ value: 'bill_of_materials', label: 'Bill of Materials', proto: ReportType.BILL_OF_MATERIALS },
		{ value: 'energy_estimate', label: 'Energy Estimate', proto: ReportType.ENERGY_ESTIMATE },
		{ value: 'full_engineering', label: 'Full Engineering Report', proto: ReportType.FULL_ENGINEERING }
	];

	const formatOptions: { value: string; label: string; proto: ReportFormat }[] = [
		{ value: 'pdf', label: 'PDF', proto: ReportFormat.PDF },
		{ value: 'csv', label: 'CSV', proto: ReportFormat.CSV },
		{ value: 'excel', label: 'Excel', proto: ReportFormat.EXCEL },
		{ value: 'json', label: 'JSON', proto: ReportFormat.JSON }
	];

	const statusLabel: Record<ReportStatus, string> = {
		[ReportStatus.UNSPECIFIED]: 'Unknown',
		[ReportStatus.PENDING]: 'Pending',
		[ReportStatus.GENERATING]: 'Generating…',
		[ReportStatus.COMPLETED]: 'Completed',
		[ReportStatus.FAILED]: 'Failed'
	};

	function formatLabel(format: ReportFormat): string {
		return formatOptions.find((option) => option.proto === format)?.label ?? `Format ${format}`;
	}

	function typeLabel(type: ReportType): string {
		return reportTypeOptions.find((option) => option.proto === type)?.label ?? `Type ${type}`;
	}

	function timestampToLocalString(timestamp?: { seconds: bigint | number }): string {
		if (!timestamp) return '—';
		return new Date(Number(timestamp.seconds) * 1000).toLocaleString();
	}

	async function loadReports() {
		if (!$activeProject) return;
		error = '';
		try {
			const res = await backendClients.report.listReports({ projectId: $activeProject.id });
			reports = res.reports;
			if (selectedReport) {
				const refreshed = res.reports.find((report) => report.id === selectedReport?.id);
				selectedReport = refreshed ?? null;
			}
			await loadEngineeringSnapshot();
		} catch (e: unknown) {
			error = e instanceof Error ? e.message : 'Failed to load reports';
		}
	}

	async function loadEngineeringSnapshot() {
		if (!$activeProject?.id) return;
		const [structuralResp, protectionResp, jobsResp] = await Promise.all([
			structuralApi.listDesigns($activeProject.id),
			protectionApi.listStudies($activeProject.id),
			backendClients.orchestration.listJobs({
				projectId: $activeProject.id,
				statusFilter: 0,
				limit: 200
			})
		]);
		structuralDesigns = structuralResp.designs;
		protectionStudies = protectionResp.studies;
		const snapshot = summarizeEngineeringSnapshot(structuralResp.designs, protectionResp.studies, jobsResp.jobs);
		structuralJobs = snapshot.structural_jobs;
		protectionJobs = snapshot.protection_jobs;
	}

	async function loadReportDetails(id: string) {
		isLoadingReport = true;
		error = '';
		try {
			const res = await backendClients.report.getReport({ id });
			selectedReport = res.report ?? null;
		} catch (e: unknown) {
			error = e instanceof Error ? e.message : 'Failed to load report details';
		} finally {
			isLoadingReport = false;
		}
	}

	async function generateReport() {
		if (!$activeProject) return;
		isGenerating = true;
		error = '';
		const typeOpt = reportTypeOptions.find((o) => o.value === reportTypeSel);
		const fmtOpt = formatOptions.find((o) => o.value === reportFormat);
		try {
			await backendClients.report.generateReport({
				projectId: $activeProject.id,
				name: `${typeOpt?.label ?? reportTypeSel} — ${$activeProject.name}`,
				reportType: typeOpt?.proto ?? ReportType.SITE_LAYOUT,
				format: fmtOpt?.proto ?? ReportFormat.PDF
			});
			selectedReport = null;
			await loadReports();
		} catch (e: unknown) {
			error = e instanceof Error ? e.message : 'Failed to generate report';
		} finally {
			isGenerating = false;
		}
	}

	async function deleteReport(id: string) {
		error = '';
		try {
			await backendClients.report.deleteReport({ id });
			reports = reports.filter((r) => r.id !== id);
			if (selectedReport?.id === id) {
				selectedReport = null;
			}
		} catch (e: unknown) {
			error = e instanceof Error ? e.message : 'Failed to delete report';
		}
	}

	async function generateBom() {
		if (!$activeProject || !$activeLayout) return;
		isLoadingBom = true;
		error = '';
		try {
			const res = await backendClients.report.generateBOM({
				projectId: $activeProject.id,
				layoutId: $activeLayout.id,
				electricalNetworkId: ''
			});
			if (res.bom) {
				bomSummary = {
					totalPanels: res.bom.totalPanels,
					totalInverters: res.bom.totalInverters,
					totalCost: res.bom.totalCost
				};
			}
		} catch (e: unknown) {
			error = e instanceof Error ? e.message : 'Failed to generate BOM';
		} finally {
			isLoadingBom = false;
		}
	}

	async function exportLayout() {
		if (!$activeProject || !$activeLayout) return;
		isExportingLayout = true;
		error = '';
		exportLayoutPath = '';
		try {
			const fmtOpt = formatOptions.find((o) => o.value === reportFormat);
			const response = await backendClients.report.exportLayout({
				projectId: $activeProject.id,
				layoutId: $activeLayout.id,
				format: fmtOpt?.proto ?? ReportFormat.PDF
			});
			exportLayoutPath = response.filePath ?? '';
			if (exportLayoutPath) {
				window.open(exportLayoutPath, '_blank', 'noopener');
			}
		} catch (e: unknown) {
			error = e instanceof Error ? e.message : 'Failed to export layout';
		} finally {
			isExportingLayout = false;
		}
	}

	$: if ($activeProject?.id && $activeProject.id !== loadedProjectId) {
		loadedProjectId = $activeProject.id;
		selectedReport = null;
		exportLayoutPath = '';
		void loadReports();
	}
</script>

<div class="reports-panel">
	<h4>Reports</h4>

	{#if error}
		<div class="error">{error}</div>
	{/if}

	<div class="section">
		<h5>Generate Report</h5>

		<div class="form-group">
			<label for="report-type">Report Type</label>
			<select id="report-type" bind:value={reportTypeSel}>
				{#each reportTypeOptions as opt}
					<option value={opt.value}>{opt.label}</option>
				{/each}
			</select>
		</div>

		<div class="form-group">
			<label for="report-format">Format</label>
			<select id="report-format" bind:value={reportFormat}>
				{#each formatOptions as opt}
					<option value={opt.value}>{opt.label}</option>
				{/each}
			</select>
		</div>

		<button class="btn-generate" on:click={generateReport} disabled={isGenerating || !$activeProject}>
			{isGenerating ? 'Generating…' : 'Generate Report'}
		</button>
	</div>

	{#if $activeLayout}
		<div class="divider"></div>
		<div class="section">
			<h5>Bill of Materials</h5>
			<button class="btn-bom" on:click={generateBom} disabled={isLoadingBom}>
				{isLoadingBom ? 'Calculating…' : 'Calculate BOM'}
			</button>
			{#if bomSummary}
				<div class="bom-summary">
					<div class="bom-row"><span>Panels</span><span>{bomSummary.totalPanels}</span></div>
					<div class="bom-row"><span>Inverters</span><span>{bomSummary.totalInverters}</span></div>
					<div class="bom-row total"><span>Est. Cost</span><span>${bomSummary.totalCost.toLocaleString()}</span></div>
				</div>
			{/if}
		</div>
		<div class="divider"></div>
		<div class="section">
			<h5>Layout Export</h5>
			<button class="btn-bom" on:click={exportLayout} disabled={isExportingLayout}>
				{isExportingLayout ? 'Exporting…' : 'Export Active Layout'}
			</button>
			{#if exportLayoutPath}
				<a class="path-link" href={exportLayoutPath} target="_blank" rel="noreferrer">Open exported layout</a>
			{/if}
		</div>
	{/if}

	{#if reports.length > 0}
		<div class="divider"></div>
		<div class="section">
			<h5>Generated Reports ({reports.length})</h5>
			{#each reports as report (report.id)}
				<div class="report-item" class:selected={selectedReport?.id === report.id}>
					<div class="report-info">
						<button class="report-name" on:click={() => void loadReportDetails(report.id)}>{report.name}</button>
						<span class="report-meta status-{report.status}">
							{statusLabel[report.status]} · {formatLabel(report.format)}
						</span>
					</div>
					<div class="report-actions">
						{#if report.filePath}
							<a class="btn-download" href={report.filePath} target="_blank" rel="noreferrer">↓</a>
						{/if}
						<button class="btn-delete" on:click={() => deleteReport(report.id)} title="Delete">✕</button>
					</div>
				</div>
			{/each}
		</div>
	{/if}

	<div class="divider"></div>
	<div class="section">
		<h5>Engineering Workflow Snapshot</h5>
		<div class="bom-summary">
			<div class="bom-row"><span>Structural Designs</span><span>{structuralDesigns.length}</span></div>
			<div class="bom-row"><span>Protection Studies</span><span>{protectionStudies.length}</span></div>
			<div class="bom-row"><span>Structural Jobs</span><span>{structuralJobs}</span></div>
			<div class="bom-row"><span>Protection Jobs</span><span>{protectionJobs}</span></div>
			<div class="bom-row"><span>Structural Approved</span><span>{structuralDesigns.filter((d) => d.review_state === 3).length}</span></div>
			<div class="bom-row"><span>Structural In Review</span><span>{structuralDesigns.filter((d) => d.review_state === 2).length}</span></div>
		</div>
		<button class="btn-bom" on:click={() => void loadEngineeringSnapshot()} disabled={!$activeProject}>Refresh Engineering Snapshot</button>
	</div>

	{#if isLoadingReport}
		<div class="divider"></div>
		<div class="section">
			<div class="empty-state">Loading report details…</div>
		</div>
	{:else if selectedReport}
		<div class="divider"></div>
		<div class="section">
			<h5>Selected Report</h5>
			<div class="detail-card">
				<div class="detail-row"><span>Name</span><strong>{selectedReport.name}</strong></div>
				<div class="detail-row"><span>Type</span><strong>{typeLabel(selectedReport.reportType)}</strong></div>
				<div class="detail-row"><span>Format</span><strong>{formatLabel(selectedReport.format)}</strong></div>
				<div class="detail-row"><span>Status</span><strong>{statusLabel[selectedReport.status]}</strong></div>
				<div class="detail-row"><span>Created</span><strong>{timestampToLocalString(selectedReport.createdAt)}</strong></div>
				<div class="detail-row"><span>Completed</span><strong>{timestampToLocalString(selectedReport.completedAt)}</strong></div>
				{#if selectedReport.filePath}
					<a class="path-link" href={selectedReport.filePath} target="_blank" rel="noreferrer">Open generated file</a>
				{/if}
			</div>
		</div>
	{/if}
</div>

<style>
	.reports-panel {
		display: flex;
		flex-direction: column;
		gap: 12px;
	}

	h4 {
		margin: 0;
		font-size: 14px;
		font-weight: 600;
		color: #e2e8f0;
	}

	h5 {
		margin: 0 0 8px 0;
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

	.divider {
		height: 1px;
		background: rgba(255, 255, 255, 0.1);
		margin: 4px 0;
	}

	.error {
		padding: 6px 8px;
		border-radius: 4px;
		background: rgba(239, 68, 68, 0.15);
		border: 1px solid rgba(239, 68, 68, 0.3);
		color: #fca5a5;
		font-size: 11px;
	}

	.form-group {
		display: flex;
		flex-direction: column;
		gap: 4px;
	}

	.form-group label {
		font-size: 11px;
		color: #94a3b8;
	}

	select {
		width: 100%;
		padding: 6px 8px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 4px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 12px;
		font-family: inherit;
		cursor: pointer;
	}

	.btn-generate {
		padding: 8px;
		border: none;
		border-radius: 6px;
		background: linear-gradient(135deg, #f59e0b, #d97706);
		color: #1a1a2e;
		font-size: 13px;
		font-weight: 600;
		cursor: pointer;
	}

	.btn-generate:hover:not(:disabled) {
		filter: brightness(1.1);
	}

	.btn-generate:disabled,
	.btn-bom:disabled {
		opacity: 0.5;
		cursor: not-allowed;
	}

	.btn-bom {
		padding: 6px 8px;
		border: 1px solid rgba(99, 102, 241, 0.4);
		border-radius: 6px;
		background: rgba(99, 102, 241, 0.1);
		color: #a5b4fc;
		font-size: 12px;
		cursor: pointer;
	}

	.btn-bom:hover:not(:disabled) {
		background: rgba(99, 102, 241, 0.2);
	}

	.bom-summary,
	.detail-card {
		display: flex;
		flex-direction: column;
		gap: 4px;
		padding: 8px;
		border-radius: 6px;
		background: rgba(99, 102, 241, 0.08);
		border: 1px solid rgba(99, 102, 241, 0.2);
	}

	.detail-card {
		background: rgba(255, 255, 255, 0.04);
		border-color: rgba(255, 255, 255, 0.08);
	}

	.bom-row,
	.detail-row {
		display: flex;
		justify-content: space-between;
		gap: 8px;
		font-size: 12px;
		color: #94a3b8;
	}

	.bom-row.total {
		color: #e2e8f0;
		font-weight: 600;
		border-top: 1px solid rgba(255, 255, 255, 0.1);
		padding-top: 4px;
		margin-top: 2px;
	}

	.detail-row strong {
		color: #e2e8f0;
		text-align: right;
	}

	.report-item {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 8px;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.08);
	}

	.report-item.selected {
		border-color: rgba(245, 158, 11, 0.35);
		background: rgba(245, 158, 11, 0.08);
	}

	.report-info {
		display: flex;
		flex-direction: column;
		gap: 2px;
		min-width: 0;
	}

	.report-name {
		font-size: 12px;
		color: #e2e8f0;
		font-weight: 500;
		border: none;
		background: transparent;
		padding: 0;
		text-align: left;
		cursor: pointer;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.report-name:hover {
		color: #fcd34d;
	}

	.report-meta {
		font-size: 10px;
		color: #64748b;
	}

	.report-meta.status-3 { color: #4ade80; }
	.report-meta.status-4 { color: #f87171; }
	.report-meta.status-2 { color: #fbbf24; }

	.report-actions {
		display: flex;
		gap: 4px;
		flex-shrink: 0;
	}

	.btn-download,
	.path-link {
		padding: 4px 8px;
		border: 1px solid rgba(245, 158, 11, 0.3);
		border-radius: 4px;
		background: transparent;
		color: #f59e0b;
		font-size: 11px;
		cursor: pointer;
		text-decoration: none;
		width: fit-content;
	}

	.btn-download:hover,
	.path-link:hover {
		background: rgba(245, 158, 11, 0.1);
	}

	.btn-delete {
		padding: 4px 6px;
		border: 1px solid rgba(239, 68, 68, 0.3);
		border-radius: 4px;
		background: transparent;
		color: #f87171;
		font-size: 10px;
		cursor: pointer;
	}

	.btn-delete:hover {
		background: rgba(239, 68, 68, 0.1);
	}

	.empty-state {
		font-size: 12px;
		color: #64748b;
	}
</style>
