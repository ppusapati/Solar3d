<script lang="ts">
	/**
	 * SolarPanel3DViewer — photorealistic procedural solar panel using Three.js.
	 *
	 * Renders a fully detailed 60-cell monocrystalline panel with:
	 *  • Aluminum U-channel frame (4 sides)
	 *  • Canvas-generated cell face: monocrystalline cells, busbars, grid fingers, interconnect ribbons
	 *  • Semi-transparent glass overlay (specular)
	 *  • White TPT backsheet
	 *  • Junction box with DC cables
	 *  • Two horizontal mounting rails on the rear
	 *  • Single-post pedestal mount with braces
	 */
	import { onMount } from 'svelte';

	export let widthMm: number = 1000;
	export let heightMm: number = 1650;
	/** Tilt label shown in the header (degrees from horizontal). No effect on geometry. */
	export let tiltDeg: number = 30;

	let container: HTMLDivElement;
	let status = 'Loading 3D viewer…';

	// ─── Canvas texture: monocrystalline cell grid ───────────────────────────

	function buildCellTexture(THREE: any): any {
		const COLS = 6;
		const ROWS = 10;
		const CW = 92; // cell width in canvas px
		const CH = 92; // cell height in canvas px
		const GAP = 4; // gap between cells
		const FRM = 14; // enclosure border
		const TW = COLS * CW + (COLS - 1) * GAP + 2 * FRM; // 648
		const TH = ROWS * CH + (ROWS - 1) * GAP + 2 * FRM; // 984

		const cvs = document.createElement('canvas');
		cvs.width = TW;
		cvs.height = TH;
		const ctx = cvs.getContext('2d')!;

		// Frame / background region
		ctx.fillStyle = '#0e1927';
		ctx.fillRect(0, 0, TW, TH);

		for (let r = 0; r < ROWS; r++) {
			for (let c = 0; c < COLS; c++) {
				const x = FRM + c * (CW + GAP);
				const y = FRM + r * (CH + GAP);

				// ── Cell base: monocrystalline blue-black gradient ──
				const bg = ctx.createLinearGradient(x, y, x + CW, y + CH);
				bg.addColorStop(0, '#172c5e');
				bg.addColorStop(0.45, '#1e4281');
				bg.addColorStop(1, '#0f2148');
				ctx.fillStyle = bg;
				ctx.fillRect(x, y, CW, CH);

				// ── Diamond/grain highlight (characteristic of mono cells) ──
				const shine = ctx.createRadialGradient(
					x + CW * 0.25,
					y + CH * 0.25,
					0,
					x + CW * 0.5,
					y + CH * 0.5,
					CW * 0.75
				);
				shine.addColorStop(0, 'rgba(110,155,220,0.14)');
				shine.addColorStop(0.6, 'rgba(60,100,180,0.04)');
				shine.addColorStop(1, 'rgba(0,0,0,0)');
				ctx.fillStyle = shine;
				ctx.fillRect(x, y, CW, CH);

				// ── 3 horizontal busbars ──
				ctx.strokeStyle = 'rgba(200,220,245,0.9)';
				ctx.lineWidth = 1.8;
				for (let b = 1; b <= 3; b++) {
					const by = y + (b * CH) / 4;
					ctx.beginPath();
					ctx.moveTo(x, by);
					ctx.lineTo(x + CW, by);
					ctx.stroke();
				}

				// ── Grid fingers (thin vertical silver lines) ──
				ctx.strokeStyle = 'rgba(185,210,240,0.22)';
				ctx.lineWidth = 0.5;
				for (let f = 1; f < 9; f++) {
					const fx = x + (f * CW) / 9;
					ctx.beginPath();
					ctx.moveTo(fx, y);
					ctx.lineTo(fx, y + CH);
					ctx.stroke();
				}
			}
		}

		// ── Interconnect ribbons between rows (align with busbars) ──
		ctx.fillStyle = 'rgba(200,220,245,0.78)';
		for (let r = 0; r < ROWS - 1; r++) {
			for (let c = 0; c < COLS; c++) {
				const x = FRM + c * (CW + GAP);
				const gapY = FRM + r * (CH + GAP) + CH;
				for (let b = 1; b <= 3; b++) {
					const rx = x + (b * CW) / 4 - 1.5;
					ctx.fillRect(rx, gapY, 3, GAP);
				}
			}
		}

		const tex = new THREE.CanvasTexture(cvs);
		tex.anisotropy = 4;
		return tex;
	}

	// ─── Procedural panel geometry ────────────────────────────────────────────

	function createSolarPanel(THREE: any, W: number, H: number): any {
		const group = new THREE.Group();

		const D = W * 0.038; // thickness: ~38mm per 1000mm width
		const FW = W * 0.019; // frame flange width: ~19mm

		// ── Materials ──
		const frameMat = new THREE.MeshStandardMaterial({
			color: 0x8d9fae,
			metalness: 0.92,
			roughness: 0.18
		});
		const bodyMat = new THREE.MeshStandardMaterial({ color: 0x0b1420, roughness: 0.9 });
		const cellMat = new THREE.MeshStandardMaterial({
			map: buildCellTexture(THREE),
			metalness: 0.05,
			roughness: 0.42
		});
		const glassMat = new THREE.MeshStandardMaterial({
			color: 0xc8e4f4,
			metalness: 0.08,
			roughness: 0.04,
			transparent: true,
			opacity: 0.16
		});
		const backMat = new THREE.MeshStandardMaterial({ color: 0xdce4ec, roughness: 0.88 });
		const jboxMat = new THREE.MeshStandardMaterial({
			color: 0x1a1f2d,
			roughness: 0.72,
			metalness: 0.12
		});
		const cableMat = new THREE.MeshStandardMaterial({ color: 0x111926, roughness: 0.65 });

		// ── Main structural body ──
		const body = new THREE.Mesh(new THREE.BoxGeometry(W, D, H), bodyMat);
		body.castShadow = true;
		body.receiveShadow = true;
		group.add(body);

		// ── Aluminum frame (4 pieces — U-channel) ──
		// BoxGeometry(W, D, H): X=width, Y=depth/thickness, Z=height
		// Frame pieces are slightly taller than D for a channel look
		const FD = D + 0.004;

		// Left side
		const leftF = new THREE.Mesh(new THREE.BoxGeometry(FW, FD, H + FW * 2), frameMat);
		leftF.position.x = -(W / 2) + FW / 2;
		leftF.castShadow = true;
		group.add(leftF);

		// Right side
		const rightF = leftF.clone();
		rightF.position.x = (W / 2) - FW / 2;
		group.add(rightF);

		// Top
		const topF = new THREE.Mesh(new THREE.BoxGeometry(W - FW * 2, FD, FW), frameMat);
		topF.position.z = -(H / 2) + FW / 2;
		topF.castShadow = true;
		group.add(topF);

		// Bottom
		const botF = topF.clone();
		botF.position.z = (H / 2) - FW / 2;
		group.add(botF);

		// Inner rear lip (creates U-channel silhouette)
		const LIP = FW * 0.38;
		const lipThick = 0.0028;
		const rearLipL = new THREE.Mesh(new THREE.BoxGeometry(LIP, lipThick, H - FW * 2), frameMat);
		rearLipL.position.set(-(W / 2) + LIP / 2, -(D / 2) - lipThick / 2, 0);
		group.add(rearLipL);
		const rearLipR = rearLipL.clone();
		rearLipR.position.x = (W / 2) - LIP / 2;
		group.add(rearLipR);

		// ── Cell face (canvas texture) ──
		// PlaneGeometry in XY, then rotated.x = -PI/2 → lies flat in XZ plane, face = +Y
		const innerW = W - 2 * FW;
		const innerH = H - 2 * FW;

		const cellFace = new THREE.Mesh(new THREE.PlaneGeometry(innerW, innerH), cellMat);
		cellFace.rotation.x = -Math.PI / 2;
		cellFace.position.y = D / 2 + 0.001;
		group.add(cellFace);

		// ── Glass overlay ──
		const glass = new THREE.Mesh(new THREE.PlaneGeometry(innerW, innerH), glassMat);
		glass.rotation.x = -Math.PI / 2;
		glass.position.y = D / 2 + 0.004;
		group.add(glass);

		// ── Rear backsheet ──
		const backsheet = new THREE.Mesh(new THREE.PlaneGeometry(innerW, innerH), backMat);
		backsheet.rotation.x = Math.PI / 2;
		backsheet.position.y = -(D / 2) - 0.001;
		group.add(backsheet);

		// ── Junction box ──
		const jW = W * 0.13;
		const jH = H * 0.055;
		const jD = FW * 2.8;
		const jbox = new THREE.Mesh(new THREE.BoxGeometry(jW, jD, jH), jboxMat);
		jbox.position.set(W * 0.07, -(D / 2) - jD / 2, H * 0.1);
		jbox.castShadow = true;
		group.add(jbox);

		// Conduit connector nubs on the junction box
		for (const side of [-1, 1]) {
			const nub = new THREE.Mesh(
				new THREE.CylinderGeometry(jD * 0.22, jD * 0.22, jD * 0.38, 8),
				jboxMat
			);
			nub.position.set(
				jbox.position.x + (side * jW) / 2,
				jbox.position.y,
				jbox.position.z
			);
			nub.rotation.z = Math.PI / 2;
			group.add(nub);
		}

		// DC cables hanging from junction box
		const cxOffsets = [-jW * 0.28, 0, jW * 0.28];
		for (const cx of cxOffsets) {
			const p0 = new THREE.Vector3(jbox.position.x + cx, -(D / 2) - jD * 1.05, H * 0.1);
			const p1 = new THREE.Vector3(
				jbox.position.x + cx * 0.85,
				-(D / 2) - jD * 1.55,
				H * 0.26
			);
			const p2 = new THREE.Vector3(
				jbox.position.x + cx * 1.3,
				-(D / 2) - jD * 1.1,
				H * 0.42
			);
			const tube = new THREE.Mesh(
				new THREE.TubeGeometry(
					new THREE.CatmullRomCurve3([p0, p1, p2]),
					14,
					W * 0.0055,
					7,
					false
				),
				cableMat
			);
			group.add(tube);
		}

		// ── Mounting rails (rear, horizontal along X) ──
		const RAIL_SZ = W * 0.032;
		const railW = W * 0.84;
		for (const rz of [H * 0.29, -H * 0.29]) {
			const rail = new THREE.Mesh(
				new THREE.BoxGeometry(railW, RAIL_SZ, RAIL_SZ),
				frameMat
			);
			rail.position.set(0, -(D / 2) - RAIL_SZ * 0.5, rz);
			rail.castShadow = true;
			group.add(rail);
		}

		// ── Single-post pedestal mount with cross-arm and braces ──
		const MAST_H = 0.92;
		const MAST_R = W * 0.034;
		const mast = new THREE.Mesh(
			new THREE.CylinderGeometry(MAST_R * 0.92, MAST_R, MAST_H, 18),
			frameMat
		);
		mast.position.set(0, -(D / 2) - RAIL_SZ - MAST_H / 2 + 0.06, 0);
		mast.castShadow = true;
		group.add(mast);

		const saddle = new THREE.Mesh(
			new THREE.BoxGeometry(W * 0.18, RAIL_SZ * 1.15, H * 0.13),
			frameMat
		);
		saddle.position.set(0, -(D / 2) - RAIL_SZ * 0.9, 0);
		saddle.castShadow = true;
		group.add(saddle);

		const braceGeom = new THREE.CylinderGeometry(W * 0.008, W * 0.008, H * 0.55, 10);
		const leftBrace = new THREE.Mesh(braceGeom, frameMat);
		leftBrace.position.set(-W * 0.18, -(D / 2) - RAIL_SZ * 1.85, H * 0.14);
		leftBrace.rotation.z = 0.42;
		leftBrace.rotation.x = -0.32;
		leftBrace.castShadow = true;
		group.add(leftBrace);

		const rightBrace = leftBrace.clone();
		rightBrace.position.x = W * 0.18;
		rightBrace.rotation.z = -0.42;
		group.add(rightBrace);

		// ── Tilt the whole group for a good product-shot viewing angle ──
		// Panel lies in XZ plane (face = +Y). rotation.x = -0.4 tilts ~23° toward camera.
		group.position.y = 1.05;
		group.rotation.x = -0.42;

		return group;
	}

	// ─── Three.js scene setup ─────────────────────────────────────────────────

	onMount(() => {
		let destroyed = false;
		let frameId = 0;
		let cleanup: (() => void) | undefined;

		async function start() {
			const THREE = await import('three');
			const { OrbitControls } = await import(
				'three/examples/jsm/controls/OrbitControls.js'
			);

			if (destroyed || !container) return;

			// Scene
			const scene = new THREE.Scene();
			scene.background = new THREE.Color(0x0b1120);
			scene.fog = new THREE.FogExp2(0x0b1120, 0.06);

			// Camera
			const camera = new THREE.PerspectiveCamera(
				42,
				container.clientWidth / Math.max(container.clientHeight, 1),
				0.05,
				120
			);
			camera.position.set(2.2, 1.6, 2.6);

			// Renderer
			const renderer = new THREE.WebGLRenderer({ antialias: true });
			renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
			renderer.setSize(
				container.clientWidth || 400,
				container.clientHeight || 280
			);
			renderer.outputColorSpace = THREE.SRGBColorSpace;
			renderer.shadowMap.enabled = true;
			renderer.shadowMap.type = THREE.PCFSoftShadowMap;
			container.appendChild(renderer.domElement);

			// Controls
			const controls = new OrbitControls(camera, renderer.domElement);
			controls.enableDamping = true;
			controls.dampingFactor = 0.06;
			controls.minDistance = 0.6;
			controls.maxDistance = 9.0;
			controls.target.set(0, 0.75, 0);
			controls.update();

			// Lighting
			scene.add(new THREE.AmbientLight(0x2e4a6a, 0.75));

			const sun = new THREE.DirectionalLight(0xfff5dd, 2.1);
			sun.position.set(4.5, 8, 3.5);
			sun.castShadow = true;
			sun.shadow.mapSize.set(1024, 1024);
			sun.shadow.camera.near = 0.5;
			sun.shadow.camera.far = 22;
			sun.shadow.camera.left = -4;
			sun.shadow.camera.right = 4;
			sun.shadow.camera.top = 4;
			sun.shadow.camera.bottom = -4;
			scene.add(sun);

			const fill = new THREE.DirectionalLight(0x90b8d8, 0.55);
			fill.position.set(-3.5, 2.5, -2.5);
			scene.add(fill);

			const rim = new THREE.DirectionalLight(0x4488aa, 0.35);
			rim.position.set(0, -2, -4);
			scene.add(rim);

			// Ground
			const ground = new THREE.Mesh(
				new THREE.CircleGeometry(4.5, 72),
				new THREE.MeshStandardMaterial({
					color: 0x192535,
					roughness: 0.93,
					metalness: 0.03
				})
			);
			ground.rotation.x = -Math.PI / 2;
			ground.position.y = -0.01;
			ground.receiveShadow = true;
			scene.add(ground);

			const grid = new THREE.GridHelper(9, 18, 0x1c3050, 0x151f2e);
			grid.position.y = 0.002;
			scene.add(grid);

			// Subtle horizon line
			const horizon = new THREE.Mesh(
				new THREE.RingGeometry(4.2, 4.5, 64),
				new THREE.MeshBasicMaterial({
					color: 0x2a4060,
					side: THREE.DoubleSide,
					transparent: true,
					opacity: 0.5
				})
			);
			horizon.rotation.x = -Math.PI / 2;
			horizon.position.y = 0.003;
			scene.add(horizon);

			// Solar panel
			const panelW = Math.max(0.4, widthMm / 1000);
			const panelH = Math.max(0.4, heightMm / 1000);
			const maxDim = Math.max(panelW, panelH);
			const scale = 1.65 / maxDim;
			const panel = createSolarPanel(THREE, panelW * scale, panelH * scale);
			scene.add(panel);

			// Resize
			const resizeObs = new ResizeObserver(() => {
				if (destroyed || !container) return;
				const w = container.clientWidth;
				const h = Math.max(container.clientHeight, 1);
				camera.aspect = w / h;
				camera.updateProjectionMatrix();
				renderer.setSize(w, h);
			});
			resizeObs.observe(container);

			status = 'Drag to rotate · scroll to zoom';

			function animate() {
				if (destroyed) return;
				controls.update();
				renderer.render(scene, camera);
				frameId = requestAnimationFrame(animate);
			}
			animate();

			return () => {
				destroyed = true;
				cancelAnimationFrame(frameId);
				controls.dispose();
				resizeObs.disconnect();
				renderer.dispose();
				renderer.domElement.remove();
			};
		}

		start().then((fn) => {
			cleanup = fn;
		});

		return () => {
			destroyed = true;
			cleanup?.();
		};
	});
