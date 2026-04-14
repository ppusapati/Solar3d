import { derived, get, writable } from 'svelte/store';

import {
	DrawingEntityType,
	FileFormat,
	PlotOutputFormat,
	type BlockDefinitionEntity,
	type DrawingEntity,
	type Drawing,
	type DrawingRevision,
	type LayerDefinitionEntity,
	type PublishedSheetArtifact,
	type RevisionPointer,
	type SheetEntity
} from '$lib/gen/drawing/v1/drawing_pb.js';
import { CadApiError, cadApi } from '$lib/core/api/cad';
import { BIM_IFC_CLASS, CAD_STANDARD_LAYERS, buildCadBimMetadata } from '$lib/core/domain/cadStandards';
import { BIM_OBJECT_TYPE, BIM_RELATIONSHIP_TYPE, buildBimEnvelope } from '$lib/core/domain/bimTaxonomy';
import { buildMaterializationMetadata, type ComputeMaterializationContext } from '$lib/core/domain/bimMaterialization';
import {
	buildElectricalNetworkGraph,
	countElectricalGroupingNodes,
	flattenElectricalTopologyToRelationships,
	getElectricalGroupingTreeDepth,
	validateElectricalTopologyParity,
	validateElectricalTopologyQuality
} from '$lib/core/domain/bimElectricalTopology';
import { activeTool } from './map';

type LonLatPoint = { x: number; y: number };

export interface TransmissionCadMaterializationInput {
	routeId: string;
	routeName?: string;
	voltageKv?: number;
	waypoints: LonLatPoint[];
	towerPoints?: LonLatPoint[];
	runId?: string;
	inputFingerprint?: string;
}

export interface ElectricalCadRouteSegment {
	segmentId: string;
	kind: 'dc' | 'ac';
	waypoints: LonLatPoint[];
}

export interface ElectricalGroupingNode {
	groupingId: string;
	groupingType: 'dc_string' | 'mppt_group' | 'inverter_route' | 'transformer_route';
	ownershipLabel?: string;
	voltage?: number;
	capacity?: number;
	childNodes: ElectricalGroupingNode[];
	childSegmentIds?: string[];
	provenance?: Record<string, unknown>;
}

export interface ElectricalCadMaterializationInput {
	networkId: string;
	networkName?: string;
	segments: ElectricalCadRouteSegment[];
	topologyRoots?: ElectricalGroupingNode[]; // New: grouping hierarchy for Sprint 8
	runId?: string;
	inputFingerprint?: string;
}

export interface TerrainCadZone {
	zoneId: string;
	zoneType: 'grading' | 'cut' | 'fill' | 'slope';
	vertices: LonLatPoint[];
	value?: number;
}

export interface TerrainCadMaterializationInput {
	analysisId: string;
	analysisName?: string;
	zones: TerrainCadZone[];
	runId?: string;
	inputFingerprint?: string;
}

export interface LayoutCadRow {
	rowId: string;
	vertices: LonLatPoint[];
}

export interface LayoutCadTable {
	tableId: string;
	boundaryVertices: LonLatPoint[];
	rowIds?: string[];
}

export interface LayoutCadMaterializationInput {
	layoutId: string;
	layoutName?: string;
	tables: LayoutCadTable[];
	rows: LayoutCadRow[];
	runId?: string;
	inputFingerprint?: string;
}

export interface CadMaterializationPipelineInput {
	runId?: string;
	inputFingerprint?: string;
	terrain?: Omit<TerrainCadMaterializationInput, 'runId' | 'inputFingerprint'>;
	layout?: Omit<LayoutCadMaterializationInput, 'runId' | 'inputFingerprint'>;
	transmission?: Omit<TransmissionCadMaterializationInput, 'runId' | 'inputFingerprint'>;
	electrical?: Omit<ElectricalCadMaterializationInput, 'runId' | 'inputFingerprint'>;
}

export interface CadMaterializationStageResult {
	stage: 'terrain' | 'layout' | 'transmission' | 'electrical';
	status: 'completed' | 'skipped';
	message: string;
	metrics?: {
		inputCount?: number;
		outputHint?: number;
		topologyNodeCount?: number;
		topologyDepth?: number;
		topologyRelationshipCount?: number;
		qualityViolations?: number;
	};
}

export interface CadMaterializationRunRecord {
	runId: string;
	inputFingerprint: string;
	timestampMs: number;
	results: CadMaterializationStageResult[];
}

export interface CadDiagnosticsConfig {
	healthPenaltyPerViolation: number;
	healthPenaltyRecentAverage: number;
	healthPenaltyRegression: number;
	healthPenaltyExcessDepth: number;
	depthBaseline: number;
	regressionStreakThreshold: number;
	averageWindowSize: number;
}

export type CadDiagnosticsPreset = 'balanced' | 'strict' | 'lenient';

export type CadDiagnosticsConfigSource = 'manual' | 'preset-balanced' | 'preset-strict' | 'preset-lenient' | 'reset';

export interface CadDiagnosticsConfigMeta {
	source: CadDiagnosticsConfigSource;
	timestampMs: number;
	summary: string;
}

export interface CadDiagnosticsConfigHistoryEntry {
	entryId: string;
	config: CadDiagnosticsConfig;
	source: CadDiagnosticsConfigSource;
	timestampMs: number;
	summary: string;
	changedFields: Array<keyof CadDiagnosticsConfig>;
}

export interface CadWorkspaceState {
	isReady: boolean;
	isBusy: boolean;
	error: string;
	drawing: Drawing | null;
	revision: DrawingRevision | null;
	revisions: RevisionPointer[];
	publishManifestJson: string;
	publishArtifacts: PublishedSheetArtifact[];
	entityTypeCounts: Record<string, number>;
	selectedBlockDefinitionId: string;
	pendingMapInsertBlockId: string;
	conflictStats: {
		total: number;
		recovered: number;
		failed: number;
		retries: number;
		lastRecoveryLatencyMs: number;
		maxRecoveryLatencyMs: number;
	};
	conflictState: 'idle' | 'refreshing' | 'retrying' | 'failed' | 'resolved';
	lastConflictMessage: string;
	lastMaterializationResults: CadMaterializationStageResult[];
	materializationHistory: CadMaterializationRunRecord[];
	diagnosticsConfig: CadDiagnosticsConfig;
	diagnosticsConfigMeta: CadDiagnosticsConfigMeta;
	diagnosticsConfigHistory: CadDiagnosticsConfigHistoryEntry[];
}

const DEFAULT_DIAGNOSTICS_CONFIG: CadDiagnosticsConfig = {
	healthPenaltyPerViolation: 12,
	healthPenaltyRecentAverage: 5,
	healthPenaltyRegression: 15,
	healthPenaltyExcessDepth: 4,
	depthBaseline: 4,
	regressionStreakThreshold: 2,
	averageWindowSize: 5
};

const DIAGNOSTICS_PRESETS: Record<CadDiagnosticsPreset, CadDiagnosticsConfig> = {
	balanced: { ...DEFAULT_DIAGNOSTICS_CONFIG },
	strict: {
		healthPenaltyPerViolation: 16,
		healthPenaltyRecentAverage: 7,
		healthPenaltyRegression: 22,
		healthPenaltyExcessDepth: 6,
		depthBaseline: 4,
		regressionStreakThreshold: 2,
		averageWindowSize: 6
	},
	lenient: {
		healthPenaltyPerViolation: 8,
		healthPenaltyRecentAverage: 3,
		healthPenaltyRegression: 8,
		healthPenaltyExcessDepth: 2,
		depthBaseline: 5,
		regressionStreakThreshold: 3,
		averageWindowSize: 4
	}
};

const DIAGNOSTICS_CONFIG_HISTORY_LIMIT = 50;

let diagnosticsConfigHistorySequence = 0;

function cloneDiagnosticsConfig(config: CadDiagnosticsConfig): CadDiagnosticsConfig {
	return { ...config };
}

