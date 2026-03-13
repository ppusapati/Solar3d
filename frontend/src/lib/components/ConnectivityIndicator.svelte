<script lang="ts">
	import { onMount, onDestroy } from 'svelte';

	let isOnline = true;
	let apiReachable = true;
	let checking = false;
	let checkInterval: ReturnType<typeof setInterval>;

	const API_BASE = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080';

	async function checkApi() {
		if (checking) return;
		checking = true;
		try {
			const controller = new AbortController();
			const timeout = setTimeout(() => controller.abort(), 5000);
			const res = await fetch(`${API_BASE}/healthz`, { signal: controller.signal });
			clearTimeout(timeout);
			apiReachable = res.ok;
		} catch {
			apiReachable = false;
		} finally {
			checking = false;
		}
	}

	function handleOnline() { isOnline = true; checkApi(); }
	function handleOffline() { isOnline = false; apiReachable = false; }

	onMount(() => {
		isOnline = navigator.onLine;
		window.addEventListener('online', handleOnline);
		window.addEventListener('offline', handleOffline);
		checkApi();
		checkInterval = setInterval(checkApi, 30000);
	});

	onDestroy(() => {
		window.removeEventListener('online', handleOnline);
		window.removeEventListener('offline', handleOffline);
		clearInterval(checkInterval);
	});

	$: status = !isOnline ? 'offline' : !apiReachable ? 'api-down' : 'connected';
	$: statusLabel = status === 'offline' ? 'Offline' : status === 'api-down' ? 'API Unreachable' : 'Connected';
	$: statusColor = status === 'connected' ? '#10b981' : status === 'api-down' ? '#f59e0b' : '#ef4444';
</script>

<div class="connectivity" title={statusLabel} role="status" aria-label="Connection status: {statusLabel}">
	<span class="dot" style="background: {statusColor}" class:pulse={status !== 'connected'}></span>
	{#if status !== 'connected'}
		<span class="label">{statusLabel}</span>
	{/if}
</div>

<style>
	.connectivity {
		display: flex;
		align-items: center;
		gap: 6px;
		padding: 2px 8px;
		border-radius: 12px;
		font-size: 11px;
		color: #94a3b8;
	}
	.dot {
		width: 8px;
		height: 8px;
		border-radius: 50%;
		flex-shrink: 0;
	}
	.pulse {
		animation: pulse 2s ease-in-out infinite;
	}
	.label {
		font-weight: 500;
	}
	@keyframes pulse {
		0%, 100% { opacity: 1; }
		50% { opacity: 0.4; }
	}
</style>
