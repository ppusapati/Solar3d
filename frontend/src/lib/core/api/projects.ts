import { createClient } from '@connectrpc/connect';
import { createConnectTransport } from '@connectrpc/connect-web';
import type { Timestamp } from '@bufbuild/protobuf/wkt';
import { timestampDate } from '@bufbuild/protobuf/wkt';

import { api } from './client';
import { API_BASE } from './client';
import {
	ProjectService,
	ProjectStatus as ProtoProjectStatus,
	type Project as ProtoProject,
	type Site as ProtoSite
} from '$lib/gen/project/v1/project_pb.js';

export interface Project {
	id: string;
	name: string;
	description: string;
	status: string;
	target_capacity_mw: number;
	location_name: string;
	client_name: string;
	notes: string;
	initial_latitude: number;
	initial_longitude: number;
	created_at: string;
	updated_at: string;
}

export interface Site {
	id: string;
	project_id: string;
	name: string;
	boundary_geojson: string;
	area_sqm: number;
	latitude: number;
	longitude: number;
	timezone: string;
	created_at: string;
}

export interface ConstraintZone {
	id: string;
	site_id: string;
	name: string;
	zone_type: string;
	boundary_geojson: string;
	area_sqm: number;
	severity_level: number;
	notes?: string;
	source?: string;
	created_at: string;
	updated_at?: string;
}

export interface CadParseFeature {
	type: 'Feature';
	geometry: {
		type: string;
		coordinates: number[][] | number[][][];
	};
	properties: {
		layer?: string;
		name?: string;
		entity_type?: string;
		closed?: boolean;
	};
}

export interface CadParseResponse {
	source_format: 'kml' | 'dxf';
	source_crs: string;
	layers: string[];
	feature_collection: {
		type: 'FeatureCollection';
		features: CadParseFeature[];
	};
}

type ApiErrorPayload = {
	error?: string;
	message?: string;
	reason?: string;
	suggested_action?: string;
	dwg_version?: string;
};

export interface CreateProjectRequest {
	name: string;
	description?: string;
	target_capacity_mw?: number;
	location_name?: string;
	client_name?: string;
	notes?: string;
	initial_latitude?: number;
	initial_longitude?: number;
}

export interface CreateSiteRequest {
	project_id: string;
	name: string;
	boundary_geojson: string;
	area_sqm?: number;
	latitude?: number;
	longitude?: number;
	timezone?: string;
}

const transport = createConnectTransport({
	baseUrl: API_BASE
});

const client = createClient(ProjectService, transport);

async function readErrorMessage(response: Response, fallback: string): Promise<string> {
	const contentType = response.headers.get('content-type') ?? '';
	if (contentType.includes('application/json')) {
		const payload = (await response.json()) as ApiErrorPayload;
		const parts = [payload.error ?? payload.message ?? fallback];
		if (payload.reason && payload.reason !== parts[0]) {
			parts.push(payload.reason);
		}
		if (payload.dwg_version) {
			parts.push(`Detected version: ${payload.dwg_version}`);
		}
		if (payload.suggested_action) {
			parts.push(payload.suggested_action);
		}
		return parts.filter(Boolean).join(' ');
	}

	const text = await response.text();
	return text || fallback;
}

function timestampToIso(timestamp?: Timestamp): string {
	return timestamp ? timestampDate(timestamp).toISOString() : '';
}

function statusFromProto(status: ProtoProjectStatus): string {
	switch (status) {
		case ProtoProjectStatus.DRAFT:
			return 'draft';
		case ProtoProjectStatus.DESIGN:
			return 'design';
		case ProtoProjectStatus.SIMULATION:
			return 'simulation';
		case ProtoProjectStatus.REVIEW:
			return 'review';
		case ProtoProjectStatus.APPROVED:
			return 'approved';
		case ProtoProjectStatus.ARCHIVED:
			return 'archived';
		default:
			return 'draft';
	}
}

function statusToProto(status?: string): ProtoProjectStatus {
	switch (status) {
		case 'draft':
			return ProtoProjectStatus.DRAFT;
		case 'design':
			return ProtoProjectStatus.DESIGN;
		case 'simulation':
			return ProtoProjectStatus.SIMULATION;
		case 'review':
			return ProtoProjectStatus.REVIEW;
		case 'approved':
			return ProtoProjectStatus.APPROVED;
		case 'archived':
			return ProtoProjectStatus.ARCHIVED;
		default:
			return ProtoProjectStatus.UNSPECIFIED;
	}
}

function mapProject(project?: ProtoProject): Project {
	if (!project) {
		throw new Error('Project response was empty');
	}

	return {
		id: project.id,
		name: project.name,
		description: project.description,
		status: statusFromProto(project.status),
		target_capacity_mw: project.metadata?.targetCapacityMw ?? 0,
		location_name: project.metadata?.locationName ?? '',
		client_name: project.metadata?.clientName ?? '',
		notes: project.metadata?.notes ?? '',
		initial_latitude: project.site?.latitude ?? 0,
		initial_longitude: project.site?.longitude ?? 0,
		created_at: timestampToIso(project.createdAt),
		updated_at: timestampToIso(project.updatedAt)
	};
}