function clampDiagnosticsConfig(input: Partial<CadDiagnosticsConfig>, current: CadDiagnosticsConfig): CadDiagnosticsConfig {
	return {
		healthPenaltyPerViolation: Math.max(1, Math.min(50, input.healthPenaltyPerViolation ?? current.healthPenaltyPerViolation)),
		healthPenaltyRecentAverage: Math.max(0, Math.min(25, input.healthPenaltyRecentAverage ?? current.healthPenaltyRecentAverage)),
		healthPenaltyRegression: Math.max(0, Math.min(40, input.healthPenaltyRegression ?? current.healthPenaltyRegression)),
		healthPenaltyExcessDepth: Math.max(0, Math.min(20, input.healthPenaltyExcessDepth ?? current.healthPenaltyExcessDepth)),
		depthBaseline: Math.max(1, Math.min(12, input.depthBaseline ?? current.depthBaseline)),
		regressionStreakThreshold: Math.max(1, Math.min(5, Math.floor(input.regressionStreakThreshold ?? current.regressionStreakThreshold))),
		averageWindowSize: Math.max(1, Math.min(12, Math.floor(input.averageWindowSize ?? current.averageWindowSize)))
	};
}

function getDiagnosticsConfigChangedFields(
	previous: CadDiagnosticsConfig,
	next: CadDiagnosticsConfig
): Array<keyof CadDiagnosticsConfig> {
	const fields = Object.keys(next) as Array<keyof CadDiagnosticsConfig>;
	return fields.filter((field) => previous[field] !== next[field]);
}

function describeDiagnosticsConfigSummary(
	source: CadDiagnosticsConfigSource,
	changedFields: Array<keyof CadDiagnosticsConfig>,
	summaryOverride?: string
): string {
	if (summaryOverride) {
		return summaryOverride;
	}

	if (source === 'reset') {
		return 'Reset diagnostics tuning to defaults';
	}

	if (source.startsWith('preset-')) {
		return `Applied ${source.replace('preset-', '')} diagnostics preset`;
	}

	if (changedFields.length === 0) {
		return 'Reapplied diagnostics tuning';
	}

	return `Updated ${changedFields.length} diagnostics tuning value${changedFields.length === 1 ? '' : 's'}`;
}

function buildDiagnosticsConfigHistoryEntry(
	config: CadDiagnosticsConfig,
	source: CadDiagnosticsConfigSource,
	timestampMs: number,
	changedFields: Array<keyof CadDiagnosticsConfig>,
	summary: string
): CadDiagnosticsConfigHistoryEntry {
	diagnosticsConfigHistorySequence += 1;
	return {
		entryId: `diag-config-${timestampMs}-${diagnosticsConfigHistorySequence}`,
		config: cloneDiagnosticsConfig(config),
		source,
		timestampMs,
		summary,
		changedFields: [...changedFields]
	};
}

function commitDiagnosticsConfig(
	state: CadWorkspaceState,
	config: CadDiagnosticsConfig,
	source: CadDiagnosticsConfigSource,
	summaryOverride?: string
): CadWorkspaceState {
	const timestampMs = Date.now();
	const changedFields = getDiagnosticsConfigChangedFields(state.diagnosticsConfig, config);
	const summary = describeDiagnosticsConfigSummary(source, changedFields, summaryOverride);
	const entry = buildDiagnosticsConfigHistoryEntry(config, source, timestampMs, changedFields, summary);
	return {
		...state,
		diagnosticsConfig: cloneDiagnosticsConfig(config),
		diagnosticsConfigMeta: {
			source,
			timestampMs,
			summary
		},
		diagnosticsConfigHistory: [entry, ...state.diagnosticsConfigHistory].slice(0, DIAGNOSTICS_CONFIG_HISTORY_LIMIT)
	};
}

function createInitialState(): CadWorkspaceState {
	const diagnosticsConfig = cloneDiagnosticsConfig(DEFAULT_DIAGNOSTICS_CONFIG);
	return {
		isReady: false,
		isBusy: false,
		error: '',
		drawing: null,
		revision: null,
		revisions: [],
		publishManifestJson: '',
		publishArtifacts: [],
		entityTypeCounts: {},
		selectedBlockDefinitionId: '',
		pendingMapInsertBlockId: '',
		conflictStats: {
			total: 0,
			recovered: 0,
			failed: 0,
			retries: 0,
			lastRecoveryLatencyMs: 0,
			maxRecoveryLatencyMs: 0
		},
		conflictState: 'idle',
		lastConflictMessage: '',
		lastMaterializationResults: [],
		materializationHistory: [],
		diagnosticsConfig,
		diagnosticsConfigMeta: {
			source: 'reset',
			timestampMs: Date.now(),
			summary: 'Reset diagnostics tuning to defaults'
		},
		diagnosticsConfigHistory: []
	};
}

const initialState = createInitialState();

export const cadWorkspace = writable<CadWorkspaceState>({ ...initialState });

export const cadDrawing = derived(cadWorkspace, ($state) => $state.drawing);
export const cadRevision = derived(cadWorkspace, ($state) => $state.revision);
export const cadReady = derived(cadWorkspace, ($state) => $state.isReady);
export const cadBusy = derived(cadWorkspace, ($state) => $state.isBusy);
export const cadError = derived(cadWorkspace, ($state) => $state.error);
export const cadBlockDefinitions = derived(cadWorkspace, ($state) => getCadBlockDefinitions($state.revision));
export const selectedCadBlockDefinitionId = derived(cadWorkspace, ($state) => $state.selectedBlockDefinitionId);
export const cadPendingMapInsertBlockId = derived(cadWorkspace, ($state) => $state.pendingMapInsertBlockId);
export const cadConflictState = derived(cadWorkspace, ($state) => $state.conflictState);
export const cadLastMaterializationResults = derived(cadWorkspace, ($state) => $state.lastMaterializationResults);
export const cadMaterializationHistory = derived(cadWorkspace, ($state) => $state.materializationHistory);
export const cadDiagnosticsConfig = derived(cadWorkspace, ($state) => $state.diagnosticsConfig);
export const cadDiagnosticsConfigMeta = derived(cadWorkspace, ($state) => $state.diagnosticsConfigMeta);
export const cadDiagnosticsConfigHistory = derived(cadWorkspace, ($state) => $state.diagnosticsConfigHistory);
export const cadElectricalDiagnostics = derived(cadWorkspace, ($state) => {
	const electrical = $state.lastMaterializationResults.find((entry) => entry.stage === 'electrical');
	if (!electrical) {
		return {
			hasData: false,
			status: 'unknown',
			summary: 'No electrical pipeline run yet',
			metrics: null as CadMaterializationStageResult['metrics'] | null
		};
	}
	const metrics = electrical.metrics;
	const hasViolations = (metrics?.qualityViolations ?? 0) > 0;
	return {
		hasData: true,
		status: hasViolations ? 'warning' : 'ok',
		summary: electrical.message,
		metrics: metrics ?? null
	};
});
export const cadElectricalDiagnosticsHistory = derived(cadWorkspace, ($state) => {
	const history = $state.materializationHistory;
	return history
		.map((run, index) => {
			const electrical = run.results.find((entry) => entry.stage === 'electrical');
			const currentViolations = electrical?.metrics?.qualityViolations ?? 0;
			const previous = history[index + 1]?.results.find((entry) => entry.stage === 'electrical');
			const previousViolations = previous?.metrics?.qualityViolations ?? 0;
			return {
				runId: run.runId,
				timestampMs: run.timestampMs,
				qualityViolations: currentViolations,
				deltaFromPrevious: index + 1 < history.length ? currentViolations - previousViolations : 0,
				topologyNodeCount: electrical?.metrics?.topologyNodeCount ?? 0,
				topologyDepth: electrical?.metrics?.topologyDepth ?? 0
			};
		})
		.slice(0, 5);
});
export const cadElectricalRegressionAlert = derived([cadElectricalDiagnosticsHistory, cadWorkspace], ([$history, $state]) => {
	const threshold = Math.max(1, Math.floor($state.diagnosticsConfig.regressionStreakThreshold));
	if ($history.length < 3) {
		return {
			active: false,
			streak: 0,
			message: 'Insufficient run history for regression trend'
		};
	}

	let streak = 0;
	for (let i = 0; i < $history.length; i += 1) {
		if (($history[i].deltaFromPrevious ?? 0) > 0) {
			streak += 1;
		} else {
			break;
		}
	}

	if (streak >= threshold) {
		return {
			active: true,
			streak,
			message: `Quality regression detected: violations increased for ${streak} consecutive runs (threshold ${threshold})`
		};
	}

	return {
		active: false,
		streak,
		message: 'No sustained regression trend detected'
	};
});
export const cadElectricalDiagnosticsIntelligence = derived(
	[cadWorkspace, cadElectricalRegressionAlert],
	([$state, $regression]) => {
		const cfg = $state.diagnosticsConfig;
		const electrical = $state.lastMaterializationResults.find((entry) => entry.stage === 'electrical');
		const currentViolations = electrical?.metrics?.qualityViolations ?? 0;
		const topologyDepth = electrical?.metrics?.topologyDepth ?? 0;
		const topologyNodes = electrical?.metrics?.topologyNodeCount ?? 0;
		const inputCount = electrical?.metrics?.inputCount ?? 0;
		const averageWindow = Math.max(1, Math.floor(cfg.averageWindowSize));
		const recent = $state.materializationHistory
			.slice(0, averageWindow)
			.map((run) => run.results.find((entry) => entry.stage === 'electrical')?.metrics?.qualityViolations ?? 0);
		const recentAverage = recent.length > 0
			? recent.reduce((sum, value) => sum + value, 0) / recent.length
			: 0;

		const rawHealth =
			100 -
			currentViolations * cfg.healthPenaltyPerViolation -
			recentAverage * cfg.healthPenaltyRecentAverage -
			($regression.active ? cfg.healthPenaltyRegression : 0) -
			Math.max(0, topologyDepth - cfg.depthBaseline) * cfg.healthPenaltyExcessDepth;
		const healthScore = Math.max(0, Math.min(100, Math.round(rawHealth)));

		const trend = $regression.active
			? 'declining'
			: currentViolations === 0 && recentAverage <= 0.5
				? 'improving'
				: 'stable';

		const recommendations: string[] = [];
		if (currentViolations > 0) {
			recommendations.push('Resolve electrical topology quality violations before release promotion.');
		}
		if (inputCount > 0 && topologyNodes === 0) {
			recommendations.push('Provide topology roots for electrical runs so diagnostics can enforce grouping parity.');
		}
		if (topologyDepth > 4) {
			recommendations.push('Review deep topology chains and flatten hierarchy where possible to reduce orchestration fragility.');
		}
		if ($regression.active) {
			recommendations.push('Regression alert active: block deployment and run targeted remediation on latest two runs.');
		}
		if (recommendations.length === 0) {
			recommendations.push('Electrical diagnostics are healthy. Continue normal monitoring cadence.');
		}

		return {
			healthScore,
			trend,
			recentAverageViolations: Number(recentAverage.toFixed(2)),
			recommendations
		};
	}
);

