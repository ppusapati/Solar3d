<script lang="ts">
	import { activeLayout, activeProject } from '$lib/core/stores';

	let reportType = 'bom';
	let reportFormat = 'pdf';
	let isGenerating = false;
	let generatedReports: { name: string; type: string; date: string }[] = [];

	async function generateReport() {
		if (!$activeLayout) return;
		isGenerating = true;

		// Simulated report generation
		await new Promise((r) => setTimeout(r, 1500));

		const typeLabels: Record<string, string> = {
			bom: 'Bill of Materials',
			layout: 'Layout Export',
			electrical: 'Electrical Design',
			simulation: 'Simulation Results',
			full: 'Full Project Report'
		};

		generatedReports = [
			{
				name: `${typeLabels[reportType]} - ${$activeProject?.name || 'Project'}`,
				type: reportFormat.toUpperCase(),
				date: new Date().toLocaleDateString()
			},
			...generatedReports
		];

		isGenerating = false;
	}
</script>

<div class="reports-panel">
	<h4>Reports</h4>

	<div class="section">
		<h5>Generate Report</h5>

		<div class="form-group">
			<label>Report Type</label>
			<select bind:value={reportType}>
				<option value="bom">Bill of Materials</option>
				<option value="layout">Layout Export</option>
				<option value="electrical">Electrical Design</option>
				<option value="simulation">Simulation Results</option>
				<option value="full">Full Project Report</option>
			</select>
		</div>

		<div class="form-group">
			<label>Format</label>
			<select bind:value={reportFormat}>
				<option value="pdf">PDF</option>
				<option value="csv">CSV</option>
				<option value="json">JSON</option>
			</select>
		</div>

		<button
			class="btn-generate"
			on:click={generateReport}
			disabled={isGenerating || !$activeLayout}
		>
			{isGenerating ? 'Generating...' : 'Generate Report'}
		</button>
	</div>

	{#if generatedReports.length > 0}
		<div class="divider"></div>
		<div class="section">
			<h5>Generated Reports</h5>
			{#each generatedReports as report}
				<div class="report-item">
					<div class="report-info">
						<span class="report-name">{report.name}</span>
						<span class="report-meta">{report.type} - {report.date}</span>
					</div>
					<button class="btn-download">Download</button>
				</div>
			{/each}
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

	.btn-generate:disabled {
		opacity: 0.5;
		cursor: not-allowed;
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
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.report-meta {
		font-size: 10px;
		color: #64748b;
	}

	.btn-download {
		padding: 4px 8px;
		border: 1px solid rgba(245, 158, 11, 0.3);
		border-radius: 4px;
		background: transparent;
		color: #f59e0b;
		font-size: 11px;
		cursor: pointer;
		flex-shrink: 0;
	}

	.btn-download:hover {
		background: rgba(245, 158, 11, 0.1);
	}
</style>
