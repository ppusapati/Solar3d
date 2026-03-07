# Solar3d — Solar EPC Design Platform

Solar3d is a web-based platform for designing, simulating, and engineering utility-scale solar farms (5 MW – 500 MW). It provides an interactive 3D geospatial environment where solar engineers can place panel arrays on real terrain, run energy-yield simulations, design electrical networks, route cables and roads, and generate construction-ready documentation — all from a single application.

---

## Problem Statement

Designing a utility-scale solar farm involves juggling many interdependent concerns:

- **Terrain analysis** — understanding elevation, slope, and aspect across a site
- **Panel layout** — placing hundreds of thousands of panels while respecting spacing, tilt, and terrain constraints
- **Energy simulation** — predicting annual yield by modeling sun position, shading, and irradiance hour-by-hour
- **Electrical design** — sizing strings, grouping inverters, optimizing DC/AC ratios, and calculating losses
- **Cable & road routing** — planning physical infrastructure with cost and slope constraints
- **Reporting** — producing bills of materials, engineering reports, and exportable drawings

Solar3d integrates all of these into a cohesive workflow backed by high-performance compute.

---

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    Frontend (SvelteKit)                   │
│           CesiumJS 3D Globe · TailwindCSS UI             │
└────────────────────────┬─────────────────────────────────┘
                         │  HTTP / ConnectRPC (JSON)
       ┌─────────────────┼─────────────────┐
       ▼                 ▼                 ▼
┌────────────┐   ┌─────────────┐   ┌─────────────┐
│  Project    │   │   Terrain   │   │   Layout    │
│  Service    │   │   Service   │   │   Service   │
│  :8080      │   │   :8081     │   │   :8082     │
└────────────┘   └──────┬──────┘   └─────────────┘
                        │ FFI
┌────────────┐   ┌──────▼──────┐   ┌─────────────┐
│ Simulation  │   │    Rust     │   │  Electrical  │
│  Service    │───│   Compute   │   │   Service   │
│  :8083      │   │  (SIMD)     │   │   :8084     │
└────────────┘   └─────────────┘   └─────────────┘

┌────────────┐   ┌─────────────┐   ┌─────────────┐
│  Routing    │   │   Report    │   │   Asset     │
│  Service    │   │   Service   │   │   Service   │
│  :8085      │   │   :8086     │   │   :8087     │
└────────────┘   └─────────────┘   └─────────────┘
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
   ┌────────────┐  ┌──────────┐  ┌──────────┐
   │ PostgreSQL │  │  MinIO   │  │  Redis   │
   │  + PostGIS │  │  (S3)    │  │ (collab) │
   └────────────┘  └──────────┘  └──────────┘
