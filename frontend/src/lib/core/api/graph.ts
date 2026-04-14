import { backendClients } from './backend';

export const graphApi = {
	minimumSpanningTree: async (input: Parameters<typeof backendClients.graph.minimumSpanningTree>[0]) =>
		backendClients.graph.minimumSpanningTree(input),
	approximateSteinerTree: async (input: Parameters<typeof backendClients.graph.approximateSteinerTree>[0]) =>
		backendClients.graph.approximateSteinerTree(input)
};
