<script lang="ts">
	import { onMount } from 'svelte';
	import { writable } from 'svelte/store';

	interface UploadJob {
		uploadJobId: string;
		fileName: string;
		status: 'PENDING' | 'PROCESSING' | 'COMPLETED' | 'FAILED';
		featuresProcessed: number;
		totalFeatures: number;
		errorMessage?: string;
		createdAt?: string;
		completedAt?: string;
	}

	interface ImportedGeometry {
		geometryId: string;
		name: string;
		type: 'POINT' | 'LINESTRING' | 'POLYGON' | 'MULTIPOLYGON';
		boundingBox?: {
			minX: number;
			minY: number;
			maxX: number;
			maxY: number;
		};
	}

	// State
	let files: FileList | null = null;
	let isDragging = false;
	let uploadJob: UploadJob | null = null;
	let isUploading = false;
	let progress = 0;
	let uploadError: string | null = null;
	let importedGeometries: ImportedGeometry[] = [];
	let showGeometries = false;

	// Reactive stores
	let statusPolling: ReturnType<typeof setInterval> | null = null;

	// Configuration
	const API_ENDPOINT = import.meta.env.PUBLIC_MONOLITH_URL ?? 'http://127.0.0.1:9191';
	const MAX_FILE_SIZE = 100 * 1024 * 1024; // 100MB
	const ALLOWED_TYPES = ['application/vnd.google-earth.kml+xml', 'application/zip'];

	// Handle file selection
	function handleFileSelect(event: Event) {
		const target = event.target as HTMLInputElement;
		if (target.files) {
			files = target.files;
			validateAndUpload();
		}
	}

	// Handle drag and drop
	function handleDragOver(event: DragEvent) {
		event.preventDefault();
		isDragging = true;
	}

	function handleDragLeave() {
		isDragging = false;
	}

	function handleDrop(event: DragEvent) {
		event.preventDefault();
		isDragging = false;
		if (event.dataTransfer?.files) {
			files = event.dataTransfer.files;
			validateAndUpload();
		}
	}

	// Validation and upload
	async function validateAndUpload() {
		uploadError = null;

		// Validate files
		if (!files || files.length === 0) {
			uploadError = 'No file selected';
			return;
		}

		const file = files[0];

		// Check file type
		const fileName = file.name.toLowerCase();
		if (!fileName.endsWith('.kml') && !fileName.endsWith('.kmz')) {
			uploadError = 'File must be KML or KMZ format';
			return;
		}

		// Check file size
		if (file.size > MAX_FILE_SIZE) {
			uploadError = `File size exceeds 100MB limit (${(file.size / 1024 / 1024).toFixed(2)}MB)`;
			return;
		}

		// Start upload
		await uploadKML(file);
	}

	// Upload KML file
	async function uploadKML(file: File) {
		isUploading = true;
		uploadError = null;
		progress = 0;
		importedGeometries = [];
		showGeometries = false;

		try {
			// Read file as binary
			const fileData = await file.arrayBuffer();

			// Call gRPC endpoint (would use generated proto client in real implementation)
			// For now, we'll simulate the request
			const response = await fetch(`${API_ENDPOINT}/kml.v1.KMLIngestionService/UploadKML`, {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json',
				},
				body: JSON.stringify({
					fileData: Array.from(new Uint8Array(fileData)),
					fileName: file.name,
					sourceCrs: 4326, // WGS84
					tags: {
						source: 'web-upload',
						uploadDate: new Date().toISOString().split('T')[0],
					},
				}),
			});

			if (!response.ok) {
				const error = await response.json();
				throw new Error(error.message || `Upload failed with status ${response.status}`);
			}

			const result = await response.json();
			uploadJob = result;
			progress = 10;

			// Poll for status updates
			startStatusPolling();
		} catch (error) {
			uploadError = error instanceof Error ? error.message : 'Upload failed';
			isUploading = false;
		}
	}

	// Poll upload status
	function startStatusPolling() {
		if (!uploadJob) return;

		const uploadJobId = uploadJob.uploadJobId;

		statusPolling = setInterval(async () => {
			try {
				const response = await fetch(`${API_ENDPOINT}/kml.v1.KMLIngestionService/GetUploadStatus`, {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json',
					},
					body: JSON.stringify({
						uploadJobId,
					}),
				});

				if (!response.ok) {
					throw new Error('Failed to get status');
				}

				const job = await response.json();
				uploadJob = job;

				// Update progress
				if (job.totalFeatures > 0) {
					progress = 10 + (job.featuresProcessed / job.totalFeatures) * 80;
				}

				// Check if complete
				if (job.status === 'COMPLETED') {
					progress = 100;
					stopStatusPolling();
					await loadImportedGeometries();
					isUploading = false;
				} else if (job.status === 'FAILED') {
					uploadError = job.errorMessage || 'Upload failed';
					stopStatusPolling();
					isUploading = false;
				}
			} catch (error) {
				console.error('Status polling error:', error);
			}
		}, 500); // Poll every 500ms
	}

	function stopStatusPolling() {
		if (statusPolling) {
			clearInterval(statusPolling);
			statusPolling = null;
		}
	}

	// Load imported geometries
	async function loadImportedGeometries() {
		if (!uploadJob) return;

		try {
			const response = await fetch(`${API_ENDPOINT}/kml.v1.KMLIngestionService/ListImportedGeometries`, {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json',
				},
				body: JSON.stringify({
					uploadJobId: uploadJob.uploadJobId,
					limit: 100,
					offset: 0,
				}),
			});

			if (response.ok) {
				const result = await response.json();
				importedGeometries = result.geometries || [];
				showGeometries = true;
			}
		} catch (error) {
			console.error('Failed to load geometries:', error);
		}
	}

	// Reset upload
	function resetUpload() {
		files = null;
		uploadJob = null;
		isUploading = false;
		progress = 0;
		uploadError = null;
		importedGeometries = [];
		showGeometries = false;
		stopStatusPolling();
	}

	// Format bytes to human readable
	function formatBytes(bytes: number): string {
		if (bytes === 0) return '0 Bytes';
		const k = 1024;
		const sizes = ['Bytes', 'KB', 'MB'];
		const i = Math.floor(Math.log(bytes) / Math.log(k));
		return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i];
	}

	// Geometry type label
	function getGeometryTypeLabel(type: string): string {
		const labels: Record<string, string> = {
			POINT: '📍 Point',
			LINESTRING: '📏 LineString',
			POLYGON: '🔷 Polygon',
			MULTIPOLYGON: '🔶 MultiPolygon',
		};
		return labels[type] || type;
	}

	onMount(() => {
		return () => {
			stopStatusPolling();
		};
	});