const MAX_STALE_RETRIES = 2;
const MAX_MATERIALIZATION_HISTORY = 12;

function getRevisionEntities(revision: DrawingRevision | null | undefined): DrawingEntity[] {
	if (!revision || !Array.isArray(revision.entities)) {
		return [];
	}
	return revision.entities.filter((entity): entity is DrawingEntity => Boolean(entity));
}

function geometryValue<T>(entity: DrawingEntity | null | undefined, kind: DrawingEntity['geometry']['case']): T | null {
	if (!entity?.geometry || entity.geometry.case !== kind) {
		return null;
	}
	return entity.geometry.value as T;
}

function getRevisionSheets(revision: DrawingRevision | null | undefined): SheetEntity[] {
	return getRevisionEntities(revision)
		.map((entity) => geometryValue<SheetEntity>(entity, 'sheet'))
		.filter((sheet): sheet is SheetEntity => Boolean(sheet?.sheetId));
}

function entityMetadata(entity: DrawingEntity | null | undefined): Record<string, unknown> {
	const raw = entity?.header?.metadataJson;
	if (!raw) {
		return {};
	}
	try {
		const parsed = JSON.parse(raw) as Record<string, unknown>;
		return parsed && typeof parsed === 'object' ? parsed : {};
	} catch {
		return {};
	}
}

function isTransmissionRouteEntity(entity: DrawingEntity, routeId: string): boolean {
	const metadata = entityMetadata(entity);
	return metadata.discipline === 'transmission' && metadata.transmissionRouteId === routeId;
}

function isElectricalNetworkEntity(entity: DrawingEntity, networkId: string): boolean {
	const metadata = entityMetadata(entity);
	return metadata.discipline === 'electrical' && metadata.electricalNetworkId === networkId;
}

function isTerrainAnalysisEntity(entity: DrawingEntity, analysisId: string): boolean {
	const metadata = entityMetadata(entity);
	return metadata.discipline === 'civil' && metadata.terrainAnalysisId === analysisId;
}

function isLayoutEntity(entity: DrawingEntity, layoutId: string): boolean {
	const metadata = entityMetadata(entity);
	return metadata.discipline === 'layout' && metadata.layoutId === layoutId;
}

function ensureClosedRing(vertices: LonLatPoint[]): LonLatPoint[] {
	if (vertices.length < 3) {
		return vertices;
	}
	const first = vertices[0];
	const last = vertices[vertices.length - 1];
	if (first.x === last.x && first.y === last.y) {
		return vertices;
	}
	return [...vertices, first];
}

function computeElectricalPipelineMetrics(input: Omit<ElectricalCadMaterializationInput, 'runId' | 'inputFingerprint'>) {
	const base = {
		inputCount: input.segments.length,
		outputHint: input.segments.length,
		topologyNodeCount: 0,
		topologyDepth: 0,
		topologyRelationshipCount: 0,
		qualityViolations: 0
	};

	if (!input.topologyRoots || input.topologyRoots.length === 0) {
		return base;
	}

	const graph = buildElectricalNetworkGraph(input.networkId, input.networkName, input.topologyRoots);
	const parity = validateElectricalTopologyParity(graph);
	const quality = validateElectricalTopologyQuality(
		graph,
		input.segments.map((segment) => segment.segmentId)
	);
	const topologyNodeCount = input.topologyRoots.reduce((sum, root) => sum + countElectricalGroupingNodes(root), 0);
	const topologyDepth = input.topologyRoots.reduce((maxDepth, root) => Math.max(maxDepth, getElectricalGroupingTreeDepth(root)), 0);
	const topologyRelationshipCount = flattenElectricalTopologyToRelationships(graph).length;

	return {
		...base,
		topologyNodeCount,
		topologyDepth,
		topologyRelationshipCount,
		qualityViolations: parity.violations.length + quality.violations.length
	};
}

function setBusy(isBusy: boolean) {
	cadWorkspace.update((state) => ({ ...state, isBusy }));
}

function setError(error: unknown) {
	const message = error instanceof Error ? error.message : String(error);
	cadWorkspace.update((state) => ({ ...state, error: message, isBusy: false, conflictState: 'failed' }));
}

function isStaleRevisionError(error: unknown): boolean {
	if (error instanceof CadApiError) {
		const code = error.code.toLowerCase();
		if (code === 'stale_revision') {
			return true;
		}
		return code === 'failed_precondition' && error.message.toLowerCase().includes('stale');
	}
	const message = (error instanceof Error ? error.message : String(error)).toLowerCase();
	return message.includes('stale') && (message.includes('failed_precondition') || message.includes('base revision'));
}

function staleConflictMessage(error: unknown): string {
	if (error instanceof CadApiError && error.baseRevisionId && error.headRevisionId) {
		const headVersionSuffix = typeof error.headVersion === 'number' && Number.isFinite(error.headVersion)
			? ` Head version ${error.headVersion}.`
			: '';
		const attemptSuffix = error.attemptId ? ` Attempt ${error.attemptId}.` : '';
		return `Revision ${error.baseRevisionId} is stale. Current head is ${error.headRevisionId}.${headVersionSuffix}${attemptSuffix} Refreshing latest CAD state...`;
	}
	return 'Revision stale. Refreshing latest CAD state...';
}

function retryDelayMs(error: unknown, attempt: number): number {
	if (error instanceof CadApiError && typeof error.retryAfterMs === 'number' && error.retryAfterMs > 0) {
		return error.retryAfterMs;
	}
	return staleRetryBackoffMs(attempt);
}

