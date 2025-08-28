#!/usr/bin/env bash
set -euo pipefail

SOCK="/var/run/docker.sock"
API="http://localhost"

echo "[entrypoint] ensure docker socket present at ${SOCK}"
if [ ! -S "${SOCK}" ]; then
  echo "[entrypoint] ERROR: docker.sock missing"; exit 1
fi

# 1) Create network sp-net if missing
echo "[entrypoint] ensure network sp-net exists"
if curl --silent --fail --unix-socket "${SOCK}" "${API}/networks/sp-net" >/dev/null 2>&1; then
  echo "[entrypoint] sp-net already exists"
else
  curl --silent --unix-socket "${SOCK}" -H "Content-Type: application/json" \
    -X POST "${API}/networks/create" \
    -d '{"Name":"sp-net","Driver":"bridge"}' \
    && echo "[entrypoint] sp-net created"
fi

# 2) Attach current container to sp-net
CID="$(cat /etc/hostname)"
echo "[entrypoint] attach container ${CID} to sp-net (idempotent)"
curl --silent --unix-socket "${SOCK}" -H "Content-Type: application/json" \
  -X POST "${API}/networks/sp-net/connect" \
  -d "{\"Container\":\"${CID}\"}" >/dev/null 2>&1 || true

# 3) Start ShinyProxy
echo "[entrypoint] starting ShinyProxy..."
exec java -jar /opt/shinyproxy/shinyproxy.jar
