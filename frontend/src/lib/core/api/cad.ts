import {
	DrawingEntityType,
	type BlockDefinitionEntity,
	type Drawing,
	type DrawingEntity,
	type DrawingRevision,
	type FidelityReport,
	type LayerDefinitionEntity,
	type PublishedSheetArtifact,
	type RevisionPointer,
	type SheetEntity
} from '$lib/gen/drawing/v1/drawing_pb.js';
import {
	BIM_IFC_CLASS,
	CAD_DEFAULT_DIMENSION_PRECISION,
	CAD_DEFAULT_DIMENSION_UNIT,
	CAD_STANDARD_LAYERS,
	buildCadBimMetadata,
	buildCadTraceMetadata
} from '$lib/core/domain/cadStandards';
import { normalizeBimContractMetadata } from '$lib/core/domain/bimContract';

import { API_BASE } from './client';

export interface CadContext {
	drawing: Drawing;
	revision: DrawingRevision;
}

export class CadApiError extends Error {
	code: string;
	outcomeCode?: string;
	attemptId?: string;
	headVersion?: number;
	retryAfterMs?: number;
	status?: number;
	baseRevisionId?: string;
	headRevisionId?: string;

	constructor(
		message: string,
		code = 'unknown',
		outcomeCode?: string,
		attemptId?: string,
		headVersion?: number,
		retryAfterMs?: number,
		status?: number,
		baseRevisionId?: string,
		headRevisionId?: string
	) {
		super(message);
		this.name = 'CadApiError';
		this.code = code;
		this.outcomeCode = outcomeCode;
		this.attemptId = attemptId;
		this.headVersion = headVersion;
		this.retryAfterMs = retryAfterMs;
		this.status = status;
		this.baseRevisionId = baseRevisionId;
		this.headRevisionId = headRevisionId;
	}
}

function resolveServiceBase(targetPort: number, override?: string): string {
	if (override && override.trim().length > 0) {
		return override;
	}
	if (API_BASE.match(/:\d+$/)) {
		return API_BASE.replace(/:\d+$/, `:${targetPort}`);
	}
	return API_BASE;
}

const CAD_ENDPOINTS = {
	drawingRevision: resolveServiceBase(8088, import.meta.env.VITE_DRAWING_REVISION_API_BASE_URL),
	cadAnnotation: resolveServiceBase(8093, import.meta.env.VITE_CAD_ANNOTATION_API_BASE_URL),
	cadLayerBlock: resolveServiceBase(8094, import.meta.env.VITE_CAD_LAYER_BLOCK_API_BASE_URL),
	interop: resolveServiceBase(8095, import.meta.env.VITE_INTEROP_API_BASE_URL),
	plotSheet: resolveServiceBase(8096, import.meta.env.VITE_PLOT_SHEET_API_BASE_URL)
};

async function callConnect<T>(baseUrl: string, path: string, body: unknown): Promise<T> {
	const response = await fetch(`${baseUrl}${path}`, {
		method: 'POST',
		headers: {
			'Content-Type': 'application/json',
			'Connect-Protocol-Version': '1'
		},
		body: JSON.stringify(body)
	});

	if (!response.ok) {
		const retryAfterHeader = response.headers.get('retry-after');
		const retryAfterMs = retryAfterHeader ? Number(retryAfterHeader) * 1000 : undefined;
		const errorCodeHeader = response.headers.get('x-solar3d-error-code') ?? '';
		const outcomeCodeHeader = response.headers.get('x-solar3d-outcome-code') ?? undefined;
		const attemptId = response.headers.get('x-solar3d-attempt-id') ?? undefined;
		const headVersionHeader = response.headers.get('x-solar3d-head-version');
		const headVersion = headVersionHeader ? Number(headVersionHeader) : undefined;
		const baseRevisionId = response.headers.get('x-solar3d-base-revision-id') ?? undefined;
		const headRevisionId = response.headers.get('x-solar3d-head-revision-id') ?? undefined;

		let text = '';
		let code = errorCodeHeader || 'unknown';
		let message = '';
		try {
			text = await response.text();
			if (text) {
				const parsed = JSON.parse(text) as { code?: string; message?: string };
				if (!errorCodeHeader && parsed.code) {
					code = parsed.code;
				}
				message = parsed.message ?? '';
			}
		} catch {
			message = text;
		}

		const fallback = text || `CAD API request failed: ${response.status}`;
		throw new CadApiError(
			message || fallback,
			code,
			outcomeCodeHeader,
			attemptId,
			headVersion,
			retryAfterMs,
			response.status,
			baseRevisionId,
			headRevisionId
		);
	}

	return (await response.json()) as T;
}

