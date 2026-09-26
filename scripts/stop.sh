#!/usr/bin/env bash
set -euo pipefail

CONTAINER_NAME="pm-app"

if ! docker info >/dev/null 2>&1; then
  echo "Docker is not running. Start Docker and retry."
  exit 1
fi

docker rm -f "$CONTAINER_NAME" >/dev/null 2>&1 || true
echo "Stopped ${CONTAINER_NAME}"
