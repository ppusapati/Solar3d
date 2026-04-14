<script lang="ts">
	import { onMount } from 'svelte';
	import { AssetCategory } from '$lib/gen/asset/v1/asset_pb.js';

	export let modelPath = '';
	export let category: AssetCategory = AssetCategory.SOLAR_PANEL;
	export let widthMm = 0;
	export let heightMm = 0;
	export let depthMm = 0;

	let container: HTMLDivElement;
	let status = 'Preparing 3D preview...';
	let hasExternalModel = false;

	function isModelPath(path: string): boolean {
		const normalized = (path || '').trim().toLowerCase();
		return normalized.endsWith('.glb') || normalized.endsWith('.gltf');
	}

	function normalizedSize(value: number, fallback: number): number {
		if (!Number.isFinite(value) || value <= 0) {
			return fallback;
		}
		return Math.max(0.2, value / 1000);
	}

	onMount(() => {
		let destroyed = false;
		let frameId = 0;
		let resizeObserver: ResizeObserver | null = null;

		async function start() {
			const THREE = await import('three');
			const { OrbitControls } = await import('three/examples/jsm/controls/OrbitControls.js');
			const { GLTFLoader } = await import('three/examples/jsm/loaders/GLTFLoader.js');

			if (destroyed || !container) {
				return;
			}

			const scene = new THREE.Scene();
			scene.background = new THREE.Color('#0b1120');

			const camera = new THREE.PerspectiveCamera(45, 1, 0.1, 200);
			camera.position.set(2.6, 1.8, 2.6);

			const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: false });
			renderer.setPixelRatio(Math.min(window.devicePixelRatio || 1, 2));
			renderer.setSize(container.clientWidth || 320, container.clientHeight || 220);
			renderer.outputColorSpace = THREE.SRGBColorSpace;
			container.appendChild(renderer.domElement);

			const controls = new OrbitControls(camera, renderer.domElement);
			controls.enableDamping = true;
			controls.dampingFactor = 0.08;
			controls.minDistance = 0.8;
			controls.maxDistance = 12;
			controls.target.set(0, 0.55, 0);
			controls.update();

			const key = new THREE.DirectionalLight('#f8fafc', 1.1);
			key.position.set(4, 6, 3);
			scene.add(key);
			scene.add(new THREE.AmbientLight('#93c5fd', 0.55));
			const fill = new THREE.DirectionalLight('#fef3c7', 0.45);
			fill.position.set(-3, 2, -2);
			scene.add(fill);

			const floor = new THREE.Mesh(
				new THREE.CircleGeometry(2.6, 48),
				new THREE.MeshStandardMaterial({ color: '#1e293b', roughness: 0.95, metalness: 0.05 })
			);
			floor.rotation.x = -Math.PI / 2;
			floor.position.y = -0.01;
			scene.add(floor);

			const grid = new THREE.GridHelper(5, 10, '#334155', '#1e293b');
			grid.position.y = 0;
			scene.add(grid);

			const fallback = createFallbackModel(THREE);
			scene.add(fallback);

			if (isModelPath(modelPath)) {
				status = 'Loading 3D model...';
				const loader = new GLTFLoader();
				loader.load(
					modelPath,
					(gltf) => {
						if (destroyed) {
							return;
						}
						hasExternalModel = true;
						const model = gltf.scene;
						const box = new THREE.Box3().setFromObject(model);
						const size = box.getSize(new THREE.Vector3());
						const maxSize = Math.max(size.x, size.y, size.z, 0.001);
						const scale = 1.6 / maxSize;
						model.scale.multiplyScalar(scale);
						const centered = new THREE.Box3().setFromObject(model);
						const center = centered.getCenter(new THREE.Vector3());
						model.position.sub(center);
						model.position.y += centered.getSize(new THREE.Vector3()).y / 2;
						scene.add(model);
						fallback.visible = false;
						status = 'Drag to rotate, scroll to zoom';
					},
					undefined,
					() => {
						if (destroyed) {
							return;
						}
						status = 'Using generated 3D proxy. Provide a valid .glb/.gltf path to render the full model.';
					}
				);
			} else {
				status = 'Using generated 3D proxy. Set a .glb/.gltf path for the full model.';
			}

			resizeObserver = new ResizeObserver(() => {
				if (!container || destroyed) {
					return;
				}
				const width = Math.max(200, container.clientWidth);
				const height = Math.max(180, container.clientHeight);
				camera.aspect = width / height;
				camera.updateProjectionMatrix();
				renderer.setSize(width, height);
			});
			resizeObserver.observe(container);

			const animate = () => {
				if (destroyed) {
					return;
				}
				controls.update();
				renderer.render(scene, camera);
				frameId = requestAnimationFrame(animate);
			};
			animate();

			return () => {
				destroyed = true;
				cancelAnimationFrame(frameId);
				controls.dispose();
				resizeObserver?.disconnect();
				renderer.dispose();
				renderer.domElement.remove();
			};
		}

		let cleanup: (() => void) | undefined;
		void start().then((fn) => {
			cleanup = fn;
		});

		return () => {
			destroyed = true;
			cleanup?.();
		};
	});

	function createFallbackModel(THREE: any) {
		const width = normalizedSize(widthMm, 1.6);
		const height = normalizedSize(heightMm, 1.1);
		const depth = normalizedSize(depthMm, 0.15);
		const group = new THREE.Group();

		const metal = new THREE.MeshStandardMaterial({ color: '#94a3b8', metalness: 0.35, roughness: 0.45 });
		const dark = new THREE.MeshStandardMaterial({ color: '#0f172a', metalness: 0.15, roughness: 0.6 });
		const panel = new THREE.MeshStandardMaterial({ color: '#1d4ed8', metalness: 0.15, roughness: 0.35 });
		const accent = new THREE.MeshStandardMaterial({ color: '#f59e0b', metalness: 0.2, roughness: 0.4 });

		switch (category) {
			case AssetCategory.SOLAR_PANEL: {
				// Detailed procedural solar panel
				const W = width;
				const H = height;
				const D = Math.min(W * 0.038, 0.052); // realistic ~38mm thickness
				const FW = W * 0.019; // frame flange width
				const panelGroup = new THREE.Group();

				// Build canvas cell texture
				const COLS = 6, ROWS = 10;
				const CW = 90, CH = 90, GAP = 4, FRM = 12;
				const TW = COLS * CW + (COLS - 1) * GAP + 2 * FRM;
				const TH = ROWS * CH + (ROWS - 1) * GAP + 2 * FRM;
				const cvs = document.createElement('canvas');
				cvs.width = TW; cvs.height = TH;
				const ctx = cvs.getContext('2d')!;
				ctx.fillStyle = '#0e1927';
				ctx.fillRect(0, 0, TW, TH);
				for (let r = 0; r < ROWS; r++) {
					for (let c = 0; c < COLS; c++) {
						const cx = FRM + c * (CW + GAP), cy = FRM + r * (CH + GAP);
						const bg = ctx.createLinearGradient(cx, cy, cx + CW, cy + CH);
						bg.addColorStop(0, '#172c5e'); bg.addColorStop(0.45, '#1e4281'); bg.addColorStop(1, '#0f2148');
						ctx.fillStyle = bg; ctx.fillRect(cx, cy, CW, CH);
						ctx.strokeStyle = 'rgba(200,220,245,0.88)'; ctx.lineWidth = 1.6;
						for (let b = 1; b <= 3; b++) {
							const by = cy + (b * CH) / 4;
							ctx.beginPath(); ctx.moveTo(cx, by); ctx.lineTo(cx + CW, by); ctx.stroke();
						}
						ctx.strokeStyle = 'rgba(185,210,240,0.20)'; ctx.lineWidth = 0.5;
						for (let f = 1; f < 9; f++) {
							const fx = cx + (f * CW) / 9;
							ctx.beginPath(); ctx.moveTo(fx, cy); ctx.lineTo(fx, cy + CH); ctx.stroke();
						}
					}
				}
				ctx.fillStyle = 'rgba(200,220,245,0.76)';
				for (let r = 0; r < ROWS - 1; r++) {
					for (let c = 0; c < COLS; c++) {
						const cx = FRM + c * (CW + GAP), gapY = FRM + r * (CH + GAP) + CH;
						for (let b = 1; b <= 3; b++) { ctx.fillRect(cx + (b * CW) / 4 - 1.5, gapY, 3, GAP); }
					}
				}
				const cellTex = new THREE.CanvasTexture(cvs);
				cellTex.anisotropy = 4;

				// Body
				panelGroup.add(new THREE.Mesh(new THREE.BoxGeometry(W, D, H),
					new THREE.MeshStandardMaterial({ color: 0x0b1420, roughness: 0.9 })));

				// Frame — 4 aluminium pieces
				const frameMat3 = new THREE.MeshStandardMaterial({ color: 0x8d9fae, metalness: 0.92, roughness: 0.18 });
				const FD = D + 0.004;
				const lf = new THREE.Mesh(new THREE.BoxGeometry(FW, FD, H + FW * 2), frameMat3);
				lf.position.x = -(W / 2) + FW / 2; panelGroup.add(lf);
				const rf = lf.clone(); rf.position.x = (W / 2) - FW / 2; panelGroup.add(rf);
				const tf = new THREE.Mesh(new THREE.BoxGeometry(W - FW * 2, FD, FW), frameMat3);
				tf.position.z = -(H / 2) + FW / 2; panelGroup.add(tf);
				const bf = tf.clone(); bf.position.z = (H / 2) - FW / 2; panelGroup.add(bf);

				// Cell face
				const iW = W - 2 * FW, iH = H - 2 * FW;
				const cf = new THREE.Mesh(new THREE.PlaneGeometry(iW, iH),
					new THREE.MeshStandardMaterial({ map: cellTex, metalness: 0.05, roughness: 0.42 }));
				cf.rotation.x = -Math.PI / 2; cf.position.y = D / 2 + 0.001; panelGroup.add(cf);

				// Glass
				const gf = new THREE.Mesh(new THREE.PlaneGeometry(iW, iH),
					new THREE.MeshStandardMaterial({ color: 0xc8e4f4, metalness: 0.08, roughness: 0.04, transparent: true, opacity: 0.15 }));
				gf.rotation.x = -Math.PI / 2; gf.position.y = D / 2 + 0.004; panelGroup.add(gf);

				// Backsheet
				const bk = new THREE.Mesh(new THREE.PlaneGeometry(iW, iH),
					new THREE.MeshStandardMaterial({ color: 0xdce4ec, roughness: 0.88 }));
				bk.rotation.x = Math.PI / 2; bk.position.y = -(D / 2) - 0.001; panelGroup.add(bk);

				// Junction box
				const jbW = W * 0.13, jbH = H * 0.055, jbD = FW * 2.8;
				const jbox = new THREE.Mesh(new THREE.BoxGeometry(jbW, jbD, jbH),
					new THREE.MeshStandardMaterial({ color: 0x1a1f2d, roughness: 0.72, metalness: 0.12 }));
				jbox.position.set(W * 0.07, -(D / 2) - jbD / 2, H * 0.1); panelGroup.add(jbox);

				// Mounting rails
				const RS = W * 0.030;
				for (const rz of [H * 0.29, -H * 0.29]) {
					const rail = new THREE.Mesh(new THREE.BoxGeometry(W * 0.84, RS, RS), frameMat3);
					rail.position.set(0, -(D / 2) - RS * 0.5, rz); panelGroup.add(rail);
				}

				// Single-post pedestal mount
				const mast = new THREE.Mesh(
					new THREE.CylinderGeometry(W * 0.03, W * 0.032, 0.78, 16),
					frameMat3
				);
				mast.position.set(0, -(D / 2) - RS - 0.28, 0); panelGroup.add(mast);
				const saddle = new THREE.Mesh(
					new THREE.BoxGeometry(W * 0.18, RS * 1.2, H * 0.12),
					frameMat3
				);
				saddle.position.set(0, -(D / 2) - RS * 0.9, 0); panelGroup.add(saddle);
				const braceGeom = new THREE.CylinderGeometry(W * 0.007, W * 0.007, H * 0.52, 10);
				const braceL = new THREE.Mesh(braceGeom, frameMat3);
				braceL.position.set(-W * 0.18, -(D / 2) - RS * 1.75, H * 0.14);
				braceL.rotation.z = 0.42; braceL.rotation.x = -0.32; panelGroup.add(braceL);
				const braceR = braceL.clone();
				braceR.position.x = W * 0.18; braceR.rotation.z = -0.42; panelGroup.add(braceR);

				panelGroup.position.y = 0.85;
				panelGroup.rotation.x = -0.4;
				group.add(panelGroup);
				break;
			}
			case AssetCategory.STRING_INVERTER:
			case AssetCategory.CENTRAL_INVERTER: {
				const body = new THREE.Mesh(new THREE.BoxGeometry(width * 0.9, height * 0.55, Math.max(0.35, depth * 1.8)), dark);
				body.position.y = 0.55;
				group.add(body);
				const bolt = new THREE.Mesh(new THREE.CylinderGeometry(0.08, 0.08, 0.28, 16), accent);
				bolt.position.set(0, 0.58, body.geometry.parameters.depth / 2 + 0.1);
				bolt.rotation.x = Math.PI / 2;
				group.add(bolt);
				break;
			}
			case AssetCategory.TRACKER:
			case AssetCategory.MOUNTING_STRUCTURE: {
				const rail = new THREE.Mesh(new THREE.BoxGeometry(Math.max(1.6, width), 0.08, 0.08), metal);
				rail.position.y = 0.65;
				group.add(rail);
				const supportA = new THREE.Mesh(new THREE.BoxGeometry(0.08, 0.9, 0.08), metal);
				supportA.position.set(-0.6, 0.45, 0);
				group.add(supportA);
				const supportB = supportA.clone();
				supportB.position.x = 0.6;
				group.add(supportB);
				const module = new THREE.Mesh(new THREE.BoxGeometry(1.25, 0.04, 0.85), panel);
				module.position.set(0, 0.77, 0);
				module.rotation.x = -0.3;
				group.add(module);
				break;
			}
			case AssetCategory.CABLE: {
				const curve = new THREE.CatmullRomCurve3([
					new THREE.Vector3(-1, 0.5, -0.3),
					new THREE.Vector3(-0.3, 0.8, 0.2),
					new THREE.Vector3(0.4, 0.2, -0.2),
					new THREE.Vector3(1, 0.6, 0.3)
				]);
				const tube = new THREE.Mesh(new THREE.TubeGeometry(curve, 56, 0.07, 16, false), accent);
				group.add(tube);
				break;
			}
			case AssetCategory.TRANSFORMER:
			case AssetCategory.JUNCTION_BOX:
			case AssetCategory.COMBINER_BOX:
			case AssetCategory.SUBSTATION:
			default: {
				const enclosure = new THREE.Mesh(new THREE.BoxGeometry(Math.max(1.1, width * 0.9), Math.max(0.8, height * 0.5), Math.max(0.6, depth * 1.4)), metal);
				enclosure.position.y = 0.5;
				group.add(enclosure);
				const base = new THREE.Mesh(new THREE.BoxGeometry(1.4, 0.08, 1), dark);
				base.position.y = 0.04;
				group.add(base);
			}
		}

		return group;
	}
