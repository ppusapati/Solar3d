<script lang="ts">
	import { onMount } from 'svelte';
	import { writable } from 'svelte/store';
	import { constraintApi } from '$lib/core/api/constraint';
	import { toast } from '$lib/core/stores/toast';
	import { confirm as confirmModal } from '$lib/core/stores/confirm';
	import { structuredLog } from '$lib/core/error-handling';

	interface Zone {
		zoneId: string;
		name: string;
		description: string;
		zoneType: 'EXCLUSION' | 'INCLUSION' | 'BUFFER';
		zoneCategory: string;
		geometryWkt: string;
		bufferDistanceM?: number;
		zoneStatus: 'ACTIVE' | 'INACTIVE' | 'EXPIRED' | 'PENDING';
		effectiveStartAt?: string;
		effectiveEndAt?: string;
		isPublic: boolean;
		tags: string[];
		createdAt: string;
		createdBy: string;
	}

	interface ZoneFilter {
		projectId: string;
		zoneType?: string;
		category?: string;
		status?: string;
		searchText?: string;
	}

	// State management
	const zones = writable<Zone[]>([]);
	const filters = writable<ZoneFilter>({
		projectId: 'dev-solar-1',
		zoneType: '',
		category: '',
		status: 'ACTIVE'
	});

	let filteredZones: Zone[] = [];
	let showForm = false;
	let selectedZone: Zone | null = null;
	let isEditing = false;
	let hoveredZoneId: string | null = null;
	let sortBy: 'name' | 'created' | 'modified' = 'created';
	let ascending = false;

	// Form fields
	let zoneName = '';
	let zoneType: 'EXCLUSION' | 'INCLUSION' | 'BUFFER' = 'EXCLUSION';
	let zoneCategory = 'ENVIRONMENTAL';
	let zoneStatus: 'ACTIVE' | 'INACTIVE' | 'EXPIRED' | 'PENDING' = 'ACTIVE';
	let geometryWkt = '';
	let bufferDistance = 500;
	let description = '';
	let isPublic = false;
	let tagsInput = '';

	// Constants
	const ZONE_TYPES: Array<{ value: Zone['zoneType']; label: string; color: string }> = [
		{ value: 'EXCLUSION', label: 'Exclusion (No Site)', color: '#ef4444' },
		{ value: 'INCLUSION', label: 'Inclusion (Site Required)', color: '#22c55e' },
		{ value: 'BUFFER', label: 'Buffer (Distance Required)', color: '#f59e0b' }
	];

	const ZONE_CATEGORIES = [
		'GEOLOGICAL',
		'ENVIRONMENTAL',
		'REGULATORY',
		'INFRASTRUCTURE',
		'MILITARY',
		'PROTECTED'
	];

	const STATUSES: Array<{
		value: Zone['zoneStatus'];
		label: string;
		badge: 'success' | 'secondary' | 'warning' | 'danger';
	}> = [
		{ value: 'ACTIVE', label: 'Active', badge: 'success' },
		{ value: 'INACTIVE', label: 'Inactive', badge: 'secondary' },
		{ value: 'PENDING', label: 'Pending', badge: 'warning' },
		{ value: 'EXPIRED', label: 'Expired', badge: 'danger' }
	];

	const SORT_OPTIONS: Array<'name' | 'created' | 'modified'> = ['name', 'created', 'modified'];

	// Lifecycle
	onMount(async () => {
		loadZones();
	});

	// Subscribe to stores
	zones.subscribe((z) => {
		updateFilteredZones();
	});

	filters.subscribe(() => {
		updateFilteredZones();
	});

	function protoZoneToUi(z: any): Zone {
		return {
			zoneId: z.zoneId,
			name: z.name,
			description: z.description ?? '',
			zoneType: zoneTypeFromProto(z.zoneType),
			zoneCategory: zoneCategoryFromProto(z.zoneCategory),
			geometryWkt: z.geometryWkt ?? '',
			bufferDistanceM: z.bufferDistanceM,
			zoneStatus: zoneStatusFromProto(z.zoneStatus),
			effectiveStartAt: z.effectiveStartAt,
			effectiveEndAt: z.effectiveEndAt,
			isPublic: !!z.isPublic,
			tags: z.tags ?? [],
			createdAt: z.createdAt,
			createdBy: z.createdBy ?? ''
		};
	}

	function zoneTypeFromProto(v: number | string): Zone['zoneType'] {
		const s = typeof v === 'number' ? ['UNSPECIFIED', 'EXCLUSION', 'INCLUSION', 'BUFFER'][v] : String(v);
		return (s === 'INCLUSION' || s === 'BUFFER' ? s : 'EXCLUSION') as Zone['zoneType'];
	}
	function zoneStatusFromProto(v: number | string): Zone['zoneStatus'] {
		const s = typeof v === 'number'
			? ['UNSPECIFIED', 'ACTIVE', 'INACTIVE', 'EXPIRED', 'PENDING'][v]
			: String(v);
		return (['ACTIVE', 'INACTIVE', 'EXPIRED', 'PENDING'].includes(s) ? s : 'ACTIVE') as Zone['zoneStatus'];
	}
	function zoneCategoryFromProto(v: number | string): string {
		if (typeof v === 'string') return v;
		return ['UNSPECIFIED', 'ENVIRONMENTAL', 'REGULATORY', 'INFRASTRUCTURE', 'CULTURAL', 'ECONOMIC', 'OTHER'][v] ?? 'OTHER';
	}

	// Zone loading and filtering
	async function loadZones() {
		try {
			const resp = await constraintApi.list({ projectId: $filters.projectId, limit: 200 });
			zones.set((resp.zones ?? []).map(protoZoneToUi));
		} catch (error) {
			structuredLog('error', 'constraint_zones.load', { error: String(error), projectId: $filters.projectId });
			toast.error('Failed to load constraint zones');
			zones.set([]);
		}
	}

	function updateFilteredZones() {
		let result = $zones;

		const currentFilter = $filters;

		if (currentFilter.zoneType) {
			result = result.filter((z) => z.zoneType === currentFilter.zoneType);
		}

		if (currentFilter.category) {
			result = result.filter((z) => z.zoneCategory === currentFilter.category);
		}

		if (currentFilter.status) {
			result = result.filter((z) => z.zoneStatus === currentFilter.status);
		}

		if (currentFilter.searchText) {
			const search = currentFilter.searchText.toLowerCase();
			result = result.filter(
				(z) =>
					z.name.toLowerCase().includes(search) ||
					z.description.toLowerCase().includes(search) ||
					z.tags.some((t) => t.toLowerCase().includes(search))
			);
		}

		// Sort
		result.sort((a, b) => {
			let comparison = 0;
			switch (sortBy) {
				case 'name':
					comparison = a.name.localeCompare(b.name);
					break;
				case 'created':
					comparison = new Date(a.createdAt).getTime() - new Date(b.createdAt).getTime();
					break;
				case 'modified':
					comparison = 0; // Would use updatedAt in real implementation
					break;
			}
			return ascending ? comparison : -comparison;
		});

		filteredZones = result;
	}

	// Zone operations
	function openCreateForm() {
		showForm = true;
		isEditing = false;
		selectedZone = null;
		resetForm();
	}

	function openEditForm(zone: Zone) {
		showForm = true;
		isEditing = true;
		selectedZone = zone;
		zoneName = zone.name;
		zoneType = zone.zoneType;
		zoneCategory = zone.zoneCategory;
		zoneStatus = zone.zoneStatus;
		geometryWkt = zone.geometryWkt;
		bufferDistance = zone.bufferDistanceM || 500;
		description = zone.description;
		isPublic = zone.isPublic;
		tagsInput = zone.tags.join(', ');
	}

	function closeForm() {
		showForm = false;
		selectedZone = null;
		resetForm();
	}

	function resetForm() {
		zoneName = '';
		zoneType = 'EXCLUSION';
		zoneCategory = 'ENVIRONMENTAL';
		zoneStatus = 'ACTIVE';
		geometryWkt = '';
		bufferDistance = 500;
		description = '';
		isPublic = false;
		tagsInput = '';
	}

	async function submitForm() {
		if (!zoneName || !geometryWkt) {
			toast.warning('Name and geometry are required');
			return;
		}

		const tags = tagsInput.split(',').map((t) => t.trim()).filter(Boolean);

		try {
			if (isEditing && selectedZone) {
				await constraintApi.update({
					zoneId: selectedZone.zoneId,
					name: zoneName,
					description,
					zoneType: zoneType as never,
					zoneCategory: zoneCategory as never,
					geometryWkt,
					bufferDistanceMeters: zoneType === 'BUFFER' ? bufferDistance : undefined,
					zoneStatus: zoneStatus as never,
					isPublic,
					tags
				});
				toast.success(`Zone "${zoneName}" updated`);
			} else {
				await constraintApi.create({
					projectId: $filters.projectId,
					name: zoneName,
					description,
					zoneType: zoneType as never,
					zoneCategory: zoneCategory as never,
					geometryWkt,
					bufferDistanceMeters: zoneType === 'BUFFER' ? bufferDistance : undefined,
					isPublic,
					tags
				});
				toast.success(`Zone "${zoneName}" created`);
			}
			closeForm();
			await loadZones();
		} catch (error) {
			structuredLog('error', 'constraint_zones.save', { error: String(error), name: zoneName });
			toast.error(`Failed to save zone: ${error instanceof Error ? error.message : 'unknown error'}`);
		}
	}

	async function deleteZone(zoneId: string) {
		const ok = await confirmModal({
			title: 'Delete this zone?',
			body: 'The zone will be removed from siting analysis. This cannot be undone.',
			confirmLabel: 'Delete',
			danger: true
		});
		if (!ok) return;

		try {
			await constraintApi.delete(zoneId);
			toast.success('Zone deleted');
			await loadZones();
		} catch (error) {
			structuredLog('error', 'constraint_zones.delete', { error: String(error), zoneId });
			toast.error('Failed to delete zone');
		}
	}

	function getZoneTypeColor(type: string): string {
		return ZONE_TYPES.find((t) => t.value === type)?.color || '#gray';
	}

	function formatDate(dateString: string): string {
		return new Date(dateString).toLocaleDateString('en-US', {
			month: 'short',
			day: 'numeric',
			year: 'numeric'
		});
	}
