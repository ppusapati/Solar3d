<script lang="ts">
	import { activeConfirm, resolveActiveConfirm } from '$lib/core/stores/confirm';
	import { onMount } from 'svelte';

	function onKey(e: KeyboardEvent) {
		if (!$activeConfirm) return;
		if (e.key === 'Escape') resolveActiveConfirm(false);
		if (e.key === 'Enter') resolveActiveConfirm(true);
	}

	onMount(() => {
		window.addEventListener('keydown', onKey);
		return () => window.removeEventListener('keydown', onKey);
	});
</script>

{#if $activeConfirm}
	<div
		class="backdrop"
		on:click|self={() => resolveActiveConfirm(false)}
		role="dialog"
		aria-modal="true"
		aria-labelledby="confirm-title"
	>
		<div class="modal" class:danger={$activeConfirm.danger}>
			<h3 id="confirm-title">{$activeConfirm.title}</h3>
			{#if $activeConfirm.body}
				<p>{$activeConfirm.body}</p>
			{/if}
			<div class="actions">
				<button type="button" class="btn-secondary" on:click={() => resolveActiveConfirm(false)}>
					{$activeConfirm.cancelLabel ?? 'Cancel'}
				</button>
				<button
					type="button"
					class:btn-danger={$activeConfirm.danger}
					class:btn-primary={!$activeConfirm.danger}
					on:click={() => resolveActiveConfirm(true)}
					autofocus
				>
					{$activeConfirm.confirmLabel ?? 'Confirm'}
				</button>
			</div>
		</div>
	</div>
{/if}

<style>
	.backdrop {
		position: fixed;
		inset: 0;
		background: rgba(0, 0, 0, 0.55);
		display: flex;
		align-items: center;
		justify-content: center;
		z-index: 9999;
	}
	.modal {
		background: var(--color-bg, #1e293b);
		border: 1px solid var(--color-border, rgba(255, 255, 255, 0.08));
		border-radius: 12px;
		padding: 24px;
		min-width: 320px;
		max-width: 480px;
		box-shadow: 0 24px 48px rgba(0, 0, 0, 0.4);
	}
	.modal.danger {
		border-color: rgba(239, 68, 68, 0.4);
	}
	h3 {
		margin: 0 0 12px;
		font-size: 16px;
		color: var(--color-text, #e2e8f0);
	}
	p {
		margin: 0 0 20px;
		font-size: 14px;
		color: var(--color-text-muted, #94a3b8);
		line-height: 1.5;
	}
	.actions {
		display: flex;
		gap: 8px;
		justify-content: flex-end;
	}
	button {
		padding: 8px 16px;
		border-radius: 8px;
		border: 1px solid transparent;
		font-size: 14px;
		cursor: pointer;
	}
	.btn-secondary {
		background: rgba(255, 255, 255, 0.05);
		border-color: rgba(255, 255, 255, 0.1);
		color: var(--color-text, #e2e8f0);
	}
	.btn-primary {
		background: var(--color-primary, #1976d2);
		color: white;
	}
	.btn-danger {
		background: #ef4444;
		color: white;
	}
	button:hover {
		opacity: 0.9;
	}
</style>
