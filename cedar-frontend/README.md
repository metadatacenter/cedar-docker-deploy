# CEDAR Frontend Compose Project

For normal use, start with the [Docker Install](https://metadatacenter.readthedocs.io/en/latest/install-docker/overview/).
The [Docker](https://metadatacenter.readthedocs.io/en/latest/developer-guide/cedarcli/docker/) and
[hybrid](https://metadatacenter.readthedocs.io/en/latest/developer-guide/cedarcli/hybrid/) chapters
of the cedarcli manual explain which frontend tier each deployment mode owns. This README describes
only the Compose project and its routing rehearsal.

## Runtime Topology

`docker-compose.yml` defines the complete seven-frontend set. It consumes images from
`cedar-docker-build` and contains no image build instructions.

| Service | Public hostname | Container port | Docker image |
| --- | --- | ---: | --- |
| Template Editor | `cedar.${CEDAR_HOST}` | 4200 | `cedar-frontend-main` |
| Workspace | `workspace.${CEDAR_HOST}` | 4201 | `cedar-frontend-workspace` |
| Template Designer | `designer.${CEDAR_HOST}` | 4202 | `cedar-frontend-template-designer` |
| OpenView | `openview.${CEDAR_HOST}` | 4220 | `cedar-frontend-openview` |
| Content | `content.${CEDAR_HOST}` | 4240 | `cedar-frontend-content` |
| Monitoring | `monitoring.${CEDAR_HOST}` | 4300 | `cedar-frontend-monitoring` |
| Bridging | `bridging.${CEDAR_HOST}` | 4340 | `cedar-frontend-bridging` |

The infrastructure nginx container is the only public TLS endpoint and overall application router.
It contains no frontend assets. In Docker mode, it proxies each public hostname over `cedarnet` to
the corresponding frontend container, whose private nginx serves that application's immutable npm
payload. API hostnames return to the infrastructure nginx and are routed to the Java containers.

Frontend package selection and image construction belong to `cedar-docker-build`; native frontend
build and serve behavior belongs to the source repositories. This Compose project records only the
container runtime relationship.

## Local Route-Switch Rehearsal

The two `docker-compose.routing-rehearsal*.yml` files and `rehearse-routing-switch.sh` are a focused
developer test, not an installation path. They place disposable nginx gateways in front of three
already-running frontend applications and prove that a complete routing-table replacement can be
rolled back without rebuilding or restarting an application. The applications may be native Gulp
servers or local containers; the rehearsal does not configure TLS, authentication, Keycloak, or
public deployment hostnames.

Run it only after the Template Editor, Workspace, and Designer applications are available:

```bash
cd "$CEDAR_HOME/cedar-development"
./ops/cedar-services.sh start frontend workspace designer

cd "$CEDAR_HOME/cedar-docker-deploy/cedar-frontend"
./rehearse-routing-switch.sh
```

The canonical rehearsal origin is `http://localhost:4280`; Designer is
`http://localhost:4282`. In split mode, `/templates`, `/elements`, and `/fields` use HTTP 307 to the
Designer origin while preserving the path and query. Rollback recreates only the canonical gateway
with the complete `rollback/` configuration and sends every route to the unchanged monolith.

The gate records the application container or process IDs before the switch, confirms they are
unchanged afterward, and removes its disposable gateways on exit. Keep the two nginx configurations
complete and mutually exclusive: composing individual route fragments would make rollback partial,
and permanent redirects could leave browsers caching a route after rollback.
