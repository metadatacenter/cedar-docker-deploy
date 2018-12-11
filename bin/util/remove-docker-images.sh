#!/bin/bash

docker images | grep "metadatacenter/cedar-.*" | awk '{print $3}' | xargs docker rmi