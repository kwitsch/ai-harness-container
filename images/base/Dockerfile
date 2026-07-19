# syntax=docker/dockerfile:1

FROM oven/bun:alpine AS bun

FROM alpine:3.24

ARG RTK_VERSION=0.43.0
ARG GH_VERSION=2.96.0
ARG CBM_VERSION=0.9.0

RUN sed -i '/community/s/^#//' /etc/apk/repositories

RUN --mount=type=cache,target=/var/cache/apk <<EOF
#!/bin/sh -e
apk --cache-dir=/var/cache/apk update
apk --cache-dir=/var/cache/apk add bash build-base git nodejs npm ripgrep
EOF

ADD --checksum=sha256:83d5c2ccad5498f58bf6368acb1ab32588cf43ab3a4b1c301bf36328b1c8bd60 \
    https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz /tmp/gh.tar.gz
RUN <<EOF
#!/bin/sh -e
tar -xzf /tmp/gh.tar.gz -C /tmp
mv /tmp/gh_${GH_VERSION}_linux_amd64/bin/gh /usr/local/bin/gh
chmod +x /usr/local/bin/gh
rm -rf /tmp/gh.tar.gz /tmp/gh_${GH_VERSION}_linux_amd64
EOF

ADD --checksum=sha256:ff8a1e7766496e175291a85aeca1dc97c9ff6df33e51e5893d1fbc78fea2a609 \
    https://github.com/rtk-ai/rtk/releases/download/v${RTK_VERSION}/rtk-x86_64-unknown-linux-musl.tar.gz /tmp/rtk.tar.gz
RUN <<EOF
#!/bin/sh -e
tar -xzf /tmp/rtk.tar.gz -C /usr/local/bin
chmod +x /usr/local/bin/rtk
rm -f /tmp/rtk.tar.gz
EOF

ADD --checksum=sha256:8459d5c9d1457f2c82de3de307ffc7641ecbba2dde893427be1e62eca8ef9b25 \
    https://github.com/DeusData/codebase-memory-mcp/releases/download/v${CBM_VERSION}/codebase-memory-mcp-linux-amd64-portable.tar.gz /tmp/cbm.tar.gz
RUN <<EOF
#!/bin/sh -e
tar -xzf /tmp/cbm.tar.gz -C /usr/local/bin
chmod +x /usr/local/bin/codebase-memory-mcp
rm -f /tmp/cbm.tar.gz
EOF

COPY --from=bun /usr/local/bin/bun /usr/local/bin/bun

RUN <<EOF
#!/bin/sh -e
addgroup -g 1000 harness
adduser -D -u 1000 -G harness harness
EOF

USER harness
WORKDIR /home/harness