function recordStaleConflict(recovered: boolean, incrementRetry = false, recoveryLatencyMs = 0) {
	cadWorkspace.update((state) => ({
		...state,
		conflictStats: {
			total: state.conflictStats.total + 1,
			recovered: state.conflictStats.recovered + (recovered ? 1 : 0),
			failed: state.conflictStats.failed + (recovered ? 0 : 1),
			retries: state.conflictStats.retries + (incrementRetry ? 1 : 0),
			lastRecoveryLatencyMs: recoveryLatencyMs,
			maxRecoveryLatencyMs: Math.max(state.conflictStats.maxRecoveryLatencyMs, recoveryLatencyMs)
		},
		conflictState: recovered ? 'resolved' : 'retrying'
	}));
}

function setConflictState(state: CadWorkspaceState['conflictState'], message = '') {
	cadWorkspace.update((s) => ({ ...s, conflictState: state, lastConflictMessage: message || s.lastConflictMessage }));
}

function delay(ms: number): Promise<void> {
	return new Promise((resolve) => setTimeout(resolve, ms));
}

function staleRetryBackoffMs(attempt: number): number {
	const base = Math.min(1200, 150 * Math.pow(2, attempt));
	const jitter = Math.floor(Math.random() * 90);
	return base + jitter;
}

async function refreshCadWorkspaceInternal() {
	const state = get(cadWorkspace);
	if (!state.drawing) {
		return;
	}
	const context = await cadApi.getDrawingState(state.drawing.drawingId, state.revision?.pointer?.revisionId);
	const revisions = await cadApi.listDrawingRevisions(context.drawing.drawingId, 100);
	setContext(context.drawing, context.revision, revisions);
}

function finalizeWriteConflictState(retryAttempt: number, firstStaleAtMs: number) {
	if (retryAttempt > 0) {
		recordStaleConflict(true, false, Math.max(0, Date.now() - firstStaleAtMs));
		setConflictState('resolved', 'CAD conflict resolved automatically.');
		return;
	}
	setConflictState('idle', '');
}

async function executeCadWrite<T>(
	perform: () => Promise<T>,
	applyResult: (result: T) => Promise<void> | void,
	retryAttempt = 0,
	firstStaleAtMs = 0
): Promise<void> {
	setBusy(true);
	try {
		setConflictState('idle', '');
		const result = await perform();
		await applyResult(result);
	} catch (error) {
		if (isStaleRevisionError(error) && retryAttempt < MAX_STALE_RETRIES) {
			const staleAtMs = firstStaleAtMs > 0 ? firstStaleAtMs : Date.now();
			setConflictState('refreshing', staleConflictMessage(error));
			recordStaleConflict(false, true);
			try {
				await refreshCadWorkspaceInternal();
			} catch (refreshError) {
				setError(refreshError);
				return;
			}
			setConflictState('retrying', 'Retrying CAD operation on latest revision...');
			await delay(retryDelayMs(error, retryAttempt));
			return executeCadWrite(perform, applyResult, retryAttempt + 1, staleAtMs);
		}
		if (isStaleRevisionError(error)) {
			recordStaleConflict(false);
		}
		setError(error);
		return;
	}
	finalizeWriteConflictState(retryAttempt, firstStaleAtMs);
}

export function getCadBlockDefinitions(revision: DrawingRevision | null | undefined): BlockDefinitionEntity[] {
	return getRevisionEntities(revision)
		.map((entity) => geometryValue<BlockDefinitionEntity>(entity, 'blockDefinition'))
		.filter((block): block is BlockDefinitionEntity => Boolean(block?.blockDefinitionId));
}

function normalizeBlockSelection(
	blockDefinitions: BlockDefinitionEntity[],
	requestedSelectedBlockId: string,
	requestedPendingMapInsertBlockId: string
) {
	const blockIds = new Set(blockDefinitions.map((block) => block.blockDefinitionId));
	const fallbackBlockId = blockDefinitions[0]?.blockDefinitionId ?? '';
	const selectedBlockDefinitionId = blockIds.has(requestedSelectedBlockId)
		? requestedSelectedBlockId
		: fallbackBlockId;
	const pendingMapInsertBlockId = blockIds.has(requestedPendingMapInsertBlockId)
		? requestedPendingMapInsertBlockId
		: '';

	return {
		selectedBlockDefinitionId,
		pendingMapInsertBlockId
	};
}

function setContext(
	drawing: Drawing,
	revision: DrawingRevision,
	revisions: RevisionPointer[] = [],
	overrides: {
		selectedBlockDefinitionId?: string;
		pendingMapInsertBlockId?: string;
	} = {}
) {
	cadWorkspace.update((state) => ({
		...state,
		...normalizeBlockSelection(
			getCadBlockDefinitions(revision),
			overrides.selectedBlockDefinitionId ?? state.selectedBlockDefinitionId,
			overrides.pendingMapInsertBlockId ?? state.pendingMapInsertBlockId
		),
		isReady: true,
		isBusy: false,
		error: '',
		drawing,
		revision,
		revisions,
		entityTypeCounts: cadApi.inferEntityTypeCounts(revision)
	}));
}

function requireContext(): { drawing: Drawing; revision: DrawingRevision } {
	const state = get(cadWorkspace);
	if (!state.drawing || !state.revision) {
		throw new Error('CAD workspace is not initialized');
	}
	return { drawing: state.drawing, revision: state.revision };
}

export async function initializeCadWorkspace(projectId: string, projectName: string) {
	setBusy(true);
	try {
		const context = await cadApi.ensureProjectDrawing(projectId, projectName);
		const revisions = await cadApi.listDrawingRevisions(context.drawing.drawingId, 100);
		setContext(context.drawing, context.revision, revisions);
	} catch (error) {
		setError(error);
	}
}

export async function refreshCadWorkspace() {
	setBusy(true);
	try {
		await refreshCadWorkspaceInternal();
	} catch (error) {
		setError(error);
	}
}

export async function createCadLayer(input: {
	name: string;
	colorHex: string;
	lineType: string;
	lineWeightMm: number;
	visible: boolean;
	locked: boolean;
	plottable: boolean;
	}) {
	return executeCadWrite(async () => {
		const { drawing, revision } = requireContext();
		const layer: LayerDefinitionEntity = {
			$typeName: 'drawing.v1.LayerDefinitionEntity',
			layerId: `layer_${Date.now()}`,
			name: input.name,
			colorHex: input.colorHex,
			lineType: input.lineType,
			lineWeightMm: input.lineWeightMm,
			visible: input.visible,
			locked: input.locked,
			plottable: input.plottable
		};
		return cadApi.upsertLayer({ drawingId: drawing.drawingId, revision, layer });
	}, async (updated) => {
		const revisions = await cadApi.listDrawingRevisions(updated.drawing.drawingId, 100);
		setContext(updated.drawing, updated.revision, revisions);
	});
}

export async function createCadBlockDefinition(input: { name: string; label: string }) {
	return executeCadWrite(async () => {
		const { drawing, revision } = requireContext();
		const block: BlockDefinitionEntity = {
			$typeName: 'drawing.v1.BlockDefinitionEntity',
			blockDefinitionId: `block_${Date.now()}`,
			name: input.name,
			basePoint: { $typeName: 'common.v1.Point2D', x: 0, y: 0 },
			entities: [
				{
					$typeName: 'drawing.v1.DrawingEntity',
					header: {
						$typeName: 'drawing.v1.EntityHeader',
						entityId: `text_${Date.now()}`,
						drawingId: drawing.drawingId,
						entityType: DrawingEntityType.TEXT,
						layer: {
							$typeName: 'drawing.v1.LayerRef',
							layerId: CAD_STANDARD_LAYERS.BLOCKS.id,
							layerName: CAD_STANDARD_LAYERS.BLOCKS.name
						},
						style: { $typeName: 'drawing.v1.StyleRef', styleId: '', styleName: 'Default' },
						metadataJson: buildCadBimMetadata('create-block-definition-text', BIM_IFC_CLASS.ANNOTATION, {
							discipline: 'electrical-layout'
						})
					},
					geometry: {
						case: 'text',
						value: {
							$typeName: 'drawing.v1.TextEntity',
							anchor: { $typeName: 'common.v1.Point2D', x: 0, y: 0 },
							text: input.label,
							rotationDeg: 0,
							height: 1,
							fontFamily: 'Arial'
						}
					}
				}
			],
			defaultAttributes: {}
		};
		return cadApi.createBlockDefinition({ drawingId: drawing.drawingId, revision, block });
	}, async (updated) => {
		const revisions = await cadApi.listDrawingRevisions(updated.drawing.drawingId, 100);
		setContext(updated.drawing, updated.revision, revisions, {
			selectedBlockDefinitionId: updated.revision.entities
				?.map((entity) => geometryValue<BlockDefinitionEntity>(entity as DrawingEntity, 'blockDefinition'))
				.filter((block): block is BlockDefinitionEntity => Boolean(block?.blockDefinitionId))
				.find((block) => block.name === input.name.trim())?.blockDefinitionId ?? ''
		});
	});
}

