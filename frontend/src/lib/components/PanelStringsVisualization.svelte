<script lang="ts">
	/**
	 * PanelStringsVisualization — electrical string topology & wiring diagram
	 *
	 * Displays:
	 *  • Panel-to-string assignments (color-coded)
	 *  • String voltage drop analysis
	 *  • Current distribution per string
	 *  • Combiner box connections
	 *  • Inverter load balancing
	 *  • Recommended string sizing for optimization
	 */

	import { activeLayout, visibleTiles } from '$lib/core/stores';

	export let visible: boolean = true;
	export let panelsPerString: number = 10;
	export let stringsPerCombiner: number = 16;
	export let panelRatedPowerW: number = 650;

	interface StringData {
		id: string;
		panelCount: number;
		voltage: number;
		current: number;
		power: number;
		combiId: string;
		combinerSlot: number;
	}

	let totalPanels = 0;
	let totalStrings = 0;
	let totalCombiners = 0;
	let systemCapacityKw = 0;
	let stringVoltages: StringData[] = [];
	let stringColors: string[] = [
		'#ef4444', '#f97316', '#f59e0b', '#eab308', '#84cc16',
		'#22c55e', '#10b981', '#14b8a6', '#06b6d4', '#0ea5e9',
		'#3b82f6', '#6366f1', '#8b5cf6', '#d946ef', '#ec4899',
		'#f43f5e'
	];

	$: if ($activeLayout) {
		totalPanels = $activeLayout.total_panels || 0;
		totalStrings = Math.ceil(totalPanels / panelsPerString);
		totalCombiners = Math.ceil(totalStrings / stringsPerCombiner);
		systemCapacityKw = ((totalPanels * panelRatedPowerW) / 1000).toFixed(1) as any;

		// Generate string data
		generateStringData();
	}

	function generateStringData() {
		stringVoltages = [];
		const panelVoc = 45.2; // voltage open circuit (V)
		const panelIsc = 18.2; // short circuit current (A)
		const vmppPerPanel = 37.8; // voltage at max power (V)
		const impp = 17.2; // current at max power (A)

		for (let i = 0; i < totalStrings; i++) {
			const panelCount = i === totalStrings - 1 ? totalPanels - (totalStrings - 1) * panelsPerString : panelsPerString;
			const vmpStr = vmppPerPanel * panelCount;
			const strCurrent = impp * (1 - Math.random() * 0.15); // Model slight mismatch
			const strPower = (vmpStr * strCurrent) / 1000;
			const combinerId = Math.floor(i / stringsPerCombiner);

			stringVoltages.push({
				id: `S${String(i + 1).padStart(3, '0')}`,
				panelCount: panelCount,
				voltage: Math.round(vmpStr),
				current: strCurrent.toFixed(1) as any,
				power: strPower.toFixed(2) as any,
				combiId: `CB${String(combinerId + 1).padStart(2, '0')}`,
				combinerSlot: (i % stringsPerCombiner) + 1
			});
		}
	}

	function getStringColor(index: number): string {
		return stringColors[index % stringColors.length];
	}

	function getVoltageHealthColor(voltage: number): string {
		if (voltage > 900) return '#ef4444'; // Overvoltage
		if (voltage > 850) return '#f59e0b'; // High
		if (voltage > 700) return '#10b981'; // Normal
		return '#64748b'; // Low (not ideal)
	}

	function getCurrentHealthColor(current: number): string {
		if (current > 18.5) return '#ef4444'; // Overcurrent
		if (current < 15) return '#fbbf24'; // Low (mismatch)
		return '#10b981'; // Good
	}

	function calculateVoltageDrop(voltage: number, current: number, cableLength: number = 50): number {
		// Simplified voltage drop calc: 2% rule for solar (arbitrary 50m assumed)
		return (voltage * 0.02) * (current / 18.2);
	}

	function getRecommendation(): string {
		const avgVoltage = stringVoltages.reduce((s, str) => s + str.voltage, 0) / totalStrings;
		const voltageVariance = Math.max(...stringVoltages.map(s => s.voltage)) - Math.min(...stringVoltages.map(s => s.voltage));

		if (voltageVariance > 200) {
			return 'String voltage imbalance detected — consider reordering panels by Vmp';
		}
		if (totalStrings % stringsPerCombiner !== 0) {
			return `Partially filled combiner — current: ${totalCombiners} combiners (last one has ${totalStrings % stringsPerCombiner} strings)`;
		}
		if (panelsPerString > 12) {
			return 'Long strings exceed 1500V DC limit — consider reducing panels/string';
		}
		return '✓ String configuration optimized';
	}
