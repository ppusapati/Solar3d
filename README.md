# Solar EPC 3D Layout & Simulation Platform

A production-grade solar EPC design platform for designing and simulating utility-scale solar farms (5MW–500MW) in a 3D geospatial environment.

## Architecture

The platform is implemented as independent microservices:

| Service | Language | Description |
|---------|----------|-------------|
| project-service | Go | Project lifecycle management |
| terrain-service | Go + Rust | DEM processing, slope/aspect computation |
| layout-service | Go | Component placement, panel array generation, tiling |
| simulation-service | Go + Rust | Solar position, shadow analysis |
| electrical-service | Go | String sizing, inverter grouping, DC/AC ratios |
| routing-service | Go + Rust | Cable/road routing with A* pathfinding |
| report-service | Go | BOM, PDF/CSV/Excel export |
| asset-service | Go | Solar component catalog management |

### Frontend

- **SvelteKit** + **TypeScript** + **TailwindCSS**
- **CesiumJS** for 3D geospatial visualization
- Modular architecture with map, terrain, layout, simulation, electrical, routing, and report modules

### Communication

- **ConnectRPC / gRPC** between services
- **REST** gateway for external APIs
- **Protobuf** API definitions

### Data

- **PostgreSQL** + **PostGIS** for geospatial data
- **sqlc** for typed query generation
- **S3-compatible** object storage for terrain datasets, 3D models, exports

## Project Structure

```
Solar3d/
├── proto/                    # Protobuf API definitions
├── services/                 # Go backend services
│   ├── project-service/
│   ├── terrain-service/
│   ├── layout-service/
│   ├── simulation-service/
│   ├── electrical-service/
│   ├── routing-service/
│   ├── report-service/
│   └── asset-service/
├── compute/                  # Rust compute modules
│   ├── solar-compute/
│   └── terrain-compute/
├── frontend/                 # SvelteKit application
├── deploy/                   # Docker & Kubernetes configs
└── migrations/               # Database migrations
```

## Development

### Prerequisites

- Go 1.22+
- Rust 1.76+
- Node.js 20+
- PostgreSQL 16+ with PostGIS 3.4+
- Docker & Docker Compose
- buf (protobuf tooling)
- sqlc

### Quick Start

```bash
# Start infrastructure
docker compose up -d postgres minio

# Run database migrations
make migrate

# Generate protobuf code
make proto

# Generate sqlc queries
make sqlc

# Start all services
make dev
```

## Performance

- Supports 100k–500k panels via spatial tile partitioning
- LOD rendering (arrays → rows → individual panels)
- Viewport-based tile loading
- SIMD-accelerated Rust compute for simulations