export async function insertCadBlockReference(input: {
	blockDefinitionId: string;
	x: number;
	y: number;
}) {
	return executeCadWrite(async () => {
		const { drawing, revision } = requireContext();
		return cadApi.insertBlockReference({
			drawingId: drawing.drawingId,
			revision,
			blockDefinitionId: input.blockDefinitionId,
			point: { x: input.x, y: input.y }
		});
	}, async (updated) => {
		const revisions = await cadApi.listDrawingRevisions(updated.drawing.drawingId, 100);
		setContext(updated.drawing, updated.revision, revisions, {
			selectedBlockDefinitionId: input.blockDefinitionId,
			pendingMapInsertBlockId: ''
		});
	});
}

export async function createCadSheet(input: {
	title: string;
	widthMm: number;
	heightMm: number;
	viewScale: number;
}) {
	return executeCadWrite(async () => {
		const { drawing, revision } = requireContext();
		const sheet: SheetEntity = {
			$typeName: 'drawing.v1.SheetEntity',
			sheetId: `sheet_${Date.now()}`,
			title: input.title,
			pageWidthMm: input.widthMm,
			pageHeightMm: input.heightMm,
			viewScale: input.viewScale,
			viewportEntityIds: [],
			titleBlockName: 'Solar3D Standard',
			metadataJson: '{}'
		};
		return cadApi.createSheet({ drawingId: drawing.drawingId, revision, sheet });
	}, async (updated) => {
		const revisions = await cadApi.listDrawingRevisions(updated.drawing.drawingId, 100);
		setContext(updated.drawing, updated.revision, revisions);
	});
}

export async function createCadDimensionFromMap(input: {
	start: { x: number; y: number };
	end: { x: number; y: number };
}) {
	return executeCadWrite(async () => {
		const { drawing, revision } = requireContext();
		return cadApi.createDimensionAnnotation({
			drawingId: drawing.drawingId,
			revision,
			start: input.start,
			end: input.end
		});
	}, async (updated) => {
		const revisions = await cadApi.listDrawingRevisions(updated.drawing.drawingId, 100);
		setContext(updated.drawing, updated.revision, revisions);
	});
}

export async function materializeTransmissionRouteToCad(input: TransmissionCadMaterializationInput) {
	return executeCadWrite(async () => {
		const routeId = input.routeId.trim();
		if (!routeId) {
			throw new Error('Transmission route ID is required');
		}
		if (!input.waypoints || input.waypoints.length < 2) {
			throw new Error('Transmission route requires at least 2 waypoints');
		}

		const { drawing, revision } = requireContext();
		const retainedEntities = getRevisionEntities(revision).filter((entity) => !isTransmissionRouteEntity(entity, routeId));
		const materializationContext: ComputeMaterializationContext = {
			sourceService: 'transmission-routing-service',
			serviceVersion: 'v1',
			stage: 'route-materialization',
			runId: input.runId,
			inputFingerprint: input.inputFingerprint
		};
		const routeEnvelope = buildBimEnvelope({
			objectType: BIM_OBJECT_TYPE.TRANSMISSION_CORRIDOR,
			nativeId: routeId,
			relationships: (input.towerPoints ?? []).map((_, index) => ({
				relation: BIM_RELATIONSHIP_TYPE.SUPPORTED_BY,
				targetType: BIM_OBJECT_TYPE.TRANSMISSION_TOWER,
				targetId: `${routeId}-tower-${index + 1}`
			}))
		});
		const transmissionMetadata = buildMaterializationMetadata(
			materializationContext,
			{
				discipline: 'transmission',
				bimObjectType: routeEnvelope.objectType,
				bimObjectId: routeEnvelope.objectId,
				bimRelationships: routeEnvelope.relationships,
				materializationKind: 'route-centerline',
				nativeId: routeId
			},
			{
				transmissionRouteId: routeId,
				transmissionRouteName: input.routeName ?? '',
				voltageKv: input.voltageKv ?? null
			}
		);

		const routeEntity: DrawingEntity = {
			$typeName: 'drawing.v1.DrawingEntity',
			header: {
				$typeName: 'drawing.v1.EntityHeader',
				entityId: `tx_route_${Date.now()}`,
				drawingId: drawing.drawingId,
				entityType: DrawingEntityType.POLYLINE,
				layer: {
					$typeName: 'drawing.v1.LayerRef',
					layerId: CAD_STANDARD_LAYERS.TRANSMISSION.id,
					layerName: CAD_STANDARD_LAYERS.TRANSMISSION.name
				},
				style: { $typeName: 'drawing.v1.StyleRef', styleId: '', styleName: 'TransmissionRoute' },
				metadataJson: buildCadBimMetadata('materialize-transmission-route', BIM_IFC_CLASS.FLOW_SEGMENT, transmissionMetadata)
			},
			geometry: {
				case: 'polyline',
				value: {
					$typeName: 'drawing.v1.PolylineEntity',
					vertices: input.waypoints.map((point) => ({
						$typeName: 'common.v1.Point2D',
						x: point.x,
						y: point.y
					})),
					closed: false
				}
			}
		};

		const towerEntities: DrawingEntity[] = (input.towerPoints ?? []).map((point, index) => {
			const towerEnvelope = buildBimEnvelope({
				objectType: BIM_OBJECT_TYPE.TRANSMISSION_TOWER,
				nativeId: `${routeId}-tower-${index + 1}`
			});

			const towerMetadata = buildMaterializationMetadata(
				materializationContext,
				{
					discipline: 'transmission',
					bimObjectType: towerEnvelope.objectType,
					bimObjectId: towerEnvelope.objectId,
					bimRelationships: towerEnvelope.relationships,
					materializationKind: 'tower',
					nativeId: `${routeId}-tower-${index + 1}`
				},
				{
					transmissionRouteId: routeId,
					transmissionRouteName: input.routeName ?? '',
					voltageKv: input.voltageKv ?? null,
					towerIndex: index + 1
				}
			);

			return {
				$typeName: 'drawing.v1.DrawingEntity',
				header: {
					$typeName: 'drawing.v1.EntityHeader',
					entityId: `tx_tower_${Date.now()}_${index + 1}`,
					drawingId: drawing.drawingId,
					entityType: DrawingEntityType.BLOCK_REFERENCE,
					layer: {
						$typeName: 'drawing.v1.LayerRef',
						layerId: CAD_STANDARD_LAYERS.TRANSMISSION.id,
						layerName: CAD_STANDARD_LAYERS.TRANSMISSION.name
					},
					style: { $typeName: 'drawing.v1.StyleRef', styleId: '', styleName: 'TransmissionTower' },
					metadataJson: buildCadBimMetadata('materialize-transmission-tower', BIM_IFC_CLASS.BUILDING_ELEMENT_PROXY, towerMetadata)
				},
				geometry: {
					case: 'blockReference',
					value: {
						$typeName: 'drawing.v1.BlockReferenceEntity',
						blockDefinitionId: 'transmission_tower',
						insertionPoint: { $typeName: 'common.v1.Point2D', x: point.x, y: point.y },
						rotationDeg: 0,
						scaleX: 1,
						scaleY: 1,
						attributes: {
							towerIndex: String(index + 1),
							routeId
						}
					}
				}
			};
		});

		return cadApi.storeDrawingRevision({
			drawingId: drawing.drawingId,
			summary: `Materialize transmission route ${routeId}`,
			entities: [...retainedEntities, routeEntity, ...towerEntities]
		});
	}, async (updated) => {
		const revisions = await cadApi.listDrawingRevisions(updated.drawing.drawingId, 100);
		setContext(updated.drawing, updated.revision, revisions);
	});
}

