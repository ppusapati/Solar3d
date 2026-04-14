<script lang="ts">
	import { onMount } from 'svelte';
	import { writable } from 'svelte/store';

	interface SitingConflict {
		conflictId: string;
		zoneId: string;
		zoneName: string;
		zoneType: 'EXCLUSION' | 'INCLUSION' | 'BUFFER';
		severity: 'INFO' | 'WARNING' | 'ERROR' | 'BLOCKER';
		reason: string;
		distanceMeters?: number;
		mitigationSuggestions: string[];
	}

	interface RiskScore {
		totalConflicts: number;
		blockerCount: number;
		errorCount: number;
		warningCount: number;
		infoCount: number;
		isSiteable: boolean;
		overallRiskPercentage: number;
		sitingRecommendation: string;
	}

	interface AnalysisResult {
		sitingGeometry: string;
		riskScore: RiskScore;
		conflicts: SitingConflict[];
		analyzedAt: string;
		analyzedBy: string;
	}

	// State
	const analyses = writable<AnalysisResult[]>([]);
	let currentAnalysis: AnalysisResult | null = null;
	let proposedSiteGeometry = '';
	let geometryType: 'POINT' | 'POLYGON' | 'LINESTRING' = 'POINT';
	let isAnalyzing = false;
	let showResults = false;
	let selectedConflict: SitingConflict | null = null;
	let includeBufferZones = true;
	let includeExpiredZones = false;
	let projectId = 'dev-solar-1';

	// UI State
	let expandedSeverityFilter = 'all';
	let sortBy: 'severity' | 'zone-name' | 'distance' = 'severity';
	let ascending = false;

	// Constants
	const SEVERITY_LEVELS = [
		{ value: 'BLOCKER', label: 'Blocker', color: '#dc2626', bgColor: '#fee2e2', priority: 4 },
		{ value: 'ERROR', label: 'Error', color: '#ea580c', bgColor: '#fed7aa', priority: 3 },
		{ value: 'WARNING', label: 'Warning', color: '#ca8a04', bgColor: '#fef3c7', priority: 2 },
		{ value: 'INFO', label: 'Info', color: '#0284c7', bgColor: '#cffafe', priority: 1 }
	];

	const SITEABILITY_STATUSES = [
		{
			status: 'APPROVED',
			color: '#22c55e',
			bgColor: '#dcfce7',
			icon: '✓',
			message: 'Site is approved for development'
		},
		{
			status: 'CONDITIONAL',
			color: '#ca8a04',
			bgColor: '#fef3c7',
			icon: '!',
			message: 'Site may be viable with mitigation'
		},
		{
			status: 'NOT_RECOMMENDED',
			color: '#ea580c',
			bgColor: '#fed7aa',
			icon: '◆',
			message: 'Site not recommended due to conflicts'
		},
		{
			status: 'REJECTED',
			color: '#dc2626',
			bgColor: '#fee2e2',
			icon: '✕',
			message: 'Site cannot be developed'
		}
	];

	const GEOMETRY_TYPES = ['POINT', 'POLYGON', 'LINESTRING'] as const;

	$: currentStatus = currentAnalysis ? getSiteabilityStatus(currentAnalysis.riskScore) : null;

	// Lifecycle
	onMount(async () => {
		loadAnalysisHistory();
	});

	// Load analysis history
	async function loadAnalysisHistory() {
		try {
			// TODO: API call to fetch analysis history
			// const response = await fetch(`/api/siting-analyses?projectId=${projectId}`);
			// const data = await response.json();
			// analyses.set(data);
			analyses.set([]);
		} catch (error) {
			console.error('Failed to load analysis history:', error);
		}
	}

	// Analyze siting
	async function analyzeSite() {
		if (!proposedSiteGeometry) {
			alert('Please enter proposed site geometry');
			return;
		}

		isAnalyzing = true;

		try {
			// TODO: Replace with actual API call
			// const response = await fetch('/api/constraint-zones/check-siting-conflicts', {
			//   method: 'POST',
			//   body: JSON.stringify({
			//     projectId,
			//     proposedSiteGeometryWkt: proposedSiteGeometry,
			//     proposedGeometryType: geometryType,
			//     includeBufferZones,
			//     includeExpiredZones,
			//     analyzedByUser: 'current-user'
			//   })
			// });
			// const data = await response.json();

			// Mock analysis result
			const mockConflicts: SitingConflict[] = [
				{
					conflictId: 'conflict-1',
					zoneId: 'zone-env-1',
					zoneName: 'Protected Habitat Alpha',
					zoneType: 'EXCLUSION',
					severity: 'BLOCKER',
					reason: 'Site overlaps critical wildlife habitat (endangered species present)',
					distanceMeters: 0,
					mitigationSuggestions: [
						'Relocate site at least 500m away from habitat boundaries',
						'Obtain endangered species permit (may take 6-12 months)',
						'Implement habitat restoration plan (costly)'
					]
				},
				{
					conflictId: 'conflict-2',
					zoneId: 'zone-inf-1',
					zoneName: 'Power Line Buffer',
					zoneType: 'BUFFER',
					severity: 'WARNING',
					reason: 'Site within 500m buffer of high-voltage transmission lines',
					distanceMeters: 250,
					mitigationSuggestions: [
						'Maintain 500m clearance from transmission lines',
						'Install underground conduit if closer than 300m',
						'Coordinate with utility company for safety approval'
					]
				},
				{
					conflictId: 'conflict-3',
					zoneId: 'zone-reg-1',
					zoneName: 'Designated Solar Zone',
					zoneType: 'INCLUSION',
					severity: 'INFO',
					reason: 'Site is within county-approved solar development zone',
					distanceMeters: 0,
					mitigationSuggestions: ['No action required - site matches regulatory approval']
				}
			];

			const mockRiskScore: RiskScore = {
				totalConflicts: mockConflicts.length,
				blockerCount: 1,
				errorCount: 0,
				warningCount: 1,
				infoCount: 1,
				isSiteable: false,
				overallRiskPercentage: 61.67,
				sitingRecommendation:
					'CRITICAL: Site cannot be placed due to 1 blocker conflicts. Relocation required.'
			};

			const analysis: AnalysisResult = {
				sitingGeometry: proposedSiteGeometry,
				riskScore: mockRiskScore,
				conflicts: mockConflicts,
				analyzedAt: new Date().toISOString(),
				analyzedBy: 'current-user'
			};

			currentAnalysis = analysis;
			analyses.update((a) => [analysis, ...a]);
			showResults = true;
		} catch (error) {
			console.error('Failed to analyze site:', error);
			alert('Failed to analyze site: ' + error);
		} finally {
			isAnalyzing = false;
		}
	}

	// Utility functions
	function getSeverityLevel(severity: string) {
		return SEVERITY_LEVELS.find((s) => s.value === severity);
	}

	function getSiteabilityStatus(riskScore: RiskScore) {
		if (riskScore.blockerCount > 0) {
			return SITEABILITY_STATUSES[3]; // REJECTED
		}
		if (riskScore.errorCount > 0) {
			return SITEABILITY_STATUSES[2]; // NOT_RECOMMENDED
		}
		if (riskScore.warningCount > 0) {
			return SITEABILITY_STATUSES[1]; // CONDITIONAL
		}
		return SITEABILITY_STATUSES[0]; // APPROVED
	}

	function sortConflicts(conflicts: SitingConflict[]): SitingConflict[] {
		let result = [...conflicts];
		result.sort((a, b) => {
			let comparison = 0;
			switch (sortBy) {
				case 'severity': {
					const severityA =
						SEVERITY_LEVELS.find((s) => s.value === a.severity)?.priority || 0;
					const severityB =
						SEVERITY_LEVELS.find((s) => s.value === b.severity)?.priority || 0;
					comparison = severityA - severityB;
					break;
				}
				case 'zone-name':
					comparison = a.zoneName.localeCompare(b.zoneName);
					break;
				case 'distance':
					comparison = (a.distanceMeters || 0) - (b.distanceMeters || 0);
					break;
			}
			return ascending ? comparison : -comparison;
		});
		return result;
	}

	function filterConflictsBySeverity(conflicts: SitingConflict[]): SitingConflict[] {
		if (expandedSeverityFilter === 'all') {
			return conflicts;
		}
		return conflicts.filter((c) => c.severity === expandedSeverityFilter);
	}

	function downloadReport() {
		if (!currentAnalysis) return;

		const csv = [
			['Siting Analysis Report'],
			['Generated:', new Date().toLocaleString()],
			['Project:', projectId],
			['Site Geometry:', currentAnalysis.sitingGeometry],
			[''],
			['Overall Risk Assessment'],
			['Total Conflicts:', currentAnalysis.riskScore.totalConflicts],
			['Blockers:', currentAnalysis.riskScore.blockerCount],
			['Errors:', currentAnalysis.riskScore.errorCount],
			['Warnings:', currentAnalysis.riskScore.warningCount],
			['Info:', currentAnalysis.riskScore.infoCount],
			['Overall Risk %:', currentAnalysis.riskScore.overallRiskPercentage.toFixed(2)],
			['Siteable:', currentAnalysis.riskScore.isSiteable ? 'Yes' : 'No'],
			['Recommendation:', currentAnalysis.riskScore.sitingRecommendation],
			[''],
			['Detailed Conflicts'],
			['Zone Name', 'Type', 'Severity', 'Reason', 'Distance (m)', 'Mitigations'],
			...currentAnalysis.conflicts.map((c) => [
				c.zoneName,
				c.zoneType,
				c.severity,
				c.reason,
				c.distanceMeters?.toString() || 'N/A',
				c.mitigationSuggestions.join('; ')
			])
		];

		const csvContent = csv.map((row) => row.map((cell) => `"${cell}"`).join(',')).join('\n');
		const blob = new Blob([csvContent], { type: 'text/csv' });
		const url = URL.createObjectURL(blob);
		const a = document.createElement('a');
		a.href = url;
		a.download = `siting-analysis-${Date.now()}.csv`;
		a.click();
		URL.revokeObjectURL(url);
	}

	function copyGeometryToAnalysis(geometry: string) {
		proposedSiteGeometry = geometry;
	}
