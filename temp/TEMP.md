Looking at your TODO files in context of what you've just completed, here's what remains:

## **Completed** ✅
- Compute Orchestration Service (job queuing, retries, idempotency, dead-letter, metrics, tracing)
- Existing compute services: solar-compute, terrain-compute
- Basic project, terrain, layout, simulation, electrical, routing, asset, report services

---

## **Major Work Remaining** (Prioritized by impact)

### **Tier 1: Core Compute Extensions (Rust)** 
To fulfill the algorithm matrix and enable real optimization/ML:

```
compute/
  ├── geo-compute/          [MISSING] - Point-in-polygon, buffering, proximity, contours
  ├── graph-compute/        [MISSING] - MST, Steiner tree, network topology
  ├── optimization-compute/ [MISSING] - GA/PSO/SA, Pareto multi-objective, ILP bridge
  ├── ml-compute/          [MISSING] - ONNX inference, yield forecasting, anomaly detection
  └── common/              [MISSING] - Shared geometry/energy types, numerics, errors
```

**Effort**: 4-6 weeks (expert Rust engineers)  
**Blockers**: None (work independently from services)

---

### **Tier 2: ML Training Pipeline** (From ML-TODO.md Phase 1-9)
Currently missing entire learning loop:

| Phase | Focus | Status |
|-------|-------|--------|
| Phase 1-2 | Define scope, extend proto RPCs | Not started |
| Phase 3 | Add ML schema tables, tracking | Not started |
| Phase 4 | Training orchestrator workflow | Not started |
| Phase 5 | Model registry, artifact storage | Not started |
| Phase 6 | Inference runtime hot-reload | Not started |
| Phase 7 | Monitoring, drift, safety guardrails | Not started |
| Phase 8 | Testing/validation harness | Not started |
| Phase 9 | Rollout: logging → shadow → canary → auto-promote | Not started |

**Effort**: 8-12 weeks (includes data infrastructure + model ops)  
**Blocker**: Compute Orchestration (✅ done), needs ml_inference.proto enhancement

---

### **Tier 3: New Microservices** (8 services from TODO.md)

| Service | Purpose | Go/Rust | Est. Effort |
|---------|---------|---------|-------------|
| **API Gateway** | Single entry point, request routing | Go | 2 weeks |
| **CAD Core** | Drawing commands, snap/grid, undo/redo | Go + JS | 6 weeks |
| **CAD Annotation** | Dimensions, text, associative updates | Go + JS | 3 weeks |
| **CAD Layer-Block** | Symbol libraries, layer standards | Go | 2 weeks |
| **Drawing Storage & Revision** | Versioning, merge, baselines | Go + PG | 4 weeks |
| **Interop** | DXF/DWG/IFC import/export | Go + Rust | 5 weeks |
| **Plot & Sheet** | Paper-space layouts, PDF/plot export | Go | 3 weeks |
| **Geo-Analytics** | Buffer, contours, clustering, viewshed | Go wrapper around rust compute | 3 weeks |

**Total**: ~28 weeks for all 8

---

### **Tier 4: Enhancements to Existing Services** (5 services from TODO.md)

| Service | Changes | Effort |
|---------|---------|--------|
| Project Service | Add drawing revision & publish references | 1 week |
| Terrain Service | Add contour export, tile pyramid APIs | 2 weeks |
| Layout Service | Integrate CAD entities, parametric constraints | 3 weeks |
| Simulation Service | Weather models, uncertainty, calibration | 2 weeks |
| Electrical Service | Network graph APIs, optimization hooks | 2 weeks |

**Total**: 10 weeks

---

## **Realistic Next Steps** (Pick one):

### **Option A: Complete Learning Loop First** (8-12 weeks)
- Get true ML training + deployment working end-to-end
- Unblock yield prediction, anomaly detection, forecasting
- Build monitoring/safety framework before going into CAD

**Pros**: High business value, proves ML ops, unblocks revenue  
**Cons**: No CAD yet

### **Option B: Extend Compute Core** (4-6 weeks, Rust-only)
- Build geo-compute, graph-compute, optimization-compute, ml-compute
- Give Go services clean algorithm APIs
- Foundation for everything else

**Pros**: Fast, no service bloat, enables tier 1 & 3 in parallel  
**Cons**: Still no inference/optimization until ML phase

### **Option C: Geo-Analytics + Optimization First** (6-8 weeks)
- geo-compute + optimization-compute in Rust
- Geo-Analytics service as Go wrapper
- Optimization service as primary user
- Validate real optimization workflows before ML

**Pros**: Unblocks real optimization jobs, validates compute → Go bridge  
**Cons**: Delays ML

### **Option D: Parallel Option B + API Gateway** (6-8 weeks)
- Rust compute core independently
- Go API Gateway routes to existing services
- CAD services waiting for orchestration

**Pros**: Unblocks both compute and frontend routing faster  
**Cons**: Complex coordination

---

## **My Recommendation**

**Start with Option B + A (Compute Core + ML Pipeline in parallel, weeks 1-12):**

1. **Weeks 1-6**: Rust compute crates (geo, graph, optimization, ml-compute, common)
2. **Weeks 1-12**: ML pipeline (proto, schema, training orchestrator, model registry, inference runtime)
3. **Weeks 13+**: Use compute + ML together for Geo-Analytics, Optimization, ML services

This lets you:
- Build algo foundation without service noise
- Get real ML learning working end-to-end
- Then layer new CAD/geo services on solid ground

Would you like me to create a detailed week-by-week execution plan for either option, or start on one of the Rust crates?


This hierarchy is **sound and well-reasoned**, and it aligns strongly with your current project state. You've just stabilized Go↔Rust type boundaries—so you're positioned to execute it. Let me validate it against your context and refine the sequencing:

