<script lang="ts">
	import { onMount, onDestroy } from 'svelte';
	import { camera, isMapReady, viewport } from '$lib/core/stores';

	export let satelliteEnabled = true;
	export let terrainEnabled = true;

	let container: HTMLDivElement;
	let viewer: any;
	let streetImageryLayer: any;
	let satelliteImageryLayer: any;
	let satelliteImageryHealthy = true;
	let satelliteImageryAvailable = false;
	let terrainAvailable = false;
	let defaultTerrainProvider: any;
	let flatTerrainProvider: any;
	let resizeObserver: ResizeObserver;
	let wheelHandler: ((event: WheelEvent) => void) | null = null;

	function clamp(value: number, min: number, max: number): number {
		return Math.min(max, Math.max(min, value));
	}

	function isFiniteNumber(value: unknown): value is number {
		return typeof value === 'number' && Number.isFinite(value);
	}

	onMount(async () => {
		const Cesium = await import('cesium');
		const ionToken = (import.meta.env.PUBLIC_CESIUM_ION_TOKEN ?? '').trim();
		satelliteImageryAvailable = ionToken.length > 0;
		if (ionToken) {
			Cesium.Ion.defaultAccessToken = ionToken;
		}

		flatTerrainProvider = new Cesium.EllipsoidTerrainProvider();
		defaultTerrainProvider = flatTerrainProvider;
		if (ionToken) {
			try {
				defaultTerrainProvider = await Cesium.createWorldTerrainAsync();
				terrainAvailable = true;
			} catch {
				defaultTerrainProvider = flatTerrainProvider;
				terrainAvailable = false;
			}
		}

		viewer = new Cesium.Viewer(container, {
			terrainProvider: defaultTerrainProvider,
			baseLayerPicker: true,
			geocoder: true,
			homeButton: true,
			sceneModePicker: true,
			navigationHelpButton: false,
			animation: false,
			timeline: false,
			fullscreenButton: true,
			selectionIndicator: true,
			infoBox: true
		});

		// Keep the scene in 3D so camera pitch/rotation are always available.
		viewer.scene.morphTo3D(0);

		// Add imagery provider after viewer creation
		viewer.imageryLayers.removeAll();
		streetImageryLayer = viewer.imageryLayers.addImageryProvider(
			new Cesium.OpenStreetMapImageryProvider({
				url: 'https://tile.openstreetmap.org/',
				maximumLevel: 19
			})
		);
		if (satelliteImageryAvailable) {
			satelliteImageryLayer = viewer.imageryLayers.addImageryProvider(
				new Cesium.UrlTemplateImageryProvider({
					url: 'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
					maximumLevel: 19
				})
			);

			// If the satellite provider fails, automatically fall back to the street layer.
			satelliteImageryLayer.imageryProvider.errorEvent.addEventListener(() => {
				satelliteImageryHealthy = false;
				satelliteImageryLayer.show = false;
				streetImageryLayer.show = true;
			});
		}

		const useSatelliteOnInit = satelliteEnabled && satelliteImageryAvailable && satelliteImageryHealthy;
		streetImageryLayer.show = !useSatelliteOnInit;
		if (satelliteImageryLayer) {
			satelliteImageryLayer.show = useSatelliteOnInit;
		}

		const controller = viewer.scene.screenSpaceCameraController;
		controller.enableRotate = true;
		controller.enableTilt = true;
		controller.enableLook = true;
		controller.minimumZoomDistance = 20;
		controller.maximumZoomDistance = 40000000;

		// Cesium default wheel zoom can be jumpy at low altitudes; override with damped zoom.
		controller.enableZoom = false;
		wheelHandler = (event: WheelEvent) => {
			if (!viewer) return;
			event.preventDefault();
			const height = Math.max(viewer.camera.positionCartographic?.height ?? 1000, 20);
			const step = Math.max(8, height * 0.12);
			if (event.deltaY > 0) {
				viewer.camera.zoomOut(step);
			} else if (event.deltaY < 0) {
				viewer.camera.zoomIn(step);
			}
		};
		container.addEventListener('wheel', wheelHandler, { passive: false });


		// Set initial camera position
		viewer.camera.setView({
			destination: Cesium.Cartesian3.fromDegrees(
				$camera.longitude,
				$camera.latitude,
				$camera.height
			),
			orientation: {
				heading: Cesium.Math.toRadians($camera.heading),
				pitch: Cesium.Math.toRadians($camera.pitch),
				roll: 0
			}
		});

		// Update stores on camera move
		viewer.camera.changed.addEventListener(() => {
			const cartographic = viewer.camera.positionCartographic;
			if (
				!cartographic ||
				!isFiniteNumber(cartographic.longitude) ||
				!isFiniteNumber(cartographic.latitude) ||
				!isFiniteNumber(cartographic.height) ||
				!isFiniteNumber(viewer.camera.heading) ||
				!isFiniteNumber(viewer.camera.pitch)
			) {
				return;
			}

			camera.set({
				longitude: Cesium.Math.toDegrees(cartographic.longitude),
				latitude: Cesium.Math.toDegrees(cartographic.latitude),
				height: cartographic.height,
				heading: Cesium.Math.toDegrees(viewer.camera.heading),
				pitch: Cesium.Math.toDegrees(viewer.camera.pitch),
				roll: 0
			});

			// Update viewport bounds
			const rect = viewer.camera.computeViewRectangle();
			if (rect) {
				if (
					!isFiniteNumber(rect.west) ||
					!isFiniteNumber(rect.south) ||
					!isFiniteNumber(rect.east) ||
					!isFiniteNumber(rect.north)
				) {
					return;
				}

				viewport.set({
					west: Cesium.Math.toDegrees(rect.west),
					south: Cesium.Math.toDegrees(rect.south),
					east: Cesium.Math.toDegrees(rect.east),
					north: Cesium.Math.toDegrees(rect.north)
				});
			}
		});

		isMapReady.set(true);

		// Force the canvas to match the container's actual rendered size,
		// then keep it in sync via ResizeObserver (handles initial flex layout settle + future resizes)
		resizeObserver = new ResizeObserver(() => {
			if (viewer) viewer.resize();
		});
		resizeObserver.observe(container);
	});

	$: if (streetImageryLayer) {
		const useSatellite = satelliteEnabled && satelliteImageryAvailable && satelliteImageryHealthy;
		streetImageryLayer.show = !useSatellite;
		if (satelliteImageryLayer) {
			satelliteImageryLayer.show = useSatellite;
		}
	}

	$: if (viewer && defaultTerrainProvider && flatTerrainProvider) {
		viewer.scene.terrainProvider = terrainEnabled && terrainAvailable ? defaultTerrainProvider : flatTerrainProvider;
	}

	onDestroy(() => {
		if (container && wheelHandler) {
			container.removeEventListener('wheel', wheelHandler);
		}
		resizeObserver?.disconnect();
		if (viewer) {
			viewer.destroy();
		}
	});

	export function getViewer() {
		return viewer;
	}

	export function flyTo(longitude: number, latitude: number, height: number = 5000) {
		if (!viewer) return;
		import('cesium').then((Cesium) => {
			viewer.camera.flyTo({
				destination: Cesium.Cartesian3.fromDegrees(longitude, latitude, height),
				duration: 2
			});
		});
	}

	export function adjustView(deltaHeadingDeg: number, deltaPitchDeg: number) {
		if (!viewer) return;
		import('cesium').then((Cesium) => {
			const current = viewer.camera.positionCartographic;
			if (
				!current ||
				!isFiniteNumber(current.longitude) ||
				!isFiniteNumber(current.latitude) ||
				!isFiniteNumber(current.height) ||
				!isFiniteNumber(viewer.camera.heading) ||
				!isFiniteNumber(viewer.camera.pitch)
			) {
				return;
			}

			const heading = viewer.camera.heading + Cesium.Math.toRadians(deltaHeadingDeg);
			const pitch = clamp(
				viewer.camera.pitch + Cesium.Math.toRadians(deltaPitchDeg),
				Cesium.Math.toRadians(-89),
				Cesium.Math.toRadians(-8)
			);

			viewer.camera.setView({
				destination: Cesium.Cartesian3.fromRadians(current.longitude, current.latitude, current.height),
				orientation: {
					heading,
					pitch,
					roll: 0
				}
			});
		});
	}

	let gpsPinEntity: any = null;

	export function addGpsPin(longitude: number, latitude: number) {
		if (!viewer) return;
		import('cesium').then((Cesium) => {
			if (gpsPinEntity) {
				viewer.entities.remove(gpsPinEntity);
			}
			gpsPinEntity = viewer.entities.add({
				position: Cesium.Cartesian3.fromDegrees(longitude, latitude),
				point: {
					pixelSize: 14,
					color: Cesium.Color.fromCssColorString('#f59e0b'),
					outlineColor: Cesium.Color.WHITE,
					outlineWidth: 2,
					disableDepthTestDistance: Number.POSITIVE_INFINITY
				},
				label: {
					text: 'Project Location',
					font: '13px sans-serif',
					fillColor: Cesium.Color.WHITE,
					outlineColor: Cesium.Color.BLACK,
					outlineWidth: 2,
					style: Cesium.LabelStyle.FILL_AND_OUTLINE,
					pixelOffset: new Cesium.Cartesian2(0, -28),
					disableDepthTestDistance: Number.POSITIVE_INFINITY
				}
			});
		});
	}

	export function removeGpsPin() {
		if (viewer && gpsPinEntity) {
			viewer.entities.remove(gpsPinEntity);
			gpsPinEntity = null;
		}
	}
</script>

<div bind:this={container} class="cesium-container"></div>

<style>
	.cesium-container {
		width: 100%;
		height: 100%;
		position: absolute;
		top: 0;
		left: 0;
	}
</style>
