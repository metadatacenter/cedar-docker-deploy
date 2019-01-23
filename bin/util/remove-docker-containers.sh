#!/bin/bash

docker ps -a | grep "metadatacenter/cedar-.*" | awk '{print $1}' | xargs docker rm