</script>

<div class="asset-3d-preview">
	<div class="preview-toolbar">
		<span class="preview-title">3D Asset View</span>
		<span class="preview-badge">{hasExternalModel ? 'Model loaded' : 'Proxy mode'}</span>
	</div>
	<div class="canvas-host" bind:this={container}></div>
	<div class="preview-status">{status}</div>
</div>

<style>
	.asset-3d-preview {
		display: flex;
		flex-direction: column;
		gap: 6px;
		padding: 10px;
		border-radius: 8px;
		border: 1px solid rgba(255, 255, 255, 0.08);
		background: rgba(2, 6, 23, 0.55);
	}

	.preview-toolbar {
		display: flex;
		justify-content: space-between;
		align-items: center;
		gap: 8px;
	}

	.preview-title {
		font-size: 11px;
		font-weight: 600;
		text-transform: uppercase;
		letter-spacing: 0.05em;
		color: #cbd5e1;
	}

	.preview-badge {
		font-size: 10px;
		padding: 2px 6px;
		border-radius: 999px;
		background: rgba(56, 189, 248, 0.15);
		border: 1px solid rgba(56, 189, 248, 0.3);
		color: #7dd3fc;
	}

	.canvas-host {
		width: 100%;
		height: 220px;
		border-radius: 8px;
		overflow: hidden;
		border: 1px solid rgba(255, 255, 255, 0.08);
		background: #0b1120;
	}

	.preview-status {
		font-size: 11px;
		color: #94a3b8;
	}
</style>
