# CEDAR Frontend Compose Stacks

`docker-compose.yml` is the current production frontend stack and remains unchanged during the
frontend separation migration.

## Deployment modes

| Mode | Asset source | Compose file | Status |
| --- | --- | --- | --- |
| Native hybrid | Seven native Node.js development servers behind Docker nginx | None for frontends | Current Docker-backend development mode |
| Split-image preview | Workspace and Designer containers on `cedarnet` | `docker-compose.preview.yml` | Opt-in migration test |
| Normal Docker frontend stack | Existing frontend images | `docker-compose.yml` | Unchanged; does not include Workspace or Designer |

In the native hybrid, Docker nginx contains no frontend application payload. It proxies each UI
hostname to a native server through `host.docker.internal`; that server reads or generates assets
from its source checkout. The complete hostname, source-root, process, port, start, verification,
and stop map is in `$CEDAR_HOME/cedar-development/ops/DOCKER-BACKEND-RUNBOOK.md`.

The nginx Workspace/Designer virtual hosts support both the native hybrid and the opt-in image
preview. Their existence does not promote the two images into `docker-compose.yml` or the normal
`cedarcli docker start frontends` lifecycle.

`docker-compose.preview.yml` is an opt-in stack for the extracted Workspace and Template Designer.
Build their local images and ensure the running infrastructure nginx contains the split virtual
hosts, then start and verify them. Stop native Workspace and Designer first because both modes
publish ports 4201 and 4202.

```sh
export CEDAR_HOME=$HOME/CEDAR
source "$CEDAR_HOME/cedar-development/bin/templates/cedar-profile-docker-eval.sh"
export CEDAR_AUTH_HOST_TARGET="$CEDAR_NGINX_HOST"

cd "$CEDAR_HOME/cedar-docker-build"
./bin/build-split-preview-frontends.sh
cedarcli docker build nginx

cd "$CEDAR_HOME/cedar-docker-deploy/cedar-infrastructure"
docker compose up -d --no-deps --force-recreate nginx

cd "$CEDAR_HOME/cedar-docker-deploy/cedar-frontend"
CEDAR_WORKSPACE_FRONTEND_URL=https://workspace.metadatacenter.orgx \
CEDAR_TEMPLATE_DESIGNER_FRONTEND_URL=https://designer.metadatacenter.orgx \
docker compose -f docker-compose.preview.yml up -d --wait

cd "$CEDAR_HOME/cedar-development/ops/e2e"
npm run smoke:split:hostnames:keycloak
npm run smoke:split:hostnames:deployment
CEDAR_WORKSPACE_PREVIEW=https://workspace.metadatacenter.orgx \
CEDAR_DESIGNER_PREVIEW=https://designer.metadatacenter.orgx \
npm run record:split:deployment

cd "$CEDAR_HOME/cedar-docker-deploy/cedar-frontend"
docker compose -f docker-compose.preview.yml down
```

The preview stack uses ports 4201 and 4202, joins the external `cedarnet` network at the Workspace
and Designer addresses from the Docker profile, and keeps separate log volumes. Infrastructure
nginx routes `workspace.${CEDAR_HOST}` and `designer.${CEDAR_HOST}` to those addresses. Override
`CEDAR_WORKSPACE_PREVIEW_PORT` or `CEDAR_TEMPLATE_DESIGNER_PREVIEW_PORT` for host-port collisions.
For a remote preview topology, also set the two absolute frontend URL variables consumed by the
images. This file is not loaded by the normal `cedarcli docker start frontends` command.
The deployment smoke rejects dirty or provenance-unknown image inputs and verifies the no-store
runtime build metadata. Save the recorder's JSON output with staging evidence; it names both full
source commits and the exact generated bundle digests needed to distinguish a deployment and its
rollback target even when an image tag is reused.

## Local route-switch rehearsal

The routing rehearsal is deliberately separate from both production Compose and the image preview.
It puts disposable nginx gateways in front of three already-running applications and proves that a
complete routing-table replacement can reverse the split without rebuilding or restarting one. The
applications may be native Gulp servers or already-built local preview images. The rehearsal does
not use TLS, authenticate, select deployment hostnames, or modify Keycloak.

Start the three applications, then run the whole split-and-rollback gate:

```sh
cd "$CEDAR_HOME/cedar-development"
./ops/cedar-services.sh start frontend workspace designer

cd "$CEDAR_HOME/cedar-docker-deploy/cedar-frontend"
./rehearse-routing-switch.sh
```

The canonical rehearsal origin is `http://localhost:4280`; Designer is
`http://localhost:4282`. In split mode, `/templates`, `/elements`, and `/fields` use HTTP 307 to the
Designer origin and preserve the exact path and query. All other paths go to Workspace. Rollback
recreates only the canonical gateway with the complete `rollback/` configuration, which sends every route to the unchanged
monolith. The gate checks each application's container ID or native process ID before and after the
switch and removes its two gateways on exit; it intentionally leaves the three applications in their
original state.

The two Compose files mount complete, mutually exclusive nginx configurations. Do not combine
individual route fragments in an operational deployment: atomically selecting a complete config is
what prevents a partial rollback. Permanent redirects (301 or 308) are not acceptable during the
migration because cached route decisions can survive a rollback.
