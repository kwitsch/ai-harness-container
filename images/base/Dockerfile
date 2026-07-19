# syntax=docker/dockerfile:1

FROM oven/bun:alpine AS bun

FROM alpine:3.24

RUN sed -i '/community/s/^#//' /etc/apk/repositories

RUN --mount=type=cache,target=/var/cache/apk \
    apk --cache-dir=/var/cache/apk update && \
    apk --cache-dir=/var/cache/apk add \
      bash \
      build-base \
      curl \
      git \
      github-cli \
      nodejs \
      npm \
      ripgrep

RUN curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh -o /tmp/rtk-install.sh \
    && RTK_INSTALL_DIR=/usr/local/bin sh /tmp/rtk-install.sh \
    && rm /tmp/rtk-install.sh

RUN curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh -o /tmp/cbm-install.sh \
    && bash /tmp/cbm-install.sh --dir=/usr/local/bin --skip-config \
    && rm /tmp/cbm-install.sh

COPY --from=bun /usr/local/bin/bun /usr/local/bin/bun

RUN addgroup -g 1000 harness \
    && adduser -D -u 1000 -G harness harness

USER harness
WORKDIR /home/harness
