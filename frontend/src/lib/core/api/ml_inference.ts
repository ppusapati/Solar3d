import { MLInferenceService } from '$lib/gen/ml_inference/v1/ml_inference_pb.js';

import { createApiClient } from './connect';

const client = createApiClient(MLInferenceService);

export const mlInferenceApi = {
	extractFeatures: async (input: Parameters<typeof client.extractFeatures>[0]) => client.extractFeatures(input),
	predictYield: async (input: Parameters<typeof client.predictYield>[0]) => client.predictYield(input),
	detectAnomaly: async (input: Parameters<typeof client.detectAnomaly>[0]) => client.detectAnomaly(input),
	forecastDegradation: async (input: Parameters<typeof client.forecastDegradation>[0]) => client.forecastDegradation(input),
	submitFeedback: async (input: Parameters<typeof client.submitFeedback>[0]) => client.submitFeedback(input),
	startTraining: async (input: Parameters<typeof client.startTraining>[0]) => client.startTraining(input),
	getTrainingStatus: async (input: Parameters<typeof client.getTrainingStatus>[0]) => client.getTrainingStatus(input),
	getModelVersions: async (input: Parameters<typeof client.getModelVersions>[0]) => client.getModelVersions(input),
	getActiveModelVersion: async (input: Parameters<typeof client.getActiveModelVersion>[0]) => client.getActiveModelVersion(input),
	evaluateModel: async (input: Parameters<typeof client.evaluateModel>[0]) => client.evaluateModel(input),
	deployModelVersion: async (input: Parameters<typeof client.deployModelVersion>[0]) => client.deployModelVersion(input),
	rollbackModelVersion: async (input: Parameters<typeof client.rollbackModelVersion>[0]) => client.rollbackModelVersion(input)
};
