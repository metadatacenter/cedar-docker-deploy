# CEDAR Frontend Deployment

`docker-compose.yml` runs the complete seven-frontend set. It consumes images built in
`cedar-docker-build`; this repository contains runtime topology only and never builds an image.

| Service | Public hostname | Container port | Docker image |
| --- | --- | ---: | --- |
| Template Editor | `cedar.${CEDAR_HOST}` | 4200 | `cedar-frontend-main` |
| Workspace | `workspace.${CEDAR_HOST}` | 4201 | `cedar-frontend-workspace` |
| Template Designer | `designer.${CEDAR_HOST}` | 4202 | `cedar-frontend-template-designer` |
| OpenView | `openview.${CEDAR_HOST}` | 4220 | `cedar-frontend-openview` |
| Content | `content.${CEDAR_HOST}` | 4240 | `cedar-frontend-content` |
| Monitoring | `monitoring.${CEDAR_HOST}` | 4300 | `cedar-frontend-monitoring` |
| Bridging | `bridging.${CEDAR_HOST}` | 4340 | `cedar-frontend-bridging` |

The main infrastructure nginx remains the only public TLS endpoint and overall application router.
It contains no frontend assets. In all-Docker mode it proxies each hostname over `cedarnet` to the
corresponding frontend container, whose private nginx serves that application's payload. API
requests return to the main nginx on the API hostnames and are routed to the Java containers.

## npm artifacts and image construction

Frontend source repositories remain Docker-agnostic. Dockerfiles, nginx configurations,
entrypoints, and image metadata live in `cedar-docker-build`. Every image downloads an npm package
from the CEDAR Nexus repository.

npm does not implement Maven-style overwriteable snapshots. A package version can be published
only once, so Docker images must never consume a Maven-style moving snapshot. Publish immutable
development packages from clean commits instead:

```bash
export CEDAR_HOME=$HOME/CEDAR
bash $CEDAR_HOME/cedar-development/ops/publish-frontend-package.sh \
  main|workspace|designer|openview|content|monitoring|bridging
```

The helper stages the package without modifying its source checkout and publishes a development
prerelease derived from the release line, commit time, and source commit. It records the complete source commit as
`gitHead`, is idempotent for the same commit, and refuses dirty repositories. The exact seven
versions are pinned in `cedar-docker-build/bin/cedar-images-base.sh`; the moving `dev` dist-tag is
never an image input. Each image verifies package name, version, and full source commit and records
the package SHA-256 under `/usr/local/share`.

Stable npm releases remain unchanged. This immutable prerelease scheme is specifically the Docker
development input model; it does not change Maven SNAPSHOT behavior.

## All-Docker frontend mode

Stop native frontend processes first because both modes publish the same seven host ports. Build
and start with the Docker profile:

```bash
export CEDAR_HOME=$HOME/CEDAR
bash $CEDAR_HOME/cedar-development/ops/cedar-services.sh stop \
  frontend workspace designer ui-openview ui-content ui-monitoring ui-bridging

source $CEDAR_HOME/cedar-development/bin/templates/cedar-profile-docker-eval.sh
cedarcli docker build frontends
cedarcli docker start all --mode full --pull never
```

Verify all containers and public routes:

```bash
docker ps --filter 'name=frontend-' --format '{{.Names}}\t{{.Status}}'

for host in cedar workspace designer openview content monitoring bridging; do
  curl -sk -o /dev/null -w "$host %{http_code}\n" \
    "https://${host}.metadatacenter.orgx/"
done
```

Expected: seven healthy frontend containers and seven HTTP 200 responses. The 2026-08-21
acceptance also completed the authenticated Workspace → Smoke Tests → template → Designer journey
with no browser console errors. Stopping this Compose project does not change backend containers or
data: `cedarcli docker stop frontends`.

## Native and hybrid modes remain supported

Dockerizing the frontends does not alter their native build or serve commands. There are three
supported topology choices:

| Mode | Frontend assets come from | Public nginx |
| --- | --- | --- |
| Native stack | Seven source checkouts and native Node development servers | Native nginx |
| Docker-backend hybrid | The same seven native Node development servers | Docker nginx routes through `host.docker.internal` |
| All Docker | Seven immutable npm payloads in seven frontend containers | Docker nginx routes over `cedarnet` |

To change from all-Docker back to the hybrid, stop the frontend Compose project, start the seven
native frontend services with `CEDAR_FRONTEND_BIND_HOST=0.0.0.0`, then run
`cedarcli docker start all --mode hybrid`. The complete commands and request path are in
`$CEDAR_HOME/cedar-development/ops/DOCKER-RUNBOOK.md`.

## Local route-switch rehearsal

The routing rehearsal is deliberately separate from deployment Compose.
It puts disposable nginx gateways in front of three already-running applications and proves that a
complete routing-table replacement can reverse the split without rebuilding or restarting one. The
applications may be native Gulp servers or already-built local images. The rehearsal does
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

The rehearsal's two Compose files mount complete, mutually exclusive nginx configurations. Do not combine
individual route fragments in an operational deployment: atomically selecting a complete config is
what prevents a partial rollback. Permanent redirects (301 or 308) are not acceptable during the
migration because cached route decisions can survive a rollback.
