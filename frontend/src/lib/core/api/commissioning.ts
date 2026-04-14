import {
	CommissioningService,
	CommissioningStatus,
	ChecklistItemStatus,
	ChecklistSection,
	AsBuiltArtifactType,
	type CommissioningChecklist as ProtoChecklist,
	type ChecklistItem as ProtoItem,
	type CommissioningSignoff as ProtoSignoff,
	type HandoverRecord as ProtoHandover,
	type AsBuiltArtifact as ProtoArtifact
} from '$lib/gen/commissioning/v1/commissioning_pb.js';

import { createApiClient, timestampToIso } from './connect';

// ── Re-export enums so consumers don't need to import from gen directly ──────

export { CommissioningStatus, ChecklistItemStatus, ChecklistSection, AsBuiltArtifactType };

// ── Domain interfaces ────────────────────────────────────────────────────────

export interface Checklist {
	id: string;
	project_id: string;
	name: string;
	status: CommissioningStatus;
	items: ChecklistItem[];
	signoffs: Signoff[];
	created_at: string;
	updated_at: string;
	created_by: string;
	total_items: number;
	completed_items: number;
	failed_items: number;
}

export interface ChecklistItem {
	id: string;
	checklist_id: string;
	description: string;
	section: ChecklistSection;
	status: ChecklistItemStatus;
	required: boolean;
	completed_by: string;
	completed_at: string;
	notes: string;
	sequence: number;
}

export interface Signoff {
	id: string;
	checklist_id: string;
	signed_by: string;
	role: string;
	comments: string;
	signed_at: string;
}

export interface HandoverRecord {
	id: string;
	project_id: string;
	checklist_id: string;
	handed_over_by: string;
	received_by: string;
	notes: string;
	artifact_ids: string[];
	handover_date: string;
	created_at: string;
}

export interface AsBuiltArtifact {
	id: string;
	project_id: string;
	name: string;
	artifact_type: AsBuiltArtifactType;
	storage_url: string;
	uploaded_by: string;
	uploaded_at: string;
	description: string;
	file_size_bytes: bigint;
	revision: string;
}

// ── Mappers ──────────────────────────────────────────────────────────────────

function mapItem(item: ProtoItem): ChecklistItem {
	return {
		id: item.id,
		checklist_id: item.checklistId,
		description: item.description,
		section: item.section,
		status: item.status,
		required: item.required,
		completed_by: item.completedBy,
		completed_at: timestampToIso(item.completedAt),
		notes: item.notes,
		sequence: item.sequence
	};
}

function mapSignoff(s: ProtoSignoff): Signoff {
	return {
		id: s.id,
		checklist_id: s.checklistId,
		signed_by: s.signedBy,
		role: s.role,
		comments: s.comments,
		signed_at: timestampToIso(s.signedAt)
	};
}

function mapChecklist(cl: ProtoChecklist | undefined): Checklist {
	if (!cl) throw new Error('Checklist response was empty');
	return {
		id: cl.id,
		project_id: cl.projectId,
		name: cl.name,
		status: cl.status,
		items: cl.items.map(mapItem),
		signoffs: cl.signoffs.map(mapSignoff),
		created_at: timestampToIso(cl.createdAt),
		updated_at: timestampToIso(cl.updatedAt),
		created_by: cl.createdBy,
		total_items: cl.totalItems,
		completed_items: cl.completedItems,
		failed_items: cl.failedItems
	};
}

function mapHandover(h: ProtoHandover | undefined): HandoverRecord {
	if (!h) throw new Error('Handover response was empty');
	return {
		id: h.id,
		project_id: h.projectId,
		checklist_id: h.checklistId,
		handed_over_by: h.handedOverBy,
		received_by: h.receivedBy,
		notes: h.notes,
		artifact_ids: h.artifactIds,
		handover_date: timestampToIso(h.handoverDate),
		created_at: timestampToIso(h.createdAt)
	};
}

function mapArtifact(a: ProtoArtifact | undefined): AsBuiltArtifact {
	if (!a) throw new Error('AsBuilt artifact response was empty');
	return {
		id: a.id,
		project_id: a.projectId,
		name: a.name,
		artifact_type: a.artifactType,
		storage_url: a.storageUrl,
		uploaded_by: a.uploadedBy,
		uploaded_at: timestampToIso(a.uploadedAt),
		description: a.description,
		file_size_bytes: a.fileSizeBytes,
		revision: a.revision
	};
}

