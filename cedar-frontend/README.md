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
npm run smoke:split

cd "$CEDAR_HOME/cedar-docker-deploy/cedar-frontend"
docker compose -f docker-compose.preview.yml down
```

The preview stack uses ports 4201 and 4202 and its own Docker network and log volumes. Override
`CEDAR_WORKSPACE_PREVIEW_PORT` or `CEDAR_TEMPLATE_DESIGNER_PREVIEW_PORT` for host-port collisions.
For a remote preview topology, also set the two absolute frontend URL variables consumed by the
images. This file is not loaded by the normal `cedarcli docker start frontends` command.
