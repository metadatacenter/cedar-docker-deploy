#!/bin/bash

docker volume rm cedar_ca
docker volume rm cedar_cert
docker volume rm elasticsearch_data
docker volume rm elasticsearch_log
docker volume rm keycloak_log
docker volume rm mongo_data
docker volume rm mongo_log
docker volume rm mongo_state
docker volume rm mysql_data
docker volume rm mysql_log
docker volume rm neo4j_data
docker volume rm neo4j_log
docker volume rm neo4j_state
docker volume rm nginx_log
docker volume rm redis_data
docker volume rm redis_log

docker volume rm terminology_data

docker volume rm group_log
docker volume rm internals_log
docker volume rm messaging_log
docker volume rm openview_log
docker volume rm repo_log
docker volume rm resource_log
docker volume rm schema_log
docker volume rm submission_log
docker volume rm artifact_log
docker volume rm terminology_log
docker volume rm user_log
docker volume rm valuerecommender_log
docker volume rm worker_log
docker volume rm resource_state

docker volume rm frontend_log
