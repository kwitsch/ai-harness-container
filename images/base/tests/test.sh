#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG="ai-harness-base:test"
IMAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Building ${IMAGE_TAG} from ${IMAGE_DIR}"
docker build -t "${IMAGE_TAG}" "${IMAGE_DIR}"

run() {
  docker run --rm "${IMAGE_TAG}" "$@"
}

check() {
  local name="$1"
  shift
  echo "==> Checking ${name}"
  local output
  if ! output="$(run "$@" 2>&1)"; then
    echo "FAILED: ${name}" >&2
    echo "${output}" >&2
    exit 1
  fi
}

check "bash" bash --version
check "build-base (gcc)" gcc --version
check "ripgrep" rg --version
check "git" git --version
check "gh" gh --version
check "rtk" rtk --version
check "codebase-memory-mcp" codebase-memory-mcp --version
check "bun" bun --version

echo "==> Checking node --version starts with v24."
node_version="$(run node --version)"
if [[ "${node_version}" != v24.* ]]; then
  echo "FAILED: node --version expected v24.x, got ${node_version}" >&2
  exit 1
fi

echo "==> Checking non-root user"
uid="$(run id -u)"
if [[ "${uid}" == "0" ]]; then
  echo "FAILED: container runs as root (uid 0)" >&2
  exit 1
fi

echo "All checks passed."
