import { derived, writable, get } from 'svelte/store';

export interface HistoryAction {
	type: string;
	description: string;
	undo: () => void | Promise<void>;
	redo: () => void | Promise<void>;
}

const undoStack = writable<HistoryAction[]>([]);
const redoStack = writable<HistoryAction[]>([]);

export const commandStack = derived(undoStack, ($stack) => $stack);

export const canUndo = writable(false);
export const canRedo = writable(false);
export const lastAction = writable<string>('');

undoStack.subscribe((stack) => canUndo.set(stack.length > 0));
redoStack.subscribe((stack) => canRedo.set(stack.length > 0));

export function pushAction(action: HistoryAction) {
	undoStack.update((stack) => [...stack, action]);
	redoStack.set([]); // Clear redo on new action
	lastAction.set(action.description);
}

export async function undo() {
	const stack = get(undoStack);
	if (stack.length === 0) return;

	const action = stack[stack.length - 1];
	undoStack.update((s) => s.slice(0, -1));

	await action.undo();
	redoStack.update((s) => [...s, action]);
	lastAction.set(`Undo: ${action.description}`);
}

export async function redo() {
	const stack = get(redoStack);
	if (stack.length === 0) return;

	const action = stack[stack.length - 1];
	redoStack.update((s) => s.slice(0, -1));

	await action.redo();
	undoStack.update((s) => [...s, action]);
	lastAction.set(`Redo: ${action.description}`);
}

export function clearHistory() {
	undoStack.set([]);
	redoStack.set([]);
	lastAction.set('');
}
