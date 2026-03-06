<script lang="ts">
	import TopBar from '$lib/components/TopBar.svelte';
	import Toolbar from '$lib/components/Toolbar.svelte';
	import InspectorPanel from '$lib/components/InspectorPanel.svelte';
	import CesiumViewer from '$lib/modules/map/CesiumViewer.svelte';
</script>

<svelte:head>
	<title>Solar3D - Solar EPC Design Platform</title>
</svelte:head>

<div class="app-container">
	<TopBar />

	<div class="main-content">
		<div class="toolbar-container">
			<Toolbar />
		</div>

		<div class="map-container">
			<CesiumViewer />
		</div>

		<InspectorPanel />
	</div>
</div>

<style>
	.app-container {
		display: flex;
		flex-direction: column;
		height: 100vh;
		width: 100vw;
		overflow: hidden;
	}

	.main-content {
		display: flex;
		flex: 1;
		position: relative;
		overflow: hidden;
	}

	.toolbar-container {
		position: absolute;
		top: 12px;
		left: 12px;
		z-index: 50;
	}

	.map-container {
		flex: 1;
		position: relative;
	}
</style>
