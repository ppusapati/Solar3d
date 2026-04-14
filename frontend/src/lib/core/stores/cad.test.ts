import { beforeEach, describe, expect, it, vi } from 'vitest';
import { get } from 'svelte/store';
import type { BlockDefinitionEntity, Drawing, DrawingRevision, RevisionPointer } from '$lib/gen/drawing/v1/drawing_pb.js';
import { activeTool } from './map';

const cadApiMock = vi.hoisted(() => ({
	ensureProjectDrawing: vi.fn(),
	listDrawingRevisions: vi.fn(),
	createBlockDefinition: vi.fn(),
	insertBlockReference: vi.fn(),
	storeDrawingRevision: vi.fn(),
	upsertLayer: vi.fn(),
	getDrawingState: vi.fn(),
	inferEntityTypeCounts: vi.fn((revision: DrawingRevision) => ({
		blockDefinition: (revision.entities ?? []).filter((entity) => entity?.geometry?.case === 'blockDefinition').length,
		blockReference: (revision.entities ?? []).filter((entity) => entity?.geometry?.case === 'blockReference').length
	}))
}));

vi.mock('$lib/core/api/cad', () => ({
	CadApiError: class CadApiError extends Error {
		code = '';
		baseRevisionId?: string;
		headRevisionId?: string;
		retryAfterMs?: number;
	},
	cadApi: cadApiMock
}));

import {
	armCadMapBlockInsertion,
	cadElectricalDiagnosticsIntelligence,
	cadBlockDefinitions,
	cadElectricalRegressionAlert,
	cadPendingMapInsertBlockId,
	cadWorkspace,
	clearCadWorkspace,
	createCadBlockDefinition,
	initializeCadWorkspace,
	insertCadBlockReference,
	materializeElectricalNetworkToCad,
	materializeTerrainAnalysisToCad,
	materializeLayoutToCad,
	materializeTransmissionRouteToCad,
	runCadMaterializationPipeline,
	setCadDiagnosticsConfig,
	resetCadDiagnosticsConfig,
	applyCadDiagnosticsPreset,
	restoreCadDiagnosticsConfigHistoryEntry,
	selectCadBlockDefinition,
	selectedCadBlockDefinitionId,
	disarmCadMapBlockInsertion
} from './cad';

function makeDrawing(revisionId: string): Drawing {
	return {
		$typeName: 'drawing.v1.Drawing',
		drawingId: 'drawing-1',
		projectId: 'project-1',
		name: 'CAD Workspace',
		description: 'Primary CAD workspace',
		metadataJson: '{}',
		status: 0,
		currentRevisionId: revisionId,
		revisionCount: 1,
		entityCount: 0
	} as Drawing;
}

function makeBlockDefinition(blockDefinitionId: string, name: string): BlockDefinitionEntity {
	return {
		$typeName: 'drawing.v1.BlockDefinitionEntity',
		blockDefinitionId,
		name,
		basePoint: { $typeName: 'common.v1.Point2D', x: 0, y: 0 },
		entities: [],
		defaultAttributes: {}
	} as BlockDefinitionEntity;
}

function makeRevision(revisionId: string, blocks: BlockDefinitionEntity[], includeBlockReference = false): DrawingRevision {
	const entities: DrawingRevision['entities'] = blocks.map((block) => ({
		$typeName: 'drawing.v1.DrawingEntity',
		header: undefined,
		geometry: {
			case: 'blockDefinition',
			value: block
		}
	})) as DrawingRevision['entities'];

	if (includeBlockReference) {
		entities.push({
			$typeName: 'drawing.v1.DrawingEntity',
			header: undefined,
			geometry: {
				case: 'blockReference',
				value: {
					$typeName: 'drawing.v1.BlockReferenceEntity',
					blockDefinitionId: blocks[0]?.blockDefinitionId ?? '',
					insertionPoint: { $typeName: 'common.v1.Point2D', x: 10, y: 20 },
					rotationDeg: 0,
					scaleX: 1,
					scaleY: 1,
					attributes: {}
				}
			}
		} as DrawingRevision['entities'][number]);
	}

	return {
		$typeName: 'drawing.v1.DrawingRevision',
		pointer: {
			$typeName: 'drawing.v1.RevisionPointer',
			revisionId,
			parentRevisionId: '',
			author: 'test-user',
			summary: 'test revision'
		} as RevisionPointer,
		drawingId: 'drawing-1',
		commandId: `cmd-${revisionId}`,
		entities
	} as DrawingRevision;
}

