# base

Alpine Linux base image for the AI harness container toolchain.

## Build

```
docker build -t ai-harness-base images/base
```

## Tools installed

| Tool | Source |
|---|---|
| bash | Alpine `bash` package |
| build-base | Alpine `build-base` package (gcc, make, musl-dev, etc. — Alpine's build-essentials equivalent) |
| ripgrep (`rg`) | Alpine `ripgrep` package |
| git | Alpine `git` package |
| GitHub CLI (`gh`) | pinned release binary from [cli/cli](https://github.com/cli/cli), checksum-verified (Alpine's `github-cli` apk package lags upstream) |
| Node.js 24 | Alpine `nodejs` / `npm` packages |
| [bun](https://bun.com) | copied from the official `oven/bun:alpine` image |
| [rtk](https://github.com/rtk-ai/rtk) | pinned release binary, checksum-verified |
| [codebase-memory-mcp](https://github.com/DeusData/codebase-memory-mcp) | pinned release binary, checksum-verified |

## Non-root user

The image runs as `harness` (uid/gid 1000), not root.

## Architecture

amd64 only. `rtk` has no musl-compatible arm64 release asset (only a glibc
`aarch64-unknown-linux-gnu` one, incompatible with this Alpine base).

## Bumping pinned tool versions

`gh`, `rtk`, and `codebase-memory-mcp` are pinned via build ARGs
(`GH_VERSION`, `RTK_VERSION`, `CBM_VERSION`) with a matching `--checksum` on
each `ADD`. To bump one: update its `ARG` default and the `sha256:` value in
the matching `ADD` line (from that release's own checksums file) — a
mismatched checksum fails the build loudly rather than installing silently
wrong content.

## Versioning

Published to `ghcr.io/kwitsch/base` on merge to `main`, tagged from
`VERSION` — see the repo-root `CLAUDE.md` for the full release flow.

## Tests

```
bash images/base/tests/test.sh
```

Builds the image and verifies every tool installed correctly and that the
container runs as non-root.