</script>

<div class="siting-analyzer p-6 max-w-7xl mx-auto">
	<!-- Header -->
	<div class="mb-8">
		<h1 class="text-3xl font-bold text-gray-900 mb-2">Land Siting Analyzer</h1>
		<p class="text-gray-600">
			Analyze proposed sites against constraint zones to identify conflicts and siting feasibility
		</p>
	</div>

	<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
		<!-- Analysis Form (Left Column) -->
		<div class="lg:col-span-1">
			<div class="bg-white rounded-lg border border-gray-200 p-6 sticky top-6">
				<h2 class="text-lg font-bold text-gray-900 mb-4">Analysis Input</h2>

				<!-- Project Selection -->
				<div class="mb-4">
					<label for="project-select" class="block text-sm font-medium text-gray-700 mb-1">Project</label>
					<select
						id="project-select"
						bind:value={projectId}
						class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
					>
						<option value="dev-solar-1">Development Solar Site 1</option>
						<option value="dev-solar-2">Development Solar Site 2</option>
					</select>
				</div>

				<!-- Geometry Type -->
				<div class="mb-4">
					<p class="block text-sm font-medium text-gray-700 mb-2">Geometry Type</p>
					<div class="grid grid-cols-3 gap-2">
						{#each GEOMETRY_TYPES as type}
							<button
								on:click={() => (geometryType = type)}
								class="py-2 px-3 text-sm rounded border-2 transition-colors {geometryType === type
									? 'border-blue-600 bg-blue-50 text-blue-700 font-semibold'
									: 'border-gray-200 text-gray-700 hover:border-gray-300'}"
							>
								{type}
							</button>
						{/each}
					</div>
				</div>

				<!-- Proposed Site Geometry -->
				<div class="mb-4">
					<label for="proposed-site-geometry" class="block text-sm font-medium text-gray-700 mb-1">
						Proposed Site Geometry (WKT) *
					</label>
					<textarea
						id="proposed-site-geometry"
						bind:value={proposedSiteGeometry}
						placeholder={geometryType === 'POINT'
							? 'e.g., POINT(-118.45 35.25)'
							: geometryType === 'POLYGON'
								? 'e.g., POLYGON((-118.5 35.2, -118.4 35.2, -118.4 35.3, -118.5 35.3, -118.5 35.2))'
								: 'e.g., LINESTRING(-118.5 35.1, -118.4 35.3)'}
						rows="4"
						class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-xs font-mono"
					></textarea>
					<p class="mt-1 text-xs text-gray-500">Well-Known Text (WKT) format</p>
				</div>

				<!-- Analysis Options -->
				<div class="mb-6 space-y-2 pb-6 border-b border-gray-200">
					<label class="flex items-center">
						<input
							type="checkbox"
							bind:checked={includeBufferZones}
							class="w-4 h-4 text-blue-600 rounded focus:ring-2 focus:ring-blue-500"
						/>
						<span class="ml-2 text-sm text-gray-700">Include buffer zones</span>
					</label>
					<label class="flex items-center">
						<input
							type="checkbox"
							bind:checked={includeExpiredZones}
							class="w-4 h-4 text-blue-600 rounded focus:ring-2 focus:ring-blue-500"
						/>
						<span class="ml-2 text-sm text-gray-700">Include expired zones</span>
					</label>
				</div>

				<!-- Action Buttons -->
				<button
					on:click={analyzeSite}
					disabled={isAnalyzing}
					class="w-full py-3 px-4 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 font-semibold flex items-center justify-center gap-2 transition-colors"
				>
					{#if isAnalyzing}
						<svg class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24">
							<circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4" />
							<path
								class="opacity-75"
								fill="currentColor"
								d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
							/>
						</svg>
						Analyzing...
					{:else}
						<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
							/>
						</svg>
						Analyze Site
					{/if}
				</button>
			</div>
		</div>

		<!-- Results (Right Column) -->
		<div class="lg:col-span-2">
			{#if showResults && currentAnalysis}
				<div class="space-y-6">
					<!-- Summary Card -->
					<div
						class="rounded-lg p-6 border-2"
						style="background-color: {currentStatus?.bgColor}; border-color: {currentStatus?.color}"
					>
						<div class="flex items-start justify-between mb-4">
							<div class="flex items-center gap-3">
								<div
									class="w-12 h-12 rounded-full flex items-center justify-center text-white text-2xl font-bold"
									style="background-color: {currentStatus?.color}"
								>
									{currentStatus?.icon}
								</div>
								<div>
									<h3 class="text-xl font-bold" style="color: {currentStatus?.color}">{currentStatus?.status}</h3>
									<p class="text-sm text-gray-600">{currentStatus?.message}</p>
								</div>
							</div>
							{#if currentAnalysis.riskScore.isSiteable}
								<div class="text-right">
									<p class="text-sm text-gray-600">Overall Risk</p>
									<p
										class="text-2xl font-bold"
										style="color: {currentStatus?.color}"
									>
										{currentAnalysis.riskScore.overallRiskPercentage.toFixed(1)}%
									</p>
								</div>
							{:else}
								<div class="text-right">
									<p class="text-sm text-gray-600">Overall Risk</p>
									<p
										class="text-2xl font-bold"
										style="color: {currentStatus?.color}"
									>
										{currentAnalysis.riskScore.overallRiskPercentage.toFixed(1)}%
									</p>
								</div>
							{/if}
						</div>

						<p class="text-gray-700 text-sm mb-4">{currentAnalysis.riskScore.sitingRecommendation}</p>

						<!-- Risk Breakdown -->
						<div class="grid grid-cols-4 gap-3">
							<div class="bg-white bg-opacity-70 rounded p-3 text-center">
								<p class="text-sm font-semibold text-gray-700">Blockers</p>
								<p class="text-2xl font-bold text-red-600">{currentAnalysis.riskScore.blockerCount}</p>
							</div>
							<div class="bg-white bg-opacity-70 rounded p-3 text-center">
								<p class="text-sm font-semibold text-gray-700">Errors</p>
								<p class="text-2xl font-bold text-orange-600">{currentAnalysis.riskScore.errorCount}</p>
							</div>
							<div class="bg-white bg-opacity-70 rounded p-3 text-center">
								<p class="text-sm font-semibold text-gray-700">Warnings</p>
								<p class="text-2xl font-bold text-yellow-600">{currentAnalysis.riskScore.warningCount}</p>
							</div>
							<div class="bg-white bg-opacity-70 rounded p-3 text-center">
								<p class="text-sm font-semibold text-gray-700">Info</p>
								<p class="text-2xl font-bold text-blue-600">{currentAnalysis.riskScore.infoCount}</p>
							</div>
						</div>
					</div>

					<!-- Conflicts List -->
					<div class="bg-white rounded-lg border border-gray-200 p-6">
						<div class="flex justify-between items-center mb-4">
							<h3 class="text-lg font-bold text-gray-900">
								Conflicts Detected ({currentAnalysis.riskScore.totalConflicts})
							</h3>
							<button
								on:click={downloadReport}
								class="px-3 py-2 text-sm bg-gray-100 text-gray-700 rounded hover:bg-gray-200 flex items-center gap-1"
							>
								<svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
									<path
										stroke-linecap="round"
										stroke-linejoin="round"
										stroke-width="2"
										d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"
									/>
								</svg>
								Export CSV
							</button>
						</div>

						<!-- Severity Filter -->
						{#if currentAnalysis.riskScore.totalConflicts > 0}
							<div class="mb-4 flex gap-2 flex-wrap">
								<button
									on:click={() => (expandedSeverityFilter = 'all')}
									class="px-3 py-1 text-sm rounded {expandedSeverityFilter === 'all'
										? 'bg-blue-100 text-blue-700 font-semibold'
										: 'bg-gray-100 text-gray-700 hover:bg-gray-200'}"
								>
									All ({currentAnalysis.riskScore.totalConflicts})
								</button>
								{#each SEVERITY_LEVELS as level}
									{@const count = level.value === 'BLOCKER'
										? currentAnalysis.riskScore.blockerCount
										: level.value === 'ERROR'
											? currentAnalysis.riskScore.errorCount
											: level.value === 'WARNING'
												? currentAnalysis.riskScore.warningCount
												: currentAnalysis.riskScore.infoCount}
									{#if count > 0}
										<button
											on:click={() => (expandedSeverityFilter = level.value)}
											class="px-3 py-1 text-sm rounded {expandedSeverityFilter === level.value
												? 'font-semibold'
												: 'hover:opacity-80'}"
											style="background-color: {level.bgColor}; color: {level.color}"
										>
											{level.label} ({count})
										</button>
									{/if}
								{/each}
							</div>

							<!-- Conflicts Items -->
							<div class="space-y-3">
								{#each sortConflicts(filterConflictsBySeverity(currentAnalysis.conflicts)) as conflict (conflict.conflictId)}
									{@const severityLevel = getSeverityLevel(conflict.severity)}
									<div
										class="border-l-4 rounded p-4"
										style="border-color: {severityLevel?.color}; background-color: {severityLevel?.bgColor}"
									>
										<div class="flex items-start gap-3 mb-2">
											<div
												class="w-8 h-8 rounded-full flex items-center justify-center text-white font-bold text-sm flex-shrink-0"
												style="background-color: {severityLevel?.color}"
											>
												{conflict.severity[0]}
											</div>
											<div class="flex-1">
												<div class="flex items-center gap-2 mb-1">
													<h4 class="font-semibold text-gray-900">{conflict.zoneName}</h4>
													<span
														class="text-xs font-semibold px-2 py-0.5 rounded"
														style="background-color: {severityLevel?.color}20; color: {severityLevel?.color}"
													>
														{conflict.zoneType}
													</span>
												</div>
												<p class="text-sm text-gray-700 mb-2">{conflict.reason}</p>
												{#if conflict.distanceMeters !== undefined && conflict.distanceMeters > 0}
													<p class="text-xs text-gray-600 mb-2">
														<strong>Distance:</strong> {conflict.distanceMeters}m
													</p>
												{/if}
												{#if conflict.mitigationSuggestions.length > 0}
													<div class="mt-3">
														<p class="text-xs font-semibold text-gray-700 mb-1">Mitigation Options:</p>
														<ul class="text-xs text-gray-700 space-y-1">
															{#each conflict.mitigationSuggestions as suggestion}
																<li class="flex gap-2">
																	<span class="text-gray-400">•</span>
																	<span>{suggestion}</span>
																</li>
															{/each}
														</ul>
													</div>
												{/if}
											</div>
										</div>
									</div>
								{/each}
							</div>
						{:else}
							<div class="text-center py-8 bg-green-50 rounded-lg border border-green-200">
								<svg
									class="w-12 h-12 text-green-600 mx-auto mb-3"
									fill="none"
									stroke="currentColor"
									viewBox="0 0 24 24"
								>
									<path
										stroke-linecap="round"
										stroke-linejoin="round"
										stroke-width="2"
										d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
									/>
								</svg>
								<p class="text-green-700 font-semibold">No conflicts detected!</p>
								<p class="text-sm text-green-600">Site is clear for development</p>
							</div>
						{/if}
					</div>

					<!-- Analysis Metadata -->
					<div class="bg-gray-50 rounded-lg p-4 text-xs text-gray-600">
						<p>
							<strong>Analyzed:</strong> {new Date(currentAnalysis.analyzedAt).toLocaleString()}
						</p>
						<p>
							<strong>Site Geometry:</strong>
							{#if currentAnalysis.sitingGeometry.length > 60}
								{currentAnalysis.sitingGeometry.substring(0, 60)}...
								<button
									on:click={() => currentAnalysis && copyGeometryToAnalysis(currentAnalysis.sitingGeometry)}
									class="text-blue-600 hover:underline ml-2"
								>
									copy
								</button>
							{:else}
								{currentAnalysis.sitingGeometry}
							{/if}
						</p>
					</div>
				</div>
			{:else if !showResults}
				<div class="text-center py-16 bg-gray-50 rounded-lg border-2 border-dashed border-gray-300">
					<svg class="w-16 h-16 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
						/>
					</svg>
					<p class="text-gray-500 text-lg font-semibold mb-2">No Analysis Yet</p>
					<p class="text-gray-400">Enter a proposed site geometry and click "Analyze Site" to begin</p>
				</div>
			{/if}
		</div>
	</div>

	<!-- Analysis History -->
	{#if $analyses.length > 0}
		<div class="mt-12">
			<h2 class="text-2xl font-bold text-gray-900 mb-4">Recent Analyses</h2>
			<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
				{#each $analyses.slice(0, 6) as analysis}
					{@const status = getSiteabilityStatus(analysis.riskScore)}
					<button
						on:click={() => {
							currentAnalysis = analysis;
							showResults = true;
						}}
						class="text-left bg-white rounded-lg border border-gray-200 p-4 hover:shadow-lg hover:border-blue-400 transition-all"
					>
						<div class="flex items-center gap-2 mb-2">
							<div
								class="w-4 h-4 rounded-full"
								style="background-color: {status.color}"
							></div>
							<span class="text-xs font-semibold" style="color: {status.color}">{status.status}</span>
						</div>
						<p class="text-sm font-mono text-gray-700 truncate">{analysis.sitingGeometry}</p>
						<p class="text-xs text-gray-500 mt-2">
							{new Date(analysis.analyzedAt).toLocaleDateString()}
						</p>
					</button>
				{/each}
			</div>
		</div>
	{/if}
</div>
