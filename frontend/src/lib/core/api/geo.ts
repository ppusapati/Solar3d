import { backendClients } from './backend';

export const geoApi = {
	bufferPoint: async (input: Parameters<typeof backendClients.geo.bufferPoint>[0]) =>
		backendClients.geo.bufferPoint(input),
	nearestPoint: async (input: Parameters<typeof backendClients.geo.nearestPoint>[0]) =>
		backendClients.geo.nearestPoint(input),
	generateContours: async (input: Parameters<typeof backendClients.geo.generateContours>[0]) =>
		backendClients.geo.generateContours(input)
};
