#!/bin/bash

echo "Checking previous Docker network ..."
if docker network ls | grep "cedarnet" > /dev/null 2>&1
then
    echo "Removing previous Docker network ..."
    docker network remove cedarnet
else
    echo "Previous network not present, nothing to do."
    echo
fi

echo "Creating Docker network: cedarnet ..."
docker network create --subnet=${CEDAR_NET_SUBNET}/24 --gateway ${CEDAR_NET_GATEWAY} cedarnet