```

### Technology Stack

| Layer | Technology |
|-------|-----------|
| Frontend | SvelteKit 2.5, Svelte 5, TypeScript 5.5, TailwindCSS 3.4, CesiumJS 1.120 |
| Backend | Go 1.22+ (8 microservices) |
| Compute | Rust 1.76+ with SIMD acceleration (rayon, chrono) |
| API | ConnectRPC / gRPC over HTTP, Protocol Buffers (proto3) |
| Database | PostgreSQL 16 + PostGIS 3.4 |
| Storage | MinIO (S3-compatible) |
| DevOps | Docker Compose, Kubernetes (deploy/), buf, sqlc |

---

## Backend Services

### Project Service (`:8080`)
Manages the lifecycle of solar farm projects and their geographic site boundaries. A project moves through stages: **draft → design → simulation → review → approved → archived**. Each project contains a site defined by a PostGIS polygon boundary with area, coordinates, and timezone.

### Terrain Service (`:8081`)
Ingests Digital Elevation Model (DEM) data and produces derived layers — slope, aspect, and hillshade. Stores raster data in MinIO and delegates heavy computation (gradient/aspect analysis) to the Rust `terrain-compute` module. Supports single-point and grid elevation queries.

### Layout Service (`:8082`)
Handles panel array generation and component placement. Given parameters (panel dimensions, row spacing, tilt, azimuth, site boundary), it generates arrays of up to 500,000 panels. Uses **spatial tiling** with Level-of-Detail (LOD) to partition panels into viewport-queryable tiles, enabling smooth rendering at any zoom level.

### Simulation Service (`:8083`)
Computes solar position using the NOAA astronomical algorithm (Jean Meeus), then runs shadow analysis and irradiance simulations. Supports three simulation types: **shadow maps** (panel shadow polygons at a given time), **irradiance** (kWh/m² over a time range), and **annual yield** (full-year energy production with performance ratio and shading losses). The Earth-Sun distance (radius vector) is used for 1/R² irradiance correction. Calls the Rust `solar-compute` module for SIMD-accelerated batch processing.

### Electrical Service (`:8084`)
Designs the DC and AC electrical network. Auto-generates panel strings (series connections), groups strings into inverter blocks, and validates voltage/current against inverter MPPT ranges. Calculates a detailed **loss breakdown**: soiling, shading, mismatch, DC wiring, AC wiring, inverter efficiency, and transformer losses. Optimizes the DC/AC ratio.

### Routing Service (`:8085`)
Plans cable runs and access roads using **A\* pathfinding** on a terrain elevation grid. Supports slope constraints, obstacle avoidance (water bodies, exclusion zones), and slope penalty factors. Optimizes multi-route plans using nearest-neighbor ordering and 2-opt improvement. Produces cost estimates per route.

### Report Service (`:8086`)
Generates project documentation: **Bill of Materials** (panel/inverter/transformer/cable quantities and costs), layout exports (DXF, CSV), and engineering reports (PDF, Excel, JSON). Stores generated content to the filesystem (production: S3/MinIO) and tracks report metadata in PostgreSQL.

### Asset Service (`:8087`)
A component catalog for reusable equipment specifications — solar panels, inverters, transformers, trackers, cables, junction boxes, and more. Each asset stores physical dimensions, electrical parameters (rated power, Voc, Isc, Vmp, Imp, efficiency, temperature coefficients), and optional 3D model / datasheet paths.

---

## Frontend

The frontend is a single-page **SvelteKit** application that renders a full-screen CesiumJS 3D globe with an overlay of design tools.

### Key Capabilities

- **3D Panel Visualization** — Flat and tilted panels rendered at correct geographic positions with mounting posts
- **Interactive Drawing** — Draw site boundaries and fill areas directly on the globe
- **Panel Array Generation** — Configure tilt, azimuth, spacing, and dimensions; generate arrays with one click
- **Shadow Analysis** — Visualize shadow polygons cast by panels at any date/time
- **Terrain Heatmaps** — Color-coded overlays for elevation, slope, and aspect
- **Electrical Design** — String/inverter assignment and loss visualization
- **Cable/Road Routing** — View planned routes with cost annotations
- **Export** — DXF, CSV, PDF, and JSON export of layouts and reports
- **Collaboration** — Real-time multi-user editing via WebSocket with cursor sharing and entity locking
- **Undo/Redo** — Full action history stack
- **Keyboard Shortcuts** — V (select), H (pan), B (draw boundary), A (draw area), P (place component), M (measure), 1–5 (view modes), Ctrl+Z/Y (undo/redo)

### View Modes

1. **Design** — Panel placement and layout editing
2. **Simulate** — Shadow and irradiance visualization
3. **Electrical** — String and inverter network view
4. **Reports** — Generated documents and exports
5. **Financial** — Cost and ROI analysis

### State Management

Svelte stores manage application state across modules:
- `project` — active project, project list
- `layout` — active layout, tiles, components, generation progress
- `map` — camera position, viewport bounds, active tool, layer visibility
- `history` — undo/redo action stacks
- `entities` — spatial entity index for picking and selection

---

## Database Schema

PostgreSQL with PostGIS stores all spatial and relational data in 13 core tables:

| Table | Purpose |
|-------|---------|
| `projects` | Project metadata, status, target capacity |
| `sites` | Geographic boundary polygon, area, timezone |
| `terrain_layers` | DEM/slope/aspect raster metadata and bounds |
| `layouts` | Panel array container with capacity totals |
| `layout_tiles` | Spatial tile partitions with LOD levels |
| `components` | Placed equipment (inverters, transformers, etc.) |
| `panels` | Individual panel geometry, tilt, azimuth, string assignment |
| `electrical_networks` | DC/AC capacity, string/inverter counts |
| `panel_strings` | Series-connected panel groups with voltage/current |
| `inverter_groups` | Inverter assignments with DC/AC ratio |
| `routes` | Cable/road path geometry, distance, cost |
| `assets` | Equipment catalog with electrical parameters |
| `reports` | Generated report metadata and file paths |

Spatial columns use PostGIS geometry types (POLYGON, POINT, LINESTRING) with GiST indexes for efficient spatial queries.

---

## Performance Design

- **Tile-based LOD** — Panels are spatially partitioned into tiles; only visible tiles are loaded based on the camera viewport
- **SIMD Compute** — Rust modules use rayon parallelism for batch solar position and terrain calculations
- **Connection Pooling** — Each Go service maintains a pgx connection pool (2 min / 20 max connections)
- **Spatial Indexing** — GiST indexes on all geometry columns for sub-millisecond spatial queries
- **Typed SQL** — sqlc generates type-safe Go code from SQL, eliminating runtime query errors

---

## Development

### Prerequisites

- Go 1.22+, Rust 1.76+, Node.js 20+, Docker

### Quick Start

```bash
# Start infrastructure (PostgreSQL, MinIO) and all services
docker compose up -d

