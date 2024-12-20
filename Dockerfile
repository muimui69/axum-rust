# Etapa de compilación
FROM rust:latest AS builder

WORKDIR /usr/src/app

COPY Cargo.toml Cargo.lock ./
COPY src ./src

RUN cargo build --release

# Etapa de ejecución
FROM debian:bookworm-slim

WORKDIR /app

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    libssl-dev \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/app/target/release/my_axum_project /app/my_axum_project

EXPOSE 3000

CMD ["/app/my_axum_project"]