</script>

<div class="constraint-zone-manager p-6 max-w-7xl mx-auto">
	<div class="mb-8">
		<div class="flex justify-between items-center mb-6">
			<div>
				<h1 class="text-3xl font-bold text-gray-900 mb-2">Constraint Zone Management</h1>
				<p class="text-gray-600">
					Create and manage exclusion, inclusion, and buffer zones for land siting analysis
				</p>
			</div>
			<button
				on:click={openCreateForm}
				class="px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-semibold flex items-center gap-2"
			>
				<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
				</svg>
				New Zone
			</button>
		</div>

		<!-- Filters -->
		<div class="grid grid-cols-1 md:grid-cols-4 gap-4">
			<div>
				<label class="block text-sm font-medium text-gray-700 mb-2">Zone Type</label>
				<select
					bind:value={$filters.zoneType}
					class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
				>
					<option value="">All Types</option>
					{#each ZONE_TYPES as type}
						<option value={type.value}>{type.label}</option>
					{/each}
				</select>
			</div>

			<div>
				<label class="block text-sm font-medium text-gray-700 mb-2">Category</label>
				<select
					bind:value={$filters.category}
					class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
				>
					<option value="">All Categories</option>
					{#each ZONE_CATEGORIES as cat}
						<option value={cat}>{cat}</option>
					{/each}
				</select>
			</div>

			<div>
				<label class="block text-sm font-medium text-gray-700 mb-2">Status</label>
				<select
					bind:value={$filters.status}
					class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
				>
					<option value="">All Statuses</option>
					{#each STATUSES as s}
						<option value={s.value}>{s.label}</option>
					{/each}
				</select>
			</div>

			<div>
				<label class="block text-sm font-medium text-gray-700 mb-2">Search</label>
				<input
					type="text"
					placeholder="Zone name, description, tags..."
					on:input={(e) => ($filters.searchText = e.currentTarget.value)}
					class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
				/>
			</div>
		</div>

		<!-- Sort Controls -->
		<div class="mt-4 flex items-center gap-4">
			<span class="text-sm text-gray-600">Sort by:</span>
			<div class="flex gap-2">
				{#each SORT_OPTIONS as sort}
					<button
						on:click={() => {
							if (sortBy === sort) {
								ascending = !ascending;
							} else {
								sortBy = sort;
								ascending = false;
							}
							updateFilteredZones();
						}}
						class="px-3 py-1 text-sm rounded {sortBy === sort
							? 'bg-blue-100 text-blue-700 font-semibold'
							: 'bg-gray-100 text-gray-700 hover:bg-gray-200'}"
					>
						{sort}
						{#if sortBy === sort}
							<span>{ascending ? '▲' : '▼'}</span>
						{/if}
					</button>
				{/each}
			</div>
			<span class="text-sm text-gray-600 ml-auto">{filteredZones.length} zones</span>
		</div>
	</div>

	<!-- Zones List -->
	<div class="space-y-3">
		{#if filteredZones.length === 0}
			<div class="text-center py-12 bg-gray-50 rounded-lg">
				<svg class="w-12 h-12 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
				</svg>
				<p class="text-gray-500">No zones found matching your filters</p>
			</div>
		{:else}
			{#each filteredZones as zone (zone.zoneId)}
				<div
					class="bg-white rounded-lg border border-gray-200 p-4 hover:shadow-lg transition-shadow"
					on:mouseenter={() => (hoveredZoneId = zone.zoneId)}
					on:mouseleave={() => (hoveredZoneId = null)}
				>
					<div class="flex items-start justify-between">
						<div class="flex-1">
							<div class="flex items-center gap-3 mb-2">
								<div
									class="w-3 h-3 rounded-full"
									style="background-color: {getZoneTypeColor(zone.zoneType)}"
								/>
								<h3 class="text-lg font-semibold text-gray-900">{zone.name}</h3>
								{#if zone.zoneStatus === 'EXPIRED'}
									<span class="inline-block px-2 py-1 bg-red-100 text-red-700 text-xs font-semibold rounded">
										EXPIRED
									</span>
								{:else if zone.zoneStatus === 'PENDING'}
									<span class="inline-block px-2 py-1 bg-yellow-100 text-yellow-700 text-xs font-semibold rounded">
										PENDING
									</span>
								{:else if zone.zoneStatus === 'INACTIVE'}
									<span class="inline-block px-2 py-1 bg-gray-100 text-gray-700 text-xs font-semibold rounded">
										INACTIVE
									</span>
								{:else}
									<span class="inline-block px-2 py-1 bg-green-100 text-green-700 text-xs font-semibold rounded">
										ACTIVE
									</span>
								{/if}
							</div>

							<p class="text-gray-600 text-sm mb-3">{zone.description}</p>

							<div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-sm">
								<div>
									<span class="text-gray-500">Type</span>
									<p class="font-medium text-gray-900">
										{ZONE_TYPES.find((t) => t.value === zone.zoneType)?.label}
									</p>
								</div>
								<div>
									<span class="text-gray-500">Category</span>
									<p class="font-medium text-gray-900">{zone.zoneCategory}</p>
								</div>
								{#if zone.bufferDistanceM}
									<div>
										<span class="text-gray-500">Buffer Distance</span>
										<p class="font-medium text-gray-900">{zone.bufferDistanceM}m</p>
									</div>
								{/if}
								<div>
									<span class="text-gray-500">Created</span>
									<p class="font-medium text-gray-900">{formatDate(zone.createdAt)}</p>
								</div>
							</div>

							{#if zone.tags.length > 0}
								<div class="mt-3 flex flex-wrap gap-2">
									{#each zone.tags as tag}
										<span class="inline-block px-2 py-1 bg-blue-50 text-blue-700 text-xs rounded">
											{tag}
										</span>
									{/each}
								</div>
							{/if}
						</div>

						<!-- Actions -->
						<div
							class="flex gap-2 ml-4 {hoveredZoneId === zone.zoneId ? 'opacity-100' : 'opacity-0'} transition-opacity"
						>
							<button
								on:click={() => openEditForm(zone)}
								class="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition-colors"
								title="Edit zone"
							>
								<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
								</svg>
							</button>
							<button
								on:click={() => deleteZone(zone.zoneId)}
								class="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
								title="Delete zone"
							>
								<svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
								</svg>
							</button>
						</div>
					</div>
				</div>
			{/each}
		{/if}
	</div>

	<!-- Modal Form -->
	{#if showForm}
		<div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
			<div class="bg-white rounded-lg shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
				<div class="sticky top-0 px-6 py-4 border-b border-gray-200 bg-white flex justify-between items-center">
					<h2 class="text-xl font-bold text-gray-900">
						{isEditing ? 'Edit Zone' : 'Create New Zone'}
					</h2>
					<button
						on:click={closeForm}
						class="text-gray-500 hover:text-gray-700"
					>
						<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
						</svg>
					</button>
				</div>

				<div class="px-6 py-4 space-y-4">
					<!-- Zone Name -->
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-1">Zone Name *</label>
						<input
							type="text"
							bind:value={zoneName}
							placeholder="e.g., Protected Habitat Zone"
							class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
						/>
					</div>

					<!-- Description -->
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
						<textarea
							bind:value={description}
							placeholder="Describe the zone and why it restricts siting..."
							rows="3"
							class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
						/>
					</div>

					<!-- Zone Type -->
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-2">Zone Type *</label>
						<div class="grid grid-cols-3 gap-3">
							{#each ZONE_TYPES as type}
								<button
									on:click={() => (zoneType = type.value)}
									class="p-3 text-left border-2 rounded-lg transition-colors {zoneType === type.value
										? 'border-blue-600 bg-blue-50'
										: 'border-gray-200 hover:border-gray-300'}"
								>
									<div class="flex items-center mb-2">
										<div class="w-3 h-3 rounded-full mr-2" style="background-color: {type.color}" />
										<span class="font-semibold text-gray-900">{type.label}</span>
									</div>
									<span class="text-xs text-gray-600">
										{#if type.value === 'EXCLUSION'}
											Site placement prohibited
										{:else if type.value === 'INCLUSION'}
											Site must be within zone
										{:else}
											Distance requirement applies
										{/if}
									</span>
								</button>
							{/each}
						</div>
					</div>

					<!-- Category -->
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-1">Category</label>
						<select
							bind:value={zoneCategory}
							class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
						>
							{#each ZONE_CATEGORIES as cat}
								<option value={cat}>{cat}</option>
							{/each}
						</select>
					</div>

					<!-- Geometry -->
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-1">Geometry (WKT) *</label>
						<textarea
							bind:value={geometryWkt}
							placeholder="e.g., POLYGON((-118.5 35.2, -118.4 35.2, -118.4 35.3, -118.5 35.3, -118.5 35.2))"
							rows="3"
							class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent text-xs font-mono"
						/>
						<p class="mt-1 text-xs text-gray-500">Well-Known Text (WKT) format for spatial geometry</p>
					</div>

					<!-- Buffer Distance -->
					{#if zoneType === 'BUFFER'}
						<div>
							<label class="block text-sm font-medium text-gray-700 mb-1">Buffer Distance (meters)</label>
							<input
								type="number"
								bind:value={bufferDistance}
								min="1"
								max="100000"
								class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
							/>
						</div>
					{/if}

					<!-- Status -->
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-1">Status</label>
						<select
							bind:value={zoneStatus}
							class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
						>
							{#each STATUSES as s}
								<option value={s.value}>{s.label}</option>
							{/each}
						</select>
					</div>

					<!-- Tags -->
					<div>
						<label class="block text-sm font-medium text-gray-700 mb-1">Tags (comma-separated)</label>
						<input
							type="text"
							bind:value={tagsInput}
							placeholder="e.g., habitat, protected, critical"
							class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
						/>
					</div>

					<!-- Public -->
					<div class="flex items-center">
						<input
							type="checkbox"
							bind:checked={isPublic}
							id="isPublic"
							class="w-4 h-4 text-blue-600 rounded focus:ring-2 focus:ring-blue-500"
						/>
						<label for="isPublic" class="ml-2 text-sm text-gray-700">Make zone publicly visible</label>
					</div>
				</div>

				<!-- Form Actions -->
				<div class="sticky bottom-0 px-6 py-4 border-t border-gray-200 bg-gray-50 flex justify-end gap-3">
					<button
						on:click={closeForm}
						class="px-4 py-2 text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50 font-medium"
					>
						Cancel
					</button>
					<button
						on:click={submitForm}
						class="px-6 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium"
					>
						{isEditing ? 'Update Zone' : 'Create Zone'}
					</button>
				</div>
			</div>
		</div>
	{/if}
</div>
