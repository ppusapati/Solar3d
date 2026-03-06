/**
 * WebSocket-based real-time collaboration for multi-user editing.
 * Handles connection management, reconnection, and message routing.
 */

import { writable, get } from 'svelte/store';

export interface CollabUser {
	id: string;
	name: string;
	color: string;
	cursor?: { longitude: number; latitude: number };
	lastSeen: number;
}

export interface CollabMessage {
	type: 'join' | 'leave' | 'cursor' | 'action' | 'sync' | 'lock' | 'unlock' | 'chat';
	userId: string;
	userName?: string;
	payload: any;
	timestamp: number;
}

export const collabUsers = writable<Map<string, CollabUser>>(new Map());
export const isConnected = writable(false);
export const localUserId = writable<string>('');
export const chatMessages = writable<{ userId: string; userName: string; text: string; time: number }[]>([]);

const COLLAB_COLORS = ['#ef4444', '#3b82f6', '#22c55e', '#f59e0b', '#8b5cf6', '#ec4899', '#06b6d4', '#84cc16'];

let ws: WebSocket | null = null;
let reconnectTimer: ReturnType<typeof setTimeout> | null = null;
let reconnectAttempts = 0;
const MAX_RECONNECT = 5;
let messageHandlers: ((msg: CollabMessage) => void)[] = [];

export function connect(projectId: string, userName: string) {
	const wsUrl = import.meta.env.VITE_WS_URL || 'ws://localhost:8090';
	const userId = generateUserId();
	localUserId.set(userId);

	try {
		ws = new WebSocket(`${wsUrl}/collab/${projectId}?user=${userId}&name=${encodeURIComponent(userName)}`);

		ws.onopen = () => {
			isConnected.set(true);
			reconnectAttempts = 0;

			send({
				type: 'join',
				userId,
				userName,
				payload: { color: COLLAB_COLORS[Math.floor(Math.random() * COLLAB_COLORS.length)] },
				timestamp: Date.now()
			});
		};

		ws.onmessage = (event) => {
			try {
				const msg: CollabMessage = JSON.parse(event.data);
				handleMessage(msg);
			} catch {
				// ignore malformed messages
			}
		};

		ws.onclose = () => {
			isConnected.set(false);
			attemptReconnect(projectId, userName);
		};

		ws.onerror = () => {
			// onclose will fire after this
		};
	} catch {
		isConnected.set(false);
	}
}

export function disconnect() {
	if (reconnectTimer) {
		clearTimeout(reconnectTimer);
		reconnectTimer = null;
	}
	reconnectAttempts = MAX_RECONNECT; // prevent reconnection
	if (ws) {
		ws.close();
		ws = null;
	}
	isConnected.set(false);
	collabUsers.set(new Map());
}

export function send(msg: CollabMessage) {
	if (ws?.readyState === WebSocket.OPEN) {
		ws.send(JSON.stringify(msg));
	}
}

export function sendCursorUpdate(longitude: number, latitude: number) {
	const userId = get(localUserId);
	if (!userId) return;

	send({
		type: 'cursor',
		userId,
		payload: { longitude, latitude },
		timestamp: Date.now()
	});
}

export function sendAction(actionType: string, payload: any) {
	const userId = get(localUserId);
	if (!userId) return;

	send({
		type: 'action',
		userId,
		payload: { actionType, ...payload },
		timestamp: Date.now()
	});
}

export function sendChat(text: string) {
	const userId = get(localUserId);
	if (!userId) return;

	send({
		type: 'chat',
		userId,
		payload: { text },
		timestamp: Date.now()
	});
}

export function lockEntity(entityId: string) {
	const userId = get(localUserId);
	send({
		type: 'lock',
		userId,
		payload: { entityId },
		timestamp: Date.now()
	});
}

export function unlockEntity(entityId: string) {
	const userId = get(localUserId);
	send({
		type: 'unlock',
		userId,
		payload: { entityId },
		timestamp: Date.now()
	});
}

export function onMessage(handler: (msg: CollabMessage) => void) {
	messageHandlers.push(handler);
	return () => {
		messageHandlers = messageHandlers.filter((h) => h !== handler);
	};
}

function handleMessage(msg: CollabMessage) {
	switch (msg.type) {
		case 'join': {
			collabUsers.update((users) => {
				users.set(msg.userId, {
					id: msg.userId,
					name: msg.userName || 'Anonymous',
					color: msg.payload?.color || COLLAB_COLORS[users.size % COLLAB_COLORS.length],
					lastSeen: msg.timestamp
				});
				return new Map(users);
			});
			break;
		}
		case 'leave': {
			collabUsers.update((users) => {
				users.delete(msg.userId);
				return new Map(users);
			});
			break;
		}
		case 'cursor': {
			collabUsers.update((users) => {
				const user = users.get(msg.userId);
				if (user) {
					user.cursor = msg.payload;
					user.lastSeen = msg.timestamp;
					users.set(msg.userId, user);
				}
				return new Map(users);
			});
			break;
		}
		case 'chat': {
			chatMessages.update((msgs) => [
				...msgs,
				{
					userId: msg.userId,
					userName: msg.userName || 'Unknown',
					text: msg.payload.text,
					time: msg.timestamp
				}
			]);
			break;
		}
	}

	// Forward to all registered handlers
	for (const handler of messageHandlers) {
		handler(msg);
	}
}

function attemptReconnect(projectId: string, userName: string) {
	if (reconnectAttempts >= MAX_RECONNECT) return;

	const delay = Math.min(1000 * Math.pow(2, reconnectAttempts), 16000);
	reconnectAttempts++;

	reconnectTimer = setTimeout(() => {
		connect(projectId, userName);
	}, delay);
}

function generateUserId(): string {
	if (typeof crypto !== 'undefined' && crypto.randomUUID) {
		return 'user_' + crypto.randomUUID().substring(0, 8);
	}
	const bytes = new Uint8Array(8);
	crypto.getRandomValues(bytes);
	return 'user_' + Array.from(bytes, (b) => b.toString(16).padStart(2, '0')).join('').substring(0, 8);
}
