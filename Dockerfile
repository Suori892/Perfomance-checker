FROM alpine:latest

RUN apk update && apk add --no-cache rust cargo

COPY . /usr/src/perfomance-checker

WORKDIR /usr/src/perfomance-checker

RUN cargo build --release

CMD ["/usr/src/perfomance-checker/target/release/perfomance-checker"]
