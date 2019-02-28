#!/bin/bash
clear
echo --------------------------------------------------------------------------------
echo Starting Dropwizard enabled CEDAR microservices
echo - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

shopt -s expand_aliases
source $CEDAR_UTIL_BIN/set-dev-aliases.sh

startgroup
sleepbetweenstarts
startmessaging
sleepbetweenstarts
startrepo
sleepbetweenstarts
startresource
sleepbetweenstarts
startschema
sleepbetweenstarts
starttemplate
sleepbetweenstarts
startterminology
sleepbetweenstarts
startuser
sleepbetweenstarts
startvaluerecommender
sleepbetweenstarts
startsubmission
sleepbetweenstarts
startworker
sleepbetweenstarts
startopen