# Or run services individually for development
make proto      # Generate Go + TypeScript from protobuf
make sqlc       # Generate typed SQL queries
make migrate    # Apply database migrations
make dev        # Start all 8 services in parallel

# Frontend
cd frontend && npm install && npm run dev
```

### Project Layout

```
Solar3d/
├── proto/              # Protobuf API definitions (8 services)
├── services/           # Go microservices
│   ├── project-service/
│   ├── terrain-service/
│   ├── layout-service/
│   ├── simulation-service/
│   ├── electrical-service/
│   ├── routing-service/
│   ├── report-service/
│   └── asset-service/
├── compute/            # Rust SIMD modules
│   ├── solar-compute/
│   └── terrain-compute/
├── frontend/           # SvelteKit application
├── migrations/         # PostgreSQL schema migrations
├── deploy/             # Docker & Kubernetes configs
├── docker-compose.yml
└── Makefile
```

### Configuration

All services read configuration from environment variables. Key settings:

| Variable | Description | Default |
|----------|-------------|---------|
| `DATABASE_URL` | PostgreSQL connection string | *(required)* |
| `S3_ENDPOINT` | MinIO/S3 endpoint | `http://localhost:9000` |
| `LOG_LEVEL` | Logging verbosity | `info` |
| `VITE_API_BASE_URL` | Backend URL for frontend | `http://localhost:8080` |
| `VITE_WS_URL` | WebSocket URL for collaboration | `ws://localhost:8090` |

---

## Workflow Summary

A typical solar farm design workflow in Solar3d:

1. **Create Project** — Define project name, target capacity, client
2. **Define Site** — Draw the geographic boundary on the 3D globe
3. **Upload Terrain** — Import DEM data; generate slope and aspect layers
4. **Design Layout** — Configure panel parameters and generate arrays; place inverters and transformers
5. **Run Simulation** — Execute shadow analysis and annual yield estimation
6. **Electrical Design** — Auto-generate strings, assign inverters, calculate losses
7. **Route Infrastructure** — Plan cable runs and access roads with A* pathfinding
8. **Generate Reports** — Produce BOM, export layouts as DXF, generate PDF reports
9. **Review & Approve** — Transition project through review stages to approved
