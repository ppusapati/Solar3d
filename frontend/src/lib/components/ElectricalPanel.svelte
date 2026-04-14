<script lang="ts">
	import { activeLayout, activeProject } from '$lib/core/stores';
	import { backendClients, electricalApi } from '$lib/core/api';
	import PanelStringsVisualization from './PanelStringsVisualization.svelte';
	import type { Asset } from '$lib/gen/asset/v1/asset_pb.js';
	import { AssetCategory } from '$lib/gen/asset/v1/asset_pb.js';
	import type {
		ElectricalNetwork,
		InverterGroup,
		PanelString,
		ValidateSizingResult,
		ValidateNetworkResult,
		NetworkBOMResult
	} from '$lib/core/api/electrical';

	type LossState = {
		soiling: number;
		shading: number;
		mismatch: number;
		wiring: number;
		inverter: number;
		transformer: number;
		total: number;
	};

	function defaultLosses(): LossState {
		return {
			soiling: 2.0,
			shading: 1.5,
			mismatch: 1.0,
			wiring: 2.0,
			inverter: 1.5,
			transformer: 0.5,
			total: 8.2
		};
	}

	let networkSummary = {
		totalStrings: 0,
		totalInverters: 0,
		dcCapacity: 0,
		acCapacity: 0,
		dcAcRatio: 0,
		losses: defaultLosses()
	};

	let networks: ElectricalNetwork[] = [];
	let strings: PanelString[] = [];
	let inverterGroups: InverterGroup[] = [];
	let inverterAssets: Asset[] = [];
	let networkId: string | null = null;
	let networkName = 'Primary Network';
	let panelsPerString = 28;
	let stringsPerInverter = 2;
	let panelVoltage = 42;
	let panelCurrent = 13;
	let manualPanelIds = '';
	let selectedStringIds: string[] = [];
	let selectedInverterAssetId = '';
	let inverterPositionGeojson = '';
	let loading = false;
	let creatingNetwork = false;
	let autoGenerating = false;
	let creatingString = false;
	let assigningInverter = false;
	let deletingNetwork = false;
	let validatingSizing = false;
	let validatingNetwork = false;
	let generatingBom = false;
	let errorMsg = '';
	let statusMsg = '';
	let loadedLayoutKey = '';
	let sizingResult: ValidateSizingResult | null = null;
	let networkValidationResult: ValidateNetworkResult | null = null;
	let networkBomResult: NetworkBOMResult | null = null;
	let inverterMpptCount = 12;
	let maxStringsPerMppt = 2;
	let panelUnitCost = 85;
	let inverterUnitCost = 12000;
	let cableCostPerM = 4.5;
	let mountingCostPerPanel = 18;
	let currencyCode = 'USD';
	let panelVoc = 51.2;
	let panelVmp = 42;
	let panelIsc = 13.8;
	let panelImp = 13;
	let inverterVdcMax = 1500;
	let inverterVmpptMin = 850;
	let inverterVmpptMax = 1300;
	let inverterIdcMax = 32;
	let inverterAcKw = 300;
	let dcAcRatioMin = 1.1;
	let dcAcRatioMax = 1.5;
	let tempCoeffVoc = -0.29;
	let lowestExpectedTemp = -10;
	let highestExpectedTemp = 45;

	function setFallbackSummary(layout: { total_panels: number; total_capacity_kw: number }) {
		const cap = layout.total_capacity_kw;
		networkSummary = {
			totalStrings: Math.ceil(layout.total_panels / Math.max(1, panelsPerString)),
			totalInverters: Math.ceil(cap / 500),
			dcCapacity: cap,
			acCapacity: cap * 0.85,
			dcAcRatio: cap > 0 ? cap / (cap * 0.85) : 0,
			losses: defaultLosses()
		};
		strings = [];
		inverterGroups = [];
	}

	async function loadInverterAssets() {
		const [stringResp, centralResp] = await Promise.all([
			backendClients.asset.listAssets({ categoryFilter: AssetCategory.STRING_INVERTER, pageSize: 50 }),
			backendClients.asset.listAssets({ categoryFilter: AssetCategory.CENTRAL_INVERTER, pageSize: 50 })
		]);
		inverterAssets = [...stringResp.assets, ...centralResp.assets];
		if (!selectedInverterAssetId && inverterAssets[0]) {
			selectedInverterAssetId = inverterAssets[0].id;
		}
	}

	async function refreshNetwork(network: ElectricalNetwork) {
		const [dc, ac, losses, listedStrings, groups] = await Promise.all([
			electricalApi.calculateDCCapacity(network.id),
			electricalApi.calculateACCapacity(network.id),
			electricalApi.calculateLosses(network.id),
			electricalApi.listStrings(network.id),
			electricalApi.listInverterGroups(network.id)
		]);

		networkSummary = {
			totalStrings: dc.total_strings || network.total_strings,
			totalInverters: ac.total_inverters || network.total_inverters,
			dcCapacity: dc.total_dc_kw || network.total_dc_capacity_kw,
			acCapacity: ac.total_ac_kw || network.total_ac_capacity_kw,
			dcAcRatio: ac.dc_ac_ratio || network.dc_ac_ratio,
			losses: {
				soiling: losses.losses.soiling_percent,
				shading: losses.losses.shading_percent,
				mismatch: losses.losses.mismatch_percent,
				wiring: losses.losses.wiring_percent,
				inverter: losses.losses.inverter_percent,
				transformer: losses.losses.transformer_percent,
				total: losses.losses.total_loss_percent
			}
		};
		strings = listedStrings.strings;
		inverterGroups = groups.inverter_groups;
		selectedStringIds = selectedStringIds.filter((id) => strings.some((entry) => entry.id === id));
	}

	async function loadElectricalData(projectId: string, layout: { id: string; total_panels: number; total_capacity_kw: number }) {
		loading = true;
		errorMsg = '';
		statusMsg = '';
		try {
			await loadInverterAssets();
			const resp = await electricalApi.listNetworks(projectId);
			networks = resp.networks || [];
			const network = networks.find((entry) => entry.layout_id === layout.id) ?? networks[0] ?? null;
			if (!network) {
				networkId = null;
				setFallbackSummary(layout);
				return;
			}

			networkId = network.id;
			networkName = network.name;
			await refreshNetwork(network);
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to load electrical data';
			setFallbackSummary(layout);
		} finally {
			loading = false;
		}
	}

	async function createNetwork() {
		if (!$activeProject || !$activeLayout) return;
		creatingNetwork = true;
		errorMsg = '';
		statusMsg = '';
		try {
			const response = await electricalApi.createNetwork({
				project_id: $activeProject.id,
				layout_id: $activeLayout.id,
				name: networkName.trim() || 'Primary Network'
			});
			networkId = response.network.id;
			statusMsg = 'Electrical network created.';
			await loadElectricalData($activeProject.id, $activeLayout);
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to create electrical network';
		} finally {
			creatingNetwork = false;
		}
	}

	async function autoGenerate() {
		if (!networkId || !$activeLayout) return;
		autoGenerating = true;
		errorMsg = '';
		statusMsg = '';
		try {
			await electricalApi.autoGenerateStrings(networkId, {
				layout_id: $activeLayout.id,
				total_panels: $activeLayout.total_panels,
				panels_per_string: panelsPerString,
				strings_per_inverter: stringsPerInverter,
				panel_vmp: panelVoltage,
				panel_imp: panelCurrent,
				inverter_asset_id: selectedInverterAssetId
			});
			statusMsg = 'Auto-generated strings and updated network capacity.';
			const network = networks.find((entry) => entry.id === networkId);
			if (network) {
				await refreshNetwork(network);
			}
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to auto-generate strings';
		} finally {
			autoGenerating = false;
		}
	}

	async function createManualString() {
		if (!networkId) return;
		const panelIds = manualPanelIds
			.split(/[\s,]+/)
			.map((value) => value.trim())
			.filter(Boolean);
		if (panelIds.length === 0) {
			errorMsg = 'Enter one or more panel IDs to create a string.';
			return;
		}

		creatingString = true;
		errorMsg = '';
		statusMsg = '';
		try {
			await electricalApi.createString(networkId, {
				panel_ids: panelIds,
				panel_voltage: panelVoltage,
				panel_current: panelCurrent
			});
			manualPanelIds = '';
			statusMsg = 'Manual string created.';
			const network = networks.find((entry) => entry.id === networkId);
			if (network) {
				await refreshNetwork(network);
			}
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to create string';
		} finally {
			creatingString = false;
		}
	}

	function toggleStringSelection(id: string) {
		selectedStringIds = selectedStringIds.includes(id)
			? selectedStringIds.filter((value) => value !== id)
			: [...selectedStringIds, id];
	}

	async function assignSelectedStrings() {
		if (!networkId || !selectedInverterAssetId || selectedStringIds.length === 0) return;
		assigningInverter = true;
		errorMsg = '';
		statusMsg = '';
		try {
			await electricalApi.assignInverter(networkId, {
				inverter_asset_id: selectedInverterAssetId,
				string_ids: selectedStringIds,
				position_geojson: inverterPositionGeojson
			});
			selectedStringIds = [];
			statusMsg = 'Assigned selected strings to inverter group.';
			const network = networks.find((entry) => entry.id === networkId);
			if (network) {
				await refreshNetwork(network);
			}
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to assign inverter';
		} finally {
			assigningInverter = false;
		}
	}

	async function deleteNetwork() {
		if (!networkId || !$activeLayout) return;
		deletingNetwork = true;
		errorMsg = '';
		statusMsg = '';
		try {
			await electricalApi.delete(networkId);
			networkId = null;
			statusMsg = 'Electrical network deleted.';
			setFallbackSummary($activeLayout);
			await loadElectricalData($activeProject?.id ?? '', $activeLayout);
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to delete network';
		} finally {
			deletingNetwork = false;
		}
	}

	async function refreshActiveElectricalData() {
		if (!$activeProject || !$activeLayout) return;
		await loadElectricalData($activeProject.id, $activeLayout);
	}

	async function validateSizing() {
		if (!networkId) {
			errorMsg = 'Create or select a network before validating sizing.';
			return;
		}

		validatingSizing = true;
		errorMsg = '';
		statusMsg = '';
		try {
			sizingResult = await electricalApi.validateSizing({
				network_id: networkId,
				panel_voc_v: panelVoc,
				panel_vmp_v: panelVmp,
				panel_isc_a: panelIsc,
				panel_imp_a: panelImp,
				panels_per_string: panelsPerString,
				inverter_vdc_max_v: inverterVdcMax,
				inverter_vmppt_min_v: inverterVmpptMin,
				inverter_vmppt_max_v: inverterVmpptMax,
				inverter_idc_max_a: inverterIdcMax,
				inverter_ac_kw: inverterAcKw,
				dc_ac_ratio_min: dcAcRatioMin,
				dc_ac_ratio_max: dcAcRatioMax,
				temp_coeff_voc_pct_per_c: tempCoeffVoc,
				lowest_expected_temp_c: lowestExpectedTemp,
				highest_expected_temp_c: highestExpectedTemp
			});
			statusMsg = sizingResult.valid
				? 'Sizing validation passed.'
				: `Sizing validation found ${sizingResult.violations.length} issue${sizingResult.violations.length === 1 ? '' : 's'}.`;
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to validate sizing';
		} finally {
			validatingSizing = false;
		}
	}

	async function validateNetworkConsistency() {
		if (!networkId) {
			errorMsg = 'Create or select a network before validating topology.';
			return;
		}

		validatingNetwork = true;
		errorMsg = '';
		statusMsg = '';
		try {
			networkValidationResult = await electricalApi.validateNetwork({
				network_id: networkId,
				inverter_mppt_count: inverterMpptCount,
				max_strings_per_mppt: maxStringsPerMppt
			});
			statusMsg = networkValidationResult.valid
				? 'Network topology validation passed.'
				: `Network topology validation found ${networkValidationResult.issues.length} issue${networkValidationResult.issues.length === 1 ? '' : 's'}.`;
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to validate network topology';
		} finally {
			validatingNetwork = false;
		}
	}

	async function generateNetworkBom() {
		if (!networkId) {
			errorMsg = 'Create or select a network before generating BOM.';
			return;
		}

		generatingBom = true;
		errorMsg = '';
		statusMsg = '';
		try {
			networkBomResult = await electricalApi.generateNetworkBOM({
				network_id: networkId,
				panel_unit_cost: panelUnitCost,
				inverter_unit_cost: inverterUnitCost,
				cable_cost_per_m: cableCostPerM,
				mounting_cost_per_panel: mountingCostPerPanel,
				currency_code: currencyCode
			});
			statusMsg = `Generated network BOM with ${networkBomResult.items.length} line item${networkBomResult.items.length === 1 ? '' : 's'}.`;
		} catch (err) {
			errorMsg = err instanceof Error ? err.message : 'Failed to generate network BOM';
		} finally {
			generatingBom = false;
		}
	}

	$: {
		const nextKey = `${$activeProject?.id ?? ''}:${$activeLayout?.id ?? ''}`;
		if ($activeProject?.id && $activeLayout?.id && nextKey !== loadedLayoutKey) {
			loadedLayoutKey = nextKey;
			void loadElectricalData($activeProject.id, $activeLayout);
		}
	}
