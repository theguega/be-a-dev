#!/usr/bin/env bash
# Run three Linux (amd64) containers in parallel: ./install.sh -c (CLI only, no GUI).
#
# Docker only runs Linux — not macOS. This host may not run linux/arm64 without QEMU;
# we use three amd64 images instead (Ubuntu 24.04, Ubuntu 22.04, Debian bookworm).
#
# To test on macOS (Intel or Apple Silicon), run on a real Mac:
#   cd ~/.dotfiles && ./install.sh -c
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOGDIR="${TMPDIR:-/tmp}/dotfiles-install-test-$$"
mkdir -p "$LOGDIR"

trap 'echo "Logs under: $LOGDIR"' EXIT

declare -a PIDS=()

run_one() {
    local name=$1
    local image=$2
    local log="$LOGDIR/${name}.log"
    echo "Starting $name ($image) → $log" >&2
    (
        docker run --rm --platform linux/amd64 \
            -e TERM=xterm-256color \
            -e CI=1 \
            -v "$ROOT:/dotfiles-src:ro" \
            -v "$ROOT/test/docker-inner-install.sh:/inner.sh:ro" \
            "$image" \
            bash /inner.sh >"$log" 2>&1
        ec=$?
        echo "=== container exit $ec ===" >>"$log"
        exit "$ec"
    ) &
    PIDS+=($!)
}

echo "Note: macOS cannot run in Docker. Using three linux/amd64 images (CLI-only install)."
echo ""

run_one linux-u2404 ubuntu:24.04
run_one linux-u2204 ubuntu:22.04
run_one debian-amd64 debian:bookworm-slim

ec=0
for pid in "${PIDS[@]}"; do
    if ! wait "$pid"; then
        ec=1
    fi
done

for f in "$LOGDIR"/*.log; do
    echo "---- $(basename "$f") (tail) ----"
    tail -n 40 "$f"
    echo ""
done

exit "$ec"
