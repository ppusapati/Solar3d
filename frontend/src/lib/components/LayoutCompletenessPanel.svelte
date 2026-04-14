<script lang="ts">
	import type { LayoutCompletenessSummary } from '$lib/core/domain/workflowReadiness';

	export let summary: LayoutCompletenessSummary;

	function statusLabel(status: string): string {
		switch (status) {
			case 'complete':
				return 'Complete';
			case 'partial':
				return 'Partial';
			default:
				return 'Missing';
		}
	}
</script>

<div class="layout-completeness">
	<h5>Complete Layout Coverage</h5>
	<div class="coverage-row">
		<span>Coverage</span>
		<strong>{summary.coverage_percent}%</strong>
	</div>
	{#each summary.classes as item}
		<div class="class-row status-{item.status}">
			<div class="head">
				<span>{item.label}</span>
				<span>{statusLabel(item.status)} · {item.count}</span>
			</div>
			{#if item.identity_samples.length > 0}
				<div class="ids">IDs: {item.identity_samples.join(', ')}</div>
			{/if}
			{#if item.note}
				<div class="note">{item.note}</div>
			{/if}
		</div>
	{/each}
</div>

<style>
	.layout-completeness {
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

	.coverage-row {
		display: flex;
		justify-content: space-between;
		font-size: 12px;
		color: #e2e8f0;
	}

	.coverage-row strong {
		color: #f8fafc;
	}

	.class-row {
		padding: 7px;
		border-radius: 6px;
		border: 1px solid rgba(255, 255, 255, 0.1);
		background: rgba(15, 23, 42, 0.45);
		display: flex;
		flex-direction: column;
		gap: 4px;
	}

	.class-row.status-complete {
		border-color: rgba(34, 197, 94, 0.45);
	}

	.class-row.status-partial {
		border-color: rgba(245, 158, 11, 0.5);
	}

	.class-row.status-missing {
		border-color: rgba(239, 68, 68, 0.5);
	}

	.head {
		display: flex;
		justify-content: space-between;
		font-size: 12px;
		color: #e2e8f0;
	}

	.ids {
		font-size: 11px;
		color: #cbd5e1;
		word-break: break-word;
	}

	.note {
		font-size: 11px;
		color: #fbbf24;
	}
</style>
