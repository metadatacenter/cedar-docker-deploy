#!/bin/bash

docker run -v cedar_cert:/data --name cedar-cert-helper busybox true
docker cp ${CEDAR_DOCKER_CERT_HOME}/cedar.crt cedar-cert-helper:/data
docker cp ${CEDAR_DOCKER_CERT_HOME}/cedar.key cedar-cert-helper:/data
docker rm cedar-cert-helper

docker run -v cedar_ca:/data --name cedar-ca-helper busybox true
docker cp ${CEDAR_DOCKER_CA_HOME}/ca-cedar.crt cedar-ca-helper:/data
docker rm cedar-ca-helper