# Build stage
FROM golang:1.26-alpine AS builder

WORKDIR /build

COPY services/compute-service/go.mod services/compute-service/go.sum ./services/compute-service/
COPY proto/gen/go ./proto/gen/go

WORKDIR /build/services/compute-service

RUN go mod download

COPY services/compute-service ./

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /build/compute-service ./cmd

# Runtime stage
FROM alpine:3.19

RUN apk add --no-cache ca-certificates

WORKDIR /app

COPY --from=builder /build/compute-service .

EXPOSE 50051

ENTRYPOINT ["./compute-service"]
