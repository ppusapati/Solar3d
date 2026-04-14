<script lang="ts">
	import { activeLayout, activeProject } from '$lib/core/stores';
	import { backendClients, mlInferenceApi, geoApi, graphApi } from '$lib/core/api';
	import { Objective_ObjectiveKind } from '$lib/gen/optimization/v1/optimization_pb.js';
	import { ObjectiveKind, VariableType } from '$lib/gen/optimization/v1/optimization_domain_pb.js';

	const paretoObjectivesTemplate = JSON.stringify(
		[
			{ name: 'yield', kind: Objective_ObjectiveKind.MAXIMIZE, weight: 0.65 },
			{ name: 'capex', kind: Objective_ObjectiveKind.MINIMIZE, weight: 0.35 }
		],
		null,
		2
	);

	const paretoSolutionTemplate = JSON.stringify(
		{ id: 101, variables: [6, 22], objectives: [1845, 925000], rank: 1, crowdingDistance: 0.24 },
		null,
		2
	);

	const optimizationProblemTemplate = JSON.stringify(
		{
			problemId: 'layout-optimizer',
			variables: [
				{ name: 'pitch', variableType: VariableType.CONTINUOUS, bounds: { min: 4, max: 9 } },
				{ name: 'tilt', variableType: VariableType.CONTINUOUS, bounds: { min: 10, max: 35 } }
			],
			objectives: [
				{ name: 'yield', kind: ObjectiveKind.MAXIMIZE, weight: 0.6 },
				{ name: 'cost', kind: ObjectiveKind.MINIMIZE, weight: 0.4 }
			],
			constraints: [
				{
					name: 'row_spacing',
					expression: 'pitch - tilt / 10',
					allowedRange: { min: 1.5, max: 10 },
					hardConstraint: true
				}
			],
			randomSeed: 42,
			maxIterations: 200
		},
		null,
		2
	);

	const monteCarloTemplate = JSON.stringify(
		[
			{ mean: 1800, stdDev: 120 },
			{ mean: 0.79, stdDev: 0.03 }
		],
		null,
		2
	);

	const geoCandidatesTemplate = JSON.stringify(
		[
			{ x: 0, y: 0 },
			{ x: 12, y: 4 },
			{ x: 18, y: 16 },
			{ x: 6, y: 10 }
		],
		null,
		2
	);

	const contourDataTemplate = JSON.stringify(
		[
			104, 106, 108, 110,
			103, 105, 107, 109,
			101, 102, 104, 106,
			99, 100, 101, 103
		],
		null,
		2
	);

	const graphEdgesTemplate = JSON.stringify(
		[
			{ u: 0, v: 1, weight: 4 },
			{ u: 1, v: 2, weight: 3 },
			{ u: 0, v: 2, weight: 5 },
			{ u: 2, v: 3, weight: 2 },
			{ u: 1, v: 3, weight: 6 }
		],
		null,
		2
	);

	const graphTerminalsTemplate = JSON.stringify([0, 2, 3], null, 2);

	const solarObstaclesTemplate = JSON.stringify(
		[
			{ id: 'tree-1', base: { x: 12, y: 8, z: 0 }, heightM: 5, extentM: 2 },
			{ id: 'shed-1', base: { x: 26, y: 14, z: 0 }, heightM: 3, extentM: 4 }
		],
		null,
		2
	);

	const bulkSolarTimestampsTemplate = JSON.stringify(
		[
			Math.floor(Date.now() / 1000),
			Math.floor(Date.now() / 1000) + 3600,
			Math.floor(Date.now() / 1000) + 7200
		],
		null,
		2
	);

	const hyperparametersTemplate = JSON.stringify({ learning_rate: 0.001, epochs: 20, batch_size: 64 }, null, 2);
	const alertThresholdsTemplate = JSON.stringify(['p95_latency<500ms', 'yield_drift<3%'], null, 2);

	let mlTaskType = 'yield_forecast';
	let mlSiteId = '';
	let temperatureC = 28;
	let irradianceWM2 = 900;
	let humidityPercent = 35;
	let pressureMb = 1012;
	let windSpeedMS = 4.5;
	let solarAltitudeDeg = 62;
	let solarAzimuthDeg = 145;
	let airMass = 1.15;
	let clearnessIndex = 0.72;
	let hourOfDay = 13;
	let dayOfYear = 190;
	let month = 7;
	let isWeekend = false;
	let modelOutput = 1480;
	let uncertaintyEstimate = 65;
	let expectedYield = 1500;
	let actualYield = 1370;
	let modelPrediction = 1450;
	let sensorVariance = 18;
	let currentDegradation = 1.8;
	let annualRate = 0.45;
	let degradationYears = 10;
	let feedbackPredictionId = '';
	let feedbackActualLabel = 1425;
	let feedbackNotes = 'Measured after inverter maintenance';
	let trainingVersion = 'v-next';
	let lookbackDays = 365;
	let minSamplesPerSite = 200;
	let trainSplitRatio = 0.7;
	let validationSplitRatio = 0.15;
	let testSplitRatio = 0.15;
	let timeAwareSplit = true;
	let trainingTriggeredBy = 'frontend-user';
	let trainingCommitHash = 'workspace-head';
	let hyperparametersJson = hyperparametersTemplate;
	let trainingRunId = '';
	let versionsLimit = 10;
	let statusFilter = '';
	let candidateModelVersionId = '';
	let versusModelId = '';
	let deploymentApprovalId = 'manual-review';
	let deploymentNotes = 'Deploy from advanced analytics panel';
	let requireManualApproval = true;
	let canaryTrafficPercent = 10;
	let rollbackThresholdMinutes = 30;
	let minImprovementPercent = 2;
	let alertThresholdsJson = alertThresholdsTemplate;
	let rollbackReason = 'Manual rollback from frontend';

	let paretoObjectivesJson = paretoObjectivesTemplate;
	let paretoSolutionJson = paretoSolutionTemplate;
	let optimizationProblemJson = optimizationProblemTemplate;
	let monteCarloJson = monteCarloTemplate;
	let monteCarloSamples = 500;
	let optimizationSeed = 42;
	let gaPopulationSize = 50;
	let gaGenerations = 40;
	let gaCrossoverRate = 0.75;
	let gaMutationRate = 0.12;
	let gaEliteCount = 4;
	let saInitialTemperature = 100;
	let saCoolingRate = 0.92;
	let saIterations = 120;
	let saPerturbationScale = 0.5;
	let psoParticles = 30;
	let psoIterations = 80;
	let psoC1 = 1.5;
	let psoC2 = 1.7;
	let psoW = 0.8;
	let psoBoundaryMin = 0;
	let psoBoundaryMax = 10;

	let bufferCenterX = 10;
	let bufferCenterY = 12;
	let bufferRadius = 8;
	let bufferSegments = 24;
	let nearestQueryX = 9;
	let nearestQueryY = 7;
	let geoCandidatesJson = geoCandidatesTemplate;
	let contourWidth = 4;
	let contourHeight = 4;
	let contourResolution = 2;
	let contourOriginX = 0;
	let contourOriginY = 0;
	let contourNoData = -9999;
	let contourInterval = 2;
	let contourDataJson = contourDataTemplate;

	let graphNodeCount = 4;
	let graphEdgesJson = graphEdgesTemplate;
	let graphTerminalsJson = graphTerminalsTemplate;

	let solarTimestampSeconds = Math.floor(Date.now() / 1000);
	let solarLatitude = 17.385;
	let solarLongitude = 78.4867;
	let solarUtcOffset = 5.5;
	let solarObstaclesJson = solarObstaclesTemplate;
	let solarSunElevation = 42;
	let solarSunAzimuth = 155;
	let solarExaggeration = 1;
	let solarTurbidity = 2;
	let solarClearnessIndex = 0.68;
	let bulkSolarTimestampsJson = bulkSolarTimestampsTemplate;

	let mlBusy = false;
	let mlError = '';
	let optimizationBusy = false;
	let optimizationError = '';
	let geoBusy = false;
	let geoError = '';
	let graphBusy = false;
	let graphError = '';
	let solarBusy = false;
	let solarError = '';

	let extractedFeatures: any = null;
	let yieldPrediction: any = null;
	let anomalyDetection: any = null;
	let degradationForecast: any = null;
	let feedbackResult: any = null;
	let trainingResult: any = null;
	let trainingStatus: any = null;
	let modelVersions: any[] = [];
	let activeModelVersion: any = null;
	let modelEvaluation: any = null;
	let deploymentResult: any = null;
	let rollbackResult: any = null;

	let paretoResult: any = null;
	let monteCarloResult: any = null;
	let gaResult: any = null;
	let saResult: any = null;
	let psoResult: any = null;

	let bufferResult: any = null;
	let nearestPointResult: any = null;
	let contourResult: any = null;

	let mstResult: any = null;
	let steinerResult: any = null;

	let solarPositionResult: any = null;
	let castShadowsResult: any = null;
	let dniResult: any = null;
	let dhiResult: any = null;
	let bulkSolarResult: any = null;

	$: if ($activeProject?.id && !mlSiteId) {
		mlSiteId = $activeProject.id;
	}

	$: if ($activeLayout && !feedbackPredictionId) {
		feedbackPredictionId = `${$activeLayout.id}-latest`;
	}

	function parseJson<T>(text: string, label: string): T {
		try {
			return JSON.parse(text) as T;
		} catch (error) {
			throw new Error(`${label} must be valid JSON`);
		}
	}

	function normalizeProblem(problem: any) {
		return {
			...problem,
			randomSeed: BigInt(problem.randomSeed ?? optimizationSeed),
			maxIterations: Number(problem.maxIterations ?? 100),
			variables: Array.isArray(problem.variables) ? problem.variables : [],
			objectives: Array.isArray(problem.objectives) ? problem.objectives : [],
			constraints: Array.isArray(problem.constraints) ? problem.constraints : []
		};
	}

	function prettyJson(value: unknown): string {
		return JSON.stringify(
			value,
			(_key, nestedValue) => (typeof nestedValue === 'bigint' ? Number(nestedValue) : nestedValue),
			2
		);
	}

	function formatTimestamp(timestamp?: { seconds?: bigint; nanos?: number }): string {
		if (!timestamp) {
			return '—';
		}
		const seconds = Number(timestamp.seconds ?? 0n);
		const nanos = Number(timestamp.nanos ?? 0);
		const millis = seconds * 1000 + Math.floor(nanos / 1_000_000);
		if (!Number.isFinite(millis) || millis <= 0) {
			return '—';
		}
		return new Date(millis).toLocaleString();
	}

	async function runMl<T>(action: () => Promise<T>, apply: (result: T) => void) {
		mlBusy = true;
		mlError = '';
		try {
			apply(await action());
		} catch (error) {
			mlError = error instanceof Error ? error.message : 'ML operation failed';
		} finally {
			mlBusy = false;
		}
	}

	async function extractFeatures() {
		await runMl(
			() =>
				mlInferenceApi.extractFeatures({
					weather: { temperatureC, irradianceWM2, humidityPercent, pressureMb, windSpeedMS },
					solar: { solarAltitudeDeg, solarAzimuthDeg, airMass, clearnessIndex },
					time: { hourOfDay, dayOfYear, month, isWeekend }
				}),
			(result) => {
				extractedFeatures = result;
			}
		);
	}

	async function predictYield() {
		await runMl(
			() =>
				mlInferenceApi.predictYield({
					features: extractedFeatures?.features,
					featurePayload: extractedFeatures?.payload,
					modelOutput,
					uncertaintyEstimate
				}),
			(result) => {
				yieldPrediction = result;
			}
		);
	}

	async function detectAnomaly() {
		await runMl(
			() =>
				mlInferenceApi.detectAnomaly({
					expectedYield,
					actualYield,
					modelPrediction,
					sensorVariance
				}),
			(result) => {
				anomalyDetection = result;
			}
		);
	}

	async function forecastDegradation() {
		await runMl(
			() =>
				mlInferenceApi.forecastDegradation({
					currentDegradation,
					annualRate,
					years: degradationYears
				}),
			(result) => {
				degradationForecast = result;
			}
		);
	}

	async function submitFeedback() {
		await runMl(
			() =>
				mlInferenceApi.submitFeedback({
					predictionId: feedbackPredictionId,
					siteId: mlSiteId,
					taskType: mlTaskType,
					actualLabel: feedbackActualLabel,
					notes: feedbackNotes,
					submittedBy: 'frontend-user',
					sample: extractedFeatures?.payload
						? {
							sampleId: `${mlSiteId || 'site'}-${Date.now()}`,
							payload: extractedFeatures.payload,
							label: feedbackActualLabel,
							labelSource: 'field-measurement'
						}
						: undefined
				}),
			(result) => {
				feedbackResult = result;
			}
		);
	}

	async function startTraining() {
		await runMl(
			() => {
				const hyperparameters = parseJson<Record<string, unknown>>(hyperparametersJson, 'Training hyperparameters');
				return mlInferenceApi.startTraining({
					taskType: mlTaskType,
					config: {
						version: trainingVersion,
						lookbackDays,
						minSamplesPerSite,
						trainSplitRatio,
						validationSplitRatio,
						testSplitRatio,
						timeAwareSplit
					},
						hyperparams: Object.fromEntries(
						Object.entries(hyperparameters).map(([key, value]) => [key, String(value)])
					),
					triggeredBy: trainingTriggeredBy,
					commitHash: trainingCommitHash
				});
			},
			(result) => {
				trainingResult = result;
				trainingRunId = result.trainingRunId;
			}
		);
	}

	async function getTrainingStatus() {
		if (!trainingRunId.trim()) {
			mlError = 'Training run ID is required';
			return;
		}
		await runMl(
			() => mlInferenceApi.getTrainingStatus({ trainingRunId: trainingRunId.trim() }),
			(result) => {
				trainingStatus = result;
				if (result.modelVersionId) {
					candidateModelVersionId = result.modelVersionId;
				}
			}
		);
	}

	async function getModelVersions() {
		await runMl(
			() => mlInferenceApi.getModelVersions({ taskType: mlTaskType, limit: versionsLimit, statusFilter }),
			(result) => {
				modelVersions = result.versions ?? [];
			}
		);
	}

	async function getActiveModelVersion() {
		await runMl(
			() => mlInferenceApi.getActiveModelVersion({ taskType: mlTaskType }),
			(result) => {
				activeModelVersion = result;
				candidateModelVersionId = result.activeVersion?.versionId ?? candidateModelVersionId;
				versusModelId = result.previousVersion?.versionId ?? versusModelId;
			}
		);
	}

	async function evaluateModel() {
		await runMl(
			() =>
				mlInferenceApi.evaluateModel({
					modelVersionId: candidateModelVersionId,
					dataset: 'holdout',
					versusModelId
				}),
			(result) => {
				modelEvaluation = result;
			}
		);
	}

	async function deployModelVersion() {
		await runMl(
			() => {
				const alertThresholds = parseJson<string[]>(alertThresholdsJson, 'Deployment alert thresholds');
				return mlInferenceApi.deployModelVersion({
					modelVersionId: candidateModelVersionId,
					policy: {
						minImprovementPercent,
						requireManualApproval,
						canaryTrafficPercent,
						rollbackThresholdMinutes,
						alertThresholds
					},
					deployedBy: 'frontend-user',
					approvalId: deploymentApprovalId,
					notes: deploymentNotes
				});
			},
			(result) => {
				deploymentResult = result;
			}
		);
	}

	async function rollbackModelVersion() {
		await runMl(
			() =>
				mlInferenceApi.rollbackModelVersion({
					taskType: mlTaskType,
					reason: rollbackReason,
					rolledBackBy: 'frontend-user'
				}),
			(result) => {
				rollbackResult = result;
			}
		);
	}

	async function runOptimization<T>(action: () => Promise<T>, apply: (result: T) => void) {
		optimizationBusy = true;
		optimizationError = '';
		try {
			apply(await action());
		} catch (error) {
			optimizationError = error instanceof Error ? error.message : 'Optimization call failed';
		} finally {
			optimizationBusy = false;
		}
	}

	async function computeParetoFrontier() {
		await runOptimization(
			() =>
				backendClients.optimization.paretoFrontier({
					objectives: parseJson<any[]>(paretoObjectivesJson, 'Pareto objectives'),
					newSolution: parseJson<any>(paretoSolutionJson, 'Candidate solution')
				}),
			(result) => {
				paretoResult = result;
			}
		);
	}

	async function runMonteCarloSampling() {
		await runOptimization(
			() => {
				const distributions = parseJson<any[]>(monteCarloJson, 'Monte Carlo distributions');
				return backendClients.optimization.monteCarloSampling({
					distributions,
					numSamples: monteCarloSamples,
					seed: BigInt(optimizationSeed)
				});
			},
			(result) => {
				monteCarloResult = result;
			}
		);
	}

	async function runGeneticAlgorithm() {
		await runOptimization(
			() =>
				backendClients.optimization.geneticAlgorithm({
					populationSize: gaPopulationSize,
					generations: gaGenerations,
					crossoverRate: gaCrossoverRate,
					mutationRate: gaMutationRate,
					eliteCount: gaEliteCount,
					seed: BigInt(optimizationSeed),
					problem: normalizeProblem(parseJson<any>(optimizationProblemJson, 'Optimization problem'))
				}),
			(result) => {
				gaResult = result;
			}
		);
	}

	async function runSimulatedAnnealing() {
		await runOptimization(
			() =>
				backendClients.optimization.simulatedAnnealing({
					initialTemperature: saInitialTemperature,
					coolingRate: saCoolingRate,
					iterations: saIterations,
					perturbationScale: saPerturbationScale,
					seed: BigInt(optimizationSeed),
					initialSolution: [6, 20],
					problem: normalizeProblem(parseJson<any>(optimizationProblemJson, 'Optimization problem'))
				}),
			(result) => {
				saResult = result;
			}
		);
	}

	async function runParticleSwarmOptimization() {
		await runOptimization(
			() =>
				backendClients.optimization.particleSwarmOptimization({
					numParticles: psoParticles,
					iterations: psoIterations,
					c1: psoC1,
					c2: psoC2,
					w: psoW,
					boundaryMin: psoBoundaryMin,
					boundaryMax: psoBoundaryMax,
					seed: BigInt(optimizationSeed),
					problem: normalizeProblem(parseJson<any>(optimizationProblemJson, 'Optimization problem'))
				}),
			(result) => {
				psoResult = result;
			}
		);
	}

	async function runGeo<T>(action: () => Promise<T>, apply: (result: T) => void) {
		geoBusy = true;
		geoError = '';
		try {
			apply(await action());
		} catch (error) {
			geoError = error instanceof Error ? error.message : 'Geo operation failed';
		} finally {
			geoBusy = false;
		}
	}

	async function createBuffer() {
		await runGeo(
			() =>
				geoApi.bufferPoint({
					center: { x: bufferCenterX, y: bufferCenterY },
					radius: bufferRadius,
					segments: bufferSegments
				}),
			(result) => {
				bufferResult = result;
			}
		);
	}

	async function findNearestPoint() {
		await runGeo(
			() =>
				geoApi.nearestPoint({
					query: { x: nearestQueryX, y: nearestQueryY },
					candidates: parseJson<any[]>(geoCandidatesJson, 'Geo candidates')
				}),
			(result) => {
				nearestPointResult = result;
			}
		);
	}

	async function generateContours() {
		await runGeo(
			() =>
				geoApi.generateContours({
					width: contourWidth,
					height: contourHeight,
					resolution: contourResolution,
					originX: contourOriginX,
					originY: contourOriginY,
					noData: contourNoData,
					data: parseJson<number[]>(contourDataJson, 'Contour grid data'),
					interval: contourInterval
				}),
			(result) => {
				contourResult = result;
			}
		);
	}

	async function runGraph<T>(action: () => Promise<T>, apply: (result: T) => void) {
		graphBusy = true;
		graphError = '';
		try {
			apply(await action());
		} catch (error) {
			graphError = error instanceof Error ? error.message : 'Graph operation failed';
		} finally {
			graphBusy = false;
		}
	}

	async function computeMst() {
		await runGraph(
			() =>
				graphApi.minimumSpanningTree({
					nodeCount: graphNodeCount,
					edges: parseJson<any[]>(graphEdgesJson, 'Graph edges')
				}),
			(result) => {
				mstResult = result;
			}
		);
	}

	async function computeSteinerTree() {
		await runGraph(
			() =>
				graphApi.approximateSteinerTree({
					nodeCount: graphNodeCount,
					edges: parseJson<any[]>(graphEdgesJson, 'Graph edges'),
					terminals: parseJson<number[]>(graphTerminalsJson, 'Graph terminals')
				}),
			(result) => {
				steinerResult = result;
			}
		);
	}

	async function runSolar<T>(action: () => Promise<T>, apply: (result: T) => void) {
		solarBusy = true;
		solarError = '';
		try {
			apply(await action());
		} catch (error) {
			solarError = error instanceof Error ? error.message : 'Solar operation failed';
		} finally {
			solarBusy = false;
		}
	}

	async function calculateSolarPosition() {
		await runSolar(
			() =>
				backendClients.solar.calculateSolarPosition({
					timestampSeconds: solarTimestampSeconds,
					latitudeDeg: solarLatitude,
					longitudeDeg: solarLongitude,
					utcOffsetHours: solarUtcOffset
				}),
			(result) => {
				solarPositionResult = result;
			}
		);
	}

	async function castShadows() {
		await runSolar(
			() =>
				backendClients.solar.castShadows({
					obstacles: parseJson<any[]>(solarObstaclesJson, 'Solar obstacles'),
					sunElevationDeg: solarSunElevation,
					sunAzimuthDeg: solarSunAzimuth,
					exaggeration: solarExaggeration
				}),
			(result) => {
				castShadowsResult = result;
			}
		);
	}

	async function calculateDni() {
		await runSolar(
			() => backendClients.solar.calculateDNI({ airMass, zenithAngleDeg: 90 - solarAltitudeDeg, turbidity: solarTurbidity }),
			(result) => {
				dniResult = result;
			}
		);
	}

	async function calculateDhi() {
		await runSolar(
			() => backendClients.solar.calculateDHI({ zenithAngleDeg: 90 - solarAltitudeDeg, clearnessIndex: solarClearnessIndex }),
			(result) => {
				dhiResult = result;
			}
		);
	}

	async function calculateBulkSolar() {
		await runSolar(
			() =>
				backendClients.solar.bulkSolarPosition({
					timestampSeconds: parseJson<number[]>(bulkSolarTimestampsJson, 'Bulk solar timestamps'),
					latitudeDeg: solarLatitude,
					longitudeDeg: solarLongitude,
					utcOffsetHours: solarUtcOffset
				}),
			(result) => {
				bulkSolarResult = result;
			}
		);
	}
