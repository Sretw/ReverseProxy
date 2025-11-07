FROM caddy:2.10.2-builder-alpine AS builder

# Build with modules
RUN xcaddy build \
    --with github.com/abiosoft/caddy-json-schema \
    --with github.com/mholt/caddy-l4 \
    --with github.com/mholt/caddy-grpc-web

FROM caddy:2.10.2-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
