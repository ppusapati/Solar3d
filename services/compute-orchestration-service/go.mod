module solar3d/compute-orchestration-service

go 1.26.1

require (
	connectrpc.com/connect v1.16.2
	github.com/google/uuid v1.6.0
	github.com/jackc/pgx/v5 v5.9.1
	github.com/lib/pq v1.10.9
	github.com/rs/zerolog v1.35.0
	github.com/solar3d/solar3d/gen v0.0.0
	google.golang.org/protobuf v1.36.8
)

require (
	github.com/google/go-cmp v0.7.0 // indirect
	github.com/jackc/pgpassfile v1.0.0 // indirect
	github.com/jackc/pgservicefile v0.0.0-20240606120523-5a60cdf6a761 // indirect
	github.com/jackc/puddle/v2 v2.2.2 // indirect
	github.com/mattn/go-colorable v0.1.14 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	golang.org/x/net v0.43.0 // indirect
	golang.org/x/sync v0.17.0 // indirect
	golang.org/x/sys v0.35.0 // indirect
	golang.org/x/text v0.29.0 // indirect
)

replace github.com/solar3d/solar3d/gen => ../../proto/gen/go
