module p9e.in/samavaya/solar3d/transmission-routing-service

go 1.26.1

require (
	connectrpc.com/connect v1.19.1
	github.com/google/uuid v1.6.0
	github.com/jackc/pgx/v5 v5.9.1
	github.com/rs/zerolog v1.35.0
	p9e.in/samavaya/solar3d/gen v0.0.0
	p9e.in/samavaya/packages v0.0.0-00010101000000-000000000000
)

require github.com/davecgh/go-spew v1.1.2-0.20180830191138-d8f796af33cc // indirect

require (
	github.com/jackc/pgpassfile v1.0.0 // indirect
	github.com/jackc/pgservicefile v0.0.0-20240606120523-5a60cdf6a761 // indirect
	github.com/jackc/puddle/v2 v2.2.2 // indirect
	github.com/mattn/go-colorable v0.1.14 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	golang.org/x/sync v0.17.0 // indirect
	golang.org/x/sys v0.35.0 // indirect
	golang.org/x/text v0.29.0 // indirect
	google.golang.org/protobuf v1.36.9
)

replace p9e.in/samavaya/solar3d/gen => ../../proto/gen/go

replace p9e.in/samavaya/packages => ../packages
