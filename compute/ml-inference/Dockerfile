FROM docker.io/library/rust:1.88-bookworm AS builder
WORKDIR /workspace

# Build from the full workspace so Cargo can resolve all workspace members.
COPY compute/ ./compute/
RUN cd compute && cargo build --release -p ml-inference --bin ml_http_bridge

FROM docker.io/library/debian:bookworm-slim
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY --from=builder /workspace/compute/target/release/ml_http_bridge /usr/local/bin/ml_http_bridge

ENV RUST_ML_BRIDGE_ADDR=0.0.0.0:3030
EXPOSE 3030
CMD ["ml_http_bridge"]
