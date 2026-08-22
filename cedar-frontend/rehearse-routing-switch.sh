#!/bin/sh
set -eu

# Proves the route-only split and rollback against already-running local
# frontends. It owns and removes only the disposable nginx gateways.

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
CEDAR_ROOT=${CEDAR_HOME:-$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)}
E2E_DIR="$CEDAR_ROOT/cedar-development/ops/e2e"
BASE_COMPOSE="$SCRIPT_DIR/docker-compose.routing-rehearsal.yml"
ROLLBACK_COMPOSE="$SCRIPT_DIR/docker-compose.routing-rehearsal.rollback.yml"
PROJECT=cedar-routing-rehearsal

owner_of_port() {
  lsof -ti "tcp:$1" -sTCP:LISTEN 2>/dev/null | head -1
}

container_for_port() {
  docker ps --filter "publish=$1" --format '{{.ID}}' | head -1
}

identity_of_port() {
  container=$(container_for_port "$1")
  if [ -n "$container" ]; then
    echo "container:$container"
  else
    owner=$(owner_of_port "$1")
    [ -n "$owner" ] && echo "pid:$owner"
  fi
}

require_application() {
  name=$1
  port=$2
  identity=$(identity_of_port "$port")
  if [ -z "$identity" ]; then
    echo "$name is not listening on port $port" >&2
    echo "Start it first with: cedar-services.sh start frontend workspace designer" >&2
    exit 1
  fi
  echo "$identity"
}

compose() {
  docker compose --project-name "$PROJECT" "$@"
}

cleanup() {
  compose -f "$BASE_COMPOSE" down --remove-orphans >/dev/null 2>&1 || true
}
trap cleanup EXIT HUP INT TERM

frontend_identity=$(require_application "Monolith" 4200)
workspace_identity=$(require_application "Workspace" 4201)
designer_identity=$(require_application "Template Designer" 4202)

echo "Application identities before switch: $frontend_identity $workspace_identity $designer_identity"

compose -f "$BASE_COMPOSE" up -d --wait
canonical_split_id=$(compose -f "$BASE_COMPOSE" ps -q routing-canonical)
designer_gateway_id=$(compose -f "$BASE_COMPOSE" ps -q routing-designer)

(cd "$E2E_DIR" && npm run smoke:routing:split)

compose -f "$BASE_COMPOSE" -f "$ROLLBACK_COMPOSE" \
  up -d --wait --no-deps --force-recreate routing-canonical

canonical_rollback_id=$(compose -f "$BASE_COMPOSE" -f "$ROLLBACK_COMPOSE" \
  ps -q routing-canonical)
designer_gateway_after=$(compose -f "$BASE_COMPOSE" -f "$ROLLBACK_COMPOSE" \
  ps -q routing-designer)

if [ "$canonical_split_id" = "$canonical_rollback_id" ]; then
  echo "Canonical gateway was not recreated for rollback" >&2
  exit 1
fi
if [ "$designer_gateway_id" != "$designer_gateway_after" ]; then
  echo "Designer gateway changed during canonical rollback" >&2
  exit 1
fi

for pair in "4200:$frontend_identity" "4201:$workspace_identity" "4202:$designer_identity"; do
  port=${pair%%:*}
  expected=${pair#*:}
  actual=$(identity_of_port "$port")
  if [ "$actual" != "$expected" ]; then
    echo "Application identity on port $port changed: $expected -> ${actual:-none}" >&2
    exit 1
  fi
done

(cd "$E2E_DIR" && npm run smoke:routing:rollback)

echo "PASS: split routing and route-only rollback preserved all application processes"