function mapSite(site?: ProtoSite): Site | null {
	if (!site) {
		return null;
	}

	return {
		id: site.id,
		project_id: site.projectId,
		name: site.name,
		boundary_geojson: site.boundaryGeojson,
		area_sqm: site.areaSqm,
		latitude: site.latitude,
		longitude: site.longitude,
		timezone: site.timezone,
		created_at: timestampToIso(site.createdAt)
	};
}

function metadataFromCreate(req: CreateProjectRequest) {
	if (
		req.target_capacity_mw === undefined &&
		req.location_name === undefined &&
		req.client_name === undefined &&
		req.notes === undefined
	) {
		return undefined;
	}

	return {
		targetCapacityMw: req.target_capacity_mw ?? 0,
		locationName: req.location_name ?? '',
		clientName: req.client_name ?? '',
		notes: req.notes ?? ''
	};
}

function metadataFromUpdate(data: Partial<Project>) {
	if (
		data.target_capacity_mw === undefined &&
		data.location_name === undefined &&
		data.client_name === undefined &&
		data.notes === undefined
	) {
		return undefined;
	}

	return {
		targetCapacityMw: data.target_capacity_mw ?? 0,
		locationName: data.location_name ?? '',
		clientName: data.client_name ?? '',
		notes: data.notes ?? ''
	};
}

export const projectsApi = {
	create: async (req: CreateProjectRequest) => {
		const response = await client.createProject({
			name: req.name,
			description: req.description ?? '',
			metadata: metadataFromCreate(req)
		});
		return { project: mapProject(response.project) };
	},

	get: async (id: string) => {
		const response = await client.getProject({ id });
		return { project: mapProject(response.project), site: mapSite(response.project?.site) };
	},

	list: async (pageSize = 20, pageToken = '') => {
		const response = await client.listProjects({
			pageSize,
			pageToken,
			statusFilter: ProtoProjectStatus.UNSPECIFIED
		});
		return {
			projects: (response.projects ?? []).map((project) => mapProject(project)),
			next_page_token: response.nextPageToken ?? '',
			total_count: response.totalCount ?? 0
		};
	},

	update: async (id: string, data: Partial<Project>) => {
		const existing = await client.getProject({ id });
		const base = mapProject(existing.project);

		const response = await client.updateProject({
			id,
			name: data.name ?? base.name,
			description: data.description ?? base.description,
			status: statusToProto(data.status ?? base.status),
			metadata: metadataFromUpdate({
				target_capacity_mw: data.target_capacity_mw ?? base.target_capacity_mw,
				location_name: data.location_name ?? base.location_name,
				client_name: data.client_name ?? base.client_name,
				notes: data.notes ?? base.notes
			})
		});
		return { project: mapProject(response.project) };
	},

	delete: async (id: string) => {
		await client.deleteProject({ id });
		return {};
	},

	createSite: async (req: CreateSiteRequest) => {
		const site = await api.post<Site>('/solar.project.v1.ProjectService/CreateSite', req);
		return { site };
	},

	getSiteByProjectId: async (projectId: string) => {
		const site = await api.post<Site>('/solar.project.v1.ProjectService/GetSiteByProjectID', { id: projectId });
		return { site };
	},

	importSiteBoundary: async (projectId: string, file: File, options?: { name?: string; timezone?: string }) => {
		const form = new FormData();
		form.append('file', file);
		if (options?.name) {
			form.append('name', options.name);
		}
		if (options?.timezone) {
			form.append('timezone', options.timezone);
		}

		const response = await fetch(`${API_BASE}/api/v1/projects/${projectId}/site/import-boundary`, {
			method: 'POST',
			body: form
		});
		if (!response.ok) {
			throw new Error(await readErrorMessage(response, `Boundary import failed (${response.status})`));
		}

		const site = (await response.json()) as Site;
		return { site };
	},

	parseCadFile: async (file: File) => {
		const form = new FormData();
		form.append('file', file);

		const response = await fetch(`${API_BASE}/api/v1/cad/parse`, {
			method: 'POST',
			body: form
		});
		if (!response.ok) {
			throw new Error(await readErrorMessage(response, `CAD parse failed (${response.status})`));
		}

		return (await response.json()) as CadParseResponse;
	},

	importConstraintZones: async (projectId: string, file: File) => {
		const form = new FormData();
		form.append('file', file);

		const response = await fetch(`${API_BASE}/api/v1/projects/${projectId}/zones/import`, {
			method: 'POST',
			body: form
		});
		if (!response.ok) {
			throw new Error(await readErrorMessage(response, `Constraint zone import failed (${response.status})`));
		}

		const payload = (await response.json()) as { zones?: ConstraintZone[]; count?: number };
		return {
			zones: payload.zones ?? [],
			count: payload.count ?? payload.zones?.length ?? 0
		};
	},

	getConstraintZonesByProjectId: async (projectId: string) => {
		const response = await fetch(`${API_BASE}/api/v1/projects/${projectId}/zones`, {
			method: 'GET'
		});
		if (!response.ok) {
			throw new Error(await readErrorMessage(response, `Failed to load constraint zones (${response.status})`));
		}
		const payload = (await response.json()) as { zones?: ConstraintZone[]; count?: number };
		return {
			zones: payload.zones ?? [],
			count: payload.count ?? payload.zones?.length ?? 0
		};
	}
};
