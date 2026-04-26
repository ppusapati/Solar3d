module p9e.in/samavaya/solar3d/cad-core-service

go 1.26.1

require (
	connectrpc.com/connect v1.19.1
	github.com/google/uuid v1.6.0
	github.com/rs/zerolog v1.35.0
	p9e.in/samavaya/solar3d/gen v0.0.0
	google.golang.org/protobuf v1.36.9
	p9e.in/samavaya/packages v0.0.0-00010101000000-000000000000
)

require (
	github.com/mattn/go-colorable v0.1.14 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	golang.org/x/sys v0.35.0 // indirect
)

replace p9e.in/samavaya/solar3d/gen => ../../proto/gen/go

replace p9e.in/samavaya/packages => ../packages
