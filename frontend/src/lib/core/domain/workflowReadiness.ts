export type CompletenessStatus = 'complete' | 'partial' | 'missing';

export interface LayoutClassSummary {
	key: string;
	label: string;
	count: number;
	status: CompletenessStatus;
	identity_samples: string[];
	note?: string;
}

export interface LayoutCompletenessSummary {
	generated_at: string;
	coverage_percent: number;
	classes: LayoutClassSummary[];
	blockers: string[];
}

export interface WorkflowComponentLite {
	id: string;
	component_type: string;
	position?: {
		longitude: number;
		latitude: number;
		elevation: number;
	};
}

export interface WorkflowEntityLite {
	id: string;
	type: string;
	properties?: Record<string, unknown>;
}

export interface LayoutCompletenessInput {
	layout_id: string;
	total_panels: number;
	total_capacity_kw: number;
	fill_area_count: number;
	drawn_road_count: number;
	components: WorkflowComponentLite[];
	entities: WorkflowEntityLite[];
}

export interface Lod400ChecklistItem {
	key: string;
	label: string;
	required: boolean;
	status: CompletenessStatus;
	pass: boolean;
	reason: string;
}

export interface Lod400ChecklistSummary {
	pass: boolean;
	items: Lod400ChecklistItem[];
	blocker_reasons: string[];
}

const REQUIRED_CLASSES: Array<{ key: string; label: string }> = [
	{ key: 'panels', label: 'Panels' },
	{ key: 'roads', label: 'Road Access' },
	{ key: 'strings', label: 'Stringing' },
	{ key: 'inverters', label: 'Inverters' },
	{ key: 'cabling', label: 'Cabling Routes' },
	{ key: 'transformers', label: 'Transformers' },
	{ key: 'acdc_equipment', label: 'AC/DC Equipment' },
	{ key: 'fault_identifiers', label: 'Fault Identifiers' },
	{ key: 'precision_fields', label: 'Precision Fields' }
];

function sampleIds(ids: string[]): string[] {
	return ids.slice(0, 3);
}

function hasFinitePosition(component: WorkflowComponentLite): boolean {
	if (!component.position) return false;
	const { longitude, latitude, elevation } = component.position;
	return Number.isFinite(longitude) && Number.isFinite(latitude) && Number.isFinite(elevation);
}