## **Validation: This Hierarchy is Correct** ✅

**Why it works:**

1. **Steps 1-2 lock safety first** (contracts + ML hardening) before you add more surface area—this is defensive and wins operational confidence early.

2. **Step 3 (compute algorithms)** is the correct pivot point. Your Go services now compile, but without `geo-compute`, `graph-compute`, `optimization-compute`, `ml-compute` in Rust, those services are hollow. This step fills them.

3. **Steps 4-5 (orchestration + existing service upgrades)** stabilize the foundation before new CAD/analytics layers. This prevents churn later.

4. **Steps 6-9 (CAD + analytics integration)** build on proven primitives, not speculation.

5. **Step 10 (release gates)** comes last, after all pieces are integrated.

---

## **Critical Path Dependencies** 

Your hierarchy correctly identifies these must-complete-first:

```
Step 1: Contracts locked
    ↓
Step 2: ML pipeline hardened (retraining, schema validation, rollback tests)
    ↓
Step 3: Rust compute core (geo/graph/optimization/ml-compute crates)
    ├─→ Enables Step 5 (existing service upgrades use new compute)
    └─→ Enables Step 8 (analytics workflows)
    
Step 4: Orchestration + data plane (lineage, idempotency, artifact lifecycle)
    ↓
Step 5: Existing service upgrades (now they have stable compute to call)
    ├─→ Unblocks Step 6 (API Gateway routes to proven services)
    └─→ Unblocks Step 8 (cross-service workflows now safe)

Step 6: Platform backbone (API Gateway, Drawing Storage, CAD Core)
    ├─→ Enables Step 7 (CAD modules depend on Drawing Storage and Core)
    └─→ Enables Step 9 (frontend talks to API Gateway + CAD Core)

Step 7: CAD modules (Annotation, Layer-Block, Interop, Plot & Sheet)
    ↓
Step 8: Analytics workflows (Geo-Analytics, Graph, Optimization, ML)
    ↓
Step 9: Frontend CAD workspace
    ↓
Step 10: Release gates
```

**You cannot skip steps or reorder arbitrarily without creating rework.**

---

## **Where Your Hierarchy Outperforms the TEMP/TODO/ML-TODO Structure**

| Point | Your Hierarchy | Original TODOs | Winner |
|-------|---|---|---|
| Contract stability | ✅ Step 1 explicit lock | Implicit in TODOs | Yours — clearer |
| ML ops hardening | ✅ Step 2 before new work | Not prioritized | Yours — safer |
| Compute first, services second | ✅ Step 3 kernels before Step 5/8 | Tier 1, Tier 3 order ambiguous | Yours — less rework |
| Orchestration discipline | ✅ Step 4 before Step 8 analytics | Mentioned but not sequenced | Yours — more dependable |
| CAD backbone before CAD modules | ✅ Step 6 (Gateway, Storage, Core) before Step 7 | Tier 3 services listed flat | Yours — correct dependency |

---

## **Refinement: What Can Parallelize** (to compress timeline)

Your hierarchy is **sequential for critical path**, but some steps *can* run in parallel to others:

| Parallel Track | Original Step | Can Start During | Why Safe |
|---|---|---|---|
| **Documentation/spec writing** | Step 1 | Immediately | Unblocks communication before coding |
| **ML schema + testing framework** | Step 2 | Step 1 (after contracts locked) | Independent of compute Rust work |
| **Rust compute crates** | Step 3 | Step 1 (after domain types locked) | Pure algorithms, no service deps |
| **Orchestration hardening** | Step 4 | Step 3 (in parallel with compute) | Uses existing orchestration service |
| **Geometry robustness research** | Pre-Step 3 | Now | Inform Step 3 algorithm priorities |

**Suggested parallel tracks (2-3 teams):**
- **Team A**: Step 1 (contracts), then Step 2 (ML hardening)
- **Team B**: Step 3 (Rust compute crates) — **start immediately after Step 1 domain types are locked**
- **Team C**: Step 4 (orchestration/data plane) — **start after Step 1, in parallel with Step 3**

This compresses 12 weeks of pure sequential work to ~8-10 weeks with parallelization.

---

## **One Clarification: Step 3 Should Have Sub-Priority**

Within Step 3 (Rust compute algorithms), prioritize this order:

1. **Geometry robustness** (point-in-polygon, buffering, predicates) — foundation for everything else
2. **Proximity + contours** — unblocks Geo-Analytics service
3. **MST + Steiner** — unblocks Graph service
4. **Pareto + PSO/GA/SA** — unblocks Optimization service  
5. **ML inference loader** — unblocks ML service

This ordering lets you validate each Go service adapter incrementally as its Rust compute crate finishes, rather than waiting for all of Step 3 to complete.

---

## **From Current State: Your Next Action**

You just got **geo-analytics, graph, optimization, ml Go services compiling**. They're currently wrappers around empty/mock Rust bridges.

**Immediate next step (before Steps 1-3):**

1. **Verify contract stability** (5 days):
   - Review current proto files for breaking change risk
   - Lock domain-model types (geometry, graph, energy, ML feature vectors)
   - Add versioning policy to shared contracts

2. **Once contracts locked, split teams** (Day 6 onward):
   - Team A: ML pipeline hardening (Phase 2-9 integration tests, load tests, rollback drills)
   - Team B: Rust compute crates (geo, graph, optimization, ml, common)
   - Team C: Orchestration data plane (lineage, idempotency, artifact lifecycle)

---

**Bottom line: Yes, your hierarchy is correct. It's actually *better* sequenced than the original TODO/TEMP docs, and you're ready to start it now.** 

Want me to create a detailed 12-week execution roadmap with team assignments, sub-milestones, and specific deliverables per step?