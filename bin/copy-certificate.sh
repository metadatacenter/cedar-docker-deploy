#!/bin/bash

docker run -v cedar_cert:/data --name cedar-cert-helper busybox true
echo Copying live to docker volume cedar_cert
docker cp ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/cedar-assets/cert/live cedar-cert-helper:/data
docker rm cedar-cert-helper

docker run -v cedar_ca:/data --name cedar-ca-helper busybox true
echo Copying ca-cedar.crt to docker volume cedar_ca
docker cp ${CEDAR_DOCKER_SRC_HOME}/cedar-docker-deploy/cedar-assets/ca-cedar.crt cedar-ca-helper:/data
docker rm cedar-ca-helper