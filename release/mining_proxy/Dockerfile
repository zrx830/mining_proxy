# FROM clux/muslrust:stable as builder
# WORKDIR /usr/src/proxy
# COPY . .
# RUN cargo install --target=x86_64-unknown-linux-musl --path .

FROM alpine:latest
#COPY --from=builder /root/.cargo/bin/proxy /usr/local/bin/proxy
ADD ./mining_proxy /usr/local/bin/mining_proxy
CMD ["mining_proxy","-c","/etc/proxy/default.yaml"]