// ── API client ───────────────────────────────────────────────────────────────

const client = createApiClient(CommissioningService);

export const commissioningApi = {
	// Checklists
	createChecklist: async (input: { project_id: string; name: string; created_by: string }) => {
		const response = await client.createChecklist({
			projectId: input.project_id,
			name: input.name,
			createdBy: input.created_by
		});
		return { checklist: mapChecklist(response.checklist) };
	},

	getChecklist: async (checklistId: string) => {
		const response = await client.getChecklist({ checklistId });
		return { checklist: mapChecklist(response.checklist) };
	},

	listChecklists: async (projectId: string) => {
		const response = await client.listChecklists({ projectId });
		return { checklists: response.checklists.map(mapChecklist) };
	},

	// Items
	addChecklistItem: async (input: {
		checklist_id: string;
		description: string;
		section: ChecklistSection;
		required: boolean;
		sequence?: number;
	}) => {
		const response = await client.addChecklistItem({
			checklistId: input.checklist_id,
			description: input.description,
			section: input.section,
			required: input.required,
			sequence: input.sequence ?? 0
		});
		if (!response.item) throw new Error('Item response was empty');
		return { item: mapItem(response.item) };
	},

	updateChecklistItem: async (input: {
		item_id: string;
		status: ChecklistItemStatus;
		completed_by: string;
		notes?: string;
	}) => {
		const response = await client.updateChecklistItem({
			itemId: input.item_id,
			status: input.status,
			completedBy: input.completed_by,
			notes: input.notes ?? ''
		});
		if (!response.item) throw new Error('Item response was empty');
		return { item: mapItem(response.item) };
	},

	// Signoff
	signOffChecklist: async (input: {
		checklist_id: string;
		signed_by: string;
		role: string;
		comments?: string;
	}) => {
		const response = await client.signOffChecklist({
			checklistId: input.checklist_id,
			signedBy: input.signed_by,
			role: input.role,
			comments: input.comments ?? ''
		});
		return {
			signoff: response.signoff ? mapSignoff(response.signoff) : null,
			checklist: mapChecklist(response.updatedChecklist)
		};
	},

	listSignoffs: async (checklistId: string) => {
		const response = await client.listSignoffs({ checklistId });
		return { signoffs: response.signoffs.map(mapSignoff) };
	},

	// Handover
	createHandover: async (input: {
		project_id: string;
		checklist_id: string;
		handed_over_by: string;
		received_by: string;
		notes?: string;
		artifact_ids?: string[];
	}) => {
		const response = await client.createHandover({
			projectId: input.project_id,
			checklistId: input.checklist_id,
			handedOverBy: input.handed_over_by,
			receivedBy: input.received_by,
			notes: input.notes ?? '',
			artifactIds: input.artifact_ids ?? []
		});
		return { handover: mapHandover(response.handover) };
	},

	getHandover: async (handoverId: string) => {
		const response = await client.getHandover({ handoverId });
		return { handover: mapHandover(response.handover) };
	},

	// As-built artifacts
	recordAsBuilt: async (input: {
		project_id: string;
		name: string;
		artifact_type: AsBuiltArtifactType;
		storage_url: string;
		uploaded_by: string;
		description?: string;
		file_size_bytes?: bigint;
		revision?: string;
	}) => {
		const response = await client.recordAsBuilt({
			projectId: input.project_id,
			name: input.name,
			artifactType: input.artifact_type,
			storageUrl: input.storage_url,
			uploadedBy: input.uploaded_by,
			description: input.description ?? '',
			fileSizeBytes: input.file_size_bytes ?? 0n,
			revision: input.revision ?? ''
		});
		return { artifact: mapArtifact(response.artifact) };
	},

	listAsBuiltArtifacts: async (projectId: string) => {
		const response = await client.listAsBuiltArtifacts({ projectId });
		return { artifacts: response.artifacts.map(mapArtifact) };
	},

	// Report
	generateReport: async (checklistId: string) => {
		const response = await client.generateCommissioningReport({ checklistId });
		return {
			report_text: response.reportText,
			generated_at: timestampToIso(response.generatedAt)
		};
	}
};
