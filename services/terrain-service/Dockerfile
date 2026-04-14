# Terrain Service Dockerfile


FROM golang:1.26-alpine as builder
WORKDIR /app
# Copy service source from monorepo root context
COPY services/terrain-service .
# Copy shared module from monorepo root context
COPY services/shared /shared
# Copy generated proto Go module for ConnectRPC handlers/messages
COPY proto/gen/go /proto/gen/go
WORKDIR /app/cmd/server
RUN go mod tidy
RUN go build -o /app/server

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/server .
EXPOSE 8080
CMD ["./server"]
