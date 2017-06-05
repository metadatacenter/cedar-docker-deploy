#!/bin/bash

# Set it to an existing directory with write permission for the current user
# This is the location for data persistency
export CEDAR_DOCKER_HOME=~/cedar-docker-deployment

# CEDAR hostname for backend services
export CEDAR_HOST=metadatacenter.orgx

# Docker network, IP address
export CEDAR_NET_GATEWAY=192.168.17.1

# Keycloak admin user and connection data
export CEDAR_KEYCLOAK_ADMIN_USER="administrator"
export CEDAR_KEYCLOAK_ADMIN_PASSWORD="changeme"
export CEDAR_KEYCLOAK_HOST="${CEDAR_NET_GATEWAY}"
export CEDAR_KEYCLOAK_PORT=8080

#Keycloak event listener
export CEDAR_KEYCLOAK_CLIENT_ID="cedar-angular-app"
export CEDAR_RESOURCE_SERVER_USER_CALLBACK_URL="https://resource.${CEDAR_HOST}/command/auth-user-callback"
export CEDAR_RESOURCE_SERVER_ADMIN_CALLBACK_URL="https://resource.${CEDAR_HOST}/command/auth-admin-callback"

# cedar-admin user data
# You should change this before the first run
# 64 characters, [0-9, a-f]
export CEDAR_ADMIN_USER_API_KEY="0000111122223333444455556666777788889999aaaabbbbccccddddeeeeffff"
export CEDAR_ADMIN_USER_PASSWORD="changeme"

# Mongo user and connection data
export CEDAR_MONGO_ROOT_USER_NAME="mongoRootUser"
export CEDAR_MONGO_ROOT_USER_PASSWORD="changeme"
export CEDAR_MONGO_APP_USER_NAME="cedarMongoUser"
export CEDAR_MONGO_APP_USER_PASSWORD="changeme"
export CEDAR_MONGO_APP_DATABASE_NAME="cedar"
export CEDAR_MONGO_HOST="${CEDAR_NET_GATEWAY}"
export CEDAR_MONGO_PORT=27017

# MySQL CEDAR app user data for Keycloak persistence
export CEDAR_MYSQL_ROOT_PASSWORD="changeme"
export CEDAR_MYSQL_USER="cedarMySQLUser"
export CEDAR_MYSQL_PASSWORD="changeme"
export CEDAR_MYSQL_HOST="${CEDAR_NET_GATEWAY}"
export CEDAR_MYSQL_PORT=3306

# Neo4j user amd connection data - do not change the user name
export CEDAR_NEO4J_USER_NAME="neo4j"
export CEDAR_NEO4J_USER_PASSWORD="changeme"
export CEDAR_NEO4J_HOST="${CEDAR_NET_GATEWAY}"
export CEDAR_NEO4J_REST_PORT=7474
export CEDAR_NEO4J_BOLT_PORT=7687

# Port assignment
export CEDAR_PORT_KIBANA=5601
export CEDAR_PORT_REDIS_COMMANDER=8081

# Microservices host
export CEDAR_MICROSERVICE_HOST="${CEDAR_NET_GATEWAY}"

# Microservice ports
export CEDAR_PORT_FOLDER=9008
export CEDAR_PORT_GROUP=9009
export CEDAR_PORT_REPO=9002
export CEDAR_PORT_RESOURCE=9007
export CEDAR_PORT_SCHEMA=9003
export CEDAR_PORT_SUBMISSION=9010
export CEDAR_PORT_TEMPLATE=9001
export CEDAR_PORT_TERMINOLOGY=9004
export CEDAR_PORT_USER=9005
export CEDAR_PORT_VALUERECOMMENDER=9006
export CEDAR_PORT_WORKER=9011

# Frontend
export CEDAR_FRONTEND_HOST="${CEDAR_NET_GATEWAY}"
export CEDAR_FRONTEND_PORT=4200

# Redis
export CEDAR_REDIS_PERSISTENT_HOST="${CEDAR_NET_GATEWAY}"
export CEDAR_REDIS_PERSISTENT_PORT=6379
export CEDAR_REDIS_NONPERSISTENT_HOST="${CEDAR_NET_GATEWAY}"
export CEDAR_REDIS_NONPERSISTENT_PORT=6380

# Bioportal
export CEDAR_BIOPORTAL_REST_BASE="http://data.bioontology.org/"

# Elasticsearch
export CEDAR_ELASTICSEARCH_HOST="${CEDAR_NET_GATEWAY}"
export CEDAR_ELASTICSEARCH_REST_PORT=9200
export CEDAR_ELASTICSEARCH_TRANSPORT_PORT=9300

# Nginx
export CEDAR_NGINX_HTTP_PORT=80
export CEDAR_NGINX_HTTPS_PORT=443

# Data
export CEDAR_EVERYBODY_GROUP_NAME="Everybody" 

