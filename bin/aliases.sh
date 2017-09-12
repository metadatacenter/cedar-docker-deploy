#!/bin/bash

alias godocker='cd $CEDAR_DOCKER_HOME'

alias gobuild='cd $CEDAR_DOCKER_HOME/cedar-docker-build/'
alias godeploy='cd $CEDAR_DOCKER_HOME/cedar-docker-deploy/'
alias gofrontend='cd $CEDAR_DOCKER_HOME/cedar-docker-deploy/cedar-frontend'
alias goinfrastructure='cd $CEDAR_DOCKER_HOME/cedar-docker-deploy/cedar-infrastructure'
alias gomicroservices='cd $CEDAR_DOCKER_HOME/cedar-docker-deploy/cedar-microservices'
alias gomonitoring='cd $CEDAR_DOCKER_HOME/cedar-docker-deploy/cedar-monitoring'

alias startfrontend='gofrontend && docker-compose up'
alias startmonitoring='gomonitoring && docker-compose up'
alias startmicroservices='gomicroservices && docker-compose up'
alias startinfrastructure='goinfrastructure && docker-compose up'

alias stopfrontend='gofrontend && docker-compose down'
alias stopmonitoring='gomonitoring && docker-compose down'
alias stopmicroservices='gomicroservices && docker-compose down'
alias stopinfrastructure='goinfrastructure && docker-compose down'

alias cedarss='$CEDAR_DOCKER_HOME/cedar-docker-deploy/bin/cedarstatus.sh'

