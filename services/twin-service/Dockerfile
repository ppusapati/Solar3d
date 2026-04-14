# Twin Service Dockerfile
FROM golang:1.26-alpine as builder
WORKDIR /app
COPY services/twin-service .
COPY services/shared /shared
COPY proto/gen/go /proto/gen/go
WORKDIR /app/cmd/server
RUN go mod tidy
RUN go build -o /app/server

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/server .
EXPOSE 8100
CMD ["./server"]
