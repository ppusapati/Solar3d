module solar3d/cad-layer-block-service

go 1.26.1

require (
	connectrpc.com/connect v1.16.2
	github.com/google/uuid v1.6.0
	github.com/rs/zerolog v1.35.0
	github.com/solar3d/solar3d/gen v0.0.0
	solar3d/shared v0.0.0-00010101000000-000000000000
)

require (
	github.com/mattn/go-colorable v0.1.14 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	golang.org/x/sys v0.35.0 // indirect
	google.golang.org/protobuf v1.36.8 // indirect
)

replace github.com/solar3d/solar3d/gen => ../../proto/gen/go

replace solar3d/shared => ../shared
