module p9e.in/samavaya/solar3d/twin-service

go 1.26.1

require (
	github.com/google/uuid v1.6.0
	github.com/jackc/pgx/v5 v5.9.1
	github.com/rs/zerolog v1.35.0
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
)

replace (
	p9e.in/samavaya/solar3d/gen => ../../proto/gen/go
	p9e.in/samavaya/packages => ../packages
)