export function computeLayoutCompleteness(input: LayoutCompletenessInput): LayoutCompletenessSummary {
	const byType = new Map<string, WorkflowComponentLite[]>();
	for (const component of input.components) {
		const list = byType.get(component.component_type) ?? [];
		list.push(component);
		byType.set(component.component_type, list);
	}

	const routeEntities = input.entities.filter(
		(entity) => entity.type === 'component' && String(entity.properties?.type ?? '') === 'route'
	);
	const cableRoutes = routeEntities.filter((entity) => String(entity.properties?.route_type ?? '') === 'cable');
	const roadRoutes = routeEntities.filter((entity) => String(entity.properties?.route_type ?? '') === 'road');
	const faultEntities = input.entities.filter((entity) => {
		const props = entity.properties ?? {};
		return Boolean(
			props.fault_id ?? props.fault_identifier ?? props.fault_code ?? props.faultCode ?? props.faultIdentifier
		);
	});

	const panelsCount = Math.max(0, input.total_panels);
	const inverterComponents = byType.get('inverter') ?? [];
	const transformerComponents = byType.get('transformer') ?? [];
	const combinerComponents = byType.get('combiner_box') ?? [];
	const substationComponents = byType.get('substation') ?? [];
	const trackerComponents = byType.get('tracker') ?? [];
	const stringsCount = combinerComponents.length;
	const roadsCount = input.drawn_road_count + roadRoutes.length;
	const cablesCount = cableRoutes.length;
	const acDcCount = substationComponents.length + combinerComponents.length + trackerComponents.length;
	const precisionReady =
		input.fill_area_count > 0 &&
		input.total_capacity_kw > 0 &&
		input.components.every((component) => hasFinitePosition(component));

	const classes: LayoutClassSummary[] = [
		{
			key: 'panels',
			label: 'Panels',
			count: panelsCount,
			status: panelsCount > 0 ? 'complete' : 'missing',
			identity_samples: panelsCount > 0 ? [`layout:${input.layout_id}:panels`] : []
		},
		{
			key: 'roads',
			label: 'Road Access',
			count: roadsCount,
			status: roadsCount > 0 ? 'complete' : 'missing',
			identity_samples: roadRoutes.length > 0 ? sampleIds(roadRoutes.map((route) => route.id)) : []
		},
		{
			key: 'strings',
			label: 'Stringing',
			count: stringsCount,
			status: stringsCount > 0 ? 'partial' : 'missing',
			identity_samples: sampleIds(combinerComponents.map((component) => component.id)),
			note: 'Stringing count is currently inferred from combiner boxes until explicit string IDs are surfaced.'
		},
		{
			key: 'inverters',
			label: 'Inverters',
			count: inverterComponents.length,
			status: inverterComponents.length > 0 ? 'complete' : 'missing',
			identity_samples: sampleIds(inverterComponents.map((component) => component.id))
		},
		{
			key: 'cabling',
			label: 'Cabling Routes',
			count: cablesCount,
			status: cablesCount > 0 ? 'complete' : 'missing',
			identity_samples: sampleIds(cableRoutes.map((route) => route.id))
		},
		{
			key: 'transformers',
			label: 'Transformers',
			count: transformerComponents.length,
			status: transformerComponents.length > 0 ? 'complete' : 'missing',
			identity_samples: sampleIds(transformerComponents.map((component) => component.id))
		},
		{
			key: 'acdc_equipment',
			label: 'AC/DC Equipment',
			count: acDcCount,
			status: acDcCount > 0 ? 'complete' : 'missing',
			identity_samples: sampleIds(
				[...substationComponents, ...combinerComponents, ...trackerComponents].map((component) => component.id)
			)
		},
		{
			key: 'fault_identifiers',
			label: 'Fault Identifiers',
			count: faultEntities.length,
			status: faultEntities.length > 0 ? 'complete' : 'missing',
			identity_samples: sampleIds(faultEntities.map((entity) => entity.id))
		},
		{
			key: 'precision_fields',
			label: 'Precision Fields',
			count: precisionReady ? 1 : 0,
			status: precisionReady ? 'complete' : 'missing',
			identity_samples: precisionReady ? [`layout:${input.layout_id}:precision`] : []
		}
	];

	const completeCount = classes.filter((item) => item.status === 'complete').length;
	const coveragePercent = Math.round((completeCount / REQUIRED_CLASSES.length) * 100);
	const blockers = classes
		.filter((item) => item.status === 'missing')
		.map((item) => `${item.label} not ready`);

	return {
		generated_at: new Date().toISOString(),
		coverage_percent: coveragePercent,
		classes,
		blockers
	};
}

export function computeLod400Checklist(
	completeness: LayoutCompletenessSummary,
	workflowBlockers: string[]
): Lod400ChecklistSummary {
	const items: Lod400ChecklistItem[] = completeness.classes.map((entry) => {
		const pass = entry.status !== 'missing';
		return {
			key: entry.key,
			label: entry.label,
			required: true,
			status: entry.status,
			pass,
			reason: pass ? 'Ready for LOD 400 evidence review.' : `${entry.label} evidence is missing.`
		};
	});

	const blockerReasons = [
		...workflowBlockers.map((blocker) => `Workflow blocker: ${blocker}`),
		...items.filter((item) => !item.pass).map((item) => item.reason)
	];

	return {
		pass: blockerReasons.length === 0,
		items,
		blocker_reasons: blockerReasons
	};
}
