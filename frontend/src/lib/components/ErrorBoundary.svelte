<script lang="ts">
	import { onMount } from 'svelte';
	import { structuredLog, Solar3DError } from '$lib/core/error-handling';

	export let fallbackMessage = 'Something went wrong';
	export let scope = 'root';

	let hasError = false;
	let errorMessage = '';

	onMount(() => {
		const handler = (event: ErrorEvent) => {
			hasError = true;
			errorMessage = event.message || 'An unexpected error occurred';
			structuredLog('error', `error_boundary.${scope}`, event.error instanceof Solar3DError ? event.error : { message: errorMessage, source: event.filename, line: event.lineno });
			event.preventDefault();
		};

		const rejectionHandler = (event: PromiseRejectionEvent) => {
			hasError = true;
			errorMessage = event.reason?.message || 'An unhandled promise rejection occurred';
			structuredLog('error', `error_boundary.${scope}.rejection`, event.reason instanceof Solar3DError ? event.reason : { message: errorMessage });
			event.preventDefault();
		};

		window.addEventListener('error', handler);
		window.addEventListener('unhandledrejection', rejectionHandler);

		return () => {
			window.removeEventListener('error', handler);
			window.removeEventListener('unhandledrejection', rejectionHandler);
		};
	});

	function reset() {
		hasError = false;
		errorMessage = '';
	}
</script>

{#if hasError}
	<div class="error-boundary" role="alert">
		<div class="error-content">
			<svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2">
				<circle cx="12" cy="12" r="10"/>
				<line x1="12" y1="8" x2="12" y2="12"/>
				<line x1="12" y1="16" x2="12.01" y2="16"/>
			</svg>
			<h3>{fallbackMessage}</h3>
			<p class="error-detail">{errorMessage}</p>
			<button on:click={reset}>Try Again</button>
		</div>
	</div>
{:else}
	<slot />
{/if}

<style>
	.error-boundary {
		display: flex;
		align-items: center;
		justify-content: center;
		min-height: 200px;
		padding: 24px;
	}
	.error-content {
		text-align: center;
		max-width: 400px;
	}
	h3 {
		margin: 16px 0 8px;
		color: #e2e8f0;
		font-size: 18px;
	}
	.error-detail {
		color: #94a3b8;
		font-size: 13px;
		margin-bottom: 16px;
		word-break: break-word;
	}
	button {
		padding: 8px 20px;
		border-radius: 8px;
		border: 1px solid rgba(255,255,255,0.1);
		background: rgba(59, 130, 246, 0.2);
		color: #93c5fd;
		cursor: pointer;
		font-size: 14px;
	}
	button:hover {
		background: rgba(59, 130, 246, 0.3);
	}
</style>
