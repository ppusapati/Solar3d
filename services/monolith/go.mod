module p9e.in/samavaya/solar3d/monolith

go 1.26.1

require (
	github.com/jackc/pgx/v5 v5.9.1
	github.com/rs/zerolog v1.35.0
	golang.org/x/net v0.43.0
	p9e.in/samavaya/solar3d/api-gateway-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/asset-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/cad-annotation-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/cad-core-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/cad-layer-block-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/compute-orchestration-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/compute-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/drawing-revision-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/electrical-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/geo-analytics-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/graph-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/interop-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/layout-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/ml-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/optimization-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/plot-sheet-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/project-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/report-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/routing-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/packages v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/simulation-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/terrain-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/transmission-routing-service v0.0.0-00010101000000-000000000000
	p9e.in/samavaya/solar3d/twin-service v0.0.0-00010101000000-000000000000
)

require (
	connectrpc.com/connect v1.19.1 // indirect
	github.com/go-pdf/fpdf v0.9.0 // indirect
	github.com/google/uuid v1.6.0 // indirect
	github.com/jackc/pgpassfile v1.0.0 // indirect
	github.com/jackc/pgservicefile v0.0.0-20240606120523-5a60cdf6a761 // indirect
	github.com/jackc/puddle/v2 v2.2.2 // indirect
	github.com/mattn/go-colorable v0.1.14 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	p9e.in/samavaya/solar3d/gen v0.0.0 // indirect
	golang.org/x/sync v0.17.0 // indirect
	golang.org/x/sys v0.35.0 // indirect
	golang.org/x/text v0.29.0 // indirect
	google.golang.org/protobuf v1.36.9 // indirect
)

replace (
	p9e.in/samavaya/solar3d/gen => ../../proto/gen/go
	p9e.in/samavaya/solar3d/api-gateway-service => ../api-gateway-service
	p9e.in/samavaya/solar3d/asset-service => ../asset-service
	p9e.in/samavaya/solar3d/cad-annotation-service => ../cad-annotation-service
	p9e.in/samavaya/solar3d/cad-core-service => ../cad-core-service
	p9e.in/samavaya/solar3d/cad-layer-block-service => ../cad-layer-block-service
	p9e.in/samavaya/solar3d/compute-orchestration-service => ../compute-orchestration-service
	p9e.in/samavaya/solar3d/compute-service => ../compute-service
	p9e.in/samavaya/solar3d/drawing-revision-service => ../drawing-revision-service
	p9e.in/samavaya/solar3d/electrical-service => ../electrical-service
	p9e.in/samavaya/solar3d/geo-analytics-service => ../geo-analytics-service
	p9e.in/samavaya/solar3d/graph-service => ../graph-service
	p9e.in/samavaya/solar3d/interop-service => ../interop-service
	p9e.in/samavaya/solar3d/layout-service => ../layout-service
	p9e.in/samavaya/solar3d/ml-service => ../ml-service
	p9e.in/samavaya/solar3d/optimization-service => ../optimization-service
	p9e.in/samavaya/solar3d/plot-sheet-service => ../plot-sheet-service
	p9e.in/samavaya/solar3d/project-service => ../project-service
	p9e.in/samavaya/solar3d/report-service => ../report-service
	p9e.in/samavaya/solar3d/routing-service => ../routing-service
	p9e.in/samavaya/packages => ../packages
	p9e.in/samavaya/solar3d/simulation-service => ../simulation-service
	p9e.in/samavaya/solar3d/terrain-service => ../terrain-service
	p9e.in/samavaya/solar3d/transmission-routing-service => ../transmission-routing-service
	p9e.in/samavaya/solar3d/twin-service => ../twin-service
)
