#!/bin/bash

echo "Creating CEDAR home and directories"
mkdir -p ${CEDAR_DOCKER_HOME}
mkdir -p ${CEDAR_DOCKER_CA_HOME}
mkdir -p ${CEDAR_DOCKER_CERT_HOME}
mkdir -p ${CEDAR_DOCKER_DATA_HOME}
mkdir -p ${CEDAR_DOCKER_LOG_HOME}