</script>

<div class="advanced-panel">
	<h4>Advanced Compute</h4>

	<div class="section">
		<h5>ML Inference And Lifecycle</h5>
		{#if mlError}
			<div class="error">{mlError}</div>
		{/if}
		<div class="grid two-col">
			<label>Task Type <input bind:value={mlTaskType} /></label>
			<label>Site ID <input bind:value={mlSiteId} /></label>
			<label>Temperature C <input type="number" bind:value={temperatureC} step="0.1" /></label>
			<label>Irradiance W/m2 <input type="number" bind:value={irradianceWM2} step="1" /></label>
			<label>Humidity % <input type="number" bind:value={humidityPercent} step="0.1" /></label>
			<label>Pressure mb <input type="number" bind:value={pressureMb} step="0.1" /></label>
			<label>Wind m/s <input type="number" bind:value={windSpeedMS} step="0.1" /></label>
			<label>Solar Altitude <input type="number" bind:value={solarAltitudeDeg} step="0.1" /></label>
			<label>Solar Azimuth <input type="number" bind:value={solarAzimuthDeg} step="0.1" /></label>
			<label>Air Mass <input type="number" bind:value={airMass} step="0.01" /></label>
			<label>Clearness Index <input type="number" bind:value={clearnessIndex} step="0.01" min="0" max="1" /></label>
			<label>Hour <input type="number" bind:value={hourOfDay} min="0" max="23" /></label>
			<label>Day Of Year <input type="number" bind:value={dayOfYear} min="1" max="366" /></label>
			<label>Month <input type="number" bind:value={month} min="1" max="12" /></label>
			<label class="checkbox"><input type="checkbox" bind:checked={isWeekend} /> Weekend</label>
			<label>Model Output <input type="number" bind:value={modelOutput} step="1" /></label>
			<label>Uncertainty <input type="number" bind:value={uncertaintyEstimate} step="1" /></label>
		</div>
		<div class="actions">
			<button on:click={extractFeatures} disabled={mlBusy}>Extract Features</button>
			<button class="secondary" on:click={predictYield} disabled={mlBusy || !extractedFeatures}>Predict Yield</button>
		</div>
		<div class="grid two-col mt8">
			<label>Expected Yield <input type="number" bind:value={expectedYield} step="1" /></label>
			<label>Actual Yield <input type="number" bind:value={actualYield} step="1" /></label>
			<label>Model Prediction <input type="number" bind:value={modelPrediction} step="1" /></label>
			<label>Sensor Variance <input type="number" bind:value={sensorVariance} step="0.1" /></label>
			<label>Current Degradation % <input type="number" bind:value={currentDegradation} step="0.1" /></label>
			<label>Annual Rate % <input type="number" bind:value={annualRate} step="0.01" /></label>
			<label>Forecast Years <input type="number" bind:value={degradationYears} step="1" min="1" /></label>
		</div>
		<div class="actions">
			<button class="secondary" on:click={detectAnomaly} disabled={mlBusy}>Detect Anomaly</button>
			<button class="secondary" on:click={forecastDegradation} disabled={mlBusy}>Forecast Degradation</button>
		</div>
		<div class="grid two-col mt8">
			<label>Prediction ID <input bind:value={feedbackPredictionId} /></label>
			<label>Actual Label <input type="number" bind:value={feedbackActualLabel} step="0.1" /></label>
			<label class="span-2">Feedback Notes <textarea rows="2" bind:value={feedbackNotes}></textarea></label>
		</div>
		<div class="actions">
			<button class="secondary" on:click={submitFeedback} disabled={mlBusy}>Submit Feedback</button>
		</div>
		<div class="grid two-col mt8">
			<label>Version <input bind:value={trainingVersion} /></label>
			<label>Trigger <input bind:value={trainingTriggeredBy} /></label>
			<label>Lookback Days <input type="number" bind:value={lookbackDays} min="1" /></label>
			<label>Min Samples/Site <input type="number" bind:value={minSamplesPerSite} min="1" /></label>
			<label>Train Split <input type="number" bind:value={trainSplitRatio} step="0.01" min="0" max="1" /></label>
			<label>Validation Split <input type="number" bind:value={validationSplitRatio} step="0.01" min="0" max="1" /></label>
			<label>Test Split <input type="number" bind:value={testSplitRatio} step="0.01" min="0" max="1" /></label>
			<label class="checkbox"><input type="checkbox" bind:checked={timeAwareSplit} /> Time-aware split</label>
			<label class="span-2">Commit Hash <input bind:value={trainingCommitHash} /></label>
			<label class="span-2">Hyperparameters <textarea rows="5" bind:value={hyperparametersJson}></textarea></label>
		</div>
		<div class="actions">
			<button on:click={startTraining} disabled={mlBusy}>Start Training</button>
			<button class="secondary" on:click={getTrainingStatus} disabled={mlBusy || !trainingRunId.trim()}>Get Training Status</button>
		</div>
		<div class="grid two-col mt8">
			<label>Run ID <input bind:value={trainingRunId} /></label>
			<label>Limit <input type="number" bind:value={versionsLimit} min="1" /></label>
			<label>Status Filter <input bind:value={statusFilter} placeholder="deployed" /></label>
		</div>
		<div class="actions">
			<button class="secondary" on:click={getModelVersions} disabled={mlBusy}>List Versions</button>
			<button class="secondary" on:click={getActiveModelVersion} disabled={mlBusy}>Get Active Version</button>
		</div>
		<div class="grid two-col mt8">
			<label>Candidate Version <input bind:value={candidateModelVersionId} /></label>
			<label>Baseline Version <input bind:value={versusModelId} /></label>
			<label>Min Improvement % <input type="number" bind:value={minImprovementPercent} step="0.1" /></label>
			<label>Canary % <input type="number" bind:value={canaryTrafficPercent} step="1" /></label>
			<label>Rollback Threshold Min <input type="number" bind:value={rollbackThresholdMinutes} step="1" /></label>
			<label class="checkbox"><input type="checkbox" bind:checked={requireManualApproval} /> Manual approval</label>
			<label>Approval ID <input bind:value={deploymentApprovalId} /></label>
			<label>Rollback Reason <input bind:value={rollbackReason} /></label>
			<label class="span-2">Deployment Notes <textarea rows="2" bind:value={deploymentNotes}></textarea></label>
			<label class="span-2">Alert Thresholds <textarea rows="3" bind:value={alertThresholdsJson}></textarea></label>
		</div>
		<div class="actions">
			<button class="secondary" on:click={evaluateModel} disabled={mlBusy || !candidateModelVersionId.trim()}>Evaluate Model</button>
			<button class="secondary" on:click={deployModelVersion} disabled={mlBusy || !candidateModelVersionId.trim()}>Deploy Version</button>
			<button class="danger" on:click={rollbackModelVersion} disabled={mlBusy}>Rollback Active Version</button>
		</div>
		<div class="result-grid">
			{#if extractedFeatures}<pre>{prettyJson(extractedFeatures)}</pre>{/if}
			{#if yieldPrediction}<pre>{prettyJson(yieldPrediction)}</pre>{/if}
			{#if anomalyDetection}<pre>{prettyJson(anomalyDetection)}</pre>{/if}
			{#if degradationForecast}<pre>{prettyJson(degradationForecast)}</pre>{/if}
			{#if feedbackResult}<pre>{prettyJson(feedbackResult)}</pre>{/if}
			{#if trainingResult}<pre>{prettyJson(trainingResult)}</pre>{/if}
			{#if trainingStatus}<pre>{prettyJson(trainingStatus)}</pre>{/if}
			{#if activeModelVersion}<pre>{prettyJson(activeModelVersion)}</pre>{/if}
			{#if modelEvaluation}<pre>{prettyJson(modelEvaluation)}</pre>{/if}
			{#if deploymentResult}<pre>{prettyJson(deploymentResult)}</pre>{/if}
			{#if rollbackResult}<pre>{prettyJson(rollbackResult)}</pre>{/if}
			{#if modelVersions.length > 0}<pre>{prettyJson(modelVersions)}</pre>{/if}
		</div>
		{#if activeModelVersion?.activeVersion || activeModelVersion?.previousVersion}
			<div class="meta-row">
				<span>Active created</span>
				<strong>{formatTimestamp(activeModelVersion?.activeVersion?.createdAt)}</strong>
			</div>
		{/if}
	</div>

	<div class="section">
		<h5>Optimization</h5>
		{#if optimizationError}
			<div class="error">{optimizationError}</div>
		{/if}
		<label>Pareto Objectives <textarea rows="5" bind:value={paretoObjectivesJson}></textarea></label>
		<label>Candidate Solution <textarea rows="4" bind:value={paretoSolutionJson}></textarea></label>
		<div class="actions">
			<button on:click={computeParetoFrontier} disabled={optimizationBusy}>Compute Pareto Frontier</button>
		</div>
		<div class="grid two-col mt8">
			<label>Samples <input type="number" bind:value={monteCarloSamples} min="10" /></label>
			<label>Seed <input type="number" bind:value={optimizationSeed} /></label>
		</div>
		<label>Monte Carlo Distributions <textarea rows="4" bind:value={monteCarloJson}></textarea></label>
		<div class="actions">
			<button class="secondary" on:click={runMonteCarloSampling} disabled={optimizationBusy}>Run Monte Carlo</button>
		</div>
		<label>Optimization Problem <textarea rows="10" bind:value={optimizationProblemJson}></textarea></label>
		<div class="grid three-col mt8">
			<label>GA Population <input type="number" bind:value={gaPopulationSize} min="2" /></label>
			<label>GA Generations <input type="number" bind:value={gaGenerations} min="1" /></label>
			<label>GA Elite Count <input type="number" bind:value={gaEliteCount} min="0" /></label>
			<label>Crossover <input type="number" bind:value={gaCrossoverRate} step="0.01" /></label>
			<label>Mutation <input type="number" bind:value={gaMutationRate} step="0.01" /></label>
			<label>SA Temp <input type="number" bind:value={saInitialTemperature} step="1" /></label>
			<label>SA Cooling <input type="number" bind:value={saCoolingRate} step="0.01" /></label>
			<label>SA Iterations <input type="number" bind:value={saIterations} min="1" /></label>
			<label>SA Perturbation <input type="number" bind:value={saPerturbationScale} step="0.1" /></label>
			<label>PSO Particles <input type="number" bind:value={psoParticles} min="1" /></label>
			<label>PSO Iterations <input type="number" bind:value={psoIterations} min="1" /></label>
			<label>PSO Inertia <input type="number" bind:value={psoW} step="0.01" /></label>
			<label>PSO c1 <input type="number" bind:value={psoC1} step="0.1" /></label>
			<label>PSO c2 <input type="number" bind:value={psoC2} step="0.1" /></label>
			<label>Boundary Min <input type="number" bind:value={psoBoundaryMin} step="0.1" /></label>
			<label>Boundary Max <input type="number" bind:value={psoBoundaryMax} step="0.1" /></label>
		</div>
		<div class="actions">
			<button class="secondary" on:click={runGeneticAlgorithm} disabled={optimizationBusy}>Genetic Algorithm</button>
			<button class="secondary" on:click={runSimulatedAnnealing} disabled={optimizationBusy}>Simulated Annealing</button>
			<button class="secondary" on:click={runParticleSwarmOptimization} disabled={optimizationBusy}>Particle Swarm</button>
		</div>
		<div class="result-grid">
			{#if paretoResult}<pre>{prettyJson(paretoResult)}</pre>{/if}
			{#if monteCarloResult}<pre>{prettyJson(monteCarloResult)}</pre>{/if}
			{#if gaResult}<pre>{prettyJson(gaResult)}</pre>{/if}
			{#if saResult}<pre>{prettyJson(saResult)}</pre>{/if}
			{#if psoResult}<pre>{prettyJson(psoResult)}</pre>{/if}
		</div>
	</div>

	<div class="section">
		<h5>Geo</h5>
		{#if geoError}
			<div class="error">{geoError}</div>
		{/if}
		<div class="grid two-col">
			<label>Buffer X <input type="number" bind:value={bufferCenterX} step="0.1" /></label>
			<label>Buffer Y <input type="number" bind:value={bufferCenterY} step="0.1" /></label>
			<label>Radius <input type="number" bind:value={bufferRadius} step="0.1" /></label>
			<label>Segments <input type="number" bind:value={bufferSegments} min="3" /></label>
		</div>
		<div class="actions">
			<button on:click={createBuffer} disabled={geoBusy}>Create Buffer Polygon</button>
		</div>
		<div class="grid two-col mt8">
			<label>Query X <input type="number" bind:value={nearestQueryX} step="0.1" /></label>
			<label>Query Y <input type="number" bind:value={nearestQueryY} step="0.1" /></label>
		</div>
		<label>Candidates <textarea rows="4" bind:value={geoCandidatesJson}></textarea></label>
		<div class="actions">
			<button class="secondary" on:click={findNearestPoint} disabled={geoBusy}>Find Nearest</button>
		</div>
		<div class="grid three-col mt8">
			<label>Width <input type="number" bind:value={contourWidth} min="1" /></label>
			<label>Height <input type="number" bind:value={contourHeight} min="1" /></label>
			<label>Resolution <input type="number" bind:value={contourResolution} step="0.1" /></label>
			<label>Origin X <input type="number" bind:value={contourOriginX} step="0.1" /></label>
			<label>Origin Y <input type="number" bind:value={contourOriginY} step="0.1" /></label>
			<label>Interval <input type="number" bind:value={contourInterval} step="0.1" /></label>
			<label>No Data <input type="number" bind:value={contourNoData} step="1" /></label>
		</div>
		<label>Grid Data <textarea rows="5" bind:value={contourDataJson}></textarea></label>
		<div class="actions">
			<button class="secondary" on:click={generateContours} disabled={geoBusy}>Generate Contours</button>
		</div>
		<div class="result-grid">
			{#if bufferResult}<pre>{prettyJson(bufferResult)}</pre>{/if}
			{#if nearestPointResult}<pre>{prettyJson(nearestPointResult)}</pre>{/if}
			{#if contourResult}<pre>{prettyJson(contourResult)}</pre>{/if}
		</div>
	</div>

	<div class="section">
		<h5>Graph</h5>
		{#if graphError}
			<div class="error">{graphError}</div>
		{/if}
		<div class="grid two-col">
			<label>Node Count <input type="number" bind:value={graphNodeCount} min="2" /></label>
		</div>
		<label>Edges <textarea rows="5" bind:value={graphEdgesJson}></textarea></label>
		<label>Terminals <textarea rows="3" bind:value={graphTerminalsJson}></textarea></label>
		<div class="actions">
			<button on:click={computeMst} disabled={graphBusy}>Minimum Spanning Tree</button>
			<button class="secondary" on:click={computeSteinerTree} disabled={graphBusy}>Approximate Steiner Tree</button>
		</div>
		<div class="result-grid">
			{#if mstResult}<pre>{prettyJson(mstResult)}</pre>{/if}
			{#if steinerResult}<pre>{prettyJson(steinerResult)}</pre>{/if}
		</div>
	</div>

	<div class="section">
		<h5>Solar Compute</h5>
		{#if solarError}
			<div class="error">{solarError}</div>
		{/if}
		<div class="grid two-col">
			<label>Timestamp Seconds <input type="number" bind:value={solarTimestampSeconds} step="1" /></label>
			<label>Latitude <input type="number" bind:value={solarLatitude} step="0.0001" /></label>
			<label>Longitude <input type="number" bind:value={solarLongitude} step="0.0001" /></label>
			<label>UTC Offset <input type="number" bind:value={solarUtcOffset} step="0.5" /></label>
			<label>Sun Elevation <input type="number" bind:value={solarSunElevation} step="0.1" /></label>
			<label>Sun Azimuth <input type="number" bind:value={solarSunAzimuth} step="0.1" /></label>
			<label>Exaggeration <input type="number" bind:value={solarExaggeration} step="0.1" /></label>
			<label>Turbidity <input type="number" bind:value={solarTurbidity} step="0.1" /></label>
			<label>Clearness Index <input type="number" bind:value={solarClearnessIndex} step="0.01" min="0" max="1" /></label>
		</div>
		<label>Obstacles <textarea rows="5" bind:value={solarObstaclesJson}></textarea></label>
		<label>Bulk Timestamps <textarea rows="3" bind:value={bulkSolarTimestampsJson}></textarea></label>
		<div class="actions">
			<button on:click={calculateSolarPosition} disabled={solarBusy}>Solar Position</button>
			<button class="secondary" on:click={castShadows} disabled={solarBusy}>Cast Shadows</button>
			<button class="secondary" on:click={calculateDni} disabled={solarBusy}>Calculate DNI</button>
			<button class="secondary" on:click={calculateDhi} disabled={solarBusy}>Calculate DHI</button>
			<button class="secondary" on:click={calculateBulkSolar} disabled={solarBusy}>Bulk Solar Position</button>
		</div>
		<div class="result-grid">
			{#if solarPositionResult}<pre>{prettyJson(solarPositionResult)}</pre>{/if}
			{#if castShadowsResult}<pre>{prettyJson(castShadowsResult)}</pre>{/if}
			{#if dniResult}<pre>{prettyJson(dniResult)}</pre>{/if}
			{#if dhiResult}<pre>{prettyJson(dhiResult)}</pre>{/if}
			{#if bulkSolarResult}<pre>{prettyJson(bulkSolarResult)}</pre>{/if}
		</div>
	</div>
</div>

<style>
	.advanced-panel {
		display: flex;
		flex-direction: column;
		gap: 12px;
	}

	h4 {
		margin: 0;
		font-size: 14px;
		font-weight: 600;
		color: #e2e8f0;
	}

	h5 {
		margin: 0 0 8px;
		font-size: 12px;
		font-weight: 600;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.section {
		display: flex;
		flex-direction: column;
		gap: 8px;
		padding: 10px;
		border: 1px solid rgba(255, 255, 255, 0.08);
		border-radius: 8px;
		background: rgba(15, 23, 42, 0.28);
	}

	.grid {
		display: grid;
		gap: 8px;
	}

	.two-col {
		grid-template-columns: repeat(2, minmax(0, 1fr));
	}

	.three-col {
		grid-template-columns: repeat(3, minmax(0, 1fr));
	}

	label {
		display: flex;
		flex-direction: column;
		gap: 4px;
		font-size: 11px;
		color: #cbd5e1;
	}

	label.checkbox {
		flex-direction: row;
		align-items: center;
		gap: 8px;
		padding-top: 18px;
	}

	input,
	textarea {
		padding: 6px 8px;
		border-radius: 6px;
		border: 1px solid rgba(255, 255, 255, 0.12);
		background: rgba(2, 6, 23, 0.55);
		color: #e2e8f0;
		font-size: 12px;
		font-family: inherit;
	}

	textarea {
		resize: vertical;
		min-height: 72px;
		font-family: 'Consolas', 'Courier New', monospace;
	}

	button {
		padding: 7px 10px;
		border-radius: 6px;
		border: 1px solid rgba(245, 158, 11, 0.35);
		background: rgba(245, 158, 11, 0.18);
		color: #fbbf24;
		font-size: 12px;
		font-weight: 600;
		cursor: pointer;
	}

	button.secondary {
		border-color: rgba(59, 130, 246, 0.35);
		background: rgba(59, 130, 246, 0.16);
		color: #93c5fd;
	}

	button.danger {
		border-color: rgba(239, 68, 68, 0.35);
		background: rgba(239, 68, 68, 0.16);
		color: #fca5a5;
	}

	button:disabled {
		opacity: 0.45;
		cursor: not-allowed;
	}

	.actions {
		display: flex;
		flex-wrap: wrap;
		gap: 8px;
	}

	.result-grid {
		display: grid;
		grid-template-columns: 1fr;
		gap: 8px;
	}

	pre {
		margin: 0;
		padding: 10px;
		border-radius: 6px;
		background: rgba(2, 6, 23, 0.75);
		border: 1px solid rgba(255, 255, 255, 0.08);
		color: #cbd5e1;
		font-size: 11px;
		overflow: auto;
	}

	.error {
		padding: 6px 8px;
		border-radius: 6px;
		background: rgba(239, 68, 68, 0.14);
		border: 1px solid rgba(239, 68, 68, 0.28);
		color: #fca5a5;
		font-size: 11px;
	}

	.meta-row {
		display: flex;
		justify-content: space-between;
		gap: 8px;
		font-size: 11px;
		color: #94a3b8;
	}

	.span-2 {
		grid-column: span 2;
	}

	.mt8 {
		margin-top: 8px;
	}

	@media (max-width: 900px) {
		.two-col,
		.three-col {
			grid-template-columns: 1fr;
		}

		.span-2 {
			grid-column: auto;
		}
	}
</style>