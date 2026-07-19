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
| GitHub CLI (`gh`) | Alpine `github-cli` package |
| Node.js 24 | Alpine `nodejs` / `npm` packages |
| [bun](https://bun.com) | copied from the official `oven/bun:alpine` image |
| [rtk](https://github.com/rtk-ai/rtk) | official install script |
| [codebase-memory-mcp](https://github.com/DeusData/codebase-memory-mcp) | official install script |

## Non-root user

The image runs as `harness` (uid/gid 1000), not root.

## Versioning

Published to `ghcr.io/kwitsch/base` on merge to `main`, tagged from
`VERSION` — see the repo-root `CLAUDE.md` for the full release flow.

## Tests

```
bash images/base/tests/test.sh
```

Builds the image and verifies every tool installed correctly and that the
container runs as non-root.
