<script lang="ts">
	/**
	 * Snapping and alignment system for precise component placement.
	 * Provides grid snapping, entity-to-entity snapping, and alignment guides.
	 */
	import { onDestroy } from 'svelte';
	import { get } from 'svelte/store';
	import { snapEnabled, snapGridVisible, snapGridSizeM, snapDistanceM } from '$lib/core/stores';

	export let viewer: any;
	export let enabled: boolean = true;

	let Cesium: any;
	let guideEntities: any[] = [];

	import('cesium').then((mod) => { Cesium = mod; });

	/**
	 * Snap a position to the nearest grid point.
	 */
	export function snapToGrid(lon: number, lat: number): { longitude: number; latitude: number } {
		const active = enabled && get(snapEnabled);
		if (!active) return { longitude: lon, latitude: lat };
		const gridSizeM = get(snapGridSizeM);

		// Convert grid size from meters to approximate degrees
		const mPerDegLon = 111320 * Math.cos((lat * Math.PI) / 180);
		const mPerDegLat = 111320;

		const gridLon = gridSizeM / mPerDegLon;
		const gridLat = gridSizeM / mPerDegLat;

		return {
			longitude: Math.round(lon / gridLon) * gridLon,
			latitude: Math.round(lat / gridLat) * gridLat
		};
	}

	/**
	 * Snap to nearby entities (panels, components).
	 */
	export function snapToEntity(
		lon: number, lat: number,
		existingPositions: { longitude: number; latitude: number }[]
	): { longitude: number; latitude: number; snapped: boolean } {
		const active = enabled && get(snapEnabled);
		if (!active || existingPositions.length === 0) {
			return { longitude: lon, latitude: lat, snapped: false };
		}
		const snapDistance = get(snapDistanceM);

		const mPerDegLon = 111320 * Math.cos((lat * Math.PI) / 180);
		const mPerDegLat = 111320;
		const thresholdLon = snapDistance / mPerDegLon;
		const thresholdLat = snapDistance / mPerDegLat;

		let closestDist = Infinity;
		let closestPos = { longitude: lon, latitude: lat };

		for (const pos of existingPositions) {
			const dLon = Math.abs(pos.longitude - lon);
			const dLat = Math.abs(pos.latitude - lat);

			if (dLon < thresholdLon && dLat < thresholdLat) {
				const dist = Math.sqrt(
					(dLon * mPerDegLon) ** 2 + (dLat * mPerDegLat) ** 2
				);
				if (dist < closestDist) {
					closestDist = dist;
					closestPos = pos;
				}
			}
		}

		return {
			...closestPos,
			snapped: closestDist < snapDistance
		};
	}

	/**
	 * Show alignment guides between a point and nearby entities.
	 */
	export function showAlignmentGuides(
		lon: number, lat: number,
		existingPositions: { longitude: number; latitude: number }[]
	) {
		clearGuides();
		if (!Cesium || !viewer || !enabled || !get(snapEnabled)) return;

		const mPerDegLon = 111320 * Math.cos((lat * Math.PI) / 180);
		const mPerDegLat = 111320;
		const threshold = 20 / mPerDegLon; // 20m alignment threshold

		for (const pos of existingPositions) {
			// Horizontal alignment
			if (Math.abs(pos.latitude - lat) * mPerDegLat < 1) {
				const guide = viewer.entities.add({
					polyline: {
						positions: [
							Cesium.Cartesian3.fromDegrees(Math.min(lon, pos.longitude) - 0.0001, lat),
							Cesium.Cartesian3.fromDegrees(Math.max(lon, pos.longitude) + 0.0001, lat)
						],
						width: 1,
						material: new Cesium.PolylineDashMaterialProperty({
							color: Cesium.Color.fromCssColorString('#22c55e').withAlpha(0.5),
							dashLength: 8
						}),
						clampToGround: true
					}
				});
				guideEntities.push(guide);
			}

			// Vertical alignment
			if (Math.abs(pos.longitude - lon) * mPerDegLon < 1) {
				const guide = viewer.entities.add({
					polyline: {
						positions: [
							Cesium.Cartesian3.fromDegrees(lon, Math.min(lat, pos.latitude) - 0.0001),
							Cesium.Cartesian3.fromDegrees(lon, Math.max(lat, pos.latitude) + 0.0001)
						],
						width: 1,
						material: new Cesium.PolylineDashMaterialProperty({
							color: Cesium.Color.fromCssColorString('#22c55e').withAlpha(0.5),
							dashLength: 8
						}),
						clampToGround: true
					}
				});
				guideEntities.push(guide);
			}
		}
	}

	export function clearGuides() {
		guideEntities.forEach((e) => {
			if (viewer?.entities?.contains(e)) viewer.entities.remove(e);
		});
		guideEntities = [];
	}

	/**
	 * Render a visual grid overlay on the terrain.
	 */
	export function showGrid(centerLon: number, centerLat: number, extentM: number = 200) {
		clearGuides();
		if (!Cesium || !viewer || !get(snapGridVisible)) return;
		const gridSizeM = get(snapGridSizeM);

		const mPerDegLon = 111320 * Math.cos((centerLat * Math.PI) / 180);
		const mPerDegLat = 111320;

		const gridLon = gridSizeM / mPerDegLon;
		const gridLat = gridSizeM / mPerDegLat;
		const stepsLon = Math.floor(extentM / gridSizeM);
		const stepsLat = Math.floor(extentM / gridSizeM);

		for (let i = -stepsLon; i <= stepsLon; i++) {
			const lon = centerLon + i * gridLon;
			const guide = viewer.entities.add({
				polyline: {
					positions: [
						Cesium.Cartesian3.fromDegrees(lon, centerLat - stepsLat * gridLat),
						Cesium.Cartesian3.fromDegrees(lon, centerLat + stepsLat * gridLat)
					],
					width: 0.5,
					material: Cesium.Color.fromCssColorString('#475569').withAlpha(0.2),
					clampToGround: true
				}
			});
			guideEntities.push(guide);
		}

		for (let i = -stepsLat; i <= stepsLat; i++) {
			const lat = centerLat + i * gridLat;
			const guide = viewer.entities.add({
				polyline: {
					positions: [
						Cesium.Cartesian3.fromDegrees(centerLon - stepsLon * gridLon, lat),
						Cesium.Cartesian3.fromDegrees(centerLon + stepsLon * gridLon, lat)
					],
					width: 0.5,
					material: Cesium.Color.fromCssColorString('#475569').withAlpha(0.2),
					clampToGround: true
				}
			});
			guideEntities.push(guide);
		}
	}

	onDestroy(() => clearGuides());
</script>
