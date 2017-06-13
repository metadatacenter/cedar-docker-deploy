#!/bin/bash

mkdir -p ${CEDAR_DOCKER_HOME}
mkdir -p ${CEDAR_DOCKER_HOME}/ca
mkdir -p ${CEDAR_DOCKER_HOME}/cert
mkdir -p ${CEDAR_DOCKER_HOME}/data
mkdir -p ${CEDAR_DOCKER_HOME}/log

docker network remove cedarnet
docker network create --subnet=${CEDAR_NET_SUBNET}/24 --gateway ${CEDAR_NET_GATEWAY} cedarnet