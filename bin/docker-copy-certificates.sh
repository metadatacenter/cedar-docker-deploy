#!/bin/bash

echo "Copying self-signed certificates into the cedar_cert volume..."
docker run -v cedar_cert:/data --name cedar-cert-helper busybox true
docker cp ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/cedar-assets/cert/live cedar-cert-helper:/data
docker rm cedar-cert-helper

echo "Copying CA certificate into the cedar_ca volume..."
docker run -v cedar_ca:/data --name cedar-ca-helper busybox true
docker cp ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/cedar-assets/ca/ca-cedar.crt cedar-ca-helper:/data
docker rm cedar-ca-helper