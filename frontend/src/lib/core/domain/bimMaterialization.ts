export interface ComputeMaterializationContext {
	sourceService: string;
	serviceVersion: string;
	stage: string;
	runId?: string;
	inputFingerprint?: string;
}

export type MaterializationKind =
	| 'route-centerline'
	| 'tower'
	| 'electrical-segment'
	| 'terrain-zone'
	| 'layout-table'
	| 'layout-row'
	| 'annotation';

export interface MaterializationEnvelopeDetails {
	discipline: string;
	bimObjectType: string;
	bimObjectId: string;
	bimRelationships: Array<Record<string, unknown> | { relation: string; targetType: string; targetId: string }>;
	materializationKind: MaterializationKind;
	nativeId?: string;
}

export function buildMaterializationRunId(context: ComputeMaterializationContext): string {
	if (context.runId && context.runId.trim().length > 0) {
		return context.runId.trim();
	}
	const safeService = context.sourceService.trim().toLowerCase().replace(/[^a-z0-9]+/g, '-');
	const safeStage = context.stage.trim().toLowerCase().replace(/[^a-z0-9]+/g, '-');
	return `${safeService}-${safeStage}-${Date.now()}`;
}

export function buildMaterializationMetadata(
	context: ComputeMaterializationContext,
	details: MaterializationEnvelopeDetails,
	extra: Record<string, unknown> = {}
): Record<string, unknown> {
	return {
		discipline: details.discipline,
		bimObjectType: details.bimObjectType,
		bimObjectId: details.bimObjectId,
		bimRelationships: details.bimRelationships.map((relationship) => ({
			...(relationship as Record<string, unknown>)
		})),
		materializationKind: details.materializationKind,
		nativeId: details.nativeId ?? '',
		compute: {
			sourceService: context.sourceService,
			serviceVersion: context.serviceVersion,
			stage: context.stage,
			runId: buildMaterializationRunId(context),
			inputFingerprint: context.inputFingerprint ?? ''
		},
		...extra
	};
}