export async function materializeElectricalNetworkToCad(input: ElectricalCadMaterializationInput) {
	return executeCadWrite(async () => {
		const networkId = input.networkId.trim();
		if (!networkId) {
			throw new Error('Electrical network ID is required');
		}
		if (!input.segments || input.segments.length === 0) {
			throw new Error('Electrical materialization requires at least one segment');
		}

		// Sprint 8: Validate electrical topology parity if grouping roots are provided
		if (input.topologyRoots && input.topologyRoots.length > 0) {
			const graph = buildElectricalNetworkGraph(networkId, input.networkName, input.topologyRoots);
			const parityCheck = validateElectricalTopologyParity(graph);
			if (!parityCheck.isValid) {
				throw new Error(`Electrical topology validation failed: ${parityCheck.violations.join('; ')}`);
			}
			const qualityCheck = validateElectricalTopologyQuality(
				graph,
				input.segments.map((segment) => segment.segmentId)
			);
			if (!qualityCheck.isValid) {
				throw new Error(`Electrical topology quality validation failed: ${qualityCheck.violations.join('; ')}`);
			}
		}

		const { drawing, revision } = requireContext();
		const retainedEntities = getRevisionEntities(revision).filter((entity) => !isElectricalNetworkEntity(entity, networkId));
		const materializationContext: ComputeMaterializationContext = {
			sourceService: 'electrical-service',
			serviceVersion: 'v2', // Bumped to v2 for Sprint 8 grouping support
			stage: 'network-materialization',
			runId: input.runId,
			inputFingerprint: input.inputFingerprint
		};

		const entities: DrawingEntity[] = [];

		// Materialize segments first
		const segmentEntities = input.segments
			.filter((segment) => segment.waypoints.length >= 2)
			.map((segment) => {
				const objectType = segment.kind === 'dc'
					? BIM_OBJECT_TYPE.DC_STRING_SEGMENT
					: BIM_OBJECT_TYPE.AC_FEEDER_SEGMENT;
				const envelope = buildBimEnvelope({
					objectType,
					nativeId: segment.segmentId
				});
				const layer = segment.kind === 'dc'
					? CAD_STANDARD_LAYERS.ELECTRICAL_DC
					: CAD_STANDARD_LAYERS.ELECTRICAL_AC;
				const metadata = buildMaterializationMetadata(
					materializationContext,
					{
						discipline: 'electrical',
						bimObjectType: envelope.objectType,
						bimObjectId: envelope.objectId,
						bimRelationships: envelope.relationships,
						materializationKind: 'electrical-segment',
						nativeId: segment.segmentId
					},
					{
						electricalNetworkId: networkId,
						electricalNetworkName: input.networkName ?? '',
						segmentKind: segment.kind
					}
				);

				return {
					$typeName: 'drawing.v1.DrawingEntity',
					header: {
						$typeName: 'drawing.v1.EntityHeader',
						entityId: `elec_seg_${Date.now()}_${segment.segmentId}`,
						drawingId: drawing.drawingId,
						entityType: DrawingEntityType.POLYLINE,
						layer: {
							$typeName: 'drawing.v1.LayerRef',
							layerId: layer.id,
							layerName: layer.name
						},
						style: { $typeName: 'drawing.v1.StyleRef', styleId: '', styleName: `Electrical-${segment.kind.toUpperCase()}` },
						metadataJson: buildCadBimMetadata('materialize-electrical-segment', BIM_IFC_CLASS.CABLE_CARRIER_SEGMENT, metadata)
					},
					geometry: {
						case: 'polyline',
						value: {
							$typeName: 'drawing.v1.PolylineEntity',
							vertices: segment.waypoints.map((point) => ({
								$typeName: 'common.v1.Point2D',
								x: point.x,
								y: point.y
							})),
							closed: false
						}
					}
				} as DrawingEntity;
			});

		entities.push(...segmentEntities);

		// Sprint 8: Materialize grouping constructs (topology annotations)
		if (input.topologyRoots && input.topologyRoots.length > 0) {
			const graph = buildElectricalNetworkGraph(networkId, input.networkName, input.topologyRoots);
			const relationships = flattenElectricalTopologyToRelationships(graph);
			const segmentAnchorById = new Map<string, LonLatPoint>();
			for (const segment of input.segments) {
				if (segment.waypoints.length < 2) continue;
				const first = segment.waypoints[0];
				const last = segment.waypoints[segment.waypoints.length - 1];
				segmentAnchorById.set(segment.segmentId, {
					x: (first.x + last.x) / 2,
					y: (first.y + last.y) / 2
				});
			}

			const topologyNodeAnchor = (nodeId: string): LonLatPoint | null => {
				const node = graph.allNodes.get(nodeId);
				if (!node) return null;
				for (const segmentId of node.childSegmentIds ?? []) {
					const anchor = segmentAnchorById.get(segmentId);
					if (anchor) return anchor;
				}
				for (const child of node.childNodes) {
					const childAnchor = topologyNodeAnchor(child.groupingId);
					if (childAnchor) return childAnchor;
				}
				return null;
			};

			const fallbackAnchor = segmentAnchorById.values().next().value as LonLatPoint | undefined;

			// For each grouping relationship, create a text annotation entity
			for (let index = 0; index < relationships.length; index += 1) {
				const rel = relationships[index];
				const objectType =
					rel.toType === 'dc_string'
						? BIM_OBJECT_TYPE.DC_STRING_GROUP
						: rel.toType === 'mppt_group'
						? BIM_OBJECT_TYPE.MPPT_GROUP
						: rel.toType === 'inverter_route'
						? BIM_OBJECT_TYPE.INVERTER_ROUTE
						: BIM_OBJECT_TYPE.TRANSFORMER_ROUTE;

				const envelope = buildBimEnvelope({
					objectType,
					nativeId: rel.toId,
					relationships: [
						{
							relation: 'connected_to' as any,
							targetType: BIM_OBJECT_TYPE.DC_STRING_SEGMENT,
							targetId: rel.fromId
						}
					]
				});

				const metadata = buildMaterializationMetadata(
					materializationContext,
					{
						discipline: 'electrical',
						bimObjectType: envelope.objectType,
						bimObjectId: envelope.objectId,
						bimRelationships: envelope.relationships,
						materializationKind: 'annotation',
						nativeId: rel.toId
					},
					{
						electricalGroupingType: rel.toType,
						electricalTopologyRelation: rel.relation,
						parentGroupingId: rel.fromId,
						topologyOverlay: true
					}
				);

				const baseAnchor = topologyNodeAnchor(rel.toId) ?? fallbackAnchor ?? { x: 0, y: 0 };
				const offset = 0.00003 * ((index % 5) + 1);
				const anchor = {
					x: baseAnchor.x + offset,
					y: baseAnchor.y + offset
				};

				entities.push({
					$typeName: 'drawing.v1.DrawingEntity',
					header: {
						$typeName: 'drawing.v1.EntityHeader',
						entityId: `elec_grouping_${Date.now()}_${rel.toId}`,
						drawingId: drawing.drawingId,
						entityType: DrawingEntityType.TEXT,
						layer: {
							$typeName: 'drawing.v1.LayerRef',
							layerId: CAD_STANDARD_LAYERS.ELECTRICAL_AC.id,
							layerName: CAD_STANDARD_LAYERS.ELECTRICAL_AC.name
						},
						style: { $typeName: 'drawing.v1.StyleRef', styleId: '', styleName: 'ElectricalTopology' },
						metadataJson: buildCadBimMetadata(
							'materialize-electrical-topology',
							BIM_IFC_CLASS.ANNOTATION,
							metadata
						)
					},
					geometry: {
						case: 'text',
						value: {
							$typeName: 'drawing.v1.TextEntity',
							text: `${rel.toType}:${rel.toId}`,
							anchor: { $typeName: 'common.v1.Point2D', x: anchor.x, y: anchor.y },
							height: 2.5,
							rotationDeg: 0,
							fontFamily: 'Arial'
						}
					}
				} as DrawingEntity);
			}
		}

		return cadApi.storeDrawingRevision({
			drawingId: drawing.drawingId,
			summary: `Materialize electrical network ${networkId}${input.topologyRoots && input.topologyRoots.length > 0 ? ' with topology' : ''}`,
			entities: [...retainedEntities, ...entities]
		});
	}, async (updated) => {
		const revisions = await cadApi.listDrawingRevisions(updated.drawing.drawingId, 100);
		setContext(updated.drawing, updated.revision, revisions);
	});
}

