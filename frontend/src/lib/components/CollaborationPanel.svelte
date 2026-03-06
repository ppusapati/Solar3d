<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import {
		connect,
		disconnect,
		collabUsers,
		isConnected,
		localUserId,
		sendChat,
		chatMessages
	} from '$lib/core/collaboration/websocket';
	import { activeProject } from '$lib/core/stores';

	let userName = 'Designer';
	let isJoined = false;
	let chatInput = '';
	let showChat = false;

	function handleJoin() {
		if (!$activeProject) return;
		connect($activeProject.id, userName);
		isJoined = true;
	}

	function handleLeave() {
		disconnect();
		isJoined = false;
	}

	function handleSendChat() {
		if (!chatInput.trim()) return;
		sendChat(chatInput.trim());
		chatInput = '';
	}

	function handleChatKeydown(e: KeyboardEvent) {
		if (e.key === 'Enter') handleSendChat();
	}

	function getUserColor(userId: string): string {
		return $collabUsers.get(userId)?.color || '#94a3b8';
	}

	onDestroy(() => {
		if (isJoined) disconnect();
	});
</script>

<div class="collab-panel">
	<h5>Collaboration</h5>

	{#if !isJoined}
		<div class="join-form">
			<input
				type="text"
				bind:value={userName}
				placeholder="Your name"
				class="name-input"
			/>
			<button class="btn-join" on:click={handleJoin} disabled={!$activeProject}>
				Join Session
			</button>
		</div>
	{:else}
		<div class="session-info">
			<div class="connection-status" class:connected={$isConnected}>
				<span class="status-dot"></span>
				{$isConnected ? 'Connected' : 'Reconnecting...'}
			</div>
			<button class="btn-leave" on:click={handleLeave}>Leave</button>
		</div>

		<div class="users-list">
			<div class="users-header">
				<span>Active Users ({$collabUsers.size})</span>
			</div>
			{#each [...$collabUsers.values()] as user}
				<div class="user-item" class:is-self={user.id === $localUserId}>
					<span class="user-dot" style="background: {user.color}"></span>
					<span class="user-name">{user.name}</span>
					{#if user.id === $localUserId}
						<span class="you-badge">You</span>
					{/if}
					{#if user.cursor}
						<span class="user-coords">
							{user.cursor.latitude.toFixed(3)}, {user.cursor.longitude.toFixed(3)}
						</span>
					{/if}
				</div>
			{/each}
		</div>

		<div class="chat-section">
			<button class="chat-toggle" on:click={() => { showChat = !showChat; }}>
				{showChat ? 'Hide Chat' : 'Show Chat'} ({$chatMessages.length})
			</button>

			{#if showChat}
				<div class="chat-messages">
					{#each $chatMessages.slice(-20) as msg}
						<div class="chat-msg">
							<span class="msg-author" style="color: {getUserColor(msg.userId)}">
								{msg.userName}:
							</span>
							<span class="msg-text">{msg.text}</span>
						</div>
					{/each}
				</div>

				<div class="chat-input-row">
					<input
						type="text"
						bind:value={chatInput}
						on:keydown={handleChatKeydown}
						placeholder="Type a message..."
						class="chat-input"
					/>
					<button class="btn-send" on:click={handleSendChat}>Send</button>
				</div>
			{/if}
		</div>
	{/if}
</div>

<style>
	.collab-panel {
		display: flex;
		flex-direction: column;
		gap: 10px;
	}

	h5 {
		margin: 0;
		font-size: 12px;
		font-weight: 600;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.join-form {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	.name-input, .chat-input {
		padding: 6px 8px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 4px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 12px;
		font-family: inherit;
	}

	.btn-join {
		padding: 8px;
		border: none;
		border-radius: 6px;
		background: linear-gradient(135deg, #3b82f6, #2563eb);
		color: white;
		font-size: 13px;
		font-weight: 600;
		cursor: pointer;
	}

	.btn-join:disabled { opacity: 0.5; cursor: not-allowed; }

	.session-info {
		display: flex;
		align-items: center;
		justify-content: space-between;
	}

	.connection-status {
		display: flex;
		align-items: center;
		gap: 6px;
		font-size: 12px;
		color: #f59e0b;
	}

	.connection-status.connected { color: #22c55e; }

	.status-dot {
		width: 6px;
		height: 6px;
		border-radius: 50%;
		background: currentColor;
	}

	.btn-leave {
		padding: 4px 8px;
		border: 1px solid rgba(239, 68, 68, 0.3);
		border-radius: 4px;
		background: transparent;
		color: #ef4444;
		font-size: 11px;
		cursor: pointer;
	}

	.users-list {
		display: flex;
		flex-direction: column;
		gap: 4px;
	}

	.users-header {
		font-size: 11px;
		color: #64748b;
	}

	.user-item {
		display: flex;
		align-items: center;
		gap: 6px;
		padding: 4px 6px;
		border-radius: 4px;
		font-size: 12px;
	}

	.user-item.is-self {
		background: rgba(255, 255, 255, 0.04);
	}

	.user-dot {
		width: 8px;
		height: 8px;
		border-radius: 50%;
		flex-shrink: 0;
	}

	.user-name {
		color: #e2e8f0;
		flex: 1;
	}

	.you-badge {
		font-size: 9px;
		color: #64748b;
		padding: 1px 4px;
		border-radius: 2px;
		background: rgba(255, 255, 255, 0.06);
	}

	.user-coords {
		font-size: 9px;
		color: #64748b;
		font-family: monospace;
	}

	.chat-section {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	.chat-toggle {
		padding: 4px 8px;
		border: 1px solid rgba(255, 255, 255, 0.1);
		border-radius: 4px;
		background: transparent;
		color: #94a3b8;
		font-size: 11px;
		cursor: pointer;
		text-align: left;
	}

	.chat-messages {
		max-height: 120px;
		overflow-y: auto;
		display: flex;
		flex-direction: column;
		gap: 2px;
		padding: 6px;
		background: rgba(0, 0, 0, 0.2);
		border-radius: 4px;
	}

	.chat-msg {
		font-size: 11px;
		line-height: 1.3;
	}

	.msg-author {
		font-weight: 600;
	}

	.msg-text {
		color: #e2e8f0;
	}

	.chat-input-row {
		display: flex;
		gap: 4px;
	}

	.chat-input {
		flex: 1;
	}

	.btn-send {
		padding: 4px 8px;
		border: none;
		border-radius: 4px;
		background: #3b82f6;
		color: white;
		font-size: 11px;
		cursor: pointer;
	}
</style>