</script>

<div class="w-full max-w-2xl mx-auto p-6">
	<div class="bg-white rounded-lg shadow-lg">
		<!-- Header -->
		<div class="bg-gradient-to-r from-blue-500 to-blue-600 text-white p-6 rounded-t-lg">
			<h1 class="text-3xl font-bold">📁 KML Import</h1>
			<p class="text-blue-100 mt-2">Upload geographic data in KML or KMZ format</p>
		</div>

		<!-- Content -->
		<div class="p-6">
			{#if uploadError}
				<div class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded">
					<h3 class="font-bold mb-1">⚠️ Error</h3>
					<p class="text-sm">{uploadError}</p>
				</div>
			{/if}

			{#if !uploadJob}
				<!-- Upload Area -->
				<div
					class="border-2 border-dashed border-gray-300 rounded-lg p-12 text-center transition-colors cursor-pointer"
					class:border-blue-500={isDragging}
					class:bg-blue-50={isDragging}
					on:dragover={handleDragOver}
					on:dragleave={handleDragLeave}
					on:drop={handleDrop}
					role="presentation"
				>
					<div class="flex flex-col items-center gap-4">
						<div class="text-5xl">📦</div>
						<div>
							<p class="text-lg font-semibold text-gray-700">Drag and drop your KML/KMZ file</p>
							<p class="text-sm text-gray-500 mt-2">or</p>
						</div>
						<label class="inline-block">
							<span class="px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition cursor-pointer font-medium">
								Browse Files
							</span>
							<input
								type="file"
								accept=".kml,.kmz"
								on:change={handleFileSelect}
								class="hidden"
							/>
						</label>
						<p class="text-xs text-gray-400 mt-4">Maximum file size: 100MB</p>
					</div>
				</div>
			{:else if isUploading && uploadJob.status !== 'COMPLETED' && uploadJob.status !== 'FAILED'}
				<!-- Progress -->
				<div class="space-y-4">
					<div class="flex items-center justify-between">
						<h3 class="font-semibold text-gray-700">Uploading: {uploadJob.fileName}</h3>
						<span class="text-sm text-gray-500">{Math.round(progress)}%</span>
					</div>
					<div class="w-full bg-gray-200 rounded-full h-3 overflow-hidden">
						<div
							class="bg-gradient-to-r from-blue-500 to-blue-600 h-full rounded-full transition-all duration-300"
							style="width: {progress}%"
						></div>
					</div>

					{#if uploadJob.totalFeatures > 0}
						<div class="text-sm text-gray-600">
							<span class="font-medium">{uploadJob.featuresProcessed}</span> of
							<span class="font-medium">{uploadJob.totalFeatures}</span> features processed
						</div>
					{/if}

					<div class="text-xs text-gray-500 mt-4">
						Status: <span class="font-semibold capitalize">{uploadJob.status.toLowerCase()}</span>
					</div>
				</div>
			{:else if uploadJob.status === 'COMPLETED'}
				<!-- Completed -->
				<div class="space-y-6">
					<div class="p-4 bg-green-50 border-l-4 border-green-500 text-green-700 rounded">
						<h3 class="font-bold mb-2">✅ Upload Successful</h3>
						<div class="text-sm space-y-1">
							<p><strong>File:</strong> {uploadJob.fileName}</p>
							<p><strong>Features:</strong> {uploadJob.totalFeatures}</p>
							<p><strong>Imported:</strong> {uploadJob.featuresProcessed}</p>
						</div>
					</div>

					{#if showGeometries && importedGeometries.length > 0}
						<div>
							<h3 class="font-semibold text-gray-700 mb-4">📍 Imported Geometries</h3>
							<div class="grid grid-cols-1 md:grid-cols-2 gap-3 max-h-96 overflow-y-auto">
								{#each importedGeometries as geom (geom.geometryId)}
									<div class="p-3 bg-gray-50 rounded-lg border border-gray-200  hover:bg-gray-100 transition">
										<div class="flex items-start justify-between">
											<div class="flex-1">
												<p class="font-medium text-gray-800 truncate">{geom.name || 'Unnamed'}</p>
												<p class="text-xs text-gray-500 mt-1">
													{getGeometryTypeLabel(geom.type)}
												</p>
											</div>
										</div>
										{#if geom.boundingBox}
											<div class="text-xs text-gray-400 mt-2">
												Bounds: ({geom.boundingBox.minX.toFixed(3)}, {geom.boundingBox.minY.toFixed(3)})
										</div>
										{/if}
									</div>
								{/each}
							</div>
						</div>
					{/if}

					<button
						on:click={resetUpload}
						class="w-full px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition font-medium"
					>
						Upload Another File
					</button>
				</div>
			{:else if uploadJob.status === 'FAILED'}
				<!-- Failed -->
				<div class="space-y-4">
					<div class="p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded">
						<h3 class="font-bold mb-2">❌ Upload Failed</h3>
						<p class="text-sm">{uploadJob.errorMessage || 'An unknown error occurred'}</p>
					</div>

					<button
						on:click={resetUpload}
						class="w-full px-6 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition font-medium"
					>
						Try Again
					</button>
				</div>
			{/if}
		</div>

		<!-- Footer -->
		<div class="bg-gray-50 px-6 py-4 rounded-b-lg text-xs text-gray-500 border-t">
			<p>
				💡 <strong>Tip:</strong> KML files must contain valid geometries (Point, LineString, Polygon).
				Supported coordinate systems: WGS84, NAD83, Web Mercator, and UTM zones.
			</p>
		</div>
	</div>
</div>

