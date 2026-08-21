# CEDAR Frontend Compose Stacks

`docker-compose.yml` is the current production frontend stack and remains unchanged during the
frontend separation migration.

`docker-compose.preview.yml` is an opt-in stack for the extracted Workspace and Template Designer.
Build their local images first, then start and verify them:

```sh
cd "$CEDAR_HOME/cedar-docker-build"
./bin/build-split-preview-frontends.sh

cd "$CEDAR_HOME/cedar-docker-deploy/cedar-frontend"
docker compose -f docker-compose.preview.yml up -d --wait

cd "$CEDAR_HOME/cedar-development/ops/e2e"
npm run smoke:split:deployment
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
