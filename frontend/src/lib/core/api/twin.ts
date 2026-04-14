import { api } from './client';

export type TwinStatus = 'PROVISIONING' | 'ACTIVE' | 'SUSPENDED' | 'DECOMMISSIONED';

export interface OperationalState {
	power_output_kw: number;
	availability_pct: number;
	active_fault_count: number;
	health_score: number;
}

export interface DigitalTwin {
	id: string;
	project_id: string;
	layout_id?: string;
	electrical_network_id?: string;
	transmission_route_id?: string;
	status: TwinStatus;
	operational: OperationalState;
	created_at: string;
	updated_at: string;
}

export interface AssetIdentity {
	id: string;
	twin_id: string;
	design_asset_id: string;
	design_asset_type: string;
	physical_serial_number: string;
	commissioning_ref: string;
	created_at: string;
	updated_at: string;
}

export interface TelemetryReadingInput {
	sensor_id: string;
	asset_identity_id?: string;
	metric: string;
	value: number;
	unit: string;
	quality?: string;
	recorded_at: string;
}

interface IngestTelemetryResponse {
	ingested: number;
}

export const twinApi = {
	provisionTwin: async (input: {
		project_id: string;
		layout_id?: string;
		electrical_network_id?: string;
		transmission_route_id?: string;
	}) => api.post<DigitalTwin>('/api/v1/twins', input),

	getTwinState: async (twinId: string) => api.get<DigitalTwin>(`/api/v1/twins/${twinId}`),

	linkAssetIdentity: async (
		twinId: string,
		input: {
			design_asset_id: string;
			design_asset_type: string;
			physical_serial_number: string;
			commissioning_ref?: string;
		}
	) => api.post<AssetIdentity>(`/api/v1/twins/${twinId}/asset-identities`, input),

	ingestTelemetry: async (twinId: string, readings: TelemetryReadingInput[]) =>
		api.post<IngestTelemetryResponse>(`/api/v1/twins/${twinId}/telemetry`, { readings })
};
