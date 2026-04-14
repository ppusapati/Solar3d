# Multi-stage build for Go services
FROM golang:1.26-alpine AS builder

ARG SERVICE_NAME

RUN apk add --no-cache git ca-certificates

WORKDIR /build

# Copy the entire services directory to preserve relative module paths
# This maintains the go.mod -> ../shared relative replacements
COPY services/ ./services/
COPY proto/ ./proto/

# Work in the service directory (maintains relative paths for go.mod)
WORKDIR /build/services/${SERVICE_NAME}

# Download dependencies - go.mod relative replacements will work correctly
RUN go mod download
RUN go mod tidy

# Build the service
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /app ./cmd/server/main.go

# Runtime
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata
COPY --from=builder /app /app

EXPOSE 8080
ENTRYPOINT ["/app"]
