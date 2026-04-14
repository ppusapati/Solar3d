<script lang="ts">
	import KMLUpload from '../../components/KMLUpload.svelte';
</script>

<div class="min-h-screen bg-gradient-to-br from-gray-900 to-gray-800 py-12 px-4">
	<!-- Header -->
	<div class="max-w-6xl mx-auto mb-12">
		<h1 class="text-4xl md:text-5xl font-bold text-white mb-4">🌍 Geospatial Data Import</h1>
		<p class="text-xl text-gray-300">
			Import geographic datasets in KML/KMZ format to your Solar3D project. All data is automatically
			validated and normalized to WGS84.
		</p>
	</div>

	<!-- Main Content -->
	<div class="max-w-6xl mx-auto grid md:grid-cols-3 gap-6">
		<!-- Upload Component -->
		<div class="md:col-span-2">
			<KMLUpload />
		</div>

		<!-- Info Panel -->
		<div class="space-y-4">
			<!-- Supported Formats -->
			<div class="bg-white rounded-lg shadow-lg p-6">
				<h3 class="text-lg font-bold text-gray-800 mb-4">📋 Supported Formats</h3>
				<ul class="space-y-2 text-sm text-gray-600">
					<li class="flex items-start gap-2">
						<span class="text-blue-500 font-bold">✓</span>
						<span><strong>KML</strong> - Keyhole Markup Language</span>
					</li>
					<li class="flex items-start gap-2">
						<span class="text-blue-500 font-bold">✓</span>
						<span><strong>KMZ</strong> - Compressed KML archive</span>
					</li>
				</ul>
			</div>

			<!-- Geometry Types -->
			<div class="bg-white rounded-lg shadow-lg p-6">
				<h3 class="text-lg font-bold text-gray-800 mb-4">🔷 Geometry Types</h3>
				<ul class="space-y-2 text-sm text-gray-600">
					<li class="flex items-center gap-2">
						<span>📍</span>
						<span>Points</span>
					</li>
					<li class="flex items-center gap-2">
						<span>📏</span>
						<span>LineStrings</span>
					</li>
					<li class="flex items-center gap-2">
						<span>🔷</span>
						<span>Polygons</span>
					</li>
					<li class="flex items-center gap-2">
						<span>🔶</span>
						<span>MultiPolygons</span>
					</li>
				</ul>
			</div>

			<!-- Coordinate Systems -->
			<div class="bg-white rounded-lg shadow-lg p-6">
				<h3 class="text-lg font-bold text-gray-800 mb-4">🗺️ Coordinate Systems</h3>
				<ul class="space-y-2 text-xs text-gray-600">
					<li class="flex items-start gap-2">
						<span class="text-green-500">•</span>
						<span><strong>WGS84</strong> (EPSG:4326) - Auto-detected</span>
					</li>
					<li class="flex items-start gap-2">
						<span class="text-green-500">•</span>
						<span><strong>NAD83</strong> (EPSG:4269) - Auto-normalized</span>
					</li>
					<li class="flex items-start gap-2">
						<span class="text-green-500">•</span>
						<span><strong>Web Mercator</strong> (EPSG:3857) - Auto-transformed</span>
					</li>
					<li class="flex items-start gap-2">
						<span class="text-green-500">•</span>
						<span><strong>UTM Zones</strong> (EPSG:326xx) - Auto-converted</span>
					</li>
				</ul>
			</div>

			<!-- Processing Steps -->
			<div class="bg-white rounded-lg shadow-lg p-6">
				<h3 class="text-lg font-bold text-gray-800 mb-4">⚙️ Processing Pipeline</h3>
				<ol class="space-y-3 text-sm text-gray-600">
					<li class="flex gap-3">
						<span class="flex-shrink-0 w-6 h-6 bg-blue-500 text-white rounded-full flex items-center justify-center text-xs font-bold">
							1
						</span>
						<span>Parse KML/KMZ file</span>
					</li>
					<li class="flex gap-3">
						<span class="flex-shrink-0 w-6 h-6 bg-blue-500 text-white rounded-full flex items-center justify-center text-xs font-bold">
							2
						</span>
						<span>Validate geometries</span>
					</li>
					<li class="flex gap-3">
						<span class="flex-shrink-0 w-6 h-6 bg-blue-500 text-white rounded-full flex items-center justify-center text-xs font-bold">
							3
						</span>
						<span>Detect coordinate system</span>
					</li>
					<li class="flex gap-3">
						<span class="flex-shrink-0 w-6 h-6 bg-blue-500 text-white rounded-full flex items-center justify-center text-xs font-bold">
							4
						</span>
						<span>Normalize to WGS84</span>
					</li>
					<li class="flex gap-3">
						<span class="flex-shrink-0 w-6 h-6 bg-blue-500 text-white rounded-full flex items-center justify-center text-xs font-bold">
							5
						</span>
						<span>Store in database</span>
					</li>
				</ol>
			</div>

			<!-- Limits -->
			<div class="bg-blue-50 rounded-lg p-6 border border-blue-200">
				<h3 class="text-lg font-bold text-blue-900 mb-3">📊 Limits & Constraints</h3>
				<ul class="space-y-2 text-sm text-blue-800">
					<li><strong>Max file size:</strong> 100 MB</li>
					<li><strong>Max features:</strong> 100,000</li>
					<li><strong>Max points/geom:</strong> 10,000</li>
					<li><strong>Auto-deduplication:</strong> Enabled</li>
				</ul>
			</div>
		</div>
	</div>
</div>

