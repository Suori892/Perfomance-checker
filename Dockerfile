#Alpine
FROM rust:1.72.1-alpine AS builder
WORKDIR /app

RUN apk upgrade --update-cache --available && \
    apk add openssl-dev musl-dev pkgconfig mysql-client && \
    rm -rf /var/cache/apk/*

COPY . .

RUN RUSTFLAGS='-C target-feature=-crt-static' cargo build --release

FROM alpine:latest AS runtime
WORKDIR /app

RUN apk upgrade --update-cache --available && \
    apk add libgcc mysql-client && \
    rm -rf /var/cache/apk/*

COPY --from=builder /app/target/release/perfomance-checker perfomance-checker
COPY --from=builder /app/init.sql /app/init.sql

CMD mysql -h mysql -u root -p admin123 perfomance-checker < /app/init.sql


#Debian
# FROM rust:slim-buster AS builder
# WORKDIR /app

# RUN apt-get update && \
#     apt-get install -y --no-install-recommends pkg-config openssl libssl-dev \
#     && rm -rf /var/lib/apt/lists/*

# COPY . .

# RUN RUSTFLAGS="-C target-cpu=native" cargo build --release

# FROM debian:buster-slim AS runtime
# WORKDIR /app

# RUN apt-get update && \
#     apt-get install -y --no-install-recommends ca-certificates \
#     && rm -rf /var/lib/apt/lists/*

# COPY --from=builder /app/target/release/perfomance-checker perfomance-checker

# ENTRYPOINT [ "./perfomance-checker" ]
