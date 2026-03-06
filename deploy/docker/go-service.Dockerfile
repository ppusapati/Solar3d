# Multi-stage build for Go services
FROM golang:1.22-alpine AS builder

ARG SERVICE_NAME

RUN apk add --no-cache git ca-certificates

WORKDIR /build

COPY services/${SERVICE_NAME}/go.mod services/${SERVICE_NAME}/go.sum* ./
RUN go mod download

COPY services/${SERVICE_NAME}/ .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -o /app cmd/server/main.go

# Runtime
FROM alpine:3.19

RUN apk add --no-cache ca-certificates tzdata
COPY --from=builder /app /app

EXPOSE 8080
ENTRYPOINT ["/app"]