function requireRevisionId(revision?: DrawingRevision): string {
	const revisionId = revision?.pointer?.revisionId ?? '';
	if (!revisionId) {
		throw new Error('Drawing revision is missing revision_id');
	}
	return revisionId;
}

// The Go backend returns proto JSON where oneof fields are top-level keys
// (e.g. "blockDefinition": {...}) rather than the protobuf-es runtime format
// (entity.geometry = { case: "blockDefinition", value: {...} }).
// normalizeDrawingRevision transforms the raw proto JSON into the protobuf-es
// case/value shape expected by all entity-reading code in the frontend.
const ENTITY_GEOMETRY_CASES = [
	'polyline',
	'polygon',
	'text',
	'dimension',
	'blockReference',
	'layerDefinition',
	'blockDefinition',
	'leader',
	'sheet'
] as const;

function normalizeEntity(raw: Record<string, unknown>): DrawingEntity {
	const rawHeader = raw.header as Record<string, unknown> | undefined;
	const normalizedHeader = rawHeader
		? {
				...rawHeader,
				metadataJson: normalizeBimContractMetadata(rawHeader.metadataJson as string | undefined)
			}
		: rawHeader;

	// Already in protobuf-es format — skip
	if (
		raw.geometry != null &&
		typeof (raw.geometry as Record<string, unknown>).case === 'string'
	) {
		return { ...raw, header: normalizedHeader } as unknown as DrawingEntity;
	}
	let geometry: DrawingEntity['geometry'] = { case: undefined };
	for (const c of ENTITY_GEOMETRY_CASES) {
		if (c in raw && raw[c] !== undefined) {
			geometry = { case: c, value: raw[c] } as DrawingEntity['geometry'];
			break;
		}
	}
	return { ...raw, header: normalizedHeader, geometry } as unknown as DrawingEntity;
}

function normalizeDrawingRevision(revision: unknown): DrawingRevision | undefined {
	if (!revision || typeof revision !== 'object') return undefined;
	const rev = revision as Record<string, unknown>;
	const rawEntities = Array.isArray(rev.entities)
		? (rev.entities as Record<string, unknown>[])
		: [];
	return { ...rev, entities: rawEntities.map(normalizeEntity) } as unknown as DrawingRevision;
}

function requireDrawing(context: { drawing?: Drawing; revision?: DrawingRevision }): CadContext {
	if (!context.drawing || !context.revision) {
		throw new Error('CAD context response is incomplete');
	}
	return {
		drawing: context.drawing,
		revision: context.revision
	};
}

async function callConnectCtx(baseUrl: string, path: string, body: unknown): Promise<CadContext> {
	const response = await callConnect<{ drawing: Drawing; revision: DrawingRevision }>(
		baseUrl,
		path,
		body
	);
	return requireDrawing({ drawing: response.drawing, revision: normalizeDrawingRevision(response.revision) });
}