</script>

<div class="elec-panel">
	<h4>Electrical Design</h4>

	{#if !$activeLayout}
		<p class="empty">Create a layout to configure electrical design.</p>
	{:else}
		{#if errorMsg}
			<p class="error">{errorMsg}</p>
		{/if}
		{#if statusMsg}
			<p class="status">{statusMsg}</p>
		{/if}

		<div class="section">
			<h5>Network</h5>
			<div class="control-grid">
				<label>
					<span>Network Name</span>
					<input bind:value={networkName} placeholder="Primary Network" />
				</label>
				<label>
					<span>Existing Network</span>
					<select bind:value={networkId} disabled={networks.length === 0}>
						<option value={null}>No network</option>
						{#each networks as network}
							<option value={network.id}>{network.name}</option>
						{/each}
					</select>
				</label>
			</div>
			<div class="button-row">
				<button class="btn-primary" on:click={createNetwork} disabled={creatingNetwork}>
					{creatingNetwork ? 'Creating…' : 'Create Network'}
				</button>
				<button class="btn-secondary" on:click={() => void refreshActiveElectricalData()} disabled={loading}>
					{loading ? 'Refreshing…' : 'Refresh'}
				</button>
				<button class="btn-danger" on:click={deleteNetwork} disabled={!networkId || deletingNetwork}>
					{deletingNetwork ? 'Deleting…' : 'Delete Network'}
				</button>
			</div>
		</div>

		<div class="divider"></div>

		<div class="section">
			<h5>Network Summary</h5>
			<div class="stat-grid">
				<div class="stat"><span class="stat-value">{networkSummary.totalStrings}</span><span class="stat-label">Strings</span></div>
				<div class="stat"><span class="stat-value">{networkSummary.totalInverters}</span><span class="stat-label">Inverters</span></div>
				<div class="stat"><span class="stat-value">{networkSummary.dcCapacity.toFixed(0)}</span><span class="stat-label">DC kW</span></div>
				<div class="stat"><span class="stat-value">{networkSummary.acCapacity.toFixed(0)}</span><span class="stat-label">AC kW</span></div>
			</div>
			<div class="ratio">DC/AC Ratio: <strong>{networkSummary.dcAcRatio.toFixed(2)}</strong></div>
		</div>

		<div class="divider"></div>

		<div class="section">
			<h5>String Generation</h5>
			<div class="control-grid">
				<label><span>Panels / String</span><input type="number" min="1" bind:value={panelsPerString} /></label>
				<label><span>Strings / Inverter</span><input type="number" min="1" bind:value={stringsPerInverter} /></label>
				<label><span>Panel Voltage</span><input type="number" min="0" step="0.1" bind:value={panelVoltage} /></label>
				<label><span>Panel Current</span><input type="number" min="0" step="0.1" bind:value={panelCurrent} /></label>
				<label class="full-width">
					<span>Inverter Asset</span>
					<select bind:value={selectedInverterAssetId}>
						<option value="">Unassigned</option>
						{#each inverterAssets as asset}
							<option value={asset.id}>{asset.manufacturer} {asset.model || asset.name}</option>
						{/each}
					</select>
				</label>
			</div>
			<button class="btn-primary" on:click={autoGenerate} disabled={!networkId || autoGenerating}>
				{autoGenerating ? 'Generating…' : 'Auto-Generate Strings'}
			</button>
			<label>
				<span>Manual Panel IDs</span>
				<textarea bind:value={manualPanelIds} rows="3" placeholder="panel-1, panel-2, panel-3"></textarea>
			</label>
			<button class="btn-secondary" on:click={createManualString} disabled={!networkId || creatingString}>
				{creatingString ? 'Creating…' : 'Create Manual String'}
			</button>
		</div>

		<div class="divider"></div>

		<div class="section">
			<h5>Strings</h5>
			{#if strings.length === 0}
				<p class="empty compact">No strings available for the current network.</p>
			{:else}
				<div class="list">
					{#each strings as stringEntry (stringEntry.id)}
						<label class="list-item selectable">
							<input type="checkbox" checked={selectedStringIds.includes(stringEntry.id)} on:change={() => toggleStringSelection(stringEntry.id)} />
							<div class="list-copy">
								<span>{stringEntry.id.slice(0, 8)} · {stringEntry.panel_count} panels</span>
								<small>{stringEntry.voltage_v.toFixed(1)} V · {stringEntry.current_a.toFixed(1)} A · {(stringEntry.power_w / 1000).toFixed(2)} kW</small>
							</div>
						</label>
					{/each}
				</div>
			{/if}
		</div>

		<div class="divider"></div>

		<div class="section">
			<h5>Inverter Assignment</h5>
			<label>
				<span>Inverter Position GeoJSON</span>
				<textarea bind:value={inverterPositionGeojson} rows="2" placeholder={"{\"type\":\"Point\",\"coordinates\":[0,0]}"}></textarea>
			</label>
			<button class="btn-primary" on:click={assignSelectedStrings} disabled={!networkId || selectedStringIds.length === 0 || !selectedInverterAssetId || assigningInverter}>
				{assigningInverter ? 'Assigning…' : 'Assign Selected Strings'}
			</button>
			{#if inverterGroups.length > 0}
				<div class="list">
					{#each inverterGroups as group (group.id)}
						<div class="list-item">
							<div class="list-copy">
								<span>{group.id.slice(0, 8)} · {group.string_ids.length} strings</span>
								<small>{group.dc_input_kw.toFixed(2)} kW DC · {group.ac_output_kw.toFixed(2)} kW AC · ratio {group.dc_ac_ratio.toFixed(2)}</small>
							</div>
						</div>
					{/each}
				</div>
			{/if}
		</div>

		<div class="divider"></div>

		<div class="section">
			<h5>Sizing Validation</h5>
			<div class="control-grid">
				<label><span>Panel Voc</span><input type="number" min="0" step="0.1" bind:value={panelVoc} /></label>
				<label><span>Panel Vmp</span><input type="number" min="0" step="0.1" bind:value={panelVmp} /></label>
				<label><span>Panel Isc</span><input type="number" min="0" step="0.1" bind:value={panelIsc} /></label>
				<label><span>Panel Imp</span><input type="number" min="0" step="0.1" bind:value={panelImp} /></label>
				<label><span>Inv. Vdc Max</span><input type="number" min="0" step="1" bind:value={inverterVdcMax} /></label>
				<label><span>Inv. MPPT Min</span><input type="number" min="0" step="1" bind:value={inverterVmpptMin} /></label>
				<label><span>Inv. MPPT Max</span><input type="number" min="0" step="1" bind:value={inverterVmpptMax} /></label>
				<label><span>Inv. Idc Max</span><input type="number" min="0" step="0.1" bind:value={inverterIdcMax} /></label>
				<label><span>Inv. AC kW</span><input type="number" min="0" step="0.1" bind:value={inverterAcKw} /></label>
				<label><span>DC/AC Min</span><input type="number" min="0" step="0.01" bind:value={dcAcRatioMin} /></label>
				<label><span>DC/AC Max</span><input type="number" min="0" step="0.01" bind:value={dcAcRatioMax} /></label>
				<label><span>Temp Coeff Voc %/C</span><input type="number" step="0.01" bind:value={tempCoeffVoc} /></label>
				<label><span>Lowest Temp C</span><input type="number" step="0.1" bind:value={lowestExpectedTemp} /></label>
				<label><span>Highest Temp C</span><input type="number" step="0.1" bind:value={highestExpectedTemp} /></label>
			</div>
			<button class="btn-primary" on:click={validateSizing} disabled={!networkId || validatingSizing}>
				{validatingSizing ? 'Validating…' : 'Validate Sizing'}
			</button>
			{#if sizingResult}
				<div class="stat-grid validation-grid">
					<div class="stat"><span class="stat-value">{sizingResult.string_voc_cold_v.toFixed(1)}</span><span class="stat-label">Cold Voc V</span></div>
					<div class="stat"><span class="stat-value">{sizingResult.string_vmp_hot_v.toFixed(1)}</span><span class="stat-label">Hot Vmp V</span></div>
					<div class="stat"><span class="stat-value">{sizingResult.dc_string_power_kw.toFixed(2)}</span><span class="stat-label">String kW</span></div>
					<div class="stat"><span class="stat-value">{sizingResult.dc_ac_ratio.toFixed(2)}</span><span class="stat-label">DC/AC</span></div>
					<div class="stat"><span class="stat-value">{sizingResult.min_panels_per_string}</span><span class="stat-label">Min Panels/String</span></div>
					<div class="stat"><span class="stat-value">{sizingResult.max_panels_per_string}</span><span class="stat-label">Max Panels/String</span></div>
				</div>
				{#if sizingResult.violations.length > 0}
					<div class="list validation-list">
						{#each sizingResult.violations as violation (violation.code)}
							<div class="list-item violation-item">
								<div class="list-copy">
									<span>{violation.code}</span>
									<small>{violation.message}</small>
								</div>
								<div class="violation-values">
									<span>{violation.actual.toFixed(2)}</span>
									<small>limit {violation.limit.toFixed(2)}</small>
								</div>
							</div>
						{/each}
					</div>
				{/if}
			{/if}
		</div>

		<div class="divider"></div>

		<div class="section">
			<h5>Network Topology Validation</h5>
			<div class="control-grid">
				<label><span>Inverter MPPT Count</span><input type="number" min="1" step="1" bind:value={inverterMpptCount} /></label>
				<label><span>Max Strings / MPPT</span><input type="number" min="1" step="1" bind:value={maxStringsPerMppt} /></label>
			</div>
			<button class="btn-primary" on:click={validateNetworkConsistency} disabled={!networkId || validatingNetwork}>
				{validatingNetwork ? 'Validating…' : 'Validate Network Topology'}
			</button>
			{#if networkValidationResult}
				<div class="stat-grid validation-grid">
					<div class="stat"><span class="stat-value">{networkValidationResult.total_strings}</span><span class="stat-label">Total Strings</span></div>
					<div class="stat"><span class="stat-value">{networkValidationResult.assigned_strings}</span><span class="stat-label">Assigned Strings</span></div>
					<div class="stat"><span class="stat-value">{networkValidationResult.unassigned_strings}</span><span class="stat-label">Unassigned Strings</span></div>
					<div class="stat"><span class="stat-value">{networkValidationResult.duplicate_panel_refs}</span><span class="stat-label">Duplicate Panels</span></div>
				</div>
				{#if networkValidationResult.issues.length > 0}
					<div class="list validation-list">
						{#each networkValidationResult.issues as issue (issue.code + issue.entity_id)}
							<div class="list-item violation-item">
								<div class="list-copy">
									<span>{issue.code}</span>
									<small>{issue.message}</small>
								</div>
								<div class="violation-values">
									<span>{issue.entity_id || '-'}</span>
								</div>
							</div>
						{/each}
					</div>
				{/if}
			{/if}
		</div>

		<div class="divider"></div>

		<div class="section">
			<h5>Network BOM Consistency</h5>
			<div class="control-grid">
				<label><span>Panel Unit Cost</span><input type="number" min="0" step="0.01" bind:value={panelUnitCost} /></label>
				<label><span>Inverter Unit Cost</span><input type="number" min="0" step="0.01" bind:value={inverterUnitCost} /></label>
				<label><span>Cable Cost / m</span><input type="number" min="0" step="0.01" bind:value={cableCostPerM} /></label>
				<label><span>Mounting Cost / Panel</span><input type="number" min="0" step="0.01" bind:value={mountingCostPerPanel} /></label>
				<label><span>Currency</span><input bind:value={currencyCode} maxlength="8" /></label>
			</div>
			<button class="btn-primary" on:click={generateNetworkBom} disabled={!networkId || generatingBom}>
				{generatingBom ? 'Generating…' : 'Generate BOM from Network'}
			</button>
			{#if networkBomResult}
				<div class="stat-grid validation-grid">
					<div class="stat"><span class="stat-value">{networkBomResult.panel_count}</span><span class="stat-label">Panels</span></div>
					<div class="stat"><span class="stat-value">{networkBomResult.string_count}</span><span class="stat-label">Strings</span></div>
					<div class="stat"><span class="stat-value">{networkBomResult.inverter_group_count}</span><span class="stat-label">Inverter Groups</span></div>
					<div class="stat"><span class="stat-value">{networkBomResult.total_cost.toFixed(2)}</span><span class="stat-label">Total {networkBomResult.currency_code || 'USD'}</span></div>
				</div>
				{#if networkBomResult.items.length > 0}
					<div class="list validation-list">
						{#each networkBomResult.items as item (item.category + item.name)}
							<div class="list-item">
								<div class="list-copy">
									<span>{item.category}: {item.name}</span>
									<small>{item.quantity} {item.unit} × {item.unit_cost.toFixed(2)}</small>
								</div>
								<div class="violation-values">
									<span>{item.total_cost.toFixed(2)}</span>
									<small>{networkBomResult.currency_code || currencyCode}</small>
								</div>
							</div>
						{/each}
					</div>
				{/if}
			{/if}
		</div>

		<div class="divider"></div>

		<div class="section">
			<h5>Loss Breakdown</h5>
			<div class="loss-list">
				{#each Object.entries(networkSummary.losses) as [key, value]}
					{#if key !== 'total'}
						<div class="loss-item">
							<span class="loss-label">{key.charAt(0).toUpperCase() + key.slice(1)}</span>
							<div class="loss-bar-container"><div class="loss-bar" style="width: {Math.min(value * 10, 100)}%"></div></div>
							<span class="loss-value">{value.toFixed(1)}%</span>
						</div>
					{/if}
				{/each}
				<div class="loss-total"><span>Total Loss</span><span class="loss-total-value">{networkSummary.losses.total.toFixed(1)}%</span></div>
			</div>
		</div>

		<div class="divider"></div>

		<PanelStringsVisualization
			visible={true}
			panelsPerString={panelsPerString}
			stringsPerCombiner={stringsPerInverter}
			panelRatedPowerW={panelCurrent * panelVoltage}
		/>
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

	.control-grid {
		display: grid;
		grid-template-columns: 1fr 1fr;
		gap: 8px;
	}

	.control-grid label,
	.section > label {
		display: flex;
		flex-direction: column;
		gap: 4px;
		font-size: 11px;
		color: #94a3b8;
	}

	.full-width {
		grid-column: 1 / -1;
	}

	input,
	select,
	textarea {
		width: 100%;
		padding: 6px 8px;
		border: 1px solid rgba(255, 255, 255, 0.15);
		border-radius: 4px;
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 12px;
		font-family: inherit;
	}

	textarea {
		resize: vertical;
	}

	.button-row {
		display: flex;
		gap: 8px;
		flex-wrap: wrap;
	}

	.btn-primary,
	.btn-secondary,
	.btn-danger {
		padding: 8px;
		border-radius: 6px;
		font-size: 13px;
		cursor: pointer;
	}

	.btn-primary {
		border: none;
		background: linear-gradient(135deg, #3b82f6, #2563eb);
		color: white;
		font-weight: 600;
	}

	.btn-secondary {
		border: 1px solid rgba(255, 255, 255, 0.15);
		background: transparent;
		color: #94a3b8;
	}

	.btn-danger {
		border: 1px solid rgba(239, 68, 68, 0.3);
		background: rgba(239, 68, 68, 0.08);
		color: #fca5a5;
	}

	.btn-primary:disabled,
	.btn-secondary:disabled,
	.btn-danger:disabled {
		opacity: 0.5;
		cursor: not-allowed;
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

	.list {
		display: flex;
		flex-direction: column;
		gap: 6px;
	}

	.list-item {
		display: flex;
		gap: 8px;
		align-items: center;
		padding: 8px;
		border-radius: 6px;
		background: rgba(255, 255, 255, 0.04);
		border: 1px solid rgba(255, 255, 255, 0.08);
	}

	.list-item.selectable {
		cursor: pointer;
	}

	.list-copy {
		display: flex;
		flex-direction: column;
		gap: 2px;
		color: #e2e8f0;
		font-size: 12px;
	}

	.list-copy small {
		color: #94a3b8;
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

	.validation-grid {
		margin-top: 8px;
	}

	.validation-list {
		margin-top: 8px;
	}

	.violation-item {
		justify-content: space-between;
		border-color: rgba(239, 68, 68, 0.18);
		background: rgba(239, 68, 68, 0.06);
	}

	.violation-values {
		display: flex;
		flex-direction: column;
		align-items: flex-end;
		font-size: 12px;
		color: #fecaca;
	}

	.violation-values small {
		color: #fca5a5;
	}

	.error,
	.status,
	.empty {
		font-size: 12px;
		margin: 0;
	}

	.error {
		color: #fca5a5;
	}

	.status {
		color: #93c5fd;
	}

	.empty {
		color: #64748b;
		text-align: center;
		padding: 24px 0;
	}

	.empty.compact {
		padding: 0;
		text-align: left;
	}
</style>