describe('cad store', () => {
	beforeEach(() => {
		vi.clearAllMocks();
		clearCadWorkspace();
		activeTool.set('select');
		cadApiMock.listDrawingRevisions.mockResolvedValue([
			{
				$typeName: 'drawing.v1.RevisionPointer',
				revisionId: 'rev-1',
				parentRevisionId: '',
				author: 'test-user',
				summary: 'initial'
			}
		]);
	});

	it('initializes block definitions and selects the first available block', async () => {
		const revision = makeRevision('rev-1', [
			makeBlockDefinition('block-north', 'North Arrow'),
			makeBlockDefinition('block-legend', 'Legend')
		]);
		cadApiMock.ensureProjectDrawing.mockResolvedValue({
			drawing: makeDrawing('rev-1'),
			revision
		});

		await initializeCadWorkspace('project-1', 'Solar Farm');

		expect(get(cadWorkspace).isReady).toBe(true);
		expect(get(cadBlockDefinitions).map((block) => block.blockDefinitionId)).toEqual(['block-north', 'block-legend']);
		expect(get(selectedCadBlockDefinitionId)).toBe('block-north');
		expect(get(cadWorkspace).entityTypeCounts.blockDefinition).toBe(2);
	});

	it('selects a newly created block definition after refresh', async () => {
		const initialRevision = makeRevision('rev-1', [makeBlockDefinition('block-north', 'North Arrow')]);
		const createdBlockId = 'block_1710000000000';
		const createdRevision = makeRevision('rev-2', [
			makeBlockDefinition('block-north', 'North Arrow'),
			makeBlockDefinition(createdBlockId, 'Legend')
		]);

		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision: initialRevision });
		cadApiMock.createBlockDefinition.mockResolvedValue({ drawing: makeDrawing('rev-2'), revision: createdRevision });

		const dateNowSpy = vi.spyOn(Date, 'now').mockReturnValue(1710000000000);

		await initializeCadWorkspace('project-1', 'Solar Farm');
		await createCadBlockDefinition({ name: 'Legend', label: 'L' });

		expect(get(selectedCadBlockDefinitionId)).toBe(createdBlockId);
		expect(get(cadBlockDefinitions).map((block) => block.blockDefinitionId)).toContain(createdBlockId);

		dateNowSpy.mockRestore();
	});

	it('arms and disarms map placement using the selected block definition', async () => {
		const revision = makeRevision('rev-1', [
			makeBlockDefinition('block-north', 'North Arrow'),
			makeBlockDefinition('block-legend', 'Legend')
		]);
		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision });

		await initializeCadWorkspace('project-1', 'Solar Farm');
		selectCadBlockDefinition('block-legend');
		armCadMapBlockInsertion();

		expect(get(selectedCadBlockDefinitionId)).toBe('block-legend');
		expect(get(cadPendingMapInsertBlockId)).toBe('block-legend');

		disarmCadMapBlockInsertion();

		expect(get(cadPendingMapInsertBlockId)).toBe('');
	});

	it('disarms pending block placement when the active tool leaves insert-block', async () => {
		const revision = makeRevision('rev-1', [makeBlockDefinition('block-north', 'North Arrow')]);
		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision });

		await initializeCadWorkspace('project-1', 'Solar Farm');
		armCadMapBlockInsertion('block-north');
		activeTool.set('insert-block');
		expect(get(cadPendingMapInsertBlockId)).toBe('block-north');

		activeTool.set('select');

		expect(get(cadPendingMapInsertBlockId)).toBe('');
	});

	it('preserves selected block but clears pending placement after block insertion refresh', async () => {
		const baseRevision = makeRevision('rev-1', [
			makeBlockDefinition('block-north', 'North Arrow'),
			makeBlockDefinition('block-legend', 'Legend')
		]);
		const insertedRevision = makeRevision(
			'rev-2',
			[
				makeBlockDefinition('block-north', 'North Arrow'),
				makeBlockDefinition('block-legend', 'Legend')
			],
			true
		);

		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision: baseRevision });
		cadApiMock.insertBlockReference.mockResolvedValue({ drawing: makeDrawing('rev-2'), revision: insertedRevision });

		await initializeCadWorkspace('project-1', 'Solar Farm');
		selectCadBlockDefinition('block-legend');
		armCadMapBlockInsertion();
		await insertCadBlockReference({ blockDefinitionId: 'block-legend', x: 12.5, y: 48.2 });

		expect(cadApiMock.insertBlockReference).toHaveBeenCalledWith({
			drawingId: 'drawing-1',
			revision: baseRevision,
			blockDefinitionId: 'block-legend',
			point: { x: 12.5, y: 48.2 }
		});
		expect(get(selectedCadBlockDefinitionId)).toBe('block-legend');
		expect(get(cadPendingMapInsertBlockId)).toBe('');
		expect(get(cadWorkspace).entityTypeCounts.blockReference).toBe(1);
	});

	it('ignores null geometry entries when collecting block definitions', async () => {
		const revision = {
			...makeRevision('rev-1', [makeBlockDefinition('block-legend', 'Legend')]),
			entities: [
				null,
				{ $typeName: 'drawing.v1.DrawingEntity', header: undefined, geometry: undefined },
				...(makeRevision('rev-1', [makeBlockDefinition('block-legend', 'Legend')]).entities ?? [])
			]
		} as DrawingRevision;
		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision });

		await initializeCadWorkspace('project-1', 'Solar Farm');

		expect(get(cadBlockDefinitions).map((block) => block.blockDefinitionId)).toEqual(['block-legend']);
	});

	it('materializes transmission route entities into CAD revision using shared contract metadata', async () => {
		const baseRevision = makeRevision('rev-1', [makeBlockDefinition('block-north', 'North Arrow')]);
		const updatedRevision = makeRevision('rev-2', [makeBlockDefinition('block-north', 'North Arrow')], true);

		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision: baseRevision });
		cadApiMock.storeDrawingRevision.mockResolvedValue({ drawing: makeDrawing('rev-2'), revision: updatedRevision });

		await initializeCadWorkspace('project-1', 'Solar Farm');
		await materializeTransmissionRouteToCad({
			routeId: 'route-7',
			routeName: 'Primary Interconnect',
			voltageKv: 132,
			waypoints: [
				{ x: 78.1, y: 16.1 },
				{ x: 78.2, y: 16.2 }
			],
			towerPoints: [{ x: 78.15, y: 16.15 }],
			runId: 'tx-run-1',
			inputFingerprint: 'fp-123'
		});

		expect(cadApiMock.storeDrawingRevision).toHaveBeenCalledTimes(1);
		const request = cadApiMock.storeDrawingRevision.mock.calls[0][0];
		expect(request.summary).toContain('route-7');
		const entities = request.entities as DrawingRevision['entities'];
		const txEntities = entities.filter((entity) => {
			const metadataRaw = entity?.header?.metadataJson ?? '{}';
			const metadata = JSON.parse(metadataRaw) as Record<string, unknown>;
			return metadata.discipline === 'transmission';
		});
		expect(txEntities.length).toBeGreaterThanOrEqual(2);
	});

	it('materializes electrical dc/ac segments into CAD revision', async () => {
		const baseRevision = makeRevision('rev-1', [makeBlockDefinition('block-north', 'North Arrow')]);
		const updatedRevision = makeRevision('rev-2', [makeBlockDefinition('block-north', 'North Arrow')], true);

		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision: baseRevision });
		cadApiMock.storeDrawingRevision.mockResolvedValue({ drawing: makeDrawing('rev-2'), revision: updatedRevision });

		await initializeCadWorkspace('project-1', 'Solar Farm');
		await materializeElectricalNetworkToCad({
			networkId: 'network-9',
			networkName: 'Phase A Network',
			segments: [
				{
					segmentId: 'seg-dc-1',
					kind: 'dc',
					waypoints: [
						{ x: 78.31, y: 16.31 },
						{ x: 78.32, y: 16.32 }
					]
				},
				{
					segmentId: 'seg-ac-1',
					kind: 'ac',
					waypoints: [
						{ x: 78.33, y: 16.33 },
						{ x: 78.34, y: 16.34 }
					]
				}
			],
			runId: 'elec-run-1',
			inputFingerprint: 'elec-fp-9'
		});

		expect(cadApiMock.storeDrawingRevision).toHaveBeenCalledTimes(1);
		const request = cadApiMock.storeDrawingRevision.mock.calls[0][0];
		const entities = request.entities as DrawingRevision['entities'];
		const electricalEntities = entities.filter((entity) => {
			const metadataRaw = entity?.header?.metadataJson ?? '{}';
			const metadata = JSON.parse(metadataRaw) as Record<string, unknown>;
			return metadata.discipline === 'electrical';
		});
		expect(electricalEntities.length).toBe(2);
	});

	it('orchestrates transmission and electrical materialization with shared run lineage', async () => {
		const baseRevision = makeRevision('rev-1', [makeBlockDefinition('block-north', 'North Arrow')]);
		const updatedRevision1 = makeRevision('rev-2', [makeBlockDefinition('block-north', 'North Arrow')], true);
		const updatedRevision2 = makeRevision('rev-3', [makeBlockDefinition('block-north', 'North Arrow')], true);
		const updatedRevision3 = makeRevision('rev-4', [makeBlockDefinition('block-north', 'North Arrow')], true);
		const updatedRevision4 = makeRevision('rev-5', [makeBlockDefinition('block-north', 'North Arrow')], true);

		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision: baseRevision });
		cadApiMock.storeDrawingRevision
			.mockResolvedValueOnce({ drawing: makeDrawing('rev-2'), revision: updatedRevision1 })
			.mockResolvedValueOnce({ drawing: makeDrawing('rev-3'), revision: updatedRevision2 })
			.mockResolvedValueOnce({ drawing: makeDrawing('rev-4'), revision: updatedRevision3 })
			.mockResolvedValueOnce({ drawing: makeDrawing('rev-5'), revision: updatedRevision4 });

		await initializeCadWorkspace('project-1', 'Solar Farm');
		const result = await runCadMaterializationPipeline({
			runId: 'pipeline-run-44',
			inputFingerprint: 'fp-pipeline-44',
			terrain: {
				analysisId: 'terrain-44',
				zones: [
					{
						zoneId: 'zone-44',
						zoneType: 'grading',
						vertices: [
							{ x: 78.39, y: 16.39 },
							{ x: 78.4, y: 16.39 },
							{ x: 78.4, y: 16.4 }
						]
					}
				]
			},
			layout: {
				layoutId: 'layout-44',
				tables: [
					{
						tableId: 'table-44',
						boundaryVertices: [
							{ x: 78.405, y: 16.405 },
							{ x: 78.415, y: 16.405 },
							{ x: 78.415, y: 16.415 }
						],
						rowIds: ['row-44-a']
					}
				],
				rows: [
					{
						rowId: 'row-44-a',
						vertices: [
							{ x: 78.406, y: 16.406 },
							{ x: 78.414, y: 16.414 }
						]
					}
				]
			},
			transmission: {
				routeId: 'route-44',
				waypoints: [
					{ x: 78.4, y: 16.4 },
					{ x: 78.5, y: 16.5 }
				]
			},
			electrical: {
				networkId: 'network-44',
				segments: [
					{
						segmentId: 'seg-44-dc',
						kind: 'dc',
						waypoints: [
							{ x: 78.41, y: 16.41 },
							{ x: 78.42, y: 16.42 }
						]
					}
				]
			}
		});

		expect(cadApiMock.storeDrawingRevision).toHaveBeenCalledTimes(4);
		expect(result.map((entry) => entry.status)).toEqual(['completed', 'completed', 'completed', 'completed']);
		expect(result.map((entry) => entry.stage)).toEqual(['terrain', 'layout', 'transmission', 'electrical']);
		const electricalStage = result.find((entry) => entry.stage === 'electrical');
		expect(electricalStage?.metrics?.inputCount).toBe(1);
		expect(electricalStage?.metrics?.topologyNodeCount).toBe(0);
		expect(get(cadWorkspace).lastMaterializationResults).toHaveLength(4);
		expect(get(cadWorkspace).lastMaterializationResults[3].stage).toBe('electrical');
		expect(get(cadWorkspace).materializationHistory).toHaveLength(1);
		expect(get(cadWorkspace).materializationHistory[0].runId).toBe('pipeline-run-44');
		expect(get(cadWorkspace).materializationHistory[0].results[3].stage).toBe('electrical');

		const thirdCallEntities = cadApiMock.storeDrawingRevision.mock.calls[2][0].entities as DrawingRevision['entities'];
		const fourthCallEntities = cadApiMock.storeDrawingRevision.mock.calls[3][0].entities as DrawingRevision['entities'];

		const firstTx = thirdCallEntities.find((entity) => {
			const metadata = JSON.parse(entity?.header?.metadataJson ?? '{}') as Record<string, unknown>;
			return metadata.discipline === 'transmission';
		});
		const secondElec = fourthCallEntities.find((entity) => {
			const metadata = JSON.parse(entity?.header?.metadataJson ?? '{}') as Record<string, unknown>;
			return metadata.discipline === 'electrical';
		});

		const txCompute = JSON.parse(firstTx?.header?.metadataJson ?? '{}').compute;
		const elecCompute = JSON.parse(secondElec?.header?.metadataJson ?? '{}').compute;

		expect(txCompute.runId).toBe('pipeline-run-44');
		expect(elecCompute.runId).toBe('pipeline-run-44');
		expect(txCompute.inputFingerprint).toBe('fp-pipeline-44');
		expect(elecCompute.inputFingerprint).toBe('fp-pipeline-44');
	});

	it('materializes layout tables and rows into panels layer entities', async () => {
		const baseRevision = makeRevision('rev-1', [makeBlockDefinition('block-north', 'North Arrow')]);
		const updatedRevision = makeRevision('rev-2', [makeBlockDefinition('block-north', 'North Arrow')], true);

		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision: baseRevision });
		cadApiMock.storeDrawingRevision.mockResolvedValue({ drawing: makeDrawing('rev-2'), revision: updatedRevision });

		await initializeCadWorkspace('project-1', 'Solar Farm');
		await materializeLayoutToCad({
			layoutId: 'layout-7',
			layoutName: 'Solar Block A',
			tables: [
				{
					tableId: 'table-7',
					boundaryVertices: [
						{ x: 78.21, y: 16.21 },
						{ x: 78.22, y: 16.21 },
						{ x: 78.22, y: 16.22 }
					],
					rowIds: ['row-7-a']
				}
			],
			rows: [
				{
					rowId: 'row-7-a',
					vertices: [
						{ x: 78.211, y: 16.211 },
						{ x: 78.219, y: 16.219 }
					]
				}
			],
			runId: 'layout-run-7',
			inputFingerprint: 'layout-fp-7'
		});

		expect(cadApiMock.storeDrawingRevision).toHaveBeenCalledTimes(1);
		const entities = cadApiMock.storeDrawingRevision.mock.calls[0][0].entities as DrawingRevision['entities'];
		const layoutEntities = entities.filter((entity) => {
			const metadata = JSON.parse(entity?.header?.metadataJson ?? '{}') as Record<string, unknown>;
			return metadata.discipline === 'layout' && metadata.layoutId === 'layout-7';
		});
		expect(layoutEntities.length).toBe(2);
	});

	it('materializes terrain analysis zones into terrain layer polygons', async () => {
		const baseRevision = makeRevision('rev-1', [makeBlockDefinition('block-north', 'North Arrow')]);
		const updatedRevision = makeRevision('rev-2', [makeBlockDefinition('block-north', 'North Arrow')], true);

		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision: baseRevision });
		cadApiMock.storeDrawingRevision.mockResolvedValue({ drawing: makeDrawing('rev-2'), revision: updatedRevision });

		await initializeCadWorkspace('project-1', 'Solar Farm');
		await materializeTerrainAnalysisToCad({
			analysisId: 'terrain-analysis-7',
			analysisName: 'Site grading candidate',
			zones: [
				{
					zoneId: 'zone-cut-1',
					zoneType: 'cut',
					vertices: [
						{ x: 78.01, y: 16.01 },
						{ x: 78.02, y: 16.01 },
						{ x: 78.02, y: 16.02 }
					],
					value: 3.4
				}
			],
			runId: 'terrain-run-7',
			inputFingerprint: 'terrain-fp-7'
		});

		expect(cadApiMock.storeDrawingRevision).toHaveBeenCalledTimes(1);
		const request = cadApiMock.storeDrawingRevision.mock.calls[0][0];
		const entities = request.entities as DrawingRevision['entities'];
		const terrainEntities = entities.filter((entity) => {
			const metadataRaw = entity?.header?.metadataJson ?? '{}';
			const metadata = JSON.parse(metadataRaw) as Record<string, unknown>;
			return metadata.discipline === 'civil' && metadata.terrainAnalysisId === 'terrain-analysis-7';
		});
		expect(terrainEntities.length).toBe(1);
	});

	it('materializes electrical network with topology grouping hierarchy (Sprint 8)', async () => {
		const baseRevision = makeRevision('rev-1', [makeBlockDefinition('block-north', 'North Arrow')]);
		const updatedRevision = makeRevision('rev-2', [makeBlockDefinition('block-north', 'North Arrow')], true);

		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision: baseRevision });
		cadApiMock.storeDrawingRevision.mockResolvedValue({ drawing: makeDrawing('rev-2'), revision: updatedRevision });

		await initializeCadWorkspace('project-1', 'Solar Farm');
		await materializeElectricalNetworkToCad({
			networkId: 'network-dc-8',
			networkName: 'DC String Network with MPPT',
			segments: [
				{
					segmentId: 'seg-dc-1',
					kind: 'dc',
					waypoints: [
						{ x: 100, y: 50 },
						{ x: 101, y: 51 }
					]
				},
				{
					segmentId: 'seg-dc-2',
					kind: 'dc',
					waypoints: [
						{ x: 101, y: 51 },
						{ x: 102, y: 52 }
					]
				}
			],
			topologyRoots: [
				{
					groupingId: 'xfmr-1',
					groupingType: 'transformer_route',
					ownershipLabel: 'xfmr_main',
					childNodes: [
						{
							groupingId: 'inv-1',
							groupingType: 'inverter_route',
							ownershipLabel: 'inv_01',
							childNodes: [
								{
									groupingId: 'mppt-1',
									groupingType: 'mppt_group',
									ownershipLabel: 'controller_mppt_01',
									childNodes: [
										{
											groupingId: 'str-1',
											groupingType: 'dc_string',
											childNodes: [],
											childSegmentIds: ['seg-dc-1', 'seg-dc-2']
										}
									]
								}
							]
						}
					]
				}
			],
			runId: 'elec-run-8',
			inputFingerprint: 'elec-fp-8'
		});

		expect(cadApiMock.storeDrawingRevision).toHaveBeenCalledTimes(1);
		const request = cadApiMock.storeDrawingRevision.mock.calls[0][0];
		const entities = request.entities as DrawingRevision['entities'];

		// Check that both segments and topology grouping entities were created
		const segmentEntities = entities.filter((entity) => {
			const metadataRaw = entity?.header?.metadataJson ?? '{}';
			const metadata = JSON.parse(metadataRaw) as Record<string, unknown>;
			return metadata.materializationKind === 'electrical-segment';
		});

		const topologyEntities = entities.filter((entity) => {
			const metadataRaw = entity?.header?.metadataJson ?? '{}';
			const metadata = JSON.parse(metadataRaw) as Record<string, unknown>;
			return metadata.electricalGroupingType !== undefined; // Topology annotations
		});
		const firstTopology = topologyEntities[0];
		const firstTopologyAnchor = firstTopology?.geometry?.case === 'text' ? firstTopology.geometry.value.anchor : undefined;

		expect(segmentEntities.length).toBeGreaterThanOrEqual(2);
		expect(topologyEntities.length).toBeGreaterThanOrEqual(1); // At least one grouping annotation
		expect(firstTopologyAnchor).toBeDefined();
		expect(firstTopologyAnchor?.x).toBeGreaterThan(90);
		expect(firstTopologyAnchor?.y).toBeGreaterThan(40);
	});

	it('blocks electrical materialization when topology quality checks fail (Sprint 9)', async () => {
		const baseRevision = makeRevision('rev-1', [makeBlockDefinition('block-north', 'North Arrow')]);

		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision: baseRevision });

		await initializeCadWorkspace('project-1', 'Solar Farm');
		await materializeElectricalNetworkToCad({
			networkId: 'network-qc-9',
			segments: [
				{
					segmentId: 'seg-dc-1',
					kind: 'dc',
					waypoints: [
						{ x: 100, y: 50 },
						{ x: 101, y: 51 }
					]
				},
				{
					segmentId: 'seg-dc-2',
					kind: 'dc',
					waypoints: [
						{ x: 101, y: 51 },
						{ x: 102, y: 52 }
					]
				}
			],
			topologyRoots: [
				{
					groupingId: 'inv-9',
					groupingType: 'inverter_route',
					voltage: 1500,
					childNodes: [
						{
							groupingId: 'mppt-9',
							groupingType: 'mppt_group',
							voltage: 1000,
							childNodes: [
								{
									groupingId: 'str-9-a',
									groupingType: 'dc_string',
									childNodes: [],
									childSegmentIds: ['seg-dc-1']
								},
								{
									groupingId: 'str-9-b',
									groupingType: 'dc_string',
									childNodes: [],
									childSegmentIds: []
								}
							]
						}
					]
				}
			]
		});

		expect(cadApiMock.storeDrawingRevision).not.toHaveBeenCalled();
		expect(get(cadWorkspace).error).toContain('Electrical topology quality validation failed');
	});

	it('stores pipeline history with newest run first', async () => {
		const baseRevision = makeRevision('rev-1', [makeBlockDefinition('block-north', 'North Arrow')]);
		const updatedRevision1 = makeRevision('rev-2', [makeBlockDefinition('block-north', 'North Arrow')], true);
		const updatedRevision2 = makeRevision('rev-3', [makeBlockDefinition('block-north', 'North Arrow')], true);

		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision: baseRevision });
		cadApiMock.storeDrawingRevision
			.mockResolvedValueOnce({ drawing: makeDrawing('rev-2'), revision: updatedRevision1 })
			.mockResolvedValueOnce({ drawing: makeDrawing('rev-3'), revision: updatedRevision2 });

		await initializeCadWorkspace('project-1', 'Solar Farm');
		await runCadMaterializationPipeline({
			runId: 'pipeline-a',
			electrical: {
				networkId: 'network-a',
				segments: [
					{
						segmentId: 'seg-a',
						kind: 'dc',
						waypoints: [
							{ x: 10, y: 10 },
							{ x: 11, y: 11 }
						]
					}
				]
			}
		});
		await runCadMaterializationPipeline({
			runId: 'pipeline-b',
			electrical: {
				networkId: 'network-b',
				segments: [
					{
						segmentId: 'seg-b',
						kind: 'dc',
						waypoints: [
							{ x: 12, y: 12 },
							{ x: 13, y: 13 }
						]
					}
				]
			}
		});

		const history = get(cadWorkspace).materializationHistory;
		expect(history).toHaveLength(2);
		expect(history[0].runId).toBe('pipeline-b');
		expect(history[1].runId).toBe('pipeline-a');
	});

	it('caps materialization history at 12 runs', async () => {
		const baseRevision = makeRevision('rev-1', [makeBlockDefinition('block-north', 'North Arrow')]);
		const updatedRevision = makeRevision('rev-2', [makeBlockDefinition('block-north', 'North Arrow')], true);

		cadApiMock.ensureProjectDrawing.mockResolvedValue({ drawing: makeDrawing('rev-1'), revision: baseRevision });
		cadApiMock.storeDrawingRevision.mockResolvedValue({ drawing: makeDrawing('rev-2'), revision: updatedRevision });

		await initializeCadWorkspace('project-1', 'Solar Farm');
		for (let i = 0; i < 13; i += 1) {
			await runCadMaterializationPipeline({
				runId: `pipeline-${i}`,
				electrical: {
					networkId: `network-${i}`,
					segments: [
						{
							segmentId: `seg-${i}`,
							kind: 'dc',
							waypoints: [
								{ x: 20 + i, y: 20 + i },
								{ x: 21 + i, y: 21 + i }
							]
						}
					]
				}
			});
		}

		const history = get(cadWorkspace).materializationHistory;
		expect(history).toHaveLength(12);
		expect(history[0].runId).toBe('pipeline-12');
		expect(history[11].runId).toBe('pipeline-1');
	});

	it('raises regression alert when violations increase across 2+ consecutive runs', async () => {
		cadWorkspace.update((state) => ({
			...state,
			materializationHistory: [
				{
					runId: 'run-3',
					inputFingerprint: '',
					timestampMs: 3000,
					results: [
						{ stage: 'electrical', status: 'completed', message: 'r3', metrics: { qualityViolations: 3 } }
					]
				},
				{
					runId: 'run-2',
					inputFingerprint: '',
					timestampMs: 2000,
					results: [
						{ stage: 'electrical', status: 'completed', message: 'r2', metrics: { qualityViolations: 2 } }
					]
				},
				{
					runId: 'run-1',
					inputFingerprint: '',
					timestampMs: 1000,
					results: [
						{ stage: 'electrical', status: 'completed', message: 'r1', metrics: { qualityViolations: 1 } }
					]
				}
			]
		}));

		const alert = get(cadElectricalRegressionAlert);
		expect(alert.active).toBe(true);
		expect(alert.streak).toBeGreaterThanOrEqual(2);
	});

	it('computes diagnostics intelligence health and recommendations', async () => {
		cadWorkspace.update((state) => ({
			...state,
			lastMaterializationResults: [
				{
					stage: 'electrical',
					status: 'completed',
					message: 'Electrical run',
					metrics: {
						inputCount: 4,
						topologyNodeCount: 0,
						topologyDepth: 5,
						qualityViolations: 3
					}
				}
			],
			materializationHistory: [
				{
					runId: 'run-new',
					inputFingerprint: '',
					timestampMs: 3000,
					results: [
						{ stage: 'electrical', status: 'completed', message: 'new', metrics: { qualityViolations: 3 } }
					]
				},
				{
					runId: 'run-mid',
					inputFingerprint: '',
					timestampMs: 2000,
					results: [
						{ stage: 'electrical', status: 'completed', message: 'mid', metrics: { qualityViolations: 2 } }
					]
				},
				{
					runId: 'run-old',
					inputFingerprint: '',
					timestampMs: 1000,
					results: [
						{ stage: 'electrical', status: 'completed', message: 'old', metrics: { qualityViolations: 1 } }
					]
				}
			]
		}));

		const intelligence = get(cadElectricalDiagnosticsIntelligence);
		expect(intelligence.healthScore).toBeLessThan(70);
		expect(intelligence.trend).toBe('declining');
		expect(intelligence.recommendations.join(' | ')).toContain('Resolve electrical topology quality violations');
		expect(intelligence.recommendations.join(' | ')).toContain('Provide topology roots for electrical runs');
	});

	it('respects configurable regression streak threshold', async () => {
		cadWorkspace.update((state) => ({
			...state,
			materializationHistory: [
				{ runId: 'run-3', inputFingerprint: '', timestampMs: 3000, results: [{ stage: 'electrical', status: 'completed', message: 'r3', metrics: { qualityViolations: 3 } }] },
				{ runId: 'run-2', inputFingerprint: '', timestampMs: 2000, results: [{ stage: 'electrical', status: 'completed', message: 'r2', metrics: { qualityViolations: 2 } }] },
				{ runId: 'run-1', inputFingerprint: '', timestampMs: 1000, results: [{ stage: 'electrical', status: 'completed', message: 'r1', metrics: { qualityViolations: 1 } }] }
			]
		}));

		setCadDiagnosticsConfig({ regressionStreakThreshold: 3 });
		expect(get(cadElectricalRegressionAlert).active).toBe(false);

		setCadDiagnosticsConfig({ regressionStreakThreshold: 2 });
		expect(get(cadElectricalRegressionAlert).active).toBe(true);
	});

	it('recalculates intelligence health score using configured penalties', async () => {
		cadWorkspace.update((state) => ({
			...state,
			lastMaterializationResults: [
				{ stage: 'electrical', status: 'completed', message: 'run', metrics: { qualityViolations: 2, topologyDepth: 5, topologyNodeCount: 1, inputCount: 2 } }
			],
			materializationHistory: [
				{ runId: 'run-a', inputFingerprint: '', timestampMs: 1000, results: [{ stage: 'electrical', status: 'completed', message: 'a', metrics: { qualityViolations: 2 } }] }
			]
		}));

		setCadDiagnosticsConfig({
			healthPenaltyPerViolation: 12,
			healthPenaltyRecentAverage: 5,
			healthPenaltyRegression: 15,
			healthPenaltyExcessDepth: 4,
			depthBaseline: 4
		});
		const baseline = get(cadElectricalDiagnosticsIntelligence).healthScore;

		setCadDiagnosticsConfig({ healthPenaltyPerViolation: 20 });
		const stricter = get(cadElectricalDiagnosticsIntelligence).healthScore;

		expect(stricter).toBeLessThan(baseline);
	});

	it('applies diagnostics preset values', async () => {
		applyCadDiagnosticsPreset('strict');
		const strictConfig = get(cadWorkspace).diagnosticsConfig;
		expect(strictConfig.healthPenaltyPerViolation).toBe(16);
		expect(strictConfig.regressionStreakThreshold).toBe(2);

		applyCadDiagnosticsPreset('lenient');
		const lenientConfig = get(cadWorkspace).diagnosticsConfig;
		expect(lenientConfig.healthPenaltyPerViolation).toBe(8);
		expect(lenientConfig.regressionStreakThreshold).toBe(3);
	});

	it('resets diagnostics config to defaults', async () => {
		setCadDiagnosticsConfig({
			healthPenaltyPerViolation: 20,
			averageWindowSize: 9,
			regressionStreakThreshold: 4
		});
		resetCadDiagnosticsConfig();
		const config = get(cadWorkspace).diagnosticsConfig;
		expect(config.healthPenaltyPerViolation).toBe(12);
		expect(config.averageWindowSize).toBe(5);
		expect(config.regressionStreakThreshold).toBe(2);
	});

	it('tracks diagnostics config provenance across manual, preset, reset, and restore flows', async () => {
		const dateNowSpy = vi.spyOn(Date, 'now');
		dateNowSpy.mockReturnValueOnce(1000);
		setCadDiagnosticsConfig({ healthPenaltyPerViolation: 20, averageWindowSize: 8 });

		let workspace = get(cadWorkspace);
		expect(workspace.diagnosticsConfigMeta.source).toBe('manual');
		expect(workspace.diagnosticsConfigMeta.timestampMs).toBe(1000);
		expect(workspace.diagnosticsConfigMeta.summary).toContain('Updated');
		expect(workspace.diagnosticsConfigHistory[0].changedFields).toEqual(['healthPenaltyPerViolation', 'averageWindowSize']);

		dateNowSpy.mockReturnValueOnce(1100);
		applyCadDiagnosticsPreset('strict');
		workspace = get(cadWorkspace);
		expect(workspace.diagnosticsConfigMeta.source).toBe('preset-strict');
		expect(workspace.diagnosticsConfigMeta.timestampMs).toBe(1100);
		expect(workspace.diagnosticsConfigHistory[0].summary).toBe('Applied strict diagnostics preset');

		dateNowSpy.mockReturnValueOnce(1200);
		resetCadDiagnosticsConfig();
		workspace = get(cadWorkspace);
		expect(workspace.diagnosticsConfigMeta.source).toBe('reset');
		expect(workspace.diagnosticsConfigMeta.timestampMs).toBe(1200);
		expect(workspace.diagnosticsConfigHistory[0].summary).toBe('Reset diagnostics tuning to defaults');

		const manualEntry = workspace.diagnosticsConfigHistory.find((entry) => entry.source === 'manual' && entry.timestampMs === 1000);
		expect(manualEntry).toBeDefined();

		dateNowSpy.mockReturnValueOnce(1300);
		restoreCadDiagnosticsConfigHistoryEntry(manualEntry!.entryId);
		workspace = get(cadWorkspace);
		expect(workspace.diagnosticsConfigMeta.source).toBe('manual');
		expect(workspace.diagnosticsConfigMeta.timestampMs).toBe(1300);
		expect(workspace.diagnosticsConfigMeta.summary).toBe('Restored diagnostics tuning from audit history');
		expect(workspace.diagnosticsConfig.healthPenaltyPerViolation).toBe(20);
		expect(workspace.diagnosticsConfig.averageWindowSize).toBe(8);
		expect(workspace.diagnosticsConfigHistory[0].summary).toBe('Restored diagnostics tuning from audit history');

		dateNowSpy.mockRestore();
	});

	it('caps diagnostics config audit history at 50 entries', async () => {
		const dateNowSpy = vi.spyOn(Date, 'now');
		let timestampMs = 1000;
		dateNowSpy.mockImplementation(() => timestampMs++);

		for (let index = 0; index < 55; index += 1) {
			setCadDiagnosticsConfig({
				healthPenaltyPerViolation: 10 + (index % 20),
				averageWindowSize: 1 + (index % 12)
			});
		}

		const history = get(cadWorkspace).diagnosticsConfigHistory;
		expect(history).toHaveLength(50);
		expect(history[0].timestampMs).toBe(1054);
		expect(history[49].timestampMs).toBe(1005);

		dateNowSpy.mockRestore();
	});
});