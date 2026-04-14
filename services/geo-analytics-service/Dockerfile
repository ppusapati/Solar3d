FROM golang:1.26-alpine as builder
WORKDIR /app

COPY services/geo-analytics-service .
COPY services/shared /shared
COPY proto/gen/go /proto/gen/go

WORKDIR /app/cmd/server
RUN go mod tidy
RUN go build -o /app/geo-analytics

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/geo-analytics .

EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=5s --retries=5 \
  CMD wget -q -O- http://localhost:8080/healthz || exit 1

CMD ["./geo-analytics"]