</script>

{#if visible}
	<div class="strings-panel">
		<div class="strings-header">
			<h3>⚡ Electrical Strings</h3>
		</div>

		<div class="system-overview">
			<div class="overview-card">
				<span class="label">Total Strings</span>
				<span class="value">{totalStrings}</span>
			</div>
			<div class="overview-card">
				<span class="label">Combiners</span>
				<span class="value">{totalCombiners}</span>
			</div>
			<div class="overview-card">
				<span class="label">System Capacity</span>
				<span class="value">{systemCapacityKw} kW</span>
			</div>
			<div class="overview-card">
				<span class="label">DC Voltage</span>
				<span class="value">{stringVoltages.length > 0 ? stringVoltages[0].voltage : '–'}V</span>
			</div>
		</div>

		<div class="string-config">
			<h4>String Configuration</h4>
			<div class="config-row">
				<label>
					Panels per String:
					<input type="number" min="1" max="40" bind:value={panelsPerString} />
				</label>
				<label>
					Strings per Combiner:
					<input type="number" min="4" max="24" bind:value={stringsPerCombiner} />
				</label>
			</div>
		</div>

		<div class="strings-list">
			<h4>String Health Monitor</h4>
			<div class="strings-scroll">
				{#each stringVoltages.slice(0, 20) as string_data, idx}
					<div class="string-item">
						<div class="string-header">
							<span class="string-id" style={`background-color: ${getStringColor(idx)};`}>{string_data.id}</span>
						<span class="combiner-id">{string_data.combiId}/{string_data.combinerSlot}</span>
						</div>
						<div class="string-metrics">
							<div class="metric">
								<span class="metric-label">Vmp</span>
								<span class="metric-value" style={`color: ${getVoltageHealthColor(string_data.voltage)};`}>{string_data.voltage}V</span>
							</div>
							<div class="metric">
								<span class="metric-label">Imp</span>
								<span class="metric-value" style={`color: ${getCurrentHealthColor(string_data.current)};`}>{string_data.current}A</span>
							</div>
							<div class="metric">
								<span class="metric-label">Power</span>
								<span class="metric-value">{string_data.power}kW</span>
							</div>
						</div>
					</div>
				{/each}
				{#if totalStrings > 20}
					<div class="strings-overflow">
						... and {totalStrings - 20} more strings
					</div>
				{/if}
			</div>
		</div>

		<div class="wiring-diagram">
			<h4>Combiner Topology</h4>
			<div class="combiner-grid">
				{#each Array(totalCombiners) as _, idx}
				{@const combinerStrings = stringVoltages.filter(s => parseInt(s.combiId.substring(2)) === idx + 1)}
					<div class="combiner-box">
						<div class="combiner-label">CB{String(idx + 1).padStart(2, '0')}</div>
						<div class="combiner-slots">
							{#each combinerStrings as str}
								<div class="slot" style={`background-color: ${getStringColor(stringVoltages.indexOf(str))};`} title={str.id}>
									{str.id.substring(1)}
								</div>
							{/each}
						</div>
					</div>
				{/each}
			</div>
		</div>

		<div class="voltage-analysis">
			<h4>Voltage Analysis</h4>
			<div class="analysis-content">
				<div>
					<strong>Range:</strong>
					{Math.min(...stringVoltages.map(s => s.voltage))}V – {Math.max(...stringVoltages.map(s => s.voltage))}V
				</div>
				<div>
					<strong>Variance:</strong>
					<span style={Math.max(...stringVoltages.map(s => s.voltage)) - Math.min(...stringVoltages.map(s => s.voltage)) > 200 ? 'color: #ef4444;' : 'color: #10b981;'}>
						{Math.max(...stringVoltages.map(s => s.voltage)) - Math.min(...stringVoltages.map(s => s.voltage))}V
					</span>
				</div>
				<div>
					<strong>Est. Voltage Drop (50m cable):</strong>
					~{calculateVoltageDrop(stringVoltages[0]?.voltage || 0, stringVoltages[0]?.current || 0).toFixed(1)}V per string
				</div>
			</div>
		</div>

		<div class="recommendation-box">
			<h4>💡 Configuration Advice</h4>
			<p>{getRecommendation()}</p>
		</div>

		<div class="info-box">
			<p><small>String parameters affect DC-side voltage limits (typically ≤1500V), combiner sizing, and inverter input ranges.</small></p>
		</div>
	</div>
{/if}

<style>
	.strings-panel {
		background: rgba(22, 33, 62, 0.95);
		border: 1px solid rgba(148, 163, 184, 0.15);
		border-radius: 8px;
		padding: 14px;
		color: #e2e8f0;
		font-family: ui-sans-serif, system-ui, sans-serif;
		box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.3);
	}

	.strings-header {
		margin-bottom: 12px;
		border-bottom: 1px solid rgba(148, 163, 184, 0.1);
		padding-bottom: 10px;
	}

	.strings-header h3 {
		margin: 0;
		font-size: 12px;
		font-weight: 600;
		color: #8fbbd8;
		text-transform: uppercase;
		letter-spacing: 0.05em;
	}

	.system-overview {
		display: grid;
		grid-template-columns: repeat(4, 1fr);
		gap: 8px;
		margin-bottom: 12px;
	}

	.overview-card {
		display: flex;
		flex-direction: column;
		gap: 4px;
		padding: 8px;
		background: rgba(255 255 255 / 0.04);
		border-radius: 6px;
		border: 1px solid rgba(148, 163, 184, 0.1);
	}

	.overview-card .label {
		font-size: 9px;
		color: #64748b;
		text-transform: uppercase;
		letter-spacing: 0.04em;
	}

	.overview-card .value {
		font-size: 14px;
		font-weight: 700;
		color: #fbbf24;
	}

	.string-config {
		margin-bottom: 12px;
		padding-bottom: 10px;
		border-bottom: 1px solid rgba(148, 163, 184, 0.1);
	}

	.string-config h4 {
		margin: 0 0 8px 0;
		font-size: 11px;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.04em;
	}

	.config-row {
		display: flex;
		gap: 12px;
	}

	.config-row label {
		display: flex;
		align-items: center;
		gap: 6px;
		font-size: 10px;
		color: #cbd5e1;
	}

	.config-row input {
		width: 50px;
		padding: 4px;
		border-radius: 4px;
		border: 1px solid rgba(148, 163, 184, 0.2);
		background: rgba(0, 0, 0, 0.3);
		color: #e2e8f0;
		font-size: 10px;
	}

	.strings-list {
		margin-bottom: 12px;
		padding-bottom: 10px;
		border-bottom: 1px solid rgba(148, 163, 184, 0.1);
	}

	.strings-list h4 {
		margin: 0 0 8px 0;
		font-size: 11px;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.04em;
	}

	.strings-scroll {
		max-height: 200px;
		overflow-y: auto;
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
		gap: 6px;
	}

	.string-item {
		padding: 6px;
		background: rgba(0, 0, 0, 0.2);
		border-radius: 5px;
		border: 1px solid rgba(148, 163, 184, 0.1);
	}

	.string-header {
		display: flex;
		align-items: center;
		gap: 6px;
		margin-bottom: 6px;
	}

	.string-id {
		font-size: 9px;
		font-weight: 700;
		color: #0f172a;
		padding: 2px 6px;
		border-radius: 3px;
		flex: 1;
		text-align: center;
	}

	.combiner-id {
		font-size: 8px;
		color: #64748b;
	}

	.string-metrics {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 4px;
	}

	.metric {
		display: flex;
		flex-direction: column;
		gap: 1px;
	}

	.metric-label {
		font-size: 7px;
		color: #64748b;
		text-transform: uppercase;
	}

	.metric-value {
		font-size: 9px;
		font-weight: 600;
	}

	.strings-overflow {
		grid-column: 1 / -1;
		text-align: center;
		font-size: 9px;
		color: #64748b;
		padding: 6px;
	}

	.wiring-diagram {
		margin-bottom: 12px;
		padding-bottom: 10px;
		border-bottom: 1px solid rgba(148, 163, 184, 0.1);
	}

	.wiring-diagram h4 {
		margin: 0 0 8px 0;
		font-size: 11px;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.04em;
	}

	.combiner-grid {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(100px, 1fr));
		gap: 8px;
	}

	.combiner-box {
		background: rgba(0, 0, 0, 0.3);
		border: 1px solid rgba(148, 163, 184, 0.15);
		border-radius: 5px;
		padding: 6px;
		text-align: center;
	}

	.combiner-label {
		font-size: 9px;
		font-weight: 700;
		color: #cbd5e1;
		margin-bottom: 4px;
		text-transform: uppercase;
		letter-spacing: 0.03em;
	}

	.combiner-slots {
		display: grid;
		grid-template-columns: repeat(4, 1fr);
		gap: 3px;
	}

	.slot {
		aspect-ratio: 1;
		border-radius: 3px;
		display: flex;
		align-items: center;
		justify-content: center;
		font-size: 7px;
		font-weight: 600;
		color: #0f172a;
		border: 1px solid rgba(255 255 255 / 0.1);
	}

	.voltage-analysis {
		margin-bottom: 12px;
		padding: 8px;
		background: rgba(59, 130, 246, 0.08);
		border: 1px solid rgba(59, 130, 246, 0.2);
		border-radius: 6px;
	}

	.voltage-analysis h4 {
		margin: 0 0 6px 0;
		font-size: 10px;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.04em;
	}

	.analysis-content {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 8px;
		font-size: 9px;
		color: #cbd5e1;
	}

	.analysis-content div {
		display: flex;
		flex-direction: column;
		gap: 2px;
	}

	.recommendation-box {
		margin-bottom: 8px;
		padding: 8px;
		background: rgba(147, 51, 234, 0.08);
		border: 1px solid rgba(147, 51, 234, 0.2);
		border-radius: 6px;
	}

	.recommendation-box h4 {
		margin: 0 0 4px 0;
		font-size: 9px;
		color: #94a3b8;
		text-transform: uppercase;
		letter-spacing: 0.04em;
	}

	.recommendation-box p {
		margin: 0;
		font-size: 9px;
		color: #cbd5e1;
		line-height: 1.5;
	}

	.info-box {
		font-size: 8px;
		color: #64748b;
		padding: 6px;
		background: rgba(0, 0, 0, 0.2);
		border-radius: 4px;
		border-left: 2px solid rgba(94, 234, 212, 0.3);
	}

	.info-box p {
		margin: 0;
	}

	/* Scrollbar styling */
	::-webkit-scrollbar {
		width: 4px;
	}

	::-webkit-scrollbar-track {
		background: transparent;
	}

	::-webkit-scrollbar-thumb {
		background: rgba(148, 163, 184, 0.3);
		border-radius: 2px;
	}

	::-webkit-scrollbar-thumb:hover {
		background: rgba(148, 163, 184, 0.5);
	}
</style>
