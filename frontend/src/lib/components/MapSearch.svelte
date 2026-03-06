<script lang="ts">
	import { createEventDispatcher } from 'svelte';

	const dispatch = createEventDispatcher<{
		flyTo: { longitude: number; latitude: number; name: string };
	}>();

	let query = '';
	let results: SearchResult[] = [];
	let isSearching = false;
	let showResults = false;

	interface SearchResult {
		name: string;
		latitude: number;
		longitude: number;
		type: string;
	}

	// Common solar farm locations for quick access
	const quickLocations: SearchResult[] = [
		{ name: 'Mojave Desert, CA', latitude: 35.0, longitude: -117.5, type: 'region' },
		{ name: 'Phoenix, AZ', latitude: 33.45, longitude: -112.07, type: 'city' },
		{ name: 'Las Vegas, NV', latitude: 36.17, longitude: -115.14, type: 'city' },
		{ name: 'Rajasthan, India', latitude: 26.9, longitude: 70.9, type: 'region' },
		{ name: 'Atacama, Chile', latitude: -23.5, longitude: -68.5, type: 'region' },
		{ name: 'Dubai, UAE', latitude: 24.96, longitude: 55.18, type: 'city' }
	];

	async function handleSearch() {
		if (!query.trim()) {
			results = quickLocations;
			showResults = true;
			return;
		}

		isSearching = true;
		showResults = true;

		try {
			// Use Nominatim OpenStreetMap geocoding (free, no API key)
			const response = await fetch(
				`https://nominatim.openstreetmap.org/search?format=json&q=${encodeURIComponent(query)}&limit=5`,
				{ headers: { 'Accept-Language': 'en' } }
			);
			const data = await response.json();
			results = data.map((r: any) => ({
				name: r.display_name.split(',').slice(0, 3).join(','),
				latitude: parseFloat(r.lat),
				longitude: parseFloat(r.lon),
				type: r.type
			}));
		} catch {
			// Fallback: filter quick locations
			results = quickLocations.filter(
				(l) => l.name.toLowerCase().includes(query.toLowerCase())
			);
		} finally {
			isSearching = false;
		}
	}

	function selectResult(result: SearchResult) {
		query = result.name;
		showResults = false;
		dispatch('flyTo', { longitude: result.longitude, latitude: result.latitude, name: result.name });
	}

	function handleFocus() {
		if (!query.trim()) {
			results = quickLocations;
		}
		showResults = true;
	}

	function handleBlur() {
		// Delay to allow click on results
		setTimeout(() => { showResults = false; }, 200);
	}

	function handleKeydown(e: KeyboardEvent) {
		if (e.key === 'Enter') {
			handleSearch();
		} else if (e.key === 'Escape') {
			showResults = false;
		}
	}
</script>

<div class="search-container">
	<div class="search-input-wrapper">
		<span class="search-icon">Q</span>
		<input
			type="text"
			bind:value={query}
			on:input={handleSearch}
			on:focus={handleFocus}
			on:blur={handleBlur}
			on:keydown={handleKeydown}
			placeholder="Search location..."
			class="search-input"
		/>
		{#if isSearching}
			<span class="spinner"></span>
		{/if}
	</div>

	{#if showResults && results.length > 0}
		<div class="search-results">
			{#if !query.trim()}
				<div class="results-header">Popular Solar Locations</div>
			{/if}
			{#each results as result}
				<button class="result-item" on:mousedown={() => selectResult(result)}>
					<span class="result-name">{result.name}</span>
					<span class="result-coords">
						{result.latitude.toFixed(2)}, {result.longitude.toFixed(2)}
					</span>
				</button>
			{/each}
		</div>
	{/if}
</div>

<style>
	.search-container {
		position: relative;
		width: 280px;
	}

	.search-input-wrapper {
		display: flex;
		align-items: center;
		gap: 8px;
		padding: 6px 12px;
		background: rgba(22, 33, 62, 0.95);
		border-radius: 8px;
		border: 1px solid rgba(255, 255, 255, 0.1);
		backdrop-filter: blur(8px);
	}

	.search-icon {
		color: #64748b;
		font-size: 12px;
		font-weight: 700;
	}

	.search-input {
		flex: 1;
		border: none;
		background: transparent;
		color: #e2e8f0;
		font-size: 13px;
		font-family: inherit;
		outline: none;
	}

	.search-input::placeholder {
		color: #64748b;
	}

	.spinner {
		width: 14px;
		height: 14px;
		border: 2px solid rgba(255, 255, 255, 0.1);
		border-top-color: #f59e0b;
		border-radius: 50%;
		animation: spin 0.6s linear infinite;
	}

	@keyframes spin {
		to { transform: rotate(360deg); }
	}

	.search-results {
		position: absolute;
		top: 100%;
		left: 0;
		right: 0;
		margin-top: 4px;
		background: rgba(22, 33, 62, 0.98);
		border-radius: 8px;
		border: 1px solid rgba(255, 255, 255, 0.1);
		overflow: hidden;
		z-index: 100;
		max-height: 280px;
		overflow-y: auto;
		backdrop-filter: blur(8px);
	}

	.results-header {
		padding: 8px 12px;
		font-size: 10px;
		font-weight: 600;
		color: #64748b;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		border-bottom: 1px solid rgba(255, 255, 255, 0.05);
	}

	.result-item {
		display: flex;
		align-items: center;
		justify-content: space-between;
		width: 100%;
		padding: 8px 12px;
		border: none;
		background: transparent;
		color: #e2e8f0;
		font-size: 12px;
		cursor: pointer;
		text-align: left;
	}

	.result-item:hover {
		background: rgba(245, 158, 11, 0.1);
	}

	.result-name {
		flex: 1;
		white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
	}

	.result-coords {
		color: #64748b;
		font-size: 10px;
		flex-shrink: 0;
		margin-left: 8px;
	}
</style>