export async function materializeTerrainAnalysisToCad(input: TerrainCadMaterializationInput) {
	return executeCadWrite(async () => {
		const analysisId = input.analysisId.trim();
		if (!analysisId) {
			throw new Error('Terrain analysis ID is required');
		}
		if (!input.zones || input.zones.length === 0) {
			throw new Error('Terrain materialization requires at least one zone');
		}

		const { drawing, revision } = requireContext();
		const retainedEntities = getRevisionEntities(revision).filter((entity) => !isTerrainAnalysisEntity(entity, analysisId));
		const materializationContext: ComputeMaterializationContext = {
			sourceService: 'terrain-service',
			serviceVersion: 'v1',
			stage: 'analysis-materialization',
			runId: input.runId,
			inputFingerprint: input.inputFingerprint
		};

		const entities: DrawingEntity[] = input.zones
			.filter((zone) => zone.vertices.length >= 3)
			.map((zone) => {
				const envelope = buildBimEnvelope({
					objectType: BIM_OBJECT_TYPE.GRADING_ZONE,
					nativeId: zone.zoneId
				});
				const metadata = buildMaterializationMetadata(
					materializationContext,
					{
						discipline: 'civil',
						bimObjectType: envelope.objectType,
						bimObjectId: envelope.objectId,
						bimRelationships: envelope.relationships,
						materializationKind: 'terrain-zone',
						nativeId: zone.zoneId
					},
					{
						terrainAnalysisId: analysisId,
						terrainAnalysisName: input.analysisName ?? '',
						terrainZoneType: zone.zoneType,
						terrainZoneValue: zone.value ?? null
					}
				);

				return {
					$typeName: 'drawing.v1.DrawingEntity',
					header: {
						$typeName: 'drawing.v1.EntityHeader',
						entityId: `terrain_zone_${Date.now()}_${zone.zoneId}`,
						drawingId: drawing.drawingId,
						entityType: DrawingEntityType.POLYGON,
						layer: {
							$typeName: 'drawing.v1.LayerRef',
							layerId: CAD_STANDARD_LAYERS.TERRAIN.id,
							layerName: CAD_STANDARD_LAYERS.TERRAIN.name
						},
						style: { $typeName: 'drawing.v1.StyleRef', styleId: '', styleName: `Terrain-${zone.zoneType}` },
						metadataJson: buildCadBimMetadata('materialize-terrain-zone', BIM_IFC_CLASS.SLAB, metadata)
					},
					geometry: {
						case: 'polygon',
						value: {
							$typeName: 'drawing.v1.PolygonEntity',
							geometry: {
								$typeName: 'common.v1.Polygon2D',
								rings: [
									{
										$typeName: 'common.v1.LineString2D',
										points: ensureClosedRing(zone.vertices).map((point) => ({
											$typeName: 'common.v1.Point2D',
											x: point.x,
											y: point.y
										}))
									}
								]
							}
						}
					}
				} as DrawingEntity;
			});

		return cadApi.storeDrawingRevision({
			drawingId: drawing.drawingId,
			summary: `Materialize terrain analysis ${analysisId}`,
			entities: [...retainedEntities, ...entities]
		});
	}, async (updated) => {
		const revisions = await cadApi.listDrawingRevisions(updated.drawing.drawingId, 100);
		setContext(updated.drawing, updated.revision, revisions);
	});
}

export async function materializeLayoutToCad(input: LayoutCadMaterializationInput) {
	return executeCadWrite(async () => {
		const layoutId = input.layoutId.trim();
		if (!layoutId) {
			throw new Error('Layout ID is required');
		}
		if ((!input.tables || input.tables.length === 0) && (!input.rows || input.rows.length === 0)) {
			throw new Error('Layout materialization requires at least one table or row');
		}

		const { drawing, revision } = requireContext();
		const retainedEntities = getRevisionEntities(revision).filter((entity) => !isLayoutEntity(entity, layoutId));
		const materializationContext: ComputeMaterializationContext = {
			sourceService: 'layout-service',
			serviceVersion: 'v1',
			stage: 'layout-materialization',
			runId: input.runId,
			inputFingerprint: input.inputFingerprint
		};

		const tableEntities: DrawingEntity[] = input.tables
			.filter((table) => table.boundaryVertices.length >= 3)
			.map((table) => {
				const envelope = buildBimEnvelope({
					objectType: BIM_OBJECT_TYPE.PANEL_TABLE,
					nativeId: table.tableId,
					relationships: (table.rowIds ?? []).map((rowId) => ({
						relation: BIM_RELATIONSHIP_TYPE.CONTAINS,
						targetType: BIM_OBJECT_TYPE.PANEL_ROW,
						targetId: rowId
					}))
				});
				const metadata = buildMaterializationMetadata(
					materializationContext,
					{
						discipline: 'layout',
						bimObjectType: envelope.objectType,
						bimObjectId: envelope.objectId,
						bimRelationships: envelope.relationships,
						materializationKind: 'layout-table',
						nativeId: table.tableId
					},
					{
						layoutId,
						layoutName: input.layoutName ?? '',
						tableId: table.tableId
					}
				);

				return {
					$typeName: 'drawing.v1.DrawingEntity',
					header: {
						$typeName: 'drawing.v1.EntityHeader',
						entityId: `layout_table_${Date.now()}_${table.tableId}`,
						drawingId: drawing.drawingId,
						entityType: DrawingEntityType.POLYGON,
						layer: {
							$typeName: 'drawing.v1.LayerRef',
							layerId: CAD_STANDARD_LAYERS.PANELS.id,
							layerName: CAD_STANDARD_LAYERS.PANELS.name
						},
						style: { $typeName: 'drawing.v1.StyleRef', styleId: '', styleName: 'Layout-Table' },
						metadataJson: buildCadBimMetadata('materialize-layout-table', BIM_IFC_CLASS.BUILDING_ELEMENT_PROXY, metadata)
					},
					geometry: {
						case: 'polygon',
						value: {
							$typeName: 'drawing.v1.PolygonEntity',
							geometry: {
								$typeName: 'common.v1.Polygon2D',
								rings: [
									{
										$typeName: 'common.v1.LineString2D',
										points: ensureClosedRing(table.boundaryVertices).map((point) => ({
											$typeName: 'common.v1.Point2D',
											x: point.x,
											y: point.y
										}))
									}
								]
							}
						}
					}
				} as DrawingEntity;
			});

		const rowEntities: DrawingEntity[] = input.rows
			.filter((row) => row.vertices.length >= 2)
			.map((row) => {
				const envelope = buildBimEnvelope({
					objectType: BIM_OBJECT_TYPE.PANEL_ROW,
					nativeId: row.rowId
				});
				const metadata = buildMaterializationMetadata(
					materializationContext,
					{
						discipline: 'layout',
						bimObjectType: envelope.objectType,
						bimObjectId: envelope.objectId,
						bimRelationships: envelope.relationships,
						materializationKind: 'layout-row',
						nativeId: row.rowId
					},
					{
						layoutId,
						layoutName: input.layoutName ?? '',
						rowId: row.rowId
					}
				);

				return {
					$typeName: 'drawing.v1.DrawingEntity',
					header: {
						$typeName: 'drawing.v1.EntityHeader',
						entityId: `layout_row_${Date.now()}_${row.rowId}`,
						drawingId: drawing.drawingId,
						entityType: DrawingEntityType.POLYLINE,
						layer: {
							$typeName: 'drawing.v1.LayerRef',
							layerId: CAD_STANDARD_LAYERS.PANELS.id,
							layerName: CAD_STANDARD_LAYERS.PANELS.name
						},
						style: { $typeName: 'drawing.v1.StyleRef', styleId: '', styleName: 'Layout-Row' },
						metadataJson: buildCadBimMetadata('materialize-layout-row', BIM_IFC_CLASS.BUILDING_ELEMENT_PROXY, metadata)
					},
					geometry: {
						case: 'polyline',
						value: {
							$typeName: 'drawing.v1.PolylineEntity',
							vertices: row.vertices.map((point) => ({
								$typeName: 'common.v1.Point2D',
								x: point.x,
								y: point.y
							})),
							closed: false
						}
					}
				} as DrawingEntity;
			});

		return cadApi.storeDrawingRevision({
			drawingId: drawing.drawingId,
			summary: `Materialize layout ${layoutId}`,
			entities: [...retainedEntities, ...tableEntities, ...rowEntities]
		});
	}, async (updated) => {
		const revisions = await cadApi.listDrawingRevisions(updated.drawing.drawingId, 100);
		setContext(updated.drawing, updated.revision, revisions);
	});
}

