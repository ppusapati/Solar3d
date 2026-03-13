<script lang="ts">
	export let lines = 3;
	export let height = '16px';
	export let variant: 'text' | 'card' | 'metric' = 'text';
</script>

{#if variant === 'card'}
	<div class="skeleton-card" aria-hidden="true">
		<div class="skeleton-line" style="width: 60%; height: 20px;"></div>
		<div class="skeleton-line" style="width: 80%; height: {height}; margin-top: 8px;"></div>
		<div class="skeleton-line" style="width: 40%; height: {height}; margin-top: 8px;"></div>
	</div>
{:else if variant === 'metric'}
	<div class="skeleton-metric" aria-hidden="true">
		<div class="skeleton-line" style="width: 50%; height: 12px;"></div>
		<div class="skeleton-line" style="width: 70%; height: 28px; margin-top: 8px;"></div>
	</div>
{:else}
	<div class="skeleton-text" aria-hidden="true">
		{#each Array(lines) as _, i}
			<div
				class="skeleton-line"
				style="width: {i === lines - 1 ? '60%' : '100%'}; height: {height};"
			></div>
		{/each}
	</div>
{/if}

<style>
	.skeleton-card, .skeleton-text, .skeleton-metric {
		padding: 16px;
	}
	.skeleton-line {
		background: linear-gradient(90deg,
			rgba(255,255,255,0.04) 0%,
			rgba(255,255,255,0.08) 50%,
			rgba(255,255,255,0.04) 100%
		);
		background-size: 200% 100%;
		animation: shimmer 1.5s ease-in-out infinite;
		border-radius: 4px;
		margin-bottom: 6px;
	}
	@keyframes shimmer {
		0% { background-position: 200% 0; }
		100% { background-position: -200% 0; }
	}
</style>
