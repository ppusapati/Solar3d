<script lang="ts">
	import { activeLayout, activeProject } from '$lib/core/stores';
	import { electricalApi } from '$lib/core/api';

	let networkSummary = {
		totalStrings: 0,
		totalInverters: 0,
		dcCapacity: 0,
		acCapacity: 0,
		dcAcRatio: 0,
		losses: {
			soiling: 2.0,
			shading: 1.5,
			mismatch: 1.0,
			wiring: 2.0,
			inverter: 1.5,
			transformer: 0.5,
			total: 8.2
		}
	};

	let networkId: string | null = null;

	// Load electrical network data from API when layout changes
	$: if ($activeLayout && $activeProject) {
		loadElectricalData($activeProject.id, $activeLayout);
	}

	async function loadElectricalData(projectId: string, layout: { total_panels: number; total_capacity_kw: number }) {
		try {
			const resp = await electricalApi.listNetworks(projectId);
			const networks = resp.networks || [];
			if (networks.length > 0) {
				const network = networks[0];
				networkId = network.id;
				networkSummary = {
					totalStrings: network.total_strings,
					totalInverters: network.total_inverters,
					dcCapacity: network.total_dc_capacity_kw,
					acCapacity: network.total_ac_capacity_kw,
					dcAcRatio: network.dc_ac_ratio,
					losses: networkSummary.losses
				};
				// Fetch losses from API
				try {
					const lossResp = await electricalApi.calculateLosses(network.id);
					if (lossResp.losses) {
						networkSummary.losses = {
							soiling: lossResp.losses.soiling_percent,
							shading: lossResp.losses.shading_percent,
							mismatch: lossResp.losses.mismatch_percent,
							wiring: lossResp.losses.wiring_percent,
							inverter: lossResp.losses.inverter_percent,
							transformer: lossResp.losses.transformer_percent,
							total: lossResp.losses.total_loss_percent
						};
					}
				} catch { /* use defaults if losses unavailable */ }
				return;
			}
		} catch { /* API unavailable, use computed defaults */ }

		// Fallback: derive from layout metadata
		const cap = layout.total_capacity_kw;
		networkSummary = {
			totalStrings: Math.ceil(layout.total_panels / 28),
			totalInverters: Math.ceil(cap / 500),
			dcCapacity: cap,
			acCapacity: cap * 0.85,
			dcAcRatio: cap > 0 ? cap / (cap * 0.85) : 0,
			losses: networkSummary.losses
		};
	}
</script>

<div class="elec-panel">
	<h4>Electrical Design</h4>

	{#if $activeLayout}
		<div class="section">
			<h5>Network Summary</h5>
			<div class="stat-grid">
				<div class="stat">
					<span class="stat-value">{networkSummary.totalStrings}</span>
					<span class="stat-label">Strings</span>
				</div>
				<div class="stat">
					<span class="stat-value">{networkSummary.totalInverters}</span>
					<span class="stat-label">Inverters</span>
				</div>
				<div class="stat">
					<span class="stat-value">{networkSummary.dcCapacity.toFixed(0)}</span>
					<span class="stat-label">DC kW</span>
				</div>
				<div class="stat">
					<span class="stat-value">{networkSummary.acCapacity.toFixed(0)}</span>
					<span class="stat-label">AC kW</span>
				</div>
			</div>
			<div class="ratio">
				DC/AC Ratio: <strong>{networkSummary.dcAcRatio.toFixed(2)}</strong>
			</div>
		</div>

		<div class="divider"></div>

		<div class="section">
			<h5>Loss Breakdown</h5>
			<div class="loss-list">
				{#each Object.entries(networkSummary.losses) as [key, value]}
					{#if key !== 'total'}
						<div class="loss-item">
							<span class="loss-label">{key.charAt(0).toUpperCase() + key.slice(1)}</span>
							<div class="loss-bar-container">
								<div class="loss-bar" style="width: {value * 10}%"></div>
							</div>
							<span class="loss-value">{value.toFixed(1)}%</span>
						</div>
					{/if}
				{/each}
				<div class="loss-total">
					<span>Total Loss</span>
					<span class="loss-total-value">{networkSummary.losses.total.toFixed(1)}%</span>
				</div>
			</div>
		</div>

		<div class="divider"></div>

		<div class="section">
			<button class="btn-auto">Auto-Generate Strings</button>
			<button class="btn-secondary">Optimize Cable Routes</button>
		</div>
	{:else}
		<p class="empty">Create a layout to configure electrical design.</p>
	{/if}
</div>

<style>
	.elec-panel {
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
		margin: 0 0 8px 0;
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
	}

	.divider {
		height: 1px;
		background: rgba(255, 255, 255, 0.1);
		margin: 4px 0;
	}

	.stat-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 8px;
	}

	.stat {
		display: flex;
		flex-direction: column;
		padding: 8px;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.08);
	}

	.stat-value {
		font-size: 18px;
		font-weight: 700;
		color: #3b82f6;
	}

	.stat-label {
		font-size: 10px;
		color: #94a3b8;
	}

	.ratio {
		font-size: 12px;
		color: #94a3b8;
		text-align: center;
	}

	.ratio strong {
		color: #f59e0b;
	}

	.loss-list {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	.loss-item {
		display: flex;
		align-items: center;
		gap: 8px;
		font-size: 12px;
	}

	.loss-label {
		width: 80px;
		color: #94a3b8;
		flex-shrink: 0;
	}

	.loss-bar-container {
		flex: 1;
		height: 6px;
		background: rgba(255, 255, 255, 0.08);
		border-radius: 3px;
		overflow: hidden;
	}

	.loss-bar {
		height: 100%;
		background: linear-gradient(90deg, #f59e0b, #ef4444);
		border-radius: 3px;
	}

	.loss-value {
		width: 40px;
		text-align: right;
		color: #e2e8f0;
		font-weight: 500;
	}

	.loss-total {
		display: flex;
		justify-content: space-between;
		padding-top: 6px;
		border-top: 1px solid rgba(255, 255, 255, 0.1);
		font-size: 12px;
		font-weight: 600;
		color: #e2e8f0;
	}

	.loss-total-value {
		color: #ef4444;
	}

	.btn-auto {
		padding: 8px;
		border: none;
		border-radius: 6px;
		background: linear-gradient(135deg, #3b82f6, #2563eb);
		color: white;
		font-size: 13px;
		font-weight: 600;
		cursor: pointer;
	}

	.btn-secondary {
		padding: 8px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 6px;
		background: transparent;
		color: #94a3b8;
		font-size: 13px;
		cursor: pointer;
	}

	.btn-auto:hover,
	.btn-secondary:hover {
		filter: brightness(1.1);
	}

	.empty {
		color: #64748b;
		font-size: 13px;
		text-align: center;
		padding: 24px 0;
	}
</style>
