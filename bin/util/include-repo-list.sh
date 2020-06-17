#!/bin/bash
CEDAR_REPOS=("cedar-admin-tool" "cedar-archetype-exporter" "cedar-archetype-instance-reader" "cedar-component-distribution" "cedar-archetype-instance-writer" "cedar-conf" "cedar-docker-build" "cedar-docker-deploy" "cedar-docs" "cedar-openview" "cedar-open-server" "cedar-group-server" "cedar-keycloak-event-listener" "cedar-model-validation-library" "cedar-messaging-server" "cedar-metadata-form" "cedar-parent" "cedar-project" "cedar-repo-server" "cedar-resource-server" "cedar-schema-server" "cedar-server-core-library" "cedar-swagger-ui" "cedar-template-editor" "cedar-artifact-server" "cedar-terminology-server" "cedar-user-server" "cedar-util" "cedar-valuerecommender-server" "cedar-worker-server" "cedar-submission-server" "cedar-internals-server")

echo List of CEDAR repos:
for i in "${CEDAR_REPOS[@]}"
do
   echo "   - " $i
done
