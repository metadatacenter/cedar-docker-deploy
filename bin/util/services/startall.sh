#!/bin/bash
clear
echo --------------------------------------------------------------------------------
echo Starting Dropwizard enabled CEDAR microservices
echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

shopt -s expand_aliases
source $CEDAR_UTIL_BIN/set-dev-aliases.sh

startworkspace
sleep 1
startgroup
sleep 1
startmessaging
sleep 1
startrepo
sleep 1
startresource
sleep 1
startschema
sleep 1
starttemplate
sleep 1
startterminology
sleep 1
startuser
sleep 1
startvaluerecommender
sleep 1
startsubmission
sleep 1
startworker
sleep 1
startopen