</script>

<div class="spv-root">
	<div class="spv-header">
		<span class="spv-title">Solar Panel — 3D Preview</span>
		<span class="spv-meta">{widthMm} × {heightMm} mm · tilt {tiltDeg}°</span>
	</div>
	<div class="spv-canvas" bind:this={container}></div>
	<div class="spv-status">{status}</div>
</div>

<style>
	.spv-root {
		display: flex;
		flex-direction: column;
		width: 100%;
		height: 100%;
		background: #0b1120;
		border-radius: 8px;
		overflow: hidden;
		font-family: ui-sans-serif, system-ui, sans-serif;
		user-select: none;
	}

	.spv-header {
		display: flex;
		align-items: center;
		justify-content: space-between;
		padding: 7px 14px;
		background: rgba(255 255 255 / 0.04);
		border-bottom: 1px solid rgba(255 255 255 / 0.06);
		flex-shrink: 0;
	}

	.spv-title {
		font-size: 11.5px;
		font-weight: 600;
		color: #8fbbd8;
		letter-spacing: 0.04em;
		text-transform: uppercase;
	}

	.spv-meta {
		font-size: 10.5px;
		color: #445a6e;
	}

	.spv-canvas {
		flex: 1;
		min-height: 0;
		width: 100%;
	}

	.spv-status {
		padding: 5px 14px;
		font-size: 10px;
		color: #38526a;
		background: rgba(255 255 255 / 0.02);
		text-align: center;
		flex-shrink: 0;
	}
</style>
