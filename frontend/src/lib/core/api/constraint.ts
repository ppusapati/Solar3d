// ConnectRPC client bindings for the ConstraintZoneService backend
// (services/compute-service/internal/handler/constraint.go).
//
// The backend handles CRUD over `constraint_zones` rows, geometry-based
// zone-by-location queries, and siting-conflict scoring used by the
// site-feasibility analyser.
import { createClient } from '@connectrpc/connect';
import { createConnectTransport } from '@connectrpc/connect-web';

import { API_BASE } from './client';
import {
	ConstraintZoneService,
	type Zone,
	type SitingConflict,
	type RiskScore,
	type CreateZoneRequest,
	type UpdateZoneRequest,
	type ListZonesRequest,
	type QueryZonesByLocationRequest,
	type CheckSitingConflictsRequest
} from '$lib/gen/constraint/v1/constraint_zones_pb.js';

const transport = createConnectTransport({ baseUrl: API_BASE });
const client = createClient(ConstraintZoneService, transport);

export type { Zone, SitingConflict, RiskScore };

export const constraintApi = {
	create: (req: Partial<CreateZoneRequest>) => client.createZone(req as CreateZoneRequest),
	update: (req: Partial<UpdateZoneRequest>) => client.updateZone(req as UpdateZoneRequest),
	delete: (zoneId: string, reason?: string) =>
		client.deleteZone({ zoneId, reason: reason ?? '' } as never),
	get: (zoneId: string) => client.getZone({ zoneId } as never),
	list: (req: Partial<ListZonesRequest>) => client.listZones(req as ListZonesRequest),
	queryByLocation: (req: Partial<QueryZonesByLocationRequest>) =>
		client.queryZonesByLocation(req as QueryZonesByLocationRequest),
	checkSitingConflicts: (req: Partial<CheckSitingConflictsRequest>) =>
		client.checkSitingConflicts(req as CheckSitingConflictsRequest),
	listCategories: () => client.listZoneCategories({} as never)
};
