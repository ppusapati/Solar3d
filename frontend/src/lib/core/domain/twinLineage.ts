import type { AsBuiltArtifact } from '$lib/core/api/commissioning';
import type { AssetIdentity, TelemetryReadingInput } from '$lib/core/api/twin';
import type { WorkflowTransitionRecord } from '$lib/core/api/workflow';

export interface LineageHop {
	stage: string;
	detail: string;
	timestamp: string;
}

export function buildTwinLineageTrail(input: {
	telemetry: TelemetryReadingInput | null;
	identities: AssetIdentity[];
	artifacts: AsBuiltArtifact[];
	workflowTransitions: WorkflowTransitionRecord[];
}): LineageHop[] {
	const hops: LineageHop[] = [];
	const commissioningTransition = [...input.workflowTransitions]
		.filter((transition) => transition.to_phase === 'COMMISSIONING_READY' || transition.to_phase === 'APPROVED')
		.sort((a, b) => Date.parse(b.occurred_at || '') - Date.parse(a.occurred_at || ''))[0];

	if (commissioningTransition) {
		hops.push({
			stage: 'Workflow',
			detail: `${commissioningTransition.from_phase} -> ${commissioningTransition.to_phase} by ${commissioningTransition.actor_id || 'system'}`,
			timestamp: commissioningTransition.occurred_at
		});
	}

	if (!input.telemetry) {
		return hops;
	}

	hops.push({
		stage: 'Operational Event',
		detail: `${input.telemetry.metric}=${input.telemetry.value} ${input.telemetry.unit} from ${input.telemetry.sensor_id}`,
		timestamp: input.telemetry.recorded_at
	});

	const identity = input.identities.find((item) => item.id === input.telemetry?.asset_identity_id);
	if (identity) {
		hops.push({
			stage: 'Asset Identity',
			detail: `${identity.design_asset_type} mapped to serial ${identity.physical_serial_number}`,
			timestamp: identity.updated_at || identity.created_at
		});

		const artifact = input.artifacts.find((item) => item.id === identity.design_asset_id);
		if (artifact) {
			hops.push({
				stage: 'Design Revision',
				detail: `${artifact.name} (${artifact.revision || 'rev-na'})`,
				timestamp: artifact.uploaded_at
			});
		}
	}

	return hops;
}