export async function runCadMaterializationPipeline(
	input: CadMaterializationPipelineInput
): Promise<CadMaterializationStageResult[]> {
	const runId = input.runId?.trim() || `cad-pipeline-${Date.now()}`;
	const inputFingerprint = input.inputFingerprint?.trim() || '';
	const results: CadMaterializationStageResult[] = [];

	if (input.terrain) {
		await materializeTerrainAnalysisToCad({
			...input.terrain,
			runId,
			inputFingerprint
		});
		results.push({
			stage: 'terrain',
			status: 'completed',
			message: `Terrain analysis ${input.terrain.analysisId} materialized (${input.terrain.zones.length} zones)`,
			metrics: {
				inputCount: input.terrain.zones.length,
				outputHint: input.terrain.zones.filter((zone) => zone.vertices.length >= 3).length
			}
		});
	} else {
		results.push({
			stage: 'terrain',
			status: 'skipped',
			message: 'No terrain payload supplied',
			metrics: { inputCount: 0, outputHint: 0 }
		});
	}

	if (input.layout) {
		await materializeLayoutToCad({
			...input.layout,
			runId,
			inputFingerprint
		});
		results.push({
			stage: 'layout',
			status: 'completed',
			message: `Layout ${input.layout.layoutId} materialized (${input.layout.tables.length} tables, ${input.layout.rows.length} rows)`,
			metrics: {
				inputCount: input.layout.tables.length + input.layout.rows.length,
				outputHint:
					input.layout.tables.filter((table) => table.boundaryVertices.length >= 3).length +
					input.layout.rows.filter((row) => row.vertices.length >= 2).length
			}
		});
	} else {
		results.push({
			stage: 'layout',
			status: 'skipped',
			message: 'No layout payload supplied',
			metrics: { inputCount: 0, outputHint: 0 }
		});
	}

	if (input.transmission) {
		await materializeTransmissionRouteToCad({
			...input.transmission,
			runId,
			inputFingerprint
		});
		results.push({
			stage: 'transmission',
			status: 'completed',
			message: `Transmission route ${input.transmission.routeId} materialized (${input.transmission.waypoints.length} waypoints)`,
			metrics: {
				inputCount: input.transmission.waypoints.length + (input.transmission.towerPoints?.length ?? 0),
				outputHint:
					(input.transmission.waypoints.length >= 2 ? 1 : 0) +
					(input.transmission.towerPoints?.length ?? 0)
			}
		});
	} else {
		results.push({
			stage: 'transmission',
			status: 'skipped',
			message: 'No transmission payload supplied',
			metrics: { inputCount: 0, outputHint: 0 }
		});
	}

	if (input.electrical) {
		const electricalMetrics = computeElectricalPipelineMetrics(input.electrical);
		await materializeElectricalNetworkToCad({
			...input.electrical,
			runId,
			inputFingerprint
		});
		results.push({
			stage: 'electrical',
			status: 'completed',
			message: `Electrical network ${input.electrical.networkId} materialized (${electricalMetrics.inputCount} segments, ${electricalMetrics.topologyNodeCount} topology nodes)`,
			metrics: electricalMetrics
		});
	} else {
		results.push({
			stage: 'electrical',
			status: 'skipped',
			message: 'No electrical payload supplied',
			metrics: { inputCount: 0, outputHint: 0, topologyNodeCount: 0, topologyDepth: 0, topologyRelationshipCount: 0, qualityViolations: 0 }
		});
	}

	cadWorkspace.update((state) => ({
		...state,
		lastMaterializationResults: results,
		materializationHistory: [
			{
				runId,
				inputFingerprint,
				timestampMs: Date.now(),
				results
			},
			...state.materializationHistory
		].slice(0, MAX_MATERIALIZATION_HISTORY)
	}));

	return results;
}

export async function publishCadSheets(format: PlotOutputFormat, explicitSheetIds?: string[]) {
	return executeCadWrite(async () => {
		const { drawing, revision } = requireContext();
		const inferredSheetIds = getRevisionSheets(revision)
			.map((sheet) => sheet.sheetId)
			.filter((id) => id.length > 0);
		const sheetIds = explicitSheetIds?.length ? explicitSheetIds : inferredSheetIds;
		if (!sheetIds.length) {
			throw new Error('No sheets found to publish');
		}
		return cadApi.publishDrawing({ drawingId: drawing.drawingId, revision, sheetIds, format });
	}, async (published) => {
		cadWorkspace.update((state) => ({
			...state,
			isBusy: false,
			error: '',
			publishArtifacts: published.artifacts,
			publishManifestJson: published.manifestJson,
			lastConflictMessage: ''
		}));
	});
}

export async function exportCadDrawing(format: FileFormat): Promise<{ fileName: string; contentType: string; payload: Uint8Array }> {
	const { drawing, revision } = requireContext();
	return cadApi.exportDrawing({ drawingId: drawing.drawingId, revision, format });
}

export function selectCadBlockDefinition(blockDefinitionId: string) {
	cadWorkspace.update((state) => {
		const blockIds = new Set(getCadBlockDefinitions(state.revision).map((block) => block.blockDefinitionId));
		if (!blockDefinitionId || !blockIds.has(blockDefinitionId)) {
			return state;
		}

		return {
			...state,
			selectedBlockDefinitionId: blockDefinitionId,
			pendingMapInsertBlockId:
				state.pendingMapInsertBlockId && blockIds.has(state.pendingMapInsertBlockId)
					? state.pendingMapInsertBlockId
					: ''
		};
	});
}

export function armCadMapBlockInsertion(blockDefinitionId?: string) {
	cadWorkspace.update((state) => {
		const blockIds = new Set(getCadBlockDefinitions(state.revision).map((block) => block.blockDefinitionId));
		const targetBlockId = blockDefinitionId?.trim() || state.selectedBlockDefinitionId;
		if (!targetBlockId || !blockIds.has(targetBlockId)) {
			return {
				...state,
				error: 'Select a block definition before placing it on the map',
				pendingMapInsertBlockId: ''
			};
		}

		return {
			...state,
			error: '',
			selectedBlockDefinitionId: targetBlockId,
			pendingMapInsertBlockId: targetBlockId
		};
	});
}

export function disarmCadMapBlockInsertion() {
	cadWorkspace.update((state) => ({
		...state,
		pendingMapInsertBlockId: ''
	}));
}

export function setCadDiagnosticsConfig(input: Partial<CadDiagnosticsConfig>) {
	cadWorkspace.update((state) => {
		const next = clampDiagnosticsConfig(input, state.diagnosticsConfig);
		return commitDiagnosticsConfig(state, next, 'manual');
	});
}

export function resetCadDiagnosticsConfig() {
	cadWorkspace.update((state) => commitDiagnosticsConfig(state, cloneDiagnosticsConfig(DEFAULT_DIAGNOSTICS_CONFIG), 'reset'));
}

export function applyCadDiagnosticsPreset(preset: CadDiagnosticsPreset) {
	cadWorkspace.update((state) =>
		commitDiagnosticsConfig(state, cloneDiagnosticsConfig(DIAGNOSTICS_PRESETS[preset]), `preset-${preset}`)
	);
}

export function restoreCadDiagnosticsConfigHistoryEntry(entryId: string) {
	cadWorkspace.update((state) => {
		const entry = state.diagnosticsConfigHistory.find((candidate) => candidate.entryId === entryId);
		if (!entry) {
			return {
				...state,
				error: 'Diagnostics config history entry not found'
			};
		}

		return {
			...commitDiagnosticsConfig(state, cloneDiagnosticsConfig(entry.config), 'manual', 'Restored diagnostics tuning from audit history'),
			error: ''
		};
	});
}

activeTool.subscribe((tool) => {
	if (tool === 'insert-block') {
		return;
	}
	disarmCadMapBlockInsertion();
});

export function clearCadWorkspace() {
	cadWorkspace.set(createInitialState());
}
