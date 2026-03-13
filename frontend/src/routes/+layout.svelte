<script>
	import '../app.css';
	import ErrorBoundary from '$lib/components/ErrorBoundary.svelte';
</script>

<ErrorBoundary fallbackMessage="Something went wrong with Solar3D">
	<slot />
</ErrorBoundary>
