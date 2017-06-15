#!/bin/bash

echo "Removing previous Docker network"
docker network remove cedarnet

echo "Creating Docker network: cedarnet"
docker network create --subnet=${CEDAR_NET_SUBNET}/24 --gateway ${CEDAR_NET_GATEWAY} cedarnet