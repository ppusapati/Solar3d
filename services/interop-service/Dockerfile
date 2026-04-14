FROM golang:1.26-alpine as builder
WORKDIR /app

COPY services/interop-service .
COPY services/shared /shared
COPY proto/gen/go /proto/gen/go

WORKDIR /app/cmd/server
RUN go mod tidy
RUN go build -o /app/interop-service

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/interop-service .

EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
  CMD wget -q -O- http://localhost:8080/healthz || exit 1

CMD ["./interop-service"]