<script lang="ts">
	import { fly } from 'svelte/transition';
	import { toasts, removeToast, type Toast } from '$lib/core/stores/toast';

	function getIcon(type: Toast['type']): string {
		switch (type) {
			case 'success': return 'V';
			case 'error': return 'X';
			case 'warning': return '!';
			case 'info': return 'i';
		}
	}
</script>

<div class="toast-container">
	{#each $toasts as toast (toast.id)}
		<div
			class="toast toast-{toast.type}"
			transition:fly={{ y: 20, duration: 300 }}
		>
			<span class="toast-icon">{getIcon(toast.type)}</span>
			<span class="toast-message">{toast.message}</span>
			<button class="toast-close" on:click={() => removeToast(toast.id)}>x</button>
		</div>
	{/each}
</div>

<style>
	.toast-container {
		position: fixed;
		bottom: 44px;
		right: 16px;
		z-index: 300;
		display: flex;
		flex-direction: column-reverse;
		gap: 8px;
		pointer-events: none;
	}

	.toast {
		display: flex;
		align-items: center;
		gap: 8px;
		padding: 10px 14px;
		border-radius: 8px;
		background: rgba(22, 33, 62, 0.98);
		backdrop-filter: blur(8px);
		border: 1px solid rgba(255, 255, 255, 0.1);
		min-width: 260px;
		max-width: 400px;
		pointer-events: all;
		box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
	}

	.toast-success {
		border-left: 3px solid #22c55e;
	}

	.toast-error {
		border-left: 3px solid #ef4444;
	}

	.toast-warning {
		border-left: 3px solid #f59e0b;
	}

	.toast-info {
		border-left: 3px solid #3b82f6;
	}

	.toast-icon {
		width: 20px;
		height: 20px;
		display: flex;
		align-items: center;
		justify-content: center;
		border-radius: 50%;
		font-size: 11px;
		font-weight: 700;
		flex-shrink: 0;
	}

	.toast-success .toast-icon {
		background: rgba(34, 197, 94, 0.2);
		color: #22c55e;
	}

	.toast-error .toast-icon {
		background: rgba(239, 68, 68, 0.2);
		color: #ef4444;
	}

	.toast-warning .toast-icon {
		background: rgba(245, 158, 11, 0.2);
		color: #f59e0b;
	}

	.toast-info .toast-icon {
		background: rgba(59, 130, 246, 0.2);
		color: #3b82f6;
	}

	.toast-message {
		flex: 1;
		font-size: 13px;
		color: #e2e8f0;
		line-height: 1.3;
	}

	.toast-close {
		border: none;
		background: transparent;
		color: #64748b;
		font-size: 14px;
		cursor: pointer;
		padding: 2px;
		flex-shrink: 0;
	}

	.toast-close:hover {
		color: #e2e8f0;
	}
</style>
