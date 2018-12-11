#!/bin/bash
clear
echo --------------------------------------------------------------------------------
echo Starting Dropwizard enabled CEDAR microservices
echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

shopt -s expand_aliases
source $CEDAR_UTIL_BIN/set-dev-aliases.sh

startworkspace
startgroup
startmessaging
startrepo
startresource
startschema
starttemplate
startterminology
startuser
startvaluerecommender
startsubmission
startworker
