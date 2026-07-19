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
      nodejs \
      npm \
      ripgrep

RUN for i in 1 2 3 4 5; do \
      GH_VERSION=$(curl -sI https://github.com/cli/cli/releases/latest | grep -i '^location:' | sed -E 's|.*/tag/v?([^[:space:]]+).*|\1|' | tr -d '\r') \
        && curl -fsSL -o /tmp/gh.tar.gz "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_amd64.tar.gz" \
        && tar -xzf /tmp/gh.tar.gz -C /tmp \
        && mv "/tmp/gh_${GH_VERSION}_linux_amd64/bin/gh" /usr/local/bin/gh \
        && break; \
      echo "gh install attempt $i failed, retrying..." >&2; \
      rm -rf /tmp/gh.tar.gz /tmp/gh_*_linux_amd64; \
      sleep 3; \
    done \
    && rm -rf /tmp/gh.tar.gz /tmp/gh_*_linux_amd64 \
    && test -x /usr/local/bin/gh

RUN for i in 1 2 3 4 5; do \
      curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh -o /tmp/rtk-install.sh \
        && RTK_INSTALL_DIR=/usr/local/bin sh /tmp/rtk-install.sh \
        && break; \
      echo "rtk install attempt $i failed, retrying..." >&2; \
      sleep 3; \
    done \
    && rm -f /tmp/rtk-install.sh \
    && test -x /usr/local/bin/rtk

RUN for i in 1 2 3 4 5; do \
      curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh -o /tmp/cbm-install.sh \
        && bash /tmp/cbm-install.sh --dir=/usr/local/bin --skip-config \
        && break; \
      echo "codebase-memory-mcp install attempt $i failed, retrying..." >&2; \
      sleep 3; \
    done \
    && rm -f /tmp/cbm-install.sh \
    && test -x /usr/local/bin/codebase-memory-mcp

COPY --from=bun /usr/local/bin/bun /usr/local/bin/bun

RUN addgroup -g 1000 harness \
    && adduser -D -u 1000 -G harness harness

USER harness
WORKDIR /home/harness