export const cadApi = {
	async getDrawing(drawingId: string): Promise<Drawing> {
		const response = await callConnect<{ drawing: Drawing }>(
			CAD_ENDPOINTS.drawingRevision,
			'/drawing.v1.DrawingRevisionService/GetDrawing',
			{ drawingId }
		);
		if (!response.drawing) {
			throw new Error('Drawing payload missing from response');
		}
		return response.drawing;
	},

	async updateDrawing(input: {
		drawingId: string;
		name: string;
		description: string;
		metadataJson: string;
		status?: number;
	}): Promise<Drawing> {
		const response = await callConnect<{ drawing: Drawing }>(
			CAD_ENDPOINTS.drawingRevision,
			'/drawing.v1.DrawingRevisionService/UpdateDrawing',
			{
				drawingId: input.drawingId,
				name: input.name,
				description: input.description,
				metadataJson: input.metadataJson,
				status: input.status ?? 0
			}
		);
		if (!response.drawing) {
			throw new Error('Updated drawing payload missing from response');
		}
		return response.drawing;
	},

	async ensureProjectDrawing(projectId: string, preferredName: string): Promise<CadContext> {
		const listed = await callConnect<{ drawings: Drawing[] }>(
			CAD_ENDPOINTS.drawingRevision,
			'/drawing.v1.DrawingRevisionService/ListDrawings',
			{
				projectId,
				pageSize: 50,
				pageToken: '',
				includeArchived: false
			}
		);

		let drawing = listed.drawings?.[0];
		if (!drawing) {
			const created = await callConnect<{ drawing: Drawing; revision: DrawingRevision }>(
				CAD_ENDPOINTS.drawingRevision,
				'/drawing.v1.DrawingRevisionService/CreateDrawing',
				{
					projectId,
					name: `${preferredName} CAD Workspace`,
					description: 'Primary CAD workspace',
					author: 'frontend-user'
				}
			);
			drawing = created.drawing;
		}

		if (!drawing) {
			throw new Error('Unable to resolve drawing for project');
		}

		return callConnectCtx(
			CAD_ENDPOINTS.drawingRevision,
			'/drawing.v1.DrawingRevisionService/GetDrawingState',
			{ drawingId: drawing.drawingId, revisionId: drawing.currentRevisionId }
		);
	},

	async getDrawingRevision(drawingId: string, revisionId: string): Promise<CadContext> {
		return callConnectCtx(
			CAD_ENDPOINTS.drawingRevision,
			'/drawing.v1.DrawingRevisionService/GetDrawingRevision',
			{ drawingId, revisionId }
		);
	},

	async storeDrawingRevision(input: {
		drawingId: string;
		summary: string;
		commandId?: string;
		entities: DrawingRevision['entities'];
	}): Promise<CadContext> {
		return callConnectCtx(
			CAD_ENDPOINTS.drawingRevision,
			'/drawing.v1.DrawingRevisionService/StoreDrawingRevision',
			{
				drawingId: input.drawingId,
				author: 'frontend-user',
				summary: input.summary,
				commandId: input.commandId ?? `manual-snapshot-${Date.now()}`,
				entities: input.entities ?? []
			}
		);
	},

	async revertDrawingRevision(input: {
		drawingId: string;
		targetRevisionId: string;
		summary: string;
	}): Promise<CadContext> {
		return callConnectCtx(
			CAD_ENDPOINTS.drawingRevision,
			'/drawing.v1.CadCoreService/RevertDrawingRevision',
			{
				drawingId: input.drawingId,
				targetRevisionId: input.targetRevisionId,
				author: 'frontend-user',
				summary: input.summary
			}
		);
	},

	async getDrawingState(drawingId: string, revisionId?: string): Promise<CadContext> {
		return callConnectCtx(
			CAD_ENDPOINTS.drawingRevision,
			'/drawing.v1.DrawingRevisionService/GetDrawingState',
			{ drawingId, revisionId: revisionId ?? '' }
		);
	},

	async listDrawingRevisions(drawingId: string, pageSize = 100): Promise<RevisionPointer[]> {
		const response = await callConnect<{ revisions: RevisionPointer[] }>(
			CAD_ENDPOINTS.drawingRevision,
			'/drawing.v1.DrawingRevisionService/ListDrawingRevisions',
			{ drawingId, pageSize, pageToken: '' }
		);
		return response.revisions ?? [];
	},

	async createDimensionAnnotation(input: {
		drawingId: string;
		revision: DrawingRevision;
		start: { x: number; y: number };
		end: { x: number; y: number };
		layerId?: string;
		layerName?: string;
		styleName?: string;
	}): Promise<CadContext> {
		const response = await callConnect<{ drawing: Drawing; revision: DrawingRevision }>(
			CAD_ENDPOINTS.cadAnnotation,
			'/drawing.v1.CadAnnotationService/CreateAnnotation',
			{
				drawingId: input.drawingId,
				baseRevisionId: requireRevisionId(input.revision),
				author: 'frontend-user',
				summary: 'Create dimension from CAD workspace',
				layerId: input.layerId ?? CAD_STANDARD_LAYERS.DIMENSIONS.id,
				layerName: input.layerName ?? CAD_STANDARD_LAYERS.DIMENSIONS.name,
				styleId: '',
				styleName: input.styleName ?? 'Default',
				metadataJson: buildCadBimMetadata('create-dimension-annotation', BIM_IFC_CLASS.ANNOTATION, {
					discipline: 'electrical-civil-shared'
				}),
				annotation: {
					kind: {
						case: 'dimension',
						value: {
							start: input.start,
							end: input.end,
							textAnchor: {
								x: (input.start.x + input.end.x) / 2,
								y: (input.start.y + input.end.y) / 2
							},
							unit: CAD_DEFAULT_DIMENSION_UNIT,
							precision: CAD_DEFAULT_DIMENSION_PRECISION,
							associations: []
						}
					}
				}
			}
		);
		return requireDrawing({ drawing: response.drawing, revision: normalizeDrawingRevision(response.revision) });
	},

	async upsertLayer(input: {
		drawingId: string;
		revision: DrawingRevision;
		layer: LayerDefinitionEntity;
	}): Promise<CadContext> {
		return callConnectCtx(
			CAD_ENDPOINTS.cadLayerBlock,
			'/drawing.v1.CadLayerBlockService/UpsertLayer',
			{
				drawingId: input.drawingId,
				baseRevisionId: requireRevisionId(input.revision),
				author: 'frontend-user',
				summary: `Upsert layer ${input.layer.name}`,
				metadataJson: buildCadTraceMetadata('upsert-layer', {
					discipline: 'cad-governance',
					layerId: input.layer.layerId
				}),
				layer: input.layer
			}
		);
	},

	async createBlockDefinition(input: {
		drawingId: string;
		revision: DrawingRevision;
		block: BlockDefinitionEntity;
		layerName?: string;
	}): Promise<CadContext> {
		return callConnectCtx(
			CAD_ENDPOINTS.cadLayerBlock,
			'/drawing.v1.CadLayerBlockService/CreateBlockDefinition',
			{
				drawingId: input.drawingId,
				baseRevisionId: requireRevisionId(input.revision),
				author: 'frontend-user',
				summary: `Create block ${input.block.name}`,
				layerId: CAD_STANDARD_LAYERS.BLOCKS.id,
				layerName: input.layerName ?? CAD_STANDARD_LAYERS.BLOCKS.name,
				styleId: '',
				styleName: 'Default',
				metadataJson: buildCadBimMetadata('create-block-definition', BIM_IFC_CLASS.BUILDING_ELEMENT_PROXY, {
					discipline: 'electrical-layout'
				}),
				block: input.block
			}
		);
	},

	async insertBlockReference(input: {
		drawingId: string;
		revision: DrawingRevision;
		blockDefinitionId: string;
		point: { x: number; y: number };
	}): Promise<CadContext> {
		return callConnectCtx(
			CAD_ENDPOINTS.cadLayerBlock,
			'/drawing.v1.CadLayerBlockService/InsertBlockReference',
			{
				drawingId: input.drawingId,
				baseRevisionId: requireRevisionId(input.revision),
				author: 'frontend-user',
				summary: 'Insert block reference',
				layerId: CAD_STANDARD_LAYERS.BLOCKS.id,
				layerName: CAD_STANDARD_LAYERS.BLOCKS.name,
				styleId: '',
				styleName: 'Default',
				metadataJson: buildCadBimMetadata('insert-block-reference', BIM_IFC_CLASS.BUILDING_ELEMENT_PROXY, {
					discipline: 'electrical-layout'
				}),
				blockReference: {
					blockDefinitionId: input.blockDefinitionId,
					insertionPoint: input.point,
					rotationDeg: 0,
					scaleX: 1,
					scaleY: 1,
					attributes: {}
				}
			}
		);
	},

	async createSheet(input: {
		drawingId: string;
		revision: DrawingRevision;
		sheet: SheetEntity;
	}): Promise<CadContext> {
		return callConnectCtx(
			CAD_ENDPOINTS.plotSheet,
			'/drawing.v1.PlotSheetService/CreateSheet',
			{
				drawingId: input.drawingId,
				baseRevisionId: requireRevisionId(input.revision),
				author: 'frontend-user',
				summary: `Create sheet ${input.sheet.title}`,
				layerId: CAD_STANDARD_LAYERS.SHEETS.id,
				layerName: CAD_STANDARD_LAYERS.SHEETS.name,
				styleId: '',
				styleName: 'Default',
				metadataJson: buildCadBimMetadata('create-sheet', BIM_IFC_CLASS.ANNOTATION, {
					discipline: 'cad-documentation'
				}),
				sheet: input.sheet
			}
		);
	},

	async publishDrawing(input: {
		drawingId: string;
		revision: DrawingRevision;
		sheetIds: string[];
		format: number;
	}): Promise<{ artifacts: PublishedSheetArtifact[]; manifestJson: string }> {
		const response = await callConnect<{ artifacts: PublishedSheetArtifact[]; manifestJson: string }>(
			CAD_ENDPOINTS.plotSheet,
			'/drawing.v1.PlotSheetService/PublishDrawing',
			{
				drawingId: input.drawingId,
				revisionId: requireRevisionId(input.revision),
				sheetIds: input.sheetIds,
				format: input.format,
				options: {
					monochrome: false,
					includeMetadata: true,
					strokeWidthMm: 0.18
				}
			}
		);
		return { artifacts: response.artifacts ?? [], manifestJson: response.manifestJson ?? '' };
	},

	async exportDrawing(input: {
		drawingId: string;
		revision: DrawingRevision;
		format: number;
	}): Promise<{ fileName: string; contentType: string; payload: Uint8Array }> {
		const response = await callConnect<{ fileName: string; contentType: string; payload: string }>(
			CAD_ENDPOINTS.interop,
			'/drawing.v1.InteropService/ExportDrawing',
			{
				drawingId: input.drawingId,
				revisionId: requireRevisionId(input.revision),
				format: input.format
			}
		);
		return {
			fileName: response.fileName,
			contentType: response.contentType,
			payload: Uint8Array.from(atob(response.payload ?? ''), (char) => char.charCodeAt(0))
		};
	},

	async importDrawing(input: {
		drawingId: string;
		revision: DrawingRevision;
		format: number;
		mergeStrategy: number;
		payload: string;
		summary: string;
	}): Promise<{ context: CadContext; report?: FidelityReport }> {
		const response = await callConnect<{ drawing: Drawing; revision: DrawingRevision; report?: FidelityReport }>(
			CAD_ENDPOINTS.interop,
			'/drawing.v1.InteropService/ImportDrawing',
			{
				drawingId: input.drawingId,
				baseRevisionId: requireRevisionId(input.revision),
				author: 'frontend-user',
				summary: input.summary,
				format: input.format,
				payload: input.payload,
				mergeStrategy: input.mergeStrategy
			}
		);
		return {
			context: requireDrawing({ drawing: response.drawing, revision: normalizeDrawingRevision(response.revision) }),
			report: response.report
		};
	},

	async validateDrawingRoundTrip(input: {
		drawingId: string;
		revision: DrawingRevision;
		format: number;
	}): Promise<FidelityReport | null> {
		const response = await callConnect<{ report?: FidelityReport }>(
			CAD_ENDPOINTS.interop,
			'/drawing.v1.InteropService/ValidateDrawingRoundTrip',
			{
				drawingId: input.drawingId,
				revisionId: requireRevisionId(input.revision),
				format: input.format
			}
		);
		return response.report ?? null;
	},

	inferEntityTypeCounts(revision: DrawingRevision): Record<string, number> {
		const counts: Record<string, number> = {
			polyline: 0,
			polygon: 0,
			text: 0,
			dimension: 0,
			blockReference: 0,
			layerDefinition: 0,
			blockDefinition: 0,
			leader: 0,
			sheet: 0
		};
		const entities = revision.entities ?? [];
		for (const entity of entities) {
			const kind = entity?.geometry?.case;
			if (kind) {
				counts[kind] = (counts[kind] ?? 0) + 1;
			}
			if (entity?.header?.entityType === DrawingEntityType.DIMENSION) {
				counts.dimension += 1;
			}
		}
		return counts;
	}
};
