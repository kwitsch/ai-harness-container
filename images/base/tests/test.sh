#!/usr/bin/env bash
set -euo pipefail

IMAGE_TAG="ai-harness-base:test"
IMAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "==> Building ${IMAGE_TAG} from ${IMAGE_DIR}"
docker build -t "${IMAGE_TAG}" "${IMAGE_DIR}"

run() {
  docker run --rm "${IMAGE_TAG}" "$@"
}

fail() {
  local name="$1" output="$2"
  echo "FAILED: ${name}" >&2
  echo "${output}" >&2
  exit 1
}

check() {
  local name="$1"
  shift
  echo "==> Checking ${name}"
  local output
  output="$(run "$@" 2>&1)" || fail "${name}" "${output}"
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
[[ "${node_version}" == v24.* ]] || fail "node --version (expected v24.x)" "${node_version}"

echo "==> Checking non-root user"
uid="$(run id -u)"
[[ "${uid}" != "0" ]] || fail "non-root check" "container runs as root (uid 0)"

echo "All checks passed."
