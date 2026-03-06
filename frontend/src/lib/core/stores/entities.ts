import { writable, derived, get } from 'svelte/store';

export interface MapEntity {
	id: string;
	type: 'boundary' | 'panel-area' | 'component' | 'measurement';
	geojson: string;
	cesiumEntityIds: string[];
	properties: Record<string, any>;
	createdAt: number;
}

const entityMap = writable<Map<string, MapEntity>>(new Map());

export const entities = derived(entityMap, ($map) => Array.from($map.values()));

export const boundaryEntities = derived(entities, ($e) =>
	$e.filter((e) => e.type === 'boundary')
);

export const componentEntities = derived(entities, ($e) =>
	$e.filter((e) => e.type === 'component')
);

let counter = 0;

function generateId(): string {
	return `entity_${Date.now()}_${++counter}`;
}

export function addEntity(
	type: MapEntity['type'],
	geojson: string,
	cesiumEntityIds: string[],
	properties: Record<string, any> = {}
): string {
	const id = generateId();
	const entity: MapEntity = {
		id,
		type,
		geojson,
		cesiumEntityIds,
		properties,
		createdAt: Date.now()
	};
	entityMap.update((m) => {
		m.set(id, entity);
		return new Map(m);
	});
	return id;
}

export function removeEntity(id: string): MapEntity | null {
	let removed: MapEntity | null = null;
	entityMap.update((m) => {
		removed = m.get(id) ?? null;
		m.delete(id);
		return new Map(m);
	});
	return removed;
}

export function getEntity(id: string): MapEntity | undefined {
	return get(entityMap).get(id);
}

export function updateEntityProperty(id: string, key: string, value: any) {
	entityMap.update((m) => {
		const entity = m.get(id);
		if (entity) {
			entity.properties = { ...entity.properties, [key]: value };
			m.set(id, { ...entity });
		}
		return new Map(m);
	});
}

export function clearEntities() {
	entityMap.set(new Map());
}

export function getAllEntitiesForExport(): MapEntity[] {
	return get(entities);
}
