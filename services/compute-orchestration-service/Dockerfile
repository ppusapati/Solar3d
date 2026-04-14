FROM golang:1.26-alpine AS builder
WORKDIR /app

COPY services/compute-orchestration-service/go.mod services/compute-orchestration-service/go.sum ./services/compute-orchestration-service/
COPY proto/gen/go ./proto/gen/go
RUN cd services/compute-orchestration-service && go mod download

COPY services/compute-orchestration-service ./services/compute-orchestration-service
RUN cd services/compute-orchestration-service && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/compute-orchestration-service ./cmd/server

FROM alpine:3.20
WORKDIR /app
COPY --from=builder /out/compute-orchestration-service /app/compute-orchestration-service
EXPOSE 50059
ENTRYPOINT ["/app/compute-orchestration-service"]
