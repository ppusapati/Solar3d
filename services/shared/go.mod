module solar3d/shared

go 1.26.1

require (
	connectrpc.com/connect v1.16.2
	github.com/google/uuid v1.6.0
	github.com/rs/zerolog v1.35.0
	github.com/solar3d/solar3d/gen v0.0.0
	google.golang.org/protobuf v1.36.8
)

require (
	github.com/google/go-cmp v0.7.0 // indirect
	github.com/mattn/go-colorable v0.1.14 // indirect
	github.com/mattn/go-isatty v0.0.20 // indirect
	golang.org/x/net v0.43.0 // indirect
	golang.org/x/sys v0.35.0 // indirect
	golang.org/x/text v0.29.0 // indirect
)

replace github.com/solar3d/solar3d/gen => ../../proto/gen/go
