#!/bin/sh
# Deploy botboard to Fly. Builds remotely from the repo root (the Dockerfile copies vendor/botboard).
#   fly/deploy.sh [flyctl deploy args...]
set -eu
cd "$(dirname "$0")/.."
[ -f vendor/botboard/go.mod ] || { echo "submodule missing: run 'git submodule update --init'" >&2; exit 1; }
[ -z "$(git -C vendor/botboard status --porcelain)" ] || { echo "vendor/botboard is not clean; refusing" >&2; exit 1; }
exec flyctl deploy --config fly/fly.toml --dockerfile fly/Dockerfile --ha=false "$@" .
