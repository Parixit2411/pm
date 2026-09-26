#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

IMAGE_NAME="pm-app"
CONTAINER_NAME="pm-app"
PORT="8000"

if [[ ! -f .env ]]; then
  echo "Missing .env in project root"
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Start Docker and retry."
  exit 1
fi

docker build -t "$IMAGE_NAME" .
docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
docker run -d \
  --name "$CONTAINER_NAME" \
  -p "${PORT}:8000" \
  --env-file .env \
  "$IMAGE_NAME"

echo "Started http://localhost:${PORT}"
