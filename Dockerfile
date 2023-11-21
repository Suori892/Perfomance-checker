FROM alpine:latest

RUN apk --no-cache add rust cargo

COPY . /usr/src/perfomance-checker

WORKDIR /usr/src/perfomance-checker

RUN cargo build --release

CMD ["/usr/src/perfomance-checker/target/release/perfomance-checker"]
